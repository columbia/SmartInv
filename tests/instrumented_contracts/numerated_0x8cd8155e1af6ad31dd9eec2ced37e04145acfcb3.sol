1 /**
2  *Submitted for verification at Etherscan.io on 2021-09-15
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-09-12
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2021-09-11
11 */
12 
13 // SPDX-License-Identifier: MIT
14  
15 // File: @openzeppelin/contracts/utils/Context.sol
16 
17 pragma solidity >=0.6.0 <0.8.0;
18 
19 /*
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with GSN meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 // File: @openzeppelin/contracts/introspection/IERC165.sol
41 
42 
43 
44 pragma solidity >=0.6.0 <0.8.0;
45 
46 /**
47  * @dev Interface of the ERC165 standard, as defined in the
48  * https://eips.ethereum.org/EIPS/eip-165[EIP].
49  *
50  * Implementers can declare support of contract interfaces, which can then be
51  * queried by others ({ERC165Checker}).
52  *
53  * For an implementation, see {ERC165}.
54  */
55 interface IERC165 {
56     /**
57      * @dev Returns true if this contract implements the interface defined by
58      * `interfaceId`. See the corresponding
59      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
60      * to learn more about how these ids are created.
61      *
62      * This function call must use less than 30 000 gas.
63      */
64     function supportsInterface(bytes4 interfaceId) external view returns (bool);
65 }
66 
67 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
68 
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
199 
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
228 
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
259 
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
283 
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
339 
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
556 
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
748 
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
1048 
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
1317 
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
1354 
1355 
1356 pragma solidity >=0.6.0 <0.8.0;
1357 
1358 /**
1359  * @title ERC721 Non-Fungible Token Standard basic implementation
1360  * @dev see https://eips.ethereum.org/EIPS/eip-721
1361  */
1362  
1363 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1364     using SafeMath for uint256;
1365     using Address for address;
1366     using EnumerableSet for EnumerableSet.UintSet;
1367     using EnumerableMap for EnumerableMap.UintToAddressMap;
1368     using Strings for uint256;
1369 
1370     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1371     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1372     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1373 
1374     // Mapping from holder address to their (enumerable) set of owned tokens
1375     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1376 
1377     // Enumerable mapping from token ids to their owners
1378     EnumerableMap.UintToAddressMap private _tokenOwners;
1379 
1380     // Mapping from token ID to approved address
1381     mapping (uint256 => address) private _tokenApprovals;
1382 
1383     // Mapping from owner to operator approvals
1384     mapping (address => mapping (address => bool)) private _operatorApprovals;
1385 
1386     // Token name
1387     string private _name;
1388 
1389     // Token symbol
1390     string private _symbol;
1391 
1392     // Optional mapping for token URIs
1393     mapping (uint256 => string) private _tokenURIs;
1394 
1395     // Base URI
1396     string private _baseURI;
1397 
1398     /*
1399      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1400      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1401      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1402      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1403      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1404      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1405      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1406      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1407      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1408      *
1409      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1410      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1411      */
1412     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1413 
1414     /*
1415      *     bytes4(keccak256('name()')) == 0x06fdde03
1416      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1417      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1418      *
1419      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1420      */
1421     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1422 
1423     /*
1424      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1425      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1426      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1427      *
1428      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1429      */
1430     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1431 
1432     /**
1433      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1434      */
1435     constructor (string memory name_, string memory symbol_) public {
1436         _name = name_;
1437         _symbol = symbol_;
1438 
1439         // register the supported interfaces to conform to ERC721 via ERC165
1440         _registerInterface(_INTERFACE_ID_ERC721);
1441         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1442         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1443     }
1444 
1445     /**
1446      * @dev See {IERC721-balanceOf}.
1447      */
1448     function balanceOf(address owner) public view virtual override returns (uint256) {
1449         require(owner != address(0), "ERC721: balance query for the zero address");
1450         return _holderTokens[owner].length();
1451     }
1452 
1453     /**
1454      * @dev See {IERC721-ownerOf}.
1455      */
1456     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1457         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1458     }
1459 
1460     /**
1461      * @dev See {IERC721Metadata-name}.
1462      */
1463     function name() public view virtual override returns (string memory) {
1464         return _name;
1465     }
1466 
1467     /**
1468      * @dev See {IERC721Metadata-symbol}.
1469      */
1470     function symbol() public view virtual override returns (string memory) {
1471         return _symbol;
1472     }
1473 
1474     /**
1475      * @dev See {IERC721Metadata-tokenURI}.
1476      */
1477     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1478         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1479 
1480         string memory _tokenURI = _tokenURIs[tokenId];
1481         string memory base = baseURI();
1482 
1483         // If there is no base URI, return the token URI.
1484         if (bytes(base).length == 0) {
1485             return _tokenURI;
1486         }
1487         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1488         if (bytes(_tokenURI).length > 0) {
1489             return string(abi.encodePacked(base, _tokenURI));
1490         }
1491         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1492         return string(abi.encodePacked(base, tokenId.toString()));
1493     }
1494 
1495     /**
1496     * @dev Returns the base URI set via {_setBaseURI}. This will be
1497     * automatically added as a prefix in {tokenURI} to each token's URI, or
1498     * to the token ID if no specific URI is set for that token ID.
1499     */
1500     function baseURI() public view virtual returns (string memory) {
1501         return _baseURI;
1502     }
1503 
1504     /**
1505      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1506      */
1507     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1508         return _holderTokens[owner].at(index);
1509     }
1510 
1511     /**
1512      * @dev See {IERC721Enumerable-totalSupply}.
1513      */
1514     function totalSupply() public view virtual override returns (uint256) {
1515         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1516         return _tokenOwners.length();
1517     }
1518 
1519     /**
1520      * @dev See {IERC721Enumerable-tokenByIndex}.
1521      */
1522     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1523         (uint256 tokenId, ) = _tokenOwners.at(index);
1524         return tokenId;
1525     }
1526 
1527     /**
1528      * @dev See {IERC721-approve}.
1529      */
1530     function approve(address to, uint256 tokenId) public virtual override {
1531         address owner = ERC721.ownerOf(tokenId);
1532         require(to != owner, "ERC721: approval to current owner");
1533 
1534         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1535             "ERC721: approve caller is not owner nor approved for all"
1536         );
1537 
1538         _approve(to, tokenId);
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-getApproved}.
1543      */
1544     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1545         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1546 
1547         return _tokenApprovals[tokenId];
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-setApprovalForAll}.
1552      */
1553     function setApprovalForAll(address operator, bool approved) public virtual override {
1554         require(operator != _msgSender(), "ERC721: approve to caller");
1555 
1556         _operatorApprovals[_msgSender()][operator] = approved;
1557         emit ApprovalForAll(_msgSender(), operator, approved);
1558     }
1559 
1560     /**
1561      * @dev See {IERC721-isApprovedForAll}.
1562      */
1563     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1564         return _operatorApprovals[owner][operator];
1565     }
1566 
1567     /**
1568      * @dev See {IERC721-transferFrom}.
1569      */
1570     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1571         //solhint-disable-next-line max-line-length
1572         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1573 
1574         _transfer(from, to, tokenId);
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-safeTransferFrom}.
1579      */
1580     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1581         safeTransferFrom(from, to, tokenId, "");
1582     }
1583 
1584     /**
1585      * @dev See {IERC721-safeTransferFrom}.
1586      */
1587     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1588         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1589         _safeTransfer(from, to, tokenId, _data);
1590     }
1591 
1592     /**
1593      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1594      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1595      *
1596      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1597      *
1598      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1599      * implement alternative mechanisms to perform token transfer, such as signature-based.
1600      *
1601      * Requirements:
1602      *
1603      * - `from` cannot be the zero address.
1604      * - `to` cannot be the zero address.
1605      * - `tokenId` token must exist and be owned by `from`.
1606      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1607      *
1608      * Emits a {Transfer} event.
1609      */
1610     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1611         _transfer(from, to, tokenId);
1612         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1613     }
1614 
1615     /**
1616      * @dev Returns whether `tokenId` exists.
1617      *
1618      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1619      *
1620      * Tokens start existing when they are minted (`_mint`),
1621      * and stop existing when they are burned (`_burn`).
1622      */
1623     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1624         return _tokenOwners.contains(tokenId);
1625     }
1626 
1627     /**
1628      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1629      *
1630      * Requirements:
1631      *
1632      * - `tokenId` must exist.
1633      */
1634     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1635         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1636         address owner = ERC721.ownerOf(tokenId);
1637         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1638     }
1639 
1640     /**
1641      * @dev Safely mints `tokenId` and transfers it to `to`.
1642      *
1643      * Requirements:
1644      d*
1645      * - `tokenId` must not exist.
1646      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1647      *
1648      * Emits a {Transfer} event.
1649      */
1650     function _safeMint(address to, uint256 tokenId) internal virtual {
1651         _safeMint(to, tokenId, "");
1652     }
1653 
1654     /**
1655      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1656      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1657      */
1658     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1659         _mint(to, tokenId);
1660         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1661     }
1662 
1663     /**
1664      * @dev Mints `tokenId` and transfers it to `to`.
1665      *
1666      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1667      *
1668      * Requirements:
1669      *
1670      * - `tokenId` must not exist.
1671      * - `to` cannot be the zero address.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function _mint(address to, uint256 tokenId) internal virtual {
1676         require(to != address(0), "ERC721: mint to the zero address");
1677         require(!_exists(tokenId), "ERC721: token already minted");
1678 
1679         _beforeTokenTransfer(address(0), to, tokenId);
1680 
1681         _holderTokens[to].add(tokenId);
1682 
1683         _tokenOwners.set(tokenId, to);
1684 
1685         emit Transfer(address(0), to, tokenId);
1686     }
1687 
1688     /**
1689      * @dev Destroys `tokenId`.
1690      * The approval is cleared when the token is burned.
1691      *
1692      * Requirements:
1693      *
1694      * - `tokenId` must exist.
1695      *
1696      * Emits a {Transfer} event.
1697      */
1698     function _burn(uint256 tokenId) internal virtual {
1699         address owner = ERC721.ownerOf(tokenId); // internal owner
1700 
1701         _beforeTokenTransfer(owner, address(0), tokenId);
1702 
1703         // Clear approvals
1704         _approve(address(0), tokenId);
1705 
1706         // Clear metadata (if any)
1707         if (bytes(_tokenURIs[tokenId]).length != 0) {
1708             delete _tokenURIs[tokenId];
1709         }
1710 
1711         _holderTokens[owner].remove(tokenId);
1712 
1713         _tokenOwners.remove(tokenId);
1714 
1715         emit Transfer(owner, address(0), tokenId);
1716     }
1717 
1718     /**
1719      * @dev Transfers `tokenId` from `from` to `to`.
1720      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1721      *
1722      * Requirements:
1723      *
1724      * - `to` cannot be the zero address.
1725      * - `tokenId` token must be owned by `from`.
1726      *
1727      * Emits a {Transfer} event.
1728      */
1729     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1730         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1731         require(to != address(0), "ERC721: transfer to the zero address");
1732 
1733         _beforeTokenTransfer(from, to, tokenId);
1734 
1735         // Clear approvals from the previous owner
1736         _approve(address(0), tokenId);
1737 
1738         _holderTokens[from].remove(tokenId);
1739         _holderTokens[to].add(tokenId);
1740 
1741         _tokenOwners.set(tokenId, to);
1742 
1743         emit Transfer(from, to, tokenId);
1744     }
1745 
1746     /**
1747      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1748      *
1749      * Requirements:
1750      *
1751      * - `tokenId` must exist.
1752      */
1753     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1754         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1755         _tokenURIs[tokenId] = _tokenURI;
1756     }
1757 
1758     /**
1759      * @dev Internal function to set the base URI for all token IDs. It is
1760      * automatically added as a prefix to the value returned in {tokenURI},
1761      * or to the token ID if {tokenURI} is empty.
1762      */
1763     function _setBaseURI(string memory baseURI_) internal virtual {
1764         _baseURI = baseURI_;
1765     }
1766 
1767     /**
1768      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1769      * The call is not executed if the target address is not a contract.
1770      *
1771      * @param from address representing the previous owner of the given token ID
1772      * @param to target address that will receive the tokens
1773      * @param tokenId uint256 ID of the token to be transferred
1774      * @param _data bytes optional data to send along with the call
1775      * @return bool whether the call correctly returned the expected magic value
1776      */
1777     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1778         private returns (bool)
1779     {
1780         if (!to.isContract()) {
1781             return true;
1782         }
1783         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1784             IERC721Receiver(to).onERC721Received.selector,
1785             _msgSender(),
1786             from,
1787             tokenId,
1788             _data
1789         ), "ERC721: transfer to non ERC721Receiver implementer");
1790         bytes4 retval = abi.decode(returndata, (bytes4));
1791         return (retval == _ERC721_RECEIVED);
1792     }
1793 
1794     /**
1795      * @dev Approve `to` to operate on `tokenId`
1796      *
1797      * Emits an {Approval} event.
1798      */
1799     function _approve(address to, uint256 tokenId) internal virtual {
1800         _tokenApprovals[tokenId] = to;
1801         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1802     }
1803 
1804     /**
1805      * @dev Hook that is called before any token transfer. This includes minting
1806      * and burning.
1807      *
1808      * Calling conditions:
1809      *
1810      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1811      * transferred to `to`.
1812      * - When `from` is zero, `tokenId` will be minted for `to`.
1813      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1814      * - `from` cannot be the zero address.
1815      * - `to` cannot be the zero address.
1816      *
1817      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1818      */
1819     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1820 }
1821 
1822 // File: @openzeppelin/contracts/access/Ownable.sol
1823 
1824 
1825 
1826 pragma solidity >=0.6.0 <0.8.0;
1827 
1828 /**
1829  * @dev Contract module which provides a basic access control mechanism, where
1830  * there is an account (an owner) that can be granted exclusive access to
1831  * specific functions.
1832  *
1833  * By default, the owner account will be the one that deploys the contract. This
1834  * can later be changed with {transferOwnership}.
1835  *
1836  * This module is used through inheritance. It will make available the modifier
1837  * `onlyOwner`, which can be applied to your functions to restrict their use to
1838  * the owner.
1839  */
1840 abstract contract Ownable is Context {
1841     address private _owner;
1842 
1843     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1844 
1845     /**
1846      * @dev Initializes the contract setting the deployer as the initial owner.
1847      */
1848     constructor () internal {
1849         address msgSender = _msgSender();
1850         _owner = msgSender;
1851         emit OwnershipTransferred(address(0), msgSender);
1852     }
1853 
1854     /**
1855      * @dev Returns the address of the current owner.
1856      */
1857     function owner() public view virtual returns (address) {
1858         return _owner;
1859     }
1860 
1861     /**
1862      * @dev Throws if called by any account other than the owner.
1863      */
1864     modifier onlyOwner() {
1865         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1866         _;
1867     }
1868 
1869     /**
1870      * @dev Leaves the contract without owner. It will not be possible to call
1871      * `onlyOwner` functions anymore. Can only be called by the current owner.
1872      *
1873      * NOTE: Renouncing ownership will leave the contract without an owner,
1874      * thereby removing any functionality that is only available to the owner.
1875      */
1876     function renounceOwnership() public virtual onlyOwner {
1877         emit OwnershipTransferred(_owner, address(0));
1878         _owner = address(0);
1879     }
1880 
1881     /**
1882      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1883      * Can only be called by the current owner.
1884      */
1885     function transferOwnership(address newOwner) public virtual onlyOwner {
1886         require(newOwner != address(0), "Ownable: new owner is the zero address");
1887         emit OwnershipTransferred(_owner, newOwner);
1888         _owner = newOwner;
1889     }
1890 }
1891 
1892 // @openzeppelin/contracts/cryptography/MerkleProof.sol
1893 
1894 pragma solidity >=0.6.0 <0.8.0;
1895 
1896 /**
1897  * @dev These functions deal with verification of Merkle Trees proofs.
1898  *
1899  * The proofs can be generated using the JavaScript library
1900  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1901  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1902  *
1903  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1904  */
1905 library MerkleProof {
1906     /**
1907      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1908      * defined by `root`. For this, a `proof` must be provided, containing
1909      * sibling hashes on the branch from the leaf to the root of the tree. Each
1910      * pair of leaves and each pair of pre-images are assumed to be sorted.
1911      */
1912     function verify(
1913         bytes32[] memory proof,
1914         bytes32 root,
1915         bytes32 leaf
1916     ) internal pure returns (bool) {
1917         bytes32 computedHash = leaf;
1918 
1919         for (uint256 i = 0; i < proof.length; i++) {
1920             bytes32 proofElement = proof[i];
1921 
1922             if (computedHash <= proofElement) {
1923                 // Hash(current computed hash + current element of the proof)
1924                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
1925             } else {
1926                 // Hash(current element of the proof + current computed hash)
1927                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
1928             }
1929         }
1930 
1931         // Check if the computed hash (root) is equal to the provided root
1932         return computedHash == root;
1933     }
1934 }
1935 
1936 pragma solidity ^0.7.0;
1937 pragma abicoder v2;
1938 
1939 contract cupcat is ERC721, Ownable {
1940     
1941     using SafeMath for uint256;
1942 
1943     string public CUPCAT_PROVENANCE = "";
1944     string public LICENSE_TEXT = ""; 
1945     bool licenseLocked = false; 
1946 
1947     address private owner_;
1948     bytes32 public merkleRoot;
1949 
1950     uint256 public constant cupcatPrice = 20000000000000000;
1951     uint public constant maxCupCatPurchase = 3;
1952     uint256 public constant MAX_CUPCAT = 5000;
1953     uint public cupcatReserve = 100;
1954 
1955     bool public saleIsActive = false;
1956     mapping(address => bool) private whitelisted_minters;
1957     mapping(address => uint) private max_mints_per_address;
1958     event WhitelistedMint(address minter);
1959     event MerkleRootUpdated(bytes32 new_merkle_root);
1960     
1961 
1962     constructor() ERC721("Cupcat NFT", "CUPCAT") { }
1963     
1964     function withdraw() public onlyOwner {
1965         uint balance = address(this).balance;
1966         msg.sender.transfer(balance);
1967     }
1968 
1969     function reserveCupcat(address _to, uint256 _reserveAmount) public onlyOwner {        
1970         uint supply = totalSupply();
1971         require(_reserveAmount > 0 && _reserveAmount <= cupcatReserve, "Not enough reserve");
1972         for (uint i = 0; i < _reserveAmount; i++) {
1973             _safeMint(_to, supply + i);
1974         }
1975         cupcatReserve = cupcatReserve.sub(_reserveAmount);
1976     }
1977 
1978 
1979     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1980         CUPCAT_PROVENANCE = provenanceHash;
1981     }
1982 
1983     function setBaseURI(string memory baseURI) public onlyOwner {
1984         _setBaseURI(baseURI);
1985     }
1986 
1987 
1988     function flipSaleState() public onlyOwner {
1989         saleIsActive = !saleIsActive;
1990     }
1991     
1992     
1993     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1994         uint256 tokenCount = balanceOf(_owner);
1995         if (tokenCount == 0) {
1996             // Return an empty array
1997             return new uint256[](0);
1998         } else {
1999             uint256[] memory result = new uint256[](tokenCount);
2000             uint256 index;
2001             for (index = 0; index < tokenCount; index++) {
2002                 result[index] = tokenOfOwnerByIndex(_owner, index);
2003             }
2004             return result;
2005         }
2006     }
2007     
2008     
2009     
2010      function mintCupCat(uint numberOfTokens) public payable {
2011         require(saleIsActive, "Sale must be active to mint Cupcat");
2012         require(!isContract(msg.sender), "Mint via contract not allowed");
2013         require(numberOfTokens > 0 && numberOfTokens <= maxCupCatPurchase, "Can only mint 3 tokens at a time");
2014         require(msg.value == cupcatPrice.mul(numberOfTokens), "Ether value sent is not correct");
2015         require(max_mints_per_address[msg.sender].add(numberOfTokens) <= 3,"Max 3 mints per wallet allowed");
2016         
2017         for(uint i = 0; i < numberOfTokens; i++) {
2018             if (totalSupply() < MAX_CUPCAT) {
2019                 _safeMint(msg.sender, totalSupply());
2020                 max_mints_per_address[msg.sender] = max_mints_per_address[msg.sender].add(1);
2021             } else {
2022                saleIsActive = !saleIsActive;
2023                 msg.sender.transfer(numberOfTokens.sub(i).mul(cupcatPrice));
2024                 break;
2025             }
2026         }
2027     }
2028    function isContract(address account) internal view returns (bool) {
2029         uint256 size;
2030         assembly {
2031             size := extcodesize(account)
2032         }
2033         return size > 0;
2034     } 
2035 
2036    
2037    // to set the merkle proof
2038     function updateMerkleRoot(bytes32 newmerkleRoot) external onlyOwner {
2039         merkleRoot = newmerkleRoot;
2040         emit MerkleRootUpdated(merkleRoot);
2041     }
2042 
2043 
2044     function whitelistedMints( bytes32[] calldata merkleProof ) payable external  {
2045         address user_ = msg.sender;
2046 
2047         require(msg.value == cupcatPrice,"Exactly 0.02 ETH is needed for mint" );
2048         require(totalSupply().add(1) <= MAX_CUPCAT, "Mint would exceed max supply of Cupcats");
2049         require(!whitelisted_minters[user_],"Already Claimed the whitelisted mint");
2050 
2051         // Verify the merkle proof
2052         require(MerkleProof.verify(merkleProof, merkleRoot,  keccak256(abi.encodePacked(user_))  ), "Invalid proof");
2053 
2054         // Mark it claimed
2055         whitelisted_minters[user_] = true;
2056 
2057         // Mint 1 CupCat NFT for the user
2058        _safeMint(user_, totalSupply());
2059 
2060         emit WhitelistedMint(user_);
2061     }
2062 }