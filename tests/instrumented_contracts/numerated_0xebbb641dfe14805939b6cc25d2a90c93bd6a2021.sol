1 /**
2  *  SPDX-License-Identifier: MIT
3 */
4 pragma solidity ^0.8.7;
5 
6 // CAUTION
7 // This version of SafeMath should only be used with Solidity 0.8 or later,
8 // because it relies on the compiler's built in overflow checks.
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations.
12  *
13  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
14  * now has built in overflow checking.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, with an overflow flag.
19      *
20      * _Available since v3.4._
21      */
22     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
23         unchecked {
24             uint256 c = a + b;
25             if (c < a) return (false, 0);
26             return (true, c);
27         }
28     }
29 
30     /**
31      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {
37             if (b > a) return (false, 0);
38             return (true, a - b);
39         }
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50             // benefit is lost if 'b' is also tested.
51             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
52             if (a == 0) return (true, 0);
53             uint256 c = a * b;
54             if (c / a != b) return (false, 0);
55             return (true, c);
56         }
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             if (b == 0) return (false, 0);
67             return (true, a / b);
68         }
69     }
70 
71     /**
72      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a % b);
80         }
81     }
82 
83     /**
84      * @dev Returns the addition of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `+` operator.
88      *
89      * Requirements:
90      *
91      * - Addition cannot overflow.
92      */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a + b;
95     }
96 
97     /**
98      * @dev Returns the subtraction of two unsigned integers, reverting on
99      * overflow (when the result is negative).
100      *
101      * Counterpart to Solidity's `-` operator.
102      *
103      * Requirements:
104      *
105      * - Subtraction cannot overflow.
106      */
107     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a - b;
109     }
110 
111     /**
112      * @dev Returns the multiplication of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `*` operator.
116      *
117      * Requirements:
118      *
119      * - Multiplication cannot overflow.
120      */
121     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
122         return a * b;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator.
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         return a / b;
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * reverting when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a % b;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * CAUTION: This function is deprecated because it requires allocating memory for the error
160      * message unnecessarily. For custom revert reasons use {trySub}.
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         unchecked {
174             require(b <= a, errorMessage);
175             return a - b;
176         }
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         unchecked {
197             require(b > 0, errorMessage);
198             return a / b;
199         }
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * reverting with custom message when dividing by zero.
205      *
206      * CAUTION: This function is deprecated because it requires allocating memory for the error
207      * message unnecessarily. For custom revert reasons use {tryMod}.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         unchecked {
223             require(b > 0, errorMessage);
224             return a % b;
225         }
226     }
227 }
228 
229 /**
230  * @dev Interface of an ERC721A compliant contract.
231  */
232 interface IERC721A {
233     /**
234      * The caller must own the token or be an approved operator.
235      */
236     error ApprovalCallerNotOwnerNorApproved();
237 
238     /**
239      * The token does not exist.
240      */
241     error ApprovalQueryForNonexistentToken();
242 
243     /**
244      * The caller cannot approve to their own address.
245      */
246     error ApproveToCaller();
247 
248     /**
249      * Cannot query the balance for the zero address.
250      */
251     error BalanceQueryForZeroAddress();
252 
253     /**
254      * Cannot mint to the zero address.
255      */
256     error MintToZeroAddress();
257 
258     /**
259      * The quantity of tokens minted must be more than zero.
260      */
261     error MintZeroQuantity();
262 
263     /**
264      * The token does not exist.
265      */
266     error OwnerQueryForNonexistentToken();
267 
268     /**
269      * The caller must own the token or be an approved operator.
270      */
271     error TransferCallerNotOwnerNorApproved();
272 
273     /**
274      * The token must be owned by `from`.
275      */
276     error TransferFromIncorrectOwner();
277 
278     /**
279      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
280      */
281     error TransferToNonERC721ReceiverImplementer();
282 
283     /**
284      * Cannot transfer to the zero address.
285      */
286     error TransferToZeroAddress();
287 
288     /**
289      * The token does not exist.
290      */
291     error URIQueryForNonexistentToken();
292 
293     struct TokenOwnership {
294         // The address of the owner.
295         address addr;
296         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
297         uint64 startTimestamp;
298         // Whether the token has been burned.
299         bool burned;
300     }
301 
302     /**
303      * @dev Returns the total amount of tokens stored by the contract.
304      *
305      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
306      */
307     function totalSupply() external view returns (uint256);
308 
309     // ==============================
310     //            IERC165
311     // ==============================
312 
313     /**
314      * @dev Returns true if this contract implements the interface defined by
315      * `interfaceId`. See the corresponding
316      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
317      * to learn more about how these ids are created.
318      *
319      * This function call must use less than 30 000 gas.
320      */
321     function supportsInterface(bytes4 interfaceId) external view returns (bool);
322 
323     // ==============================
324     //            IERC721
325     // ==============================
326 
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`.
358      *
359      * Requirements:
360      *
361      * - `from` cannot be the zero address.
362      * - `to` cannot be the zero address.
363      * - `tokenId` token must exist and be owned by `from`.
364      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
365      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
366      *
367      * Emits a {Transfer} event.
368      */
369     function safeTransferFrom(
370         address from,
371         address to,
372         uint256 tokenId,
373         bytes calldata data
374     ) external;
375 
376     /**
377      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
378      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
379      *
380      * Requirements:
381      *
382      * - `from` cannot be the zero address.
383      * - `to` cannot be the zero address.
384      * - `tokenId` token must exist and be owned by `from`.
385      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
387      *
388      * Emits a {Transfer} event.
389      */
390     function safeTransferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Transfers `tokenId` token from `from` to `to`.
398      *
399      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `tokenId` token must be owned by `from`.
406      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
407      *
408      * Emits a {Transfer} event.
409      */
410     function transferFrom(
411         address from,
412         address to,
413         uint256 tokenId
414     ) external;
415 
416     /**
417      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
418      * The approval is cleared when the token is transferred.
419      *
420      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
421      *
422      * Requirements:
423      *
424      * - The caller must own the token or be an approved operator.
425      * - `tokenId` must exist.
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address to, uint256 tokenId) external;
430 
431     /**
432      * @dev Approve or remove `operator` as an operator for the caller.
433      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
434      *
435      * Requirements:
436      *
437      * - The `operator` cannot be the caller.
438      *
439      * Emits an {ApprovalForAll} event.
440      */
441     function setApprovalForAll(address operator, bool _approved) external;
442 
443     /**
444      * @dev Returns the account approved for `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function getApproved(uint256 tokenId) external view returns (address operator);
451 
452     /**
453      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
454      *
455      * See {setApprovalForAll}
456      */
457     function isApprovedForAll(address owner, address operator) external view returns (bool);
458 
459     // ==============================
460     //        IERC721Metadata
461     // ==============================
462 
463     /**
464      * @dev Returns the token collection name.
465      */
466     function name() external view returns (string memory);
467 
468     /**
469      * @dev Returns the token collection symbol.
470      */
471     function symbol() external view returns (string memory);
472 
473     /**
474      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
475      */
476     function tokenURI(uint256 tokenId) external view returns (string memory);
477 }
478 
479 
480 /**
481  * @dev ERC721 token receiver interface.
482  */
483 interface ERC721A__IERC721Receiver {
484     function onERC721Received(
485         address operator,
486         address from,
487         uint256 tokenId,
488         bytes calldata data
489     ) external returns (bytes4);
490 }
491 
492 
493 /**
494  * @dev Interface of the ERC20 standard as defined in the EIP.
495  */
496 interface IERC20 {
497     /**
498      * @dev Returns the amount of tokens in existence.
499      */
500     function totalSupply() external view returns (uint256);
501 
502     /**
503      * @dev Returns the amount of tokens owned by `account`.
504      */
505     function balanceOf(address account) external view returns (uint256);
506 
507     /**
508      * @dev Moves `amount` tokens from the caller's account to `recipient`.
509      *
510      * Returns a boolean value indicating whether the operation succeeded.
511      *
512      * Emits a {Transfer} event.
513      */
514     function transfer(address recipient, uint256 amount) external returns (bool);
515 
516     /**
517      * @dev Returns the remaining number of tokens that `spender` will be
518      * allowed to spend on behalf of `owner` through {transferFrom}. This is
519      * zero by default.
520      *
521      * This value changes when {approve} or {transferFrom} are called.
522      */
523     function allowance(address owner, address spender) external view returns (uint256);
524 
525     /**
526      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
527      *
528      * Returns a boolean value indicating whether the operation succeeded.
529      *
530      * IMPORTANT: Beware that changing an allowance with this method brings the risk
531      * that someone may use both the old and the new allowance by unfortunate
532      * transaction ordering. One possible solution to mitigate this race
533      * condition is to first reduce the spender's allowance to 0 and set the
534      * desired value afterwards:
535      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
536      *
537      * Emits an {Approval} event.
538      */
539     function approve(address spender, uint256 amount) external returns (bool);
540 
541     /**
542      * @dev Moves `amount` tokens from `sender` to `recipient` using the
543      * allowance mechanism. `amount` is then deducted from the caller's
544      * allowance.
545      *
546      * Returns a boolean value indicating whether the operation succeeded.
547      *
548      * Emits a {Transfer} event.
549      */
550     function transferFrom(
551         address sender,
552         address recipient,
553         uint256 amount
554     ) external returns (bool);
555 
556     /**
557      * @dev Emitted when `value` tokens are moved from one account (`from`) to
558      * another (`to`).
559      *
560      * Note that `value` may be zero.
561      */
562     event Transfer(address indexed from, address indexed to, uint256 value);
563 
564     /**
565      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
566      * a call to {approve}. `value` is the new allowance.
567      */
568     event Approval(address indexed owner, address indexed spender, uint256 value);
569 }
570 
571 /*
572  * @dev Provides information about the current execution context, including the
573  * sender of the transaction and its data. While these are generally available
574  * via msg.sender and msg.data, they should not be accessed in such a direct
575  * manner, since when dealing with meta-transactions the account sending and
576  * paying for execution may not be the actual sender (as far as an application
577  * is concerned).
578  *
579  * This contract is only required for intermediate, library-like contracts.
580  */
581 abstract contract Context {
582     function _msgSender() internal view virtual returns (address) {
583         return msg.sender;
584     }
585 
586     function _msgData() internal view virtual returns (bytes calldata) {
587         return msg.data;
588     }
589 }
590 
591 
592 /**
593  * @dev Contract module which provides a basic access control mechanism, where
594  * there is an account (an owner) that can be granted exclusive access to
595  * specific functions.
596  *
597  * By default, the owner account will be the one that deploys the contract. This
598  * can later be changed with {transferOwnership}.
599  *
600  * This module is used through inheritance. It will make available the modifier
601  * `onlyOwner`, which can be applied to your functions to restrict their use to
602  * the owner.
603  */
604 abstract contract Ownable is Context {
605     address private _owner;
606 
607     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
608 
609     /**
610      * @dev Initializes the contract setting the deployer as the initial owner.
611      */
612     constructor() {
613         _transferOwnership(_msgSender());
614     }
615 
616     /**
617      * @dev Returns the address of the current owner.
618      */
619     function owner() public view virtual returns (address) {
620         return _owner;
621     }
622 
623     /**
624      * @dev Throws if called by any account other than the owner.
625      */
626     modifier onlyOwner() {
627         require(owner() == _msgSender(), "Ownable: caller is not the owner");
628         _;
629     }
630 
631     /**
632      * @dev Leaves the contract without owner. It will not be possible to call
633      * `onlyOwner` functions anymore. Can only be called by the current owner.
634      *
635      * NOTE: Renouncing ownership will leave the contract without an owner,
636      * thereby removing any functionality that is only available to the owner.
637      */
638     function renounceOwnership() public virtual onlyOwner {
639         _transferOwnership(address(0));
640     }
641 
642     /**
643      * @dev Transfers ownership of the contract to a new account (`newOwner`).
644      * Can only be called by the current owner.
645      */
646     function transferOwnership(address newOwner) public virtual onlyOwner {
647         require(newOwner != address(0), "Ownable: new owner is the zero address");
648         _transferOwnership(newOwner);
649     }
650 
651     /**
652      * @dev Transfers ownership of the contract to a new account (`newOwner`).
653      * Internal function without access restriction.
654      */
655     function _transferOwnership(address newOwner) internal virtual {
656         address oldOwner = _owner;
657         _owner = newOwner;
658         emit OwnershipTransferred(oldOwner, newOwner);
659     }
660 }
661 
662 contract SignatureVerifiable{
663     
664     using SafeMath for uint256;
665     
666     bytes32 public constant DOMAIN_TYPEHASH =keccak256(
667       abi.encodePacked(
668         "EIP712Domain(",
669         "string name,",
670         "string version,",
671         "uint256 chainId,",
672         "address verifyingContract",
673         ")"
674       )
675     );
676 
677     
678     bytes32 public constant DOMAIN_NAME = keccak256("MintableNFT");
679     bytes32 public constant DOMAIN_VERSION = keccak256("1");
680     bytes32 public DOMAIN_SEPARATOR;
681     address public verifyAddress;
682     
683     function getChainId() public view returns (uint256 id) {
684         // no-inline-assembly
685         assembly {
686           id := chainid()
687         }
688     }
689 
690    /**
691    * @notice Recover the signatory from a signature
692    * @param hash bytes32
693    * @param v uint8
694    * @param r bytes32
695    * @param s bytes32
696    */
697     function getSignatory(
698         bytes32 hash,
699         uint8 v,
700         bytes32 r,
701         bytes32 s
702       ) internal view returns (address) {
703         bytes32 digest =
704           keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, hash));
705         address signatory = ecrecover(digest, v, r, s);
706         // Ensure the signatory is not null
707         require(signatory != address(0), "INVALID_SIG");
708         return signatory;
709     }
710 }
711 
712 library Address {
713     /**
714      * @dev Returns true if `account` is a contract.
715      *
716      * [IMPORTANT]
717      * ====
718      * It is unsafe to assume that an address for which this function returns
719      * false is an externally-owned account (EOA) and not a contract.
720      *
721      * Among others, `isContract` will return false for the following
722      * types of addresses:
723      *
724      *  - an externally-owned account
725      *  - a contract in construction
726      *  - an address where a contract will be created
727      *  - an address where a contract lived, but was destroyed
728      * ====
729      */
730     function isContract(address account) internal view returns (bool) {
731         // This method relies in extcodesize, which returns 0 for contracts in
732         // construction, since the code is only stored at the end of the
733         // constructor execution.
734 
735         uint256 size;
736         // solhint-disable-next-line no-inline-assembly
737         assembly { size := extcodesize(account) }
738         return size > 0;
739     }
740 
741     /**
742      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
743      * `recipient`, forwarding all available gas and reverting on errors.
744      *
745      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
746      * of certain opcodes, possibly making contracts go over the 2300 gas limit
747      * imposed by `transfer`, making them unable to receive funds via
748      * `transfer`. {sendValue} removes this limitation.
749      *
750      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
751      *
752      * IMPORTANT: because control is transferred to `recipient`, care must be
753      * taken to not create reentrancy vulnerabilities. Consider using
754      * {ReentrancyGuard} or the
755      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
756      */
757     function sendValue(address payable recipient, uint256 amount) internal {
758         require(address(this).balance >= amount, "Address: insufficient balance");
759 
760         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
761         (bool success, ) = recipient.call{ value: amount }("");
762         require(success, "Address: unable to send value, recipient may have reverted");
763     }
764 
765     /**
766      * @dev Performs a Solidity function call using a low level `call`. A
767      * plain`call` is an unsafe replacement for a function call: use this
768      * function instead.
769      *
770      * If `target` reverts with a revert reason, it is bubbled up by this
771      * function (like regular Solidity function calls).
772      *
773      * Returns the raw returned data. To convert to the expected return value,
774      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
775      *
776      * Requirements:
777      *
778      * - `target` must be a contract.
779      * - calling `target` with `data` must not revert.
780      *
781      * _Available since v3.1._
782      */
783     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
784       return functionCall(target, data, "Address: low-level call failed");
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
789      * `errorMessage` as a fallback revert reason when `target` reverts.
790      *
791      * _Available since v3.1._
792      */
793     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
794         return _functionCallWithValue(target, data, 0, errorMessage);
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
799      * but also transferring `value` wei to `target`.
800      *
801      * Requirements:
802      *
803      * - the calling contract must have an ETH balance of at least `value`.
804      * - the called Solidity function must be `payable`.
805      *
806      * _Available since v3.1._
807      */
808     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
809         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
814      * with `errorMessage` as a fallback revert reason when `target` reverts.
815      *
816      * _Available since v3.1._
817      */
818     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
819         require(address(this).balance >= value, "Address: insufficient balance for call");
820         return _functionCallWithValue(target, data, value, errorMessage);
821     }
822 
823     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
824         require(isContract(target), "Address: call to non-contract");
825 
826         // solhint-disable-next-line avoid-low-level-calls
827         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
828         if (success) {
829             return returndata;
830         } else {
831             // Look for revert reason and bubble it up if present
832             if (returndata.length > 0) {
833                 // The easiest way to bubble the revert reason is using memory via assembly
834 
835                 // solhint-disable-next-line no-inline-assembly
836                 assembly {
837                     let returndata_size := mload(returndata)
838                     revert(add(32, returndata), returndata_size)
839                 }
840             } else {
841                 revert(errorMessage);
842             }
843         }
844     }
845 }
846 
847 library SafeERC20 {
848     using SafeMath for uint256;
849     using Address for address;
850 
851     function safeTransfer(IERC20 token, address to, uint256 value) internal {
852         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
853     }
854 
855     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
856         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
857     }
858 
859     /**
860      * @dev Deprecated. This function has issues similar to the ones found in
861      * {IERC20-approve}, and its usage is discouraged.
862      *
863      * Whenever possible, use {safeIncreaseAllowance} and
864      * {safeDecreaseAllowance} instead.
865      */
866     function safeApprove(IERC20 token, address spender, uint256 value) internal {
867         // safeApprove should only be called when setting an initial allowance,
868         // or when resetting it to zero. To increase and decrease it, use
869         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
870         // solhint-disable-next-line max-line-length
871         require((value == 0) || (token.allowance(address(this), spender) == 0),
872             "SafeERC20: approve from non-zero to non-zero allowance"
873         );
874         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
875     }
876 
877     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
878         uint256 newAllowance = token.allowance(address(this), spender).add(value);
879         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
880     }
881 
882     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
883         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
884         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
885     }
886 
887     /**
888      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
889      * on the return value: the return value is optional (but if data is returned, it must not be false).
890      * @param token The token targeted by the call.
891      * @param data The call data (encoded using abi.encode or one of its variants).
892      */
893     function _callOptionalReturn(IERC20 token, bytes memory data) private {
894         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
895         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
896         // the target address contains contract code and also asserts for success in the low-level call.
897 
898         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
899         if (returndata.length > 0) { // Return data is optional
900             // solhint-disable-next-line max-line-length
901             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
902         }
903     }
904 }
905 
906 /**
907  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
908  * the Metadata extension. Built to optimize for lower gas during batch mints.
909  *
910  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
911  *
912  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
913  *
914  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
915  */
916 contract MintableNFTa is IERC721A,Ownable,SignatureVerifiable {
917 
918     using SafeMath for uint256; 
919     using SafeERC20 for IERC20;
920 
921     // Mask of an entry in packed address data.
922     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
923 
924     // The bit position of `numberMinted` in packed address data.
925     uint256 private constant BITPOS_NUMBER_MINTED = 64;
926 
927     // The bit position of `numberBurned` in packed address data.
928     uint256 private constant BITPOS_NUMBER_BURNED = 128;
929 
930     // The bit position of `aux` in packed address data.
931     uint256 private constant BITPOS_AUX = 192;
932 
933     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
934     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
935 
936     // The bit position of `startTimestamp` in packed ownership.
937     uint256 private constant BITPOS_START_TIMESTAMP = 160;
938 
939     // The bit mask of the `burned` bit in packed ownership.
940     uint256 private constant BITMASK_BURNED = 1 << 224;
941 
942     // The bit position of the `nextInitialized` bit in packed ownership.
943     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
944 
945     // The bit mask of the `nextInitialized` bit in packed ownership.
946     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
947 
948     // The tokenId of the next token to be minted.
949     uint256 private _currentIndex;
950 
951     // The number of tokens burned.
952     uint256 private _burnCounter;
953 
954     // Token name
955     string private _name;
956 
957     // Token symbol
958     string private _symbol;
959 
960     // Mapping from token ID to ownership details
961     // An empty struct value does not necessarily mean the token is unowned.
962     // See `_packedOwnershipOf` implementation for details.
963     //
964     // Bits Layout:
965     // - [0..159]   `addr`
966     // - [160..223] `startTimestamp`
967     // - [224]      `burned`
968     // - [225]      `nextInitialized`
969     mapping(uint256 => uint256) private _packedOwnerships;
970 
971     // Mapping owner address to address data.
972     //
973     // Bits Layout:
974     // - [0..63]    `balance`
975     // - [64..127]  `numberMinted`
976     // - [128..191] `numberBurned`
977     // - [192..255] `aux`
978     mapping(address => uint256) private _packedAddressData;
979 
980     // Mapping from token ID to approved address.
981     mapping(uint256 => address) private _tokenApprovals;
982 
983     // Mapping from owner to operator approvals
984     mapping(address => mapping(address => bool)) private _operatorApprovals;
985 
986     uint256 private _maxSupply;
987 
988     //baseURI prefix
989     string private _baseURI = "";
990 
991     string private _blindURI = "";
992 
993     mapping(address=>mapping(uint256=>uint256)) public userStageMintTotal;
994     mapping(uint256=>uint256) public stageMintTotal;
995     address public devAddress;
996 
997     constructor(string memory __name,string memory __symbol,uint256 __maxSupply,address _verifyAddress,string memory __blindURI) {
998         _currentIndex = _startTokenId();
999         _name = __name;
1000         _symbol = __symbol;
1001         _blindURI = __blindURI;
1002         _maxSupply = __maxSupply;
1003         devAddress = msg.sender;
1004         verifyAddress = _verifyAddress;
1005 
1006         //init signatory
1007         uint256 currentChainId = getChainId();
1008         DOMAIN_SEPARATOR = keccak256(
1009           abi.encode(
1010             DOMAIN_TYPEHASH,
1011             DOMAIN_NAME,
1012             DOMAIN_VERSION,
1013             currentChainId,
1014             this
1015           )
1016         );
1017     }
1018 
1019     
1020     function verifyMint(address sender,uint256 stage,uint256 mintCount,uint256 maxCount,uint256 stageCount,uint256 mintPrice,uint256 expire,uint8 v,uint256 _r,uint256 _s) internal view returns(bool){
1021         bytes32 r = bytes32(_r);
1022         bytes32 s = bytes32(_s);        
1023         bytes32 hash = keccak256(
1024             abi.encode(
1025               keccak256(abi.encodePacked("payment(address sender,uint256 stage,uint256 mintCount,uint256 maxCount,uint256 stageCount,uint256 mintPrice,uint256 expire)")),
1026               sender,stage,mintCount,maxCount,stageCount,mintPrice,expire
1027             )
1028         );
1029         if(getSignatory(hash,v,r,s) == verifyAddress){
1030             return true;
1031         }
1032         else{
1033             return false;
1034         }
1035     }
1036     
1037     function setDevAddress(address _devAddress) public onlyOwner{
1038         require(_devAddress!=address(0),"address invalid.");
1039         devAddress = _devAddress;
1040     }
1041 
1042     function setVerifyAddress(address _addr) public onlyOwner{
1043         verifyAddress = _addr;
1044     }
1045 
1046     function sweep(address _tokenAddress) public onlyOwner{
1047         uint256 amount = IERC20(_tokenAddress).balanceOf(address(this));
1048         if(amount > 0){
1049             IERC20(_tokenAddress).safeTransfer(msg.sender,amount);
1050         }
1051     }
1052     
1053     //admin function 
1054     function setBaseURI(string memory baseURI_) public onlyOwner{
1055         _baseURI = baseURI_;
1056     }
1057 
1058     function setBlindURI(string memory blindURI_) public onlyOwner{
1059         _blindURI = blindURI_;
1060     }
1061 
1062     function mint(address sender,uint256 stage,uint256 mintCount,uint256 maxCount,uint256 stageCount,uint256 mintPrice,uint256 expire,uint8 v,uint256 _r,uint256 _s) public payable{
1063         require(msg.sender==tx.origin,"human only"); 
1064         require(userStageMintTotal[msg.sender][stage].add(mintCount)<=maxCount,"user mint max");
1065         require(totalSupply().add(mintCount)<=_maxSupply,"max"); 
1066         require(totalSupply().add(mintCount)<=stageCount,"stage max"); 
1067         require(block.timestamp<=expire,"expired.");
1068         require(verifyMint(sender,stage,mintCount,maxCount,stageCount,mintPrice,expire,v,_r,_s),"invalid sig");
1069 
1070         require(msg.value>=mintPrice,"payment insufficient");
1071         uint256 lessAmount = msg.value.sub(mintPrice);
1072         if(lessAmount>0)
1073                 payable(msg.sender).transfer(lessAmount);
1074         payable(devAddress).transfer(mintPrice); 
1075         
1076         //mint...
1077         _safeMint(msg.sender,mintCount);
1078         userStageMintTotal[msg.sender][stage]  = userStageMintTotal[msg.sender][stage].add(mintCount);    
1079         stageMintTotal[stage] = stageMintTotal[stage].add(mintCount);
1080     }
1081 
1082     /**
1083      * @dev Returns the starting token ID.
1084      * To change the starting token ID, please override this function.
1085      */
1086     function _startTokenId() internal view virtual returns (uint256) {
1087         return 0;
1088     }
1089 
1090     /**
1091      * @dev Returns the next token ID to be minted.
1092      */
1093     function _nextTokenId() internal view returns (uint256) {
1094         return _currentIndex;
1095     }
1096 
1097     /**
1098      * @dev Returns the total number of tokens in existence.
1099      * Burned tokens will reduce the count.
1100      * To get the total number of tokens minted, please see `_totalMinted`.
1101      */
1102     function totalSupply() public view override returns (uint256) {
1103         // Counter underflow is impossible as _burnCounter cannot be incremented
1104         // more than `_currentIndex - _startTokenId()` times.
1105         unchecked {
1106             return _currentIndex - _burnCounter - _startTokenId();
1107         }
1108     }
1109 
1110     function maxSupply() public view returns (uint256){
1111         return _maxSupply;
1112     }
1113 
1114     /**
1115      * @dev Returns the total amount of tokens minted in the contract.
1116      */
1117     function _totalMinted() internal view returns (uint256) {
1118         // Counter underflow is impossible as _currentIndex does not decrement,
1119         // and it is initialized to `_startTokenId()`
1120         unchecked {
1121             return _currentIndex - _startTokenId();
1122         }
1123     }
1124 
1125     /**
1126      * @dev Returns the total number of tokens burned.
1127      */
1128     function _totalBurned() internal view returns (uint256) {
1129         return _burnCounter;
1130     }
1131 
1132     /**
1133      * @dev See {IERC165-supportsInterface}.
1134      */
1135     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1136         // The interface IDs are constants representing the first 4 bytes of the XOR of
1137         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1138         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1139         return
1140             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1141             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1142             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-balanceOf}.
1147      */
1148     function balanceOf(address owner) public view override returns (uint256) {
1149         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
1150         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1151     }
1152 
1153     /**
1154      * Returns the number of tokens minted by `owner`.
1155      */
1156     function _numberMinted(address owner) internal view returns (uint256) {
1157         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1158     }
1159 
1160     /**
1161      * Returns the number of tokens burned by or on behalf of `owner`.
1162      */
1163     function _numberBurned(address owner) internal view returns (uint256) {
1164         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1165     }
1166 
1167     /**
1168      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1169      */
1170     function _getAux(address owner) internal view returns (uint64) {
1171         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1172     }
1173 
1174     /**
1175      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1176      * If there are multiple variables, please pack them into a uint64.
1177      */
1178     function _setAux(address owner, uint64 aux) internal {
1179         uint256 packed = _packedAddressData[owner];
1180         uint256 auxCasted;
1181         assembly {
1182             // Cast aux without masking.
1183             auxCasted := aux
1184         }
1185         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1186         _packedAddressData[owner] = packed;
1187     }
1188 
1189     /**
1190      * Returns the packed ownership data of `tokenId`.
1191      */
1192     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1193         uint256 curr = tokenId;
1194 
1195         unchecked {
1196             if (_startTokenId() <= curr)
1197                 if (curr < _currentIndex) {
1198                     uint256 packed = _packedOwnerships[curr];
1199                     // If not burned.
1200                     if (packed & BITMASK_BURNED == 0) {
1201                         // Invariant:
1202                         // There will always be an ownership that has an address and is not burned
1203                         // before an ownership that does not have an address and is not burned.
1204                         // Hence, curr will not underflow.
1205                         //
1206                         // We can directly compare the packed value.
1207                         // If the address is zero, packed is zero.
1208                         while (packed == 0) {
1209                             packed = _packedOwnerships[--curr];
1210                         }
1211                         return packed;
1212                     }
1213                 }
1214         }
1215         revert OwnerQueryForNonexistentToken();
1216     }
1217 
1218     /**
1219      * Returns the unpacked `TokenOwnership` struct from `packed`.
1220      */
1221     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1222         ownership.addr = address(uint160(packed));
1223         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1224         ownership.burned = packed & BITMASK_BURNED != 0;
1225     }
1226 
1227     /**
1228      * Returns the unpacked `TokenOwnership` struct at `index`.
1229      */
1230     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1231         return _unpackedOwnership(_packedOwnerships[index]);
1232     }
1233 
1234     /**
1235      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1236      */
1237     function _initializeOwnershipAt(uint256 index) internal {
1238         if (_packedOwnerships[index] == 0) {
1239             _packedOwnerships[index] = _packedOwnershipOf(index);
1240         }
1241     }
1242 
1243     /**
1244      * Gas spent here starts off proportional to the maximum mint batch size.
1245      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1246      */
1247     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1248         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1249     }
1250 
1251     /**
1252      * @dev See {IERC721-ownerOf}.
1253      */
1254     function ownerOf(uint256 tokenId) public view override returns (address) {
1255         return address(uint160(_packedOwnershipOf(tokenId)));
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Metadata-name}.
1260      */
1261     function name() public view virtual override returns (string memory) {
1262         return _name;
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Metadata-symbol}.
1267      */
1268     function symbol() public view virtual override returns (string memory) {
1269         return _symbol;
1270     }
1271 
1272     /**
1273      * @dev See {IERC721Metadata-tokenURI}.
1274      */
1275     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1276         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1277         return bytes(_baseURI).length > 0 ? string(abi.encodePacked(_baseURI, _toString(tokenId))) : _blindURI;
1278     }
1279 
1280     /**
1281      * @dev Casts the address to uint256 without masking.
1282      */
1283     function _addressToUint256(address value) private pure returns (uint256 result) {
1284         assembly {
1285             result := value
1286         }
1287     }
1288 
1289     /**
1290      * @dev Casts the boolean to uint256 without branching.
1291      */
1292     function _boolToUint256(bool value) private pure returns (uint256 result) {
1293         assembly {
1294             result := value
1295         }
1296     }
1297 
1298     /**
1299      * @dev See {IERC721-approve}.
1300      */
1301     function approve(address to, uint256 tokenId) public override {
1302         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1303 
1304         if (_msgSenderERC721A() != owner)
1305             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1306                 revert ApprovalCallerNotOwnerNorApproved();
1307             }
1308 
1309         _tokenApprovals[tokenId] = to;
1310         emit Approval(owner, to, tokenId);
1311     }
1312 
1313     /**
1314      * @dev See {IERC721-getApproved}.
1315      */
1316     function getApproved(uint256 tokenId) public view override returns (address) {
1317         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1318 
1319         return _tokenApprovals[tokenId];
1320     }
1321 
1322     /**
1323      * @dev See {IERC721-setApprovalForAll}.
1324      */
1325     function setApprovalForAll(address operator, bool approved) public virtual override {
1326         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1327 
1328         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1329         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1330     }
1331 
1332     /**
1333      * @dev See {IERC721-isApprovedForAll}.
1334      */
1335     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1336         return _operatorApprovals[owner][operator];
1337     }
1338 
1339     /**
1340      * @dev See {IERC721-transferFrom}.
1341      */
1342     function transferFrom(
1343         address from,
1344         address to,
1345         uint256 tokenId
1346     ) public virtual override {
1347         _transfer(from, to, tokenId);
1348     }
1349 
1350     /**
1351      * @dev See {IERC721-safeTransferFrom}.
1352      */
1353     function safeTransferFrom(
1354         address from,
1355         address to,
1356         uint256 tokenId
1357     ) public virtual override {
1358         safeTransferFrom(from, to, tokenId, '');
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-safeTransferFrom}.
1363      */
1364     function safeTransferFrom(
1365         address from,
1366         address to,
1367         uint256 tokenId,
1368         bytes memory _data
1369     ) public virtual override {
1370         _transfer(from, to, tokenId);
1371         if (to.code.length != 0)
1372             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1373                 revert TransferToNonERC721ReceiverImplementer();
1374             }
1375     }
1376 
1377     /**
1378      * @dev Returns whether `tokenId` exists.
1379      *
1380      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1381      *
1382      * Tokens start existing when they are minted (`_mint`),
1383      */
1384     function _exists(uint256 tokenId) internal view returns (bool) {
1385         return
1386             _startTokenId() <= tokenId &&
1387             tokenId < _currentIndex && // If within bounds,
1388             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1389     }
1390 
1391     /**
1392      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1393      */
1394     function _safeMint(address to, uint256 quantity) internal {
1395         _safeMint(to, quantity, '');
1396     }
1397 
1398     /**
1399      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1400      *
1401      * Requirements:
1402      *
1403      * - If `to` refers to a smart contract, it must implement
1404      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1405      * - `quantity` must be greater than 0.
1406      *
1407      * Emits a {Transfer} event for each mint.
1408      */
1409     function _safeMint(
1410         address to,
1411         uint256 quantity,
1412         bytes memory _data
1413     ) internal {
1414         _mint(to, quantity);
1415 
1416         unchecked {
1417             if (to.code.length != 0) {
1418                 uint256 end = _currentIndex;
1419                 uint256 index = end - quantity;
1420                 do {
1421                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1422                         revert TransferToNonERC721ReceiverImplementer();
1423                     }
1424                 } while (index < end);
1425                 // Reentrancy protection.
1426                 if (_currentIndex != end) revert();
1427             }
1428         }
1429     }
1430 
1431     /**
1432      * @dev Mints `quantity` tokens and transfers them to `to`.
1433      *
1434      * Requirements:
1435      *
1436      * - `to` cannot be the zero address.
1437      * - `quantity` must be greater than 0.
1438      *
1439      * Emits a {Transfer} event for each mint.
1440      */
1441     function _mint(address to, uint256 quantity) internal {
1442         uint256 startTokenId = _currentIndex;
1443         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1444         if (quantity == 0) revert MintZeroQuantity();
1445 
1446         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1447 
1448         // Overflows are incredibly unrealistic.
1449         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1450         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1451         unchecked {
1452             // Updates:
1453             // - `balance += quantity`.
1454             // - `numberMinted += quantity`.
1455             //
1456             // We can directly add to the balance and number minted.
1457             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1458 
1459             // Updates:
1460             // - `address` to the owner.
1461             // - `startTimestamp` to the timestamp of minting.
1462             // - `burned` to `false`.
1463             // - `nextInitialized` to `quantity == 1`.
1464             _packedOwnerships[startTokenId] =
1465                 _addressToUint256(to) |
1466                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1467                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1468 
1469             uint256 offset;
1470             do {
1471                 emit Transfer(address(0), to, startTokenId + offset++);
1472             } while (offset < quantity);
1473 
1474             _currentIndex = startTokenId + quantity;
1475         }
1476         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1477     }
1478 
1479     /**
1480      * @dev Transfers `tokenId` from `from` to `to`.
1481      *
1482      * Requirements:
1483      *
1484      * - `to` cannot be the zero address.
1485      * - `tokenId` token must be owned by `from`.
1486      *
1487      * Emits a {Transfer} event.
1488      */
1489     function _transfer(
1490         address from,
1491         address to,
1492         uint256 tokenId
1493     ) private {
1494         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1495 
1496         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1497 
1498         address approvedAddress = _tokenApprovals[tokenId];
1499 
1500         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1501             isApprovedForAll(from, _msgSenderERC721A()) ||
1502             approvedAddress == _msgSenderERC721A());
1503 
1504         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1505         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1506 
1507         _beforeTokenTransfers(from, to, tokenId, 1);
1508 
1509         // Clear approvals from the previous owner.
1510         if (_addressToUint256(approvedAddress) != 0) {
1511             delete _tokenApprovals[tokenId];
1512         }
1513 
1514         // Underflow of the sender's balance is impossible because we check for
1515         // ownership above and the recipient's balance can't realistically overflow.
1516         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1517         unchecked {
1518             // We can directly increment and decrement the balances.
1519             --_packedAddressData[from]; // Updates: `balance -= 1`.
1520             ++_packedAddressData[to]; // Updates: `balance += 1`.
1521 
1522             // Updates:
1523             // - `address` to the next owner.
1524             // - `startTimestamp` to the timestamp of transfering.
1525             // - `burned` to `false`.
1526             // - `nextInitialized` to `true`.
1527             _packedOwnerships[tokenId] =
1528                 _addressToUint256(to) |
1529                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1530                 BITMASK_NEXT_INITIALIZED;
1531 
1532             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1533             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1534                 uint256 nextTokenId = tokenId + 1;
1535                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1536                 if (_packedOwnerships[nextTokenId] == 0) {
1537                     // If the next slot is within bounds.
1538                     if (nextTokenId != _currentIndex) {
1539                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1540                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1541                     }
1542                 }
1543             }
1544         }
1545 
1546         emit Transfer(from, to, tokenId);
1547         _afterTokenTransfers(from, to, tokenId, 1);
1548     }
1549 
1550     /**
1551      * @dev Equivalent to `_burn(tokenId, false)`.
1552      */
1553     function _burn(uint256 tokenId) internal virtual {
1554         _burn(tokenId, false);
1555     }
1556 
1557     /**
1558      * @dev Destroys `tokenId`.
1559      * The approval is cleared when the token is burned.
1560      *
1561      * Requirements:
1562      *
1563      * - `tokenId` must exist.
1564      *
1565      * Emits a {Transfer} event.
1566      */
1567     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1568         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1569 
1570         address from = address(uint160(prevOwnershipPacked));
1571         address approvedAddress = _tokenApprovals[tokenId];
1572 
1573         if (approvalCheck) {
1574             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1575                 isApprovedForAll(from, _msgSenderERC721A()) ||
1576                 approvedAddress == _msgSenderERC721A());
1577 
1578             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1579         }
1580 
1581         _beforeTokenTransfers(from, address(0), tokenId, 1);
1582 
1583         // Clear approvals from the previous owner.
1584         if (_addressToUint256(approvedAddress) != 0) {
1585             delete _tokenApprovals[tokenId];
1586         }
1587 
1588         // Underflow of the sender's balance is impossible because we check for
1589         // ownership above and the recipient's balance can't realistically overflow.
1590         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1591         unchecked {
1592             // Updates:
1593             // - `balance -= 1`.
1594             // - `numberBurned += 1`.
1595             //
1596             // We can directly decrement the balance, and increment the number burned.
1597             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1598             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1599 
1600             // Updates:
1601             // - `address` to the last owner.
1602             // - `startTimestamp` to the timestamp of burning.
1603             // - `burned` to `true`.
1604             // - `nextInitialized` to `true`.
1605             _packedOwnerships[tokenId] =
1606                 _addressToUint256(from) |
1607                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1608                 BITMASK_BURNED |
1609                 BITMASK_NEXT_INITIALIZED;
1610 
1611             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1612             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1613                 uint256 nextTokenId = tokenId + 1;
1614                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1615                 if (_packedOwnerships[nextTokenId] == 0) {
1616                     // If the next slot is within bounds.
1617                     if (nextTokenId != _currentIndex) {
1618                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1619                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1620                     }
1621                 }
1622             }
1623         }
1624 
1625         emit Transfer(from, address(0), tokenId);
1626         _afterTokenTransfers(from, address(0), tokenId, 1);
1627 
1628         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1629         unchecked {
1630             _burnCounter++;
1631         }
1632     }
1633 
1634     /**
1635      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1636      *
1637      * @param from address representing the previous owner of the given token ID
1638      * @param to target address that will receive the tokens
1639      * @param tokenId uint256 ID of the token to be transferred
1640      * @param _data bytes optional data to send along with the call
1641      * @return bool whether the call correctly returned the expected magic value
1642      */
1643     function _checkContractOnERC721Received(
1644         address from,
1645         address to,
1646         uint256 tokenId,
1647         bytes memory _data
1648     ) private returns (bool) {
1649         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1650             bytes4 retval
1651         ) {
1652             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1653         } catch (bytes memory reason) {
1654             if (reason.length == 0) {
1655                 revert TransferToNonERC721ReceiverImplementer();
1656             } else {
1657                 assembly {
1658                     revert(add(32, reason), mload(reason))
1659                 }
1660             }
1661         }
1662     }
1663 
1664     /**
1665      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1666      * And also called before burning one token.
1667      *
1668      * startTokenId - the first token id to be transferred
1669      * quantity - the amount to be transferred
1670      *
1671      * Calling conditions:
1672      *
1673      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1674      * transferred to `to`.
1675      * - When `from` is zero, `tokenId` will be minted for `to`.
1676      * - When `to` is zero, `tokenId` will be burned by `from`.
1677      * - `from` and `to` are never both zero.
1678      */
1679     function _beforeTokenTransfers(
1680         address from,
1681         address to,
1682         uint256 startTokenId,
1683         uint256 quantity
1684     ) internal virtual {}
1685 
1686     /**
1687      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1688      * minting.
1689      * And also called after one token has been burned.
1690      *
1691      * startTokenId - the first token id to be transferred
1692      * quantity - the amount to be transferred
1693      *
1694      * Calling conditions:
1695      *
1696      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1697      * transferred to `to`.
1698      * - When `from` is zero, `tokenId` has been minted for `to`.
1699      * - When `to` is zero, `tokenId` has been burned by `from`.
1700      * - `from` and `to` are never both zero.
1701      */
1702     function _afterTokenTransfers(
1703         address from,
1704         address to,
1705         uint256 startTokenId,
1706         uint256 quantity
1707     ) internal virtual {}
1708 
1709     /**
1710      * @dev Returns the message sender (defaults to `msg.sender`).
1711      *
1712      * If you are writing GSN compatible contracts, you need to override this function.
1713      */
1714     function _msgSenderERC721A() internal view virtual returns (address) {
1715         return msg.sender;
1716     }
1717 
1718     /**
1719      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1720      */
1721     function _toString(uint256 value) internal pure returns (string memory ptr) {
1722         assembly {
1723             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1724             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1725             // We will need 1 32-byte word to store the length,
1726             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1727             ptr := add(mload(0x40), 128)
1728             // Update the free memory pointer to allocate.
1729             mstore(0x40, ptr)
1730 
1731             // Cache the end of the memory to calculate the length later.
1732             let end := ptr
1733 
1734             // We write the string from the rightmost digit to the leftmost digit.
1735             // The following is essentially a do-while loop that also handles the zero case.
1736             // Costs a bit more than early returning for the zero case,
1737             // but cheaper in terms of deployment and overall runtime costs.
1738             for {
1739                 // Initialize and perform the first pass without check.
1740                 let temp := value
1741                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1742                 ptr := sub(ptr, 1)
1743                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1744                 mstore8(ptr, add(48, mod(temp, 10)))
1745                 temp := div(temp, 10)
1746             } temp {
1747                 // Keep dividing `temp` until zero.
1748                 temp := div(temp, 10)
1749             } {
1750                 // Body of the for loop.
1751                 ptr := sub(ptr, 1)
1752                 mstore8(ptr, add(48, mod(temp, 10)))
1753             }
1754 
1755             let length := sub(end, ptr)
1756             // Move the pointer 32 bytes leftwards to make room for the length.
1757             ptr := sub(ptr, 32)
1758             // Store the length.
1759             mstore(ptr, length)
1760         }
1761     }
1762 }