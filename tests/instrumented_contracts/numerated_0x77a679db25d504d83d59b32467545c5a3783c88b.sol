1 // Sources flattened with hardhat v2.3.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 
98 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.1
99 
100 /**
101  * @dev Interface of the ERC165 standard, as defined in the
102  * https://eips.ethereum.org/EIPS/eip-165[EIP].
103  *
104  * Implementers can declare support of contract interfaces, which can then be
105  * queried by others ({ERC165Checker}).
106  *
107  * For an implementation, see {ERC165}.
108  */
109 interface IERC165 {
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30 000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 }
120 
121 
122 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.1
123 
124 /**
125  * @dev Required interface of an ERC721 compliant contract.
126  */
127 interface IERC721 is IERC165 {
128     /**
129      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
130      */
131     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
135      */
136     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
140      */
141     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
142 
143     /**
144      * @dev Returns the number of tokens in ``owner``'s account.
145      */
146     function balanceOf(address owner) external view returns (uint256 balance);
147 
148     /**
149      * @dev Returns the owner of the `tokenId` token.
150      *
151      * Requirements:
152      *
153      * - `tokenId` must exist.
154      */
155     function ownerOf(uint256 tokenId) external view returns (address owner);
156 
157     /**
158      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
159      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
160      *
161      * Requirements:
162      *
163      * - `from` cannot be the zero address.
164      * - `to` cannot be the zero address.
165      * - `tokenId` token must exist and be owned by `from`.
166      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
167      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
168      *
169      * Emits a {Transfer} event.
170      */
171     function safeTransferFrom(address from, address to, uint256 tokenId) external;
172 
173     /**
174      * @dev Transfers `tokenId` token from `from` to `to`.
175      *
176      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
177      *
178      * Requirements:
179      *
180      * - `from` cannot be the zero address.
181      * - `to` cannot be the zero address.
182      * - `tokenId` token must be owned by `from`.
183      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(address from, address to, uint256 tokenId) external;
188 
189     /**
190      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
191      * The approval is cleared when the token is transferred.
192      *
193      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
194      *
195      * Requirements:
196      *
197      * - The caller must own the token or be an approved operator.
198      * - `tokenId` must exist.
199      *
200      * Emits an {Approval} event.
201      */
202     function approve(address to, uint256 tokenId) external;
203 
204     /**
205      * @dev Returns the account approved for `tokenId` token.
206      *
207      * Requirements:
208      *
209      * - `tokenId` must exist.
210      */
211     function getApproved(uint256 tokenId) external view returns (address operator);
212 
213     /**
214      * @dev Approve or remove `operator` as an operator for the caller.
215      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
216      *
217      * Requirements:
218      *
219      * - The `operator` cannot be the caller.
220      *
221      * Emits an {ApprovalForAll} event.
222      */
223     function setApprovalForAll(address operator, bool _approved) external;
224 
225     /**
226      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
227      *
228      * See {setApprovalForAll}
229      */
230     function isApprovedForAll(address owner, address operator) external view returns (bool);
231 
232     /**
233       * @dev Safely transfers `tokenId` token from `from` to `to`.
234       *
235       * Requirements:
236       *
237       * - `from` cannot be the zero address.
238       * - `to` cannot be the zero address.
239       * - `tokenId` token must exist and be owned by `from`.
240       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
241       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
242       *
243       * Emits a {Transfer} event.
244       */
245     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
246 }
247 
248 
249 // File @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol@v3.4.1
250 
251 /**
252  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
253  * @dev See https://eips.ethereum.org/EIPS/eip-721
254  */
255 interface IERC721Metadata is IERC721 {
256 
257     /**
258      * @dev Returns the token collection name.
259      */
260     function name() external view returns (string memory);
261 
262     /**
263      * @dev Returns the token collection symbol.
264      */
265     function symbol() external view returns (string memory);
266 
267     /**
268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
269      */
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 }
272 
273 
274 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.1
275 
276 /**
277  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
278  * @dev See https://eips.ethereum.org/EIPS/eip-721
279  */
280 interface IERC721Enumerable is IERC721 {
281 
282     /**
283      * @dev Returns the total amount of tokens stored by the contract.
284      */
285     function totalSupply() external view returns (uint256);
286 
287     /**
288      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
289      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
290      */
291     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
292 
293     /**
294      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
295      * Use along with {totalSupply} to enumerate all tokens.
296      */
297     function tokenByIndex(uint256 index) external view returns (uint256);
298 }
299 
300 
301 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v3.4.1
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
317      */
318     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
319 }
320 
321 
322 // File @openzeppelin/contracts/introspection/ERC165.sol@v3.4.1
323 
324 /**
325  * @dev Implementation of the {IERC165} interface.
326  *
327  * Contracts may inherit from this and call {_registerInterface} to declare
328  * their support of an interface.
329  */
330 abstract contract ERC165 is IERC165 {
331     /*
332      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
333      */
334     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
335 
336     /**
337      * @dev Mapping of interface ids to whether or not it's supported.
338      */
339     mapping(bytes4 => bool) private _supportedInterfaces;
340 
341     constructor () internal {
342         // Derived contracts need only register support for their own interfaces,
343         // we register support for ERC165 itself here
344         _registerInterface(_INTERFACE_ID_ERC165);
345     }
346 
347     /**
348      * @dev See {IERC165-supportsInterface}.
349      *
350      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
351      */
352     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
353         return _supportedInterfaces[interfaceId];
354     }
355 
356     /**
357      * @dev Registers the contract as an implementer of the interface defined by
358      * `interfaceId`. Support of the actual ERC165 interface is automatic and
359      * registering its interface id is not required.
360      *
361      * See {IERC165-supportsInterface}.
362      *
363      * Requirements:
364      *
365      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
366      */
367     function _registerInterface(bytes4 interfaceId) internal virtual {
368         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
369         _supportedInterfaces[interfaceId] = true;
370     }
371 }
372 
373 
374 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
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
587 
588 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
589 
590 /**
591  * @dev Collection of functions related to the address type
592  */
593 library Address {
594     /**
595      * @dev Returns true if `account` is a contract.
596      *
597      * [IMPORTANT]
598      * ====
599      * It is unsafe to assume that an address for which this function returns
600      * false is an externally-owned account (EOA) and not a contract.
601      *
602      * Among others, `isContract` will return false for the following
603      * types of addresses:
604      *
605      *  - an externally-owned account
606      *  - a contract in construction
607      *  - an address where a contract will be created
608      *  - an address where a contract lived, but was destroyed
609      * ====
610      */
611     function isContract(address account) internal view returns (bool) {
612         // This method relies on extcodesize, which returns 0 for contracts in
613         // construction, since the code is only stored at the end of the
614         // constructor execution.
615 
616         uint256 size;
617         // solhint-disable-next-line no-inline-assembly
618         assembly { size := extcodesize(account) }
619         return size > 0;
620     }
621 
622     /**
623      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
624      * `recipient`, forwarding all available gas and reverting on errors.
625      *
626      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
627      * of certain opcodes, possibly making contracts go over the 2300 gas limit
628      * imposed by `transfer`, making them unable to receive funds via
629      * `transfer`. {sendValue} removes this limitation.
630      *
631      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
632      *
633      * IMPORTANT: because control is transferred to `recipient`, care must be
634      * taken to not create reentrancy vulnerabilities. Consider using
635      * {ReentrancyGuard} or the
636      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
637      */
638     function sendValue(address payable recipient, uint256 amount) internal {
639         require(address(this).balance >= amount, "Address: insufficient balance");
640 
641         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
642         (bool success, ) = recipient.call{ value: amount }("");
643         require(success, "Address: unable to send value, recipient may have reverted");
644     }
645 
646     /**
647      * @dev Performs a Solidity function call using a low level `call`. A
648      * plain`call` is an unsafe replacement for a function call: use this
649      * function instead.
650      *
651      * If `target` reverts with a revert reason, it is bubbled up by this
652      * function (like regular Solidity function calls).
653      *
654      * Returns the raw returned data. To convert to the expected return value,
655      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
656      *
657      * Requirements:
658      *
659      * - `target` must be a contract.
660      * - calling `target` with `data` must not revert.
661      *
662      * _Available since v3.1._
663      */
664     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
665       return functionCall(target, data, "Address: low-level call failed");
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
670      * `errorMessage` as a fallback revert reason when `target` reverts.
671      *
672      * _Available since v3.1._
673      */
674     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
675         return functionCallWithValue(target, data, 0, errorMessage);
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
680      * but also transferring `value` wei to `target`.
681      *
682      * Requirements:
683      *
684      * - the calling contract must have an ETH balance of at least `value`.
685      * - the called Solidity function must be `payable`.
686      *
687      * _Available since v3.1._
688      */
689     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
690         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
695      * with `errorMessage` as a fallback revert reason when `target` reverts.
696      *
697      * _Available since v3.1._
698      */
699     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
700         require(address(this).balance >= value, "Address: insufficient balance for call");
701         require(isContract(target), "Address: call to non-contract");
702 
703         // solhint-disable-next-line avoid-low-level-calls
704         (bool success, bytes memory returndata) = target.call{ value: value }(data);
705         return _verifyCallResult(success, returndata, errorMessage);
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
710      * but performing a static call.
711      *
712      * _Available since v3.3._
713      */
714     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
715         return functionStaticCall(target, data, "Address: low-level static call failed");
716     }
717 
718     /**
719      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
720      * but performing a static call.
721      *
722      * _Available since v3.3._
723      */
724     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
725         require(isContract(target), "Address: static call to non-contract");
726 
727         // solhint-disable-next-line avoid-low-level-calls
728         (bool success, bytes memory returndata) = target.staticcall(data);
729         return _verifyCallResult(success, returndata, errorMessage);
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
734      * but performing a delegate call.
735      *
736      * _Available since v3.4._
737      */
738     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
739         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
744      * but performing a delegate call.
745      *
746      * _Available since v3.4._
747      */
748     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
749         require(isContract(target), "Address: delegate call to non-contract");
750 
751         // solhint-disable-next-line avoid-low-level-calls
752         (bool success, bytes memory returndata) = target.delegatecall(data);
753         return _verifyCallResult(success, returndata, errorMessage);
754     }
755 
756     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
757         if (success) {
758             return returndata;
759         } else {
760             // Look for revert reason and bubble it up if present
761             if (returndata.length > 0) {
762                 // The easiest way to bubble the revert reason is using memory via assembly
763 
764                 // solhint-disable-next-line no-inline-assembly
765                 assembly {
766                     let returndata_size := mload(returndata)
767                     revert(add(32, returndata), returndata_size)
768                 }
769             } else {
770                 revert(errorMessage);
771             }
772         }
773     }
774 }
775 
776 
777 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
778 
779 /**
780  * @dev Library for managing
781  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
782  * types.
783  *
784  * Sets have the following properties:
785  *
786  * - Elements are added, removed, and checked for existence in constant time
787  * (O(1)).
788  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
789  *
790  * ```
791  * contract Example {
792  *     // Add the library methods
793  *     using EnumerableSet for EnumerableSet.AddressSet;
794  *
795  *     // Declare a set state variable
796  *     EnumerableSet.AddressSet private mySet;
797  * }
798  * ```
799  *
800  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
801  * and `uint256` (`UintSet`) are supported.
802  */
803 library EnumerableSet {
804     // To implement this library for multiple types with as little code
805     // repetition as possible, we write it in terms of a generic Set type with
806     // bytes32 values.
807     // The Set implementation uses private functions, and user-facing
808     // implementations (such as AddressSet) are just wrappers around the
809     // underlying Set.
810     // This means that we can only create new EnumerableSets for types that fit
811     // in bytes32.
812 
813     struct Set {
814         // Storage of set values
815         bytes32[] _values;
816 
817         // Position of the value in the `values` array, plus 1 because index 0
818         // means a value is not in the set.
819         mapping (bytes32 => uint256) _indexes;
820     }
821 
822     /**
823      * @dev Add a value to a set. O(1).
824      *
825      * Returns true if the value was added to the set, that is if it was not
826      * already present.
827      */
828     function _add(Set storage set, bytes32 value) private returns (bool) {
829         if (!_contains(set, value)) {
830             set._values.push(value);
831             // The value is stored at length-1, but we add 1 to all indexes
832             // and use 0 as a sentinel value
833             set._indexes[value] = set._values.length;
834             return true;
835         } else {
836             return false;
837         }
838     }
839 
840     /**
841      * @dev Removes a value from a set. O(1).
842      *
843      * Returns true if the value was removed from the set, that is if it was
844      * present.
845      */
846     function _remove(Set storage set, bytes32 value) private returns (bool) {
847         // We read and store the value's index to prevent multiple reads from the same storage slot
848         uint256 valueIndex = set._indexes[value];
849 
850         if (valueIndex != 0) { // Equivalent to contains(set, value)
851             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
852             // the array, and then remove the last element (sometimes called as 'swap and pop').
853             // This modifies the order of the array, as noted in {at}.
854 
855             uint256 toDeleteIndex = valueIndex - 1;
856             uint256 lastIndex = set._values.length - 1;
857 
858             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
859             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
860 
861             bytes32 lastvalue = set._values[lastIndex];
862 
863             // Move the last value to the index where the value to delete is
864             set._values[toDeleteIndex] = lastvalue;
865             // Update the index for the moved value
866             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
867 
868             // Delete the slot where the moved value was stored
869             set._values.pop();
870 
871             // Delete the index for the deleted slot
872             delete set._indexes[value];
873 
874             return true;
875         } else {
876             return false;
877         }
878     }
879 
880     /**
881      * @dev Returns true if the value is in the set. O(1).
882      */
883     function _contains(Set storage set, bytes32 value) private view returns (bool) {
884         return set._indexes[value] != 0;
885     }
886 
887     /**
888      * @dev Returns the number of values on the set. O(1).
889      */
890     function _length(Set storage set) private view returns (uint256) {
891         return set._values.length;
892     }
893 
894    /**
895     * @dev Returns the value stored at position `index` in the set. O(1).
896     *
897     * Note that there are no guarantees on the ordering of values inside the
898     * array, and it may change when more values are added or removed.
899     *
900     * Requirements:
901     *
902     * - `index` must be strictly less than {length}.
903     */
904     function _at(Set storage set, uint256 index) private view returns (bytes32) {
905         require(set._values.length > index, "EnumerableSet: index out of bounds");
906         return set._values[index];
907     }
908 
909     // Bytes32Set
910 
911     struct Bytes32Set {
912         Set _inner;
913     }
914 
915     /**
916      * @dev Add a value to a set. O(1).
917      *
918      * Returns true if the value was added to the set, that is if it was not
919      * already present.
920      */
921     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
922         return _add(set._inner, value);
923     }
924 
925     /**
926      * @dev Removes a value from a set. O(1).
927      *
928      * Returns true if the value was removed from the set, that is if it was
929      * present.
930      */
931     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
932         return _remove(set._inner, value);
933     }
934 
935     /**
936      * @dev Returns true if the value is in the set. O(1).
937      */
938     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
939         return _contains(set._inner, value);
940     }
941 
942     /**
943      * @dev Returns the number of values in the set. O(1).
944      */
945     function length(Bytes32Set storage set) internal view returns (uint256) {
946         return _length(set._inner);
947     }
948 
949    /**
950     * @dev Returns the value stored at position `index` in the set. O(1).
951     *
952     * Note that there are no guarantees on the ordering of values inside the
953     * array, and it may change when more values are added or removed.
954     *
955     * Requirements:
956     *
957     * - `index` must be strictly less than {length}.
958     */
959     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
960         return _at(set._inner, index);
961     }
962 
963     // AddressSet
964 
965     struct AddressSet {
966         Set _inner;
967     }
968 
969     /**
970      * @dev Add a value to a set. O(1).
971      *
972      * Returns true if the value was added to the set, that is if it was not
973      * already present.
974      */
975     function add(AddressSet storage set, address value) internal returns (bool) {
976         return _add(set._inner, bytes32(uint256(uint160(value))));
977     }
978 
979     /**
980      * @dev Removes a value from a set. O(1).
981      *
982      * Returns true if the value was removed from the set, that is if it was
983      * present.
984      */
985     function remove(AddressSet storage set, address value) internal returns (bool) {
986         return _remove(set._inner, bytes32(uint256(uint160(value))));
987     }
988 
989     /**
990      * @dev Returns true if the value is in the set. O(1).
991      */
992     function contains(AddressSet storage set, address value) internal view returns (bool) {
993         return _contains(set._inner, bytes32(uint256(uint160(value))));
994     }
995 
996     /**
997      * @dev Returns the number of values in the set. O(1).
998      */
999     function length(AddressSet storage set) internal view returns (uint256) {
1000         return _length(set._inner);
1001     }
1002 
1003    /**
1004     * @dev Returns the value stored at position `index` in the set. O(1).
1005     *
1006     * Note that there are no guarantees on the ordering of values inside the
1007     * array, and it may change when more values are added or removed.
1008     *
1009     * Requirements:
1010     *
1011     * - `index` must be strictly less than {length}.
1012     */
1013     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1014         return address(uint160(uint256(_at(set._inner, index))));
1015     }
1016 
1017 
1018     // UintSet
1019 
1020     struct UintSet {
1021         Set _inner;
1022     }
1023 
1024     /**
1025      * @dev Add a value to a set. O(1).
1026      *
1027      * Returns true if the value was added to the set, that is if it was not
1028      * already present.
1029      */
1030     function add(UintSet storage set, uint256 value) internal returns (bool) {
1031         return _add(set._inner, bytes32(value));
1032     }
1033 
1034     /**
1035      * @dev Removes a value from a set. O(1).
1036      *
1037      * Returns true if the value was removed from the set, that is if it was
1038      * present.
1039      */
1040     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1041         return _remove(set._inner, bytes32(value));
1042     }
1043 
1044     /**
1045      * @dev Returns true if the value is in the set. O(1).
1046      */
1047     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1048         return _contains(set._inner, bytes32(value));
1049     }
1050 
1051     /**
1052      * @dev Returns the number of values on the set. O(1).
1053      */
1054     function length(UintSet storage set) internal view returns (uint256) {
1055         return _length(set._inner);
1056     }
1057 
1058    /**
1059     * @dev Returns the value stored at position `index` in the set. O(1).
1060     *
1061     * Note that there are no guarantees on the ordering of values inside the
1062     * array, and it may change when more values are added or removed.
1063     *
1064     * Requirements:
1065     *
1066     * - `index` must be strictly less than {length}.
1067     */
1068     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1069         return uint256(_at(set._inner, index));
1070     }
1071 }
1072 
1073 
1074 // File @openzeppelin/contracts/utils/EnumerableMap.sol@v3.4.1
1075 
1076 /**
1077  * @dev Library for managing an enumerable variant of Solidity's
1078  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1079  * type.
1080  *
1081  * Maps have the following properties:
1082  *
1083  * - Entries are added, removed, and checked for existence in constant time
1084  * (O(1)).
1085  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1086  *
1087  * ```
1088  * contract Example {
1089  *     // Add the library methods
1090  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1091  *
1092  *     // Declare a set state variable
1093  *     EnumerableMap.UintToAddressMap private myMap;
1094  * }
1095  * ```
1096  *
1097  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1098  * supported.
1099  */
1100 library EnumerableMap {
1101     // To implement this library for multiple types with as little code
1102     // repetition as possible, we write it in terms of a generic Map type with
1103     // bytes32 keys and values.
1104     // The Map implementation uses private functions, and user-facing
1105     // implementations (such as Uint256ToAddressMap) are just wrappers around
1106     // the underlying Map.
1107     // This means that we can only create new EnumerableMaps for types that fit
1108     // in bytes32.
1109 
1110     struct MapEntry {
1111         bytes32 _key;
1112         bytes32 _value;
1113     }
1114 
1115     struct Map {
1116         // Storage of map keys and values
1117         MapEntry[] _entries;
1118 
1119         // Position of the entry defined by a key in the `entries` array, plus 1
1120         // because index 0 means a key is not in the map.
1121         mapping (bytes32 => uint256) _indexes;
1122     }
1123 
1124     /**
1125      * @dev Adds a key-value pair to a map, or updates the value for an existing
1126      * key. O(1).
1127      *
1128      * Returns true if the key was added to the map, that is if it was not
1129      * already present.
1130      */
1131     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1132         // We read and store the key's index to prevent multiple reads from the same storage slot
1133         uint256 keyIndex = map._indexes[key];
1134 
1135         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1136             map._entries.push(MapEntry({ _key: key, _value: value }));
1137             // The entry is stored at length-1, but we add 1 to all indexes
1138             // and use 0 as a sentinel value
1139             map._indexes[key] = map._entries.length;
1140             return true;
1141         } else {
1142             map._entries[keyIndex - 1]._value = value;
1143             return false;
1144         }
1145     }
1146 
1147     /**
1148      * @dev Removes a key-value pair from a map. O(1).
1149      *
1150      * Returns true if the key was removed from the map, that is if it was present.
1151      */
1152     function _remove(Map storage map, bytes32 key) private returns (bool) {
1153         // We read and store the key's index to prevent multiple reads from the same storage slot
1154         uint256 keyIndex = map._indexes[key];
1155 
1156         if (keyIndex != 0) { // Equivalent to contains(map, key)
1157             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1158             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1159             // This modifies the order of the array, as noted in {at}.
1160 
1161             uint256 toDeleteIndex = keyIndex - 1;
1162             uint256 lastIndex = map._entries.length - 1;
1163 
1164             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1165             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1166 
1167             MapEntry storage lastEntry = map._entries[lastIndex];
1168 
1169             // Move the last entry to the index where the entry to delete is
1170             map._entries[toDeleteIndex] = lastEntry;
1171             // Update the index for the moved entry
1172             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1173 
1174             // Delete the slot where the moved entry was stored
1175             map._entries.pop();
1176 
1177             // Delete the index for the deleted slot
1178             delete map._indexes[key];
1179 
1180             return true;
1181         } else {
1182             return false;
1183         }
1184     }
1185 
1186     /**
1187      * @dev Returns true if the key is in the map. O(1).
1188      */
1189     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1190         return map._indexes[key] != 0;
1191     }
1192 
1193     /**
1194      * @dev Returns the number of key-value pairs in the map. O(1).
1195      */
1196     function _length(Map storage map) private view returns (uint256) {
1197         return map._entries.length;
1198     }
1199 
1200    /**
1201     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1202     *
1203     * Note that there are no guarantees on the ordering of entries inside the
1204     * array, and it may change when more entries are added or removed.
1205     *
1206     * Requirements:
1207     *
1208     * - `index` must be strictly less than {length}.
1209     */
1210     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1211         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1212 
1213         MapEntry storage entry = map._entries[index];
1214         return (entry._key, entry._value);
1215     }
1216 
1217     /**
1218      * @dev Tries to returns the value associated with `key`.  O(1).
1219      * Does not revert if `key` is not in the map.
1220      */
1221     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1222         uint256 keyIndex = map._indexes[key];
1223         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1224         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1225     }
1226 
1227     /**
1228      * @dev Returns the value associated with `key`.  O(1).
1229      *
1230      * Requirements:
1231      *
1232      * - `key` must be in the map.
1233      */
1234     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1235         uint256 keyIndex = map._indexes[key];
1236         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1237         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1238     }
1239 
1240     /**
1241      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1242      *
1243      * CAUTION: This function is deprecated because it requires allocating memory for the error
1244      * message unnecessarily. For custom revert reasons use {_tryGet}.
1245      */
1246     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1247         uint256 keyIndex = map._indexes[key];
1248         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1249         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1250     }
1251 
1252     // UintToAddressMap
1253 
1254     struct UintToAddressMap {
1255         Map _inner;
1256     }
1257 
1258     /**
1259      * @dev Adds a key-value pair to a map, or updates the value for an existing
1260      * key. O(1).
1261      *
1262      * Returns true if the key was added to the map, that is if it was not
1263      * already present.
1264      */
1265     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1266         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1267     }
1268 
1269     /**
1270      * @dev Removes a value from a set. O(1).
1271      *
1272      * Returns true if the key was removed from the map, that is if it was present.
1273      */
1274     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1275         return _remove(map._inner, bytes32(key));
1276     }
1277 
1278     /**
1279      * @dev Returns true if the key is in the map. O(1).
1280      */
1281     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1282         return _contains(map._inner, bytes32(key));
1283     }
1284 
1285     /**
1286      * @dev Returns the number of elements in the map. O(1).
1287      */
1288     function length(UintToAddressMap storage map) internal view returns (uint256) {
1289         return _length(map._inner);
1290     }
1291 
1292    /**
1293     * @dev Returns the element stored at position `index` in the set. O(1).
1294     * Note that there are no guarantees on the ordering of values inside the
1295     * array, and it may change when more values are added or removed.
1296     *
1297     * Requirements:
1298     *
1299     * - `index` must be strictly less than {length}.
1300     */
1301     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1302         (bytes32 key, bytes32 value) = _at(map._inner, index);
1303         return (uint256(key), address(uint160(uint256(value))));
1304     }
1305 
1306     /**
1307      * @dev Tries to returns the value associated with `key`.  O(1).
1308      * Does not revert if `key` is not in the map.
1309      *
1310      * _Available since v3.4._
1311      */
1312     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1313         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1314         return (success, address(uint160(uint256(value))));
1315     }
1316 
1317     /**
1318      * @dev Returns the value associated with `key`.  O(1).
1319      *
1320      * Requirements:
1321      *
1322      * - `key` must be in the map.
1323      */
1324     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1325         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1326     }
1327 
1328     /**
1329      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1330      *
1331      * CAUTION: This function is deprecated because it requires allocating memory for the error
1332      * message unnecessarily. For custom revert reasons use {tryGet}.
1333      */
1334     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1335         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1336     }
1337 }
1338 
1339 
1340 // File @openzeppelin/contracts/utils/Strings.sol@v3.4.1
1341 
1342 /**
1343  * @dev String operations.
1344  */
1345 library Strings {
1346     /**
1347      * @dev Converts a `uint256` to its ASCII `string` representation.
1348      */
1349     function toString(uint256 value) internal pure returns (string memory) {
1350         // Inspired by OraclizeAPI's implementation - MIT licence
1351         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1352 
1353         if (value == 0) {
1354             return "0";
1355         }
1356         uint256 temp = value;
1357         uint256 digits;
1358         while (temp != 0) {
1359             digits++;
1360             temp /= 10;
1361         }
1362         bytes memory buffer = new bytes(digits);
1363         uint256 index = digits - 1;
1364         temp = value;
1365         while (temp != 0) {
1366             buffer[index--] = bytes1(uint8(48 + temp % 10));
1367             temp /= 10;
1368         }
1369         return string(buffer);
1370     }
1371 }
1372 
1373 
1374 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v3.4.1
1375 
1376 /**
1377  * @title ERC721 Non-Fungible Token Standard basic implementation
1378  * @dev see https://eips.ethereum.org/EIPS/eip-721
1379  */
1380 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1381     using SafeMath for uint256;
1382     using Address for address;
1383     using EnumerableSet for EnumerableSet.UintSet;
1384     using EnumerableMap for EnumerableMap.UintToAddressMap;
1385     using Strings for uint256;
1386 
1387     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1388     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1389     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1390 
1391     // Mapping from holder address to their (enumerable) set of owned tokens
1392     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1393 
1394     // Enumerable mapping from token ids to their owners
1395     EnumerableMap.UintToAddressMap private _tokenOwners;
1396 
1397     // Mapping from token ID to approved address
1398     mapping (uint256 => address) private _tokenApprovals;
1399 
1400     // Mapping from owner to operator approvals
1401     mapping (address => mapping (address => bool)) private _operatorApprovals;
1402 
1403     // Token name
1404     string private _name;
1405 
1406     // Token symbol
1407     string private _symbol;
1408 
1409     // Optional mapping for token URIs
1410     mapping (uint256 => string) private _tokenURIs;
1411 
1412     // Base URI
1413     string private _baseURI;
1414 
1415     /*
1416      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1417      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1418      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1419      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1420      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1421      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1422      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1423      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1424      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1425      *
1426      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1427      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1428      */
1429     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1430 
1431     /*
1432      *     bytes4(keccak256('name()')) == 0x06fdde03
1433      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1434      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1435      *
1436      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1437      */
1438     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1439 
1440     /*
1441      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1442      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1443      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1444      *
1445      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1446      */
1447     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1448 
1449     /**
1450      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1451      */
1452     constructor (string memory name_, string memory symbol_) public {
1453         _name = name_;
1454         _symbol = symbol_;
1455 
1456         // register the supported interfaces to conform to ERC721 via ERC165
1457         _registerInterface(_INTERFACE_ID_ERC721);
1458         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1459         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1460     }
1461 
1462     /**
1463      * @dev See {IERC721-balanceOf}.
1464      */
1465     function balanceOf(address owner) public view virtual override returns (uint256) {
1466         require(owner != address(0), "ERC721: balance query for the zero address");
1467         return _holderTokens[owner].length();
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-ownerOf}.
1472      */
1473     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1474         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1475     }
1476 
1477     /**
1478      * @dev See {IERC721Metadata-name}.
1479      */
1480     function name() public view virtual override returns (string memory) {
1481         return _name;
1482     }
1483 
1484     /**
1485      * @dev See {IERC721Metadata-symbol}.
1486      */
1487     function symbol() public view virtual override returns (string memory) {
1488         return _symbol;
1489     }
1490 
1491     /**
1492      * @dev See {IERC721Metadata-tokenURI}.
1493      */
1494     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1495         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1496 
1497         string memory _tokenURI = _tokenURIs[tokenId];
1498         string memory base = baseURI();
1499 
1500         // If there is no base URI, return the token URI.
1501         if (bytes(base).length == 0) {
1502             return _tokenURI;
1503         }
1504         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1505         if (bytes(_tokenURI).length > 0) {
1506             return string(abi.encodePacked(base, _tokenURI));
1507         }
1508         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1509         return string(abi.encodePacked(base, tokenId.toString()));
1510     }
1511 
1512     /**
1513     * @dev Returns the base URI set via {_setBaseURI}. This will be
1514     * automatically added as a prefix in {tokenURI} to each token's URI, or
1515     * to the token ID if no specific URI is set for that token ID.
1516     */
1517     function baseURI() public view virtual returns (string memory) {
1518         return _baseURI;
1519     }
1520 
1521     /**
1522      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1523      */
1524     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1525         return _holderTokens[owner].at(index);
1526     }
1527 
1528     /**
1529      * @dev See {IERC721Enumerable-totalSupply}.
1530      */
1531     function totalSupply() public view virtual override returns (uint256) {
1532         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1533         return _tokenOwners.length();
1534     }
1535 
1536     /**
1537      * @dev See {IERC721Enumerable-tokenByIndex}.
1538      */
1539     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1540         (uint256 tokenId, ) = _tokenOwners.at(index);
1541         return tokenId;
1542     }
1543 
1544     /**
1545      * @dev See {IERC721-approve}.
1546      */
1547     function approve(address to, uint256 tokenId) public virtual override {
1548         address owner = ERC721.ownerOf(tokenId);
1549         require(to != owner, "ERC721: approval to current owner");
1550 
1551         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1552             "ERC721: approve caller is not owner nor approved for all"
1553         );
1554 
1555         _approve(to, tokenId);
1556     }
1557 
1558     /**
1559      * @dev See {IERC721-getApproved}.
1560      */
1561     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1562         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1563 
1564         return _tokenApprovals[tokenId];
1565     }
1566 
1567     /**
1568      * @dev See {IERC721-setApprovalForAll}.
1569      */
1570     function setApprovalForAll(address operator, bool approved) public virtual override {
1571         require(operator != _msgSender(), "ERC721: approve to caller");
1572 
1573         _operatorApprovals[_msgSender()][operator] = approved;
1574         emit ApprovalForAll(_msgSender(), operator, approved);
1575     }
1576 
1577     /**
1578      * @dev See {IERC721-isApprovedForAll}.
1579      */
1580     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1581         return _operatorApprovals[owner][operator];
1582     }
1583 
1584     /**
1585      * @dev See {IERC721-transferFrom}.
1586      */
1587     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1588         //solhint-disable-next-line max-line-length
1589         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1590 
1591         _transfer(from, to, tokenId);
1592     }
1593 
1594     /**
1595      * @dev See {IERC721-safeTransferFrom}.
1596      */
1597     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1598         safeTransferFrom(from, to, tokenId, "");
1599     }
1600 
1601     /**
1602      * @dev See {IERC721-safeTransferFrom}.
1603      */
1604     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1605         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1606         _safeTransfer(from, to, tokenId, _data);
1607     }
1608 
1609     /**
1610      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1611      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1612      *
1613      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1614      *
1615      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1616      * implement alternative mechanisms to perform token transfer, such as signature-based.
1617      *
1618      * Requirements:
1619      *
1620      * - `from` cannot be the zero address.
1621      * - `to` cannot be the zero address.
1622      * - `tokenId` token must exist and be owned by `from`.
1623      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1624      *
1625      * Emits a {Transfer} event.
1626      */
1627     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1628         _transfer(from, to, tokenId);
1629         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1630     }
1631 
1632     /**
1633      * @dev Returns whether `tokenId` exists.
1634      *
1635      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1636      *
1637      * Tokens start existing when they are minted (`_mint`),
1638      * and stop existing when they are burned (`_burn`).
1639      */
1640     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1641         return _tokenOwners.contains(tokenId);
1642     }
1643 
1644     /**
1645      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1646      *
1647      * Requirements:
1648      *
1649      * - `tokenId` must exist.
1650      */
1651     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1652         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1653         address owner = ERC721.ownerOf(tokenId);
1654         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1655     }
1656 
1657     /**
1658      * @dev Safely mints `tokenId` and transfers it to `to`.
1659      *
1660      * Requirements:
1661      d*
1662      * - `tokenId` must not exist.
1663      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1664      *
1665      * Emits a {Transfer} event.
1666      */
1667     function _safeMint(address to, uint256 tokenId) internal virtual {
1668         _safeMint(to, tokenId, "");
1669     }
1670 
1671     /**
1672      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1673      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1674      */
1675     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1676         _mint(to, tokenId);
1677         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1678     }
1679 
1680     /**
1681      * @dev Mints `tokenId` and transfers it to `to`.
1682      *
1683      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1684      *
1685      * Requirements:
1686      *
1687      * - `tokenId` must not exist.
1688      * - `to` cannot be the zero address.
1689      *
1690      * Emits a {Transfer} event.
1691      */
1692     function _mint(address to, uint256 tokenId) internal virtual {
1693         require(to != address(0), "ERC721: mint to the zero address");
1694         require(!_exists(tokenId), "ERC721: token already minted");
1695 
1696         _beforeTokenTransfer(address(0), to, tokenId);
1697 
1698         _holderTokens[to].add(tokenId);
1699 
1700         _tokenOwners.set(tokenId, to);
1701 
1702         emit Transfer(address(0), to, tokenId);
1703     }
1704 
1705     /**
1706      * @dev Destroys `tokenId`.
1707      * The approval is cleared when the token is burned.
1708      *
1709      * Requirements:
1710      *
1711      * - `tokenId` must exist.
1712      *
1713      * Emits a {Transfer} event.
1714      */
1715     function _burn(uint256 tokenId) internal virtual {
1716         address owner = ERC721.ownerOf(tokenId); // internal owner
1717 
1718         _beforeTokenTransfer(owner, address(0), tokenId);
1719 
1720         // Clear approvals
1721         _approve(address(0), tokenId);
1722 
1723         // Clear metadata (if any)
1724         if (bytes(_tokenURIs[tokenId]).length != 0) {
1725             delete _tokenURIs[tokenId];
1726         }
1727 
1728         _holderTokens[owner].remove(tokenId);
1729 
1730         _tokenOwners.remove(tokenId);
1731 
1732         emit Transfer(owner, address(0), tokenId);
1733     }
1734 
1735     /**
1736      * @dev Transfers `tokenId` from `from` to `to`.
1737      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1738      *
1739      * Requirements:
1740      *
1741      * - `to` cannot be the zero address.
1742      * - `tokenId` token must be owned by `from`.
1743      *
1744      * Emits a {Transfer} event.
1745      */
1746     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1747         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1748         require(to != address(0), "ERC721: transfer to the zero address");
1749 
1750         _beforeTokenTransfer(from, to, tokenId);
1751 
1752         // Clear approvals from the previous owner
1753         _approve(address(0), tokenId);
1754 
1755         _holderTokens[from].remove(tokenId);
1756         _holderTokens[to].add(tokenId);
1757 
1758         _tokenOwners.set(tokenId, to);
1759 
1760         emit Transfer(from, to, tokenId);
1761     }
1762 
1763     /**
1764      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1765      *
1766      * Requirements:
1767      *
1768      * - `tokenId` must exist.
1769      */
1770     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1771         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1772         _tokenURIs[tokenId] = _tokenURI;
1773     }
1774 
1775     /**
1776      * @dev Internal function to set the base URI for all token IDs. It is
1777      * automatically added as a prefix to the value returned in {tokenURI},
1778      * or to the token ID if {tokenURI} is empty.
1779      */
1780     function _setBaseURI(string memory baseURI_) internal virtual {
1781         _baseURI = baseURI_;
1782     }
1783 
1784     /**
1785      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1786      * The call is not executed if the target address is not a contract.
1787      *
1788      * @param from address representing the previous owner of the given token ID
1789      * @param to target address that will receive the tokens
1790      * @param tokenId uint256 ID of the token to be transferred
1791      * @param _data bytes optional data to send along with the call
1792      * @return bool whether the call correctly returned the expected magic value
1793      */
1794     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1795         private returns (bool)
1796     {
1797         if (!to.isContract()) {
1798             return true;
1799         }
1800         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1801             IERC721Receiver(to).onERC721Received.selector,
1802             _msgSender(),
1803             from,
1804             tokenId,
1805             _data
1806         ), "ERC721: transfer to non ERC721Receiver implementer");
1807         bytes4 retval = abi.decode(returndata, (bytes4));
1808         return (retval == _ERC721_RECEIVED);
1809     }
1810 
1811     /**
1812      * @dev Approve `to` to operate on `tokenId`
1813      *
1814      * Emits an {Approval} event.
1815      */
1816     function _approve(address to, uint256 tokenId) internal virtual {
1817         _tokenApprovals[tokenId] = to;
1818         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1819     }
1820 
1821     /**
1822      * @dev Hook that is called before any token transfer. This includes minting
1823      * and burning.
1824      *
1825      * Calling conditions:
1826      *
1827      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1828      * transferred to `to`.
1829      * - When `from` is zero, `tokenId` will be minted for `to`.
1830      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1831      * - `from` cannot be the zero address.
1832      * - `to` cannot be the zero address.
1833      *
1834      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1835      */
1836     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1837 }
1838 
1839 
1840 // File hardhat/console.sol@v2.3.0
1841 
1842 library console {
1843 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
1844 
1845 	function _sendLogPayload(bytes memory payload) private view {
1846 		uint256 payloadLength = payload.length;
1847 		address consoleAddress = CONSOLE_ADDRESS;
1848 		assembly {
1849 			let payloadStart := add(payload, 32)
1850 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
1851 		}
1852 	}
1853 
1854 	function log() internal view {
1855 		_sendLogPayload(abi.encodeWithSignature("log()"));
1856 	}
1857 
1858 	function logInt(int p0) internal view {
1859 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
1860 	}
1861 
1862 	function logUint(uint p0) internal view {
1863 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
1864 	}
1865 
1866 	function logString(string memory p0) internal view {
1867 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
1868 	}
1869 
1870 	function logBool(bool p0) internal view {
1871 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
1872 	}
1873 
1874 	function logAddress(address p0) internal view {
1875 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
1876 	}
1877 
1878 	function logBytes(bytes memory p0) internal view {
1879 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
1880 	}
1881 
1882 	function logBytes1(bytes1 p0) internal view {
1883 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
1884 	}
1885 
1886 	function logBytes2(bytes2 p0) internal view {
1887 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
1888 	}
1889 
1890 	function logBytes3(bytes3 p0) internal view {
1891 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
1892 	}
1893 
1894 	function logBytes4(bytes4 p0) internal view {
1895 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
1896 	}
1897 
1898 	function logBytes5(bytes5 p0) internal view {
1899 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
1900 	}
1901 
1902 	function logBytes6(bytes6 p0) internal view {
1903 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
1904 	}
1905 
1906 	function logBytes7(bytes7 p0) internal view {
1907 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
1908 	}
1909 
1910 	function logBytes8(bytes8 p0) internal view {
1911 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
1912 	}
1913 
1914 	function logBytes9(bytes9 p0) internal view {
1915 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
1916 	}
1917 
1918 	function logBytes10(bytes10 p0) internal view {
1919 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
1920 	}
1921 
1922 	function logBytes11(bytes11 p0) internal view {
1923 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
1924 	}
1925 
1926 	function logBytes12(bytes12 p0) internal view {
1927 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
1928 	}
1929 
1930 	function logBytes13(bytes13 p0) internal view {
1931 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
1932 	}
1933 
1934 	function logBytes14(bytes14 p0) internal view {
1935 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
1936 	}
1937 
1938 	function logBytes15(bytes15 p0) internal view {
1939 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
1940 	}
1941 
1942 	function logBytes16(bytes16 p0) internal view {
1943 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
1944 	}
1945 
1946 	function logBytes17(bytes17 p0) internal view {
1947 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
1948 	}
1949 
1950 	function logBytes18(bytes18 p0) internal view {
1951 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
1952 	}
1953 
1954 	function logBytes19(bytes19 p0) internal view {
1955 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
1956 	}
1957 
1958 	function logBytes20(bytes20 p0) internal view {
1959 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
1960 	}
1961 
1962 	function logBytes21(bytes21 p0) internal view {
1963 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
1964 	}
1965 
1966 	function logBytes22(bytes22 p0) internal view {
1967 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
1968 	}
1969 
1970 	function logBytes23(bytes23 p0) internal view {
1971 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
1972 	}
1973 
1974 	function logBytes24(bytes24 p0) internal view {
1975 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
1976 	}
1977 
1978 	function logBytes25(bytes25 p0) internal view {
1979 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
1980 	}
1981 
1982 	function logBytes26(bytes26 p0) internal view {
1983 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
1984 	}
1985 
1986 	function logBytes27(bytes27 p0) internal view {
1987 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
1988 	}
1989 
1990 	function logBytes28(bytes28 p0) internal view {
1991 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
1992 	}
1993 
1994 	function logBytes29(bytes29 p0) internal view {
1995 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
1996 	}
1997 
1998 	function logBytes30(bytes30 p0) internal view {
1999 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
2000 	}
2001 
2002 	function logBytes31(bytes31 p0) internal view {
2003 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
2004 	}
2005 
2006 	function logBytes32(bytes32 p0) internal view {
2007 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
2008 	}
2009 
2010 	function log(uint p0) internal view {
2011 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
2012 	}
2013 
2014 	function log(string memory p0) internal view {
2015 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
2016 	}
2017 
2018 	function log(bool p0) internal view {
2019 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
2020 	}
2021 
2022 	function log(address p0) internal view {
2023 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
2024 	}
2025 
2026 	function log(uint p0, uint p1) internal view {
2027 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
2028 	}
2029 
2030 	function log(uint p0, string memory p1) internal view {
2031 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
2032 	}
2033 
2034 	function log(uint p0, bool p1) internal view {
2035 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
2036 	}
2037 
2038 	function log(uint p0, address p1) internal view {
2039 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
2040 	}
2041 
2042 	function log(string memory p0, uint p1) internal view {
2043 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
2044 	}
2045 
2046 	function log(string memory p0, string memory p1) internal view {
2047 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
2048 	}
2049 
2050 	function log(string memory p0, bool p1) internal view {
2051 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
2052 	}
2053 
2054 	function log(string memory p0, address p1) internal view {
2055 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
2056 	}
2057 
2058 	function log(bool p0, uint p1) internal view {
2059 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
2060 	}
2061 
2062 	function log(bool p0, string memory p1) internal view {
2063 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
2064 	}
2065 
2066 	function log(bool p0, bool p1) internal view {
2067 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
2068 	}
2069 
2070 	function log(bool p0, address p1) internal view {
2071 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
2072 	}
2073 
2074 	function log(address p0, uint p1) internal view {
2075 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
2076 	}
2077 
2078 	function log(address p0, string memory p1) internal view {
2079 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
2080 	}
2081 
2082 	function log(address p0, bool p1) internal view {
2083 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
2084 	}
2085 
2086 	function log(address p0, address p1) internal view {
2087 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
2088 	}
2089 
2090 	function log(uint p0, uint p1, uint p2) internal view {
2091 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
2092 	}
2093 
2094 	function log(uint p0, uint p1, string memory p2) internal view {
2095 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
2096 	}
2097 
2098 	function log(uint p0, uint p1, bool p2) internal view {
2099 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
2100 	}
2101 
2102 	function log(uint p0, uint p1, address p2) internal view {
2103 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
2104 	}
2105 
2106 	function log(uint p0, string memory p1, uint p2) internal view {
2107 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
2108 	}
2109 
2110 	function log(uint p0, string memory p1, string memory p2) internal view {
2111 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
2112 	}
2113 
2114 	function log(uint p0, string memory p1, bool p2) internal view {
2115 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
2116 	}
2117 
2118 	function log(uint p0, string memory p1, address p2) internal view {
2119 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
2120 	}
2121 
2122 	function log(uint p0, bool p1, uint p2) internal view {
2123 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
2124 	}
2125 
2126 	function log(uint p0, bool p1, string memory p2) internal view {
2127 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
2128 	}
2129 
2130 	function log(uint p0, bool p1, bool p2) internal view {
2131 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
2132 	}
2133 
2134 	function log(uint p0, bool p1, address p2) internal view {
2135 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
2136 	}
2137 
2138 	function log(uint p0, address p1, uint p2) internal view {
2139 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
2140 	}
2141 
2142 	function log(uint p0, address p1, string memory p2) internal view {
2143 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
2144 	}
2145 
2146 	function log(uint p0, address p1, bool p2) internal view {
2147 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
2148 	}
2149 
2150 	function log(uint p0, address p1, address p2) internal view {
2151 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
2152 	}
2153 
2154 	function log(string memory p0, uint p1, uint p2) internal view {
2155 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
2156 	}
2157 
2158 	function log(string memory p0, uint p1, string memory p2) internal view {
2159 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
2160 	}
2161 
2162 	function log(string memory p0, uint p1, bool p2) internal view {
2163 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
2164 	}
2165 
2166 	function log(string memory p0, uint p1, address p2) internal view {
2167 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
2168 	}
2169 
2170 	function log(string memory p0, string memory p1, uint p2) internal view {
2171 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
2172 	}
2173 
2174 	function log(string memory p0, string memory p1, string memory p2) internal view {
2175 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
2176 	}
2177 
2178 	function log(string memory p0, string memory p1, bool p2) internal view {
2179 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
2180 	}
2181 
2182 	function log(string memory p0, string memory p1, address p2) internal view {
2183 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
2184 	}
2185 
2186 	function log(string memory p0, bool p1, uint p2) internal view {
2187 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
2188 	}
2189 
2190 	function log(string memory p0, bool p1, string memory p2) internal view {
2191 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
2192 	}
2193 
2194 	function log(string memory p0, bool p1, bool p2) internal view {
2195 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
2196 	}
2197 
2198 	function log(string memory p0, bool p1, address p2) internal view {
2199 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
2200 	}
2201 
2202 	function log(string memory p0, address p1, uint p2) internal view {
2203 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
2204 	}
2205 
2206 	function log(string memory p0, address p1, string memory p2) internal view {
2207 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
2208 	}
2209 
2210 	function log(string memory p0, address p1, bool p2) internal view {
2211 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
2212 	}
2213 
2214 	function log(string memory p0, address p1, address p2) internal view {
2215 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
2216 	}
2217 
2218 	function log(bool p0, uint p1, uint p2) internal view {
2219 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
2220 	}
2221 
2222 	function log(bool p0, uint p1, string memory p2) internal view {
2223 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
2224 	}
2225 
2226 	function log(bool p0, uint p1, bool p2) internal view {
2227 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
2228 	}
2229 
2230 	function log(bool p0, uint p1, address p2) internal view {
2231 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
2232 	}
2233 
2234 	function log(bool p0, string memory p1, uint p2) internal view {
2235 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
2236 	}
2237 
2238 	function log(bool p0, string memory p1, string memory p2) internal view {
2239 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
2240 	}
2241 
2242 	function log(bool p0, string memory p1, bool p2) internal view {
2243 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
2244 	}
2245 
2246 	function log(bool p0, string memory p1, address p2) internal view {
2247 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
2248 	}
2249 
2250 	function log(bool p0, bool p1, uint p2) internal view {
2251 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
2252 	}
2253 
2254 	function log(bool p0, bool p1, string memory p2) internal view {
2255 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
2256 	}
2257 
2258 	function log(bool p0, bool p1, bool p2) internal view {
2259 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
2260 	}
2261 
2262 	function log(bool p0, bool p1, address p2) internal view {
2263 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
2264 	}
2265 
2266 	function log(bool p0, address p1, uint p2) internal view {
2267 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
2268 	}
2269 
2270 	function log(bool p0, address p1, string memory p2) internal view {
2271 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
2272 	}
2273 
2274 	function log(bool p0, address p1, bool p2) internal view {
2275 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
2276 	}
2277 
2278 	function log(bool p0, address p1, address p2) internal view {
2279 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
2280 	}
2281 
2282 	function log(address p0, uint p1, uint p2) internal view {
2283 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
2284 	}
2285 
2286 	function log(address p0, uint p1, string memory p2) internal view {
2287 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
2288 	}
2289 
2290 	function log(address p0, uint p1, bool p2) internal view {
2291 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
2292 	}
2293 
2294 	function log(address p0, uint p1, address p2) internal view {
2295 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
2296 	}
2297 
2298 	function log(address p0, string memory p1, uint p2) internal view {
2299 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
2300 	}
2301 
2302 	function log(address p0, string memory p1, string memory p2) internal view {
2303 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
2304 	}
2305 
2306 	function log(address p0, string memory p1, bool p2) internal view {
2307 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
2308 	}
2309 
2310 	function log(address p0, string memory p1, address p2) internal view {
2311 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
2312 	}
2313 
2314 	function log(address p0, bool p1, uint p2) internal view {
2315 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
2316 	}
2317 
2318 	function log(address p0, bool p1, string memory p2) internal view {
2319 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
2320 	}
2321 
2322 	function log(address p0, bool p1, bool p2) internal view {
2323 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
2324 	}
2325 
2326 	function log(address p0, bool p1, address p2) internal view {
2327 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
2328 	}
2329 
2330 	function log(address p0, address p1, uint p2) internal view {
2331 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
2332 	}
2333 
2334 	function log(address p0, address p1, string memory p2) internal view {
2335 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2336 	}
2337 
2338 	function log(address p0, address p1, bool p2) internal view {
2339 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2340 	}
2341 
2342 	function log(address p0, address p1, address p2) internal view {
2343 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2344 	}
2345 
2346 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
2347 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
2348 	}
2349 
2350 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
2351 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
2352 	}
2353 
2354 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
2355 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
2356 	}
2357 
2358 	function log(uint p0, uint p1, uint p2, address p3) internal view {
2359 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
2360 	}
2361 
2362 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
2363 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
2364 	}
2365 
2366 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
2367 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
2368 	}
2369 
2370 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
2371 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
2372 	}
2373 
2374 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
2375 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
2376 	}
2377 
2378 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
2379 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
2380 	}
2381 
2382 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
2383 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
2384 	}
2385 
2386 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
2387 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
2388 	}
2389 
2390 	function log(uint p0, uint p1, bool p2, address p3) internal view {
2391 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
2392 	}
2393 
2394 	function log(uint p0, uint p1, address p2, uint p3) internal view {
2395 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
2396 	}
2397 
2398 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
2399 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
2400 	}
2401 
2402 	function log(uint p0, uint p1, address p2, bool p3) internal view {
2403 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
2404 	}
2405 
2406 	function log(uint p0, uint p1, address p2, address p3) internal view {
2407 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
2408 	}
2409 
2410 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
2411 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
2412 	}
2413 
2414 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
2415 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
2416 	}
2417 
2418 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
2419 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
2420 	}
2421 
2422 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
2423 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
2424 	}
2425 
2426 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
2427 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
2428 	}
2429 
2430 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
2431 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
2432 	}
2433 
2434 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
2435 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
2436 	}
2437 
2438 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
2439 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
2440 	}
2441 
2442 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
2443 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
2444 	}
2445 
2446 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
2447 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2448 	}
2449 
2450 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2451 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2452 	}
2453 
2454 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2455 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2456 	}
2457 
2458 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2459 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2460 	}
2461 
2462 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2463 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2464 	}
2465 
2466 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2467 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2468 	}
2469 
2470 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2471 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2472 	}
2473 
2474 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2475 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2476 	}
2477 
2478 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2479 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2480 	}
2481 
2482 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2483 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2484 	}
2485 
2486 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2487 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2488 	}
2489 
2490 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2491 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2492 	}
2493 
2494 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2495 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2496 	}
2497 
2498 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2499 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2500 	}
2501 
2502 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2503 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2504 	}
2505 
2506 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2507 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2508 	}
2509 
2510 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2511 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2512 	}
2513 
2514 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2515 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2516 	}
2517 
2518 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2519 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2520 	}
2521 
2522 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2523 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2524 	}
2525 
2526 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2527 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2528 	}
2529 
2530 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2531 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2532 	}
2533 
2534 	function log(uint p0, bool p1, address p2, address p3) internal view {
2535 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2536 	}
2537 
2538 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2539 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2540 	}
2541 
2542 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2543 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2544 	}
2545 
2546 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2547 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2548 	}
2549 
2550 	function log(uint p0, address p1, uint p2, address p3) internal view {
2551 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2552 	}
2553 
2554 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2555 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2556 	}
2557 
2558 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2559 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2560 	}
2561 
2562 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2563 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2564 	}
2565 
2566 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2567 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2568 	}
2569 
2570 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2571 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2572 	}
2573 
2574 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2575 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2576 	}
2577 
2578 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2579 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2580 	}
2581 
2582 	function log(uint p0, address p1, bool p2, address p3) internal view {
2583 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2584 	}
2585 
2586 	function log(uint p0, address p1, address p2, uint p3) internal view {
2587 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2588 	}
2589 
2590 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2591 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2592 	}
2593 
2594 	function log(uint p0, address p1, address p2, bool p3) internal view {
2595 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2596 	}
2597 
2598 	function log(uint p0, address p1, address p2, address p3) internal view {
2599 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2600 	}
2601 
2602 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2603 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2604 	}
2605 
2606 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2607 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2608 	}
2609 
2610 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2611 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2612 	}
2613 
2614 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2615 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2616 	}
2617 
2618 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2619 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2620 	}
2621 
2622 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2623 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2624 	}
2625 
2626 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2627 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2628 	}
2629 
2630 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2631 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2632 	}
2633 
2634 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2635 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2636 	}
2637 
2638 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2639 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2640 	}
2641 
2642 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2643 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2644 	}
2645 
2646 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2647 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2648 	}
2649 
2650 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2651 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2652 	}
2653 
2654 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2655 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2656 	}
2657 
2658 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2659 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2660 	}
2661 
2662 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2663 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2664 	}
2665 
2666 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2667 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2668 	}
2669 
2670 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2671 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2672 	}
2673 
2674 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2675 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2676 	}
2677 
2678 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2679 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2680 	}
2681 
2682 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2683 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2684 	}
2685 
2686 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2687 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2688 	}
2689 
2690 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2691 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2692 	}
2693 
2694 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2695 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2696 	}
2697 
2698 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2699 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2700 	}
2701 
2702 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2703 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2704 	}
2705 
2706 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2707 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2708 	}
2709 
2710 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2711 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2712 	}
2713 
2714 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2715 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2716 	}
2717 
2718 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2719 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2720 	}
2721 
2722 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2723 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2724 	}
2725 
2726 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2727 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2728 	}
2729 
2730 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2731 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2732 	}
2733 
2734 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2735 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2736 	}
2737 
2738 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2739 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2740 	}
2741 
2742 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2743 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2744 	}
2745 
2746 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2747 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2748 	}
2749 
2750 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2751 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2752 	}
2753 
2754 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2755 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2756 	}
2757 
2758 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2759 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2760 	}
2761 
2762 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
2763 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
2764 	}
2765 
2766 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
2767 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
2768 	}
2769 
2770 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
2771 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
2772 	}
2773 
2774 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
2775 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
2776 	}
2777 
2778 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
2779 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
2780 	}
2781 
2782 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
2783 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
2784 	}
2785 
2786 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
2787 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
2788 	}
2789 
2790 	function log(string memory p0, bool p1, address p2, address p3) internal view {
2791 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
2792 	}
2793 
2794 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
2795 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
2796 	}
2797 
2798 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
2799 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
2800 	}
2801 
2802 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
2803 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
2804 	}
2805 
2806 	function log(string memory p0, address p1, uint p2, address p3) internal view {
2807 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
2808 	}
2809 
2810 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
2811 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
2812 	}
2813 
2814 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
2815 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
2816 	}
2817 
2818 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
2819 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
2820 	}
2821 
2822 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
2823 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
2824 	}
2825 
2826 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
2827 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
2828 	}
2829 
2830 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
2831 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
2832 	}
2833 
2834 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
2835 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
2836 	}
2837 
2838 	function log(string memory p0, address p1, bool p2, address p3) internal view {
2839 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
2840 	}
2841 
2842 	function log(string memory p0, address p1, address p2, uint p3) internal view {
2843 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
2844 	}
2845 
2846 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
2847 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
2848 	}
2849 
2850 	function log(string memory p0, address p1, address p2, bool p3) internal view {
2851 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
2852 	}
2853 
2854 	function log(string memory p0, address p1, address p2, address p3) internal view {
2855 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
2856 	}
2857 
2858 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
2859 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
2860 	}
2861 
2862 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
2863 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
2864 	}
2865 
2866 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
2867 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
2868 	}
2869 
2870 	function log(bool p0, uint p1, uint p2, address p3) internal view {
2871 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
2872 	}
2873 
2874 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
2875 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
2876 	}
2877 
2878 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
2879 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
2880 	}
2881 
2882 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
2883 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
2884 	}
2885 
2886 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
2887 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
2888 	}
2889 
2890 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
2891 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
2892 	}
2893 
2894 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
2895 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
2896 	}
2897 
2898 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
2899 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
2900 	}
2901 
2902 	function log(bool p0, uint p1, bool p2, address p3) internal view {
2903 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
2904 	}
2905 
2906 	function log(bool p0, uint p1, address p2, uint p3) internal view {
2907 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
2908 	}
2909 
2910 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
2911 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
2912 	}
2913 
2914 	function log(bool p0, uint p1, address p2, bool p3) internal view {
2915 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
2916 	}
2917 
2918 	function log(bool p0, uint p1, address p2, address p3) internal view {
2919 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
2920 	}
2921 
2922 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
2923 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
2924 	}
2925 
2926 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
2927 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
2928 	}
2929 
2930 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
2931 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
2932 	}
2933 
2934 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
2935 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
2936 	}
2937 
2938 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
2939 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
2940 	}
2941 
2942 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
2943 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
2944 	}
2945 
2946 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
2947 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
2948 	}
2949 
2950 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
2951 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
2952 	}
2953 
2954 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
2955 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
2956 	}
2957 
2958 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
2959 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
2960 	}
2961 
2962 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
2963 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
2964 	}
2965 
2966 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
2967 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
2968 	}
2969 
2970 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
2971 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
2972 	}
2973 
2974 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
2975 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
2976 	}
2977 
2978 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
2979 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
2980 	}
2981 
2982 	function log(bool p0, string memory p1, address p2, address p3) internal view {
2983 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
2984 	}
2985 
2986 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
2987 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
2988 	}
2989 
2990 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
2991 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
2992 	}
2993 
2994 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
2995 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
2996 	}
2997 
2998 	function log(bool p0, bool p1, uint p2, address p3) internal view {
2999 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
3000 	}
3001 
3002 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
3003 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
3004 	}
3005 
3006 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
3007 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
3008 	}
3009 
3010 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
3011 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
3012 	}
3013 
3014 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
3015 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
3016 	}
3017 
3018 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
3019 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
3020 	}
3021 
3022 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
3023 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
3024 	}
3025 
3026 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
3027 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
3028 	}
3029 
3030 	function log(bool p0, bool p1, bool p2, address p3) internal view {
3031 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
3032 	}
3033 
3034 	function log(bool p0, bool p1, address p2, uint p3) internal view {
3035 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
3036 	}
3037 
3038 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
3039 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
3040 	}
3041 
3042 	function log(bool p0, bool p1, address p2, bool p3) internal view {
3043 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
3044 	}
3045 
3046 	function log(bool p0, bool p1, address p2, address p3) internal view {
3047 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
3048 	}
3049 
3050 	function log(bool p0, address p1, uint p2, uint p3) internal view {
3051 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
3052 	}
3053 
3054 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
3055 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
3056 	}
3057 
3058 	function log(bool p0, address p1, uint p2, bool p3) internal view {
3059 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
3060 	}
3061 
3062 	function log(bool p0, address p1, uint p2, address p3) internal view {
3063 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
3064 	}
3065 
3066 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
3067 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
3068 	}
3069 
3070 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
3071 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
3072 	}
3073 
3074 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
3075 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
3076 	}
3077 
3078 	function log(bool p0, address p1, string memory p2, address p3) internal view {
3079 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
3080 	}
3081 
3082 	function log(bool p0, address p1, bool p2, uint p3) internal view {
3083 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
3084 	}
3085 
3086 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
3087 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
3088 	}
3089 
3090 	function log(bool p0, address p1, bool p2, bool p3) internal view {
3091 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
3092 	}
3093 
3094 	function log(bool p0, address p1, bool p2, address p3) internal view {
3095 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
3096 	}
3097 
3098 	function log(bool p0, address p1, address p2, uint p3) internal view {
3099 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
3100 	}
3101 
3102 	function log(bool p0, address p1, address p2, string memory p3) internal view {
3103 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
3104 	}
3105 
3106 	function log(bool p0, address p1, address p2, bool p3) internal view {
3107 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
3108 	}
3109 
3110 	function log(bool p0, address p1, address p2, address p3) internal view {
3111 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
3112 	}
3113 
3114 	function log(address p0, uint p1, uint p2, uint p3) internal view {
3115 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
3116 	}
3117 
3118 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
3119 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
3120 	}
3121 
3122 	function log(address p0, uint p1, uint p2, bool p3) internal view {
3123 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
3124 	}
3125 
3126 	function log(address p0, uint p1, uint p2, address p3) internal view {
3127 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
3128 	}
3129 
3130 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
3131 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
3132 	}
3133 
3134 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
3135 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
3136 	}
3137 
3138 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
3139 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
3140 	}
3141 
3142 	function log(address p0, uint p1, string memory p2, address p3) internal view {
3143 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
3144 	}
3145 
3146 	function log(address p0, uint p1, bool p2, uint p3) internal view {
3147 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
3148 	}
3149 
3150 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
3151 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
3152 	}
3153 
3154 	function log(address p0, uint p1, bool p2, bool p3) internal view {
3155 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
3156 	}
3157 
3158 	function log(address p0, uint p1, bool p2, address p3) internal view {
3159 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
3160 	}
3161 
3162 	function log(address p0, uint p1, address p2, uint p3) internal view {
3163 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
3164 	}
3165 
3166 	function log(address p0, uint p1, address p2, string memory p3) internal view {
3167 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
3168 	}
3169 
3170 	function log(address p0, uint p1, address p2, bool p3) internal view {
3171 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
3172 	}
3173 
3174 	function log(address p0, uint p1, address p2, address p3) internal view {
3175 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
3176 	}
3177 
3178 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
3179 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
3180 	}
3181 
3182 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
3183 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
3184 	}
3185 
3186 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
3187 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
3188 	}
3189 
3190 	function log(address p0, string memory p1, uint p2, address p3) internal view {
3191 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
3192 	}
3193 
3194 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
3195 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
3196 	}
3197 
3198 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
3199 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
3200 	}
3201 
3202 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
3203 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
3204 	}
3205 
3206 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
3207 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
3208 	}
3209 
3210 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
3211 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
3212 	}
3213 
3214 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
3215 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
3216 	}
3217 
3218 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
3219 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
3220 	}
3221 
3222 	function log(address p0, string memory p1, bool p2, address p3) internal view {
3223 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
3224 	}
3225 
3226 	function log(address p0, string memory p1, address p2, uint p3) internal view {
3227 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
3228 	}
3229 
3230 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
3231 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
3232 	}
3233 
3234 	function log(address p0, string memory p1, address p2, bool p3) internal view {
3235 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
3236 	}
3237 
3238 	function log(address p0, string memory p1, address p2, address p3) internal view {
3239 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
3240 	}
3241 
3242 	function log(address p0, bool p1, uint p2, uint p3) internal view {
3243 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
3244 	}
3245 
3246 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
3247 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
3248 	}
3249 
3250 	function log(address p0, bool p1, uint p2, bool p3) internal view {
3251 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
3252 	}
3253 
3254 	function log(address p0, bool p1, uint p2, address p3) internal view {
3255 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
3256 	}
3257 
3258 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
3259 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
3260 	}
3261 
3262 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
3263 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
3264 	}
3265 
3266 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
3267 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
3268 	}
3269 
3270 	function log(address p0, bool p1, string memory p2, address p3) internal view {
3271 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
3272 	}
3273 
3274 	function log(address p0, bool p1, bool p2, uint p3) internal view {
3275 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
3276 	}
3277 
3278 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
3279 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
3280 	}
3281 
3282 	function log(address p0, bool p1, bool p2, bool p3) internal view {
3283 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
3284 	}
3285 
3286 	function log(address p0, bool p1, bool p2, address p3) internal view {
3287 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
3288 	}
3289 
3290 	function log(address p0, bool p1, address p2, uint p3) internal view {
3291 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
3292 	}
3293 
3294 	function log(address p0, bool p1, address p2, string memory p3) internal view {
3295 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
3296 	}
3297 
3298 	function log(address p0, bool p1, address p2, bool p3) internal view {
3299 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
3300 	}
3301 
3302 	function log(address p0, bool p1, address p2, address p3) internal view {
3303 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
3304 	}
3305 
3306 	function log(address p0, address p1, uint p2, uint p3) internal view {
3307 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
3308 	}
3309 
3310 	function log(address p0, address p1, uint p2, string memory p3) internal view {
3311 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
3312 	}
3313 
3314 	function log(address p0, address p1, uint p2, bool p3) internal view {
3315 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
3316 	}
3317 
3318 	function log(address p0, address p1, uint p2, address p3) internal view {
3319 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
3320 	}
3321 
3322 	function log(address p0, address p1, string memory p2, uint p3) internal view {
3323 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
3324 	}
3325 
3326 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
3327 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
3328 	}
3329 
3330 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3331 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3332 	}
3333 
3334 	function log(address p0, address p1, string memory p2, address p3) internal view {
3335 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3336 	}
3337 
3338 	function log(address p0, address p1, bool p2, uint p3) internal view {
3339 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
3340 	}
3341 
3342 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3343 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3344 	}
3345 
3346 	function log(address p0, address p1, bool p2, bool p3) internal view {
3347 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3348 	}
3349 
3350 	function log(address p0, address p1, bool p2, address p3) internal view {
3351 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3352 	}
3353 
3354 	function log(address p0, address p1, address p2, uint p3) internal view {
3355 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
3356 	}
3357 
3358 	function log(address p0, address p1, address p2, string memory p3) internal view {
3359 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3360 	}
3361 
3362 	function log(address p0, address p1, address p2, bool p3) internal view {
3363 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3364 	}
3365 
3366 	function log(address p0, address p1, address p2, address p3) internal view {
3367 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3368 	}
3369 
3370 }
3371 
3372 
3373 // File contracts/Anon.sol
3374 
3375 contract Anon is Ownable, ERC721 {
3376     using SafeMath for uint256;
3377 
3378     /**
3379      Tile related configurations
3380      */
3381 
3382     // Token IDs are from 0 to 10132
3383     uint256 internal constant ALL_TOKEN_NUM = 10133;
3384 
3385     /**
3386      Draw related configurations
3387      */
3388     
3389     // proof of state of all tiles
3390     string public constant SHA256 = "253762fe521a835df8726d8c614f0f7bbb86e67690b422e0c3556d7b4d5e146d";
3391 
3392     // Have 3 different draws
3393     uint256 internal constant ALL_DRAW_NUM = 3;
3394 
3395     // can draw 1 token, 5 tokens or 10 tokens together
3396     enum DrawLevel {One, Five, Ten}
3397 
3398     struct Draw {
3399         DrawLevel level;
3400         // the total price
3401         uint256 price;
3402         // how many tokens to get
3403         uint256 number;
3404     }
3405 
3406     Draw[ALL_DRAW_NUM] internal allDraws;
3407 
3408     /**
3409      Draw & Mint related stats
3410      */
3411 
3412     // how many tokens are sold
3413     uint256 internal soldNumber;
3414 
3415     // The user actions are enabled or not, default true
3416     bool internal enabled = true;
3417 
3418     // withdraw splits
3419     uint256 internal constant ALL_SLICE_NUM = 6;
3420 
3421     struct Slice {
3422         string name;
3423         address to;
3424         uint256 share; // percentage
3425     }
3426 
3427     Slice[ALL_SLICE_NUM] internal slices;
3428 
3429     // gift fund
3430     uint256 internal giftFund; // the remaining fund needs to send to giftFundAddress
3431 
3432     address internal giftFundAddress;
3433 
3434     /**
3435      Events
3436      */
3437 
3438     // Emit the event when user play the game
3439     event PlayRequestReceived(
3440         address indexed toAddress,
3441         uint256 indexed gameId,
3442         uint256 indexed encrypted
3443     );
3444 
3445     // Emit the event when user draw
3446     event TokenDrawn(string indexed uuid, uint256[] tokens);
3447 
3448     /**
3449      constructor
3450      */
3451 
3452     constructor(
3453         string memory _name,
3454         string memory _symbol
3455     ) public ERC721(_name, _symbol) {
3456         // init draw conf
3457         allDraws[0] = Draw({level: DrawLevel.One, price: 0.1 ether, number: 1});
3458         allDraws[1] = Draw({
3459             level: DrawLevel.Five,
3460             price: 0.45 ether,
3461             number: 5
3462         });
3463         allDraws[2] = Draw({level: DrawLevel.Ten, price: 0.8 ether, number: 10});
3464 
3465         // init withdraw splits
3466         slices[0] = Slice({name: "Anna", to: address(0x31ee1e6A5adf01d86CB5835c1FC08b8D3D547b4e), share: 27});
3467         slices[1] = Slice({name: "Elsa", to: address(0x8ee2DAdEfd72f17e35FDC85136C244f7EE05Dfa5), share: 20});
3468         slices[2] = Slice({name: "Mickey", to: address(0xa652b59F2b685564563556B54F8aD1F8Bec9Ea7b), share: 20});
3469         slices[3] = Slice({name: "Belle", to: address(0x0Cc7eb98B12E8483C3a5d64995d1543B22a9a9dB), share: 20});
3470         slices[4] = Slice({name: "Dumbo", to: address(0xb680073B79eFFcdf6F599B5614DCAC54568612fa), share: 12});
3471         slices[5] = Slice({name: "Goofy", to: address(0xE10012bC19838f43ee54CfD6a44293A2667b7F44), share: 1});
3472 
3473         // init gift funds
3474         giftFund = 60 ether;
3475         giftFundAddress = address(0x31C423e089EdF3748697408456EfA98836816AA7);
3476     }
3477 
3478     /**
3479      user facing functions
3480      */
3481 
3482     modifier onlyWhenEnabled() {
3483         require(enabled, "Contract is disabled, please come back later");
3484         _;
3485     }
3486 
3487     // user call this function to draw
3488     function draw(string memory uuid) public onlyWhenEnabled payable {
3489         uint256 number;
3490         for (uint256 i = 0; i < ALL_DRAW_NUM; i++) {
3491             if (allDraws[i].price == msg.value) {
3492                 number = allDraws[i].number;
3493                 break;
3494             }
3495         }
3496 
3497         require(
3498             number > 0,
3499             "Invalid price, please pay either 0.1 ETH for 1 draw or 0.45 ETH for 5 draws or 0.8 ETH for 10 draws"
3500         );
3501 
3502         uint256 newSoldNumber = soldNumber + number;
3503 
3504         require(newSoldNumber <= ALL_TOKEN_NUM, "Not enough supply");
3505 
3506         uint256[] memory tokens = new uint256[](number);
3507 
3508         for (uint256 i = 0; i < number; i++) {
3509             // tokenId is taken sequential
3510             uint256 tokenId = soldNumber + i;
3511             // mint the token immediately
3512             _mint(msg.sender, tokenId);
3513 
3514             tokens[i] = tokenId;
3515         }
3516 
3517         // update the sold number
3518         soldNumber = newSoldNumber;
3519 
3520         // Emit token drawn event
3521         emit TokenDrawn(uuid, tokens);
3522     }
3523 
3524     // user call this function to play
3525     function play(uint256 gameId, uint256 encrypted)
3526         public
3527         onlyWhenEnabled
3528     {
3529         emit PlayRequestReceived(msg.sender, gameId, encrypted);
3530     }
3531 
3532     /**
3533      OpenSea facing functions
3534      */
3535 
3536     function contractURI() public view returns (string memory) {
3537         string memory base = baseURI();
3538 
3539         // If there is no base URI, return the token URI.
3540         if (bytes(base).length == 0) {
3541             return "";
3542         }
3543         
3544         return string(abi.encodePacked(base, "opensea-metadata"));
3545     }
3546 
3547     /**
3548      admin facing functions
3549      */
3550 
3551     function setEnabled(bool _enabled) public onlyOwner {
3552         enabled = _enabled;
3553     }
3554 
3555     function _payout(address to, uint256 value) internal {
3556         (bool success, ) = to.call{value: value}("");
3557         require(success, "Payout failed");
3558     }
3559 
3560     function withdraw() public onlyOwner {
3561         uint256 amount = address(this).balance;
3562 
3563         // always payout to gift fund first
3564         if (giftFund > 0) {
3565             uint256 value;
3566             
3567             if (amount > giftFund) {
3568                 value = giftFund;
3569                 giftFund = 0;
3570             } else {
3571                 value = amount;
3572                 giftFund -= amount;
3573             }
3574 
3575             _payout(giftFundAddress, value);
3576             return;
3577         }
3578 
3579         // payout to slices if gift fund has already paid out
3580         uint256 paid = 0;
3581         // loop except the last one
3582         for (uint256 i = 0; i < ALL_SLICE_NUM - 1; i++) {
3583             uint256 value = amount * slices[i].share / 100;
3584             
3585             _payout(slices[i].to, value);
3586 
3587             paid += value;
3588         }
3589 
3590         // payout the remaining to the last slice
3591         //  - sum of percentages is 100, paying the remaining fund is the same
3592         //  - paying the remaining to avoid potential rounding bug
3593         _payout(slices[ALL_SLICE_NUM - 1].to, amount - paid);
3594     }
3595 
3596     function setBaseURI(string memory baseURI_) public onlyOwner {
3597         _setBaseURI(baseURI_);
3598     }
3599 }
3600 
3601 
3602 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
3603 
3604 /**
3605  * @dev Interface of the ERC20 standard as defined in the EIP.
3606  */
3607 interface IERC20 {
3608     /**
3609      * @dev Returns the amount of tokens in existence.
3610      */
3611     function totalSupply() external view returns (uint256);
3612 
3613     /**
3614      * @dev Returns the amount of tokens owned by `account`.
3615      */
3616     function balanceOf(address account) external view returns (uint256);
3617 
3618     /**
3619      * @dev Moves `amount` tokens from the caller's account to `recipient`.
3620      *
3621      * Returns a boolean value indicating whether the operation succeeded.
3622      *
3623      * Emits a {Transfer} event.
3624      */
3625     function transfer(address recipient, uint256 amount) external returns (bool);
3626 
3627     /**
3628      * @dev Returns the remaining number of tokens that `spender` will be
3629      * allowed to spend on behalf of `owner` through {transferFrom}. This is
3630      * zero by default.
3631      *
3632      * This value changes when {approve} or {transferFrom} are called.
3633      */
3634     function allowance(address owner, address spender) external view returns (uint256);
3635 
3636     /**
3637      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
3638      *
3639      * Returns a boolean value indicating whether the operation succeeded.
3640      *
3641      * IMPORTANT: Beware that changing an allowance with this method brings the risk
3642      * that someone may use both the old and the new allowance by unfortunate
3643      * transaction ordering. One possible solution to mitigate this race
3644      * condition is to first reduce the spender's allowance to 0 and set the
3645      * desired value afterwards:
3646      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
3647      *
3648      * Emits an {Approval} event.
3649      */
3650     function approve(address spender, uint256 amount) external returns (bool);
3651 
3652     /**
3653      * @dev Moves `amount` tokens from `sender` to `recipient` using the
3654      * allowance mechanism. `amount` is then deducted from the caller's
3655      * allowance.
3656      *
3657      * Returns a boolean value indicating whether the operation succeeded.
3658      *
3659      * Emits a {Transfer} event.
3660      */
3661     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
3662 
3663     /**
3664      * @dev Emitted when `value` tokens are moved from one account (`from`) to
3665      * another (`to`).
3666      *
3667      * Note that `value` may be zero.
3668      */
3669     event Transfer(address indexed from, address indexed to, uint256 value);
3670 
3671     /**
3672      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
3673      * a call to {approve}. `value` is the new allowance.
3674      */
3675     event Approval(address indexed owner, address indexed spender, uint256 value);
3676 }
3677 
3678 
3679 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
3680 
3681 /**
3682  * @dev Implementation of the {IERC20} interface.
3683  *
3684  * This implementation is agnostic to the way tokens are created. This means
3685  * that a supply mechanism has to be added in a derived contract using {_mint}.
3686  * For a generic mechanism see {ERC20PresetMinterPauser}.
3687  *
3688  * TIP: For a detailed writeup see our guide
3689  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
3690  * to implement supply mechanisms].
3691  *
3692  * We have followed general OpenZeppelin guidelines: functions revert instead
3693  * of returning `false` on failure. This behavior is nonetheless conventional
3694  * and does not conflict with the expectations of ERC20 applications.
3695  *
3696  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
3697  * This allows applications to reconstruct the allowance for all accounts just
3698  * by listening to said events. Other implementations of the EIP may not emit
3699  * these events, as it isn't required by the specification.
3700  *
3701  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
3702  * functions have been added to mitigate the well-known issues around setting
3703  * allowances. See {IERC20-approve}.
3704  */
3705 contract ERC20 is Context, IERC20 {
3706     using SafeMath for uint256;
3707 
3708     mapping (address => uint256) private _balances;
3709 
3710     mapping (address => mapping (address => uint256)) private _allowances;
3711 
3712     uint256 private _totalSupply;
3713 
3714     string private _name;
3715     string private _symbol;
3716     uint8 private _decimals;
3717 
3718     /**
3719      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
3720      * a default value of 18.
3721      *
3722      * To select a different value for {decimals}, use {_setupDecimals}.
3723      *
3724      * All three of these values are immutable: they can only be set once during
3725      * construction.
3726      */
3727     constructor (string memory name_, string memory symbol_) public {
3728         _name = name_;
3729         _symbol = symbol_;
3730         _decimals = 18;
3731     }
3732 
3733     /**
3734      * @dev Returns the name of the token.
3735      */
3736     function name() public view virtual returns (string memory) {
3737         return _name;
3738     }
3739 
3740     /**
3741      * @dev Returns the symbol of the token, usually a shorter version of the
3742      * name.
3743      */
3744     function symbol() public view virtual returns (string memory) {
3745         return _symbol;
3746     }
3747 
3748     /**
3749      * @dev Returns the number of decimals used to get its user representation.
3750      * For example, if `decimals` equals `2`, a balance of `505` tokens should
3751      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
3752      *
3753      * Tokens usually opt for a value of 18, imitating the relationship between
3754      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
3755      * called.
3756      *
3757      * NOTE: This information is only used for _display_ purposes: it in
3758      * no way affects any of the arithmetic of the contract, including
3759      * {IERC20-balanceOf} and {IERC20-transfer}.
3760      */
3761     function decimals() public view virtual returns (uint8) {
3762         return _decimals;
3763     }
3764 
3765     /**
3766      * @dev See {IERC20-totalSupply}.
3767      */
3768     function totalSupply() public view virtual override returns (uint256) {
3769         return _totalSupply;
3770     }
3771 
3772     /**
3773      * @dev See {IERC20-balanceOf}.
3774      */
3775     function balanceOf(address account) public view virtual override returns (uint256) {
3776         return _balances[account];
3777     }
3778 
3779     /**
3780      * @dev See {IERC20-transfer}.
3781      *
3782      * Requirements:
3783      *
3784      * - `recipient` cannot be the zero address.
3785      * - the caller must have a balance of at least `amount`.
3786      */
3787     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
3788         _transfer(_msgSender(), recipient, amount);
3789         return true;
3790     }
3791 
3792     /**
3793      * @dev See {IERC20-allowance}.
3794      */
3795     function allowance(address owner, address spender) public view virtual override returns (uint256) {
3796         return _allowances[owner][spender];
3797     }
3798 
3799     /**
3800      * @dev See {IERC20-approve}.
3801      *
3802      * Requirements:
3803      *
3804      * - `spender` cannot be the zero address.
3805      */
3806     function approve(address spender, uint256 amount) public virtual override returns (bool) {
3807         _approve(_msgSender(), spender, amount);
3808         return true;
3809     }
3810 
3811     /**
3812      * @dev See {IERC20-transferFrom}.
3813      *
3814      * Emits an {Approval} event indicating the updated allowance. This is not
3815      * required by the EIP. See the note at the beginning of {ERC20}.
3816      *
3817      * Requirements:
3818      *
3819      * - `sender` and `recipient` cannot be the zero address.
3820      * - `sender` must have a balance of at least `amount`.
3821      * - the caller must have allowance for ``sender``'s tokens of at least
3822      * `amount`.
3823      */
3824     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
3825         _transfer(sender, recipient, amount);
3826         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
3827         return true;
3828     }
3829 
3830     /**
3831      * @dev Atomically increases the allowance granted to `spender` by the caller.
3832      *
3833      * This is an alternative to {approve} that can be used as a mitigation for
3834      * problems described in {IERC20-approve}.
3835      *
3836      * Emits an {Approval} event indicating the updated allowance.
3837      *
3838      * Requirements:
3839      *
3840      * - `spender` cannot be the zero address.
3841      */
3842     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
3843         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
3844         return true;
3845     }
3846 
3847     /**
3848      * @dev Atomically decreases the allowance granted to `spender` by the caller.
3849      *
3850      * This is an alternative to {approve} that can be used as a mitigation for
3851      * problems described in {IERC20-approve}.
3852      *
3853      * Emits an {Approval} event indicating the updated allowance.
3854      *
3855      * Requirements:
3856      *
3857      * - `spender` cannot be the zero address.
3858      * - `spender` must have allowance for the caller of at least
3859      * `subtractedValue`.
3860      */
3861     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
3862         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
3863         return true;
3864     }
3865 
3866     /**
3867      * @dev Moves tokens `amount` from `sender` to `recipient`.
3868      *
3869      * This is internal function is equivalent to {transfer}, and can be used to
3870      * e.g. implement automatic token fees, slashing mechanisms, etc.
3871      *
3872      * Emits a {Transfer} event.
3873      *
3874      * Requirements:
3875      *
3876      * - `sender` cannot be the zero address.
3877      * - `recipient` cannot be the zero address.
3878      * - `sender` must have a balance of at least `amount`.
3879      */
3880     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
3881         require(sender != address(0), "ERC20: transfer from the zero address");
3882         require(recipient != address(0), "ERC20: transfer to the zero address");
3883 
3884         _beforeTokenTransfer(sender, recipient, amount);
3885 
3886         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
3887         _balances[recipient] = _balances[recipient].add(amount);
3888         emit Transfer(sender, recipient, amount);
3889     }
3890 
3891     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
3892      * the total supply.
3893      *
3894      * Emits a {Transfer} event with `from` set to the zero address.
3895      *
3896      * Requirements:
3897      *
3898      * - `to` cannot be the zero address.
3899      */
3900     function _mint(address account, uint256 amount) internal virtual {
3901         require(account != address(0), "ERC20: mint to the zero address");
3902 
3903         _beforeTokenTransfer(address(0), account, amount);
3904 
3905         _totalSupply = _totalSupply.add(amount);
3906         _balances[account] = _balances[account].add(amount);
3907         emit Transfer(address(0), account, amount);
3908     }
3909 
3910     /**
3911      * @dev Destroys `amount` tokens from `account`, reducing the
3912      * total supply.
3913      *
3914      * Emits a {Transfer} event with `to` set to the zero address.
3915      *
3916      * Requirements:
3917      *
3918      * - `account` cannot be the zero address.
3919      * - `account` must have at least `amount` tokens.
3920      */
3921     function _burn(address account, uint256 amount) internal virtual {
3922         require(account != address(0), "ERC20: burn from the zero address");
3923 
3924         _beforeTokenTransfer(account, address(0), amount);
3925 
3926         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
3927         _totalSupply = _totalSupply.sub(amount);
3928         emit Transfer(account, address(0), amount);
3929     }
3930 
3931     /**
3932      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
3933      *
3934      * This internal function is equivalent to `approve`, and can be used to
3935      * e.g. set automatic allowances for certain subsystems, etc.
3936      *
3937      * Emits an {Approval} event.
3938      *
3939      * Requirements:
3940      *
3941      * - `owner` cannot be the zero address.
3942      * - `spender` cannot be the zero address.
3943      */
3944     function _approve(address owner, address spender, uint256 amount) internal virtual {
3945         require(owner != address(0), "ERC20: approve from the zero address");
3946         require(spender != address(0), "ERC20: approve to the zero address");
3947 
3948         _allowances[owner][spender] = amount;
3949         emit Approval(owner, spender, amount);
3950     }
3951 
3952     /**
3953      * @dev Sets {decimals} to a value other than the default one of 18.
3954      *
3955      * WARNING: This function should only be called from the constructor. Most
3956      * applications that interact with token contracts will not expect
3957      * {decimals} to ever change, and may work incorrectly if it does.
3958      */
3959     function _setupDecimals(uint8 decimals_) internal virtual {
3960         _decimals = decimals_;
3961     }
3962 
3963     /**
3964      * @dev Hook that is called before any transfer of tokens. This includes
3965      * minting and burning.
3966      *
3967      * Calling conditions:
3968      *
3969      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
3970      * will be to transferred to `to`.
3971      * - when `from` is zero, `amount` tokens will be minted for `to`.
3972      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
3973      * - `from` and `to` are never both zero.
3974      *
3975      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
3976      */
3977     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
3978 }
3979 
3980 
3981 // File contracts/DummyERC20.sol
3982 
3983 contract DummyERC20 is ERC20 {
3984 
3985     constructor () public ERC20("Dummy ERC20", "DUMMY") {
3986         _mint(msg.sender, 10 * 10**6 * 10**18);
3987     }
3988 
3989 }
3990 
3991 
3992 // File contracts/DummyLINK.sol
3993 
3994 contract DummyLINK is ERC20 {
3995 
3996     constructor () public ERC20("Dummy LINK", "DUMMYLINK") {
3997         _mint(msg.sender, 10 * 10**6 * 10**18);
3998     }
3999 
4000     function decreaseApproval(address spender, uint256 subtractedValue) external returns (bool success) {
4001         return decreaseAllowance(spender, subtractedValue);
4002     }
4003 
4004     function increaseApproval(address spender, uint256 addedValue) external {
4005         increaseAllowance(spender, addedValue);
4006     }
4007 
4008     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool success) {
4009         transfer(to, value);
4010         return true;
4011     }
4012 
4013 }
4014 
4015 
4016 // File @chainlink/contracts/src/v0.6/interfaces/LinkTokenInterface.sol@v0.1.7
4017 
4018 interface LinkTokenInterface {
4019   function allowance(address owner, address spender) external view returns (uint256 remaining);
4020   function approve(address spender, uint256 value) external returns (bool success);
4021   function balanceOf(address owner) external view returns (uint256 balance);
4022   function decimals() external view returns (uint8 decimalPlaces);
4023   function decreaseApproval(address spender, uint256 addedValue) external returns (bool success);
4024   function increaseApproval(address spender, uint256 subtractedValue) external;
4025   function name() external view returns (string memory tokenName);
4026   function symbol() external view returns (string memory tokenSymbol);
4027   function totalSupply() external view returns (uint256 totalTokensIssued);
4028   function transfer(address to, uint256 value) external returns (bool success);
4029   function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool success);
4030   function transferFrom(address from, address to, uint256 value) external returns (bool success);
4031 }
4032 
4033 
4034 // File @chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol@v0.1.7
4035 
4036 /**
4037  * @dev Wrappers over Solidity's arithmetic operations with added overflow
4038  * checks.
4039  *
4040  * Arithmetic operations in Solidity wrap on overflow. This can easily result
4041  * in bugs, because programmers usually assume that an overflow raises an
4042  * error, which is the standard behavior in high level programming languages.
4043  * `SafeMath` restores this intuition by reverting the transaction when an
4044  * operation overflows.
4045  *
4046  * Using this library instead of the unchecked operations eliminates an entire
4047  * class of bugs, so it's recommended to use it always.
4048  */
4049 library SafeMathChainlink {
4050   /**
4051     * @dev Returns the addition of two unsigned integers, reverting on
4052     * overflow.
4053     *
4054     * Counterpart to Solidity's `+` operator.
4055     *
4056     * Requirements:
4057     * - Addition cannot overflow.
4058     */
4059   function add(uint256 a, uint256 b) internal pure returns (uint256) {
4060     uint256 c = a + b;
4061     require(c >= a, "SafeMath: addition overflow");
4062 
4063     return c;
4064   }
4065 
4066   /**
4067     * @dev Returns the subtraction of two unsigned integers, reverting on
4068     * overflow (when the result is negative).
4069     *
4070     * Counterpart to Solidity's `-` operator.
4071     *
4072     * Requirements:
4073     * - Subtraction cannot overflow.
4074     */
4075   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
4076     require(b <= a, "SafeMath: subtraction overflow");
4077     uint256 c = a - b;
4078 
4079     return c;
4080   }
4081 
4082   /**
4083     * @dev Returns the multiplication of two unsigned integers, reverting on
4084     * overflow.
4085     *
4086     * Counterpart to Solidity's `*` operator.
4087     *
4088     * Requirements:
4089     * - Multiplication cannot overflow.
4090     */
4091   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4092     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
4093     // benefit is lost if 'b' is also tested.
4094     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
4095     if (a == 0) {
4096       return 0;
4097     }
4098 
4099     uint256 c = a * b;
4100     require(c / a == b, "SafeMath: multiplication overflow");
4101 
4102     return c;
4103   }
4104 
4105   /**
4106     * @dev Returns the integer division of two unsigned integers. Reverts on
4107     * division by zero. The result is rounded towards zero.
4108     *
4109     * Counterpart to Solidity's `/` operator. Note: this function uses a
4110     * `revert` opcode (which leaves remaining gas untouched) while Solidity
4111     * uses an invalid opcode to revert (consuming all remaining gas).
4112     *
4113     * Requirements:
4114     * - The divisor cannot be zero.
4115     */
4116   function div(uint256 a, uint256 b) internal pure returns (uint256) {
4117     // Solidity only automatically asserts when dividing by 0
4118     require(b > 0, "SafeMath: division by zero");
4119     uint256 c = a / b;
4120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
4121 
4122     return c;
4123   }
4124 
4125   /**
4126     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
4127     * Reverts when dividing by zero.
4128     *
4129     * Counterpart to Solidity's `%` operator. This function uses a `revert`
4130     * opcode (which leaves remaining gas untouched) while Solidity uses an
4131     * invalid opcode to revert (consuming all remaining gas).
4132     *
4133     * Requirements:
4134     * - The divisor cannot be zero.
4135     */
4136   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
4137     require(b != 0, "SafeMath: modulo by zero");
4138     return a % b;
4139   }
4140 }
4141 
4142 
4143 // File @chainlink/contracts/src/v0.6/VRFRequestIDBase.sol@v0.1.7
4144 
4145 contract VRFRequestIDBase {
4146 
4147   /**
4148    * @notice returns the seed which is actually input to the VRF coordinator
4149    *
4150    * @dev To prevent repetition of VRF output due to repetition of the
4151    * @dev user-supplied seed, that seed is combined in a hash with the
4152    * @dev user-specific nonce, and the address of the consuming contract. The
4153    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
4154    * @dev the final seed, but the nonce does protect against repetition in
4155    * @dev requests which are included in a single block.
4156    *
4157    * @param _userSeed VRF seed input provided by user
4158    * @param _requester Address of the requesting contract
4159    * @param _nonce User-specific nonce at the time of the request
4160    */
4161   function makeVRFInputSeed(bytes32 _keyHash, uint256 _userSeed,
4162     address _requester, uint256 _nonce)
4163     internal pure returns (uint256)
4164   {
4165     return  uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
4166   }
4167 
4168   /**
4169    * @notice Returns the id for this request
4170    * @param _keyHash The serviceAgreement ID to be used for this request
4171    * @param _vRFInputSeed The seed to be passed directly to the VRF
4172    * @return The id for this request
4173    *
4174    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
4175    * @dev contract, but the one generated by makeVRFInputSeed
4176    */
4177   function makeRequestId(
4178     bytes32 _keyHash, uint256 _vRFInputSeed) internal pure returns (bytes32) {
4179     return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
4180   }
4181 }
4182 
4183 
4184 // File @chainlink/contracts/src/v0.6/VRFConsumerBase.sol@v0.1.7
4185 
4186 /** ****************************************************************************
4187  * @notice Interface for contracts using VRF randomness
4188  * *****************************************************************************
4189  * @dev PURPOSE
4190  *
4191  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
4192  * @dev to Vera the verifier in such a way that Vera can be sure he's not
4193  * @dev making his output up to suit himself. Reggie provides Vera a public key
4194  * @dev to which he knows the secret key. Each time Vera provides a seed to
4195  * @dev Reggie, he gives back a value which is computed completely
4196  * @dev deterministically from the seed and the secret key.
4197  *
4198  * @dev Reggie provides a proof by which Vera can verify that the output was
4199  * @dev correctly computed once Reggie tells it to her, but without that proof,
4200  * @dev the output is indistinguishable to her from a uniform random sample
4201  * @dev from the output space.
4202  *
4203  * @dev The purpose of this contract is to make it easy for unrelated contracts
4204  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
4205  * @dev simple access to a verifiable source of randomness.
4206  * *****************************************************************************
4207  * @dev USAGE
4208  *
4209  * @dev Calling contracts must inherit from VRFConsumerBase, and can
4210  * @dev initialize VRFConsumerBase's attributes in their constructor as
4211  * @dev shown:
4212  *
4213  * @dev   contract VRFConsumer {
4214  * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
4215  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
4216  * @dev         <initialization with other arguments goes here>
4217  * @dev       }
4218  * @dev   }
4219  *
4220  * @dev The oracle will have given you an ID for the VRF keypair they have
4221  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
4222  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
4223  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
4224  * @dev want to generate randomness from.
4225  *
4226  * @dev Once the VRFCoordinator has received and validated the oracle's response
4227  * @dev to your request, it will call your contract's fulfillRandomness method.
4228  *
4229  * @dev The randomness argument to fulfillRandomness is the actual random value
4230  * @dev generated from your seed.
4231  *
4232  * @dev The requestId argument is generated from the keyHash and the seed by
4233  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
4234  * @dev requests open, you can use the requestId to track which seed is
4235  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
4236  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
4237  * @dev if your contract could have multiple requests in flight simultaneously.)
4238  *
4239  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
4240  * @dev differ. (Which is critical to making unpredictable randomness! See the
4241  * @dev next section.)
4242  *
4243  * *****************************************************************************
4244  * @dev SECURITY CONSIDERATIONS
4245  *
4246  * @dev A method with the ability to call your fulfillRandomness method directly
4247  * @dev could spoof a VRF response with any random value, so it's critical that
4248  * @dev it cannot be directly called by anything other than this base contract
4249  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
4250  *
4251  * @dev For your users to trust that your contract's random behavior is free
4252  * @dev from malicious interference, it's best if you can write it so that all
4253  * @dev behaviors implied by a VRF response are executed *during* your
4254  * @dev fulfillRandomness method. If your contract must store the response (or
4255  * @dev anything derived from it) and use it later, you must ensure that any
4256  * @dev user-significant behavior which depends on that stored value cannot be
4257  * @dev manipulated by a subsequent VRF request.
4258  *
4259  * @dev Similarly, both miners and the VRF oracle itself have some influence
4260  * @dev over the order in which VRF responses appear on the blockchain, so if
4261  * @dev your contract could have multiple VRF requests in flight simultaneously,
4262  * @dev you must ensure that the order in which the VRF responses arrive cannot
4263  * @dev be used to manipulate your contract's user-significant behavior.
4264  *
4265  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
4266  * @dev block in which the request is made, user-provided seeds have no impact
4267  * @dev on its economic security properties. They are only included for API
4268  * @dev compatability with previous versions of this contract.
4269  *
4270  * @dev Since the block hash of the block which contains the requestRandomness
4271  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
4272  * @dev miner could, in principle, fork the blockchain to evict the block
4273  * @dev containing the request, forcing the request to be included in a
4274  * @dev different block with a different hash, and therefore a different input
4275  * @dev to the VRF. However, such an attack would incur a substantial economic
4276  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
4277  * @dev until it calls responds to a request.
4278  */
4279 abstract contract VRFConsumerBase is VRFRequestIDBase {
4280 
4281   using SafeMathChainlink for uint256;
4282 
4283   /**
4284    * @notice fulfillRandomness handles the VRF response. Your contract must
4285    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
4286    * @notice principles to keep in mind when implementing your fulfillRandomness
4287    * @notice method.
4288    *
4289    * @dev VRFConsumerBase expects its subcontracts to have a method with this
4290    * @dev signature, and will call it once it has verified the proof
4291    * @dev associated with the randomness. (It is triggered via a call to
4292    * @dev rawFulfillRandomness, below.)
4293    *
4294    * @param requestId The Id initially returned by requestRandomness
4295    * @param randomness the VRF output
4296    */
4297   function fulfillRandomness(bytes32 requestId, uint256 randomness)
4298     internal virtual;
4299 
4300   /**
4301    * @notice requestRandomness initiates a request for VRF output given _seed
4302    *
4303    * @dev The fulfillRandomness method receives the output, once it's provided
4304    * @dev by the Oracle, and verified by the vrfCoordinator.
4305    *
4306    * @dev The _keyHash must already be registered with the VRFCoordinator, and
4307    * @dev the _fee must exceed the fee specified during registration of the
4308    * @dev _keyHash.
4309    *
4310    * @dev The _seed parameter is vestigial, and is kept only for API
4311    * @dev compatibility with older versions. It can't *hurt* to mix in some of
4312    * @dev your own randomness, here, but it's not necessary because the VRF
4313    * @dev oracle will mix the hash of the block containing your request into the
4314    * @dev VRF seed it ultimately uses.
4315    *
4316    * @param _keyHash ID of public key against which randomness is generated
4317    * @param _fee The amount of LINK to send with the request
4318    * @param _seed seed mixed into the input of the VRF.
4319    *
4320    * @return requestId unique ID for this request
4321    *
4322    * @dev The returned requestId can be used to distinguish responses to
4323    * @dev concurrent requests. It is passed as the first argument to
4324    * @dev fulfillRandomness.
4325    */
4326   function requestRandomness(bytes32 _keyHash, uint256 _fee, uint256 _seed)
4327     internal returns (bytes32 requestId)
4328   {
4329     LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, _seed));
4330     // This is the seed passed to VRFCoordinator. The oracle will mix this with
4331     // the hash of the block containing this request to obtain the seed/input
4332     // which is finally passed to the VRF cryptographic machinery.
4333     uint256 vRFSeed  = makeVRFInputSeed(_keyHash, _seed, address(this), nonces[_keyHash]);
4334     // nonces[_keyHash] must stay in sync with
4335     // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
4336     // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
4337     // This provides protection against the user repeating their input seed,
4338     // which would result in a predictable/duplicate output, if multiple such
4339     // requests appeared in the same block.
4340     nonces[_keyHash] = nonces[_keyHash].add(1);
4341     return makeRequestId(_keyHash, vRFSeed);
4342   }
4343 
4344   LinkTokenInterface immutable internal LINK;
4345   address immutable private vrfCoordinator;
4346 
4347   // Nonces for each VRF key from which randomness has been requested.
4348   //
4349   // Must stay in sync with VRFCoordinator[_keyHash][this]
4350   mapping(bytes32 /* keyHash */ => uint256 /* nonce */) private nonces;
4351 
4352   /**
4353    * @param _vrfCoordinator address of VRFCoordinator contract
4354    * @param _link address of LINK token contract
4355    *
4356    * @dev https://docs.chain.link/docs/link-token-contracts
4357    */
4358   constructor(address _vrfCoordinator, address _link) public {
4359     vrfCoordinator = _vrfCoordinator;
4360     LINK = LinkTokenInterface(_link);
4361   }
4362 
4363   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
4364   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
4365   // the origin of the call
4366   function rawFulfillRandomness(bytes32 requestId, uint256 randomness) external {
4367     require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
4368     fulfillRandomness(requestId, randomness);
4369   }
4370 }
4371 
4372 
4373 // File contracts/DummyVRF.sol
4374 
4375 contract DummyVRF {
4376 
4377     LinkTokenInterface public LINK;
4378 
4379     event RandomnessRequest(address indexed sender, bytes32 indexed keyHash, uint256 indexed seed);
4380 
4381     constructor(address linkAddress) public {
4382         LINK = LinkTokenInterface(linkAddress);
4383     }
4384 
4385     function onTokenTransfer(address sender, uint256 fee, bytes memory _data)
4386         public
4387     {
4388         (bytes32 keyHash, uint256 seed) = abi.decode(_data, (bytes32, uint256));
4389         emit RandomnessRequest(sender, keyHash, seed);
4390     }
4391 
4392     function callBackWithRandomness(
4393         bytes32 requestId,
4394         uint256 randomness,
4395         address consumerContract
4396     ) public {
4397         VRFConsumerBase v;
4398         bytes memory resp = abi.encodeWithSelector(v.rawFulfillRandomness.selector, requestId, randomness);
4399         uint256 b = 206000;
4400         require(gasleft() >= b, "not enough gas for consumer");
4401         (bool success,) = consumerContract.call(resp);
4402     }
4403 
4404 }
4405 
4406 
4407 // File contracts/OpenSeaMatic.sol
4408 
4409 /**
4410  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/ContextMixin.sol
4411  */
4412 abstract contract ContextMixin {
4413     function msgSender()
4414         internal
4415         view
4416         returns (address payable sender)
4417     {
4418         if (msg.sender == address(this)) {
4419             bytes memory array = msg.data;
4420             uint256 index = msg.data.length;
4421             assembly {
4422                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
4423                 sender := and(
4424                     mload(add(array, index)),
4425                     0xffffffffffffffffffffffffffffffffffffffff
4426                 )
4427             }
4428         } else {
4429             sender = msg.sender;
4430         }
4431         return sender;
4432     }
4433 }
4434 
4435 /**
4436  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/Initializable.sol
4437  */
4438 contract Initializable {
4439     bool inited = false;
4440 
4441     modifier initializer() {
4442         require(!inited, "already inited");
4443         _;
4444         inited = true;
4445     }
4446 }
4447 
4448 /**
4449  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/EIP712Base.sol
4450  */
4451 contract EIP712Base is Initializable {
4452     struct EIP712Domain {
4453         string name;
4454         string version;
4455         address verifyingContract;
4456         bytes32 salt;
4457     }
4458 
4459     string constant public ERC712_VERSION = "1";
4460 
4461     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
4462         bytes(
4463             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
4464         )
4465     );
4466     bytes32 internal domainSeperator;
4467 
4468     // supposed to be called once while initializing.
4469     // one of the contractsa that inherits this contract follows proxy pattern
4470     // so it is not possible to do this in a constructor
4471     function _initializeEIP712(
4472         string memory name
4473     )
4474         internal
4475         initializer
4476     {
4477         _setDomainSeperator(name);
4478     }
4479 
4480     function _setDomainSeperator(string memory name) internal {
4481         domainSeperator = keccak256(
4482             abi.encode(
4483                 EIP712_DOMAIN_TYPEHASH,
4484                 keccak256(bytes(name)),
4485                 keccak256(bytes(ERC712_VERSION)),
4486                 address(this),
4487                 bytes32(getChainId())
4488             )
4489         );
4490     }
4491 
4492     function getDomainSeperator() public view returns (bytes32) {
4493         return domainSeperator;
4494     }
4495 
4496     function getChainId() public pure returns (uint256) {
4497         uint256 id;
4498         assembly {
4499             id := chainid()
4500         }
4501         return id;
4502     }
4503 
4504     /**
4505      * Accept message hash and returns hash message in EIP712 compatible form
4506      * So that it can be used to recover signer from signature signed using EIP712 formatted data
4507      * https://eips.ethereum.org/EIPS/eip-712
4508      * "\\x19" makes the encoding deterministic
4509      * "\\x01" is the version byte to make it compatible to EIP-191
4510      */
4511     function toTypedMessageHash(bytes32 messageHash)
4512         internal
4513         view
4514         returns (bytes32)
4515     {
4516         return
4517             keccak256(
4518                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
4519             );
4520     }
4521 }
4522 
4523 /**
4524  * https://github.com/maticnetwork/pos-portal/blob/master/contracts/common/NativeMetaTransaction.sol
4525  */
4526 contract NativeMetaTransaction is EIP712Base {
4527     using SafeMath for uint256;
4528     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
4529         bytes(
4530             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
4531         )
4532     );
4533     event MetaTransactionExecuted(
4534         address userAddress,
4535         address payable relayerAddress,
4536         bytes functionSignature
4537     );
4538     mapping(address => uint256) nonces;
4539 
4540     /*
4541      * Meta transaction structure.
4542      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
4543      * He should call the desired function directly in that case.
4544      */
4545     struct MetaTransaction {
4546         uint256 nonce;
4547         address from;
4548         bytes functionSignature;
4549     }
4550 
4551     function executeMetaTransaction(
4552         address userAddress,
4553         bytes memory functionSignature,
4554         bytes32 sigR,
4555         bytes32 sigS,
4556         uint8 sigV
4557     ) public payable returns (bytes memory) {
4558         MetaTransaction memory metaTx = MetaTransaction({
4559             nonce: nonces[userAddress],
4560             from: userAddress,
4561             functionSignature: functionSignature
4562         });
4563         require(
4564             verify(userAddress, metaTx, sigR, sigS, sigV),
4565             "Signer and signature do not match"
4566         );
4567 
4568         // increase nonce for user (to avoid re-use)
4569         nonces[userAddress] = nonces[userAddress].add(1);
4570 
4571         emit MetaTransactionExecuted(
4572             userAddress,
4573             msg.sender,
4574             functionSignature
4575         );
4576 
4577         // Append userAddress and relayer address at the end to extract it from calling context
4578         (bool success, bytes memory returnData) = address(this).call(
4579             abi.encodePacked(functionSignature, userAddress)
4580         );
4581         require(success, "Function call not successful");
4582 
4583         return returnData;
4584     }
4585 
4586     function hashMetaTransaction(MetaTransaction memory metaTx)
4587         internal
4588         pure
4589         returns (bytes32)
4590     {
4591         return
4592             keccak256(
4593                 abi.encode(
4594                     META_TRANSACTION_TYPEHASH,
4595                     metaTx.nonce,
4596                     metaTx.from,
4597                     keccak256(metaTx.functionSignature)
4598                 )
4599             );
4600     }
4601 
4602     function getNonce(address user) public view returns (uint256 nonce) {
4603         nonce = nonces[user];
4604     }
4605 
4606     function verify(
4607         address signer,
4608         MetaTransaction memory metaTx,
4609         bytes32 sigR,
4610         bytes32 sigS,
4611         uint8 sigV
4612     ) internal view returns (bool) {
4613         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
4614         return
4615             signer ==
4616             ecrecover(
4617                 toTypedMessageHash(hashMetaTransaction(metaTx)),
4618                 sigV,
4619                 sigR,
4620                 sigS
4621             );
4622     }
4623 }