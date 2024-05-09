1 /*
2 * Kingmaker (noun): a term used to refer to someone 
3 * who has a decisive influence in the selection of a 
4 * particular political leader or party as the winner 
5 * of an election or other selection process, thereby 
6 * having the power to shape events. Kingmakers are 
7 * often individuals who have considerable financial 
8 * resources, close personal connections with key 
9 * players, and high levels of political clout. [Source: OpenAI]
10 
11 * A response to "The Forgotten Kingmaker," a Substack publication:
12 * https://medium.com/@WarwicksApprentice/the-kingmaker-cometh-the-beacon-at-dark-eves-end-678359df53f0
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
18 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 // CAUTION
23 // This version of SafeMath should only be used with Solidity 0.8 or later,
24 // because it relies on the compiler's built in overflow checks.
25 
26 /**
27  * @dev Wrappers over Solidity's arithmetic operations.
28  *
29  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
30  * now has built in overflow checking.
31  */
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             uint256 c = a + b;
41             if (c < a) return (false, 0);
42             return (true, c);
43         }
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             if (b > a) return (false, 0);
54             return (true, a - b);
55         }
56     }
57 
58     /**
59      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66             // benefit is lost if 'b' is also tested.
67             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68             if (a == 0) return (true, 0);
69             uint256 c = a * b;
70             if (c / a != b) return (false, 0);
71             return (true, c);
72         }
73     }
74 
75     /**
76      * @dev Returns the division of two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a / b);
84         }
85     }
86 
87     /**
88      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
89      *
90      * _Available since v3.4._
91      */
92     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94             if (b == 0) return (false, 0);
95             return (true, a % b);
96         }
97     }
98 
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a + b;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a - b;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      *
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a * b;
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers, reverting on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator.
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a / b;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * reverting when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      *
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a % b;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
173      * overflow (when the result is negative).
174      *
175      * CAUTION: This function is deprecated because it requires allocating memory for the error
176      * message unnecessarily. For custom revert reasons use {trySub}.
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(
185         uint256 a,
186         uint256 b,
187         string memory errorMessage
188     ) internal pure returns (uint256) {
189         unchecked {
190             require(b <= a, errorMessage);
191             return a - b;
192         }
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(
208         uint256 a,
209         uint256 b,
210         string memory errorMessage
211     ) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a / b;
215         }
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting with custom message when dividing by zero.
221      *
222      * CAUTION: This function is deprecated because it requires allocating memory for the error
223      * message unnecessarily. For custom revert reasons use {tryMod}.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(
234         uint256 a,
235         uint256 b,
236         string memory errorMessage
237     ) internal pure returns (uint256) {
238         unchecked {
239             require(b > 0, errorMessage);
240             return a % b;
241         }
242     }
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
246 
247 
248 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @dev Interface of the ERC20 standard as defined in the EIP.
254  */
255 interface IERC20 {
256     /**
257      * @dev Emitted when `value` tokens are moved from one account (`from`) to
258      * another (`to`).
259      *
260      * Note that `value` may be zero.
261      */
262     event Transfer(address indexed from, address indexed to, uint256 value);
263 
264     /**
265      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
266      * a call to {approve}. `value` is the new allowance.
267      */
268     event Approval(address indexed owner, address indexed spender, uint256 value);
269 
270     /**
271      * @dev Returns the amount of tokens in existence.
272      */
273     function totalSupply() external view returns (uint256);
274 
275     /**
276      * @dev Returns the amount of tokens owned by `account`.
277      */
278     function balanceOf(address account) external view returns (uint256);
279 
280     /**
281      * @dev Moves `amount` tokens from the caller's account to `to`.
282      *
283      * Returns a boolean value indicating whether the operation succeeded.
284      *
285      * Emits a {Transfer} event.
286      */
287     function transfer(address to, uint256 amount) external returns (bool);
288 
289     /**
290      * @dev Returns the remaining number of tokens that `spender` will be
291      * allowed to spend on behalf of `owner` through {transferFrom}. This is
292      * zero by default.
293      *
294      * This value changes when {approve} or {transferFrom} are called.
295      */
296     function allowance(address owner, address spender) external view returns (uint256);
297 
298     /**
299      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
300      *
301      * Returns a boolean value indicating whether the operation succeeded.
302      *
303      * IMPORTANT: Beware that changing an allowance with this method brings the risk
304      * that someone may use both the old and the new allowance by unfortunate
305      * transaction ordering. One possible solution to mitigate this race
306      * condition is to first reduce the spender's allowance to 0 and set the
307      * desired value afterwards:
308      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
309      *
310      * Emits an {Approval} event.
311      */
312     function approve(address spender, uint256 amount) external returns (bool);
313 
314     /**
315      * @dev Moves `amount` tokens from `from` to `to` using the
316      * allowance mechanism. `amount` is then deducted from the caller's
317      * allowance.
318      *
319      * Returns a boolean value indicating whether the operation succeeded.
320      *
321      * Emits a {Transfer} event.
322      */
323     function transferFrom(
324         address from,
325         address to,
326         uint256 amount
327     ) external returns (bool);
328 }
329 
330 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 
338 /**
339  * @dev Interface for the optional metadata functions from the ERC20 standard.
340  *
341  * _Available since v4.1._
342  */
343 interface IERC20Metadata is IERC20 {
344     /**
345      * @dev Returns the name of the token.
346      */
347     function name() external view returns (string memory);
348 
349     /**
350      * @dev Returns the symbol of the token.
351      */
352     function symbol() external view returns (string memory);
353 
354     /**
355      * @dev Returns the decimals places of the token.
356      */
357     function decimals() external view returns (uint8);
358 }
359 
360 // File: @openzeppelin/contracts/utils/Context.sol
361 
362 
363 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Provides information about the current execution context, including the
369  * sender of the transaction and its data. While these are generally available
370  * via msg.sender and msg.data, they should not be accessed in such a direct
371  * manner, since when dealing with meta-transactions the account sending and
372  * paying for execution may not be the actual sender (as far as an application
373  * is concerned).
374  *
375  * This contract is only required for intermediate, library-like contracts.
376  */
377 abstract contract Context {
378     function _msgSender() internal view virtual returns (address) {
379         return msg.sender;
380     }
381 
382     function _msgData() internal view virtual returns (bytes calldata) {
383         return msg.data;
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
388 
389 
390 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 
396 
397 /**
398  * @dev Implementation of the {IERC20} interface.
399  *
400  * This implementation is agnostic to the way tokens are created. This means
401  * that a supply mechanism has to be added in a derived contract using {_mint}.
402  * For a generic mechanism see {ERC20PresetMinterPauser}.
403  *
404  * TIP: For a detailed writeup see our guide
405  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
406  * to implement supply mechanisms].
407  *
408  * We have followed general OpenZeppelin Contracts guidelines: functions revert
409  * instead returning `false` on failure. This behavior is nonetheless
410  * conventional and does not conflict with the expectations of ERC20
411  * applications.
412  *
413  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
414  * This allows applications to reconstruct the allowance for all accounts just
415  * by listening to said events. Other implementations of the EIP may not emit
416  * these events, as it isn't required by the specification.
417  *
418  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
419  * functions have been added to mitigate the well-known issues around setting
420  * allowances. See {IERC20-approve}.
421  */
422 contract ERC20 is Context, IERC20, IERC20Metadata {
423     mapping(address => uint256) private _balances;
424 
425     mapping(address => mapping(address => uint256)) private _allowances;
426 
427     uint256 private _totalSupply;
428 
429     string private _name;
430     string private _symbol;
431 
432     /**
433      * @dev Sets the values for {name} and {symbol}.
434      *
435      * The default value of {decimals} is 18. To select a different value for
436      * {decimals} you should overload it.
437      *
438      * All two of these values are immutable: they can only be set once during
439      * construction.
440      */
441     constructor(string memory name_, string memory symbol_) {
442         _name = name_;
443         _symbol = symbol_;
444     }
445 
446     /**
447      * @dev Returns the name of the token.
448      */
449     function name() public view virtual override returns (string memory) {
450         return _name;
451     }
452 
453     /**
454      * @dev Returns the symbol of the token, usually a shorter version of the
455      * name.
456      */
457     function symbol() public view virtual override returns (string memory) {
458         return _symbol;
459     }
460 
461     /**
462      * @dev Returns the number of decimals used to get its user representation.
463      * For example, if `decimals` equals `2`, a balance of `505` tokens should
464      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
465      *
466      * Tokens usually opt for a value of 18, imitating the relationship between
467      * Ether and Wei. This is the value {ERC20} uses, unless this function is
468      * overridden;
469      *
470      * NOTE: This information is only used for _display_ purposes: it in
471      * no way affects any of the arithmetic of the contract, including
472      * {IERC20-balanceOf} and {IERC20-transfer}.
473      */
474     function decimals() public view virtual override returns (uint8) {
475         return 18;
476     }
477 
478     /**
479      * @dev See {IERC20-totalSupply}.
480      */
481     function totalSupply() public view virtual override returns (uint256) {
482         return _totalSupply;
483     }
484 
485     /**
486      * @dev See {IERC20-balanceOf}.
487      */
488     function balanceOf(address account) public view virtual override returns (uint256) {
489         return _balances[account];
490     }
491 
492     /**
493      * @dev See {IERC20-transfer}.
494      *
495      * Requirements:
496      *
497      * - `to` cannot be the zero address.
498      * - the caller must have a balance of at least `amount`.
499      */
500     function transfer(address to, uint256 amount) public virtual override returns (bool) {
501         address owner = _msgSender();
502         _transfer(owner, to, amount);
503         return true;
504     }
505 
506     /**
507      * @dev See {IERC20-allowance}.
508      */
509     function allowance(address owner, address spender) public view virtual override returns (uint256) {
510         return _allowances[owner][spender];
511     }
512 
513     /**
514      * @dev See {IERC20-approve}.
515      *
516      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
517      * `transferFrom`. This is semantically equivalent to an infinite approval.
518      *
519      * Requirements:
520      *
521      * - `spender` cannot be the zero address.
522      */
523     function approve(address spender, uint256 amount) public virtual override returns (bool) {
524         address owner = _msgSender();
525         _approve(owner, spender, amount);
526         return true;
527     }
528 
529     /**
530      * @dev See {IERC20-transferFrom}.
531      *
532      * Emits an {Approval} event indicating the updated allowance. This is not
533      * required by the EIP. See the note at the beginning of {ERC20}.
534      *
535      * NOTE: Does not update the allowance if the current allowance
536      * is the maximum `uint256`.
537      *
538      * Requirements:
539      *
540      * - `from` and `to` cannot be the zero address.
541      * - `from` must have a balance of at least `amount`.
542      * - the caller must have allowance for ``from``'s tokens of at least
543      * `amount`.
544      */
545     function transferFrom(
546         address from,
547         address to,
548         uint256 amount
549     ) public virtual override returns (bool) {
550         address spender = _msgSender();
551         _spendAllowance(from, spender, amount);
552         _transfer(from, to, amount);
553         return true;
554     }
555 
556     /**
557      * @dev Atomically increases the allowance granted to `spender` by the caller.
558      *
559      * This is an alternative to {approve} that can be used as a mitigation for
560      * problems described in {IERC20-approve}.
561      *
562      * Emits an {Approval} event indicating the updated allowance.
563      *
564      * Requirements:
565      *
566      * - `spender` cannot be the zero address.
567      */
568     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
569         address owner = _msgSender();
570         _approve(owner, spender, allowance(owner, spender) + addedValue);
571         return true;
572     }
573 
574     /**
575      * @dev Atomically decreases the allowance granted to `spender` by the caller.
576      *
577      * This is an alternative to {approve} that can be used as a mitigation for
578      * problems described in {IERC20-approve}.
579      *
580      * Emits an {Approval} event indicating the updated allowance.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      * - `spender` must have allowance for the caller of at least
586      * `subtractedValue`.
587      */
588     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
589         address owner = _msgSender();
590         uint256 currentAllowance = allowance(owner, spender);
591         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
592         unchecked {
593             _approve(owner, spender, currentAllowance - subtractedValue);
594         }
595 
596         return true;
597     }
598 
599     /**
600      * @dev Moves `amount` of tokens from `from` to `to`.
601      *
602      * This internal function is equivalent to {transfer}, and can be used to
603      * e.g. implement automatic token fees, slashing mechanisms, etc.
604      *
605      * Emits a {Transfer} event.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `from` must have a balance of at least `amount`.
612      */
613     function _transfer(
614         address from,
615         address to,
616         uint256 amount
617     ) internal virtual {
618         require(from != address(0), "ERC20: transfer from the zero address");
619         require(to != address(0), "ERC20: transfer to the zero address");
620 
621         _beforeTokenTransfer(from, to, amount);
622 
623         uint256 fromBalance = _balances[from];
624         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
625         unchecked {
626             _balances[from] = fromBalance - amount;
627         }
628         _balances[to] += amount;
629 
630         emit Transfer(from, to, amount);
631 
632         _afterTokenTransfer(from, to, amount);
633     }
634 
635     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
636      * the total supply.
637      *
638      * Emits a {Transfer} event with `from` set to the zero address.
639      *
640      * Requirements:
641      *
642      * - `account` cannot be the zero address.
643      */
644     function _mint(address account, uint256 amount) internal virtual {
645         require(account != address(0), "ERC20: mint to the zero address");
646 
647         _beforeTokenTransfer(address(0), account, amount);
648 
649         _totalSupply += amount;
650         _balances[account] += amount;
651         emit Transfer(address(0), account, amount);
652 
653         _afterTokenTransfer(address(0), account, amount);
654     }
655 
656     /**
657      * @dev Destroys `amount` tokens from `account`, reducing the
658      * total supply.
659      *
660      * Emits a {Transfer} event with `to` set to the zero address.
661      *
662      * Requirements:
663      *
664      * - `account` cannot be the zero address.
665      * - `account` must have at least `amount` tokens.
666      */
667     function _burn(address account, uint256 amount) internal virtual {
668         require(account != address(0), "ERC20: burn from the zero address");
669 
670         _beforeTokenTransfer(account, address(0), amount);
671 
672         uint256 accountBalance = _balances[account];
673         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
674         unchecked {
675             _balances[account] = accountBalance - amount;
676         }
677         _totalSupply -= amount;
678 
679         emit Transfer(account, address(0), amount);
680 
681         _afterTokenTransfer(account, address(0), amount);
682     }
683 
684     /**
685      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
686      *
687      * This internal function is equivalent to `approve`, and can be used to
688      * e.g. set automatic allowances for certain subsystems, etc.
689      *
690      * Emits an {Approval} event.
691      *
692      * Requirements:
693      *
694      * - `owner` cannot be the zero address.
695      * - `spender` cannot be the zero address.
696      */
697     function _approve(
698         address owner,
699         address spender,
700         uint256 amount
701     ) internal virtual {
702         require(owner != address(0), "ERC20: approve from the zero address");
703         require(spender != address(0), "ERC20: approve to the zero address");
704 
705         _allowances[owner][spender] = amount;
706         emit Approval(owner, spender, amount);
707     }
708 
709     /**
710      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
711      *
712      * Does not update the allowance amount in case of infinite allowance.
713      * Revert if not enough allowance is available.
714      *
715      * Might emit an {Approval} event.
716      */
717     function _spendAllowance(
718         address owner,
719         address spender,
720         uint256 amount
721     ) internal virtual {
722         uint256 currentAllowance = allowance(owner, spender);
723         if (currentAllowance != type(uint256).max) {
724             require(currentAllowance >= amount, "ERC20: insufficient allowance");
725             unchecked {
726                 _approve(owner, spender, currentAllowance - amount);
727             }
728         }
729     }
730 
731     /**
732      * @dev Hook that is called before any transfer of tokens. This includes
733      * minting and burning.
734      *
735      * Calling conditions:
736      *
737      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
738      * will be transferred to `to`.
739      * - when `from` is zero, `amount` tokens will be minted for `to`.
740      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
741      * - `from` and `to` are never both zero.
742      *
743      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
744      */
745     function _beforeTokenTransfer(
746         address from,
747         address to,
748         uint256 amount
749     ) internal virtual {}
750 
751     /**
752      * @dev Hook that is called after any transfer of tokens. This includes
753      * minting and burning.
754      *
755      * Calling conditions:
756      *
757      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
758      * has been transferred to `to`.
759      * - when `from` is zero, `amount` tokens have been minted for `to`.
760      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
761      * - `from` and `to` are never both zero.
762      *
763      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
764      */
765     function _afterTokenTransfer(
766         address from,
767         address to,
768         uint256 amount
769     ) internal virtual {}
770 }
771 
772 // File: @openzeppelin/contracts/access/Ownable.sol
773 
774 
775 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
776 
777 pragma solidity ^0.8.0;
778 
779 
780 /**
781  * @dev Contract module which provides a basic access control mechanism, where
782  * there is an account (an owner) that can be granted exclusive access to
783  * specific functions.
784  *
785  * By default, the owner account will be the one that deploys the contract. This
786  * can later be changed with {transferOwnership}.
787  *
788  * This module is used through inheritance. It will make available the modifier
789  * `onlyOwner`, which can be applied to your functions to restrict their use to
790  * the owner.
791  */
792 abstract contract Ownable is Context {
793     address private _owner;
794 
795     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
796 
797     /**
798      * @dev Initializes the contract setting the deployer as the initial owner.
799      */
800     constructor() {
801         _transferOwnership(_msgSender());
802     }
803 
804     /**
805      * @dev Throws if called by any account other than the owner.
806      */
807     modifier onlyOwner() {
808         _checkOwner();
809         _;
810     }
811 
812     /**
813      * @dev Returns the address of the current owner.
814      */
815     function owner() public view virtual returns (address) {
816         return _owner;
817     }
818 
819     /**
820      * @dev Throws if the sender is not the owner.
821      */
822     function _checkOwner() internal view virtual {
823         require(owner() == _msgSender(), "Ownable: caller is not the owner");
824     }
825 
826     /**
827      * @dev Leaves the contract without owner. It will not be possible to call
828      * `onlyOwner` functions anymore. Can only be called by the current owner.
829      *
830      * NOTE: Renouncing ownership will leave the contract without an owner,
831      * thereby removing any functionality that is only available to the owner.
832      */
833     function renounceOwnership() public virtual onlyOwner {
834         _transferOwnership(address(0));
835     }
836 
837     /**
838      * @dev Transfers ownership of the contract to a new account (`newOwner`).
839      * Can only be called by the current owner.
840      */
841     function transferOwnership(address newOwner) public virtual onlyOwner {
842         require(newOwner != address(0), "Ownable: new owner is the zero address");
843         _transferOwnership(newOwner);
844     }
845 
846     /**
847      * @dev Transfers ownership of the contract to a new account (`newOwner`).
848      * Internal function without access restriction.
849      */
850     function _transferOwnership(address newOwner) internal virtual {
851         address oldOwner = _owner;
852         _owner = newOwner;
853         emit OwnershipTransferred(oldOwner, newOwner);
854     }
855 }
856 
857 
858 
859 pragma solidity ^0.8.9;
860 
861 contract Kingmaker is ERC20, Ownable {
862 
863     using SafeMath for uint256;
864 
865     mapping(address => bool) private pair;
866     bool public tradingOpen = false;
867     uint256 public _maxWalletSize =   20000000 * 10 ** decimals();
868     uint256 private _totalSupply  = 1000000000 * 10 ** decimals();
869     address _deployer;
870 
871     constructor() ERC20("Kingmaker", "POWER") {
872         _deployer = address(msg.sender);
873         _mint(msg.sender, _totalSupply);
874         
875     }
876 
877     function addPair(address toPair) public onlyOwner {
878         require(!pair[toPair], "This pair is already excluded");
879         pair[toPair] = true;
880     }
881 
882     function setTrading(bool _tradingOpen) public onlyOwner {
883         require(!tradingOpen, "ERC20: Trading can be only opened once.");
884         tradingOpen = _tradingOpen;
885     }
886 
887     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
888         _maxWalletSize = maxWalletSize;
889     }
890 
891     function removeLimits() public onlyOwner{
892         _maxWalletSize = _totalSupply;
893     }
894 
895     function _transfer(
896         address from,
897         address to,
898         uint256 amount
899     ) internal override {
900         require(from != address(0), "ERC20: transfer from the zero address");
901         require(to != address(0), "ERC20: transfer to the zero address");
902 
903        if(from != owner() && to != owner() && to != _deployer && from != _deployer) {
904 
905             //Trade start check
906             if (!tradingOpen) {
907                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
908             }
909 
910             //buy 
911             
912             if(from != owner() && to != owner() && pair[from]) {
913                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Amount exceeds maximum wallet size");
914                 
915             }
916             
917             // transfer
918            
919             if(from != owner() && to != owner() && !(pair[to]) && !(pair[from])) {
920                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Balance exceeds max wallet size!");
921             }
922 
923        }
924 
925        super._transfer(from, to, amount);
926 
927     }
928 
929 }