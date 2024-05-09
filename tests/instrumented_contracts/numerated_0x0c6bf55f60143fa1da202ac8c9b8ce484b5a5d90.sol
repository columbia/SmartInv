1 /**
2 
3 Telegram: https://t.me/odaportal
4 
5 Website: http://Odaethereum.com
6 
7 Medium: https://medium.com/@odaethereum/oda-token-2bd23e9f66a1
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
13 pragma experimental ABIEncoderV2;
14 
15 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
16 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
17 
18 /* pragma solidity ^0.8.0; */
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
41 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
42 
43 /* pragma solidity ^0.8.0; */
44 
45 /* import "../utils/Context.sol"; */
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor() {
68         _transferOwnership(_msgSender());
69     }
70 
71     /**
72      * @dev Returns the address of the current owner.
73      */
74     function owner() public view virtual returns (address) {
75         return _owner;
76     }
77 
78     /**
79      * @dev Throws if called by any account other than the owner.
80      */
81     modifier onlyOwner() {
82         require(owner() == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     /**
87      * @dev Leaves the contract without owner. It will not be possible to call
88      * `onlyOwner` functions anymore. Can only be called by the current owner.
89      *
90      * NOTE: Renouncing ownership will leave the contract without an owner,
91      * thereby removing any functionality that is only available to the owner.
92      */
93     function renounceOwnership() public virtual onlyOwner {
94         _transferOwnership(address(0));
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public virtual onlyOwner {
102         require(newOwner != address(0), "Ownable: new owner is the zero address");
103         _transferOwnership(newOwner);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Internal function without access restriction.
109      */
110     function _transferOwnership(address newOwner) internal virtual {
111         address oldOwner = _owner;
112         _owner = newOwner;
113         emit OwnershipTransferred(oldOwner, newOwner);
114     }
115 }
116 
117 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
118 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
119 
120 /* pragma solidity ^0.8.0; */
121 
122 /**
123  * @dev Interface of the ERC20 standard as defined in the EIP.
124  */
125 interface IERC20 {
126     /**
127      * @dev Returns the amount of tokens in existence.
128      */
129     function totalSupply() external view returns (uint256);
130 
131     /**
132      * @dev Returns the amount of tokens owned by `account`.
133      */
134     function balanceOf(address account) external view returns (uint256);
135 
136     /**
137      * @dev Moves `amount` tokens from the caller's account to `recipient`.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transfer(address recipient, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Returns the remaining number of tokens that `spender` will be
147      * allowed to spend on behalf of `owner` through {transferFrom}. This is
148      * zero by default.
149      *
150      * This value changes when {approve} or {transferFrom} are called.
151      */
152     function allowance(address owner, address spender) external view returns (uint256);
153 
154 
155     function approve(address spender, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Moves `amount` tokens from `sender` to `recipient` using the
159      * allowance mechanism. `amount` is then deducted from the caller's
160      * allowance.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transferFrom(
167         address sender,
168         address recipient,
169         uint256 amount
170     ) external returns (bool);
171 
172     /**
173      * @dev Emitted when `value` tokens are moved from one account (`from`) to
174      * another (`to`).
175      *
176      * Note that `value` may be zero.
177      */
178     event Transfer(address indexed from, address indexed to, uint256 value);
179 
180     /**
181      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
182      * a call to {approve}. `value` is the new allowance.
183      */
184     event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 
187 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
188 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
189 
190 /* pragma solidity ^0.8.0; */
191 
192 /* import "../IERC20.sol"; */
193 
194 /**
195  * @dev Interface for the optional metadata functions from the ERC20 standard.
196  *
197  * _Available since v4.1._
198  */
199 interface IERC20Metadata is IERC20 {
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() external view returns (string memory);
204 
205     /**
206      * @dev Returns the symbol of the token.
207      */
208     function symbol() external view returns (string memory);
209 
210     /**
211      * @dev Returns the decimals places of the token.
212      */
213     function decimals() external view returns (uint8);
214 }
215 
216 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
217 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
218 
219 /* pragma solidity ^0.8.0; */
220 
221 /* import "./IERC20.sol"; */
222 /* import "./extensions/IERC20Metadata.sol"; */
223 /* import "../../utils/Context.sol"; */
224 
225 /**
226  * @dev Implementation of the {IERC20} interface.
227  *
228  * This implementation is agnostic to the way tokens are created. This means
229  * that a supply mechanism has to be added in a derived contract using {_mint}.
230  * For a generic mechanism see {ERC20PresetMinterPauser}.
231  *
232  * TIP: For a detailed writeup see our guide
233  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
234  * to implement supply mechanisms].
235  *
236  * We have followed general OpenZeppelin Contracts guidelines: functions revert
237  * instead returning `false` on failure. This behavior is nonetheless
238  * conventional and does not conflict with the expectations of ERC20
239  * applications.
240  *
241  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
242  * This allows applications to reconstruct the allowance for all accounts just
243  * by listening to said events. Other implementations of the EIP may not emit
244  * these events, as it isn't required by the specification.
245  *
246  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
247  * functions have been added to mitigate the well-known issues around setting
248  * allowances. See {IERC20-approve}.
249  */
250 contract ERC20 is Context, IERC20, IERC20Metadata {
251     mapping(address => uint256) private _balances;
252 
253     mapping(address => mapping(address => uint256)) private _allowances;
254 
255     uint256 private _totalSupply;
256 
257     string private _name;
258     string private _symbol;
259 
260     /**
261      * @dev Sets the values for {name} and {symbol}.
262      *
263      * The default value of {decimals} is 18. To select a different value for
264      * {decimals} you should overload it.
265      *
266      * All two of these values are immutable: they can only be set once during
267      * construction.
268      */
269     constructor(string memory name_, string memory symbol_) {
270         _name = name_;
271         _symbol = symbol_;
272     }
273 
274     /**
275      * @dev Returns the name of the token.
276      */
277     function name() public view virtual override returns (string memory) {
278         return _name;
279     }
280 
281     /**
282      * @dev Returns the symbol of the token, usually a shorter version of the
283      * name.
284      */
285     function symbol() public view virtual override returns (string memory) {
286         return _symbol;
287     }
288 
289     /**
290      * @dev Returns the number of decimals used to get its user representation.
291      * For example, if `decimals` equals `2`, a balance of `505` tokens should
292      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
293      *
294      * Tokens usually opt for a value of 18, imitating the relationship between
295      * Ether and Wei. This is the value {ERC20} uses, unless this function is
296      * overridden;
297      *
298      * NOTE: This information is only used for _display_ purposes: it in
299      * no way affects any of the arithmetic of the contract, including
300      * {IERC20-balanceOf} and {IERC20-transfer}.
301      */
302     function decimals() public view virtual override returns (uint8) {
303         return 18;
304     }
305 
306     /**
307      * @dev See {IERC20-totalSupply}.
308      */
309     function totalSupply() public view virtual override returns (uint256) {
310         return _totalSupply;
311     }
312 
313     /**
314      * @dev See {IERC20-balanceOf}.
315      */
316     function balanceOf(address account) public view virtual override returns (uint256) {
317         return _balances[account];
318     }
319 
320     /**
321      * @dev See {IERC20-transfer}.
322      *
323      * Requirements:
324      *
325      * - `recipient` cannot be the zero address.
326      * - the caller must have a balance of at least `amount`.
327      */
328     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
329         _transfer(_msgSender(), recipient, amount);
330         return true;
331     }
332 
333     /**
334      * @dev See {IERC20-allowance}.
335      */
336     function allowance(address owner, address spender) public view virtual override returns (uint256) {
337         return _allowances[owner][spender];
338     }
339 
340     /**
341      * @dev See {IERC20-approve}.
342      *
343      * Requirements:
344      *
345      * - `spender` cannot be the zero address.
346      */
347     function approve(address spender, uint256 amount) public virtual override returns (bool) {
348         _approve(_msgSender(), spender, amount);
349         return true;
350     }
351 
352     /**
353      * @dev See {IERC20-transferFrom}.
354      *
355      * Emits an {Approval} event indicating the updated allowance. This is not
356      * required by the EIP. See the note at the beginning of {ERC20}.
357      *
358      * Requirements:
359      *
360      * - `sender` and `recipient` cannot be the zero address.
361      * - `sender` must have a balance of at least `amount`.
362      * - the caller must have allowance for ``sender``'s tokens of at least
363      * `amount`.
364      */
365     function transferFrom(
366         address sender,
367         address recipient,
368         uint256 amount
369     ) public virtual override returns (bool) {
370         _transfer(sender, recipient, amount);
371 
372         uint256 currentAllowance = _allowances[sender][_msgSender()];
373         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
374         unchecked {
375             _approve(sender, _msgSender(), currentAllowance - amount);
376         }
377 
378         return true;
379     }
380 
381     /**
382      * @dev Atomically increases the allowance granted to `spender` by the caller.
383      *
384      * This is an alternative to {approve} that can be used as a mitigation for
385      * problems described in {IERC20-approve}.
386      *
387      * Emits an {Approval} event indicating the updated allowance.
388      *
389      * Requirements:
390      *
391      * - `spender` cannot be the zero address.
392      */
393     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
394         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
395         return true;
396     }
397 
398     /**
399      * @dev Atomically decreases the allowance granted to `spender` by the caller.
400      *
401      * This is an alternative to {approve} that can be used as a mitigation for
402      * problems described in {IERC20-approve}.
403      *
404      * Emits an {Approval} event indicating the updated allowance.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      * - `spender` must have allowance for the caller of at least
410      * `subtractedValue`.
411      */
412     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
413         uint256 currentAllowance = _allowances[_msgSender()][spender];
414         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
415         unchecked {
416             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
417         }
418 
419         return true;
420     }
421 
422     /**
423      * @dev Moves `amount` of tokens from `sender` to `recipient`.
424      *
425      * This internal function is equivalent to {transfer}, and can be used to
426      * e.g. implement automatic token fees, slashing mechanisms, etc.
427      *
428      * Emits a {Transfer} event.
429      *
430      * Requirements:
431      *
432      * - `sender` cannot be the zero address.
433      * - `recipient` cannot be the zero address.
434      * - `sender` must have a balance of at least `amount`.
435      */
436     function _transfer(
437         address sender,
438         address recipient,
439         uint256 amount
440     ) internal virtual {
441         require(sender != address(0), "ERC20: transfer from the zero address");
442         require(recipient != address(0), "ERC20: transfer to the zero address");
443 
444         _beforeTokenTransfer(sender, recipient, amount);
445 
446         uint256 senderBalance = _balances[sender];
447         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
448         unchecked {
449             _balances[sender] = senderBalance - amount;
450         }
451         _balances[recipient] += amount;
452 
453         emit Transfer(sender, recipient, amount);
454 
455         _afterTokenTransfer(sender, recipient, amount);
456     }
457 
458     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
459      * the total supply.
460      *
461      * Emits a {Transfer} event with `from` set to the zero address.
462      *
463      * Requirements:
464      *
465      * - `account` cannot be the zero address.
466      */
467     function _mint(address account, uint256 amount) internal virtual {
468         require(account != address(0), "ERC20: mint to the zero address");
469 
470         _beforeTokenTransfer(address(0), account, amount);
471 
472         _totalSupply += amount;
473         _balances[account] += amount;
474         emit Transfer(address(0), account, amount);
475 
476         _afterTokenTransfer(address(0), account, amount);
477     }
478 
479     /**
480      * @dev Destroys `amount` tokens from `account`, reducing the
481      * total supply.
482      *
483      * Emits a {Transfer} event with `to` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `account` cannot be the zero address.
488      * - `account` must have at least `amount` tokens.
489      */
490     function _burn(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: burn from the zero address");
492 
493         _beforeTokenTransfer(account, address(0), amount);
494 
495         uint256 accountBalance = _balances[account];
496         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
497         unchecked {
498             _balances[account] = accountBalance - amount;
499         }
500         _totalSupply -= amount;
501 
502         emit Transfer(account, address(0), amount);
503 
504         _afterTokenTransfer(account, address(0), amount);
505     }
506 
507     /**
508      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
509      *
510      * This internal function is equivalent to `approve`, and can be used to
511      * e.g. set automatic allowances for certain subsystems, etc.
512      *
513      * Emits an {Approval} event.
514      *
515      * Requirements:
516      *
517      * - `owner` cannot be the zero address.
518      * - `spender` cannot be the zero address.
519      */
520     function _approve(
521         address owner,
522         address spender,
523         uint256 amount
524     ) internal virtual {
525         require(owner != address(0), "ERC20: approve from the zero address");
526         require(spender != address(0), "ERC20: approve to the zero address");
527 
528         _allowances[owner][spender] = amount;
529         emit Approval(owner, spender, amount);
530     }
531 
532     /**
533      * @dev Hook that is called before any transfer of tokens. This includes
534      * minting and burning.
535      *
536      * Calling conditions:
537      *
538      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
539      * will be transferred to `to`.
540      * - when `from` is zero, `amount` tokens will be minted for `to`.
541      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
542      * - `from` and `to` are never both zero.
543      *
544      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
545      */
546     function _beforeTokenTransfer(
547         address from,
548         address to,
549         uint256 amount
550     ) internal virtual {}
551 
552     /**
553      * @dev Hook that is called after any transfer of tokens. This includes
554      * minting and burning.
555      *
556      * Calling conditions:
557      *
558      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
559      * has been transferred to `to`.
560      * - when `from` is zero, `amount` tokens have been minted for `to`.
561      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
562      * - `from` and `to` are never both zero.
563      *
564      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
565      */
566     function _afterTokenTransfer(
567         address from,
568         address to,
569         uint256 amount
570     ) internal virtual {}
571 }
572 
573 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
574 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
575 
576 /* pragma solidity ^0.8.0; */
577 
578 // CAUTION
579 // This version of SafeMath should only be used with Solidity 0.8 or later,
580 // because it relies on the compiler's built in overflow checks.
581 
582 /**
583  * @dev Wrappers over Solidity's arithmetic operations.
584  *
585  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
586  * now has built in overflow checking.
587  */
588 library SafeMath {
589     /**
590      * @dev Returns the addition of two unsigned integers, with an overflow flag.
591      *
592      * _Available since v3.4._
593      */
594     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
595         unchecked {
596             uint256 c = a + b;
597             if (c < a) return (false, 0);
598             return (true, c);
599         }
600     }
601 
602     /**
603      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
604      *
605      * _Available since v3.4._
606      */
607     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
608         unchecked {
609             if (b > a) return (false, 0);
610             return (true, a - b);
611         }
612     }
613 
614     /**
615      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
616      *
617      * _Available since v3.4._
618      */
619     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
622             // benefit is lost if 'b' is also tested.
623             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
624             if (a == 0) return (true, 0);
625             uint256 c = a * b;
626             if (c / a != b) return (false, 0);
627             return (true, c);
628         }
629     }
630 
631     /**
632      * @dev Returns the division of two unsigned integers, with a division by zero flag.
633      *
634      * _Available since v3.4._
635      */
636     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
637         unchecked {
638             if (b == 0) return (false, 0);
639             return (true, a / b);
640         }
641     }
642 
643     /**
644      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
645      *
646      * _Available since v3.4._
647      */
648     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
649         unchecked {
650             if (b == 0) return (false, 0);
651             return (true, a % b);
652         }
653     }
654 
655     /**
656      * @dev Returns the addition of two unsigned integers, reverting on
657      * overflow.
658      *
659      * Counterpart to Solidity's `+` operator.
660      *
661      * Requirements:
662      *
663      * - Addition cannot overflow.
664      */
665     function add(uint256 a, uint256 b) internal pure returns (uint256) {
666         return a + b;
667     }
668 
669     /**
670      * @dev Returns the subtraction of two unsigned integers, reverting on
671      * overflow (when the result is negative).
672      *
673      * Counterpart to Solidity's `-` operator.
674      *
675      * Requirements:
676      *
677      * - Subtraction cannot overflow.
678      */
679     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
680         return a - b;
681     }
682 
683     /**
684      * @dev Returns the multiplication of two unsigned integers, reverting on
685      * overflow.
686      *
687      * Counterpart to Solidity's `*` operator.
688      *
689      * Requirements:
690      *
691      * - Multiplication cannot overflow.
692      */
693     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
694         return a * b;
695     }
696 
697     /**
698      * @dev Returns the integer division of two unsigned integers, reverting on
699      * division by zero. The result is rounded towards zero.
700      *
701      * Counterpart to Solidity's `/` operator.
702      *
703      * Requirements:
704      *
705      * - The divisor cannot be zero.
706      */
707     function div(uint256 a, uint256 b) internal pure returns (uint256) {
708         return a / b;
709     }
710 
711     /**
712      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
713      * reverting when dividing by zero.
714      *
715      * Counterpart to Solidity's `%` operator. This function uses a `revert`
716      * opcode (which leaves remaining gas untouched) while Solidity uses an
717      * invalid opcode to revert (consuming all remaining gas).
718      *
719      * Requirements:
720      *
721      * - The divisor cannot be zero.
722      */
723     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
724         return a % b;
725     }
726 
727     /**
728      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
729      * overflow (when the result is negative).
730      *
731      * CAUTION: This function is deprecated because it requires allocating memory for the error
732      * message unnecessarily. For custom revert reasons use {trySub}.
733      *
734      * Counterpart to Solidity's `-` operator.
735      *
736      * Requirements:
737      *
738      * - Subtraction cannot overflow.
739      */
740     function sub(
741         uint256 a,
742         uint256 b,
743         string memory errorMessage
744     ) internal pure returns (uint256) {
745         unchecked {
746             require(b <= a, errorMessage);
747             return a - b;
748         }
749     }
750 
751     /**
752      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
753      * division by zero. The result is rounded towards zero.
754      *
755      * Counterpart to Solidity's `/` operator. Note: this function uses a
756      * `revert` opcode (which leaves remaining gas untouched) while Solidity
757      * uses an invalid opcode to revert (consuming all remaining gas).
758      *
759      * Requirements:
760      *
761      * - The divisor cannot be zero.
762      */
763     function div(
764         uint256 a,
765         uint256 b,
766         string memory errorMessage
767     ) internal pure returns (uint256) {
768         unchecked {
769             require(b > 0, errorMessage);
770             return a / b;
771         }
772     }
773 
774     /**
775      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
776      * reverting with custom message when dividing by zero.
777      *
778      * CAUTION: This function is deprecated because it requires allocating memory for the error
779      * message unnecessarily. For custom revert reasons use {tryMod}.
780      *
781      * Counterpart to Solidity's `%` operator. This function uses a `revert`
782      * opcode (which leaves remaining gas untouched) while Solidity uses an
783      * invalid opcode to revert (consuming all remaining gas).
784      *
785      * Requirements:
786      *
787      * - The divisor cannot be zero.
788      */
789     function mod(
790         uint256 a,
791         uint256 b,
792         string memory errorMessage
793     ) internal pure returns (uint256) {
794         unchecked {
795             require(b > 0, errorMessage);
796             return a % b;
797         }
798     }
799 }
800 
801 /* pragma solidity 0.8.10; */
802 /* pragma experimental ABIEncoderV2; */
803 
804 interface IUniswapV2Factory {
805     event PairCreated(
806         address indexed token0,
807         address indexed token1,
808         address pair,
809         uint256
810     );
811 
812     function feeTo() external view returns (address);
813 
814     function feeToSetter() external view returns (address);
815 
816     function getPair(address tokenA, address tokenB)
817         external
818         view
819         returns (address pair);
820 
821     function allPairs(uint256) external view returns (address pair);
822 
823     function allPairsLength() external view returns (uint256);
824 
825     function createPair(address tokenA, address tokenB)
826         external
827         returns (address pair);
828 
829     function setFeeTo(address) external;
830 
831     function setFeeToSetter(address) external;
832 }
833 
834 /* pragma solidity 0.8.10; */
835 /* pragma experimental ABIEncoderV2; */
836 
837 interface IUniswapV2Pair {
838     event Approval(
839         address indexed owner,
840         address indexed spender,
841         uint256 value
842     );
843     event Transfer(address indexed from, address indexed to, uint256 value);
844 
845     function name() external pure returns (string memory);
846 
847     function symbol() external pure returns (string memory);
848 
849     function decimals() external pure returns (uint8);
850 
851     function totalSupply() external view returns (uint256);
852 
853     function balanceOf(address owner) external view returns (uint256);
854 
855     function allowance(address owner, address spender)
856         external
857         view
858         returns (uint256);
859 
860     function approve(address spender, uint256 value) external returns (bool);
861 
862     function transfer(address to, uint256 value) external returns (bool);
863 
864     function transferFrom(
865         address from,
866         address to,
867         uint256 value
868     ) external returns (bool);
869 
870     function DOMAIN_SEPARATOR() external view returns (bytes32);
871 
872     function PERMIT_TYPEHASH() external pure returns (bytes32);
873 
874     function nonces(address owner) external view returns (uint256);
875 
876     function permit(
877         address owner,
878         address spender,
879         uint256 value,
880         uint256 deadline,
881         uint8 v,
882         bytes32 r,
883         bytes32 s
884     ) external;
885 
886     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
887     event Burn(
888         address indexed sender,
889         uint256 amount0,
890         uint256 amount1,
891         address indexed to
892     );
893     event Swap(
894         address indexed sender,
895         uint256 amount0In,
896         uint256 amount1In,
897         uint256 amount0Out,
898         uint256 amount1Out,
899         address indexed to
900     );
901     event Sync(uint112 reserve0, uint112 reserve1);
902 
903     function MINIMUM_LIQUIDITY() external pure returns (uint256);
904 
905     function factory() external view returns (address);
906 
907     function token0() external view returns (address);
908 
909     function token1() external view returns (address);
910 
911     function getReserves()
912         external
913         view
914         returns (
915             uint112 reserve0,
916             uint112 reserve1,
917             uint32 blockTimestampLast
918         );
919 
920     function price0CumulativeLast() external view returns (uint256);
921 
922     function price1CumulativeLast() external view returns (uint256);
923 
924     function kLast() external view returns (uint256);
925 
926     function mint(address to) external returns (uint256 liquidity);
927 
928     function burn(address to)
929         external
930         returns (uint256 amount0, uint256 amount1);
931 
932     function swap(
933         uint256 amount0Out,
934         uint256 amount1Out,
935         address to,
936         bytes calldata data
937     ) external;
938 
939     function skim(address to) external;
940 
941     function sync() external;
942 
943     function initialize(address, address) external;
944 }
945 
946 /* pragma solidity 0.8.10; */
947 /* pragma experimental ABIEncoderV2; */
948 
949 interface IUniswapV2Router02 {
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
987     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
988         uint256 amountIn,
989         uint256 amountOutMin,
990         address[] calldata path,
991         address to,
992         uint256 deadline
993     ) external;
994 
995     function swapExactETHForTokensSupportingFeeOnTransferTokens(
996         uint256 amountOutMin,
997         address[] calldata path,
998         address to,
999         uint256 deadline
1000     ) external payable;
1001 
1002     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1003         uint256 amountIn,
1004         uint256 amountOutMin,
1005         address[] calldata path,
1006         address to,
1007         uint256 deadline
1008     ) external;
1009 }
1010 
1011 /* pragma solidity >=0.8.10; */
1012 
1013 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1014 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1015 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1016 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1017 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1018 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1019 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1020 
1021 contract ODA is ERC20, Ownable {
1022     using SafeMath for uint256;
1023 
1024     IUniswapV2Router02 public immutable uniswapV2Router;
1025     address public immutable uniswapV2Pair;
1026     address public constant deadAddress = address(0xdead);
1027 
1028     bool private swapping;
1029 
1030 	address public charityWallet;
1031     address public marketingWallet;
1032     address public devWallet;
1033 
1034     uint256 public maxTransactionAmount;
1035     uint256 public swapTokensAtAmount;
1036     uint256 public maxWallet;
1037 
1038     bool public limitsInEffect = true;
1039     bool public tradingActive = false;
1040     bool public swapEnabled = false;
1041 
1042     // Anti-bot and anti-whale mappings and variables
1043     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1044     bool public transferDelayEnabled = true;
1045 
1046     uint256 public buyTotalFees;
1047 	uint256 public buyCharityFee;
1048     uint256 public buyMarketingFee;
1049     uint256 public buyLiquidityFee;
1050     uint256 public buyDevFee;
1051 
1052     uint256 public sellTotalFees;
1053 	uint256 public sellCharityFee;
1054     uint256 public sellMarketingFee;
1055     uint256 public sellLiquidityFee;
1056     uint256 public sellDevFee;
1057 
1058 	uint256 public tokensForCharity;
1059     uint256 public tokensForMarketing;
1060     uint256 public tokensForLiquidity;
1061     uint256 public tokensForDev;
1062 
1063     /******************/
1064 
1065     // exlcude from fees and max transaction amount
1066     mapping(address => bool) private _isExcludedFromFees;
1067     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1068 
1069     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1070     // could be subject to a maximum transfer amount
1071     mapping(address => bool) public automatedMarketMakerPairs;
1072 
1073     event UpdateUniswapV2Router(
1074         address indexed newAddress,
1075         address indexed oldAddress
1076     );
1077 
1078     event ExcludeFromFees(address indexed account, bool isExcluded);
1079 
1080     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1081 
1082     event SwapAndLiquify(
1083         uint256 tokensSwapped,
1084         uint256 ethReceived,
1085         uint256 tokensIntoLiquidity
1086     );
1087 
1088     constructor() ERC20("Eiichiro Oda", "ODA") {
1089         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1090             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1091         );
1092 
1093         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1094         uniswapV2Router = _uniswapV2Router;
1095 
1096         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1097             .createPair(address(this), _uniswapV2Router.WETH());
1098         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1099         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1100 
1101 		uint256 _buyCharityFee = 0;
1102         uint256 _buyMarketingFee = 10;
1103         uint256 _buyLiquidityFee = 0;
1104         uint256 _buyDevFee = 0;
1105 
1106 		uint256 _sellCharityFee = 0;
1107         uint256 _sellMarketingFee = 25;
1108         uint256 _sellLiquidityFee = 0;
1109         uint256 _sellDevFee = 0;
1110 
1111         uint256 totalSupply = 10000000000 * 1e18;
1112 
1113         maxTransactionAmount = 200000000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1114         maxWallet = 200000000 * 1e18; // 2% from total supply maxWallet
1115         swapTokensAtAmount = (totalSupply * 40) / 10000; // 0.4% swap wallet
1116 
1117 		buyCharityFee = _buyCharityFee;
1118         buyMarketingFee = _buyMarketingFee;
1119         buyLiquidityFee = _buyLiquidityFee;
1120         buyDevFee = _buyDevFee;
1121         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1122 
1123 		sellCharityFee = _sellCharityFee;
1124         sellMarketingFee = _sellMarketingFee;
1125         sellLiquidityFee = _sellLiquidityFee;
1126         sellDevFee = _sellDevFee;
1127         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1128 
1129 		charityWallet = address(0x3B6389C9B3B667871d6780cF96bbf11c5214FA66); 
1130         marketingWallet = address(0x3B6389C9B3B667871d6780cF96bbf11c5214FA66); 
1131         devWallet = address(0x3B6389C9B3B667871d6780cF96bbf11c5214FA66); 
1132 
1133         // exclude from paying fees or having max transaction amount
1134         excludeFromFees(owner(), true);
1135         excludeFromFees(address(this), true);
1136         excludeFromFees(address(0xdead), true);
1137 
1138         excludeFromMaxTransaction(owner(), true);
1139         excludeFromMaxTransaction(address(this), true);
1140         excludeFromMaxTransaction(address(0xdead), true);
1141 
1142         /*
1143             _mint is an internal function in ERC20.sol that is only called here,
1144             and CANNOT be called ever again
1145         */
1146         _mint(msg.sender, totalSupply);
1147     }
1148 
1149     receive() external payable {}
1150 
1151     // once enabled, can never be turned off
1152     function enableTrading() external onlyOwner {
1153         tradingActive = true;
1154         swapEnabled = true;
1155     }
1156 
1157     // remove limits after token is stable
1158     function removeLimits() external onlyOwner returns (bool) {
1159         limitsInEffect = false;
1160         return true;
1161     }
1162 
1163     // disable Transfer delay - cannot be reenabled
1164     function disableTransferDelay() external onlyOwner returns (bool) {
1165         transferDelayEnabled = false;
1166         return true;
1167     }
1168 
1169     // change the minimum amount of tokens to sell from fees
1170     function updateSwapTokensAtAmount(uint256 newAmount)
1171         external
1172         onlyOwner
1173         returns (bool)
1174     {
1175         require(
1176             newAmount >= (totalSupply() * 1) / 100000,
1177             "Swap amount cannot be lower than 0.001% total supply."
1178         );
1179         require(
1180             newAmount <= (totalSupply() * 5) / 1000,
1181             "Swap amount cannot be higher than 0.5% total supply."
1182         );
1183         swapTokensAtAmount = newAmount;
1184         return true;
1185     }
1186 
1187     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1188         require(
1189             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1190             "Cannot set maxTransactionAmount lower than 0.5%"
1191         );
1192         maxTransactionAmount = newNum * (10**18);
1193     }
1194 
1195     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1196         require(
1197             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1198             "Cannot set maxWallet lower than 0.5%"
1199         );
1200         maxWallet = newNum * (10**18);
1201     }
1202 	
1203     function excludeFromMaxTransaction(address updAds, bool isEx)
1204         public
1205         onlyOwner
1206     {
1207         _isExcludedMaxTransactionAmount[updAds] = isEx;
1208     }
1209 
1210     // only use to disable contract sales if absolutely necessary (emergency use only)
1211     function updateSwapEnabled(bool enabled) external onlyOwner {
1212         swapEnabled = enabled;
1213     }
1214 
1215     function updateBuyFees(
1216 		uint256 _charityFee,
1217         uint256 _marketingFee,
1218         uint256 _liquidityFee,
1219         uint256 _devFee
1220     ) external onlyOwner {
1221 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1222 		buyCharityFee = _charityFee;
1223         buyMarketingFee = _marketingFee;
1224         buyLiquidityFee = _liquidityFee;
1225         buyDevFee = _devFee;
1226         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1227      }
1228 
1229     function updateSellFees(
1230 		uint256 _charityFee,
1231         uint256 _marketingFee,
1232         uint256 _liquidityFee,
1233         uint256 _devFee
1234     ) external onlyOwner {
1235 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 99, "Max SellFee 99% to trick bots");
1236 		sellCharityFee = _charityFee;
1237         sellMarketingFee = _marketingFee;
1238         sellLiquidityFee = _liquidityFee;
1239         sellDevFee = _devFee;
1240         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1241     }
1242 
1243     function excludeFromFees(address account, bool excluded) public onlyOwner {
1244         _isExcludedFromFees[account] = excluded;
1245         emit ExcludeFromFees(account, excluded);
1246     }
1247 
1248     function setAutomatedMarketMakerPair(address pair, bool value)
1249         public
1250         onlyOwner
1251     {
1252         require(
1253             pair != uniswapV2Pair,
1254             "The pair cannot be removed from automatedMarketMakerPairs"
1255         );
1256 
1257         _setAutomatedMarketMakerPair(pair, value);
1258     }
1259 
1260     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1261         automatedMarketMakerPairs[pair] = value;
1262 
1263         emit SetAutomatedMarketMakerPair(pair, value);
1264     }
1265 
1266     function isExcludedFromFees(address account) public view returns (bool) {
1267         return _isExcludedFromFees[account];
1268     }
1269 
1270     function _transfer(
1271         address from,
1272         address to,
1273         uint256 amount
1274     ) internal override {
1275         require(from != address(0), "ERC20: transfer from the zero address");
1276         require(to != address(0), "ERC20: transfer to the zero address");
1277 
1278         if (amount == 0) {
1279             super._transfer(from, to, 0);
1280             return;
1281         }
1282 
1283         if (limitsInEffect) {
1284             if (
1285                 from != owner() &&
1286                 to != owner() &&
1287                 to != address(0) &&
1288                 to != address(0xdead) &&
1289                 !swapping
1290             ) {
1291                 if (!tradingActive) {
1292                     require(
1293                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1294                         "Trading is not active."
1295                     );
1296                 }
1297 
1298                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1299                 if (transferDelayEnabled) {
1300                     if (
1301                         to != owner() &&
1302                         to != address(uniswapV2Router) &&
1303                         to != address(uniswapV2Pair)
1304                     ) {
1305                         require(
1306                             _holderLastTransferTimestamp[tx.origin] <
1307                                 block.number,
1308                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1309                         );
1310                         _holderLastTransferTimestamp[tx.origin] = block.number;
1311                     }
1312                 }
1313 
1314                 //when buy
1315                 if (
1316                     automatedMarketMakerPairs[from] &&
1317                     !_isExcludedMaxTransactionAmount[to]
1318                 ) {
1319                     require(
1320                         amount <= maxTransactionAmount,
1321                         "Buy transfer amount exceeds the maxTransactionAmount."
1322                     );
1323                     require(
1324                         amount + balanceOf(to) <= maxWallet,
1325                         "Max wallet exceeded"
1326                     );
1327                 }
1328                 //when sell
1329                 else if (
1330                     automatedMarketMakerPairs[to] &&
1331                     !_isExcludedMaxTransactionAmount[from]
1332                 ) {
1333                     require(
1334                         amount <= maxTransactionAmount,
1335                         "Sell transfer amount exceeds the maxTransactionAmount."
1336                     );
1337                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1338                     require(
1339                         amount + balanceOf(to) <= maxWallet,
1340                         "Max wallet exceeded"
1341                     );
1342                 }
1343             }
1344         }
1345 
1346         uint256 contractTokenBalance = balanceOf(address(this));
1347 
1348         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1349 
1350         if (
1351             canSwap &&
1352             swapEnabled &&
1353             !swapping &&
1354             !automatedMarketMakerPairs[from] &&
1355             !_isExcludedFromFees[from] &&
1356             !_isExcludedFromFees[to]
1357         ) {
1358             swapping = true;
1359 
1360             swapBack();
1361 
1362             swapping = false;
1363         }
1364 
1365         bool takeFee = !swapping;
1366 
1367         // if any account belongs to _isExcludedFromFee account then remove the fee
1368         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1369             takeFee = false;
1370         }
1371 
1372         uint256 fees = 0;
1373         // only take fees on buys/sells, do not take on wallet transfers
1374         if (takeFee) {
1375             // on sell
1376             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1377                 fees = amount.mul(sellTotalFees).div(100);
1378 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1379                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1380                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1381                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1382             }
1383             // on buy
1384             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1385                 fees = amount.mul(buyTotalFees).div(100);
1386 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1387                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1388                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1389                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1390             }
1391 
1392             if (fees > 0) {
1393                 super._transfer(from, address(this), fees);
1394             }
1395 
1396             amount -= fees;
1397         }
1398 
1399         super._transfer(from, to, amount);
1400     }
1401 
1402     function swapTokensForEth(uint256 tokenAmount) private {
1403         // generate the uniswap pair path of token -> weth
1404         address[] memory path = new address[](2);
1405         path[0] = address(this);
1406         path[1] = uniswapV2Router.WETH();
1407 
1408         _approve(address(this), address(uniswapV2Router), tokenAmount);
1409 
1410         // make the swap
1411         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1412             tokenAmount,
1413             0, // accept any amount of ETH
1414             path,
1415             address(this),
1416             block.timestamp
1417         );
1418     }
1419 
1420     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1421         // approve token transfer to cover all possible scenarios
1422         _approve(address(this), address(uniswapV2Router), tokenAmount);
1423 
1424         // add the liquidity
1425         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1426             address(this),
1427             tokenAmount,
1428             0, // slippage is unavoidable
1429             0, // slippage is unavoidable
1430             devWallet,
1431             block.timestamp
1432         );
1433     }
1434 
1435     function swapBack() private {
1436         uint256 contractBalance = balanceOf(address(this));
1437         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1438         bool success;
1439 
1440         if (contractBalance == 0 || totalTokensToSwap == 0) {
1441             return;
1442         }
1443 
1444         if (contractBalance > swapTokensAtAmount * 20) {
1445             contractBalance = swapTokensAtAmount * 20;
1446         }
1447 
1448         // Halve the amount of liquidity tokens
1449         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1450         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1451 
1452         uint256 initialETHBalance = address(this).balance;
1453 
1454         swapTokensForEth(amountToSwapForETH);
1455 
1456         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1457 
1458 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1459         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1460         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1461 
1462         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1463 
1464         tokensForLiquidity = 0;
1465 		tokensForCharity = 0;
1466         tokensForMarketing = 0;
1467         tokensForDev = 0;
1468 
1469         (success, ) = address(devWallet).call{value: ethForDev}("");
1470         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1471 
1472 
1473         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1474             addLiquidity(liquidityTokens, ethForLiquidity);
1475             emit SwapAndLiquify(
1476                 amountToSwapForETH,
1477                 ethForLiquidity,
1478                 tokensForLiquidity
1479             );
1480         }
1481 
1482         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1483     }
1484 
1485 }