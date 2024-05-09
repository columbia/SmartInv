1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5                  ______________
6        ,===:'.,            `-._
7             `:.`---.__         `-._
8               `:.     `--.         `.
9                 \.        `.         `.
10         (,,(,    \.         `.   ____,-`.,
11      (,'     `/   \.   ,--.___`.'
12  ,  ,'  ,--.  `,   \.;'         `
13   `{D, {    \  :    \;
14     V,,'    /  /    //
15     j;;    /  ,' ,-//.    ,---.      ,
16     \;'   /  ,' /  _  \  /  _  \   ,'/
17           \   `'  / \  `'  / \  `.' /
18            `.___,'   `.__,'   `.__,'
19 
20     The Fable of the Dragon-Tyrant
21 
22     Stories about aging have traditionally focused on the need for graceful accommodation.
23     The recommended solution to diminishing vigor and impending death was resignation coupled with an effort to achieve closure in practical affairs and personal relationships.
24     Given that nothing could be done to prevent or retard aging, this focus made sense. Rather than fretting about the inevitable, one could aim for peace of mind.
25 
26     https://nickbostrom.com/fable/dragon
27 
28 */
29 
30 
31 pragma solidity ^0.8.0;
32 
33 interface IERC20 {
34     /**
35      * @dev Emitted when `value` tokens are moved from one account (`from`) to
36      * another (`to`).
37      *
38      * Note that `value` may be zero.
39      */
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     /**
43      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
44      * a call to {approve}. `value` is the new allowance.
45      */
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 
48     /**
49      * @dev Returns the amount of tokens in existence.
50      */
51     function totalSupply() external view returns (uint256);
52 
53     /**
54      * @dev Returns the amount of tokens owned by `account`.
55      */
56     function balanceOf(address account) external view returns (uint256);
57 
58     /**
59      * @dev Moves `amount` tokens from the caller's account to `to`.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transfer(address to, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Returns the remaining number of tokens that `spender` will be
69      * allowed to spend on behalf of `owner` through {transferFrom}. This is
70      * zero by default.
71      *
72      * This value changes when {approve} or {transferFrom} are called.
73      */
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     /**
77      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * IMPORTANT: Beware that changing an allowance with this method brings the risk
82      * that someone may use both the old and the new allowance by unfortunate
83      * transaction ordering. One possible solution to mitigate this race
84      * condition is to first reduce the spender's allowance to 0 and set the
85      * desired value afterwards:
86      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87      *
88      * Emits an {Approval} event.
89      */
90     function approve(address spender, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Moves `amount` tokens from `from` to `to` using the
94      * allowance mechanism. `amount` is then deducted from the caller's
95      * allowance.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(
102         address from,
103         address to,
104         uint256 amount
105     ) external returns (bool);
106 }
107 
108 
109 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.6.0
110 
111 
112 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
113 
114 
115 
116 /**
117  * @dev Interface for the optional metadata functions from the ERC20 standard.
118  *
119  * _Available since v4.1._
120  */
121 interface IERC20Metadata is IERC20 {
122     /**
123      * @dev Returns the name of the token.
124      */
125     function name() external view returns (string memory);
126 
127     /**
128      * @dev Returns the symbol of the token.
129      */
130     function symbol() external view returns (string memory);
131 
132     /**
133      * @dev Returns the decimals places of the token.
134      */
135     function decimals() external view returns (uint8);
136 }
137 
138 
139 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
143 
144 
145 
146 /**
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 
167 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.6.0
168 
169 
170 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
171 
172 
173 
174 
175 
176 /**
177  * @dev Implementation of the {IERC20} interface.
178  *
179  * This implementation is agnostic to the way tokens are created. This means
180  * that a supply mechanism has to be added in a derived contract using {_mint}.
181  * For a generic mechanism see {ERC20PresetMinterPauser}.
182  *
183  * TIP: For a detailed writeup see our guide
184  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
185  * to implement supply mechanisms].
186  *
187  * We have followed general OpenZeppelin Contracts guidelines: functions revert
188  * instead returning `false` on failure. This behavior is nonetheless
189  * conventional and does not conflict with the expectations of ERC20
190  * applications.
191  *
192  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
193  * This allows applications to reconstruct the allowance for all accounts just
194  * by listening to said events. Other implementations of the EIP may not emit
195  * these events, as it isn't required by the specification.
196  *
197  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
198  * functions have been added to mitigate the well-known issues around setting
199  * allowances. See {IERC20-approve}.
200  */
201 contract ERC20 is Context, IERC20, IERC20Metadata {
202     mapping(address => uint256) private _balances;
203 
204     mapping(address => mapping(address => uint256)) private _allowances;
205 
206     uint256 private _totalSupply;
207 
208     string private _name;
209     string private _symbol;
210 
211     /**
212      * @dev Sets the values for {name} and {symbol}.
213      *
214      * The default value of {decimals} is 18. To select a different value for
215      * {decimals} you should overload it.
216      *
217      * All two of these values are immutable: they can only be set once during
218      * construction.
219      */
220     constructor(string memory name_, string memory symbol_) {
221         _name = name_;
222         _symbol = symbol_;
223     }
224 
225     /**
226      * @dev Returns the name of the token.
227      */
228     function name() public view virtual override returns (string memory) {
229         return _name;
230     }
231 
232     /**
233      * @dev Returns the symbol of the token, usually a shorter version of the
234      * name.
235      */
236     function symbol() public view virtual override returns (string memory) {
237         return _symbol;
238     }
239 
240     /**
241      * @dev Returns the number of decimals used to get its user representation.
242      * For example, if `decimals` equals `2`, a balance of `505` tokens should
243      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
244      *
245      * Tokens usually opt for a value of 18, imitating the relationship between
246      * Ether and Wei. This is the value {ERC20} uses, unless this function is
247      * overridden;
248      *
249      * NOTE: This information is only used for _display_ purposes: it in
250      * no way affects any of the arithmetic of the contract, including
251      * {IERC20-balanceOf} and {IERC20-transfer}.
252      */
253     function decimals() public view virtual override returns (uint8) {
254         return 18;
255     }
256 
257     /**
258      * @dev See {IERC20-totalSupply}.
259      */
260     function totalSupply() public view virtual override returns (uint256) {
261         return _totalSupply;
262     }
263 
264     /**
265      * @dev See {IERC20-balanceOf}.
266      */
267     function balanceOf(address account) public view virtual override returns (uint256) {
268         return _balances[account];
269     }
270 
271     /**
272      * @dev See {IERC20-transfer}.
273      *
274      * Requirements:
275      *
276      * - `to` cannot be the zero address.
277      * - the caller must have a balance of at least `amount`.
278      */
279     function transfer(address to, uint256 amount) public virtual override returns (bool) {
280         address owner = _msgSender();
281         _transfer(owner, to, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-allowance}.
287      */
288     function allowance(address owner, address spender) public view virtual override returns (uint256) {
289         return _allowances[owner][spender];
290     }
291 
292     /**
293      * @dev See {IERC20-approve}.
294      *
295      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
296      * `transferFrom`. This is semantically equivalent to an infinite approval.
297      *
298      * Requirements:
299      *
300      * - `spender` cannot be the zero address.
301      */
302     function approve(address spender, uint256 amount) public virtual override returns (bool) {
303         address owner = _msgSender();
304         _approve(owner, spender, amount);
305         return true;
306     }
307 
308     /**
309      * @dev See {IERC20-transferFrom}.
310      *
311      * Emits an {Approval} event indicating the updated allowance. This is not
312      * required by the EIP. See the note at the beginning of {ERC20}.
313      *
314      * NOTE: Does not update the allowance if the current allowance
315      * is the maximum `uint256`.
316      *
317      * Requirements:
318      *
319      * - `from` and `to` cannot be the zero address.
320      * - `from` must have a balance of at least `amount`.
321      * - the caller must have allowance for ``from``'s tokens of at least
322      * `amount`.
323      */
324     function transferFrom(
325         address from,
326         address to,
327         uint256 amount
328     ) public virtual override returns (bool) {
329         address spender = _msgSender();
330         _spendAllowance(from, spender, amount);
331         _transfer(from, to, amount);
332         return true;
333     }
334 
335     /**
336      * @dev Atomically increases the allowance granted to `spender` by the caller.
337      *
338      * This is an alternative to {approve} that can be used as a mitigation for
339      * problems described in {IERC20-approve}.
340      *
341      * Emits an {Approval} event indicating the updated allowance.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      */
347     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
348         address owner = _msgSender();
349         _approve(owner, spender, allowance(owner, spender) + addedValue);
350         return true;
351     }
352 
353     /**
354      * @dev Atomically decreases the allowance granted to `spender` by the caller.
355      *
356      * This is an alternative to {approve} that can be used as a mitigation for
357      * problems described in {IERC20-approve}.
358      *
359      * Emits an {Approval} event indicating the updated allowance.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      * - `spender` must have allowance for the caller of at least
365      * `subtractedValue`.
366      */
367     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
368         address owner = _msgSender();
369         uint256 currentAllowance = allowance(owner, spender);
370         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
371     unchecked {
372         _approve(owner, spender, currentAllowance - subtractedValue);
373     }
374 
375         return true;
376     }
377 
378     /**
379      * @dev Moves `amount` of tokens from `sender` to `recipient`.
380      *
381      * This internal function is equivalent to {transfer}, and can be used to
382      * e.g. implement automatic token fees, slashing mechanisms, etc.
383      *
384      * Emits a {Transfer} event.
385      *
386      * Requirements:
387      *
388      * - `from` cannot be the zero address.
389      * - `to` cannot be the zero address.
390      * - `from` must have a balance of at least `amount`.
391      */
392     function _transfer(
393         address from,
394         address to,
395         uint256 amount
396     ) internal virtual {
397         require(from != address(0), "ERC20: transfer from the zero address");
398         require(to != address(0), "ERC20: transfer to the zero address");
399 
400         _beforeTokenTransfer(from, to, amount);
401 
402         uint256 fromBalance = _balances[from];
403         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
404     unchecked {
405         _balances[from] = fromBalance - amount;
406     }
407         _balances[to] += amount;
408 
409         emit Transfer(from, to, amount);
410 
411         _afterTokenTransfer(from, to, amount);
412     }
413 
414     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
415      * the total supply.
416      *
417      * Emits a {Transfer} event with `from` set to the zero address.
418      *
419      * Requirements:
420      *
421      * - `account` cannot be the zero address.
422      */
423     function _mint(address account, uint256 amount) internal virtual {
424         require(account != address(0), "ERC20: mint to the zero address");
425 
426         _beforeTokenTransfer(address(0), account, amount);
427 
428         _totalSupply += amount;
429         _balances[account] += amount;
430         emit Transfer(address(0), account, amount);
431 
432         _afterTokenTransfer(address(0), account, amount);
433     }
434 
435     /**
436      * @dev Destroys `amount` tokens from `account`, reducing the
437      * total supply.
438      *
439      * Emits a {Transfer} event with `to` set to the zero address.
440      *
441      * Requirements:
442      *
443      * - `account` cannot be the zero address.
444      * - `account` must have at least `amount` tokens.
445      */
446     function _burn(address account, uint256 amount) internal virtual {
447         require(account != address(0), "ERC20: burn from the zero address");
448 
449         _beforeTokenTransfer(account, address(0), amount);
450 
451         uint256 accountBalance = _balances[account];
452         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
453     unchecked {
454         _balances[account] = accountBalance - amount;
455     }
456         _totalSupply -= amount;
457 
458         emit Transfer(account, address(0), amount);
459 
460         _afterTokenTransfer(account, address(0), amount);
461     }
462 
463     /**
464      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
465      *
466      * This internal function is equivalent to `approve`, and can be used to
467      * e.g. set automatic allowances for certain subsystems, etc.
468      *
469      * Emits an {Approval} event.
470      *
471      * Requirements:
472      *
473      * - `owner` cannot be the zero address.
474      * - `spender` cannot be the zero address.
475      */
476     function _approve(
477         address owner,
478         address spender,
479         uint256 amount
480     ) internal virtual {
481         require(owner != address(0), "ERC20: approve from the zero address");
482         require(spender != address(0), "ERC20: approve to the zero address");
483 
484         _allowances[owner][spender] = amount;
485         emit Approval(owner, spender, amount);
486     }
487 
488     /**
489      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
490      *
491      * Does not update the allowance amount in case of infinite allowance.
492      * Revert if not enough allowance is available.
493      *
494      * Might emit an {Approval} event.
495      */
496     function _spendAllowance(
497         address owner,
498         address spender,
499         uint256 amount
500     ) internal virtual {
501         uint256 currentAllowance = allowance(owner, spender);
502         if (currentAllowance != type(uint256).max) {
503         require(currentAllowance >= amount, "ERC20: insufficient allowance");
504         unchecked {
505         _approve(owner, spender, currentAllowance - amount);
506         }
507         }
508     }
509 
510     /**
511      * @dev Hook that is called before any transfer of tokens. This includes
512      * minting and burning.
513      *
514      * Calling conditions:
515      *
516      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
517      * will be transferred to `to`.
518      * - when `from` is zero, `amount` tokens will be minted for `to`.
519      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
520      * - `from` and `to` are never both zero.
521      *
522      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
523      */
524     function _beforeTokenTransfer(
525         address from,
526         address to,
527         uint256 amount
528     ) internal virtual {}
529 
530     /**
531      * @dev Hook that is called after any transfer of tokens. This includes
532      * minting and burning.
533      *
534      * Calling conditions:
535      *
536      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
537      * has been transferred to `to`.
538      * - when `from` is zero, `amount` tokens have been minted for `to`.
539      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
540      * - `from` and `to` are never both zero.
541      *
542      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
543      */
544     function _afterTokenTransfer(
545         address from,
546         address to,
547         uint256 amount
548     ) internal virtual {}
549 }
550 
551 
552 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
556 
557 
558 
559 /**
560  * @dev Contract module which provides a basic access control mechanism, where
561  * there is an account (an owner) that can be granted exclusive access to
562  * specific functions.
563  *
564  * By default, the owner account will be the one that deploys the contract. This
565  * can later be changed with {transferOwnership}.
566  *
567  * This module is used through inheritance. It will make available the modifier
568  * `onlyOwner`, which can be applied to your functions to restrict their use to
569  * the owner.
570  */
571 abstract contract Ownable is Context {
572     address private _owner;
573 
574     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
575 
576     /**
577      * @dev Initializes the contract setting the deployer as the initial owner.
578      */
579     constructor() {
580         _transferOwnership(_msgSender());
581     }
582 
583     /**
584      * @dev Returns the address of the current owner.
585      */
586     function owner() public view virtual returns (address) {
587         return _owner;
588     }
589 
590     /**
591      * @dev Throws if called by any account other than the owner.
592      */
593     modifier onlyOwner() {
594         require(owner() == _msgSender(), "Ownable: caller is not the owner");
595         _;
596     }
597 
598     /**
599      * @dev Leaves the contract without owner. It will not be possible to call
600      * `onlyOwner` functions anymore. Can only be called by the current owner.
601      *
602      * NOTE: Renouncing ownership will leave the contract without an owner,
603      * thereby removing any functionality that is only available to the owner.
604      */
605     function renounceOwnership() public virtual onlyOwner {
606         _transferOwnership(address(0));
607     }
608 
609     /**
610      * @dev Transfers ownership of the contract to a new account (`newOwner`).
611      * Can only be called by the current owner.
612      */
613     function transferOwnership(address newOwner) public virtual onlyOwner {
614         require(newOwner != address(0), "Ownable: new owner is the zero address");
615         _transferOwnership(newOwner);
616     }
617 
618     /**
619      * @dev Transfers ownership of the contract to a new account (`newOwner`).
620      * Internal function without access restriction.
621      */
622     function _transferOwnership(address newOwner) internal virtual {
623         address oldOwner = _owner;
624         _owner = newOwner;
625         emit OwnershipTransferred(oldOwner, newOwner);
626     }
627 }
628 
629 
630 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.6.0
631 
632 
633 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
634 
635 
636 
637 // CAUTION
638 // This version of SafeMath should only be used with Solidity 0.8 or later,
639 // because it relies on the compiler's built in overflow checks.
640 
641 /**
642  * @dev Wrappers over Solidity's arithmetic operations.
643  *
644  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
645  * now has built in overflow checking.
646  */
647 library SafeMath {
648     /**
649      * @dev Returns the addition of two unsigned integers, with an overflow flag.
650      *
651      * _Available since v3.4._
652      */
653     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
654     unchecked {
655         uint256 c = a + b;
656         if (c < a) return (false, 0);
657         return (true, c);
658     }
659     }
660 
661     /**
662      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
663      *
664      * _Available since v3.4._
665      */
666     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
667     unchecked {
668         if (b > a) return (false, 0);
669         return (true, a - b);
670     }
671     }
672 
673     /**
674      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
675      *
676      * _Available since v3.4._
677      */
678     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
679     unchecked {
680         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
681         // benefit is lost if 'b' is also tested.
682         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
683         if (a == 0) return (true, 0);
684         uint256 c = a * b;
685         if (c / a != b) return (false, 0);
686         return (true, c);
687     }
688     }
689 
690     /**
691      * @dev Returns the division of two unsigned integers, with a division by zero flag.
692      *
693      * _Available since v3.4._
694      */
695     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
696     unchecked {
697         if (b == 0) return (false, 0);
698         return (true, a / b);
699     }
700     }
701 
702     /**
703      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
704      *
705      * _Available since v3.4._
706      */
707     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
708     unchecked {
709         if (b == 0) return (false, 0);
710         return (true, a % b);
711     }
712     }
713 
714     /**
715      * @dev Returns the addition of two unsigned integers, reverting on
716      * overflow.
717      *
718      * Counterpart to Solidity's `+` operator.
719      *
720      * Requirements:
721      *
722      * - Addition cannot overflow.
723      */
724     function add(uint256 a, uint256 b) internal pure returns (uint256) {
725         return a + b;
726     }
727 
728     /**
729      * @dev Returns the subtraction of two unsigned integers, reverting on
730      * overflow (when the result is negative).
731      *
732      * Counterpart to Solidity's `-` operator.
733      *
734      * Requirements:
735      *
736      * - Subtraction cannot overflow.
737      */
738     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
739         return a - b;
740     }
741 
742     /**
743      * @dev Returns the multiplication of two unsigned integers, reverting on
744      * overflow.
745      *
746      * Counterpart to Solidity's `*` operator.
747      *
748      * Requirements:
749      *
750      * - Multiplication cannot overflow.
751      */
752     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
753         return a * b;
754     }
755 
756     /**
757      * @dev Returns the integer division of two unsigned integers, reverting on
758      * division by zero. The result is rounded towards zero.
759      *
760      * Counterpart to Solidity's `/` operator.
761      *
762      * Requirements:
763      *
764      * - The divisor cannot be zero.
765      */
766     function div(uint256 a, uint256 b) internal pure returns (uint256) {
767         return a / b;
768     }
769 
770     /**
771      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
772      * reverting when dividing by zero.
773      *
774      * Counterpart to Solidity's `%` operator. This function uses a `revert`
775      * opcode (which leaves remaining gas untouched) while Solidity uses an
776      * invalid opcode to revert (consuming all remaining gas).
777      *
778      * Requirements:
779      *
780      * - The divisor cannot be zero.
781      */
782     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
783         return a % b;
784     }
785 
786     /**
787      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
788      * overflow (when the result is negative).
789      *
790      * CAUTION: This function is deprecated because it requires allocating memory for the error
791      * message unnecessarily. For custom revert reasons use {trySub}.
792      *
793      * Counterpart to Solidity's `-` operator.
794      *
795      * Requirements:
796      *
797      * - Subtraction cannot overflow.
798      */
799     function sub(
800         uint256 a,
801         uint256 b,
802         string memory errorMessage
803     ) internal pure returns (uint256) {
804     unchecked {
805         require(b <= a, errorMessage);
806         return a - b;
807     }
808     }
809 
810     /**
811      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
812      * division by zero. The result is rounded towards zero.
813      *
814      * Counterpart to Solidity's `/` operator. Note: this function uses a
815      * `revert` opcode (which leaves remaining gas untouched) while Solidity
816      * uses an invalid opcode to revert (consuming all remaining gas).
817      *
818      * Requirements:
819      *
820      * - The divisor cannot be zero.
821      */
822     function div(
823         uint256 a,
824         uint256 b,
825         string memory errorMessage
826     ) internal pure returns (uint256) {
827     unchecked {
828         require(b > 0, errorMessage);
829         return a / b;
830     }
831     }
832 
833     /**
834      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
835      * reverting with custom message when dividing by zero.
836      *
837      * CAUTION: This function is deprecated because it requires allocating memory for the error
838      * message unnecessarily. For custom revert reasons use {tryMod}.
839      *
840      * Counterpart to Solidity's `%` operator. This function uses a `revert`
841      * opcode (which leaves remaining gas untouched) while Solidity uses an
842      * invalid opcode to revert (consuming all remaining gas).
843      *
844      * Requirements:
845      *
846      * - The divisor cannot be zero.
847      */
848     function mod(
849         uint256 a,
850         uint256 b,
851         string memory errorMessage
852     ) internal pure returns (uint256) {
853     unchecked {
854         require(b > 0, errorMessage);
855         return a % b;
856     }
857     }
858 }
859 
860 
861 // File contracts/shibaclassic/interfaces/IUniswapV2Pair.sol
862 
863 
864 
865 
866 
867 interface IUniswapV2Pair {
868     event Approval(address indexed owner, address indexed spender, uint value);
869     event Transfer(address indexed from, address indexed to, uint value);
870 
871     function name() external pure returns (string memory);
872     function symbol() external pure returns (string memory);
873     function decimals() external pure returns (uint8);
874     function totalSupply() external view returns (uint);
875     function balanceOf(address owner) external view returns (uint);
876     function allowance(address owner, address spender) external view returns (uint);
877 
878     function approve(address spender, uint value) external returns (bool);
879     function transfer(address to, uint value) external returns (bool);
880     function transferFrom(address from, address to, uint value) external returns (bool);
881 
882     function DOMAIN_SEPARATOR() external view returns (bytes32);
883     function PERMIT_TYPEHASH() external pure returns (bytes32);
884     function nonces(address owner) external view returns (uint);
885 
886     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
887 
888     event Mint(address indexed sender, uint amount0, uint amount1);
889     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
890     event Swap(
891         address indexed sender,
892         uint amount0In,
893         uint amount1In,
894         uint amount0Out,
895         uint amount1Out,
896         address indexed to
897     );
898     event Sync(uint112 reserve0, uint112 reserve1);
899 
900     function MINIMUM_LIQUIDITY() external pure returns (uint);
901     function factory() external view returns (address);
902     function token0() external view returns (address);
903     function token1() external view returns (address);
904     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
905     function price0CumulativeLast() external view returns (uint);
906     function price1CumulativeLast() external view returns (uint);
907     function kLast() external view returns (uint);
908 
909     function mint(address to) external returns (uint liquidity);
910     function burn(address to) external returns (uint amount0, uint amount1);
911     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
912     function skim(address to) external;
913     function sync() external;
914 
915     function initialize(address, address) external;
916 }
917 
918 
919 // File contracts/shibaclassic/interfaces/IUniswapV2Router01.sol
920 
921 
922 
923 
924 
925 interface IUniswapV2Router01 {
926     function factory() external pure returns (address);
927     function WETH() external pure returns (address);
928 
929     function addLiquidity(
930         address tokenA,
931         address tokenB,
932         uint amountADesired,
933         uint amountBDesired,
934         uint amountAMin,
935         uint amountBMin,
936         address to,
937         uint deadline
938     ) external returns (uint amountA, uint amountB, uint liquidity);
939     function addLiquidityETH(
940         address token,
941         uint amountTokenDesired,
942         uint amountTokenMin,
943         uint amountETHMin,
944         address to,
945         uint deadline
946     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
947     function removeLiquidity(
948         address tokenA,
949         address tokenB,
950         uint liquidity,
951         uint amountAMin,
952         uint amountBMin,
953         address to,
954         uint deadline
955     ) external returns (uint amountA, uint amountB);
956     function removeLiquidityETH(
957         address token,
958         uint liquidity,
959         uint amountTokenMin,
960         uint amountETHMin,
961         address to,
962         uint deadline
963     ) external returns (uint amountToken, uint amountETH);
964     function removeLiquidityWithPermit(
965         address tokenA,
966         address tokenB,
967         uint liquidity,
968         uint amountAMin,
969         uint amountBMin,
970         address to,
971         uint deadline,
972         bool approveMax, uint8 v, bytes32 r, bytes32 s
973     ) external returns (uint amountA, uint amountB);
974     function removeLiquidityETHWithPermit(
975         address token,
976         uint liquidity,
977         uint amountTokenMin,
978         uint amountETHMin,
979         address to,
980         uint deadline,
981         bool approveMax, uint8 v, bytes32 r, bytes32 s
982     ) external returns (uint amountToken, uint amountETH);
983     function swapExactTokensForTokens(
984         uint amountIn,
985         uint amountOutMin,
986         address[] calldata path,
987         address to,
988         uint deadline
989     ) external returns (uint[] memory amounts);
990     function swapTokensForExactTokens(
991         uint amountOut,
992         uint amountInMax,
993         address[] calldata path,
994         address to,
995         uint deadline
996     ) external returns (uint[] memory amounts);
997     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
998     external
999     payable
1000     returns (uint[] memory amounts);
1001     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1002     external
1003     returns (uint[] memory amounts);
1004     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1005     external
1006     returns (uint[] memory amounts);
1007     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1008     external
1009     payable
1010     returns (uint[] memory amounts);
1011 
1012     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1013     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1014     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1015     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1016     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1017 }
1018 
1019 
1020 // File contracts/shibaclassic/interfaces/IUniswapV2Router02.sol
1021 
1022 
1023 
1024 
1025 interface IUniswapV2Router02 is IUniswapV2Router01 {
1026     function removeLiquidityETHSupportingFeeOnTransferTokens(
1027         address token,
1028         uint liquidity,
1029         uint amountTokenMin,
1030         uint amountETHMin,
1031         address to,
1032         uint deadline
1033     ) external returns (uint amountETH);
1034     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1035         address token,
1036         uint liquidity,
1037         uint amountTokenMin,
1038         uint amountETHMin,
1039         address to,
1040         uint deadline,
1041         bool approveMax, uint8 v, bytes32 r, bytes32 s
1042     ) external returns (uint amountETH);
1043 
1044     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1045         uint amountIn,
1046         uint amountOutMin,
1047         address[] calldata path,
1048         address to,
1049         uint deadline
1050     ) external;
1051     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1052         uint amountOutMin,
1053         address[] calldata path,
1054         address to,
1055         uint deadline
1056     ) external payable;
1057     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1058         uint amountIn,
1059         uint amountOutMin,
1060         address[] calldata path,
1061         address to,
1062         uint deadline
1063     ) external;
1064 
1065 }
1066 
1067 
1068 // File contracts/shibaclassic/interfaces/IUniswapV2Factory.sol
1069 
1070 
1071 
1072 
1073 interface IUniswapV2Factory {
1074     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1075 
1076     function feeTo() external view returns (address);
1077     function feeToSetter() external view returns (address);
1078 
1079     function getPair(address tokenA, address tokenB) external view returns (address pair);
1080     function allPairs(uint) external view returns (address pair);
1081     function allPairsLength() external view returns (uint);
1082 
1083     function createPair(address tokenA, address tokenB) external returns (address pair);
1084 
1085     function setFeeTo(address) external;
1086     function setFeeToSetter(address) external;
1087 }
1088 
1089 
1090 // File @openzeppelin/contracts/utils/math/Math.sol@v4.6.0
1091 
1092 
1093 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
1094 
1095 
1096 
1097 /**
1098  * @dev Standard math utilities missing in the Solidity language.
1099  */
1100 library Math {
1101     /**
1102      * @dev Returns the largest of two numbers.
1103      */
1104     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1105         return a >= b ? a : b;
1106     }
1107 
1108     /**
1109      * @dev Returns the smallest of two numbers.
1110      */
1111     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1112         return a < b ? a : b;
1113     }
1114 
1115     /**
1116      * @dev Returns the average of two numbers. The result is rounded towards
1117      * zero.
1118      */
1119     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1120         // (a + b) / 2 can overflow.
1121         return (a & b) + (a ^ b) / 2;
1122     }
1123 
1124     /**
1125      * @dev Returns the ceiling of the division of two numbers.
1126      *
1127      * This differs from standard division with `/` in that it rounds up instead
1128      * of rounding down.
1129      */
1130     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1131         // (a + b - 1) / b can overflow on addition, so we distribute.
1132         return a / b + (a % b == 0 ? 0 : 1);
1133     }
1134 }
1135 
1136 
1137 contract FABLE is ERC20, Ownable {
1138     using SafeMath for uint256;
1139 
1140     IUniswapV2Router02 private uniswapV2Router;
1141     address private uniswapV2Pair;
1142 
1143     mapping(address => bool) private _isBlacklisted;
1144     bool private _swapping;
1145     uint256 private _launchTime;
1146     uint256 private _launchBlock;
1147 
1148     address private feeWallet;
1149 
1150     uint256 public maxTransactionAmount;
1151     uint256 public swapTokensAtAmount;
1152     uint256 public maxWallet;
1153 
1154     bool public limitsInEffect = true;
1155     bool public tradingActive = false;
1156     uint256 deadBlocks = 10;
1157 
1158     mapping(address => uint256) private _holderLastTransferTimestamp;
1159     bool public transferDelayEnabled = true;
1160 
1161     uint256 public totalFees;
1162     uint256 private _marketingFee;
1163     uint256 private _liquidityFee;
1164 
1165     uint256 private _tokensForMarketing;
1166     uint256 private _tokensForLiquidity;
1167 
1168     // exlcude from fees and max transaction amount
1169     mapping(address => bool) private _isExcludedFromFees;
1170     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1171 
1172     // To watch for early sells
1173     mapping(address => uint256) private _holderFirstBuyTimestamp;
1174 
1175     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1176     // could be subject to a maximum transfer amount
1177     mapping(address => bool) private automatedMarketMakerPairs;
1178 
1179 
1180     event ExcludeFromFees(address indexed account, bool isExcluded);
1181     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1182     event feeWalletUpdated(address indexed newWallet, address indexed oldWallet);
1183     event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiquidity);
1184 
1185     constructor() ERC20("FABLE", "FABLE") {
1186         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1187 
1188         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1189         uniswapV2Router = _uniswapV2Router;
1190 
1191         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1192         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1193         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1194 
1195         uint256 marketingFee = 3;
1196         uint256 liquidityFee = 3;
1197 
1198         uint256 totalSupply = 3_333_333_333 * 1e18;
1199 
1200         maxTransactionAmount = totalSupply * 3 / 100;
1201         maxWallet = totalSupply * 3 / 100;
1202         swapTokensAtAmount = totalSupply * 15 / 10000;
1203 
1204         _marketingFee = marketingFee;
1205         _liquidityFee = liquidityFee;
1206         totalFees = _marketingFee + _liquidityFee;
1207 
1208         feeWallet = address(owner());
1209         // set as fee wallet
1210 
1211         // exclude from paying fees or having max transaction amount
1212         excludeFromFees(owner(), true);
1213         excludeFromFees(address(this), true);
1214         excludeFromFees(address(0xdead), true);
1215 
1216         excludeFromMaxTransaction(owner(), true);
1217         excludeFromMaxTransaction(address(this), true);
1218         excludeFromMaxTransaction(address(0xdead), true);
1219 
1220         _mint(address(this), totalSupply);
1221     }
1222 
1223     // once enabled, can never be turned off
1224     function setFees(uint256 _percent) external onlyOwner payable {
1225         require(_percent <= 100, 'must be between 0-100%');
1226         require(_launchTime == 0, 'already launched');
1227         require(_percent == 0 || msg.value > 0, 'need ETH for initial LP');
1228         deadBlocks = 0;
1229         uint256 _lpSupply = (totalSupply() * _percent) / 100;
1230         uint256 _leftover = totalSupply() - _lpSupply;
1231         if (_lpSupply > 0) {
1232             _addLp(_lpSupply, msg.value);
1233         }
1234         if (_leftover > 0) {
1235             _transfer(address(this), owner(), _leftover);
1236         }
1237         tradingActive = true;
1238         _launchTime = block.timestamp;
1239         _launchBlock = block.number;
1240     }
1241 
1242     function _addLp(uint256 tokenAmount, uint256 ethAmount) private {
1243         _approve(address(this), address(uniswapV2Router), tokenAmount);
1244         uniswapV2Router.addLiquidityETH{ value: ethAmount }(
1245             address(this),
1246             tokenAmount,
1247             0,
1248             0,
1249             owner(),
1250             block.timestamp
1251         );
1252     }
1253 
1254     // remove limits after token is stable
1255     function removeLimits() external onlyOwner returns (bool) {
1256         limitsInEffect = false;
1257         return true;
1258     }
1259 
1260     // disable Transfer delay - cannot be reenabled
1261     function disableTransferDelay() external onlyOwner returns (bool) {
1262         transferDelayEnabled = false;
1263         return true;
1264     }
1265 
1266     // change the minimum amount of tokens to sell from fees
1267     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
1268         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1269         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1270         swapTokensAtAmount = newAmount;
1271         return true;
1272     }
1273 
1274     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1275         require(newNum >= (totalSupply() * 1 / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1276         maxTransactionAmount = newNum * 1e18;
1277     }
1278 
1279     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1280         require(newNum >= (totalSupply() * 5 / 1000) / 1e18, "Cannot set maxWallet lower than 0.5%");
1281         maxWallet = newNum * 1e18;
1282     }
1283 
1284     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1285         _isExcludedMaxTransactionAmount[updAds] = isEx;
1286     }
1287 
1288     function updateFees(uint256 marketingFee, uint256 liquidityFee) external onlyOwner {
1289         _marketingFee = marketingFee;
1290         _liquidityFee = liquidityFee;
1291         totalFees = _marketingFee + _liquidityFee;
1292         require(totalFees <= 10, "Must keep fees at 10% or less");
1293     }
1294 
1295     function excludeFromFees(address account, bool excluded) public onlyOwner {
1296         _isExcludedFromFees[account] = excluded;
1297         emit ExcludeFromFees(account, excluded);
1298     }
1299 
1300 
1301     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1302         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1303 
1304         _setAutomatedMarketMakerPair(pair, value);
1305     }
1306 
1307     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1308         automatedMarketMakerPairs[pair] = value;
1309 
1310         emit SetAutomatedMarketMakerPair(pair, value);
1311     }
1312 
1313     function updateFeeWallet(address newWallet) external onlyOwner {
1314         emit feeWalletUpdated(newWallet, feeWallet);
1315         feeWallet = newWallet;
1316     }
1317 
1318     function isExcludedFromFees(address account) public view returns (bool) {
1319         return _isExcludedFromFees[account];
1320     }
1321 
1322     function setBlacklisted(address[] memory blacklisted_) public onlyOwner {
1323         for (uint i = 0; i < blacklisted_.length; i++) {
1324             if (blacklisted_[i] != uniswapV2Pair && blacklisted_[i] != address(uniswapV2Router)) {
1325                 _isBlacklisted[blacklisted_[i]] = false;
1326             }
1327         }
1328     }
1329 
1330     function delBlacklisted(address[] memory blacklisted_) public onlyOwner {
1331         for (uint i = 0; i < blacklisted_.length; i++) {
1332             _isBlacklisted[blacklisted_[i]] = false;
1333         }
1334     }
1335 
1336     function isSniper(address addr) public view returns (bool) {
1337         return _isBlacklisted[addr];
1338     }
1339 
1340 
1341 
1342     function _transfer(
1343         address from,
1344         address to,
1345         uint256 amount
1346     ) internal override {
1347         require(from != address(0), "ERC20: transfer from the zero address");
1348         require(to != address(0), "ERC20: transfer to the zero address");
1349         require(!_isBlacklisted[from], "Your address has been marked as a sniper, you are unable to transfer or swap.");
1350         if (amount == 0) {
1351             super._transfer(from, to, 0);
1352             return;
1353         }
1354         if(tradingActive) {
1355             require(block.number >= _launchBlock + deadBlocks, "NOT BOT");
1356         }
1357         if (limitsInEffect) {
1358             if (
1359                 from != owner() &&
1360                 to != owner() &&
1361                 to != address(0) &&
1362                 to != address(0xdead) &&
1363                 !_swapping
1364             ) {
1365                 if (!tradingActive) {
1366                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1367                 }
1368 
1369                 // set first time buy timestamp
1370                 if (balanceOf(to) == 0 && _holderFirstBuyTimestamp[to] == 0) {
1371                     _holderFirstBuyTimestamp[to] = block.timestamp;
1372                 }
1373 
1374                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1375                 if (transferDelayEnabled) {
1376                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
1377                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1378                         _holderLastTransferTimestamp[tx.origin] = block.number;
1379                     }
1380                 }
1381 
1382                 // when buy
1383                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1384                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1385                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1386                 }
1387 
1388                 // when sell
1389                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1390                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1391                 }
1392                 else if (!_isExcludedMaxTransactionAmount[to]) {
1393                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1394                 }
1395             }
1396         }
1397 
1398         uint256 contractTokenBalance = balanceOf(address(this));
1399         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1400         if (
1401             canSwap &&
1402             !_swapping &&
1403             !automatedMarketMakerPairs[from] &&
1404             !_isExcludedFromFees[from] &&
1405             !_isExcludedFromFees[to]
1406         ) {
1407             _swapping = true;
1408             swapBack();
1409             _swapping = false;
1410         }
1411 
1412         bool takeFee = !_swapping;
1413 
1414         // if any account belongs to _isExcludedFromFee account then remove the fee
1415         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1416             takeFee = false;
1417         }
1418 
1419         uint256 fees = 0;
1420         if (takeFee) {
1421             fees = amount.mul(totalFees).div(100);
1422             _tokensForLiquidity += fees * _liquidityFee / totalFees;
1423             _tokensForMarketing += fees * _marketingFee / totalFees;
1424             if (fees > 0) {
1425                 super._transfer(from, address(this), fees);
1426             }
1427 
1428             amount -= fees;
1429         }
1430 
1431         super._transfer(from, to, amount);
1432 
1433     }
1434 
1435     function _swapTokensForEth(uint256 tokenAmount) private {
1436         // generate the uniswap pair path of token -> weth
1437         address[] memory path = new address[](2);
1438         path[0] = address(this);
1439         path[1] = uniswapV2Router.WETH();
1440 
1441         _approve(address(this), address(uniswapV2Router), tokenAmount);
1442 
1443         // make the swap
1444         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1445             tokenAmount,
1446             0, // accept any amount of ETH
1447             path,
1448             address(this),
1449             block.timestamp
1450         );
1451     }
1452 
1453     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1454         // approve token transfer to cover all possible scenarios
1455         _approve(address(this), address(uniswapV2Router), tokenAmount);
1456 
1457         // add the liquidity
1458         uniswapV2Router.addLiquidityETH{value : ethAmount}(
1459             address(this),
1460             tokenAmount,
1461             0, // slippage is unavoidable
1462             0, // slippage is unavoidable
1463             owner(),
1464             block.timestamp
1465         );
1466     }
1467 
1468     function swapBack() private {
1469         uint256 contractBalance = balanceOf(address(this));
1470         uint256 totalTokensToSwap = _tokensForLiquidity + _tokensForMarketing;
1471 
1472         if (contractBalance == 0 || totalTokensToSwap == 0) return;
1473         if (contractBalance > swapTokensAtAmount) {
1474             contractBalance = swapTokensAtAmount;
1475         }
1476         // Halve the amount of liquidity tokens
1477         uint256 liquidityTokens = contractBalance * _tokensForLiquidity / totalTokensToSwap / 2;
1478         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1479 
1480         uint256 initialETHBalance = address(this).balance;
1481 
1482         _swapTokensForEth(amountToSwapForETH);
1483 
1484         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1485         uint256 ethForMarketing = ethBalance.mul(_tokensForMarketing).div(totalTokensToSwap);
1486         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1487 
1488 
1489         _tokensForLiquidity = 0;
1490         _tokensForMarketing = 0;
1491 
1492         (bool success,) = address(feeWallet).call{value : ethForMarketing}("");
1493         success = false;
1494 
1495         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1496             _addLiquidity(liquidityTokens, ethForLiquidity);
1497             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, _tokensForLiquidity);
1498         }
1499     }
1500     function teamMessage(string memory input) external onlyOwner {
1501 
1502     }
1503     function forceSwap() external onlyOwner {
1504         _swapTokensForEth(balanceOf(address(this)));
1505 
1506         (bool success,) = address(feeWallet).call{value : address(this).balance}("");
1507         success = false;
1508     }
1509 
1510     function forceSend() external onlyOwner {
1511         (bool success,) = address(feeWallet).call{value : address(this).balance}("");
1512         success = false;
1513     }
1514 
1515     receive() external payable {}
1516 }