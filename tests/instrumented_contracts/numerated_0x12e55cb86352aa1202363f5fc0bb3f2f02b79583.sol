1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.18;
3 
4 /*
5                   https://swapbro.co/
6                 https://t.me/SwapBroETH
7              https://twitter.com/SwapBroETH
8             ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀
9             ⠀⢀⣀⣤⣤⣶⣾⣿⣿⣿⠿⠿⠿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀
10             ⠸⣿⣿⡿⠛⠉⠉⠛⠋⠁⠀⠀⠀⠀⠉⠀⠀⠀⠈⠙⢿⣿⣷⡀
11             ⠀⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⡇
12             ⠀⢿⣿⡇⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⢠⡄⠀⠀⠀⠀⠀⣿⣿⣿
13             ⠀⢸⣿⡇⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⣇⠀⠀⠀⠀⠀⣿⣿⡟
14             ⠀⠈⣿⡇⠀⠀⠀⠀⠐⣷⠀⠀⠀⠀⠀⢹⡀⠀⠀⠀⣰⣿⣿⡇
15             ⠀⠀⢹⣷⣄⡀⠀⠀⣀⣿⣦⣀⣀⣀⣠⣾⣷⣶⣶⣾⣿⣿⡟⠀
16             ⠀⠀⠘⣿⣿⡿⠛⠋⠉⠀⠀⠈⠉⠈⠛⣿⣿⣿⣿⣿⠿⠋⠀⠀
17             ⠀⠀⠀⢻⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⣀⣾⣿⠛⠉⠀⠀⠀⠀⠀
18             ⠀⠀⠀⠈⣿⣿⣿⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀
19             ⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀
20             ⠀⠀⠀⠀⠀⢻⣿⣿⡿⠿⠿⠿⠛⠛⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀
21 */
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `recipient`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `sender` to `recipient` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 /**
192  * @dev Interface for the optional metadata functions from the ERC20 standard.
193  *
194  * _Available since v4.1._
195  */
196 interface IERC20Metadata is IERC20 {
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the symbol of the token.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the decimals places of the token.
209      */
210     function decimals() external view returns (uint8);
211 }
212 
213 /**
214  * @dev Implementation of the {IERC20} interface.
215  *
216  * This implementation is agnostic to the way tokens are created. This means
217  * that a supply mechanism has to be added in a derived contract using {_mint}.
218  * For a generic mechanism see {ERC20PresetMinterPauser}.
219  *
220  * TIP: For a detailed writeup see our guide
221  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
222  * to implement supply mechanisms].
223  *
224  * We have followed general OpenZeppelin Contracts guidelines: functions revert
225  * instead returning `false` on failure. This behavior is nonetheless
226  * conventional and does not conflict with the expectations of ERC20
227  * applications.
228  *
229  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
230  * This allows applications to reconstruct the allowance for all accounts just
231  * by listening to said events. Other implementations of the EIP may not emit
232  * these events, as it isn't required by the specification.
233  *
234  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
235  * functions have been added to mitigate the well-known issues around setting
236  * allowances. See {IERC20-approve}.
237  */
238 contract ERC20 is Context, IERC20, IERC20Metadata {
239     mapping(address => uint256) private _balances;
240 
241     mapping(address => mapping(address => uint256)) private _allowances;
242 
243     uint256 private _totalSupply;
244 
245     string private _name;
246     string private _symbol;
247 
248     /**
249      * @dev Sets the values for {name} and {symbol}.
250      *
251      * The default value of {decimals} is 18. To select a different value for
252      * {decimals} you should overload it.
253      *
254      * All two of these values are immutable: they can only be set once during
255      * construction.
256      */
257     constructor(string memory name_, string memory symbol_) {
258         _name = name_;
259         _symbol = symbol_;
260     }
261 
262     /**
263      * @dev Returns the name of the token.
264      */
265     function name() public view virtual override returns (string memory) {
266         return _name;
267     }
268 
269     /**
270      * @dev Returns the symbol of the token, usually a shorter version of the
271      * name.
272      */
273     function symbol() public view virtual override returns (string memory) {
274         return _symbol;
275     }
276 
277     /**
278      * @dev Returns the number of decimals used to get its user representation.
279      * For example, if `decimals` equals `2`, a balance of `505` tokens should
280      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
281      *
282      * Tokens usually opt for a value of 18, imitating the relationship between
283      * Ether and Wei. This is the value {ERC20} uses, unless this function is
284      * overridden;
285      *
286      * NOTE: This information is only used for _display_ purposes: it in
287      * no way affects any of the arithmetic of the contract, including
288      * {IERC20-balanceOf} and {IERC20-transfer}.
289      */
290     function decimals() public view virtual override returns (uint8) {
291         return 18;
292     }
293 
294     /**
295      * @dev See {IERC20-totalSupply}.
296      */
297     function totalSupply() public view virtual override returns (uint256) {
298         return _totalSupply;
299     }
300 
301     /**
302      * @dev See {IERC20-balanceOf}.
303      */
304     function balanceOf(address account) public view virtual override returns (uint256) {
305         return _balances[account];
306     }
307 
308     /**
309      * @dev See {IERC20-transfer}.
310      *
311      * Requirements:
312      *
313      * - `recipient` cannot be the zero address.
314      * - the caller must have a balance of at least `amount`.
315      */
316     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
317         _transfer(_msgSender(), recipient, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-allowance}.
323      */
324     function allowance(address owner, address spender) public view virtual override returns (uint256) {
325         return _allowances[owner][spender];
326     }
327 
328     /**
329      * @dev See {IERC20-approve}.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function approve(address spender, uint256 amount) public virtual override returns (bool) {
336         _approve(_msgSender(), spender, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-transferFrom}.
342      *
343      * Emits an {Approval} event indicating the updated allowance. This is not
344      * required by the EIP. See the note at the beginning of {ERC20}.
345      *
346      * Requirements:
347      *
348      * - `sender` and `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      * - the caller must have allowance for ``sender``'s tokens of at least
351      * `amount`.
352      */
353     function transferFrom(
354         address sender,
355         address recipient,
356         uint256 amount
357     ) public virtual override returns (bool) {
358         _transfer(sender, recipient, amount);
359 
360         uint256 currentAllowance = _allowances[sender][_msgSender()];
361         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
362         unchecked {
363             _approve(sender, _msgSender(), currentAllowance - amount);
364         }
365 
366         return true;
367     }
368 
369     /**
370      * @dev Atomically increases the allowance granted to `spender` by the caller.
371      *
372      * This is an alternative to {approve} that can be used as a mitigation for
373      * problems described in {IERC20-approve}.
374      *
375      * Emits an {Approval} event indicating the updated allowance.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      */
381     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
382         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
383         return true;
384     }
385 
386     /**
387      * @dev Atomically decreases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to {approve} that can be used as a mitigation for
390      * problems described in {IERC20-approve}.
391      *
392      * Emits an {Approval} event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      * - `spender` must have allowance for the caller of at least
398      * `subtractedValue`.
399      */
400     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
401         uint256 currentAllowance = _allowances[_msgSender()][spender];
402         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
403         unchecked {
404             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
405         }
406 
407         return true;
408     }
409 
410     /**
411      * @dev Moves `amount` of tokens from `sender` to `recipient`.
412      *
413      * This internal function is equivalent to {transfer}, and can be used to
414      * e.g. implement automatic token fees, slashing mechanisms, etc.
415      *
416      * Emits a {Transfer} event.
417      *
418      * Requirements:
419      *
420      * - `sender` cannot be the zero address.
421      * - `recipient` cannot be the zero address.
422      * - `sender` must have a balance of at least `amount`.
423      */
424     function _transfer(
425         address sender,
426         address recipient,
427         uint256 amount
428     ) internal virtual {
429         require(sender != address(0), "ERC20: transfer from the zero address");
430         require(recipient != address(0), "ERC20: transfer to the zero address");
431 
432         _beforeTokenTransfer(sender, recipient, amount);
433 
434         uint256 senderBalance = _balances[sender];
435         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
436         unchecked {
437             _balances[sender] = senderBalance - amount;
438         }
439         _balances[recipient] += amount;
440 
441         emit Transfer(sender, recipient, amount);
442 
443         _afterTokenTransfer(sender, recipient, amount);
444     }
445 
446     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
447      * the total supply.
448      *
449      * Emits a {Transfer} event with `from` set to the zero address.
450      *
451      * Requirements:
452      *
453      * - `account` cannot be the zero address.
454      */
455     function _mint(address account, uint256 amount) internal virtual {
456         require(account != address(0), "ERC20: mint to the zero address");
457 
458         _beforeTokenTransfer(address(0), account, amount);
459 
460         _totalSupply += amount;
461         _balances[account] += amount;
462         emit Transfer(address(0), account, amount);
463 
464         _afterTokenTransfer(address(0), account, amount);
465     }
466 
467     /**
468      * @dev Destroys `amount` tokens from `account`, reducing the
469      * total supply.
470      *
471      * Emits a {Transfer} event with `to` set to the zero address.
472      *
473      * Requirements:
474      *
475      * - `account` cannot be the zero address.
476      * - `account` must have at least `amount` tokens.
477      */
478     function _burn(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: burn from the zero address");
480 
481         _beforeTokenTransfer(account, address(0), amount);
482 
483         uint256 accountBalance = _balances[account];
484         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
485         unchecked {
486             _balances[account] = accountBalance - amount;
487         }
488         _totalSupply -= amount;
489 
490         emit Transfer(account, address(0), amount);
491 
492         _afterTokenTransfer(account, address(0), amount);
493     }
494 
495     /**
496      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
497      *
498      * This internal function is equivalent to `approve`, and can be used to
499      * e.g. set automatic allowances for certain subsystems, etc.
500      *
501      * Emits an {Approval} event.
502      *
503      * Requirements:
504      *
505      * - `owner` cannot be the zero address.
506      * - `spender` cannot be the zero address.
507      */
508     function _approve(
509         address owner,
510         address spender,
511         uint256 amount
512     ) internal virtual {
513         require(owner != address(0), "ERC20: approve from the zero address");
514         require(spender != address(0), "ERC20: approve to the zero address");
515 
516         _allowances[owner][spender] = amount;
517         emit Approval(owner, spender, amount);
518     }
519 
520     /**
521      * @dev Hook that is called before any transfer of tokens. This includes
522      * minting and burning.
523      *
524      * Calling conditions:
525      *
526      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
527      * will be transferred to `to`.
528      * - when `from` is zero, `amount` tokens will be minted for `to`.
529      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
530      * - `from` and `to` are never both zero.
531      *
532      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
533      */
534     function _beforeTokenTransfer(
535         address from,
536         address to,
537         uint256 amount
538     ) internal virtual {}
539 
540     /**
541      * @dev Hook that is called after any transfer of tokens. This includes
542      * minting and burning.
543      *
544      * Calling conditions:
545      *
546      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
547      * has been transferred to `to`.
548      * - when `from` is zero, `amount` tokens have been minted for `to`.
549      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
550      * - `from` and `to` are never both zero.
551      *
552      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
553      */
554     function _afterTokenTransfer(
555         address from,
556         address to,
557         uint256 amount
558     ) internal virtual {}
559 }
560 
561 /**
562  * @dev Wrappers over Solidity's arithmetic operations.
563  *
564  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
565  * now has built in overflow checking.
566  */
567 library SafeMath {
568     /**
569      * @dev Returns the addition of two unsigned integers, with an overflow flag.
570      *
571      * _Available since v3.4._
572      */
573     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
574         unchecked {
575             uint256 c = a + b;
576             if (c < a) return (false, 0);
577             return (true, c);
578         }
579     }
580 
581     /**
582      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
583      *
584      * _Available since v3.4._
585      */
586     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
587         unchecked {
588             if (b > a) return (false, 0);
589             return (true, a - b);
590         }
591     }
592 
593     /**
594      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
595      *
596      * _Available since v3.4._
597      */
598     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
599         unchecked {
600             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
601             // benefit is lost if 'b' is also tested.
602             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
603             if (a == 0) return (true, 0);
604             uint256 c = a * b;
605             if (c / a != b) return (false, 0);
606             return (true, c);
607         }
608     }
609 
610     /**
611      * @dev Returns the division of two unsigned integers, with a division by zero flag.
612      *
613      * _Available since v3.4._
614      */
615     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
616         unchecked {
617             if (b == 0) return (false, 0);
618             return (true, a / b);
619         }
620     }
621 
622     /**
623      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
624      *
625      * _Available since v3.4._
626      */
627     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
628         unchecked {
629             if (b == 0) return (false, 0);
630             return (true, a % b);
631         }
632     }
633 
634     /**
635      * @dev Returns the addition of two unsigned integers, reverting on
636      * overflow.
637      *
638      * Counterpart to Solidity's `+` operator.
639      *
640      * Requirements:
641      *
642      * - Addition cannot overflow.
643      */
644     function add(uint256 a, uint256 b) internal pure returns (uint256) {
645         return a + b;
646     }
647 
648     /**
649      * @dev Returns the subtraction of two unsigned integers, reverting on
650      * overflow (when the result is negative).
651      *
652      * Counterpart to Solidity's `-` operator.
653      *
654      * Requirements:
655      *
656      * - Subtraction cannot overflow.
657      */
658     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
659         return a - b;
660     }
661 
662     /**
663      * @dev Returns the multiplication of two unsigned integers, reverting on
664      * overflow.
665      *
666      * Counterpart to Solidity's `*` operator.
667      *
668      * Requirements:
669      *
670      * - Multiplication cannot overflow.
671      */
672     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
673         return a * b;
674     }
675 
676     /**
677      * @dev Returns the integer division of two unsigned integers, reverting on
678      * division by zero. The result is rounded towards zero.
679      *
680      * Counterpart to Solidity's `/` operator.
681      *
682      * Requirements:
683      *
684      * - The divisor cannot be zero.
685      */
686     function div(uint256 a, uint256 b) internal pure returns (uint256) {
687         return a / b;
688     }
689 
690     /**
691      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
692      * reverting when dividing by zero.
693      *
694      * Counterpart to Solidity's `%` operator. This function uses a `revert`
695      * opcode (which leaves remaining gas untouched) while Solidity uses an
696      * invalid opcode to revert (consuming all remaining gas).
697      *
698      * Requirements:
699      *
700      * - The divisor cannot be zero.
701      */
702     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
703         return a % b;
704     }
705 
706     /**
707      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
708      * overflow (when the result is negative).
709      *
710      * CAUTION: This function is deprecated because it requires allocating memory for the error
711      * message unnecessarily. For custom revert reasons use {trySub}.
712      *
713      * Counterpart to Solidity's `-` operator.
714      *
715      * Requirements:
716      *
717      * - Subtraction cannot overflow.
718      */
719     function sub(
720         uint256 a,
721         uint256 b,
722         string memory errorMessage
723     ) internal pure returns (uint256) {
724         unchecked {
725             require(b <= a, errorMessage);
726             return a - b;
727         }
728     }
729 
730     /**
731      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
732      * division by zero. The result is rounded towards zero.
733      *
734      * Counterpart to Solidity's `/` operator. Note: this function uses a
735      * `revert` opcode (which leaves remaining gas untouched) while Solidity
736      * uses an invalid opcode to revert (consuming all remaining gas).
737      *
738      * Requirements:
739      *
740      * - The divisor cannot be zero.
741      */
742     function div(
743         uint256 a,
744         uint256 b,
745         string memory errorMessage
746     ) internal pure returns (uint256) {
747         unchecked {
748             require(b > 0, errorMessage);
749             return a / b;
750         }
751     }
752 
753     /**
754      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
755      * reverting with custom message when dividing by zero.
756      *
757      * CAUTION: This function is deprecated because it requires allocating memory for the error
758      * message unnecessarily. For custom revert reasons use {tryMod}.
759      *
760      * Counterpart to Solidity's `%` operator. This function uses a `revert`
761      * opcode (which leaves remaining gas untouched) while Solidity uses an
762      * invalid opcode to revert (consuming all remaining gas).
763      *
764      * Requirements:
765      *
766      * - The divisor cannot be zero.
767      */
768     function mod(
769         uint256 a,
770         uint256 b,
771         string memory errorMessage
772     ) internal pure returns (uint256) {
773         unchecked {
774             require(b > 0, errorMessage);
775             return a % b;
776         }
777     }
778 }
779 
780 interface IUniswapV2Factory {
781     event PairCreated(
782         address indexed token0,
783         address indexed token1,
784         address pair,
785         uint256
786     );
787 
788     function feeTo() external view returns (address);
789 
790     function feeToSetter() external view returns (address);
791 
792     function getPair(address tokenA, address tokenB)
793         external
794         view
795         returns (address pair);
796 
797     function allPairs(uint256) external view returns (address pair);
798 
799     function allPairsLength() external view returns (uint256);
800 
801     function createPair(address tokenA, address tokenB)
802         external
803         returns (address pair);
804 
805     function setFeeTo(address) external;
806 
807     function setFeeToSetter(address) external;
808 }
809 
810 interface IUniswapV2Pair {
811     event Approval(
812         address indexed owner,
813         address indexed spender,
814         uint256 value
815     );
816     event Transfer(address indexed from, address indexed to, uint256 value);
817 
818     function name() external pure returns (string memory);
819 
820     function symbol() external pure returns (string memory);
821 
822     function decimals() external pure returns (uint8);
823 
824     function totalSupply() external view returns (uint256);
825 
826     function balanceOf(address owner) external view returns (uint256);
827 
828     function allowance(address owner, address spender)
829         external
830         view
831         returns (uint256);
832 
833     function approve(address spender, uint256 value) external returns (bool);
834 
835     function transfer(address to, uint256 value) external returns (bool);
836 
837     function transferFrom(
838         address from,
839         address to,
840         uint256 value
841     ) external returns (bool);
842 
843     function DOMAIN_SEPARATOR() external view returns (bytes32);
844 
845     function PERMIT_TYPEHASH() external pure returns (bytes32);
846 
847     function nonces(address owner) external view returns (uint256);
848 
849     function permit(
850         address owner,
851         address spender,
852         uint256 value,
853         uint256 deadline,
854         uint8 v,
855         bytes32 r,
856         bytes32 s
857     ) external;
858 
859     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
860     event Burn(
861         address indexed sender,
862         uint256 amount0,
863         uint256 amount1,
864         address indexed to
865     );
866     event Swap(
867         address indexed sender,
868         uint256 amount0In,
869         uint256 amount1In,
870         uint256 amount0Out,
871         uint256 amount1Out,
872         address indexed to
873     );
874     event Sync(uint112 reserve0, uint112 reserve1);
875 
876     function MINIMUM_LIQUIDITY() external pure returns (uint256);
877 
878     function factory() external view returns (address);
879 
880     function token0() external view returns (address);
881 
882     function token1() external view returns (address);
883 
884     function getReserves()
885         external
886         view
887         returns (
888             uint112 reserve0,
889             uint112 reserve1,
890             uint32 blockTimestampLast
891         );
892 
893     function price0CumulativeLast() external view returns (uint256);
894 
895     function price1CumulativeLast() external view returns (uint256);
896 
897     function kLast() external view returns (uint256);
898 
899     function mint(address to) external returns (uint256 liquidity);
900 
901     function burn(address to)
902         external
903         returns (uint256 amount0, uint256 amount1);
904 
905     function swap(
906         uint256 amount0Out,
907         uint256 amount1Out,
908         address to,
909         bytes calldata data
910     ) external;
911 
912     function skim(address to) external;
913 
914     function sync() external;
915 
916     function initialize(address, address) external;
917 }
918 
919 interface IUniswapV2Router02 {
920     function factory() external pure returns (address);
921 
922     function WETH() external pure returns (address);
923 
924     function addLiquidity(
925         address tokenA,
926         address tokenB,
927         uint256 amountADesired,
928         uint256 amountBDesired,
929         uint256 amountAMin,
930         uint256 amountBMin,
931         address to,
932         uint256 deadline
933     )
934         external
935         returns (
936             uint256 amountA,
937             uint256 amountB,
938             uint256 liquidity
939         );
940 
941     function addLiquidityETH(
942         address token,
943         uint256 amountTokenDesired,
944         uint256 amountTokenMin,
945         uint256 amountETHMin,
946         address to,
947         uint256 deadline
948     )
949         external
950         payable
951         returns (
952             uint256 amountToken,
953             uint256 amountETH,
954             uint256 liquidity
955         );
956 
957     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
958         uint256 amountIn,
959         uint256 amountOutMin,
960         address[] calldata path,
961         address to,
962         uint256 deadline
963     ) external;
964 
965     function swapExactETHForTokensSupportingFeeOnTransferTokens(
966         uint256 amountOutMin,
967         address[] calldata path,
968         address to,
969         uint256 deadline
970     ) external payable;
971 
972     function swapExactTokensForETHSupportingFeeOnTransferTokens(
973         uint256 amountIn,
974         uint256 amountOutMin,
975         address[] calldata path,
976         address to,
977         uint256 deadline
978     ) external;
979 }
980 
981 contract SwapBro is ERC20, Ownable {
982     using SafeMath for uint256;
983 
984     IUniswapV2Router02 public immutable uniswapV2Router;
985     address public immutable uniswapV2Pair;
986     address public constant deadAddress = address(0xdead);
987 
988     bool private swapping;
989 
990     address payable public marketingWallet;
991     address payable public treasuryWallet;
992 
993     uint256 public maxTransactionAmount;
994     uint256 public swapTokensAtAmount;
995     uint256 public maxWallet;
996 
997     bool public limitsInEffect = true;
998     bool public tradingActive = false;
999     bool public swapEnabled = false;
1000 
1001     // Anti-bot and anti-whale mappings and variables
1002     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1003     bool public transferDelayEnabled = true;
1004 
1005     uint256 public buyTotalFees;
1006     uint256 public buyMarketingFee;
1007     uint256 public buyLiquidityFee;
1008     uint256 public buyTreasuryFee;
1009 
1010     uint256 public sellTotalFees;
1011     uint256 public sellMarketingFee;
1012     uint256 public sellLiquidityFee;
1013     uint256 public sellTreasuryFee;
1014 
1015     uint256 public tokensForMarketing;
1016     uint256 public tokensForLiquidity;
1017     uint256 public tokensForTreasury;
1018 
1019     // exlcude from fees and max transaction amount
1020     mapping(address => bool) private _isExcludedFromFees;
1021     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1022 
1023     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1024     // could be subject to a maximum transfer amount
1025     mapping(address => bool) public automatedMarketMakerPairs;
1026 
1027     event UpdateUniswapV2Router(
1028         address indexed newAddress,
1029         address indexed oldAddress
1030     );
1031 
1032     event ExcludeFromFees(address indexed account, bool isExcluded);
1033 
1034     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1035 
1036     event marketingWalletUpdated(
1037         address indexed newWallet,
1038         address indexed oldWallet
1039     );
1040 
1041     event treasuryWalletUpdated(
1042         address indexed newWallet,
1043         address indexed oldWallet
1044     );
1045 
1046     event SwapAndLiquify(
1047         uint256 tokensSwapped,
1048         uint256 ethReceived,
1049         uint256 tokensIntoLiquidity
1050     );
1051 
1052     event AutoNukeLP();
1053 
1054     event ManualNukeLP();
1055 
1056     constructor() ERC20("SwapBro", "BRUH") {
1057         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1058             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1059         );
1060 
1061         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1062         uniswapV2Router = _uniswapV2Router;
1063 
1064         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1065         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1066         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1067 
1068         uint256 totalSupply = 100_000_000 * 1e18;
1069 
1070         uint256 _buyMarketingFee = 29;
1071         uint256 _buyLiquidityFee = 0;
1072         uint256 _buyTreasuryFee = 1;
1073 
1074         uint256 _sellMarketingFee = 29;
1075         uint256 _sellLiquidityFee = 0;
1076         uint256 _sellTreasuryFee = 1;
1077 
1078         maxTransactionAmount = 2_500_000 * 1e18; // 2.5% from total supply maxTransactionAmountTxn
1079         maxWallet = 2_500_000 * 1e18; // 2.5% from total supply maxWallet
1080         swapTokensAtAmount = (totalSupply * 2) / 10000; // 0.02% swap wallet
1081 
1082         buyMarketingFee = _buyMarketingFee;
1083         buyLiquidityFee = _buyLiquidityFee;
1084         buyTreasuryFee = _buyTreasuryFee;
1085         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTreasuryFee;
1086 
1087         sellMarketingFee = _sellMarketingFee;
1088         sellLiquidityFee = _sellLiquidityFee;
1089         sellTreasuryFee = _sellTreasuryFee;
1090         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellTreasuryFee;
1091 
1092         marketingWallet = payable(0xB5FF0bc5a60ad77fe5167E038052ec13Cc1B1F32);
1093         treasuryWallet = payable(0x41DD528e4AFcb5591f4b98A6722e6a2d0859D961);
1094 
1095         // exclude from paying fees or having max transaction amount
1096         excludeFromFees(owner(), true);
1097         excludeFromFees(marketingWallet, true);
1098         excludeFromFees(address(this), true);
1099         excludeFromFees(address(0xdead), true);
1100 
1101         excludeFromMaxTransaction(owner(), true);
1102         excludeFromMaxTransaction(marketingWallet, true);
1103         excludeFromMaxTransaction(address(this), true);
1104         excludeFromMaxTransaction(address(0xdead), true);
1105 
1106         /*
1107             _mint is an internal function in ERC20.sol that is only called here,
1108             and CANNOT be called ever again
1109         */
1110         _mint(msg.sender, totalSupply);
1111     }
1112 
1113     receive() external payable {}
1114 
1115     // once enabled, can never be turned off
1116     function enableTrading() external onlyOwner {
1117         tradingActive = true;
1118         swapEnabled = true;
1119     }
1120 
1121     // remove limits after token is stable
1122     function removeLimits() external onlyOwner returns (bool) {
1123         limitsInEffect = false;
1124         return true;
1125     }
1126 
1127     // disable Transfer delay - cannot be reenabled
1128     function disableTransferDelay() external onlyOwner returns (bool) {
1129         transferDelayEnabled = false;
1130         return true;
1131     }
1132 
1133     // change the minimum amount of tokens to sell from fees
1134     function updateSwapTokensAtAmount(uint256 newAmount)
1135         external
1136         onlyOwner
1137         returns (bool)
1138     {
1139         require(
1140             newAmount >= (totalSupply() * 1) / 100000,
1141             "Swap amount cannot be lower than 0.001% total supply."
1142         );
1143         require(
1144             newAmount <= (totalSupply() * 5) / 1000,
1145             "Swap amount cannot be higher than 0.5% total supply."
1146         );
1147         swapTokensAtAmount = newAmount;
1148         return true;
1149     }
1150 
1151     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1152         require(
1153             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1154             "Cannot set maxTransactionAmount lower than 0.1%"
1155         );
1156         maxTransactionAmount = newNum * (10**18);
1157     }
1158 
1159     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1160         require(
1161             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1162             "Cannot set maxWallet lower than 0.5%"
1163         );
1164         maxWallet = newNum * (10**18);
1165     }
1166 
1167     function excludeFromMaxTransaction(address updAds, bool isEx)
1168         public
1169         onlyOwner
1170     {
1171         _isExcludedMaxTransactionAmount[updAds] = isEx;
1172     }
1173 
1174     // only use to disable contract sales if absolutely necessary (emergency use only)
1175     function updateSwapEnabled(bool enabled) external onlyOwner {
1176         swapEnabled = enabled;
1177     }
1178 
1179     function updateBuyFees(
1180         uint256 _marketingFee,
1181         uint256 _liquidityFee,
1182         uint256 _treasuryFee
1183     ) external onlyOwner {
1184         buyMarketingFee = _marketingFee;
1185         buyLiquidityFee = _liquidityFee;
1186         buyTreasuryFee = _treasuryFee;
1187         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyTreasuryFee;
1188         require(buyTotalFees <= 30, "Must keep fees at 30% or less");
1189     }
1190 
1191     function updateSellFees(
1192         uint256 _marketingFee,
1193         uint256 _liquidityFee,
1194         uint256 _treasuryFee
1195     ) external onlyOwner {
1196         sellMarketingFee = _marketingFee;
1197         sellLiquidityFee = _liquidityFee;
1198         sellTreasuryFee = _treasuryFee;
1199         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellTreasuryFee;
1200         require(sellTotalFees <= 30, "Must keep fees at 30% or less");
1201     }
1202 
1203     function excludeFromFees(address account, bool excluded) public onlyOwner {
1204         _isExcludedFromFees[account] = excluded;
1205         emit ExcludeFromFees(account, excluded);
1206     }
1207 
1208     function setAutomatedMarketMakerPair(address pair, bool value)
1209         public
1210         onlyOwner
1211     {
1212         require(
1213             pair != uniswapV2Pair,
1214             "The pair cannot be removed from automatedMarketMakerPairs"
1215         );
1216 
1217         _setAutomatedMarketMakerPair(pair, value);
1218     }
1219 
1220     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1221         automatedMarketMakerPairs[pair] = value;
1222 
1223         emit SetAutomatedMarketMakerPair(pair, value);
1224     }
1225 
1226     function updateTreasuryWallet(address payable newWallet) external onlyOwner {
1227         emit treasuryWalletUpdated(newWallet, treasuryWallet);
1228         treasuryWallet = newWallet;
1229     }
1230 
1231     function updateMarketingWallet(address payable newMarketingWallet) external onlyOwner {
1232         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1233         marketingWallet = newMarketingWallet;
1234     }
1235 
1236     function isExcludedFromFees(address account) public view returns (bool) {
1237         return _isExcludedFromFees[account];
1238     }
1239 
1240     function _transfer(
1241         address from,
1242         address to,
1243         uint256 amount
1244     ) internal override {
1245         require(from != address(0), "ERC20: transfer from the zero address");
1246         require(to != address(0), "ERC20: transfer to the zero address");
1247 
1248         if (amount == 0) {
1249             super._transfer(from, to, 0);
1250             return;
1251         }
1252 
1253         if (limitsInEffect) {
1254             if (
1255                 from != owner() &&
1256                 to != owner() &&
1257                 to != address(0) &&
1258                 to != address(0xdead) &&
1259                 !swapping
1260             ) {
1261                 if (!tradingActive) {
1262                     require(
1263                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1264                         "Trading is not active."
1265                     );
1266                 }
1267 
1268                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1269                 if (transferDelayEnabled) {
1270                     if (
1271                         to != owner() &&
1272                         to != address(uniswapV2Router) &&
1273                         to != address(uniswapV2Pair)
1274                     ) {
1275                         require(
1276                             _holderLastTransferTimestamp[tx.origin] <
1277                                 block.number,
1278                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1279                         );
1280                         _holderLastTransferTimestamp[tx.origin] = block.number;
1281                     }
1282                 }
1283 
1284                 // buy
1285                 if (
1286                     automatedMarketMakerPairs[from] &&
1287                     !_isExcludedMaxTransactionAmount[to]
1288                 ) {
1289                     require(
1290                         amount <= maxTransactionAmount,
1291                         "Buy transfer amount exceeds the maxTransactionAmount."
1292                     );
1293                     require(
1294                         amount + balanceOf(to) <= maxWallet,
1295                         "Max wallet exceeded"
1296                     );
1297                 }
1298                 // sell
1299                 else if (
1300                     automatedMarketMakerPairs[to] &&
1301                     !_isExcludedMaxTransactionAmount[from]
1302                 ) {
1303                     require(
1304                         amount <= maxTransactionAmount,
1305                         "Sell transfer amount exceeds the maxTransactionAmount."
1306                     );
1307                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1308                     require(
1309                         amount + balanceOf(to) <= maxWallet,
1310                         "Max wallet exceeded"
1311                     );
1312                 }
1313             }
1314         }
1315 
1316         uint256 contractTokenBalance = balanceOf(address(this));
1317 
1318         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1319 
1320         if (
1321             canSwap &&
1322             swapEnabled &&
1323             !swapping &&
1324             !automatedMarketMakerPairs[from] &&
1325             automatedMarketMakerPairs[to] &&
1326             !_isExcludedFromFees[from] &&
1327             !_isExcludedFromFees[to]
1328         ) {
1329             swapping = true;
1330 
1331             swapBack(amount);
1332 
1333             swapping = false;
1334         }
1335 
1336         bool takeFee = !swapping;
1337 
1338         // if any account belongs to _isExcludedFromFee account then remove the fee
1339         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1340             takeFee = false;
1341         }
1342 
1343         uint256 fees = 0;
1344         // only take fees on buys/sells, do not take on wallet transfers
1345         if (takeFee) {
1346             // on sell
1347             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1348                 fees = amount.mul(sellTotalFees).div(100);
1349                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1350                 tokensForTreasury += (fees * sellTreasuryFee) / sellTotalFees;
1351                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1352             }
1353             // on buy
1354             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1355                 fees = amount.mul(buyTotalFees).div(100);
1356                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1357                 tokensForTreasury += (fees * buyTreasuryFee) / buyTotalFees;
1358                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1359             }
1360 
1361             if (fees > 0) {
1362                 super._transfer(from, address(this), fees);
1363             }
1364 
1365             amount -= fees;
1366         }
1367 
1368         super._transfer(from, to, amount);
1369     }
1370 
1371     function swapTokensForEth(uint256 tokenAmount) private {
1372         // generate the uniswap pair path of token -> weth
1373         address[] memory path = new address[](2);
1374         path[0] = address(this);
1375         path[1] = uniswapV2Router.WETH();
1376 
1377         _approve(address(this), address(uniswapV2Router), tokenAmount);
1378 
1379         // make the swap
1380         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1381             tokenAmount,
1382             0, // accept any amount of ETH
1383             path,
1384             address(this),
1385             block.timestamp
1386         );
1387     }
1388 
1389     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1390         // approve token transfer to cover all possible scenarios
1391         _approve(address(this), address(uniswapV2Router), tokenAmount);
1392 
1393         // add the liquidity
1394         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1395             address(this),
1396             tokenAmount,
1397             0, // slippage is unavoidable
1398             0, // slippage is unavoidable
1399             deadAddress,
1400             block.timestamp
1401         );
1402     }
1403 
1404     function transferToMarketing(uint256 amount) private {
1405         marketingWallet.transfer(amount);
1406     }
1407 
1408     function transferToTreasury(uint256 amount) private {
1409         treasuryWallet.transfer(amount);
1410     }
1411 
1412     function swapBack(uint256 amount) private {
1413         uint256 contractBalance = balanceOf(address(this));
1414 
1415         if (contractBalance > amount * 2) {
1416             contractBalance = amount * 2;
1417         }
1418         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForTreasury;
1419 
1420         if (contractBalance == 0 || totalTokensToSwap == 0) {
1421             return;
1422         }
1423 
1424         if (contractBalance > swapTokensAtAmount * 10) {
1425             contractBalance = swapTokensAtAmount * 10;
1426         }
1427 
1428         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1429         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1430 
1431         uint256 initialETHBalance = address(this).balance;
1432 
1433         swapTokensForEth(amountToSwapForETH);
1434 
1435         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1436         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1437         uint256 ethForTreasury = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
1438         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForTreasury;
1439 
1440         tokensForLiquidity = 0;
1441         tokensForMarketing = 0;
1442         tokensForTreasury = 0;
1443 
1444         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1445             addLiquidity(liquidityTokens, ethForLiquidity);
1446             emit SwapAndLiquify(
1447                 amountToSwapForETH,
1448                 ethForLiquidity,
1449                 tokensForLiquidity
1450             );
1451         }
1452 
1453         transferToTreasury(ethForTreasury);
1454         transferToMarketing(address(this).balance);
1455     }
1456 }