1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.8.17;
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         _checkOwner();
58         _;
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if the sender is not the owner.
70      */
71     function _checkOwner() internal view virtual {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
107 
108 // CAUTION
109 // This version of SafeMath should only be used with Solidity 0.8 or later,
110 // because it relies on the compiler's built in overflow checks.
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations.
114  *
115  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
116  * now has built in overflow checking.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, with an overflow flag.
121      *
122      * _Available since v3.4._
123      */
124     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
125         unchecked {
126             uint256 c = a + b;
127             if (c < a) return (false, 0);
128             return (true, c);
129         }
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         unchecked {
139             if (b > a) return (false, 0);
140             return (true, a - b);
141         }
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
146      *
147      * _Available since v3.4._
148      */
149     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
150         unchecked {
151             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152             // benefit is lost if 'b' is also tested.
153             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154             if (a == 0) return (true, 0);
155             uint256 c = a * b;
156             if (c / a != b) return (false, 0);
157             return (true, c);
158         }
159     }
160 
161     /**
162      * @dev Returns the division of two unsigned integers, with a division by zero flag.
163      *
164      * _Available since v3.4._
165      */
166     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
167         unchecked {
168             if (b == 0) return (false, 0);
169             return (true, a / b);
170         }
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
175      *
176      * _Available since v3.4._
177      */
178     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
179         unchecked {
180             if (b == 0) return (false, 0);
181             return (true, a % b);
182         }
183     }
184 
185     /**
186      * @dev Returns the addition of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `+` operator.
190      *
191      * Requirements:
192      *
193      * - Addition cannot overflow.
194      */
195     function add(uint256 a, uint256 b) internal pure returns (uint256) {
196         return a + b;
197     }
198 
199     /**
200      * @dev Returns the subtraction of two unsigned integers, reverting on
201      * overflow (when the result is negative).
202      *
203      * Counterpart to Solidity's `-` operator.
204      *
205      * Requirements:
206      *
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return a - b;
211     }
212 
213     /**
214      * @dev Returns the multiplication of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `*` operator.
218      *
219      * Requirements:
220      *
221      * - Multiplication cannot overflow.
222      */
223     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a * b;
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers, reverting on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator.
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238         return a / b;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * reverting when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         return a % b;
255     }
256 
257     /**
258      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
259      * overflow (when the result is negative).
260      *
261      * CAUTION: This function is deprecated because it requires allocating memory for the error
262      * message unnecessarily. For custom revert reasons use {trySub}.
263      *
264      * Counterpart to Solidity's `-` operator.
265      *
266      * Requirements:
267      *
268      * - Subtraction cannot overflow.
269      */
270     function sub(
271         uint256 a,
272         uint256 b,
273         string memory errorMessage
274     ) internal pure returns (uint256) {
275         unchecked {
276             require(b <= a, errorMessage);
277             return a - b;
278         }
279     }
280 
281     /**
282      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
283      * division by zero. The result is rounded towards zero.
284      *
285      * Counterpart to Solidity's `/` operator. Note: this function uses a
286      * `revert` opcode (which leaves remaining gas untouched) while Solidity
287      * uses an invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function div(
294         uint256 a,
295         uint256 b,
296         string memory errorMessage
297     ) internal pure returns (uint256) {
298         unchecked {
299             require(b > 0, errorMessage);
300             return a / b;
301         }
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
319     function mod(
320         uint256 a,
321         uint256 b,
322         string memory errorMessage
323     ) internal pure returns (uint256) {
324         unchecked {
325             require(b > 0, errorMessage);
326             return a % b;
327         }
328     }
329 }
330 
331 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
332 
333 /**
334  * @dev Interface of the ERC20 standard as defined in the EIP.
335  */
336 interface IERC20 {
337     /**
338      * @dev Emitted when `value` tokens are moved from one account (`from`) to
339      * another (`to`).
340      *
341      * Note that `value` may be zero.
342      */
343     event Transfer(address indexed from, address indexed to, uint256 value);
344 
345     /**
346      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
347      * a call to {approve}. `value` is the new allowance.
348      */
349     event Approval(address indexed owner, address indexed spender, uint256 value);
350 
351     /**
352      * @dev Returns the amount of tokens in existence.
353      */
354     function totalSupply() external view returns (uint256);
355 
356     /**
357      * @dev Returns the amount of tokens owned by `account`.
358      */
359     function balanceOf(address account) external view returns (uint256);
360 
361     /**
362      * @dev Moves `amount` tokens from the caller's account to `to`.
363      *
364      * Returns a boolean value indicating whether the operation succeeded.
365      *
366      * Emits a {Transfer} event.
367      */
368     function transfer(address to, uint256 amount) external returns (bool);
369 
370     /**
371      * @dev Returns the remaining number of tokens that `spender` will be
372      * allowed to spend on behalf of `owner` through {transferFrom}. This is
373      * zero by default.
374      *
375      * This value changes when {approve} or {transferFrom} are called.
376      */
377     function allowance(address owner, address spender) external view returns (uint256);
378 
379     /**
380      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
381      *
382      * Returns a boolean value indicating whether the operation succeeded.
383      *
384      * IMPORTANT: Beware that changing an allowance with this method brings the risk
385      * that someone may use both the old and the new allowance by unfortunate
386      * transaction ordering. One possible solution to mitigate this race
387      * condition is to first reduce the spender's allowance to 0 and set the
388      * desired value afterwards:
389      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
390      *
391      * Emits an {Approval} event.
392      */
393     function approve(address spender, uint256 amount) external returns (bool);
394 
395     /**
396      * @dev Moves `amount` tokens from `from` to `to` using the
397      * allowance mechanism. `amount` is then deducted from the caller's
398      * allowance.
399      *
400      * Returns a boolean value indicating whether the operation succeeded.
401      *
402      * Emits a {Transfer} event.
403      */
404     function transferFrom(
405         address from,
406         address to,
407         uint256 amount
408     ) external returns (bool);
409 }
410 
411 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
412 
413 /**
414  * @dev Interface for the optional metadata functions from the ERC20 standard.
415  *
416  * _Available since v4.1._
417  */
418 interface IERC20Metadata is IERC20 {
419     /**
420      * @dev Returns the name of the token.
421      */
422     function name() external view returns (string memory);
423 
424     /**
425      * @dev Returns the symbol of the token.
426      */
427     function symbol() external view returns (string memory);
428 
429     /**
430      * @dev Returns the decimals places of the token.
431      */
432     function decimals() external view returns (uint8);
433 }
434 
435 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
436 
437 /**
438  * @dev Implementation of the {IERC20} interface.
439  *
440  * This implementation is agnostic to the way tokens are created. This means
441  * that a supply mechanism has to be added in a derived contract using {_mint}.
442  * For a generic mechanism see {ERC20PresetMinterPauser}.
443  *
444  * TIP: For a detailed writeup see our guide
445  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
446  * to implement supply mechanisms].
447  *
448  * We have followed general OpenZeppelin Contracts guidelines: functions revert
449  * instead returning `false` on failure. This behavior is nonetheless
450  * conventional and does not conflict with the expectations of ERC20
451  * applications.
452  *
453  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
454  * This allows applications to reconstruct the allowance for all accounts just
455  * by listening to said events. Other implementations of the EIP may not emit
456  * these events, as it isn't required by the specification.
457  *
458  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
459  * functions have been added to mitigate the well-known issues around setting
460  * allowances. See {IERC20-approve}.
461  */
462 contract ERC20 is Context, IERC20, IERC20Metadata {
463     mapping(address => uint256) private _balances;
464 
465     mapping(address => mapping(address => uint256)) private _allowances;
466 
467     uint256 private _totalSupply;
468 
469     string private _name;
470     string private _symbol;
471 
472     /**
473      * @dev Sets the values for {name} and {symbol}.
474      *
475      * The default value of {decimals} is 18. To select a different value for
476      * {decimals} you should overload it.
477      *
478      * All two of these values are immutable: they can only be set once during
479      * construction.
480      */
481     constructor(string memory name_, string memory symbol_) {
482         _name = name_;
483         _symbol = symbol_;
484     }
485 
486     /**
487      * @dev Returns the name of the token.
488      */
489     function name() public view virtual override returns (string memory) {
490         return _name;
491     }
492 
493     /**
494      * @dev Returns the symbol of the token, usually a shorter version of the
495      * name.
496      */
497     function symbol() public view virtual override returns (string memory) {
498         return _symbol;
499     }
500 
501     /**
502      * @dev Returns the number of decimals used to get its user representation.
503      * For example, if `decimals` equals `2`, a balance of `505` tokens should
504      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
505      *
506      * Tokens usually opt for a value of 18, imitating the relationship between
507      * Ether and Wei. This is the value {ERC20} uses, unless this function is
508      * overridden;
509      *
510      * NOTE: This information is only used for _display_ purposes: it in
511      * no way affects any of the arithmetic of the contract, including
512      * {IERC20-balanceOf} and {IERC20-transfer}.
513      */
514     function decimals() public view virtual override returns (uint8) {
515         return 18;
516     }
517 
518     /**
519      * @dev See {IERC20-totalSupply}.
520      */
521     function totalSupply() public view virtual override returns (uint256) {
522         return _totalSupply;
523     }
524 
525     /**
526      * @dev See {IERC20-balanceOf}.
527      */
528     function balanceOf(address account) public view virtual override returns (uint256) {
529         return _balances[account];
530     }
531 
532     /**
533      * @dev See {IERC20-transfer}.
534      *
535      * Requirements:
536      *
537      * - `to` cannot be the zero address.
538      * - the caller must have a balance of at least `amount`.
539      */
540     function transfer(address to, uint256 amount) public virtual override returns (bool) {
541         address owner = _msgSender();
542         _transfer(owner, to, amount);
543         return true;
544     }
545 
546     /**
547      * @dev See {IERC20-allowance}.
548      */
549     function allowance(address owner, address spender) public view virtual override returns (uint256) {
550         return _allowances[owner][spender];
551     }
552 
553     /**
554      * @dev See {IERC20-approve}.
555      *
556      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
557      * `transferFrom`. This is semantically equivalent to an infinite approval.
558      *
559      * Requirements:
560      *
561      * - `spender` cannot be the zero address.
562      */
563     function approve(address spender, uint256 amount) public virtual override returns (bool) {
564         address owner = _msgSender();
565         _approve(owner, spender, amount);
566         return true;
567     }
568 
569     /**
570      * @dev See {IERC20-transferFrom}.
571      *
572      * Emits an {Approval} event indicating the updated allowance. This is not
573      * required by the EIP. See the note at the beginning of {ERC20}.
574      *
575      * NOTE: Does not update the allowance if the current allowance
576      * is the maximum `uint256`.
577      *
578      * Requirements:
579      *
580      * - `from` and `to` cannot be the zero address.
581      * - `from` must have a balance of at least `amount`.
582      * - the caller must have allowance for ``from``'s tokens of at least
583      * `amount`.
584      */
585     function transferFrom(
586         address from,
587         address to,
588         uint256 amount
589     ) public virtual override returns (bool) {
590         address spender = _msgSender();
591         _spendAllowance(from, spender, amount);
592         _transfer(from, to, amount);
593         return true;
594     }
595 
596     /**
597      * @dev Atomically increases the allowance granted to `spender` by the caller.
598      *
599      * This is an alternative to {approve} that can be used as a mitigation for
600      * problems described in {IERC20-approve}.
601      *
602      * Emits an {Approval} event indicating the updated allowance.
603      *
604      * Requirements:
605      *
606      * - `spender` cannot be the zero address.
607      */
608     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
609         address owner = _msgSender();
610         _approve(owner, spender, allowance(owner, spender) + addedValue);
611         return true;
612     }
613 
614     /**
615      * @dev Atomically decreases the allowance granted to `spender` by the caller.
616      *
617      * This is an alternative to {approve} that can be used as a mitigation for
618      * problems described in {IERC20-approve}.
619      *
620      * Emits an {Approval} event indicating the updated allowance.
621      *
622      * Requirements:
623      *
624      * - `spender` cannot be the zero address.
625      * - `spender` must have allowance for the caller of at least
626      * `subtractedValue`.
627      */
628     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
629         address owner = _msgSender();
630         uint256 currentAllowance = allowance(owner, spender);
631         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
632         unchecked {
633             _approve(owner, spender, currentAllowance - subtractedValue);
634         }
635 
636         return true;
637     }
638 
639     /**
640      * @dev Moves `amount` of tokens from `from` to `to`.
641      *
642      * This internal function is equivalent to {transfer}, and can be used to
643      * e.g. implement automatic token fees, slashing mechanisms, etc.
644      *
645      * Emits a {Transfer} event.
646      *
647      * Requirements:
648      *
649      * - `from` cannot be the zero address.
650      * - `to` cannot be the zero address.
651      * - `from` must have a balance of at least `amount`.
652      */
653     function _transfer(
654         address from,
655         address to,
656         uint256 amount
657     ) internal virtual {
658         require(from != address(0), "ERC20: transfer from the zero address");
659         require(to != address(0), "ERC20: transfer to the zero address");
660 
661         _beforeTokenTransfer(from, to, amount);
662 
663         uint256 fromBalance = _balances[from];
664         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
665         unchecked {
666             _balances[from] = fromBalance - amount;
667             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
668             // decrementing then incrementing.
669             _balances[to] += amount;
670         }
671 
672         emit Transfer(from, to, amount);
673 
674         _afterTokenTransfer(from, to, amount);
675     }
676 
677     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
678      * the total supply.
679      *
680      * Emits a {Transfer} event with `from` set to the zero address.
681      *
682      * Requirements:
683      *
684      * - `account` cannot be the zero address.
685      */
686     function _mint(address account, uint256 amount) internal virtual {
687         require(account != address(0), "ERC20: mint to the zero address");
688 
689         _beforeTokenTransfer(address(0), account, amount);
690 
691         _totalSupply += amount;
692         unchecked {
693             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
694             _balances[account] += amount;
695         }
696         emit Transfer(address(0), account, amount);
697 
698         _afterTokenTransfer(address(0), account, amount);
699     }
700 
701     /**
702      * @dev Destroys `amount` tokens from `account`, reducing the
703      * total supply.
704      *
705      * Emits a {Transfer} event with `to` set to the zero address.
706      *
707      * Requirements:
708      *
709      * - `account` cannot be the zero address.
710      * - `account` must have at least `amount` tokens.
711      */
712     function _burn(address account, uint256 amount) internal virtual {
713         require(account != address(0), "ERC20: burn from the zero address");
714 
715         _beforeTokenTransfer(account, address(0), amount);
716 
717         uint256 accountBalance = _balances[account];
718         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
719         unchecked {
720             _balances[account] = accountBalance - amount;
721             // Overflow not possible: amount <= accountBalance <= totalSupply.
722             _totalSupply -= amount;
723         }
724 
725         emit Transfer(account, address(0), amount);
726 
727         _afterTokenTransfer(account, address(0), amount);
728     }
729 
730     /**
731      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
732      *
733      * This internal function is equivalent to `approve`, and can be used to
734      * e.g. set automatic allowances for certain subsystems, etc.
735      *
736      * Emits an {Approval} event.
737      *
738      * Requirements:
739      *
740      * - `owner` cannot be the zero address.
741      * - `spender` cannot be the zero address.
742      */
743     function _approve(
744         address owner,
745         address spender,
746         uint256 amount
747     ) internal virtual {
748         require(owner != address(0), "ERC20: approve from the zero address");
749         require(spender != address(0), "ERC20: approve to the zero address");
750 
751         _allowances[owner][spender] = amount;
752         emit Approval(owner, spender, amount);
753     }
754 
755     /**
756      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
757      *
758      * Does not update the allowance amount in case of infinite allowance.
759      * Revert if not enough allowance is available.
760      *
761      * Might emit an {Approval} event.
762      */
763     function _spendAllowance(
764         address owner,
765         address spender,
766         uint256 amount
767     ) internal virtual {
768         uint256 currentAllowance = allowance(owner, spender);
769         if (currentAllowance != type(uint256).max) {
770             require(currentAllowance >= amount, "ERC20: insufficient allowance");
771             unchecked {
772                 _approve(owner, spender, currentAllowance - amount);
773             }
774         }
775     }
776 
777     /**
778      * @dev Hook that is called before any transfer of tokens. This includes
779      * minting and burning.
780      *
781      * Calling conditions:
782      *
783      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
784      * will be transferred to `to`.
785      * - when `from` is zero, `amount` tokens will be minted for `to`.
786      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
787      * - `from` and `to` are never both zero.
788      *
789      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
790      */
791     function _beforeTokenTransfer(
792         address from,
793         address to,
794         uint256 amount
795     ) internal virtual {}
796 
797     /**
798      * @dev Hook that is called after any transfer of tokens. This includes
799      * minting and burning.
800      *
801      * Calling conditions:
802      *
803      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
804      * has been transferred to `to`.
805      * - when `from` is zero, `amount` tokens have been minted for `to`.
806      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
807      * - `from` and `to` are never both zero.
808      *
809      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
810      */
811     function _afterTokenTransfer(
812         address from,
813         address to,
814         uint256 amount
815     ) internal virtual {}
816 }
817 
818 interface IDEXFactory {
819     function createPair(address tokenA, address tokenB) external returns (address pair);
820 }
821 
822 interface IDEXRouter {
823     function factory() external pure returns (address);
824     function WETH() external pure returns (address);
825     function addLiquidityETH(
826         address token,
827         uint amountTokenDesired,
828         uint amountTokenMin,
829         uint amountETHMin,
830         address to,
831         uint deadline
832     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
833     function swapExactTokensForETHSupportingFeeOnTransferTokens(
834         uint amountIn,
835         uint amountOutMin,
836         address[] calldata path,
837         address to,
838         uint deadline
839     ) external;
840 }
841 
842 contract PoofToken is Context, ERC20, Ownable {
843     using SafeMath for uint256;
844 
845     IDEXRouter private _dexRouter;
846 
847     mapping (address => uint) private _cooldown;
848 
849     mapping (address => bool) private _isExcludedFromFees;
850     mapping (address => bool) private _isExcludedMaxTransactionAmount;
851     mapping (address => bool) private _isBlacklisted;
852     mapping (address => bool) public humanVerified;
853 
854     bool public tradingOpen;
855     bool private _swapping;
856     bool public swapEnabled = false;
857     bool public cooldownEnabled = false;
858     bool public feesEnabled = true;
859     bool public transferFeesEnabled = true;
860     bool private humanVerificationRequired = true;
861 
862     uint256 private constant _tSupply = 100_000_000 ether;
863 
864     uint256 public maxBuyAmount = _tSupply;
865     uint256 public maxSellAmount = _tSupply;
866     uint256 public maxWalletAmount = _tSupply;
867 
868     uint256 public tradingOpenBlock = 0;
869     uint256 private _blocksToBlacklist = 0;
870     uint256 private _cooldownBlocks = 1;
871 
872     uint256 public constant FEE_DIVISOR = 1000;
873 
874     uint256 private _totalFees;
875     uint256 private _marketingFee;
876     uint256 private _dreamFee;
877     uint256 private _liquidityFee;
878 
879     uint256 public buyMarketingFee = 20;
880     uint256 private _previousBuyMarketingFee = buyMarketingFee;
881     uint256 public buyDREAMFee = 10;
882     uint256 private _previousBuyDREAMFee = buyDREAMFee;
883     uint256 public buyLiquidityFee = 30;
884     uint256 private _previousBuyLiquidityFee = buyLiquidityFee;
885 
886     uint256 public sellMarketingFee = 20;
887     uint256 private _previousSellMktgFee = sellMarketingFee;
888     uint256 public sellDREAMFee = 10;
889     uint256 private _previousSellDevFee = sellDREAMFee;
890     uint256 public sellLiquidityFee = 30;
891     uint256 private _previousSellLiqFee = sellLiquidityFee;
892 
893     uint256 public transferMarketingFee = 20;
894     uint256 private _previousTransferMarketingFee = transferMarketingFee;
895     uint256 public transferDREAMFee = 10;
896     uint256 private _previousTransferDREAMFee = transferDREAMFee;
897     uint256 public transferLiquidityFee = 30;
898     uint256 private _previousTransferLiquidityFee = transferLiquidityFee;
899 
900     uint256 private _tokensForMarketing;
901     uint256 private _tokensForDREAM;
902     uint256 private _tokensForLiquidity;
903     uint256 private _swapTokensAtAmount = 0;
904 
905     address payable public marketingWalletAddress;
906     address payable public dreamWalletAddress;
907     address payable public liquidityWalletAddress;
908     address private _signerAddress;
909 
910     address private _dexPair;
911     address constant private DEAD = 0x000000000000000000000000000000000000dEaD;
912     address constant private ZERO = 0x0000000000000000000000000000000000000000;
913 
914     enum TransactionType {
915         BUY,
916         SELL,
917         TRANSFER
918     }
919 
920     event OpenTrading(uint256 tradingOpenBlock, uint256 _blocksToBlacklist);
921     event SetMaxBuyAmount(uint256 newMaxBuyAmount);
922     event SetMaxSellAmount(uint256 newMaxSellAmount);
923     event SetMaxWalletAmount(uint256 newMaxWalletAmount);
924     event SetSwapTokensAtAmount(uint256 newSwapTokensAtAmount);
925     event SetBuyFee(uint256 buyMarketingFee, uint256 buyDREAMFee, uint256 buyLiquidityFee);
926 	event SetSellFee(uint256 sellMarketingFee, uint256 sellDREAMFee, uint256 sellLiquidityFee);
927     event SetTransferFee(uint256 transferMarketingFee, uint256 transferDREAMFee, uint256 transferLiquidityFee);
928     event VerifyHuman(address signer);
929     
930     constructor (address payable _marketingWalletAddress, address payable _dreamWalletAddress, address payable _liquidityWalletAddress, address signerAddress) ERC20("Poof Token", "POOF") payable {
931         require(_marketingWalletAddress != ZERO, "_marketingWalletAddress cannot be 0");
932         require(_dreamWalletAddress != ZERO, "_dreamWalletAddress cannot be 0");
933         require(_liquidityWalletAddress != ZERO, "_liquidityWalletAddress cannot be 0");
934         require(signerAddress != ZERO, "_signerAddress cannot be 0");
935 
936         marketingWalletAddress = _marketingWalletAddress;
937         dreamWalletAddress = _dreamWalletAddress;
938         liquidityWalletAddress = _liquidityWalletAddress;
939         _signerAddress = signerAddress;
940 
941         _isExcludedFromFees[owner()] = true;
942         _isExcludedFromFees[address(this)] = true;
943         _isExcludedFromFees[DEAD] = true;
944         _isExcludedFromFees[marketingWalletAddress] = true;
945         _isExcludedFromFees[dreamWalletAddress] = true;
946         _isExcludedFromFees[liquidityWalletAddress] = true;
947         _isExcludedFromFees[_signerAddress] = true;
948 
949         _isExcludedMaxTransactionAmount[owner()] = true;
950         _isExcludedMaxTransactionAmount[address(this)] = true;
951         _isExcludedMaxTransactionAmount[DEAD] = true;
952         _isExcludedMaxTransactionAmount[marketingWalletAddress] = true;
953         _isExcludedMaxTransactionAmount[dreamWalletAddress] = true;
954         _isExcludedMaxTransactionAmount[liquidityWalletAddress] = true;
955         _isExcludedMaxTransactionAmount[_signerAddress] = true;
956 
957         humanVerified[owner()] = true;
958         humanVerified[address(this)] = true;
959         humanVerified[DEAD] = true;
960         humanVerified[marketingWalletAddress] = true;
961         humanVerified[dreamWalletAddress] = true;
962         humanVerified[liquidityWalletAddress] = true;
963         humanVerified[_signerAddress] = true;
964 
965         _mint(address(this), _tSupply.mul(5).div(100));
966         _mint(owner(), _tSupply.mul(95).div(100));
967     }
968 
969     function _transfer(address from, address to, uint256 amount) internal override {
970         require(from != ZERO, "ERC20: transfer from the zero address");
971         require(to != ZERO, "ERC20: transfer to the zero address");
972         require(amount > 0, "Transfer amount must be greater than zero");
973 
974         bool takeFee = true;
975         TransactionType txType = (from == _dexPair) ? TransactionType.BUY : (to == _dexPair) ? TransactionType.SELL : TransactionType.TRANSFER;
976         if (from != owner() && to != owner() && to != ZERO && to != DEAD && !_swapping) {
977             require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted.");
978 
979             if(!tradingOpen) require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not allowed yet.");
980 
981             if (cooldownEnabled) {
982                 if (to != address(_dexRouter) && to != address(_dexPair)) {
983                     require(_cooldown[tx.origin] < block.number - _cooldownBlocks && _cooldown[to] < block.number - _cooldownBlocks, "Transfer delay enabled. Try again later.");
984                     _cooldown[tx.origin] = block.number;
985                     _cooldown[to] = block.number;
986                 }
987             }
988 
989             if (txType == TransactionType.BUY && to != address(_dexRouter) && !_isExcludedMaxTransactionAmount[to]) {
990                 if (humanVerificationRequired) require(humanVerified[to] == true, "Human not verified.");
991                 
992                 require(amount <= maxBuyAmount, "Transfer amount exceeds the maxBuyAmount.");
993                 require(balanceOf(to) + amount <= maxWalletAmount, "Exceeds maximum wallet token amount.");
994             }
995             
996             if (txType == TransactionType.SELL && from != address(_dexRouter) && !_isExcludedMaxTransactionAmount[from]) require(amount <= maxSellAmount, "Transfer amount exceeds the maxSellAmount.");
997         }
998 
999         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || !feesEnabled || (!transferFeesEnabled && txType == TransactionType.TRANSFER)) takeFee = false;
1000 
1001         uint256 contractBalance = balanceOf(address(this));
1002         bool canSwap = (contractBalance > _swapTokensAtAmount) && (txType == TransactionType.SELL);
1003 
1004         if (canSwap && swapEnabled && !_swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1005             _swapping = true;
1006             _swapBack(contractBalance);
1007             _swapping = false;
1008         }
1009 
1010         _tokenTransfer(from, to, amount, takeFee, txType);
1011     }
1012 
1013     function _swapBack(uint256 contractBalance) internal {
1014         uint256 totalTokensToSwap =  _tokensForMarketing.add(_tokensForDREAM).add(_tokensForLiquidity);
1015         bool success;
1016         
1017         if (contractBalance == 0 || totalTokensToSwap == 0) return;
1018 
1019         if (contractBalance > _swapTokensAtAmount.mul(5)) contractBalance = _swapTokensAtAmount.mul(5);
1020 
1021         uint256 liquidityTokens = contractBalance.mul(_tokensForLiquidity).div(totalTokensToSwap).div(2);
1022         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1023 
1024         uint256 initialETHBalance = address(this).balance;
1025 
1026         _swapTokensForETH(amountToSwapForETH);
1027         
1028         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1029         uint256 ethForMktg = ethBalance.mul(_tokensForMarketing).div(totalTokensToSwap);
1030         uint256 ethForDev = ethBalance.mul(_tokensForDREAM).div(totalTokensToSwap);
1031         uint256 ethForLiq = ethBalance.sub(ethForMktg).sub(ethForDev);
1032         
1033         _tokensForMarketing = 0;
1034         _tokensForDREAM = 0;
1035         _tokensForLiquidity = 0;
1036 
1037         if(liquidityTokens > 0 && ethForLiq > 0) _addLiquidity(liquidityTokens, ethForLiq);
1038 
1039         (success,) = address(dreamWalletAddress).call{value: ethForDev}("");
1040         (success,) = address(marketingWalletAddress).call{value: address(this).balance}("");
1041     }
1042 
1043     function _swapTokensForETH(uint256 tokenAmount) internal {
1044         address[] memory path = new address[](2);
1045         path[0] = address(this);
1046         path[1] = _dexRouter.WETH();
1047         _approve(address(this), address(_dexRouter), tokenAmount);
1048         _dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1049             tokenAmount,
1050             0,
1051             path,
1052             address(this),
1053             block.timestamp
1054         );
1055     }
1056 
1057     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
1058         _approve(address(this), address(_dexRouter), tokenAmount);
1059         _dexRouter.addLiquidityETH{value: ethAmount}(
1060             address(this),
1061             tokenAmount,
1062             0,
1063             0,
1064             liquidityWalletAddress,
1065             block.timestamp
1066         );
1067     }
1068         
1069     function _sendETHToFee(uint256 amount) internal {
1070         marketingWalletAddress.transfer(amount.div(2));
1071         dreamWalletAddress.transfer(amount.div(2));
1072     }
1073 
1074     function isBlacklisted(address wallet) external view returns (bool) {
1075         return _isBlacklisted[wallet];
1076     }
1077 
1078     function openTrading(uint256 blocks) public onlyOwner {
1079         require(!tradingOpen, "Trading is already open");
1080         require(blocks <= 10, "Invalid blocks count.");
1081 
1082         if (block.chainid == 1 || block.chainid == 5) _dexRouter = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // ETH: Uniswap V2
1083         else if (block.chainid == 56) _dexRouter = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E); // ETH Chain: PCS V2
1084         else if (block.chainid == 97) _dexRouter = IDEXRouter(0xD99D1c33F9fC3444f8101754aBC46c52416550D1); // ETH Chain Testnet: PCS V2
1085         else if (block.chainid == 137 || block.chainid == 80001) _dexRouter = IDEXRouter(0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff); // Polygon: Quickswap 
1086         else revert("Chain not set.");
1087 
1088         _approve(address(this), address(_dexRouter), totalSupply());
1089         _dexPair = IDEXFactory(_dexRouter.factory()).createPair(address(this), _dexRouter.WETH());
1090         _dexRouter.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp);
1091         IERC20(_dexPair).approve(address(_dexRouter), type(uint).max);
1092 
1093         maxBuyAmount = totalSupply().mul(2).div(1000);
1094         maxSellAmount = totalSupply().mul(2).div(1000);
1095         maxWalletAmount = totalSupply().mul(1).div(100);
1096         _swapTokensAtAmount = totalSupply().mul(2).div(10000);
1097         swapEnabled = true;
1098         cooldownEnabled = true;
1099         tradingOpen = true;
1100         tradingOpenBlock = block.number;
1101         _blocksToBlacklist = blocks;
1102         emit OpenTrading(tradingOpenBlock, _blocksToBlacklist);
1103     }
1104 
1105     function setCooldownEnabled(bool onoff) public onlyOwner {
1106         cooldownEnabled = onoff;
1107     }
1108 
1109     function setSwapEnabled(bool onoff) public onlyOwner {
1110         swapEnabled = onoff;
1111     }
1112 
1113     function setFeesEnabled(bool onoff) public onlyOwner {
1114         feesEnabled = onoff;
1115     }
1116 
1117     function setTransferFeesEnabled(bool onoff) public onlyOwner {
1118         transferFeesEnabled = onoff;
1119     }
1120 
1121     function setHumanVerificationRequired(bool onoff) public onlyOwner {
1122         humanVerificationRequired = onoff;
1123     }
1124 
1125     function setMaxBuyAmount(uint256 _maxBuyAmount) public onlyOwner {
1126         require(_maxBuyAmount >= (totalSupply().mul(1).div(1000)), "Max buy amount cannot be lower than 0.1% total supply.");
1127         maxBuyAmount = _maxBuyAmount;
1128         emit SetMaxBuyAmount(maxBuyAmount);
1129     }
1130 
1131     function setMaxSellAmount(uint256 _maxSellAmount) public onlyOwner {
1132         require(_maxSellAmount >= (totalSupply().mul(1).div(1000)), "Max sell amount cannot be lower than 0.1% total supply.");
1133         maxSellAmount = _maxSellAmount;
1134         emit SetMaxSellAmount(maxSellAmount);
1135     }
1136     
1137     function setMaxWalletAmount(uint256 _maxWalletAmount) public onlyOwner {
1138         require(_maxWalletAmount >= (totalSupply().mul(1).div(1000)), "Max wallet amount cannot be lower than 0.1% total supply.");
1139         maxWalletAmount = _maxWalletAmount;
1140         emit SetMaxWalletAmount(maxWalletAmount);
1141     }
1142     
1143     function setSwapTokensAtAmount(uint256 swapTokensAtAmount) public onlyOwner {
1144         require(swapTokensAtAmount >= (totalSupply().mul(1).div(1000000)), "Swap amount cannot be lower than 0.0001% total supply.");
1145         require(swapTokensAtAmount <= (totalSupply().mul(5).div(1000)), "Swap amount cannot be higher than 0.5% total supply.");
1146         _swapTokensAtAmount = swapTokensAtAmount;
1147         emit SetSwapTokensAtAmount(_swapTokensAtAmount);
1148     }
1149 
1150     function setMarketingWalletAddress(address _marketingWalletAddress) public onlyOwner {
1151         require(_marketingWalletAddress != ZERO, "marketingWalletAddress cannot be 0");
1152         _isExcludedFromFees[marketingWalletAddress] = false;
1153         _isExcludedMaxTransactionAmount[marketingWalletAddress] = false;
1154         marketingWalletAddress = payable(_marketingWalletAddress);
1155         _isExcludedFromFees[marketingWalletAddress] = true;
1156         _isExcludedMaxTransactionAmount[marketingWalletAddress] = true;
1157     }
1158 
1159     function setDREAMWalletAddress(address _dreamWalletAddress) public onlyOwner {
1160         require(_dreamWalletAddress != ZERO, "dreamWalletAddress cannot be 0");
1161         _isExcludedFromFees[dreamWalletAddress] = false;
1162         _isExcludedMaxTransactionAmount[dreamWalletAddress] = false;
1163         dreamWalletAddress = payable(_dreamWalletAddress);
1164         _isExcludedFromFees[dreamWalletAddress] = true;
1165         _isExcludedMaxTransactionAmount[dreamWalletAddress] = true;
1166     }
1167 
1168     function setLiquidityWalletAddress(address _liquidityWalletAddress) public onlyOwner {
1169         require(_liquidityWalletAddress != ZERO, "liquidityWalletAddress cannot be 0");
1170         _isExcludedFromFees[liquidityWalletAddress] = false;
1171         _isExcludedMaxTransactionAmount[liquidityWalletAddress] = false;
1172         liquidityWalletAddress = payable(_liquidityWalletAddress);
1173         _isExcludedFromFees[liquidityWalletAddress] = true;
1174         _isExcludedMaxTransactionAmount[liquidityWalletAddress] = true;
1175     }
1176 
1177     function setSignerAddress(address signerAddress) public onlyOwner {
1178         require(signerAddress != ZERO, "_signerAddress cannot be 0");
1179         _signerAddress = signerAddress;
1180     }
1181 
1182     function setExcludedFromFees(address[] memory accounts, bool isEx) public onlyOwner {
1183         for (uint i = 0; i < accounts.length; i++) _isExcludedFromFees[accounts[i]] = isEx;
1184     }
1185     
1186     function setExcludeFromMaxTransaction(address[] memory accounts, bool isEx) public onlyOwner {
1187         for (uint i = 0; i < accounts.length; i++) _isExcludedMaxTransactionAmount[accounts[i]] = isEx;
1188     }
1189     
1190     function setBlacklisted(address[] memory accounts, bool isBL) public onlyOwner {
1191         for (uint i = 0; i < accounts.length; i++) {
1192             if((accounts[i] != _dexPair) && (accounts[i] != address(_dexRouter)) && (accounts[i] != address(this))) _isBlacklisted[accounts[i]] = isBL;
1193         }
1194     }
1195 
1196     function setBuyFee(uint256 _buyMarketingFee, uint256 _buyDREAMFee, uint256 _buyLiquidityFee) public onlyOwner {
1197         require(_buyMarketingFee.add(_buyDREAMFee).add(_buyLiquidityFee) <= 120, "Must keep buy taxes below 12%");
1198         buyMarketingFee = _buyMarketingFee;
1199         buyDREAMFee = _buyDREAMFee;
1200         buyLiquidityFee = _buyLiquidityFee;
1201         emit SetBuyFee(buyMarketingFee, buyDREAMFee, buyLiquidityFee);
1202     }
1203 
1204     function setSellFee(uint256 _sellMarketingFee, uint256 _sellDREAMFee, uint256 _sellLiquidityFee) public onlyOwner {
1205         require(_sellMarketingFee.add(_sellDREAMFee).add(_sellLiquidityFee) <= 120, "Must keep sell taxes below 12%");
1206         sellMarketingFee = _sellMarketingFee;
1207         sellDREAMFee = _sellDREAMFee;
1208         sellLiquidityFee = _sellLiquidityFee;
1209         emit SetSellFee(sellMarketingFee, sellDREAMFee, sellLiquidityFee);
1210     }
1211 
1212     function setTransferFee(uint256 _transferMarketingFee, uint256 _transferDREAMFee, uint256 _transferLiquidityFee) public onlyOwner {
1213         require(_transferMarketingFee.add(_transferDREAMFee).add(_transferLiquidityFee) <= 250, "Must keep transfer taxes below 25%");
1214         transferMarketingFee = _transferMarketingFee;
1215         transferDREAMFee = _transferDREAMFee;
1216         transferLiquidityFee = _transferLiquidityFee;
1217         emit SetTransferFee(transferMarketingFee, transferDREAMFee, transferLiquidityFee);
1218     }
1219 
1220     function setCooldownBlocks(uint256 blocks) public onlyOwner {
1221         require(blocks <= 10, "Invalid blocks count.");
1222         _cooldownBlocks = blocks;
1223     }
1224 
1225     function _removeAllFee() internal {
1226         if (buyMarketingFee == 0 && buyDREAMFee == 0 && buyLiquidityFee == 0 && 
1227         sellMarketingFee == 0 && sellDREAMFee == 0 && sellLiquidityFee == 0 &&
1228         transferMarketingFee == 0 && transferDREAMFee == 0 && transferLiquidityFee == 0) return;
1229 
1230         _previousBuyMarketingFee = buyMarketingFee;
1231         _previousBuyDREAMFee = buyDREAMFee;
1232         _previousBuyLiquidityFee = buyLiquidityFee;
1233         _previousSellMktgFee = sellMarketingFee;
1234         _previousSellDevFee = sellDREAMFee;
1235         _previousSellLiqFee = sellLiquidityFee;
1236         _previousTransferMarketingFee = transferMarketingFee;
1237         _previousTransferDREAMFee = transferDREAMFee;
1238         _previousTransferLiquidityFee = transferLiquidityFee;
1239         
1240         buyMarketingFee = 0;
1241         buyDREAMFee = 0;
1242         buyLiquidityFee = 0;
1243         sellMarketingFee = 0;
1244         sellDREAMFee = 0;
1245         sellLiquidityFee = 0;
1246         transferMarketingFee = 0;
1247         transferDREAMFee = 0;
1248         transferLiquidityFee = 0;
1249     }
1250     
1251     function _restoreAllFee() internal {
1252         buyMarketingFee = _previousBuyMarketingFee;
1253         buyDREAMFee = _previousBuyDREAMFee;
1254         buyLiquidityFee = _previousBuyLiquidityFee;
1255         sellMarketingFee = _previousSellMktgFee;
1256         sellDREAMFee = _previousSellDevFee;
1257         sellLiquidityFee = _previousSellLiqFee;
1258         transferMarketingFee = _previousTransferMarketingFee;
1259         transferDREAMFee = _previousTransferDREAMFee;
1260         transferLiquidityFee = _previousTransferLiquidityFee;
1261     }
1262         
1263     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee, TransactionType txType) internal {
1264         if (!takeFee) _removeAllFee();
1265         else amount = _takeFees(sender, amount, txType);
1266 
1267         super._transfer(sender, recipient, amount);
1268         
1269         if (!takeFee) _restoreAllFee();
1270     }
1271 
1272     function _takeFees(address sender, uint256 amount, TransactionType txType) internal returns (uint256) {
1273         if(tradingOpenBlock + _blocksToBlacklist >= block.number) _setBot();
1274         else if (txType == TransactionType.SELL) _setSell();
1275         else if (txType == TransactionType.BUY) _setBuy();
1276         else if (txType == TransactionType.TRANSFER) _setTransfer();
1277         else revert("Invalid transaction type.");
1278         
1279         uint256 fees;
1280         if (_totalFees > 0) {
1281             fees = amount.mul(_totalFees).div(FEE_DIVISOR);
1282             _tokensForMarketing += fees * _marketingFee / _totalFees;
1283             _tokensForDREAM += fees * _dreamFee / _totalFees;
1284             _tokensForLiquidity += fees * _liquidityFee / _totalFees;
1285         }
1286 
1287         if (fees > 0) super._transfer(sender, address(this), fees);
1288 
1289         return amount -= fees;
1290     }
1291 
1292     function _setBot() internal {
1293         _marketingFee = 333;
1294         _dreamFee = 333;
1295         _liquidityFee = 333;
1296         _totalFees = _marketingFee.add(_dreamFee).add(_liquidityFee);
1297     }
1298 
1299     function _setSell() internal {
1300         _marketingFee = sellMarketingFee;
1301         _dreamFee = sellDREAMFee;
1302         _liquidityFee = sellLiquidityFee;
1303         _totalFees = _marketingFee.add(_dreamFee).add(_liquidityFee);
1304     }
1305 
1306     function _setBuy() internal {
1307         _marketingFee = buyMarketingFee;
1308         _dreamFee = buyDREAMFee;
1309         _liquidityFee = buyLiquidityFee;
1310         _totalFees = _marketingFee.add(_dreamFee).add(_liquidityFee);
1311     }
1312 
1313     function _setTransfer() internal {
1314         _marketingFee = transferMarketingFee;
1315         _dreamFee = transferDREAMFee;
1316         _liquidityFee = transferLiquidityFee;
1317         _totalFees = _marketingFee.add(_dreamFee).add(_liquidityFee);
1318     }
1319     
1320     function unclog() public onlyOwner {
1321         uint256 contractBalance = balanceOf(address(this));
1322         _swapTokensForETH(contractBalance);
1323     }
1324     
1325     function distributeFees() public onlyOwner {
1326         uint256 contractETHBalance = address(this).balance;
1327         _sendETHToFee(contractETHBalance);
1328     }
1329 
1330     function withdrawStuckETH() public onlyOwner {
1331         bool success;
1332         (success,) = address(msg.sender).call{value: address(this).balance}("");
1333     }
1334 
1335     function withdrawStuckTokens(address tkn) public onlyOwner {
1336         require(tkn != address(this), "Cannot withdraw own token");
1337         require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1338         uint amount = IERC20(tkn).balanceOf(address(this));
1339         IERC20(tkn).transfer(msg.sender, amount);
1340     }
1341 
1342     function removeLimits() public onlyOwner {
1343         maxBuyAmount = totalSupply();
1344         maxSellAmount = totalSupply();
1345         maxWalletAmount = totalSupply();
1346         cooldownEnabled = false;
1347     }
1348 
1349     function verifyHuman(uint8 _v, bytes32 _r, bytes32 _s) public {
1350         require(tradingOpen, "Trading is not allowed yet.");
1351         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1352         bytes32 hash = keccak256(abi.encodePacked(address(this), _msgSender(), "POOF!"));
1353         bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, hash));
1354         address recovered = ecrecover(prefixedHash, _v, _r, _s);
1355 
1356         if (recovered == _signerAddress) {
1357             humanVerified[_msgSender()] = true;
1358             emit VerifyHuman(_msgSender());
1359         } else {
1360             revert("Human not verified.");
1361         }
1362     }
1363 
1364     receive() external payable {}
1365     fallback() external payable {}
1366 
1367 }