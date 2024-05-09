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
818 interface IUniswapV2Factory {
819     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
820 
821     function feeTo() external view returns (address);
822     function feeToSetter() external view returns (address);
823 
824     function getPair(address tokenA, address tokenB) external view returns (address pair);
825     function allPairs(uint) external view returns (address pair);
826     function allPairsLength() external view returns (uint);
827 
828     function createPair(address tokenA, address tokenB) external returns (address pair);
829 
830     function setFeeTo(address) external;
831     function setFeeToSetter(address) external;
832 }
833 
834 interface IUniswapV2Router01 {
835     function factory() external pure returns (address);
836     function WETH() external pure returns (address);
837 
838     function addLiquidity(
839         address tokenA,
840         address tokenB,
841         uint amountADesired,
842         uint amountBDesired,
843         uint amountAMin,
844         uint amountBMin,
845         address to,
846         uint deadline
847     ) external returns (uint amountA, uint amountB, uint liquidity);
848     function addLiquidityETH(
849         address token,
850         uint amountTokenDesired,
851         uint amountTokenMin,
852         uint amountETHMin,
853         address to,
854         uint deadline
855     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
856     function removeLiquidity(
857         address tokenA,
858         address tokenB,
859         uint liquidity,
860         uint amountAMin,
861         uint amountBMin,
862         address to,
863         uint deadline
864     ) external returns (uint amountA, uint amountB);
865     function removeLiquidityETH(
866         address token,
867         uint liquidity,
868         uint amountTokenMin,
869         uint amountETHMin,
870         address to,
871         uint deadline
872     ) external returns (uint amountToken, uint amountETH);
873     function removeLiquidityWithPermit(
874         address tokenA,
875         address tokenB,
876         uint liquidity,
877         uint amountAMin,
878         uint amountBMin,
879         address to,
880         uint deadline,
881         bool approveMax, uint8 v, bytes32 r, bytes32 s
882     ) external returns (uint amountA, uint amountB);
883     function removeLiquidityETHWithPermit(
884         address token,
885         uint liquidity,
886         uint amountTokenMin,
887         uint amountETHMin,
888         address to,
889         uint deadline,
890         bool approveMax, uint8 v, bytes32 r, bytes32 s
891     ) external returns (uint amountToken, uint amountETH);
892     function swapExactTokensForTokens(
893         uint amountIn,
894         uint amountOutMin,
895         address[] calldata path,
896         address to,
897         uint deadline
898     ) external returns (uint[] memory amounts);
899     function swapTokensForExactTokens(
900         uint amountOut,
901         uint amountInMax,
902         address[] calldata path,
903         address to,
904         uint deadline
905     ) external returns (uint[] memory amounts);
906     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
907         external
908         payable
909         returns (uint[] memory amounts);
910     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
911         external
912         returns (uint[] memory amounts);
913     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
914         external
915         returns (uint[] memory amounts);
916     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
917         external
918         payable
919         returns (uint[] memory amounts);
920 
921     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
922     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
923     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
924     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
925     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
926 }
927 
928 interface IUniswapV2Router02 is IUniswapV2Router01 {
929     function removeLiquidityETHSupportingFeeOnTransferTokens(
930         address token,
931         uint liquidity,
932         uint amountTokenMin,
933         uint amountETHMin,
934         address to,
935         uint deadline
936     ) external returns (uint amountETH);
937     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
938         address token,
939         uint liquidity,
940         uint amountTokenMin,
941         uint amountETHMin,
942         address to,
943         uint deadline,
944         bool approveMax, uint8 v, bytes32 r, bytes32 s
945     ) external returns (uint amountETH);
946 
947     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
948         uint amountIn,
949         uint amountOutMin,
950         address[] calldata path,
951         address to,
952         uint deadline
953     ) external;
954     function swapExactETHForTokensSupportingFeeOnTransferTokens(
955         uint amountOutMin,
956         address[] calldata path,
957         address to,
958         uint deadline
959     ) external payable;
960     function swapExactTokensForETHSupportingFeeOnTransferTokens(
961         uint amountIn,
962         uint amountOutMin,
963         address[] calldata path,
964         address to,
965         uint deadline
966     ) external;
967 }
968 
969 interface IUniswapV2Pair {
970     event Approval(address indexed owner, address indexed spender, uint value);
971     event Transfer(address indexed from, address indexed to, uint value);
972 
973     function name() external pure returns (string memory);
974     function symbol() external pure returns (string memory);
975     function decimals() external pure returns (uint8);
976     function totalSupply() external view returns (uint);
977     function balanceOf(address owner) external view returns (uint);
978     function allowance(address owner, address spender) external view returns (uint);
979 
980     function approve(address spender, uint value) external returns (bool);
981     function transfer(address to, uint value) external returns (bool);
982     function transferFrom(address from, address to, uint value) external returns (bool);
983 
984     function DOMAIN_SEPARATOR() external view returns (bytes32);
985     function PERMIT_TYPEHASH() external pure returns (bytes32);
986     function nonces(address owner) external view returns (uint);
987 
988     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
989 
990     event Mint(address indexed sender, uint amount0, uint amount1);
991     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
992     event Swap(
993         address indexed sender,
994         uint amount0In,
995         uint amount1In,
996         uint amount0Out,
997         uint amount1Out,
998         address indexed to
999     );
1000     event Sync(uint112 reserve0, uint112 reserve1);
1001 
1002     function MINIMUM_LIQUIDITY() external pure returns (uint);
1003     function factory() external view returns (address);
1004     function token0() external view returns (address);
1005     function token1() external view returns (address);
1006     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1007     function price0CumulativeLast() external view returns (uint);
1008     function price1CumulativeLast() external view returns (uint);
1009     function kLast() external view returns (uint);
1010 
1011     function mint(address to) external returns (uint liquidity);
1012     function burn(address to) external returns (uint amount0, uint amount1);
1013     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1014     function skim(address to) external;
1015     function sync() external;
1016 
1017     function initialize(address, address) external;
1018 }
1019 
1020 contract Torty is Context, ERC20, Ownable {
1021     using SafeMath for uint256;
1022 
1023     IUniswapV2Router02 private _uniswapV2Router;
1024     
1025     IERC20 private WrappedETH;
1026 
1027     mapping (address => uint) private _cooldown;
1028     mapping (address => uint) private _vestingCooldown;
1029 
1030     mapping (address => bool) private _isExcludedFromFees;
1031     mapping (address => bool) private _isExcludedMaxTransactionAmount;
1032     mapping (address => bool) private _isBlacklisted;
1033 
1034     bool public tradingOpen;
1035     bool private _swapping;
1036     bool public swapEnabled = false;
1037     bool public cooldownEnabled = false;
1038     bool public vestingCooldownEnabled = false;
1039     bool public feesEnabled = true;
1040     bool public transferFeesEnabled = true;
1041     bool public piPenaltyEnabled = true;
1042 
1043     uint256 private constant _tSupply = 1_000_000_000 ether;
1044 
1045     uint256 public maxBuyAmount = _tSupply;
1046     uint256 public maxSellAmount = _tSupply;
1047     uint256 public maxWalletAmount = _tSupply;
1048 
1049     uint256 public maxSellPercentage = 25;
1050 
1051     uint256 public tradingOpenBlock = 0;
1052     uint256 private _blocksToBlacklist = 0;
1053     uint256 private _cooldownBlocks = 1;
1054     uint256 private _vestingCooldownBlocks = 2390;
1055 
1056     uint256 public constant FEE_DIVISOR = 1000;
1057     uint256 public constant PENALTY_DIVISOR = 10;
1058 
1059     uint256 private _totalFees;
1060     uint256 private _mktgFee;
1061     uint256 private _devFee;
1062     uint256 private _buybackFee;
1063 
1064     uint256 public buyMktgFee = 20;
1065     uint256 private _previousBuyMktgFee = buyMktgFee;
1066     uint256 public buyDevFee = 20;
1067     uint256 private _previousBuyDevFee = buyDevFee;
1068     uint256 public buyBuybackFee = 10;
1069     uint256 private _previousBuyBuybackFee = buyBuybackFee;
1070 
1071     uint256 public sellMktgFee = 50;
1072     uint256 private _previousSellMktgFee = sellMktgFee;
1073     uint256 public sellDevFee = 50;
1074     uint256 private _previousSellDevFee = sellDevFee;
1075     uint256 public sellBuybackFee = 50;
1076     uint256 private _previousSellBuybackFee = sellBuybackFee;
1077 
1078     uint256 public transferMktgFee = 333;
1079     uint256 private _previousTransferMktgFee = transferMktgFee;
1080     uint256 public transferDevFee = 333;
1081     uint256 private _previousTransferDevFee = transferDevFee;
1082     uint256 public transferBuybackFee = 333;
1083     uint256 private _previousTransferBuybackFee = transferBuybackFee;
1084 
1085     uint256 public piPenaltyMultiplier24 = 15;
1086     uint256 public piPenaltyMultiplier46 = 20;
1087     uint256 public piPenaltyMultiplier68 = 25;
1088     uint256 public piPenaltyMultiplier810 = 30;
1089     uint256 public piPenaltyMultiplier10more = 35;
1090 
1091     uint256 private _tokensForMktg;
1092     uint256 private _tokensForDev;
1093     uint256 private _tokensForBuyback;
1094     uint256 private _swapTokensAtAmount = 0;
1095 
1096     address payable private _mktgWallet;
1097     address payable private _devWallet;
1098     address payable private _buybackWallet;
1099 
1100     address private _uniswapV2Pair;
1101     address constant private DEAD = 0x000000000000000000000000000000000000dEaD;
1102     address constant private ZERO = 0x0000000000000000000000000000000000000000;
1103 
1104     enum TransactionType {
1105         BUY,
1106         SELL,
1107         TRANSFER
1108     }
1109 
1110     event OpenTrading(uint256 tradingOpenBlock, uint256 _blocksToBlacklist);
1111     event SetMaxBuyAmount(uint256 newMaxBuyAmount);
1112     event SetMaxSellAmount(uint256 newMaxSellAmount);
1113     event SetMaxWalletAmount(uint256 newMaxWalletAmount);
1114     event SetMaxSellPercentage(uint256 newMaxSellPercentage);
1115     event SetSwapTokensAtAmount(uint256 newSwapTokensAtAmount);
1116     event SetBuyFee(uint256 buyMktgFee, uint256 buyDevFee, uint256 buyBuybackFee);
1117 	event SetSellFee(uint256 sellMktgFee, uint256 sellDevFee, uint256 sellBuybackFee);
1118     event SetTransferFee(uint256 transferMktgFee, uint256 transferDevFee, uint256 transferBuybackFee);
1119     event SetPenaltyMultiplier(uint256 piPenaltyMultiplier24, uint256 piPenaltyMultiplier46, uint256 piPenaltyMultiplier68, uint256 piPenaltyMultiplier810, uint256 piPenaltyMultiplier10more);
1120     
1121     constructor () ERC20("Torty", "TORTY") {
1122         _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1123         _approve(address(this), address(_uniswapV2Router), _tSupply);
1124         _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1125         IERC20(_uniswapV2Pair).approve(address(_uniswapV2Router), type(uint).max);
1126 
1127         WrappedETH = IERC20(_uniswapV2Router.WETH());
1128 
1129         _mktgWallet = payable(owner());
1130         _devWallet = payable(owner());
1131         _buybackWallet = payable(owner());
1132 
1133         _isExcludedFromFees[owner()] = true;
1134         _isExcludedFromFees[address(this)] = true;
1135         _isExcludedFromFees[DEAD] = true;
1136 
1137         _isExcludedMaxTransactionAmount[owner()] = true;
1138         _isExcludedMaxTransactionAmount[address(this)] = true;
1139         _isExcludedMaxTransactionAmount[DEAD] = true;
1140 
1141         _mint(owner(), _tSupply);
1142     }
1143 
1144     function _transfer(address from, address to, uint256 amount) internal override {
1145         require(from != ZERO, "ERC20: transfer from the zero address");
1146         require(to != ZERO, "ERC20: transfer to the zero address");
1147         require(amount > 0, "Transfer amount must be greater than zero");
1148 
1149         bool takeFee = true;
1150         TransactionType txType = (from == _uniswapV2Pair) ? TransactionType.BUY : (to == _uniswapV2Pair) ? TransactionType.SELL : TransactionType.TRANSFER;
1151         if (from != owner() && to != owner() && to != ZERO && to != DEAD && !_swapping) {
1152             require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted.");
1153 
1154             if(!tradingOpen) require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not allowed yet.");
1155 
1156             if (cooldownEnabled) {
1157                 if (to != address(_uniswapV2Router) && to != address(_uniswapV2Pair)) {
1158                     require(_cooldown[tx.origin] < block.number - _cooldownBlocks && _cooldown[to] < block.number - _cooldownBlocks, "Transfer delay enabled. Try again later.");
1159                     _cooldown[tx.origin] = block.number;
1160                     _cooldown[to] = block.number;
1161                 }
1162             }
1163 
1164             if (txType == TransactionType.BUY && to != address(_uniswapV2Router) && !_isExcludedMaxTransactionAmount[to]) {
1165                 require(amount <= maxBuyAmount, "Transfer amount exceeds the maxBuyAmount.");
1166                 require(balanceOf(to) + amount <= maxWalletAmount, "Exceeds maximum wallet token amount.");
1167             }
1168             
1169             if (txType == TransactionType.SELL && from != address(_uniswapV2Router) && !_isExcludedMaxTransactionAmount[from]) {
1170                 require(amount <= maxSellAmount, "Transfer amount exceeds the maxSellAmount.");
1171                 require(amount <= balanceOf(from).mul(maxSellPercentage).div(100), "Transfer amount exceeds the maxSellPercentage.");
1172 
1173                 if (vestingCooldownEnabled) {
1174                     if (from != address(_uniswapV2Router) && from != address(_uniswapV2Pair)) {
1175                         require(_vestingCooldown[tx.origin] < block.number - _vestingCooldownBlocks && _vestingCooldown[from] < block.number - _vestingCooldownBlocks, "You're vested. Try again later.");
1176                         _vestingCooldown[tx.origin] = block.number;
1177                         _vestingCooldown[from] = block.number;
1178                     }
1179                 }
1180 
1181             }
1182         }
1183 
1184         if(_isExcludedFromFees[from] || _isExcludedFromFees[to] || !feesEnabled || (!transferFeesEnabled && txType == TransactionType.TRANSFER)) takeFee = false;
1185 
1186         uint256 contractBalance = balanceOf(address(this));
1187         bool canSwap = (contractBalance > _swapTokensAtAmount) && (txType == TransactionType.SELL);
1188 
1189         if (canSwap && swapEnabled && !_swapping && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1190             _swapping = true;
1191             _swapBack(contractBalance);
1192             _swapping = false;
1193         }
1194 
1195         _tokenTransfer(from, to, amount, takeFee, txType);
1196     }
1197 
1198     function _swapBack(uint256 contractBalance) internal {
1199         uint256 totalTokensToSwap =  _tokensForMktg.add(_tokensForDev).add(_tokensForBuyback);
1200         bool success;
1201         
1202         if (contractBalance == 0 || totalTokensToSwap == 0) return;
1203 
1204         if (contractBalance > _swapTokensAtAmount.mul(5)) contractBalance = _swapTokensAtAmount.mul(5);
1205 
1206         _swapTokensForETH(contractBalance);
1207         
1208         uint256 ethBalance = address(this).balance;
1209         uint256 ethForDev = ethBalance.mul(_tokensForDev).div(totalTokensToSwap);
1210         uint256 ethForBuyback = ethBalance.mul(_tokensForBuyback).div(totalTokensToSwap);
1211         
1212         _tokensForMktg = 0;
1213         _tokensForDev = 0;
1214         _tokensForBuyback = 0;
1215 
1216         (success,) = address(_devWallet).call{value: ethForDev}("");
1217         (success,) = address(_buybackWallet).call{value: ethForBuyback}("");
1218         (success,) = address(_mktgWallet).call{value: address(this).balance}("");
1219     }
1220 
1221     function _swapTokensForETH(uint256 tokenAmount) internal {
1222         address[] memory path = new address[](2);
1223         path[0] = address(this);
1224         path[1] = _uniswapV2Router.WETH();
1225         _approve(address(this), address(_uniswapV2Router), tokenAmount);
1226         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1227             tokenAmount,
1228             0,
1229             path,
1230             address(this),
1231             block.timestamp
1232         );
1233     }
1234         
1235     function _sendETHToFee(uint256 amount) internal {
1236         _mktgWallet.transfer(amount.div(2));
1237         _devWallet.transfer(amount.div(2));
1238     }
1239 
1240     function isBlacklisted(address wallet) external view returns (bool) {
1241         return _isBlacklisted[wallet];
1242     }
1243 
1244     function openTrading(uint256 blocks) public onlyOwner {
1245         require(!tradingOpen, "Trading is already open");
1246         require(blocks <= 10, "Invalid blocks count.");
1247         maxBuyAmount = _tSupply.mul(2).div(1000);
1248         maxSellAmount = _tSupply.mul(1).div(1000);
1249         maxWalletAmount = _tSupply.mul(6).div(1000);
1250         maxSellPercentage = 25;
1251         _swapTokensAtAmount = _tSupply.mul(1).div(10000);
1252         swapEnabled = true;
1253         cooldownEnabled = true;
1254         vestingCooldownEnabled = true;
1255         tradingOpen = true;
1256         tradingOpenBlock = block.number;
1257         _blocksToBlacklist = blocks;
1258         emit OpenTrading(tradingOpenBlock, _blocksToBlacklist);
1259     }
1260 
1261     function setCooldownEnabled(bool onoff) public onlyOwner {
1262         cooldownEnabled = onoff;
1263     }
1264 
1265     function setVestingCooldownEnabled(bool onoff) public onlyOwner {
1266         vestingCooldownEnabled = onoff;
1267     }
1268 
1269     function setSwapEnabled(bool onoff) public onlyOwner {
1270         swapEnabled = onoff;
1271     }
1272 
1273     function setFeesEnabled(bool onoff) public onlyOwner {
1274         feesEnabled = onoff;
1275     }
1276 
1277     function setTransferFeesEnabled(bool onoff) public onlyOwner {
1278         transferFeesEnabled = onoff;
1279     }
1280 
1281     function setPIPenaltyEnabled(bool onoff) public onlyOwner {
1282         piPenaltyEnabled = onoff;
1283     }
1284 
1285     function setMaxBuyAmount(uint256 _maxBuyAmount) public onlyOwner {
1286         require(_maxBuyAmount >= (totalSupply().mul(1).div(1000)), "Max buy amount cannot be lower than 0.1% total supply.");
1287         maxBuyAmount = _maxBuyAmount;
1288         emit SetMaxBuyAmount(maxBuyAmount);
1289     }
1290 
1291     function setMaxSellAmount(uint256 _maxSellAmount) public onlyOwner {
1292         require(_maxSellAmount >= (totalSupply().mul(1).div(1000)), "Max sell amount cannot be lower than 0.1% total supply.");
1293         maxSellAmount = _maxSellAmount;
1294         emit SetMaxSellAmount(maxSellAmount);
1295     }
1296     
1297     function setMaxWalletAmount(uint256 _maxWalletAmount) public onlyOwner {
1298         require(_maxWalletAmount >= (totalSupply().mul(1).div(1000)), "Max wallet amount cannot be lower than 0.1% total supply.");
1299         maxWalletAmount = _maxWalletAmount;
1300         emit SetMaxWalletAmount(maxWalletAmount);
1301     }
1302 
1303     function setMaxSellPercentage(uint256 _maxSellPercentage) public onlyOwner {
1304         require(_maxSellPercentage >= 1, "Max sell percentage cannot be lower than 1%.");
1305         maxSellPercentage = _maxSellPercentage;
1306         emit SetMaxSellPercentage(maxSellPercentage);
1307     }
1308     
1309     function setSwapTokensAtAmount(uint256 swapTokensAtAmount) public onlyOwner {
1310         require(swapTokensAtAmount >= (totalSupply().mul(1).div(100000)), "Swap amount cannot be lower than 0.001% total supply.");
1311         require(swapTokensAtAmount <= (totalSupply().mul(5).div(1000)), "Swap amount cannot be higher than 0.5% total supply.");
1312         _swapTokensAtAmount = swapTokensAtAmount;
1313         emit SetSwapTokensAtAmount(_swapTokensAtAmount);
1314     }
1315 
1316     function setMktgWallet(address mktgWallet) public onlyOwner {
1317         require(mktgWallet != ZERO, "_mktgWallet address cannot be 0");
1318         _isExcludedFromFees[_mktgWallet] = false;
1319         _isExcludedMaxTransactionAmount[_mktgWallet] = false;
1320         _mktgWallet = payable(mktgWallet);
1321         _isExcludedFromFees[_mktgWallet] = true;
1322         _isExcludedMaxTransactionAmount[_mktgWallet] = true;
1323     }
1324 
1325     function setDevWallet(address devWallet) public onlyOwner {
1326         require(devWallet != ZERO, "_devWallet address cannot be 0");
1327         _isExcludedFromFees[_devWallet] = false;
1328         _isExcludedMaxTransactionAmount[_devWallet] = false;
1329         _devWallet = payable(devWallet);
1330         _isExcludedFromFees[_devWallet] = true;
1331         _isExcludedMaxTransactionAmount[_devWallet] = true;
1332     }
1333 
1334     function setBuybackWallet(address buybackWallet) public onlyOwner {
1335         require(buybackWallet != ZERO, "_buybackWallet address cannot be 0");
1336         _isExcludedFromFees[_buybackWallet] = false;
1337         _isExcludedMaxTransactionAmount[_buybackWallet] = false;
1338         _buybackWallet = payable(buybackWallet);
1339         _isExcludedFromFees[_buybackWallet] = true;
1340         _isExcludedMaxTransactionAmount[_buybackWallet] = true;
1341     }
1342 
1343     function setExcludedFromFees(address[] memory accounts, bool isEx) public onlyOwner {
1344         for (uint i = 0; i < accounts.length; i++) _isExcludedFromFees[accounts[i]] = isEx;
1345     }
1346     
1347     function setExcludeFromMaxTransaction(address[] memory accounts, bool isEx) public onlyOwner {
1348         for (uint i = 0; i < accounts.length; i++) _isExcludedMaxTransactionAmount[accounts[i]] = isEx;
1349     }
1350     
1351     function setBlacklisted(address[] memory accounts, bool isBL) public onlyOwner {
1352         for (uint i = 0; i < accounts.length; i++) {
1353             if((accounts[i] != _uniswapV2Pair) && (accounts[i] != address(_uniswapV2Router)) && (accounts[i] != address(this))) _isBlacklisted[accounts[i]] = isBL;
1354         }
1355     }
1356 
1357     function setBuyFee(uint256 _buyMktgFee, uint256 _buyDevFee, uint256 _buyBuybackFee) public onlyOwner {
1358         require(_buyMktgFee.add(_buyDevFee).add(_buyBuybackFee) <= 125, "Must keep buy taxes below 12.5%");
1359         buyMktgFee = _buyMktgFee;
1360         buyDevFee = _buyDevFee;
1361         buyBuybackFee = _buyBuybackFee;
1362         emit SetBuyFee(buyMktgFee, buyDevFee, buyBuybackFee);
1363     }
1364 
1365     function setSellFee(uint256 _sellMktgFee, uint256 _sellDevFee, uint256 _sellBuybackFee) public onlyOwner {
1366         require(_sellMktgFee.add(_sellDevFee).add(_sellBuybackFee) <= 250, "Must keep sell taxes below 25%");
1367         sellMktgFee = _sellMktgFee;
1368         sellDevFee = _sellDevFee;
1369         sellBuybackFee = _sellBuybackFee;
1370         emit SetSellFee(sellMktgFee, sellDevFee, sellBuybackFee);
1371     }
1372 
1373     function setTransferFee(uint256 _transferMktgFee, uint256 _transferDevFee, uint256 _transferBuybackFee) public onlyOwner {
1374         require(_transferMktgFee.add(_transferDevFee).add(_transferBuybackFee) <= 999, "Must keep sell taxes below 99%");
1375         transferMktgFee = _transferMktgFee;
1376         transferDevFee = _transferDevFee;
1377         transferBuybackFee = _transferBuybackFee;
1378         emit SetTransferFee(transferMktgFee, transferDevFee, transferBuybackFee);
1379     }
1380 
1381     function setPIPenaltyMultiplier(uint256 _piPenaltyMultiplier24, uint256 _piPenaltyMultiplier46, uint256 _piPenaltyMultiplier68, uint256 _piPenaltyMultiplier810, uint256 _piPenaltyMultiplier10more) public onlyOwner {
1382         piPenaltyMultiplier24 = _piPenaltyMultiplier24;
1383         piPenaltyMultiplier46 = _piPenaltyMultiplier46;
1384         piPenaltyMultiplier68 = _piPenaltyMultiplier68;
1385         piPenaltyMultiplier810 = _piPenaltyMultiplier810;
1386         piPenaltyMultiplier10more = _piPenaltyMultiplier10more;
1387         emit SetPenaltyMultiplier(piPenaltyMultiplier24, piPenaltyMultiplier46, piPenaltyMultiplier68, piPenaltyMultiplier810, piPenaltyMultiplier10more);
1388     }
1389 
1390     function setCooldownBlocks(uint256 blocks) public onlyOwner {
1391         require(blocks <= 10, "Invalid blocks count.");
1392         _cooldownBlocks = blocks;
1393     }
1394 
1395     function setVestingCooldownBlocks(uint256 blocks) public onlyOwner {
1396         require(blocks <= 215040, "Invalid blocks count.");
1397         _vestingCooldownBlocks = blocks;
1398     }
1399 
1400     function _removeAllFee() internal {
1401         if (buyMktgFee == 0 && buyDevFee == 0 && buyBuybackFee == 0 && sellMktgFee == 0 && sellDevFee == 0 && sellBuybackFee == 0) return;
1402 
1403         _previousBuyMktgFee = buyMktgFee;
1404         _previousBuyDevFee = buyDevFee;
1405         _previousBuyBuybackFee = buyBuybackFee;
1406         _previousSellMktgFee = sellMktgFee;
1407         _previousSellDevFee = sellDevFee;
1408         _previousSellBuybackFee = sellBuybackFee;
1409         
1410         buyMktgFee = 0;
1411         buyDevFee = 0;
1412         buyBuybackFee = 0;
1413         sellMktgFee = 0;
1414         sellDevFee = 0;
1415         sellBuybackFee = 0;
1416     }
1417     
1418     function _restoreAllFee() internal {
1419         buyMktgFee = _previousBuyMktgFee;
1420         buyDevFee = _previousBuyDevFee;
1421         buyBuybackFee = _previousBuyBuybackFee;
1422         sellMktgFee = _previousSellMktgFee;
1423         sellDevFee = _previousSellDevFee;
1424         sellBuybackFee = _previousSellBuybackFee;
1425     }
1426         
1427     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee, TransactionType txType) internal {
1428         if (!takeFee) _removeAllFee();
1429         else amount = _takeFees(sender, amount, txType);
1430 
1431         super._transfer(sender, recipient, amount);
1432         
1433         if (!takeFee) _restoreAllFee();
1434     }
1435 
1436     function _takeFees(address sender, uint256 amount, TransactionType txType) internal returns (uint256) {
1437         if(tradingOpenBlock + _blocksToBlacklist >= block.number) _setBot();
1438         else if (txType == TransactionType.SELL) _setSell(amount);
1439         else if (txType == TransactionType.BUY) _setBuy();
1440         else if (txType == TransactionType.TRANSFER) _setTransfer();
1441         else revert("Invalid transaction type.");
1442         
1443         uint256 fees;
1444         if (_totalFees > 0) {
1445             fees = amount.mul(_totalFees).div(FEE_DIVISOR);
1446             _tokensForMktg += fees * _mktgFee / _totalFees;
1447             _tokensForDev += fees * _devFee / _totalFees;
1448             _tokensForBuyback += fees * _buybackFee / _totalFees;
1449         }
1450 
1451         if (fees > 0) super._transfer(sender, address(this), fees);
1452 
1453         return amount -= fees;
1454     }
1455 
1456     function _setBot() internal {
1457         _mktgFee = 333;
1458         _devFee = 333;
1459         _buybackFee = 333;
1460         _totalFees = _mktgFee.add(_devFee).add(_buybackFee);
1461     }
1462 
1463     function _setSell(uint256 amount) internal {
1464         _mktgFee = sellMktgFee;
1465         _devFee = sellDevFee;
1466         _buybackFee = sellBuybackFee;
1467 
1468         if(piPenaltyEnabled) {
1469             uint256 pi = getPriceImpact(amount);
1470             if(pi > 2 ether && pi <= 4 ether) {
1471                 _mktgFee = _mktgFee.mul(piPenaltyMultiplier24).div(PENALTY_DIVISOR);
1472                 _devFee = _devFee.mul(piPenaltyMultiplier24).div(PENALTY_DIVISOR);
1473                 _buybackFee = _buybackFee.mul(piPenaltyMultiplier24).div(PENALTY_DIVISOR);
1474             } else if (pi > 4 ether && pi <= 6 ether) {
1475                 _mktgFee = _mktgFee.mul(piPenaltyMultiplier46).div(PENALTY_DIVISOR);
1476                 _devFee = _devFee.mul(piPenaltyMultiplier46).div(PENALTY_DIVISOR);
1477                 _buybackFee = _buybackFee.mul(piPenaltyMultiplier46).div(PENALTY_DIVISOR);
1478             } else if (pi > 6 ether && pi <= 8 ether) {
1479                 _mktgFee = _mktgFee.mul(piPenaltyMultiplier68).div(PENALTY_DIVISOR);
1480                 _devFee = _devFee.mul(piPenaltyMultiplier68).div(PENALTY_DIVISOR);
1481                 _buybackFee = _buybackFee.mul(piPenaltyMultiplier68).div(PENALTY_DIVISOR);
1482             } else if (pi > 8 ether && pi <= 10 ether) {
1483                 _mktgFee = _mktgFee.mul(piPenaltyMultiplier810).div(PENALTY_DIVISOR);
1484                 _devFee = _devFee.mul(piPenaltyMultiplier810).div(PENALTY_DIVISOR);
1485                 _buybackFee = _buybackFee.mul(piPenaltyMultiplier810).div(PENALTY_DIVISOR);
1486             } else if (pi > 10 ether) {
1487                 _mktgFee = _mktgFee.mul(piPenaltyMultiplier10more).div(PENALTY_DIVISOR);
1488                 _devFee = _devFee.mul(piPenaltyMultiplier10more).div(PENALTY_DIVISOR);
1489                 _buybackFee = _buybackFee.mul(piPenaltyMultiplier10more).div(PENALTY_DIVISOR);
1490             }
1491         }
1492 
1493         _totalFees = _mktgFee.add(_devFee).add(_buybackFee);
1494     }
1495 
1496     function _setBuy() internal {
1497         _mktgFee = buyMktgFee;
1498         _devFee = buyDevFee;
1499         _buybackFee = buyBuybackFee;
1500         _totalFees = _mktgFee.add(_devFee).add(_buybackFee);
1501     }
1502 
1503     function _setTransfer() internal {
1504         _mktgFee = transferMktgFee;
1505         _devFee = transferDevFee;
1506         _buybackFee = transferBuybackFee;
1507         _totalFees = _mktgFee.add(_devFee).add(_buybackFee);
1508     }
1509     
1510     function unclog() public onlyOwner {
1511         uint256 contractBalance = balanceOf(address(this));
1512         _swapTokensForETH(contractBalance);
1513     }
1514     
1515     function distributeFees() public onlyOwner {
1516         uint256 contractETHBalance = address(this).balance;
1517         _sendETHToFee(contractETHBalance);
1518     }
1519 
1520     function withdrawStuckETH() public onlyOwner {
1521         bool success;
1522         (success,) = address(msg.sender).call{value: address(this).balance}("");
1523     }
1524 
1525     function withdrawStuckTokens(address tkn) public onlyOwner {
1526         require(tkn != address(this), "Cannot withdraw own token");
1527         require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1528         uint amount = IERC20(tkn).balanceOf(address(this));
1529         IERC20(tkn).transfer(msg.sender, amount);
1530     }
1531 
1532     function removeLimits() public onlyOwner {
1533         maxBuyAmount = _tSupply;
1534         maxSellAmount = _tSupply;
1535         maxWalletAmount = _tSupply;
1536         cooldownEnabled = false;
1537     }
1538 
1539     function getConstantProduct() public view returns (uint256) {
1540         uint256 balanceThis = balanceOf(_uniswapV2Pair);
1541         uint256 balanceETH = WrappedETH.balanceOf(_uniswapV2Pair);
1542         return balanceThis.mul(balanceETH);
1543     }
1544 
1545     function getTokenPrice() public view returns (uint256) {
1546         uint256 balanceThis = balanceOf(_uniswapV2Pair).div(1 ether);
1547         uint256 balanceETH = WrappedETH.balanceOf(_uniswapV2Pair);
1548         return balanceETH.div(balanceThis);
1549     }
1550 
1551     function getPriceImpact(uint256 amount) public view returns (uint256) {
1552         uint256 iBalanceThis = balanceOf(_uniswapV2Pair);
1553         uint256 iETH = WrappedETH.balanceOf(_uniswapV2Pair);
1554 
1555         uint256 newBalanceThis = iBalanceThis.add(amount);
1556         uint256 ethAmount = getConstantProduct().div(newBalanceThis);
1557         uint256 ethToReceive = iETH.sub(ethAmount);
1558 
1559         return ((ethToReceive.mul(100)) / ethAmount).mul(1 ether);
1560     }
1561 
1562     receive() external payable {}
1563     fallback() external payable {}
1564 
1565 }