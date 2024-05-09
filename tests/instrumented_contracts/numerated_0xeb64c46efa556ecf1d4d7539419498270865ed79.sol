1 // SPDX-License-Identifier: MIT                                                                                            
2  
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are modev from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 /*
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with GSN meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract Context {
90     function _msgSender() internal view virtual returns (address payable) {
91         return msg.sender;
92     }
93 
94     function _msgData() internal view virtual returns (bytes memory) {
95         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts/introspection/IERC165.sol
101 pragma solidity >=0.6.0 <0.8.0;
102 
103 /**
104  * @dev Interface of the ERC165 standard, as defined in the
105  * https://eips.ethereum.org/EIPS/eip-165[EIP].
106  *
107  * Implementers can declare support of contract interfaces, which can then be
108  * queried by others ({ERC165Checker}).
109  *
110  * For an implementation, see {ERC165}.
111  */
112 interface IERC165 {
113     /**
114      * @dev Returns true if this contract implements the interface defined by
115      * `interfaceId`. See the corresponding
116      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
117      * to learn more about how these ids are created.
118      *
119      * This function call must use less than 30 000 gas.
120      */
121     function supportsInterface(bytes4 interfaceId) external view returns (bool);
122 }
123 
124 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
125 pragma solidity >=0.6.2 <0.8.0;
126 
127 /**
128  * @dev Required interface of an ERC721 compliant contract.
129  */
130 interface IERC721 is IERC165 {
131     /**
132      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
133      */
134     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
135 
136     /**
137      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
138      */
139     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
140 
141     /**
142      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
143      */
144     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
145 
146     /**
147      * @dev Returns the number of tokens in ``owner``'s account.
148      */
149     function balanceOf(address owner) external view returns (uint256 balance);
150 
151     /**
152      * @dev Returns the owner of the `tokenId` token.
153      *
154      * Requirements:
155      *
156      * - `tokenId` must exist.
157      */
158     function ownerOf(uint256 tokenId) external view returns (address owner);
159 
160     /**
161      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
162      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
163      *
164      * Requirements:
165      *
166      * - `from` cannot be the zero address.
167      * - `to` cannot be the zero address.
168      * - `tokenId` token must exist and be owned by `from`.
169      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
170      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
171      *
172      * Emits a {Transfer} event.
173      */
174     function safeTransferFrom(address from, address to, uint256 tokenId) external;
175 
176     /**
177      * @dev Transfers `tokenId` token from `from` to `to`.
178      *
179      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
180      *
181      * Requirements:
182      *
183      * - `from` cannot be the zero address.
184      * - `to` cannot be the zero address.
185      * - `tokenId` token must be owned by `from`.
186      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(address from, address to, uint256 tokenId) external;
191 
192     /**
193      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
194      * The approval is cleared when the token is transferred.
195      *
196      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
197      *
198      * Requirements:
199      *
200      * - The caller must own the token or be an approved operator.
201      * - `tokenId` must exist.
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address to, uint256 tokenId) external;
206 
207     /**
208      * @dev Returns the account approved for `tokenId` token.
209      *
210      * Requirements:
211      *
212      * - `tokenId` must exist.
213      */
214     function getApproved(uint256 tokenId) external view returns (address operator);
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
230      *
231      * See {setApprovalForAll}
232      */
233     function isApprovedForAll(address owner, address operator) external view returns (bool);
234 
235     /**
236       * @dev Safely transfers `tokenId` token from `from` to `to`.
237       *
238       * Requirements:
239       *
240       * - `from` cannot be the zero address.
241       * - `to` cannot be the zero address.
242       * - `tokenId` token must exist and be owned by `from`.
243       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245       *
246       * Emits a {Transfer} event.
247       */
248     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
249 }
250 
251 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
252 pragma solidity >=0.6.2 <0.8.0;
253 
254 /**
255  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
256  * @dev See https://eips.ethereum.org/EIPS/eip-721
257  */
258 interface IERC721Metadata is IERC721 {
259 
260     /**
261      * @dev Returns the token collection name.
262      */
263     function name() external view returns (string memory);
264 
265     /**
266      * @dev Returns the token collection symbol.
267      */
268     function symbol() external view returns (string memory);
269 
270     /**
271      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
272      */
273     function tokenURI(uint256 tokenId) external view returns (string memory);
274 }
275 
276 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
277 pragma solidity >=0.6.2 <0.8.0;
278 
279 /**
280  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
281  * @dev See https://eips.ethereum.org/EIPS/eip-721
282  */
283 interface IERC721Enumerable is IERC721 {
284 
285     /**
286      * @dev Returns the total amount of tokens stored by the contract.
287      */
288     function totalSupply() external view returns (uint256);
289 
290     /**
291      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
292      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
293      */
294     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
295 
296     /**
297      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
298      * Use along with {totalSupply} to enumerate all tokens.
299      */
300     function tokenByIndex(uint256 index) external view returns (uint256);
301 }
302 
303 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
304 pragma solidity >=0.6.0 <0.8.0;
305 
306 /**
307  * @title ERC721 token receiver interface
308  * @dev Interface for any contract that wants to support safeTransfers
309  * from ERC721 asset contracts.
310  */
311 interface IERC721Receiver {
312     /**
313      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
314      * by `operator` from `from`, this function is called.
315      *
316      * It must return its Solidity selector to confirm the token transfer.
317      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
318      *
319      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
320      */
321     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
322 }
323 
324 // File: @openzeppelin/contracts/introspection/ERC165.sol
325 pragma solidity >=0.6.0 <0.8.0;
326 
327 /**
328  * @dev Implementation of the {IERC165} interface.
329  *
330  * Contracts may inherit from this and call {_registerInterface} to declare
331  * their support of an interface.
332  */
333 abstract contract ERC165 is IERC165 {
334     /*
335      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
336      */
337     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
338 
339     /**
340      * @dev Mapping of interface ids to whether or not it's supported.
341      */
342     mapping(bytes4 => bool) private _supportedInterfaces;
343 
344     constructor () internal {
345         // Derived contracts need only register support for their own interfaces,
346         // we register support for ERC165 itself here
347         _registerInterface(_INTERFACE_ID_ERC165);
348     }
349 
350     /**
351      * @dev See {IERC165-supportsInterface}.
352      *
353      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
354      */
355     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
356         return _supportedInterfaces[interfaceId];
357     }
358 
359     /**
360      * @dev Registers the contract as an implementer of the interface defined by
361      * `interfaceId`. Support of the actual ERC165 interface is automatic and
362      * registering its interface id is not required.
363      *
364      * See {IERC165-supportsInterface}.
365      *
366      * Requirements:
367      *
368      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
369      */
370     function _registerInterface(bytes4 interfaceId) internal virtual {
371         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
372         _supportedInterfaces[interfaceId] = true;
373     }
374 }
375 
376 // File: @openzeppelin/contracts/math/SafeMath.sol
377 pragma solidity >=0.6.0 <0.8.0;
378 
379 /**
380  * @dev Wrappers over Solidity's arithmetic operations with added overflow
381  * checks.
382  *
383  * Arithmetic operations in Solidity wrap on overflow. This can easily result
384  * in bugs, because programmers usually assume that an overflow raises an
385  * error, which is the standard behavior in high level programming languages.
386  * `SafeMath` restores this intuition by reverting the transaction when an
387  * operation overflows.
388  *
389  * Using this library instead of the unchecked operations eliminates an entire
390  * class of bugs, so it's recommended to use it always.
391  */
392 library SafeMath {
393     /**
394      * @dev Returns the addition of two unsigned integers, with an overflow flag.
395      *
396      * _Available since v3.4._
397      */
398     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
399         uint256 c = a + b;
400         if (c < a) return (false, 0);
401         return (true, c);
402     }
403 
404     /**
405      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
406      *
407      * _Available since v3.4._
408      */
409     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
410         if (b > a) return (false, 0);
411         return (true, a - b);
412     }
413 
414     /**
415      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
416      *
417      * _Available since v3.4._
418      */
419     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
420         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
421         // benefit is lost if 'b' is also tested.
422         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
423         if (a == 0) return (true, 0);
424         uint256 c = a * b;
425         if (c / a != b) return (false, 0);
426         return (true, c);
427     }
428 
429     /**
430      * @dev Returns the division of two unsigned integers, with a division by zero flag.
431      *
432      * _Available since v3.4._
433      */
434     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
435         if (b == 0) return (false, 0);
436         return (true, a / b);
437     }
438 
439     /**
440      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
441      *
442      * _Available since v3.4._
443      */
444     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
445         if (b == 0) return (false, 0);
446         return (true, a % b);
447     }
448 
449     /**
450      * @dev Returns the addition of two unsigned integers, reverting on
451      * overflow.
452      *
453      * Counterpart to Solidity's `+` operator.
454      *
455      * Requirements:
456      *
457      * - Addition cannot overflow.
458      */
459     function add(uint256 a, uint256 b) internal pure returns (uint256) {
460         uint256 c = a + b;
461         require(c >= a, "SafeMath: addition overflow");
462         return c;
463     }
464 
465     /**
466      * @dev Returns the subtraction of two unsigned integers, reverting on
467      * overflow (when the result is negative).
468      *
469      * Counterpart to Solidity's `-` operator.
470      *
471      * Requirements:
472      *
473      * - Subtraction cannot overflow.
474      */
475     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
476         require(b <= a, "SafeMath: subtraction overflow");
477         return a - b;
478     }
479 
480     /**
481      * @dev Returns the multiplication of two unsigned integers, reverting on
482      * overflow.
483      *
484      * Counterpart to Solidity's `*` operator.
485      *
486      * Requirements:
487      *
488      * - Multiplication cannot overflow.
489      */
490     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
491         if (a == 0) return 0;
492         uint256 c = a * b;
493         require(c / a == b, "SafeMath: multiplication overflow");
494         return c;
495     }
496 
497     /**
498      * @dev Returns the integer division of two unsigned integers, reverting on
499      * division by zero. The result is rounded towards zero.
500      *
501      * Counterpart to Solidity's `/` operator. Note: this function uses a
502      * `revert` opcode (which leaves remaining gas untouched) while Solidity
503      * uses an invalid opcode to revert (consuming all remaining gas).
504      *
505      * Requirements:
506      *
507      * - The divisor cannot be zero.
508      */
509     function div(uint256 a, uint256 b) internal pure returns (uint256) {
510         require(b > 0, "SafeMath: division by zero");
511         return a / b;
512     }
513 
514     /**
515      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
516      * reverting when dividing by zero.
517      *
518      * Counterpart to Solidity's `%` operator. This function uses a `revert`
519      * opcode (which leaves remaining gas untouched) while Solidity uses an
520      * invalid opcode to revert (consuming all remaining gas).
521      *
522      * Requirements:
523      *
524      * - The divisor cannot be zero.
525      */
526     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
527         require(b > 0, "SafeMath: modulo by zero");
528         return a % b;
529     }
530 
531     /**
532      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
533      * overflow (when the result is negative).
534      *
535      * CAUTION: This function is deprecated because it requires allocating memory for the error
536      * message unnecessarily. For custom revert reasons use {trySub}.
537      *
538      * Counterpart to Solidity's `-` operator.
539      *
540      * Requirements:
541      *
542      * - Subtraction cannot overflow.
543      */
544     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
545         require(b <= a, errorMessage);
546         return a - b;
547     }
548 
549     /**
550      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
551      * division by zero. The result is rounded towards zero.
552      *
553      * CAUTION: This function is deprecated because it requires allocating memory for the error
554      * message unnecessarily. For custom revert reasons use {tryDiv}.
555      *
556      * Counterpart to Solidity's `/` operator. Note: this function uses a
557      * `revert` opcode (which leaves remaining gas untouched) while Solidity
558      * uses an invalid opcode to revert (consuming all remaining gas).
559      *
560      * Requirements:
561      *
562      * - The divisor cannot be zero.
563      */
564     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
565         require(b > 0, errorMessage);
566         return a / b;
567     }
568 
569     /**
570      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
571      * reverting with custom message when dividing by zero.
572      *
573      * CAUTION: This function is deprecated because it requires allocating memory for the error
574      * message unnecessarily. For custom revert reasons use {tryMod}.
575      *
576      * Counterpart to Solidity's `%` operator. This function uses a `revert`
577      * opcode (which leaves remaining gas untouched) while Solidity uses an
578      * invalid opcode to revert (consuming all remaining gas).
579      *
580      * Requirements:
581      *
582      * - The divisor cannot be zero.
583      */
584     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
585         require(b > 0, errorMessage);
586         return a % b;
587     }
588 }
589 
590 // File: @openzeppelin/contracts/utils/Address.sol
591 pragma solidity >=0.6.2 <0.8.0;
592 
593 /**
594  * @dev Collection of functions related to the address type
595  */
596 library Address {
597     /**
598      * @dev Returns true if `account` is a contract.
599      *
600      * [IMPORTANT]
601      * ====
602      * It is unsafe to assume that an address for which this function returns
603      * false is an externally-owned account (EOA) and not a contract.
604      *
605      * Among others, `isContract` will return false for the following
606      * types of addresses:
607      *
608      *  - an externally-owned account
609      *  - a contract in construction
610      *  - an address where a contract will be created
611      *  - an address where a contract lived, but was destroyed
612      * ====
613      */
614     function isContract(address account) internal view returns (bool) {
615         // This method relies on extcodesize, which returns 0 for contracts in
616         // construction, since the code is only stored at the end of the
617         // constructor execution.
618 
619         uint256 size;
620         // solhint-disable-next-line no-inline-assembly
621         assembly { size := extcodesize(account) }
622         return size > 0;
623     }
624 
625     /**
626      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
627      * `recipient`, forwarding all available gas and reverting on errors.
628      *
629      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
630      * of certain opcodes, possibly making contracts go over the 2300 gas limit
631      * imposed by `transfer`, making them unable to receive funds via
632      * `transfer`. {sendValue} removes this limitation.
633      *
634      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
635      *
636      * IMPORTANT: because control is transferred to `recipient`, care must be
637      * taken to not create reentrancy vulnerabilities. Consider using
638      * {ReentrancyGuard} or the
639      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
640      */
641     function sendValue(address payable recipient, uint256 amount) internal {
642         require(address(this).balance >= amount, "Address: insufficient balance");
643 
644         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
645         (bool success, ) = recipient.call{ value: amount }("");
646         require(success, "Address: unable to send value, recipient may have reverted");
647     }
648 
649     /**
650      * @dev Performs a Solidity function call using a low level `call`. A
651      * plain`call` is an unsafe replacement for a function call: use this
652      * function instead.
653      *
654      * If `target` reverts with a revert reason, it is bubbled up by this
655      * function (like regular Solidity function calls).
656      *
657      * Returns the raw returned data. To convert to the expected return value,
658      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
659      *
660      * Requirements:
661      *
662      * - `target` must be a contract.
663      * - calling `target` with `data` must not revert.
664      *
665      * _Available since v3.1._
666      */
667     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
668       return functionCall(target, data, "Address: low-level call failed");
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
673      * `errorMessage` as a fallback revert reason when `target` reverts.
674      *
675      * _Available since v3.1._
676      */
677     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
678         return functionCallWithValue(target, data, 0, errorMessage);
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
683      * but also transferring `value` wei to `target`.
684      *
685      * Requirements:
686      *
687      * - the calling contract must have an ETH balance of at least `value`.
688      * - the called Solidity function must be `payable`.
689      *
690      * _Available since v3.1._
691      */
692     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
693         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
698      * with `errorMessage` as a fallback revert reason when `target` reverts.
699      *
700      * _Available since v3.1._
701      */
702     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
703         require(address(this).balance >= value, "Address: insufficient balance for call");
704         require(isContract(target), "Address: call to non-contract");
705 
706         // solhint-disable-next-line avoid-low-level-calls
707         (bool success, bytes memory returndata) = target.call{ value: value }(data);
708         return _verifyCallResult(success, returndata, errorMessage);
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
727     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
728         require(isContract(target), "Address: static call to non-contract");
729 
730         // solhint-disable-next-line avoid-low-level-calls
731         (bool success, bytes memory returndata) = target.staticcall(data);
732         return _verifyCallResult(success, returndata, errorMessage);
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
737      * but performing a delegate call.
738      *
739      * _Available since v3.4._
740      */
741     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
742         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
747      * but performing a delegate call.
748      *
749      * _Available since v3.4._
750      */
751     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
752         require(isContract(target), "Address: delegate call to non-contract");
753 
754         // solhint-disable-next-line avoid-low-level-calls
755         (bool success, bytes memory returndata) = target.delegatecall(data);
756         return _verifyCallResult(success, returndata, errorMessage);
757     }
758 
759     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
760         if (success) {
761             return returndata;
762         } else {
763             // Look for revert reason and bubble it up if present
764             if (returndata.length > 0) {
765                 // The easiest way to bubble the revert reason is using memory via assembly
766 
767                 // solhint-disable-next-line no-inline-assembly
768                 assembly {
769                     let returndata_size := mload(returndata)
770                     revert(add(32, returndata), returndata_size)
771                 }
772             } else {
773                 revert(errorMessage);
774             }
775         }
776     }
777 }
778 
779 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
780 pragma solidity >=0.6.0 <0.8.0;
781 
782 /**
783  * @dev Library for managing
784  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
785  * types.
786  *
787  * Sets have the following properties:
788  *
789  * - Elements are added, removed, and checked for existence in constant time
790  * (O(1)).
791  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
792  *
793  * ```
794  * contract Example {
795  *     // Add the library methods
796  *     using EnumerableSet for EnumerableSet.AddressSet;
797  *
798  *     // Declare a set state variable
799  *     EnumerableSet.AddressSet private mySet;
800  * }
801  * ```
802  *
803  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
804  * and `uint256` (`UintSet`) are supported.
805  */
806 library EnumerableSet {
807     // To implement this library for multiple types with as little code
808     // repetition as possible, we write it in terms of a generic Set type with
809     // bytes32 values.
810     // The Set implementation uses private functions, and user-facing
811     // implementations (such as AddressSet) are just wrappers around the
812     // underlying Set.
813     // This means that we can only create new EnumerableSets for types that fit
814     // in bytes32.
815 
816     struct Set {
817         // Storage of set values
818         bytes32[] _values;
819 
820         // Position of the value in the `values` array, plus 1 because index 0
821         // means a value is not in the set.
822         mapping (bytes32 => uint256) _indexes;
823     }
824 
825     /**
826      * @dev Add a value to a set. O(1).
827      *
828      * Returns true if the value was added to the set, that is if it was not
829      * already present.
830      */
831     function _add(Set storage set, bytes32 value) private returns (bool) {
832         if (!_contains(set, value)) {
833             set._values.push(value);
834             // The value is stored at length-1, but we add 1 to all indexes
835             // and use 0 as a sentinel value
836             set._indexes[value] = set._values.length;
837             return true;
838         } else {
839             return false;
840         }
841     }
842 
843     /**
844      * @dev Removes a value from a set. O(1).
845      *
846      * Returns true if the value was removed from the set, that is if it was
847      * present.
848      */
849     function _remove(Set storage set, bytes32 value) private returns (bool) {
850         // We read and store the value's index to prevent multiple reads from the same storage slot
851         uint256 valueIndex = set._indexes[value];
852 
853         if (valueIndex != 0) { // Equivalent to contains(set, value)
854             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
855             // the array, and then remove the last element (sometimes called as 'swap and pop').
856             // This modifies the order of the array, as noted in {at}.
857 
858             uint256 toDeleteIndex = valueIndex - 1;
859             uint256 lastIndex = set._values.length - 1;
860 
861             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
862             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
863 
864             bytes32 lastvalue = set._values[lastIndex];
865 
866             // Move the last value to the index where the value to delete is
867             set._values[toDeleteIndex] = lastvalue;
868             // Update the index for the moved value
869             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
870 
871             // Delete the slot where the moved value was stored
872             set._values.pop();
873 
874             // Delete the index for the deleted slot
875             delete set._indexes[value];
876 
877             return true;
878         } else {
879             return false;
880         }
881     }
882 
883     /**
884      * @dev Returns true if the value is in the set. O(1).
885      */
886     function _contains(Set storage set, bytes32 value) private view returns (bool) {
887         return set._indexes[value] != 0;
888     }
889 
890     /**
891      * @dev Returns the number of values on the set. O(1).
892      */
893     function _length(Set storage set) private view returns (uint256) {
894         return set._values.length;
895     }
896 
897    /**
898     * @dev Returns the value stored at position `index` in the set. O(1).
899     *
900     * Note that there are no guarantees on the ordering of values inside the
901     * array, and it may change when more values are added or removed.
902     *
903     * Requirements:
904     *
905     * - `index` must be strictly less than {length}.
906     */
907     function _at(Set storage set, uint256 index) private view returns (bytes32) {
908         require(set._values.length > index, "EnumerableSet: index out of bounds");
909         return set._values[index];
910     }
911 
912     // Bytes32Set
913 
914     struct Bytes32Set {
915         Set _inner;
916     }
917 
918     /**
919      * @dev Add a value to a set. O(1).
920      *
921      * Returns true if the value was added to the set, that is if it was not
922      * already present.
923      */
924     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
925         return _add(set._inner, value);
926     }
927 
928     /**
929      * @dev Removes a value from a set. O(1).
930      *
931      * Returns true if the value was removed from the set, that is if it was
932      * present.
933      */
934     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
935         return _remove(set._inner, value);
936     }
937 
938     /**
939      * @dev Returns true if the value is in the set. O(1).
940      */
941     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
942         return _contains(set._inner, value);
943     }
944 
945     /**
946      * @dev Returns the number of values in the set. O(1).
947      */
948     function length(Bytes32Set storage set) internal view returns (uint256) {
949         return _length(set._inner);
950     }
951 
952    /**
953     * @dev Returns the value stored at position `index` in the set. O(1).
954     *
955     * Note that there are no guarantees on the ordering of values inside the
956     * array, and it may change when more values are added or removed.
957     *
958     * Requirements:
959     *
960     * - `index` must be strictly less than {length}.
961     */
962     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
963         return _at(set._inner, index);
964     }
965 
966     // AddressSet
967 
968     struct AddressSet {
969         Set _inner;
970     }
971 
972     /**
973      * @dev Add a value to a set. O(1).
974      *
975      * Returns true if the value was added to the set, that is if it was not
976      * already present.
977      */
978     function add(AddressSet storage set, address value) internal returns (bool) {
979         return _add(set._inner, bytes32(uint256(uint160(value))));
980     }
981 
982     /**
983      * @dev Removes a value from a set. O(1).
984      *
985      * Returns true if the value was removed from the set, that is if it was
986      * present.
987      */
988     function remove(AddressSet storage set, address value) internal returns (bool) {
989         return _remove(set._inner, bytes32(uint256(uint160(value))));
990     }
991 
992     /**
993      * @dev Returns true if the value is in the set. O(1).
994      */
995     function contains(AddressSet storage set, address value) internal view returns (bool) {
996         return _contains(set._inner, bytes32(uint256(uint160(value))));
997     }
998 
999     /**
1000      * @dev Returns the number of values in the set. O(1).
1001      */
1002     function length(AddressSet storage set) internal view returns (uint256) {
1003         return _length(set._inner);
1004     }
1005 
1006    /**
1007     * @dev Returns the value stored at position `index` in the set. O(1).
1008     *
1009     * Note that there are no guarantees on the ordering of values inside the
1010     * array, and it may change when more values are added or removed.
1011     *
1012     * Requirements:
1013     *
1014     * - `index` must be strictly less than {length}.
1015     */
1016     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1017         return address(uint160(uint256(_at(set._inner, index))));
1018     }
1019 
1020 
1021     // UintSet
1022 
1023     struct UintSet {
1024         Set _inner;
1025     }
1026 
1027     /**
1028      * @dev Add a value to a set. O(1).
1029      *
1030      * Returns true if the value was added to the set, that is if it was not
1031      * already present.
1032      */
1033     function add(UintSet storage set, uint256 value) internal returns (bool) {
1034         return _add(set._inner, bytes32(value));
1035     }
1036 
1037     /**
1038      * @dev Removes a value from a set. O(1).
1039      *
1040      * Returns true if the value was removed from the set, that is if it was
1041      * present.
1042      */
1043     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1044         return _remove(set._inner, bytes32(value));
1045     }
1046 
1047     /**
1048      * @dev Returns true if the value is in the set. O(1).
1049      */
1050     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1051         return _contains(set._inner, bytes32(value));
1052     }
1053 
1054     /**
1055      * @dev Returns the number of values on the set. O(1).
1056      */
1057     function length(UintSet storage set) internal view returns (uint256) {
1058         return _length(set._inner);
1059     }
1060 
1061    /**
1062     * @dev Returns the value stored at position `index` in the set. O(1).
1063     *
1064     * Note that there are no guarantees on the ordering of values inside the
1065     * array, and it may change when more values are added or removed.
1066     *
1067     * Requirements:
1068     *
1069     * - `index` must be strictly less than {length}.
1070     */
1071     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1072         return uint256(_at(set._inner, index));
1073     }
1074 }
1075 
1076 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
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
1343 pragma solidity >=0.6.0 <0.8.0;
1344 
1345 /**
1346  * @dev String operations.
1347  */
1348 library Strings {
1349     /**
1350      * @dev Converts a `uint256` to its ASCII `string` representation.
1351      */
1352     function toString(uint256 value) internal pure returns (string memory) {
1353         // Inspired by OraclizeAPI's implementation - MIT licence
1354         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1355 
1356         if (value == 0) {
1357             return "0";
1358         }
1359         uint256 temp = value;
1360         uint256 digits;
1361         while (temp != 0) {
1362             digits++;
1363             temp /= 10;
1364         }
1365         bytes memory buffer = new bytes(digits);
1366         uint256 index = digits - 1;
1367         temp = value;
1368         while (temp != 0) {
1369             buffer[index--] = bytes1(uint8(48 + temp % 10));
1370             temp /= 10;
1371         }
1372         return string(buffer);
1373     }
1374 }
1375 
1376 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1377 pragma solidity >=0.6.0 <0.8.0;
1378 
1379 /**
1380  * @title ERC721 Non-Fungible Token Standard basic implementation
1381  * @dev see https://eips.ethereum.org/EIPS/eip-721
1382  */
1383 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1384     using SafeMath for uint256;
1385     using Address for address;
1386     using EnumerableSet for EnumerableSet.UintSet;
1387     using EnumerableMap for EnumerableMap.UintToAddressMap;
1388     using Strings for uint256;
1389 
1390     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1391     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1392     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1393 
1394     // Mapping from holder address to their (enumerable) set of owned tokens
1395     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1396 
1397     // Enumerable mapping from token ids to their owners
1398     EnumerableMap.UintToAddressMap private _tokenOwners;
1399 
1400     // Mapping from token ID to approved address
1401     mapping (uint256 => address) private _tokenApprovals;
1402 
1403     // Mapping from owner to operator approvals
1404     mapping (address => mapping (address => bool)) private _operatorApprovals;
1405 
1406     // Token name
1407     string private _name;
1408 
1409     // Token symbol
1410     string private _symbol;
1411 
1412     // Optional mapping for token URIs
1413     mapping (uint256 => string) private _tokenURIs;
1414 
1415     // Base URI
1416     string private _baseURI;
1417 
1418     /*
1419      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1420      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1421      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1422      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1423      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1424      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1425      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1426      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1427      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1428      *
1429      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1430      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1431      */
1432     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1433 
1434     /*
1435      *     bytes4(keccak256('name()')) == 0x06fdde03
1436      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1437      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1438      *
1439      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1440      */
1441     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1442 
1443     /*
1444      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1445      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1446      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1447      *
1448      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1449      */
1450     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1451 
1452     /**
1453      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1454      */
1455     constructor (string memory name_, string memory symbol_) public {
1456         _name = name_;
1457         _symbol = symbol_;
1458 
1459         // register the supported interfaces to conform to ERC721 via ERC165
1460         _registerInterface(_INTERFACE_ID_ERC721);
1461         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1462         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1463     }
1464 
1465     /**
1466      * @dev See {IERC721-balanceOf}.
1467      */
1468     function balanceOf(address owner) public view virtual override returns (uint256) {
1469         require(owner != address(0), "ERC721: balance query for the zero address");
1470         return _holderTokens[owner].length();
1471     }
1472 
1473     /**
1474      * @dev See {IERC721-ownerOf}.
1475      */
1476     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1477         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1478     }
1479 
1480     /**
1481      * @dev See {IERC721Metadata-name}.
1482      */
1483     function name() public view virtual override returns (string memory) {
1484         return _name;
1485     }
1486 
1487     /**
1488      * @dev See {IERC721Metadata-symbol}.
1489      */
1490     function symbol() public view virtual override returns (string memory) {
1491         return _symbol;
1492     }
1493 
1494     /**
1495      * @dev See {IERC721Metadata-tokenURI}.
1496      */
1497     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1498         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1499 
1500         string memory _tokenURI = _tokenURIs[tokenId];
1501         string memory base = baseURI();
1502 
1503         // If there is no base URI, return the token URI.
1504         if (bytes(base).length == 0) {
1505             return _tokenURI;
1506         }
1507         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1508         if (bytes(_tokenURI).length > 0) {
1509             return string(abi.encodePacked(base, _tokenURI));
1510         }
1511         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1512         return string(abi.encodePacked(base, tokenId.toString()));
1513     }
1514 
1515     /**
1516     * @dev Returns the base URI set via {_setBaseURI}. This will be
1517     * automatically added as a prefix in {tokenURI} to each token's URI, or
1518     * to the token ID if no specific URI is set for that token ID.
1519     */
1520     function baseURI() public view virtual returns (string memory) {
1521         return _baseURI;
1522     }
1523 
1524     /**
1525      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1526      */
1527     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1528         return _holderTokens[owner].at(index);
1529     }
1530 
1531     /**
1532      * @dev See {IERC721Enumerable-totalSupply}.
1533      */
1534     function totalSupply() public view virtual override returns (uint256) {
1535         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1536         return _tokenOwners.length();
1537     }
1538 
1539     /**
1540      * @dev See {IERC721Enumerable-tokenByIndex}.
1541      */
1542     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1543         (uint256 tokenId, ) = _tokenOwners.at(index);
1544         return tokenId;
1545     }
1546 
1547     /**
1548      * @dev See {IERC721-approve}.
1549      */
1550     function approve(address to, uint256 tokenId) public virtual override {
1551         address owner = ERC721.ownerOf(tokenId);
1552         require(to != owner, "ERC721: approval to current owner");
1553 
1554         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1555             "ERC721: approve caller is not owner nor approved for all"
1556         );
1557 
1558         _approve(to, tokenId);
1559     }
1560 
1561     /**
1562      * @dev See {IERC721-getApproved}.
1563      */
1564     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1565         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1566 
1567         return _tokenApprovals[tokenId];
1568     }
1569 
1570     /**
1571      * @dev See {IERC721-setApprovalForAll}.
1572      */
1573     function setApprovalForAll(address operator, bool approved) public virtual override {
1574         require(operator != _msgSender(), "ERC721: approve to caller");
1575 
1576         _operatorApprovals[_msgSender()][operator] = approved;
1577         emit ApprovalForAll(_msgSender(), operator, approved);
1578     }
1579 
1580     /**
1581      * @dev See {IERC721-isApprovedForAll}.
1582      */
1583     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1584         return _operatorApprovals[owner][operator];
1585     }
1586 
1587     /**
1588      * @dev See {IERC721-transferFrom}.
1589      */
1590     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1591         //solhint-disable-next-line max-line-length
1592         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1593 
1594         _transfer(from, to, tokenId);
1595     }
1596 
1597     /**
1598      * @dev See {IERC721-safeTransferFrom}.
1599      */
1600     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1601         safeTransferFrom(from, to, tokenId, "");
1602     }
1603 
1604     /**
1605      * @dev See {IERC721-safeTransferFrom}.
1606      */
1607     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1608         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1609         _safeTransfer(from, to, tokenId, _data);
1610     }
1611 
1612     /**
1613      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1614      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1615      *
1616      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1617      *
1618      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1619      * implement alternative mechanisms to perform token transfer, such as signature-based.
1620      *
1621      * Requirements:
1622      *
1623      * - `from` cannot be the zero address.
1624      * - `to` cannot be the zero address.
1625      * - `tokenId` token must exist and be owned by `from`.
1626      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1631         _transfer(from, to, tokenId);
1632         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1633     }
1634 
1635     /**
1636      * @dev Returns whether `tokenId` exists.
1637      *
1638      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1639      *
1640      * Tokens start existing when they are minted (`_mint`),
1641      * and stop existing when they are burned (`_burn`).
1642      */
1643     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1644         return _tokenOwners.contains(tokenId);
1645     }
1646 
1647     /**
1648      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1649      *
1650      * Requirements:
1651      *
1652      * - `tokenId` must exist.
1653      */
1654     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1655         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1656         address owner = ERC721.ownerOf(tokenId);
1657         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1658     }
1659 
1660     /**
1661      * @dev Safely mints `tokenId` and transfers it to `to`.
1662      *
1663      * Requirements:
1664      d*
1665      * - `tokenId` must not exist.
1666      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1667      *
1668      * Emits a {Transfer} event.
1669      */
1670     function _safeMint(address to, uint256 tokenId) internal virtual {
1671         _safeMint(to, tokenId, "");
1672     }
1673 
1674     /**
1675      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1676      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1677      */
1678     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1679         _mint(to, tokenId);
1680         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1681     }
1682 
1683     /**
1684      * @dev Mints `tokenId` and transfers it to `to`.
1685      *
1686      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1687      *
1688      * Requirements:
1689      *
1690      * - `tokenId` must not exist.
1691      * - `to` cannot be the zero address.
1692      *
1693      * Emits a {Transfer} event.
1694      */
1695     function _mint(address to, uint256 tokenId) internal virtual {
1696         require(to != address(0), "ERC721: mint to the zero address");
1697         require(!_exists(tokenId), "ERC721: token already minted");
1698 
1699         _beforeTokenTransfer(address(0), to, tokenId);
1700 
1701         _holderTokens[to].add(tokenId);
1702 
1703         _tokenOwners.set(tokenId, to);
1704 
1705         emit Transfer(address(0), to, tokenId);
1706     }
1707 
1708     /**
1709      * @dev Destroys `tokenId`.
1710      * The approval is cleared when the token is burned.
1711      *
1712      * Requirements:
1713      *
1714      * - `tokenId` must exist.
1715      *
1716      * Emits a {Transfer} event.
1717      */
1718     function _burn(uint256 tokenId) internal virtual {
1719         address owner = ERC721.ownerOf(tokenId); // internal owner
1720 
1721         _beforeTokenTransfer(owner, address(0), tokenId);
1722 
1723         // Clear approvals
1724         _approve(address(0), tokenId);
1725 
1726         // Clear metadata (if any)
1727         if (bytes(_tokenURIs[tokenId]).length != 0) {
1728             delete _tokenURIs[tokenId];
1729         }
1730 
1731         _holderTokens[owner].remove(tokenId);
1732 
1733         _tokenOwners.remove(tokenId);
1734 
1735         emit Transfer(owner, address(0), tokenId);
1736     }
1737 
1738     /**
1739      * @dev Transfers `tokenId` from `from` to `to`.
1740      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1741      *
1742      * Requirements:
1743      *
1744      * - `to` cannot be the zero address.
1745      * - `tokenId` token must be owned by `from`.
1746      *
1747      * Emits a {Transfer} event.
1748      */
1749     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1750         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1751         require(to != address(0), "ERC721: transfer to the zero address");
1752 
1753         _beforeTokenTransfer(from, to, tokenId);
1754 
1755         // Clear approvals from the previous owner
1756         _approve(address(0), tokenId);
1757 
1758         _holderTokens[from].remove(tokenId);
1759         _holderTokens[to].add(tokenId);
1760 
1761         _tokenOwners.set(tokenId, to);
1762 
1763         emit Transfer(from, to, tokenId);
1764     }
1765 
1766     /**
1767      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1768      *
1769      * Requirements:
1770      *
1771      * - `tokenId` must exist.
1772      */
1773     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1774         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1775         _tokenURIs[tokenId] = _tokenURI;
1776     }
1777 
1778     /**
1779      * @dev Internal function to set the base URI for all token IDs. It is
1780      * automatically added as a prefix to the value returned in {tokenURI},
1781      * or to the token ID if {tokenURI} is empty.
1782      */
1783     function _setBaseURI(string memory baseURI_) internal virtual {
1784         _baseURI = baseURI_;
1785     }
1786 
1787     /**
1788      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1789      * The call is not executed if the target address is not a contract.
1790      *
1791      * @param from address representing the previous owner of the given token ID
1792      * @param to target address that will receive the tokens
1793      * @param tokenId uint256 ID of the token to be transferred
1794      * @param _data bytes optional data to send along with the call
1795      * @return bool whether the call correctly returned the expected magic value
1796      */
1797     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1798         private returns (bool)
1799     {
1800         if (!to.isContract()) {
1801             return true;
1802         }
1803         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1804             IERC721Receiver(to).onERC721Received.selector,
1805             _msgSender(),
1806             from,
1807             tokenId,
1808             _data
1809         ), "ERC721: transfer to non ERC721Receiver implementer");
1810         bytes4 retval = abi.decode(returndata, (bytes4));
1811         return (retval == _ERC721_RECEIVED);
1812     }
1813 
1814     /**
1815      * @dev Approve `to` to operate on `tokenId`
1816      *
1817      * Emits an {Approval} event.
1818      */
1819     function _approve(address to, uint256 tokenId) internal virtual {
1820         _tokenApprovals[tokenId] = to;
1821         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1822     }
1823 
1824     /**
1825      * @dev Hook that is called before any token transfer. This includes minting
1826      * and burning.
1827      *
1828      * Calling conditions:
1829      *
1830      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1831      * transferred to `to`.
1832      * - When `from` is zero, `tokenId` will be minted for `to`.
1833      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1834      * - `from` cannot be the zero address.
1835      * - `to` cannot be the zero address.
1836      *
1837      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1838      */
1839     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1840 }
1841 
1842 // File: @openzeppelin/contracts/access/Ownable.sol
1843 pragma solidity >=0.6.0 <0.8.0;
1844 
1845 /**
1846  * @dev Contract module which provides a basic access control mechanism, where
1847  * there is an account (an owner) that can be granted exclusive access to
1848  * specific functions.
1849  *
1850  * By default, the owner account will be the one that deploys the contract. This
1851  * can later be changed with {transferOwnership}.
1852  *
1853  * This module is used through inheritance. It will make available the modifier
1854  * `onlyOwner`, which can be applied to your functions to restrict their use to
1855  * the owner.
1856  */
1857 abstract contract Ownable is Context {
1858     address private _owner;
1859 
1860     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1861 
1862     /**
1863      * @dev Initializes the contract setting the deployer as the initial owner.
1864      */
1865     constructor () internal {
1866         address msgSender = _msgSender();
1867         _owner = msgSender;
1868         emit OwnershipTransferred(address(0), msgSender);
1869     }
1870 
1871     /**
1872      * @dev Returns the address of the current owner.
1873      */
1874     function owner() public view virtual returns (address) {
1875         return _owner;
1876     }
1877 
1878     /**
1879      * @dev Throws if called by any account other than the owner.
1880      */
1881     modifier onlyOwner() {
1882         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1883         _;
1884     }
1885 
1886     /**
1887      * @dev Leaves the contract without owner. It will not be possible to call
1888      * `onlyOwner` functions anymore. Can only be called by the current owner.
1889      *
1890      * NOTE: Renouncing ownership will leave the contract without an owner,
1891      * thereby removing any functionality that is only available to the owner.
1892      */
1893     function renounceOwnership() public virtual onlyOwner {
1894         emit OwnershipTransferred(_owner, address(0));
1895         _owner = address(0);
1896     }
1897 
1898     /**
1899      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1900      * Can only be called by the current owner.
1901      */
1902     function transferOwnership(address newOwner) public virtual onlyOwner {
1903         require(newOwner != address(0), "Ownable: new owner is the zero address");
1904         emit OwnershipTransferred(_owner, newOwner);
1905         _owner = newOwner;
1906     }
1907 }
1908 
1909 
1910 abstract contract ERC721URIStorageCustom is ERC721,Ownable {
1911     using Strings for uint256;
1912 
1913     // Optional mapping for token URIs
1914     mapping(uint256 => string) private _tokenURIs;
1915     
1916     bool appendJson = true;
1917     
1918     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1919         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1920 
1921         string memory _tokenURI = _tokenURIs[tokenId];
1922         string memory base = baseURI();
1923 
1924         // If there is no base URI, return the token URI.
1925         if (bytes(base).length == 0) {
1926             return _tokenURI;
1927         }
1928         
1929       
1930            
1931         if (appendJson) {
1932             return string(abi.encodePacked(base, tokenId.toString(),".json"));
1933         }
1934         
1935         if (bytes(_tokenURI).length > 0) {
1936             return string(abi.encodePacked(base, _tokenURI));
1937         }
1938         
1939         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1940         return string(abi.encodePacked(base, tokenId.toString()));
1941     }
1942 
1943     
1944     function disableJson(bool _status) public onlyOwner {
1945         appendJson = _status;
1946     }
1947     
1948 
1949 }
1950 
1951 
1952 pragma solidity ^0.7.0;
1953 
1954 /**
1955  * @title BlueChimp contract
1956  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1957  */
1958 contract BlueChimp is ERC721URIStorageCustom {
1959     uint256 public count = 0;
1960     
1961     event Increment(address who);
1962     event BlueChimpMinted(uint256 indexed id, address from);
1963 
1964     using SafeMath for uint256;
1965     uint256 public BlueChimpPrice = 340000000000000000; //0.34 ETH
1966     uint public constant maxBlueChimpPurchase = 20;
1967     uint256 public MAX_BlueChimp;
1968     bool public saleIsActive = false;
1969 
1970     constructor(string memory name, string memory symbol, uint256 maxNftSupply) ERC721(name, symbol) {
1971         MAX_BlueChimp = maxNftSupply;
1972     }
1973     
1974     address payable private marketingWallet = 0x73fB71642d9189cf8EB197ddEAA46ca962AbF8Fc;
1975     
1976     function withdrawToMarketing() public onlyOwner {
1977         uint balance = address(this).balance;
1978         marketingWallet.transfer(balance);
1979     }
1980     
1981      function withdrawToOwner() public onlyOwner {
1982         uint balance = address(this).balance;
1983         msg.sender.transfer(balance);
1984     }
1985    
1986     // Reserves BlueChimp
1987     function reserveBlueChimpForDonations(uint numberOfTokens) public onlyOwner {        
1988         uint supply = totalSupply();
1989         uint i;
1990         for (i = 0; i < numberOfTokens; i++) {
1991             mintNft(msg.sender, supply + i);
1992             count += 1;
1993         }
1994         emit Increment(msg.sender);
1995     }
1996     
1997     function withdrawStuckTokens(IERC20 token, address to) public onlyOwner {	
1998         uint256 balance = token.balanceOf(address(this));	
1999         token.transfer(to, balance);	
2000     }
2001 
2002     function setBaseURI(string memory baseURI) public onlyOwner {
2003         _setBaseURI(baseURI);
2004     }
2005 
2006   
2007 
2008 
2009     function flipSaleState() public onlyOwner {
2010         saleIsActive = !saleIsActive;
2011     }
2012 
2013     function discoverBlueChimp(uint numberOfTokens) public payable {
2014         require(saleIsActive, "Sale must be active to mint BlueChimp");
2015         require(numberOfTokens <= maxBlueChimpPurchase, "Can only mint 20 tokens at a time");
2016         require(totalSupply().add(numberOfTokens) <= MAX_BlueChimp, "Purchase would exceed max supply of BlueChimp");
2017         require(BlueChimpPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2018         
2019         for(uint i = 0; i < numberOfTokens; i++) {
2020             uint mintIndex = totalSupply();
2021             if (totalSupply() < MAX_BlueChimp) {
2022                 mintNft(msg.sender, mintIndex);
2023                 count += 1;
2024             }
2025         }
2026 
2027         emit Increment(msg.sender);
2028     }
2029 
2030     function mintNft(address to, uint256 tokenId) internal virtual {
2031         _safeMint(to, tokenId);
2032         emit BlueChimpMinted(tokenId, to);
2033     }
2034 
2035     function getCount() public view returns(uint256) {
2036         return count;
2037     }
2038 
2039     // Emergency: can be changed to account for large fluctuations in ETH price
2040     function emergencyChangePrice(uint256 newPrice) public onlyOwner {
2041         BlueChimpPrice = newPrice;
2042     }
2043 
2044     function multiTransfer(address from, address to, uint256[] calldata tokenId) public {	
2045         for(uint i=0;i<tokenId.length;i++){	
2046             safeTransferFrom(from, to, tokenId[i], "");	
2047         }	
2048     }
2049 
2050      function changeLimit(uint256 _limit) public onlyOwner {
2051         MAX_BlueChimp = _limit;
2052     }
2053 
2054 }