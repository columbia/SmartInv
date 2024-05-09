1 /**
2 *  ____/\_____________.___  ________  _____________________________ 
3 *  /   / /_/\__    ___/|   |/  _____/ /  _____/\_   _____/\______   \
4 *  \__/ / \   |    |   |   /   \  ___/   \  ___ |    __)_  |       _/
5 *  / / /   \  |    |   |   \    \_\  \    \_\  \|        \ |    |   \
6 * /_/ /__  /  |____|   |___|\______  /\______  /_______  / |____|_  /
7 *   \/   \/                        \/        \/        \/         \/ 
8 
9 
10 
11 
12 
13 *         __  _-==-=_,-.
14 *        /--`' \_@-@.--<
15 *        `--'\ \   <___/.      The wonderful thing about Tiggers,
16 *            \ \\   " /        is Tiggers are wonderful things.
17 *              >=\\_/`<        Their tops are made out of rubber,
18 *  ____       /= |  \_/        their bottoms are made out of springs.
19 *_'    `\   _/=== \__/         They're bouncy, trouncy, flouncy, pouncy,
20 *`___/ //\./=/~\====\          Fun, fun, fun, fun, fun.
21 *    \   // /   | ===:         But the most wonderful thing about Tiggers is,
22 *     |  ._/_,__|_ ==:        __  I'm the only one.
23 *      \/    \\ \\`--|       / \\
24 *       |    _     \\:      /==:-\
25 *       `.__' `-____/       |--|==:
26 *          \    \ ===\      :==:`-'
27 *          _>    \ ===\    /==/
28 *         /==\   |  ===\__/--/
29 *        <=== \  /  ====\ \\/
30 *        _`--  \/  === \/--'
31 *       |       \ ==== |
32 *        -`------/`--' /
33 *                \___-'
34 */
35 /*
36 
37 TELEGRAM: https://t.me/tiggerportal
38 */
39 // SPDX-License-Identifier: MIT
40 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
41 pragma experimental ABIEncoderV2;
42 
43 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
44 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
45 
46 /* pragma solidity ^0.8.0; */
47 
48 /**
49  * @dev Provides information about the current execution context, including the
50  * sender of the transaction and its data. While these are generally available
51  * via msg.sender and msg.data, they should not be accessed in such a direct
52  * manner, since when dealing with meta-transactions the account sending and
53  * paying for execution may not be the actual sender (as far as an application
54  * is concerned).
55  *
56  * This contract is only required for intermediate, library-like contracts.
57  */
58 abstract contract Context {
59     function _msgSender() internal view virtual returns (address) {
60         return msg.sender;
61     }
62 
63     function _msgData() internal view virtual returns (bytes calldata) {
64         return msg.data;
65     }
66 }
67 
68 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
69 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
70 
71 /* pragma solidity ^0.8.0; */
72 
73 /* import "../utils/Context.sol"; */
74 
75 /**
76  * @dev Contract module which provides a basic access control mechanism, where
77  * there is an account (an owner) that can be granted exclusive access to
78  * specific functions.
79  *
80  * By default, the owner account will be the one that deploys the contract. This
81  * can later be changed with {transferOwnership}.
82  *
83  * This module is used through inheritance. It will make available the modifier
84  * `onlyOwner`, which can be applied to your functions to restrict their use to
85  * the owner.
86  */
87 abstract contract Ownable is Context {
88     address private _owner;
89 
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     /**
93      * @dev Initializes the contract setting the deployer as the initial owner.
94      */
95     constructor() {
96         _transferOwnership(_msgSender());
97     }
98 
99     /**
100      * @dev Returns the address of the current owner.
101      */
102     function owner() public view virtual returns (address) {
103         return _owner;
104     }
105 
106     /**
107      * @dev Throws if called by any account other than the owner.
108      */
109     modifier onlyOwner() {
110         require(owner() == _msgSender(), "Ownable: caller is not the owner");
111         _;
112     }
113 
114     /**
115      * @dev Leaves the contract without owner. It will not be possible to call
116      * `onlyOwner` functions anymore. Can only be called by the current owner.
117      *
118      * NOTE: Renouncing ownership will leave the contract without an owner,
119      * thereby removing any functionality that is only available to the owner.
120      */
121     function renounceOwnership() public virtual onlyOwner {
122         _transferOwnership(address(0));
123     }
124 
125     /**
126      * @dev Transfers ownership of the contract to a new account (`newOwner`).
127      * Can only be called by the current owner.
128      */
129     function transferOwnership(address newOwner) public virtual onlyOwner {
130         require(newOwner != address(0), "Ownable: new owner is the zero address");
131         _transferOwnership(newOwner);
132     }
133 
134     /**
135      * @dev Transfers ownership of the contract to a new account (`newOwner`).
136      * Internal function without access restriction.
137      */
138     function _transferOwnership(address newOwner) internal virtual {
139         address oldOwner = _owner;
140         _owner = newOwner;
141         emit OwnershipTransferred(oldOwner, newOwner);
142     }
143 }
144 
145 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
146 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
147 
148 /* pragma solidity ^0.8.0; */
149 
150 /**
151  * @dev Interface of the ERC20 standard as defined in the EIP.
152  */
153 interface IERC20 {
154     /**
155      * @dev Returns the amount of tokens in existence.
156      */
157     function totalSupply() external view returns (uint256);
158 
159     /**
160      * @dev Returns the amount of tokens owned by `account`.
161      */
162     function balanceOf(address account) external view returns (uint256);
163 
164     /**
165      * @dev Moves `amount` tokens from the caller's account to `recipient`.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transfer(address recipient, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Returns the remaining number of tokens that `spender` will be
175      * allowed to spend on behalf of `owner` through {transferFrom}. This is
176      * zero by default.
177      *
178      * This value changes when {approve} or {transferFrom} are called.
179      */
180     function allowance(address owner, address spender) external view returns (uint256);
181 
182     /**
183      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * IMPORTANT: Beware that changing an allowance with this method brings the risk
188      * that someone may use both the old and the new allowance by unfortunate
189      * transaction ordering. One possible solution to mitigate this race
190      * condition is to first reduce the spender's allowance to 0 and set the
191      * desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      *
194      * Emits an {Approval} event.
195      */
196     function approve(address spender, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Moves `amount` tokens from `sender` to `recipient` using the
200      * allowance mechanism. `amount` is then deducted from the caller's
201      * allowance.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address sender,
209         address recipient,
210         uint256 amount
211     ) external returns (bool);
212 
213     /**
214      * @dev Emitted when `value` tokens are moved from one account (`from`) to
215      * another (`to`).
216      *
217      * Note that `value` may be zero.
218      */
219     event Transfer(address indexed from, address indexed to, uint256 value);
220 
221     /**
222      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
223      * a call to {approve}. `value` is the new allowance.
224      */
225     event Approval(address indexed owner, address indexed spender, uint256 value);
226 }
227 
228 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
229 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
230 
231 /* pragma solidity ^0.8.0; */
232 
233 /* import "../IERC20.sol"; */
234 
235 /**
236  * @dev Interface for the optional metadata functions from the ERC20 standard.
237  *
238  * _Available since v4.1._
239  */
240 interface IERC20Metadata is IERC20 {
241     /**
242      * @dev Returns the name of the token.
243      */
244     function name() external view returns (string memory);
245 
246     /**
247      * @dev Returns the symbol of the token.
248      */
249     function symbol() external view returns (string memory);
250 
251     /**
252      * @dev Returns the decimals places of the token.
253      */
254     function decimals() external view returns (uint8);
255 }
256 
257 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
258 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
259 
260 /* pragma solidity ^0.8.0; */
261 
262 /* import "./IERC20.sol"; */
263 /* import "./extensions/IERC20Metadata.sol"; */
264 /* import "../../utils/Context.sol"; */
265 
266 /**
267  * @dev Implementation of the {IERC20} interface.
268  *
269  * This implementation is agnostic to the way tokens are created. This means
270  * that a supply mechanism has to be added in a derived contract using {_mint}.
271  * For a generic mechanism see {ERC20PresetMinterPauser}.
272  *
273  * TIP: For a detailed writeup see our guide
274  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
275  * to implement supply mechanisms].
276  *
277  * We have followed general OpenZeppelin Contracts guidelines: functions revert
278  * instead returning `false` on failure. This behavior is nonetheless
279  * conventional and does not conflict with the expectations of ERC20
280  * applications.
281  *
282  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
283  * This allows applications to reconstruct the allowance for all accounts just
284  * by listening to said events. Other implementations of the EIP may not emit
285  * these events, as it isn't required by the specification.
286  *
287  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
288  * functions have been added to mitigate the well-known issues around setting
289  * allowances. See {IERC20-approve}.
290  */
291 contract ERC20 is Context, IERC20, IERC20Metadata {
292     mapping(address => uint256) private _balances;
293 
294     mapping(address => mapping(address => uint256)) private _allowances;
295 
296     uint256 private _totalSupply;
297 
298     string private _name;
299     string private _symbol;
300 
301     /**
302      * @dev Sets the values for {name} and {symbol}.
303      *
304      * The default value of {decimals} is 18. To select a different value for
305      * {decimals} you should overload it.
306      *
307      * All two of these values are immutable: they can only be set once during
308      * construction.
309      */
310     constructor(string memory name_, string memory symbol_) {
311         _name = name_;
312         _symbol = symbol_;
313     }
314 
315     /**
316      * @dev Returns the name of the token.
317      */
318     function name() public view virtual override returns (string memory) {
319         return _name;
320     }
321 
322     /**
323      * @dev Returns the symbol of the token, usually a shorter version of the
324      * name.
325      */
326     function symbol() public view virtual override returns (string memory) {
327         return _symbol;
328     }
329 
330     /**
331      * @dev Returns the number of decimals used to get its user representation.
332      * For example, if `decimals` equals `2`, a balance of `505` tokens should
333      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
334      *
335      * Tokens usually opt for a value of 18, imitating the relationship between
336      * Ether and Wei. This is the value {ERC20} uses, unless this function is
337      * overridden;
338      *
339      * NOTE: This information is only used for _display_ purposes: it in
340      * no way affects any of the arithmetic of the contract, including
341      * {IERC20-balanceOf} and {IERC20-transfer}.
342      */
343     function decimals() public view virtual override returns (uint8) {
344         return 18;
345     }
346 
347     /**
348      * @dev See {IERC20-totalSupply}.
349      */
350     function totalSupply() public view virtual override returns (uint256) {
351         return _totalSupply;
352     }
353 
354     /**
355      * @dev See {IERC20-balanceOf}.
356      */
357     function balanceOf(address account) public view virtual override returns (uint256) {
358         return _balances[account];
359     }
360 
361     /**
362      * @dev See {IERC20-transfer}.
363      *
364      * Requirements:
365      *
366      * - `recipient` cannot be the zero address.
367      * - the caller must have a balance of at least `amount`.
368      */
369     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
370         _transfer(_msgSender(), recipient, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-allowance}.
376      */
377     function allowance(address owner, address spender) public view virtual override returns (uint256) {
378         return _allowances[owner][spender];
379     }
380 
381     /**
382      * @dev See {IERC20-approve}.
383      *
384      * Requirements:
385      *
386      * - `spender` cannot be the zero address.
387      */
388     function approve(address spender, uint256 amount) public virtual override returns (bool) {
389         _approve(_msgSender(), spender, amount);
390         return true;
391     }
392 
393     /**
394      * @dev See {IERC20-transferFrom}.
395      *
396      * Emits an {Approval} event indicating the updated allowance. This is not
397      * required by the EIP. See the note at the beginning of {ERC20}.
398      *
399      * Requirements:
400      *
401      * - `sender` and `recipient` cannot be the zero address.
402      * - `sender` must have a balance of at least `amount`.
403      * - the caller must have allowance for ``sender``'s tokens of at least
404      * `amount`.
405      */
406     function transferFrom(
407         address sender,
408         address recipient,
409         uint256 amount
410     ) public virtual override returns (bool) {
411         _transfer(sender, recipient, amount);
412 
413         uint256 currentAllowance = _allowances[sender][_msgSender()];
414         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
415         unchecked {
416             _approve(sender, _msgSender(), currentAllowance - amount);
417         }
418 
419         return true;
420     }
421 
422     /**
423      * @dev Atomically increases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      */
434     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
435         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
436         return true;
437     }
438 
439     /**
440      * @dev Atomically decreases the allowance granted to `spender` by the caller.
441      *
442      * This is an alternative to {approve} that can be used as a mitigation for
443      * problems described in {IERC20-approve}.
444      *
445      * Emits an {Approval} event indicating the updated allowance.
446      *
447      * Requirements:
448      *
449      * - `spender` cannot be the zero address.
450      * - `spender` must have allowance for the caller of at least
451      * `subtractedValue`.
452      */
453     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
454         uint256 currentAllowance = _allowances[_msgSender()][spender];
455         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
456         unchecked {
457             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
458         }
459 
460         return true;
461     }
462 
463     /**
464      * @dev Moves `amount` of tokens from `sender` to `recipient`.
465      *
466      * This internal function is equivalent to {transfer}, and can be used to
467      * e.g. implement automatic token fees, slashing mechanisms, etc.
468      *
469      * Emits a {Transfer} event.
470      *
471      * Requirements:
472      *
473      * - `sender` cannot be the zero address.
474      * - `recipient` cannot be the zero address.
475      * - `sender` must have a balance of at least `amount`.
476      */
477     function _transfer(
478         address sender,
479         address recipient,
480         uint256 amount
481     ) internal virtual {
482         require(sender != address(0), "ERC20: transfer from the zero address");
483         require(recipient != address(0), "ERC20: transfer to the zero address");
484 
485         _beforeTokenTransfer(sender, recipient, amount);
486 
487         uint256 senderBalance = _balances[sender];
488         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
489         unchecked {
490             _balances[sender] = senderBalance - amount;
491         }
492         _balances[recipient] += amount;
493 
494         emit Transfer(sender, recipient, amount);
495 
496         _afterTokenTransfer(sender, recipient, amount);
497     }
498 
499     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
500      * the total supply.
501      *
502      * Emits a {Transfer} event with `from` set to the zero address.
503      *
504      * Requirements:
505      *
506      * - `account` cannot be the zero address.
507      */
508     function _mint(address account, uint256 amount) internal virtual {
509         require(account != address(0), "ERC20: mint to the zero address");
510 
511         _beforeTokenTransfer(address(0), account, amount);
512 
513         _totalSupply += amount;
514         _balances[account] += amount;
515         emit Transfer(address(0), account, amount);
516 
517         _afterTokenTransfer(address(0), account, amount);
518     }
519 
520     /**
521      * @dev Destroys `amount` tokens from `account`, reducing the
522      * total supply.
523      *
524      * Emits a {Transfer} event with `to` set to the zero address.
525      *
526      * Requirements:
527      *
528      * - `account` cannot be the zero address.
529      * - `account` must have at least `amount` tokens.
530      */
531     function _burn(address account, uint256 amount) internal virtual {
532         require(account != address(0), "ERC20: burn from the zero address");
533 
534         _beforeTokenTransfer(account, address(0), amount);
535 
536         uint256 accountBalance = _balances[account];
537         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
538         unchecked {
539             _balances[account] = accountBalance - amount;
540         }
541         _totalSupply -= amount;
542 
543         emit Transfer(account, address(0), amount);
544 
545         _afterTokenTransfer(account, address(0), amount);
546     }
547 
548     /**
549      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
550      *
551      * This internal function is equivalent to `approve`, and can be used to
552      * e.g. set automatic allowances for certain subsystems, etc.
553      *
554      * Emits an {Approval} event.
555      *
556      * Requirements:
557      *
558      * - `owner` cannot be the zero address.
559      * - `spender` cannot be the zero address.
560      */
561     function _approve(
562         address owner,
563         address spender,
564         uint256 amount
565     ) internal virtual {
566         require(owner != address(0), "ERC20: approve from the zero address");
567         require(spender != address(0), "ERC20: approve to the zero address");
568 
569         _allowances[owner][spender] = amount;
570         emit Approval(owner, spender, amount);
571     }
572 
573     /**
574      * @dev Hook that is called before any transfer of tokens. This includes
575      * minting and burning.
576      *
577      * Calling conditions:
578      *
579      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
580      * will be transferred to `to`.
581      * - when `from` is zero, `amount` tokens will be minted for `to`.
582      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
583      * - `from` and `to` are never both zero.
584      *
585      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
586      */
587     function _beforeTokenTransfer(
588         address from,
589         address to,
590         uint256 amount
591     ) internal virtual {}
592 
593     /**
594      * @dev Hook that is called after any transfer of tokens. This includes
595      * minting and burning.
596      *
597      * Calling conditions:
598      *
599      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
600      * has been transferred to `to`.
601      * - when `from` is zero, `amount` tokens have been minted for `to`.
602      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
603      * - `from` and `to` are never both zero.
604      *
605      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
606      */
607     function _afterTokenTransfer(
608         address from,
609         address to,
610         uint256 amount
611     ) internal virtual {}
612 }
613 
614 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
615 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
616 
617 /* pragma solidity ^0.8.0; */
618 
619 // CAUTION
620 // This version of SafeMath should only be used with Solidity 0.8 or later,
621 // because it relies on the compiler's built in overflow checks.
622 
623 /**
624  * @dev Wrappers over Solidity's arithmetic operations.
625  *
626  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
627  * now has built in overflow checking.
628  */
629 library SafeMath {
630     /**
631      * @dev Returns the addition of two unsigned integers, with an overflow flag.
632      *
633      * _Available since v3.4._
634      */
635     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
636         unchecked {
637             uint256 c = a + b;
638             if (c < a) return (false, 0);
639             return (true, c);
640         }
641     }
642 
643     /**
644      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
645      *
646      * _Available since v3.4._
647      */
648     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
649         unchecked {
650             if (b > a) return (false, 0);
651             return (true, a - b);
652         }
653     }
654 
655     /**
656      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
657      *
658      * _Available since v3.4._
659      */
660     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
661         unchecked {
662             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
663             // benefit is lost if 'b' is also tested.
664             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
665             if (a == 0) return (true, 0);
666             uint256 c = a * b;
667             if (c / a != b) return (false, 0);
668             return (true, c);
669         }
670     }
671 
672     /**
673      * @dev Returns the division of two unsigned integers, with a division by zero flag.
674      *
675      * _Available since v3.4._
676      */
677     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
678         unchecked {
679             if (b == 0) return (false, 0);
680             return (true, a / b);
681         }
682     }
683 
684     /**
685      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
686      *
687      * _Available since v3.4._
688      */
689     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
690         unchecked {
691             if (b == 0) return (false, 0);
692             return (true, a % b);
693         }
694     }
695 
696     /**
697      * @dev Returns the addition of two unsigned integers, reverting on
698      * overflow.
699      *
700      * Counterpart to Solidity's `+` operator.
701      *
702      * Requirements:
703      *
704      * - Addition cannot overflow.
705      */
706     function add(uint256 a, uint256 b) internal pure returns (uint256) {
707         return a + b;
708     }
709 
710     /**
711      * @dev Returns the subtraction of two unsigned integers, reverting on
712      * overflow (when the result is negative).
713      *
714      * Counterpart to Solidity's `-` operator.
715      *
716      * Requirements:
717      *
718      * - Subtraction cannot overflow.
719      */
720     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
721         return a - b;
722     }
723 
724     /**
725      * @dev Returns the multiplication of two unsigned integers, reverting on
726      * overflow.
727      *
728      * Counterpart to Solidity's `*` operator.
729      *
730      * Requirements:
731      *
732      * - Multiplication cannot overflow.
733      */
734     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
735         return a * b;
736     }
737 
738     /**
739      * @dev Returns the integer division of two unsigned integers, reverting on
740      * division by zero. The result is rounded towards zero.
741      *
742      * Counterpart to Solidity's `/` operator.
743      *
744      * Requirements:
745      *
746      * - The divisor cannot be zero.
747      */
748     function div(uint256 a, uint256 b) internal pure returns (uint256) {
749         return a / b;
750     }
751 
752     /**
753      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
754      * reverting when dividing by zero.
755      *
756      * Counterpart to Solidity's `%` operator. This function uses a `revert`
757      * opcode (which leaves remaining gas untouched) while Solidity uses an
758      * invalid opcode to revert (consuming all remaining gas).
759      *
760      * Requirements:
761      *
762      * - The divisor cannot be zero.
763      */
764     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
765         return a % b;
766     }
767 
768     /**
769      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
770      * overflow (when the result is negative).
771      *
772      * CAUTION: This function is deprecated because it requires allocating memory for the error
773      * message unnecessarily. For custom revert reasons use {trySub}.
774      *
775      * Counterpart to Solidity's `-` operator.
776      *
777      * Requirements:
778      *
779      * - Subtraction cannot overflow.
780      */
781     function sub(
782         uint256 a,
783         uint256 b,
784         string memory errorMessage
785     ) internal pure returns (uint256) {
786         unchecked {
787             require(b <= a, errorMessage);
788             return a - b;
789         }
790     }
791 
792     /**
793      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
794      * division by zero. The result is rounded towards zero.
795      *
796      * Counterpart to Solidity's `/` operator. Note: this function uses a
797      * `revert` opcode (which leaves remaining gas untouched) while Solidity
798      * uses an invalid opcode to revert (consuming all remaining gas).
799      *
800      * Requirements:
801      *
802      * - The divisor cannot be zero.
803      */
804     function div(
805         uint256 a,
806         uint256 b,
807         string memory errorMessage
808     ) internal pure returns (uint256) {
809         unchecked {
810             require(b > 0, errorMessage);
811             return a / b;
812         }
813     }
814 
815     /**
816      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
817      * reverting with custom message when dividing by zero.
818      *
819      * CAUTION: This function is deprecated because it requires allocating memory for the error
820      * message unnecessarily. For custom revert reasons use {tryMod}.
821      *
822      * Counterpart to Solidity's `%` operator. This function uses a `revert`
823      * opcode (which leaves remaining gas untouched) while Solidity uses an
824      * invalid opcode to revert (consuming all remaining gas).
825      *
826      * Requirements:
827      *
828      * - The divisor cannot be zero.
829      */
830     function mod(
831         uint256 a,
832         uint256 b,
833         string memory errorMessage
834     ) internal pure returns (uint256) {
835         unchecked {
836             require(b > 0, errorMessage);
837             return a % b;
838         }
839     }
840 }
841 
842 ////// src/IUniswapV2Factory.sol
843 /* pragma solidity 0.8.10; */
844 /* pragma experimental ABIEncoderV2; */
845 
846 interface IUniswapV2Factory {
847     event PairCreated(
848         address indexed token0,
849         address indexed token1,
850         address pair,
851         uint256
852     );
853 
854     function feeTo() external view returns (address);
855 
856     function feeToSetter() external view returns (address);
857 
858     function getPair(address tokenA, address tokenB)
859         external
860         view
861         returns (address pair);
862 
863     function allPairs(uint256) external view returns (address pair);
864 
865     function allPairsLength() external view returns (uint256);
866 
867     function createPair(address tokenA, address tokenB)
868         external
869         returns (address pair);
870 
871     function setFeeTo(address) external;
872 
873     function setFeeToSetter(address) external;
874 }
875 
876 ////// src/IUniswapV2Pair.sol
877 /* pragma solidity 0.8.10; */
878 /* pragma experimental ABIEncoderV2; */
879 
880 interface IUniswapV2Pair {
881     event Approval(
882         address indexed owner,
883         address indexed spender,
884         uint256 value
885     );
886     event Transfer(address indexed from, address indexed to, uint256 value);
887 
888     function name() external pure returns (string memory);
889 
890     function symbol() external pure returns (string memory);
891 
892     function decimals() external pure returns (uint8);
893 
894     function totalSupply() external view returns (uint256);
895 
896     function balanceOf(address owner) external view returns (uint256);
897 
898     function allowance(address owner, address spender)
899         external
900         view
901         returns (uint256);
902 
903     function approve(address spender, uint256 value) external returns (bool);
904 
905     function transfer(address to, uint256 value) external returns (bool);
906 
907     function transferFrom(
908         address from,
909         address to,
910         uint256 value
911     ) external returns (bool);
912 
913     function DOMAIN_SEPARATOR() external view returns (bytes32);
914 
915     function PERMIT_TYPEHASH() external pure returns (bytes32);
916 
917     function nonces(address owner) external view returns (uint256);
918 
919     function permit(
920         address owner,
921         address spender,
922         uint256 value,
923         uint256 deadline,
924         uint8 v,
925         bytes32 r,
926         bytes32 s
927     ) external;
928 
929     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
930     event Burn(
931         address indexed sender,
932         uint256 amount0,
933         uint256 amount1,
934         address indexed to
935     );
936     event Swap(
937         address indexed sender,
938         uint256 amount0In,
939         uint256 amount1In,
940         uint256 amount0Out,
941         uint256 amount1Out,
942         address indexed to
943     );
944     event Sync(uint112 reserve0, uint112 reserve1);
945 
946     function MINIMUM_LIQUIDITY() external pure returns (uint256);
947 
948     function factory() external view returns (address);
949 
950     function token0() external view returns (address);
951 
952     function token1() external view returns (address);
953 
954     function getReserves()
955         external
956         view
957         returns (
958             uint112 reserve0,
959             uint112 reserve1,
960             uint32 blockTimestampLast
961         );
962 
963     function price0CumulativeLast() external view returns (uint256);
964 
965     function price1CumulativeLast() external view returns (uint256);
966 
967     function kLast() external view returns (uint256);
968 
969     function mint(address to) external returns (uint256 liquidity);
970 
971     function burn(address to)
972         external
973         returns (uint256 amount0, uint256 amount1);
974 
975     function swap(
976         uint256 amount0Out,
977         uint256 amount1Out,
978         address to,
979         bytes calldata data
980     ) external;
981 
982     function skim(address to) external;
983 
984     function sync() external;
985 
986     function initialize(address, address) external;
987 }
988 
989 ////// src/IUniswapV2Router02.sol
990 /* pragma solidity 0.8.10; */
991 /* pragma experimental ABIEncoderV2; */
992 
993 interface IUniswapV2Router02 {
994     function factory() external pure returns (address);
995 
996     function WETH() external pure returns (address);
997 
998     function addLiquidity(
999         address tokenA,
1000         address tokenB,
1001         uint256 amountADesired,
1002         uint256 amountBDesired,
1003         uint256 amountAMin,
1004         uint256 amountBMin,
1005         address to,
1006         uint256 deadline
1007     )
1008         external
1009         returns (
1010             uint256 amountA,
1011             uint256 amountB,
1012             uint256 liquidity
1013         );
1014 
1015     function addLiquidityETH(
1016         address token,
1017         uint256 amountTokenDesired,
1018         uint256 amountTokenMin,
1019         uint256 amountETHMin,
1020         address to,
1021         uint256 deadline
1022     )
1023         external
1024         payable
1025         returns (
1026             uint256 amountToken,
1027             uint256 amountETH,
1028             uint256 liquidity
1029         );
1030 
1031     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1032         uint256 amountIn,
1033         uint256 amountOutMin,
1034         address[] calldata path,
1035         address to,
1036         uint256 deadline
1037     ) external;
1038 
1039     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1040         uint256 amountOutMin,
1041         address[] calldata path,
1042         address to,
1043         uint256 deadline
1044     ) external payable;
1045 
1046     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1047         uint256 amountIn,
1048         uint256 amountOutMin,
1049         address[] calldata path,
1050         address to,
1051         uint256 deadline
1052     ) external;
1053 }
1054 
1055 /* pragma solidity >=0.8.10; */
1056 
1057 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1058 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1059 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1060 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1061 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1062 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1063 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1064 
1065 contract TIGGER is ERC20, Ownable {
1066     using SafeMath for uint256;
1067 
1068     IUniswapV2Router02 public immutable uniswapV2Router;
1069     address public immutable uniswapV2Pair;
1070     address public constant deadAddress = address(0xdead);
1071 
1072     bool private swapping;
1073 
1074     address public marketingWallet;
1075     address public devWallet;
1076 
1077     uint256 public maxTransactionAmount;
1078     uint256 public swapTokensAtAmount;
1079     uint256 public maxWallet;
1080 
1081     uint256 public percentForLPBurn = 25; // 25 = .25%
1082     bool public lpBurnEnabled = false;
1083     uint256 public lpBurnFrequency = 3600 seconds;
1084     uint256 public lastLpBurnTime;
1085 
1086     uint256 public manualBurnFrequency = 30 minutes;
1087     uint256 public lastManualLpBurnTime;
1088 
1089     bool public limitsInEffect = true;
1090     bool public tradingActive = false;
1091     bool public swapEnabled = false;
1092 
1093     // Anti-bot and anti-whale mappings and variables
1094     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1095     bool public transferDelayEnabled = true;
1096 
1097     uint256 public buyTotalFees;
1098     uint256 public buyMarketingFee;
1099     uint256 public buyLiquidityFee;
1100     uint256 public buyDevFee;
1101 
1102     uint256 public sellTotalFees;
1103     uint256 public sellMarketingFee;
1104     uint256 public sellLiquidityFee;
1105     uint256 public sellDevFee;
1106 
1107     uint256 public tokensForMarketing;
1108     uint256 public tokensForLiquidity;
1109     uint256 public tokensForDev;
1110 
1111     /******************/
1112 
1113     // exlcude from fees and max transaction amount
1114     mapping(address => bool) private _isExcludedFromFees;
1115     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1116 
1117     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1118     // could be subject to a maximum transfer amount
1119     mapping(address => bool) public automatedMarketMakerPairs;
1120 
1121     event UpdateUniswapV2Router(
1122         address indexed newAddress,
1123         address indexed oldAddress
1124     );
1125 
1126     event ExcludeFromFees(address indexed account, bool isExcluded);
1127 
1128     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1129 
1130     event marketingWalletUpdated(
1131         address indexed newWallet,
1132         address indexed oldWallet
1133     );
1134 
1135     event devWalletUpdated(
1136         address indexed newWallet,
1137         address indexed oldWallet
1138     );
1139 
1140     event SwapAndLiquify(
1141         uint256 tokensSwapped,
1142         uint256 ethReceived,
1143         uint256 tokensIntoLiquidity
1144     );
1145 
1146     event AutoNukeLP();
1147 
1148     event ManualNukeLP();
1149 
1150     constructor() ERC20("TIGGER", "TIGGER") {
1151         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1152             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1153         );
1154 
1155         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1156         uniswapV2Router = _uniswapV2Router;
1157 
1158         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1159             .createPair(address(this), _uniswapV2Router.WETH());
1160         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1161         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1162 
1163         uint256 _buyMarketingFee = 20;
1164         uint256 _buyLiquidityFee = 0;
1165         uint256 _buyDevFee = 0;
1166 
1167         uint256 _sellMarketingFee = 45;
1168         uint256 _sellLiquidityFee = 0;
1169         uint256 _sellDevFee = 0;
1170 
1171         uint256 totalSupply = 100_000_000 * 1e18;
1172 
1173         maxTransactionAmount = 2_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1174         maxWallet = 2_000_000 * 1e18; // 2% from total supply maxWallet
1175         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1176 
1177         buyMarketingFee = _buyMarketingFee;
1178         buyLiquidityFee = _buyLiquidityFee;
1179         buyDevFee = _buyDevFee;
1180         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1181 
1182         sellMarketingFee = _sellMarketingFee;
1183         sellLiquidityFee = _sellLiquidityFee;
1184         sellDevFee = _sellDevFee;
1185         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1186 
1187         marketingWallet = address(0xA5a321A834317FB6d0eE5B8568Fc3Bb295e3cc84); // set as marketing wallet
1188         devWallet = address(0xA5a321A834317FB6d0eE5B8568Fc3Bb295e3cc84); // set as dev wallet
1189 
1190         // exclude from paying fees or having max transaction amount
1191         excludeFromFees(owner(), true);
1192         excludeFromFees(address(this), true);
1193         excludeFromFees(address(0xdead), true);
1194 
1195         excludeFromMaxTransaction(owner(), true);
1196         excludeFromMaxTransaction(address(this), true);
1197         excludeFromMaxTransaction(address(0xdead), true);
1198 
1199         /*
1200             _mint is an internal function in ERC20.sol that is only called here,
1201             and CANNOT be called ever again
1202         */
1203         _mint(msg.sender, totalSupply);
1204     }
1205 
1206     receive() external payable {}
1207 
1208     // once enabled, can never be turned off
1209     function enableTrading() external onlyOwner {
1210         tradingActive = true;
1211         swapEnabled = true;
1212         lastLpBurnTime = block.timestamp;
1213     }
1214 
1215     // remove limits after token is stable
1216     function removeLimits() external onlyOwner returns (bool) {
1217         limitsInEffect = false;
1218         return true;
1219     }
1220 
1221     // disable Transfer delay - cannot be reenabled
1222     function disableTransferDelay() external onlyOwner returns (bool) {
1223         transferDelayEnabled = false;
1224         return true;
1225     }
1226 
1227     // change the minimum amount of tokens to sell from fees
1228     function updateSwapTokensAtAmount(uint256 newAmount)
1229         external
1230         onlyOwner
1231         returns (bool)
1232     {
1233         require(
1234             newAmount >= (totalSupply() * 1) / 100000,
1235             "Swap amount cannot be lower than 0.001% total supply."
1236         );
1237         require(
1238             newAmount <= (totalSupply() * 5) / 1000,
1239             "Swap amount cannot be higher than 0.5% total supply."
1240         );
1241         swapTokensAtAmount = newAmount;
1242         return true;
1243     }
1244 
1245     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1246         require(
1247             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1248             "Cannot set maxTransactionAmount lower than 0.1%"
1249         );
1250         maxTransactionAmount = newNum * (10**18);
1251     }
1252 
1253     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1254         require(
1255             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1256             "Cannot set maxWallet lower than 0.5%"
1257         );
1258         maxWallet = newNum * (10**18);
1259     }
1260 
1261     function excludeFromMaxTransaction(address updAds, bool isEx)
1262         public
1263         onlyOwner
1264     {
1265         _isExcludedMaxTransactionAmount[updAds] = isEx;
1266     }
1267 
1268     // only use to disable contract sales if absolutely necessary (emergency use only)
1269     function updateSwapEnabled(bool enabled) external onlyOwner {
1270         swapEnabled = enabled;
1271     }
1272 
1273     function updateBuyFees(
1274         uint256 _marketingFee,
1275         uint256 _liquidityFee,
1276         uint256 _devFee
1277     ) external onlyOwner {
1278         buyMarketingFee = _marketingFee;
1279         buyLiquidityFee = _liquidityFee;
1280         buyDevFee = _devFee;
1281         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1282         require(buyTotalFees <= 99, "Must keep fees at 11% or less");
1283     }
1284 
1285     function updateSellFees(
1286         uint256 _marketingFee,
1287         uint256 _liquidityFee,
1288         uint256 _devFee
1289     ) external onlyOwner {
1290         sellMarketingFee = _marketingFee;
1291         sellLiquidityFee = _liquidityFee;
1292         sellDevFee = _devFee;
1293         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1294         require(sellTotalFees <= 99, "Must keep fees at 11% or less");
1295     }
1296 
1297     function excludeFromFees(address account, bool excluded) public onlyOwner {
1298         _isExcludedFromFees[account] = excluded;
1299         emit ExcludeFromFees(account, excluded);
1300     }
1301 
1302     function setAutomatedMarketMakerPair(address pair, bool value)
1303         public
1304         onlyOwner
1305     {
1306         require(
1307             pair != uniswapV2Pair,
1308             "The pair cannot be removed from automatedMarketMakerPairs"
1309         );
1310 
1311         _setAutomatedMarketMakerPair(pair, value);
1312     }
1313 
1314     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1315         automatedMarketMakerPairs[pair] = value;
1316 
1317         emit SetAutomatedMarketMakerPair(pair, value);
1318     }
1319 
1320     function updateMarketingWallet(address newMarketingWallet)
1321         external
1322         onlyOwner
1323     {
1324         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1325         marketingWallet = newMarketingWallet;
1326     }
1327 
1328     function updateDevWallet(address newWallet) external onlyOwner {
1329         emit devWalletUpdated(newWallet, devWallet);
1330         devWallet = newWallet;
1331     }
1332 
1333     function isExcludedFromFees(address account) public view returns (bool) {
1334         return _isExcludedFromFees[account];
1335     }
1336 
1337     event BoughtEarly(address indexed sniper);
1338 
1339     function _transfer(
1340         address from,
1341         address to,
1342         uint256 amount
1343     ) internal override {
1344         require(from != address(0), "ERC20: transfer from the zero address");
1345         require(to != address(0), "ERC20: transfer to the zero address");
1346 
1347         if (amount == 0) {
1348             super._transfer(from, to, 0);
1349             return;
1350         }
1351 
1352         if (limitsInEffect) {
1353             if (
1354                 from != owner() &&
1355                 to != owner() &&
1356                 to != address(0) &&
1357                 to != address(0xdead) &&
1358                 !swapping
1359             ) {
1360                 if (!tradingActive) {
1361                     require(
1362                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1363                         "Trading is not active."
1364                     );
1365                 }
1366 
1367                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1368                 if (transferDelayEnabled) {
1369                     if (
1370                         to != owner() &&
1371                         to != address(uniswapV2Router) &&
1372                         to != address(uniswapV2Pair)
1373                     ) {
1374                         require(
1375                             _holderLastTransferTimestamp[tx.origin] <
1376                                 block.number,
1377                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1378                         );
1379                         _holderLastTransferTimestamp[tx.origin] = block.number;
1380                     }
1381                 }
1382 
1383                 //when buy
1384                 if (
1385                     automatedMarketMakerPairs[from] &&
1386                     !_isExcludedMaxTransactionAmount[to]
1387                 ) {
1388                     require(
1389                         amount <= maxTransactionAmount,
1390                         "Buy transfer amount exceeds the maxTransactionAmount."
1391                     );
1392                     require(
1393                         amount + balanceOf(to) <= maxWallet,
1394                         "Max wallet exceeded"
1395                     );
1396                 }
1397                 //when sell
1398                 else if (
1399                     automatedMarketMakerPairs[to] &&
1400                     !_isExcludedMaxTransactionAmount[from]
1401                 ) {
1402                     require(
1403                         amount <= maxTransactionAmount,
1404                         "Sell transfer amount exceeds the maxTransactionAmount."
1405                     );
1406                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1407                     require(
1408                         amount + balanceOf(to) <= maxWallet,
1409                         "Max wallet exceeded"
1410                     );
1411                 }
1412             }
1413         }
1414 
1415         uint256 contractTokenBalance = balanceOf(address(this));
1416 
1417         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1418 
1419         if (
1420             canSwap &&
1421             swapEnabled &&
1422             !swapping &&
1423             !automatedMarketMakerPairs[from] &&
1424             !_isExcludedFromFees[from] &&
1425             !_isExcludedFromFees[to]
1426         ) {
1427             swapping = true;
1428 
1429             swapBack();
1430 
1431             swapping = false;
1432         }
1433 
1434         if (
1435             !swapping &&
1436             automatedMarketMakerPairs[to] &&
1437             lpBurnEnabled &&
1438             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1439             !_isExcludedFromFees[from]
1440         ) {
1441             autoBurnLiquidityPairTokens();
1442         }
1443 
1444         bool takeFee = !swapping;
1445 
1446         // if any account belongs to _isExcludedFromFee account then remove the fee
1447         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1448             takeFee = false;
1449         }
1450 
1451         uint256 fees = 0;
1452         // only take fees on buys/sells, do not take on wallet transfers
1453         if (takeFee) {
1454             // on sell
1455             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1456                 fees = amount.mul(sellTotalFees).div(100);
1457                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1458                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1459                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1460             }
1461             // on buy
1462             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1463                 fees = amount.mul(buyTotalFees).div(100);
1464                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1465                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1466                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1467             }
1468 
1469             if (fees > 0) {
1470                 super._transfer(from, address(this), fees);
1471             }
1472 
1473             amount -= fees;
1474         }
1475 
1476         super._transfer(from, to, amount);
1477     }
1478 
1479     function swapTokensForEth(uint256 tokenAmount) private {
1480         // generate the uniswap pair path of token -> weth
1481         address[] memory path = new address[](2);
1482         path[0] = address(this);
1483         path[1] = uniswapV2Router.WETH();
1484 
1485         _approve(address(this), address(uniswapV2Router), tokenAmount);
1486 
1487         // make the swap
1488         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1489             tokenAmount,
1490             0, // accept any amount of ETH
1491             path,
1492             address(this),
1493             block.timestamp
1494         );
1495     }
1496 
1497     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1498         // approve token transfer to cover all possible scenarios
1499         _approve(address(this), address(uniswapV2Router), tokenAmount);
1500 
1501         // add the liquidity
1502         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1503             address(this),
1504             tokenAmount,
1505             0, // slippage is unavoidable
1506             0, // slippage is unavoidable
1507             deadAddress,
1508             block.timestamp
1509         );
1510     }
1511 
1512     function swapBack() private {
1513         uint256 contractBalance = balanceOf(address(this));
1514         uint256 totalTokensToSwap = tokensForLiquidity +
1515             tokensForMarketing +
1516             tokensForDev;
1517         bool success;
1518 
1519         if (contractBalance == 0 || totalTokensToSwap == 0) {
1520             return;
1521         }
1522 
1523         if (contractBalance > swapTokensAtAmount * 20) {
1524             contractBalance = swapTokensAtAmount * 20;
1525         }
1526 
1527         // Halve the amount of liquidity tokens
1528         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1529             totalTokensToSwap /
1530             2;
1531         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1532 
1533         uint256 initialETHBalance = address(this).balance;
1534 
1535         swapTokensForEth(amountToSwapForETH);
1536 
1537         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1538 
1539         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1540             totalTokensToSwap
1541         );
1542         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1543 
1544         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1545 
1546         tokensForLiquidity = 0;
1547         tokensForMarketing = 0;
1548         tokensForDev = 0;
1549 
1550         (success, ) = address(devWallet).call{value: ethForDev}("");
1551 
1552         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1553             addLiquidity(liquidityTokens, ethForLiquidity);
1554             emit SwapAndLiquify(
1555                 amountToSwapForETH,
1556                 ethForLiquidity,
1557                 tokensForLiquidity
1558             );
1559         }
1560 
1561         (success, ) = address(marketingWallet).call{
1562             value: address(this).balance
1563         }("");
1564     }
1565 
1566     function setAutoLPBurnSettings(
1567         uint256 _frequencyInSeconds,
1568         uint256 _percent,
1569         bool _Enabled
1570     ) external onlyOwner {
1571         require(
1572             _frequencyInSeconds >= 600,
1573             "cannot set buyback more often than every 10 minutes"
1574         );
1575         require(
1576             _percent <= 1000 && _percent >= 0,
1577             "Must set auto LP burn percent between 0% and 10%"
1578         );
1579         lpBurnFrequency = _frequencyInSeconds;
1580         percentForLPBurn = _percent;
1581         lpBurnEnabled = _Enabled;
1582     }
1583 
1584     function autoBurnLiquidityPairTokens() internal returns (bool) {
1585         lastLpBurnTime = block.timestamp;
1586 
1587         // get balance of liquidity pair
1588         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1589 
1590         // calculate amount to burn
1591         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1592             10000
1593         );
1594 
1595         // pull tokens from pancakePair liquidity and move to dead address permanently
1596         if (amountToBurn > 0) {
1597             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1598         }
1599 
1600         //sync price since this is not in a swap transaction!
1601         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1602         pair.sync();
1603         emit AutoNukeLP();
1604         return true;
1605     }
1606 
1607     function manualBurnLiquidityPairTokens(uint256 percent)
1608         external
1609         onlyOwner
1610         returns (bool)
1611     {
1612         require(
1613             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1614             "Must wait for cooldown to finish"
1615         );
1616         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1617         lastManualLpBurnTime = block.timestamp;
1618 
1619         // get balance of liquidity pair
1620         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1621 
1622         // calculate amount to burn
1623         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1624 
1625         // pull tokens from pancakePair liquidity and move to dead address permanently
1626         if (amountToBurn > 0) {
1627             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1628         }
1629 
1630         //sync price since this is not in a swap transaction!
1631         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1632         pair.sync();
1633         emit ManualNukeLP();
1634         return true;
1635     }
1636 }