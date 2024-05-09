1 /**
2 Telegram : https://t.me/disisdawae 
3 
4 Website : https://www.dawae.vip
5 
6 Twitter: https://x.com/disisdawae
7 
8 You are lost without purpose, a rebel without a cause. Join us brothers, join us in finding DA WAE
9 */
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity =0.8.9 >=0.8.9 >=0.8.0 <0.9.0;
13 pragma experimental ABIEncoderV2;
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
106 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
107 
108 /* pragma solidity ^0.8.0; */
109 
110 /**
111  * @dev Interface of the ERC20 standard as defined in the EIP.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through {transferFrom}. This is
136      * zero by default.
137      *
138      * This value changes when {approve} or {transferFrom} are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to {approve}. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
189 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
190 
191 /* pragma solidity ^0.8.0; */
192 
193 /* import "../IERC20.sol"; */
194 
195 /**
196  * @dev Interface for the optional metadata functions from the ERC20 standard.
197  *
198  * _Available since v4.1._
199  */
200 interface IERC20Metadata is IERC20 {
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the symbol of the token.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the decimals places of the token.
213      */
214     function decimals() external view returns (uint8);
215 }
216 
217 /**
218  * @dev Implementation of the {IERC20} interface.
219  *
220  * This implementation is agnostic to the way tokens are created. This means
221  * that a supply mechanism has to be added in a derived contract using {_mint}.
222  * For a generic mechanism see {ERC20PresetMinterPauser}.
223  *
224  * TIP: For a detailed writeup see our guide
225  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
226  * to implement supply mechanisms].
227  *
228  * We have followed general OpenZeppelin Contracts guidelines: functions revert
229  * instead returning `false` on failure. This behavior is nonetheless
230  * conventional and does not conflict with the expectations of ERC20
231  * applications.
232  *
233  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
234  * This allows applications to reconstruct the allowance for all accounts just
235  * by listening to said events. Other implementations of the EIP may not emit
236  * these events, as it isn't required by the specification.
237  *
238  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
239  * functions have been added to mitigate the well-known issues around setting
240  * allowances. See {IERC20-approve}.
241  */
242 contract ERC20 is Context, IERC20, IERC20Metadata {
243     mapping(address => uint256) private _balances;
244 
245     mapping(address => mapping(address => uint256)) private _allowances;
246 
247     uint256 private _totalSupply;
248 
249     string private _name;
250     string private _symbol;
251 
252     /**
253      * @dev Sets the values for {name} and {symbol}.
254      *
255      * The default value of {decimals} is 18. To select a different value for
256      * {decimals} you should overload it.
257      *
258      * All two of these values are immutable: they can only be set once during
259      * construction.
260      */
261     constructor(string memory name_, string memory symbol_) {
262         _name = name_;
263         _symbol = symbol_;
264     }
265 
266     /**
267      * @dev Returns the name of the token.
268      */
269     function name() public view virtual override returns (string memory) {
270         return _name;
271     }
272 
273     /**
274      * @dev Returns the symbol of the token, usually a shorter version of the
275      * name.
276      */
277     function symbol() public view virtual override returns (string memory) {
278         return _symbol;
279     }
280 
281     /**
282      * @dev Returns the number of decimals used to get its user representation.
283      * For example, if `decimals` equals `2`, a balance of `505` tokens should
284      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
285      *
286      * Tokens usually opt for a value of 18, imitating the relationship between
287      * Ether and Wei. This is the value {ERC20} uses, unless this function is
288      * overridden;
289      *
290      * NOTE: This information is only used for _display_ purposes: it in
291      * no way affects any of the arithmetic of the contract, including
292      * {IERC20-balanceOf} and {IERC20-transfer}.
293      */
294     function decimals() public view virtual override returns (uint8) {
295         return 18;
296     }
297 
298     /**
299      * @dev See {IERC20-totalSupply}.
300      */
301     function totalSupply() public view virtual override returns (uint256) {
302         return _totalSupply;
303     }
304 
305     /**
306      * @dev See {IERC20-balanceOf}.
307      */
308     function balanceOf(address account) public view virtual override returns (uint256) {
309         return _balances[account];
310     }
311 
312     /**
313      * @dev See {IERC20-transfer}.
314      *
315      * Requirements:
316      *
317      * - `recipient` cannot be the zero address.
318      * - the caller must have a balance of at least `amount`.
319      */
320     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-allowance}.
327      */
328     function allowance(address owner, address spender) public view virtual override returns (uint256) {
329         return _allowances[owner][spender];
330     }
331 
332     /**
333      * @dev See {IERC20-approve}.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 amount) public virtual override returns (bool) {
340         _approve(_msgSender(), spender, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-transferFrom}.
346      *
347      * Emits an {Approval} event indicating the updated allowance. This is not
348      * required by the EIP. See the note at the beginning of {ERC20}.
349      *
350      * Requirements:
351      *
352      * - `sender` and `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      * - the caller must have allowance for ``sender``'s tokens of at least
355      * `amount`.
356      */
357     function transferFrom(
358         address sender,
359         address recipient,
360         uint256 amount
361     ) public virtual override returns (bool) {
362         _transfer(sender, recipient, amount);
363 
364         uint256 currentAllowance = _allowances[sender][_msgSender()];
365         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
366         unchecked {
367             _approve(sender, _msgSender(), currentAllowance - amount);
368         }
369 
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
405         uint256 currentAllowance = _allowances[_msgSender()][spender];
406         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
407         unchecked {
408             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
409         }
410 
411         return true;
412     }
413 
414     /**
415      * @dev Moves `amount` of tokens from `sender` to `recipient`.
416      *
417      * This internal function is equivalent to {transfer}, and can be used to
418      * e.g. implement automatic token fees, slashing mechanisms, etc.
419      *
420      * Emits a {Transfer} event.
421      *
422      * Requirements:
423      *
424      * - `sender` cannot be the zero address.
425      * - `recipient` cannot be the zero address.
426      * - `sender` must have a balance of at least `amount`.
427      */
428     function _transfer(
429         address sender,
430         address recipient,
431         uint256 amount
432     ) internal virtual {
433         require(sender != address(0), "ERC20: transfer from the zero address");
434         require(recipient != address(0), "ERC20: transfer to the zero address");
435 
436         _beforeTokenTransfer(sender, recipient, amount);
437 
438         uint256 senderBalance = _balances[sender];
439         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
440         unchecked {
441             _balances[sender] = senderBalance - amount;
442         }
443         _balances[recipient] += amount;
444 
445         emit Transfer(sender, recipient, amount);
446 
447         _afterTokenTransfer(sender, recipient, amount);
448     }
449 
450     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
451      * the total supply.
452      *
453      * Emits a {Transfer} event with `from` set to the zero address.
454      *
455      * Requirements:
456      *
457      * - `account` cannot be the zero address.
458      */
459     function _mint(address account, uint256 amount) internal virtual {
460         require(account != address(0), "ERC20: mint to the zero address");
461 
462         _beforeTokenTransfer(address(0), account, amount);
463 
464         _totalSupply += amount;
465         _balances[account] += amount;
466         emit Transfer(address(0), account, amount);
467 
468         _afterTokenTransfer(address(0), account, amount);
469     }
470 
471     /**
472      * @dev Destroys `amount` tokens from `account`, reducing the
473      * total supply.
474      *
475      * Emits a {Transfer} event with `to` set to the zero address.
476      *
477      * Requirements:
478      *
479      * - `account` cannot be the zero address.
480      * - `account` must have at least `amount` tokens.
481      */
482     function _burn(address account, uint256 amount) internal virtual {
483         require(account != address(0), "ERC20: burn from the zero address");
484 
485         _beforeTokenTransfer(account, address(0), amount);
486 
487         uint256 accountBalance = _balances[account];
488         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
489         unchecked {
490             _balances[account] = accountBalance - amount;
491         }
492         _totalSupply -= amount;
493 
494         emit Transfer(account, address(0), amount);
495 
496         _afterTokenTransfer(account, address(0), amount);
497     }
498 
499     /**
500      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
501      *
502      * This internal function is equivalent to `approve`, and can be used to
503      * e.g. set automatic allowances for certain subsystems, etc.
504      *
505      * Emits an {Approval} event.
506      *
507      * Requirements:
508      *
509      * - `owner` cannot be the zero address.
510      * - `spender` cannot be the zero address.
511      */
512     function _approve(
513         address owner,
514         address spender,
515         uint256 amount
516     ) internal virtual {
517         require(owner != address(0), "ERC20: approve from the zero address");
518         require(spender != address(0), "ERC20: approve to the zero address");
519 
520         _allowances[owner][spender] = amount;
521         emit Approval(owner, spender, amount);
522     }
523 
524     /**
525      * @dev Hook that is called before any transfer of tokens. This includes
526      * minting and burning.
527      *
528      * Calling conditions:
529      *
530      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
531      * will be transferred to `to`.
532      * - when `from` is zero, `amount` tokens will be minted for `to`.
533      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
534      * - `from` and `to` are never both zero.
535      *
536      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
537      */
538     function _beforeTokenTransfer(
539         address from,
540         address to,
541         uint256 amount
542     ) internal virtual {}
543 
544     /**
545      * @dev Hook that is called after any transfer of tokens. This includes
546      * minting and burning.
547      *
548      * Calling conditions:
549      *
550      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
551      * has been transferred to `to`.
552      * - when `from` is zero, `amount` tokens have been minted for `to`.
553      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
554      * - `from` and `to` are never both zero.
555      *
556      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
557      */
558     function _afterTokenTransfer(
559         address from,
560         address to,
561         uint256 amount
562     ) internal virtual {}
563 }
564 
565 /**
566  * @dev Wrappers over Solidity's arithmetic operations.
567  *
568  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
569  * now has built in overflow checking.
570  */
571 library SafeMath {
572     /**
573      * @dev Returns the addition of two unsigned integers, with an overflow flag.
574      *
575      * _Available since v3.4._
576      */
577     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
578         unchecked {
579             uint256 c = a + b;
580             if (c < a) return (false, 0);
581             return (true, c);
582         }
583     }
584 
585     /**
586      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
587      *
588      * _Available since v3.4._
589      */
590     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
591         unchecked {
592             if (b > a) return (false, 0);
593             return (true, a - b);
594         }
595     }
596 
597     /**
598      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
599      *
600      * _Available since v3.4._
601      */
602     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
603         unchecked {
604             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
605             // benefit is lost if 'b' is also tested.
606             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
607             if (a == 0) return (true, 0);
608             uint256 c = a * b;
609             if (c / a != b) return (false, 0);
610             return (true, c);
611         }
612     }
613 
614     /**
615      * @dev Returns the division of two unsigned integers, with a division by zero flag.
616      *
617      * _Available since v3.4._
618      */
619     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             if (b == 0) return (false, 0);
622             return (true, a / b);
623         }
624     }
625 
626     /**
627      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
628      *
629      * _Available since v3.4._
630      */
631     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
632         unchecked {
633             if (b == 0) return (false, 0);
634             return (true, a % b);
635         }
636     }
637 
638     /**
639      * @dev Returns the addition of two unsigned integers, reverting on
640      * overflow.
641      *
642      * Counterpart to Solidity's `+` operator.
643      *
644      * Requirements:
645      *
646      * - Addition cannot overflow.
647      */
648     function add(uint256 a, uint256 b) internal pure returns (uint256) {
649         return a + b;
650     }
651 
652     /**
653      * @dev Returns the subtraction of two unsigned integers, reverting on
654      * overflow (when the result is negative).
655      *
656      * Counterpart to Solidity's `-` operator.
657      *
658      * Requirements:
659      *
660      * - Subtraction cannot overflow.
661      */
662     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
663         return a - b;
664     }
665 
666     /**
667      * @dev Returns the multiplication of two unsigned integers, reverting on
668      * overflow.
669      *
670      * Counterpart to Solidity's `*` operator.
671      *
672      * Requirements:
673      *
674      * - Multiplication cannot overflow.
675      */
676     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
677         return a * b;
678     }
679 
680     /**
681      * @dev Returns the integer division of two unsigned integers, reverting on
682      * division by zero. The result is rounded towards zero.
683      *
684      * Counterpart to Solidity's `/` operator.
685      *
686      * Requirements:
687      *
688      * - The divisor cannot be zero.
689      */
690     function div(uint256 a, uint256 b) internal pure returns (uint256) {
691         return a / b;
692     }
693 
694     /**
695      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
696      * reverting when dividing by zero.
697      *
698      * Counterpart to Solidity's `%` operator. This function uses a `revert`
699      * opcode (which leaves remaining gas untouched) while Solidity uses an
700      * invalid opcode to revert (consuming all remaining gas).
701      *
702      * Requirements:
703      *
704      * - The divisor cannot be zero.
705      */
706     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
707         return a % b;
708     }
709 
710     /**
711      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
712      * overflow (when the result is negative).
713      *
714      * CAUTION: This function is deprecated because it requires allocating memory for the error
715      * message unnecessarily. For custom revert reasons use {trySub}.
716      *
717      * Counterpart to Solidity's `-` operator.
718      *
719      * Requirements:
720      *
721      * - Subtraction cannot overflow.
722      */
723     function sub(
724         uint256 a,
725         uint256 b,
726         string memory errorMessage
727     ) internal pure returns (uint256) {
728         unchecked {
729             require(b <= a, errorMessage);
730             return a - b;
731         }
732     }
733 
734     /**
735      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
736      * division by zero. The result is rounded towards zero.
737      *
738      * Counterpart to Solidity's `/` operator. Note: this function uses a
739      * `revert` opcode (which leaves remaining gas untouched) while Solidity
740      * uses an invalid opcode to revert (consuming all remaining gas).
741      *
742      * Requirements:
743      *
744      * - The divisor cannot be zero.
745      */
746     function div(
747         uint256 a,
748         uint256 b,
749         string memory errorMessage
750     ) internal pure returns (uint256) {
751         unchecked {
752             require(b > 0, errorMessage);
753             return a / b;
754         }
755     }
756 
757     /**
758      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
759      * reverting with custom message when dividing by zero.
760      *
761      * CAUTION: This function is deprecated because it requires allocating memory for the error
762      * message unnecessarily. For custom revert reasons use {tryMod}.
763      *
764      * Counterpart to Solidity's `%` operator. This function uses a `revert`
765      * opcode (which leaves remaining gas untouched) while Solidity uses an
766      * invalid opcode to revert (consuming all remaining gas).
767      *
768      * Requirements:
769      *
770      * - The divisor cannot be zero.
771      */
772     function mod(
773         uint256 a,
774         uint256 b,
775         string memory errorMessage
776     ) internal pure returns (uint256) {
777         unchecked {
778             require(b > 0, errorMessage);
779             return a % b;
780         }
781     }
782 }
783 
784 interface IUniswapV2Factory {
785     event PairCreated(
786         address indexed token0,
787         address indexed token1,
788         address pair,
789         uint256
790     );
791 
792     function feeTo() external view returns (address);
793 
794     function feeToSetter() external view returns (address);
795 
796     function getPair(address tokenA, address tokenB)
797         external
798         view
799         returns (address pair);
800 
801     function allPairs(uint256) external view returns (address pair);
802 
803     function allPairsLength() external view returns (uint256);
804 
805     function createPair(address tokenA, address tokenB)
806         external
807         returns (address pair);
808 
809     function setFeeTo(address) external;
810 
811     function setFeeToSetter(address) external;
812 }
813 
814 ////// src/IUniswapV2Pair.sol
815 /* pragma solidity 0.8.10; */
816 /* pragma experimental ABIEncoderV2; */
817 
818 interface IUniswapV2Pair {
819     event Approval(
820         address indexed owner,
821         address indexed spender,
822         uint256 value
823     );
824     event Transfer(address indexed from, address indexed to, uint256 value);
825 
826     function name() external pure returns (string memory);
827 
828     function symbol() external pure returns (string memory);
829 
830     function decimals() external pure returns (uint8);
831 
832     function totalSupply() external view returns (uint256);
833 
834     function balanceOf(address owner) external view returns (uint256);
835 
836     function allowance(address owner, address spender)
837         external
838         view
839         returns (uint256);
840 
841     function approve(address spender, uint256 value) external returns (bool);
842 
843     function transfer(address to, uint256 value) external returns (bool);
844 
845     function transferFrom(
846         address from,
847         address to,
848         uint256 value
849     ) external returns (bool);
850 
851     function DOMAIN_SEPARATOR() external view returns (bytes32);
852 
853     function PERMIT_TYPEHASH() external pure returns (bytes32);
854 
855     function nonces(address owner) external view returns (uint256);
856 
857     function permit(
858         address owner,
859         address spender,
860         uint256 value,
861         uint256 deadline,
862         uint8 v,
863         bytes32 r,
864         bytes32 s
865     ) external;
866 
867     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
868     event Burn(
869         address indexed sender,
870         uint256 amount0,
871         uint256 amount1,
872         address indexed to
873     );
874     event Swap(
875         address indexed sender,
876         uint256 amount0In,
877         uint256 amount1In,
878         uint256 amount0Out,
879         uint256 amount1Out,
880         address indexed to
881     );
882     event Sync(uint112 reserve0, uint112 reserve1);
883 
884     function MINIMUM_LIQUIDITY() external pure returns (uint256);
885 
886     function factory() external view returns (address);
887 
888     function token0() external view returns (address);
889 
890     function token1() external view returns (address);
891 
892     function getReserves()
893         external
894         view
895         returns (
896             uint112 reserve0,
897             uint112 reserve1,
898             uint32 blockTimestampLast
899         );
900 
901     function price0CumulativeLast() external view returns (uint256);
902 
903     function price1CumulativeLast() external view returns (uint256);
904 
905     function kLast() external view returns (uint256);
906 
907     function mint(address to) external returns (uint256 liquidity);
908 
909     function burn(address to)
910         external
911         returns (uint256 amount0, uint256 amount1);
912 
913     function swap(
914         uint256 amount0Out,
915         uint256 amount1Out,
916         address to,
917         bytes calldata data
918     ) external;
919 
920     function skim(address to) external;
921 
922     function sync() external;
923 
924     function initialize(address, address) external;
925 }
926 
927 interface IUniswapV2Router02 {
928     function factory() external pure returns (address);
929 
930     function WETH() external pure returns (address);
931 
932     function addLiquidity(
933         address tokenA,
934         address tokenB,
935         uint256 amountADesired,
936         uint256 amountBDesired,
937         uint256 amountAMin,
938         uint256 amountBMin,
939         address to,
940         uint256 deadline
941     )
942         external
943         returns (
944             uint256 amountA,
945             uint256 amountB,
946             uint256 liquidity
947         );
948 
949     function addLiquidityETH(
950         address token,
951         uint256 amountTokenDesired,
952         uint256 amountTokenMin,
953         uint256 amountETHMin,
954         address to,
955         uint256 deadline
956     )
957         external
958         payable
959         returns (
960             uint256 amountToken,
961             uint256 amountETH,
962             uint256 liquidity
963         );
964 
965     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
966         uint256 amountIn,
967         uint256 amountOutMin,
968         address[] calldata path,
969         address to,
970         uint256 deadline
971     ) external;
972 
973     function swapExactETHForTokensSupportingFeeOnTransferTokens(
974         uint256 amountOutMin,
975         address[] calldata path,
976         address to,
977         uint256 deadline
978     ) external payable;
979 
980     function swapExactTokensForETHSupportingFeeOnTransferTokens(
981         uint256 amountIn,
982         uint256 amountOutMin,
983         address[] calldata path,
984         address to,
985         uint256 deadline
986     ) external;
987 }
988 
989 contract DAWAE is ERC20, Ownable {
990     using SafeMath for uint256;
991 
992     IUniswapV2Router02 public immutable uniswapV2Router;
993     address public immutable uniswapV2Pair;
994     address public constant deadAddress = address(0xdead);
995 
996     bool private swapping;
997 
998     address public marketingWallet;
999     address public devWallet;
1000 
1001     uint256 public maxTransactionAmount;
1002     uint256 public swapTokensAtAmount;
1003     uint256 public maxWallet;
1004 
1005     bool public limitsInEffect = true;
1006     bool public tradingActive = false;
1007     bool public swapEnabled = false;
1008 
1009     // Anti-bot and anti-whale mappings and variables
1010     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1011     mapping(address => bool) blacklisted;
1012     bool public transferDelayEnabled = true;
1013 
1014     uint256 public buyTotalFees;
1015     uint256 public buyMarketingFee;
1016     uint256 public buyLiquidityFee;
1017     uint256 public buyDevFee;
1018 
1019     uint256 public sellTotalFees;
1020     uint256 public sellMarketingFee;
1021     uint256 public sellLiquidityFee;
1022     uint256 public sellDevFee;
1023 
1024     uint256 public tokensForMarketing;
1025     uint256 public tokensForLiquidity;
1026     uint256 public tokensForDev;
1027 
1028     /******************/
1029 
1030     // exclude from fees and max transaction amount
1031     mapping(address => bool) private _isExcludedFromFees;
1032     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1033 
1034     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1035     // could be subject to a maximum transfer amount
1036     mapping(address => bool) public automatedMarketMakerPairs;
1037 
1038     event UpdateUniswapV2Router(
1039         address indexed newAddress,
1040         address indexed oldAddress
1041     );
1042 
1043     event ExcludeFromFees(address indexed account, bool isExcluded);
1044 
1045     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1046 
1047     event marketingWalletUpdated(
1048         address indexed newWallet,
1049         address indexed oldWallet
1050     );
1051 
1052     event devWalletUpdated(
1053         address indexed newWallet,
1054         address indexed oldWallet
1055     );
1056 
1057     event SwapAndLiquify(
1058         uint256 tokensSwapped,
1059         uint256 ethReceived,
1060         uint256 tokensIntoLiquidity
1061     );
1062 
1063     event AutoNukeLP();
1064 
1065     event ManualNukeLP();
1066 
1067     constructor() ERC20("Dawae", "DAWAE") {
1068         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1069             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1070         );
1071 
1072         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1073         uniswapV2Router = _uniswapV2Router;
1074 
1075         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1076             .createPair(address(this), _uniswapV2Router.WETH());
1077         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1078         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1079 
1080         uint256 _buyMarketingFee = 2;
1081         uint256 _buyLiquidityFee = 0;
1082         uint256 _buyDevFee = 0;
1083 
1084         uint256 _sellMarketingFee = 2;
1085         uint256 _sellLiquidityFee = 0;
1086         uint256 _sellDevFee = 0;
1087 
1088         uint256 totalSupply = 50_000_000 * 1e18;
1089 
1090         maxTransactionAmount = 50_000 * 1e18; // 0.1% from total supply maxTransactionAmountTxn
1091         maxWallet = 100_000 * 1e18; // 0.2% from total supply maxWallet
1092         swapTokensAtAmount = 25_000 * 1e18; // 0.05% swap wallet
1093 
1094         buyMarketingFee = _buyMarketingFee;
1095         buyLiquidityFee = _buyLiquidityFee;
1096         buyDevFee = _buyDevFee;
1097         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1098 
1099         sellMarketingFee = _sellMarketingFee;
1100         sellLiquidityFee = _sellLiquidityFee;
1101         sellDevFee = _sellDevFee;
1102         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1103 
1104         marketingWallet = address(0x657F6e5Bb39EEa6EDb15Bf2824785381e88929D0); // set as marketing wallet
1105         devWallet = address(0x657F6e5Bb39EEa6EDb15Bf2824785381e88929D0); // set as dev wallet
1106 
1107         // exclude from paying fees or having max transaction amount
1108         excludeFromFees(owner(), true);
1109         excludeFromFees(address(this), true);
1110         excludeFromFees(address(0xdead), true);
1111 
1112         excludeFromMaxTransaction(owner(), true);
1113         excludeFromMaxTransaction(address(this), true);
1114         excludeFromMaxTransaction(address(0xdead), true);
1115 
1116         /*
1117             _mint is an internal function in ERC20.sol that is only called here,
1118             and CANNOT be called ever again
1119         */
1120         _mint(msg.sender, totalSupply);
1121     }
1122 
1123     receive() external payable {}
1124 
1125     // once enabled, can never be turned off
1126     function enableTrading() external onlyOwner {
1127         tradingActive = true;
1128         swapEnabled = true;
1129     }
1130 
1131     // remove limits after token is stable
1132     function removeLimits() external onlyOwner returns (bool) {
1133         limitsInEffect = false;
1134         return true;
1135     }
1136 
1137     function enableLimits() external onlyOwner returns (bool) {
1138         limitsInEffect = true;
1139         return true;
1140     }
1141 
1142     // disable Transfer delay - cannot be reenabled
1143     function disableTransferDelay() external onlyOwner returns (bool) {
1144         transferDelayEnabled = false;
1145         return true;
1146     }
1147 
1148     // change the minimum amount of tokens to sell from fees
1149     function updateSwapTokensAtAmount(uint256 newAmount)
1150         external
1151         onlyOwner
1152         returns (bool)
1153     {
1154         swapTokensAtAmount = newAmount;
1155         return true;
1156     }
1157 
1158     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1159         maxTransactionAmount = newNum * (10**18);
1160     }
1161 
1162     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1163         maxWallet = newNum * (10**18);
1164     }
1165 
1166     function excludeFromMaxTransaction(address updAds, bool isEx)
1167         public
1168         onlyOwner
1169     {
1170         _isExcludedMaxTransactionAmount[updAds] = isEx;
1171     }
1172 
1173     // only use to disable contract sales if absolutely necessary (emergency use only)
1174     function updateSwapEnabled(bool enabled) external onlyOwner {
1175         swapEnabled = enabled;
1176     }
1177 
1178     function updateBuyFees(
1179         uint256 _marketingFee,
1180         uint256 _liquidityFee,
1181         uint256 _devFee
1182     ) external onlyOwner {
1183         buyMarketingFee = _marketingFee;
1184         buyLiquidityFee = _liquidityFee;
1185         buyDevFee = _devFee;
1186         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1187     }
1188 
1189     function updateSellFees(
1190         uint256 _marketingFee,
1191         uint256 _liquidityFee,
1192         uint256 _devFee
1193     ) external onlyOwner {
1194         sellMarketingFee = _marketingFee;
1195         sellLiquidityFee = _liquidityFee;
1196         sellDevFee = _devFee;
1197         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1198     }
1199 
1200     function excludeFromFees(address account, bool excluded) public onlyOwner {
1201         _isExcludedFromFees[account] = excluded;
1202         emit ExcludeFromFees(account, excluded);
1203     }
1204 
1205     function setAutomatedMarketMakerPair(address pair, bool value)
1206         public
1207         onlyOwner
1208     {
1209         require(
1210             pair != uniswapV2Pair,
1211             "The pair cannot be removed from automatedMarketMakerPairs"
1212         );
1213 
1214         _setAutomatedMarketMakerPair(pair, value);
1215     }
1216 
1217     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1218         automatedMarketMakerPairs[pair] = value;
1219 
1220         emit SetAutomatedMarketMakerPair(pair, value);
1221     }
1222 
1223     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1224         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1225         marketingWallet = newMarketingWallet;
1226     }
1227 
1228     function updateDevWallet(address newWallet) external onlyOwner {
1229         emit devWalletUpdated(newWallet, devWallet);
1230         devWallet = newWallet;
1231     }
1232 
1233     function isExcludedFromFees(address account) public view returns (bool) {
1234         return _isExcludedFromFees[account];
1235     }
1236 
1237     function isBlacklisted(address account) public view returns (bool) {
1238         return blacklisted[account];
1239     }
1240 
1241     function _transfer(
1242         address from,
1243         address to,
1244         uint256 amount
1245     ) internal override {
1246         require(from != address(0), "ERC20: transfer from the zero address");
1247         require(to != address(0), "ERC20: transfer to the zero address");
1248         require(!blacklisted[from],"Sender blacklisted");
1249         require(!blacklisted[to],"Receiver blacklisted");
1250 
1251         if (amount == 0) {
1252             super._transfer(from, to, 0);
1253             return;
1254         }
1255 
1256         if (limitsInEffect) {
1257             if (
1258                 from != owner() &&
1259                 to != owner() &&
1260                 to != address(0) &&
1261                 to != address(0xdead) &&
1262                 !swapping
1263             ) {
1264                 if (!tradingActive) {
1265                     require(
1266                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1267                         "Trading is not active."
1268                     );
1269                 }
1270 
1271                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1272                 if (transferDelayEnabled) {
1273                     if (
1274                         to != owner() &&
1275                         to != address(uniswapV2Router) &&
1276                         to != address(uniswapV2Pair)
1277                     ) {
1278                         require(
1279                             _holderLastTransferTimestamp[tx.origin] + 1 <
1280                                 block.number,
1281                             "_transfer:: Transfer Delay enabled.  Only one purchase per two blocks allowed."
1282                         );
1283                         _holderLastTransferTimestamp[tx.origin] = block.number;
1284                     }
1285                 }
1286 
1287                 //when buy
1288                 if (
1289                     automatedMarketMakerPairs[from] &&
1290                     !_isExcludedMaxTransactionAmount[to]
1291                 ) {
1292                     require(
1293                         amount <= maxTransactionAmount,
1294                         "Buy transfer amount exceeds the maxTransactionAmount."
1295                     );
1296                     require(
1297                         amount + balanceOf(to) <= maxWallet,
1298                         "Max wallet exceeded"
1299                     );
1300                 }
1301                 //when sell
1302                 else if (
1303                     automatedMarketMakerPairs[to] &&
1304                     !_isExcludedMaxTransactionAmount[from]
1305                 ) {
1306                     require(
1307                         amount <= maxTransactionAmount,
1308                         "Sell transfer amount exceeds the maxTransactionAmount."
1309                     );
1310                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1311                     require(
1312                         amount + balanceOf(to) <= maxWallet,
1313                         "Max wallet exceeded"
1314                     );
1315                 }
1316             }
1317         }
1318 
1319         uint256 contractTokenBalance = balanceOf(address(this));
1320 
1321         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1322 
1323         if (
1324             canSwap &&
1325             swapEnabled &&
1326             !swapping &&
1327             !automatedMarketMakerPairs[from] &&
1328             !_isExcludedFromFees[from] &&
1329             !_isExcludedFromFees[to]
1330         ) {
1331             swapping = true;
1332 
1333             swapBack();
1334 
1335             swapping = false;
1336         }
1337 
1338         bool takeFee = !swapping;
1339 
1340         // if any account belongs to _isExcludedFromFee account then remove the fee
1341         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1342             takeFee = false;
1343         }
1344 
1345         uint256 fees = 0;
1346         // only take fees on buys/sells, do not take on wallet transfers
1347         if (takeFee) {
1348             // on sell
1349             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1350                 fees = amount.mul(sellTotalFees).div(100);
1351                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1352                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1353                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1354             }
1355             // on buy
1356             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1357                 fees = amount.mul(buyTotalFees).div(100);
1358                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1359                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1360                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1361             }
1362 
1363             if (fees > 0) {
1364                 super._transfer(from, address(this), fees);
1365             }
1366 
1367             amount -= fees;
1368         }
1369 
1370         super._transfer(from, to, amount);
1371     }
1372 
1373     function swapTokensForEth(uint256 tokenAmount) private {
1374         // generate the uniswap pair path of token -> weth
1375         address[] memory path = new address[](2);
1376         path[0] = address(this);
1377         path[1] = uniswapV2Router.WETH();
1378 
1379         _approve(address(this), address(uniswapV2Router), tokenAmount);
1380 
1381         // make the swap
1382         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1383             tokenAmount,
1384             0, // accept any amount of ETH
1385             path,
1386             address(this),
1387             block.timestamp
1388         );
1389     }
1390 
1391     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1392         // approve token transfer to cover all possible scenarios
1393         _approve(address(this), address(uniswapV2Router), tokenAmount);
1394 
1395         // add the liquidity
1396         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1397             address(this),
1398             tokenAmount,
1399             0, // slippage is unavoidable
1400             0, // slippage is unavoidable
1401             owner(),
1402             block.timestamp
1403         );
1404     }
1405 
1406     function swapBack() private {
1407         uint256 contractBalance = balanceOf(address(this));
1408         uint256 totalTokensToSwap = tokensForLiquidity +
1409             tokensForMarketing +
1410             tokensForDev;
1411         bool success;
1412 
1413         if (contractBalance == 0 || totalTokensToSwap == 0) {
1414             return;
1415         }
1416 
1417         if (contractBalance > swapTokensAtAmount * 20) {
1418             contractBalance = swapTokensAtAmount * 20;
1419         }
1420 
1421         // Halve the amount of liquidity tokens
1422         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1423             totalTokensToSwap /
1424             2;
1425         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1426 
1427         uint256 initialETHBalance = address(this).balance;
1428 
1429         swapTokensForEth(amountToSwapForETH);
1430 
1431         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1432 
1433         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap - (tokensForLiquidity / 2));
1434         
1435         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap - (tokensForLiquidity / 2));
1436 
1437         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1438 
1439         tokensForLiquidity = 0;
1440         tokensForMarketing = 0;
1441         tokensForDev = 0;
1442 
1443         (success, ) = address(devWallet).call{value: ethForDev}("");
1444 
1445         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1446             addLiquidity(liquidityTokens, ethForLiquidity);
1447             emit SwapAndLiquify(
1448                 amountToSwapForETH,
1449                 ethForLiquidity,
1450                 tokensForLiquidity
1451             );
1452         }
1453 
1454         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1455     }
1456 
1457     function withdraw() external onlyOwner {
1458         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1459         IERC20(address(this)).transfer(msg.sender, balance);
1460         payable(msg.sender).transfer(address(this).balance);
1461     }
1462 
1463     function withdrawToken(address _token, address _to) external onlyOwner {
1464         require(_token != address(0), "_token address cannot be 0");
1465         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1466         IERC20(_token).transfer(_to, _contractBalance);
1467     }
1468 
1469     function blacklist(address _black) public onlyOwner {
1470         blacklisted[_black] = true;
1471     }
1472 
1473     function unblacklist(address _black) public onlyOwner {
1474         blacklisted[_black] = false;
1475     }
1476 }