1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Stake $LIQ earn LP
5 
6 LiqBot: https://t.me/LiqSharesBot
7 Website: https://liqshares.com/
8 Twitter: https://twitter.com/LIQshares_
9 Telegram: https://t.me/LiqShares
10 */
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.3
35 
36 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         _checkOwner();
72         _;
73     }
74 
75     /**
76      * @dev Returns the address of the current owner.
77      */
78     function owner() public view virtual returns (address) {
79         return _owner;
80     }
81 
82     /**
83      * @dev Throws if the sender is not the owner.
84      */
85     function _checkOwner() internal view virtual {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions. Can only be called by the current owner.
92      *
93      * NOTE: Renouncing ownership will leave the contract without an owner,
94      * thereby disabling any functionality that is only available to the owner.
95      */
96     function renounceOwnership() public virtual onlyOwner {
97         _transferOwnership(address(0));
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(
106             newOwner != address(0),
107             "Ownable: new owner is the zero address"
108         );
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Internal function without access restriction.
115      */
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.3
124 
125 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Interface of the ERC20 standard as defined in the EIP.
131  */
132 interface IERC20 {
133     /**
134      * @dev Emitted when `value` tokens are moved from one account (`from`) to
135      * another (`to`).
136      *
137      * Note that `value` may be zero.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     /**
142      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
143      * a call to {approve}. `value` is the new allowance.
144      */
145     event Approval(
146         address indexed owner,
147         address indexed spender,
148         uint256 value
149     );
150 
151     /**
152      * @dev Returns the amount of tokens in existence.
153      */
154     function totalSupply() external view returns (uint256);
155 
156     /**
157      * @dev Returns the amount of tokens owned by `account`.
158      */
159     function balanceOf(address account) external view returns (uint256);
160 
161     /**
162      * @dev Moves `amount` tokens from the caller's account to `to`.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transfer(address to, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Returns the remaining number of tokens that `spender` will be
172      * allowed to spend on behalf of `owner` through {transferFrom}. This is
173      * zero by default.
174      *
175      * This value changes when {approve} or {transferFrom} are called.
176      */
177     function allowance(address owner, address spender)
178     external
179     view
180     returns (uint256);
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
199      * @dev Moves `amount` tokens from `from` to `to` using the
200      * allowance mechanism. `amount` is then deducted from the caller's
201      * allowance.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 amount
211     ) external returns (bool);
212 }
213 
214 // File @openzeppelin/contracts/interfaces/IERC20.sol@v4.9.3
215 
216 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
217 
218 pragma solidity ^0.8.0;
219 
220 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.3
221 
222 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev Interface for the optional metadata functions from the ERC20 standard.
228  *
229  * _Available since v4.1._
230  */
231 interface IERC20Metadata is IERC20 {
232     /**
233      * @dev Returns the name of the token.
234      */
235     function name() external view returns (string memory);
236 
237     /**
238      * @dev Returns the symbol of the token.
239      */
240     function symbol() external view returns (string memory);
241 
242     /**
243      * @dev Returns the decimals places of the token.
244      */
245     function decimals() external view returns (uint8);
246 }
247 
248 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.3
249 
250 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Implementation of the {IERC20} interface.
256  *
257  * This implementation is agnostic to the way tokens are created. This means
258  * that a supply mechanism has to be added in a derived contract using {_mint}.
259  * For a generic mechanism see {ERC20PresetMinterPauser}.
260  *
261  * TIP: For a detailed writeup see our guide
262  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
263  * to implement supply mechanisms].
264  *
265  * The default value of {decimals} is 18. To change this, you should override
266  * this function so it returns a different value.
267  *
268  * We have followed general OpenZeppelin Contracts guidelines: functions revert
269  * instead returning `false` on failure. This behavior is nonetheless
270  * conventional and does not conflict with the expectations of ERC20
271  * applications.
272  *
273  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
274  * This allows applications to reconstruct the allowance for all accounts just
275  * by listening to said events. Other implementations of the EIP may not emit
276  * these events, as it isn't required by the specification.
277  *
278  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
279  * functions have been added to mitigate the well-known issues around setting
280  * allowances. See {IERC20-approve}.
281  */
282 contract ERC20 is Context, IERC20, IERC20Metadata {
283     mapping(address => uint256) private _balances;
284 
285     mapping(address => mapping(address => uint256)) private _allowances;
286 
287     uint256 private _totalSupply;
288 
289     string private _name;
290     string private _symbol;
291 
292     /**
293      * @dev Sets the values for {name} and {symbol}.
294      *
295      * All two of these values are immutable: they can only be set once during
296      * construction.
297      */
298     constructor(string memory name_, string memory symbol_) {
299         _name = name_;
300         _symbol = symbol_;
301     }
302 
303     /**
304      * @dev Returns the name of the token.
305      */
306     function name() public view virtual override returns (string memory) {
307         return _name;
308     }
309 
310     /**
311      * @dev Returns the symbol of the token, usually a shorter version of the
312      * name.
313      */
314     function symbol() public view virtual override returns (string memory) {
315         return _symbol;
316     }
317 
318     /**
319      * @dev Returns the number of decimals used to get its user representation.
320      * For example, if `decimals` equals `2`, a balance of `505` tokens should
321      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
322      *
323      * Tokens usually opt for a value of 18, imitating the relationship between
324      * Ether and Wei. This is the default value returned by this function, unless
325      * it's overridden.
326      *
327      * NOTE: This information is only used for _display_ purposes: it in
328      * no way affects any of the arithmetic of the contract, including
329      * {IERC20-balanceOf} and {IERC20-transfer}.
330      */
331     function decimals() public view virtual override returns (uint8) {
332         return 18;
333     }
334 
335     /**
336      * @dev See {IERC20-totalSupply}.
337      */
338     function totalSupply() public view virtual override returns (uint256) {
339         return _totalSupply;
340     }
341 
342     /**
343      * @dev See {IERC20-balanceOf}.
344      */
345     function balanceOf(address account)
346     public
347     view
348     virtual
349     override
350     returns (uint256)
351     {
352         return _balances[account];
353     }
354 
355     /**
356      * @dev See {IERC20-transfer}.
357      *
358      * Requirements:
359      *
360      * - `to` cannot be the zero address.
361      * - the caller must have a balance of at least `amount`.
362      */
363     function transfer(address to, uint256 amount)
364     public
365     virtual
366     override
367     returns (bool)
368     {
369         address owner = _msgSender();
370         _transfer(owner, to, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-allowance}.
376      */
377     function allowance(address owner, address spender)
378     public
379     view
380     virtual
381     override
382     returns (uint256)
383     {
384         return _allowances[owner][spender];
385     }
386 
387     /**
388      * @dev See {IERC20-approve}.
389      *
390      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
391      * `transferFrom`. This is semantically equivalent to an infinite approval.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function approve(address spender, uint256 amount)
398     public
399     virtual
400     override
401     returns (bool)
402     {
403         address owner = _msgSender();
404         _approve(owner, spender, amount);
405         return true;
406     }
407 
408     /**
409      * @dev See {IERC20-transferFrom}.
410      *
411      * Emits an {Approval} event indicating the updated allowance. This is not
412      * required by the EIP. See the note at the beginning of {ERC20}.
413      *
414      * NOTE: Does not update the allowance if the current allowance
415      * is the maximum `uint256`.
416      *
417      * Requirements:
418      *
419      * - `from` and `to` cannot be the zero address.
420      * - `from` must have a balance of at least `amount`.
421      * - the caller must have allowance for ``from``'s tokens of at least
422      * `amount`.
423      */
424     function transferFrom(
425         address from,
426         address to,
427         uint256 amount
428     ) public virtual override returns (bool) {
429         address spender = _msgSender();
430         _spendAllowance(from, spender, amount);
431         _transfer(from, to, amount);
432         return true;
433     }
434 
435     /**
436      * @dev Atomically increases the allowance granted to `spender` by the caller.
437      *
438      * This is an alternative to {approve} that can be used as a mitigation for
439      * problems described in {IERC20-approve}.
440      *
441      * Emits an {Approval} event indicating the updated allowance.
442      *
443      * Requirements:
444      *
445      * - `spender` cannot be the zero address.
446      */
447     function increaseAllowance(address spender, uint256 addedValue)
448     public
449     virtual
450     returns (bool)
451     {
452         address owner = _msgSender();
453         _approve(owner, spender, allowance(owner, spender) + addedValue);
454         return true;
455     }
456 
457     /**
458      * @dev Atomically decreases the allowance granted to `spender` by the caller.
459      *
460      * This is an alternative to {approve} that can be used as a mitigation for
461      * problems described in {IERC20-approve}.
462      *
463      * Emits an {Approval} event indicating the updated allowance.
464      *
465      * Requirements:
466      *
467      * - `spender` cannot be the zero address.
468      * - `spender` must have allowance for the caller of at least
469      * `subtractedValue`.
470      */
471     function decreaseAllowance(address spender, uint256 subtractedValue)
472     public
473     virtual
474     returns (bool)
475     {
476         address owner = _msgSender();
477         uint256 currentAllowance = allowance(owner, spender);
478         require(
479             currentAllowance >= subtractedValue,
480             "ERC20: decreased allowance below zero"
481         );
482         unchecked {
483             _approve(owner, spender, currentAllowance - subtractedValue);
484         }
485 
486         return true;
487     }
488 
489     /**
490      * @dev Moves `amount` of tokens from `from` to `to`.
491      *
492      * This internal function is equivalent to {transfer}, and can be used to
493      * e.g. implement automatic token fees, slashing mechanisms, etc.
494      *
495      * Emits a {Transfer} event.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `from` must have a balance of at least `amount`.
502      */
503     function _transfer(
504         address from,
505         address to,
506         uint256 amount
507     ) internal virtual {
508         require(from != address(0), "ERC20: transfer from the zero address");
509         require(to != address(0), "ERC20: transfer to the zero address");
510 
511         _beforeTokenTransfer(from, to, amount);
512 
513         uint256 fromBalance = _balances[from];
514         require(
515             fromBalance >= amount,
516             "ERC20: transfer amount exceeds balance"
517         );
518         unchecked {
519             _balances[from] = fromBalance - amount;
520         // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
521         // decrementing then incrementing.
522             _balances[to] += amount;
523         }
524 
525         emit Transfer(from, to, amount);
526 
527         _afterTokenTransfer(from, to, amount);
528     }
529 
530     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
531      * the total supply.
532      *
533      * Emits a {Transfer} event with `from` set to the zero address.
534      *
535      * Requirements:
536      *
537      * - `account` cannot be the zero address.
538      */
539     function _mint(address account, uint256 amount) internal virtual {
540         require(account != address(0), "ERC20: mint to the zero address");
541 
542         _beforeTokenTransfer(address(0), account, amount);
543 
544         _totalSupply += amount;
545         unchecked {
546         // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
547             _balances[account] += amount;
548         }
549         emit Transfer(address(0), account, amount);
550 
551         _afterTokenTransfer(address(0), account, amount);
552     }
553 
554     /**
555      * @dev Destroys `amount` tokens from `account`, reducing the
556      * total supply.
557      *
558      * Emits a {Transfer} event with `to` set to the zero address.
559      *
560      * Requirements:
561      *
562      * - `account` cannot be the zero address.
563      * - `account` must have at least `amount` tokens.
564      */
565     function _burn(address account, uint256 amount) internal virtual {
566         require(account != address(0), "ERC20: burn from the zero address");
567 
568         _beforeTokenTransfer(account, address(0), amount);
569 
570         uint256 accountBalance = _balances[account];
571         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
572         unchecked {
573             _balances[account] = accountBalance - amount;
574         // Overflow not possible: amount <= accountBalance <= totalSupply.
575             _totalSupply -= amount;
576         }
577 
578         emit Transfer(account, address(0), amount);
579 
580         _afterTokenTransfer(account, address(0), amount);
581     }
582 
583     /**
584      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
585      *
586      * This internal function is equivalent to `approve`, and can be used to
587      * e.g. set automatic allowances for certain subsystems, etc.
588      *
589      * Emits an {Approval} event.
590      *
591      * Requirements:
592      *
593      * - `owner` cannot be the zero address.
594      * - `spender` cannot be the zero address.
595      */
596     function _approve(
597         address owner,
598         address spender,
599         uint256 amount
600     ) internal virtual {
601         require(owner != address(0), "ERC20: approve from the zero address");
602         require(spender != address(0), "ERC20: approve to the zero address");
603 
604         _allowances[owner][spender] = amount;
605         emit Approval(owner, spender, amount);
606     }
607 
608     /**
609      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
610      *
611      * Does not update the allowance amount in case of infinite allowance.
612      * Revert if not enough allowance is available.
613      *
614      * Might emit an {Approval} event.
615      */
616     function _spendAllowance(
617         address owner,
618         address spender,
619         uint256 amount
620     ) internal virtual {
621         uint256 currentAllowance = allowance(owner, spender);
622         if (currentAllowance != type(uint256).max) {
623             require(
624                 currentAllowance >= amount,
625                 "ERC20: insufficient allowance"
626             );
627             unchecked {
628                 _approve(owner, spender, currentAllowance - amount);
629             }
630         }
631     }
632 
633     /**
634      * @dev Hook that is called before any transfer of tokens. This includes
635      * minting and burning.
636      *
637      * Calling conditions:
638      *
639      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
640      * will be transferred to `to`.
641      * - when `from` is zero, `amount` tokens will be minted for `to`.
642      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
643      * - `from` and `to` are never both zero.
644      *
645      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
646      */
647     function _beforeTokenTransfer(
648         address from,
649         address to,
650         uint256 amount
651     ) internal virtual {}
652 
653     /**
654      * @dev Hook that is called after any transfer of tokens. This includes
655      * minting and burning.
656      *
657      * Calling conditions:
658      *
659      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
660      * has been transferred to `to`.
661      * - when `from` is zero, `amount` tokens have been minted for `to`.
662      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
663      * - `from` and `to` are never both zero.
664      *
665      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
666      */
667     function _afterTokenTransfer(
668         address from,
669         address to,
670         uint256 amount
671     ) internal virtual {}
672 }
673 
674 // File contracts/ILPDiv.sol
675 
676 pragma solidity ^0.8.6;
677 
678 interface DividendPayingTokenInterface {
679     /// @notice View the amount of dividend in wei that an address can withdraw.
680     /// @param _owner The address of a token holder.
681     /// @return The amount of dividend in wei that `_owner` can withdraw.
682     function dividendOf(address _owner) external view returns (uint256);
683 
684     /// @notice Withdraws the ether distributed to the sender.
685     /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
686     ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
687     function withdrawDividend() external;
688 
689     /// @notice View the amount of dividend in wei that an address can withdraw.
690     /// @param _owner The address of a token holder.
691     /// @return The amount of dividend in wei that `_owner` can withdraw.
692     function withdrawableDividendOf(address _owner)
693     external
694     view
695     returns (uint256);
696 
697     /// @notice View the amount of dividend in wei that an address has withdrawn.
698     /// @param _owner The address of a token holder.
699     /// @return The amount of dividend in wei that `_owner` has withdrawn.
700     function withdrawnDividendOf(address _owner)
701     external
702     view
703     returns (uint256);
704 
705     /// @notice View the amount of dividend in wei that an address has earned in total.
706     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
707     /// @param _owner The address of a token holder.
708     /// @return The amount of dividend in wei that `_owner` has earned in total.
709     function accumulativeDividendOf(address _owner)
710     external
711     view
712     returns (uint256);
713 
714     /// @dev This event MUST emit when ether is distributed to token holders.
715     /// @param from The address which sends ether to this contract.
716     /// @param weiAmount The amount of distributed ether in wei.
717     event DividendsDistributed(address indexed from, uint256 weiAmount);
718 
719     /// @dev This event MUST emit when an address withdraws their dividend.
720     /// @param to The address which withdraws ether from this contract.
721     /// @param weiAmount The amount of withdrawn ether in wei.
722     event DividendWithdrawn(address indexed to, uint256 weiAmount);
723 }
724 
725 // File contracts/SafeMath.sol
726 
727 pragma solidity ^0.8.6;
728 
729 library SafeMath {
730     /**
731      * @dev Returns the addition of two unsigned integers, reverting on
732      * overflow.
733      *
734      * Counterpart to Solidity's `+` operator.
735      *
736      * Requirements:
737      *
738      * - Addition cannot overflow.
739      */
740     function add(uint256 a, uint256 b) internal pure returns (uint256) {
741         uint256 c = a + b;
742         require(c >= a, "SafeMath: addition overflow");
743 
744         return c;
745     }
746 
747     /**
748      * @dev Returns the subtraction of two unsigned integers, reverting on
749      * overflow (when the result is negative).
750      *
751      * Counterpart to Solidity's `-` operator.
752      *
753      * Requirements:
754      *
755      * - Subtraction cannot overflow.
756      */
757     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
758         return sub(a, b, "SafeMath: subtraction overflow");
759     }
760 
761     /**
762      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
763      * overflow (when the result is negative).
764      *
765      * Counterpart to Solidity's `-` operator.
766      *
767      * Requirements:
768      *
769      * - Subtraction cannot overflow.
770      */
771     function sub(
772         uint256 a,
773         uint256 b,
774         string memory errorMessage
775     ) internal pure returns (uint256) {
776         require(b <= a, errorMessage);
777         uint256 c = a - b;
778 
779         return c;
780     }
781 
782     /**
783      * @dev Returns the multiplication of two unsigned integers, reverting on
784      * overflow.
785      *
786      * Counterpart to Solidity's `*` operator.
787      *
788      * Requirements:
789      *
790      * - Multiplication cannot overflow.
791      */
792     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
793         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
794         // benefit is lost if 'b' is also tested.
795         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
796         if (a == 0) {
797             return 0;
798         }
799 
800         uint256 c = a * b;
801         require(c / a == b, "SafeMath: multiplication overflow");
802 
803         return c;
804     }
805 
806     /**
807      * @dev Returns the integer division of two unsigned integers. Reverts on
808      * division by zero. The result is rounded towards zero.
809      *
810      * Counterpart to Solidity's `/` operator. Note: this function uses a
811      * `revert` opcode (which leaves remaining gas untouched) while Solidity
812      * uses an invalid opcode to revert (consuming all remaining gas).
813      *
814      * Requirements:
815      *
816      * - The divisor cannot be zero.
817      */
818     function div(uint256 a, uint256 b) internal pure returns (uint256) {
819         return div(a, b, "SafeMath: division by zero");
820     }
821 
822     /**
823      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
824      * division by zero. The result is rounded towards zero.
825      *
826      * Counterpart to Solidity's `/` operator. Note: this function uses a
827      * `revert` opcode (which leaves remaining gas untouched) while Solidity
828      * uses an invalid opcode to revert (consuming all remaining gas).
829      *
830      * Requirements:
831      *
832      * - The divisor cannot be zero.
833      */
834     function div(
835         uint256 a,
836         uint256 b,
837         string memory errorMessage
838     ) internal pure returns (uint256) {
839         require(b > 0, errorMessage);
840         uint256 c = a / b;
841         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
842 
843         return c;
844     }
845 
846     /**
847      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
848      * Reverts when dividing by zero.
849      *
850      * Counterpart to Solidity's `%` operator. This function uses a `revert`
851      * opcode (which leaves remaining gas untouched) while Solidity uses an
852      * invalid opcode to revert (consuming all remaining gas).
853      *
854      * Requirements:
855      *
856      * - The divisor cannot be zero.
857      */
858     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
859         return mod(a, b, "SafeMath: modulo by zero");
860     }
861 
862     /**
863      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
864      * Reverts with custom message when dividing by zero.
865      *
866      * Counterpart to Solidity's `%` operator. This function uses a `revert`
867      * opcode (which leaves remaining gas untouched) while Solidity uses an
868      * invalid opcode to revert (consuming all remaining gas).
869      *
870      * Requirements:
871      *
872      * - The divisor cannot be zero.
873      */
874     function mod(
875         uint256 a,
876         uint256 b,
877         string memory errorMessage
878     ) internal pure returns (uint256) {
879         require(b != 0, errorMessage);
880         return a % b;
881     }
882 }
883 
884 /**
885  * @title SafeMathInt
886  * @dev Math operations for int256 with overflow safety checks.
887  */
888 library SafeMathInt {
889     int256 private constant MIN_INT256 = int256(1) << 255;
890     int256 private constant MAX_INT256 = ~(int256(1) << 255);
891 
892     /**
893      * @dev Multiplies two int256 variables and fails on overflow.
894      */
895     function mul(int256 a, int256 b) internal pure returns (int256) {
896         int256 c = a * b;
897 
898         // Detect overflow when multiplying MIN_INT256 with -1
899         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
900         require((b == 0) || (c / b == a));
901         return c;
902     }
903 
904     /**
905      * @dev Division of two int256 variables and fails on overflow.
906      */
907     function div(int256 a, int256 b) internal pure returns (int256) {
908         // Prevent overflow when dividing MIN_INT256 by -1
909         require(b != -1 || a != MIN_INT256);
910 
911         // Solidity already throws when dividing by 0.
912         return a / b;
913     }
914 
915     /**
916      * @dev Subtracts two int256 variables and fails on overflow.
917      */
918     function sub(int256 a, int256 b) internal pure returns (int256) {
919         int256 c = a - b;
920         require((b >= 0 && c <= a) || (b < 0 && c > a));
921         return c;
922     }
923 
924     /**
925      * @dev Adds two int256 variables and fails on overflow.
926      */
927     function add(int256 a, int256 b) internal pure returns (int256) {
928         int256 c = a + b;
929         require((b >= 0 && c >= a) || (b < 0 && c < a));
930         return c;
931     }
932 
933     /**
934      * @dev Converts to absolute value, and fails on overflow.
935      */
936     function abs(int256 a) internal pure returns (int256) {
937         require(a != MIN_INT256);
938         return a < 0 ? -a : a;
939     }
940 
941     function toUint256Safe(int256 a) internal pure returns (uint256) {
942         require(a >= 0);
943         return uint256(a);
944     }
945 }
946 
947 /**
948  * @title SafeMathUint
949  * @dev Math operations with safety checks that revert on error
950  */
951 library SafeMathUint {
952     function toInt256Safe(uint256 a) internal pure returns (int256) {
953         int256 b = int256(a);
954         require(b >= 0);
955         return b;
956     }
957 }
958 
959 // File contracts/LPDiv.sol
960 
961 pragma solidity ^0.8.10;
962 
963 interface IPair {
964     function getReserves()
965     external
966     view
967     returns (
968         uint112 reserve0,
969         uint112 reserve1,
970         uint32 blockTimestampLast
971     );
972 
973     function token0() external view returns (address);
974 }
975 
976 interface IFactory {
977     function createPair(address tokenA, address tokenB)
978     external
979     returns (address pair);
980 
981     function getPair(address tokenA, address tokenB)
982     external
983     view
984     returns (address pair);
985 }
986 
987 interface IUniswapRouter {
988     function factory() external pure returns (address);
989 
990     function WETH() external pure returns (address);
991 
992     function addLiquidityETH(
993         address token,
994         uint256 amountTokenDesired,
995         uint256 amountTokenMin,
996         uint256 amountETHMin,
997         address to,
998         uint256 deadline
999     )
1000     external
1001     payable
1002     returns (
1003         uint256 amountToken,
1004         uint256 amountETH,
1005         uint256 liquidity
1006     );
1007 
1008     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1009         uint256 amountIn,
1010         uint256 amountOutMin,
1011         address[] calldata path,
1012         address to,
1013         uint256 deadline
1014     ) external;
1015 
1016     function swapExactETHForTokens(
1017         uint256 amountOutMin,
1018         address[] calldata path,
1019         address to,
1020         uint256 deadline
1021     ) external payable returns (uint256[] memory amounts);
1022 
1023     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1024         uint256 amountIn,
1025         uint256 amountOutMin,
1026         address[] calldata path,
1027         address to,
1028         uint256 deadline
1029     ) external;
1030 }
1031 
1032 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, Ownable {
1033     using SafeMath for uint256;
1034     using SafeMathUint for uint256;
1035     using SafeMathInt for int256;
1036 
1037     address public LP_Token;
1038 
1039     // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1040     // For more discussion about choosing the value of `magnitude`,
1041     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1042     uint256 internal constant magnitude = 2**128;
1043 
1044     uint256 internal magnifiedDividendPerShare;
1045 
1046     // About dividendCorrection:
1047     // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1048     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1049     // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1050     //   `dividendOf(_user)` should not be changed,
1051     //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1052     // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1053     //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1054     //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1055     //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1056     // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1057     mapping(address => int256) internal magnifiedDividendCorrections;
1058     mapping(address => uint256) internal withdrawnDividends;
1059 
1060     uint256 public totalDividendsDistributed;
1061     uint256 public totalDividendsWithdrawn;
1062 
1063     constructor(string memory _name, string memory _symbol)
1064     ERC20(_name, _symbol)
1065     {}
1066 
1067     function distributeLPDividends(uint256 amount) public onlyOwner {
1068         require(totalSupply() > 0);
1069 
1070         if (amount > 0) {
1071             magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1072                 (amount).mul(magnitude) / totalSupply()
1073             );
1074             emit DividendsDistributed(msg.sender, amount);
1075 
1076             totalDividendsDistributed = totalDividendsDistributed.add(amount);
1077         }
1078     }
1079 
1080     /// @notice Withdraws the ether distributed to the sender.
1081     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1082     function withdrawDividend() public virtual override {
1083         _withdrawDividendOfUser(payable(msg.sender));
1084     }
1085 
1086     /// @notice Withdraws the ether distributed to the sender.
1087     /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1088     function _withdrawDividendOfUser(address payable user)
1089     internal
1090     returns (uint256)
1091     {
1092         uint256 _withdrawableDividend = withdrawableDividendOf(user);
1093         if (_withdrawableDividend > 0) {
1094             withdrawnDividends[user] = withdrawnDividends[user].add(
1095                 _withdrawableDividend
1096             );
1097             totalDividendsWithdrawn += _withdrawableDividend;
1098             emit DividendWithdrawn(user, _withdrawableDividend);
1099             bool success = IERC20(LP_Token).transfer(
1100                 user,
1101                 _withdrawableDividend
1102             );
1103 
1104             if (!success) {
1105                 withdrawnDividends[user] = withdrawnDividends[user].sub(
1106                     _withdrawableDividend
1107                 );
1108                 totalDividendsWithdrawn -= _withdrawableDividend;
1109                 return 0;
1110             }
1111 
1112             return _withdrawableDividend;
1113         }
1114 
1115         return 0;
1116     }
1117 
1118     /// @notice View the amount of dividend in wei that an address can withdraw.
1119     /// @param _owner The address of a token holder.
1120     /// @return The amount of dividend in wei that `_owner` can withdraw.
1121     function dividendOf(address _owner) public view override returns (uint256) {
1122         return withdrawableDividendOf(_owner);
1123     }
1124 
1125     /// @notice View the amount of dividend in wei that an address can withdraw.
1126     /// @param _owner The address of a token holder.
1127     /// @return The amount of dividend in wei that `_owner` can withdraw.
1128     function withdrawableDividendOf(address _owner)
1129     public
1130     view
1131     override
1132     returns (uint256)
1133     {
1134         return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1135     }
1136 
1137     /// @notice View the amount of dividend in wei that an address has withdrawn.
1138     /// @param _owner The address of a token holder.
1139     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1140     function withdrawnDividendOf(address _owner)
1141     public
1142     view
1143     override
1144     returns (uint256)
1145     {
1146         return withdrawnDividends[_owner];
1147     }
1148 
1149     /// @notice View the amount of dividend in wei that an address has earned in total.
1150     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1151     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1152     /// @param _owner The address of a token holder.
1153     /// @return The amount of dividend in wei that `_owner` has earned in total.
1154     function accumulativeDividendOf(address _owner)
1155     public
1156     view
1157     override
1158     returns (uint256)
1159     {
1160         return
1161             magnifiedDividendPerShare
1162             .mul(balanceOf(_owner))
1163             .toInt256Safe()
1164             .add(magnifiedDividendCorrections[_owner])
1165             .toUint256Safe() / magnitude;
1166     }
1167 
1168     /// @dev Internal function that transfer tokens from one address to another.
1169     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1170     /// @param from The address to transfer from.
1171     /// @param to The address to transfer to.
1172     /// @param value The amount to be transferred.
1173     function _transfer(
1174         address from,
1175         address to,
1176         uint256 value
1177     ) internal virtual override {
1178         require(false);
1179 
1180         int256 _magCorrection = magnifiedDividendPerShare
1181             .mul(value)
1182             .toInt256Safe();
1183         magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from]
1184             .add(_magCorrection);
1185         magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(
1186             _magCorrection
1187         );
1188     }
1189 
1190     /// @dev Internal function that mints tokens to an account.
1191     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1192     /// @param account The account that will receive the created tokens.
1193     /// @param value The amount that will be created.
1194     function _mint(address account, uint256 value) internal override {
1195         super._mint(account, value);
1196 
1197         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
1198                     account
1199             ].sub((magnifiedDividendPerShare.mul(value)).toInt256Safe());
1200     }
1201 
1202     /// @dev Internal function that burns an amount of the token of a given account.
1203     /// Update magnifiedDividendCorrections to keep dividends unchanged.
1204     /// @param account The account whose tokens will be burnt.
1205     /// @param value The amount that will be burnt.
1206     function _burn(address account, uint256 value) internal override {
1207         super._burn(account, value);
1208 
1209         magnifiedDividendCorrections[account] = magnifiedDividendCorrections[
1210                     account
1211             ].add((magnifiedDividendPerShare.mul(value)).toInt256Safe());
1212     }
1213 
1214     function _setBalance(address account, uint256 newBalance) internal {
1215         uint256 currentBalance = balanceOf(account);
1216 
1217         if (newBalance > currentBalance) {
1218             uint256 mintAmount = newBalance.sub(currentBalance);
1219             _mint(account, mintAmount);
1220         } else if (newBalance < currentBalance) {
1221             uint256 burnAmount = currentBalance.sub(newBalance);
1222             _burn(account, burnAmount);
1223         }
1224     }
1225 }
1226 
1227 pragma solidity ^0.8.21;
1228 
1229 contract LiqShares is ERC20, Ownable {
1230     IUniswapRouter public router;
1231     address public pair;
1232 
1233     bool private swapping;
1234     bool public swapEnabled = true;
1235     bool public claimEnabled;
1236     bool public tradingEnabled;
1237 
1238     DividendTracker public dividendTracker;
1239 
1240     address public devWallet;
1241 
1242     uint256 public swapTokensAtAmount;
1243     uint256 public maxBuyAmount;
1244     uint256 public maxSellAmount;
1245     uint256 public maxWallet;
1246 
1247     struct Taxes {
1248         uint256 liquidity;
1249         uint256 dev;
1250     }
1251 
1252     Taxes public buyTaxes = Taxes(3, 2);
1253     Taxes public sellTaxes = Taxes(3, 2);
1254 
1255     uint256 public totalBuyTax = 5;
1256     uint256 public totalSellTax = 5;
1257 
1258     uint256 private _initialTax = 20;
1259     uint256 private _reduceTaxAt = 30;
1260     uint256 private _buyCount = 0;
1261     uint256 private _sellCount = 0;
1262 
1263     mapping(address => bool) private _isExcludedFromFees;
1264     mapping(address => bool) public automatedMarketMakerPairs;
1265     mapping(address => bool) private _isExcludedFromMaxWallet;
1266 
1267     ///////////////
1268     //   Events  //
1269     ///////////////
1270 
1271     event ExcludeFromFees(address indexed account, bool isExcluded);
1272     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1273     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1274     event GasForProcessingUpdated(
1275         uint256 indexed newValue,
1276         uint256 indexed oldValue
1277     );
1278     event SendDividends(uint256 tokensSwapped, uint256 amount);
1279     event ProcessedDividendTracker(
1280         uint256 iterations,
1281         uint256 claims,
1282         uint256 lastProcessedIndex,
1283         bool indexed automatic,
1284         uint256 gas,
1285         address indexed processor
1286     );
1287 
1288     constructor() ERC20("LIQ", "LiqShares") {
1289         dividendTracker = new DividendTracker();
1290         setDevWallet(_msgSender());
1291 
1292         IUniswapRouter _router = IUniswapRouter(
1293             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1294         );
1295         address _pair = IFactory(_router.factory()).createPair(
1296             address(this),
1297             _router.WETH()
1298         );
1299 
1300         router = _router;
1301         pair = _pair;
1302         setSwapTokensAtAmount(3000000); //
1303         updateMaxWalletAmount(20000000);
1304         setMaxBuyAndSell(20000000, 20000000);
1305 
1306         _setAutomatedMarketMakerPair(_pair, true);
1307 
1308         dividendTracker.updateLP_Token(pair);
1309 
1310         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1311         dividendTracker.excludeFromDividends(address(this), true);
1312         dividendTracker.excludeFromDividends(owner(), true);
1313         dividendTracker.excludeFromDividends(address(0xdead), true);
1314         dividendTracker.excludeFromDividends(address(_router), true);
1315 
1316         excludeFromMaxWallet(address(_pair), true);
1317         excludeFromMaxWallet(address(this), true);
1318         excludeFromMaxWallet(address(_router), true);
1319 
1320         excludeFromFees(owner(), true);
1321         excludeFromFees(address(this), true);
1322 
1323         _mint(owner(), 1000000000 * (10**18));
1324     }
1325 
1326     receive() external payable {}
1327 
1328     function updateDividendTracker(address newAddress) public onlyOwner {
1329         DividendTracker newDividendTracker = DividendTracker(
1330             payable(newAddress)
1331         );
1332         newDividendTracker.excludeFromDividends(
1333             address(newDividendTracker),
1334             true
1335         );
1336         newDividendTracker.excludeFromDividends(address(this), true);
1337         newDividendTracker.excludeFromDividends(owner(), true);
1338         newDividendTracker.excludeFromDividends(address(router), true);
1339         dividendTracker = newDividendTracker;
1340     }
1341 
1342     /// @notice Manual claim the dividends
1343     function claim() external {
1344         require(claimEnabled, "Claim not enabled");
1345         dividendTracker.processAccount(payable(msg.sender));
1346     }
1347 
1348     function updateMaxWalletAmount(uint256 newNum) public onlyOwner {
1349         require(newNum >= 10000000, "Cannot set maxWallet lower than 1%");
1350         maxWallet = newNum * 10**18;
1351     }
1352 
1353     function setMaxBuyAndSell(uint256 maxBuy, uint256 maxSell)
1354     public
1355     onlyOwner
1356     {
1357         require(maxBuy >= 10000000, "Cannot set maxbuy lower than 1% ");
1358         require(maxSell >= 5000000, "Cannot set maxsell lower than 0.5% ");
1359         maxBuyAmount = maxBuy * 10**18;
1360         maxSellAmount = maxSell * 10**18;
1361     }
1362 
1363     function setSwapTokensAtAmount(uint256 amount) public onlyOwner {
1364         swapTokensAtAmount = amount * 10**18;
1365     }
1366 
1367     function excludeFromMaxWallet(address account, bool excluded)
1368     public
1369     onlyOwner
1370     {
1371         _isExcludedFromMaxWallet[account] = excluded;
1372     }
1373 
1374     /// @notice Withdraw tokens sent by mistake.
1375     /// @param tokenAddress The address of the token to withdraw
1376     function rescueETH20Tokens(address tokenAddress) external onlyOwner {
1377         IERC20(tokenAddress).transfer(
1378             owner(),
1379             IERC20(tokenAddress).balanceOf(address(this))
1380         );
1381     }
1382 
1383     /// @notice Send remaining ETH to dev
1384     /// @dev It will send all ETH to dev
1385     function forceSend() external onlyOwner {
1386         uint256 ETHbalance = address(this).balance;
1387         (bool success, ) = payable(devWallet).call{value: ETHbalance}("");
1388         require(success);
1389     }
1390 
1391     function trackerRescueETH20Tokens(address tokenAddress) external onlyOwner {
1392         dividendTracker.trackerRescueETH20Tokens(msg.sender, tokenAddress);
1393     }
1394 
1395     function updateRouter(address newRouter) external onlyOwner {
1396         router = IUniswapRouter(newRouter);
1397     }
1398 
1399     /////////////////////////////////
1400     // Exclude / Include functions //
1401     /////////////////////////////////
1402 
1403     function excludeFromFees(address account, bool excluded) public onlyOwner {
1404         require(
1405             _isExcludedFromFees[account] != excluded,
1406             "Account is already the value of 'excluded'"
1407         );
1408         _isExcludedFromFees[account] = excluded;
1409 
1410         emit ExcludeFromFees(account, excluded);
1411     }
1412 
1413     /// @dev "true" to exlcude, "false" to include
1414     function excludeFromDividends(address account, bool value)
1415     public
1416     onlyOwner
1417     {
1418         dividendTracker.excludeFromDividends(account, value);
1419     }
1420 
1421     function setDevWallet(address newWallet) public onlyOwner {
1422         devWallet = newWallet;
1423     }
1424 
1425     /// @notice Enable or disable internal swaps
1426     /// @dev Set "true" to enable internal swaps for liquidity, treasury and dividends
1427     function setSwapEnabled(bool _enabled) external onlyOwner {
1428         swapEnabled = _enabled;
1429     }
1430 
1431     function activateTrading() external onlyOwner {
1432         require(!tradingEnabled, "Trading already enabled");
1433         tradingEnabled = true;
1434     }
1435 
1436     function setClaimEnabled(bool state) external onlyOwner {
1437         claimEnabled = state;
1438     }
1439 
1440     function setLP_Token(address _lpToken) external onlyOwner {
1441         dividendTracker.updateLP_Token(_lpToken);
1442     }
1443 
1444     /// @dev Set new pairs created due to listing in new DEX
1445     function setAutomatedMarketMakerPair(address newPair, bool value)
1446     external
1447     onlyOwner
1448     {
1449         _setAutomatedMarketMakerPair(newPair, value);
1450     }
1451 
1452     function _setAutomatedMarketMakerPair(address newPair, bool value) private {
1453         require(
1454             automatedMarketMakerPairs[newPair] != value,
1455             "Automated market maker pair is already set to that value"
1456         );
1457         automatedMarketMakerPairs[newPair] = value;
1458 
1459         if (value) {
1460             dividendTracker.excludeFromDividends(newPair, true);
1461         }
1462 
1463         emit SetAutomatedMarketMakerPair(newPair, value);
1464     }
1465 
1466     //////////////////////
1467     // Getter Functions //
1468     //////////////////////
1469 
1470     function getTotalDividendsDistributed() external view returns (uint256) {
1471         return dividendTracker.totalDividendsDistributed();
1472     }
1473 
1474     function isExcludedFromFees(address account) public view returns (bool) {
1475         return _isExcludedFromFees[account];
1476     }
1477 
1478     function withdrawableDividendOf(address account)
1479     public
1480     view
1481     returns (uint256)
1482     {
1483         return dividendTracker.withdrawableDividendOf(account);
1484     }
1485 
1486     function dividendTokenBalanceOf(address account)
1487     public
1488     view
1489     returns (uint256)
1490     {
1491         return dividendTracker.balanceOf(account);
1492     }
1493 
1494     function getAccountInfo(address account)
1495     external
1496     view
1497     returns (
1498         address,
1499         uint256,
1500         uint256,
1501         uint256,
1502         uint256
1503     )
1504     {
1505         return dividendTracker.getAccount(account);
1506     }
1507 
1508     ////////////////////////
1509     // Transfer Functions //
1510     ////////////////////////
1511 
1512     function _transfer(
1513         address from,
1514         address to,
1515         uint256 amount
1516     ) internal override {
1517         require(from != address(0), "ERC20: transfer from the zero address");
1518         require(to != address(0), "ERC20: transfer to the zero address");
1519 
1520         if (
1521             !_isExcludedFromFees[from] && !_isExcludedFromFees[to] && !swapping
1522         ) {
1523             require(tradingEnabled, "Trading not active");
1524             if (automatedMarketMakerPairs[to]) {
1525                 require(
1526                     amount <= maxSellAmount,
1527                     "You are exceeding maxSellAmount"
1528                 );
1529                 _sellCount++;
1530             } else if (automatedMarketMakerPairs[from]) {
1531                 require(
1532                     amount <= maxBuyAmount,
1533                     "You are exceeding maxBuyAmount"
1534                 );
1535                 _buyCount++;
1536             }
1537             if (!_isExcludedFromMaxWallet[to]) {
1538                 require(
1539                     amount + balanceOf(to) <= maxWallet,
1540                     "Unable to exceed Max Wallet"
1541                 );
1542             }
1543         }
1544 
1545         if (amount == 0) {
1546             super._transfer(from, to, 0);
1547             return;
1548         }
1549 
1550         uint256 contractTokenBalance = balanceOf(address(this));
1551         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1552 
1553         if (
1554             canSwap &&
1555             !swapping &&
1556             swapEnabled &&
1557             automatedMarketMakerPairs[to] &&
1558             !_isExcludedFromFees[from] &&
1559             !_isExcludedFromFees[to]
1560         ) {
1561             swapping = true;
1562 
1563             if (totalSellTax > 0) {
1564                 swapAndLiquify(swapTokensAtAmount);
1565             }
1566 
1567             swapping = false;
1568         }
1569 
1570         bool takeFee = !swapping;
1571 
1572         // if any account belongs to _isExcludedFromFee account then remove the fee
1573         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1574             takeFee = false;
1575         }
1576 
1577         if (!automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from])
1578             takeFee = false;
1579 
1580         if (takeFee) {
1581             uint256 feeAmt;
1582             if (automatedMarketMakerPairs[to]) {
1583                 feeAmt =
1584                     (amount *
1585                         (
1586                             _sellCount > _reduceTaxAt
1587                                 ? totalSellTax
1588                                 : _initialTax
1589                         )) /
1590                     100;
1591             } else if (automatedMarketMakerPairs[from]) {
1592                 feeAmt =
1593                     (amount *
1594                         (
1595                             _buyCount > _reduceTaxAt ? totalBuyTax : _initialTax
1596                         )) /
1597                     100;
1598             }
1599 
1600             amount = amount - feeAmt;
1601             super._transfer(from, address(this), feeAmt);
1602         }
1603         super._transfer(from, to, amount);
1604 
1605         try dividendTracker.setBalance(from, balanceOf(from)) {} catch {}
1606         try dividendTracker.setBalance(to, balanceOf(to)) {} catch {}
1607     }
1608 
1609     function swapAndLiquify(uint256 tokens) private {
1610         uint256 toSwapForLiq = ((tokens * sellTaxes.liquidity) / totalSellTax) /
1611                     2;
1612         uint256 tokensToAddLiquidityWith = ((tokens * sellTaxes.liquidity) /
1613             totalSellTax) / 2;
1614         uint256 toSwapForDev = (tokens * sellTaxes.dev) / totalSellTax;
1615 
1616         swapTokensForETH(toSwapForLiq);
1617 
1618         uint256 currentbalance = address(this).balance;
1619 
1620         if (currentbalance > 0) {
1621             // Add liquidity to uni
1622             addLiquidity(tokensToAddLiquidityWith, currentbalance);
1623         }
1624 
1625         swapTokensForETH(toSwapForDev);
1626 
1627         uint256 EthTaxBalance = address(this).balance;
1628 
1629         // Send ETH to dev
1630         uint256 devAmt = EthTaxBalance;
1631 
1632         if (devAmt > 0) {
1633             (bool success, ) = payable(devWallet).call{value: devAmt}("");
1634             require(success, "Failed to send ETH to dev wallet");
1635         }
1636 
1637         uint256 lpBalance = IERC20(pair).balanceOf(address(this));
1638 
1639         //Send LP to dividends
1640         uint256 dividends = lpBalance;
1641 
1642         if (dividends > 0) {
1643             bool success = IERC20(pair).transfer(
1644                 address(dividendTracker),
1645                 dividends
1646             );
1647             if (success) {
1648                 dividendTracker.distributeLPDividends(dividends);
1649                 emit SendDividends(tokens, dividends);
1650             }
1651         }
1652     }
1653 
1654     // transfers LP from the owners wallet to holders // must approve this contract, on pair contract before calling
1655     function ManualLiquidityDistribution(uint256 amount) public onlyOwner {
1656         bool success = IERC20(pair).transferFrom(
1657             msg.sender,
1658             address(dividendTracker),
1659             amount
1660         );
1661         if (success) {
1662             dividendTracker.distributeLPDividends(amount);
1663         }
1664     }
1665 
1666     function swapTokensForETH(uint256 tokenAmount) private {
1667         address[] memory path = new address[](2);
1668         path[0] = address(this);
1669         path[1] = router.WETH();
1670 
1671         _approve(address(this), address(router), tokenAmount);
1672 
1673         // make the swap
1674         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1675             tokenAmount,
1676             0, // accept any amount of ETH
1677             path,
1678             address(this),
1679             block.timestamp
1680         );
1681     }
1682 
1683     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1684         // approve token transfer to cover all possible scenarios
1685         _approve(address(this), address(router), tokenAmount);
1686 
1687         // add the liquidity
1688         router.addLiquidityETH{value: ethAmount}(
1689             address(this),
1690             tokenAmount,
1691             0, // slippage is unavoidable
1692             0, // slippage is unavoidable
1693             address(this),
1694             block.timestamp
1695         );
1696     }
1697 }
1698 
1699 contract DividendTracker is Ownable, DividendPayingToken {
1700     struct AccountInfo {
1701         address account;
1702         uint256 withdrawableDividends;
1703         uint256 totalDividends;
1704         uint256 lastClaimTime;
1705     }
1706 
1707     mapping(address => bool) public excludedFromDividends;
1708 
1709     mapping(address => uint256) public lastClaimTimes;
1710 
1711     event ExcludeFromDividends(address indexed account, bool value);
1712     event Claim(address indexed account, uint256 amount);
1713 
1714     constructor()
1715     DividendPayingToken("LIQ_Dividend_Tracker", "LIQ_Dividend_Tracker")
1716     {}
1717 
1718     function trackerRescueETH20Tokens(address recipient, address tokenAddress)
1719     external
1720     onlyOwner
1721     {
1722         IERC20(tokenAddress).transfer(
1723             recipient,
1724             IERC20(tokenAddress).balanceOf(address(this))
1725         );
1726     }
1727 
1728     function updateLP_Token(address _lpToken) external onlyOwner {
1729         LP_Token = _lpToken;
1730     }
1731 
1732     function _transfer(
1733         address,
1734         address,
1735         uint256
1736     ) internal pure override {
1737         require(false, "LIQ_Dividend_Tracker: No transfers allowed");
1738     }
1739 
1740     function excludeFromDividends(address account, bool value)
1741     external
1742     onlyOwner
1743     {
1744         require(excludedFromDividends[account] != value);
1745         excludedFromDividends[account] = value;
1746         if (value == true) {
1747             _setBalance(account, 0);
1748         } else {
1749             _setBalance(account, balanceOf(account));
1750         }
1751         emit ExcludeFromDividends(account, value);
1752     }
1753 
1754     function getAccount(address account)
1755     public
1756     view
1757     returns (
1758         address,
1759         uint256,
1760         uint256,
1761         uint256,
1762         uint256
1763     )
1764     {
1765         AccountInfo memory info;
1766         info.account = account;
1767         info.withdrawableDividends = withdrawableDividendOf(account);
1768         info.totalDividends = accumulativeDividendOf(account);
1769         info.lastClaimTime = lastClaimTimes[account];
1770         return (
1771             info.account,
1772             info.withdrawableDividends,
1773             info.totalDividends,
1774             info.lastClaimTime,
1775             totalDividendsWithdrawn
1776         );
1777     }
1778 
1779     function setBalance(address account, uint256 newBalance)
1780     external
1781     onlyOwner
1782     {
1783         if (excludedFromDividends[account]) {
1784             return;
1785         }
1786         _setBalance(account, newBalance);
1787     }
1788 
1789     function processAccount(address payable account)
1790     external
1791     onlyOwner
1792     returns (bool)
1793     {
1794         uint256 amount = _withdrawDividendOfUser(account);
1795 
1796         if (amount > 0) {
1797             lastClaimTimes[account] = block.timestamp;
1798             emit Claim(account, amount);
1799             return true;
1800         }
1801         return false;
1802     }
1803 }