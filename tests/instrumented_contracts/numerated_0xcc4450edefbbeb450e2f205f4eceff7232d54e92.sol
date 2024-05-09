1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5  *
6  * THE GUEST LIST (TGL)
7  *
8  * The Telegram community for this project is at: https://t.me/theguestlistTGL
9  *
10  * The Guest List (TGL) is a new platform that aims to overhaul the “shitcoin” space by linking top-quality 
11  * start-up projects with higher quality investors. 
12  *
13  * Our custom-built blockchain technology tracks users’ on-chain behaviour and produces a scoring system 
14  * that - if high enough - gives said users the option to buy into the private sales of the biggest 
15  * new crypto launches available.  
16  *
17  * The higher your score, the more access you get to the best private sales – the lower your score, 
18  * SORRY you’re not getting on “The Guest List.”  
19  *
20  * Connecting the best new projects to solid “diamond hand” investors.
21  * A match made in crypto heaven. 
22  *
23  * The Twitter account for this project is: @theguestlistTGL
24  *
25  */ 
26 
27 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
28 
29 /**
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor() {
72         _transferOwnership(_msgSender());
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         _checkOwner();
80         _;
81     }
82 
83     /**
84      * @dev Returns the address of the current owner.
85      */
86     function owner() public view virtual returns (address) {
87         return _owner;
88     }
89 
90     /**
91      * @dev Throws if the sender is not the owner.
92      */
93     function _checkOwner() internal view virtual {
94         require(owner() == _msgSender(), "Ownable: caller is not the owner");
95     }
96 
97     /**
98      * @dev Leaves the contract without owner. It will not be possible to call
99      * `onlyOwner` functions anymore. Can only be called by the current owner.
100      *
101      * NOTE: Renouncing ownership will leave the contract without an owner,
102      * thereby removing any functionality that is only available to the owner.
103      */
104     function renounceOwnership() public virtual onlyOwner {
105         _transferOwnership(address(0));
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Can only be called by the current owner.
111      */
112     function transferOwnership(address newOwner) public virtual onlyOwner {
113         require(newOwner != address(0), "Ownable: new owner is the zero address");
114         _transferOwnership(newOwner);
115     }
116 
117     /**
118      * @dev Transfers ownership of the contract to a new account (`newOwner`).
119      * Internal function without access restriction.
120      */
121     function _transferOwnership(address newOwner) internal virtual {
122         address oldOwner = _owner;
123         _owner = newOwner;
124         emit OwnershipTransferred(oldOwner, newOwner);
125     }
126 }
127 
128 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
129 
130 /**
131  * @dev Interface of the ERC20 standard as defined in the EIP.
132  */
133 interface IERC20 {
134     /**
135      * @dev Emitted when `value` tokens are moved from one account (`from`) to
136      * another (`to`).
137      *
138      * Note that `value` may be zero.
139      */
140     event Transfer(address indexed from, address indexed to, uint value);
141 
142     /**
143      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
144      * a call to {approve}. `value` is the new allowance.
145      */
146     event Approval(address indexed owner, address indexed spender, uint value);
147 
148     /**
149      * @dev Returns the amount of tokens in existence.
150      */
151     function totalSupply() external view returns (uint);
152 
153     /**
154      * @dev Returns the amount of tokens owned by `account`.
155      */
156     function balanceOf(address account) external view returns (uint);
157 
158     /**
159      * @dev Moves `amount` tokens from the caller's account to `to`.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transfer(address to, uint amount) external returns (bool);
166 
167     /**
168      * @dev Returns the remaining number of tokens that `spender` will be
169      * allowed to spend on behalf of `owner` through {transferFrom}. This is
170      * zero by default.
171      *
172      * This value changes when {approve} or {transferFrom} are called.
173      */
174     function allowance(address owner, address spender) external view returns (uint);
175 
176     /**
177      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * IMPORTANT: Beware that changing an allowance with this method brings the risk
182      * that someone may use both the old and the new allowance by unfortunate
183      * transaction ordering. One possible solution to mitigate this race
184      * condition is to first reduce the spender's allowance to 0 and set the
185      * desired value afterwards:
186      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187      *
188      * Emits an {Approval} event.
189      */
190     function approve(address spender, uint amount) external returns (bool);
191 
192     /**
193      * @dev Moves `amount` tokens from `from` to `to` using the
194      * allowance mechanism. `amount` is then deducted from the caller's
195      * allowance.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transferFrom(
202         address from,
203         address to,
204         uint amount
205     ) external returns (bool);
206 }
207 
208 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
209 
210 /**
211  * @dev Interface for the optional metadata functions from the ERC20 standard.
212  *
213  * _Available since v4.1._
214  */
215 interface IERC20Metadata is IERC20 {
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the symbol of the token.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the decimals places of the token.
228      */
229     function decimals() external view returns (uint8);
230 }
231 
232 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
233 
234 /**
235  * @dev Implementation of the {IERC20} interface.
236  *
237  * This implementation is agnostic to the way tokens are created. This means
238  * that a supply mechanism has to be added in a derived contract using {_mint}.
239  * For a generic mechanism see {ERC20PresetMinterPauser}.
240  *
241  * TIP: For a detailed writeup see our guide
242  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
243  * to implement supply mechanisms].
244  *
245  * We have followed general OpenZeppelin Contracts guidelines: functions revert
246  * instead returning `false` on failure. This behavior is nonetheless
247  * conventional and does not conflict with the expectations of ERC20
248  * applications.
249  *
250  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
251  * This allows applications to reconstruct the allowance for all accounts just
252  * by listening to said events. Other implementations of the EIP may not emit
253  * these events, as it isn't required by the specification.
254  *
255  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
256  * functions have been added to mitigate the well-known issues around setting
257  * allowances. See {IERC20-approve}.
258  */
259 contract ERC20 is Context, IERC20, IERC20Metadata {
260     mapping(address => uint) private _balances;
261 
262     mapping(address => mapping(address => uint)) private _allowances;
263 
264     uint private _totalSupply;
265 
266     string private _name;
267     string private _symbol;
268 
269     /**
270      * @dev Sets the values for {name} and {symbol}.
271      *
272      * The default value of {decimals} is 18. To select a different value for
273      * {decimals} you should overload it.
274      *
275      * All two of these values are immutable: they can only be set once during
276      * construction.
277      */
278     constructor(string memory name_, string memory symbol_) {
279         _name = name_;
280         _symbol = symbol_;
281     }
282 
283     /**
284      * @dev Returns the name of the token.
285      */
286     function name() public view virtual override returns (string memory) {
287         return _name;
288     }
289 
290     /**
291      * @dev Returns the symbol of the token, usually a shorter version of the
292      * name.
293      */
294     function symbol() public view virtual override returns (string memory) {
295         return _symbol;
296     }
297 
298     /**
299      * @dev Returns the number of decimals used to get its user representation.
300      * For example, if `decimals` equals `2`, a balance of `505` tokens should
301      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
302      *
303      * Tokens usually opt for a value of 18, imitating the relationship between
304      * Ether and Wei. This is the value {ERC20} uses, unless this function is
305      * overridden;
306      *
307      * NOTE: This information is only used for _display_ purposes: it in
308      * no way affects any of the arithmetic of the contract, including
309      * {IERC20-balanceOf} and {IERC20-transfer}.
310      */
311     function decimals() public view virtual override returns (uint8) {
312         return 18;
313     }
314 
315     /**
316      * @dev See {IERC20-totalSupply}.
317      */
318     function totalSupply() public view virtual override returns (uint) {
319         return _totalSupply;
320     }
321 
322     /**
323      * @dev See {IERC20-balanceOf}.
324      */
325     function balanceOf(address account) public view virtual override returns (uint) {
326         return _balances[account];
327     }
328 
329     /**
330      * @dev See {IERC20-transfer}.
331      *
332      * Requirements:
333      *
334      * - `to` cannot be the zero address.
335      * - the caller must have a balance of at least `amount`.
336      */
337     function transfer(address to, uint amount) public virtual override returns (bool) {
338         address owner = _msgSender();
339         _transfer(owner, to, amount);
340         return true;
341     }
342 
343     /**
344      * @dev See {IERC20-allowance}.
345      */
346     function allowance(address owner, address spender) public view virtual override returns (uint) {
347         return _allowances[owner][spender];
348     }
349 
350     /**
351      * @dev See {IERC20-approve}.
352      *
353      * NOTE: If `amount` is the maximum `uint`, the allowance is not updated on
354      * `transferFrom`. This is semantically equivalent to an infinite approval.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function approve(address spender, uint amount) public virtual override returns (bool) {
361         address owner = _msgSender();
362         _approve(owner, spender, amount);
363         return true;
364     }
365 
366     /**
367      * @dev See {IERC20-transferFrom}.
368      *
369      * Emits an {Approval} event indicating the updated allowance. This is not
370      * required by the EIP. See the note at the beginning of {ERC20}.
371      *
372      * NOTE: Does not update the allowance if the current allowance
373      * is the maximum `uint`.
374      *
375      * Requirements:
376      *
377      * - `from` and `to` cannot be the zero address.
378      * - `from` must have a balance of at least `amount`.
379      * - the caller must have allowance for ``from``'s tokens of at least
380      * `amount`.
381      */
382     function transferFrom(
383         address from,
384         address to,
385         uint amount
386     ) public virtual override returns (bool) {
387         address spender = _msgSender();
388         _spendAllowance(from, spender, amount);
389         _transfer(from, to, amount);
390         return true;
391     }
392 
393     /**
394      * @dev Atomically increases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      */
405     function increaseAllowance(address spender, uint addedValue) public virtual returns (bool) {
406         address owner = _msgSender();
407         _approve(owner, spender, allowance(owner, spender) + addedValue);
408         return true;
409     }
410 
411     /**
412      * @dev Atomically decreases the allowance granted to `spender` by the caller.
413      *
414      * This is an alternative to {approve} that can be used as a mitigation for
415      * problems described in {IERC20-approve}.
416      *
417      * Emits an {Approval} event indicating the updated allowance.
418      *
419      * Requirements:
420      *
421      * - `spender` cannot be the zero address.
422      * - `spender` must have allowance for the caller of at least
423      * `subtractedValue`.
424      */
425     function decreaseAllowance(address spender, uint subtractedValue) public virtual returns (bool) {
426         address owner = _msgSender();
427         uint currentAllowance = allowance(owner, spender);
428         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
429         unchecked {
430             _approve(owner, spender, currentAllowance - subtractedValue);
431         }
432 
433         return true;
434     }
435 
436     /**
437      * @dev Moves `amount` of tokens from `from` to `to`.
438      *
439      * This internal function is equivalent to {transfer}, and can be used to
440      * e.g. implement automatic token fees, slashing mechanisms, etc.
441      *
442      * Emits a {Transfer} event.
443      *
444      * Requirements:
445      *
446      * - `from` cannot be the zero address.
447      * - `to` cannot be the zero address.
448      * - `from` must have a balance of at least `amount`.
449      */
450     function _transfer(
451         address from,
452         address to,
453         uint amount
454     ) internal virtual {
455         require(from != address(0), "ERC20: transfer from the zero address");
456         require(to != address(0), "ERC20: transfer to the zero address");
457 
458         _beforeTokenTransfer(from, to, amount);
459 
460         uint fromBalance = _balances[from];
461         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
462         unchecked {
463             _balances[from] = fromBalance - amount;
464             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
465             // decrementing then incrementing.
466             _balances[to] += amount;
467         }
468 
469         emit Transfer(from, to, amount);
470 
471         _afterTokenTransfer(from, to, amount);
472     }
473 
474     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
475      * the total supply.
476      *
477      * Emits a {Transfer} event with `from` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `account` cannot be the zero address.
482      */
483     function _mint(address account, uint amount) internal virtual {
484         require(account != address(0), "ERC20: mint to the zero address");
485 
486         _beforeTokenTransfer(address(0), account, amount);
487 
488         _totalSupply += amount;
489         unchecked {
490             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
491             _balances[account] += amount;
492         }
493         emit Transfer(address(0), account, amount);
494 
495         _afterTokenTransfer(address(0), account, amount);
496     }
497 
498     /**
499      * @dev Destroys `amount` tokens from `account`, reducing the
500      * total supply.
501      *
502      * Emits a {Transfer} event with `to` set to the zero address.
503      *
504      * Requirements:
505      *
506      * - `account` cannot be the zero address.
507      * - `account` must have at least `amount` tokens.
508      */
509     function _burn(address account, uint amount) internal virtual {
510         require(account != address(0), "ERC20: burn from the zero address");
511 
512         _beforeTokenTransfer(account, address(0), amount);
513 
514         uint accountBalance = _balances[account];
515         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
516         unchecked {
517             _balances[account] = accountBalance - amount;
518             // Overflow not possible: amount <= accountBalance <= totalSupply.
519             _totalSupply -= amount;
520         }
521 
522         emit Transfer(account, address(0), amount);
523 
524         _afterTokenTransfer(account, address(0), amount);
525     }
526 
527     /**
528      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
529      *
530      * This internal function is equivalent to `approve`, and can be used to
531      * e.g. set automatic allowances for certain subsystems, etc.
532      *
533      * Emits an {Approval} event.
534      *
535      * Requirements:
536      *
537      * - `owner` cannot be the zero address.
538      * - `spender` cannot be the zero address.
539      */
540     function _approve(
541         address owner,
542         address spender,
543         uint amount
544     ) internal virtual {
545         require(owner != address(0), "ERC20: approve from the zero address");
546         require(spender != address(0), "ERC20: approve to the zero address");
547 
548         _allowances[owner][spender] = amount;
549         emit Approval(owner, spender, amount);
550     }
551 
552     /**
553      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
554      *
555      * Does not update the allowance amount in case of infinite allowance.
556      * Revert if not enough allowance is available.
557      *
558      * Might emit an {Approval} event.
559      */
560     function _spendAllowance(
561         address owner,
562         address spender,
563         uint amount
564     ) internal virtual {
565         uint currentAllowance = allowance(owner, spender);
566         if (currentAllowance != type(uint).max) {
567             require(currentAllowance >= amount, "ERC20: insufficient allowance");
568             unchecked {
569                 _approve(owner, spender, currentAllowance - amount);
570             }
571         }
572     }
573 
574     /**
575      * @dev Hook that is called before any transfer of tokens. This includes
576      * minting and burning.
577      *
578      * Calling conditions:
579      *
580      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
581      * will be transferred to `to`.
582      * - when `from` is zero, `amount` tokens will be minted for `to`.
583      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
584      * - `from` and `to` are never both zero.
585      *
586      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
587      */
588     function _beforeTokenTransfer(
589         address from,
590         address to,
591         uint amount
592     ) internal virtual {}
593 
594     /**
595      * @dev Hook that is called after any transfer of tokens. This includes
596      * minting and burning.
597      *
598      * Calling conditions:
599      *
600      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
601      * has been transferred to `to`.
602      * - when `from` is zero, `amount` tokens have been minted for `to`.
603      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
604      * - `from` and `to` are never both zero.
605      *
606      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
607      */
608     function _afterTokenTransfer(
609         address from,
610         address to,
611         uint amount
612     ) internal virtual {}
613 }
614 
615 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
616 
617 // CAUTION
618 // This version of SafeMath should only be used with Solidity 0.8 or later,
619 // because it relies on the compiler's built in overflow checks.
620 
621 /**
622  * @dev Wrappers over Solidity's arithmetic operations.
623  *
624  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
625  * now has built in overflow checking.
626  */
627 library SafeMath {
628     /**
629      * @dev Returns the addition of two unsigned integers, with an overflow flag.
630      *
631      * _Available since v3.4._
632      */
633     function tryAdd(uint a, uint b) internal pure returns (bool, uint) {
634         unchecked {
635             uint c = a + b;
636             if (c < a) return (false, 0);
637             return (true, c);
638         }
639     }
640 
641     /**
642      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
643      *
644      * _Available since v3.4._
645      */
646     function trySub(uint a, uint b) internal pure returns (bool, uint) {
647         unchecked {
648             if (b > a) return (false, 0);
649             return (true, a - b);
650         }
651     }
652 
653     /**
654      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
655      *
656      * _Available since v3.4._
657      */
658     function tryMul(uint a, uint b) internal pure returns (bool, uint) {
659         unchecked {
660             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
661             // benefit is lost if 'b' is also tested.
662             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
663             if (a == 0) return (true, 0);
664             uint c = a * b;
665             if (c / a != b) return (false, 0);
666             return (true, c);
667         }
668     }
669 
670     /**
671      * @dev Returns the division of two unsigned integers, with a division by zero flag.
672      *
673      * _Available since v3.4._
674      */
675     function tryDiv(uint a, uint b) internal pure returns (bool, uint) {
676         unchecked {
677             if (b == 0) return (false, 0);
678             return (true, a / b);
679         }
680     }
681 
682     /**
683      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
684      *
685      * _Available since v3.4._
686      */
687     function tryMod(uint a, uint b) internal pure returns (bool, uint) {
688         unchecked {
689             if (b == 0) return (false, 0);
690             return (true, a % b);
691         }
692     }
693 
694     /**
695      * @dev Returns the addition of two unsigned integers, reverting on
696      * overflow.
697      *
698      * Counterpart to Solidity's `+` operator.
699      *
700      * Requirements:
701      *
702      * - Addition cannot overflow.
703      */
704     function add(uint a, uint b) internal pure returns (uint) {
705         return a + b;
706     }
707 
708     /**
709      * @dev Returns the subtraction of two unsigned integers, reverting on
710      * overflow (when the result is negative).
711      *
712      * Counterpart to Solidity's `-` operator.
713      *
714      * Requirements:
715      *
716      * - Subtraction cannot overflow.
717      */
718     function sub(uint a, uint b) internal pure returns (uint) {
719         return a - b;
720     }
721 
722     /**
723      * @dev Returns the multiplication of two unsigned integers, reverting on
724      * overflow.
725      *
726      * Counterpart to Solidity's `*` operator.
727      *
728      * Requirements:
729      *
730      * - Multiplication cannot overflow.
731      */
732     function mul(uint a, uint b) internal pure returns (uint) {
733         return a * b;
734     }
735 
736     /**
737      * @dev Returns the integer division of two unsigned integers, reverting on
738      * division by zero. The result is rounded towards zero.
739      *
740      * Counterpart to Solidity's `/` operator.
741      *
742      * Requirements:
743      *
744      * - The divisor cannot be zero.
745      */
746     function div(uint a, uint b) internal pure returns (uint) {
747         return a / b;
748     }
749 
750     /**
751      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
752      * reverting when dividing by zero.
753      *
754      * Counterpart to Solidity's `%` operator. This function uses a `revert`
755      * opcode (which leaves remaining gas untouched) while Solidity uses an
756      * invalid opcode to revert (consuming all remaining gas).
757      *
758      * Requirements:
759      *
760      * - The divisor cannot be zero.
761      */
762     function mod(uint a, uint b) internal pure returns (uint) {
763         return a % b;
764     }
765 
766     /**
767      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
768      * overflow (when the result is negative).
769      *
770      * CAUTION: This function is deprecated because it requires allocating memory for the error
771      * message unnecessarily. For custom revert reasons use {trySub}.
772      *
773      * Counterpart to Solidity's `-` operator.
774      *
775      * Requirements:
776      *
777      * - Subtraction cannot overflow.
778      */
779     function sub(
780         uint a,
781         uint b,
782         string memory errorMessage
783     ) internal pure returns (uint) {
784         unchecked {
785             require(b <= a, errorMessage);
786             return a - b;
787         }
788     }
789 
790     /**
791      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
792      * division by zero. The result is rounded towards zero.
793      *
794      * Counterpart to Solidity's `/` operator. Note: this function uses a
795      * `revert` opcode (which leaves remaining gas untouched) while Solidity
796      * uses an invalid opcode to revert (consuming all remaining gas).
797      *
798      * Requirements:
799      *
800      * - The divisor cannot be zero.
801      */
802     function div(
803         uint a,
804         uint b,
805         string memory errorMessage
806     ) internal pure returns (uint) {
807         unchecked {
808             require(b > 0, errorMessage);
809             return a / b;
810         }
811     }
812 
813     /**
814      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
815      * reverting with custom message when dividing by zero.
816      *
817      * CAUTION: This function is deprecated because it requires allocating memory for the error
818      * message unnecessarily. For custom revert reasons use {tryMod}.
819      *
820      * Counterpart to Solidity's `%` operator. This function uses a `revert`
821      * opcode (which leaves remaining gas untouched) while Solidity uses an
822      * invalid opcode to revert (consuming all remaining gas).
823      *
824      * Requirements:
825      *
826      * - The divisor cannot be zero.
827      */
828     function mod(
829         uint a,
830         uint b,
831         string memory errorMessage
832     ) internal pure returns (uint) {
833         unchecked {
834             require(b > 0, errorMessage);
835             return a % b;
836         }
837     }
838 }
839 
840 interface IUniswapV2Factory {
841     event PairCreated(
842         address indexed token0,
843         address indexed token1,
844         address pair,
845         uint
846     );
847 
848     function feeTo() external view returns (address);
849 
850     function feeToSetter() external view returns (address);
851 
852     function getPair(address tokenA, address tokenB)
853         external
854         view
855         returns (address pair);
856 
857     function allPairs(uint) external view returns (address pair);
858 
859     function allPairsLength() external view returns (uint);
860 
861     function createPair(address tokenA, address tokenB)
862         external
863         returns (address pair);
864 
865     function setFeeTo(address) external;
866 
867     function setFeeToSetter(address) external;
868 }
869 
870 interface IUniswapV2Pair {
871     event Approval(
872         address indexed owner,
873         address indexed spender,
874         uint value
875     );
876     event Transfer(address indexed from, address indexed to, uint value);
877 
878     function name() external pure returns (string memory);
879 
880     function symbol() external pure returns (string memory);
881 
882     function decimals() external pure returns (uint8);
883 
884     function totalSupply() external view returns (uint);
885 
886     function balanceOf(address owner) external view returns (uint);
887 
888     function allowance(address owner, address spender)
889         external
890         view
891         returns (uint);
892 
893     function approve(address spender, uint value) external returns (bool);
894 
895     function transfer(address to, uint value) external returns (bool);
896 
897     function transferFrom(
898         address from,
899         address to,
900         uint value
901     ) external returns (bool);
902 
903     function DOMAIN_SEPARATOR() external view returns (bytes32);
904 
905     function PERMIT_TYPEHASH() external pure returns (bytes32);
906 
907     function nonces(address owner) external view returns (uint);
908 
909     function permit(
910         address owner,
911         address spender,
912         uint value,
913         uint deadline,
914         uint8 v,
915         bytes32 r,
916         bytes32 s
917     ) external;
918 
919     event Mint(address indexed sender, uint amount0, uint amount1);
920     event Burn(
921         address indexed sender,
922         uint amount0,
923         uint amount1,
924         address indexed to
925     );
926     event Swap(
927         address indexed sender,
928         uint amount0In,
929         uint amount1In,
930         uint amount0Out,
931         uint amount1Out,
932         address indexed to
933     );
934     event Sync(uint112 reserve0, uint112 reserve1);
935 
936     function MINIMUM_LIQUIDITY() external pure returns (uint);
937 
938     function factory() external view returns (address);
939 
940     function token0() external view returns (address);
941 
942     function token1() external view returns (address);
943 
944     function getReserves()
945         external
946         view
947         returns (
948             uint112 reserve0,
949             uint112 reserve1,
950             uint32 blockTimestampLast
951         );
952 
953     function price0CumulativeLast() external view returns (uint);
954 
955     function price1CumulativeLast() external view returns (uint);
956 
957     function kLast() external view returns (uint);
958 
959     function mint(address to) external returns (uint liquidity);
960 
961     function burn(address to)
962         external
963         returns (uint amount0, uint amount1);
964 
965     function swap(
966         uint amount0Out,
967         uint amount1Out,
968         address to,
969         bytes calldata data
970     ) external;
971 
972     function skim(address to) external;
973 
974     function sync() external;
975 
976     function initialize(address, address) external;
977 }
978 
979 interface IUniswapV2Router02 {
980     function factory() external pure returns (address);
981 
982     function WETH() external pure returns (address);
983 
984     function addLiquidity(
985         address tokenA,
986         address tokenB,
987         uint amountADesired,
988         uint amountBDesired,
989         uint amountAMin,
990         uint amountBMin,
991         address to,
992         uint deadline
993     )
994         external
995         returns (
996             uint amountA,
997             uint amountB,
998             uint liquidity
999         );
1000 
1001     function addLiquidityETH(
1002         address token,
1003         uint amountTokenDesired,
1004         uint amountTokenMin,
1005         uint amountETHMin,
1006         address to,
1007         uint deadline
1008     )
1009         external
1010         payable
1011         returns (
1012             uint amountToken,
1013             uint amountETH,
1014             uint liquidity
1015         );
1016 
1017     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1018         uint amountIn,
1019         uint amountOutMin,
1020         address[] calldata path,
1021         address to,
1022         uint deadline
1023     ) external;
1024 
1025     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1026         uint amountOutMin,
1027         address[] calldata path,
1028         address to,
1029         uint deadline
1030     ) external payable;
1031 
1032     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1033         uint amountIn,
1034         uint amountOutMin,
1035         address[] calldata path,
1036         address to,
1037         uint deadline
1038     ) external;
1039 }
1040 
1041 interface ISwapManager {
1042     function swapToUsdc(uint tokenAmount) external;
1043     function addLiquidity(uint tokenAmount, uint usdcAmount) external;
1044 }
1045 
1046 contract TheGuestList is ERC20, Ownable {
1047     using SafeMath for uint;
1048 
1049     IUniswapV2Router02 public immutable uniswapV2Router;
1050     address public immutable uniswapV2Pair;
1051     address public constant deadAddress = address(0xdead);
1052     address public constant usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
1053 
1054     bool private swapping;
1055 
1056     address public marketingWallet;
1057     address public operationsWallet;
1058     address public teamWallet;
1059 
1060     ISwapManager public swapManager;
1061     uint public maxTransactionAmount;
1062     uint public swapTokensAtAmount;
1063     uint public maxWallet;
1064 
1065     bool public limitsInEffect = true;
1066     bool public tradingActive = false;
1067     bool public swapEnabled = false;
1068 
1069     // Anti-bot and anti-whale mappings and variables
1070     mapping(address => uint) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1071     bool public transferDelayEnabled = true;
1072 
1073     uint public buyTotalFees;
1074     uint public buyMarketingFee;
1075     uint public buyOperationsFee;
1076     uint public buyLiquidityFee;
1077     uint public buyTeamFee;
1078 
1079     uint public sellTotalFees;
1080     uint public sellMarketingFee;
1081     uint public sellOperationsFee;
1082     uint public sellLiquidityFee;
1083     uint public sellTeamFee;
1084 
1085     uint public tokensForMarketing;
1086     uint public tokensForOperations;
1087     uint public tokensForLiquidity;
1088     uint public tokensForTeam;
1089 
1090     // exlcude from fees and max transaction amount
1091     mapping(address => bool) private _isExcludedFromFees;
1092     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1093 
1094     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1095     // could be subject to a maximum transfer amount
1096     mapping(address => bool) public automatedMarketMakerPairs;
1097 
1098     event UpdateUniswapV2Router(
1099         address indexed newAddress,
1100         address indexed oldAddress
1101     );
1102 
1103     event ExcludeFromFees(address indexed account, bool isExcluded);
1104 
1105     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1106 
1107     event SwapManagerUpdated(
1108         address indexed newManager,
1109         address indexed oldManager
1110     );
1111 
1112     event MarketingWalletUpdated(
1113         address indexed newWallet,
1114         address indexed oldWallet
1115     );
1116 
1117     event OperationsWalletUpdated(
1118         address indexed newWallet,
1119         address indexed oldWallet
1120     );
1121 
1122     event TeamWalletUpdated(
1123         address indexed newWallet,
1124         address indexed oldWallet
1125     );
1126 
1127     event SwapAndLiquify(
1128         uint tokensSwapped,
1129         uint usdcReceived,
1130         uint tokensIntoLiquidity
1131     );
1132 
1133     constructor() ERC20("The Guest List", "TGL") {
1134         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1135 
1136         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1137         uniswapV2Router = _uniswapV2Router;
1138 
1139         address pair = IUniswapV2Factory(_uniswapV2Router.factory())
1140             .createPair(address(this), usdc);
1141             
1142         uniswapV2Pair = pair;
1143         excludeFromMaxTransaction(pair, true);
1144         _setAutomatedMarketMakerPair(pair, true);
1145 
1146         uint totalSupply = 100_000_000 * 1e18;
1147 
1148         maxTransactionAmount = totalSupply * 2 / 100;
1149         maxWallet = totalSupply * 3 / 100;
1150         swapTokensAtAmount = totalSupply * 5 / 1000;
1151 
1152         buyMarketingFee = 2;
1153         buyOperationsFee = 1;
1154         buyLiquidityFee = 1;
1155         buyTeamFee = 1;
1156         buyTotalFees = buyMarketingFee + buyOperationsFee + buyLiquidityFee + buyTeamFee;
1157 
1158         sellMarketingFee = 2;
1159         sellOperationsFee = 1;
1160         sellLiquidityFee = 1;
1161         sellTeamFee = 1;
1162         sellTotalFees = sellMarketingFee + sellOperationsFee + sellLiquidityFee + sellTeamFee;
1163 
1164         marketingWallet = address(0xdaE9Df2b8FB2aC249178CeA78ae7788153b1306e);
1165         operationsWallet = address(0xe964caB6efdB66395c2A81B375229A9403dc214b);
1166         teamWallet = address(0xa18a1b4D0b94800Ec69d0aD48a3112E3e57956B7);
1167 
1168         // exclude from paying fees or having max transaction amount
1169         excludeFromFees(owner(), true);
1170         excludeFromFees(address(this), true);
1171         excludeFromFees(deadAddress, true);
1172 
1173         excludeFromMaxTransaction(owner(), true);
1174         excludeFromMaxTransaction(address(this), true);
1175         excludeFromMaxTransaction(deadAddress, true);
1176 
1177         /*
1178             _mint is an internal function in ERC20.sol that is only called here,
1179             and CANNOT be called ever again
1180         */
1181         _mint(msg.sender, totalSupply);
1182     }
1183 
1184     // once enabled, can never be turned off
1185     function enableTrading() external onlyOwner {
1186         require (
1187             address(swapManager) != address(0), 
1188             "Need to set swap manager"
1189         );
1190         tradingActive = true;
1191         swapEnabled = true;
1192     }
1193 
1194     // remove limits after token is stable
1195     function removeLimits() external onlyOwner returns (bool) {
1196         limitsInEffect = false;
1197         return true;
1198     }
1199 
1200     // disable Transfer delay - cannot be reenabled
1201     function disableTransferDelay() external onlyOwner returns (bool) {
1202         transferDelayEnabled = false;
1203         return true;
1204     }
1205 
1206     // change the minimum amount of tokens to sell from fees
1207     function updateSwapTokensAtAmount(uint newAmount)
1208         external
1209         onlyOwner
1210         returns (bool)
1211     {
1212         require(
1213             newAmount >= (totalSupply() * 1) / 100000,
1214             "Swap amount cannot be lower than 0.001% total supply."
1215         );
1216         require(
1217             newAmount <= (totalSupply() * 5) / 1000,
1218             "Swap amount cannot be higher than 0.5% total supply."
1219         );
1220         swapTokensAtAmount = newAmount;
1221         return true;
1222     }
1223 
1224     function updateMaxTxnAmount(uint newNum) external onlyOwner {
1225         require(
1226             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1227             "Cannot set maxTransactionAmount lower than 0.1%"
1228         );
1229         maxTransactionAmount = newNum * (10**18);
1230     }
1231 
1232     function updateMaxWalletAmount(uint newNum) external onlyOwner {
1233         require(
1234             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1235             "Cannot set maxWallet lower than 0.5%"
1236         );
1237         maxWallet = newNum * (10**18);
1238     }
1239 
1240     function excludeFromMaxTransaction(address updAds, bool isEx)
1241         public
1242         onlyOwner
1243     {
1244         _isExcludedMaxTransactionAmount[updAds] = isEx;
1245     }
1246 
1247     function updateSwapManager(address newManager) external onlyOwner {
1248         emit SwapManagerUpdated(newManager, address(swapManager));
1249         swapManager = ISwapManager(newManager);
1250         excludeFromFees(newManager, true);
1251         excludeFromMaxTransaction(newManager, true);
1252     }
1253 
1254     // only use to disable contract sales if absolutely necessary (emergency use only)
1255     function updateSwapEnabled(bool enabled) external onlyOwner {
1256         swapEnabled = enabled;
1257     }
1258 
1259     function updateBuyFees(
1260         uint _marketingFee,
1261         uint _operationsFee,
1262         uint _liquidityFee,
1263         uint _teamFee
1264     ) external onlyOwner {
1265         buyMarketingFee = _marketingFee;
1266         buyOperationsFee = _operationsFee;
1267         buyLiquidityFee = _liquidityFee;
1268         buyTeamFee = _teamFee;
1269         buyTotalFees = buyMarketingFee + buyOperationsFee + buyLiquidityFee + buyTeamFee;
1270         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1271     }
1272 
1273     function updateSellFees(
1274         uint _marketingFee,
1275         uint _operationsFee,
1276         uint _liquidityFee,
1277         uint _teamFee
1278     ) external onlyOwner {
1279         sellMarketingFee = _marketingFee;
1280         sellOperationsFee = _operationsFee;
1281         sellLiquidityFee = _liquidityFee;
1282         sellTeamFee = _teamFee;
1283         sellTotalFees = sellMarketingFee + sellOperationsFee + sellLiquidityFee + sellTeamFee;
1284         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1285     }
1286 
1287     function excludeFromFees(address account, bool excluded) public onlyOwner {
1288         _isExcludedFromFees[account] = excluded;
1289         emit ExcludeFromFees(account, excluded);
1290     }
1291 
1292     function setAutomatedMarketMakerPair(address pair, bool value)
1293         public
1294         onlyOwner
1295     {
1296         require(
1297             pair != uniswapV2Pair,
1298             "The pair cannot be removed from automatedMarketMakerPairs"
1299         );
1300 
1301         _setAutomatedMarketMakerPair(pair, value);
1302     }
1303 
1304     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1305         automatedMarketMakerPairs[pair] = value;
1306 
1307         emit SetAutomatedMarketMakerPair(pair, value);
1308     }
1309 
1310     function updateMarketingWallet(address newMarketingWallet)
1311         external
1312         onlyOwner
1313     {
1314         emit MarketingWalletUpdated(newMarketingWallet, marketingWallet);
1315         marketingWallet = newMarketingWallet;
1316     }
1317 
1318     function updateOperationsWallet(address newOperationsWallet)
1319         external
1320         onlyOwner
1321     {
1322         emit OperationsWalletUpdated(newOperationsWallet, operationsWallet);
1323         operationsWallet = newOperationsWallet;
1324     }
1325 
1326     function updateTeamWallet(address newTeamWallet) external onlyOwner {
1327         emit TeamWalletUpdated(newTeamWallet, teamWallet);
1328         teamWallet = newTeamWallet;
1329     }
1330 
1331     function isExcludedFromFees(address account) public view returns (bool) {
1332         return _isExcludedFromFees[account];
1333     }
1334 
1335     function _transfer(
1336         address from,
1337         address to,
1338         uint amount
1339     ) internal override {
1340         require(from != address(0), "ERC20: transfer from the zero address");
1341         require(to != address(0), "ERC20: transfer to the zero address");
1342 
1343         if (amount == 0) {
1344             super._transfer(from, to, 0);
1345             return;
1346         }
1347 
1348         if (limitsInEffect) {
1349             if (
1350                 from != owner() &&
1351                 to != owner() &&
1352                 to != address(0) &&
1353                 to != address(0xdead) &&
1354                 !swapping
1355             ) {
1356                 if (!tradingActive) {
1357                     require(
1358                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1359                         "Trading is not active."
1360                     );
1361                 }
1362 
1363                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1364                 if (transferDelayEnabled) {
1365                     if (
1366                         to != owner() &&
1367                         to != address(uniswapV2Router) &&
1368                         to != address(uniswapV2Pair)
1369                     ) {
1370                         require(
1371                             _holderLastTransferTimestamp[tx.origin] <
1372                                 block.number,
1373                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1374                         );
1375                         _holderLastTransferTimestamp[tx.origin] = block.number;
1376                     }
1377                 }
1378 
1379                 //when buy
1380                 if (
1381                     automatedMarketMakerPairs[from] &&
1382                     !_isExcludedMaxTransactionAmount[to]
1383                 ) {
1384                     require(
1385                         amount <= maxTransactionAmount,
1386                         "Buy transfer amount exceeds the maxTransactionAmount."
1387                     );
1388                     require(
1389                         amount + balanceOf(to) <= maxWallet,
1390                         "Max wallet exceeded"
1391                     );
1392                 }
1393                 //when sell
1394                 else if (
1395                     automatedMarketMakerPairs[to] &&
1396                     !_isExcludedMaxTransactionAmount[from]
1397                 ) {
1398                     require(
1399                         amount <= maxTransactionAmount,
1400                         "Sell transfer amount exceeds the maxTransactionAmount."
1401                     );
1402                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1403                     require(
1404                         amount + balanceOf(to) <= maxWallet,
1405                         "Max wallet exceeded"
1406                     );
1407                 }
1408             }
1409         }
1410 
1411         uint contractTokenBalance = balanceOf(address(this));
1412 
1413         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1414 
1415         if (
1416             canSwap &&
1417             swapEnabled &&
1418             !swapping &&
1419             !automatedMarketMakerPairs[from] &&
1420             !_isExcludedFromFees[from] &&
1421             !_isExcludedFromFees[to]
1422         ) {
1423             swapping = true;
1424 
1425             swapBack();
1426 
1427             swapping = false;
1428         }
1429 
1430         bool takeFee = !swapping;
1431 
1432         // if any account belongs to _isExcludedFromFee account then remove the fee
1433         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1434             takeFee = false;
1435         }
1436 
1437         uint fees = 0;
1438         // only take fees on buys/sells, do not take on wallet transfers
1439         if (takeFee) {
1440             // on sell
1441             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1442                 fees = amount.mul(sellTotalFees).div(100);
1443                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1444                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
1445                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1446                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
1447                 
1448             }
1449             // on buy
1450             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1451                 fees = amount.mul(buyTotalFees).div(100);
1452                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1453                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
1454                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1455                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
1456             }
1457 
1458             if (fees > 0) {
1459                 super._transfer(from, address(this), fees);
1460             }
1461 
1462             amount -= fees;
1463         }
1464 
1465         super._transfer(from, to, amount);
1466     }
1467 
1468     function swapBack() private {
1469         uint contractBalance = balanceOf(address(this));
1470         uint totalTokensToSwap = tokensForMarketing +
1471             tokensForOperations +
1472             tokensForLiquidity +
1473             tokensForTeam;
1474 
1475         if (contractBalance == 0 || totalTokensToSwap == 0) {
1476             return;
1477         }
1478 
1479         if (contractBalance > swapTokensAtAmount * 20) {
1480             contractBalance = swapTokensAtAmount * 20;
1481         }
1482 
1483         // Halve the amount of liquidity tokens
1484         uint liquidityTokens = (contractBalance * tokensForLiquidity) /
1485             totalTokensToSwap / 2;
1486         uint amountToSwapForUsdc = contractBalance.sub(liquidityTokens);
1487 
1488         uint initialUsdcBalance = IERC20(usdc).balanceOf(address(this));
1489 
1490         _approve(address(this), address(swapManager), amountToSwapForUsdc);
1491         swapManager.swapToUsdc(amountToSwapForUsdc);
1492 
1493         uint usdcBalance = IERC20(usdc).balanceOf(address(this)).sub(initialUsdcBalance);
1494 
1495         uint usdcForMarketing = usdcBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1496         uint usdcForOperations = usdcBalance.mul(tokensForOperations).div(totalTokensToSwap);
1497         uint usdcForTeam = usdcBalance.mul(tokensForTeam).div(totalTokensToSwap);
1498         uint usdcForLiquidity = usdcBalance - usdcForMarketing - usdcForOperations - usdcForTeam;
1499 
1500         tokensForMarketing = 0;
1501         tokensForOperations = 0;
1502         tokensForLiquidity = 0;
1503         tokensForTeam = 0;
1504 
1505         IERC20(usdc).transfer(marketingWallet, usdcForMarketing);
1506         IERC20(usdc).transfer(operationsWallet, usdcForOperations);
1507 
1508         if (liquidityTokens > 0 && usdcForLiquidity > 0) {
1509             _approve(address(this), address(swapManager), liquidityTokens);
1510             IERC20(usdc).approve(address(swapManager), usdcForLiquidity);
1511 
1512             swapManager.addLiquidity(liquidityTokens, usdcForLiquidity);
1513             emit SwapAndLiquify(
1514                 amountToSwapForUsdc,
1515                 usdcForLiquidity,
1516                 tokensForLiquidity
1517             );
1518         }
1519 
1520         IERC20(usdc).transfer(teamWallet, IERC20(usdc).balanceOf(address(this)));
1521     }
1522 }