1 /* Saudi Inu $Saudi – The Saudis are buying! 
2  * https://t.me/Saudiinuportal
3  * https://saudiinu.com
4  * SPDX-License-Identifier: MIT
5  * */
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
8 
9 /* pragma solidity ^0.8.0; */
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 /* pragma solidity ^0.8.0; */
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     /**
28      * @dev Initializes the contract setting the deployer as the initial owner.
29      */
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view virtual returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public virtual onlyOwner {
57         _transferOwnership(address(0));
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Internal function without access restriction.
72      */
73     function _transferOwnership(address newOwner) internal virtual {
74         address oldOwner = _owner;
75         _owner = newOwner;
76         emit OwnershipTransferred(oldOwner, newOwner);
77     }
78 }
79 
80 /* pragma solidity ^0.8.0; */
81 
82 /**
83  * @dev Interface of the ERC20 standard as defined in the EIP.
84  */
85 interface IERC20 {
86     /**
87      * @dev Returns the amount of tokens in existence.
88      */
89     function totalSupply() external view returns (uint256);
90 
91     /**
92      * @dev Returns the amount of tokens owned by `account`.
93      */
94     function balanceOf(address account) external view returns (uint256);
95 
96     /**
97      * @dev Moves `amount` tokens from the caller's account to `recipient`.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transfer(address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Returns the remaining number of tokens that `spender` will be
107      * allowed to spend on behalf of `owner` through {transferFrom}. This is
108      * zero by default.
109      *
110      * This value changes when {approve} or {transferFrom} are called.
111      */
112     function allowance(address owner, address spender) external view returns (uint256);
113 
114     /**
115      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * IMPORTANT: Beware that changing an allowance with this method brings the risk
120      * that someone may use both the old and the new allowance by unfortunate
121      * transaction ordering. One possible solution to mitigate this race
122      * condition is to first reduce the spender's allowance to 0 and set the
123      * desired value afterwards:
124      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address spender, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Moves `amount` tokens from `sender` to `recipient` using the
132      * allowance mechanism. `amount` is then deducted from the caller's
133      * allowance.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) external returns (bool);
144 
145     /**
146      * @dev Emitted when `value` tokens are moved from one account (`from`) to
147      * another (`to`).
148      *
149      * Note that `value` may be zero.
150      */
151     event Transfer(address indexed from, address indexed to, uint256 value);
152 
153     /**
154      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
155      * a call to {approve}. `value` is the new allowance.
156      */
157     event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 /* pragma solidity ^0.8.0; */
161 
162 /* import "../IERC20.sol"; */
163 
164 /**
165  * @dev Interface for the optional metadata functions from the ERC20 standard.
166  *
167  * _Available since v4.1._
168  */
169 interface IERC20Metadata is IERC20 {
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() external view returns (string memory);
174 
175     /**
176      * @dev Returns the symbol of the token.
177      */
178     function symbol() external view returns (string memory);
179 
180     /**
181      * @dev Returns the decimals places of the token.
182      */
183     function decimals() external view returns (uint8);
184 }
185 
186 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
187 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
188 
189 /* pragma solidity ^0.8.0; */
190 
191 /* import "./IERC20.sol"; */
192 /* import "./extensions/IERC20Metadata.sol"; */
193 /* import "../../utils/Context.sol"; */
194 
195 /**
196  * @dev Implementation of the {IERC20} interface.
197  *
198  * This implementation is agnostic to the way tokens are created. This means
199  * that a supply mechanism has to be added in a derived contract using {_mint}.
200  * For a generic mechanism see {ERC20PresetMinterPauser}.
201  *
202  * TIP: For a detailed writeup see our guide
203  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
204  * to implement supply mechanisms].
205  *
206  * We have followed general OpenZeppelin Contracts guidelines: functions revert
207  * instead returning `false` on failure. This behavior is nonetheless
208  * conventional and does not conflict with the expectations of ERC20
209  * applications.
210  *
211  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
212  * This allows applications to reconstruct the allowance for all accounts just
213  * by listening to said events. Other implementations of the EIP may not emit
214  * these events, as it isn't required by the specification.
215  *
216  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
217  * functions have been added to mitigate the well-known issues around setting
218  * allowances. See {IERC20-approve}.
219  */
220 contract ERC20 is Context, IERC20, IERC20Metadata {
221     mapping(address => uint256) private _balances;
222 
223     mapping(address => mapping(address => uint256)) private _allowances;
224 
225     uint256 private _totalSupply;
226 
227     string private _name;
228     string private _symbol;
229 
230     /**
231      * @dev Sets the values for {name} and {symbol}.
232      *
233      * The default value of {decimals} is 18. To select a different value for
234      * {decimals} you should overload it.
235      *
236      * All two of these values are immutable: they can only be set once during
237      * construction.
238      */
239     constructor(string memory name_, string memory symbol_) {
240         _name = name_;
241         _symbol = symbol_;
242     }
243 
244     /**
245      * @dev Returns the name of the token.
246      */
247     function name() public view virtual override returns (string memory) {
248         return _name;
249     }
250 
251     /**
252      * @dev Returns the symbol of the token, usually a shorter version of the
253      * name.
254      */
255     function symbol() public view virtual override returns (string memory) {
256         return _symbol;
257     }
258 
259     /**
260      * @dev Returns the number of decimals used to get its user representation.
261      * For example, if `decimals` equals `2`, a balance of `505` tokens should
262      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
263      *
264      * Tokens usually opt for a value of 18, imitating the relationship between
265      * Ether and Wei. This is the value {ERC20} uses, unless this function is
266      * overridden;
267      *
268      * NOTE: This information is only used for _display_ purposes: it in
269      * no way affects any of the arithmetic of the contract, including
270      * {IERC20-balanceOf} and {IERC20-transfer}.
271      */
272     function decimals() public view virtual override returns (uint8) {
273         return 18;
274     }
275 
276     /**
277      * @dev See {IERC20-totalSupply}.
278      */
279     function totalSupply() public view virtual override returns (uint256) {
280         return _totalSupply;
281     }
282 
283     /**
284      * @dev See {IERC20-balanceOf}.
285      */
286     function balanceOf(address account) public view virtual override returns (uint256) {
287         return _balances[account];
288     }
289 
290     /**
291      * @dev See {IERC20-transfer}.
292      *
293      * Requirements:
294      *
295      * - `recipient` cannot be the zero address.
296      * - the caller must have a balance of at least `amount`.
297      */
298     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
299         _transfer(_msgSender(), recipient, amount);
300         return true;
301     }
302 
303     /**
304      * @dev See {IERC20-allowance}.
305      */
306     function allowance(address owner, address spender) public view virtual override returns (uint256) {
307         return _allowances[owner][spender];
308     }
309 
310     /**
311      * @dev See {IERC20-approve}.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function approve(address spender, uint256 amount) public virtual override returns (bool) {
318         _approve(_msgSender(), spender, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-transferFrom}.
324      *
325      * Emits an {Approval} event indicating the updated allowance. This is not
326      * required by the EIP. See the note at the beginning of {ERC20}.
327      *
328      * Requirements:
329      *
330      * - `sender` and `recipient` cannot be the zero address.
331      * - `sender` must have a balance of at least `amount`.
332      * - the caller must have allowance for ``sender``'s tokens of at least
333      * `amount`.
334      */
335     function transferFrom(
336         address sender,
337         address recipient,
338         uint256 amount
339     ) public virtual override returns (bool) {
340         _transfer(sender, recipient, amount);
341 
342         uint256 currentAllowance = _allowances[sender][_msgSender()];
343         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
344         unchecked {
345             _approve(sender, _msgSender(), currentAllowance - amount);
346         }
347 
348         return true;
349     }
350 
351     /**
352      * @dev Atomically increases the allowance granted to `spender` by the caller.
353      *
354      * This is an alternative to {approve} that can be used as a mitigation for
355      * problems described in {IERC20-approve}.
356      *
357      * Emits an {Approval} event indicating the updated allowance.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
364         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
365         return true;
366     }
367 
368     /**
369      * @dev Atomically decreases the allowance granted to `spender` by the caller.
370      *
371      * This is an alternative to {approve} that can be used as a mitigation for
372      * problems described in {IERC20-approve}.
373      *
374      * Emits an {Approval} event indicating the updated allowance.
375      *
376      * Requirements:
377      *
378      * - `spender` cannot be the zero address.
379      * - `spender` must have allowance for the caller of at least
380      * `subtractedValue`.
381      */
382     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
383         uint256 currentAllowance = _allowances[_msgSender()][spender];
384         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
385         unchecked {
386             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
387         }
388 
389         return true;
390     }
391 
392     /**
393      * @dev Moves `amount` of tokens from `sender` to `recipient`.
394      *
395      * This internal function is equivalent to {transfer}, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a {Transfer} event.
399      *
400      * Requirements:
401      *
402      * - `sender` cannot be the zero address.
403      * - `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      */
406     function _transfer(
407         address sender,
408         address recipient,
409         uint256 amount
410     ) internal virtual {
411         require(sender != address(0), "ERC20: transfer from the zero address");
412         require(recipient != address(0), "ERC20: transfer to the zero address");
413 
414         _beforeTokenTransfer(sender, recipient, amount);
415 
416         uint256 senderBalance = _balances[sender];
417         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
418         unchecked {
419             _balances[sender] = senderBalance - amount;
420         }
421         _balances[recipient] += amount;
422 
423         emit Transfer(sender, recipient, amount);
424 
425         _afterTokenTransfer(sender, recipient, amount);
426     }
427 
428     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
429      * the total supply.
430      *
431      * Emits a {Transfer} event with `from` set to the zero address.
432      *
433      * Requirements:
434      *
435      * - `account` cannot be the zero address.
436      */
437     function _mint(address account, uint256 amount) internal virtual {
438         require(account != address(0), "ERC20: mint to the zero address");
439 
440         _beforeTokenTransfer(address(0), account, amount);
441 
442         _totalSupply += amount;
443         _balances[account] += amount;
444         emit Transfer(address(0), account, amount);
445 
446         _afterTokenTransfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements:
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal virtual {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _beforeTokenTransfer(account, address(0), amount);
464 
465         uint256 accountBalance = _balances[account];
466         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
467         unchecked {
468             _balances[account] = accountBalance - amount;
469         }
470         _totalSupply -= amount;
471 
472         emit Transfer(account, address(0), amount);
473 
474         _afterTokenTransfer(account, address(0), amount);
475     }
476 
477     /**
478      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
479      *
480      * This internal function is equivalent to `approve`, and can be used to
481      * e.g. set automatic allowances for certain subsystems, etc.
482      *
483      * Emits an {Approval} event.
484      *
485      * Requirements:
486      *
487      * - `owner` cannot be the zero address.
488      * - `spender` cannot be the zero address.
489      */
490     function _approve(
491         address owner,
492         address spender,
493         uint256 amount
494     ) internal virtual {
495         require(owner != address(0), "ERC20: approve from the zero address");
496         require(spender != address(0), "ERC20: approve to the zero address");
497 
498         _allowances[owner][spender] = amount;
499         emit Approval(owner, spender, amount);
500     }
501 
502     /**
503      * @dev Hook that is called before any transfer of tokens. This includes
504      * minting and burning.
505      *
506      * Calling conditions:
507      *
508      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
509      * will be transferred to `to`.
510      * - when `from` is zero, `amount` tokens will be minted for `to`.
511      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
512      * - `from` and `to` are never both zero.
513      *
514      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
515      */
516     function _beforeTokenTransfer(
517         address from,
518         address to,
519         uint256 amount
520     ) internal virtual {}
521 
522     /**
523      * @dev Hook that is called after any transfer of tokens. This includes
524      * minting and burning.
525      *
526      * Calling conditions:
527      *
528      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
529      * has been transferred to `to`.
530      * - when `from` is zero, `amount` tokens have been minted for `to`.
531      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
532      * - `from` and `to` are never both zero.
533      *
534      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
535      */
536     function _afterTokenTransfer(
537         address from,
538         address to,
539         uint256 amount
540     ) internal virtual {}
541 }
542 
543 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
544 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
545 
546 /* pragma solidity ^0.8.0; */
547 
548 // CAUTION
549 // This version of SafeMath should only be used with Solidity 0.8 or later,
550 // because it relies on the compiler's built in overflow checks.
551 
552 /**
553  * @dev Wrappers over Solidity's arithmetic operations.
554  *
555  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
556  * now has built in overflow checking.
557  */
558 library SafeMath {
559     /**
560      * @dev Returns the addition of two unsigned integers, with an overflow flag.
561      *
562      * _Available since v3.4._
563      */
564     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
565         unchecked {
566             uint256 c = a + b;
567             if (c < a) return (false, 0);
568             return (true, c);
569         }
570     }
571 
572     /**
573      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
574      *
575      * _Available since v3.4._
576      */
577     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
578         unchecked {
579             if (b > a) return (false, 0);
580             return (true, a - b);
581         }
582     }
583 
584     /**
585      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
586      *
587      * _Available since v3.4._
588      */
589     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
590         unchecked {
591             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
592             // benefit is lost if 'b' is also tested.
593             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
594             if (a == 0) return (true, 0);
595             uint256 c = a * b;
596             if (c / a != b) return (false, 0);
597             return (true, c);
598         }
599     }
600 
601     /**
602      * @dev Returns the division of two unsigned integers, with a division by zero flag.
603      *
604      * _Available since v3.4._
605      */
606     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
607         unchecked {
608             if (b == 0) return (false, 0);
609             return (true, a / b);
610         }
611     }
612 
613     /**
614      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
615      *
616      * _Available since v3.4._
617      */
618     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
619         unchecked {
620             if (b == 0) return (false, 0);
621             return (true, a % b);
622         }
623     }
624 
625     /**
626      * @dev Returns the addition of two unsigned integers, reverting on
627      * overflow.
628      *
629      * Counterpart to Solidity's `+` operator.
630      *
631      * Requirements:
632      *
633      * - Addition cannot overflow.
634      */
635     function add(uint256 a, uint256 b) internal pure returns (uint256) {
636         return a + b;
637     }
638 
639     /**
640      * @dev Returns the subtraction of two unsigned integers, reverting on
641      * overflow (when the result is negative).
642      *
643      * Counterpart to Solidity's `-` operator.
644      *
645      * Requirements:
646      *
647      * - Subtraction cannot overflow.
648      */
649     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
650         return a - b;
651     }
652 
653     /**
654      * @dev Returns the multiplication of two unsigned integers, reverting on
655      * overflow.
656      *
657      * Counterpart to Solidity's `*` operator.
658      *
659      * Requirements:
660      *
661      * - Multiplication cannot overflow.
662      */
663     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
664         return a * b;
665     }
666 
667     /**
668      * @dev Returns the integer division of two unsigned integers, reverting on
669      * division by zero. The result is rounded towards zero.
670      *
671      * Counterpart to Solidity's `/` operator.
672      *
673      * Requirements:
674      *
675      * - The divisor cannot be zero.
676      */
677     function div(uint256 a, uint256 b) internal pure returns (uint256) {
678         return a / b;
679     }
680 
681     /**
682      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
683      * reverting when dividing by zero.
684      *
685      * Counterpart to Solidity's `%` operator. This function uses a `revert`
686      * opcode (which leaves remaining gas untouched) while Solidity uses an
687      * invalid opcode to revert (consuming all remaining gas).
688      *
689      * Requirements:
690      *
691      * - The divisor cannot be zero.
692      */
693     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
694         return a % b;
695     }
696 
697     /**
698      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
699      * overflow (when the result is negative).
700      *
701      * CAUTION: This function is deprecated because it requires allocating memory for the error
702      * message unnecessarily. For custom revert reasons use {trySub}.
703      *
704      * Counterpart to Solidity's `-` operator.
705      *
706      * Requirements:
707      *
708      * - Subtraction cannot overflow.
709      */
710     function sub(
711         uint256 a,
712         uint256 b,
713         string memory errorMessage
714     ) internal pure returns (uint256) {
715         unchecked {
716             require(b <= a, errorMessage);
717             return a - b;
718         }
719     }
720 
721     /**
722      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
723      * division by zero. The result is rounded towards zero.
724      *
725      * Counterpart to Solidity's `/` operator. Note: this function uses a
726      * `revert` opcode (which leaves remaining gas untouched) while Solidity
727      * uses an invalid opcode to revert (consuming all remaining gas).
728      *
729      * Requirements:
730      *
731      * - The divisor cannot be zero.
732      */
733     function div(
734         uint256 a,
735         uint256 b,
736         string memory errorMessage
737     ) internal pure returns (uint256) {
738         unchecked {
739             require(b > 0, errorMessage);
740             return a / b;
741         }
742     }
743 
744     /**
745      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
746      * reverting with custom message when dividing by zero.
747      *
748      * CAUTION: This function is deprecated because it requires allocating memory for the error
749      * message unnecessarily. For custom revert reasons use {tryMod}.
750      *
751      * Counterpart to Solidity's `%` operator. This function uses a `revert`
752      * opcode (which leaves remaining gas untouched) while Solidity uses an
753      * invalid opcode to revert (consuming all remaining gas).
754      *
755      * Requirements:
756      *
757      * - The divisor cannot be zero.
758      */
759     function mod(
760         uint256 a,
761         uint256 b,
762         string memory errorMessage
763     ) internal pure returns (uint256) {
764         unchecked {
765             require(b > 0, errorMessage);
766             return a % b;
767         }
768     }
769 }
770 
771 ////// src/IUniswapV2Factory.sol
772 /* pragma solidity 0.8.10; */
773 /* pragma experimental ABIEncoderV2; */
774 
775 interface IUniswapV2Factory {
776     event PairCreated(
777         address indexed token0,
778         address indexed token1,
779         address pair,
780         uint256
781     );
782 
783     function feeTo() external view returns (address);
784 
785     function feeToSetter() external view returns (address);
786 
787     function getPair(address tokenA, address tokenB)
788         external
789         view
790         returns (address pair);
791 
792     function allPairs(uint256) external view returns (address pair);
793 
794     function allPairsLength() external view returns (uint256);
795 
796     function createPair(address tokenA, address tokenB)
797         external
798         returns (address pair);
799 
800     function setFeeTo(address) external;
801 
802     function setFeeToSetter(address) external;
803 }
804 
805 ////// src/IUniswapV2Pair.sol
806 /* pragma solidity 0.8.10; */
807 /* pragma experimental ABIEncoderV2; */
808 
809 interface IUniswapV2Pair {
810     event Approval(
811         address indexed owner,
812         address indexed spender,
813         uint256 value
814     );
815     event Transfer(address indexed from, address indexed to, uint256 value);
816 
817     function name() external pure returns (string memory);
818 
819     function symbol() external pure returns (string memory);
820 
821     function decimals() external pure returns (uint8);
822 
823     function totalSupply() external view returns (uint256);
824 
825     function balanceOf(address owner) external view returns (uint256);
826 
827     function allowance(address owner, address spender)
828         external
829         view
830         returns (uint256);
831 
832     function approve(address spender, uint256 value) external returns (bool);
833 
834     function transfer(address to, uint256 value) external returns (bool);
835 
836     function transferFrom(
837         address from,
838         address to,
839         uint256 value
840     ) external returns (bool);
841 
842     function DOMAIN_SEPARATOR() external view returns (bytes32);
843 
844     function PERMIT_TYPEHASH() external pure returns (bytes32);
845 
846     function nonces(address owner) external view returns (uint256);
847 
848     function permit(
849         address owner,
850         address spender,
851         uint256 value,
852         uint256 deadline,
853         uint8 v,
854         bytes32 r,
855         bytes32 s
856     ) external;
857 
858     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
859     event Burn(
860         address indexed sender,
861         uint256 amount0,
862         uint256 amount1,
863         address indexed to
864     );
865     event Swap(
866         address indexed sender,
867         uint256 amount0In,
868         uint256 amount1In,
869         uint256 amount0Out,
870         uint256 amount1Out,
871         address indexed to
872     );
873     event Sync(uint112 reserve0, uint112 reserve1);
874 
875     function MINIMUM_LIQUIDITY() external pure returns (uint256);
876 
877     function factory() external view returns (address);
878 
879     function token0() external view returns (address);
880 
881     function token1() external view returns (address);
882 
883     function getReserves()
884         external
885         view
886         returns (
887             uint112 reserve0,
888             uint112 reserve1,
889             uint32 blockTimestampLast
890         );
891 
892     function price0CumulativeLast() external view returns (uint256);
893 
894     function price1CumulativeLast() external view returns (uint256);
895 
896     function kLast() external view returns (uint256);
897 
898     function mint(address to) external returns (uint256 liquidity);
899 
900     function burn(address to)
901         external
902         returns (uint256 amount0, uint256 amount1);
903 
904     function swap(
905         uint256 amount0Out,
906         uint256 amount1Out,
907         address to,
908         bytes calldata data
909     ) external;
910 
911     function skim(address to) external;
912 
913     function sync() external;
914 
915     function initialize(address, address) external;
916 }
917 
918 ////// src/IUniswapV2Router02.sol
919 /* pragma solidity 0.8.10; */
920 /* pragma experimental ABIEncoderV2; */
921 
922 interface IUniswapV2Router02 {
923     function factory() external pure returns (address);
924 
925     function WETH() external pure returns (address);
926 
927     function addLiquidity(
928         address tokenA,
929         address tokenB,
930         uint256 amountADesired,
931         uint256 amountBDesired,
932         uint256 amountAMin,
933         uint256 amountBMin,
934         address to,
935         uint256 deadline
936     )
937         external
938         returns (
939             uint256 amountA,
940             uint256 amountB,
941             uint256 liquidity
942         );
943 
944     function addLiquidityETH(
945         address token,
946         uint256 amountTokenDesired,
947         uint256 amountTokenMin,
948         uint256 amountETHMin,
949         address to,
950         uint256 deadline
951     )
952         external
953         payable
954         returns (
955             uint256 amountToken,
956             uint256 amountETH,
957             uint256 liquidity
958         );
959 
960     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
961         uint256 amountIn,
962         uint256 amountOutMin,
963         address[] calldata path,
964         address to,
965         uint256 deadline
966     ) external;
967 
968     function swapExactETHForTokensSupportingFeeOnTransferTokens(
969         uint256 amountOutMin,
970         address[] calldata path,
971         address to,
972         uint256 deadline
973     ) external payable;
974 
975     function swapExactTokensForETHSupportingFeeOnTransferTokens(
976         uint256 amountIn,
977         uint256 amountOutMin,
978         address[] calldata path,
979         address to,
980         uint256 deadline
981     ) external;
982 }
983 
984 /* pragma solidity >=0.8.10; */
985 
986 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
987 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
988 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
989 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
990 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
991 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
992 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
993 
994 contract Saudi is ERC20, Ownable {
995     using SafeMath for uint256;
996 
997     IUniswapV2Router02 public immutable uniswapV2Router;
998     address public immutable uniswapV2Pair;
999     address public constant deadAddress = address(0xdead);
1000 
1001     bool private swapping;
1002 
1003     address public marketingWallet;
1004     address public devWallet;
1005 
1006     uint256 public maxTransactionAmount;
1007     uint256 public swapTokensAtAmount;
1008     uint256 public maxWallet;
1009 
1010     uint256 public percentForLPBurn = 25; // 25 = .25%
1011     bool public lpBurnEnabled = false;
1012     uint256 public lpBurnFrequency = 3600 seconds;
1013     uint256 public lastLpBurnTime;
1014 
1015     uint256 public manualBurnFrequency = 30 minutes;
1016     uint256 public lastManualLpBurnTime;
1017 
1018     bool public limitsInEffect = true;
1019     bool public tradingActive = false;
1020     bool public swapEnabled = false;
1021 
1022     // Anti-bot and anti-whale mappings and variables
1023     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1024     bool public transferDelayEnabled = true;
1025 
1026     uint256 public buyTotalFees;
1027     uint256 public buyMarketingFee;
1028     uint256 public buyLiquidityFee;
1029     uint256 public buyDevFee;
1030 
1031     uint256 public sellTotalFees;
1032     uint256 public sellMarketingFee;
1033     uint256 public sellLiquidityFee;
1034     uint256 public sellDevFee;
1035 
1036     uint256 public tokensForMarketing;
1037     uint256 public tokensForLiquidity;
1038     uint256 public tokensForDev;
1039 
1040     /******************/
1041 
1042     // exlcude from fees and max transaction amount
1043     mapping(address => bool) private _isExcludedFromFees;
1044     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1045 
1046     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1047     // could be subject to a maximum transfer amount
1048     mapping(address => bool) public automatedMarketMakerPairs;
1049 
1050     event UpdateUniswapV2Router(
1051         address indexed newAddress,
1052         address indexed oldAddress
1053     );
1054 
1055     event ExcludeFromFees(address indexed account, bool isExcluded);
1056 
1057     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1058 
1059     event marketingWalletUpdated(
1060         address indexed newWallet,
1061         address indexed oldWallet
1062     );
1063 
1064     event devWalletUpdated(
1065         address indexed newWallet,
1066         address indexed oldWallet
1067     );
1068 
1069     event SwapAndLiquify(
1070         uint256 tokensSwapped,
1071         uint256 ethReceived,
1072         uint256 tokensIntoLiquidity
1073     );
1074 
1075     event AutoNukeLP();
1076 
1077     event ManualNukeLP();
1078 
1079     constructor() ERC20("Saudi Inu", "Saudi") {
1080         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1081             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1082         );
1083 
1084         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1085         uniswapV2Router = _uniswapV2Router;
1086 
1087         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1088             .createPair(address(this), _uniswapV2Router.WETH());
1089         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1090         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1091 
1092         uint256 _buyMarketingFee = 4;
1093         uint256 _buyLiquidityFee = 2;
1094         uint256 _buyDevFee = 1;
1095 
1096         uint256 _sellMarketingFee = 6;
1097         uint256 _sellLiquidityFee = 3;
1098         uint256 _sellDevFee = 1;
1099 
1100         uint256 totalSupply = 1_000_000_000 * 1e18;
1101 
1102         maxTransactionAmount = 10_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1103         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1104         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1105 
1106         buyMarketingFee = _buyMarketingFee;
1107         buyLiquidityFee = _buyLiquidityFee;
1108         buyDevFee = _buyDevFee;
1109         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1110 
1111         sellMarketingFee = _sellMarketingFee;
1112         sellLiquidityFee = _sellLiquidityFee;
1113         sellDevFee = _sellDevFee;
1114         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1115 
1116         marketingWallet = address(0x3507C90106924797A29f86F2Db1F5D07FbD66171); // set as marketing wallet
1117         devWallet = address(0xbd0Bc214927DA3e5a37dA8B42239e3c9480D75ca); // set as dev wallet
1118 
1119         // exclude from paying fees or having max transaction amount
1120         excludeFromFees(owner(), true);
1121         excludeFromFees(address(this), true);
1122         excludeFromFees(address(0xdead), true);
1123 
1124         excludeFromMaxTransaction(owner(), true);
1125         excludeFromMaxTransaction(address(this), true);
1126         excludeFromMaxTransaction(address(0xdead), true);
1127 
1128         /*
1129             _mint is an internal function in ERC20.sol that is only called here,
1130             and CANNOT be called ever again
1131         */
1132         _mint(msg.sender, totalSupply);
1133     }
1134 
1135     receive() external payable {}
1136 
1137     // once enabled, can never be turned off
1138     function enableTrading() external onlyOwner {
1139         tradingActive = true;
1140         swapEnabled = true;
1141         lastLpBurnTime = block.timestamp;
1142     }
1143 
1144     // remove limits after token is stable
1145     function removeLimits() external onlyOwner returns (bool) {
1146         limitsInEffect = false;
1147         return true;
1148     }
1149 
1150     // disable Transfer delay - cannot be reenabled
1151     function disableTransferDelay() external onlyOwner returns (bool) {
1152         transferDelayEnabled = false;
1153         return true;
1154     }
1155 
1156     // change the minimum amount of tokens to sell from fees
1157     function updateSwapTokensAtAmount(uint256 newAmount)
1158         external
1159         onlyOwner
1160         returns (bool)
1161     {
1162         require(
1163             newAmount >= (totalSupply() * 1) / 100000,
1164             "Swap amount cannot be lower than 0.001% total supply."
1165         );
1166         require(
1167             newAmount <= (totalSupply() * 5) / 1000,
1168             "Swap amount cannot be higher than 0.5% total supply."
1169         );
1170         swapTokensAtAmount = newAmount;
1171         return true;
1172     }
1173 
1174     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1175         require(
1176             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1177             "Cannot set maxTransactionAmount lower than 0.1%"
1178         );
1179         maxTransactionAmount = newNum * (10**18);
1180     }
1181 
1182     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1183         require(
1184             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1185             "Cannot set maxWallet lower than 0.5%"
1186         );
1187         maxWallet = newNum * (10**18);
1188     }
1189 
1190     function excludeFromMaxTransaction(address updAds, bool isEx)
1191         public
1192         onlyOwner
1193     {
1194         _isExcludedMaxTransactionAmount[updAds] = isEx;
1195     }
1196 
1197     // only use to disable contract sales if absolutely necessary (emergency use only)
1198     function updateSwapEnabled(bool enabled) external onlyOwner {
1199         swapEnabled = enabled;
1200     }
1201 
1202     function updateBuyFees(
1203         uint256 _marketingFee,
1204         uint256 _liquidityFee,
1205         uint256 _devFee
1206     ) external onlyOwner {
1207         buyMarketingFee = _marketingFee;
1208         buyLiquidityFee = _liquidityFee;
1209         buyDevFee = _devFee;
1210         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1211         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1212     }
1213 
1214     function updateSellFees(
1215         uint256 _marketingFee,
1216         uint256 _liquidityFee,
1217         uint256 _devFee
1218     ) external onlyOwner {
1219         sellMarketingFee = _marketingFee;
1220         sellLiquidityFee = _liquidityFee;
1221         sellDevFee = _devFee;
1222         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1223         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1224     }
1225 
1226     function excludeFromFees(address account, bool excluded) public onlyOwner {
1227         _isExcludedFromFees[account] = excluded;
1228         emit ExcludeFromFees(account, excluded);
1229     }
1230 
1231     function setAutomatedMarketMakerPair(address pair, bool value)
1232         public
1233         onlyOwner
1234     {
1235         require(
1236             pair != uniswapV2Pair,
1237             "The pair cannot be removed from automatedMarketMakerPairs"
1238         );
1239 
1240         _setAutomatedMarketMakerPair(pair, value);
1241     }
1242 
1243     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1244         automatedMarketMakerPairs[pair] = value;
1245 
1246         emit SetAutomatedMarketMakerPair(pair, value);
1247     }
1248 
1249     function updateMarketingWallet(address newMarketingWallet)
1250         external
1251         onlyOwner
1252     {
1253         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1254         marketingWallet = newMarketingWallet;
1255     }
1256 
1257     function updateDevWallet(address newWallet) external onlyOwner {
1258         emit devWalletUpdated(newWallet, devWallet);
1259         devWallet = newWallet;
1260     }
1261 
1262     function isExcludedFromFees(address account) public view returns (bool) {
1263         return _isExcludedFromFees[account];
1264     }
1265 
1266     event BoughtEarly(address indexed sniper);
1267 
1268     function _transfer(
1269         address from,
1270         address to,
1271         uint256 amount
1272     ) internal override {
1273         require(from != address(0), "ERC20: transfer from the zero address");
1274         require(to != address(0), "ERC20: transfer to the zero address");
1275 
1276         if (amount == 0) {
1277             super._transfer(from, to, 0);
1278             return;
1279         }
1280 
1281         if (limitsInEffect) {
1282             if (
1283                 from != owner() &&
1284                 to != owner() &&
1285                 to != address(0) &&
1286                 to != address(0xdead) &&
1287                 !swapping
1288             ) {
1289                 if (!tradingActive) {
1290                     require(
1291                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1292                         "Trading is not active."
1293                     );
1294                 }
1295 
1296                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1297                 if (transferDelayEnabled) {
1298                     if (
1299                         to != owner() &&
1300                         to != address(uniswapV2Router) &&
1301                         to != address(uniswapV2Pair)
1302                     ) {
1303                         require(
1304                             _holderLastTransferTimestamp[tx.origin] <
1305                                 block.number,
1306                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1307                         );
1308                         _holderLastTransferTimestamp[tx.origin] = block.number;
1309                     }
1310                 }
1311 
1312                 //when buy
1313                 if (
1314                     automatedMarketMakerPairs[from] &&
1315                     !_isExcludedMaxTransactionAmount[to]
1316                 ) {
1317                     require(
1318                         amount <= maxTransactionAmount,
1319                         "Buy transfer amount exceeds the maxTransactionAmount."
1320                     );
1321                     require(
1322                         amount + balanceOf(to) <= maxWallet,
1323                         "Max wallet exceeded"
1324                     );
1325                 }
1326                 //when sell
1327                 else if (
1328                     automatedMarketMakerPairs[to] &&
1329                     !_isExcludedMaxTransactionAmount[from]
1330                 ) {
1331                     require(
1332                         amount <= maxTransactionAmount,
1333                         "Sell transfer amount exceeds the maxTransactionAmount."
1334                     );
1335                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1336                     require(
1337                         amount + balanceOf(to) <= maxWallet,
1338                         "Max wallet exceeded"
1339                     );
1340                 }
1341             }
1342         }
1343 
1344         uint256 contractTokenBalance = balanceOf(address(this));
1345 
1346         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1347 
1348         if (
1349             canSwap &&
1350             swapEnabled &&
1351             !swapping &&
1352             !automatedMarketMakerPairs[from] &&
1353             !_isExcludedFromFees[from] &&
1354             !_isExcludedFromFees[to]
1355         ) {
1356             swapping = true;
1357 
1358             swapBack();
1359 
1360             swapping = false;
1361         }
1362 
1363         if (
1364             !swapping &&
1365             automatedMarketMakerPairs[to] &&
1366             lpBurnEnabled &&
1367             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1368             !_isExcludedFromFees[from]
1369         ) {
1370             autoBurnLiquidityPairTokens();
1371         }
1372 
1373         bool takeFee = !swapping;
1374 
1375         // if any account belongs to _isExcludedFromFee account then remove the fee
1376         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1377             takeFee = false;
1378         }
1379 
1380         uint256 fees = 0;
1381         // only take fees on buys/sells, do not take on wallet transfers
1382         if (takeFee) {
1383             // on sell
1384             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1385                 fees = amount.mul(sellTotalFees).div(100);
1386                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1387                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1388                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1389             }
1390             // on buy
1391             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1392                 fees = amount.mul(buyTotalFees).div(100);
1393                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1394                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1395                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1396             }
1397 
1398             if (fees > 0) {
1399                 super._transfer(from, address(this), fees);
1400             }
1401 
1402             amount -= fees;
1403         }
1404 
1405         super._transfer(from, to, amount);
1406     }
1407 
1408     function swapTokensForEth(uint256 tokenAmount) private {
1409         // generate the uniswap pair path of token -> weth
1410         address[] memory path = new address[](2);
1411         path[0] = address(this);
1412         path[1] = uniswapV2Router.WETH();
1413 
1414         _approve(address(this), address(uniswapV2Router), tokenAmount);
1415 
1416         // make the swap
1417         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1418             tokenAmount,
1419             0, // accept any amount of ETH
1420             path,
1421             address(this),
1422             block.timestamp
1423         );
1424     }
1425 
1426     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1427         // approve token transfer to cover all possible scenarios
1428         _approve(address(this), address(uniswapV2Router), tokenAmount);
1429 
1430         // add the liquidity
1431         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1432             address(this),
1433             tokenAmount,
1434             0, // slippage is unavoidable
1435             0, // slippage is unavoidable
1436             deadAddress,
1437             block.timestamp
1438         );
1439     }
1440 
1441     function swapBack() private {
1442         uint256 contractBalance = balanceOf(address(this));
1443         uint256 totalTokensToSwap = tokensForLiquidity +
1444             tokensForMarketing +
1445             tokensForDev;
1446         bool success;
1447 
1448         if (contractBalance == 0 || totalTokensToSwap == 0) {
1449             return;
1450         }
1451 
1452         if (contractBalance > swapTokensAtAmount * 20) {
1453             contractBalance = swapTokensAtAmount * 20;
1454         }
1455 
1456         // Halve the amount of liquidity tokens
1457         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1458             totalTokensToSwap /
1459             2;
1460         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1461 
1462         uint256 initialETHBalance = address(this).balance;
1463 
1464         swapTokensForEth(amountToSwapForETH);
1465 
1466         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1467 
1468         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1469             totalTokensToSwap
1470         );
1471         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1472 
1473         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1474 
1475         tokensForLiquidity = 0;
1476         tokensForMarketing = 0;
1477         tokensForDev = 0;
1478 
1479         (success, ) = address(devWallet).call{value: ethForDev}("");
1480 
1481         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1482             addLiquidity(liquidityTokens, ethForLiquidity);
1483             emit SwapAndLiquify(
1484                 amountToSwapForETH,
1485                 ethForLiquidity,
1486                 tokensForLiquidity
1487             );
1488         }
1489 
1490         (success, ) = address(marketingWallet).call{
1491             value: address(this).balance
1492         }("");
1493     }
1494 
1495     function setAutoLPBurnSettings(
1496         uint256 _frequencyInSeconds,
1497         uint256 _percent,
1498         bool _Enabled
1499     ) external onlyOwner {
1500         require(
1501             _frequencyInSeconds >= 600,
1502             "cannot set buyback more often than every 10 minutes"
1503         );
1504         require(
1505             _percent <= 1000 && _percent >= 0,
1506             "Must set auto LP burn percent between 0% and 10%"
1507         );
1508         lpBurnFrequency = _frequencyInSeconds;
1509         percentForLPBurn = _percent;
1510         lpBurnEnabled = _Enabled;
1511     }
1512 
1513     function autoBurnLiquidityPairTokens() internal returns (bool) {
1514         lastLpBurnTime = block.timestamp;
1515 
1516         // get balance of liquidity pair
1517         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1518 
1519         // calculate amount to burn
1520         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1521             10000
1522         );
1523 
1524         // pull tokens from pancakePair liquidity and move to dead address permanently
1525         if (amountToBurn > 0) {
1526             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1527         }
1528 
1529         //sync price since this is not in a swap transaction!
1530         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1531         pair.sync();
1532         emit AutoNukeLP();
1533         return true;
1534     }
1535 
1536     function manualBurnLiquidityPairTokens(uint256 percent)
1537         external
1538         onlyOwner
1539         returns (bool)
1540     {
1541         require(
1542             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1543             "Must wait for cooldown to finish"
1544         );
1545         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1546         lastManualLpBurnTime = block.timestamp;
1547 
1548         // get balance of liquidity pair
1549         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1550 
1551         // calculate amount to burn
1552         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1553 
1554         // pull tokens from pancakePair liquidity and move to dead address permanently
1555         if (amountToBurn > 0) {
1556             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1557         }
1558 
1559         //sync price since this is not in a swap transaction!
1560         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1561         pair.sync();
1562         emit ManualNukeLP();
1563         return true;
1564     }
1565 }