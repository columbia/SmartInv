1 /**
2  *CREATING A HOUSE OF DEGENERATES...
3 */
4 
5 // SPDX-License-Identifier: MIT
6  
7 pragma solidity 0.8.17;
8 pragma experimental ABIEncoderV2;
9  
10 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
11  
12 // pragma solidity ^0.8.0;
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
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35  
36 // pragma solidity ^0.8.0;
37  
38 // import "../utils/Context.sol";
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
123 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
124  
125 // pragma solidity ^0.8.0;
126  
127 /**
128  * @dev Interface of the ERC20 standard as defined in the EIP.
129  */
130 interface IERC20 {
131     /**
132      * @dev Emitted when `value` tokens are moved from one account (`from`) to
133      * another (`to`).
134      *
135      * Note that `value` may be zero.
136      */
137     event Transfer(address indexed from, address indexed to, uint256 value);
138  
139     /**
140      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
141      * a call to {approve}. `value` is the new allowance.
142      */
143     event Approval(
144         address indexed owner,
145         address indexed spender,
146         uint256 value
147     );
148  
149     /**
150      * @dev Returns the amount of tokens in existence.
151      */
152     function totalSupply() external view returns (uint256);
153  
154     /**
155      * @dev Returns the amount of tokens owned by `account`.
156      */
157     function balanceOf(address account) external view returns (uint256);
158  
159     /**
160      * @dev Moves `amount` tokens from the caller's account to `to`.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transfer(address to, uint256 amount) external returns (bool);
167  
168     /**
169      * @dev Returns the remaining number of tokens that `spender` will be
170      * allowed to spend on behalf of `owner` through {transferFrom}. This is
171      * zero by default.
172      *
173      * This value changes when {approve} or {transferFrom} are called.
174      */
175     function allowance(address owner, address spender)
176         external
177         view
178         returns (uint256);
179  
180     /**
181      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * IMPORTANT: Beware that changing an allowance with this method brings the risk
186      * that someone may use both the old and the new allowance by unfortunate
187      * transaction ordering. One possible solution to mitigate this race
188      * condition is to first reduce the spender's allowance to 0 and set the
189      * desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * Emits an {Approval} event.
193      */
194     function approve(address spender, uint256 amount) external returns (bool);
195  
196     /**
197      * @dev Moves `amount` tokens from `from` to `to` using the
198      * allowance mechanism. `amount` is then deducted from the caller's
199      * allowance.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address from,
207         address to,
208         uint256 amount
209     ) external returns (bool);
210 }
211  
212 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
213  
214 // pragma solidity ^0.8.0;
215  
216 // import "../IERC20.sol";
217  
218 /**
219  * @dev Interface for the optional metadata functions from the ERC20 standard.
220  *
221  * _Available since v4.1._
222  */
223 interface IERC20Metadata is IERC20 {
224     /**
225      * @dev Returns the name of the token.
226      */
227     function name() external view returns (string memory);
228  
229     /**
230      * @dev Returns the symbol of the token.
231      */
232     function symbol() external view returns (string memory);
233  
234     /**
235      * @dev Returns the decimals places of the token.
236      */
237     function decimals() external view returns (uint8);
238 }
239  
240 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
241  
242 // pragma solidity ^0.8.0;
243  
244 // import "./IERC20.sol";
245 // import "./extensions/IERC20Metadata.sol";
246 // import "../../utils/Context.sol";
247  
248 /**
249  * @dev Implementation of the {IERC20} interface.
250  *
251  * This implementation is agnostic to the way tokens are created. This means
252  * that a supply mechanism has to be added in a derived contract using {_mint}.
253  * For a generic mechanism see {ERC20PresetMinterPauser}.
254  *
255  * TIP: For a detailed writeup see our guide
256  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
257  * to implement supply mechanisms].
258  *
259  * The default value of {decimals} is 18. To change this, you should override
260  * this function so it returns a different value.
261  *
262  * We have followed general OpenZeppelin Contracts guidelines: functions revert
263  * instead returning `false` on failure. This behavior is nonetheless
264  * conventional and does not conflict with the expectations of ERC20
265  * applications.
266  *
267  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
268  * This allows applications to reconstruct the allowance for all accounts just
269  * by listening to said events. Other implementations of the EIP may not emit
270  * these events, as it isn't required by the specification.
271  *
272  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
273  * functions have been added to mitigate the well-known issues around setting
274  * allowances. See {IERC20-approve}.
275  */
276 contract ERC20 is Context, IERC20, IERC20Metadata {
277     mapping(address => uint256) private _balances;
278  
279     mapping(address => mapping(address => uint256)) private _allowances;
280  
281     uint256 private _totalSupply;
282  
283     string private _name;
284     string private _symbol;
285  
286     /**
287      * @dev Sets the values for {name} and {symbol}.
288      *
289      * All two of these values are immutable: they can only be set once during
290      * construction.
291      */
292     constructor(string memory name_, string memory symbol_) {
293         _name = name_;
294         _symbol = symbol_;
295     }
296  
297     /**
298      * @dev Returns the name of the token.
299      */
300     function name() public view virtual override returns (string memory) {
301         return _name;
302     }
303  
304     /**
305      * @dev Returns the symbol of the token, usually a shorter version of the
306      * name.
307      */
308     function symbol() public view virtual override returns (string memory) {
309         return _symbol;
310     }
311  
312     /**
313      * @dev Returns the number of decimals used to get its user representation.
314      * For example, if `decimals` equals `2`, a balance of `505` tokens should
315      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
316      *
317      * Tokens usually opt for a value of 18, imitating the relationship between
318      * Ether and Wei. This is the default value returned by this function, unless
319      * it's overridden.
320      *
321      * NOTE: This information is only used for _display_ purposes: it in
322      * no way affects any of the arithmetic of the contract, including
323      * {IERC20-balanceOf} and {IERC20-transfer}.
324      */
325     function decimals() public view virtual override returns (uint8) {
326         return 18;
327     }
328  
329     /**
330      * @dev See {IERC20-totalSupply}.
331      */
332     function totalSupply() public view virtual override returns (uint256) {
333         return _totalSupply;
334     }
335  
336     /**
337      * @dev See {IERC20-balanceOf}.
338      */
339     function balanceOf(address account)
340         public
341         view
342         virtual
343         override
344         returns (uint256)
345     {
346         return _balances[account];
347     }
348  
349     /**
350      * @dev See {IERC20-transfer}.
351      *
352      * Requirements:
353      *
354      * - `to` cannot be the zero address.
355      * - the caller must have a balance of at least `amount`.
356      */
357     function transfer(address to, uint256 amount)
358         public
359         virtual
360         override
361         returns (bool)
362     {
363         address owner = _msgSender();
364         _transfer(owner, to, amount);
365         return true;
366     }
367  
368     /**
369      * @dev See {IERC20-allowance}.
370      */
371     function allowance(address owner, address spender)
372         public
373         view
374         virtual
375         override
376         returns (uint256)
377     {
378         return _allowances[owner][spender];
379     }
380  
381     /**
382      * @dev See {IERC20-approve}.
383      *
384      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
385      * `transferFrom`. This is semantically equivalent to an infinite approval.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      */
391     function approve(address spender, uint256 amount)
392         public
393         virtual
394         override
395         returns (bool)
396     {
397         address owner = _msgSender();
398         _approve(owner, spender, amount);
399         return true;
400     }
401  
402     /**
403      * @dev See {IERC20-transferFrom}.
404      *
405      * Emits an {Approval} event indicating the updated allowance. This is not
406      * required by the EIP. See the note at the beginning of {ERC20}.
407      *
408      * NOTE: Does not update the allowance if the current allowance
409      * is the maximum `uint256`.
410      *
411      * Requirements:
412      *
413      * - `from` and `to` cannot be the zero address.
414      * - `from` must have a balance of at least `amount`.
415      * - the caller must have allowance for ``from``'s tokens of at least
416      * `amount`.
417      */
418     function transferFrom(
419         address from,
420         address to,
421         uint256 amount
422     ) public virtual override returns (bool) {
423         address spender = _msgSender();
424         _spendAllowance(from, spender, amount);
425         _transfer(from, to, amount);
426         return true;
427     }
428  
429     /**
430      * @dev Atomically increases the allowance granted to `spender` by the caller.
431      *
432      * This is an alternative to {approve} that can be used as a mitigation for
433      * problems described in {IERC20-approve}.
434      *
435      * Emits an {Approval} event indicating the updated allowance.
436      *
437      * Requirements:
438      *
439      * - `spender` cannot be the zero address.
440      */
441     function increaseAllowance(address spender, uint256 addedValue)
442         public
443         virtual
444         returns (bool)
445     {
446         address owner = _msgSender();
447         _approve(owner, spender, allowance(owner, spender) + addedValue);
448         return true;
449     }
450  
451     /**
452      * @dev Atomically decreases the allowance granted to `spender` by the caller.
453      *
454      * This is an alternative to {approve} that can be used as a mitigation for
455      * problems described in {IERC20-approve}.
456      *
457      * Emits an {Approval} event indicating the updated allowance.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      * - `spender` must have allowance for the caller of at least
463      * `subtractedValue`.
464      */
465     function decreaseAllowance(address spender, uint256 subtractedValue)
466         public
467         virtual
468         returns (bool)
469     {
470         address owner = _msgSender();
471         uint256 currentAllowance = allowance(owner, spender);
472         require(
473             currentAllowance >= subtractedValue,
474             "ERC20: decreased allowance below zero"
475         );
476         unchecked {
477             _approve(owner, spender, currentAllowance - subtractedValue);
478         }
479  
480         return true;
481     }
482  
483     /**
484      * @dev Moves `amount` of tokens from `from` to `to`.
485      *
486      * This internal function is equivalent to {transfer}, and can be used to
487      * e.g. implement automatic token fees, slashing mechanisms, etc.
488      *
489      * Emits a {Transfer} event.
490      *
491      * Requirements:
492      *
493      * - `from` cannot be the zero address.
494      * - `to` cannot be the zero address.
495      * - `from` must have a balance of at least `amount`.
496      */
497     function _transfer(
498         address from,
499         address to,
500         uint256 amount
501     ) internal virtual {
502         require(from != address(0), "ERC20: transfer from the zero address");
503         require(to != address(0), "ERC20: transfer to the zero address");
504  
505         _beforeTokenTransfer(from, to, amount);
506  
507         uint256 fromBalance = _balances[from];
508         require(
509             fromBalance >= amount,
510             "ERC20: transfer amount exceeds balance"
511         );
512         unchecked {
513             _balances[from] = fromBalance - amount;
514             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
515             // decrementing then incrementing.
516             _balances[to] += amount;
517         }
518  
519         emit Transfer(from, to, amount);
520  
521         _afterTokenTransfer(from, to, amount);
522     }
523  
524     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
525      * the total supply.
526      *
527      * Emits a {Transfer} event with `from` set to the zero address.
528      *
529      * Requirements:
530      *
531      * - `account` cannot be the zero address.
532      */
533     function _mint(address account, uint256 amount) internal virtual {
534         require(account != address(0), "ERC20: mint to the zero address");
535  
536         _beforeTokenTransfer(address(0), account, amount);
537  
538         _totalSupply += amount;
539         unchecked {
540             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
541             _balances[account] += amount;
542         }
543         emit Transfer(address(0), account, amount);
544  
545         _afterTokenTransfer(address(0), account, amount);
546     }
547  
548     /**
549      * @dev Destroys `amount` tokens from `account`, reducing the
550      * total supply.
551      *
552      * Emits a {Transfer} event with `to` set to the zero address.
553      *
554      * Requirements:
555      *
556      * - `account` cannot be the zero address.
557      * - `account` must have at least `amount` tokens.
558      */
559     function _burn(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: burn from the zero address");
561  
562         _beforeTokenTransfer(account, address(0), amount);
563  
564         uint256 accountBalance = _balances[account];
565         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
566         unchecked {
567             _balances[account] = accountBalance - amount;
568             // Overflow not possible: amount <= accountBalance <= totalSupply.
569             _totalSupply -= amount;
570         }
571  
572         emit Transfer(account, address(0), amount);
573  
574         _afterTokenTransfer(account, address(0), amount);
575     }
576  
577     /**
578      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
579      *
580      * This internal function is equivalent to `approve`, and can be used to
581      * e.g. set automatic allowances for certain subsystems, etc.
582      *
583      * Emits an {Approval} event.
584      *
585      * Requirements:
586      *
587      * - `owner` cannot be the zero address.
588      * - `spender` cannot be the zero address.
589      */
590     function _approve(
591         address owner,
592         address spender,
593         uint256 amount
594     ) internal virtual {
595         require(owner != address(0), "ERC20: approve from the zero address");
596         require(spender != address(0), "ERC20: approve to the zero address");
597  
598         _allowances[owner][spender] = amount;
599         emit Approval(owner, spender, amount);
600     }
601  
602     /**
603      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
604      *
605      * Does not update the allowance amount in case of infinite allowance.
606      * Revert if not enough allowance is available.
607      *
608      * Might emit an {Approval} event.
609      */
610     function _spendAllowance(
611         address owner,
612         address spender,
613         uint256 amount
614     ) internal virtual {
615         uint256 currentAllowance = allowance(owner, spender);
616         if (currentAllowance != type(uint256).max) {
617             require(
618                 currentAllowance >= amount,
619                 "ERC20: insufficient allowance"
620             );
621             unchecked {
622                 _approve(owner, spender, currentAllowance - amount);
623             }
624         }
625     }
626  
627     /**
628      * @dev Hook that is called before any transfer of tokens. This includes
629      * minting and burning.
630      *
631      * Calling conditions:
632      *
633      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
634      * will be transferred to `to`.
635      * - when `from` is zero, `amount` tokens will be minted for `to`.
636      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
637      * - `from` and `to` are never both zero.
638      *
639      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
640      */
641     function _beforeTokenTransfer(
642         address from,
643         address to,
644         uint256 amount
645     ) internal virtual {}
646  
647     /**
648      * @dev Hook that is called after any transfer of tokens. This includes
649      * minting and burning.
650      *
651      * Calling conditions:
652      *
653      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
654      * has been transferred to `to`.
655      * - when `from` is zero, `amount` tokens have been minted for `to`.
656      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
657      * - `from` and `to` are never both zero.
658      *
659      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
660      */
661     function _afterTokenTransfer(
662         address from,
663         address to,
664         uint256 amount
665     ) internal virtual {}
666 }
667  
668 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
669  
670 // pragma solidity ^0.8.0;
671  
672 // CAUTION
673 // This version of SafeMath should only be used with Solidity 0.8 or later,
674 // because it relies on the compiler's built in overflow checks.
675  
676 /**
677  * @dev Wrappers over Solidity's arithmetic operations.
678  *
679  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
680  * now has built in overflow checking.
681  */
682 library SafeMath {
683     /**
684      * @dev Returns the addition of two unsigned integers, with an overflow flag.
685      *
686      * _Available since v3.4._
687      */
688     function tryAdd(uint256 a, uint256 b)
689         internal
690         pure
691         returns (bool, uint256)
692     {
693         unchecked {
694             uint256 c = a + b;
695             if (c < a) return (false, 0);
696             return (true, c);
697         }
698     }
699  
700     /**
701      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
702      *
703      * _Available since v3.4._
704      */
705     function trySub(uint256 a, uint256 b)
706         internal
707         pure
708         returns (bool, uint256)
709     {
710         unchecked {
711             if (b > a) return (false, 0);
712             return (true, a - b);
713         }
714     }
715  
716     /**
717      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
718      *
719      * _Available since v3.4._
720      */
721     function tryMul(uint256 a, uint256 b)
722         internal
723         pure
724         returns (bool, uint256)
725     {
726         unchecked {
727             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
728             // benefit is lost if 'b' is also tested.
729             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
730             if (a == 0) return (true, 0);
731             uint256 c = a * b;
732             if (c / a != b) return (false, 0);
733             return (true, c);
734         }
735     }
736  
737     /**
738      * @dev Returns the division of two unsigned integers, with a division by zero flag.
739      *
740      * _Available since v3.4._
741      */
742     function tryDiv(uint256 a, uint256 b)
743         internal
744         pure
745         returns (bool, uint256)
746     {
747         unchecked {
748             if (b == 0) return (false, 0);
749             return (true, a / b);
750         }
751     }
752  
753     /**
754      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
755      *
756      * _Available since v3.4._
757      */
758     function tryMod(uint256 a, uint256 b)
759         internal
760         pure
761         returns (bool, uint256)
762     {
763         unchecked {
764             if (b == 0) return (false, 0);
765             return (true, a % b);
766         }
767     }
768  
769     /**
770      * @dev Returns the addition of two unsigned integers, reverting on
771      * overflow.
772      *
773      * Counterpart to Solidity's `+` operator.
774      *
775      * Requirements:
776      *
777      * - Addition cannot overflow.
778      */
779     function add(uint256 a, uint256 b) internal pure returns (uint256) {
780         return a + b;
781     }
782  
783     /**
784      * @dev Returns the subtraction of two unsigned integers, reverting on
785      * overflow (when the result is negative).
786      *
787      * Counterpart to Solidity's `-` operator.
788      *
789      * Requirements:
790      *
791      * - Subtraction cannot overflow.
792      */
793     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
794         return a - b;
795     }
796  
797     /**
798      * @dev Returns the multiplication of two unsigned integers, reverting on
799      * overflow.
800      *
801      * Counterpart to Solidity's `*` operator.
802      *
803      * Requirements:
804      *
805      * - Multiplication cannot overflow.
806      */
807     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
808         return a * b;
809     }
810  
811     /**
812      * @dev Returns the integer division of two unsigned integers, reverting on
813      * division by zero. The result is rounded towards zero.
814      *
815      * Counterpart to Solidity's `/` operator.
816      *
817      * Requirements:
818      *
819      * - The divisor cannot be zero.
820      */
821     function div(uint256 a, uint256 b) internal pure returns (uint256) {
822         return a / b;
823     }
824  
825     /**
826      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
827      * reverting when dividing by zero.
828      *
829      * Counterpart to Solidity's `%` operator. This function uses a `revert`
830      * opcode (which leaves remaining gas untouched) while Solidity uses an
831      * invalid opcode to revert (consuming all remaining gas).
832      *
833      * Requirements:
834      *
835      * - The divisor cannot be zero.
836      */
837     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
838         return a % b;
839     }
840  
841     /**
842      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
843      * overflow (when the result is negative).
844      *
845      * CAUTION: This function is deprecated because it requires allocating memory for the error
846      * message unnecessarily. For custom revert reasons use {trySub}.
847      *
848      * Counterpart to Solidity's `-` operator.
849      *
850      * Requirements:
851      *
852      * - Subtraction cannot overflow.
853      */
854     function sub(
855         uint256 a,
856         uint256 b,
857         string memory errorMessage
858     ) internal pure returns (uint256) {
859         unchecked {
860             require(b <= a, errorMessage);
861             return a - b;
862         }
863     }
864  
865     /**
866      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
867      * division by zero. The result is rounded towards zero.
868      *
869      * Counterpart to Solidity's `/` operator. Note: this function uses a
870      * `revert` opcode (which leaves remaining gas untouched) while Solidity
871      * uses an invalid opcode to revert (consuming all remaining gas).
872      *
873      * Requirements:
874      *
875      * - The divisor cannot be zero.
876      */
877     function div(
878         uint256 a,
879         uint256 b,
880         string memory errorMessage
881     ) internal pure returns (uint256) {
882         unchecked {
883             require(b > 0, errorMessage);
884             return a / b;
885         }
886     }
887  
888     /**
889      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
890      * reverting with custom message when dividing by zero.
891      *
892      * CAUTION: This function is deprecated because it requires allocating memory for the error
893      * message unnecessarily. For custom revert reasons use {tryMod}.
894      *
895      * Counterpart to Solidity's `%` operator. This function uses a `revert`
896      * opcode (which leaves remaining gas untouched) while Solidity uses an
897      * invalid opcode to revert (consuming all remaining gas).
898      *
899      * Requirements:
900      *
901      * - The divisor cannot be zero.
902      */
903     function mod(
904         uint256 a,
905         uint256 b,
906         string memory errorMessage
907     ) internal pure returns (uint256) {
908         unchecked {
909             require(b > 0, errorMessage);
910             return a % b;
911         }
912     }
913 }
914  
915 // pragma solidity >=0.5.0;
916  
917 interface IUniswapV2Factory {
918     event PairCreated(
919         address indexed token0,
920         address indexed token1,
921         address pair,
922         uint256
923     );
924  
925     function feeTo() external view returns (address);
926  
927     function feeToSetter() external view returns (address);
928  
929     function getPair(address tokenA, address tokenB)
930         external
931         view
932         returns (address pair);
933  
934     function allPairs(uint256) external view returns (address pair);
935  
936     function allPairsLength() external view returns (uint256);
937  
938     function createPair(address tokenA, address tokenB)
939         external
940         returns (address pair);
941  
942     function setFeeTo(address) external;
943  
944     function setFeeToSetter(address) external;
945 }
946  
947 // pragma solidity >=0.6.2;
948  
949 interface IUniswapV2Router01 {
950     function factory() external pure returns (address);
951  
952     function WETH() external pure returns (address);
953  
954     function addLiquidity(
955         address tokenA,
956         address tokenB,
957         uint256 amountADesired,
958         uint256 amountBDesired,
959         uint256 amountAMin,
960         uint256 amountBMin,
961         address to,
962         uint256 deadline
963     )
964         external
965         returns (
966             uint256 amountA,
967             uint256 amountB,
968             uint256 liquidity
969         );
970  
971     function addLiquidityETH(
972         address token,
973         uint256 amountTokenDesired,
974         uint256 amountTokenMin,
975         uint256 amountETHMin,
976         address to,
977         uint256 deadline
978     )
979         external
980         payable
981         returns (
982             uint256 amountToken,
983             uint256 amountETH,
984             uint256 liquidity
985         );
986  
987     function removeLiquidity(
988         address tokenA,
989         address tokenB,
990         uint256 liquidity,
991         uint256 amountAMin,
992         uint256 amountBMin,
993         address to,
994         uint256 deadline
995     ) external returns (uint256 amountA, uint256 amountB);
996  
997     function removeLiquidityETH(
998         address token,
999         uint256 liquidity,
1000         uint256 amountTokenMin,
1001         uint256 amountETHMin,
1002         address to,
1003         uint256 deadline
1004     ) external returns (uint256 amountToken, uint256 amountETH);
1005  
1006     function removeLiquidityWithPermit(
1007         address tokenA,
1008         address tokenB,
1009         uint256 liquidity,
1010         uint256 amountAMin,
1011         uint256 amountBMin,
1012         address to,
1013         uint256 deadline,
1014         bool approveMax,
1015         uint8 v,
1016         bytes32 r,
1017         bytes32 s
1018     ) external returns (uint256 amountA, uint256 amountB);
1019  
1020     function removeLiquidityETHWithPermit(
1021         address token,
1022         uint256 liquidity,
1023         uint256 amountTokenMin,
1024         uint256 amountETHMin,
1025         address to,
1026         uint256 deadline,
1027         bool approveMax,
1028         uint8 v,
1029         bytes32 r,
1030         bytes32 s
1031     ) external returns (uint256 amountToken, uint256 amountETH);
1032  
1033     function swapExactTokensForTokens(
1034         uint256 amountIn,
1035         uint256 amountOutMin,
1036         address[] calldata path,
1037         address to,
1038         uint256 deadline
1039     ) external returns (uint256[] memory amounts);
1040  
1041     function swapTokensForExactTokens(
1042         uint256 amountOut,
1043         uint256 amountInMax,
1044         address[] calldata path,
1045         address to,
1046         uint256 deadline
1047     ) external returns (uint256[] memory amounts);
1048  
1049     function swapExactETHForTokens(
1050         uint256 amountOutMin,
1051         address[] calldata path,
1052         address to,
1053         uint256 deadline
1054     ) external payable returns (uint256[] memory amounts);
1055  
1056     function swapTokensForExactETH(
1057         uint256 amountOut,
1058         uint256 amountInMax,
1059         address[] calldata path,
1060         address to,
1061         uint256 deadline
1062     ) external returns (uint256[] memory amounts);
1063  
1064     function swapExactTokensForETH(
1065         uint256 amountIn,
1066         uint256 amountOutMin,
1067         address[] calldata path,
1068         address to,
1069         uint256 deadline
1070     ) external returns (uint256[] memory amounts);
1071  
1072     function swapETHForExactTokens(
1073         uint256 amountOut,
1074         address[] calldata path,
1075         address to,
1076         uint256 deadline
1077     ) external payable returns (uint256[] memory amounts);
1078  
1079     function quote(
1080         uint256 amountA,
1081         uint256 reserveA,
1082         uint256 reserveB
1083     ) external pure returns (uint256 amountB);
1084  
1085     function getAmountOut(
1086         uint256 amountIn,
1087         uint256 reserveIn,
1088         uint256 reserveOut
1089     ) external pure returns (uint256 amountOut);
1090  
1091     function getAmountIn(
1092         uint256 amountOut,
1093         uint256 reserveIn,
1094         uint256 reserveOut
1095     ) external pure returns (uint256 amountIn);
1096  
1097     function getAmountsOut(uint256 amountIn, address[] calldata path)
1098         external
1099         view
1100         returns (uint256[] memory amounts);
1101  
1102     function getAmountsIn(uint256 amountOut, address[] calldata path)
1103         external
1104         view
1105         returns (uint256[] memory amounts);
1106 }
1107  
1108 // pragma solidity >=0.6.2;
1109  
1110 // import './IUniswapV2Router01.sol';
1111  
1112 interface IUniswapV2Router02 is IUniswapV2Router01 {
1113     function removeLiquidityETHSupportingFeeOnTransferTokens(
1114         address token,
1115         uint256 liquidity,
1116         uint256 amountTokenMin,
1117         uint256 amountETHMin,
1118         address to,
1119         uint256 deadline
1120     ) external returns (uint256 amountETH);
1121  
1122     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1123         address token,
1124         uint256 liquidity,
1125         uint256 amountTokenMin,
1126         uint256 amountETHMin,
1127         address to,
1128         uint256 deadline,
1129         bool approveMax,
1130         uint8 v,
1131         bytes32 r,
1132         bytes32 s
1133     ) external returns (uint256 amountETH);
1134  
1135     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1136         uint256 amountIn,
1137         uint256 amountOutMin,
1138         address[] calldata path,
1139         address to,
1140         uint256 deadline
1141     ) external;
1142  
1143     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1144         uint256 amountOutMin,
1145         address[] calldata path,
1146         address to,
1147         uint256 deadline
1148     ) external payable;
1149  
1150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1151         uint256 amountIn,
1152         uint256 amountOutMin,
1153         address[] calldata path,
1154         address to,
1155         uint256 deadline
1156     ) external;
1157 }
1158  
1159 contract HouseOfDegenerates is ERC20, Ownable {
1160     using SafeMath for uint256;
1161  
1162     IUniswapV2Router02 public immutable uniswapV2Router;
1163     address public uniswapV2Pair;
1164     address public constant deadAddress = address(0xdead);
1165  
1166     bool private swapping;
1167  
1168     address public marketingWallet;
1169     address public developmentWallet;
1170     address public partnershipsCEXRewardsWallet;
1171  
1172     uint256 public maxTransactionAmount;
1173     uint256 public swapTokensAtAmount;
1174     uint256 public maxWallet;
1175  
1176     bool public tradingActive = false;
1177     bool public swapEnabled = false;
1178  
1179     uint256 public buyTotalFees;
1180     uint256 private buyMarketingFee;
1181     uint256 private buyDevelopmentFee;
1182 
1183     uint256 public sellTotalFees;
1184     uint256 private sellMarketingFee;
1185     uint256 private sellDevelopmentFee;
1186  
1187     uint256 private tokensForMarketing;
1188     uint256 private tokensForDevelopment;
1189 
1190     uint256 private previousFee;
1191  
1192     mapping(address => bool) private _isExcludedFromFees;
1193     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1194     mapping(address => bool) private automatedMarketMakerPairs;
1195  
1196     event ExcludeFromFees(address indexed account, bool isExcluded);
1197  
1198     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1199  
1200     event marketingWalletUpdated(
1201         address indexed newWallet,
1202         address indexed oldWallet
1203     );
1204 
1205     event developmentWalletUpdated(
1206         address indexed newWallet,
1207         address indexed oldWallet
1208     );
1209  
1210  
1211     constructor(address _marketingWallet,address _developmentWallet, address _partnershipsCEXRewardsWallet) ERC20(unicode"House of Degenerates", unicode"HOD") {
1212         uniswapV2Router = IUniswapV2Router02(
1213             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1214         );
1215         _approve(address(this), address(uniswapV2Router), type(uint256).max);
1216  
1217         uint256 totalSupply = 100_000_000_000 ether;
1218 
1219         maxTransactionAmount = (totalSupply) / 50; //2% of total supply
1220         maxWallet = (totalSupply) / 50;  //2% of total supply
1221 
1222         swapTokensAtAmount = (totalSupply * 5) / 10000;
1223 
1224         buyMarketingFee = 8;
1225         buyDevelopmentFee = 8;
1226         buyTotalFees = buyMarketingFee + buyDevelopmentFee; //16% buy for first hour. 2% at renounce
1227  
1228         sellMarketingFee = 15;
1229         sellDevelopmentFee = 15;
1230         sellTotalFees = sellMarketingFee + sellDevelopmentFee; //30% buy for first hour. 2% at renounce
1231 
1232         previousFee = sellTotalFees;
1233 
1234         marketingWallet = _marketingWallet;
1235         developmentWallet = _developmentWallet;
1236         partnershipsCEXRewardsWallet = _partnershipsCEXRewardsWallet;
1237 
1238  
1239         excludeFromFees(owner(), true);
1240         excludeFromFees(address(this), true);
1241         excludeFromFees(deadAddress, true);
1242         excludeFromFees(marketingWallet, true);
1243         excludeFromFees(developmentWallet, true);
1244         excludeFromFees(partnershipsCEXRewardsWallet, true);
1245  
1246         excludeFromMaxTransaction(owner(), true);
1247         excludeFromMaxTransaction(address(this), true);
1248         excludeFromMaxTransaction(deadAddress, true);
1249         excludeFromMaxTransaction(address(uniswapV2Router), true);
1250         excludeFromMaxTransaction(marketingWallet, true);
1251         excludeFromMaxTransaction(developmentWallet, true);
1252         excludeFromMaxTransaction(partnershipsCEXRewardsWallet, true);
1253 
1254 
1255         // Define address and the minting amounts. 85% will go to the LP and 15% will be held for the future
1256         uint256 partnershipsPlusTokenAmount = (totalSupply * 15) / 100; // 15% for partnershipsPlus
1257         uint256 contractAmount = totalSupply - partnershipsPlusTokenAmount; // 85  % for the LP
1258 
1259         // Mint the tokens
1260         _mint(partnershipsCEXRewardsWallet, partnershipsPlusTokenAmount);
1261         _mint(address(this), contractAmount);
1262 
1263     }
1264  
1265     receive() external payable {}
1266  
1267     function burn(uint256 amount) external {
1268         _burn(msg.sender, amount);
1269     }
1270  
1271     function enableTrading() external onlyOwner {
1272         require(!tradingActive, "Trading already active.");
1273  
1274         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1275             address(this),
1276             uniswapV2Router.WETH()
1277         );
1278         _approve(address(this), address(uniswapV2Pair), type(uint256).max);
1279         IERC20(uniswapV2Pair).approve(
1280             address(uniswapV2Router),
1281             type(uint256).max
1282         );
1283  
1284         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1285         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1286 
1287         uint256 tokensInWallet = balanceOf(address(this));
1288  
1289         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1290             address(this),
1291             tokensInWallet, 
1292             0,
1293             0,
1294             owner(),
1295             block.timestamp
1296         );
1297  
1298         tradingActive = true;
1299         swapEnabled = true;
1300     }
1301  
1302     function updateSwapTokensAtAmount(uint256 newAmount)
1303         external
1304         onlyOwner
1305         returns (bool)
1306     {
1307         require(
1308             newAmount >= (totalSupply() * 1) / 100000,
1309             "ERC20: Swap amount cannot be lower than 0.001% total supply."
1310         );
1311         require(
1312             newAmount <= (totalSupply() * 5) / 1000,
1313             "ERC20: Swap amount cannot be higher than 0.5% total supply."
1314         );
1315         swapTokensAtAmount = newAmount;
1316         return true;
1317     }
1318  
1319     function updateMaxWalletAndTxnAmount(
1320         uint256 newTxnNum,
1321         uint256 newMaxWalletNum
1322     ) external onlyOwner {
1323         require(
1324             newTxnNum >= ((totalSupply() * 5) / 1000),
1325             "ERC20: Cannot set maxTxn lower than 0.5%"
1326         );
1327         require(
1328             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1329             "ERC20: Cannot set maxWallet lower than 0.5%"
1330         );
1331         maxWallet = newMaxWalletNum;
1332         maxTransactionAmount = newTxnNum;
1333     }
1334  
1335     function excludeFromMaxTransaction(address updAds, bool isEx)
1336         public
1337         onlyOwner
1338     {
1339         _isExcludedMaxTransactionAmount[updAds] = isEx;
1340     }
1341 
1342     function updateBuyFees(
1343         uint256 _marketingFee,
1344         uint256 _developmentFee
1345     ) external onlyOwner {
1346         buyMarketingFee = _marketingFee;
1347         buyDevelopmentFee = _developmentFee;
1348         buyTotalFees = buyMarketingFee + buyDevelopmentFee;
1349         require(buyTotalFees <= 30, "ERC20: Must keep fees at 30% or less");
1350     }
1351  
1352     function updateSellFees(
1353         uint256 _marketingFee,
1354         uint256 _developmentFee
1355     ) external onlyOwner {
1356         sellMarketingFee = _marketingFee;
1357         sellDevelopmentFee = _developmentFee;
1358         sellTotalFees =
1359             sellMarketingFee +
1360             sellDevelopmentFee;
1361         previousFee = sellTotalFees;
1362         require(sellTotalFees <= 30, "ERC20: Must keep fees at 30% or less");
1363     }
1364  
1365     function updateMarketingWallet(address _marketingWallet)
1366         external
1367         onlyOwner
1368     {
1369         require(_marketingWallet != address(0), "ERC20: Address 0");
1370         address oldWallet = marketingWallet;
1371         marketingWallet = _marketingWallet;
1372         emit marketingWalletUpdated(marketingWallet, oldWallet);
1373     }
1374 
1375     function updateDevelopmentWallet(address _developmentWallet)
1376         external
1377         onlyOwner
1378     {
1379         require(_developmentWallet != address(0), "ERC20: Address 0");
1380         address oldWallet = developmentWallet;
1381         developmentWallet = _developmentWallet;
1382         emit developmentWalletUpdated(developmentWallet, oldWallet);
1383     }
1384   
1385     function excludeFromFees(address account, bool excluded) public onlyOwner {
1386         _isExcludedFromFees[account] = excluded;
1387         emit ExcludeFromFees(account, excluded);
1388     }
1389  
1390     function withdrawStuckETH() public onlyOwner {
1391         bool success;
1392         (success, ) = address(msg.sender).call{value: address(this).balance}(
1393             ""
1394         );
1395     }
1396  
1397     function withdrawStuckTokens(address tkn) public onlyOwner {
1398         require(IERC20(tkn).balanceOf(address(this)) > 0, "No tokens");
1399         uint256 amount = IERC20(tkn).balanceOf(address(this));
1400         IERC20(tkn).transfer(msg.sender, amount);
1401     }
1402  
1403     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1404         automatedMarketMakerPairs[pair] = value;
1405  
1406         emit SetAutomatedMarketMakerPair(pair, value);
1407     }
1408  
1409     function isExcludedFromFees(address account) public view returns (bool) {
1410         return _isExcludedFromFees[account];
1411     }
1412  
1413     function _transfer(
1414         address from,
1415         address to,
1416         uint256 amount
1417     ) internal override {
1418         require(from != address(0), "ERC20: transfer from the zero address");
1419         require(to != address(0), "ERC20: transfer to the zero address");
1420  
1421         if (amount == 0) {
1422             super._transfer(from, to, 0);
1423             return;
1424         }
1425  
1426         if (
1427             from != owner() &&
1428             to != owner() &&
1429             to != address(0) &&
1430             to != deadAddress &&
1431             !swapping
1432         ) {
1433             if (!tradingActive) {
1434                 require(
1435                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1436                     "ERC20: Trading is not active."
1437                 );
1438             }
1439  
1440             //when buy
1441             if (
1442                 automatedMarketMakerPairs[from] &&
1443                 !_isExcludedMaxTransactionAmount[to]
1444             ) {
1445                 require(
1446                     amount <= maxTransactionAmount,
1447                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1448                 );
1449                 require(
1450                     amount + balanceOf(to) <= maxWallet,
1451                     "ERC20: Max wallet exceeded"
1452                 );
1453             }
1454             //when sell
1455             else if (
1456                 automatedMarketMakerPairs[to] &&
1457                 !_isExcludedMaxTransactionAmount[from]
1458             ) {
1459                 require(
1460                     amount <= maxTransactionAmount,
1461                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1462                 );
1463             } else if (!_isExcludedMaxTransactionAmount[to]) {
1464                 require(
1465                     amount + balanceOf(to) <= maxWallet,
1466                     "ERC20: Max wallet exceeded"
1467                 );
1468             }
1469         }
1470  
1471         uint256 contractTokenBalance = balanceOf(address(this));
1472  
1473         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1474  
1475         if (
1476             canSwap &&
1477             swapEnabled &&
1478             !swapping &&
1479             !automatedMarketMakerPairs[from] &&
1480             !_isExcludedFromFees[from] &&
1481             !_isExcludedFromFees[to]
1482         ) {
1483             swapping = true;
1484  
1485             swapBack();
1486  
1487             swapping = false;
1488         }
1489  
1490         bool takeFee = !swapping;
1491  
1492         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1493             takeFee = false;
1494         }
1495  
1496         uint256 fees = 0;
1497  
1498         if (takeFee) {
1499             // on sell
1500             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1501                 fees = amount.mul(sellTotalFees).div(100);
1502                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1503                 tokensForDevelopment += (fees * sellDevelopmentFee) / sellTotalFees;
1504 
1505             }
1506             // on buy
1507             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1508                 fees = amount.mul(buyTotalFees).div(100);
1509                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1510                 tokensForDevelopment += (fees * buyDevelopmentFee) / buyTotalFees;
1511             }
1512  
1513             if (fees > 0) {
1514                 super._transfer(from, address(this), fees);
1515             }
1516  
1517             amount -= fees;
1518         }
1519  
1520         super._transfer(from, to, amount);
1521         sellTotalFees = previousFee;
1522     }
1523  
1524     function swapTokensForEth(uint256 tokenAmount) private {
1525         address[] memory path = new address[](2);
1526         path[0] = address(this);
1527         path[1] = uniswapV2Router.WETH();
1528  
1529         _approve(address(this), address(uniswapV2Router), tokenAmount);
1530  
1531         // make the swap
1532         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1533             tokenAmount,
1534             0,
1535             path,
1536             address(this),
1537             block.timestamp
1538         );
1539     }
1540  
1541     function swapBack() private {
1542         uint256 contractBalance = balanceOf(address(this));
1543         uint256 totalTokensToSwap = tokensForMarketing + tokensForDevelopment;
1544         bool success;
1545  
1546         if (contractBalance == 0 || totalTokensToSwap == 0) {
1547             return;
1548         }
1549  
1550         if (contractBalance > swapTokensAtAmount * 20) {
1551             contractBalance = swapTokensAtAmount * 20;
1552         }
1553 
1554         swapTokensForEth(contractBalance);
1555 
1556         uint256 initialETHBalance = address(this).balance;
1557  
1558         uint256 ethForMarketing = initialETHBalance.mul(tokensForMarketing).div(
1559             totalTokensToSwap
1560         );
1561   
1562         tokensForMarketing = 0;
1563         tokensForDevelopment = 0;
1564  
1565         (success, ) = address(marketingWallet).call{value: ethForMarketing}(
1566             ""
1567         );
1568  
1569         (success, ) = address(developmentWallet).call{
1570             value: address(this).balance
1571         }("");
1572     }
1573 }