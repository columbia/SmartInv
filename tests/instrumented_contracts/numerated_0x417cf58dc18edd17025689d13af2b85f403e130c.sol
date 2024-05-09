1 pragma solidity <0.8.0;
2 
3 
4 // 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view virtual returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(owner() == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 // 
92 /**
93  * @dev Interface of the ERC165 standard, as defined in the
94  * https://eips.ethereum.org/EIPS/eip-165[EIP].
95  *
96  * Implementers can declare support of contract interfaces, which can then be
97  * queried by others ({ERC165Checker}).
98  *
99  * For an implementation, see {ERC165}.
100  */
101 interface IERC165 {
102     /**
103      * @dev Returns true if this contract implements the interface defined by
104      * `interfaceId`. See the corresponding
105      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
106      * to learn more about how these ids are created.
107      *
108      * This function call must use less than 30 000 gas.
109      */
110     function supportsInterface(bytes4 interfaceId) external view returns (bool);
111 }
112 
113 // 
114 /**
115  * @dev Required interface of an ERC721 compliant contract.
116  */
117 interface IERC721 is IERC165 {
118     /**
119      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
122 
123     /**
124      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
125      */
126     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
130      */
131     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
132 
133     /**
134      * @dev Returns the number of tokens in ``owner``'s account.
135      */
136     function balanceOf(address owner) external view returns (uint256 balance);
137 
138     /**
139      * @dev Returns the owner of the `tokenId` token.
140      *
141      * Requirements:
142      *
143      * - `tokenId` must exist.
144      */
145     function ownerOf(uint256 tokenId) external view returns (address owner);
146 
147     /**
148      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
149      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
150      *
151      * Requirements:
152      *
153      * - `from` cannot be the zero address.
154      * - `to` cannot be the zero address.
155      * - `tokenId` token must exist and be owned by `from`.
156      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
157      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
158      *
159      * Emits a {Transfer} event.
160      */
161     function safeTransferFrom(address from, address to, uint256 tokenId) external;
162 
163     /**
164      * @dev Transfers `tokenId` token from `from` to `to`.
165      *
166      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
167      *
168      * Requirements:
169      *
170      * - `from` cannot be the zero address.
171      * - `to` cannot be the zero address.
172      * - `tokenId` token must be owned by `from`.
173      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transferFrom(address from, address to, uint256 tokenId) external;
178 
179     /**
180      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
181      * The approval is cleared when the token is transferred.
182      *
183      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
184      *
185      * Requirements:
186      *
187      * - The caller must own the token or be an approved operator.
188      * - `tokenId` must exist.
189      *
190      * Emits an {Approval} event.
191      */
192     function approve(address to, uint256 tokenId) external;
193 
194     /**
195      * @dev Returns the account approved for `tokenId` token.
196      *
197      * Requirements:
198      *
199      * - `tokenId` must exist.
200      */
201     function getApproved(uint256 tokenId) external view returns (address operator);
202 
203     /**
204      * @dev Approve or remove `operator` as an operator for the caller.
205      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
206      *
207      * Requirements:
208      *
209      * - The `operator` cannot be the caller.
210      *
211      * Emits an {ApprovalForAll} event.
212      */
213     function setApprovalForAll(address operator, bool _approved) external;
214 
215     /**
216      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
217      *
218      * See {setApprovalForAll}
219      */
220     function isApprovedForAll(address owner, address operator) external view returns (bool);
221 
222     /**
223       * @dev Safely transfers `tokenId` token from `from` to `to`.
224       *
225       * Requirements:
226       *
227       * - `from` cannot be the zero address.
228       * - `to` cannot be the zero address.
229       * - `tokenId` token must exist and be owned by `from`.
230       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
231       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
232       *
233       * Emits a {Transfer} event.
234       */
235     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
236 }
237 
238 // 
239 /**
240  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
241  * @dev See https://eips.ethereum.org/EIPS/eip-721
242  */
243 interface IERC721Metadata is IERC721 {
244 
245     /**
246      * @dev Returns the token collection name.
247      */
248     function name() external view returns (string memory);
249 
250     /**
251      * @dev Returns the token collection symbol.
252      */
253     function symbol() external view returns (string memory);
254 
255     /**
256      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
257      */
258     function tokenURI(uint256 tokenId) external view returns (string memory);
259 }
260 
261 // 
262 /**
263  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
264  * @dev See https://eips.ethereum.org/EIPS/eip-721
265  */
266 interface IERC721Enumerable is IERC721 {
267 
268     /**
269      * @dev Returns the total amount of tokens stored by the contract.
270      */
271     function totalSupply() external view returns (uint256);
272 
273     /**
274      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
275      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
276      */
277     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
278 
279     /**
280      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
281      * Use along with {totalSupply} to enumerate all tokens.
282      */
283     function tokenByIndex(uint256 index) external view returns (uint256);
284 }
285 
286 // 
287 /**
288  * @title ERC721 token receiver interface
289  * @dev Interface for any contract that wants to support safeTransfers
290  * from ERC721 asset contracts.
291  */
292 interface IERC721Receiver {
293     /**
294      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
295      * by `operator` from `from`, this function is called.
296      *
297      * It must return its Solidity selector to confirm the token transfer.
298      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
299      *
300      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
301      */
302     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
303 }
304 
305 // 
306 /**
307  * @dev Implementation of the {IERC165} interface.
308  *
309  * Contracts may inherit from this and call {_registerInterface} to declare
310  * their support of an interface.
311  */
312 abstract contract ERC165 is IERC165 {
313     /*
314      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
315      */
316     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
317 
318     /**
319      * @dev Mapping of interface ids to whether or not it's supported.
320      */
321     mapping(bytes4 => bool) private _supportedInterfaces;
322 
323     constructor () internal {
324         // Derived contracts need only register support for their own interfaces,
325         // we register support for ERC165 itself here
326         _registerInterface(_INTERFACE_ID_ERC165);
327     }
328 
329     /**
330      * @dev See {IERC165-supportsInterface}.
331      *
332      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
333      */
334     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
335         return _supportedInterfaces[interfaceId];
336     }
337 
338     /**
339      * @dev Registers the contract as an implementer of the interface defined by
340      * `interfaceId`. Support of the actual ERC165 interface is automatic and
341      * registering its interface id is not required.
342      *
343      * See {IERC165-supportsInterface}.
344      *
345      * Requirements:
346      *
347      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
348      */
349     function _registerInterface(bytes4 interfaceId) internal virtual {
350         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
351         _supportedInterfaces[interfaceId] = true;
352     }
353 }
354 
355 // 
356 /**
357  * @dev Wrappers over Solidity's arithmetic operations with added overflow
358  * checks.
359  *
360  * Arithmetic operations in Solidity wrap on overflow. This can easily result
361  * in bugs, because programmers usually assume that an overflow raises an
362  * error, which is the standard behavior in high level programming languages.
363  * `SafeMath` restores this intuition by reverting the transaction when an
364  * operation overflows.
365  *
366  * Using this library instead of the unchecked operations eliminates an entire
367  * class of bugs, so it's recommended to use it always.
368  */
369 library SafeMath {
370     /**
371      * @dev Returns the addition of two unsigned integers, with an overflow flag.
372      *
373      * _Available since v3.4._
374      */
375     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
376         uint256 c = a + b;
377         if (c < a) return (false, 0);
378         return (true, c);
379     }
380 
381     /**
382      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
383      *
384      * _Available since v3.4._
385      */
386     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
387         if (b > a) return (false, 0);
388         return (true, a - b);
389     }
390 
391     /**
392      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
393      *
394      * _Available since v3.4._
395      */
396     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
397         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
398         // benefit is lost if 'b' is also tested.
399         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
400         if (a == 0) return (true, 0);
401         uint256 c = a * b;
402         if (c / a != b) return (false, 0);
403         return (true, c);
404     }
405 
406     /**
407      * @dev Returns the division of two unsigned integers, with a division by zero flag.
408      *
409      * _Available since v3.4._
410      */
411     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
412         if (b == 0) return (false, 0);
413         return (true, a / b);
414     }
415 
416     /**
417      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
418      *
419      * _Available since v3.4._
420      */
421     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
422         if (b == 0) return (false, 0);
423         return (true, a % b);
424     }
425 
426     /**
427      * @dev Returns the addition of two unsigned integers, reverting on
428      * overflow.
429      *
430      * Counterpart to Solidity's `+` operator.
431      *
432      * Requirements:
433      *
434      * - Addition cannot overflow.
435      */
436     function add(uint256 a, uint256 b) internal pure returns (uint256) {
437         uint256 c = a + b;
438         require(c >= a, "SafeMath: addition overflow");
439         return c;
440     }
441 
442     /**
443      * @dev Returns the subtraction of two unsigned integers, reverting on
444      * overflow (when the result is negative).
445      *
446      * Counterpart to Solidity's `-` operator.
447      *
448      * Requirements:
449      *
450      * - Subtraction cannot overflow.
451      */
452     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
453         require(b <= a, "SafeMath: subtraction overflow");
454         return a - b;
455     }
456 
457     /**
458      * @dev Returns the multiplication of two unsigned integers, reverting on
459      * overflow.
460      *
461      * Counterpart to Solidity's `*` operator.
462      *
463      * Requirements:
464      *
465      * - Multiplication cannot overflow.
466      */
467     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
468         if (a == 0) return 0;
469         uint256 c = a * b;
470         require(c / a == b, "SafeMath: multiplication overflow");
471         return c;
472     }
473 
474     /**
475      * @dev Returns the integer division of two unsigned integers, reverting on
476      * division by zero. The result is rounded towards zero.
477      *
478      * Counterpart to Solidity's `/` operator. Note: this function uses a
479      * `revert` opcode (which leaves remaining gas untouched) while Solidity
480      * uses an invalid opcode to revert (consuming all remaining gas).
481      *
482      * Requirements:
483      *
484      * - The divisor cannot be zero.
485      */
486     function div(uint256 a, uint256 b) internal pure returns (uint256) {
487         require(b > 0, "SafeMath: division by zero");
488         return a / b;
489     }
490 
491     /**
492      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
493      * reverting when dividing by zero.
494      *
495      * Counterpart to Solidity's `%` operator. This function uses a `revert`
496      * opcode (which leaves remaining gas untouched) while Solidity uses an
497      * invalid opcode to revert (consuming all remaining gas).
498      *
499      * Requirements:
500      *
501      * - The divisor cannot be zero.
502      */
503     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
504         require(b > 0, "SafeMath: modulo by zero");
505         return a % b;
506     }
507 
508     /**
509      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
510      * overflow (when the result is negative).
511      *
512      * CAUTION: This function is deprecated because it requires allocating memory for the error
513      * message unnecessarily. For custom revert reasons use {trySub}.
514      *
515      * Counterpart to Solidity's `-` operator.
516      *
517      * Requirements:
518      *
519      * - Subtraction cannot overflow.
520      */
521     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
522         require(b <= a, errorMessage);
523         return a - b;
524     }
525 
526     /**
527      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
528      * division by zero. The result is rounded towards zero.
529      *
530      * CAUTION: This function is deprecated because it requires allocating memory for the error
531      * message unnecessarily. For custom revert reasons use {tryDiv}.
532      *
533      * Counterpart to Solidity's `/` operator. Note: this function uses a
534      * `revert` opcode (which leaves remaining gas untouched) while Solidity
535      * uses an invalid opcode to revert (consuming all remaining gas).
536      *
537      * Requirements:
538      *
539      * - The divisor cannot be zero.
540      */
541     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
542         require(b > 0, errorMessage);
543         return a / b;
544     }
545 
546     /**
547      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
548      * reverting with custom message when dividing by zero.
549      *
550      * CAUTION: This function is deprecated because it requires allocating memory for the error
551      * message unnecessarily. For custom revert reasons use {tryMod}.
552      *
553      * Counterpart to Solidity's `%` operator. This function uses a `revert`
554      * opcode (which leaves remaining gas untouched) while Solidity uses an
555      * invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
562         require(b > 0, errorMessage);
563         return a % b;
564     }
565 }
566 
567 // 
568 /**
569  * @dev Collection of functions related to the address type
570  */
571 library Address {
572     /**
573      * @dev Returns true if `account` is a contract.
574      *
575      * [IMPORTANT]
576      * ====
577      * It is unsafe to assume that an address for which this function returns
578      * false is an externally-owned account (EOA) and not a contract.
579      *
580      * Among others, `isContract` will return false for the following
581      * types of addresses:
582      *
583      *  - an externally-owned account
584      *  - a contract in construction
585      *  - an address where a contract will be created
586      *  - an address where a contract lived, but was destroyed
587      * ====
588      */
589     function isContract(address account) internal view returns (bool) {
590         // This method relies on extcodesize, which returns 0 for contracts in
591         // construction, since the code is only stored at the end of the
592         // constructor execution.
593 
594         uint256 size;
595         // solhint-disable-next-line no-inline-assembly
596         assembly { size := extcodesize(account) }
597         return size > 0;
598     }
599 
600     /**
601      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
602      * `recipient`, forwarding all available gas and reverting on errors.
603      *
604      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
605      * of certain opcodes, possibly making contracts go over the 2300 gas limit
606      * imposed by `transfer`, making them unable to receive funds via
607      * `transfer`. {sendValue} removes this limitation.
608      *
609      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
610      *
611      * IMPORTANT: because control is transferred to `recipient`, care must be
612      * taken to not create reentrancy vulnerabilities. Consider using
613      * {ReentrancyGuard} or the
614      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
615      */
616     function sendValue(address payable recipient, uint256 amount) internal {
617         require(address(this).balance >= amount, "Address: insufficient balance");
618 
619         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
620         (bool success, ) = recipient.call{ value: amount }("");
621         require(success, "Address: unable to send value, recipient may have reverted");
622     }
623 
624     /**
625      * @dev Performs a Solidity function call using a low level `call`. A
626      * plain`call` is an unsafe replacement for a function call: use this
627      * function instead.
628      *
629      * If `target` reverts with a revert reason, it is bubbled up by this
630      * function (like regular Solidity function calls).
631      *
632      * Returns the raw returned data. To convert to the expected return value,
633      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
634      *
635      * Requirements:
636      *
637      * - `target` must be a contract.
638      * - calling `target` with `data` must not revert.
639      *
640      * _Available since v3.1._
641      */
642     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
643       return functionCall(target, data, "Address: low-level call failed");
644     }
645 
646     /**
647      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
648      * `errorMessage` as a fallback revert reason when `target` reverts.
649      *
650      * _Available since v3.1._
651      */
652     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
653         return functionCallWithValue(target, data, 0, errorMessage);
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
658      * but also transferring `value` wei to `target`.
659      *
660      * Requirements:
661      *
662      * - the calling contract must have an ETH balance of at least `value`.
663      * - the called Solidity function must be `payable`.
664      *
665      * _Available since v3.1._
666      */
667     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
668         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
669     }
670 
671     /**
672      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
673      * with `errorMessage` as a fallback revert reason when `target` reverts.
674      *
675      * _Available since v3.1._
676      */
677     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
678         require(address(this).balance >= value, "Address: insufficient balance for call");
679         require(isContract(target), "Address: call to non-contract");
680 
681         // solhint-disable-next-line avoid-low-level-calls
682         (bool success, bytes memory returndata) = target.call{ value: value }(data);
683         return _verifyCallResult(success, returndata, errorMessage);
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
688      * but performing a static call.
689      *
690      * _Available since v3.3._
691      */
692     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
693         return functionStaticCall(target, data, "Address: low-level static call failed");
694     }
695 
696     /**
697      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
698      * but performing a static call.
699      *
700      * _Available since v3.3._
701      */
702     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
703         require(isContract(target), "Address: static call to non-contract");
704 
705         // solhint-disable-next-line avoid-low-level-calls
706         (bool success, bytes memory returndata) = target.staticcall(data);
707         return _verifyCallResult(success, returndata, errorMessage);
708     }
709 
710     /**
711      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
712      * but performing a delegate call.
713      *
714      * _Available since v3.4._
715      */
716     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
717         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
718     }
719 
720     /**
721      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
722      * but performing a delegate call.
723      *
724      * _Available since v3.4._
725      */
726     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
727         require(isContract(target), "Address: delegate call to non-contract");
728 
729         // solhint-disable-next-line avoid-low-level-calls
730         (bool success, bytes memory returndata) = target.delegatecall(data);
731         return _verifyCallResult(success, returndata, errorMessage);
732     }
733 
734     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
735         if (success) {
736             return returndata;
737         } else {
738             // Look for revert reason and bubble it up if present
739             if (returndata.length > 0) {
740                 // The easiest way to bubble the revert reason is using memory via assembly
741 
742                 // solhint-disable-next-line no-inline-assembly
743                 assembly {
744                     let returndata_size := mload(returndata)
745                     revert(add(32, returndata), returndata_size)
746                 }
747             } else {
748                 revert(errorMessage);
749             }
750         }
751     }
752 }
753 
754 // 
755 /**
756  * @dev Library for managing
757  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
758  * types.
759  *
760  * Sets have the following properties:
761  *
762  * - Elements are added, removed, and checked for existence in constant time
763  * (O(1)).
764  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
765  *
766  * ```
767  * contract Example {
768  *     // Add the library methods
769  *     using EnumerableSet for EnumerableSet.AddressSet;
770  *
771  *     // Declare a set state variable
772  *     EnumerableSet.AddressSet private mySet;
773  * }
774  * ```
775  *
776  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
777  * and `uint256` (`UintSet`) are supported.
778  */
779 library EnumerableSet {
780     // To implement this library for multiple types with as little code
781     // repetition as possible, we write it in terms of a generic Set type with
782     // bytes32 values.
783     // The Set implementation uses private functions, and user-facing
784     // implementations (such as AddressSet) are just wrappers around the
785     // underlying Set.
786     // This means that we can only create new EnumerableSets for types that fit
787     // in bytes32.
788 
789     struct Set {
790         // Storage of set values
791         bytes32[] _values;
792 
793         // Position of the value in the `values` array, plus 1 because index 0
794         // means a value is not in the set.
795         mapping (bytes32 => uint256) _indexes;
796     }
797 
798     /**
799      * @dev Add a value to a set. O(1).
800      *
801      * Returns true if the value was added to the set, that is if it was not
802      * already present.
803      */
804     function _add(Set storage set, bytes32 value) private returns (bool) {
805         if (!_contains(set, value)) {
806             set._values.push(value);
807             // The value is stored at length-1, but we add 1 to all indexes
808             // and use 0 as a sentinel value
809             set._indexes[value] = set._values.length;
810             return true;
811         } else {
812             return false;
813         }
814     }
815 
816     /**
817      * @dev Removes a value from a set. O(1).
818      *
819      * Returns true if the value was removed from the set, that is if it was
820      * present.
821      */
822     function _remove(Set storage set, bytes32 value) private returns (bool) {
823         // We read and store the value's index to prevent multiple reads from the same storage slot
824         uint256 valueIndex = set._indexes[value];
825 
826         if (valueIndex != 0) { // Equivalent to contains(set, value)
827             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
828             // the array, and then remove the last element (sometimes called as 'swap and pop').
829             // This modifies the order of the array, as noted in {at}.
830 
831             uint256 toDeleteIndex = valueIndex - 1;
832             uint256 lastIndex = set._values.length - 1;
833 
834             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
835             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
836 
837             bytes32 lastvalue = set._values[lastIndex];
838 
839             // Move the last value to the index where the value to delete is
840             set._values[toDeleteIndex] = lastvalue;
841             // Update the index for the moved value
842             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
843 
844             // Delete the slot where the moved value was stored
845             set._values.pop();
846 
847             // Delete the index for the deleted slot
848             delete set._indexes[value];
849 
850             return true;
851         } else {
852             return false;
853         }
854     }
855 
856     /**
857      * @dev Returns true if the value is in the set. O(1).
858      */
859     function _contains(Set storage set, bytes32 value) private view returns (bool) {
860         return set._indexes[value] != 0;
861     }
862 
863     /**
864      * @dev Returns the number of values on the set. O(1).
865      */
866     function _length(Set storage set) private view returns (uint256) {
867         return set._values.length;
868     }
869 
870    /**
871     * @dev Returns the value stored at position `index` in the set. O(1).
872     *
873     * Note that there are no guarantees on the ordering of values inside the
874     * array, and it may change when more values are added or removed.
875     *
876     * Requirements:
877     *
878     * - `index` must be strictly less than {length}.
879     */
880     function _at(Set storage set, uint256 index) private view returns (bytes32) {
881         require(set._values.length > index, "EnumerableSet: index out of bounds");
882         return set._values[index];
883     }
884 
885     // Bytes32Set
886 
887     struct Bytes32Set {
888         Set _inner;
889     }
890 
891     /**
892      * @dev Add a value to a set. O(1).
893      *
894      * Returns true if the value was added to the set, that is if it was not
895      * already present.
896      */
897     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
898         return _add(set._inner, value);
899     }
900 
901     /**
902      * @dev Removes a value from a set. O(1).
903      *
904      * Returns true if the value was removed from the set, that is if it was
905      * present.
906      */
907     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
908         return _remove(set._inner, value);
909     }
910 
911     /**
912      * @dev Returns true if the value is in the set. O(1).
913      */
914     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
915         return _contains(set._inner, value);
916     }
917 
918     /**
919      * @dev Returns the number of values in the set. O(1).
920      */
921     function length(Bytes32Set storage set) internal view returns (uint256) {
922         return _length(set._inner);
923     }
924 
925    /**
926     * @dev Returns the value stored at position `index` in the set. O(1).
927     *
928     * Note that there are no guarantees on the ordering of values inside the
929     * array, and it may change when more values are added or removed.
930     *
931     * Requirements:
932     *
933     * - `index` must be strictly less than {length}.
934     */
935     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
936         return _at(set._inner, index);
937     }
938 
939     // AddressSet
940 
941     struct AddressSet {
942         Set _inner;
943     }
944 
945     /**
946      * @dev Add a value to a set. O(1).
947      *
948      * Returns true if the value was added to the set, that is if it was not
949      * already present.
950      */
951     function add(AddressSet storage set, address value) internal returns (bool) {
952         return _add(set._inner, bytes32(uint256(uint160(value))));
953     }
954 
955     /**
956      * @dev Removes a value from a set. O(1).
957      *
958      * Returns true if the value was removed from the set, that is if it was
959      * present.
960      */
961     function remove(AddressSet storage set, address value) internal returns (bool) {
962         return _remove(set._inner, bytes32(uint256(uint160(value))));
963     }
964 
965     /**
966      * @dev Returns true if the value is in the set. O(1).
967      */
968     function contains(AddressSet storage set, address value) internal view returns (bool) {
969         return _contains(set._inner, bytes32(uint256(uint160(value))));
970     }
971 
972     /**
973      * @dev Returns the number of values in the set. O(1).
974      */
975     function length(AddressSet storage set) internal view returns (uint256) {
976         return _length(set._inner);
977     }
978 
979    /**
980     * @dev Returns the value stored at position `index` in the set. O(1).
981     *
982     * Note that there are no guarantees on the ordering of values inside the
983     * array, and it may change when more values are added or removed.
984     *
985     * Requirements:
986     *
987     * - `index` must be strictly less than {length}.
988     */
989     function at(AddressSet storage set, uint256 index) internal view returns (address) {
990         return address(uint160(uint256(_at(set._inner, index))));
991     }
992 
993 
994     // UintSet
995 
996     struct UintSet {
997         Set _inner;
998     }
999 
1000     /**
1001      * @dev Add a value to a set. O(1).
1002      *
1003      * Returns true if the value was added to the set, that is if it was not
1004      * already present.
1005      */
1006     function add(UintSet storage set, uint256 value) internal returns (bool) {
1007         return _add(set._inner, bytes32(value));
1008     }
1009 
1010     /**
1011      * @dev Removes a value from a set. O(1).
1012      *
1013      * Returns true if the value was removed from the set, that is if it was
1014      * present.
1015      */
1016     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1017         return _remove(set._inner, bytes32(value));
1018     }
1019 
1020     /**
1021      * @dev Returns true if the value is in the set. O(1).
1022      */
1023     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1024         return _contains(set._inner, bytes32(value));
1025     }
1026 
1027     /**
1028      * @dev Returns the number of values on the set. O(1).
1029      */
1030     function length(UintSet storage set) internal view returns (uint256) {
1031         return _length(set._inner);
1032     }
1033 
1034    /**
1035     * @dev Returns the value stored at position `index` in the set. O(1).
1036     *
1037     * Note that there are no guarantees on the ordering of values inside the
1038     * array, and it may change when more values are added or removed.
1039     *
1040     * Requirements:
1041     *
1042     * - `index` must be strictly less than {length}.
1043     */
1044     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1045         return uint256(_at(set._inner, index));
1046     }
1047 }
1048 
1049 // 
1050 /**
1051  * @dev Library for managing an enumerable variant of Solidity's
1052  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1053  * type.
1054  *
1055  * Maps have the following properties:
1056  *
1057  * - Entries are added, removed, and checked for existence in constant time
1058  * (O(1)).
1059  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1060  *
1061  * ```
1062  * contract Example {
1063  *     // Add the library methods
1064  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1065  *
1066  *     // Declare a set state variable
1067  *     EnumerableMap.UintToAddressMap private myMap;
1068  * }
1069  * ```
1070  *
1071  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1072  * supported.
1073  */
1074 library EnumerableMap {
1075     // To implement this library for multiple types with as little code
1076     // repetition as possible, we write it in terms of a generic Map type with
1077     // bytes32 keys and values.
1078     // The Map implementation uses private functions, and user-facing
1079     // implementations (such as Uint256ToAddressMap) are just wrappers around
1080     // the underlying Map.
1081     // This means that we can only create new EnumerableMaps for types that fit
1082     // in bytes32.
1083 
1084     struct MapEntry {
1085         bytes32 _key;
1086         bytes32 _value;
1087     }
1088 
1089     struct Map {
1090         // Storage of map keys and values
1091         MapEntry[] _entries;
1092 
1093         // Position of the entry defined by a key in the `entries` array, plus 1
1094         // because index 0 means a key is not in the map.
1095         mapping (bytes32 => uint256) _indexes;
1096     }
1097 
1098     /**
1099      * @dev Adds a key-value pair to a map, or updates the value for an existing
1100      * key. O(1).
1101      *
1102      * Returns true if the key was added to the map, that is if it was not
1103      * already present.
1104      */
1105     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1106         // We read and store the key's index to prevent multiple reads from the same storage slot
1107         uint256 keyIndex = map._indexes[key];
1108 
1109         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1110             map._entries.push(MapEntry({ _key: key, _value: value }));
1111             // The entry is stored at length-1, but we add 1 to all indexes
1112             // and use 0 as a sentinel value
1113             map._indexes[key] = map._entries.length;
1114             return true;
1115         } else {
1116             map._entries[keyIndex - 1]._value = value;
1117             return false;
1118         }
1119     }
1120 
1121     /**
1122      * @dev Removes a key-value pair from a map. O(1).
1123      *
1124      * Returns true if the key was removed from the map, that is if it was present.
1125      */
1126     function _remove(Map storage map, bytes32 key) private returns (bool) {
1127         // We read and store the key's index to prevent multiple reads from the same storage slot
1128         uint256 keyIndex = map._indexes[key];
1129 
1130         if (keyIndex != 0) { // Equivalent to contains(map, key)
1131             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1132             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1133             // This modifies the order of the array, as noted in {at}.
1134 
1135             uint256 toDeleteIndex = keyIndex - 1;
1136             uint256 lastIndex = map._entries.length - 1;
1137 
1138             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1139             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1140 
1141             MapEntry storage lastEntry = map._entries[lastIndex];
1142 
1143             // Move the last entry to the index where the entry to delete is
1144             map._entries[toDeleteIndex] = lastEntry;
1145             // Update the index for the moved entry
1146             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1147 
1148             // Delete the slot where the moved entry was stored
1149             map._entries.pop();
1150 
1151             // Delete the index for the deleted slot
1152             delete map._indexes[key];
1153 
1154             return true;
1155         } else {
1156             return false;
1157         }
1158     }
1159 
1160     /**
1161      * @dev Returns true if the key is in the map. O(1).
1162      */
1163     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1164         return map._indexes[key] != 0;
1165     }
1166 
1167     /**
1168      * @dev Returns the number of key-value pairs in the map. O(1).
1169      */
1170     function _length(Map storage map) private view returns (uint256) {
1171         return map._entries.length;
1172     }
1173 
1174    /**
1175     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1176     *
1177     * Note that there are no guarantees on the ordering of entries inside the
1178     * array, and it may change when more entries are added or removed.
1179     *
1180     * Requirements:
1181     *
1182     * - `index` must be strictly less than {length}.
1183     */
1184     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1185         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1186 
1187         MapEntry storage entry = map._entries[index];
1188         return (entry._key, entry._value);
1189     }
1190 
1191     /**
1192      * @dev Tries to returns the value associated with `key`.  O(1).
1193      * Does not revert if `key` is not in the map.
1194      */
1195     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1196         uint256 keyIndex = map._indexes[key];
1197         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1198         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1199     }
1200 
1201     /**
1202      * @dev Returns the value associated with `key`.  O(1).
1203      *
1204      * Requirements:
1205      *
1206      * - `key` must be in the map.
1207      */
1208     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1209         uint256 keyIndex = map._indexes[key];
1210         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1211         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1212     }
1213 
1214     /**
1215      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1216      *
1217      * CAUTION: This function is deprecated because it requires allocating memory for the error
1218      * message unnecessarily. For custom revert reasons use {_tryGet}.
1219      */
1220     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1221         uint256 keyIndex = map._indexes[key];
1222         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1223         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1224     }
1225 
1226     // UintToAddressMap
1227 
1228     struct UintToAddressMap {
1229         Map _inner;
1230     }
1231 
1232     /**
1233      * @dev Adds a key-value pair to a map, or updates the value for an existing
1234      * key. O(1).
1235      *
1236      * Returns true if the key was added to the map, that is if it was not
1237      * already present.
1238      */
1239     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1240         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1241     }
1242 
1243     /**
1244      * @dev Removes a value from a set. O(1).
1245      *
1246      * Returns true if the key was removed from the map, that is if it was present.
1247      */
1248     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1249         return _remove(map._inner, bytes32(key));
1250     }
1251 
1252     /**
1253      * @dev Returns true if the key is in the map. O(1).
1254      */
1255     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1256         return _contains(map._inner, bytes32(key));
1257     }
1258 
1259     /**
1260      * @dev Returns the number of elements in the map. O(1).
1261      */
1262     function length(UintToAddressMap storage map) internal view returns (uint256) {
1263         return _length(map._inner);
1264     }
1265 
1266    /**
1267     * @dev Returns the element stored at position `index` in the set. O(1).
1268     * Note that there are no guarantees on the ordering of values inside the
1269     * array, and it may change when more values are added or removed.
1270     *
1271     * Requirements:
1272     *
1273     * - `index` must be strictly less than {length}.
1274     */
1275     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1276         (bytes32 key, bytes32 value) = _at(map._inner, index);
1277         return (uint256(key), address(uint160(uint256(value))));
1278     }
1279 
1280     /**
1281      * @dev Tries to returns the value associated with `key`.  O(1).
1282      * Does not revert if `key` is not in the map.
1283      *
1284      * _Available since v3.4._
1285      */
1286     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1287         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1288         return (success, address(uint160(uint256(value))));
1289     }
1290 
1291     /**
1292      * @dev Returns the value associated with `key`.  O(1).
1293      *
1294      * Requirements:
1295      *
1296      * - `key` must be in the map.
1297      */
1298     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1299         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1300     }
1301 
1302     /**
1303      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1304      *
1305      * CAUTION: This function is deprecated because it requires allocating memory for the error
1306      * message unnecessarily. For custom revert reasons use {tryGet}.
1307      */
1308     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1309         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1310     }
1311 }
1312 
1313 // 
1314 /**
1315  * @dev String operations.
1316  */
1317 library Strings {
1318     /**
1319      * @dev Converts a `uint256` to its ASCII `string` representation.
1320      */
1321     function toString(uint256 value) internal pure returns (string memory) {
1322         // Inspired by OraclizeAPI's implementation - MIT licence
1323         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1324 
1325         if (value == 0) {
1326             return "0";
1327         }
1328         uint256 temp = value;
1329         uint256 digits;
1330         while (temp != 0) {
1331             digits++;
1332             temp /= 10;
1333         }
1334         bytes memory buffer = new bytes(digits);
1335         uint256 index = digits - 1;
1336         temp = value;
1337         while (temp != 0) {
1338             buffer[index--] = bytes1(uint8(48 + temp % 10));
1339             temp /= 10;
1340         }
1341         return string(buffer);
1342     }
1343 }
1344 
1345 // 
1346 /**
1347  * @title ERC721 Non-Fungible Token Standard basic implementation
1348  * @dev see https://eips.ethereum.org/EIPS/eip-721
1349  */
1350 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1351     using SafeMath for uint256;
1352     using Address for address;
1353     using EnumerableSet for EnumerableSet.UintSet;
1354     using EnumerableMap for EnumerableMap.UintToAddressMap;
1355     using Strings for uint256;
1356 
1357     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1358     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1359     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1360 
1361     // Mapping from holder address to their (enumerable) set of owned tokens
1362     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1363 
1364     // Enumerable mapping from token ids to their owners
1365     EnumerableMap.UintToAddressMap private _tokenOwners;
1366 
1367     // Mapping from token ID to approved address
1368     mapping (uint256 => address) private _tokenApprovals;
1369 
1370     // Mapping from owner to operator approvals
1371     mapping (address => mapping (address => bool)) private _operatorApprovals;
1372 
1373     // Token name
1374     string private _name;
1375 
1376     // Token symbol
1377     string private _symbol;
1378 
1379     // Optional mapping for token URIs
1380     mapping (uint256 => string) private _tokenURIs;
1381 
1382     // Base URI
1383     string private _baseURI;
1384 
1385     /*
1386      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1387      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1388      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1389      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1390      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1391      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1392      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1393      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1394      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1395      *
1396      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1397      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1398      */
1399     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1400 
1401     /*
1402      *     bytes4(keccak256('name()')) == 0x06fdde03
1403      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1404      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1405      *
1406      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1407      */
1408     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1409 
1410     /*
1411      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1412      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1413      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1414      *
1415      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1416      */
1417     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1418 
1419     /**
1420      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1421      */
1422     constructor (string memory name_, string memory symbol_) public {
1423         _name = name_;
1424         _symbol = symbol_;
1425 
1426         // register the supported interfaces to conform to ERC721 via ERC165
1427         _registerInterface(_INTERFACE_ID_ERC721);
1428         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1429         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1430     }
1431 
1432     /**
1433      * @dev See {IERC721-balanceOf}.
1434      */
1435     function balanceOf(address owner) public view virtual override returns (uint256) {
1436         require(owner != address(0), "ERC721: balance query for the zero address");
1437         return _holderTokens[owner].length();
1438     }
1439 
1440     /**
1441      * @dev See {IERC721-ownerOf}.
1442      */
1443     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1444         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1445     }
1446 
1447     /**
1448      * @dev See {IERC721Metadata-name}.
1449      */
1450     function name() public view virtual override returns (string memory) {
1451         return _name;
1452     }
1453 
1454     /**
1455      * @dev See {IERC721Metadata-symbol}.
1456      */
1457     function symbol() public view virtual override returns (string memory) {
1458         return _symbol;
1459     }
1460 
1461     /**
1462      * @dev See {IERC721Metadata-tokenURI}.
1463      */
1464     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1465         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1466 
1467         string memory _tokenURI = _tokenURIs[tokenId];
1468         string memory base = baseURI();
1469 
1470         // If there is no base URI, return the token URI.
1471         if (bytes(base).length == 0) {
1472             return _tokenURI;
1473         }
1474         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1475         if (bytes(_tokenURI).length > 0) {
1476             return string(abi.encodePacked(base, _tokenURI));
1477         }
1478         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1479         return string(abi.encodePacked(base, tokenId.toString()));
1480     }
1481 
1482     /**
1483     * @dev Returns the base URI set via {_setBaseURI}. This will be
1484     * automatically added as a prefix in {tokenURI} to each token's URI, or
1485     * to the token ID if no specific URI is set for that token ID.
1486     */
1487     function baseURI() public view virtual returns (string memory) {
1488         return _baseURI;
1489     }
1490 
1491     /**
1492      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1493      */
1494     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1495         return _holderTokens[owner].at(index);
1496     }
1497 
1498     /**
1499      * @dev See {IERC721Enumerable-totalSupply}.
1500      */
1501     function totalSupply() public view virtual override returns (uint256) {
1502         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1503         return _tokenOwners.length();
1504     }
1505 
1506     /**
1507      * @dev See {IERC721Enumerable-tokenByIndex}.
1508      */
1509     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1510         (uint256 tokenId, ) = _tokenOwners.at(index);
1511         return tokenId;
1512     }
1513 
1514     /**
1515      * @dev See {IERC721-approve}.
1516      */
1517     function approve(address to, uint256 tokenId) public virtual override {
1518         address owner = ERC721.ownerOf(tokenId);
1519         require(to != owner, "ERC721: approval to current owner");
1520 
1521         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1522             "ERC721: approve caller is not owner nor approved for all"
1523         );
1524 
1525         _approve(to, tokenId);
1526     }
1527 
1528     /**
1529      * @dev See {IERC721-getApproved}.
1530      */
1531     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1532         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1533 
1534         return _tokenApprovals[tokenId];
1535     }
1536 
1537     /**
1538      * @dev See {IERC721-setApprovalForAll}.
1539      */
1540     function setApprovalForAll(address operator, bool approved) public virtual override {
1541         require(operator != _msgSender(), "ERC721: approve to caller");
1542 
1543         _operatorApprovals[_msgSender()][operator] = approved;
1544         emit ApprovalForAll(_msgSender(), operator, approved);
1545     }
1546 
1547     /**
1548      * @dev See {IERC721-isApprovedForAll}.
1549      */
1550     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1551         return _operatorApprovals[owner][operator];
1552     }
1553 
1554     /**
1555      * @dev See {IERC721-transferFrom}.
1556      */
1557     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1558         //solhint-disable-next-line max-line-length
1559         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1560 
1561         _transfer(from, to, tokenId);
1562     }
1563 
1564     /**
1565      * @dev See {IERC721-safeTransferFrom}.
1566      */
1567     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1568         safeTransferFrom(from, to, tokenId, "");
1569     }
1570 
1571     /**
1572      * @dev See {IERC721-safeTransferFrom}.
1573      */
1574     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1575         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1576         _safeTransfer(from, to, tokenId, _data);
1577     }
1578 
1579     /**
1580      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1581      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1582      *
1583      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1584      *
1585      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1586      * implement alternative mechanisms to perform token transfer, such as signature-based.
1587      *
1588      * Requirements:
1589      *
1590      * - `from` cannot be the zero address.
1591      * - `to` cannot be the zero address.
1592      * - `tokenId` token must exist and be owned by `from`.
1593      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1594      *
1595      * Emits a {Transfer} event.
1596      */
1597     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1598         _transfer(from, to, tokenId);
1599         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1600     }
1601 
1602     /**
1603      * @dev Returns whether `tokenId` exists.
1604      *
1605      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1606      *
1607      * Tokens start existing when they are minted (`_mint`),
1608      * and stop existing when they are burned (`_burn`).
1609      */
1610     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1611         return _tokenOwners.contains(tokenId);
1612     }
1613 
1614     /**
1615      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1616      *
1617      * Requirements:
1618      *
1619      * - `tokenId` must exist.
1620      */
1621     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1622         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1623         address owner = ERC721.ownerOf(tokenId);
1624         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1625     }
1626 
1627     /**
1628      * @dev Safely mints `tokenId` and transfers it to `to`.
1629      *
1630      * Requirements:
1631      d*
1632      * - `tokenId` must not exist.
1633      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1634      *
1635      * Emits a {Transfer} event.
1636      */
1637     function _safeMint(address to, uint256 tokenId) internal virtual {
1638         _safeMint(to, tokenId, "");
1639     }
1640 
1641     /**
1642      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1643      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1644      */
1645     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1646         _mint(to, tokenId);
1647         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1648     }
1649 
1650     /**
1651      * @dev Mints `tokenId` and transfers it to `to`.
1652      *
1653      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1654      *
1655      * Requirements:
1656      *
1657      * - `tokenId` must not exist.
1658      * - `to` cannot be the zero address.
1659      *
1660      * Emits a {Transfer} event.
1661      */
1662     function _mint(address to, uint256 tokenId) internal virtual {
1663         require(to != address(0), "ERC721: mint to the zero address");
1664         require(!_exists(tokenId), "ERC721: token already minted");
1665 
1666         _beforeTokenTransfer(address(0), to, tokenId);
1667 
1668         _holderTokens[to].add(tokenId);
1669 
1670         _tokenOwners.set(tokenId, to);
1671 
1672         emit Transfer(address(0), to, tokenId);
1673     }
1674 
1675     /**
1676      * @dev Destroys `tokenId`.
1677      * The approval is cleared when the token is burned.
1678      *
1679      * Requirements:
1680      *
1681      * - `tokenId` must exist.
1682      *
1683      * Emits a {Transfer} event.
1684      */
1685     function _burn(uint256 tokenId) internal virtual {
1686         address owner = ERC721.ownerOf(tokenId); // internal owner
1687 
1688         _beforeTokenTransfer(owner, address(0), tokenId);
1689 
1690         // Clear approvals
1691         _approve(address(0), tokenId);
1692 
1693         // Clear metadata (if any)
1694         if (bytes(_tokenURIs[tokenId]).length != 0) {
1695             delete _tokenURIs[tokenId];
1696         }
1697 
1698         _holderTokens[owner].remove(tokenId);
1699 
1700         _tokenOwners.remove(tokenId);
1701 
1702         emit Transfer(owner, address(0), tokenId);
1703     }
1704 
1705     /**
1706      * @dev Transfers `tokenId` from `from` to `to`.
1707      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1708      *
1709      * Requirements:
1710      *
1711      * - `to` cannot be the zero address.
1712      * - `tokenId` token must be owned by `from`.
1713      *
1714      * Emits a {Transfer} event.
1715      */
1716     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1717         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1718         require(to != address(0), "ERC721: transfer to the zero address");
1719 
1720         _beforeTokenTransfer(from, to, tokenId);
1721 
1722         // Clear approvals from the previous owner
1723         _approve(address(0), tokenId);
1724 
1725         _holderTokens[from].remove(tokenId);
1726         _holderTokens[to].add(tokenId);
1727 
1728         _tokenOwners.set(tokenId, to);
1729 
1730         emit Transfer(from, to, tokenId);
1731     }
1732 
1733     /**
1734      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1735      *
1736      * Requirements:
1737      *
1738      * - `tokenId` must exist.
1739      */
1740     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1741         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1742         _tokenURIs[tokenId] = _tokenURI;
1743     }
1744 
1745     /**
1746      * @dev Internal function to set the base URI for all token IDs. It is
1747      * automatically added as a prefix to the value returned in {tokenURI},
1748      * or to the token ID if {tokenURI} is empty.
1749      */
1750     function _setBaseURI(string memory baseURI_) internal virtual {
1751         _baseURI = baseURI_;
1752     }
1753 
1754     /**
1755      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1756      * The call is not executed if the target address is not a contract.
1757      *
1758      * @param from address representing the previous owner of the given token ID
1759      * @param to target address that will receive the tokens
1760      * @param tokenId uint256 ID of the token to be transferred
1761      * @param _data bytes optional data to send along with the call
1762      * @return bool whether the call correctly returned the expected magic value
1763      */
1764     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1765         private returns (bool)
1766     {
1767         if (!to.isContract()) {
1768             return true;
1769         }
1770         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1771             IERC721Receiver(to).onERC721Received.selector,
1772             _msgSender(),
1773             from,
1774             tokenId,
1775             _data
1776         ), "ERC721: transfer to non ERC721Receiver implementer");
1777         bytes4 retval = abi.decode(returndata, (bytes4));
1778         return (retval == _ERC721_RECEIVED);
1779     }
1780 
1781     function _approve(address to, uint256 tokenId) private {
1782         _tokenApprovals[tokenId] = to;
1783         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1784     }
1785 
1786     /**
1787      * @dev Hook that is called before any token transfer. This includes minting
1788      * and burning.
1789      *
1790      * Calling conditions:
1791      *
1792      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1793      * transferred to `to`.
1794      * - When `from` is zero, `tokenId` will be minted for `to`.
1795      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1796      * - `from` cannot be the zero address.
1797      * - `to` cannot be the zero address.
1798      *
1799      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1800      */
1801     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1802 }
1803 
1804 // 
1805 /**
1806  * @title Crypteriors contract
1807  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
1808  */
1809 contract NFToken is Ownable, ERC721 {
1810     using SafeMath for uint256;
1811 
1812     // This will hold the provenance hash for all Crypteriors artwork in existence
1813     string public  CRYPTERIORS_PROVENANCE = "";
1814 
1815     uint256 public constant MAX_NFT_SUPPLY = 11111;
1816 
1817     // Mapping if certain name string has already been reserved
1818     mapping(string => bool) private _nameReserved;
1819 
1820     uint256 public startingIndexBlock;
1821     uint256 public startingIndex;
1822 
1823     uint256 public constant SALE_START_TIMESTAMP = 1616864400;
1824     
1825     uint256 public constant REVEAL_TIMESTAMP =
1826         SALE_START_TIMESTAMP + (86400 * 10);
1827 
1828     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1829 
1830     // The title of the token
1831     mapping(uint256 => string) tokenTitles;
1832     mapping(uint256 => uint256) tokenTimes;
1833 
1834     // Sale status
1835     bool public hasSaleStarted = false;
1836 
1837     // Token name
1838     string private _name;
1839 
1840     // Token symbol
1841     string private _symbol;
1842  
1843     // Events
1844     event ArtChange(
1845         uint256 indexed tokenId,
1846         string newTitle,
1847         uint256 timestamp
1848     );
1849 
1850     // The event emitted (useable by web3) when a token is purchased
1851     event BoughtToken(address indexed buyer, uint256 tokenId);
1852 
1853     constructor(
1854         string memory name,
1855         string memory symbol,
1856         string memory baseURI,
1857         string memory provenanceHash
1858     ) ERC721(name, symbol) {
1859 
1860         _name = name;
1861         _symbol = symbol;
1862 
1863         setBaseURI(baseURI);
1864         setProvenanceHash(provenanceHash);
1865     }
1866     
1867     /**
1868      * @dev Mints Crypteriors 
1869      */
1870     function mintNFT(uint256 numberOfNfts) public payable {
1871         require(totalSupply() < MAX_NFT_SUPPLY, "Sale has already ended");
1872         require(numberOfNfts > 0, "numberOfNfts cannot be 0");
1873         require(
1874             numberOfNfts <= 20,
1875             "You may not buy more than 20 NFTs at once"
1876         );
1877         require(
1878             totalSupply().add(numberOfNfts) <= MAX_NFT_SUPPLY,
1879             "Exceeds MAX_NFT_SUPPLY"
1880         );
1881         require(
1882             getCurrentPrice().mul(numberOfNfts) == msg.value,
1883             "Ether value sent is not correct"
1884         );
1885 
1886         for (uint256 i = 0; i < numberOfNfts; i++) {
1887             uint256 mintIndex = totalSupply();
1888             if (totalSupply() < MAX_NFT_SUPPLY) {
1889                 _safeMint(msg.sender, mintIndex);
1890                 emit BoughtToken(msg.sender, mintIndex);
1891             }
1892         }
1893 
1894         /**
1895          * Source of randomness. Theoretical miner withhold manipulation possible but should be sufficient in a pragmatic sense
1896          */
1897         if (
1898             startingIndexBlock == 0 &&
1899             (totalSupply() == MAX_NFT_SUPPLY ||
1900                 block.timestamp >= REVEAL_TIMESTAMP)
1901         ) {
1902             startingIndexBlock = block.number;
1903         }
1904     }
1905 
1906     /**
1907      * @dev Finalize starting index
1908      */
1909     function finalizeStartingIndex() public {
1910         require(startingIndex == 0, "Starting index is already set");
1911         require(startingIndexBlock != 0, "Starting index block must be set");
1912 
1913         startingIndex = uint256(blockhash(startingIndexBlock)) % MAX_NFT_SUPPLY;
1914         // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
1915         if (block.number.sub(startingIndexBlock) > 255) {
1916             startingIndex =
1917                 uint256(blockhash(block.number - 1)) %
1918                 MAX_NFT_SUPPLY;
1919         }
1920         // Prevent default sequence
1921         if (startingIndex == 0) {
1922             startingIndex = startingIndex.add(1);
1923         }
1924     }
1925 
1926     function setBaseURI(string memory baseURI) public onlyOwner {
1927         _setBaseURI(baseURI);
1928     }
1929 
1930     function startSale() public onlyOwner {
1931         hasSaleStarted = true;
1932     }
1933 
1934     function pauseSale() public onlyOwner {
1935         hasSaleStarted = false;
1936     }
1937 
1938     function setProvenanceHash(string memory _hash) public onlyOwner {
1939         CRYPTERIORS_PROVENANCE = _hash;
1940     }
1941 
1942     function mintStartingIndexBlock() public onlyOwner {
1943         require(startingIndexBlock == 0, "Starting indexblock already mintend");
1944 
1945         if (
1946             startingIndexBlock == 0 
1947         ) {
1948             startingIndexBlock = block.number;
1949         }
1950     }
1951     /**
1952      * @dev Changes the name for tokenId
1953      */
1954     function changeArt(
1955         uint256 tokenId,
1956         string memory newRoomOwnerName,
1957         uint256 newTimeStamp
1958     ) public {
1959         address owner = ownerOf(tokenId);
1960 
1961         require(_msgSender() == owner, "ERC721: caller is not the owner");
1962         require(
1963             validateFutureTimestamp(newTimeStamp) == true,
1964             "Not a valid time"
1965         );
1966         require(validateName(newRoomOwnerName) == true, "Not a valid new name");
1967         require(
1968             sha256(bytes(newRoomOwnerName)) !=
1969                 sha256(bytes(tokenTitles[tokenId])),
1970             "New name is same as the current one"
1971         );
1972         require(
1973             isNameReserved(newRoomOwnerName) == false,
1974             "Name already taken"
1975         );
1976         require(bytes(tokenTitles[tokenId]).length == 0,
1977             "This Crypterior already has a name"
1978         );
1979     
1980         toggleReserveName(newRoomOwnerName, true);
1981         tokenTitles[tokenId] = newRoomOwnerName;
1982         tokenTimes[tokenId] = newTimeStamp;
1983 
1984         emit ArtChange(tokenId, newRoomOwnerName, newTimeStamp);
1985     }
1986 
1987     /**
1988      * @dev Returns if the name has been reserved.
1989      */
1990     function isNameReserved(string memory nameString)
1991         public
1992         view
1993         returns (bool)
1994     {
1995         return _nameReserved[toLower(nameString)];
1996     }
1997 
1998     /** 
1999     * @dev  Returns a list of all IDs assigned to an address.
2000     */
2001     function tokensOfOwner(address _owner)
2002         external
2003         view
2004         returns (uint256[] memory)
2005     {
2006         uint256 tokenCount = balanceOf(_owner);
2007 
2008         if (tokenCount == 0) {
2009             // Return an empty array
2010             return new uint256[](0);
2011         } else {
2012             uint256[] memory result = new uint256[](tokenCount);
2013             uint256 resultIndex = 0;
2014             uint256 tokenId;
2015 
2016             for (tokenId = 0; tokenId < totalSupply(); tokenId++) {
2017                 if (ownerOf(tokenId) == _owner) {
2018                     result[resultIndex] = tokenId;
2019                     resultIndex++;
2020                 }
2021             }
2022 
2023             return result;
2024         }
2025     }
2026 
2027     /// @dev Returns all the relevant information about a specific token
2028     /// @param _tokenId The ID of the token of interest
2029 
2030     function getToken(uint256 _tokenId)
2031         external
2032         view
2033         returns (
2034             string memory tokenTitle_,
2035             uint256 tokenTime_
2036         )
2037     {
2038         tokenTitle_ = tokenTitles[_tokenId];
2039         tokenTime_ = tokenTimes[_tokenId];
2040     }
2041 
2042     /// @dev Returns the current price for each token
2043     function getCurrentPrice() public view returns (uint256) {
2044         require(hasSaleStarted == true, "Sale has not started");
2045         require(totalSupply() < MAX_NFT_SUPPLY, "Sale has already ended");
2046 
2047         uint256 currentSupply = totalSupply();
2048        
2049         if (currentSupply >= 11100) {
2050             return 1500000000000000000;   // 11100 - 11111 1.5 ETH
2051         } else if (currentSupply >= 10500) {
2052             return  800000000000000000;   // 10500 - 11099 0.8 ETH
2053         } else if (currentSupply >= 6500) {
2054             return  500000000000000000;   // 6500 - 10499 0.5 ETH
2055         } else if (currentSupply >= 2500) {
2056             return  300000000000000000;   // 2500 - 6499 0.3 ETH
2057         } else if (currentSupply >= 1000) {
2058             return  150000000000000000;   // 1000 - 2499 0.15 ETH
2059         } else {
2060             return   75000000000000000;   // 0 - 999 0.075 ETH
2061         }     
2062 
2063     }
2064 
2065     /**
2066      * @dev Withdraw ether from this contract (Callable by owner)
2067      */
2068     function withdraw() public onlyOwner {
2069         require(payable(msg.sender).send(address(this).balance));
2070    } 
2071 
2072     // Reserved for people who helped this project and giveaways
2073     // Also to ensure everything works as expected, before the sale
2074     
2075     function reserveGiveaway(uint256 numNFTs) public onlyOwner {
2076         uint currentSupply = totalSupply();
2077         require(totalSupply().add(numNFTs) <= 30, "Exceeded giveaway supply");
2078         require(hasSaleStarted == false, "Sale has already started");
2079         uint256 index;
2080         for (index = 0; index < numNFTs; index++) {
2081             _safeMint(owner(), currentSupply + index);
2082         }
2083     }
2084 
2085     /**
2086      * @dev Reserves the name if isReserve is set to true, de-reserves if set to false
2087      */
2088     function toggleReserveName(string memory str, bool isReserve) internal {
2089         _nameReserved[toLower(str)] = isReserve;
2090     }
2091 
2092     function validateFutureTimestamp(uint256 timestamp)
2093         public
2094         view
2095         returns (bool)
2096     {
2097         if (timestamp < block.timestamp) {
2098             return false;
2099         }
2100         return true;
2101     }
2102 
2103     /**
2104      * @dev Check if the name string is valid (Alphanumeric and spaces without leading or trailing space)
2105      */
2106     function validateName(string memory str) public pure returns (bool) {
2107         bytes memory b = bytes(str);
2108         if (b.length < 1) return false;
2109         if (b.length > 25) return false; // Cannot be longer than 25 characters
2110         if (b[0] == 0x20) return false; // Leading space
2111         if (b[b.length - 1] == 0x20) return false; // Trailing space
2112 
2113         bytes1 lastChar = b[0];
2114 
2115         for (uint256 i; i < b.length; i++) {
2116             bytes1 char = b[i];
2117 
2118             if (char == 0x20 && lastChar == 0x20) return false; // Cannot contain continous spaces
2119 
2120             if (
2121                 !(char >= 0x30 && char <= 0x39) && //9-0
2122                 !(char >= 0x41 && char <= 0x5A) && //A-Z
2123                 !(char >= 0x61 && char <= 0x7A) && //a-z
2124                 !(char == 0x20) //space
2125             ) return false;
2126 
2127             lastChar = char;
2128         }
2129 
2130         return true;
2131     }
2132 
2133     /**
2134      * @dev Converts the string to lowercase
2135      */
2136     function toLower(string memory str) public pure returns (string memory) {
2137         bytes memory bStr = bytes(str);
2138         bytes memory bLower = new bytes(bStr.length);
2139         for (uint256 i = 0; i < bStr.length; i++) {
2140             // Uppercase character
2141             if ((uint8(bStr[i]) >= 65) && (uint8(bStr[i]) <= 90)) {
2142                 bLower[i] = bytes1(uint8(bStr[i]) + 32);
2143             } else {
2144                 bLower[i] = bStr[i];
2145             }
2146         }
2147         return string(bLower);
2148     }
2149 }