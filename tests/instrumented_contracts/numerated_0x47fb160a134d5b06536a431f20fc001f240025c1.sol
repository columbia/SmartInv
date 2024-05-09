1 /**
2 Telegram : https://t.me/MOISTURISEDANDSTABLE 
3 Website : http://www.moisturisedandstable.com
4 Twitter: https://twitter.com/PHPSHMHXI
5 Linktree : https://linktr.ee/phpshmhxi
6 
7 SHITCOINING IS THE NEW STABLE
8 $TETHER IS THE ULTIMATE SHITCOIN
9 MAKE SURE YOU ARE MOISTURISED AND IN YOUR FAVOURITE CHAIR
10 WELCOME TO YOUR SEAT AT THE STABLE TABLE WHERE WE ARE ALL UNHINGED 
11 LETS EAT FAM - DIG IN :)
12 */
13 
14 // SPDX-License-Identifier: MIT
15 pragma solidity =0.8.9 >=0.8.9 >=0.8.0 <0.9.0;
16 pragma experimental ABIEncoderV2;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
109 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
110 
111 /* pragma solidity ^0.8.0; */
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `recipient`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `sender` to `recipient` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
192 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
193 
194 /* pragma solidity ^0.8.0; */
195 
196 /* import "../IERC20.sol"; */
197 
198 /**
199  * @dev Interface for the optional metadata functions from the ERC20 standard.
200  *
201  * _Available since v4.1._
202  */
203 interface IERC20Metadata is IERC20 {
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() external view returns (string memory);
208 
209     /**
210      * @dev Returns the symbol of the token.
211      */
212     function symbol() external view returns (string memory);
213 
214     /**
215      * @dev Returns the decimals places of the token.
216      */
217     function decimals() external view returns (uint8);
218 }
219 
220 /**
221  * @dev Implementation of the {IERC20} interface.
222  *
223  * This implementation is agnostic to the way tokens are created. This means
224  * that a supply mechanism has to be added in a derived contract using {_mint}.
225  * For a generic mechanism see {ERC20PresetMinterPauser}.
226  *
227  * TIP: For a detailed writeup see our guide
228  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
229  * to implement supply mechanisms].
230  *
231  * We have followed general OpenZeppelin Contracts guidelines: functions revert
232  * instead returning `false` on failure. This behavior is nonetheless
233  * conventional and does not conflict with the expectations of ERC20
234  * applications.
235  *
236  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
237  * This allows applications to reconstruct the allowance for all accounts just
238  * by listening to said events. Other implementations of the EIP may not emit
239  * these events, as it isn't required by the specification.
240  *
241  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
242  * functions have been added to mitigate the well-known issues around setting
243  * allowances. See {IERC20-approve}.
244  */
245 contract ERC20 is Context, IERC20, IERC20Metadata {
246     mapping(address => uint256) private _balances;
247 
248     mapping(address => mapping(address => uint256)) private _allowances;
249 
250     uint256 private _totalSupply;
251 
252     string private _name;
253     string private _symbol;
254 
255     /**
256      * @dev Sets the values for {name} and {symbol}.
257      *
258      * The default value of {decimals} is 18. To select a different value for
259      * {decimals} you should overload it.
260      *
261      * All two of these values are immutable: they can only be set once during
262      * construction.
263      */
264     constructor(string memory name_, string memory symbol_) {
265         _name = name_;
266         _symbol = symbol_;
267     }
268 
269     /**
270      * @dev Returns the name of the token.
271      */
272     function name() public view virtual override returns (string memory) {
273         return _name;
274     }
275 
276     /**
277      * @dev Returns the symbol of the token, usually a shorter version of the
278      * name.
279      */
280     function symbol() public view virtual override returns (string memory) {
281         return _symbol;
282     }
283 
284     /**
285      * @dev Returns the number of decimals used to get its user representation.
286      * For example, if `decimals` equals `2`, a balance of `505` tokens should
287      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
288      *
289      * Tokens usually opt for a value of 18, imitating the relationship between
290      * Ether and Wei. This is the value {ERC20} uses, unless this function is
291      * overridden;
292      *
293      * NOTE: This information is only used for _display_ purposes: it in
294      * no way affects any of the arithmetic of the contract, including
295      * {IERC20-balanceOf} and {IERC20-transfer}.
296      */
297     function decimals() public view virtual override returns (uint8) {
298         return 18;
299     }
300 
301     /**
302      * @dev See {IERC20-totalSupply}.
303      */
304     function totalSupply() public view virtual override returns (uint256) {
305         return _totalSupply;
306     }
307 
308     /**
309      * @dev See {IERC20-balanceOf}.
310      */
311     function balanceOf(address account) public view virtual override returns (uint256) {
312         return _balances[account];
313     }
314 
315     /**
316      * @dev See {IERC20-transfer}.
317      *
318      * Requirements:
319      *
320      * - `recipient` cannot be the zero address.
321      * - the caller must have a balance of at least `amount`.
322      */
323     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
324         _transfer(_msgSender(), recipient, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-allowance}.
330      */
331     function allowance(address owner, address spender) public view virtual override returns (uint256) {
332         return _allowances[owner][spender];
333     }
334 
335     /**
336      * @dev See {IERC20-approve}.
337      *
338      * Requirements:
339      *
340      * - `spender` cannot be the zero address.
341      */
342     function approve(address spender, uint256 amount) public virtual override returns (bool) {
343         _approve(_msgSender(), spender, amount);
344         return true;
345     }
346 
347     /**
348      * @dev See {IERC20-transferFrom}.
349      *
350      * Emits an {Approval} event indicating the updated allowance. This is not
351      * required by the EIP. See the note at the beginning of {ERC20}.
352      *
353      * Requirements:
354      *
355      * - `sender` and `recipient` cannot be the zero address.
356      * - `sender` must have a balance of at least `amount`.
357      * - the caller must have allowance for ``sender``'s tokens of at least
358      * `amount`.
359      */
360     function transferFrom(
361         address sender,
362         address recipient,
363         uint256 amount
364     ) public virtual override returns (bool) {
365         _transfer(sender, recipient, amount);
366 
367         uint256 currentAllowance = _allowances[sender][_msgSender()];
368         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
369         unchecked {
370             _approve(sender, _msgSender(), currentAllowance - amount);
371         }
372 
373         return true;
374     }
375 
376     /**
377      * @dev Atomically increases the allowance granted to `spender` by the caller.
378      *
379      * This is an alternative to {approve} that can be used as a mitigation for
380      * problems described in {IERC20-approve}.
381      *
382      * Emits an {Approval} event indicating the updated allowance.
383      *
384      * Requirements:
385      *
386      * - `spender` cannot be the zero address.
387      */
388     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
389         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
390         return true;
391     }
392 
393     /**
394      * @dev Atomically decreases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      * - `spender` must have allowance for the caller of at least
405      * `subtractedValue`.
406      */
407     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
408         uint256 currentAllowance = _allowances[_msgSender()][spender];
409         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
410         unchecked {
411             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
412         }
413 
414         return true;
415     }
416 
417     /**
418      * @dev Moves `amount` of tokens from `sender` to `recipient`.
419      *
420      * This internal function is equivalent to {transfer}, and can be used to
421      * e.g. implement automatic token fees, slashing mechanisms, etc.
422      *
423      * Emits a {Transfer} event.
424      *
425      * Requirements:
426      *
427      * - `sender` cannot be the zero address.
428      * - `recipient` cannot be the zero address.
429      * - `sender` must have a balance of at least `amount`.
430      */
431     function _transfer(
432         address sender,
433         address recipient,
434         uint256 amount
435     ) internal virtual {
436         require(sender != address(0), "ERC20: transfer from the zero address");
437         require(recipient != address(0), "ERC20: transfer to the zero address");
438 
439         _beforeTokenTransfer(sender, recipient, amount);
440 
441         uint256 senderBalance = _balances[sender];
442         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
443         unchecked {
444             _balances[sender] = senderBalance - amount;
445         }
446         _balances[recipient] += amount;
447 
448         emit Transfer(sender, recipient, amount);
449 
450         _afterTokenTransfer(sender, recipient, amount);
451     }
452 
453     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
454      * the total supply.
455      *
456      * Emits a {Transfer} event with `from` set to the zero address.
457      *
458      * Requirements:
459      *
460      * - `account` cannot be the zero address.
461      */
462     function _mint(address account, uint256 amount) internal virtual {
463         require(account != address(0), "ERC20: mint to the zero address");
464 
465         _beforeTokenTransfer(address(0), account, amount);
466 
467         _totalSupply += amount;
468         _balances[account] += amount;
469         emit Transfer(address(0), account, amount);
470 
471         _afterTokenTransfer(address(0), account, amount);
472     }
473 
474     /**
475      * @dev Destroys `amount` tokens from `account`, reducing the
476      * total supply.
477      *
478      * Emits a {Transfer} event with `to` set to the zero address.
479      *
480      * Requirements:
481      *
482      * - `account` cannot be the zero address.
483      * - `account` must have at least `amount` tokens.
484      */
485     function _burn(address account, uint256 amount) internal virtual {
486         require(account != address(0), "ERC20: burn from the zero address");
487 
488         _beforeTokenTransfer(account, address(0), amount);
489 
490         uint256 accountBalance = _balances[account];
491         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
492         unchecked {
493             _balances[account] = accountBalance - amount;
494         }
495         _totalSupply -= amount;
496 
497         emit Transfer(account, address(0), amount);
498 
499         _afterTokenTransfer(account, address(0), amount);
500     }
501 
502     /**
503      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
504      *
505      * This internal function is equivalent to `approve`, and can be used to
506      * e.g. set automatic allowances for certain subsystems, etc.
507      *
508      * Emits an {Approval} event.
509      *
510      * Requirements:
511      *
512      * - `owner` cannot be the zero address.
513      * - `spender` cannot be the zero address.
514      */
515     function _approve(
516         address owner,
517         address spender,
518         uint256 amount
519     ) internal virtual {
520         require(owner != address(0), "ERC20: approve from the zero address");
521         require(spender != address(0), "ERC20: approve to the zero address");
522 
523         _allowances[owner][spender] = amount;
524         emit Approval(owner, spender, amount);
525     }
526 
527     /**
528      * @dev Hook that is called before any transfer of tokens. This includes
529      * minting and burning.
530      *
531      * Calling conditions:
532      *
533      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
534      * will be transferred to `to`.
535      * - when `from` is zero, `amount` tokens will be minted for `to`.
536      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
537      * - `from` and `to` are never both zero.
538      *
539      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
540      */
541     function _beforeTokenTransfer(
542         address from,
543         address to,
544         uint256 amount
545     ) internal virtual {}
546 
547     /**
548      * @dev Hook that is called after any transfer of tokens. This includes
549      * minting and burning.
550      *
551      * Calling conditions:
552      *
553      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
554      * has been transferred to `to`.
555      * - when `from` is zero, `amount` tokens have been minted for `to`.
556      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
557      * - `from` and `to` are never both zero.
558      *
559      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
560      */
561     function _afterTokenTransfer(
562         address from,
563         address to,
564         uint256 amount
565     ) internal virtual {}
566 }
567 
568 /**
569  * @dev Wrappers over Solidity's arithmetic operations.
570  *
571  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
572  * now has built in overflow checking.
573  */
574 library SafeMath {
575     /**
576      * @dev Returns the addition of two unsigned integers, with an overflow flag.
577      *
578      * _Available since v3.4._
579      */
580     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
581         unchecked {
582             uint256 c = a + b;
583             if (c < a) return (false, 0);
584             return (true, c);
585         }
586     }
587 
588     /**
589      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
590      *
591      * _Available since v3.4._
592      */
593     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
594         unchecked {
595             if (b > a) return (false, 0);
596             return (true, a - b);
597         }
598     }
599 
600     /**
601      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
602      *
603      * _Available since v3.4._
604      */
605     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
606         unchecked {
607             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
608             // benefit is lost if 'b' is also tested.
609             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
610             if (a == 0) return (true, 0);
611             uint256 c = a * b;
612             if (c / a != b) return (false, 0);
613             return (true, c);
614         }
615     }
616 
617     /**
618      * @dev Returns the division of two unsigned integers, with a division by zero flag.
619      *
620      * _Available since v3.4._
621      */
622     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
623         unchecked {
624             if (b == 0) return (false, 0);
625             return (true, a / b);
626         }
627     }
628 
629     /**
630      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
631      *
632      * _Available since v3.4._
633      */
634     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
635         unchecked {
636             if (b == 0) return (false, 0);
637             return (true, a % b);
638         }
639     }
640 
641     /**
642      * @dev Returns the addition of two unsigned integers, reverting on
643      * overflow.
644      *
645      * Counterpart to Solidity's `+` operator.
646      *
647      * Requirements:
648      *
649      * - Addition cannot overflow.
650      */
651     function add(uint256 a, uint256 b) internal pure returns (uint256) {
652         return a + b;
653     }
654 
655     /**
656      * @dev Returns the subtraction of two unsigned integers, reverting on
657      * overflow (when the result is negative).
658      *
659      * Counterpart to Solidity's `-` operator.
660      *
661      * Requirements:
662      *
663      * - Subtraction cannot overflow.
664      */
665     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
666         return a - b;
667     }
668 
669     /**
670      * @dev Returns the multiplication of two unsigned integers, reverting on
671      * overflow.
672      *
673      * Counterpart to Solidity's `*` operator.
674      *
675      * Requirements:
676      *
677      * - Multiplication cannot overflow.
678      */
679     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
680         return a * b;
681     }
682 
683     /**
684      * @dev Returns the integer division of two unsigned integers, reverting on
685      * division by zero. The result is rounded towards zero.
686      *
687      * Counterpart to Solidity's `/` operator.
688      *
689      * Requirements:
690      *
691      * - The divisor cannot be zero.
692      */
693     function div(uint256 a, uint256 b) internal pure returns (uint256) {
694         return a / b;
695     }
696 
697     /**
698      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
699      * reverting when dividing by zero.
700      *
701      * Counterpart to Solidity's `%` operator. This function uses a `revert`
702      * opcode (which leaves remaining gas untouched) while Solidity uses an
703      * invalid opcode to revert (consuming all remaining gas).
704      *
705      * Requirements:
706      *
707      * - The divisor cannot be zero.
708      */
709     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
710         return a % b;
711     }
712 
713     /**
714      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
715      * overflow (when the result is negative).
716      *
717      * CAUTION: This function is deprecated because it requires allocating memory for the error
718      * message unnecessarily. For custom revert reasons use {trySub}.
719      *
720      * Counterpart to Solidity's `-` operator.
721      *
722      * Requirements:
723      *
724      * - Subtraction cannot overflow.
725      */
726     function sub(
727         uint256 a,
728         uint256 b,
729         string memory errorMessage
730     ) internal pure returns (uint256) {
731         unchecked {
732             require(b <= a, errorMessage);
733             return a - b;
734         }
735     }
736 
737     /**
738      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
739      * division by zero. The result is rounded towards zero.
740      *
741      * Counterpart to Solidity's `/` operator. Note: this function uses a
742      * `revert` opcode (which leaves remaining gas untouched) while Solidity
743      * uses an invalid opcode to revert (consuming all remaining gas).
744      *
745      * Requirements:
746      *
747      * - The divisor cannot be zero.
748      */
749     function div(
750         uint256 a,
751         uint256 b,
752         string memory errorMessage
753     ) internal pure returns (uint256) {
754         unchecked {
755             require(b > 0, errorMessage);
756             return a / b;
757         }
758     }
759 
760     /**
761      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
762      * reverting with custom message when dividing by zero.
763      *
764      * CAUTION: This function is deprecated because it requires allocating memory for the error
765      * message unnecessarily. For custom revert reasons use {tryMod}.
766      *
767      * Counterpart to Solidity's `%` operator. This function uses a `revert`
768      * opcode (which leaves remaining gas untouched) while Solidity uses an
769      * invalid opcode to revert (consuming all remaining gas).
770      *
771      * Requirements:
772      *
773      * - The divisor cannot be zero.
774      */
775     function mod(
776         uint256 a,
777         uint256 b,
778         string memory errorMessage
779     ) internal pure returns (uint256) {
780         unchecked {
781             require(b > 0, errorMessage);
782             return a % b;
783         }
784     }
785 }
786 
787 interface IUniswapV2Factory {
788     event PairCreated(
789         address indexed token0,
790         address indexed token1,
791         address pair,
792         uint256
793     );
794 
795     function feeTo() external view returns (address);
796 
797     function feeToSetter() external view returns (address);
798 
799     function getPair(address tokenA, address tokenB)
800         external
801         view
802         returns (address pair);
803 
804     function allPairs(uint256) external view returns (address pair);
805 
806     function allPairsLength() external view returns (uint256);
807 
808     function createPair(address tokenA, address tokenB)
809         external
810         returns (address pair);
811 
812     function setFeeTo(address) external;
813 
814     function setFeeToSetter(address) external;
815 }
816 
817 ////// src/IUniswapV2Pair.sol
818 /* pragma solidity 0.8.10; */
819 /* pragma experimental ABIEncoderV2; */
820 
821 interface IUniswapV2Pair {
822     event Approval(
823         address indexed owner,
824         address indexed spender,
825         uint256 value
826     );
827     event Transfer(address indexed from, address indexed to, uint256 value);
828 
829     function name() external pure returns (string memory);
830 
831     function symbol() external pure returns (string memory);
832 
833     function decimals() external pure returns (uint8);
834 
835     function totalSupply() external view returns (uint256);
836 
837     function balanceOf(address owner) external view returns (uint256);
838 
839     function allowance(address owner, address spender)
840         external
841         view
842         returns (uint256);
843 
844     function approve(address spender, uint256 value) external returns (bool);
845 
846     function transfer(address to, uint256 value) external returns (bool);
847 
848     function transferFrom(
849         address from,
850         address to,
851         uint256 value
852     ) external returns (bool);
853 
854     function DOMAIN_SEPARATOR() external view returns (bytes32);
855 
856     function PERMIT_TYPEHASH() external pure returns (bytes32);
857 
858     function nonces(address owner) external view returns (uint256);
859 
860     function permit(
861         address owner,
862         address spender,
863         uint256 value,
864         uint256 deadline,
865         uint8 v,
866         bytes32 r,
867         bytes32 s
868     ) external;
869 
870     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
871     event Burn(
872         address indexed sender,
873         uint256 amount0,
874         uint256 amount1,
875         address indexed to
876     );
877     event Swap(
878         address indexed sender,
879         uint256 amount0In,
880         uint256 amount1In,
881         uint256 amount0Out,
882         uint256 amount1Out,
883         address indexed to
884     );
885     event Sync(uint112 reserve0, uint112 reserve1);
886 
887     function MINIMUM_LIQUIDITY() external pure returns (uint256);
888 
889     function factory() external view returns (address);
890 
891     function token0() external view returns (address);
892 
893     function token1() external view returns (address);
894 
895     function getReserves()
896         external
897         view
898         returns (
899             uint112 reserve0,
900             uint112 reserve1,
901             uint32 blockTimestampLast
902         );
903 
904     function price0CumulativeLast() external view returns (uint256);
905 
906     function price1CumulativeLast() external view returns (uint256);
907 
908     function kLast() external view returns (uint256);
909 
910     function mint(address to) external returns (uint256 liquidity);
911 
912     function burn(address to)
913         external
914         returns (uint256 amount0, uint256 amount1);
915 
916     function swap(
917         uint256 amount0Out,
918         uint256 amount1Out,
919         address to,
920         bytes calldata data
921     ) external;
922 
923     function skim(address to) external;
924 
925     function sync() external;
926 
927     function initialize(address, address) external;
928 }
929 
930 interface IUniswapV2Router02 {
931     function factory() external pure returns (address);
932 
933     function WETH() external pure returns (address);
934 
935     function addLiquidity(
936         address tokenA,
937         address tokenB,
938         uint256 amountADesired,
939         uint256 amountBDesired,
940         uint256 amountAMin,
941         uint256 amountBMin,
942         address to,
943         uint256 deadline
944     )
945         external
946         returns (
947             uint256 amountA,
948             uint256 amountB,
949             uint256 liquidity
950         );
951 
952     function addLiquidityETH(
953         address token,
954         uint256 amountTokenDesired,
955         uint256 amountTokenMin,
956         uint256 amountETHMin,
957         address to,
958         uint256 deadline
959     )
960         external
961         payable
962         returns (
963             uint256 amountToken,
964             uint256 amountETH,
965             uint256 liquidity
966         );
967 
968     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
969         uint256 amountIn,
970         uint256 amountOutMin,
971         address[] calldata path,
972         address to,
973         uint256 deadline
974     ) external;
975 
976     function swapExactETHForTokensSupportingFeeOnTransferTokens(
977         uint256 amountOutMin,
978         address[] calldata path,
979         address to,
980         uint256 deadline
981     ) external payable;
982 
983     function swapExactTokensForETHSupportingFeeOnTransferTokens(
984         uint256 amountIn,
985         uint256 amountOutMin,
986         address[] calldata path,
987         address to,
988         uint256 deadline
989     ) external;
990 }
991 
992 contract TETHER is ERC20, Ownable {
993     using SafeMath for uint256;
994 
995     IUniswapV2Router02 public immutable uniswapV2Router;
996     address public immutable uniswapV2Pair;
997     address public constant deadAddress = address(0xdead);
998 
999     bool private swapping;
1000 
1001     address public marketingWallet;
1002     address public devWallet;
1003 
1004     uint256 public maxTransactionAmount;
1005     uint256 public swapTokensAtAmount;
1006     uint256 public maxWallet;
1007 
1008     bool public limitsInEffect = true;
1009     bool public tradingActive = false;
1010     bool public swapEnabled = false;
1011 
1012     // Anti-bot and anti-whale mappings and variables
1013     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1014     mapping(address => bool) blacklisted;
1015     bool public transferDelayEnabled = true;
1016 
1017     uint256 public buyTotalFees;
1018     uint256 public buyMarketingFee;
1019     uint256 public buyLiquidityFee;
1020     uint256 public buyDevFee;
1021 
1022     uint256 public sellTotalFees;
1023     uint256 public sellMarketingFee;
1024     uint256 public sellLiquidityFee;
1025     uint256 public sellDevFee;
1026 
1027     uint256 public tokensForMarketing;
1028     uint256 public tokensForLiquidity;
1029     uint256 public tokensForDev;
1030 
1031     /******************/
1032 
1033     // exclude from fees and max transaction amount
1034     mapping(address => bool) private _isExcludedFromFees;
1035     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1036 
1037     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1038     // could be subject to a maximum transfer amount
1039     mapping(address => bool) public automatedMarketMakerPairs;
1040 
1041     event UpdateUniswapV2Router(
1042         address indexed newAddress,
1043         address indexed oldAddress
1044     );
1045 
1046     event ExcludeFromFees(address indexed account, bool isExcluded);
1047 
1048     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1049 
1050     event marketingWalletUpdated(
1051         address indexed newWallet,
1052         address indexed oldWallet
1053     );
1054 
1055     event devWalletUpdated(
1056         address indexed newWallet,
1057         address indexed oldWallet
1058     );
1059 
1060     event SwapAndLiquify(
1061         uint256 tokensSwapped,
1062         uint256 ethReceived,
1063         uint256 tokensIntoLiquidity
1064     );
1065 
1066     event AutoNukeLP();
1067 
1068     event ManualNukeLP();
1069 
1070     constructor() ERC20("TETHER", "PrinceHarryPotterStableHawkingMoisturiseHobbesXInu") {
1071         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1072             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1073         );
1074 
1075         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1076         uniswapV2Router = _uniswapV2Router;
1077 
1078         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1079             .createPair(address(this), _uniswapV2Router.WETH());
1080         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1081         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1082 
1083         uint256 _buyMarketingFee = 2;
1084         uint256 _buyLiquidityFee = 0;
1085         uint256 _buyDevFee = 0;
1086 
1087         uint256 _sellMarketingFee = 2;
1088         uint256 _sellLiquidityFee = 0;
1089         uint256 _sellDevFee = 0;
1090 
1091         uint256 totalSupply = 1_000_000_000 * 1e18;
1092 
1093         maxTransactionAmount = 100_000 * 1e18; // 0.01% from total supply maxTransactionAmountTxn
1094         maxWallet = 200_000 * 1e18; // 0.02% from total supply maxWallet
1095         swapTokensAtAmount = 500_000 * 1e18; // 0.05% swap wallet
1096 
1097         buyMarketingFee = _buyMarketingFee;
1098         buyLiquidityFee = _buyLiquidityFee;
1099         buyDevFee = _buyDevFee;
1100         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1101 
1102         sellMarketingFee = _sellMarketingFee;
1103         sellLiquidityFee = _sellLiquidityFee;
1104         sellDevFee = _sellDevFee;
1105         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1106 
1107         marketingWallet = address(0x602C0451C343Be6d42Da1F05f6685327CF4C4c2D); // set as marketing wallet
1108         devWallet = address(0x602C0451C343Be6d42Da1F05f6685327CF4C4c2D); // set as dev wallet
1109 
1110         // exclude from paying fees or having max transaction amount
1111         excludeFromFees(owner(), true);
1112         excludeFromFees(address(this), true);
1113         excludeFromFees(address(0xdead), true);
1114 
1115         excludeFromMaxTransaction(owner(), true);
1116         excludeFromMaxTransaction(address(this), true);
1117         excludeFromMaxTransaction(address(0xdead), true);
1118 
1119         /*
1120             _mint is an internal function in ERC20.sol that is only called here,
1121             and CANNOT be called ever again
1122         */
1123         _mint(msg.sender, totalSupply);
1124     }
1125 
1126     receive() external payable {}
1127 
1128     // once enabled, can never be turned off
1129     function enableTrading() external onlyOwner {
1130         tradingActive = true;
1131         swapEnabled = true;
1132     }
1133 
1134     // remove limits after token is stable
1135     function removeLimits() external onlyOwner returns (bool) {
1136         limitsInEffect = false;
1137         return true;
1138     }
1139 
1140     function enableLimits() external onlyOwner returns (bool) {
1141         limitsInEffect = true;
1142         return true;
1143     }
1144 
1145     // disable Transfer delay - cannot be reenabled
1146     function disableTransferDelay() external onlyOwner returns (bool) {
1147         transferDelayEnabled = false;
1148         return true;
1149     }
1150 
1151     // change the minimum amount of tokens to sell from fees
1152     function updateSwapTokensAtAmount(uint256 newAmount)
1153         external
1154         onlyOwner
1155         returns (bool)
1156     {
1157         swapTokensAtAmount = newAmount;
1158         return true;
1159     }
1160 
1161     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1162         maxTransactionAmount = newNum * (10**18);
1163     }
1164 
1165     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1166         maxWallet = newNum * (10**18);
1167     }
1168 
1169     function excludeFromMaxTransaction(address updAds, bool isEx)
1170         public
1171         onlyOwner
1172     {
1173         _isExcludedMaxTransactionAmount[updAds] = isEx;
1174     }
1175 
1176     // only use to disable contract sales if absolutely necessary (emergency use only)
1177     function updateSwapEnabled(bool enabled) external onlyOwner {
1178         swapEnabled = enabled;
1179     }
1180 
1181     function updateBuyFees(
1182         uint256 _marketingFee,
1183         uint256 _liquidityFee,
1184         uint256 _devFee
1185     ) external onlyOwner {
1186         buyMarketingFee = _marketingFee;
1187         buyLiquidityFee = _liquidityFee;
1188         buyDevFee = _devFee;
1189         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1190     }
1191 
1192     function updateSellFees(
1193         uint256 _marketingFee,
1194         uint256 _liquidityFee,
1195         uint256 _devFee
1196     ) external onlyOwner {
1197         sellMarketingFee = _marketingFee;
1198         sellLiquidityFee = _liquidityFee;
1199         sellDevFee = _devFee;
1200         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1201     }
1202 
1203     function excludeFromFees(address account, bool excluded) public onlyOwner {
1204         _isExcludedFromFees[account] = excluded;
1205         emit ExcludeFromFees(account, excluded);
1206     }
1207 
1208     function setAutomatedMarketMakerPair(address pair, bool value)
1209         public
1210         onlyOwner
1211     {
1212         require(
1213             pair != uniswapV2Pair,
1214             "The pair cannot be removed from automatedMarketMakerPairs"
1215         );
1216 
1217         _setAutomatedMarketMakerPair(pair, value);
1218     }
1219 
1220     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1221         automatedMarketMakerPairs[pair] = value;
1222 
1223         emit SetAutomatedMarketMakerPair(pair, value);
1224     }
1225 
1226     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1227         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1228         marketingWallet = newMarketingWallet;
1229     }
1230 
1231     function updateDevWallet(address newWallet) external onlyOwner {
1232         emit devWalletUpdated(newWallet, devWallet);
1233         devWallet = newWallet;
1234     }
1235 
1236     function isExcludedFromFees(address account) public view returns (bool) {
1237         return _isExcludedFromFees[account];
1238     }
1239 
1240     function isBlacklisted(address account) public view returns (bool) {
1241         return blacklisted[account];
1242     }
1243 
1244     function _transfer(
1245         address from,
1246         address to,
1247         uint256 amount
1248     ) internal override {
1249         require(from != address(0), "ERC20: transfer from the zero address");
1250         require(to != address(0), "ERC20: transfer to the zero address");
1251         require(!blacklisted[from],"Sender blacklisted");
1252         require(!blacklisted[to],"Receiver blacklisted");
1253 
1254         if (amount == 0) {
1255             super._transfer(from, to, 0);
1256             return;
1257         }
1258 
1259         if (limitsInEffect) {
1260             if (
1261                 from != owner() &&
1262                 to != owner() &&
1263                 to != address(0) &&
1264                 to != address(0xdead) &&
1265                 !swapping
1266             ) {
1267                 if (!tradingActive) {
1268                     require(
1269                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1270                         "Trading is not active."
1271                     );
1272                 }
1273 
1274                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1275                 if (transferDelayEnabled) {
1276                     if (
1277                         to != owner() &&
1278                         to != address(uniswapV2Router) &&
1279                         to != address(uniswapV2Pair)
1280                     ) {
1281                         require(
1282                             _holderLastTransferTimestamp[tx.origin] + 1 <
1283                                 block.number,
1284                             "_transfer:: Transfer Delay enabled.  Only one purchase per two blocks allowed."
1285                         );
1286                         _holderLastTransferTimestamp[tx.origin] = block.number;
1287                     }
1288                 }
1289 
1290                 //when buy
1291                 if (
1292                     automatedMarketMakerPairs[from] &&
1293                     !_isExcludedMaxTransactionAmount[to]
1294                 ) {
1295                     require(
1296                         amount <= maxTransactionAmount,
1297                         "Buy transfer amount exceeds the maxTransactionAmount."
1298                     );
1299                     require(
1300                         amount + balanceOf(to) <= maxWallet,
1301                         "Max wallet exceeded"
1302                     );
1303                 }
1304                 //when sell
1305                 else if (
1306                     automatedMarketMakerPairs[to] &&
1307                     !_isExcludedMaxTransactionAmount[from]
1308                 ) {
1309                     require(
1310                         amount <= maxTransactionAmount,
1311                         "Sell transfer amount exceeds the maxTransactionAmount."
1312                     );
1313                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1314                     require(
1315                         amount + balanceOf(to) <= maxWallet,
1316                         "Max wallet exceeded"
1317                     );
1318                 }
1319             }
1320         }
1321 
1322         uint256 contractTokenBalance = balanceOf(address(this));
1323 
1324         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1325 
1326         if (
1327             canSwap &&
1328             swapEnabled &&
1329             !swapping &&
1330             !automatedMarketMakerPairs[from] &&
1331             !_isExcludedFromFees[from] &&
1332             !_isExcludedFromFees[to]
1333         ) {
1334             swapping = true;
1335 
1336             swapBack();
1337 
1338             swapping = false;
1339         }
1340 
1341         bool takeFee = !swapping;
1342 
1343         // if any account belongs to _isExcludedFromFee account then remove the fee
1344         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1345             takeFee = false;
1346         }
1347 
1348         uint256 fees = 0;
1349         // only take fees on buys/sells, do not take on wallet transfers
1350         if (takeFee) {
1351             // on sell
1352             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1353                 fees = amount.mul(sellTotalFees).div(100);
1354                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1355                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1356                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1357             }
1358             // on buy
1359             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1360                 fees = amount.mul(buyTotalFees).div(100);
1361                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1362                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1363                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1364             }
1365 
1366             if (fees > 0) {
1367                 super._transfer(from, address(this), fees);
1368             }
1369 
1370             amount -= fees;
1371         }
1372 
1373         super._transfer(from, to, amount);
1374     }
1375 
1376     function swapTokensForEth(uint256 tokenAmount) private {
1377         // generate the uniswap pair path of token -> weth
1378         address[] memory path = new address[](2);
1379         path[0] = address(this);
1380         path[1] = uniswapV2Router.WETH();
1381 
1382         _approve(address(this), address(uniswapV2Router), tokenAmount);
1383 
1384         // make the swap
1385         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1386             tokenAmount,
1387             0, // accept any amount of ETH
1388             path,
1389             address(this),
1390             block.timestamp
1391         );
1392     }
1393 
1394     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1395         // approve token transfer to cover all possible scenarios
1396         _approve(address(this), address(uniswapV2Router), tokenAmount);
1397 
1398         // add the liquidity
1399         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1400             address(this),
1401             tokenAmount,
1402             0, // slippage is unavoidable
1403             0, // slippage is unavoidable
1404             owner(),
1405             block.timestamp
1406         );
1407     }
1408 
1409     function swapBack() private {
1410         uint256 contractBalance = balanceOf(address(this));
1411         uint256 totalTokensToSwap = tokensForLiquidity +
1412             tokensForMarketing +
1413             tokensForDev;
1414         bool success;
1415 
1416         if (contractBalance == 0 || totalTokensToSwap == 0) {
1417             return;
1418         }
1419 
1420         if (contractBalance > swapTokensAtAmount * 20) {
1421             contractBalance = swapTokensAtAmount * 20;
1422         }
1423 
1424         // Halve the amount of liquidity tokens
1425         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1426             totalTokensToSwap /
1427             2;
1428         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1429 
1430         uint256 initialETHBalance = address(this).balance;
1431 
1432         swapTokensForEth(amountToSwapForETH);
1433 
1434         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1435 
1436         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap - (tokensForLiquidity / 2));
1437         
1438         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap - (tokensForLiquidity / 2));
1439 
1440         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1441 
1442         tokensForLiquidity = 0;
1443         tokensForMarketing = 0;
1444         tokensForDev = 0;
1445 
1446         (success, ) = address(devWallet).call{value: ethForDev}("");
1447 
1448         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1449             addLiquidity(liquidityTokens, ethForLiquidity);
1450             emit SwapAndLiquify(
1451                 amountToSwapForETH,
1452                 ethForLiquidity,
1453                 tokensForLiquidity
1454             );
1455         }
1456 
1457         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1458     }
1459 
1460     function withdraw() external onlyOwner {
1461         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1462         IERC20(address(this)).transfer(msg.sender, balance);
1463         payable(msg.sender).transfer(address(this).balance);
1464     }
1465 
1466     function withdrawToken(address _token, address _to) external onlyOwner {
1467         require(_token != address(0), "_token address cannot be 0");
1468         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1469         IERC20(_token).transfer(_to, _contractBalance);
1470     }
1471 
1472     function blacklist(address _black) public onlyOwner {
1473         blacklisted[_black] = true;
1474     }
1475 
1476     function unblacklist(address _black) public onlyOwner {
1477         blacklisted[_black] = false;
1478     }
1479 }