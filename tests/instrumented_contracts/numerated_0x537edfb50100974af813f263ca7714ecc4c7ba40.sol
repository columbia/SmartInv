1 // File: contracts/IScam.sol
2 
3 // spd-License-Identifier: AGPL-3.0-or-later
4 
5 pragma solidity ^0.6.8;
6 
7 interface IScam {
8   function transferFrom(address from, address to, uint256 tokenId) external;
9   function ownerOf(uint256 tokenId) external view returns (address owner);
10 }
11 
12 // File: @openzeppelin/contracts/utils/Context.sol
13 
14 // spd-License-Identifier: MIT
15 
16 pragma solidity >=0.6.0 <0.8.0;
17 
18 /*
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with GSN meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address payable) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes memory) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 // File: @openzeppelin/contracts/introspection/IERC165.sol
40 
41 // spd-License-Identifier: MIT
42 
43 pragma solidity >=0.6.0 <0.8.0;
44 
45 /**
46  * @dev Interface of the ERC165 standard, as defined in the
47  * https://eips.ethereum.org/EIPS/eip-165[EIP].
48  *
49  * Implementers can declare support of contract interfaces, which can then be
50  * queried by others ({ERC165Checker}).
51  *
52  * For an implementation, see {ERC165}.
53  */
54 interface IERC165 {
55     /**
56      * @dev Returns true if this contract implements the interface defined by
57      * `interfaceId`. See the corresponding
58      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
59      * to learn more about how these ids are created.
60      *
61      * This function call must use less than 30 000 gas.
62      */
63     function supportsInterface(bytes4 interfaceId) external view returns (bool);
64 }
65 
66 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
67 
68 // spd-License-Identifier: MIT
69 
70 pragma solidity >=0.6.2 <0.8.0;
71 
72 
73 /**
74  * @dev Required interface of an ERC721 compliant contract.
75  */
76 interface IERC721 is IERC165 {
77     /**
78      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
81 
82     /**
83      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
84      */
85     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
86 
87     /**
88      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
89      */
90     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
91 
92     /**
93      * @dev Returns the number of tokens in ``owner``'s account.
94      */
95     function balanceOf(address owner) external view returns (uint256 balance);
96 
97     /**
98      * @dev Returns the owner of the `tokenId` token.
99      *
100      * Requirements:
101      *
102      * - `tokenId` must exist.
103      */
104     function ownerOf(uint256 tokenId) external view returns (address owner);
105 
106     /**
107      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
108      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
109      *
110      * Requirements:
111      *
112      * - `from` cannot be the zero address.
113      * - `to` cannot be the zero address.
114      * - `tokenId` token must exist and be owned by `from`.
115      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
116      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
117      *
118      * Emits a {Transfer} event.
119      */
120     function safeTransferFrom(address from, address to, uint256 tokenId) external;
121 
122     /**
123      * @dev Transfers `tokenId` token from `from` to `to`.
124      *
125      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
126      *
127      * Requirements:
128      *
129      * - `from` cannot be the zero address.
130      * - `to` cannot be the zero address.
131      * - `tokenId` token must be owned by `from`.
132      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transferFrom(address from, address to, uint256 tokenId) external;
137 
138     /**
139      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
140      * The approval is cleared when the token is transferred.
141      *
142      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
143      *
144      * Requirements:
145      *
146      * - The caller must own the token or be an approved operator.
147      * - `tokenId` must exist.
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address to, uint256 tokenId) external;
152 
153     /**
154      * @dev Returns the account approved for `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function getApproved(uint256 tokenId) external view returns (address operator);
161 
162     /**
163      * @dev Approve or remove `operator` as an operator for the caller.
164      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
165      *
166      * Requirements:
167      *
168      * - The `operator` cannot be the caller.
169      *
170      * Emits an {ApprovalForAll} event.
171      */
172     function setApprovalForAll(address operator, bool _approved) external;
173 
174     /**
175      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
176      *
177      * See {setApprovalForAll}
178      */
179     function isApprovedForAll(address owner, address operator) external view returns (bool);
180 
181     /**
182       * @dev Safely transfers `tokenId` token from `from` to `to`.
183       *
184       * Requirements:
185       *
186       * - `from` cannot be the zero address.
187       * - `to` cannot be the zero address.
188       * - `tokenId` token must exist and be owned by `from`.
189       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
190       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
191       *
192       * Emits a {Transfer} event.
193       */
194     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
195 }
196 
197 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
198 
199 // spd-License-Identifier: MIT
200 
201 pragma solidity >=0.6.2 <0.8.0;
202 
203 
204 /**
205  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
206  * @dev See https://eips.ethereum.org/EIPS/eip-721
207  */
208 interface IERC721Metadata is IERC721 {
209 
210     /**
211      * @dev Returns the token collection name.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the token collection symbol.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
222      */
223     function tokenURI(uint256 tokenId) external view returns (string memory);
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
227 
228 // spd-License-Identifier: MIT
229 
230 pragma solidity >=0.6.2 <0.8.0;
231 
232 
233 /**
234  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
235  * @dev See https://eips.ethereum.org/EIPS/eip-721
236  */
237 interface IERC721Enumerable is IERC721 {
238 
239     /**
240      * @dev Returns the total amount of tokens stored by the contract.
241      */
242     function totalSupply() external view returns (uint256);
243 
244     /**
245      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
246      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
247      */
248     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
249 
250     /**
251      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
252      * Use along with {totalSupply} to enumerate all tokens.
253      */
254     function tokenByIndex(uint256 index) external view returns (uint256);
255 }
256 
257 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
258 
259 // spd-License-Identifier: MIT
260 
261 pragma solidity >=0.6.0 <0.8.0;
262 
263 /**
264  * @title ERC721 token receiver interface
265  * @dev Interface for any contract that wants to support safeTransfers
266  * from ERC721 asset contracts.
267  */
268 interface IERC721Receiver {
269     /**
270      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
271      * by `operator` from `from`, this function is called.
272      *
273      * It must return its Solidity selector to confirm the token transfer.
274      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
275      *
276      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
277      */
278     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
279 }
280 
281 // File: @openzeppelin/contracts/introspection/ERC165.sol
282 
283 // spd-License-Identifier: MIT
284 
285 pragma solidity >=0.6.0 <0.8.0;
286 
287 
288 /**
289  * @dev Implementation of the {IERC165} interface.
290  *
291  * Contracts may inherit from this and call {_registerInterface} to declare
292  * their support of an interface.
293  */
294 abstract contract ERC165 is IERC165 {
295     /*
296      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
297      */
298     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
299 
300     /**
301      * @dev Mapping of interface ids to whether or not it's supported.
302      */
303     mapping(bytes4 => bool) private _supportedInterfaces;
304 
305     constructor () internal {
306         // Derived contracts need only register support for their own interfaces,
307         // we register support for ERC165 itself here
308         _registerInterface(_INTERFACE_ID_ERC165);
309     }
310 
311     /**
312      * @dev See {IERC165-supportsInterface}.
313      *
314      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
315      */
316     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
317         return _supportedInterfaces[interfaceId];
318     }
319 
320     /**
321      * @dev Registers the contract as an implementer of the interface defined by
322      * `interfaceId`. Support of the actual ERC165 interface is automatic and
323      * registering its interface id is not required.
324      *
325      * See {IERC165-supportsInterface}.
326      *
327      * Requirements:
328      *
329      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
330      */
331     function _registerInterface(bytes4 interfaceId) internal virtual {
332         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
333         _supportedInterfaces[interfaceId] = true;
334     }
335 }
336 
337 // File: @openzeppelin/contracts/math/SafeMath.sol
338 
339 // spd-License-Identifier: MIT
340 
341 pragma solidity >=0.6.0 <0.8.0;
342 
343 /**
344  * @dev Wrappers over Solidity's arithmetic operations with added overflow
345  * checks.
346  *
347  * Arithmetic operations in Solidity wrap on overflow. This can easily result
348  * in bugs, because programmers usually assume that an overflow raises an
349  * error, which is the standard behavior in high level programming languages.
350  * `SafeMath` restores this intuition by reverting the transaction when an
351  * operation overflows.
352  *
353  * Using this library instead of the unchecked operations eliminates an entire
354  * class of bugs, so it's recommended to use it always.
355  */
356 library SafeMath {
357     /**
358      * @dev Returns the addition of two unsigned integers, with an overflow flag.
359      *
360      * _Available since v3.4._
361      */
362     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
363         uint256 c = a + b;
364         if (c < a) return (false, 0);
365         return (true, c);
366     }
367 
368     /**
369      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
370      *
371      * _Available since v3.4._
372      */
373     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
374         if (b > a) return (false, 0);
375         return (true, a - b);
376     }
377 
378     /**
379      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
380      *
381      * _Available since v3.4._
382      */
383     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
384         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
385         // benefit is lost if 'b' is also tested.
386         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
387         if (a == 0) return (true, 0);
388         uint256 c = a * b;
389         if (c / a != b) return (false, 0);
390         return (true, c);
391     }
392 
393     /**
394      * @dev Returns the division of two unsigned integers, with a division by zero flag.
395      *
396      * _Available since v3.4._
397      */
398     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
399         if (b == 0) return (false, 0);
400         return (true, a / b);
401     }
402 
403     /**
404      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
405      *
406      * _Available since v3.4._
407      */
408     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
409         if (b == 0) return (false, 0);
410         return (true, a % b);
411     }
412 
413     /**
414      * @dev Returns the addition of two unsigned integers, reverting on
415      * overflow.
416      *
417      * Counterpart to Solidity's `+` operator.
418      *
419      * Requirements:
420      *
421      * - Addition cannot overflow.
422      */
423     function add(uint256 a, uint256 b) internal pure returns (uint256) {
424         uint256 c = a + b;
425         require(c >= a, "SafeMath: addition overflow");
426         return c;
427     }
428 
429     /**
430      * @dev Returns the subtraction of two unsigned integers, reverting on
431      * overflow (when the result is negative).
432      *
433      * Counterpart to Solidity's `-` operator.
434      *
435      * Requirements:
436      *
437      * - Subtraction cannot overflow.
438      */
439     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
440         require(b <= a, "SafeMath: subtraction overflow");
441         return a - b;
442     }
443 
444     /**
445      * @dev Returns the multiplication of two unsigned integers, reverting on
446      * overflow.
447      *
448      * Counterpart to Solidity's `*` operator.
449      *
450      * Requirements:
451      *
452      * - Multiplication cannot overflow.
453      */
454     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
455         if (a == 0) return 0;
456         uint256 c = a * b;
457         require(c / a == b, "SafeMath: multiplication overflow");
458         return c;
459     }
460 
461     /**
462      * @dev Returns the integer division of two unsigned integers, reverting on
463      * division by zero. The result is rounded towards zero.
464      *
465      * Counterpart to Solidity's `/` operator. Note: this function uses a
466      * `revert` opcode (which leaves remaining gas untouched) while Solidity
467      * uses an invalid opcode to revert (consuming all remaining gas).
468      *
469      * Requirements:
470      *
471      * - The divisor cannot be zero.
472      */
473     function div(uint256 a, uint256 b) internal pure returns (uint256) {
474         require(b > 0, "SafeMath: division by zero");
475         return a / b;
476     }
477 
478     /**
479      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
480      * reverting when dividing by zero.
481      *
482      * Counterpart to Solidity's `%` operator. This function uses a `revert`
483      * opcode (which leaves remaining gas untouched) while Solidity uses an
484      * invalid opcode to revert (consuming all remaining gas).
485      *
486      * Requirements:
487      *
488      * - The divisor cannot be zero.
489      */
490     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
491         require(b > 0, "SafeMath: modulo by zero");
492         return a % b;
493     }
494 
495     /**
496      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
497      * overflow (when the result is negative).
498      *
499      * CAUTION: This function is deprecated because it requires allocating memory for the error
500      * message unnecessarily. For custom revert reasons use {trySub}.
501      *
502      * Counterpart to Solidity's `-` operator.
503      *
504      * Requirements:
505      *
506      * - Subtraction cannot overflow.
507      */
508     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
509         require(b <= a, errorMessage);
510         return a - b;
511     }
512 
513     /**
514      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
515      * division by zero. The result is rounded towards zero.
516      *
517      * CAUTION: This function is deprecated because it requires allocating memory for the error
518      * message unnecessarily. For custom revert reasons use {tryDiv}.
519      *
520      * Counterpart to Solidity's `/` operator. Note: this function uses a
521      * `revert` opcode (which leaves remaining gas untouched) while Solidity
522      * uses an invalid opcode to revert (consuming all remaining gas).
523      *
524      * Requirements:
525      *
526      * - The divisor cannot be zero.
527      */
528     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
529         require(b > 0, errorMessage);
530         return a / b;
531     }
532 
533     /**
534      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
535      * reverting with custom message when dividing by zero.
536      *
537      * CAUTION: This function is deprecated because it requires allocating memory for the error
538      * message unnecessarily. For custom revert reasons use {tryMod}.
539      *
540      * Counterpart to Solidity's `%` operator. This function uses a `revert`
541      * opcode (which leaves remaining gas untouched) while Solidity uses an
542      * invalid opcode to revert (consuming all remaining gas).
543      *
544      * Requirements:
545      *
546      * - The divisor cannot be zero.
547      */
548     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
549         require(b > 0, errorMessage);
550         return a % b;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/utils/Address.sol
555 
556 // spd-License-Identifier: MIT
557 
558 pragma solidity >=0.6.2 <0.8.0;
559 
560 /**
561  * @dev Collection of functions related to the address type
562  */
563 library Address {
564     /**
565      * @dev Returns true if `account` is a contract.
566      *
567      * [IMPORTANT]
568      * ====
569      * It is unsafe to assume that an address for which this function returns
570      * false is an externally-owned account (EOA) and not a contract.
571      *
572      * Among others, `isContract` will return false for the following
573      * types of addresses:
574      *
575      *  - an externally-owned account
576      *  - a contract in construction
577      *  - an address where a contract will be created
578      *  - an address where a contract lived, but was destroyed
579      * ====
580      */
581     function isContract(address account) internal view returns (bool) {
582         // This method relies on extcodesize, which returns 0 for contracts in
583         // construction, since the code is only stored at the end of the
584         // constructor execution.
585 
586         uint256 size;
587         // solhint-disable-next-line no-inline-assembly
588         assembly { size := extcodesize(account) }
589         return size > 0;
590     }
591 
592     /**
593      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
594      * `recipient`, forwarding all available gas and reverting on errors.
595      *
596      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
597      * of certain opcodes, possibly making contracts go over the 2300 gas limit
598      * imposed by `transfer`, making them unable to receive funds via
599      * `transfer`. {sendValue} removes this limitation.
600      *
601      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
602      *
603      * IMPORTANT: because control is transferred to `recipient`, care must be
604      * taken to not create reentrancy vulnerabilities. Consider using
605      * {ReentrancyGuard} or the
606      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
607      */
608     function sendValue(address payable recipient, uint256 amount) internal {
609         require(address(this).balance >= amount, "Address: insufficient balance");
610 
611         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
612         (bool success, ) = recipient.call{ value: amount }("");
613         require(success, "Address: unable to send value, recipient may have reverted");
614     }
615 
616     /**
617      * @dev Performs a Solidity function call using a low level `call`. A
618      * plain`call` is an unsafe replacement for a function call: use this
619      * function instead.
620      *
621      * If `target` reverts with a revert reason, it is bubbled up by this
622      * function (like regular Solidity function calls).
623      *
624      * Returns the raw returned data. To convert to the expected return value,
625      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
626      *
627      * Requirements:
628      *
629      * - `target` must be a contract.
630      * - calling `target` with `data` must not revert.
631      *
632      * _Available since v3.1._
633      */
634     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
635       return functionCall(target, data, "Address: low-level call failed");
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
640      * `errorMessage` as a fallback revert reason when `target` reverts.
641      *
642      * _Available since v3.1._
643      */
644     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
645         return functionCallWithValue(target, data, 0, errorMessage);
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
650      * but also transferring `value` wei to `target`.
651      *
652      * Requirements:
653      *
654      * - the calling contract must have an ETH balance of at least `value`.
655      * - the called Solidity function must be `payable`.
656      *
657      * _Available since v3.1._
658      */
659     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
660         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
665      * with `errorMessage` as a fallback revert reason when `target` reverts.
666      *
667      * _Available since v3.1._
668      */
669     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
670         require(address(this).balance >= value, "Address: insufficient balance for call");
671         require(isContract(target), "Address: call to non-contract");
672 
673         // solhint-disable-next-line avoid-low-level-calls
674         (bool success, bytes memory returndata) = target.call{ value: value }(data);
675         return _verifyCallResult(success, returndata, errorMessage);
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
680      * but performing a static call.
681      *
682      * _Available since v3.3._
683      */
684     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
685         return functionStaticCall(target, data, "Address: low-level static call failed");
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
690      * but performing a static call.
691      *
692      * _Available since v3.3._
693      */
694     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
695         require(isContract(target), "Address: static call to non-contract");
696 
697         // solhint-disable-next-line avoid-low-level-calls
698         (bool success, bytes memory returndata) = target.staticcall(data);
699         return _verifyCallResult(success, returndata, errorMessage);
700     }
701 
702     /**
703      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
704      * but performing a delegate call.
705      *
706      * _Available since v3.4._
707      */
708     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
709         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
710     }
711 
712     /**
713      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
714      * but performing a delegate call.
715      *
716      * _Available since v3.4._
717      */
718     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
719         require(isContract(target), "Address: delegate call to non-contract");
720 
721         // solhint-disable-next-line avoid-low-level-calls
722         (bool success, bytes memory returndata) = target.delegatecall(data);
723         return _verifyCallResult(success, returndata, errorMessage);
724     }
725 
726     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
727         if (success) {
728             return returndata;
729         } else {
730             // Look for revert reason and bubble it up if present
731             if (returndata.length > 0) {
732                 // The easiest way to bubble the revert reason is using memory via assembly
733 
734                 // solhint-disable-next-line no-inline-assembly
735                 assembly {
736                     let returndata_size := mload(returndata)
737                     revert(add(32, returndata), returndata_size)
738                 }
739             } else {
740                 revert(errorMessage);
741             }
742         }
743     }
744 }
745 
746 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
747 
748 // spd-License-Identifier: MIT
749 
750 pragma solidity >=0.6.0 <0.8.0;
751 
752 /**
753  * @dev Library for managing
754  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
755  * types.
756  *
757  * Sets have the following properties:
758  *
759  * - Elements are added, removed, and checked for existence in constant time
760  * (O(1)).
761  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
762  *
763  * ```
764  * contract Example {
765  *     // Add the library methods
766  *     using EnumerableSet for EnumerableSet.AddressSet;
767  *
768  *     // Declare a set state variable
769  *     EnumerableSet.AddressSet private mySet;
770  * }
771  * ```
772  *
773  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
774  * and `uint256` (`UintSet`) are supported.
775  */
776 library EnumerableSet {
777     // To implement this library for multiple types with as little code
778     // repetition as possible, we write it in terms of a generic Set type with
779     // bytes32 values.
780     // The Set implementation uses private functions, and user-facing
781     // implementations (such as AddressSet) are just wrappers around the
782     // underlying Set.
783     // This means that we can only create new EnumerableSets for types that fit
784     // in bytes32.
785 
786     struct Set {
787         // Storage of set values
788         bytes32[] _values;
789 
790         // Position of the value in the `values` array, plus 1 because index 0
791         // means a value is not in the set.
792         mapping (bytes32 => uint256) _indexes;
793     }
794 
795     /**
796      * @dev Add a value to a set. O(1).
797      *
798      * Returns true if the value was added to the set, that is if it was not
799      * already present.
800      */
801     function _add(Set storage set, bytes32 value) private returns (bool) {
802         if (!_contains(set, value)) {
803             set._values.push(value);
804             // The value is stored at length-1, but we add 1 to all indexes
805             // and use 0 as a sentinel value
806             set._indexes[value] = set._values.length;
807             return true;
808         } else {
809             return false;
810         }
811     }
812 
813     /**
814      * @dev Removes a value from a set. O(1).
815      *
816      * Returns true if the value was removed from the set, that is if it was
817      * present.
818      */
819     function _remove(Set storage set, bytes32 value) private returns (bool) {
820         // We read and store the value's index to prevent multiple reads from the same storage slot
821         uint256 valueIndex = set._indexes[value];
822 
823         if (valueIndex != 0) { // Equivalent to contains(set, value)
824             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
825             // the array, and then remove the last element (sometimes called as 'swap and pop').
826             // This modifies the order of the array, as noted in {at}.
827 
828             uint256 toDeleteIndex = valueIndex - 1;
829             uint256 lastIndex = set._values.length - 1;
830 
831             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
832             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
833 
834             bytes32 lastvalue = set._values[lastIndex];
835 
836             // Move the last value to the index where the value to delete is
837             set._values[toDeleteIndex] = lastvalue;
838             // Update the index for the moved value
839             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
840 
841             // Delete the slot where the moved value was stored
842             set._values.pop();
843 
844             // Delete the index for the deleted slot
845             delete set._indexes[value];
846 
847             return true;
848         } else {
849             return false;
850         }
851     }
852 
853     /**
854      * @dev Returns true if the value is in the set. O(1).
855      */
856     function _contains(Set storage set, bytes32 value) private view returns (bool) {
857         return set._indexes[value] != 0;
858     }
859 
860     /**
861      * @dev Returns the number of values on the set. O(1).
862      */
863     function _length(Set storage set) private view returns (uint256) {
864         return set._values.length;
865     }
866 
867    /**
868     * @dev Returns the value stored at position `index` in the set. O(1).
869     *
870     * Note that there are no guarantees on the ordering of values inside the
871     * array, and it may change when more values are added or removed.
872     *
873     * Requirements:
874     *
875     * - `index` must be strictly less than {length}.
876     */
877     function _at(Set storage set, uint256 index) private view returns (bytes32) {
878         require(set._values.length > index, "EnumerableSet: index out of bounds");
879         return set._values[index];
880     }
881 
882     // Bytes32Set
883 
884     struct Bytes32Set {
885         Set _inner;
886     }
887 
888     /**
889      * @dev Add a value to a set. O(1).
890      *
891      * Returns true if the value was added to the set, that is if it was not
892      * already present.
893      */
894     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
895         return _add(set._inner, value);
896     }
897 
898     /**
899      * @dev Removes a value from a set. O(1).
900      *
901      * Returns true if the value was removed from the set, that is if it was
902      * present.
903      */
904     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
905         return _remove(set._inner, value);
906     }
907 
908     /**
909      * @dev Returns true if the value is in the set. O(1).
910      */
911     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
912         return _contains(set._inner, value);
913     }
914 
915     /**
916      * @dev Returns the number of values in the set. O(1).
917      */
918     function length(Bytes32Set storage set) internal view returns (uint256) {
919         return _length(set._inner);
920     }
921 
922    /**
923     * @dev Returns the value stored at position `index` in the set. O(1).
924     *
925     * Note that there are no guarantees on the ordering of values inside the
926     * array, and it may change when more values are added or removed.
927     *
928     * Requirements:
929     *
930     * - `index` must be strictly less than {length}.
931     */
932     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
933         return _at(set._inner, index);
934     }
935 
936     // AddressSet
937 
938     struct AddressSet {
939         Set _inner;
940     }
941 
942     /**
943      * @dev Add a value to a set. O(1).
944      *
945      * Returns true if the value was added to the set, that is if it was not
946      * already present.
947      */
948     function add(AddressSet storage set, address value) internal returns (bool) {
949         return _add(set._inner, bytes32(uint256(uint160(value))));
950     }
951 
952     /**
953      * @dev Removes a value from a set. O(1).
954      *
955      * Returns true if the value was removed from the set, that is if it was
956      * present.
957      */
958     function remove(AddressSet storage set, address value) internal returns (bool) {
959         return _remove(set._inner, bytes32(uint256(uint160(value))));
960     }
961 
962     /**
963      * @dev Returns true if the value is in the set. O(1).
964      */
965     function contains(AddressSet storage set, address value) internal view returns (bool) {
966         return _contains(set._inner, bytes32(uint256(uint160(value))));
967     }
968 
969     /**
970      * @dev Returns the number of values in the set. O(1).
971      */
972     function length(AddressSet storage set) internal view returns (uint256) {
973         return _length(set._inner);
974     }
975 
976    /**
977     * @dev Returns the value stored at position `index` in the set. O(1).
978     *
979     * Note that there are no guarantees on the ordering of values inside the
980     * array, and it may change when more values are added or removed.
981     *
982     * Requirements:
983     *
984     * - `index` must be strictly less than {length}.
985     */
986     function at(AddressSet storage set, uint256 index) internal view returns (address) {
987         return address(uint160(uint256(_at(set._inner, index))));
988     }
989 
990 
991     // UintSet
992 
993     struct UintSet {
994         Set _inner;
995     }
996 
997     /**
998      * @dev Add a value to a set. O(1).
999      *
1000      * Returns true if the value was added to the set, that is if it was not
1001      * already present.
1002      */
1003     function add(UintSet storage set, uint256 value) internal returns (bool) {
1004         return _add(set._inner, bytes32(value));
1005     }
1006 
1007     /**
1008      * @dev Removes a value from a set. O(1).
1009      *
1010      * Returns true if the value was removed from the set, that is if it was
1011      * present.
1012      */
1013     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1014         return _remove(set._inner, bytes32(value));
1015     }
1016 
1017     /**
1018      * @dev Returns true if the value is in the set. O(1).
1019      */
1020     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1021         return _contains(set._inner, bytes32(value));
1022     }
1023 
1024     /**
1025      * @dev Returns the number of values on the set. O(1).
1026      */
1027     function length(UintSet storage set) internal view returns (uint256) {
1028         return _length(set._inner);
1029     }
1030 
1031    /**
1032     * @dev Returns the value stored at position `index` in the set. O(1).
1033     *
1034     * Note that there are no guarantees on the ordering of values inside the
1035     * array, and it may change when more values are added or removed.
1036     *
1037     * Requirements:
1038     *
1039     * - `index` must be strictly less than {length}.
1040     */
1041     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1042         return uint256(_at(set._inner, index));
1043     }
1044 }
1045 
1046 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1047 
1048 // spd-License-Identifier: MIT
1049 
1050 pragma solidity >=0.6.0 <0.8.0;
1051 
1052 /**
1053  * @dev Library for managing an enumerable variant of Solidity's
1054  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1055  * type.
1056  *
1057  * Maps have the following properties:
1058  *
1059  * - Entries are added, removed, and checked for existence in constant time
1060  * (O(1)).
1061  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1062  *
1063  * ```
1064  * contract Example {
1065  *     // Add the library methods
1066  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1067  *
1068  *     // Declare a set state variable
1069  *     EnumerableMap.UintToAddressMap private myMap;
1070  * }
1071  * ```
1072  *
1073  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1074  * supported.
1075  */
1076 library EnumerableMap {
1077     // To implement this library for multiple types with as little code
1078     // repetition as possible, we write it in terms of a generic Map type with
1079     // bytes32 keys and values.
1080     // The Map implementation uses private functions, and user-facing
1081     // implementations (such as Uint256ToAddressMap) are just wrappers around
1082     // the underlying Map.
1083     // This means that we can only create new EnumerableMaps for types that fit
1084     // in bytes32.
1085 
1086     struct MapEntry {
1087         bytes32 _key;
1088         bytes32 _value;
1089     }
1090 
1091     struct Map {
1092         // Storage of map keys and values
1093         MapEntry[] _entries;
1094 
1095         // Position of the entry defined by a key in the `entries` array, plus 1
1096         // because index 0 means a key is not in the map.
1097         mapping (bytes32 => uint256) _indexes;
1098     }
1099 
1100     /**
1101      * @dev Adds a key-value pair to a map, or updates the value for an existing
1102      * key. O(1).
1103      *
1104      * Returns true if the key was added to the map, that is if it was not
1105      * already present.
1106      */
1107     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1108         // We read and store the key's index to prevent multiple reads from the same storage slot
1109         uint256 keyIndex = map._indexes[key];
1110 
1111         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1112             map._entries.push(MapEntry({ _key: key, _value: value }));
1113             // The entry is stored at length-1, but we add 1 to all indexes
1114             // and use 0 as a sentinel value
1115             map._indexes[key] = map._entries.length;
1116             return true;
1117         } else {
1118             map._entries[keyIndex - 1]._value = value;
1119             return false;
1120         }
1121     }
1122 
1123     /**
1124      * @dev Removes a key-value pair from a map. O(1).
1125      *
1126      * Returns true if the key was removed from the map, that is if it was present.
1127      */
1128     function _remove(Map storage map, bytes32 key) private returns (bool) {
1129         // We read and store the key's index to prevent multiple reads from the same storage slot
1130         uint256 keyIndex = map._indexes[key];
1131 
1132         if (keyIndex != 0) { // Equivalent to contains(map, key)
1133             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1134             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1135             // This modifies the order of the array, as noted in {at}.
1136 
1137             uint256 toDeleteIndex = keyIndex - 1;
1138             uint256 lastIndex = map._entries.length - 1;
1139 
1140             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1141             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1142 
1143             MapEntry storage lastEntry = map._entries[lastIndex];
1144 
1145             // Move the last entry to the index where the entry to delete is
1146             map._entries[toDeleteIndex] = lastEntry;
1147             // Update the index for the moved entry
1148             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1149 
1150             // Delete the slot where the moved entry was stored
1151             map._entries.pop();
1152 
1153             // Delete the index for the deleted slot
1154             delete map._indexes[key];
1155 
1156             return true;
1157         } else {
1158             return false;
1159         }
1160     }
1161 
1162     /**
1163      * @dev Returns true if the key is in the map. O(1).
1164      */
1165     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1166         return map._indexes[key] != 0;
1167     }
1168 
1169     /**
1170      * @dev Returns the number of key-value pairs in the map. O(1).
1171      */
1172     function _length(Map storage map) private view returns (uint256) {
1173         return map._entries.length;
1174     }
1175 
1176    /**
1177     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1178     *
1179     * Note that there are no guarantees on the ordering of entries inside the
1180     * array, and it may change when more entries are added or removed.
1181     *
1182     * Requirements:
1183     *
1184     * - `index` must be strictly less than {length}.
1185     */
1186     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1187         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1188 
1189         MapEntry storage entry = map._entries[index];
1190         return (entry._key, entry._value);
1191     }
1192 
1193     /**
1194      * @dev Tries to returns the value associated with `key`.  O(1).
1195      * Does not revert if `key` is not in the map.
1196      */
1197     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1198         uint256 keyIndex = map._indexes[key];
1199         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1200         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1201     }
1202 
1203     /**
1204      * @dev Returns the value associated with `key`.  O(1).
1205      *
1206      * Requirements:
1207      *
1208      * - `key` must be in the map.
1209      */
1210     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1211         uint256 keyIndex = map._indexes[key];
1212         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1213         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1214     }
1215 
1216     /**
1217      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1218      *
1219      * CAUTION: This function is deprecated because it requires allocating memory for the error
1220      * message unnecessarily. For custom revert reasons use {_tryGet}.
1221      */
1222     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1223         uint256 keyIndex = map._indexes[key];
1224         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1225         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1226     }
1227 
1228     // UintToAddressMap
1229 
1230     struct UintToAddressMap {
1231         Map _inner;
1232     }
1233 
1234     /**
1235      * @dev Adds a key-value pair to a map, or updates the value for an existing
1236      * key. O(1).
1237      *
1238      * Returns true if the key was added to the map, that is if it was not
1239      * already present.
1240      */
1241     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1242         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1243     }
1244 
1245     /**
1246      * @dev Removes a value from a set. O(1).
1247      *
1248      * Returns true if the key was removed from the map, that is if it was present.
1249      */
1250     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1251         return _remove(map._inner, bytes32(key));
1252     }
1253 
1254     /**
1255      * @dev Returns true if the key is in the map. O(1).
1256      */
1257     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1258         return _contains(map._inner, bytes32(key));
1259     }
1260 
1261     /**
1262      * @dev Returns the number of elements in the map. O(1).
1263      */
1264     function length(UintToAddressMap storage map) internal view returns (uint256) {
1265         return _length(map._inner);
1266     }
1267 
1268    /**
1269     * @dev Returns the element stored at position `index` in the set. O(1).
1270     * Note that there are no guarantees on the ordering of values inside the
1271     * array, and it may change when more values are added or removed.
1272     *
1273     * Requirements:
1274     *
1275     * - `index` must be strictly less than {length}.
1276     */
1277     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1278         (bytes32 key, bytes32 value) = _at(map._inner, index);
1279         return (uint256(key), address(uint160(uint256(value))));
1280     }
1281 
1282     /**
1283      * @dev Tries to returns the value associated with `key`.  O(1).
1284      * Does not revert if `key` is not in the map.
1285      *
1286      * _Available since v3.4._
1287      */
1288     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1289         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1290         return (success, address(uint160(uint256(value))));
1291     }
1292 
1293     /**
1294      * @dev Returns the value associated with `key`.  O(1).
1295      *
1296      * Requirements:
1297      *
1298      * - `key` must be in the map.
1299      */
1300     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1301         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1302     }
1303 
1304     /**
1305      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1306      *
1307      * CAUTION: This function is deprecated because it requires allocating memory for the error
1308      * message unnecessarily. For custom revert reasons use {tryGet}.
1309      */
1310     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1311         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1312     }
1313 }
1314 
1315 // File: @openzeppelin/contracts/utils/Strings.sol
1316 
1317 // spd-License-Identifier: MIT
1318 
1319 pragma solidity >=0.6.0 <0.8.0;
1320 
1321 /**
1322  * @dev String operations.
1323  */
1324 library Strings {
1325     /**
1326      * @dev Converts a `uint256` to its ASCII `string` representation.
1327      */
1328     function toString(uint256 value) internal pure returns (string memory) {
1329         // Inspired by OraclizeAPI's implementation - MIT licence
1330         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1331 
1332         if (value == 0) {
1333             return "0";
1334         }
1335         uint256 temp = value;
1336         uint256 digits;
1337         while (temp != 0) {
1338             digits++;
1339             temp /= 10;
1340         }
1341         bytes memory buffer = new bytes(digits);
1342         uint256 index = digits - 1;
1343         temp = value;
1344         while (temp != 0) {
1345             buffer[index--] = bytes1(uint8(48 + temp % 10));
1346             temp /= 10;
1347         }
1348         return string(buffer);
1349     }
1350 }
1351 
1352 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1353 
1354 // spd-License-Identifier: MIT
1355 
1356 pragma solidity >=0.6.0 <0.8.0;
1357 
1358 
1359 
1360 
1361 
1362 
1363 
1364 
1365 
1366 
1367 
1368 
1369 /**
1370  * @title ERC721 Non-Fungible Token Standard basic implementation
1371  * @dev see https://eips.ethereum.org/EIPS/eip-721
1372  */
1373 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1374     using SafeMath for uint256;
1375     using Address for address;
1376     using EnumerableSet for EnumerableSet.UintSet;
1377     using EnumerableMap for EnumerableMap.UintToAddressMap;
1378     using Strings for uint256;
1379 
1380     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1381     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1382     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1383 
1384     // Mapping from holder address to their (enumerable) set of owned tokens
1385     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1386 
1387     // Enumerable mapping from token ids to their owners
1388     EnumerableMap.UintToAddressMap private _tokenOwners;
1389 
1390     // Mapping from token ID to approved address
1391     mapping (uint256 => address) private _tokenApprovals;
1392 
1393     // Mapping from owner to operator approvals
1394     mapping (address => mapping (address => bool)) private _operatorApprovals;
1395 
1396     // Token name
1397     string private _name;
1398 
1399     // Token symbol
1400     string private _symbol;
1401 
1402     // Optional mapping for token URIs
1403     mapping (uint256 => string) private _tokenURIs;
1404 
1405     // Base URI
1406     string private _baseURI;
1407 
1408     /*
1409      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1410      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1411      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1412      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1413      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1414      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1415      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1416      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1417      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1418      *
1419      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1420      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1421      */
1422     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1423 
1424     /*
1425      *     bytes4(keccak256('name()')) == 0x06fdde03
1426      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1427      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1428      *
1429      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1430      */
1431     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1432 
1433     /*
1434      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1435      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1436      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1437      *
1438      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1439      */
1440     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1441 
1442     /**
1443      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1444      */
1445     constructor (string memory name_, string memory symbol_) public {
1446         _name = name_;
1447         _symbol = symbol_;
1448 
1449         // register the supported interfaces to conform to ERC721 via ERC165
1450         _registerInterface(_INTERFACE_ID_ERC721);
1451         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1452         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1453     }
1454 
1455     /**
1456      * @dev See {IERC721-balanceOf}.
1457      */
1458     function balanceOf(address owner) public view virtual override returns (uint256) {
1459         require(owner != address(0), "ERC721: balance query for the zero address");
1460         return _holderTokens[owner].length();
1461     }
1462 
1463     /**
1464      * @dev See {IERC721-ownerOf}.
1465      */
1466     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1467         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1468     }
1469 
1470     /**
1471      * @dev See {IERC721Metadata-name}.
1472      */
1473     function name() public view virtual override returns (string memory) {
1474         return _name;
1475     }
1476 
1477     /**
1478      * @dev See {IERC721Metadata-symbol}.
1479      */
1480     function symbol() public view virtual override returns (string memory) {
1481         return _symbol;
1482     }
1483 
1484     /**
1485      * @dev See {IERC721Metadata-tokenURI}.
1486      */
1487     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1488         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1489 
1490         string memory _tokenURI = _tokenURIs[tokenId];
1491         string memory base = baseURI();
1492 
1493         // If there is no base URI, return the token URI.
1494         if (bytes(base).length == 0) {
1495             return _tokenURI;
1496         }
1497         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1498         if (bytes(_tokenURI).length > 0) {
1499             return string(abi.encodePacked(base, _tokenURI));
1500         }
1501         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1502         return string(abi.encodePacked(base, tokenId.toString()));
1503     }
1504 
1505     /**
1506     * @dev Returns the base URI set via {_setBaseURI}. This will be
1507     * automatically added as a prefix in {tokenURI} to each token's URI, or
1508     * to the token ID if no specific URI is set for that token ID.
1509     */
1510     function baseURI() public view virtual returns (string memory) {
1511         return _baseURI;
1512     }
1513 
1514     /**
1515      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1516      */
1517     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1518         return _holderTokens[owner].at(index);
1519     }
1520 
1521     /**
1522      * @dev See {IERC721Enumerable-totalSupply}.
1523      */
1524     function totalSupply() public view virtual override returns (uint256) {
1525         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1526         return _tokenOwners.length();
1527     }
1528 
1529     /**
1530      * @dev See {IERC721Enumerable-tokenByIndex}.
1531      */
1532     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1533         (uint256 tokenId, ) = _tokenOwners.at(index);
1534         return tokenId;
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-approve}.
1539      */
1540     function approve(address to, uint256 tokenId) public virtual override {
1541         address owner = ERC721.ownerOf(tokenId);
1542         require(to != owner, "ERC721: approval to current owner");
1543 
1544         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1545             "ERC721: approve caller is not owner nor approved for all"
1546         );
1547 
1548         _approve(to, tokenId);
1549     }
1550 
1551     /**
1552      * @dev See {IERC721-getApproved}.
1553      */
1554     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1555         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1556 
1557         return _tokenApprovals[tokenId];
1558     }
1559 
1560     /**
1561      * @dev See {IERC721-setApprovalForAll}.
1562      */
1563     function setApprovalForAll(address operator, bool approved) public virtual override {
1564         require(operator != _msgSender(), "ERC721: approve to caller");
1565 
1566         _operatorApprovals[_msgSender()][operator] = approved;
1567         emit ApprovalForAll(_msgSender(), operator, approved);
1568     }
1569 
1570     /**
1571      * @dev See {IERC721-isApprovedForAll}.
1572      */
1573     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1574         return _operatorApprovals[owner][operator];
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-transferFrom}.
1579      */
1580     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1581         //solhint-disable-next-line max-line-length
1582         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1583 
1584         _transfer(from, to, tokenId);
1585     }
1586 
1587     /**
1588      * @dev See {IERC721-safeTransferFrom}.
1589      */
1590     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1591         safeTransferFrom(from, to, tokenId, "");
1592     }
1593 
1594     /**
1595      * @dev See {IERC721-safeTransferFrom}.
1596      */
1597     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1598         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1599         _safeTransfer(from, to, tokenId, _data);
1600     }
1601 
1602     /**
1603      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1604      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1605      *
1606      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1607      *
1608      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1609      * implement alternative mechanisms to perform token transfer, such as signature-based.
1610      *
1611      * Requirements:
1612      *
1613      * - `from` cannot be the zero address.
1614      * - `to` cannot be the zero address.
1615      * - `tokenId` token must exist and be owned by `from`.
1616      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1617      *
1618      * Emits a {Transfer} event.
1619      */
1620     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1621         _transfer(from, to, tokenId);
1622         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1623     }
1624 
1625     /**
1626      * @dev Returns whether `tokenId` exists.
1627      *
1628      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1629      *
1630      * Tokens start existing when they are minted (`_mint`),
1631      * and stop existing when they are burned (`_burn`).
1632      */
1633     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1634         return _tokenOwners.contains(tokenId);
1635     }
1636 
1637     /**
1638      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1639      *
1640      * Requirements:
1641      *
1642      * - `tokenId` must exist.
1643      */
1644     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1645         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1646         address owner = ERC721.ownerOf(tokenId);
1647         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1648     }
1649 
1650     /**
1651      * @dev Safely mints `tokenId` and transfers it to `to`.
1652      *
1653      * Requirements:
1654      d*
1655      * - `tokenId` must not exist.
1656      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1657      *
1658      * Emits a {Transfer} event.
1659      */
1660     function _safeMint(address to, uint256 tokenId) internal virtual {
1661         _safeMint(to, tokenId, "");
1662     }
1663 
1664     /**
1665      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1666      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1667      */
1668     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1669         _mint(to, tokenId);
1670         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1671     }
1672 
1673     /**
1674      * @dev Mints `tokenId` and transfers it to `to`.
1675      *
1676      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1677      *
1678      * Requirements:
1679      *
1680      * - `tokenId` must not exist.
1681      * - `to` cannot be the zero address.
1682      *
1683      * Emits a {Transfer} event.
1684      */
1685     function _mint(address to, uint256 tokenId) internal virtual {
1686         require(to != address(0), "ERC721: mint to the zero address");
1687         require(!_exists(tokenId), "ERC721: token already minted");
1688 
1689         _beforeTokenTransfer(address(0), to, tokenId);
1690 
1691         _holderTokens[to].add(tokenId);
1692 
1693         _tokenOwners.set(tokenId, to);
1694 
1695         emit Transfer(address(0), to, tokenId);
1696     }
1697 
1698     /**
1699      * @dev Destroys `tokenId`.
1700      * The approval is cleared when the token is burned.
1701      *
1702      * Requirements:
1703      *
1704      * - `tokenId` must exist.
1705      *
1706      * Emits a {Transfer} event.
1707      */
1708     function _burn(uint256 tokenId) internal virtual {
1709         address owner = ERC721.ownerOf(tokenId); // internal owner
1710 
1711         _beforeTokenTransfer(owner, address(0), tokenId);
1712 
1713         // Clear approvals
1714         _approve(address(0), tokenId);
1715 
1716         // Clear metadata (if any)
1717         if (bytes(_tokenURIs[tokenId]).length != 0) {
1718             delete _tokenURIs[tokenId];
1719         }
1720 
1721         _holderTokens[owner].remove(tokenId);
1722 
1723         _tokenOwners.remove(tokenId);
1724 
1725         emit Transfer(owner, address(0), tokenId);
1726     }
1727 
1728     /**
1729      * @dev Transfers `tokenId` from `from` to `to`.
1730      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1731      *
1732      * Requirements:
1733      *
1734      * - `to` cannot be the zero address.
1735      * - `tokenId` token must be owned by `from`.
1736      *
1737      * Emits a {Transfer} event.
1738      */
1739     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1740         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1741         require(to != address(0), "ERC721: transfer to the zero address");
1742 
1743         _beforeTokenTransfer(from, to, tokenId);
1744 
1745         // Clear approvals from the previous owner
1746         _approve(address(0), tokenId);
1747 
1748         _holderTokens[from].remove(tokenId);
1749         _holderTokens[to].add(tokenId);
1750 
1751         _tokenOwners.set(tokenId, to);
1752 
1753         emit Transfer(from, to, tokenId);
1754     }
1755 
1756     /**
1757      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1758      *
1759      * Requirements:
1760      *
1761      * - `tokenId` must exist.
1762      */
1763     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1764         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1765         _tokenURIs[tokenId] = _tokenURI;
1766     }
1767 
1768     /**
1769      * @dev Internal function to set the base URI for all token IDs. It is
1770      * automatically added as a prefix to the value returned in {tokenURI},
1771      * or to the token ID if {tokenURI} is empty.
1772      */
1773     function _setBaseURI(string memory baseURI_) internal virtual {
1774         _baseURI = baseURI_;
1775     }
1776 
1777     /**
1778      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1779      * The call is not executed if the target address is not a contract.
1780      *
1781      * @param from address representing the previous owner of the given token ID
1782      * @param to target address that will receive the tokens
1783      * @param tokenId uint256 ID of the token to be transferred
1784      * @param _data bytes optional data to send along with the call
1785      * @return bool whether the call correctly returned the expected magic value
1786      */
1787     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1788         private returns (bool)
1789     {
1790         if (!to.isContract()) {
1791             return true;
1792         }
1793         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1794             IERC721Receiver(to).onERC721Received.selector,
1795             _msgSender(),
1796             from,
1797             tokenId,
1798             _data
1799         ), "ERC721: transfer to non ERC721Receiver implementer");
1800         bytes4 retval = abi.decode(returndata, (bytes4));
1801         return (retval == _ERC721_RECEIVED);
1802     }
1803 
1804     /**
1805      * @dev Approve `to` to operate on `tokenId`
1806      *
1807      * Emits an {Approval} event.
1808      */
1809     function _approve(address to, uint256 tokenId) internal virtual {
1810         _tokenApprovals[tokenId] = to;
1811         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1812     }
1813 
1814     /**
1815      * @dev Hook that is called before any token transfer. This includes minting
1816      * and burning.
1817      *
1818      * Calling conditions:
1819      *
1820      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1821      * transferred to `to`.
1822      * - When `from` is zero, `tokenId` will be minted for `to`.
1823      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1824      * - `from` cannot be the zero address.
1825      * - `to` cannot be the zero address.
1826      *
1827      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1828      */
1829     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1830 }
1831 
1832 // File: @openzeppelin/contracts/token/ERC721/ERC721Burnable.sol
1833 
1834 // spd-License-Identifier: MIT
1835 
1836 pragma solidity >=0.6.0 <0.8.0;
1837 
1838 
1839 
1840 /**
1841  * @title ERC721 Burnable Token
1842  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1843  */
1844 abstract contract ERC721Burnable is Context, ERC721 {
1845     /**
1846      * @dev Burns `tokenId`. See {ERC721-_burn}.
1847      *
1848      * Requirements:
1849      *
1850      * - The caller must own `tokenId` or be an approved operator.
1851      */
1852     function burn(uint256 tokenId) public virtual {
1853         //solhint-disable-next-line max-line-length
1854         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1855         _burn(tokenId);
1856     }
1857 }
1858 
1859 // File: @openzeppelin/contracts/access/Ownable.sol
1860 
1861 // spd-License-Identifier: MIT
1862 
1863 pragma solidity >=0.6.0 <0.8.0;
1864 
1865 /**
1866  * @dev Contract module which provides a basic access control mechanism, where
1867  * there is an account (an owner) that can be granted exclusive access to
1868  * specific functions.
1869  *
1870  * By default, the owner account will be the one that deploys the contract. This
1871  * can later be changed with {transferOwnership}.
1872  *
1873  * This module is used through inheritance. It will make available the modifier
1874  * `onlyOwner`, which can be applied to your functions to restrict their use to
1875  * the owner.
1876  */
1877 abstract contract Ownable is Context {
1878     address private _owner;
1879 
1880     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1881 
1882     /**
1883      * @dev Initializes the contract setting the deployer as the initial owner.
1884      */
1885     constructor () internal {
1886         address msgSender = _msgSender();
1887         _owner = msgSender;
1888         emit OwnershipTransferred(address(0), msgSender);
1889     }
1890 
1891     /**
1892      * @dev Returns the address of the current owner.
1893      */
1894     function owner() public view virtual returns (address) {
1895         return _owner;
1896     }
1897 
1898     /**
1899      * @dev Throws if called by any account other than the owner.
1900      */
1901     modifier onlyOwner() {
1902         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1903         _;
1904     }
1905 
1906     /**
1907      * @dev Leaves the contract without owner. It will not be possible to call
1908      * `onlyOwner` functions anymore. Can only be called by the current owner.
1909      *
1910      * NOTE: Renouncing ownership will leave the contract without an owner,
1911      * thereby removing any functionality that is only available to the owner.
1912      */
1913     function renounceOwnership() public virtual onlyOwner {
1914         emit OwnershipTransferred(_owner, address(0));
1915         _owner = address(0);
1916     }
1917 
1918     /**
1919      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1920      * Can only be called by the current owner.
1921      */
1922     function transferOwnership(address newOwner) public virtual onlyOwner {
1923         require(newOwner != address(0), "Ownable: new owner is the zero address");
1924         emit OwnershipTransferred(_owner, newOwner);
1925         _owner = newOwner;
1926     }
1927 }
1928 
1929 // File: contracts/Nftnft.sol
1930 
1931 // spd-License-Identifier: AGPL-3.0-or-later
1932 
1933 pragma solidity ^0.6.8;
1934 
1935 
1936 
1937 
1938 contract Nftnft is ERC721, Ownable {
1939 
1940   address payable public mastermind = 0x4e2f98c96e2d595a83AFa35888C4af58Ac343E44;
1941   address apeThis = 0x3aaDA3e213aBf8529606924d8D1c55CbDc70Bf74;
1942   uint256 public numDegens;
1943   uint256 public numRugPullVictims;
1944   mapping(address => bool) public hasBeenRugged;
1945   mapping(address => mapping(uint256 => uint256)) public start;
1946   mapping(address => mapping(uint256 => uint256)) public end;
1947   mapping(uint256 => bool) public isValuelessGovToken;
1948 
1949   constructor() ERC721("NFTNFT", "NFTNFT") public {
1950     _mint(msg.sender, 1);
1951     _setBaseURI("https://xmons.herokuapp.com/nftnft/");
1952   }
1953 
1954   modifier degen() {
1955     mastermind.transfer(msg.value);
1956     if (msg.value >= 1 ether) {
1957       numDegens += 1;
1958       _mint(msg.sender, 696969696969696969699+numDegens);
1959     }
1960     _;
1961   }
1962 
1963   function yeet(address victim, uint256 perp, uint256 numBodies) public payable degen {
1964     IScam(victim).transferFrom(msg.sender, address(this), perp);
1965     start[victim][perp] = totalSupply() + 1;
1966     end[victim][perp] = totalSupply() + numBodies;
1967     for (uint256 i = start[victim][perp]; i <= end[victim][perp]; i++) {
1968       _mint(msg.sender, i);
1969     }
1970   }
1971 
1972   function assembleMecha(address blueprints, uint256 model) public payable degen {
1973     for (uint256 i = start[blueprints][model]; i <= end[blueprints][model]; i++) {
1974       require(ownerOf(i) == msg.sender, "Bigger robot");
1975       _burn(i);
1976     }
1977     IScam(blueprints).transferFrom(address(this), msg.sender, model);
1978   }
1979 
1980   function _fakeBondingCurve() internal view returns (uint256){
1981     uint256 i = totalSupply() % 6;
1982     uint256 p = 0;
1983     if (i == 1) {
1984       p = 1;
1985     }
1986     if (i == 2) {
1987       p = 2;
1988     }
1989     if (i == 3) {
1990       p = 3;
1991     }
1992     if (i == 4) {
1993       p = 2;
1994     }
1995     if (i == 5) {
1996       p = 1;
1997     }
1998     return p;
1999   }
2000 
2001   function getRugged() public payable degen {
2002     require(!hasBeenRugged[msg.sender], "Already rugged");
2003     hasBeenRugged[msg.sender] = true;
2004     numRugPullVictims += 1;
2005     if (numRugPullVictims > 1000) {
2006       require(msg.value > _fakeBondingCurve() * totalSupply() * 0.000001 ether, "pay up fren");
2007       mastermind.transfer(msg.value);
2008     }
2009     isValuelessGovToken[totalSupply()+1] = true;
2010     _mint(msg.sender, totalSupply() + 1);
2011   }
2012 
2013   // Modifies the tokenURI of a monster
2014   function setTokenURI(uint256 id, string memory uri) public onlyOwner {
2015     _setTokenURI(id, uri);
2016   }
2017 
2018   // Sets the base URI
2019   function setBaseURI(string memory uri) public onlyOwner {
2020     _setBaseURI(uri);
2021   }
2022 
2023   function isChad(uint256 id) public pure returns (bool) {
2024     return id > 696969696969696969699;
2025   }
2026 }