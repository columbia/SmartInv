1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      *
27      * - Addition cannot overflow.
28      */
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32 
33         return c;
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the multiplication of two unsigned integers, reverting on
69      * overflow.
70      *
71      * Counterpart to Solidity's `*` operator.
72      *
73      * Requirements:
74      *
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      *
101      * - The divisor cannot be zero.
102      */
103     function div(uint256 a, uint256 b) internal pure returns (uint256) {
104         return div(a, b, "SafeMath: division by zero");
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         require(b > 0, errorMessage);
121         uint256 c = a / b;
122         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
129      * Reverts when dividing by zero.
130      *
131      * Counterpart to Solidity's `%` operator. This function uses a `revert`
132      * opcode (which leaves remaining gas untouched) while Solidity uses an
133      * invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b != 0, errorMessage);
157         return a % b;
158     }
159 }
160 
161 /*
162  * @dev Provides information about the current execution context, including the
163  * sender of the transaction and its data. While these are generally available
164  * via msg.sender and msg.data, they should not be accessed in such a direct
165  * manner, since when dealing with GSN meta-transactions the account sending and
166  * paying for execution may not be the actual sender (as far as an application
167  * is concerned).
168  *
169  * This contract is only required for intermediate, library-like contracts.
170  */
171 abstract contract Context {
172     function _msgSender() internal view virtual returns (address payable) {
173         return msg.sender;
174     }
175 
176     function _msgData() internal view virtual returns (bytes memory) {
177         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
178         return msg.data;
179     }
180 }
181 
182 /**
183  * @dev Interface of the ERC165 standard, as defined in the
184  * https://eips.ethereum.org/EIPS/eip-165[EIP].
185  *
186  * Implementers can declare support of contract interfaces, which can then be
187  * queried by others ({ERC165Checker}).
188  *
189  * For an implementation, see {ERC165}.
190  */
191 interface IERC165 {
192     /**
193      * @dev Returns true if this contract implements the interface defined by
194      * `interfaceId`. See the corresponding
195      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
196      * to learn more about how these ids are created.
197      *
198      * This function call must use less than 30 000 gas.
199      */
200     function supportsInterface(bytes4 interfaceId) external view returns (bool);
201 }
202 
203 /**
204  * @dev Interface of the ERC20 standard as defined in the EIP.
205  */
206 interface IERC20 {
207     /**
208      * @dev Returns the amount of tokens in existence.
209      */
210     function totalSupply() external view returns (uint256);
211 
212     /**
213      * @dev Returns the amount of tokens owned by `account`.
214      */
215     function balanceOf(address account) external view returns (uint256);
216 
217     /**
218      * @dev Moves `amount` tokens from the caller's account to `recipient`.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transfer(address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Returns the remaining number of tokens that `spender` will be
228      * allowed to spend on behalf of `owner` through {transferFrom}. This is
229      * zero by default.
230      *
231      * This value changes when {approve} or {transferFrom} are called.
232      */
233     function allowance(address owner, address spender) external view returns (uint256);
234 
235     /**
236      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
237      *
238      * Returns a boolean value indicating whether the operation succeeded.
239      *
240      * IMPORTANT: Beware that changing an allowance with this method brings the risk
241      * that someone may use both the old and the new allowance by unfortunate
242      * transaction ordering. One possible solution to mitigate this race
243      * condition is to first reduce the spender's allowance to 0 and set the
244      * desired value afterwards:
245      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
246      *
247      * Emits an {Approval} event.
248      */
249     function approve(address spender, uint256 amount) external returns (bool);
250 
251     /**
252      * @dev Moves `amount` tokens from `sender` to `recipient` using the
253      * allowance mechanism. `amount` is then deducted from the caller's
254      * allowance.
255      *
256      * Returns a boolean value indicating whether the operation succeeded.
257      *
258      * Emits a {Transfer} event.
259      */
260     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
261 
262 
263     /**
264      * TODO: Add comment
265      */
266     function burn(uint256 burnQuantity) external returns (bool);
267 
268     /**
269      * @dev Emitted when `value` tokens are moved from one account (`from`) to
270      * another (`to`).
271      *
272      * Note that `value` may be zero.
273      */
274     event Transfer(address indexed from, address indexed to, uint256 value);
275 
276     /**
277      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
278      * a call to {approve}. `value` is the new allowance.
279      */
280     event Approval(address indexed owner, address indexed spender, uint256 value);
281 }
282 
283 /**
284  * @dev Required interface of an ERC721 compliant contract.
285  */
286 interface IERC721 is IERC165 {
287     /**
288      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
289      */
290     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
291 
292     /**
293      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
294      */
295     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
296 
297     /**
298      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
299      */
300     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
301 
302     /**
303      * @dev Returns the number of tokens in ``owner``'s account.
304      */
305     function balanceOf(address owner) external view returns (uint256 balance);
306 
307     /**
308      * @dev Returns the owner of the `tokenId` token.
309      *
310      * Requirements:
311      *
312      * - `tokenId` must exist.
313      */
314     function ownerOf(uint256 tokenId) external view returns (address owner);
315 
316     /**
317      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
318      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
319      *
320      * Requirements:
321      *
322      * - `from` cannot be the zero address.
323      * - `to` cannot be the zero address.
324      * - `tokenId` token must exist and be owned by `from`.
325      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
326      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
327      *
328      * Emits a {Transfer} event.
329      */
330     function safeTransferFrom(address from, address to, uint256 tokenId) external;
331 
332     /**
333      * @dev Transfers `tokenId` token from `from` to `to`.
334      *
335      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
336      *
337      * Requirements:
338      *
339      * - `from` cannot be the zero address.
340      * - `to` cannot be the zero address.
341      * - `tokenId` token must be owned by `from`.
342      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
343      *
344      * Emits a {Transfer} event.
345      */
346     function transferFrom(address from, address to, uint256 tokenId) external;
347 
348     /**
349      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
350      * The approval is cleared when the token is transferred.
351      *
352      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
353      *
354      * Requirements:
355      *
356      * - The caller must own the token or be an approved operator.
357      * - `tokenId` must exist.
358      *
359      * Emits an {Approval} event.
360      */
361     function approve(address to, uint256 tokenId) external;
362 
363     /**
364      * @dev Returns the account approved for `tokenId` token.
365      *
366      * Requirements:
367      *
368      * - `tokenId` must exist.
369      */
370     function getApproved(uint256 tokenId) external view returns (address operator);
371 
372     /**
373      * @dev Approve or remove `operator` as an operator for the caller.
374      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
375      *
376      * Requirements:
377      *
378      * - The `operator` cannot be the caller.
379      *
380      * Emits an {ApprovalForAll} event.
381      */
382     function setApprovalForAll(address operator, bool _approved) external;
383 
384     /**
385      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
386      *
387      * See {setApprovalForAll}
388      */
389     function isApprovedForAll(address owner, address operator) external view returns (bool);
390 
391     /**
392       * @dev Safely transfers `tokenId` token from `from` to `to`.
393       *
394       * Requirements:
395       *
396      * - `from` cannot be the zero address.
397      * - `to` cannot be the zero address.
398       * - `tokenId` token must exist and be owned by `from`.
399       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
400       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
401       *
402       * Emits a {Transfer} event.
403       */
404     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
405 }
406 
407 /**
408  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
409  * @dev See https://eips.ethereum.org/EIPS/eip-721
410  */
411 interface IERC721Enumerable is IERC721 {
412 
413     /**
414      * @dev Returns the total amount of tokens stored by the contract.
415      */
416     function totalSupply() external view returns (uint256);
417 
418     /**
419      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
420      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
421      */
422     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
423 
424     /**
425      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
426      * Use along with {totalSupply} to enumerate all tokens.
427      */
428     function tokenByIndex(uint256 index) external view returns (uint256);
429 }
430 
431 interface IWaifus is IERC721Enumerable {
432     function isMintedBeforeReveal(uint256 index) external view returns (bool);
433 }
434 
435 /**
436  *
437  * WaifuEnhancementToken Contract (The native token of Waifus)
438  * @dev Extends standard ERC20 contract
439  */
440 contract WaifuEnhancementToken is Context, IERC20 {
441     using SafeMath for uint256;
442 
443     // Constants
444     uint256 public SECONDS_IN_A_DAY = 86400;
445 
446     uint256 public constant INITIAL_ALLOTMENT = 1830 * (10 ** 18);
447 
448     uint256 public constant PRE_REVEAL_MULTIPLIER = 1;
449 
450     // Public variables
451     uint256 public emissionStart;
452 
453     uint256 public emissionEnd; 
454 
455     uint256 public emissionPerDay = 10 * (10 ** 18);
456 
457     mapping (address => uint256) private _balances;
458 
459     mapping (address => mapping (address => uint256)) private _allowances;
460     
461     mapping(uint256 => uint256) private _lastClaim;
462 
463     uint256 private _totalSupply;
464 
465     string private _name;
466     string private _symbol;
467     uint8 private _decimals;
468     address private _waifusAddress;
469 
470     /**
471      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
472      * a default value of 18. Also initalizes {emissionStart}
473      *
474      * To select a different value for {decimals}, use {_setupDecimals}.
475      *
476      * All three of these values are immutable: they can only be set once during
477      * construction.
478      */
479     constructor (string memory name, string memory symbol, uint256 emissionStartTimestamp) {
480         _name = name;
481         _symbol = symbol;
482         _decimals = 18;
483         emissionStart = emissionStartTimestamp;
484         emissionEnd = emissionStartTimestamp + (86400 * 365 * 10);
485     }
486 
487     /**
488      * @dev Returns the name of the token.
489      */
490     function name() public view returns (string memory) {
491         return _name;
492     }
493 
494     /**
495      * @dev Returns the symbol of the token, usually a shorter version of the
496      * name.
497      */
498     function symbol() public view returns (string memory) {
499         return _symbol;
500     }
501 
502     /**
503      * @dev Returns the number of decimals used to get its user representation.
504      * For example, if `decimals` equals `2`, a balance of `505` tokens should
505      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
506      *
507      * Tokens usually opt for a value of 18, imitating the relationship between
508      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
509      * called.
510      *
511      * NOTE: This information is only used for _display_ purposes: it in
512      * no way affects any of the arithmetic of the contract, including
513      * {IERC20-balanceOf} and {IERC20-transfer}.
514      */
515     function decimals() public view returns (uint8) {
516         return _decimals;
517     }
518 
519     /**
520      * @dev See {IERC20-totalSupply}.
521      */
522     function totalSupply() public view override returns (uint256) {
523         return _totalSupply;
524     }
525 
526     /**
527      * @dev See {IERC20-balanceOf}.
528      */
529     function balanceOf(address account) public view override returns (uint256) {
530         return _balances[account];
531     }
532     
533     /**
534      * @dev When accumulated NCTs have last been claimed for a Hashmask index
535      */
536     function lastClaim(uint256 tokenIndex) public view returns (uint256) {
537         require(IWaifus(_waifusAddress).ownerOf(tokenIndex) != address(0), "Owner cannot be 0 address");
538         require(tokenIndex < IWaifus(_waifusAddress).totalSupply(), "NFT at index has not been minted yet");
539 
540         uint256 lastClaimed = uint256(_lastClaim[tokenIndex]) != 0 ? uint256(_lastClaim[tokenIndex]) : emissionStart;
541         return lastClaimed;
542     }
543     
544     /**
545      * @dev Accumulated NCT tokens for a Hashmask token index.
546      */
547     function accumulated(uint256 tokenIndex) public view returns (uint256) {
548         require(block.timestamp > emissionStart, "Emission has not started yet");
549         require(IWaifus(_waifusAddress).ownerOf(tokenIndex) != address(0), "Owner cannot be 0 address");
550         require(tokenIndex < IWaifus(_waifusAddress).totalSupply(), "NFT at index has not been minted yet");
551 
552         uint256 lastClaimed = lastClaim(tokenIndex);
553 
554         // Sanity check if last claim was on or after emission end
555         if (lastClaimed >= emissionEnd) return 0;
556 
557         uint256 accumulationPeriod = block.timestamp < emissionEnd ? block.timestamp : emissionEnd; // Getting the min value of both
558         uint256 totalAccumulated = accumulationPeriod.sub(lastClaimed).mul(emissionPerDay).div(SECONDS_IN_A_DAY);
559 
560         // If claim hasn't been done before for the index, add initial allotment (plus prereveal multiplier if applicable)
561         if (lastClaimed == emissionStart) {
562             uint256 initialAllotment = IWaifus(_waifusAddress).isMintedBeforeReveal(tokenIndex) == true ? INITIAL_ALLOTMENT.mul(PRE_REVEAL_MULTIPLIER) : INITIAL_ALLOTMENT;
563             totalAccumulated = totalAccumulated.add(initialAllotment);
564         }
565 
566         return totalAccumulated;
567     }
568 
569     /**
570      * @dev Permissioning not added because it is only callable once. It is set right after deployment and verified.
571      */
572     function setWaifusAddress(address waifusAddress) public {
573         require(_waifusAddress == address(0), "Already set");
574         
575         _waifusAddress = waifusAddress;
576     }
577     
578     /**
579      * @dev Claim mints NCTs and supports multiple Hashmask token indices at once.
580      */
581     function claim(uint256[] memory tokenIndices) public returns (uint256) {
582         require(block.timestamp > emissionStart, "Emission has not started yet");
583 
584         uint256 totalClaimQty = 0;
585         for (uint i = 0; i < tokenIndices.length; i++) {
586             // Sanity check for non-minted index
587             require(tokenIndices[i] < IWaifus(_waifusAddress).totalSupply(), "NFT at index has not been minted yet");
588             // Duplicate token index check
589             for (uint j = i + 1; j < tokenIndices.length; j++) {
590                 require(tokenIndices[i] != tokenIndices[j], "Duplicate token index");
591             }
592 
593             uint tokenIndex = tokenIndices[i];
594             require(IWaifus(_waifusAddress).ownerOf(tokenIndex) == msg.sender, "Sender is not the owner");
595 
596             uint256 claimQty = accumulated(tokenIndex);
597             if (claimQty != 0) {
598                 totalClaimQty = totalClaimQty.add(claimQty);
599                 _lastClaim[tokenIndex] = block.timestamp;
600             }
601         }
602 
603         require(totalClaimQty != 0, "No accumulated NCT");
604         _mint(msg.sender, totalClaimQty); 
605         return totalClaimQty;
606     }
607 
608     /**
609      * @dev See {IERC20-transfer}.
610      *
611      * Requirements:
612      *
613      * - `recipient` cannot be the zero address.
614      * - the caller must have a balance of at least `amount`.
615      */
616     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
617         _transfer(_msgSender(), recipient, amount);
618         return true;
619     }
620 
621     /**
622      * @dev See {IERC20-allowance}.
623      */
624     function allowance(address owner, address spender) public view virtual override returns (uint256) {
625         return _allowances[owner][spender];
626     }
627 
628     /**
629      * @dev See {IERC20-approve}.
630      *
631      * Requirements:
632      *
633      * - `spender` cannot be the zero address.
634      */
635     function approve(address spender, uint256 amount) public virtual override returns (bool) {
636         _approve(_msgSender(), spender, amount);
637         return true;
638     }
639 
640     /**
641      * @dev See {IERC20-transferFrom}.
642      *
643      * Emits an {Approval} event indicating the updated allowance. This is not
644      * required by the EIP. See the note at the beginning of {ERC20}.
645      *
646      * Requirements:
647      *
648      * - `sender` and `recipient` cannot be the zero address.
649      * - `sender` must have a balance of at least `amount`.
650      * - the caller must have allowance for ``sender``'s tokens of at least
651      * `amount`.
652      */
653     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
654         _transfer(sender, recipient, amount);
655         // Approval check is skipped if the caller of transferFrom is the Waifus contract. For better UX.
656         if (msg.sender != _waifusAddress) {
657             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
658         }
659         return true;
660     }
661 
662     /**
663      * @dev Atomically increases the allowance granted to `spender` by the caller.
664      *
665      * This is an alternative to {approve} that can be used as a mitigation for
666      * problems described in {IERC20-approve}.
667      *
668      * Emits an {Approval} event indicating the updated allowance.
669      *
670      * Requirements:
671      *
672      * - `spender` cannot be the zero address.
673      */
674     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
675         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
676         return true;
677     }
678 
679     // ++
680     /**
681      * @dev Burns a quantity of tokens held by the caller.
682      *
683      * Emits an {Transfer} event to 0 address
684      *
685      */
686     function burn(uint256 burnQuantity) public virtual override returns (bool) {
687         _burn(msg.sender, burnQuantity);
688         return true;
689     }
690     // ++
691 
692     /**
693      * @dev Atomically decreases the allowance granted to `spender` by the caller.
694      *
695      * This is an alternative to {approve} that can be used as a mitigation for
696      * problems described in {IERC20-approve}.
697      *
698      * Emits an {Approval} event indicating the updated allowance.
699      *
700      * Requirements:
701      *
702      * - `spender` cannot be the zero address.
703      * - `spender` must have allowance for the caller of at least
704      * `subtractedValue`.
705      */
706     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
707         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
708         return true;
709     }
710 
711     /**
712      * @dev Moves tokens `amount` from `sender` to `recipient`.
713      *
714      * This is internal function is equivalent to {transfer}, and can be used to
715      * e.g. implement automatic token fees, slashing mechanisms, etc.
716      *
717      * Emits a {Transfer} event.
718      *
719      * Requirements:
720      *
721      * - `sender` cannot be the zero address.
722      * - `recipient` cannot be the zero address.
723      * - `sender` must have a balance of at least `amount`.
724      */
725     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
726         require(sender != address(0), "ERC20: transfer from the zero address");
727         require(recipient != address(0), "ERC20: transfer to the zero address");
728 
729         _beforeTokenTransfer(sender, recipient, amount);
730 
731         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
732         _balances[recipient] = _balances[recipient].add(amount);
733         emit Transfer(sender, recipient, amount);
734     }
735 
736     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
737      * the total supply.
738      *
739      * Emits a {Transfer} event with `from` set to the zero address.
740      *
741      * Requirements:
742      *
743      * - `to` cannot be the zero address.
744      */
745     function _mint(address account, uint256 amount) internal virtual {
746         require(account != address(0), "ERC20: mint to the zero address");
747 
748         _beforeTokenTransfer(address(0), account, amount);
749 
750         _totalSupply = _totalSupply.add(amount);
751         _balances[account] = _balances[account].add(amount);
752         emit Transfer(address(0), account, amount);
753     }
754 
755     /**
756      * @dev Destroys `amount` tokens from `account`, reducing the
757      * total supply.
758      *
759      * Emits a {Transfer} event with `to` set to the zero address.
760      *
761      * Requirements:
762      *
763      * - `account` cannot be the zero address.
764      * - `account` must have at least `amount` tokens.
765      */
766     function _burn(address account, uint256 amount) internal virtual {
767         require(account != address(0), "ERC20: burn from the zero address");
768 
769         _beforeTokenTransfer(account, address(0), amount);
770 
771         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
772         _totalSupply = _totalSupply.sub(amount);
773         emit Transfer(account, address(0), amount);
774     }
775 
776     /**
777      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
778      *
779      * This internal function is equivalent to `approve`, and can be used to
780      * e.g. set automatic allowances for certain subsystems, etc.
781      *
782      * Emits an {Approval} event.
783      *
784      * Requirements:
785      *
786      * - `owner` cannot be the zero address.
787      * - `spender` cannot be the zero address.
788      */
789     function _approve(address owner, address spender, uint256 amount) internal virtual {
790         require(owner != address(0), "ERC20: approve from the zero address");
791         require(spender != address(0), "ERC20: approve to the zero address");
792 
793         _allowances[owner][spender] = amount;
794         emit Approval(owner, spender, amount);
795     }
796 
797     /**
798      * @dev Sets {decimals} to a value other than the default one of 18.
799      *
800      * WARNING: This function should only be called from the constructor. Most
801      * applications that interact with token contracts will not expect
802      * {decimals} to ever change, and may work incorrectly if it does.
803      */
804     function _setupDecimals(uint8 decimals_) internal {
805         _decimals = decimals_;
806     }
807 
808     /**
809      * @dev Hook that is called before any transfer of tokens. This includes
810      * minting and burning.
811      *
812      * Calling conditions:
813      *
814      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
815      * will be to transferred to `to`.
816      * - when `from` is zero, `amount` tokens will be minted for `to`.
817      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
818      * - `from` and `to` are never both zero.
819      *
820      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
821      */
822     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
823 }