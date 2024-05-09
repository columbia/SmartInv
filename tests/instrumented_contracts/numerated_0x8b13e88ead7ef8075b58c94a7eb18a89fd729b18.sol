1 // 🤖 🚀 🌔  MoonshotBots for public goods funding!
2 /*
3 ______  ___                         ______       _____
4 ___   |/  /____________________________  /_________  /________
5 __  /|_/ /_  __ \  __ \_  __ \_  ___/_  __ \  __ \  __/_  ___/
6 _  /  / / / /_/ / /_/ /  / / /(__  )_  / / / /_/ / /_ _(__  )
7 /_/  /_/  \____/\____//_/ /_//____/ /_/ /_/\____/\__/ /____/
8 
9 ________                               ______ __________                              _________
10 ___  __/_____________   ____________  ____  /____  /__(_)______   _______ __________________  /
11 __  /_ _  __ \_  ___/   ___  __ \  / / /_  __ \_  /__  /_  ___/   __  __ `/  __ \  __ \  __  /
12 _  __/ / /_/ /  /       __  /_/ / /_/ /_  /_/ /  / _  / / /__     _  /_/ // /_/ / /_/ / /_/ /
13 /_/    \____//_/        _  .___/\__,_/ /_.___//_/  /_/  \___/     _\__, / \____/\____/\__,_/
14                         /_/                                       /____/                       
15                                                                                                                                                         /_/                                       /____/
16 🦧✊ Demand more from PFPs! 👇
17 🌱🌱 100% of MoonshotBot Minting Fees go to fund Ethereum Public Goods on Gitcoin Grants 🌱🌱
18 🦧✊🌱100%🌱✊🦧
19 
20 */
21 
22 // https://github.com/austintgriffith/scaffold-eth/tree/moonshot-bots-with-curve
23 
24 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
25 
26 // SPDX-License-Identifier: MIT
27 
28 pragma solidity >=0.6.0 <0.8.0;
29 
30 /*
31  * @dev Provides information about the current execution context, including the
32  * sender of the transaction and its data. While these are generally available
33  * via msg.sender and msg.data, they should not be accessed in such a direct
34  * manner, since when dealing with GSN meta-transactions the account sending and
35  * paying for execution may not be the actual sender (as far as an application
36  * is concerned).
37  *
38  * This contract is only required for intermediate, library-like contracts.
39  */
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 
52 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.1
53 
54 // SPDX-License-Identifier: MIT
55 
56 pragma solidity >=0.6.0 <0.8.0;
57 
58 /**
59  * @dev Interface of the ERC165 standard, as defined in the
60  * https://eips.ethereum.org/EIPS/eip-165[EIP].
61  *
62  * Implementers can declare support of contract interfaces, which can then be
63  * queried by others ({ERC165Checker}).
64  *
65  * For an implementation, see {ERC165}.
66  */
67 interface IERC165 {
68     /**
69      * @dev Returns true if this contract implements the interface defined by
70      * `interfaceId`. See the corresponding
71      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
72      * to learn more about how these ids are created.
73      *
74      * This function call must use less than 30 000 gas.
75      */
76     function supportsInterface(bytes4 interfaceId) external view returns (bool);
77 }
78 
79 
80 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.1
81 
82 // SPDX-License-Identifier: MIT
83 
84 pragma solidity >=0.6.2 <0.8.0;
85 
86 /**
87  * @dev Required interface of an ERC721 compliant contract.
88  */
89 interface IERC721 is IERC165 {
90     /**
91      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
94 
95     /**
96      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
97      */
98     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
99 
100     /**
101      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
102      */
103     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
104 
105     /**
106      * @dev Returns the number of tokens in ``owner``'s account.
107      */
108     function balanceOf(address owner) external view returns (uint256 balance);
109 
110     /**
111      * @dev Returns the owner of the `tokenId` token.
112      *
113      * Requirements:
114      *
115      * - `tokenId` must exist.
116      */
117     function ownerOf(uint256 tokenId) external view returns (address owner);
118 
119     /**
120      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
121      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
122      *
123      * Requirements:
124      *
125      * - `from` cannot be the zero address.
126      * - `to` cannot be the zero address.
127      * - `tokenId` token must exist and be owned by `from`.
128      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
129      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
130      *
131      * Emits a {Transfer} event.
132      */
133     function safeTransferFrom(address from, address to, uint256 tokenId) external;
134 
135     /**
136      * @dev Transfers `tokenId` token from `from` to `to`.
137      *
138      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
139      *
140      * Requirements:
141      *
142      * - `from` cannot be the zero address.
143      * - `to` cannot be the zero address.
144      * - `tokenId` token must be owned by `from`.
145      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transferFrom(address from, address to, uint256 tokenId) external;
150 
151     /**
152      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
153      * The approval is cleared when the token is transferred.
154      *
155      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
156      *
157      * Requirements:
158      *
159      * - The caller must own the token or be an approved operator.
160      * - `tokenId` must exist.
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address to, uint256 tokenId) external;
165 
166     /**
167      * @dev Returns the account approved for `tokenId` token.
168      *
169      * Requirements:
170      *
171      * - `tokenId` must exist.
172      */
173     function getApproved(uint256 tokenId) external view returns (address operator);
174 
175     /**
176      * @dev Approve or remove `operator` as an operator for the caller.
177      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
178      *
179      * Requirements:
180      *
181      * - The `operator` cannot be the caller.
182      *
183      * Emits an {ApprovalForAll} event.
184      */
185     function setApprovalForAll(address operator, bool _approved) external;
186 
187     /**
188      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
189      *
190      * See {setApprovalForAll}
191      */
192     function isApprovedForAll(address owner, address operator) external view returns (bool);
193 
194     /**
195       * @dev Safely transfers `tokenId` token from `from` to `to`.
196       *
197       * Requirements:
198       *
199       * - `from` cannot be the zero address.
200       * - `to` cannot be the zero address.
201       * - `tokenId` token must exist and be owned by `from`.
202       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
203       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
204       *
205       * Emits a {Transfer} event.
206       */
207     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
208 }
209 
210 
211 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.1
212 
213 // SPDX-License-Identifier: MIT
214 
215 pragma solidity >=0.6.2 <0.8.0;
216 
217 /**
218  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
219  * @dev See https://eips.ethereum.org/EIPS/eip-721
220  */
221 interface IERC721Metadata is IERC721 {
222 
223     /**
224      * @dev Returns the token collection name.
225      */
226     function name() external view returns (string memory);
227 
228     /**
229      * @dev Returns the token collection symbol.
230      */
231     function symbol() external view returns (string memory);
232 
233     /**
234      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
235      */
236     function tokenURI(uint256 tokenId) external view returns (string memory);
237 }
238 
239 
240 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.1
241 
242 // SPDX-License-Identifier: MIT
243 
244 pragma solidity >=0.6.2 <0.8.0;
245 
246 /**
247  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
248  * @dev See https://eips.ethereum.org/EIPS/eip-721
249  */
250 interface IERC721Enumerable is IERC721 {
251 
252     /**
253      * @dev Returns the total amount of tokens stored by the contract.
254      */
255     function totalSupply() external view returns (uint256);
256 
257     /**
258      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
259      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
260      */
261     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
262 
263     /**
264      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
265      * Use along with {totalSupply} to enumerate all tokens.
266      */
267     function tokenByIndex(uint256 index) external view returns (uint256);
268 }
269 
270 
271 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.1
272 
273 // SPDX-License-Identifier: MIT
274 
275 pragma solidity >=0.6.0 <0.8.0;
276 
277 /**
278  * @title ERC721 token receiver interface
279  * @dev Interface for any contract that wants to support safeTransfers
280  * from ERC721 asset contracts.
281  */
282 interface IERC721Receiver {
283     /**
284      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
285      * by `operator` from `from`, this function is called.
286      *
287      * It must return its Solidity selector to confirm the token transfer.
288      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
289      *
290      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
291      */
292     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
293 }
294 
295 
296 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.1
297 
298 // SPDX-License-Identifier: MIT
299 
300 pragma solidity >=0.6.0 <0.8.0;
301 
302 /**
303  * @dev Implementation of the {IERC165} interface.
304  *
305  * Contracts may inherit from this and call {_registerInterface} to declare
306  * their support of an interface.
307  */
308 abstract contract ERC165 is IERC165 {
309     /*
310      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
311      */
312     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
313 
314     /**
315      * @dev Mapping of interface ids to whether or not it's supported.
316      */
317     mapping(bytes4 => bool) private _supportedInterfaces;
318 
319     constructor () internal {
320         // Derived contracts need only register support for their own interfaces,
321         // we register support for ERC165 itself here
322         _registerInterface(_INTERFACE_ID_ERC165);
323     }
324 
325     /**
326      * @dev See {IERC165-supportsInterface}.
327      *
328      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
329      */
330     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
331         return _supportedInterfaces[interfaceId];
332     }
333 
334     /**
335      * @dev Registers the contract as an implementer of the interface defined by
336      * `interfaceId`. Support of the actual ERC165 interface is automatic and
337      * registering its interface id is not required.
338      *
339      * See {IERC165-supportsInterface}.
340      *
341      * Requirements:
342      *
343      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
344      */
345     function _registerInterface(bytes4 interfaceId) internal virtual {
346         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
347         _supportedInterfaces[interfaceId] = true;
348     }
349 }
350 
351 
352 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
353 
354 // SPDX-License-Identifier: MIT
355 
356 pragma solidity >=0.6.0 <0.8.0;
357 
358 /**
359  * @dev Wrappers over Solidity's arithmetic operations with added overflow
360  * checks.
361  *
362  * Arithmetic operations in Solidity wrap on overflow. This can easily result
363  * in bugs, because programmers usually assume that an overflow raises an
364  * error, which is the standard behavior in high level programming languages.
365  * `SafeMath` restores this intuition by reverting the transaction when an
366  * operation overflows.
367  *
368  * Using this library instead of the unchecked operations eliminates an entire
369  * class of bugs, so it's recommended to use it always.
370  */
371 library SafeMath {
372     /**
373      * @dev Returns the addition of two unsigned integers, with an overflow flag.
374      *
375      * _Available since v3.4._
376      */
377     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
378         uint256 c = a + b;
379         if (c < a) return (false, 0);
380         return (true, c);
381     }
382 
383     /**
384      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
385      *
386      * _Available since v3.4._
387      */
388     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
389         if (b > a) return (false, 0);
390         return (true, a - b);
391     }
392 
393     /**
394      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
395      *
396      * _Available since v3.4._
397      */
398     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
399         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
400         // benefit is lost if 'b' is also tested.
401         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
402         if (a == 0) return (true, 0);
403         uint256 c = a * b;
404         if (c / a != b) return (false, 0);
405         return (true, c);
406     }
407 
408     /**
409      * @dev Returns the division of two unsigned integers, with a division by zero flag.
410      *
411      * _Available since v3.4._
412      */
413     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
414         if (b == 0) return (false, 0);
415         return (true, a / b);
416     }
417 
418     /**
419      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
420      *
421      * _Available since v3.4._
422      */
423     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
424         if (b == 0) return (false, 0);
425         return (true, a % b);
426     }
427 
428     /**
429      * @dev Returns the addition of two unsigned integers, reverting on
430      * overflow.
431      *
432      * Counterpart to Solidity's `+` operator.
433      *
434      * Requirements:
435      *
436      * - Addition cannot overflow.
437      */
438     function add(uint256 a, uint256 b) internal pure returns (uint256) {
439         uint256 c = a + b;
440         require(c >= a, "SafeMath: addition overflow");
441         return c;
442     }
443 
444     /**
445      * @dev Returns the subtraction of two unsigned integers, reverting on
446      * overflow (when the result is negative).
447      *
448      * Counterpart to Solidity's `-` operator.
449      *
450      * Requirements:
451      *
452      * - Subtraction cannot overflow.
453      */
454     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
455         require(b <= a, "SafeMath: subtraction overflow");
456         return a - b;
457     }
458 
459     /**
460      * @dev Returns the multiplication of two unsigned integers, reverting on
461      * overflow.
462      *
463      * Counterpart to Solidity's `*` operator.
464      *
465      * Requirements:
466      *
467      * - Multiplication cannot overflow.
468      */
469     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
470         if (a == 0) return 0;
471         uint256 c = a * b;
472         require(c / a == b, "SafeMath: multiplication overflow");
473         return c;
474     }
475 
476     /**
477      * @dev Returns the integer division of two unsigned integers, reverting on
478      * division by zero. The result is rounded towards zero.
479      *
480      * Counterpart to Solidity's `/` operator. Note: this function uses a
481      * `revert` opcode (which leaves remaining gas untouched) while Solidity
482      * uses an invalid opcode to revert (consuming all remaining gas).
483      *
484      * Requirements:
485      *
486      * - The divisor cannot be zero.
487      */
488     function div(uint256 a, uint256 b) internal pure returns (uint256) {
489         require(b > 0, "SafeMath: division by zero");
490         return a / b;
491     }
492 
493     /**
494      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
495      * reverting when dividing by zero.
496      *
497      * Counterpart to Solidity's `%` operator. This function uses a `revert`
498      * opcode (which leaves remaining gas untouched) while Solidity uses an
499      * invalid opcode to revert (consuming all remaining gas).
500      *
501      * Requirements:
502      *
503      * - The divisor cannot be zero.
504      */
505     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
506         require(b > 0, "SafeMath: modulo by zero");
507         return a % b;
508     }
509 
510     /**
511      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
512      * overflow (when the result is negative).
513      *
514      * CAUTION: This function is deprecated because it requires allocating memory for the error
515      * message unnecessarily. For custom revert reasons use {trySub}.
516      *
517      * Counterpart to Solidity's `-` operator.
518      *
519      * Requirements:
520      *
521      * - Subtraction cannot overflow.
522      */
523     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
524         require(b <= a, errorMessage);
525         return a - b;
526     }
527 
528     /**
529      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
530      * division by zero. The result is rounded towards zero.
531      *
532      * CAUTION: This function is deprecated because it requires allocating memory for the error
533      * message unnecessarily. For custom revert reasons use {tryDiv}.
534      *
535      * Counterpart to Solidity's `/` operator. Note: this function uses a
536      * `revert` opcode (which leaves remaining gas untouched) while Solidity
537      * uses an invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
544         require(b > 0, errorMessage);
545         return a / b;
546     }
547 
548     /**
549      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
550      * reverting with custom message when dividing by zero.
551      *
552      * CAUTION: This function is deprecated because it requires allocating memory for the error
553      * message unnecessarily. For custom revert reasons use {tryMod}.
554      *
555      * Counterpart to Solidity's `%` operator. This function uses a `revert`
556      * opcode (which leaves remaining gas untouched) while Solidity uses an
557      * invalid opcode to revert (consuming all remaining gas).
558      *
559      * Requirements:
560      *
561      * - The divisor cannot be zero.
562      */
563     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
564         require(b > 0, errorMessage);
565         return a % b;
566     }
567 }
568 
569 
570 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
571 
572 // SPDX-License-Identifier: MIT
573 
574 pragma solidity >=0.6.2 <0.8.0;
575 
576 /**
577  * @dev Collection of functions related to the address type
578  */
579 library Address {
580     /**
581      * @dev Returns true if `account` is a contract.
582      *
583      * [IMPORTANT]
584      * ====
585      * It is unsafe to assume that an address for which this function returns
586      * false is an externally-owned account (EOA) and not a contract.
587      *
588      * Among others, `isContract` will return false for the following
589      * types of addresses:
590      *
591      *  - an externally-owned account
592      *  - a contract in construction
593      *  - an address where a contract will be created
594      *  - an address where a contract lived, but was destroyed
595      * ====
596      */
597     function isContract(address account) internal view returns (bool) {
598         // This method relies on extcodesize, which returns 0 for contracts in
599         // construction, since the code is only stored at the end of the
600         // constructor execution.
601 
602         uint256 size;
603         // solhint-disable-next-line no-inline-assembly
604         assembly { size := extcodesize(account) }
605         return size > 0;
606     }
607 
608     /**
609      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
610      * `recipient`, forwarding all available gas and reverting on errors.
611      *
612      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
613      * of certain opcodes, possibly making contracts go over the 2300 gas limit
614      * imposed by `transfer`, making them unable to receive funds via
615      * `transfer`. {sendValue} removes this limitation.
616      *
617      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
618      *
619      * IMPORTANT: because control is transferred to `recipient`, care must be
620      * taken to not create reentrancy vulnerabilities. Consider using
621      * {ReentrancyGuard} or the
622      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
623      */
624     function sendValue(address payable recipient, uint256 amount) internal {
625         require(address(this).balance >= amount, "Address: insufficient balance");
626 
627         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
628         (bool success, ) = recipient.call{ value: amount }("");
629         require(success, "Address: unable to send value, recipient may have reverted");
630     }
631 
632     /**
633      * @dev Performs a Solidity function call using a low level `call`. A
634      * plain`call` is an unsafe replacement for a function call: use this
635      * function instead.
636      *
637      * If `target` reverts with a revert reason, it is bubbled up by this
638      * function (like regular Solidity function calls).
639      *
640      * Returns the raw returned data. To convert to the expected return value,
641      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
642      *
643      * Requirements:
644      *
645      * - `target` must be a contract.
646      * - calling `target` with `data` must not revert.
647      *
648      * _Available since v3.1._
649      */
650     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
651       return functionCall(target, data, "Address: low-level call failed");
652     }
653 
654     /**
655      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
656      * `errorMessage` as a fallback revert reason when `target` reverts.
657      *
658      * _Available since v3.1._
659      */
660     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
661         return functionCallWithValue(target, data, 0, errorMessage);
662     }
663 
664     /**
665      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
666      * but also transferring `value` wei to `target`.
667      *
668      * Requirements:
669      *
670      * - the calling contract must have an ETH balance of at least `value`.
671      * - the called Solidity function must be `payable`.
672      *
673      * _Available since v3.1._
674      */
675     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
676         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
681      * with `errorMessage` as a fallback revert reason when `target` reverts.
682      *
683      * _Available since v3.1._
684      */
685     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
686         require(address(this).balance >= value, "Address: insufficient balance for call");
687         require(isContract(target), "Address: call to non-contract");
688 
689         // solhint-disable-next-line avoid-low-level-calls
690         (bool success, bytes memory returndata) = target.call{ value: value }(data);
691         return _verifyCallResult(success, returndata, errorMessage);
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
696      * but performing a static call.
697      *
698      * _Available since v3.3._
699      */
700     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
701         return functionStaticCall(target, data, "Address: low-level static call failed");
702     }
703 
704     /**
705      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
706      * but performing a static call.
707      *
708      * _Available since v3.3._
709      */
710     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
711         require(isContract(target), "Address: static call to non-contract");
712 
713         // solhint-disable-next-line avoid-low-level-calls
714         (bool success, bytes memory returndata) = target.staticcall(data);
715         return _verifyCallResult(success, returndata, errorMessage);
716     }
717 
718     /**
719      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
720      * but performing a delegate call.
721      *
722      * _Available since v3.4._
723      */
724     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
725         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
726     }
727 
728     /**
729      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
730      * but performing a delegate call.
731      *
732      * _Available since v3.4._
733      */
734     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
735         require(isContract(target), "Address: delegate call to non-contract");
736 
737         // solhint-disable-next-line avoid-low-level-calls
738         (bool success, bytes memory returndata) = target.delegatecall(data);
739         return _verifyCallResult(success, returndata, errorMessage);
740     }
741 
742     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
743         if (success) {
744             return returndata;
745         } else {
746             // Look for revert reason and bubble it up if present
747             if (returndata.length > 0) {
748                 // The easiest way to bubble the revert reason is using memory via assembly
749 
750                 // solhint-disable-next-line no-inline-assembly
751                 assembly {
752                     let returndata_size := mload(returndata)
753                     revert(add(32, returndata), returndata_size)
754                 }
755             } else {
756                 revert(errorMessage);
757             }
758         }
759     }
760 }
761 
762 
763 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
764 
765 // SPDX-License-Identifier: MIT
766 
767 pragma solidity >=0.6.0 <0.8.0;
768 
769 /**
770  * @dev Library for managing
771  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
772  * types.
773  *
774  * Sets have the following properties:
775  *
776  * - Elements are added, removed, and checked for existence in constant time
777  * (O(1)).
778  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
779  *
780  * ```
781  * contract Example {
782  *     // Add the library methods
783  *     using EnumerableSet for EnumerableSet.AddressSet;
784  *
785  *     // Declare a set state variable
786  *     EnumerableSet.AddressSet private mySet;
787  * }
788  * ```
789  *
790  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
791  * and `uint256` (`UintSet`) are supported.
792  */
793 library EnumerableSet {
794     // To implement this library for multiple types with as little code
795     // repetition as possible, we write it in terms of a generic Set type with
796     // bytes32 values.
797     // The Set implementation uses private functions, and user-facing
798     // implementations (such as AddressSet) are just wrappers around the
799     // underlying Set.
800     // This means that we can only create new EnumerableSets for types that fit
801     // in bytes32.
802 
803     struct Set {
804         // Storage of set values
805         bytes32[] _values;
806 
807         // Position of the value in the `values` array, plus 1 because index 0
808         // means a value is not in the set.
809         mapping (bytes32 => uint256) _indexes;
810     }
811 
812     /**
813      * @dev Add a value to a set. O(1).
814      *
815      * Returns true if the value was added to the set, that is if it was not
816      * already present.
817      */
818     function _add(Set storage set, bytes32 value) private returns (bool) {
819         if (!_contains(set, value)) {
820             set._values.push(value);
821             // The value is stored at length-1, but we add 1 to all indexes
822             // and use 0 as a sentinel value
823             set._indexes[value] = set._values.length;
824             return true;
825         } else {
826             return false;
827         }
828     }
829 
830     /**
831      * @dev Removes a value from a set. O(1).
832      *
833      * Returns true if the value was removed from the set, that is if it was
834      * present.
835      */
836     function _remove(Set storage set, bytes32 value) private returns (bool) {
837         // We read and store the value's index to prevent multiple reads from the same storage slot
838         uint256 valueIndex = set._indexes[value];
839 
840         if (valueIndex != 0) { // Equivalent to contains(set, value)
841             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
842             // the array, and then remove the last element (sometimes called as 'swap and pop').
843             // This modifies the order of the array, as noted in {at}.
844 
845             uint256 toDeleteIndex = valueIndex - 1;
846             uint256 lastIndex = set._values.length - 1;
847 
848             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
849             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
850 
851             bytes32 lastvalue = set._values[lastIndex];
852 
853             // Move the last value to the index where the value to delete is
854             set._values[toDeleteIndex] = lastvalue;
855             // Update the index for the moved value
856             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
857 
858             // Delete the slot where the moved value was stored
859             set._values.pop();
860 
861             // Delete the index for the deleted slot
862             delete set._indexes[value];
863 
864             return true;
865         } else {
866             return false;
867         }
868     }
869 
870     /**
871      * @dev Returns true if the value is in the set. O(1).
872      */
873     function _contains(Set storage set, bytes32 value) private view returns (bool) {
874         return set._indexes[value] != 0;
875     }
876 
877     /**
878      * @dev Returns the number of values on the set. O(1).
879      */
880     function _length(Set storage set) private view returns (uint256) {
881         return set._values.length;
882     }
883 
884    /**
885     * @dev Returns the value stored at position `index` in the set. O(1).
886     *
887     * Note that there are no guarantees on the ordering of values inside the
888     * array, and it may change when more values are added or removed.
889     *
890     * Requirements:
891     *
892     * - `index` must be strictly less than {length}.
893     */
894     function _at(Set storage set, uint256 index) private view returns (bytes32) {
895         require(set._values.length > index, "EnumerableSet: index out of bounds");
896         return set._values[index];
897     }
898 
899     // Bytes32Set
900 
901     struct Bytes32Set {
902         Set _inner;
903     }
904 
905     /**
906      * @dev Add a value to a set. O(1).
907      *
908      * Returns true if the value was added to the set, that is if it was not
909      * already present.
910      */
911     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
912         return _add(set._inner, value);
913     }
914 
915     /**
916      * @dev Removes a value from a set. O(1).
917      *
918      * Returns true if the value was removed from the set, that is if it was
919      * present.
920      */
921     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
922         return _remove(set._inner, value);
923     }
924 
925     /**
926      * @dev Returns true if the value is in the set. O(1).
927      */
928     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
929         return _contains(set._inner, value);
930     }
931 
932     /**
933      * @dev Returns the number of values in the set. O(1).
934      */
935     function length(Bytes32Set storage set) internal view returns (uint256) {
936         return _length(set._inner);
937     }
938 
939    /**
940     * @dev Returns the value stored at position `index` in the set. O(1).
941     *
942     * Note that there are no guarantees on the ordering of values inside the
943     * array, and it may change when more values are added or removed.
944     *
945     * Requirements:
946     *
947     * - `index` must be strictly less than {length}.
948     */
949     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
950         return _at(set._inner, index);
951     }
952 
953     // AddressSet
954 
955     struct AddressSet {
956         Set _inner;
957     }
958 
959     /**
960      * @dev Add a value to a set. O(1).
961      *
962      * Returns true if the value was added to the set, that is if it was not
963      * already present.
964      */
965     function add(AddressSet storage set, address value) internal returns (bool) {
966         return _add(set._inner, bytes32(uint256(uint160(value))));
967     }
968 
969     /**
970      * @dev Removes a value from a set. O(1).
971      *
972      * Returns true if the value was removed from the set, that is if it was
973      * present.
974      */
975     function remove(AddressSet storage set, address value) internal returns (bool) {
976         return _remove(set._inner, bytes32(uint256(uint160(value))));
977     }
978 
979     /**
980      * @dev Returns true if the value is in the set. O(1).
981      */
982     function contains(AddressSet storage set, address value) internal view returns (bool) {
983         return _contains(set._inner, bytes32(uint256(uint160(value))));
984     }
985 
986     /**
987      * @dev Returns the number of values in the set. O(1).
988      */
989     function length(AddressSet storage set) internal view returns (uint256) {
990         return _length(set._inner);
991     }
992 
993    /**
994     * @dev Returns the value stored at position `index` in the set. O(1).
995     *
996     * Note that there are no guarantees on the ordering of values inside the
997     * array, and it may change when more values are added or removed.
998     *
999     * Requirements:
1000     *
1001     * - `index` must be strictly less than {length}.
1002     */
1003     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1004         return address(uint160(uint256(_at(set._inner, index))));
1005     }
1006 
1007 
1008     // UintSet
1009 
1010     struct UintSet {
1011         Set _inner;
1012     }
1013 
1014     /**
1015      * @dev Add a value to a set. O(1).
1016      *
1017      * Returns true if the value was added to the set, that is if it was not
1018      * already present.
1019      */
1020     function add(UintSet storage set, uint256 value) internal returns (bool) {
1021         return _add(set._inner, bytes32(value));
1022     }
1023 
1024     /**
1025      * @dev Removes a value from a set. O(1).
1026      *
1027      * Returns true if the value was removed from the set, that is if it was
1028      * present.
1029      */
1030     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1031         return _remove(set._inner, bytes32(value));
1032     }
1033 
1034     /**
1035      * @dev Returns true if the value is in the set. O(1).
1036      */
1037     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1038         return _contains(set._inner, bytes32(value));
1039     }
1040 
1041     /**
1042      * @dev Returns the number of values on the set. O(1).
1043      */
1044     function length(UintSet storage set) internal view returns (uint256) {
1045         return _length(set._inner);
1046     }
1047 
1048    /**
1049     * @dev Returns the value stored at position `index` in the set. O(1).
1050     *
1051     * Note that there are no guarantees on the ordering of values inside the
1052     * array, and it may change when more values are added or removed.
1053     *
1054     * Requirements:
1055     *
1056     * - `index` must be strictly less than {length}.
1057     */
1058     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1059         return uint256(_at(set._inner, index));
1060     }
1061 }
1062 
1063 
1064 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.1
1065 
1066 // SPDX-License-Identifier: MIT
1067 
1068 pragma solidity >=0.6.0 <0.8.0;
1069 
1070 /**
1071  * @dev Library for managing an enumerable variant of Solidity's
1072  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1073  * type.
1074  *
1075  * Maps have the following properties:
1076  *
1077  * - Entries are added, removed, and checked for existence in constant time
1078  * (O(1)).
1079  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1080  *
1081  * ```
1082  * contract Example {
1083  *     // Add the library methods
1084  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1085  *
1086  *     // Declare a set state variable
1087  *     EnumerableMap.UintToAddressMap private myMap;
1088  * }
1089  * ```
1090  *
1091  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1092  * supported.
1093  */
1094 library EnumerableMap {
1095     // To implement this library for multiple types with as little code
1096     // repetition as possible, we write it in terms of a generic Map type with
1097     // bytes32 keys and values.
1098     // The Map implementation uses private functions, and user-facing
1099     // implementations (such as Uint256ToAddressMap) are just wrappers around
1100     // the underlying Map.
1101     // This means that we can only create new EnumerableMaps for types that fit
1102     // in bytes32.
1103 
1104     struct MapEntry {
1105         bytes32 _key;
1106         bytes32 _value;
1107     }
1108 
1109     struct Map {
1110         // Storage of map keys and values
1111         MapEntry[] _entries;
1112 
1113         // Position of the entry defined by a key in the `entries` array, plus 1
1114         // because index 0 means a key is not in the map.
1115         mapping (bytes32 => uint256) _indexes;
1116     }
1117 
1118     /**
1119      * @dev Adds a key-value pair to a map, or updates the value for an existing
1120      * key. O(1).
1121      *
1122      * Returns true if the key was added to the map, that is if it was not
1123      * already present.
1124      */
1125     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1126         // We read and store the key's index to prevent multiple reads from the same storage slot
1127         uint256 keyIndex = map._indexes[key];
1128 
1129         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1130             map._entries.push(MapEntry({ _key: key, _value: value }));
1131             // The entry is stored at length-1, but we add 1 to all indexes
1132             // and use 0 as a sentinel value
1133             map._indexes[key] = map._entries.length;
1134             return true;
1135         } else {
1136             map._entries[keyIndex - 1]._value = value;
1137             return false;
1138         }
1139     }
1140 
1141     /**
1142      * @dev Removes a key-value pair from a map. O(1).
1143      *
1144      * Returns true if the key was removed from the map, that is if it was present.
1145      */
1146     function _remove(Map storage map, bytes32 key) private returns (bool) {
1147         // We read and store the key's index to prevent multiple reads from the same storage slot
1148         uint256 keyIndex = map._indexes[key];
1149 
1150         if (keyIndex != 0) { // Equivalent to contains(map, key)
1151             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1152             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1153             // This modifies the order of the array, as noted in {at}.
1154 
1155             uint256 toDeleteIndex = keyIndex - 1;
1156             uint256 lastIndex = map._entries.length - 1;
1157 
1158             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1159             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1160 
1161             MapEntry storage lastEntry = map._entries[lastIndex];
1162 
1163             // Move the last entry to the index where the entry to delete is
1164             map._entries[toDeleteIndex] = lastEntry;
1165             // Update the index for the moved entry
1166             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1167 
1168             // Delete the slot where the moved entry was stored
1169             map._entries.pop();
1170 
1171             // Delete the index for the deleted slot
1172             delete map._indexes[key];
1173 
1174             return true;
1175         } else {
1176             return false;
1177         }
1178     }
1179 
1180     /**
1181      * @dev Returns true if the key is in the map. O(1).
1182      */
1183     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1184         return map._indexes[key] != 0;
1185     }
1186 
1187     /**
1188      * @dev Returns the number of key-value pairs in the map. O(1).
1189      */
1190     function _length(Map storage map) private view returns (uint256) {
1191         return map._entries.length;
1192     }
1193 
1194    /**
1195     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1196     *
1197     * Note that there are no guarantees on the ordering of entries inside the
1198     * array, and it may change when more entries are added or removed.
1199     *
1200     * Requirements:
1201     *
1202     * - `index` must be strictly less than {length}.
1203     */
1204     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1205         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1206 
1207         MapEntry storage entry = map._entries[index];
1208         return (entry._key, entry._value);
1209     }
1210 
1211     /**
1212      * @dev Tries to returns the value associated with `key`.  O(1).
1213      * Does not revert if `key` is not in the map.
1214      */
1215     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1216         uint256 keyIndex = map._indexes[key];
1217         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1218         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1219     }
1220 
1221     /**
1222      * @dev Returns the value associated with `key`.  O(1).
1223      *
1224      * Requirements:
1225      *
1226      * - `key` must be in the map.
1227      */
1228     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1229         uint256 keyIndex = map._indexes[key];
1230         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1231         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1232     }
1233 
1234     /**
1235      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1236      *
1237      * CAUTION: This function is deprecated because it requires allocating memory for the error
1238      * message unnecessarily. For custom revert reasons use {_tryGet}.
1239      */
1240     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1241         uint256 keyIndex = map._indexes[key];
1242         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1243         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1244     }
1245 
1246     // UintToAddressMap
1247 
1248     struct UintToAddressMap {
1249         Map _inner;
1250     }
1251 
1252     /**
1253      * @dev Adds a key-value pair to a map, or updates the value for an existing
1254      * key. O(1).
1255      *
1256      * Returns true if the key was added to the map, that is if it was not
1257      * already present.
1258      */
1259     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1260         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1261     }
1262 
1263     /**
1264      * @dev Removes a value from a set. O(1).
1265      *
1266      * Returns true if the key was removed from the map, that is if it was present.
1267      */
1268     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1269         return _remove(map._inner, bytes32(key));
1270     }
1271 
1272     /**
1273      * @dev Returns true if the key is in the map. O(1).
1274      */
1275     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1276         return _contains(map._inner, bytes32(key));
1277     }
1278 
1279     /**
1280      * @dev Returns the number of elements in the map. O(1).
1281      */
1282     function length(UintToAddressMap storage map) internal view returns (uint256) {
1283         return _length(map._inner);
1284     }
1285 
1286    /**
1287     * @dev Returns the element stored at position `index` in the set. O(1).
1288     * Note that there are no guarantees on the ordering of values inside the
1289     * array, and it may change when more values are added or removed.
1290     *
1291     * Requirements:
1292     *
1293     * - `index` must be strictly less than {length}.
1294     */
1295     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1296         (bytes32 key, bytes32 value) = _at(map._inner, index);
1297         return (uint256(key), address(uint160(uint256(value))));
1298     }
1299 
1300     /**
1301      * @dev Tries to returns the value associated with `key`.  O(1).
1302      * Does not revert if `key` is not in the map.
1303      *
1304      * _Available since v3.4._
1305      */
1306     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1307         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1308         return (success, address(uint160(uint256(value))));
1309     }
1310 
1311     /**
1312      * @dev Returns the value associated with `key`.  O(1).
1313      *
1314      * Requirements:
1315      *
1316      * - `key` must be in the map.
1317      */
1318     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1319         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1320     }
1321 
1322     /**
1323      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1324      *
1325      * CAUTION: This function is deprecated because it requires allocating memory for the error
1326      * message unnecessarily. For custom revert reasons use {tryGet}.
1327      */
1328     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1329         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1330     }
1331 }
1332 
1333 
1334 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.1
1335 
1336 // SPDX-License-Identifier: MIT
1337 
1338 pragma solidity >=0.6.0 <0.8.0;
1339 
1340 /**
1341  * @dev String operations.
1342  */
1343 library Strings {
1344     /**
1345      * @dev Converts a `uint256` to its ASCII `string` representation.
1346      */
1347     function toString(uint256 value) internal pure returns (string memory) {
1348         // Inspired by OraclizeAPI's implementation - MIT licence
1349         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1350 
1351         if (value == 0) {
1352             return "0";
1353         }
1354         uint256 temp = value;
1355         uint256 digits;
1356         while (temp != 0) {
1357             digits++;
1358             temp /= 10;
1359         }
1360         bytes memory buffer = new bytes(digits);
1361         uint256 index = digits - 1;
1362         temp = value;
1363         while (temp != 0) {
1364             buffer[index--] = bytes1(uint8(48 + temp % 10));
1365             temp /= 10;
1366         }
1367         return string(buffer);
1368     }
1369 }
1370 
1371 
1372 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.1
1373 
1374 // SPDX-License-Identifier: MIT
1375 
1376 pragma solidity >=0.6.0 <0.8.0;
1377 
1378 
1379 
1380 
1381 
1382 
1383 
1384 
1385 
1386 
1387 
1388 /**
1389  * @title ERC721 Non-Fungible Token Standard basic implementation
1390  * @dev see https://eips.ethereum.org/EIPS/eip-721
1391  */
1392 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1393     using SafeMath for uint256;
1394     using Address for address;
1395     using EnumerableSet for EnumerableSet.UintSet;
1396     using EnumerableMap for EnumerableMap.UintToAddressMap;
1397     using Strings for uint256;
1398 
1399     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1400     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1401     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1402 
1403     // Mapping from holder address to their (enumerable) set of owned tokens
1404     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1405 
1406     // Enumerable mapping from token ids to their owners
1407     EnumerableMap.UintToAddressMap private _tokenOwners;
1408 
1409     // Mapping from token ID to approved address
1410     mapping (uint256 => address) private _tokenApprovals;
1411 
1412     // Mapping from owner to operator approvals
1413     mapping (address => mapping (address => bool)) private _operatorApprovals;
1414 
1415     // Token name
1416     string private _name;
1417 
1418     // Token symbol
1419     string private _symbol;
1420 
1421     // Optional mapping for token URIs
1422     mapping (uint256 => string) private _tokenURIs;
1423 
1424     // Base URI
1425     string private _baseURI;
1426 
1427     /*
1428      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1429      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1430      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1431      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1432      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1433      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1434      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1435      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1436      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1437      *
1438      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1439      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1440      */
1441     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1442 
1443     /*
1444      *     bytes4(keccak256('name()')) == 0x06fdde03
1445      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1446      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1447      *
1448      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1449      */
1450     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1451 
1452     /*
1453      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1454      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1455      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1456      *
1457      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1458      */
1459     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1460 
1461     /**
1462      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1463      */
1464     constructor (string memory name_, string memory symbol_) public {
1465         _name = name_;
1466         _symbol = symbol_;
1467 
1468         // register the supported interfaces to conform to ERC721 via ERC165
1469         _registerInterface(_INTERFACE_ID_ERC721);
1470         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1471         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-balanceOf}.
1476      */
1477     function balanceOf(address owner) public view virtual override returns (uint256) {
1478         require(owner != address(0), "ERC721: balance query for the zero address");
1479         return _holderTokens[owner].length();
1480     }
1481 
1482     /**
1483      * @dev See {IERC721-ownerOf}.
1484      */
1485     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1486         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1487     }
1488 
1489     /**
1490      * @dev See {IERC721Metadata-name}.
1491      */
1492     function name() public view virtual override returns (string memory) {
1493         return _name;
1494     }
1495 
1496     /**
1497      * @dev See {IERC721Metadata-symbol}.
1498      */
1499     function symbol() public view virtual override returns (string memory) {
1500         return _symbol;
1501     }
1502 
1503     /**
1504      * @dev See {IERC721Metadata-tokenURI}.
1505      */
1506     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1507         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1508 
1509         string memory _tokenURI = _tokenURIs[tokenId];
1510         string memory base = baseURI();
1511 
1512         // If there is no base URI, return the token URI.
1513         if (bytes(base).length == 0) {
1514             return _tokenURI;
1515         }
1516         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1517         if (bytes(_tokenURI).length > 0) {
1518             return string(abi.encodePacked(base, _tokenURI));
1519         }
1520         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1521         return string(abi.encodePacked(base, tokenId.toString()));
1522     }
1523 
1524     /**
1525     * @dev Returns the base URI set via {_setBaseURI}. This will be
1526     * automatically added as a prefix in {tokenURI} to each token's URI, or
1527     * to the token ID if no specific URI is set for that token ID.
1528     */
1529     function baseURI() public view virtual returns (string memory) {
1530         return _baseURI;
1531     }
1532 
1533     /**
1534      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1535      */
1536     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1537         return _holderTokens[owner].at(index);
1538     }
1539 
1540     /**
1541      * @dev See {IERC721Enumerable-totalSupply}.
1542      */
1543     function totalSupply() public view virtual override returns (uint256) {
1544         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1545         return _tokenOwners.length();
1546     }
1547 
1548     /**
1549      * @dev See {IERC721Enumerable-tokenByIndex}.
1550      */
1551     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1552         (uint256 tokenId, ) = _tokenOwners.at(index);
1553         return tokenId;
1554     }
1555 
1556     /**
1557      * @dev See {IERC721-approve}.
1558      */
1559     function approve(address to, uint256 tokenId) public virtual override {
1560         address owner = ERC721.ownerOf(tokenId);
1561         require(to != owner, "ERC721: approval to current owner");
1562 
1563         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1564             "ERC721: approve caller is not owner nor approved for all"
1565         );
1566 
1567         _approve(to, tokenId);
1568     }
1569 
1570     /**
1571      * @dev See {IERC721-getApproved}.
1572      */
1573     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1574         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1575 
1576         return _tokenApprovals[tokenId];
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-setApprovalForAll}.
1581      */
1582     function setApprovalForAll(address operator, bool approved) public virtual override {
1583         require(operator != _msgSender(), "ERC721: approve to caller");
1584 
1585         _operatorApprovals[_msgSender()][operator] = approved;
1586         emit ApprovalForAll(_msgSender(), operator, approved);
1587     }
1588 
1589     /**
1590      * @dev See {IERC721-isApprovedForAll}.
1591      */
1592     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1593         return _operatorApprovals[owner][operator];
1594     }
1595 
1596     /**
1597      * @dev See {IERC721-transferFrom}.
1598      */
1599     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1600         //solhint-disable-next-line max-line-length
1601         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1602 
1603         _transfer(from, to, tokenId);
1604     }
1605 
1606     /**
1607      * @dev See {IERC721-safeTransferFrom}.
1608      */
1609     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1610         safeTransferFrom(from, to, tokenId, "");
1611     }
1612 
1613     /**
1614      * @dev See {IERC721-safeTransferFrom}.
1615      */
1616     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1617         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1618         _safeTransfer(from, to, tokenId, _data);
1619     }
1620 
1621     /**
1622      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1623      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1624      *
1625      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1626      *
1627      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1628      * implement alternative mechanisms to perform token transfer, such as signature-based.
1629      *
1630      * Requirements:
1631      *
1632      * - `from` cannot be the zero address.
1633      * - `to` cannot be the zero address.
1634      * - `tokenId` token must exist and be owned by `from`.
1635      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1640         _transfer(from, to, tokenId);
1641         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1642     }
1643 
1644     /**
1645      * @dev Returns whether `tokenId` exists.
1646      *
1647      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1648      *
1649      * Tokens start existing when they are minted (`_mint`),
1650      * and stop existing when they are burned (`_burn`).
1651      */
1652     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1653         return _tokenOwners.contains(tokenId);
1654     }
1655 
1656     /**
1657      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1658      *
1659      * Requirements:
1660      *
1661      * - `tokenId` must exist.
1662      */
1663     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1664         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1665         address owner = ERC721.ownerOf(tokenId);
1666         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1667     }
1668 
1669     /**
1670      * @dev Safely mints `tokenId` and transfers it to `to`.
1671      *
1672      * Requirements:
1673      d*
1674      * - `tokenId` must not exist.
1675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function _safeMint(address to, uint256 tokenId) internal virtual {
1680         _safeMint(to, tokenId, "");
1681     }
1682 
1683     /**
1684      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1685      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1686      */
1687     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1688         _mint(to, tokenId);
1689         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1690     }
1691 
1692     /**
1693      * @dev Mints `tokenId` and transfers it to `to`.
1694      *
1695      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1696      *
1697      * Requirements:
1698      *
1699      * - `tokenId` must not exist.
1700      * - `to` cannot be the zero address.
1701      *
1702      * Emits a {Transfer} event.
1703      */
1704     function _mint(address to, uint256 tokenId) internal virtual {
1705         require(to != address(0), "ERC721: mint to the zero address");
1706         require(!_exists(tokenId), "ERC721: token already minted");
1707 
1708         _beforeTokenTransfer(address(0), to, tokenId);
1709 
1710         _holderTokens[to].add(tokenId);
1711 
1712         _tokenOwners.set(tokenId, to);
1713 
1714         emit Transfer(address(0), to, tokenId);
1715     }
1716 
1717     /**
1718      * @dev Destroys `tokenId`.
1719      * The approval is cleared when the token is burned.
1720      *
1721      * Requirements:
1722      *
1723      * - `tokenId` must exist.
1724      *
1725      * Emits a {Transfer} event.
1726      */
1727     function _burn(uint256 tokenId) internal virtual {
1728         address owner = ERC721.ownerOf(tokenId); // internal owner
1729 
1730         _beforeTokenTransfer(owner, address(0), tokenId);
1731 
1732         // Clear approvals
1733         _approve(address(0), tokenId);
1734 
1735         // Clear metadata (if any)
1736         if (bytes(_tokenURIs[tokenId]).length != 0) {
1737             delete _tokenURIs[tokenId];
1738         }
1739 
1740         _holderTokens[owner].remove(tokenId);
1741 
1742         _tokenOwners.remove(tokenId);
1743 
1744         emit Transfer(owner, address(0), tokenId);
1745     }
1746 
1747     /**
1748      * @dev Transfers `tokenId` from `from` to `to`.
1749      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1750      *
1751      * Requirements:
1752      *
1753      * - `to` cannot be the zero address.
1754      * - `tokenId` token must be owned by `from`.
1755      *
1756      * Emits a {Transfer} event.
1757      */
1758     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1759         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1760         require(to != address(0), "ERC721: transfer to the zero address");
1761 
1762         _beforeTokenTransfer(from, to, tokenId);
1763 
1764         // Clear approvals from the previous owner
1765         _approve(address(0), tokenId);
1766 
1767         _holderTokens[from].remove(tokenId);
1768         _holderTokens[to].add(tokenId);
1769 
1770         _tokenOwners.set(tokenId, to);
1771 
1772         emit Transfer(from, to, tokenId);
1773     }
1774 
1775     /**
1776      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1777      *
1778      * Requirements:
1779      *
1780      * - `tokenId` must exist.
1781      */
1782     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1783         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1784         _tokenURIs[tokenId] = _tokenURI;
1785     }
1786 
1787     /**
1788      * @dev Internal function to set the base URI for all token IDs. It is
1789      * automatically added as a prefix to the value returned in {tokenURI},
1790      * or to the token ID if {tokenURI} is empty.
1791      */
1792     function _setBaseURI(string memory baseURI_) internal virtual {
1793         _baseURI = baseURI_;
1794     }
1795 
1796     /**
1797      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1798      * The call is not executed if the target address is not a contract.
1799      *
1800      * @param from address representing the previous owner of the given token ID
1801      * @param to target address that will receive the tokens
1802      * @param tokenId uint256 ID of the token to be transferred
1803      * @param _data bytes optional data to send along with the call
1804      * @return bool whether the call correctly returned the expected magic value
1805      */
1806     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1807         private returns (bool)
1808     {
1809         if (!to.isContract()) {
1810             return true;
1811         }
1812         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1813             IERC721Receiver(to).onERC721Received.selector,
1814             _msgSender(),
1815             from,
1816             tokenId,
1817             _data
1818         ), "ERC721: transfer to non ERC721Receiver implementer");
1819         bytes4 retval = abi.decode(returndata, (bytes4));
1820         return (retval == _ERC721_RECEIVED);
1821     }
1822 
1823     /**
1824      * @dev Approve `to` to operate on `tokenId`
1825      *
1826      * Emits an {Approval} event.
1827      */
1828     function _approve(address to, uint256 tokenId) internal virtual {
1829         _tokenApprovals[tokenId] = to;
1830         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1831     }
1832 
1833     /**
1834      * @dev Hook that is called before any token transfer. This includes minting
1835      * and burning.
1836      *
1837      * Calling conditions:
1838      *
1839      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1840      * transferred to `to`.
1841      * - When `from` is zero, `tokenId` will be minted for `to`.
1842      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1843      * - `from` cannot be the zero address.
1844      * - `to` cannot be the zero address.
1845      *
1846      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1847      */
1848     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1849 }
1850 
1851 
1852 // File @openzeppelin/contracts/utils/Counters.sol@v3.4.1
1853 
1854 // SPDX-License-Identifier: MIT
1855 
1856 pragma solidity >=0.6.0 <0.8.0;
1857 
1858 /**
1859  * @title Counters
1860  * @author Matt Condon (@shrugs)
1861  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1862  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1863  *
1864  * Include with `using Counters for Counters.Counter;`
1865  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1866  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1867  * directly accessed.
1868  */
1869 library Counters {
1870     using SafeMath for uint256;
1871 
1872     struct Counter {
1873         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1874         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1875         // this feature: see https://github.com/ethereum/solidity/issues/4637
1876         uint256 _value; // default: 0
1877     }
1878 
1879     function current(Counter storage counter) internal view returns (uint256) {
1880         return counter._value;
1881     }
1882 
1883     function increment(Counter storage counter) internal {
1884         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1885         counter._value += 1;
1886     }
1887 
1888     function decrement(Counter storage counter) internal {
1889         counter._value = counter._value.sub(1);
1890     }
1891 }
1892 
1893 
1894 // File contracts/MoonshotBot.sol
1895 
1896 pragma solidity >=0.6.0 <0.7.0;
1897 //SPDX-License-Identifier: MIT
1898 
1899 // 🤖 🚀 🌔  MoonshotBots for public goods funding!
1900 /*
1901 ______  ___                         ______       _____            ________                               ______ __________                              _________
1902 ___   |/  /____________________________  /_________  /________    ___  __/_____________   ____________  ____  /____  /__(_)______   _______ __________________  /
1903 __  /|_/ /_  __ \  __ \_  __ \_  ___/_  __ \  __ \  __/_  ___/    __  /_ _  __ \_  ___/   ___  __ \  / / /_  __ \_  /__  /_  ___/   __  __ `/  __ \  __ \  __  /
1904 _  /  / / / /_/ / /_/ /  / / /(__  )_  / / / /_/ / /_ _(__  )     _  __/ / /_/ /  /       __  /_/ / /_/ /_  /_/ /  / _  / / /__     _  /_/ // /_/ / /_/ / /_/ /
1905 /_/  /_/  \____/\____//_/ /_//____/ /_/ /_/\____/\__/ /____/      /_/    \____//_/        _  .___/\__,_/ /_.___//_/  /_/  \___/     _\__, / \____/\____/\__,_/
1906                                                                                           /_/                                       /____/
1907 🦧✊ Demand more from PFPs! 👇
1908 🌱🌱 100% of MoonshotBot Minting Fees go to fund Ethereum Public Goods on Gitcoin Grants 🌱🌱
1909 🦧✊🌱100%🌱✊🦧
1910 
1911 */
1912 // https://github.com/austintgriffith/scaffold-eth/tree/moonshot-bots-with-curve
1913 
1914 contract MoonshotBot is ERC721 {
1915 
1916   address payable public constant gitcoin = 0xde21F729137C5Af1b01d73aF1dC21eFfa2B8a0d6;
1917 
1918   using Counters for Counters.Counter;
1919   Counters.Counter private _tokenIds;
1920 
1921   string [] private uris;
1922 
1923   constructor() public ERC721("MoonShotBots", "MSB") {
1924     _setBaseURI("https://gateway.pinata.cloud/ipfs/QmdRmZ1UPSALNVuXY2mYPb3T5exn9in1AL3tsema4rY2QF/json/");
1925     uris =  ['Superior_Wiki.json', 'Homely_Word_processor.json', 'Abrupt_Paste.json', 'Hungry_Inbox.json', 'Acidic_Digital.json', 'Hungry_Windows.json', 'Adorable_Malware.json', 'Hurt_App.json', 'Adorable_Platform.json', 'Hurt_Bug.json', 'Adventurous_Hack.json', 'Hurt_Byte.json', 'Aggressive_Kernel.json', 'Hurt_Spyware.json', 'Alert_Flash.json', 'Icy_Hyperlink.json', 'Alert_Privacy.json', 'Ideal_Captcha.json', 'Alert_Status_bar.json', 'Ideal_Node.json', 'Aloof_Data.json', 'Immense_Enter.json', 'Aloof_Text_editor.json', 'Impressionable_Surf.json', 'Aloof_Url.json', 'Intrigued_Blogger.json', 'Amiable_Shift.json', 'Intrigued_Database.json', 'Anxious_Status_bar.json', 'Irate_Scanner.json', 'Apprehensive_Email.json', 'Irritable_Cloud_computing.json', 'Apprehensive_Teminal.json', 'Irritable_Xml.json', 'Arrogant_Dns_.json', 'Itchy_Notebook_computer.json', 'Ashamed_Backup.json', 'Jealous_Html.json', 'Ashamed_Password.json', 'Jittery_Script.json', 'Average_Platform.json', 'Jolly_Domain_name.json', 'Average_Router.json', 'Jolly_Real-time.json', 'Batty_Cypherpunk.json', 'Joyous_Queue.json', 'Beefy_Binary.json', 'Joyous_Security.json', 'Bland_Domain.json', 'Juicy_Template.json', 'Blushing_Malware.json', 'Jumpy_Widget.json', 'Blushing_Platform.json', 'Kind_Cd-rom.json', 'Blushing_Storage.json', 'Lackadaisical_Phishing.json', 'Bright_Log_out.json', 'Lackadaisical_Windows.json', 'Broad_Save.json', 'Lackadaisical_Zip.json', 'Burly_Configure.json', 'Large_Linux.json', 'Cheeky_Hacker.json', 'Large_Table.json', 'Cheeky_Spam.json', 'Large_Undo.json', 'Clueless_App.json', 'Lively_Scroll_bar.json', 'Clueless_Operating_system.json', 'Lively_Template.json', 'Colorful_Development.json', 'Lucky_Tag.json', 'Colorful_Email.json', 'Macho_Bite.json', 'Combative_Log_out.json', 'Magnificent_Captcha.json', 'Combative_Shareware.json', 'Maniacal_Dns_.json', 'Condemned_Bandwidth.json', 'Maniacal_Scan.json', 'Condemned_Keyword.json', 'Massive_Browser.json', 'Condescending_Kernel.json', 'Massive_Captcha.json', 'Condescending_Qwerty.json', 'Massive_Login.json', 'Contemplative_Dashboard.json', 'Massive_Offline.json', 'Convincing_Flash.json', 'Melancholy_Buffer.json', 'Convincing_Lurking.json', 'Melancholy_Bus.json', 'Cooperative_Computer.json', 'Melancholy_Shift_key.json', 'Cooperative_Screen.json', 'Miniature_Java.json', 'Corny_Internet.json', 'Misty_Drag.json', 'Corny_Motherboard.json', 'Misty_Zip.json', 'Crabby_Macro.json', 'Muddy_Backup.json', 'Crooked_Virus.json', 'Narrow_Hacker.json', 'Cruel_Dns_.json', 'Narrow_Hypertext.json', 'Cumbersome_Worm.json', 'Nasty_Faq__frequently_asked_questions_.json', 'Cynical_Desktop.json', 'Nasty_Pirate.json', 'Dashing_Clip_art.json', 'Naughty_Backup.json', 'Dashing_Cpu_.json', 'Naughty_Logic.json', 'Dashing_Data_mining.json', 'Naughty_Wireless.json', 'Dashing_Interface.json', 'Nervous_Html.json', 'Deceitful_Bus.json', 'Nonchalant_Log_out.json', 'Deceitful_Log_out.json', 'Nonsensical_Backup.json', 'Defeated_Host.json', 'Nonsensical_Gigabyte.json', 'Delicious_Widget.json', 'Nutritious_Flash_drive.json', 'Delightful_App.json', 'Odd_Clip_board.json', 'Delightful_Database.json', 'Odd_Gigabyte.json', 'Delightful_Hacker.json', 'Old-fashioned_Broadband.json', 'Distinct_Url.json', 'Panicky_Keyword.json', 'Disturbed_Domain_name.json', 'Panicky_User.json', 'Eager_Frame.json', 'Petite_Worm.json', 'Ecstatic_Version.json', 'Petty_Clip_art.json', 'Ecstatic_Zip.json', 'Plain_Cd.json', 'Elated_Bug.json', 'Plain_Firmware.json', 'Elated_Data_mining.json', 'Plain_Multimedia.json', 'Elegant_Wiki.json', 'Pleasant_Flaming.json', 'Emaciated_Page.json', 'Pleasant_Tag.json', 'Emaciated_Rom__read_only_memory_.json', 'Poised_Shell.json', 'Embarrassed_Server.json', 'Poised_Trojan_horse.json', 'Enchanting_Privacy.json', 'Poised_User.json', 'Enormous_Template.json', 'Precious_Computer.json', 'Enthusiastic_Disk.json', 'Precious_Logic.json', 'Exasperated_Encrypt.json', 'Prickly_Supercomputer.json', 'Exasperated_Finder.json', 'Proud_Storage.json', 'Excited_Hacker.json', 'Pungent_Floppy_disk.json', 'Excited_Home_page.json', 'Puny_Mirror.json', 'Extensive_Plug-in.json', 'Quaint_Bus.json', 'Exuberant_Broadband.json', 'Quaint_Shell.json', 'Exuberant_Kernel.json', 'Quizzical_Spyware.json', 'Fantastic_Linux.json', 'Repulsive_Analog.json', 'Fantastic_Screenshot.json', 'Responsive_Kernel.json', 'Flat_Portal.json', 'Responsive_Output.json', 'Floppy_Cloud_computing.json', 'Responsive_Shell.json', 'Floppy_Interface.json', 'Responsive_Tag.json', 'Fluttering_Integer.json', 'Robust_Interface.json', 'Fluttering_Upload.json', 'Round_Finder.json', 'Foolish_Kernel.json', 'Round_Username.json', 'Foolish_Network.json', 'Salty_Cybercrime.json', 'Frantic_Java.json', 'Salty_Shift_key.json', 'Fresh_Domain_name.json', 'Sarcastic_Desktop.json', 'Fresh_Laptop.json', 'Sarcastic_Save.json', 'Fresh_Password.json', 'Scary_Router.json', 'Fresh_Ram.json', 'Shaky_Output.json', 'Fresh_Shareware.json', 'Shallow_Link.json', 'Frustrating_Bug.json', 'Silky_Dot.json', 'Funny_Bitmap.json', 'Silky_Screenshot.json', 'Funny_Real-time.json', 'Silky_Trash.json', 'Fuzzy_Buffer.json', 'Slimy_Qwerty.json', 'Fuzzy_Virtual.json', 'Small_Internet.json', 'Gaudy_Data_mining.json', 'Small_Path.json', 'Gentle_Malware.json', 'Smarmy_Dynamic.json', 'Ghastly_Joystick.json', 'Smoggy_Monitor.json', 'Ghastly_Podcast.json', 'Soggy_Root.json', 'Ghastly_Pop-up.json', 'Sour_Paste.json', 'Ghastly_Status_bar.json', 'Spicy_Array.json', 'Ghastly_Version.json', 'Spicy_Database.json', 'Giddy_Computer.json', 'Stale_Download.json', 'Giddy_Laptop.json', 'Steady_Modem.json', 'Gigantic_Bug.json', 'Steady_Privacy.json', 'Gigantic_Log_out.json', 'Sticky_Font.json', 'Glamorous_Desktop.json', 'Stormy_Url.json', 'Gleaming_Byte.json', 'Stout_Cloud_computing.json', 'Gleaming_Process.json', 'Stunning_Programmer.json', 'Gleaming_Scan.json', 'Substantial_Monitor.json', 'Glorious_Integer.json', 'Succulent_Icon.json', 'Glorious_Programmer.json', 'Superficial_Array.json', 'Gorgeous_Piracy.json', 'Graceful_Security.json', 'Swanky_Trojan_horse.json', 'Graceful_Software.json', 'Sweet_Host.json', 'Greasy_Bus.json', 'Tasty_Url.json', 'Greasy_Digital.json', 'Tense_Blogger.json', 'Grieving_Freeware.json', 'Terrible_Shift_key.json', 'Grotesque_Clip_art.json', 'Thoughtless_Html.json', 'Grotesque_Password.json', 'Uneven_Spam.json', 'Grubby_Computer.json', 'Uneven_Workstation.json', 'Grubby_Media.json', 'Unsightly_Backup.json', 'Grumpy_Bite.json', 'Unsightly_Network.json', 'Grumpy_Script.json', 'Unsightly_Word_processor.json', 'Grumpy_Teminal.json', 'Upset_Runtime.json', 'Grumpy_Url.json', 'Uptight_Restore.json', 'Handsome_Worm.json', 'Uptight_Text_editor.json', 'Happy_Delete.json', 'Vast_Cloud_computing.json', 'Happy_Drag.json', 'Vast_Compile.json', 'Happy_Macro.json', 'Victorious_Cyberspace.json', 'Healthy_Encryption.json', 'Victorious_Motherboard.json', 'Helpful_Version.json', 'Vivacious_Bug.json', 'Helpless_Flowchart.json', 'Vivid_Domain_name.json', 'Helpless_Laptop.json', 'Wacky_Cpu_.json', 'Helpless_Pirate.json', 'Wacky_Logic.json', 'Helpless_Shell.json', 'Whimsical_Pirate.json', 'High_Rom__read_only_memory_.json', 'Whopping_Screen.json', 'Hollow_Interface.json', 'Wicked_Development.json', 'Hollow_Kernel.json', 'Wicked_Key.json', 'Hollow_Spammer.json', 'Wicked_Online.json'];
1926   }
1927 
1928   uint256 public constant limit = 303;
1929   uint256 public price = 0.0033 ether;
1930 
1931   function mintItem(address to, string memory tokenURI)
1932       private
1933       returns (uint256)
1934   {
1935       require( _tokenIds.current() < limit , "DONE MINTING");
1936       _tokenIds.increment();
1937 
1938       uint256 id = _tokenIds.current();
1939       _mint(to, id);
1940       _setTokenURI(id, tokenURI);
1941 
1942       return id;
1943   }
1944 
1945   function requestMint(address to)
1946       public
1947       payable
1948   {
1949     require( msg.value >= price, "NOT ENOUGH");
1950     price = (price * 1047) / 1000;
1951     (bool success,) = gitcoin.call{value:msg.value}("");
1952     require( success, "could not send");
1953     mintItem(to, uris[_tokenIds.current()]);
1954   }
1955 }