1 // SPDX-License-Identifier: Copyleft
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 
25 library SafeMath {
26     /**
27      * @dev Returns the addition of two unsigned integers, reverting on
28      * overflow.
29      *
30      * Counterpart to Solidity's `+` operator.
31      *
32      * Requirements:
33      *
34      * - Addition cannot overflow.
35      */
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39 
40         return c;
41     }
42 
43     /**
44      * @dev Returns the subtraction of two unsigned integers, reverting on
45      * overflow (when the result is negative).
46      *
47      * Counterpart to Solidity's `-` operator.
48      *
49      * Requirements:
50      *
51      * - Subtraction cannot overflow.
52      */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      *
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      *
82      * - Multiplication cannot overflow.
83      */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      *
108      * - The divisor cannot be zero.
109      */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b > 0, errorMessage);
128         uint256 c = a / b;
129         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * Reverts when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         return mod(a, b, "SafeMath: modulo by zero");
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts with custom message when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b != 0, errorMessage);
164         return a % b;
165     }
166 }
167 
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev Contract module which provides a basic access control mechanism, where
173  * there is an account (an owner) that can be granted exclusive access to
174  * specific functions.
175  *
176  * By default, the owner account will be the one that deploys the contract. This
177  * can later be changed with {transferOwnership}.
178  *
179  * This module is used through inheritance. It will make available the modifier
180  * `onlyOwner`, which can be applied to your functions to restrict their use to
181  * the owner.
182  */
183 abstract contract Ownable is Context {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     /**
189      * @dev Initializes the contract setting the deployer as the initial owner.
190      */
191     constructor() {
192         _transferOwnership(_msgSender());
193     }
194 
195     /**
196      * @dev Returns the address of the current owner.
197      */
198     function owner() public view virtual returns (address) {
199         return _owner;
200     }
201 
202     /**
203      * @dev Throws if called by any account other than the owner.
204      */
205     modifier onlyOwner() {
206         require(owner() == _msgSender(), "Ownable: caller is not the owner");
207         _;
208     }
209 
210     /**
211      * @dev Leaves the contract without owner. It will not be possible to call
212      * `onlyOwner` functions anymore. Can only be called by the current owner.
213      *
214      * NOTE: Renouncing ownership will leave the contract without an owner,
215      * thereby removing any functionality that is only available to the owner.
216      */
217     function renounceOwnership() public virtual onlyOwner {
218         _transferOwnership(address(0));
219     }
220 
221     /**
222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
223      * Can only be called by the current owner.
224      */
225     function transferOwnership(address newOwner) public virtual onlyOwner {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         _transferOwnership(newOwner);
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Internal function without access restriction.
233      */
234     function _transferOwnership(address newOwner) internal virtual {
235         address oldOwner = _owner;
236         _owner = newOwner;
237         emit OwnershipTransferred(oldOwner, newOwner);
238     }
239 }
240 
241 
242 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
243 
244 
245 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 /**
250  * @dev Interface of the ERC20 standard as defined in the EIP.
251  */
252 interface IERC20 {
253     /**
254      * @dev Returns the amount of tokens in existence.
255      */
256     function totalSupply() external view returns (uint256);
257 
258     /**
259      * @dev Returns the amount of tokens owned by `account`.
260      */
261     function balanceOf(address account) external view returns (uint256);
262 
263     /**
264      * @dev Moves `amount` tokens from the caller's account to `recipient`.
265      *
266      * Returns a boolean value indicating whether the operation succeeded.
267      *
268      * Emits a {Transfer} event.
269      */
270     function transfer(address recipient, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Returns the remaining number of tokens that `spender` will be
274      * allowed to spend on behalf of `owner` through {transferFrom}. This is
275      * zero by default.
276      *
277      * This value changes when {approve} or {transferFrom} are called.
278      */
279     function allowance(address owner, address spender) external view returns (uint256);
280 
281     /**
282      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
283      *
284      * Returns a boolean value indicating whether the operation succeeded.
285      *
286      * IMPORTANT: Beware that changing an allowance with this method brings the risk
287      * that someone may use both the old and the new allowance by unfortunate
288      * transaction ordering. One possible solution to mitigate this race
289      * condition is to first reduce the spender's allowance to 0 and set the
290      * desired value afterwards:
291      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292      *
293      * Emits an {Approval} event.
294      */
295     function approve(address spender, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Moves `amount` tokens from `sender` to `recipient` using the
299      * allowance mechanism. `amount` is then deducted from the caller's
300      * allowance.
301      *
302      * Returns a boolean value indicating whether the operation succeeded.
303      *
304      * Emits a {Transfer} event.
305      */
306     function transferFrom(
307         address sender,
308         address recipient,
309         uint256 amount
310     ) external returns (bool);
311 
312     /**
313      * @dev Emitted when `value` tokens are moved from one account (`from`) to
314      * another (`to`).
315      *
316      * Note that `value` may be zero.
317      */
318     event Transfer(address indexed from, address indexed to, uint256 value);
319 
320     /**
321      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
322      * a call to {approve}. `value` is the new allowance.
323      */
324     event Approval(address indexed owner, address indexed spender, uint256 value);
325 }
326 
327 
328 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
329 
330 
331 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev Interface for the optional metadata functions from the ERC20 standard.
337  *
338  * _Available since v4.1._
339  */
340 interface IERC20Metadata is IERC20 {
341     /**
342      * @dev Returns the name of the token.
343      */
344     function name() external view returns (string memory);
345 
346     /**
347      * @dev Returns the symbol of the token.
348      */
349     function symbol() external view returns (string memory);
350 
351     /**
352      * @dev Returns the decimals places of the token.
353      */
354     function decimals() external view returns (uint8);
355 }
356 
357 
358 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
359 
360 
361 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
362 
363 pragma solidity ^0.8.0;
364 
365 
366 
367 /**
368  * @dev Implementation of the {IERC20} interface.
369  *
370  * This implementation is agnostic to the way tokens are created. This means
371  * that a supply mechanism has to be added in a derived contract using {_mint}.
372  * For a generic mechanism see {ERC20PresetMinterPauser}.
373  *
374  * TIP: For a detailed writeup see our guide
375  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
376  * to implement supply mechanisms].
377  *
378  * We have followed general OpenZeppelin Contracts guidelines: functions revert
379  * instead returning `false` on failure. This behavior is nonetheless
380  * conventional and does not conflict with the expectations of ERC20
381  * applications.
382  *
383  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
384  * This allows applications to reconstruct the allowance for all accounts just
385  * by listening to said events. Other implementations of the EIP may not emit
386  * these events, as it isn't required by the specification.
387  *
388  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
389  * functions have been added to mitigate the well-known issues around setting
390  * allowances. See {IERC20-approve}.
391  */
392 contract ERC20 is Context, IERC20, IERC20Metadata {
393     mapping(address => uint256) private _balances;
394 
395     mapping(address => mapping(address => uint256)) private _allowances;
396 
397     uint256 private _totalSupply;
398 
399     string private _name;
400     string private _symbol;
401 
402     /**
403      * @dev Sets the values for {name} and {symbol}.
404      *
405      * The default value of {decimals} is 18. To select a different value for
406      * {decimals} you should overload it.
407      *
408      * All two of these values are immutable: they can only be set once during
409      * construction.
410      */
411     constructor(string memory name_, string memory symbol_) {
412         _name = name_;
413         _symbol = symbol_;
414     }
415 
416     /**
417      * @dev Returns the name of the token.
418      */
419     function name() public view virtual override returns (string memory) {
420         return _name;
421     }
422 
423     /**
424      * @dev Returns the symbol of the token, usually a shorter version of the
425      * name.
426      */
427     function symbol() public view virtual override returns (string memory) {
428         return _symbol;
429     }
430 
431     /**
432      * @dev Returns the number of decimals used to get its user representation.
433      * For example, if `decimals` equals `2`, a balance of `505` tokens should
434      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
435      *
436      * Tokens usually opt for a value of 18, imitating the relationship between
437      * Ether and Wei. This is the value {ERC20} uses, unless this function is
438      * overridden;
439      *
440      * NOTE: This information is only used for _display_ purposes: it in
441      * no way affects any of the arithmetic of the contract, including
442      * {IERC20-balanceOf} and {IERC20-transfer}.
443      */
444     function decimals() public view virtual override returns (uint8) {
445         return 18;
446     }
447 
448     /**
449      * @dev See {IERC20-totalSupply}.
450      */
451     function totalSupply() public view virtual override returns (uint256) {
452         return _totalSupply;
453     }
454 
455     /**
456      * @dev See {IERC20-balanceOf}.
457      */
458     function balanceOf(address account) public view virtual override returns (uint256) {
459         return _balances[account];
460     }
461 
462     /**
463      * @dev See {IERC20-transfer}.
464      *
465      * Requirements:
466      *
467      * - `recipient` cannot be the zero address.
468      * - the caller must have a balance of at least `amount`.
469      */
470     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
471         _transfer(_msgSender(), recipient, amount);
472         return true;
473     }
474 
475     /**
476      * @dev See {IERC20-allowance}.
477      */
478     function allowance(address owner, address spender) public view virtual override returns (uint256) {
479         return _allowances[owner][spender];
480     }
481 
482     /**
483      * @dev See {IERC20-approve}.
484      *
485      * Requirements:
486      *
487      * - `spender` cannot be the zero address.
488      */
489     function approve(address spender, uint256 amount) public virtual override returns (bool) {
490         _approve(_msgSender(), spender, amount);
491         return true;
492     }
493 
494     /**
495      * @dev See {IERC20-transferFrom}.
496      *
497      * Emits an {Approval} event indicating the updated allowance. This is not
498      * required by the EIP. See the note at the beginning of {ERC20}.
499      *
500      * Requirements:
501      *
502      * - `sender` and `recipient` cannot be the zero address.
503      * - `sender` must have a balance of at least `amount`.
504      * - the caller must have allowance for ``sender``'s tokens of at least
505      * `amount`.
506      */
507     function transferFrom(
508         address sender,
509         address recipient,
510         uint256 amount
511     ) public virtual override returns (bool) {
512         _transfer(sender, recipient, amount);
513 
514         uint256 currentAllowance = _allowances[sender][_msgSender()];
515         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
516         unchecked {
517             _approve(sender, _msgSender(), currentAllowance - amount);
518         }
519 
520         return true;
521     }
522 
523     /**
524      * @dev Atomically increases the allowance granted to `spender` by the caller.
525      *
526      * This is an alternative to {approve} that can be used as a mitigation for
527      * problems described in {IERC20-approve}.
528      *
529      * Emits an {Approval} event indicating the updated allowance.
530      *
531      * Requirements:
532      *
533      * - `spender` cannot be the zero address.
534      */
535     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
536         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
537         return true;
538     }
539 
540     /**
541      * @dev Atomically decreases the allowance granted to `spender` by the caller.
542      *
543      * This is an alternative to {approve} that can be used as a mitigation for
544      * problems described in {IERC20-approve}.
545      *
546      * Emits an {Approval} event indicating the updated allowance.
547      *
548      * Requirements:
549      *
550      * - `spender` cannot be the zero address.
551      * - `spender` must have allowance for the caller of at least
552      * `subtractedValue`.
553      */
554     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
555         uint256 currentAllowance = _allowances[_msgSender()][spender];
556         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
557         unchecked {
558             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
559         }
560 
561         return true;
562     }
563 
564     /**
565      * @dev Moves `amount` of tokens from `sender` to `recipient`.
566      *
567      * This internal function is equivalent to {transfer}, and can be used to
568      * e.g. implement automatic token fees, slashing mechanisms, etc.
569      *
570      * Emits a {Transfer} event.
571      *
572      * Requirements:
573      *
574      * - `sender` cannot be the zero address.
575      * - `recipient` cannot be the zero address.
576      * - `sender` must have a balance of at least `amount`.
577      */
578     function _transfer(
579         address sender,
580         address recipient,
581         uint256 amount
582     ) internal virtual {
583         require(sender != address(0), "ERC20: transfer from the zero address");
584         require(recipient != address(0), "ERC20: transfer to the zero address");
585 
586         _beforeTokenTransfer(sender, recipient, amount);
587 
588         uint256 senderBalance = _balances[sender];
589         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
590         unchecked {
591             _balances[sender] = senderBalance - amount;
592         }
593         _balances[recipient] += amount;
594 
595         emit Transfer(sender, recipient, amount);
596 
597         _afterTokenTransfer(sender, recipient, amount);
598     }
599 
600     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
601      * the total supply.
602      *
603      * Emits a {Transfer} event with `from` set to the zero address.
604      *
605      * Requirements:
606      *
607      * - `account` cannot be the zero address.
608      */
609     function _mint(address account, uint256 amount) internal virtual {
610         require(account != address(0), "ERC20: mint to the zero address");
611 
612         _beforeTokenTransfer(address(0), account, amount);
613 
614         _totalSupply += amount;
615         _balances[account] += amount;
616         emit Transfer(address(0), account, amount);
617 
618         _afterTokenTransfer(address(0), account, amount);
619     }
620 
621     /**
622      * @dev Destroys `amount` tokens from `account`, reducing the
623      * total supply.
624      *
625      * Emits a {Transfer} event with `to` set to the zero address.
626      *
627      * Requirements:
628      *
629      * - `account` cannot be the zero address.
630      * - `account` must have at least `amount` tokens.
631      */
632     function _burn(address account, uint256 amount) internal virtual {
633         require(account != address(0), "ERC20: burn from the zero address");
634 
635         _beforeTokenTransfer(account, address(0), amount);
636 
637         uint256 accountBalance = _balances[account];
638         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
639         unchecked {
640             _balances[account] = accountBalance - amount;
641         }
642         _totalSupply -= amount;
643 
644         emit Transfer(account, address(0), amount);
645 
646         _afterTokenTransfer(account, address(0), amount);
647     }
648 
649     /**
650      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
651      *
652      * This internal function is equivalent to `approve`, and can be used to
653      * e.g. set automatic allowances for certain subsystems, etc.
654      *
655      * Emits an {Approval} event.
656      *
657      * Requirements:
658      *
659      * - `owner` cannot be the zero address.
660      * - `spender` cannot be the zero address.
661      */
662     function _approve(
663         address owner,
664         address spender,
665         uint256 amount
666     ) internal virtual {
667         require(owner != address(0), "ERC20: approve from the zero address");
668         require(spender != address(0), "ERC20: approve to the zero address");
669 
670         _allowances[owner][spender] = amount;
671         emit Approval(owner, spender, amount);
672     }
673 
674     /**
675      * @dev Hook that is called before any transfer of tokens. This includes
676      * minting and burning.
677      *
678      * Calling conditions:
679      *
680      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
681      * will be transferred to `to`.
682      * - when `from` is zero, `amount` tokens will be minted for `to`.
683      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
684      * - `from` and `to` are never both zero.
685      *
686      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
687      */
688     function _beforeTokenTransfer(
689         address from,
690         address to,
691         uint256 amount
692     ) internal virtual {}
693 
694     /**
695      * @dev Hook that is called after any transfer of tokens. This includes
696      * minting and burning.
697      *
698      * Calling conditions:
699      *
700      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
701      * has been transferred to `to`.
702      * - when `from` is zero, `amount` tokens have been minted for `to`.
703      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
704      * - `from` and `to` are never both zero.
705      *
706      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
707      */
708     function _afterTokenTransfer(
709         address from,
710         address to,
711         uint256 amount
712     ) internal virtual {}
713 }
714 
715 pragma solidity ^0.8.0;
716 contract Trump is Ownable, ERC20 {
717 
718     using SafeMath for uint256;
719 
720     /**
721         Error codes:
722 
723         BA: 
724             Let me tell you, folks, you've been blacklisted. That's right, you're out. You're done. 
725             You've crossed the line, and now you're paying the price. I'm sorry to say it, but that's just the way it is.
726             You had your chance, but you blew it. So now, you're on the blacklist. 
727             It's not a good place to be, believe me. But you brought it on yourself.
728 
729     
730 
731         NR:
732             Let me make it clear, folks - we haven't even started trading yet. That's right, it's still early days.
733             But let me tell you, when we do start trading, it's going to be huge. People are going to be talking about it all
734             over the world. We're going to make cryptocurrency great again, believe me. But for now, just be patient. 
735             Good things come to those who wait, and trust me, this is going to be worth the wait.
736 
737 
738         NA:
739             If you think you can transfer an amount that's not between the minimum and maximum values allowed, think again 
740             - it's not going to happen on our watch!"
741 
742     
743      */
744 
745 
746     bool public limited;
747     uint256 public maxHoldingAmount;
748     uint256 public minHoldingAmount;
749     address public uniswapV2Pair;
750     mapping(address => bool) public blacklists;
751 
752     constructor() ERC20("Trump", "TRUMP") {
753         _mint(msg.sender, 450690000000000 * (10**18));
754     }
755 
756     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
757         blacklists[_address] = _isBlacklisting;
758     }
759 
760     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
761         limited = _limited;
762         uniswapV2Pair = _uniswapV2Pair;
763         maxHoldingAmount = _maxHoldingAmount;
764         minHoldingAmount = _minHoldingAmount;
765     }
766 
767     function _beforeTokenTransfer(
768         address from,
769         address to,
770         uint256 amount
771     ) override internal virtual {
772         require(!blacklists[to] && !blacklists[from], "BA");
773 
774         if (uniswapV2Pair == address(0)) {
775             require(from == owner() || to == owner(), "NR");
776             return;
777         }
778 
779         if (limited && from == uniswapV2Pair) {
780             require(super.balanceOf(to).add(amount) <= maxHoldingAmount && super.balanceOf(to).add(amount) >= minHoldingAmount, "NA");
781         }
782     }
783 
784     function burn(uint256 value) external {
785         _burn(msg.sender, value);
786     }
787 }