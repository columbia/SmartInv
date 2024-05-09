1 // Sources flattened with hardhat v2.2.0 https://hardhat.org
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
31 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
32 
33 pragma solidity >=0.6.0 <0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         uint256 c = a + b;
135         if (c < a) return (false, 0);
136         return (true, c);
137     }
138 
139     /**
140      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         if (b > a) return (false, 0);
146         return (true, a - b);
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) return (true, 0);
159         uint256 c = a * b;
160         if (c / a != b) return (false, 0);
161         return (true, c);
162     }
163 
164     /**
165      * @dev Returns the division of two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a / b);
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         if (b == 0) return (false, 0);
181         return (true, a % b);
182     }
183 
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      *
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a, "SafeMath: subtraction overflow");
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         if (a == 0) return 0;
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers, reverting on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b > 0, "SafeMath: division by zero");
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b > 0, "SafeMath: modulo by zero");
263         return a % b;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * CAUTION: This function is deprecated because it requires allocating memory for the error
271      * message unnecessarily. For custom revert reasons use {trySub}.
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b <= a, errorMessage);
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
286      * division by zero. The result is rounded towards zero.
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {tryDiv}.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting with custom message when dividing by zero.
307      *
308      * CAUTION: This function is deprecated because it requires allocating memory for the error
309      * message unnecessarily. For custom revert reasons use {tryMod}.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b > 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 
326 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
327 
328 pragma solidity >=0.6.0 <0.8.0;
329 
330 
331 
332 /**
333  * @dev Implementation of the {IERC20} interface.
334  *
335  * This implementation is agnostic to the way tokens are created. This means
336  * that a supply mechanism has to be added in a derived contract using {_mint}.
337  * For a generic mechanism see {ERC20PresetMinterPauser}.
338  *
339  * TIP: For a detailed writeup see our guide
340  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
341  * to implement supply mechanisms].
342  *
343  * We have followed general OpenZeppelin guidelines: functions revert instead
344  * of returning `false` on failure. This behavior is nonetheless conventional
345  * and does not conflict with the expectations of ERC20 applications.
346  *
347  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
348  * This allows applications to reconstruct the allowance for all accounts just
349  * by listening to said events. Other implementations of the EIP may not emit
350  * these events, as it isn't required by the specification.
351  *
352  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
353  * functions have been added to mitigate the well-known issues around setting
354  * allowances. See {IERC20-approve}.
355  */
356 contract ERC20 is Context, IERC20 {
357     using SafeMath for uint256;
358 
359     mapping (address => uint256) private _balances;
360 
361     mapping (address => mapping (address => uint256)) private _allowances;
362 
363     uint256 private _totalSupply;
364 
365     string private _name;
366     string private _symbol;
367     uint8 private _decimals;
368 
369     /**
370      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
371      * a default value of 18.
372      *
373      * To select a different value for {decimals}, use {_setupDecimals}.
374      *
375      * All three of these values are immutable: they can only be set once during
376      * construction.
377      */
378     constructor (string memory name_, string memory symbol_) public {
379         _name = name_;
380         _symbol = symbol_;
381         _decimals = 18;
382     }
383 
384     /**
385      * @dev Returns the name of the token.
386      */
387     function name() public view virtual returns (string memory) {
388         return _name;
389     }
390 
391     /**
392      * @dev Returns the symbol of the token, usually a shorter version of the
393      * name.
394      */
395     function symbol() public view virtual returns (string memory) {
396         return _symbol;
397     }
398 
399     /**
400      * @dev Returns the number of decimals used to get its user representation.
401      * For example, if `decimals` equals `2`, a balance of `505` tokens should
402      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
403      *
404      * Tokens usually opt for a value of 18, imitating the relationship between
405      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
406      * called.
407      *
408      * NOTE: This information is only used for _display_ purposes: it in
409      * no way affects any of the arithmetic of the contract, including
410      * {IERC20-balanceOf} and {IERC20-transfer}.
411      */
412     function decimals() public view virtual returns (uint8) {
413         return _decimals;
414     }
415 
416     /**
417      * @dev See {IERC20-totalSupply}.
418      */
419     function totalSupply() public view virtual override returns (uint256) {
420         return _totalSupply;
421     }
422 
423     /**
424      * @dev See {IERC20-balanceOf}.
425      */
426     function balanceOf(address account) public view virtual override returns (uint256) {
427         return _balances[account];
428     }
429 
430     /**
431      * @dev See {IERC20-transfer}.
432      *
433      * Requirements:
434      *
435      * - `recipient` cannot be the zero address.
436      * - the caller must have a balance of at least `amount`.
437      */
438     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
439         _transfer(_msgSender(), recipient, amount);
440         return true;
441     }
442 
443     /**
444      * @dev See {IERC20-allowance}.
445      */
446     function allowance(address owner, address spender) public view virtual override returns (uint256) {
447         return _allowances[owner][spender];
448     }
449 
450     /**
451      * @dev See {IERC20-approve}.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      */
457     function approve(address spender, uint256 amount) public virtual override returns (bool) {
458         _approve(_msgSender(), spender, amount);
459         return true;
460     }
461 
462     /**
463      * @dev See {IERC20-transferFrom}.
464      *
465      * Emits an {Approval} event indicating the updated allowance. This is not
466      * required by the EIP. See the note at the beginning of {ERC20}.
467      *
468      * Requirements:
469      *
470      * - `sender` and `recipient` cannot be the zero address.
471      * - `sender` must have a balance of at least `amount`.
472      * - the caller must have allowance for ``sender``'s tokens of at least
473      * `amount`.
474      */
475     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
476         _transfer(sender, recipient, amount);
477         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
478         return true;
479     }
480 
481     /**
482      * @dev Atomically increases the allowance granted to `spender` by the caller.
483      *
484      * This is an alternative to {approve} that can be used as a mitigation for
485      * problems described in {IERC20-approve}.
486      *
487      * Emits an {Approval} event indicating the updated allowance.
488      *
489      * Requirements:
490      *
491      * - `spender` cannot be the zero address.
492      */
493     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
494         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
495         return true;
496     }
497 
498     /**
499      * @dev Atomically decreases the allowance granted to `spender` by the caller.
500      *
501      * This is an alternative to {approve} that can be used as a mitigation for
502      * problems described in {IERC20-approve}.
503      *
504      * Emits an {Approval} event indicating the updated allowance.
505      *
506      * Requirements:
507      *
508      * - `spender` cannot be the zero address.
509      * - `spender` must have allowance for the caller of at least
510      * `subtractedValue`.
511      */
512     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
513         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
514         return true;
515     }
516 
517     /**
518      * @dev Moves tokens `amount` from `sender` to `recipient`.
519      *
520      * This is internal function is equivalent to {transfer}, and can be used to
521      * e.g. implement automatic token fees, slashing mechanisms, etc.
522      *
523      * Emits a {Transfer} event.
524      *
525      * Requirements:
526      *
527      * - `sender` cannot be the zero address.
528      * - `recipient` cannot be the zero address.
529      * - `sender` must have a balance of at least `amount`.
530      */
531     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
532         require(sender != address(0), "ERC20: transfer from the zero address");
533         require(recipient != address(0), "ERC20: transfer to the zero address");
534 
535         _beforeTokenTransfer(sender, recipient, amount);
536 
537         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
538         _balances[recipient] = _balances[recipient].add(amount);
539         emit Transfer(sender, recipient, amount);
540     }
541 
542     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
543      * the total supply.
544      *
545      * Emits a {Transfer} event with `from` set to the zero address.
546      *
547      * Requirements:
548      *
549      * - `to` cannot be the zero address.
550      */
551     function _mint(address account, uint256 amount) internal virtual {
552         require(account != address(0), "ERC20: mint to the zero address");
553 
554         _beforeTokenTransfer(address(0), account, amount);
555 
556         _totalSupply = _totalSupply.add(amount);
557         _balances[account] = _balances[account].add(amount);
558         emit Transfer(address(0), account, amount);
559     }
560 
561     /**
562      * @dev Destroys `amount` tokens from `account`, reducing the
563      * total supply.
564      *
565      * Emits a {Transfer} event with `to` set to the zero address.
566      *
567      * Requirements:
568      *
569      * - `account` cannot be the zero address.
570      * - `account` must have at least `amount` tokens.
571      */
572     function _burn(address account, uint256 amount) internal virtual {
573         require(account != address(0), "ERC20: burn from the zero address");
574 
575         _beforeTokenTransfer(account, address(0), amount);
576 
577         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
578         _totalSupply = _totalSupply.sub(amount);
579         emit Transfer(account, address(0), amount);
580     }
581 
582     /**
583      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
584      *
585      * This internal function is equivalent to `approve`, and can be used to
586      * e.g. set automatic allowances for certain subsystems, etc.
587      *
588      * Emits an {Approval} event.
589      *
590      * Requirements:
591      *
592      * - `owner` cannot be the zero address.
593      * - `spender` cannot be the zero address.
594      */
595     function _approve(address owner, address spender, uint256 amount) internal virtual {
596         require(owner != address(0), "ERC20: approve from the zero address");
597         require(spender != address(0), "ERC20: approve to the zero address");
598 
599         _allowances[owner][spender] = amount;
600         emit Approval(owner, spender, amount);
601     }
602 
603     /**
604      * @dev Sets {decimals} to a value other than the default one of 18.
605      *
606      * WARNING: This function should only be called from the constructor. Most
607      * applications that interact with token contracts will not expect
608      * {decimals} to ever change, and may work incorrectly if it does.
609      */
610     function _setupDecimals(uint8 decimals_) internal virtual {
611         _decimals = decimals_;
612     }
613 
614     /**
615      * @dev Hook that is called before any transfer of tokens. This includes
616      * minting and burning.
617      *
618      * Calling conditions:
619      *
620      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
621      * will be to transferred to `to`.
622      * - when `from` is zero, `amount` tokens will be minted for `to`.
623      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
624      * - `from` and `to` are never both zero.
625      *
626      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
627      */
628     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
629 }
630 
631 
632 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.1
633 
634 pragma solidity >=0.6.0 <0.8.0;
635 
636 /**
637  * @dev Interface of the ERC165 standard, as defined in the
638  * https://eips.ethereum.org/EIPS/eip-165[EIP].
639  *
640  * Implementers can declare support of contract interfaces, which can then be
641  * queried by others ({ERC165Checker}).
642  *
643  * For an implementation, see {ERC165}.
644  */
645 interface IERC165 {
646     /**
647      * @dev Returns true if this contract implements the interface defined by
648      * `interfaceId`. See the corresponding
649      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
650      * to learn more about how these ids are created.
651      *
652      * This function call must use less than 30 000 gas.
653      */
654     function supportsInterface(bytes4 interfaceId) external view returns (bool);
655 }
656 
657 
658 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.1
659 
660 pragma solidity >=0.6.2 <0.8.0;
661 
662 /**
663  * @dev Required interface of an ERC721 compliant contract.
664  */
665 interface IERC721 is IERC165 {
666     /**
667      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
668      */
669     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
670 
671     /**
672      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
673      */
674     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
675 
676     /**
677      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
678      */
679     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
680 
681     /**
682      * @dev Returns the number of tokens in ``owner``'s account.
683      */
684     function balanceOf(address owner) external view returns (uint256 balance);
685 
686     /**
687      * @dev Returns the owner of the `tokenId` token.
688      *
689      * Requirements:
690      *
691      * - `tokenId` must exist.
692      */
693     function ownerOf(uint256 tokenId) external view returns (address owner);
694 
695     /**
696      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
697      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
698      *
699      * Requirements:
700      *
701      * - `from` cannot be the zero address.
702      * - `to` cannot be the zero address.
703      * - `tokenId` token must exist and be owned by `from`.
704      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
705      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
706      *
707      * Emits a {Transfer} event.
708      */
709     function safeTransferFrom(address from, address to, uint256 tokenId) external;
710 
711     /**
712      * @dev Transfers `tokenId` token from `from` to `to`.
713      *
714      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
715      *
716      * Requirements:
717      *
718      * - `from` cannot be the zero address.
719      * - `to` cannot be the zero address.
720      * - `tokenId` token must be owned by `from`.
721      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
722      *
723      * Emits a {Transfer} event.
724      */
725     function transferFrom(address from, address to, uint256 tokenId) external;
726 
727     /**
728      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
729      * The approval is cleared when the token is transferred.
730      *
731      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
732      *
733      * Requirements:
734      *
735      * - The caller must own the token or be an approved operator.
736      * - `tokenId` must exist.
737      *
738      * Emits an {Approval} event.
739      */
740     function approve(address to, uint256 tokenId) external;
741 
742     /**
743      * @dev Returns the account approved for `tokenId` token.
744      *
745      * Requirements:
746      *
747      * - `tokenId` must exist.
748      */
749     function getApproved(uint256 tokenId) external view returns (address operator);
750 
751     /**
752      * @dev Approve or remove `operator` as an operator for the caller.
753      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
754      *
755      * Requirements:
756      *
757      * - The `operator` cannot be the caller.
758      *
759      * Emits an {ApprovalForAll} event.
760      */
761     function setApprovalForAll(address operator, bool _approved) external;
762 
763     /**
764      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
765      *
766      * See {setApprovalForAll}
767      */
768     function isApprovedForAll(address owner, address operator) external view returns (bool);
769 
770     /**
771       * @dev Safely transfers `tokenId` token from `from` to `to`.
772       *
773       * Requirements:
774       *
775       * - `from` cannot be the zero address.
776       * - `to` cannot be the zero address.
777       * - `tokenId` token must exist and be owned by `from`.
778       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
779       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
780       *
781       * Emits a {Transfer} event.
782       */
783     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
784 }
785 
786 
787 // File @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol@v3.4.1
788 
789 pragma solidity >=0.6.2 <0.8.0;
790 
791 /**
792  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
793  * @dev See https://eips.ethereum.org/EIPS/eip-721
794  */
795 interface IERC721Enumerable is IERC721 {
796 
797     /**
798      * @dev Returns the total amount of tokens stored by the contract.
799      */
800     function totalSupply() external view returns (uint256);
801 
802     /**
803      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
804      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
805      */
806     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
807 
808     /**
809      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
810      * Use along with {totalSupply} to enumerate all tokens.
811      */
812     function tokenByIndex(uint256 index) external view returns (uint256);
813 }
814 
815 
816 // File @openzeppelin/contracts/math/Math.sol@v3.4.1
817 
818 pragma solidity >=0.6.0 <0.8.0;
819 
820 /**
821  * @dev Standard math utilities missing in the Solidity language.
822  */
823 library Math {
824     /**
825      * @dev Returns the largest of two numbers.
826      */
827     function max(uint256 a, uint256 b) internal pure returns (uint256) {
828         return a >= b ? a : b;
829     }
830 
831     /**
832      * @dev Returns the smallest of two numbers.
833      */
834     function min(uint256 a, uint256 b) internal pure returns (uint256) {
835         return a < b ? a : b;
836     }
837 
838     /**
839      * @dev Returns the average of two numbers. The result is rounded towards
840      * zero.
841      */
842     function average(uint256 a, uint256 b) internal pure returns (uint256) {
843         // (a + b) / 2 can overflow, so we distribute
844         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
845     }
846 }
847 
848 
849 // File @openzeppelin/contracts/cryptography/MerkleProof.sol@v3.4.1
850 
851 pragma solidity >=0.6.0 <0.8.0;
852 
853 /**
854  * @dev These functions deal with verification of Merkle trees (hash trees),
855  */
856 library MerkleProof {
857     /**
858      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
859      * defined by `root`. For this, a `proof` must be provided, containing
860      * sibling hashes on the branch from the leaf to the root of the tree. Each
861      * pair of leaves and each pair of pre-images are assumed to be sorted.
862      */
863     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
864         bytes32 computedHash = leaf;
865 
866         for (uint256 i = 0; i < proof.length; i++) {
867             bytes32 proofElement = proof[i];
868 
869             if (computedHash <= proofElement) {
870                 // Hash(current computed hash + current element of the proof)
871                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
872             } else {
873                 // Hash(current element of the proof + current computed hash)
874                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
875             }
876         }
877 
878         // Check if the computed hash (root) is equal to the provided root
879         return computedHash == root;
880     }
881 }
882 
883 
884 // File contracts/Water.sol
885 pragma solidity ^0.7.3;
886 
887 
888 
889 
890 
891 contract Water is ERC20 {
892     using SafeMath for uint256;
893 
894     uint256 public immutable MAX_SUPPLY = 88888888888000000000000000000;
895     uint256 public immutable WATER_GENESIS_TIMESTAMP = 1629858907;
896     uint256 public immutable WATER_PER_SECOND_PER_BONSAI = 35810908561342;
897     IERC721Enumerable public immutable BONSAI;
898     bytes32 public immutable MERKLE_ROOT;
899 
900     mapping(uint256 => uint256) public last;
901 
902     // This is a packed array of booleans.
903     mapping(uint256 => uint256) private claimedBitMap;
904 
905     constructor(address bonsai, bytes32 root) ERC20("Water", "WATER") {
906         MERKLE_ROOT = root;
907         BONSAI = IERC721Enumerable(bonsai);
908     }
909 
910     function mintForUser(address user) external {
911         require(totalSupply() <= MAX_SUPPLY, "No more $WATER can be minted.");
912 
913         uint256 total = BONSAI.balanceOf(user);
914         uint256 owed = 0;
915         for (uint256 i = 0; i < total; i = i.add(1)) {
916             uint256 id = BONSAI.tokenOfOwnerByIndex(user, i);
917             uint256 claimed = lastClaim(id);
918             owed = owed.add(
919                 block.timestamp.sub(claimed).mul(WATER_PER_SECOND_PER_BONSAI)
920             );
921             last[id] = block.timestamp;
922         }
923         _mint(user, owed);
924     }
925 
926     function mintForIds(uint256[] calldata ids) external {
927         require(totalSupply() <= MAX_SUPPLY, "No more $WATER can be minted.");
928 
929         for (uint256 i = 0; i < ids.length; i = i.add(1)) {
930             uint256 id = ids[i];
931             address owner = BONSAI.ownerOf(id);
932             uint256 claimed = lastClaim(id);
933             uint256 owed = block.timestamp.sub(claimed).mul(
934                 WATER_PER_SECOND_PER_BONSAI
935             );
936             _mint(owner, owed);
937             last[id] = block.timestamp;
938         }
939     }
940 
941     function lastClaim(uint256 id) public view returns (uint256) {
942         return Math.max(last[id], WATER_GENESIS_TIMESTAMP);
943     }
944 
945     function claimable(address user) external view returns (uint256) {
946         uint256 total = BONSAI.balanceOf(user);
947         uint256 owed = 0;
948         for (uint256 i = 0; i < total; i = i.add(1)) {
949             uint256 id = BONSAI.tokenOfOwnerByIndex(user, i);
950             uint256 claimed = lastClaim(id);
951             owed = owed.add(
952                 block.timestamp.sub(claimed).mul(WATER_PER_SECOND_PER_BONSAI)
953             );
954         }
955         return owed;
956     }
957 
958     function isClaimed(uint256 index) public view returns (bool) {
959         uint256 claimedWordIndex = index / 256;
960         uint256 claimedBitIndex = index % 256;
961         uint256 claimedWord = claimedBitMap[claimedWordIndex];
962         uint256 mask = (1 << claimedBitIndex);
963         return claimedWord & mask == mask;
964     }
965 
966     function setClaimed(uint256 index) private {
967         uint256 claimedWordIndex = index / 256;
968         uint256 claimedBitIndex = index % 256;
969         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
970     }
971 
972     function claimRetroactive(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external {
973         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
974 
975         // Verify the merkle proof.
976         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
977         require(MerkleProof.verify(merkleProof, MERKLE_ROOT, node), 'MerkleDistributor: Invalid proof.');
978 
979         // Mark it claimed and send the token.
980         setClaimed(index);
981         _mint(account, amount);
982     }
983 }