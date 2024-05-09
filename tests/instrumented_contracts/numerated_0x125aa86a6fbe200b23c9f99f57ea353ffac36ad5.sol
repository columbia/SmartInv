1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-02
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2021-10-18
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.7;
12 
13 interface IERC20 {
14   /**
15    * @dev Returns the amount of tokens in existence.
16    */
17   function totalSupply() external view returns (uint256);
18 
19   /**
20    * @dev Returns the token decimals.
21    */
22   function decimals() external view returns (uint8);
23 
24   /**
25    * @dev Returns the token symbol.
26    */
27   function symbol() external view returns (string memory);
28 
29   /**
30   * @dev Returns the token name.
31   */
32   function name() external view returns (string memory);
33 
34   /**
35    * @dev Returns the bep token owner.
36    */
37   function getOwner() external view returns (address);
38 
39   /**
40    * @dev Returns the amount of tokens owned by `account`.
41    */
42   function balanceOf(address account) external view returns (uint256);
43 
44   /**
45    * @dev Moves `amount` tokens from the caller's account to `recipient`.
46    *
47    * Returns a boolean value indicating whether the operation succeeded.
48    *
49    * Emits a {Transfer} event.
50    */
51   function transfer(address recipient, uint256 amount) external returns (bool);
52 
53   /**
54    * @dev Returns the remaining number of tokens that `spender` will be
55    * allowed to spend on behalf of `owner` through {transferFrom}. This is
56    * zero by default.
57    *
58    * This value changes when {approve} or {transferFrom} are called.
59    */
60   function allowance(address _owner, address spender) external view returns (uint256);
61 
62   /**
63    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64    *
65    * Returns a boolean value indicating whether the operation succeeded.
66    *
67    * IMPORTANT: Beware that changing an allowance with this method brings the risk
68    * that someone may use both the old and the new allowance by unfortunate
69    * transaction ordering. One possible solution to mitigate this race
70    * condition is to first reduce the spender's allowance to 0 and set the
71    * desired value afterwards:
72    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73    *
74    * Emits an {Approval} event.
75    */
76   function approve(address spender, uint256 amount) external returns (bool);
77 
78   /**
79    * @dev Moves `amount` tokens from `sender` to `recipient` using the
80    * allowance mechanism. `amount` is then deducted from the caller's
81    * allowance.
82    *
83    * Returns a boolean value indicating whether the operation succeeded.
84    *
85    * Emits a {Transfer} event.
86    */
87   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89   /**
90    * @dev Emitted when `value` tokens are moved from one account (`from`) to
91    * another (`to`).
92    *
93    * Note that `value` may be zero.
94    */
95   event Transfer(address indexed from, address indexed to, uint256 value);
96 
97   /**
98    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99    * a call to {approve}. `value` is the new allowance.
100    */
101   event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 /*
105  * @dev Provides information about the current execution context, including the
106  * sender of the transaction and its data. While these are generally available
107  * via msg.sender and msg.data, they should not be accessed in such a direct
108  * manner, since when dealing with GSN meta-transactions the account sending and
109  * paying for execution may not be the actual sender (as far as an application
110  * is concerned).
111  *
112  * This contract is only required for intermediate, library-like contracts.
113  */
114 contract Context {
115   // Empty internal constructor, to prevent people from mistakenly deploying
116   // an instance of this contract, which should be used via inheritance.
117   constructor ()  { }
118 
119   function _msgSender() internal view returns (address payable) {
120     return payable (msg.sender);
121   }
122 
123   function _msgData() internal view returns (bytes memory) {
124     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
125     return msg.data;
126   }
127 }
128 
129 /**
130  * @dev Wrappers over Solidity's arithmetic operations with added overflow
131  * checks.
132  *
133  * Arithmetic operations in Solidity wrap on overflow. This can easily result
134  * in bugs, because programmers usually assume that an overflow raises an
135  * error, which is the standard behavior in high level programming languages.
136  * `SafeMath` restores this intuition by reverting the transaction when an
137  * operation overflows.
138  *
139  * Using this library instead of the unchecked operations eliminates an entire
140  * class of bugs, so it's recommended to use it always.
141  */
142 library SafeMath {
143   /**
144    * @dev Returns the addition of two unsigned integers, reverting on
145    * overflow.
146    *
147    * Counterpart to Solidity's `+` operator.
148    *
149    * Requirements:
150    * - Addition cannot overflow.
151    */
152   function add(uint256 a, uint256 b) internal pure returns (uint256) {
153     uint256 c = a + b;
154     require(c >= a, "SafeMath: addition overflow");
155 
156     return c;
157   }
158 
159   /**
160    * @dev Returns the subtraction of two unsigned integers, reverting on
161    * overflow (when the result is negative).
162    *
163    * Counterpart to Solidity's `-` operator.
164    *
165    * Requirements:
166    * - Subtraction cannot overflow.
167    */
168   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169     return sub(a, b, "SafeMath: subtraction overflow");
170   }
171 
172   /**
173    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
174    * overflow (when the result is negative).
175    *
176    * Counterpart to Solidity's `-` operator.
177    *
178    * Requirements:
179    * - Subtraction cannot overflow.
180    */
181   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182     require(b <= a, errorMessage);
183     uint256 c = a - b;
184 
185     return c;
186   }
187 
188   /**
189    * @dev Returns the multiplication of two unsigned integers, reverting on
190    * overflow.
191    *
192    * Counterpart to Solidity's `*` operator.
193    *
194    * Requirements:
195    * - Multiplication cannot overflow.
196    */
197   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
199     // benefit is lost if 'b' is also tested.
200     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
201     if (a == 0) {
202       return 0;
203     }
204 
205     uint256 c = a * b;
206     require(c / a == b, "SafeMath: multiplication overflow");
207 
208     return c;
209   }
210 
211   /**
212    * @dev Returns the integer division of two unsigned integers. Reverts on
213    * division by zero. The result is rounded towards zero.
214    *
215    * Counterpart to Solidity's `/` operator. Note: this function uses a
216    * `revert` opcode (which leaves remaining gas untouched) while Solidity
217    * uses an invalid opcode to revert (consuming all remaining gas).
218    *
219    * Requirements:
220    * - The divisor cannot be zero.
221    */
222   function div(uint256 a, uint256 b) internal pure returns (uint256) {
223     return div(a, b, "SafeMath: division by zero");
224   }
225 
226   /**
227    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
228    * division by zero. The result is rounded towards zero.
229    *
230    * Counterpart to Solidity's `/` operator. Note: this function uses a
231    * `revert` opcode (which leaves remaining gas untouched) while Solidity
232    * uses an invalid opcode to revert (consuming all remaining gas).
233    *
234    * Requirements:
235    * - The divisor cannot be zero.
236    */
237   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238     // Solidity only automatically asserts when dividing by 0
239     require(b > 0, errorMessage);
240     uint256 c = a / b;
241     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242 
243     return c;
244   }
245 
246   /**
247    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248    * Reverts when dividing by zero.
249    *
250    * Counterpart to Solidity's `%` operator. This function uses a `revert`
251    * opcode (which leaves remaining gas untouched) while Solidity uses an
252    * invalid opcode to revert (consuming all remaining gas).
253    *
254    * Requirements:
255    * - The divisor cannot be zero.
256    */
257   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258     return mod(a, b, "SafeMath: modulo by zero");
259   }
260 
261   /**
262    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263    * Reverts with custom message when dividing by zero.
264    *
265    * Counterpart to Solidity's `%` operator. This function uses a `revert`
266    * opcode (which leaves remaining gas untouched) while Solidity uses an
267    * invalid opcode to revert (consuming all remaining gas).
268    *
269    * Requirements:
270    * - The divisor cannot be zero.
271    */
272   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273     require(b != 0, errorMessage);
274     return a % b;
275   }
276 }
277 
278 /**
279  * @dev Contract module which provides a basic access control mechanism, where
280  * there is an account (an owner) that can be granted exclusive access to
281  * specific functions.
282  *
283  * By default, the owner account will be the one that deploys the contract. This
284  * can later be changed with {transferOwnership}.
285  *
286  * This module is used through inheritance. It will make available the modifier
287  * `onlyOwner`, which can be applied to your functions to restrict their use to
288  * the owner.
289  */
290 contract Ownable is Context {
291   address private _owner;
292 
293   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
294 
295   /**
296    * @dev Initializes the contract setting the deployer as the initial owner.
297    */
298   constructor ()  {
299     address msgSender = _msgSender();
300     _owner = msgSender;
301     emit OwnershipTransferred(address(0), msgSender);
302   }
303 
304   /**
305    * @dev Returns the address of the current owner.
306    */
307   function owner() public view returns (address) {
308     return _owner;
309   }
310 
311   /**
312    * @dev Throws if called by any account other than the owner.
313    */
314   modifier onlyOwner() {
315     require(_owner == _msgSender(), "Ownable: caller is not the owner");
316     _;
317   }
318 
319   /**
320    * @dev Leaves the contract without owner. It will not be possible to call
321    * `onlyOwner` functions anymore. Can only be called by the current owner.
322    *
323    * NOTE: Renouncing ownership will leave the contract without an owner,
324    * thereby removing any functionality that is only available to the owner.
325    */
326   function renounceOwnership() public onlyOwner {
327     emit OwnershipTransferred(_owner, address(0));
328     _owner = address(0);
329   }
330 
331   /**
332    * @dev Transfers ownership of the contract to a new account (`newOwner`).
333    * Can only be called by the current owner.
334    */
335   function transferOwnership(address newOwner) public onlyOwner {
336     _transferOwnership(newOwner);
337   }
338 
339   /**
340    * @dev Transfers ownership of the contract to a new account (`newOwner`).
341    */
342   function _transferOwnership(address newOwner) internal {
343     require(newOwner != address(0), "Ownable: new owner is the zero address");
344     emit OwnershipTransferred(_owner, newOwner);
345     _owner = newOwner;
346   }
347 }
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
368         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
369         // for accounts without code, i.e. `keccak256('')`
370         bytes32 codehash;
371         bytes32 accountHash =
372             0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
373         // solhint-disable-next-line no-inline-assembly
374         assembly {
375             codehash := extcodehash(account)
376         }
377         return (codehash != accountHash && codehash != 0x0);
378     }
379 
380     /**
381      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
382      * `recipient`, forwarding all available gas and reverting on errors.
383      *
384      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
385      * of certain opcodes, possibly making contracts go over the 2300 gas limit
386      * imposed by `transfer`, making them unable to receive funds via
387      * `transfer`. {sendValue} removes this limitation.
388      *
389      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
390      *
391      * IMPORTANT: because control is transferred to `recipient`, care must be
392      * taken to not create reentrancy vulnerabilities. Consider using
393      * {ReentrancyGuard} or the
394      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
395      */
396     function sendValue(address payable recipient, uint256 amount) internal {
397         require(
398             address(this).balance >= amount,
399             "Address: insufficient balance"
400         );
401 
402         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
403         (bool success, ) = recipient.call{value: amount}("");
404         require(
405             success,
406             "Address: unable to send value, recipient may have reverted"
407         );
408     }
409 
410     /**
411      * @dev Performs a Solidity function call using a low level `call`. A
412      * plain`call` is an unsafe replacement for a function call: use this
413      * function instead.
414      *
415      * If `target` reverts with a revert reason, it is bubbled up by this
416      * function (like regular Solidity function calls).
417      *
418      * Returns the raw returned data. To convert to the expected return value,
419      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
420      *
421      * Requirements:
422      *
423      * - `target` must be a contract.
424      * - calling `target` with `data` must not revert.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(address target, bytes memory data)
429         internal
430         returns (bytes memory)
431     {
432         return functionCall(target, data, "Address: low-level call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
437      * `errorMessage` as a fallback revert reason when `target` reverts.
438      *
439      * _Available since v3.1._
440      */
441     function functionCall(
442         address target,
443         bytes memory data,
444         string memory errorMessage
445     ) internal returns (bytes memory) {
446         return _functionCallWithValue(target, data, 0, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but also transferring `value` wei to `target`.
452      *
453      * Requirements:
454      *
455      * - the calling contract must have an ETH balance of at least `value`.
456      * - the called Solidity function must be `payable`.
457      *
458      * _Available since v3.1._
459      */
460     function functionCallWithValue(
461         address target,
462         bytes memory data,
463         uint256 value
464     ) internal returns (bytes memory) {
465         return
466             functionCallWithValue(
467                 target,
468                 data,
469                 value,
470                 "Address: low-level call with value failed"
471             );
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
476      * with `errorMessage` as a fallback revert reason when `target` reverts.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         require(
487             address(this).balance >= value,
488             "Address: insufficient balance for call"
489         );
490         return _functionCallWithValue(target, data, value, errorMessage);
491     }
492 
493     function _functionCallWithValue(
494         address target,
495         bytes memory data,
496         uint256 weiValue,
497         string memory errorMessage
498     ) private returns (bytes memory) {
499         require(isContract(target), "Address: call to non-contract");
500 
501         // solhint-disable-next-line avoid-low-level-calls
502         (bool success, bytes memory returndata) =
503             target.call{value: weiValue}(data);
504         if (success) {
505             return returndata;
506         } else {
507             // Look for revert reason and bubble it up if present
508             if (returndata.length > 0) {
509                 // The easiest way to bubble the revert reason is using memory via assembly
510 
511                 // solhint-disable-next-line no-inline-assembly
512                 assembly {
513                     let returndata_size := mload(returndata)
514                     revert(add(32, returndata), returndata_size)
515                 }
516             } else {
517                 revert(errorMessage);
518             }
519         }
520     }
521 }
522 interface IERC165 {
523     /**
524      * @dev Returns true if this contract implements the interface defined by
525      * `interfaceId`. See the corresponding
526      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
527      * to learn more about how these ids are created.
528      *
529      * This function call must use less than 30 000 gas.
530      */
531     function supportsInterface(bytes4 interfaceId) external view returns (bool);
532 }
533 interface IERC721 is IERC165 {
534     /**
535      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
536      */
537     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
538 
539     /**
540      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
541      */
542     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
543 
544     /**
545      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
546      */
547     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
548 
549     /**
550      * @dev Returns the number of tokens in ``owner``'s account.
551      */
552     function balanceOf(address owner) external view returns (uint256 balance);
553 
554     /**
555      * @dev Returns the owner of the `tokenId` token.
556      *
557      * Requirements:
558      *
559      * - `tokenId` must exist.
560      */
561     function ownerOf(uint256 tokenId) external view returns (address owner);
562 
563     /**
564      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
565      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
566      *
567      * Requirements:
568      *
569      * - `from` cannot be the zero address.
570      * - `to` cannot be the zero address.
571      * - `tokenId` token must exist and be owned by `from`.
572      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
574      *
575      * Emits a {Transfer} event.
576      */
577     function safeTransferFrom(
578         address from,
579         address to,
580         uint256 tokenId
581     ) external;
582 
583     /**
584      * @dev Transfers `tokenId` token from `from` to `to`.
585      *
586      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
587      *
588      * Requirements:
589      *
590      * - `from` cannot be the zero address.
591      * - `to` cannot be the zero address.
592      * - `tokenId` token must be owned by `from`.
593      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
594      *
595      * Emits a {Transfer} event.
596      */
597     function transferFrom(
598         address from,
599         address to,
600         uint256 tokenId
601     ) external;
602 
603     /**
604      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
605      * The approval is cleared when the token is transferred.
606      *
607      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
608      *
609      * Requirements:
610      *
611      * - The caller must own the token or be an approved operator.
612      * - `tokenId` must exist.
613      *
614      * Emits an {Approval} event.
615      */
616     function approve(address to, uint256 tokenId) external;
617 
618     /**
619      * @dev Returns the account approved for `tokenId` token.
620      *
621      * Requirements:
622      *
623      * - `tokenId` must exist.
624      */
625     function getApproved(uint256 tokenId) external view returns (address operator);
626 
627     /**
628      * @dev Approve or remove `operator` as an operator for the caller.
629      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
630      *
631      * Requirements:
632      *
633      * - The `operator` cannot be the caller.
634      *
635      * Emits an {ApprovalForAll} event.
636      */
637     function setApprovalForAll(address operator, bool _approved) external;
638 
639     /**
640      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
641      *
642      * See {setApprovalForAll}
643      */
644     function isApprovedForAll(address owner, address operator) external view returns (bool);
645 
646     /**
647      * @dev Safely transfers `tokenId` token from `from` to `to`.
648      *
649      * Requirements:
650      *
651      * - `from` cannot be the zero address.
652      * - `to` cannot be the zero address.
653      * - `tokenId` token must exist and be owned by `from`.
654      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
655      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
656      *
657      * Emits a {Transfer} event.
658      */
659     function safeTransferFrom(
660         address from,
661         address to,
662         uint256 tokenId,
663         bytes calldata data
664     ) external;
665 }
666 contract WYVERNSBREATH is Context, IERC20, Ownable {
667   using Address for address;
668   using SafeMath for uint256;
669 
670   mapping (uint => uint) public lastUpdate;
671   mapping (address => uint256) private _balances;
672   mapping (address => mapping (address => uint256)) private _allowances;
673   
674   uint256 private _totalSupply;
675   uint8 public _decimals;
676   string public _symbol;
677   string public _name;
678   IERC721 private nft;
679   uint public START;
680 
681   constructor()  {
682     _name = "Wyverns Breath";
683     _symbol = "$BREATH";
684     _decimals = 18;
685     _totalSupply = 10000000 * 10**18;
686     _balances[msg.sender] = _totalSupply;
687      nft=IERC721(0x01fE2358CC2CA3379cb5eD11442e85881997F22C);
688      START=block.timestamp;
689 
690     emit Transfer(address(0), msg.sender, _totalSupply);
691   }
692 
693   /**
694    * @dev Returns the bep token owner.
695    */
696   function getOwner() external override view returns (address) {
697     return owner();
698   }
699 
700   /**
701    * @dev Returns the token decimals.
702    */
703   function decimals() external override view returns (uint8) {
704     return _decimals;
705   }
706 
707   /**
708    * @dev Returns the token symbol.
709    */
710   function symbol() external override view returns (string memory) {
711     return _symbol;
712   }
713 
714   /**
715   * @dev Returns the token name.
716   */
717   function name() external override view returns (string memory) {
718     return _name;
719   }
720 
721   /**
722    * @dev See {BEP20-totalSupply}.
723    */
724   function totalSupply() public override view returns (uint256) {
725     return _totalSupply;
726   }
727 
728   /**
729    * @dev See {BEP20-balanceOf}.
730    */
731   function balanceOf(address account) external override view returns (uint256) {
732     return _balances[account];
733   }
734 
735   /**
736    * @dev See {BEP20-transfer}.
737    *
738    * Requirements:
739    *
740    * - `recipient` cannot be the zero address.
741    * - the caller must have a balance of at least `amount`.
742    */
743   function transfer(address recipient, uint256 amount) external override returns (bool) {
744     _transfer(_msgSender(), recipient, amount);
745     return true;
746   }
747 
748   /**
749    * @dev See {BEP20-allowance}.
750    */
751   function allowance(address owner, address spender) external override view returns (uint256) {
752     return _allowances[owner][spender];
753   }
754 
755   /**
756    * @dev See {BEP20-approve}.
757    *
758    * Requirements:
759    *
760    * - `spender` cannot be the zero address.
761    */
762   function approve(address spender, uint256 amount) external override returns (bool) {
763     _approve(_msgSender(), spender, amount);
764     return true;
765   }
766 
767   /**
768    * @dev See {BEP20-transferFrom}.
769    *
770    * Emits an {Approval} event indicating the updated allowance. This is not
771    * required by the EIP. See the note at the beginning of {BEP20};
772    *
773    * Requirements:
774    * - `sender` and `recipient` cannot be the zero address.
775    * - `sender` must have a balance of at least `amount`.
776    * - the caller must have allowance for `sender`'s tokens of at least
777    * `amount`.
778    */
779   function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
780     _transfer(sender, recipient, amount);
781     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
782     return true;
783   }
784 
785   /**
786    * @dev Atomically increases the allowance granted to `spender` by the caller.
787    *
788    * This is an alternative to {approve} that can be used as a mitigation for
789    * problems described in {BEP20-approve}.
790    *
791    * Emits an {Approval} event indicating the updated allowance.
792    *
793    * Requirements:
794    *
795    * - `spender` cannot be the zero address.
796    */
797   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
798     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
799     return true;
800   }
801 
802   /**
803    * @dev Atomically decreases the allowance granted to `spender` by the caller.
804    *
805    * This is an alternative to {approve} that can be used as a mitigation for
806    * problems described in {BEP20-approve}.
807    *
808    * Emits an {Approval} event indicating the updated allowance.
809    *
810    * Requirements:
811    *
812    * - `spender` cannot be the zero address.
813    * - `spender` must have allowance for the caller of at least
814    * `subtractedValue`.
815    */
816   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
817     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
818     return true;
819   }
820 
821   /**
822    * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
823    * the total supply.
824    *
825    * Requirements
826    *
827    * - `msg.sender` must be the token owner
828    */
829 
830   /**
831    * @dev Burn `amount` tokens and decreasing the total supply.
832    */
833   function burn(uint256 amount) public returns (bool) {
834     _burn(_msgSender(), amount);
835     return true;
836   }
837 
838   /**
839    * @dev Moves tokens `amount` from `sender` to `recipient`.
840    *
841    * This is internal function is equivalent to {transfer}, and can be used to
842    * e.g. implement automatic token fees, slashing mechanisms, etc.
843    *
844    * Emits a {Transfer} event.
845    *
846    * Requirements:
847    *
848    * - `sender` cannot be the zero address.
849    * - `recipient` cannot be the zero address.
850    * - `sender` must have a balance of at least `amount`.
851    */
852   function _transfer(address sender, address recipient, uint256 amount) internal {
853     require(sender != address(0), "BEP20: transfer from the zero address");
854     require(recipient != address(0), "BEP20: transfer to the zero address");
855 
856     _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
857     _balances[recipient] = _balances[recipient].add(amount);
858     emit Transfer(sender, recipient, amount);
859   }
860 
861   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
862    * the total supply.
863    *
864    * Emits a {Transfer} event with `from` set to the zero address.
865    *
866    * Requirements
867    *
868    * - `to` cannot be the zero address.
869    */
870   function _mint(address account, uint256 amount) internal {
871     require(account != address(0), "BEP20: mint to the zero address");
872 
873     _totalSupply = _totalSupply.add(amount);
874     _balances[account] = _balances[account].add(amount);
875     emit Transfer(address(0), account, amount);
876   }
877 
878   /**
879    * @dev Destroys `amount` tokens from `account`, reducing the
880    * total supply.
881    *
882    * Emits a {Transfer} event with `to` set to the zero address.
883    *
884    * Requirements
885    *
886    * - `account` cannot be the zero address.
887    * - `account` must have at least `amount` tokens.
888    */
889   function _burn(address account, uint256 amount) internal {
890     require(account != address(0), "BEP20: burn from the zero address");
891 
892     _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
893     _totalSupply = _totalSupply.sub(amount);
894     emit Transfer(account, address(0), amount);
895   }
896 
897   /**
898    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
899    *
900    * This is internal function is equivalent to `approve`, and can be used to
901    * e.g. set aumatic allowances for certain subsystems, etc.
902    *
903    * Emits an {Approval} event.
904    *
905    * Requirements:
906    *
907    * - `owner` cannot be the zero address.
908    * - `spender` cannot be the zero address.
909    */
910   function _approve(address owner, address spender, uint256 amount) internal {
911     require(owner != address(0), "BEP20: approve fromm the zero address");
912     require(spender != address(0), "BEP20: approvee to the zero address");
913 
914     _allowances[owner][spender] = amount;
915     emit Approval(owner, spender, amount);
916   }
917 
918   /**
919    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
920    * from the caller's allowance.
921    *
922    * See {_burn} and {_approve}.
923    */
924   function _burnFrom(address account, uint256 amount) internal {
925     _burn(account, amount);
926     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
927   }
928   function claimToken(uint tokenid) public
929     {
930         require(nft.ownerOf(tokenid) == msg.sender, "Caller not the owner");
931         uint today_count = block.timestamp / (24*60*60); 
932         uint amount = uint(getPendingReward(tokenid, today_count));
933         lastUpdate[tokenid] = today_count;
934         _transfer(owner(), msg.sender, amount);
935 
936     }
937 
938     function getPendingReward(uint tokenId, uint todayCount) public view returns (int)
939     {
940         if (lastUpdate[tokenId] == 0)
941         {
942             return 5 * 10 ** 18;
943         }
944         else
945         {
946             require(todayCount - lastUpdate[tokenId] >= 1, "user claim token , come after 24 hours");
947             int count = int(todayCount - lastUpdate[tokenId]);
948             
949             return count * (5 * 10 ** 18);
950         }
951     }
952 }