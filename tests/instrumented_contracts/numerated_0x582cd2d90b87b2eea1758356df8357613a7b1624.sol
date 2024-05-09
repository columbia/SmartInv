1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/introspection/IERC165.sol
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Contract module that helps prevent reentrant calls to a function.
34  *
35  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
36  * available, which can be applied to functions to make sure there are no nested
37  * (reentrant) calls to them.
38  *
39  * Note that because there is a single `nonReentrant` guard, functions marked as
40  * `nonReentrant` may not call one another. This can be worked around by making
41  * those functions `private`, and then adding `external` `nonReentrant` entry
42  * points to them.
43  *
44  * TIP: If you would like to learn more about reentrancy and alternative ways
45  * to protect against it, check out our blog post
46  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
47  */
48 abstract contract ReentrancyGuard {
49     // Booleans are more expensive than uint256 or any type that takes up a full
50     // word because each write operation emits an extra SLOAD to first read the
51     // slot's contents, replace the bits taken up by the boolean, and then write
52     // back. This is the compiler's defense against contract upgrades and
53     // pointer aliasing, and it cannot be disabled.
54 
55     // The values being non-zero value makes deployment a bit more expensive,
56     // but in exchange the refund on every call to nonReentrant will be lower in
57     // amount. Since refunds are capped to a percentage of the total
58     // transaction's gas, it is best to keep them low in cases like this one, to
59     // increase the likelihood of the full refund coming into effect.
60     uint256 private constant _NOT_ENTERED = 1;
61     uint256 private constant _ENTERED = 2;
62 
63     uint256 private _status;
64 
65     constructor () internal {
66         _status = _NOT_ENTERED;
67     }
68 
69     /**
70      * @dev Prevents a contract from calling itself, directly or indirectly.
71      * Calling a `nonReentrant` function from another `nonReentrant`
72      * function is not supported. It is possible to prevent this from happening
73      * by making the `nonReentrant` function external, and make it call a
74      * `private` function that does the actual work.
75      */
76     modifier nonReentrant() {
77         // On the first call to nonReentrant, _notEntered will be true
78         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
79 
80         // Any calls to nonReentrant after this point will fail
81         _status = _ENTERED;
82 
83         _;
84 
85         // By storing the original value once again, a refund is triggered (see
86         // https://eips.ethereum.org/EIPS/eip-2200)
87         _status = _NOT_ENTERED;
88     }
89 }
90 
91 
92 pragma solidity >=0.6.0 <0.8.0;
93 
94 /**
95  * @dev Interface of the ERC165 standard, as defined in the
96  * https://eips.ethereum.org/EIPS/eip-165[EIP].
97  *
98  * Implementers can declare support of contract interfaces, which can then be
99  * queried by others ({ERC165Checker}).
100  *
101  * For an implementation, see {ERC165}.
102  */
103 interface IERC165 {
104     /**
105      * @dev Returns true if this contract implements the interface defined by
106      * `interfaceId`. See the corresponding
107      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
108      * to learn more about how these ids are created.
109      *
110      * This function call must use less than 30 000 gas.
111      */
112     function supportsInterface(bytes4 interfaceId) external view returns (bool);
113 }
114 
115 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
116 
117 pragma solidity >=0.6.2 <0.8.0;
118 
119 /**
120  * @dev Required interface of an ERC721 compliant contract.
121  */
122 interface IERC721 is IERC165 {
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
130      */
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
135      */
136     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
137 
138     /**
139      * @dev Returns the number of tokens in ``owner``'s account.
140      */
141     function balanceOf(address owner) external view returns (uint256 balance);
142 
143     /**
144      * @dev Returns the owner of the `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function ownerOf(uint256 tokenId) external view returns (address owner);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
154      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(address from, address to, uint256 tokenId) external;
167 
168     /**
169      * @dev Transfers `tokenId` token from `from` to `to`.
170      *
171      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must be owned by `from`.
178      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(address from, address to, uint256 tokenId) external;
183 
184     /**
185      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
186      * The approval is cleared when the token is transferred.
187      *
188      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
189      *
190      * Requirements:
191      *
192      * - The caller must own the token or be an approved operator.
193      * - `tokenId` must exist.
194      *
195      * Emits an {Approval} event.
196      */
197     function approve(address to, uint256 tokenId) external;
198 
199     /**
200      * @dev Returns the account approved for `tokenId` token.
201      *
202      * Requirements:
203      *
204      * - `tokenId` must exist.
205      */
206     function getApproved(uint256 tokenId) external view returns (address operator);
207 
208     /**
209      * @dev Approve or remove `operator` as an operator for the caller.
210      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
211      *
212      * Requirements:
213      *
214      * - The `operator` cannot be the caller.
215      *
216      * Emits an {ApprovalForAll} event.
217      */
218     function setApprovalForAll(address operator, bool _approved) external;
219 
220     /**
221      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
222      *
223      * See {setApprovalForAll}
224      */
225     function isApprovedForAll(address owner, address operator) external view returns (bool);
226 
227     /**
228       * @dev Safely transfers `tokenId` token from `from` to `to`.
229       *
230       * Requirements:
231       *
232       * - `from` cannot be the zero address.
233       * - `to` cannot be the zero address.
234       * - `tokenId` token must exist and be owned by `from`.
235       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
236       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
237       *
238       * Emits a {Transfer} event.
239       */
240     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
241 }
242 
243 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
244 
245 pragma solidity >=0.6.2 <0.8.0;
246 
247 /**
248  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
249  * @dev See https://eips.ethereum.org/EIPS/eip-721
250  */
251 interface IERC721Metadata is IERC721 {
252 
253     /**
254      * @dev Returns the token collection name.
255      */
256     function name() external view returns (string memory);
257 
258     /**
259      * @dev Returns the token collection symbol.
260      */
261     function symbol() external view returns (string memory);
262 
263     /**
264      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
265      */
266     function tokenURI(uint256 tokenId) external view returns (string memory);
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
270 
271 pragma solidity >=0.6.2 <0.8.0;
272 
273 /**
274  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
275  * @dev See https://eips.ethereum.org/EIPS/eip-721
276  */
277 interface IERC721Enumerable is IERC721 {
278 
279     /**
280      * @dev Returns the total amount of tokens stored by the contract.
281      */
282     function totalSupply() external view returns (uint256);
283 
284     /**
285      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
286      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
287      */
288     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
289 
290     /**
291      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
292      * Use along with {totalSupply} to enumerate all tokens.
293      */
294     function tokenByIndex(uint256 index) external view returns (uint256);
295 }
296 
297 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
298 
299 pragma solidity >=0.6.0 <0.8.0;
300 
301 /**
302  * @title ERC721 token receiver interface
303  * @dev Interface for any contract that wants to support safeTransfers
304  * from ERC721 asset contracts.
305  */
306 interface IERC721Receiver {
307     /**
308      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
309      * by `operator` from `from`, this function is called.
310      *
311      * It must return its Solidity selector to confirm the token transfer.
312      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
313      *
314      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
315      */
316     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
317 }
318 
319 // File: @openzeppelin/contracts/introspection/ERC165.sol
320 
321 pragma solidity >=0.6.0 <0.8.0;
322 
323 /**
324  * @dev Implementation of the {IERC165} interface.
325  *
326  * Contracts may inherit from this and call {_registerInterface} to declare
327  * their support of an interface.
328  */
329 abstract contract ERC165 is IERC165 {
330     /*
331      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
332      */
333     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
334 
335     /**
336      * @dev Mapping of interface ids to whether or not it's supported.
337      */
338     mapping(bytes4 => bool) private _supportedInterfaces;
339 
340     constructor () internal {
341         // Derived contracts need only register support for their own interfaces,
342         // we register support for ERC165 itself here
343         _registerInterface(_INTERFACE_ID_ERC165);
344     }
345 
346     /**
347      * @dev See {IERC165-supportsInterface}.
348      *
349      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
352         return _supportedInterfaces[interfaceId];
353     }
354 
355     /**
356      * @dev Registers the contract as an implementer of the interface defined by
357      * `interfaceId`. Support of the actual ERC165 interface is automatic and
358      * registering its interface id is not required.
359      *
360      * See {IERC165-supportsInterface}.
361      *
362      * Requirements:
363      *
364      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
365      */
366     function _registerInterface(bytes4 interfaceId) internal virtual {
367         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
368         _supportedInterfaces[interfaceId] = true;
369     }
370 }
371 
372 // File: @openzeppelin/contracts/math/SafeMath.sol
373 
374 pragma solidity >=0.6.0 <0.8.0;
375 
376 /**
377  * @dev Wrappers over Solidity's arithmetic operations with added overflow
378  * checks.
379  *
380  * Arithmetic operations in Solidity wrap on overflow. This can easily result
381  * in bugs, because programmers usually assume that an overflow raises an
382  * error, which is the standard behavior in high level programming languages.
383  * `SafeMath` restores this intuition by reverting the transaction when an
384  * operation overflows.
385  *
386  * Using this library instead of the unchecked operations eliminates an entire
387  * class of bugs, so it's recommended to use it always.
388  */
389 library SafeMath {
390     /**
391      * @dev Returns the addition of two unsigned integers, with an overflow flag.
392      *
393      * _Available since v3.4._
394      */
395     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
396         uint256 c = a + b;
397         if (c < a) return (false, 0);
398         return (true, c);
399     }
400 
401     /**
402      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
403      *
404      * _Available since v3.4._
405      */
406     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
407         if (b > a) return (false, 0);
408         return (true, a - b);
409     }
410 
411     /**
412      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
413      *
414      * _Available since v3.4._
415      */
416     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
417         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
418         // benefit is lost if 'b' is also tested.
419         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
420         if (a == 0) return (true, 0);
421         uint256 c = a * b;
422         if (c / a != b) return (false, 0);
423         return (true, c);
424     }
425 
426     /**
427      * @dev Returns the division of two unsigned integers, with a division by zero flag.
428      *
429      * _Available since v3.4._
430      */
431     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
432         if (b == 0) return (false, 0);
433         return (true, a / b);
434     }
435 
436     /**
437      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
438      *
439      * _Available since v3.4._
440      */
441     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
442         if (b == 0) return (false, 0);
443         return (true, a % b);
444     }
445 
446     /**
447      * @dev Returns the addition of two unsigned integers, reverting on
448      * overflow.
449      *
450      * Counterpart to Solidity's `+` operator.
451      *
452      * Requirements:
453      *
454      * - Addition cannot overflow.
455      */
456     function add(uint256 a, uint256 b) internal pure returns (uint256) {
457         uint256 c = a + b;
458         require(c >= a, "SafeMath: addition overflow");
459         return c;
460     }
461 
462     /**
463      * @dev Returns the subtraction of two unsigned integers, reverting on
464      * overflow (when the result is negative).
465      *
466      * Counterpart to Solidity's `-` operator.
467      *
468      * Requirements:
469      *
470      * - Subtraction cannot overflow.
471      */
472     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
473         require(b <= a, "SafeMath: subtraction overflow");
474         return a - b;
475     }
476 
477     /**
478      * @dev Returns the multiplication of two unsigned integers, reverting on
479      * overflow.
480      *
481      * Counterpart to Solidity's `*` operator.
482      *
483      * Requirements:
484      *
485      * - Multiplication cannot overflow.
486      */
487     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
488         if (a == 0) return 0;
489         uint256 c = a * b;
490         require(c / a == b, "SafeMath: multiplication overflow");
491         return c;
492     }
493 
494     /**
495      * @dev Returns the integer division of two unsigned integers, reverting on
496      * division by zero. The result is rounded towards zero.
497      *
498      * Counterpart to Solidity's `/` operator. Note: this function uses a
499      * `revert` opcode (which leaves remaining gas untouched) while Solidity
500      * uses an invalid opcode to revert (consuming all remaining gas).
501      *
502      * Requirements:
503      *
504      * - The divisor cannot be zero.
505      */
506     function div(uint256 a, uint256 b) internal pure returns (uint256) {
507         require(b > 0, "SafeMath: division by zero");
508         return a / b;
509     }
510 
511     /**
512      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
513      * reverting when dividing by zero.
514      *
515      * Counterpart to Solidity's `%` operator. This function uses a `revert`
516      * opcode (which leaves remaining gas untouched) while Solidity uses an
517      * invalid opcode to revert (consuming all remaining gas).
518      *
519      * Requirements:
520      *
521      * - The divisor cannot be zero.
522      */
523     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
524         require(b > 0, "SafeMath: modulo by zero");
525         return a % b;
526     }
527 
528     /**
529      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
530      * overflow (when the result is negative).
531      *
532      * CAUTION: This function is deprecated because it requires allocating memory for the error
533      * message unnecessarily. For custom revert reasons use {trySub}.
534      *
535      * Counterpart to Solidity's `-` operator.
536      *
537      * Requirements:
538      *
539      * - Subtraction cannot overflow.
540      */
541     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
542         require(b <= a, errorMessage);
543         return a - b;
544     }
545 
546     /**
547      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
548      * division by zero. The result is rounded towards zero.
549      *
550      * CAUTION: This function is deprecated because it requires allocating memory for the error
551      * message unnecessarily. For custom revert reasons use {tryDiv}.
552      *
553      * Counterpart to Solidity's `/` operator. Note: this function uses a
554      * `revert` opcode (which leaves remaining gas untouched) while Solidity
555      * uses an invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
562         require(b > 0, errorMessage);
563         return a / b;
564     }
565 
566     /**
567      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
568      * reverting with custom message when dividing by zero.
569      *
570      * CAUTION: This function is deprecated because it requires allocating memory for the error
571      * message unnecessarily. For custom revert reasons use {tryMod}.
572      *
573      * Counterpart to Solidity's `%` operator. This function uses a `revert`
574      * opcode (which leaves remaining gas untouched) while Solidity uses an
575      * invalid opcode to revert (consuming all remaining gas).
576      *
577      * Requirements:
578      *
579      * - The divisor cannot be zero.
580      */
581     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
582         require(b > 0, errorMessage);
583         return a % b;
584     }
585 }
586 
587 // File: @openzeppelin/contracts/utils/Address.sol
588 
589 pragma solidity >=0.6.2 <0.8.0;
590 
591 /**
592  * @dev Collection of functions related to the address type
593  */
594 library Address {
595     /**
596      * @dev Returns true if `account` is a contract.
597      *
598      * [IMPORTANT]
599      * ====
600      * It is unsafe to assume that an address for which this function returns
601      * false is an externally-owned account (EOA) and not a contract.
602      *
603      * Among others, `isContract` will return false for the following
604      * types of addresses:
605      *
606      *  - an externally-owned account
607      *  - a contract in construction
608      *  - an address where a contract will be created
609      *  - an address where a contract lived, but was destroyed
610      * ====
611      */
612     function isContract(address account) internal view returns (bool) {
613         // This method relies on extcodesize, which returns 0 for contracts in
614         // construction, since the code is only stored at the end of the
615         // constructor execution.
616 
617         uint256 size;
618         // solhint-disable-next-line no-inline-assembly
619         assembly { size := extcodesize(account) }
620         return size > 0;
621     }
622 
623     /**
624      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
625      * `recipient`, forwarding all available gas and reverting on errors.
626      *
627      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
628      * of certain opcodes, possibly making contracts go over the 2300 gas limit
629      * imposed by `transfer`, making them unable to receive funds via
630      * `transfer`. {sendValue} removes this limitation.
631      *
632      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
633      *
634      * IMPORTANT: because control is transferred to `recipient`, care must be
635      * taken to not create reentrancy vulnerabilities. Consider using
636      * {ReentrancyGuard} or the
637      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
638      */
639     function sendValue(address payable recipient, uint256 amount) internal {
640         require(address(this).balance >= amount, "Address: insufficient balance");
641 
642         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
643         (bool success, ) = recipient.call{ value: amount }("");
644         require(success, "Address: unable to send value, recipient may have reverted");
645     }
646 
647     /**
648      * @dev Performs a Solidity function call using a low level `call`. A
649      * plain`call` is an unsafe replacement for a function call: use this
650      * function instead.
651      *
652      * If `target` reverts with a revert reason, it is bubbled up by this
653      * function (like regular Solidity function calls).
654      *
655      * Returns the raw returned data. To convert to the expected return value,
656      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
657      *
658      * Requirements:
659      *
660      * - `target` must be a contract.
661      * - calling `target` with `data` must not revert.
662      *
663      * _Available since v3.1._
664      */
665     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
666       return functionCall(target, data, "Address: low-level call failed");
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
671      * `errorMessage` as a fallback revert reason when `target` reverts.
672      *
673      * _Available since v3.1._
674      */
675     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
676         return functionCallWithValue(target, data, 0, errorMessage);
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
681      * but also transferring `value` wei to `target`.
682      *
683      * Requirements:
684      *
685      * - the calling contract must have an ETH balance of at least `value`.
686      * - the called Solidity function must be `payable`.
687      *
688      * _Available since v3.1._
689      */
690     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
691         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
692     }
693 
694     /**
695      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
696      * with `errorMessage` as a fallback revert reason when `target` reverts.
697      *
698      * _Available since v3.1._
699      */
700     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
701         require(address(this).balance >= value, "Address: insufficient balance for call");
702         require(isContract(target), "Address: call to non-contract");
703 
704         // solhint-disable-next-line avoid-low-level-calls
705         (bool success, bytes memory returndata) = target.call{ value: value }(data);
706         return _verifyCallResult(success, returndata, errorMessage);
707     }
708 
709     /**
710      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
711      * but performing a static call.
712      *
713      * _Available since v3.3._
714      */
715     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
716         return functionStaticCall(target, data, "Address: low-level static call failed");
717     }
718 
719     /**
720      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
721      * but performing a static call.
722      *
723      * _Available since v3.3._
724      */
725     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
726         require(isContract(target), "Address: static call to non-contract");
727 
728         // solhint-disable-next-line avoid-low-level-calls
729         (bool success, bytes memory returndata) = target.staticcall(data);
730         return _verifyCallResult(success, returndata, errorMessage);
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
735      * but performing a delegate call.
736      *
737      * _Available since v3.4._
738      */
739     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
740         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
745      * but performing a delegate call.
746      *
747      * _Available since v3.4._
748      */
749     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
750         require(isContract(target), "Address: delegate call to non-contract");
751 
752         // solhint-disable-next-line avoid-low-level-calls
753         (bool success, bytes memory returndata) = target.delegatecall(data);
754         return _verifyCallResult(success, returndata, errorMessage);
755     }
756 
757     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
758         if (success) {
759             return returndata;
760         } else {
761             // Look for revert reason and bubble it up if present
762             if (returndata.length > 0) {
763                 // The easiest way to bubble the revert reason is using memory via assembly
764 
765                 // solhint-disable-next-line no-inline-assembly
766                 assembly {
767                     let returndata_size := mload(returndata)
768                     revert(add(32, returndata), returndata_size)
769                 }
770             } else {
771                 revert(errorMessage);
772             }
773         }
774     }
775 }
776 
777 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
778 
779 pragma solidity >=0.6.0 <0.8.0;
780 
781 /**
782  * @dev Library for managing
783  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
784  * types.
785  *
786  * Sets have the following properties:
787  *
788  * - Elements are added, removed, and checked for existence in constant time
789  * (O(1)).
790  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
791  *
792  * ```
793  * contract Example {
794  *     // Add the library methods
795  *     using EnumerableSet for EnumerableSet.AddressSet;
796  *
797  *     // Declare a set state variable
798  *     EnumerableSet.AddressSet private mySet;
799  * }
800  * ```
801  *
802  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
803  * and `uint256` (`UintSet`) are supported.
804  */
805 library EnumerableSet {
806     // To implement this library for multiple types with as little code
807     // repetition as possible, we write it in terms of a generic Set type with
808     // bytes32 values.
809     // The Set implementation uses private functions, and user-facing
810     // implementations (such as AddressSet) are just wrappers around the
811     // underlying Set.
812     // This means that we can only create new EnumerableSets for types that fit
813     // in bytes32.
814 
815     struct Set {
816         // Storage of set values
817         bytes32[] _values;
818 
819         // Position of the value in the `values` array, plus 1 because index 0
820         // means a value is not in the set.
821         mapping (bytes32 => uint256) _indexes;
822     }
823 
824     /**
825      * @dev Add a value to a set. O(1).
826      *
827      * Returns true if the value was added to the set, that is if it was not
828      * already present.
829      */
830     function _add(Set storage set, bytes32 value) private returns (bool) {
831         if (!_contains(set, value)) {
832             set._values.push(value);
833             // The value is stored at length-1, but we add 1 to all indexes
834             // and use 0 as a sentinel value
835             set._indexes[value] = set._values.length;
836             return true;
837         } else {
838             return false;
839         }
840     }
841 
842     /**
843      * @dev Removes a value from a set. O(1).
844      *
845      * Returns true if the value was removed from the set, that is if it was
846      * present.
847      */
848     function _remove(Set storage set, bytes32 value) private returns (bool) {
849         // We read and store the value's index to prevent multiple reads from the same storage slot
850         uint256 valueIndex = set._indexes[value];
851 
852         if (valueIndex != 0) { // Equivalent to contains(set, value)
853             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
854             // the array, and then remove the last element (sometimes called as 'swap and pop').
855             // This modifies the order of the array, as noted in {at}.
856 
857             uint256 toDeleteIndex = valueIndex - 1;
858             uint256 lastIndex = set._values.length - 1;
859 
860             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
861             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
862 
863             bytes32 lastvalue = set._values[lastIndex];
864 
865             // Move the last value to the index where the value to delete is
866             set._values[toDeleteIndex] = lastvalue;
867             // Update the index for the moved value
868             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
869 
870             // Delete the slot where the moved value was stored
871             set._values.pop();
872 
873             // Delete the index for the deleted slot
874             delete set._indexes[value];
875 
876             return true;
877         } else {
878             return false;
879         }
880     }
881 
882     /**
883      * @dev Returns true if the value is in the set. O(1).
884      */
885     function _contains(Set storage set, bytes32 value) private view returns (bool) {
886         return set._indexes[value] != 0;
887     }
888 
889     /**
890      * @dev Returns the number of values on the set. O(1).
891      */
892     function _length(Set storage set) private view returns (uint256) {
893         return set._values.length;
894     }
895 
896    /**
897     * @dev Returns the value stored at position `index` in the set. O(1).
898     *
899     * Note that there are no guarantees on the ordering of values inside the
900     * array, and it may change when more values are added or removed.
901     *
902     * Requirements:
903     *
904     * - `index` must be strictly less than {length}.
905     */
906     function _at(Set storage set, uint256 index) private view returns (bytes32) {
907         require(set._values.length > index, "EnumerableSet: index out of bounds");
908         return set._values[index];
909     }
910 
911     // Bytes32Set
912 
913     struct Bytes32Set {
914         Set _inner;
915     }
916 
917     /**
918      * @dev Add a value to a set. O(1).
919      *
920      * Returns true if the value was added to the set, that is if it was not
921      * already present.
922      */
923     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
924         return _add(set._inner, value);
925     }
926 
927     /**
928      * @dev Removes a value from a set. O(1).
929      *
930      * Returns true if the value was removed from the set, that is if it was
931      * present.
932      */
933     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
934         return _remove(set._inner, value);
935     }
936 
937     /**
938      * @dev Returns true if the value is in the set. O(1).
939      */
940     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
941         return _contains(set._inner, value);
942     }
943 
944     /**
945      * @dev Returns the number of values in the set. O(1).
946      */
947     function length(Bytes32Set storage set) internal view returns (uint256) {
948         return _length(set._inner);
949     }
950 
951    /**
952     * @dev Returns the value stored at position `index` in the set. O(1).
953     *
954     * Note that there are no guarantees on the ordering of values inside the
955     * array, and it may change when more values are added or removed.
956     *
957     * Requirements:
958     *
959     * - `index` must be strictly less than {length}.
960     */
961     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
962         return _at(set._inner, index);
963     }
964 
965     // AddressSet
966 
967     struct AddressSet {
968         Set _inner;
969     }
970 
971     /**
972      * @dev Add a value to a set. O(1).
973      *
974      * Returns true if the value was added to the set, that is if it was not
975      * already present.
976      */
977     function add(AddressSet storage set, address value) internal returns (bool) {
978         return _add(set._inner, bytes32(uint256(uint160(value))));
979     }
980 
981     /**
982      * @dev Removes a value from a set. O(1).
983      *
984      * Returns true if the value was removed from the set, that is if it was
985      * present.
986      */
987     function remove(AddressSet storage set, address value) internal returns (bool) {
988         return _remove(set._inner, bytes32(uint256(uint160(value))));
989     }
990 
991     /**
992      * @dev Returns true if the value is in the set. O(1).
993      */
994     function contains(AddressSet storage set, address value) internal view returns (bool) {
995         return _contains(set._inner, bytes32(uint256(uint160(value))));
996     }
997 
998     /**
999      * @dev Returns the number of values in the set. O(1).
1000      */
1001     function length(AddressSet storage set) internal view returns (uint256) {
1002         return _length(set._inner);
1003     }
1004 
1005    /**
1006     * @dev Returns the value stored at position `index` in the set. O(1).
1007     *
1008     * Note that there are no guarantees on the ordering of values inside the
1009     * array, and it may change when more values are added or removed.
1010     *
1011     * Requirements:
1012     *
1013     * - `index` must be strictly less than {length}.
1014     */
1015     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1016         return address(uint160(uint256(_at(set._inner, index))));
1017     }
1018 
1019 
1020     // UintSet
1021 
1022     struct UintSet {
1023         Set _inner;
1024     }
1025 
1026     /**
1027      * @dev Add a value to a set. O(1).
1028      *
1029      * Returns true if the value was added to the set, that is if it was not
1030      * already present.
1031      */
1032     function add(UintSet storage set, uint256 value) internal returns (bool) {
1033         return _add(set._inner, bytes32(value));
1034     }
1035 
1036     /**
1037      * @dev Removes a value from a set. O(1).
1038      *
1039      * Returns true if the value was removed from the set, that is if it was
1040      * present.
1041      */
1042     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1043         return _remove(set._inner, bytes32(value));
1044     }
1045 
1046     /**
1047      * @dev Returns true if the value is in the set. O(1).
1048      */
1049     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1050         return _contains(set._inner, bytes32(value));
1051     }
1052 
1053     /**
1054      * @dev Returns the number of values on the set. O(1).
1055      */
1056     function length(UintSet storage set) internal view returns (uint256) {
1057         return _length(set._inner);
1058     }
1059 
1060    /**
1061     * @dev Returns the value stored at position `index` in the set. O(1).
1062     *
1063     * Note that there are no guarantees on the ordering of values inside the
1064     * array, and it may change when more values are added or removed.
1065     *
1066     * Requirements:
1067     *
1068     * - `index` must be strictly less than {length}.
1069     */
1070     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1071         return uint256(_at(set._inner, index));
1072     }
1073 }
1074 
1075 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1076 
1077 pragma solidity >=0.6.0 <0.8.0;
1078 
1079 /**
1080  * @dev Library for managing an enumerable variant of Solidity's
1081  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1082  * type.
1083  *
1084  * Maps have the following properties:
1085  *
1086  * - Entries are added, removed, and checked for existence in constant time
1087  * (O(1)).
1088  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1089  *
1090  * ```
1091  * contract Example {
1092  *     // Add the library methods
1093  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1094  *
1095  *     // Declare a set state variable
1096  *     EnumerableMap.UintToAddressMap private myMap;
1097  * }
1098  * ```
1099  *
1100  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1101  * supported.
1102  */
1103 library EnumerableMap {
1104     // To implement this library for multiple types with as little code
1105     // repetition as possible, we write it in terms of a generic Map type with
1106     // bytes32 keys and values.
1107     // The Map implementation uses private functions, and user-facing
1108     // implementations (such as Uint256ToAddressMap) are just wrappers around
1109     // the underlying Map.
1110     // This means that we can only create new EnumerableMaps for types that fit
1111     // in bytes32.
1112 
1113     struct MapEntry {
1114         bytes32 _key;
1115         bytes32 _value;
1116     }
1117 
1118     struct Map {
1119         // Storage of map keys and values
1120         MapEntry[] _entries;
1121 
1122         // Position of the entry defined by a key in the `entries` array, plus 1
1123         // because index 0 means a key is not in the map.
1124         mapping (bytes32 => uint256) _indexes;
1125     }
1126 
1127     /**
1128      * @dev Adds a key-value pair to a map, or updates the value for an existing
1129      * key. O(1).
1130      *
1131      * Returns true if the key was added to the map, that is if it was not
1132      * already present.
1133      */
1134     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1135         // We read and store the key's index to prevent multiple reads from the same storage slot
1136         uint256 keyIndex = map._indexes[key];
1137 
1138         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1139             map._entries.push(MapEntry({ _key: key, _value: value }));
1140             // The entry is stored at length-1, but we add 1 to all indexes
1141             // and use 0 as a sentinel value
1142             map._indexes[key] = map._entries.length;
1143             return true;
1144         } else {
1145             map._entries[keyIndex - 1]._value = value;
1146             return false;
1147         }
1148     }
1149 
1150     /**
1151      * @dev Removes a key-value pair from a map. O(1).
1152      *
1153      * Returns true if the key was removed from the map, that is if it was present.
1154      */
1155     function _remove(Map storage map, bytes32 key) private returns (bool) {
1156         // We read and store the key's index to prevent multiple reads from the same storage slot
1157         uint256 keyIndex = map._indexes[key];
1158 
1159         if (keyIndex != 0) { // Equivalent to contains(map, key)
1160             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1161             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1162             // This modifies the order of the array, as noted in {at}.
1163 
1164             uint256 toDeleteIndex = keyIndex - 1;
1165             uint256 lastIndex = map._entries.length - 1;
1166 
1167             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1168             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1169 
1170             MapEntry storage lastEntry = map._entries[lastIndex];
1171 
1172             // Move the last entry to the index where the entry to delete is
1173             map._entries[toDeleteIndex] = lastEntry;
1174             // Update the index for the moved entry
1175             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1176 
1177             // Delete the slot where the moved entry was stored
1178             map._entries.pop();
1179 
1180             // Delete the index for the deleted slot
1181             delete map._indexes[key];
1182 
1183             return true;
1184         } else {
1185             return false;
1186         }
1187     }
1188 
1189     /**
1190      * @dev Returns true if the key is in the map. O(1).
1191      */
1192     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1193         return map._indexes[key] != 0;
1194     }
1195 
1196     /**
1197      * @dev Returns the number of key-value pairs in the map. O(1).
1198      */
1199     function _length(Map storage map) private view returns (uint256) {
1200         return map._entries.length;
1201     }
1202 
1203    /**
1204     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1205     *
1206     * Note that there are no guarantees on the ordering of entries inside the
1207     * array, and it may change when more entries are added or removed.
1208     *
1209     * Requirements:
1210     *
1211     * - `index` must be strictly less than {length}.
1212     */
1213     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1214         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1215 
1216         MapEntry storage entry = map._entries[index];
1217         return (entry._key, entry._value);
1218     }
1219 
1220     /**
1221      * @dev Tries to returns the value associated with `key`.  O(1).
1222      * Does not revert if `key` is not in the map.
1223      */
1224     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1225         uint256 keyIndex = map._indexes[key];
1226         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1227         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1228     }
1229 
1230     /**
1231      * @dev Returns the value associated with `key`.  O(1).
1232      *
1233      * Requirements:
1234      *
1235      * - `key` must be in the map.
1236      */
1237     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1238         uint256 keyIndex = map._indexes[key];
1239         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1240         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1241     }
1242 
1243     /**
1244      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1245      *
1246      * CAUTION: This function is deprecated because it requires allocating memory for the error
1247      * message unnecessarily. For custom revert reasons use {_tryGet}.
1248      */
1249     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1250         uint256 keyIndex = map._indexes[key];
1251         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1252         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1253     }
1254 
1255     // UintToAddressMap
1256 
1257     struct UintToAddressMap {
1258         Map _inner;
1259     }
1260 
1261     /**
1262      * @dev Adds a key-value pair to a map, or updates the value for an existing
1263      * key. O(1).
1264      *
1265      * Returns true if the key was added to the map, that is if it was not
1266      * already present.
1267      */
1268     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1269         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1270     }
1271 
1272     /**
1273      * @dev Removes a value from a set. O(1).
1274      *
1275      * Returns true if the key was removed from the map, that is if it was present.
1276      */
1277     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1278         return _remove(map._inner, bytes32(key));
1279     }
1280 
1281     /**
1282      * @dev Returns true if the key is in the map. O(1).
1283      */
1284     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1285         return _contains(map._inner, bytes32(key));
1286     }
1287 
1288     /**
1289      * @dev Returns the number of elements in the map. O(1).
1290      */
1291     function length(UintToAddressMap storage map) internal view returns (uint256) {
1292         return _length(map._inner);
1293     }
1294 
1295    /**
1296     * @dev Returns the element stored at position `index` in the set. O(1).
1297     * Note that there are no guarantees on the ordering of values inside the
1298     * array, and it may change when more values are added or removed.
1299     *
1300     * Requirements:
1301     *
1302     * - `index` must be strictly less than {length}.
1303     */
1304     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1305         (bytes32 key, bytes32 value) = _at(map._inner, index);
1306         return (uint256(key), address(uint160(uint256(value))));
1307     }
1308 
1309     /**
1310      * @dev Tries to returns the value associated with `key`.  O(1).
1311      * Does not revert if `key` is not in the map.
1312      *
1313      * _Available since v3.4._
1314      */
1315     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1316         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1317         return (success, address(uint160(uint256(value))));
1318     }
1319 
1320     /**
1321      * @dev Returns the value associated with `key`.  O(1).
1322      *
1323      * Requirements:
1324      *
1325      * - `key` must be in the map.
1326      */
1327     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1328         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1329     }
1330 
1331     /**
1332      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1333      *
1334      * CAUTION: This function is deprecated because it requires allocating memory for the error
1335      * message unnecessarily. For custom revert reasons use {tryGet}.
1336      */
1337     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1338         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1339     }
1340 }
1341 
1342 // File: @openzeppelin/contracts/utils/Strings.sol
1343 
1344 pragma solidity >=0.6.0 <0.8.0;
1345 
1346 /**
1347  * @dev String operations.
1348  */
1349 library Strings {
1350     /**
1351      * @dev Converts a `uint256` to its ASCII `string` representation.
1352      */
1353     function toString(uint256 value) internal pure returns (string memory) {
1354         // Inspired by OraclizeAPI's implementation - MIT licence
1355         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1356 
1357         if (value == 0) {
1358             return "0";
1359         }
1360         uint256 temp = value;
1361         uint256 digits;
1362         while (temp != 0) {
1363             digits++;
1364             temp /= 10;
1365         }
1366         bytes memory buffer = new bytes(digits);
1367         uint256 index = digits - 1;
1368         temp = value;
1369         while (temp != 0) {
1370             buffer[index--] = bytes1(uint8(48 + temp % 10));
1371             temp /= 10;
1372         }
1373         return string(buffer);
1374     }
1375 }
1376 
1377 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1378 
1379 pragma solidity >=0.6.0 <0.8.0;
1380 
1381 /**
1382  * @title ERC721 Non-Fungible Token Standard basic implementation
1383  * @dev see https://eips.ethereum.org/EIPS/eip-721
1384  */
1385  
1386 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1387     using SafeMath for uint256;
1388     using Address for address;
1389     using EnumerableSet for EnumerableSet.UintSet;
1390     using EnumerableMap for EnumerableMap.UintToAddressMap;
1391     using Strings for uint256;
1392 
1393     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1394     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1395     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1396 
1397     // Mapping from holder address to their (enumerable) set of owned tokens
1398     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1399 
1400     // Enumerable mapping from token ids to their owners
1401     EnumerableMap.UintToAddressMap private _tokenOwners;
1402 
1403     // Mapping from token ID to approved address
1404     mapping (uint256 => address) private _tokenApprovals;
1405 
1406     // Mapping from owner to operator approvals
1407     mapping (address => mapping (address => bool)) private _operatorApprovals;
1408 
1409     // Token name
1410     string private _name;
1411 
1412     // Token symbol
1413     string private _symbol;
1414 
1415     // Optional mapping for token URIs
1416     mapping (uint256 => string) private _tokenURIs;
1417 
1418     // Base URI
1419     string private _baseURI;
1420 
1421     /*
1422      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1423      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1424      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1425      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1426      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1427      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1428      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1429      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1430      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1431      *
1432      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1433      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1434      */
1435     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1436 
1437     /*
1438      *     bytes4(keccak256('name()')) == 0x06fdde03
1439      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1440      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1441      *
1442      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1443      */
1444     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1445 
1446     /*
1447      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1448      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1449      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1450      *
1451      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1452      */
1453     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1454 
1455     /**
1456      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1457      */
1458     constructor (string memory name_, string memory symbol_) public {
1459         _name = name_;
1460         _symbol = symbol_;
1461 
1462         // register the supported interfaces to conform to ERC721 via ERC165
1463         _registerInterface(_INTERFACE_ID_ERC721);
1464         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1465         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1466     }
1467 
1468     /**
1469      * @dev See {IERC721-balanceOf}.
1470      */
1471     function balanceOf(address owner) public view virtual override returns (uint256) {
1472         require(owner != address(0), "ERC721: balance query for the zero address");
1473         return _holderTokens[owner].length();
1474     }
1475 
1476     /**
1477      * @dev See {IERC721-ownerOf}.
1478      */
1479     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1480         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1481     }
1482 
1483     /**
1484      * @dev See {IERC721Metadata-name}.
1485      */
1486     function name() public view virtual override returns (string memory) {
1487         return _name;
1488     }
1489 
1490     /**
1491      * @dev See {IERC721Metadata-symbol}.
1492      */
1493     function symbol() public view virtual override returns (string memory) {
1494         return _symbol;
1495     }
1496 
1497     /**
1498      * @dev See {IERC721Metadata-tokenURI}.
1499      */
1500     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1501         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1502 
1503         string memory _tokenURI = _tokenURIs[tokenId];
1504         string memory base = baseURI();
1505 
1506         // If there is no base URI, return the token URI.
1507         if (bytes(base).length == 0) {
1508             return _tokenURI;
1509         }
1510         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1511         if (bytes(_tokenURI).length > 0) {
1512             return string(abi.encodePacked(base, _tokenURI));
1513         }
1514         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1515         return string(abi.encodePacked(base, tokenId.toString()));
1516     }
1517 
1518     /**
1519     * @dev Returns the base URI set via {_setBaseURI}. This will be
1520     * automatically added as a prefix in {tokenURI} to each token's URI, or
1521     * to the token ID if no specific URI is set for that token ID.
1522     */
1523     function baseURI() public view virtual returns (string memory) {
1524         return _baseURI;
1525     }
1526 
1527     /**
1528      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1529      */
1530     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1531         return _holderTokens[owner].at(index);
1532     }
1533 
1534     /**
1535      * @dev See {IERC721Enumerable-totalSupply}.
1536      */
1537     function totalSupply() public view virtual override returns (uint256) {
1538         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1539         return _tokenOwners.length();
1540     }
1541 
1542     /**
1543      * @dev See {IERC721Enumerable-tokenByIndex}.
1544      */
1545     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1546         (uint256 tokenId, ) = _tokenOwners.at(index);
1547         return tokenId;
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-approve}.
1552      */
1553     function approve(address to, uint256 tokenId) public virtual override {
1554         address owner = ERC721.ownerOf(tokenId);
1555         require(to != owner, "ERC721: approval to current owner");
1556 
1557         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1558             "ERC721: approve caller is not owner nor approved for all"
1559         );
1560 
1561         _approve(to, tokenId);
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-getApproved}.
1566      */
1567     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1568         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1569 
1570         return _tokenApprovals[tokenId];
1571     }
1572 
1573     /**
1574      * @dev See {IERC721-setApprovalForAll}.
1575      */
1576     function setApprovalForAll(address operator, bool approved) public virtual override {
1577         require(operator != _msgSender(), "ERC721: approve to caller");
1578 
1579         _operatorApprovals[_msgSender()][operator] = approved;
1580         emit ApprovalForAll(_msgSender(), operator, approved);
1581     }
1582 
1583     /**
1584      * @dev See {IERC721-isApprovedForAll}.
1585      */
1586     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1587         return _operatorApprovals[owner][operator];
1588     }
1589 
1590     /**
1591      * @dev See {IERC721-transferFrom}.
1592      */
1593     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1594         //solhint-disable-next-line max-line-length
1595         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1596 
1597         _transfer(from, to, tokenId);
1598     }
1599 
1600     /**
1601      * @dev See {IERC721-safeTransferFrom}.
1602      */
1603     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1604         safeTransferFrom(from, to, tokenId, "");
1605     }
1606 
1607     /**
1608      * @dev See {IERC721-safeTransferFrom}.
1609      */
1610     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1611         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1612         _safeTransfer(from, to, tokenId, _data);
1613     }
1614 
1615     /**
1616      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1617      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1618      *
1619      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1620      *
1621      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1622      * implement alternative mechanisms to perform token transfer, such as signature-based.
1623      *
1624      * Requirements:
1625      *
1626      * - `from` cannot be the zero address.
1627      * - `to` cannot be the zero address.
1628      * - `tokenId` token must exist and be owned by `from`.
1629      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1630      *
1631      * Emits a {Transfer} event.
1632      */
1633     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1634         _transfer(from, to, tokenId);
1635         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1636     }
1637 
1638     /**
1639      * @dev Returns whether `tokenId` exists.
1640      *
1641      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1642      *
1643      * Tokens start existing when they are minted (`_mint`),
1644      * and stop existing when they are burned (`_burn`).
1645      */
1646     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1647         return _tokenOwners.contains(tokenId);
1648     }
1649 
1650     /**
1651      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1652      *
1653      * Requirements:
1654      *
1655      * - `tokenId` must exist.
1656      */
1657     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1658         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1659         address owner = ERC721.ownerOf(tokenId);
1660         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1661     }
1662 
1663     /**
1664      * @dev Safely mints `tokenId` and transfers it to `to`.
1665      *
1666      * Requirements:
1667      d*
1668      * - `tokenId` must not exist.
1669      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1670      *
1671      * Emits a {Transfer} event.
1672      */
1673     function _safeMint(address to, uint256 tokenId) internal virtual {
1674         _safeMint(to, tokenId, "");
1675     }
1676 
1677     /**
1678      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1679      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1680      */
1681     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1682         _mint(to, tokenId);
1683         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1684     }
1685 
1686     /**
1687      * @dev Mints `tokenId` and transfers it to `to`.
1688      *
1689      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1690      *
1691      * Requirements:
1692      *
1693      * - `tokenId` must not exist.
1694      * - `to` cannot be the zero address.
1695      *
1696      * Emits a {Transfer} event.
1697      */
1698     function _mint(address to, uint256 tokenId) internal virtual {
1699         require(to != address(0), "ERC721: mint to the zero address");
1700         require(!_exists(tokenId), "ERC721: token already minted");
1701 
1702         _beforeTokenTransfer(address(0), to, tokenId);
1703 
1704         _holderTokens[to].add(tokenId);
1705 
1706         _tokenOwners.set(tokenId, to);
1707 
1708         emit Transfer(address(0), to, tokenId);
1709     }
1710 
1711     /**
1712      * @dev Destroys `tokenId`.
1713      * The approval is cleared when the token is burned.
1714      *
1715      * Requirements:
1716      *
1717      * - `tokenId` must exist.
1718      *
1719      * Emits a {Transfer} event.
1720      */
1721     function _burn(uint256 tokenId) internal virtual {
1722         address owner = ERC721.ownerOf(tokenId); // internal owner
1723 
1724         _beforeTokenTransfer(owner, address(0), tokenId);
1725 
1726         // Clear approvals
1727         _approve(address(0), tokenId);
1728 
1729         // Clear metadata (if any)
1730         if (bytes(_tokenURIs[tokenId]).length != 0) {
1731             delete _tokenURIs[tokenId];
1732         }
1733 
1734         _holderTokens[owner].remove(tokenId);
1735 
1736         _tokenOwners.remove(tokenId);
1737 
1738         emit Transfer(owner, address(0), tokenId);
1739     }
1740 
1741     /**
1742      * @dev Transfers `tokenId` from `from` to `to`.
1743      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1744      *
1745      * Requirements:
1746      *
1747      * - `to` cannot be the zero address.
1748      * - `tokenId` token must be owned by `from`.
1749      *
1750      * Emits a {Transfer} event.
1751      */
1752     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1753         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1754         require(to != address(0), "ERC721: transfer to the zero address");
1755 
1756         _beforeTokenTransfer(from, to, tokenId);
1757 
1758         // Clear approvals from the previous owner
1759         _approve(address(0), tokenId);
1760 
1761         _holderTokens[from].remove(tokenId);
1762         _holderTokens[to].add(tokenId);
1763 
1764         _tokenOwners.set(tokenId, to);
1765 
1766         emit Transfer(from, to, tokenId);
1767     }
1768 
1769     /**
1770      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1771      *
1772      * Requirements:
1773      *
1774      * - `tokenId` must exist.
1775      */
1776     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1777         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1778         _tokenURIs[tokenId] = _tokenURI;
1779     }
1780 
1781     /**
1782      * @dev Internal function to set the base URI for all token IDs. It is
1783      * automatically added as a prefix to the value returned in {tokenURI},
1784      * or to the token ID if {tokenURI} is empty.
1785      */
1786     function _setBaseURI(string memory baseURI_) internal virtual {
1787         _baseURI = baseURI_;
1788     }
1789 
1790     /**
1791      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1792      * The call is not executed if the target address is not a contract.
1793      *
1794      * @param from address representing the previous owner of the given token ID
1795      * @param to target address that will receive the tokens
1796      * @param tokenId uint256 ID of the token to be transferred
1797      * @param _data bytes optional data to send along with the call
1798      * @return bool whether the call correctly returned the expected magic value
1799      */
1800     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1801         private returns (bool)
1802     {
1803         if (!to.isContract()) {
1804             return true;
1805         }
1806         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1807             IERC721Receiver(to).onERC721Received.selector,
1808             _msgSender(),
1809             from,
1810             tokenId,
1811             _data
1812         ), "ERC721: transfer to non ERC721Receiver implementer");
1813         bytes4 retval = abi.decode(returndata, (bytes4));
1814         return (retval == _ERC721_RECEIVED);
1815     }
1816 
1817     /**
1818      * @dev Approve `to` to operate on `tokenId`
1819      *
1820      * Emits an {Approval} event.
1821      */
1822     function _approve(address to, uint256 tokenId) internal virtual {
1823         _tokenApprovals[tokenId] = to;
1824         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1825     }
1826 
1827     /**
1828      * @dev Hook that is called before any token transfer. This includes minting
1829      * and burning.
1830      *
1831      * Calling conditions:
1832      *
1833      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1834      * transferred to `to`.
1835      * - When `from` is zero, `tokenId` will be minted for `to`.
1836      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1837      * - `from` cannot be the zero address.
1838      * - `to` cannot be the zero address.
1839      *
1840      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1841      */
1842     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1843 }
1844 
1845 // File: @openzeppelin/contracts/access/Ownable.sol
1846 
1847 pragma solidity >=0.6.0 <0.8.0;
1848 
1849 /**
1850  * @dev Contract module which provides a basic access control mechanism, where
1851  * there is an account (an owner) that can be granted exclusive access to
1852  * specific functions.
1853  *
1854  * By default, the owner account will be the one that deploys the contract. This
1855  * can later be changed with {transferOwnership}.
1856  *
1857  * This module is used through inheritance. It will make available the modifier
1858  * `onlyOwner`, which can be applied to your functions to restrict their use to
1859  * the owner.
1860  */
1861 abstract contract Ownable is Context {
1862     address private _owner;
1863 
1864     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1865 
1866     /**
1867      * @dev Initializes the contract setting the deployer as the initial owner.
1868      */
1869     constructor () internal {
1870         address msgSender = _msgSender();
1871         _owner = msgSender;
1872         emit OwnershipTransferred(address(0), msgSender);
1873     }
1874 
1875     /**
1876      * @dev Returns the address of the current owner.
1877      */
1878     function owner() public view virtual returns (address) {
1879         return _owner;
1880     }
1881 
1882     /**
1883      * @dev Throws if called by any account other than the owner.
1884      */
1885     modifier onlyOwner() {
1886         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1887         _;
1888     }
1889 
1890     /**
1891      * @dev Leaves the contract without owner. It will not be possible to call
1892      * `onlyOwner` functions anymore. Can only be called by the current owner.
1893      *
1894      * NOTE: Renouncing ownership will leave the contract without an owner,
1895      * thereby removing any functionality that is only available to the owner.
1896      */
1897     function renounceOwnership() public virtual onlyOwner {
1898         emit OwnershipTransferred(_owner, address(0));
1899         _owner = address(0);
1900     }
1901 
1902     /**
1903      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1904      * Can only be called by the current owner.
1905      */
1906     function transferOwnership(address newOwner) public virtual onlyOwner {
1907         require(newOwner != address(0), "Ownable: new owner is the zero address");
1908         emit OwnershipTransferred(_owner, newOwner);
1909         _owner = newOwner;
1910     }
1911 }
1912 
1913 
1914 
1915 pragma solidity ^0.7.0;
1916 pragma abicoder v2;
1917 
1918 contract LilBabyDoodles is ERC721, Ownable, ReentrancyGuard {
1919     using SafeMath for uint256;
1920     
1921     bool public saleIsActive = false;
1922     string public FINAL_PROVENANCE = "";
1923     uint256 public constant tokenPrice = 30000000000000000;
1924     uint public constant maxTokenPurchase = 10;
1925     uint256 public constant MAX_TOKENS = 4444;
1926     mapping(address => uint256) private minted;
1927     
1928     
1929     constructor() ERC721("Lil Baby Doodles", "LBD") { }
1930     
1931     function withdraw() public onlyOwner {
1932         uint256 balance = address(this).balance;
1933         msg.sender.transfer(balance);
1934     }
1935 
1936     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1937         FINAL_PROVENANCE = provenanceHash;
1938     }
1939 
1940     function setBaseURI(string memory baseURI) public onlyOwner {
1941         _setBaseURI(baseURI);
1942     }
1943 
1944     function flipSaleState() public onlyOwner {
1945         saleIsActive = !saleIsActive;
1946     }
1947     
1948     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1949         uint256 tokenCount = balanceOf(_owner);
1950         if (tokenCount == 0) {
1951             // Return an empty array
1952             return new uint256[](0);
1953         } else {
1954             uint256[] memory result = new uint256[](tokenCount);
1955             uint256 index;
1956             for (index = 0; index < tokenCount; index++) {
1957                 result[index] = tokenOfOwnerByIndex(_owner, index);
1958             }
1959             return result;
1960         }
1961     }
1962     
1963     function remainingMint(address user) public view returns (uint256) {
1964       require(saleIsActive, "Sale isn't active");
1965       return maxTokenPurchase - minted[user];
1966     }
1967 
1968     function mintToken(uint numberOfTokens) public payable nonReentrant {
1969         require(saleIsActive, "Sale must be active to mint");
1970         require(numberOfTokens > 0 && numberOfTokens <= maxTokenPurchase, "Can only mint 10 tokens at a time");
1971         require(totalSupply().add(numberOfTokens) <= MAX_TOKENS, "Purchase would exceed max supply");
1972         require(msg.value >= tokenPrice.mul(numberOfTokens), "Ether value sent is not correct");
1973         
1974         for(uint i = 0; i < numberOfTokens; i++) {
1975             uint mintIndex = totalSupply();
1976             if (totalSupply() < MAX_TOKENS) {
1977                 _safeMint(msg.sender, mintIndex);
1978             }
1979         }
1980 
1981         minted[msg.sender] += numberOfTokens;
1982     }
1983      
1984     
1985 }