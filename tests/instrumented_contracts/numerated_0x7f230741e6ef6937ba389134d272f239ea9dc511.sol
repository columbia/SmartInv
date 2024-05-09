1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
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
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/introspection/IERC165.sol
97 
98 pragma solidity >=0.6.0 <0.8.0;
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
121 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
122 
123 
124 
125 pragma solidity >=0.6.2 <0.8.0;
126 
127 
128 /**
129  * @dev Required interface of an ERC721 compliant contract.
130  */
131 interface IERC721 is IERC165 {
132     /**
133      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
134      */
135     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
136 
137     /**
138      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
139      */
140     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
141 
142     /**
143      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
144      */
145     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
146 
147     /**
148      * @dev Returns the number of tokens in ``owner``'s account.
149      */
150     function balanceOf(address owner) external view returns (uint256 balance);
151 
152     /**
153      * @dev Returns the owner of the `tokenId` token.
154      *
155      * Requirements:
156      *
157      * - `tokenId` must exist.
158      */
159     function ownerOf(uint256 tokenId) external view returns (address owner);
160 
161     /**
162      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
163      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
164      *
165      * Requirements:
166      *
167      * - `from` cannot be the zero address.
168      * - `to` cannot be the zero address.
169      * - `tokenId` token must exist and be owned by `from`.
170      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
171      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
172      *
173      * Emits a {Transfer} event.
174      */
175     function safeTransferFrom(address from, address to, uint256 tokenId) external;
176 
177     /**
178      * @dev Transfers `tokenId` token from `from` to `to`.
179      *
180      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
181      *
182      * Requirements:
183      *
184      * - `from` cannot be the zero address.
185      * - `to` cannot be the zero address.
186      * - `tokenId` token must be owned by `from`.
187      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transferFrom(address from, address to, uint256 tokenId) external;
192 
193     /**
194      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
195      * The approval is cleared when the token is transferred.
196      *
197      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
198      *
199      * Requirements:
200      *
201      * - The caller must own the token or be an approved operator.
202      * - `tokenId` must exist.
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address to, uint256 tokenId) external;
207 
208     /**
209      * @dev Returns the account approved for `tokenId` token.
210      *
211      * Requirements:
212      *
213      * - `tokenId` must exist.
214      */
215     function getApproved(uint256 tokenId) external view returns (address operator);
216 
217     /**
218      * @dev Approve or remove `operator` as an operator for the caller.
219      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
220      *
221      * Requirements:
222      *
223      * - The `operator` cannot be the caller.
224      *
225      * Emits an {ApprovalForAll} event.
226      */
227     function setApprovalForAll(address operator, bool _approved) external;
228 
229     /**
230      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
231      *
232      * See {setApprovalForAll}
233      */
234     function isApprovedForAll(address owner, address operator) external view returns (bool);
235 
236     /**
237       * @dev Safely transfers `tokenId` token from `from` to `to`.
238       *
239       * Requirements:
240       *
241       * - `from` cannot be the zero address.
242       * - `to` cannot be the zero address.
243       * - `tokenId` token must exist and be owned by `from`.
244       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
245       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
246       *
247       * Emits a {Transfer} event.
248       */
249     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
250 }
251 
252 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
253 
254 
255 
256 pragma solidity >=0.6.2 <0.8.0;
257 
258 
259 /**
260  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
261  * @dev See https://eips.ethereum.org/EIPS/eip-721
262  */
263 interface IERC721Metadata is IERC721 {
264 
265     /**
266      * @dev Returns the token collection name.
267      */
268     function name() external view returns (string memory);
269 
270     /**
271      * @dev Returns the token collection symbol.
272      */
273     function symbol() external view returns (string memory);
274 
275     /**
276      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
277      */
278     function tokenURI(uint256 tokenId) external view returns (string memory);
279 }
280 
281 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
282 
283 
284 
285 pragma solidity >=0.6.2 <0.8.0;
286 
287 
288 /**
289  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
290  * @dev See https://eips.ethereum.org/EIPS/eip-721
291  */
292 interface IERC721Enumerable is IERC721 {
293 
294     /**
295      * @dev Returns the total amount of tokens stored by the contract.
296      */
297     function totalSupply() external view returns (uint256);
298 
299     /**
300      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
301      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
302      */
303     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
304 
305     /**
306      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
307      * Use along with {totalSupply} to enumerate all tokens.
308      */
309     function tokenByIndex(uint256 index) external view returns (uint256);
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
313 
314 
315 
316 pragma solidity >=0.6.0 <0.8.0;
317 
318 /**
319  * @title ERC721 token receiver interface
320  * @dev Interface for any contract that wants to support safeTransfers
321  * from ERC721 asset contracts.
322  */
323 interface IERC721Receiver {
324     /**
325      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
326      * by `operator` from `from`, this function is called.
327      *
328      * It must return its Solidity selector to confirm the token transfer.
329      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
330      *
331      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
332      */
333     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
334 }
335 
336 // File: @openzeppelin/contracts/introspection/ERC165.sol
337 
338 
339 
340 pragma solidity >=0.6.0 <0.8.0;
341 
342 
343 /**
344  * @dev Implementation of the {IERC165} interface.
345  *
346  * Contracts may inherit from this and call {_registerInterface} to declare
347  * their support of an interface.
348  */
349 abstract contract ERC165 is IERC165 {
350     /*
351      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
352      */
353     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
354 
355     /**
356      * @dev Mapping of interface ids to whether or not it's supported.
357      */
358     mapping(bytes4 => bool) private _supportedInterfaces;
359 
360     constructor () {
361         // Derived contracts need only register support for their own interfaces,
362         // we register support for ERC165 itself here
363         _registerInterface(_INTERFACE_ID_ERC165);
364     }
365 
366     /**
367      * @dev See {IERC165-supportsInterface}.
368      *
369      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
370      */
371     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
372         return _supportedInterfaces[interfaceId];
373     }
374 
375     /**
376      * @dev Registers the contract as an implementer of the interface defined by
377      * `interfaceId`. Support of the actual ERC165 interface is automatic and
378      * registering its interface id is not required.
379      *
380      * See {IERC165-supportsInterface}.
381      *
382      * Requirements:
383      *
384      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
385      */
386     function _registerInterface(bytes4 interfaceId) internal virtual {
387         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
388         _supportedInterfaces[interfaceId] = true;
389     }
390 }
391 
392 // File: @openzeppelin/contracts/math/SafeMath.sol
393 
394 
395 
396 pragma solidity >=0.6.0 <0.8.0;
397 
398 /**
399  * @dev Wrappers over Solidity's arithmetic operations with added overflow
400  * checks.
401  *
402  * Arithmetic operations in Solidity wrap on overflow. This can easily result
403  * in bugs, because programmers usually assume that an overflow raises an
404  * error, which is the standard behavior in high level programming languages.
405  * `SafeMath` restores this intuition by reverting the transaction when an
406  * operation overflows.
407  *
408  * Using this library instead of the unchecked operations eliminates an entire
409  * class of bugs, so it's recommended to use it always.
410  */
411 library SafeMath {
412     /**
413      * @dev Returns the addition of two unsigned integers, with an overflow flag.
414      *
415      * _Available since v3.4._
416      */
417     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
418         uint256 c = a + b;
419         if (c < a) return (false, 0);
420         return (true, c);
421     }
422 
423     /**
424      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
425      *
426      * _Available since v3.4._
427      */
428     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
429         if (b > a) return (false, 0);
430         return (true, a - b);
431     }
432 
433     /**
434      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
435      *
436      * _Available since v3.4._
437      */
438     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
439         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
440         // benefit is lost if 'b' is also tested.
441         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
442         if (a == 0) return (true, 0);
443         uint256 c = a * b;
444         if (c / a != b) return (false, 0);
445         return (true, c);
446     }
447 
448     /**
449      * @dev Returns the division of two unsigned integers, with a division by zero flag.
450      *
451      * _Available since v3.4._
452      */
453     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
454         if (b == 0) return (false, 0);
455         return (true, a / b);
456     }
457 
458     /**
459      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
460      *
461      * _Available since v3.4._
462      */
463     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
464         if (b == 0) return (false, 0);
465         return (true, a % b);
466     }
467 
468     /**
469      * @dev Returns the addition of two unsigned integers, reverting on
470      * overflow.
471      *
472      * Counterpart to Solidity's `+` operator.
473      *
474      * Requirements:
475      *
476      * - Addition cannot overflow.
477      */
478     function add(uint256 a, uint256 b) internal pure returns (uint256) {
479         uint256 c = a + b;
480         require(c >= a, "SafeMath: addition overflow");
481         return c;
482     }
483 
484     /**
485      * @dev Returns the subtraction of two unsigned integers, reverting on
486      * overflow (when the result is negative).
487      *
488      * Counterpart to Solidity's `-` operator.
489      *
490      * Requirements:
491      *
492      * - Subtraction cannot overflow.
493      */
494     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
495         require(b <= a, "SafeMath: subtraction overflow");
496         return a - b;
497     }
498 
499     /**
500      * @dev Returns the multiplication of two unsigned integers, reverting on
501      * overflow.
502      *
503      * Counterpart to Solidity's `*` operator.
504      *
505      * Requirements:
506      *
507      * - Multiplication cannot overflow.
508      */
509     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
510         if (a == 0) return 0;
511         uint256 c = a * b;
512         require(c / a == b, "SafeMath: multiplication overflow");
513         return c;
514     }
515 
516     /**
517      * @dev Returns the integer division of two unsigned integers, reverting on
518      * division by zero. The result is rounded towards zero.
519      *
520      * Counterpart to Solidity's `/` operator. Note: this function uses a
521      * `revert` opcode (which leaves remaining gas untouched) while Solidity
522      * uses an invalid opcode to revert (consuming all remaining gas).
523      *
524      * Requirements:
525      *
526      * - The divisor cannot be zero.
527      */
528     function div(uint256 a, uint256 b) internal pure returns (uint256) {
529         require(b > 0, "SafeMath: division by zero");
530         return a / b;
531     }
532 
533     /**
534      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
535      * reverting when dividing by zero.
536      *
537      * Counterpart to Solidity's `%` operator. This function uses a `revert`
538      * opcode (which leaves remaining gas untouched) while Solidity uses an
539      * invalid opcode to revert (consuming all remaining gas).
540      *
541      * Requirements:
542      *
543      * - The divisor cannot be zero.
544      */
545     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
546         require(b > 0, "SafeMath: modulo by zero");
547         return a % b;
548     }
549 
550     /**
551      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
552      * overflow (when the result is negative).
553      *
554      * CAUTION: This function is deprecated because it requires allocating memory for the error
555      * message unnecessarily. For custom revert reasons use {trySub}.
556      *
557      * Counterpart to Solidity's `-` operator.
558      *
559      * Requirements:
560      *
561      * - Subtraction cannot overflow.
562      */
563     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
564         require(b <= a, errorMessage);
565         return a - b;
566     }
567 
568     /**
569      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
570      * division by zero. The result is rounded towards zero.
571      *
572      * CAUTION: This function is deprecated because it requires allocating memory for the error
573      * message unnecessarily. For custom revert reasons use {tryDiv}.
574      *
575      * Counterpart to Solidity's `/` operator. Note: this function uses a
576      * `revert` opcode (which leaves remaining gas untouched) while Solidity
577      * uses an invalid opcode to revert (consuming all remaining gas).
578      *
579      * Requirements:
580      *
581      * - The divisor cannot be zero.
582      */
583     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
584         require(b > 0, errorMessage);
585         return a / b;
586     }
587 
588     /**
589      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
590      * reverting with custom message when dividing by zero.
591      *
592      * CAUTION: This function is deprecated because it requires allocating memory for the error
593      * message unnecessarily. For custom revert reasons use {tryMod}.
594      *
595      * Counterpart to Solidity's `%` operator. This function uses a `revert`
596      * opcode (which leaves remaining gas untouched) while Solidity uses an
597      * invalid opcode to revert (consuming all remaining gas).
598      *
599      * Requirements:
600      *
601      * - The divisor cannot be zero.
602      */
603     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
604         require(b > 0, errorMessage);
605         return a % b;
606     }
607 }
608 
609 // File: @openzeppelin/contracts/utils/Address.sol
610 
611 
612 
613 pragma solidity >=0.6.2 <0.8.0;
614 
615 /**
616  * @dev Collection of functions related to the address type
617  */
618 library Address {
619     /**
620      * @dev Returns true if `account` is a contract.
621      *
622      * [IMPORTANT]
623      * ====
624      * It is unsafe to assume that an address for which this function returns
625      * false is an externally-owned account (EOA) and not a contract.
626      *
627      * Among others, `isContract` will return false for the following
628      * types of addresses:
629      *
630      *  - an externally-owned account
631      *  - a contract in construction
632      *  - an address where a contract will be created
633      *  - an address where a contract lived, but was destroyed
634      * ====
635      */
636     function isContract(address account) internal view returns (bool) {
637         // This method relies on extcodesize, which returns 0 for contracts in
638         // construction, since the code is only stored at the end of the
639         // constructor execution.
640 
641         uint256 size;
642         // solhint-disable-next-line no-inline-assembly
643         assembly { size := extcodesize(account) }
644         return size > 0;
645     }
646 
647     /**
648      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
649      * `recipient`, forwarding all available gas and reverting on errors.
650      *
651      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
652      * of certain opcodes, possibly making contracts go over the 2300 gas limit
653      * imposed by `transfer`, making them unable to receive funds via
654      * `transfer`. {sendValue} removes this limitation.
655      *
656      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
657      *
658      * IMPORTANT: because control is transferred to `recipient`, care must be
659      * taken to not create reentrancy vulnerabilities. Consider using
660      * {ReentrancyGuard} or the
661      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
662      */
663     function sendValue(address payable recipient, uint256 amount) internal {
664         require(address(this).balance >= amount, "Address: insufficient balance");
665 
666         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
667         (bool success, ) = recipient.call{ value: amount }("");
668         require(success, "Address: unable to send value, recipient may have reverted");
669     }
670 
671     /**
672      * @dev Performs a Solidity function call using a low level `call`. A
673      * plain`call` is an unsafe replacement for a function call: use this
674      * function instead.
675      *
676      * If `target` reverts with a revert reason, it is bubbled up by this
677      * function (like regular Solidity function calls).
678      *
679      * Returns the raw returned data. To convert to the expected return value,
680      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
681      *
682      * Requirements:
683      *
684      * - `target` must be a contract.
685      * - calling `target` with `data` must not revert.
686      *
687      * _Available since v3.1._
688      */
689     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
690       return functionCall(target, data, "Address: low-level call failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
695      * `errorMessage` as a fallback revert reason when `target` reverts.
696      *
697      * _Available since v3.1._
698      */
699     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
700         return functionCallWithValue(target, data, 0, errorMessage);
701     }
702 
703     /**
704      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
705      * but also transferring `value` wei to `target`.
706      *
707      * Requirements:
708      *
709      * - the calling contract must have an ETH balance of at least `value`.
710      * - the called Solidity function must be `payable`.
711      *
712      * _Available since v3.1._
713      */
714     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
715         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
716     }
717 
718     /**
719      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
720      * with `errorMessage` as a fallback revert reason when `target` reverts.
721      *
722      * _Available since v3.1._
723      */
724     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
725         require(address(this).balance >= value, "Address: insufficient balance for call");
726         require(isContract(target), "Address: call to non-contract");
727 
728         // solhint-disable-next-line avoid-low-level-calls
729         (bool success, bytes memory returndata) = target.call{ value: value }(data);
730         return _verifyCallResult(success, returndata, errorMessage);
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
735      * but performing a static call.
736      *
737      * _Available since v3.3._
738      */
739     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
740         return functionStaticCall(target, data, "Address: low-level static call failed");
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
745      * but performing a static call.
746      *
747      * _Available since v3.3._
748      */
749     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
750         require(isContract(target), "Address: static call to non-contract");
751 
752         // solhint-disable-next-line avoid-low-level-calls
753         (bool success, bytes memory returndata) = target.staticcall(data);
754         return _verifyCallResult(success, returndata, errorMessage);
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
759      * but performing a delegate call.
760      *
761      * _Available since v3.4._
762      */
763     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
764         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
769      * but performing a delegate call.
770      *
771      * _Available since v3.4._
772      */
773     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
774         require(isContract(target), "Address: delegate call to non-contract");
775 
776         // solhint-disable-next-line avoid-low-level-calls
777         (bool success, bytes memory returndata) = target.delegatecall(data);
778         return _verifyCallResult(success, returndata, errorMessage);
779     }
780 
781     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
782         if (success) {
783             return returndata;
784         } else {
785             // Look for revert reason and bubble it up if present
786             if (returndata.length > 0) {
787                 // The easiest way to bubble the revert reason is using memory via assembly
788 
789                 // solhint-disable-next-line no-inline-assembly
790                 assembly {
791                     let returndata_size := mload(returndata)
792                     revert(add(32, returndata), returndata_size)
793                 }
794             } else {
795                 revert(errorMessage);
796             }
797         }
798     }
799 }
800 
801 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
802 
803 
804 
805 pragma solidity >=0.6.0 <0.8.0;
806 
807 /**
808  * @dev Library for managing
809  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
810  * types.
811  *
812  * Sets have the following properties:
813  *
814  * - Elements are added, removed, and checked for existence in constant time
815  * (O(1)).
816  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
817  *
818  * ```
819  * contract Example {
820  *     // Add the library methods
821  *     using EnumerableSet for EnumerableSet.AddressSet;
822  *
823  *     // Declare a set state variable
824  *     EnumerableSet.AddressSet private mySet;
825  * }
826  * ```
827  *
828  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
829  * and `uint256` (`UintSet`) are supported.
830  */
831 library EnumerableSet {
832     // To implement this library for multiple types with as little code
833     // repetition as possible, we write it in terms of a generic Set type with
834     // bytes32 values.
835     // The Set implementation uses private functions, and user-facing
836     // implementations (such as AddressSet) are just wrappers around the
837     // underlying Set.
838     // This means that we can only create new EnumerableSets for types that fit
839     // in bytes32.
840 
841     struct Set {
842         // Storage of set values
843         bytes32[] _values;
844 
845         // Position of the value in the `values` array, plus 1 because index 0
846         // means a value is not in the set.
847         mapping (bytes32 => uint256) _indexes;
848     }
849 
850     /**
851      * @dev Add a value to a set. O(1).
852      *
853      * Returns true if the value was added to the set, that is if it was not
854      * already present.
855      */
856     function _add(Set storage set, bytes32 value) private returns (bool) {
857         if (!_contains(set, value)) {
858             set._values.push(value);
859             // The value is stored at length-1, but we add 1 to all indexes
860             // and use 0 as a sentinel value
861             set._indexes[value] = set._values.length;
862             return true;
863         } else {
864             return false;
865         }
866     }
867 
868     /**
869      * @dev Removes a value from a set. O(1).
870      *
871      * Returns true if the value was removed from the set, that is if it was
872      * present.
873      */
874     function _remove(Set storage set, bytes32 value) private returns (bool) {
875         // We read and store the value's index to prevent multiple reads from the same storage slot
876         uint256 valueIndex = set._indexes[value];
877 
878         if (valueIndex != 0) { // Equivalent to contains(set, value)
879             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
880             // the array, and then remove the last element (sometimes called as 'swap and pop').
881             // This modifies the order of the array, as noted in {at}.
882 
883             uint256 toDeleteIndex = valueIndex - 1;
884             uint256 lastIndex = set._values.length - 1;
885 
886             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
887             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
888 
889             bytes32 lastvalue = set._values[lastIndex];
890 
891             // Move the last value to the index where the value to delete is
892             set._values[toDeleteIndex] = lastvalue;
893             // Update the index for the moved value
894             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
895 
896             // Delete the slot where the moved value was stored
897             set._values.pop();
898 
899             // Delete the index for the deleted slot
900             delete set._indexes[value];
901 
902             return true;
903         } else {
904             return false;
905         }
906     }
907 
908     /**
909      * @dev Returns true if the value is in the set. O(1).
910      */
911     function _contains(Set storage set, bytes32 value) private view returns (bool) {
912         return set._indexes[value] != 0;
913     }
914 
915     /**
916      * @dev Returns the number of values on the set. O(1).
917      */
918     function _length(Set storage set) private view returns (uint256) {
919         return set._values.length;
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
932     function _at(Set storage set, uint256 index) private view returns (bytes32) {
933         require(set._values.length > index, "EnumerableSet: index out of bounds");
934         return set._values[index];
935     }
936 
937     // Bytes32Set
938 
939     struct Bytes32Set {
940         Set _inner;
941     }
942 
943     /**
944      * @dev Add a value to a set. O(1).
945      *
946      * Returns true if the value was added to the set, that is if it was not
947      * already present.
948      */
949     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
950         return _add(set._inner, value);
951     }
952 
953     /**
954      * @dev Removes a value from a set. O(1).
955      *
956      * Returns true if the value was removed from the set, that is if it was
957      * present.
958      */
959     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
960         return _remove(set._inner, value);
961     }
962 
963     /**
964      * @dev Returns true if the value is in the set. O(1).
965      */
966     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
967         return _contains(set._inner, value);
968     }
969 
970     /**
971      * @dev Returns the number of values in the set. O(1).
972      */
973     function length(Bytes32Set storage set) internal view returns (uint256) {
974         return _length(set._inner);
975     }
976 
977    /**
978     * @dev Returns the value stored at position `index` in the set. O(1).
979     *
980     * Note that there are no guarantees on the ordering of values inside the
981     * array, and it may change when more values are added or removed.
982     *
983     * Requirements:
984     *
985     * - `index` must be strictly less than {length}.
986     */
987     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
988         return _at(set._inner, index);
989     }
990 
991     // AddressSet
992 
993     struct AddressSet {
994         Set _inner;
995     }
996 
997     /**
998      * @dev Add a value to a set. O(1).
999      *
1000      * Returns true if the value was added to the set, that is if it was not
1001      * already present.
1002      */
1003     function add(AddressSet storage set, address value) internal returns (bool) {
1004         return _add(set._inner, bytes32(uint256(uint160(value))));
1005     }
1006 
1007     /**
1008      * @dev Removes a value from a set. O(1).
1009      *
1010      * Returns true if the value was removed from the set, that is if it was
1011      * present.
1012      */
1013     function remove(AddressSet storage set, address value) internal returns (bool) {
1014         return _remove(set._inner, bytes32(uint256(uint160(value))));
1015     }
1016 
1017     /**
1018      * @dev Returns true if the value is in the set. O(1).
1019      */
1020     function contains(AddressSet storage set, address value) internal view returns (bool) {
1021         return _contains(set._inner, bytes32(uint256(uint160(value))));
1022     }
1023 
1024     /**
1025      * @dev Returns the number of values in the set. O(1).
1026      */
1027     function length(AddressSet storage set) internal view returns (uint256) {
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
1041     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1042         return address(uint160(uint256(_at(set._inner, index))));
1043     }
1044 
1045 
1046     // UintSet
1047 
1048     struct UintSet {
1049         Set _inner;
1050     }
1051 
1052     /**
1053      * @dev Add a value to a set. O(1).
1054      *
1055      * Returns true if the value was added to the set, that is if it was not
1056      * already present.
1057      */
1058     function add(UintSet storage set, uint256 value) internal returns (bool) {
1059         return _add(set._inner, bytes32(value));
1060     }
1061 
1062     /**
1063      * @dev Removes a value from a set. O(1).
1064      *
1065      * Returns true if the value was removed from the set, that is if it was
1066      * present.
1067      */
1068     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1069         return _remove(set._inner, bytes32(value));
1070     }
1071 
1072     /**
1073      * @dev Returns true if the value is in the set. O(1).
1074      */
1075     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1076         return _contains(set._inner, bytes32(value));
1077     }
1078 
1079     /**
1080      * @dev Returns the number of values on the set. O(1).
1081      */
1082     function length(UintSet storage set) internal view returns (uint256) {
1083         return _length(set._inner);
1084     }
1085 
1086    /**
1087     * @dev Returns the value stored at position `index` in the set. O(1).
1088     *
1089     * Note that there are no guarantees on the ordering of values inside the
1090     * array, and it may change when more values are added or removed.
1091     *
1092     * Requirements:
1093     *
1094     * - `index` must be strictly less than {length}.
1095     */
1096     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1097         return uint256(_at(set._inner, index));
1098     }
1099 }
1100 
1101 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1102 
1103 
1104 
1105 pragma solidity >=0.6.0 <0.8.0;
1106 
1107 /**
1108  * @dev Library for managing an enumerable variant of Solidity's
1109  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1110  * type.
1111  *
1112  * Maps have the following properties:
1113  *
1114  * - Entries are added, removed, and checked for existence in constant time
1115  * (O(1)).
1116  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1117  *
1118  * ```
1119  * contract Example {
1120  *     // Add the library methods
1121  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1122  *
1123  *     // Declare a set state variable
1124  *     EnumerableMap.UintToAddressMap private myMap;
1125  * }
1126  * ```
1127  *
1128  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1129  * supported.
1130  */
1131 library EnumerableMap {
1132     // To implement this library for multiple types with as little code
1133     // repetition as possible, we write it in terms of a generic Map type with
1134     // bytes32 keys and values.
1135     // The Map implementation uses private functions, and user-facing
1136     // implementations (such as Uint256ToAddressMap) are just wrappers around
1137     // the underlying Map.
1138     // This means that we can only create new EnumerableMaps for types that fit
1139     // in bytes32.
1140 
1141     struct MapEntry {
1142         bytes32 _key;
1143         bytes32 _value;
1144     }
1145 
1146     struct Map {
1147         // Storage of map keys and values
1148         MapEntry[] _entries;
1149 
1150         // Position of the entry defined by a key in the `entries` array, plus 1
1151         // because index 0 means a key is not in the map.
1152         mapping (bytes32 => uint256) _indexes;
1153     }
1154 
1155     /**
1156      * @dev Adds a key-value pair to a map, or updates the value for an existing
1157      * key. O(1).
1158      *
1159      * Returns true if the key was added to the map, that is if it was not
1160      * already present.
1161      */
1162     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1163         // We read and store the key's index to prevent multiple reads from the same storage slot
1164         uint256 keyIndex = map._indexes[key];
1165 
1166         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1167             map._entries.push(MapEntry({ _key: key, _value: value }));
1168             // The entry is stored at length-1, but we add 1 to all indexes
1169             // and use 0 as a sentinel value
1170             map._indexes[key] = map._entries.length;
1171             return true;
1172         } else {
1173             map._entries[keyIndex - 1]._value = value;
1174             return false;
1175         }
1176     }
1177 
1178     /**
1179      * @dev Removes a key-value pair from a map. O(1).
1180      *
1181      * Returns true if the key was removed from the map, that is if it was present.
1182      */
1183     function _remove(Map storage map, bytes32 key) private returns (bool) {
1184         // We read and store the key's index to prevent multiple reads from the same storage slot
1185         uint256 keyIndex = map._indexes[key];
1186 
1187         if (keyIndex != 0) { // Equivalent to contains(map, key)
1188             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1189             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1190             // This modifies the order of the array, as noted in {at}.
1191 
1192             uint256 toDeleteIndex = keyIndex - 1;
1193             uint256 lastIndex = map._entries.length - 1;
1194 
1195             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1196             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1197 
1198             MapEntry storage lastEntry = map._entries[lastIndex];
1199 
1200             // Move the last entry to the index where the entry to delete is
1201             map._entries[toDeleteIndex] = lastEntry;
1202             // Update the index for the moved entry
1203             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1204 
1205             // Delete the slot where the moved entry was stored
1206             map._entries.pop();
1207 
1208             // Delete the index for the deleted slot
1209             delete map._indexes[key];
1210 
1211             return true;
1212         } else {
1213             return false;
1214         }
1215     }
1216 
1217     /**
1218      * @dev Returns true if the key is in the map. O(1).
1219      */
1220     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1221         return map._indexes[key] != 0;
1222     }
1223 
1224     /**
1225      * @dev Returns the number of key-value pairs in the map. O(1).
1226      */
1227     function _length(Map storage map) private view returns (uint256) {
1228         return map._entries.length;
1229     }
1230 
1231    /**
1232     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1233     *
1234     * Note that there are no guarantees on the ordering of entries inside the
1235     * array, and it may change when more entries are added or removed.
1236     *
1237     * Requirements:
1238     *
1239     * - `index` must be strictly less than {length}.
1240     */
1241     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1242         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1243 
1244         MapEntry storage entry = map._entries[index];
1245         return (entry._key, entry._value);
1246     }
1247 
1248     /**
1249      * @dev Tries to returns the value associated with `key`.  O(1).
1250      * Does not revert if `key` is not in the map.
1251      */
1252     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1253         uint256 keyIndex = map._indexes[key];
1254         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1255         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1256     }
1257 
1258     /**
1259      * @dev Returns the value associated with `key`.  O(1).
1260      *
1261      * Requirements:
1262      *
1263      * - `key` must be in the map.
1264      */
1265     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1266         uint256 keyIndex = map._indexes[key];
1267         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1268         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1269     }
1270 
1271     /**
1272      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1273      *
1274      * CAUTION: This function is deprecated because it requires allocating memory for the error
1275      * message unnecessarily. For custom revert reasons use {_tryGet}.
1276      */
1277     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1278         uint256 keyIndex = map._indexes[key];
1279         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1280         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1281     }
1282 
1283     // UintToAddressMap
1284 
1285     struct UintToAddressMap {
1286         Map _inner;
1287     }
1288 
1289     /**
1290      * @dev Adds a key-value pair to a map, or updates the value for an existing
1291      * key. O(1).
1292      *
1293      * Returns true if the key was added to the map, that is if it was not
1294      * already present.
1295      */
1296     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1297         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1298     }
1299 
1300     /**
1301      * @dev Removes a value from a set. O(1).
1302      *
1303      * Returns true if the key was removed from the map, that is if it was present.
1304      */
1305     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1306         return _remove(map._inner, bytes32(key));
1307     }
1308 
1309     /**
1310      * @dev Returns true if the key is in the map. O(1).
1311      */
1312     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1313         return _contains(map._inner, bytes32(key));
1314     }
1315 
1316     /**
1317      * @dev Returns the number of elements in the map. O(1).
1318      */
1319     function length(UintToAddressMap storage map) internal view returns (uint256) {
1320         return _length(map._inner);
1321     }
1322 
1323    /**
1324     * @dev Returns the element stored at position `index` in the set. O(1).
1325     * Note that there are no guarantees on the ordering of values inside the
1326     * array, and it may change when more values are added or removed.
1327     *
1328     * Requirements:
1329     *
1330     * - `index` must be strictly less than {length}.
1331     */
1332     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1333         (bytes32 key, bytes32 value) = _at(map._inner, index);
1334         return (uint256(key), address(uint160(uint256(value))));
1335     }
1336 
1337     /**
1338      * @dev Tries to returns the value associated with `key`.  O(1).
1339      * Does not revert if `key` is not in the map.
1340      *
1341      * _Available since v3.4._
1342      */
1343     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1344         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1345         return (success, address(uint160(uint256(value))));
1346     }
1347 
1348     /**
1349      * @dev Returns the value associated with `key`.  O(1).
1350      *
1351      * Requirements:
1352      *
1353      * - `key` must be in the map.
1354      */
1355     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1356         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1357     }
1358 
1359     /**
1360      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1361      *
1362      * CAUTION: This function is deprecated because it requires allocating memory for the error
1363      * message unnecessarily. For custom revert reasons use {tryGet}.
1364      */
1365     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1366         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1367     }
1368 }
1369 
1370 // File: @openzeppelin/contracts/utils/Strings.sol
1371 
1372 
1373 
1374 pragma solidity >=0.6.0 <0.8.0;
1375 
1376 /**
1377  * @dev String operations.
1378  */
1379 library Strings {
1380     /**
1381      * @dev Converts a `uint256` to its ASCII `string` representation.
1382      */
1383     function toString(uint256 value) internal pure returns (string memory) {
1384         // Inspired by OraclizeAPI's implementation - MIT licence
1385         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1386 
1387         if (value == 0) {
1388             return "0";
1389         }
1390         uint256 temp = value;
1391         uint256 digits;
1392         while (temp != 0) {
1393             digits++;
1394             temp /= 10;
1395         }
1396         bytes memory buffer = new bytes(digits);
1397         uint256 index = digits - 1;
1398         temp = value;
1399         while (temp != 0) {
1400             buffer[index--] = bytes1(uint8(48 + temp % 10));
1401             temp /= 10;
1402         }
1403         return string(buffer);
1404     }
1405 }
1406 
1407 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1408 
1409 
1410 
1411 pragma solidity >=0.6.0 <0.8.0;
1412 
1413 
1414 
1415 
1416 
1417 
1418 
1419 
1420 
1421 
1422 
1423 
1424 /**
1425  * @title ERC721 Non-Fungible Token Standard basic implementation
1426  * @dev see https://eips.ethereum.org/EIPS/eip-721
1427  */
1428 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1429     using SafeMath for uint256;
1430     using Address for address;
1431     using EnumerableSet for EnumerableSet.UintSet;
1432     using EnumerableMap for EnumerableMap.UintToAddressMap;
1433     using Strings for uint256;
1434 
1435     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1436     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1437     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1438 
1439     // Mapping from holder address to their (enumerable) set of owned tokens
1440     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1441 
1442     // Enumerable mapping from token ids to their owners
1443     EnumerableMap.UintToAddressMap private _tokenOwners;
1444 
1445     // Mapping from token ID to approved address
1446     mapping (uint256 => address) private _tokenApprovals;
1447 
1448     // Mapping from owner to operator approvals
1449     mapping (address => mapping (address => bool)) private _operatorApprovals;
1450 
1451     // Token name
1452     string private _name;
1453 
1454     // Token symbol
1455     string private _symbol;
1456 
1457     // Optional mapping for token URIs
1458     mapping (uint256 => string) private _tokenURIs;
1459 
1460     // Base URI
1461     string private _baseURI;
1462 
1463     /*
1464      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1465      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1466      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1467      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1468      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1469      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1470      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1471      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1472      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1473      *
1474      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1475      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1476      */
1477     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1478 
1479     /*
1480      *     bytes4(keccak256('name()')) == 0x06fdde03
1481      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1482      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1483      *
1484      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1485      */
1486     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1487 
1488     /*
1489      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1490      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1491      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1492      *
1493      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1494      */
1495     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1496 
1497     /**
1498      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1499      */
1500     constructor (string memory name_, string memory symbol_) {
1501         _name = name_;
1502         _symbol = symbol_;
1503 
1504         // register the supported interfaces to conform to ERC721 via ERC165
1505         _registerInterface(_INTERFACE_ID_ERC721);
1506         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1507         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1508     }
1509 
1510     /**
1511      * @dev See {IERC721-balanceOf}.
1512      */
1513     function balanceOf(address owner) public view virtual override returns (uint256) {
1514         require(owner != address(0), "ERC721: balance query for the zero address");
1515         return _holderTokens[owner].length();
1516     }
1517 
1518     /**
1519      * @dev See {IERC721-ownerOf}.
1520      */
1521     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1522         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1523     }
1524 
1525     /**
1526      * @dev See {IERC721Metadata-name}.
1527      */
1528     function name() public view virtual override returns (string memory) {
1529         return _name;
1530     }
1531 
1532     /**
1533      * @dev See {IERC721Metadata-symbol}.
1534      */
1535     function symbol() public view virtual override returns (string memory) {
1536         return _symbol;
1537     }
1538 
1539     /**
1540      * @dev See {IERC721Metadata-tokenURI}.
1541      */
1542     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1543         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1544 
1545         string memory _tokenURI = _tokenURIs[tokenId];
1546         string memory base = baseURI();
1547 
1548         // If there is no base URI, return the token URI.
1549         if (bytes(base).length == 0) {
1550             return _tokenURI;
1551         }
1552         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1553         if (bytes(_tokenURI).length > 0) {
1554             return string(abi.encodePacked(base, _tokenURI));
1555         }
1556         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1557         return string(abi.encodePacked(base, tokenId.toString()));
1558     }
1559 
1560     /**
1561     * @dev Returns the base URI set via {_setBaseURI}. This will be
1562     * automatically added as a prefix in {tokenURI} to each token's URI, or
1563     * to the token ID if no specific URI is set for that token ID.
1564     */
1565     function baseURI() public view virtual returns (string memory) {
1566         return _baseURI;
1567     }
1568 
1569     /**
1570      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1571      */
1572     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1573         return _holderTokens[owner].at(index);
1574     }
1575 
1576     /**
1577      * @dev See {IERC721Enumerable-totalSupply}.
1578      */
1579     function totalSupply() public view virtual override returns (uint256) {
1580         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1581         return _tokenOwners.length();
1582     }
1583 
1584     /**
1585      * @dev See {IERC721Enumerable-tokenByIndex}.
1586      */
1587     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1588         (uint256 tokenId, ) = _tokenOwners.at(index);
1589         return tokenId;
1590     }
1591 
1592     /**
1593      * @dev See {IERC721-approve}.
1594      */
1595     function approve(address to, uint256 tokenId) public virtual override {
1596         address owner = ERC721.ownerOf(tokenId);
1597         require(to != owner, "ERC721: approval to current owner");
1598 
1599         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1600             "ERC721: approve caller is not owner nor approved for all"
1601         );
1602 
1603         _approve(to, tokenId);
1604     }
1605 
1606     /**
1607      * @dev See {IERC721-getApproved}.
1608      */
1609     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1610         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1611 
1612         return _tokenApprovals[tokenId];
1613     }
1614 
1615     /**
1616      * @dev See {IERC721-setApprovalForAll}.
1617      */
1618     function setApprovalForAll(address operator, bool approved) public virtual override {
1619         require(operator != _msgSender(), "ERC721: approve to caller");
1620 
1621         _operatorApprovals[_msgSender()][operator] = approved;
1622         emit ApprovalForAll(_msgSender(), operator, approved);
1623     }
1624 
1625     /**
1626      * @dev See {IERC721-isApprovedForAll}.
1627      */
1628     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1629         return _operatorApprovals[owner][operator];
1630     }
1631 
1632     /**
1633      * @dev See {IERC721-transferFrom}.
1634      */
1635     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1636         //solhint-disable-next-line max-line-length
1637         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1638 
1639         _transfer(from, to, tokenId);
1640     }
1641 
1642     /**
1643      * @dev See {IERC721-safeTransferFrom}.
1644      */
1645     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1646         safeTransferFrom(from, to, tokenId, "");
1647     }
1648 
1649     /**
1650      * @dev See {IERC721-safeTransferFrom}.
1651      */
1652     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1653         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1654         _safeTransfer(from, to, tokenId, _data);
1655     }
1656 
1657     /**
1658      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1659      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1660      *
1661      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1662      *
1663      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1664      * implement alternative mechanisms to perform token transfer, such as signature-based.
1665      *
1666      * Requirements:
1667      *
1668      * - `from` cannot be the zero address.
1669      * - `to` cannot be the zero address.
1670      * - `tokenId` token must exist and be owned by `from`.
1671      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1672      *
1673      * Emits a {Transfer} event.
1674      */
1675     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1676         _transfer(from, to, tokenId);
1677         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1678     }
1679 
1680     /**
1681      * @dev Returns whether `tokenId` exists.
1682      *
1683      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1684      *
1685      * Tokens start existing when they are minted (`_mint`),
1686      * and stop existing when they are burned (`_burn`).
1687      */
1688     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1689         return _tokenOwners.contains(tokenId);
1690     }
1691 
1692     /**
1693      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1694      *
1695      * Requirements:
1696      *
1697      * - `tokenId` must exist.
1698      */
1699     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1700         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1701         address owner = ERC721.ownerOf(tokenId);
1702         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1703     }
1704 
1705     /**
1706      * @dev Safely mints `tokenId` and transfers it to `to`.
1707      *
1708      * Requirements:
1709      d*
1710      * - `tokenId` must not exist.
1711      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1712      *
1713      * Emits a {Transfer} event.
1714      */
1715     function _safeMint(address to, uint256 tokenId) internal virtual {
1716         _safeMint(to, tokenId, "");
1717     }
1718 
1719     /**
1720      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1721      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1722      */
1723     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1724         _mint(to, tokenId);
1725         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1726     }
1727 
1728     /**
1729      * @dev Mints `tokenId` and transfers it to `to`.
1730      *
1731      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1732      *
1733      * Requirements:
1734      *
1735      * - `tokenId` must not exist.
1736      * - `to` cannot be the zero address.
1737      *
1738      * Emits a {Transfer} event.
1739      */
1740     function _mint(address to, uint256 tokenId) internal virtual {
1741         require(to != address(0), "ERC721: mint to the zero address");
1742         require(!_exists(tokenId), "ERC721: token already minted");
1743 
1744         _beforeTokenTransfer(address(0), to, tokenId);
1745 
1746         _holderTokens[to].add(tokenId);
1747 
1748         _tokenOwners.set(tokenId, to);
1749 
1750         emit Transfer(address(0), to, tokenId);
1751     }
1752 
1753     /**
1754      * @dev Destroys `tokenId`.
1755      * The approval is cleared when the token is burned.
1756      *
1757      * Requirements:
1758      *
1759      * - `tokenId` must exist.
1760      *
1761      * Emits a {Transfer} event.
1762      */
1763     function _burn(uint256 tokenId) internal virtual {
1764         address owner = ERC721.ownerOf(tokenId); // internal owner
1765 
1766         _beforeTokenTransfer(owner, address(0), tokenId);
1767 
1768         // Clear approvals
1769         _approve(address(0), tokenId);
1770 
1771         // Clear metadata (if any)
1772         if (bytes(_tokenURIs[tokenId]).length != 0) {
1773             delete _tokenURIs[tokenId];
1774         }
1775 
1776         _holderTokens[owner].remove(tokenId);
1777 
1778         _tokenOwners.remove(tokenId);
1779 
1780         emit Transfer(owner, address(0), tokenId);
1781     }
1782 
1783     /**
1784      * @dev Transfers `tokenId` from `from` to `to`.
1785      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1786      *
1787      * Requirements:
1788      *
1789      * - `to` cannot be the zero address.
1790      * - `tokenId` token must be owned by `from`.
1791      *
1792      * Emits a {Transfer} event.
1793      */
1794     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1795         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1796         require(to != address(0), "ERC721: transfer to the zero address");
1797 
1798         _beforeTokenTransfer(from, to, tokenId);
1799 
1800         // Clear approvals from the previous owner
1801         _approve(address(0), tokenId);
1802 
1803         _holderTokens[from].remove(tokenId);
1804         _holderTokens[to].add(tokenId);
1805 
1806         _tokenOwners.set(tokenId, to);
1807 
1808         emit Transfer(from, to, tokenId);
1809     }
1810 
1811     /**
1812      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1813      *
1814      * Requirements:
1815      *
1816      * - `tokenId` must exist.
1817      */
1818     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1819         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1820         _tokenURIs[tokenId] = _tokenURI;
1821     }
1822 
1823     /**
1824      * @dev Internal function to set the base URI for all token IDs. It is
1825      * automatically added as a prefix to the value returned in {tokenURI},
1826      * or to the token ID if {tokenURI} is empty.
1827      */
1828     function _setBaseURI(string memory baseURI_) internal virtual {
1829         _baseURI = baseURI_;
1830     }
1831 
1832     /**
1833      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1834      * The call is not executed if the target address is not a contract.
1835      *
1836      * @param from address representing the previous owner of the given token ID
1837      * @param to target address that will receive the tokens
1838      * @param tokenId uint256 ID of the token to be transferred
1839      * @param _data bytes optional data to send along with the call
1840      * @return bool whether the call correctly returned the expected magic value
1841      */
1842     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1843         private returns (bool)
1844     {
1845         if (!to.isContract()) {
1846             return true;
1847         }
1848         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1849             IERC721Receiver(to).onERC721Received.selector,
1850             _msgSender(),
1851             from,
1852             tokenId,
1853             _data
1854         ), "ERC721: transfer to non ERC721Receiver implementer");
1855         bytes4 retval = abi.decode(returndata, (bytes4));
1856         return (retval == _ERC721_RECEIVED);
1857     }
1858 
1859     function _approve(address to, uint256 tokenId) private {
1860         _tokenApprovals[tokenId] = to;
1861         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1862     }
1863 
1864     /**
1865      * @dev Hook that is called before any token transfer. This includes minting
1866      * and burning.
1867      *
1868      * Calling conditions:
1869      *
1870      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1871      * transferred to `to`.
1872      * - When `from` is zero, `tokenId` will be minted for `to`.
1873      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1874      * - `from` cannot be the zero address.
1875      * - `to` cannot be the zero address.
1876      *
1877      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1878      */
1879     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1880 }
1881 
1882 // File: @openzeppelin/contracts/utils/Counters.sol
1883 
1884 
1885 
1886 pragma solidity >=0.6.0 <0.8.0;
1887 
1888 
1889 /**
1890  * @title Counters
1891  * @author Matt Condon (@shrugs)
1892  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1893  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1894  *
1895  * Include with `using Counters for Counters.Counter;`
1896  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1897  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1898  * directly accessed.
1899  */
1900 library Counters {
1901     using SafeMath for uint256;
1902 
1903     struct Counter {
1904         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1905         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1906         // this feature: see https://github.com/ethereum/solidity/issues/4637
1907         uint256 _value; // default: 0
1908     }
1909 
1910     function current(Counter storage counter) internal view returns (uint256) {
1911         return counter._value;
1912     }
1913 
1914     function increment(Counter storage counter) internal {
1915         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1916         counter._value += 1;
1917     }
1918 
1919     function decrement(Counter storage counter) internal {
1920         counter._value = counter._value.sub(1);
1921     }
1922 }
1923 
1924 // File: contracts/DeekHash.sol
1925 
1926 
1927 pragma solidity >=0.7.0 <0.8.0;
1928 
1929 
1930 
1931 
1932 contract DeekHash is ERC721, Ownable {  
1933     using Counters for Counters.Counter;
1934     using SafeMath for uint256;
1935 
1936     Counters.Counter private _tokenIds;
1937 
1938     uint256 public constant INITIAL_REG_DEEKS_CAP = 10000;
1939 
1940     uint256 private _saleBeginTime = 1615561200; // 12 March 2021, 10:00 GMT-5 (NY time)
1941     
1942     uint256 private _regularDeeksCap = INITIAL_REG_DEEKS_CAP;
1943     uint256 private _superDeeksBorn = 0;
1944     address private safeAddress;
1945 
1946     struct Deek {
1947         string name;
1948         string dna;
1949     }
1950 
1951     Deek[] private Deeks;
1952 
1953     /*
1954     * Mapping for passphrases hashes for superDeeks
1955     * True means active , not redeemed yet
1956     * False would mean promocode is invalid or already redeemed
1957      */
1958     mapping (bytes32 => bool) private superHashToRedeemStatus;
1959 
1960     constructor(address _safeAddress, string memory myBase) ERC721("DEEKHASH", "DKHSH") {
1961         _setBaseURI(myBase);
1962         safeAddress = _safeAddress;
1963     }
1964 
1965     /**
1966     * @dev Sets new maximum for the Regular Deeks to be born. It can't be more than INITIAL_REG_DEEKS_CAP
1967     */
1968     function setNewRegularDeeksCap(uint256 _newRegularDeeksCap) public onlyOwner {
1969         require(_newRegularDeeksCap <= INITIAL_REG_DEEKS_CAP, "Regular Deeks capacity cant be higher than INITIAL_REG_DEEKS_CAP");
1970         _regularDeeksCap = _newRegularDeeksCap;
1971     }
1972     
1973     /*************************************************************************
1974     *    REGULAR DEEKS GENESIS BLOCK 
1975     *************************************************************************/
1976 
1977     /**
1978     * @dev Gets current Deek price. Hard borders are incremented by superHeroesBorn
1979     * in case some superheroes will born before sale ends
1980     */
1981     
1982     function getDeekPrice() public view returns (uint256) {
1983         
1984         
1985         require(block.timestamp >= _saleBeginTime, "Too early, guys");
1986         
1987         require(totalSupply() < getTotalCurrCapacity(), "All Deeks were born");
1988 
1989         uint currentSupply = totalSupply();
1990 
1991         if (currentSupply >= 8400 + getSuperDeeksBorn()) {
1992             return 500000000000000000; // 8400  - 9999 0.5 ETH
1993         } else if (currentSupply >= 5000 + getSuperDeeksBorn()) {
1994             return 400000000000000000; // 5000 - 8399 0.4 ETH
1995         } else if (currentSupply >= 1600 + getSuperDeeksBorn()) {
1996             return 300000000000000000; // 1600 - 4999 0.3 ETH
1997         } else if (currentSupply >= 250 + getSuperDeeksBorn()) {
1998             return 200000000000000000; // 250 - 1599 0.2 ETH
1999         } else {
2000             return 100000000000000000; // 0 - 249 0.1 ETH 
2001         }
2002     }
2003     
2004 
2005     /**
2006     * @dev Mints a token
2007     * @param _name = string to hash by user from frontend
2008     * @param _dna = Deek's dna generated by frontend from _name hash
2009     */
2010     function createDeek(string memory _name, string memory _dna) 
2011 	public 
2012 	payable 
2013 	returns (uint256)
2014     {
2015         require(totalSupply() < getTotalCurrCapacity(), "All Deeks were born");
2016         require(msg.value == getDeekPrice(), "Ether value sent is not correct");
2017 
2018         // set the tokenId for token we are going to mint
2019         uint256 newItemId = _tokenIds.current();
2020         
2021         _safeMint(msg.sender, newItemId);
2022         
2023         // we fill Deek name and dna which are going to be stored on-chain
2024         Deeks.push(Deek(_name, _dna));
2025         
2026         // increment counter. 
2027         _tokenIds.increment();
2028                 
2029         return newItemId;
2030     }
2031 
2032     /*************************************************************************
2033     *    SUPERDEEKS GENESIS BLOCK 
2034     *************************************************************************/
2035 
2036     /**
2037     * @dev Adds a hash of a promocode to get the SuperDeek
2038     */
2039     function addSuperHash(string memory _promoCode) external onlyOwner {
2040         superHashToRedeemStatus[keccak256(abi.encodePacked(_promoCode))] = true;
2041     }
2042 
2043     function removeSuperHash(string memory _promoCode) external onlyOwner {
2044         superHashToRedeemStatus[keccak256(abi.encodePacked(_promoCode))] = false;
2045     }
2046 
2047     /**
2048      *  @dev Checks if there is a hash corresponding to a user entered promocode in 
2049      *  the array of the correct promocode hashes
2050      */
2051      function isPromoCodeValid(string memory _userPromoCode) internal view returns(bool) {
2052         bool _superDeekValid = superHashToRedeemStatus[keccak256(abi.encodePacked(_userPromoCode))]; 
2053         return (_superDeekValid);
2054      }
2055 
2056     /**
2057      *  @dev Mints a superDeek
2058      */
2059 
2060     function createSuperDeek (string memory _name, string memory _dna, string memory _userPromoCode) 
2061     public
2062     returns (uint256)
2063     {
2064         
2065         require(block.timestamp >= _saleBeginTime, "Too early, guys");
2066 
2067         require(isPromoCodeValid(_userPromoCode), "Your spell is not valid or already used");
2068 
2069         // set the tokenId for token we are going to mint
2070         uint256 newItemId = _tokenIds.current();
2071         
2072         _safeMint(msg.sender, newItemId);
2073         
2074         // we fill Deek name and dna which are going to be stored on-chain
2075         Deeks.push(Deek(_name, _dna));
2076         
2077         // increment counter and _superDeeksBorn value 
2078         _tokenIds.increment();
2079         _superDeeksBorn = _superDeeksBorn.add(1);
2080 
2081         // mark Promocode as not active
2082         superHashToRedeemStatus[keccak256(abi.encodePacked(_userPromoCode))] = false;
2083                 
2084         return newItemId;
2085     }
2086 
2087     /**************************************************************************
2088     * Working with URIs 
2089     **************************************************************************/
2090 
2091     /**
2092      *  @dev sets new base URI in case old is broken
2093      * baseURI is an URI for the json with the metadata for a token
2094     */ 
2095     function _setNewBaseURI(string memory _newBaseURI) external onlyOwner {
2096         _setBaseURI(_newBaseURI); 
2097     }
2098 
2099     /*
2100     *  baseURI() function which returns private _baseURI variable is defined in ERC721
2101     */
2102 
2103     /***************************************************************************
2104     * Views block
2105     ***************************************************************************/
2106 
2107     function getRegularDeeksCap() public view returns(uint256) {
2108         return _regularDeeksCap;
2109     }
2110 
2111     function getSuperDeeksBorn() public view returns(uint256) {
2112         return _superDeeksBorn;
2113     }
2114 
2115     function getTotalCurrCapacity() public view returns (uint256) {
2116         return (getRegularDeeksCap()).add(getSuperDeeksBorn());
2117     }
2118 
2119     /** 
2120     * @dev get name by tokenId
2121     */
2122     function nameByTokenId(uint256 _tokenId) public view returns(string memory) {
2123         return Deeks[_tokenId].name;
2124     }
2125 
2126     /** 
2127     * @dev get dna by tokenId
2128     */
2129     function dnaByTokenId(uint256 _tokenId) public view returns(string memory) {
2130         return Deeks[_tokenId].dna;
2131     }
2132 
2133     /**
2134     * @dev returns tokenId for the NEXT token to be minted
2135     */
2136     function getNextTokenId() public view returns(uint256) {
2137         return _tokenIds.current();
2138     }
2139 
2140       /**
2141     * @dev returns safeAccount address
2142     */
2143     function getSafeAccountAddress() onlyOwner public view returns(address) {
2144         return safeAddress;
2145     }
2146 
2147     /***************************************************************************
2148     * Finances block
2149     ***************************************************************************/
2150 
2151     /**
2152      * @dev Check contract balance
2153     */
2154     function getContractBalance() onlyOwner public view returns(uint256) {
2155         uint256 balance = address(this).balance;
2156         return balance;
2157     }
2158 
2159     /**
2160      * @dev Withdraw ether from this contract 
2161     */
2162     function withdraw() onlyOwner public {
2163         uint256 balance = address(this).balance;
2164         msg.sender.transfer(balance);
2165     }
2166     
2167     /**
2168      * @dev Withdraw to the SafeAddress 
2169     */
2170     function withdrawToSafeAddress() onlyOwner public {
2171 	    uint256 balance = address(this).balance;
2172 	    payable(safeAddress).transfer(balance);
2173     }
2174 
2175     /***************************************************************************
2176     * Sale start time management block
2177     ***************************************************************************/
2178 
2179     /**
2180     * @dev Check sale start time
2181     */
2182     function getSaleStartTime() public view returns(uint256) {
2183         return _saleBeginTime;
2184     }
2185 
2186     /**
2187     * @dev Set sale start time
2188     */
2189     function setSaleStartTime(uint256 _newSaleStartTime) onlyOwner public {
2190         _saleBeginTime = _newSaleStartTime;
2191     }
2192 
2193 }