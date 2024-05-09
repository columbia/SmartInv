1 /**
2 
3 hollywoodinu.com
4 
5 /**
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
27 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
28 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
29 
30 /* pragma solidity ^0.8.0; */
31 
32 /* import "../utils/Context.sol"; */
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
105 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
106 
107 /* pragma solidity ^0.8.0; */
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP.
111  */
112 interface IERC20 {
113     /**
114      * @dev Returns the amount of tokens in existence.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     /**
119      * @dev Returns the amount of tokens owned by `account`.
120      */
121     function balanceOf(address account) external view returns (uint256);
122 
123     /**
124      * @dev Moves `amount` tokens from the caller's account to `recipient`.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transfer(address recipient, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Returns the remaining number of tokens that `spender` will be
134      * allowed to spend on behalf of `owner` through {transferFrom}. This is
135      * zero by default.
136      *
137      * This value changes when {approve} or {transferFrom} are called.
138      */
139     function allowance(address owner, address spender) external view returns (uint256);
140 
141     /**
142      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * IMPORTANT: Beware that changing an allowance with this method brings the risk
147      * that someone may use both the old and the new allowance by unfortunate
148      * transaction ordering. One possible solution to mitigate this race
149      * condition is to first reduce the spender's allowance to 0 and set the
150      * desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      *
153      * Emits an {Approval} event.
154      */
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
801 ////// src/IUniswapV2Factory.sol
802 /* pragma solidity 0.8.10; */
803 /* pragma experimental ABIEncoderV2; */
804 
805 interface IUniswapV2Factory {
806     event PairCreated(
807         address indexed token0,
808         address indexed token1,
809         address pair,
810         uint256
811     );
812 
813     function feeTo() external view returns (address);
814 
815     function feeToSetter() external view returns (address);
816 
817     function getPair(address tokenA, address tokenB)
818         external
819         view
820         returns (address pair);
821 
822     function allPairs(uint256) external view returns (address pair);
823 
824     function allPairsLength() external view returns (uint256);
825 
826     function createPair(address tokenA, address tokenB)
827         external
828         returns (address pair);
829 
830     function setFeeTo(address) external;
831 
832     function setFeeToSetter(address) external;
833 }
834 
835 ////// src/IUniswapV2Pair.sol
836 /* pragma solidity 0.8.10; */
837 /* pragma experimental ABIEncoderV2; */
838 
839 interface IUniswapV2Pair {
840     event Approval(
841         address indexed owner,
842         address indexed spender,
843         uint256 value
844     );
845     event Transfer(address indexed from, address indexed to, uint256 value);
846 
847     function name() external pure returns (string memory);
848 
849     function symbol() external pure returns (string memory);
850 
851     function decimals() external pure returns (uint8);
852 
853     function totalSupply() external view returns (uint256);
854 
855     function balanceOf(address owner) external view returns (uint256);
856 
857     function allowance(address owner, address spender)
858         external
859         view
860         returns (uint256);
861 
862     function approve(address spender, uint256 value) external returns (bool);
863 
864     function transfer(address to, uint256 value) external returns (bool);
865 
866     function transferFrom(
867         address from,
868         address to,
869         uint256 value
870     ) external returns (bool);
871 
872     function DOMAIN_SEPARATOR() external view returns (bytes32);
873 
874     function PERMIT_TYPEHASH() external pure returns (bytes32);
875 
876     function nonces(address owner) external view returns (uint256);
877 
878     function permit(
879         address owner,
880         address spender,
881         uint256 value,
882         uint256 deadline,
883         uint8 v,
884         bytes32 r,
885         bytes32 s
886     ) external;
887 
888     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
889     event Burn(
890         address indexed sender,
891         uint256 amount0,
892         uint256 amount1,
893         address indexed to
894     );
895     event Swap(
896         address indexed sender,
897         uint256 amount0In,
898         uint256 amount1In,
899         uint256 amount0Out,
900         uint256 amount1Out,
901         address indexed to
902     );
903     event Sync(uint112 reserve0, uint112 reserve1);
904 
905     function MINIMUM_LIQUIDITY() external pure returns (uint256);
906 
907     function factory() external view returns (address);
908 
909     function token0() external view returns (address);
910 
911     function token1() external view returns (address);
912 
913     function getReserves()
914         external
915         view
916         returns (
917             uint112 reserve0,
918             uint112 reserve1,
919             uint32 blockTimestampLast
920         );
921 
922     function price0CumulativeLast() external view returns (uint256);
923 
924     function price1CumulativeLast() external view returns (uint256);
925 
926     function kLast() external view returns (uint256);
927 
928     function mint(address to) external returns (uint256 liquidity);
929 
930     function burn(address to)
931         external
932         returns (uint256 amount0, uint256 amount1);
933 
934     function swap(
935         uint256 amount0Out,
936         uint256 amount1Out,
937         address to,
938         bytes calldata data
939     ) external;
940 
941     function skim(address to) external;
942 
943     function sync() external;
944 
945     function initialize(address, address) external;
946 }
947 
948 ////// src/IUniswapV2Router02.sol
949 /* pragma solidity 0.8.10; */
950 /* pragma experimental ABIEncoderV2; */
951 
952 interface IUniswapV2Router02 {
953     function factory() external pure returns (address);
954 
955     function WETH() external pure returns (address);
956 
957     function addLiquidity(
958         address tokenA,
959         address tokenB,
960         uint256 amountADesired,
961         uint256 amountBDesired,
962         uint256 amountAMin,
963         uint256 amountBMin,
964         address to,
965         uint256 deadline
966     )
967         external
968         returns (
969             uint256 amountA,
970             uint256 amountB,
971             uint256 liquidity
972         );
973 
974     function addLiquidityETH(
975         address token,
976         uint256 amountTokenDesired,
977         uint256 amountTokenMin,
978         uint256 amountETHMin,
979         address to,
980         uint256 deadline
981     )
982         external
983         payable
984         returns (
985             uint256 amountToken,
986             uint256 amountETH,
987             uint256 liquidity
988         );
989 
990     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
991         uint256 amountIn,
992         uint256 amountOutMin,
993         address[] calldata path,
994         address to,
995         uint256 deadline
996     ) external;
997 
998     function swapExactETHForTokensSupportingFeeOnTransferTokens(
999         uint256 amountOutMin,
1000         address[] calldata path,
1001         address to,
1002         uint256 deadline
1003     ) external payable;
1004 
1005     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1006         uint256 amountIn,
1007         uint256 amountOutMin,
1008         address[] calldata path,
1009         address to,
1010         uint256 deadline
1011     ) external;
1012 }
1013 
1014 
1015 /* pragma solidity >=0.8.10; */
1016 
1017 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1018 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1019 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1020 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1021 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1022 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1023 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1024 
1025 contract HollywoodInu  is ERC20, Ownable {
1026     using SafeMath for uint256;
1027 
1028     IUniswapV2Router02 public immutable uniswapV2Router;
1029     address public immutable uniswapV2Pair;
1030     address public constant deadAddress = address(0xdead);
1031 
1032     bool private swapping;
1033 
1034     address public marketingWallet;
1035     address public devWallet;
1036 
1037     uint256 public maxTransactionAmount;
1038     uint256 public swapTokensAtAmount;
1039     uint256 public maxWallet;
1040 
1041     uint256 public percentForLPBurn = 25; // 25 = .25%
1042     bool public lpBurnEnabled = true;
1043     uint256 public lpBurnFrequency = 3600 seconds;
1044     uint256 public lastLpBurnTime;
1045 
1046     uint256 public manualBurnFrequency = 30 minutes;
1047     uint256 public lastManualLpBurnTime;
1048 
1049     bool public limitsInEffect = true;
1050     bool public tradingActive = false;
1051     bool public swapEnabled = false;
1052 
1053     // Anti-bot and anti-whale mappings and variables
1054     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1055     bool public transferDelayEnabled = true;
1056 
1057     uint256 public buyTotalFees;
1058     uint256 public buyMarketingFee;
1059     uint256 public buyLiquidityFee;
1060     uint256 public buyDevFee;
1061 
1062     uint256 public sellTotalFees;
1063     uint256 public sellMarketingFee;
1064     uint256 public sellLiquidityFee;
1065     uint256 public sellDevFee;
1066 
1067     uint256 public tokensForMarketing;
1068     uint256 public tokensForLiquidity;
1069     uint256 public tokensForDev;
1070 
1071     /******************/
1072 
1073     // exlcude from fees and max transaction amount
1074     mapping(address => bool) private _isExcludedFromFees;
1075     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1076 
1077     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1078     // could be subject to a maximum transfer amount
1079     mapping(address => bool) public automatedMarketMakerPairs;
1080 
1081     event UpdateUniswapV2Router(
1082         address indexed newAddress,
1083         address indexed oldAddress
1084     );
1085 
1086     event ExcludeFromFees(address indexed account, bool isExcluded);
1087 
1088     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1089 
1090     event marketingWalletUpdated(
1091         address indexed newWallet,
1092         address indexed oldWallet
1093     );
1094 
1095     event devWalletUpdated(
1096         address indexed newWallet,
1097         address indexed oldWallet
1098     );
1099 
1100     event SwapAndLiquify(
1101         uint256 tokensSwapped,
1102         uint256 ethReceived,
1103         uint256 tokensIntoLiquidity
1104     );
1105 
1106     event AutoNukeLP();
1107 
1108     event ManualNukeLP();
1109 
1110     constructor() ERC20("Hollywood Inu", "HWI") {
1111         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1112             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1113         );
1114 
1115         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1116         uniswapV2Router = _uniswapV2Router;
1117 
1118         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1119             .createPair(address(this), _uniswapV2Router.WETH());
1120         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1121         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1122 
1123         uint256 _buyMarketingFee = 5;
1124         uint256 _buyLiquidityFee = 3;
1125         uint256 _buyDevFee = 2;
1126 
1127         uint256 _sellMarketingFee = 10;
1128         uint256 _sellLiquidityFee = 3;
1129         uint256 _sellDevFee = 2;
1130 
1131         uint256 totalSupply = 1_000_000_000 * 1e18;
1132 
1133         maxTransactionAmount = 10_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1134         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1135         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1136 
1137         buyMarketingFee = _buyMarketingFee;
1138         buyLiquidityFee = _buyLiquidityFee;
1139         buyDevFee = _buyDevFee;
1140         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1141 
1142         sellMarketingFee = _sellMarketingFee;
1143         sellLiquidityFee = _sellLiquidityFee;
1144         sellDevFee = _sellDevFee;
1145         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1146 
1147         marketingWallet = address(0x6cA7565f0728a51eda0982E2d25faF94c5a2D182); // set as marketing wallet
1148         devWallet = address(0x08fDBB10f361E65E1f5adCB18eCaBFBF77fF5310); // set as dev wallet
1149 
1150         // exclude from paying fees or having max transaction amount
1151         excludeFromFees(owner(), true);
1152         excludeFromFees(address(this), true);
1153         excludeFromFees(address(0xdead), true);
1154 
1155         excludeFromMaxTransaction(owner(), true);
1156         excludeFromMaxTransaction(address(this), true);
1157         excludeFromMaxTransaction(address(0xdead), true);
1158 
1159         /*
1160             _mint is an internal function in ERC20.sol that is only called here,
1161             and CANNOT be called ever again
1162         */
1163         _mint(msg.sender, totalSupply);
1164     }
1165 
1166     receive() external payable {}
1167 
1168     // once enabled, can never be turned off
1169     function enableTrading() external onlyOwner {
1170         tradingActive = true;
1171         swapEnabled = true;
1172         lastLpBurnTime = block.timestamp;
1173     }
1174 
1175     // remove limits after token is stable
1176     function removeLimits() external onlyOwner returns (bool) {
1177         limitsInEffect = false;
1178         return true;
1179     }
1180 
1181     // disable Transfer delay - cannot be reenabled
1182     function disableTransferDelay() external onlyOwner returns (bool) {
1183         transferDelayEnabled = false;
1184         return true;
1185     }
1186 
1187     // change the minimum amount of tokens to sell from fees
1188     function updateSwapTokensAtAmount(uint256 newAmount)
1189         external
1190         onlyOwner
1191         returns (bool)
1192     {
1193         require(
1194             newAmount >= (totalSupply() * 1) / 100000,
1195             "Swap amount cannot be lower than 0.001% total supply."
1196         );
1197         require(
1198             newAmount <= (totalSupply() * 5) / 1000,
1199             "Swap amount cannot be higher than 0.5% total supply."
1200         );
1201         swapTokensAtAmount = newAmount;
1202         return true;
1203     }
1204 
1205     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1206         require(
1207             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1208             "Cannot set maxTransactionAmount lower than 0.1%"
1209         );
1210         maxTransactionAmount = newNum * (10**18);
1211     }
1212 
1213     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1214         require(
1215             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1216             "Cannot set maxWallet lower than 0.5%"
1217         );
1218         maxWallet = newNum * (10**18);
1219     }
1220 
1221     function excludeFromMaxTransaction(address updAds, bool isEx)
1222         public
1223         onlyOwner
1224     {
1225         _isExcludedMaxTransactionAmount[updAds] = isEx;
1226     }
1227 
1228     // only use to disable contract sales if absolutely necessary (emergency use only)
1229     function updateSwapEnabled(bool enabled) external onlyOwner {
1230         swapEnabled = enabled;
1231     }
1232 
1233     function updateBuyFees(
1234         uint256 _marketingFee,
1235         uint256 _liquidityFee,
1236         uint256 _devFee
1237     ) external onlyOwner {
1238         buyMarketingFee = _marketingFee;
1239         buyLiquidityFee = _liquidityFee;
1240         buyDevFee = _devFee;
1241         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1242         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1243     }
1244 
1245     function updateSellFees(
1246         uint256 _marketingFee,
1247         uint256 _liquidityFee,
1248         uint256 _devFee
1249     ) external onlyOwner {
1250         sellMarketingFee = _marketingFee;
1251         sellLiquidityFee = _liquidityFee;
1252         sellDevFee = _devFee;
1253         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1254         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1255     }
1256 
1257     function excludeFromFees(address account, bool excluded) public onlyOwner {
1258         _isExcludedFromFees[account] = excluded;
1259         emit ExcludeFromFees(account, excluded);
1260     }
1261 
1262     function setAutomatedMarketMakerPair(address pair, bool value)
1263         public
1264         onlyOwner
1265     {
1266         require(
1267             pair != uniswapV2Pair,
1268             "The pair cannot be removed from automatedMarketMakerPairs"
1269         );
1270 
1271         _setAutomatedMarketMakerPair(pair, value);
1272     }
1273 
1274     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1275         automatedMarketMakerPairs[pair] = value;
1276 
1277         emit SetAutomatedMarketMakerPair(pair, value);
1278     }
1279 
1280     function updateMarketingWallet(address newMarketingWallet)
1281         external
1282         onlyOwner
1283     {
1284         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1285         marketingWallet = newMarketingWallet;
1286     }
1287 
1288     function updateDevWallet(address newWallet) external onlyOwner {
1289         emit devWalletUpdated(newWallet, devWallet);
1290         devWallet = newWallet;
1291     }
1292 
1293     function isExcludedFromFees(address account) public view returns (bool) {
1294         return _isExcludedFromFees[account];
1295     }
1296 
1297     event BoughtEarly(address indexed sniper);
1298 
1299     function _transfer(
1300         address from,
1301         address to,
1302         uint256 amount
1303     ) internal override {
1304         require(from != address(0), "ERC20: transfer from the zero address");
1305         require(to != address(0), "ERC20: transfer to the zero address");
1306 
1307         if (amount == 0) {
1308             super._transfer(from, to, 0);
1309             return;
1310         }
1311 
1312         if (limitsInEffect) {
1313             if (
1314                 from != owner() &&
1315                 to != owner() &&
1316                 to != address(0) &&
1317                 to != address(0xdead) &&
1318                 !swapping
1319             ) {
1320                 if (!tradingActive) {
1321                     require(
1322                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1323                         "Trading is not active."
1324                     );
1325                 }
1326 
1327                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1328                 if (transferDelayEnabled) {
1329                     if (
1330                         to != owner() &&
1331                         to != address(uniswapV2Router) &&
1332                         to != address(uniswapV2Pair)
1333                     ) {
1334                         require(
1335                             _holderLastTransferTimestamp[tx.origin] <
1336                                 block.number,
1337                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1338                         );
1339                         _holderLastTransferTimestamp[tx.origin] = block.number;
1340                     }
1341                 }
1342 
1343                 //when buy
1344                 if (
1345                     automatedMarketMakerPairs[from] &&
1346                     !_isExcludedMaxTransactionAmount[to]
1347                 ) {
1348                     require(
1349                         amount <= maxTransactionAmount,
1350                         "Buy transfer amount exceeds the maxTransactionAmount."
1351                     );
1352                     require(
1353                         amount + balanceOf(to) <= maxWallet,
1354                         "Max wallet exceeded"
1355                     );
1356                 }
1357                 //when sell
1358                 else if (
1359                     automatedMarketMakerPairs[to] &&
1360                     !_isExcludedMaxTransactionAmount[from]
1361                 ) {
1362                     require(
1363                         amount <= maxTransactionAmount,
1364                         "Sell transfer amount exceeds the maxTransactionAmount."
1365                     );
1366                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1367                     require(
1368                         amount + balanceOf(to) <= maxWallet,
1369                         "Max wallet exceeded"
1370                     );
1371                 }
1372             }
1373         }
1374 
1375         uint256 contractTokenBalance = balanceOf(address(this));
1376 
1377         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1378 
1379         if (
1380             canSwap &&
1381             swapEnabled &&
1382             !swapping &&
1383             !automatedMarketMakerPairs[from] &&
1384             !_isExcludedFromFees[from] &&
1385             !_isExcludedFromFees[to]
1386         ) {
1387             swapping = true;
1388 
1389             swapBack();
1390 
1391             swapping = false;
1392         }
1393 
1394         if (
1395             !swapping &&
1396             automatedMarketMakerPairs[to] &&
1397             lpBurnEnabled &&
1398             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1399             !_isExcludedFromFees[from]
1400         ) {
1401             autoBurnLiquidityPairTokens();
1402         }
1403 
1404         bool takeFee = !swapping;
1405 
1406         // if any account belongs to _isExcludedFromFee account then remove the fee
1407         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1408             takeFee = false;
1409         }
1410 
1411         uint256 fees = 0;
1412         // only take fees on buys/sells, do not take on wallet transfers
1413         if (takeFee) {
1414             // on sell
1415             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1416                 fees = amount.mul(sellTotalFees).div(100);
1417                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1418                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1419                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1420             }
1421             // on buy
1422             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1423                 fees = amount.mul(buyTotalFees).div(100);
1424                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1425                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1426                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1427             }
1428 
1429             if (fees > 0) {
1430                 super._transfer(from, address(this), fees);
1431             }
1432 
1433             amount -= fees;
1434         }
1435 
1436         super._transfer(from, to, amount);
1437     }
1438 
1439     function swapTokensForEth(uint256 tokenAmount) private {
1440         // generate the uniswap pair path of token -> weth
1441         address[] memory path = new address[](2);
1442         path[0] = address(this);
1443         path[1] = uniswapV2Router.WETH();
1444 
1445         _approve(address(this), address(uniswapV2Router), tokenAmount);
1446 
1447         // make the swap
1448         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1449             tokenAmount,
1450             0, // accept any amount of ETH
1451             path,
1452             address(this),
1453             block.timestamp
1454         );
1455     }
1456 
1457     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1458         // approve token transfer to cover all possible scenarios
1459         _approve(address(this), address(uniswapV2Router), tokenAmount);
1460 
1461         // add the liquidity
1462         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1463             address(this),
1464             tokenAmount,
1465             0, // slippage is unavoidable
1466             0, // slippage is unavoidable
1467             deadAddress,
1468             block.timestamp
1469         );
1470     }
1471 
1472     function swapBack() private {
1473         uint256 contractBalance = balanceOf(address(this));
1474         uint256 totalTokensToSwap = tokensForLiquidity +
1475             tokensForMarketing +
1476             tokensForDev;
1477         bool success;
1478 
1479         if (contractBalance == 0 || totalTokensToSwap == 0) {
1480             return;
1481         }
1482 
1483         if (contractBalance > swapTokensAtAmount * 20) {
1484             contractBalance = swapTokensAtAmount * 20;
1485         }
1486 
1487         // Halve the amount of liquidity tokens
1488         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1489             totalTokensToSwap /
1490             2;
1491         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1492 
1493         uint256 initialETHBalance = address(this).balance;
1494 
1495         swapTokensForEth(amountToSwapForETH);
1496 
1497         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1498 
1499         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1500             totalTokensToSwap
1501         );
1502         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1503 
1504         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1505 
1506         tokensForLiquidity = 0;
1507         tokensForMarketing = 0;
1508         tokensForDev = 0;
1509 
1510         (success, ) = address(devWallet).call{value: ethForDev}("");
1511 
1512         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1513             addLiquidity(liquidityTokens, ethForLiquidity);
1514             emit SwapAndLiquify(
1515                 amountToSwapForETH,
1516                 ethForLiquidity,
1517                 tokensForLiquidity
1518             );
1519         }
1520 
1521         (success, ) = address(marketingWallet).call{
1522             value: address(this).balance
1523         }("");
1524     }
1525 
1526     function setAutoLPBurnSettings(
1527         uint256 _frequencyInSeconds,
1528         uint256 _percent,
1529         bool _Enabled
1530     ) external onlyOwner {
1531         require(
1532             _frequencyInSeconds >= 600,
1533             "cannot set buyback more often than every 10 minutes"
1534         );
1535         require(
1536             _percent <= 1000 && _percent >= 0,
1537             "Must set auto LP burn percent between 0% and 10%"
1538         );
1539         lpBurnFrequency = _frequencyInSeconds;
1540         percentForLPBurn = _percent;
1541         lpBurnEnabled = _Enabled;
1542     }
1543 
1544     function autoBurnLiquidityPairTokens() internal returns (bool) {
1545         lastLpBurnTime = block.timestamp;
1546 
1547         // get balance of liquidity pair
1548         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1549 
1550         // calculate amount to burn
1551         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1552             10000
1553         );
1554 
1555         // pull tokens from pancakePair liquidity and move to dead address permanently
1556         if (amountToBurn > 0) {
1557             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1558         }
1559 
1560         //sync price since this is not in a swap transaction!
1561         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1562         pair.sync();
1563         emit AutoNukeLP();
1564         return true;
1565     }
1566 
1567     function manualBurnLiquidityPairTokens(uint256 percent)
1568         external
1569         onlyOwner
1570         returns (bool)
1571     {
1572         require(
1573             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1574             "Must wait for cooldown to finish"
1575         );
1576         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1577         lastManualLpBurnTime = block.timestamp;
1578 
1579         // get balance of liquidity pair
1580         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1581 
1582         // calculate amount to burn
1583         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1584 
1585         // pull tokens from pancakePair liquidity and move to dead address permanently
1586         if (amountToBurn > 0) {
1587             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1588         }
1589 
1590         //sync price since this is not in a swap transaction!
1591         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1592         pair.sync();
1593         emit ManualNukeLP();
1594         return true;
1595     }
1596 }