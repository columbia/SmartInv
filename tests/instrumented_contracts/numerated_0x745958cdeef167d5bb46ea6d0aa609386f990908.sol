1 /**
2 
3  _______   ______   ______  
4 |       \ /      \ /      \ 
5 | ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\
6 | ▓▓  | ▓▓ ▓▓ __\▓▓ ▓▓   \▓▓
7 | ▓▓  | ▓▓ ▓▓|    \ ▓▓      
8 | ▓▓  | ▓▓ ▓▓ \▓▓▓▓ ▓▓   __ 
9 | ▓▓__/ ▓▓ ▓▓__| ▓▓ ▓▓__/  \
10 | ▓▓    ▓▓\▓▓    ▓▓\▓▓    ▓▓
11  \▓▓▓▓▓▓▓  \▓▓▓▓▓▓  \▓▓▓▓▓▓ 
12                             
13 
14 */
15 
16 // File: @openzeppelin/contracts/utils/Context.sol
17 
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity >=0.6.0 <0.8.0;
21 
22 /*
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with GSN meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address payable) {
34         return payable(msg.sender);
35     }
36 
37     function _msgData() internal view virtual returns (bytes memory) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 // File: @openzeppelin/contracts/introspection/IERC165.sol
44 
45 
46 
47 pragma solidity >=0.6.0 <0.8.0;
48 
49 /**
50  * @dev Interface of the ERC165 standard, as defined in the
51  * https://eips.ethereum.org/EIPS/eip-165[EIP].
52  *
53  * Implementers can declare support of contract interfaces, which can then be
54  * queried by others ({ERC165Checker}).
55  *
56  * For an implementation, see {ERC165}.
57  */
58 interface IERC165 {
59     /**
60      * @dev Returns true if this contract implements the interface defined by
61      * `interfaceId`. See the corresponding
62      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
63      * to learn more about how these ids are created.
64      *
65      * This function call must use less than 30 000 gas.
66      */
67     function supportsInterface(bytes4 interfaceId) external view returns (bool);
68 }
69 
70 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
71 
72 
73 
74 pragma solidity >=0.6.2 <0.8.0;
75 
76 
77 /**
78  * @dev Required interface of an ERC721 compliant contract.
79  */
80 interface IERC721 is IERC165 {
81     /**
82      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
85 
86     /**
87      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
88      */
89     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
90 
91     /**
92      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
93      */
94     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
95 
96     /**
97      * @dev Returns the number of tokens in ``owner``'s account.
98      */
99     function balanceOf(address owner) external view returns (uint256 balance);
100 
101     /**
102      * @dev Returns the owner of the `tokenId` token.
103      *
104      * Requirements:
105      *
106      * - `tokenId` must exist.
107      */
108     function ownerOf(uint256 tokenId) external view returns (address owner);
109 
110     /**
111      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
112      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
113      *
114      * Requirements:
115      *
116      * - `from` cannot be the zero address.
117      * - `to` cannot be the zero address.
118      * - `tokenId` token must exist and be owned by `from`.
119      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
120      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
121      *
122      * Emits a {Transfer} event.
123      */
124     function safeTransferFrom(address from, address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Transfers `tokenId` token from `from` to `to`.
128      *
129      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
130      *
131      * Requirements:
132      *
133      * - `from` cannot be the zero address.
134      * - `to` cannot be the zero address.
135      * - `tokenId` token must be owned by `from`.
136      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transferFrom(address from, address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
144      * The approval is cleared when the token is transferred.
145      *
146      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
147      *
148      * Requirements:
149      *
150      * - The caller must own the token or be an approved operator.
151      * - `tokenId` must exist.
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address to, uint256 tokenId) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Approve or remove `operator` as an operator for the caller.
168      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
169      *
170      * Requirements:
171      *
172      * - The `operator` cannot be the caller.
173      *
174      * Emits an {ApprovalForAll} event.
175      */
176     function setApprovalForAll(address operator, bool _approved) external;
177 
178     /**
179      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
180      *
181      * See {setApprovalForAll}
182      */
183     function isApprovedForAll(address owner, address operator) external view returns (bool);
184 
185     /**
186       * @dev Safely transfers `tokenId` token from `from` to `to`.
187       *
188       * Requirements:
189       *
190       * - `from` cannot be the zero address.
191       * - `to` cannot be the zero address.
192       * - `tokenId` token must exist and be owned by `from`.
193       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
194       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
195       *
196       * Emits a {Transfer} event.
197       */
198     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
199 }
200 
201 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
202 
203 
204 
205 pragma solidity >=0.6.2 <0.8.0;
206 
207 
208 /**
209  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
210  * @dev See https://eips.ethereum.org/EIPS/eip-721
211  */
212 interface IERC721Metadata is IERC721 {
213 
214     /**
215      * @dev Returns the token collection name.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the token collection symbol.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
226      */
227     function tokenURI(uint256 tokenId) external view returns (string memory);
228 }
229 
230 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
231 
232 
233 
234 pragma solidity >=0.6.2 <0.8.0;
235 
236 
237 /**
238  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
239  * @dev See https://eips.ethereum.org/EIPS/eip-721
240  */
241 interface IERC721Enumerable is IERC721 {
242 
243     /**
244      * @dev Returns the total amount of tokens stored by the contract.
245      */
246     function totalSupply() external view returns (uint256);
247 
248     /**
249      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
250      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
251      */
252     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
253 
254     /**
255      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
256      * Use along with {totalSupply} to enumerate all tokens.
257      */
258     function tokenByIndex(uint256 index) external view returns (uint256);
259 }
260 
261 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
262 
263 
264 
265 pragma solidity >=0.6.0 <0.8.0;
266 
267 /**
268  * @title ERC721 token receiver interface
269  * @dev Interface for any contract that wants to support safeTransfers
270  * from ERC721 asset contracts.
271  */
272 interface IERC721Receiver {
273     /**
274      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
275      * by `operator` from `from`, this function is called.
276      *
277      * It must return its Solidity selector to confirm the token transfer.
278      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
279      *
280      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
281      */
282     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
283 }
284 
285 // File: @openzeppelin/contracts/introspection/ERC165.sol
286 
287 
288 
289 pragma solidity >=0.6.0 <0.8.0;
290 
291 
292 /**
293  * @dev Implementation of the {IERC165} interface.
294  *
295  * Contracts may inherit from this and call {_registerInterface} to declare
296  * their support of an interface.
297  */
298 abstract contract ERC165 is IERC165 {
299     /*
300      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
301      */
302     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
303 
304     /**
305      * @dev Mapping of interface ids to whether or not it's supported.
306      */
307     mapping(bytes4 => bool) private _supportedInterfaces;
308 
309     constructor () {
310         // Derived contracts need only register support for their own interfaces,
311         // we register support for ERC165 itself here
312         _registerInterface(_INTERFACE_ID_ERC165);
313     }
314 
315     /**
316      * @dev See {IERC165-supportsInterface}.
317      *
318      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
319      */
320     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
321         return _supportedInterfaces[interfaceId];
322     }
323 
324     /**
325      * @dev Registers the contract as an implementer of the interface defined by
326      * `interfaceId`. Support of the actual ERC165 interface is automatic and
327      * registering its interface id is not required.
328      *
329      * See {IERC165-supportsInterface}.
330      *
331      * Requirements:
332      *
333      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
334      */
335     function _registerInterface(bytes4 interfaceId) internal virtual {
336         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
337         _supportedInterfaces[interfaceId] = true;
338     }
339 }
340 
341 // File: @openzeppelin/contracts/math/SafeMath.sol
342 
343 
344 
345 pragma solidity >=0.6.0 <0.8.0;
346 
347 /**
348  * @dev Wrappers over Solidity's arithmetic operations with added overflow
349  * checks.
350  *
351  * Arithmetic operations in Solidity wrap on overflow. This can easily result
352  * in bugs, because programmers usually assume that an overflow raises an
353  * error, which is the standard behavior in high level programming languages.
354  * `SafeMath` restores this intuition by reverting the transaction when an
355  * operation overflows.
356  *
357  * Using this library instead of the unchecked operations eliminates an entire
358  * class of bugs, so it's recommended to use it always.
359  */
360 library SafeMath {
361     /**
362      * @dev Returns the addition of two unsigned integers, with an overflow flag.
363      *
364      * _Available since v3.4._
365      */
366     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
367         uint256 c = a + b;
368         if (c < a) return (false, 0);
369         return (true, c);
370     }
371 
372     /**
373      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
374      *
375      * _Available since v3.4._
376      */
377     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
378         if (b > a) return (false, 0);
379         return (true, a - b);
380     }
381 
382     /**
383      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
384      *
385      * _Available since v3.4._
386      */
387     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
388         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
389         // benefit is lost if 'b' is also tested.
390         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
391         if (a == 0) return (true, 0);
392         uint256 c = a * b;
393         if (c / a != b) return (false, 0);
394         return (true, c);
395     }
396 
397     /**
398      * @dev Returns the division of two unsigned integers, with a division by zero flag.
399      *
400      * _Available since v3.4._
401      */
402     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
403         if (b == 0) return (false, 0);
404         return (true, a / b);
405     }
406 
407     /**
408      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
409      *
410      * _Available since v3.4._
411      */
412     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
413         if (b == 0) return (false, 0);
414         return (true, a % b);
415     }
416 
417     /**
418      * @dev Returns the addition of two unsigned integers, reverting on
419      * overflow.
420      *
421      * Counterpart to Solidity's `+` operator.
422      *
423      * Requirements:
424      *
425      * - Addition cannot overflow.
426      */
427     function add(uint256 a, uint256 b) internal pure returns (uint256) {
428         uint256 c = a + b;
429         require(c >= a, "SafeMath: addition overflow");
430         return c;
431     }
432 
433     /**
434      * @dev Returns the subtraction of two unsigned integers, reverting on
435      * overflow (when the result is negative).
436      *
437      * Counterpart to Solidity's `-` operator.
438      *
439      * Requirements:
440      *
441      * - Subtraction cannot overflow.
442      */
443     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
444         require(b <= a, "SafeMath: subtraction overflow");
445         return a - b;
446     }
447 
448     /**
449      * @dev Returns the multiplication of two unsigned integers, reverting on
450      * overflow.
451      *
452      * Counterpart to Solidity's `*` operator.
453      *
454      * Requirements:
455      *
456      * - Multiplication cannot overflow.
457      */
458     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
459         if (a == 0) return 0;
460         uint256 c = a * b;
461         require(c / a == b, "SafeMath: multiplication overflow");
462         return c;
463     }
464 
465     /**
466      * @dev Returns the integer division of two unsigned integers, reverting on
467      * division by zero. The result is rounded towards zero.
468      *
469      * Counterpart to Solidity's `/` operator. Note: this function uses a
470      * `revert` opcode (which leaves remaining gas untouched) while Solidity
471      * uses an invalid opcode to revert (consuming all remaining gas).
472      *
473      * Requirements:
474      *
475      * - The divisor cannot be zero.
476      */
477     function div(uint256 a, uint256 b) internal pure returns (uint256) {
478         require(b > 0, "SafeMath: division by zero");
479         return a / b;
480     }
481 
482     /**
483      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
484      * reverting when dividing by zero.
485      *
486      * Counterpart to Solidity's `%` operator. This function uses a `revert`
487      * opcode (which leaves remaining gas untouched) while Solidity uses an
488      * invalid opcode to revert (consuming all remaining gas).
489      *
490      * Requirements:
491      *
492      * - The divisor cannot be zero.
493      */
494     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
495         require(b > 0, "SafeMath: modulo by zero");
496         return a % b;
497     }
498 
499     /**
500      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
501      * overflow (when the result is negative).
502      *
503      * CAUTION: This function is deprecated because it requires allocating memory for the error
504      * message unnecessarily. For custom revert reasons use {trySub}.
505      *
506      * Counterpart to Solidity's `-` operator.
507      *
508      * Requirements:
509      *
510      * - Subtraction cannot overflow.
511      */
512     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
513         require(b <= a, errorMessage);
514         return a - b;
515     }
516 
517     /**
518      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
519      * division by zero. The result is rounded towards zero.
520      *
521      * CAUTION: This function is deprecated because it requires allocating memory for the error
522      * message unnecessarily. For custom revert reasons use {tryDiv}.
523      *
524      * Counterpart to Solidity's `/` operator. Note: this function uses a
525      * `revert` opcode (which leaves remaining gas untouched) while Solidity
526      * uses an invalid opcode to revert (consuming all remaining gas).
527      *
528      * Requirements:
529      *
530      * - The divisor cannot be zero.
531      */
532     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
533         require(b > 0, errorMessage);
534         return a / b;
535     }
536 
537     /**
538      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
539      * reverting with custom message when dividing by zero.
540      *
541      * CAUTION: This function is deprecated because it requires allocating memory for the error
542      * message unnecessarily. For custom revert reasons use {tryMod}.
543      *
544      * Counterpart to Solidity's `%` operator. This function uses a `revert`
545      * opcode (which leaves remaining gas untouched) while Solidity uses an
546      * invalid opcode to revert (consuming all remaining gas).
547      *
548      * Requirements:
549      *
550      * - The divisor cannot be zero.
551      */
552     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
553         require(b > 0, errorMessage);
554         return a % b;
555     }
556 }
557 
558 // File: @openzeppelin/contracts/utils/Address.sol
559 
560 
561 
562 pragma solidity >=0.6.2 <0.8.0;
563 
564 /**
565  * @dev Collection of functions related to the address type
566  */
567 library Address {
568     /**
569      * @dev Returns true if `account` is a contract.
570      *
571      * [IMPORTANT]
572      * ====
573      * It is unsafe to assume that an address for which this function returns
574      * false is an externally-owned account (EOA) and not a contract.
575      *
576      * Among others, `isContract` will return false for the following
577      * types of addresses:
578      *
579      *  - an externally-owned account
580      *  - a contract in construction
581      *  - an address where a contract will be created
582      *  - an address where a contract lived, but was destroyed
583      * ====
584      */
585     function isContract(address account) internal view returns (bool) {
586         // This method relies on extcodesize, which returns 0 for contracts in
587         // construction, since the code is only stored at the end of the
588         // constructor execution.
589 
590         uint256 size;
591         // solhint-disable-next-line no-inline-assembly
592         assembly { size := extcodesize(account) }
593         return size > 0;
594     }
595 
596     /**
597      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
598      * `recipient`, forwarding all available gas and reverting on errors.
599      *
600      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
601      * of certain opcodes, possibly making contracts go over the 2300 gas limit
602      * imposed by `transfer`, making them unable to receive funds via
603      * `transfer`. {sendValue} removes this limitation.
604      *
605      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
606      *
607      * IMPORTANT: because control is transferred to `recipient`, care must be
608      * taken to not create reentrancy vulnerabilities. Consider using
609      * {ReentrancyGuard} or the
610      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
611      */
612     function sendValue(address payable recipient, uint256 amount) internal {
613         require(address(this).balance >= amount, "Address: insufficient balance");
614 
615         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
616         (bool success, ) = recipient.call{ value: amount }("");
617         require(success, "Address: unable to send value, recipient may have reverted");
618     }
619 
620     /**
621      * @dev Performs a Solidity function call using a low level `call`. A
622      * plain`call` is an unsafe replacement for a function call: use this
623      * function instead.
624      *
625      * If `target` reverts with a revert reason, it is bubbled up by this
626      * function (like regular Solidity function calls).
627      *
628      * Returns the raw returned data. To convert to the expected return value,
629      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
630      *
631      * Requirements:
632      *
633      * - `target` must be a contract.
634      * - calling `target` with `data` must not revert.
635      *
636      * _Available since v3.1._
637      */
638     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
639         return functionCall(target, data, "Address: low-level call failed");
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
644      * `errorMessage` as a fallback revert reason when `target` reverts.
645      *
646      * _Available since v3.1._
647      */
648     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
649         return functionCallWithValue(target, data, 0, errorMessage);
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
654      * but also transferring `value` wei to `target`.
655      *
656      * Requirements:
657      *
658      * - the calling contract must have an ETH balance of at least `value`.
659      * - the called Solidity function must be `payable`.
660      *
661      * _Available since v3.1._
662      */
663     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
664         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
669      * with `errorMessage` as a fallback revert reason when `target` reverts.
670      *
671      * _Available since v3.1._
672      */
673     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
674         require(address(this).balance >= value, "Address: insufficient balance for call");
675         require(isContract(target), "Address: call to non-contract");
676 
677         // solhint-disable-next-line avoid-low-level-calls
678         (bool success, bytes memory returndata) = target.call{ value: value }(data);
679         return _verifyCallResult(success, returndata, errorMessage);
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
684      * but performing a static call.
685      *
686      * _Available since v3.3._
687      */
688     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
689         return functionStaticCall(target, data, "Address: low-level static call failed");
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
694      * but performing a static call.
695      *
696      * _Available since v3.3._
697      */
698     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
699         require(isContract(target), "Address: static call to non-contract");
700 
701         // solhint-disable-next-line avoid-low-level-calls
702         (bool success, bytes memory returndata) = target.staticcall(data);
703         return _verifyCallResult(success, returndata, errorMessage);
704     }
705 
706     /**
707      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
708      * but performing a delegate call.
709      *
710      * _Available since v3.4._
711      */
712     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
713         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
718      * but performing a delegate call.
719      *
720      * _Available since v3.4._
721      */
722     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
723         require(isContract(target), "Address: delegate call to non-contract");
724 
725         // solhint-disable-next-line avoid-low-level-calls
726         (bool success, bytes memory returndata) = target.delegatecall(data);
727         return _verifyCallResult(success, returndata, errorMessage);
728     }
729 
730     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
731         if (success) {
732             return returndata;
733         } else {
734             // Look for revert reason and bubble it up if present
735             if (returndata.length > 0) {
736                 // The easiest way to bubble the revert reason is using memory via assembly
737 
738                 // solhint-disable-next-line no-inline-assembly
739                 assembly {
740                     let returndata_size := mload(returndata)
741                     revert(add(32, returndata), returndata_size)
742                 }
743             } else {
744                 revert(errorMessage);
745             }
746         }
747     }
748 }
749 
750 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
751 
752 
753 
754 pragma solidity >=0.6.0 <0.8.0;
755 
756 /**
757  * @dev Library for managing
758  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
759  * types.
760  *
761  * Sets have the following properties:
762  *
763  * - Elements are added, removed, and checked for existence in constant time
764  * (O(1)).
765  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
766  *
767  * ```
768  * contract Example {
769  *     // Add the library methods
770  *     using EnumerableSet for EnumerableSet.AddressSet;
771  *
772  *     // Declare a set state variable
773  *     EnumerableSet.AddressSet private mySet;
774  * }
775  * ```
776  *
777  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
778  * and `uint256` (`UintSet`) are supported.
779  */
780 library EnumerableSet {
781     // To implement this library for multiple types with as little code
782     // repetition as possible, we write it in terms of a generic Set type with
783     // bytes32 values.
784     // The Set implementation uses private functions, and user-facing
785     // implementations (such as AddressSet) are just wrappers around the
786     // underlying Set.
787     // This means that we can only create new EnumerableSets for types that fit
788     // in bytes32.
789 
790     struct Set {
791         // Storage of set values
792         bytes32[] _values;
793 
794         // Position of the value in the `values` array, plus 1 because index 0
795         // means a value is not in the set.
796         mapping (bytes32 => uint256) _indexes;
797     }
798 
799     /**
800      * @dev Add a value to a set. O(1).
801      *
802      * Returns true if the value was added to the set, that is if it was not
803      * already present.
804      */
805     function _add(Set storage set, bytes32 value) private returns (bool) {
806         if (!_contains(set, value)) {
807             set._values.push(value);
808             // The value is stored at length-1, but we add 1 to all indexes
809             // and use 0 as a sentinel value
810             set._indexes[value] = set._values.length;
811             return true;
812         } else {
813             return false;
814         }
815     }
816 
817     /**
818      * @dev Removes a value from a set. O(1).
819      *
820      * Returns true if the value was removed from the set, that is if it was
821      * present.
822      */
823     function _remove(Set storage set, bytes32 value) private returns (bool) {
824         // We read and store the value's index to prevent multiple reads from the same storage slot
825         uint256 valueIndex = set._indexes[value];
826 
827         if (valueIndex != 0) { // Equivalent to contains(set, value)
828             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
829             // the array, and then remove the last element (sometimes called as 'swap and pop').
830             // This modifies the order of the array, as noted in {at}.
831 
832             uint256 toDeleteIndex = valueIndex - 1;
833             uint256 lastIndex = set._values.length - 1;
834 
835             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
836             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
837 
838             bytes32 lastvalue = set._values[lastIndex];
839 
840             // Move the last value to the index where the value to delete is
841             set._values[toDeleteIndex] = lastvalue;
842             // Update the index for the moved value
843             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
844 
845             // Delete the slot where the moved value was stored
846             set._values.pop();
847 
848             // Delete the index for the deleted slot
849             delete set._indexes[value];
850 
851             return true;
852         } else {
853             return false;
854         }
855     }
856 
857     /**
858      * @dev Returns true if the value is in the set. O(1).
859      */
860     function _contains(Set storage set, bytes32 value) private view returns (bool) {
861         return set._indexes[value] != 0;
862     }
863 
864     /**
865      * @dev Returns the number of values on the set. O(1).
866      */
867     function _length(Set storage set) private view returns (uint256) {
868         return set._values.length;
869     }
870 
871     /**
872      * @dev Returns the value stored at position `index` in the set. O(1).
873      *
874      * Note that there are no guarantees on the ordering of values inside the
875      * array, and it may change when more values are added or removed.
876      *
877      * Requirements:
878      *
879      * - `index` must be strictly less than {length}.
880      */
881     function _at(Set storage set, uint256 index) private view returns (bytes32) {
882         require(set._values.length > index, "EnumerableSet: index out of bounds");
883         return set._values[index];
884     }
885 
886     // Bytes32Set
887 
888     struct Bytes32Set {
889         Set _inner;
890     }
891 
892     /**
893      * @dev Add a value to a set. O(1).
894      *
895      * Returns true if the value was added to the set, that is if it was not
896      * already present.
897      */
898     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
899         return _add(set._inner, value);
900     }
901 
902     /**
903      * @dev Removes a value from a set. O(1).
904      *
905      * Returns true if the value was removed from the set, that is if it was
906      * present.
907      */
908     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
909         return _remove(set._inner, value);
910     }
911 
912     /**
913      * @dev Returns true if the value is in the set. O(1).
914      */
915     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
916         return _contains(set._inner, value);
917     }
918 
919     /**
920      * @dev Returns the number of values in the set. O(1).
921      */
922     function length(Bytes32Set storage set) internal view returns (uint256) {
923         return _length(set._inner);
924     }
925 
926     /**
927      * @dev Returns the value stored at position `index` in the set. O(1).
928      *
929      * Note that there are no guarantees on the ordering of values inside the
930      * array, and it may change when more values are added or removed.
931      *
932      * Requirements:
933      *
934      * - `index` must be strictly less than {length}.
935      */
936     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
937         return _at(set._inner, index);
938     }
939 
940     // AddressSet
941 
942     struct AddressSet {
943         Set _inner;
944     }
945 
946     /**
947      * @dev Add a value to a set. O(1).
948      *
949      * Returns true if the value was added to the set, that is if it was not
950      * already present.
951      */
952     function add(AddressSet storage set, address value) internal returns (bool) {
953         return _add(set._inner, bytes32(uint256(uint160(value))));
954     }
955 
956     /**
957      * @dev Removes a value from a set. O(1).
958      *
959      * Returns true if the value was removed from the set, that is if it was
960      * present.
961      */
962     function remove(AddressSet storage set, address value) internal returns (bool) {
963         return _remove(set._inner, bytes32(uint256(uint160(value))));
964     }
965 
966     /**
967      * @dev Returns true if the value is in the set. O(1).
968      */
969     function contains(AddressSet storage set, address value) internal view returns (bool) {
970         return _contains(set._inner, bytes32(uint256(uint160(value))));
971     }
972 
973     /**
974      * @dev Returns the number of values in the set. O(1).
975      */
976     function length(AddressSet storage set) internal view returns (uint256) {
977         return _length(set._inner);
978     }
979 
980     /**
981      * @dev Returns the value stored at position `index` in the set. O(1).
982      *
983      * Note that there are no guarantees on the ordering of values inside the
984      * array, and it may change when more values are added or removed.
985      *
986      * Requirements:
987      *
988      * - `index` must be strictly less than {length}.
989      */
990     function at(AddressSet storage set, uint256 index) internal view returns (address) {
991         return address(uint160(uint256(_at(set._inner, index))));
992     }
993 
994 
995     // UintSet
996 
997     struct UintSet {
998         Set _inner;
999     }
1000 
1001     /**
1002      * @dev Add a value to a set. O(1).
1003      *
1004      * Returns true if the value was added to the set, that is if it was not
1005      * already present.
1006      */
1007     function add(UintSet storage set, uint256 value) internal returns (bool) {
1008         return _add(set._inner, bytes32(value));
1009     }
1010 
1011     /**
1012      * @dev Removes a value from a set. O(1).
1013      *
1014      * Returns true if the value was removed from the set, that is if it was
1015      * present.
1016      */
1017     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1018         return _remove(set._inner, bytes32(value));
1019     }
1020 
1021     /**
1022      * @dev Returns true if the value is in the set. O(1).
1023      */
1024     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1025         return _contains(set._inner, bytes32(value));
1026     }
1027 
1028     /**
1029      * @dev Returns the number of values on the set. O(1).
1030      */
1031     function length(UintSet storage set) internal view returns (uint256) {
1032         return _length(set._inner);
1033     }
1034 
1035     /**
1036      * @dev Returns the value stored at position `index` in the set. O(1).
1037      *
1038      * Note that there are no guarantees on the ordering of values inside the
1039      * array, and it may change when more values are added or removed.
1040      *
1041      * Requirements:
1042      *
1043      * - `index` must be strictly less than {length}.
1044      */
1045     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1046         return uint256(_at(set._inner, index));
1047     }
1048 }
1049 
1050 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1051 
1052 
1053 
1054 pragma solidity >=0.6.0 <0.8.0;
1055 
1056 /**
1057  * @dev Library for managing an enumerable variant of Solidity's
1058  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1059  * type.
1060  *
1061  * Maps have the following properties:
1062  *
1063  * - Entries are added, removed, and checked for existence in constant time
1064  * (O(1)).
1065  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1066  *
1067  * ```
1068  * contract Example {
1069  *     // Add the library methods
1070  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1071  *
1072  *     // Declare a set state variable
1073  *     EnumerableMap.UintToAddressMap private myMap;
1074  * }
1075  * ```
1076  *
1077  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1078  * supported.
1079  */
1080 library EnumerableMap {
1081     // To implement this library for multiple types with as little code
1082     // repetition as possible, we write it in terms of a generic Map type with
1083     // bytes32 keys and values.
1084     // The Map implementation uses private functions, and user-facing
1085     // implementations (such as Uint256ToAddressMap) are just wrappers around
1086     // the underlying Map.
1087     // This means that we can only create new EnumerableMaps for types that fit
1088     // in bytes32.
1089 
1090     struct MapEntry {
1091         bytes32 _key;
1092         bytes32 _value;
1093     }
1094 
1095     struct Map {
1096         // Storage of map keys and values
1097         MapEntry[] _entries;
1098 
1099         // Position of the entry defined by a key in the `entries` array, plus 1
1100         // because index 0 means a key is not in the map.
1101         mapping (bytes32 => uint256) _indexes;
1102     }
1103 
1104     /**
1105      * @dev Adds a key-value pair to a map, or updates the value for an existing
1106      * key. O(1).
1107      *
1108      * Returns true if the key was added to the map, that is if it was not
1109      * already present.
1110      */
1111     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1112         // We read and store the key's index to prevent multiple reads from the same storage slot
1113         uint256 keyIndex = map._indexes[key];
1114 
1115         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1116             map._entries.push(MapEntry({ _key: key, _value: value }));
1117             // The entry is stored at length-1, but we add 1 to all indexes
1118             // and use 0 as a sentinel value
1119             map._indexes[key] = map._entries.length;
1120             return true;
1121         } else {
1122             map._entries[keyIndex - 1]._value = value;
1123             return false;
1124         }
1125     }
1126 
1127     /**
1128      * @dev Removes a key-value pair from a map. O(1).
1129      *
1130      * Returns true if the key was removed from the map, that is if it was present.
1131      */
1132     function _remove(Map storage map, bytes32 key) private returns (bool) {
1133         // We read and store the key's index to prevent multiple reads from the same storage slot
1134         uint256 keyIndex = map._indexes[key];
1135 
1136         if (keyIndex != 0) { // Equivalent to contains(map, key)
1137             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1138             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1139             // This modifies the order of the array, as noted in {at}.
1140 
1141             uint256 toDeleteIndex = keyIndex - 1;
1142             uint256 lastIndex = map._entries.length - 1;
1143 
1144             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1145             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1146 
1147             MapEntry storage lastEntry = map._entries[lastIndex];
1148 
1149             // Move the last entry to the index where the entry to delete is
1150             map._entries[toDeleteIndex] = lastEntry;
1151             // Update the index for the moved entry
1152             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1153 
1154             // Delete the slot where the moved entry was stored
1155             map._entries.pop();
1156 
1157             // Delete the index for the deleted slot
1158             delete map._indexes[key];
1159 
1160             return true;
1161         } else {
1162             return false;
1163         }
1164     }
1165 
1166     /**
1167      * @dev Returns true if the key is in the map. O(1).
1168      */
1169     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1170         return map._indexes[key] != 0;
1171     }
1172 
1173     /**
1174      * @dev Returns the number of key-value pairs in the map. O(1).
1175      */
1176     function _length(Map storage map) private view returns (uint256) {
1177         return map._entries.length;
1178     }
1179 
1180     /**
1181      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1182      *
1183      * Note that there are no guarantees on the ordering of entries inside the
1184      * array, and it may change when more entries are added or removed.
1185      *
1186      * Requirements:
1187      *
1188      * - `index` must be strictly less than {length}.
1189      */
1190     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1191         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1192 
1193         MapEntry storage entry = map._entries[index];
1194         return (entry._key, entry._value);
1195     }
1196 
1197     /**
1198      * @dev Tries to returns the value associated with `key`.  O(1).
1199      * Does not revert if `key` is not in the map.
1200      */
1201     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1202         uint256 keyIndex = map._indexes[key];
1203         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1204         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1205     }
1206 
1207     /**
1208      * @dev Returns the value associated with `key`.  O(1).
1209      *
1210      * Requirements:
1211      *
1212      * - `key` must be in the map.
1213      */
1214     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1215         uint256 keyIndex = map._indexes[key];
1216         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1217         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1218     }
1219 
1220     /**
1221      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1222      *
1223      * CAUTION: This function is deprecated because it requires allocating memory for the error
1224      * message unnecessarily. For custom revert reasons use {_tryGet}.
1225      */
1226     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1227         uint256 keyIndex = map._indexes[key];
1228         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1229         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1230     }
1231 
1232     // UintToAddressMap
1233 
1234     struct UintToAddressMap {
1235         Map _inner;
1236     }
1237 
1238     /**
1239      * @dev Adds a key-value pair to a map, or updates the value for an existing
1240      * key. O(1).
1241      *
1242      * Returns true if the key was added to the map, that is if it was not
1243      * already present.
1244      */
1245     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1246         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1247     }
1248 
1249     /**
1250      * @dev Removes a value from a set. O(1).
1251      *
1252      * Returns true if the key was removed from the map, that is if it was present.
1253      */
1254     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1255         return _remove(map._inner, bytes32(key));
1256     }
1257 
1258     /**
1259      * @dev Returns true if the key is in the map. O(1).
1260      */
1261     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1262         return _contains(map._inner, bytes32(key));
1263     }
1264 
1265     /**
1266      * @dev Returns the number of elements in the map. O(1).
1267      */
1268     function length(UintToAddressMap storage map) internal view returns (uint256) {
1269         return _length(map._inner);
1270     }
1271 
1272     /**
1273      * @dev Returns the element stored at position `index` in the set. O(1).
1274      * Note that there are no guarantees on the ordering of values inside the
1275      * array, and it may change when more values are added or removed.
1276      *
1277      * Requirements:
1278      *
1279      * - `index` must be strictly less than {length}.
1280      */
1281     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1282         (bytes32 key, bytes32 value) = _at(map._inner, index);
1283         return (uint256(key), address(uint160(uint256(value))));
1284     }
1285 
1286     /**
1287      * @dev Tries to returns the value associated with `key`.  O(1).
1288      * Does not revert if `key` is not in the map.
1289      *
1290      * _Available since v3.4._
1291      */
1292     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1293         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1294         return (success, address(uint160(uint256(value))));
1295     }
1296 
1297     /**
1298      * @dev Returns the value associated with `key`.  O(1).
1299      *
1300      * Requirements:
1301      *
1302      * - `key` must be in the map.
1303      */
1304     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1305         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1306     }
1307 
1308     /**
1309      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1310      *
1311      * CAUTION: This function is deprecated because it requires allocating memory for the error
1312      * message unnecessarily. For custom revert reasons use {tryGet}.
1313      */
1314     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1315         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1316     }
1317 }
1318 
1319 // File: @openzeppelin/contracts/utils/Strings.sol
1320 
1321 
1322 
1323 pragma solidity >=0.6.0 <0.8.0;
1324 
1325 /**
1326  * @dev String operations.
1327  */
1328 library Strings {
1329     /**
1330      * @dev Converts a `uint256` to its ASCII `string` representation.
1331      */
1332     function toString(uint256 value) internal pure returns (string memory) {
1333         // Inspired by OraclizeAPI's implementation - MIT licence
1334         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1335 
1336         if (value == 0) {
1337             return "0";
1338         }
1339         uint256 temp = value;
1340         uint256 digits;
1341         while (temp != 0) {
1342             digits++;
1343             temp /= 10;
1344         }
1345         bytes memory buffer = new bytes(digits);
1346         uint256 index = digits - 1;
1347         temp = value;
1348         while (temp != 0) {
1349             buffer[index--] = bytes1(uint8(48 + temp % 10));
1350             temp /= 10;
1351         }
1352         return string(buffer);
1353     }
1354 }
1355 
1356 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1357 
1358 
1359 
1360 pragma solidity >=0.6.0 <0.8.0;
1361 
1362 
1363 
1364 
1365 
1366 
1367 
1368 
1369 
1370 
1371 
1372 
1373 /**
1374  * @title ERC721 Non-Fungible Token Standard basic implementation
1375  * @dev see https://eips.ethereum.org/EIPS/eip-721
1376  */
1377 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1378     using SafeMath for uint256;
1379     using Address for address;
1380     using EnumerableSet for EnumerableSet.UintSet;
1381     using EnumerableMap for EnumerableMap.UintToAddressMap;
1382     using Strings for uint256;
1383 
1384     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1385     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1386     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1387 
1388     // Mapping from holder address to their (enumerable) set of owned tokens
1389     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1390 
1391     // Enumerable mapping from token ids to their owners
1392     EnumerableMap.UintToAddressMap private _tokenOwners;
1393 
1394     // Mapping from token ID to approved address
1395     mapping (uint256 => address) private _tokenApprovals;
1396 
1397     // Mapping from owner to operator approvals
1398     mapping (address => mapping (address => bool)) private _operatorApprovals;
1399 
1400     // Token name
1401     string private _name;
1402 
1403     // Token symbol
1404     string private _symbol;
1405 
1406     // Optional mapping for token URIs
1407     mapping (uint256 => string) private _tokenURIs;
1408 
1409     // Base URI
1410     string private _baseURI;
1411 
1412     /*
1413      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1414      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1415      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1416      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1417      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1418      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1419      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1420      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1421      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1422      *
1423      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1424      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1425      */
1426     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1427 
1428     /*
1429      *     bytes4(keccak256('name()')) == 0x06fdde03
1430      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1431      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1432      *
1433      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1434      */
1435     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1436 
1437     /*
1438      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1439      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1440      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1441      *
1442      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1443      */
1444     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1445 
1446     /**
1447      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1448      */
1449     constructor (string memory name_, string memory symbol_) {
1450         _name = name_;
1451         _symbol = symbol_;
1452 
1453         // register the supported interfaces to conform to ERC721 via ERC165
1454         _registerInterface(_INTERFACE_ID_ERC721);
1455         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1456         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1457     }
1458 
1459     /**
1460      * @dev See {IERC721-balanceOf}.
1461      */
1462     function balanceOf(address owner) public view virtual override returns (uint256) {
1463         require(owner != address(0), "ERC721: balance query for the zero address");
1464         return _holderTokens[owner].length();
1465     }
1466 
1467     /**
1468      * @dev See {IERC721-ownerOf}.
1469      */
1470     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1471         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1472     }
1473 
1474     /**
1475      * @dev See {IERC721Metadata-name}.
1476      */
1477     function name() public view virtual override returns (string memory) {
1478         return _name;
1479     }
1480 
1481     /**
1482      * @dev See {IERC721Metadata-symbol}.
1483      */
1484     function symbol() public view virtual override returns (string memory) {
1485         return _symbol;
1486     }
1487 
1488     /**
1489      * @dev See {IERC721Metadata-tokenURI}.
1490      */
1491     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1492         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1493 
1494         string memory _tokenURI = _tokenURIs[tokenId];
1495         string memory base = baseURI();
1496 
1497         // If there is no base URI, return the token URI.
1498         if (bytes(base).length == 0) {
1499             return _tokenURI;
1500         }
1501         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1502         if (bytes(_tokenURI).length > 0) {
1503             return string(abi.encodePacked(base, _tokenURI));
1504         }
1505         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1506         return string(abi.encodePacked(base, tokenId.toString()));
1507     }
1508 
1509     /**
1510     * @dev Returns the base URI set via {_setBaseURI}. This will be
1511     * automatically added as a prefix in {tokenURI} to each token's URI, or
1512     * to the token ID if no specific URI is set for that token ID.
1513     */
1514     function baseURI() public view virtual returns (string memory) {
1515         return _baseURI;
1516     }
1517 
1518     /**
1519      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1520      */
1521     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1522         return _holderTokens[owner].at(index);
1523     }
1524 
1525     /**
1526      * @dev See {IERC721Enumerable-totalSupply}.
1527      */
1528     function totalSupply() public view virtual override returns (uint256) {
1529         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1530         return _tokenOwners.length();
1531     }
1532 
1533     /**
1534      * @dev See {IERC721Enumerable-tokenByIndex}.
1535      */
1536     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1537         (uint256 tokenId, ) = _tokenOwners.at(index);
1538         return tokenId;
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-approve}.
1543      */
1544     function approve(address to, uint256 tokenId) public virtual override {
1545         address owner = ERC721.ownerOf(tokenId);
1546         require(to != owner, "ERC721: approval to current owner");
1547 
1548         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1549             "ERC721: approve caller is not owner nor approved for all"
1550         );
1551 
1552         _approve(to, tokenId);
1553     }
1554 
1555     /**
1556      * @dev See {IERC721-getApproved}.
1557      */
1558     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1559         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1560 
1561         return _tokenApprovals[tokenId];
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-setApprovalForAll}.
1566      */
1567     function setApprovalForAll(address operator, bool approved) public virtual override {
1568         require(operator != _msgSender(), "ERC721: approve to caller");
1569 
1570         _operatorApprovals[_msgSender()][operator] = approved;
1571         emit ApprovalForAll(_msgSender(), operator, approved);
1572     }
1573 
1574     /**
1575      * @dev See {IERC721-isApprovedForAll}.
1576      */
1577     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1578         return _operatorApprovals[owner][operator];
1579     }
1580 
1581     /**
1582      * @dev See {IERC721-transferFrom}.
1583      */
1584     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1585         //solhint-disable-next-line max-line-length
1586         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1587 
1588         _transfer(from, to, tokenId);
1589     }
1590 
1591     /**
1592      * @dev See {IERC721-safeTransferFrom}.
1593      */
1594     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1595         safeTransferFrom(from, to, tokenId, "");
1596     }
1597 
1598     /**
1599      * @dev See {IERC721-safeTransferFrom}.
1600      */
1601     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1602         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1603         _safeTransfer(from, to, tokenId, _data);
1604     }
1605 
1606     /**
1607      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1608      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1609      *
1610      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1611      *
1612      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1613      * implement alternative mechanisms to perform token transfer, such as signature-based.
1614      *
1615      * Requirements:
1616      *
1617      * - `from` cannot be the zero address.
1618      * - `to` cannot be the zero address.
1619      * - `tokenId` token must exist and be owned by `from`.
1620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1621      *
1622      * Emits a {Transfer} event.
1623      */
1624     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1625         _transfer(from, to, tokenId);
1626         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1627     }
1628 
1629     /**
1630      * @dev Returns whether `tokenId` exists.
1631      *
1632      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1633      *
1634      * Tokens start existing when they are minted (`_mint`),
1635      * and stop existing when they are burned (`_burn`).
1636      */
1637     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1638         return _tokenOwners.contains(tokenId);
1639     }
1640 
1641     /**
1642      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1643      *
1644      * Requirements:
1645      *
1646      * - `tokenId` must exist.
1647      */
1648     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1649         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1650         address owner = ERC721.ownerOf(tokenId);
1651         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1652     }
1653 
1654     /**
1655      * @dev Safely mints `tokenId` and transfers it to `to`.
1656      *
1657      * Requirements:
1658      d*
1659      * - `tokenId` must not exist.
1660      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1661      *
1662      * Emits a {Transfer} event.
1663      */
1664     function _safeMint(address to, uint256 tokenId) internal virtual {
1665         _safeMint(to, tokenId, "");
1666     }
1667 
1668     /**
1669      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1670      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1671      */
1672     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1673         _mint(to, tokenId);
1674         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1675     }
1676 
1677     /**
1678      * @dev Mints `tokenId` and transfers it to `to`.
1679      *
1680      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1681      *
1682      * Requirements:
1683      *
1684      * - `tokenId` must not exist.
1685      * - `to` cannot be the zero address.
1686      *
1687      * Emits a {Transfer} event.
1688      */
1689     function _mint(address to, uint256 tokenId) internal virtual {
1690         require(to != address(0), "ERC721: mint to the zero address");
1691         require(!_exists(tokenId), "ERC721: token already minted");
1692 
1693         _beforeTokenTransfer(address(0), to, tokenId);
1694 
1695         _holderTokens[to].add(tokenId);
1696 
1697         _tokenOwners.set(tokenId, to);
1698 
1699         emit Transfer(address(0), to, tokenId);
1700     }
1701 
1702     /**
1703      * @dev Destroys `tokenId`.
1704      * The approval is cleared when the token is burned.
1705      *
1706      * Requirements:
1707      *
1708      * - `tokenId` must exist.
1709      *
1710      * Emits a {Transfer} event.
1711      */
1712     function _burn(uint256 tokenId) internal virtual {
1713         address owner = ERC721.ownerOf(tokenId); // internal owner
1714 
1715         _beforeTokenTransfer(owner, address(0), tokenId);
1716 
1717         // Clear approvals
1718         _approve(address(0), tokenId);
1719 
1720         // Clear metadata (if any)
1721         if (bytes(_tokenURIs[tokenId]).length != 0) {
1722             delete _tokenURIs[tokenId];
1723         }
1724 
1725         _holderTokens[owner].remove(tokenId);
1726 
1727         _tokenOwners.remove(tokenId);
1728 
1729         emit Transfer(owner, address(0), tokenId);
1730     }
1731 
1732     /**
1733      * @dev Transfers `tokenId` from `from` to `to`.
1734      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1735      *
1736      * Requirements:
1737      *
1738      * - `to` cannot be the zero address.
1739      * - `tokenId` token must be owned by `from`.
1740      *
1741      * Emits a {Transfer} event.
1742      */
1743     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1744         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1745         require(to != address(0), "ERC721: transfer to the zero address");
1746 
1747         _beforeTokenTransfer(from, to, tokenId);
1748 
1749         // Clear approvals from the previous owner
1750         _approve(address(0), tokenId);
1751 
1752         _holderTokens[from].remove(tokenId);
1753         _holderTokens[to].add(tokenId);
1754 
1755         _tokenOwners.set(tokenId, to);
1756 
1757         emit Transfer(from, to, tokenId);
1758     }
1759 
1760     /**
1761      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1762      *
1763      * Requirements:
1764      *
1765      * - `tokenId` must exist.
1766      */
1767     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1768         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1769         _tokenURIs[tokenId] = _tokenURI;
1770     }
1771 
1772     /**
1773      * @dev Internal function to set the base URI for all token IDs. It is
1774      * automatically added as a prefix to the value returned in {tokenURI},
1775      * or to the token ID if {tokenURI} is empty.
1776      */
1777     function _setBaseURI(string memory baseURI_) internal virtual {
1778         _baseURI = baseURI_;
1779     }
1780 
1781     /**
1782      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1783      * The call is not executed if the target address is not a contract.
1784      *
1785      * @param from address representing the previous owner of the given token ID
1786      * @param to target address that will receive the tokens
1787      * @param tokenId uint256 ID of the token to be transferred
1788      * @param _data bytes optional data to send along with the call
1789      * @return bool whether the call correctly returned the expected magic value
1790      */
1791     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1792     private returns (bool)
1793     {
1794         if (!to.isContract()) {
1795             return true;
1796         }
1797         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1798                 IERC721Receiver(to).onERC721Received.selector,
1799                 _msgSender(),
1800                 from,
1801                 tokenId,
1802                 _data
1803             ), "ERC721: transfer to non ERC721Receiver implementer");
1804         bytes4 retval = abi.decode(returndata, (bytes4));
1805         return (retval == _ERC721_RECEIVED);
1806     }
1807 
1808     /**
1809      * @dev Approve `to` to operate on `tokenId`
1810      *
1811      * Emits an {Approval} event.
1812      */
1813     function _approve(address to, uint256 tokenId) internal virtual {
1814         _tokenApprovals[tokenId] = to;
1815         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1816     }
1817 
1818     /**
1819      * @dev Hook that is called before any token transfer. This includes minting
1820      * and burning.
1821      *
1822      * Calling conditions:
1823      *
1824      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1825      * transferred to `to`.
1826      * - When `from` is zero, `tokenId` will be minted for `to`.
1827      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1828      * - `from` cannot be the zero address.
1829      * - `to` cannot be the zero address.
1830      *
1831      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1832      */
1833     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1834 }
1835 
1836 // File: @openzeppelin/contracts/access/Ownable.sol
1837 
1838 
1839 
1840 pragma solidity >=0.6.0 <0.8.0;
1841 
1842 /**
1843  * @dev Contract module which provides a basic access control mechanism, where
1844  * there is an account (an owner) that can be granted exclusive access to
1845  * specific functions.
1846  *
1847  * By default, the owner account will be the one that deploys the contract. This
1848  * can later be changed with {transferOwnership}.
1849  *
1850  * This module is used through inheritance. It will make available the modifier
1851  * `onlyOwner`, which can be applied to your functions to restrict their use to
1852  * the owner.
1853  */
1854 abstract contract Ownable is Context {
1855     address private _owner;
1856 
1857     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1858 
1859     /**
1860      * @dev Initializes the contract setting the deployer as the initial owner.
1861      */
1862     constructor () {
1863         address msgSender = _msgSender();
1864         _owner = msgSender;
1865         emit OwnershipTransferred(address(0), msgSender);
1866     }
1867 
1868     /**
1869      * @dev Returns the address of the current owner.
1870      */
1871     function owner() public view virtual returns (address) {
1872         return _owner;
1873     }
1874 
1875     /**
1876      * @dev Throws if called by any account other than the owner.
1877      */
1878     modifier onlyOwner() {
1879         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1880         _;
1881     }
1882 
1883     /**
1884      * @dev Leaves the contract without owner. It will not be possible to call
1885      * `onlyOwner` functions anymore. Can only be called by the current owner.
1886      *
1887      * NOTE: Renouncing ownership will leave the contract without an owner,
1888      * thereby removing any functionality that is only available to the owner.
1889      */
1890     function renounceOwnership() public virtual onlyOwner {
1891         emit OwnershipTransferred(_owner, address(0));
1892         _owner = address(0);
1893     }
1894 
1895     /**
1896      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1897      * Can only be called by the current owner.
1898      */
1899     function transferOwnership(address newOwner) public virtual onlyOwner {
1900         require(newOwner != address(0), "Ownable: new owner is the zero address");
1901         emit OwnershipTransferred(_owner, newOwner);
1902         _owner = newOwner;
1903     }
1904 }
1905 
1906 // File: contracts/DoodleGutterCats.sol
1907 
1908 pragma solidity 0.7.0;
1909 
1910 /**
1911  * @title DoodleGutterCats contract
1912  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1913  */
1914 contract DoodleGutterCats is ERC721, Ownable {
1915     using SafeMath for uint256;
1916 
1917     uint256 public catPriceWl = 25000000000000000; // 0.025 ETH
1918     uint256 public catPrice = 35000000000000000; // 0.035 ETH
1919     uint256 public maxCatPurchase = 20;
1920     uint256 public maxCats = 7777;
1921 
1922     uint256 public constant WL_MAX_MINT = 4;
1923 
1924     bool public presaleIsActive = false;
1925     bool public saleIsActive = false;
1926     bool public reserved = false;
1927 
1928     mapping(address => bool) private _wlEligible;
1929 
1930     mapping(address => uint256) private _totalClaimedWl;
1931 
1932     event CatPriceWlChanged(uint256 price);
1933     event CatPriceChanged(uint256 price);
1934     event MaxTokenAmountChanged(uint256 value);
1935     event MaxPurchaseChanged(uint256 value);
1936     event CatsReserved();
1937     event RolledOver(bool status);
1938 
1939     constructor() ERC721("Doodle Gutter Cats", "DGC") { }
1940 
1941     function withdraw() public onlyOwner {
1942         uint balance = address(this).balance;
1943         Address.sendValue(_msgSender(), balance);
1944     }
1945 
1946     function reserveCats() public onlyOwner onReserve {
1947         uint supply = totalSupply();
1948         uint i;
1949         for (i; i < 30; i++) {
1950             _safeMint(_msgSender(), supply + i);
1951         }
1952     }
1953 
1954     function flipPresaleState() public onlyOwner {
1955         presaleIsActive = !presaleIsActive;
1956         emit RolledOver(presaleIsActive);
1957     }
1958 
1959     function flipSaleState() public onlyOwner {
1960         saleIsActive = !saleIsActive;
1961         emit RolledOver(saleIsActive);
1962     }
1963 
1964     function setBaseURI(string memory baseURI) public onlyOwner {
1965         _setBaseURI(baseURI);
1966     }
1967 
1968     function addToWlPresale(address[] calldata addresses) external onlyOwner {
1969         for (uint256 i = 0; i < addresses.length; i++) {
1970             require(addresses[i] != address(0), "Cannot add null address");
1971 
1972             _wlEligible[addresses[i]] = true;
1973         }
1974     }
1975 
1976     function removeFromWlPresale(address[] calldata addresses) external onlyOwner {
1977         for (uint256 i = 0; i < addresses.length; i++) {
1978             require(addresses[i] != address(0), "Cannot add null address");
1979 
1980             _wlEligible[addresses[i]] = false;
1981         }
1982     }
1983 
1984     function getWlEligible(address addr) external view returns (bool) {
1985         return _wlEligible[addr];
1986     }
1987 
1988     function getWlMintsClaimed(address addr) external view returns (uint256) {
1989         return _totalClaimedWl[addr];
1990     }
1991 
1992     function getRemainingWlMints(address addr) external view returns (uint256) {
1993         if (!_wlEligible[addr]) {
1994             return 0;
1995         }
1996         return WL_MAX_MINT - _totalClaimedWl[addr];
1997     }
1998 
1999     function mintCatsPresale(uint numberOfTokens) external payable {
2000         require(presaleIsActive, "Presale is not active");
2001         require(_wlEligible[msg.sender], "You are not eligible for the presale");
2002         require(_totalClaimedWl[msg.sender] + numberOfTokens <= WL_MAX_MINT, "Purchase exceeds max allowed for the presale");
2003         require(numberOfTokens <= maxCatPurchase, "Exceeds max number of Cats in one transaction");
2004         require(totalSupply().add(numberOfTokens) <= maxCats, "Purchase would exceed max supply of Cats");
2005         require(catPriceWl.mul(numberOfTokens) == msg.value, "Ether value sent is not correct");
2006 
2007         uint i;
2008         uint mintIndex;
2009         for (i; i < numberOfTokens; i++) {
2010             mintIndex = totalSupply();
2011             if (totalSupply() < maxCats) {
2012                 _totalClaimedWl[msg.sender] += 1;
2013                 _safeMint(_msgSender(), mintIndex);
2014             }
2015         }
2016     }
2017 
2018     function mintCatsSale(uint numberOfTokens) external payable {
2019         require(saleIsActive, "Sale is not active");
2020         require(numberOfTokens <= maxCatPurchase, "Exceeds max number of Cats in one transaction");
2021         require(totalSupply().add(numberOfTokens) <= maxCats, "Purchase would exceed max supply of Cats");
2022         require(catPrice.mul(numberOfTokens) == msg.value, "Ether value sent is not correct");
2023 
2024         uint i;
2025         uint mintIndex;
2026         for (i; i < numberOfTokens; i++) {
2027             mintIndex = totalSupply();
2028             if (totalSupply() < maxCats) {
2029                 _safeMint(_msgSender(), mintIndex);
2030             }
2031         }
2032     }
2033 
2034     function setPriceWl(uint256 _price) external onlyOwner {
2035         require(_price > 0, "Zero price");
2036 
2037         catPriceWl = _price;
2038         emit CatPriceWlChanged(_price);
2039     }
2040 
2041     function setPrice(uint256 _price) external onlyOwner {
2042         require(_price > 0, "Zero price");
2043 
2044         catPrice = _price;
2045         emit CatPriceChanged(_price);
2046     }
2047 
2048     function setMaxTokenAmount(uint256 _value) external onlyOwner {
2049         require(
2050             _value > totalSupply() && _value <= 7_777,
2051             "Wrong value for max supply"
2052         );
2053 
2054         maxCats = _value;
2055         emit MaxTokenAmountChanged(_value);
2056     }
2057 
2058     function setMaxPurchase(uint256 _value) external onlyOwner {
2059         require(_value > 0, "Very low value");
2060 
2061         maxCatPurchase = _value;
2062         emit MaxPurchaseChanged(_value);
2063     }
2064 
2065     modifier onReserve() {
2066         require(!reserved, "Tokens reserved");
2067         _;
2068         reserved = true;
2069         emit CatsReserved();
2070     }
2071 
2072 }