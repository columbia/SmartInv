1 // SPDX-License-Identifier: MIT
2 
3 //https://t.me/GROWLERC
4 
5 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
6 pragma experimental ABIEncoderV2;
7 
8 
9 
10 
11 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
12 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
13 
14 /* pragma solidity ^0.8.0; */
15 
16 
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
1014 /* pragma solidity >=0.8.10; */
1015 
1016 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1017 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1018 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1019 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1020 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1021 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1022 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1023 
1024 contract GROWL is ERC20, Ownable {
1025     using SafeMath for uint256;
1026 
1027     IUniswapV2Router02 public immutable uniswapV2Router;
1028     address public immutable uniswapV2Pair;
1029     address public constant deadAddress = address(0xdead);
1030 
1031     bool private swapping;
1032 
1033     address private marketingWallet;
1034     address private EcoWallet;
1035 
1036     uint256 public maxTransactionAmount;
1037     uint256 public swapTokensAtAmount;
1038     uint256 public maxWallet;
1039 
1040     uint256 public percentForLPBurn = 0; // 0 = 0%
1041     bool public lpBurnEnabled = false;
1042     uint256 public lpBurnFrequency = 0 seconds;
1043     uint256 public lastLpBurnTime;
1044 
1045     uint256 public manualBurnFrequency = 0 minutes;
1046     uint256 public lastManualLpBurnTime;
1047 
1048     bool public limitsInEffect = true;
1049     bool public tradingActive = false;
1050     bool public swapEnabled = false;
1051 
1052     // Anti-bot and anti-whale mappings and variables
1053     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1054     bool public transferDelayEnabled = true;
1055 
1056     uint256 public buyTotalFees;
1057     uint256 private buyMarketingFee;
1058     uint256 private buyLiquidityFee;
1059     uint256 private buyEcoFee;
1060 
1061     uint256 public sellTotalFees;
1062     uint256 private sellMarketingFee;
1063     uint256 private sellLiquidityFee;
1064     uint256 private sellEcoFee;
1065 
1066     uint256 public tokensForMarketing;
1067     uint256 public tokensForLiquidity;
1068     uint256 public tokensForDev;
1069 
1070     /******************/
1071 
1072     // exlcude from fees and max transaction amount
1073     mapping(address => bool) private _isExcludedFromFees;
1074     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1075 
1076     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1077     // could be subject to a maximum transfer amount
1078     mapping(address => bool) public automatedMarketMakerPairs;
1079 
1080     event UpdateUniswapV2Router(
1081         address indexed newAddress,
1082         address indexed oldAddress
1083     );
1084 
1085     event ExcludeFromFees(address indexed account, bool isExcluded);
1086 
1087     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1088 
1089     event marketingWalletUpdated(
1090         address indexed newWallet,
1091         address indexed oldWallet
1092     );
1093 
1094     event EcoWalletUpdated(
1095         address indexed newWallet,
1096         address indexed oldWallet
1097     );
1098 
1099     event SwapAndLiquify(
1100         uint256 tokensSwapped,
1101         uint256 ethReceived,
1102         uint256 tokensIntoLiquidity
1103     );
1104 
1105     event AutoNukeLP();
1106 
1107     event ManualNukeLP();
1108 
1109     constructor() ERC20("GROWL", "GROWL") {
1110         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1111             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1112         );
1113 
1114         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1115         uniswapV2Router = _uniswapV2Router;
1116 
1117         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1118             .createPair(address(this), _uniswapV2Router.WETH());
1119         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1120         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1121 
1122         uint256 _buyMarketingFee = 2;
1123         uint256 _buyLiquidityFee = 1;
1124         uint256 _buyEcoFee = 1;
1125 
1126         uint256 _sellMarketingFee = 20;
1127         uint256 _sellLiquidityFee = 3;
1128         uint256 _sellEcoFee = 22;
1129 
1130         uint256 totalSupply = 1_000_000 * 1e18;
1131 
1132         maxTransactionAmount = 20_000 * 1e18; 
1133         maxWallet = 20_000 * 1e18; 
1134         swapTokensAtAmount = (totalSupply * 5) / 10000; 
1135 
1136         buyMarketingFee = _buyMarketingFee;
1137         buyLiquidityFee = _buyLiquidityFee;
1138         buyEcoFee = _buyEcoFee;
1139         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyEcoFee;
1140 
1141         sellMarketingFee = _sellMarketingFee;
1142         sellLiquidityFee = _sellLiquidityFee;
1143         sellEcoFee = _sellEcoFee;
1144         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellEcoFee;
1145 
1146         marketingWallet = address(0xCF8c5A83e3A44326E71304Cdbfeffd2ec5224943); //
1147         EcoWallet = address(0xCF8c5A83e3A44326E71304Cdbfeffd2ec5224943); //
1148 
1149         // exclude from paying fees or having max transaction amount
1150         excludeFromFees(owner(), true);
1151         excludeFromFees(address(this), true);
1152         excludeFromFees(address(0xdead), true);
1153 
1154         excludeFromMaxTransaction(owner(), true);
1155         excludeFromMaxTransaction(address(this), true);
1156         excludeFromMaxTransaction(address(0xdead), true);
1157 
1158         /*
1159             _mint is an internal function in ERC20.sol that is only called here,
1160             and CANNOT be called ever again
1161         */
1162         _mint(msg.sender, totalSupply);
1163     }
1164 
1165     receive() external payable {}
1166 
1167     // once enabled, can never be turned off
1168     function enableTrading() external onlyOwner {
1169         tradingActive = true;
1170         swapEnabled = true;
1171         lastLpBurnTime = block.timestamp;
1172     }
1173 
1174     // remove limits after token is stable
1175     function removeLimits() external onlyOwner returns (bool) {
1176         limitsInEffect = false;
1177         return true;
1178     }
1179 
1180     // disable Transfer delay - cannot be reenabled
1181     function disableTransferDelay() external onlyOwner returns (bool) {
1182         transferDelayEnabled = false;
1183         return true;
1184     }
1185 
1186     // change the minimum amount of tokens to sell from fees
1187     function updateSwapTokensAtAmount(uint256 newAmount)
1188         external
1189         onlyOwner
1190         returns (bool)
1191     {
1192         require(
1193             newAmount >= (totalSupply() * 1) / 100000,
1194             "Swap amount cannot be lower than 0.001% total supply."
1195         );
1196         require(
1197             newAmount <= (totalSupply() * 5) / 1000,
1198             "Swap amount cannot be higher than 0.5% total supply."
1199         );
1200         swapTokensAtAmount = newAmount;
1201         return true;
1202     }
1203 
1204     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1205         require(
1206             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1207             "Cannot set maxTransactionAmount lower than 0.1%"
1208         );
1209         maxTransactionAmount = newNum * (10**18);
1210     }
1211 
1212     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1213         require(
1214             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1215             "Cannot set maxWallet lower than 0.5%"
1216         );
1217         maxWallet = newNum * (10**18);
1218     }
1219 
1220     function excludeFromMaxTransaction(address updAds, bool isEx)
1221         public
1222         onlyOwner
1223     {
1224         _isExcludedMaxTransactionAmount[updAds] = isEx;
1225     }
1226 
1227     // only use to disable contract sales if absolutely necessary (emergency use only)
1228     function updateSwapEnabled(bool enabled) external onlyOwner {
1229         swapEnabled = enabled;
1230     }
1231 
1232     function updateBuyFees(
1233         uint256 _marketingFee,
1234         uint256 _liquidityFee,
1235         uint256 _EcoFee
1236     ) external onlyOwner {
1237         buyMarketingFee = _marketingFee;
1238         buyLiquidityFee = _liquidityFee;
1239         buyEcoFee = _EcoFee;
1240         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyEcoFee;
1241         require(buyTotalFees <= 100, "");
1242     }
1243 
1244     function updateSellFees(
1245         uint256 _marketingFee,
1246         uint256 _liquidityFee,
1247         uint256 _EcoFee
1248     ) external onlyOwner {
1249         sellMarketingFee = _marketingFee;
1250         sellLiquidityFee = _liquidityFee;
1251         sellEcoFee = _EcoFee;
1252         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellEcoFee;
1253         require(sellTotalFees <= 100, "");
1254     }
1255 
1256     function excludeFromFees(address account, bool excluded) public onlyOwner {
1257         _isExcludedFromFees[account] = excluded;
1258         emit ExcludeFromFees(account, excluded);
1259     }
1260 
1261     function setAutomatedMarketMakerPair(address pair, bool value)
1262         public
1263         onlyOwner
1264     {
1265         require(
1266             pair != uniswapV2Pair,
1267             "The pair cannot be removed from automatedMarketMakerPairs"
1268         );
1269 
1270         _setAutomatedMarketMakerPair(pair, value);
1271     }
1272 
1273     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1274         automatedMarketMakerPairs[pair] = value;
1275 
1276         emit SetAutomatedMarketMakerPair(pair, value);
1277     }
1278 
1279     function updateMarketingWallet(address newMarketingWallet)
1280         external
1281         onlyOwner
1282     {
1283         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1284         marketingWallet = newMarketingWallet;
1285     }
1286 
1287     function updateEcoWallet(address newWallet) external onlyOwner {
1288         emit EcoWalletUpdated(newWallet, EcoWallet);
1289         EcoWallet = newWallet;
1290     }
1291 
1292     function isExcludedFromFees(address account) public view returns (bool) {
1293         return _isExcludedFromFees[account];
1294     }
1295 
1296     event BoughtEarly(address indexed sniper);
1297 
1298     function _transfer(
1299         address from,
1300         address to,
1301         uint256 amount
1302     ) internal override {
1303         require(from != address(0), "ERC20: transfer from the zero address");
1304         require(to != address(0), "ERC20: transfer to the zero address");
1305 
1306         if (amount == 0) {
1307             super._transfer(from, to, 0);
1308             return;
1309         }
1310 
1311         if (limitsInEffect) {
1312             if (
1313                 from != owner() &&
1314                 to != owner() &&
1315                 to != address(0) &&
1316                 to != address(0xdead) &&
1317                 !swapping
1318             ) {
1319                 if (!tradingActive) {
1320                     require(
1321                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1322                         "Trading is not active."
1323                     );
1324                 }
1325 
1326                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1327                 if (transferDelayEnabled) {
1328                     if (
1329                         to != owner() &&
1330                         to != address(uniswapV2Router) &&
1331                         to != address(uniswapV2Pair)
1332                     ) {
1333                         require(
1334                             _holderLastTransferTimestamp[tx.origin] <
1335                                 block.number,
1336                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1337                         );
1338                         _holderLastTransferTimestamp[tx.origin] = block.number;
1339                     }
1340                 }
1341 
1342                 //when buy
1343                 if (
1344                     automatedMarketMakerPairs[from] &&
1345                     !_isExcludedMaxTransactionAmount[to]
1346                 ) {
1347                     require(
1348                         amount <= maxTransactionAmount,
1349                         "Buy transfer amount exceeds the maxTransactionAmount."
1350                     );
1351                     require(
1352                         amount + balanceOf(to) <= maxWallet,
1353                         "Max wallet exceeded"
1354                     );
1355                 }
1356                 //when sell
1357                 else if (
1358                     automatedMarketMakerPairs[to] &&
1359                     !_isExcludedMaxTransactionAmount[from]
1360                 ) {
1361                     require(
1362                         amount <= maxTransactionAmount,
1363                         "Sell transfer amount exceeds the maxTransactionAmount."
1364                     );
1365                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1366                     require(
1367                         amount + balanceOf(to) <= maxWallet,
1368                         "Max wallet exceeded"
1369                     );
1370                 }
1371             }
1372         }
1373 
1374         uint256 contractTokenBalance = balanceOf(address(this));
1375 
1376         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1377 
1378         if (
1379             canSwap &&
1380             swapEnabled &&
1381             !swapping &&
1382             !automatedMarketMakerPairs[from] &&
1383             !_isExcludedFromFees[from] &&
1384             !_isExcludedFromFees[to]
1385         ) {
1386             swapping = true;
1387 
1388             swapBack();
1389 
1390             swapping = false;
1391         }
1392 
1393         if (
1394             !swapping &&
1395             automatedMarketMakerPairs[to] &&
1396             lpBurnEnabled &&
1397             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1398             !_isExcludedFromFees[from]
1399         ) {
1400             autoBurnLiquidityPairTokens();
1401         }
1402 
1403         bool takeFee = !swapping;
1404 
1405         // if any account belongs to _isExcludedFromFee account then remove the fee
1406         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1407             takeFee = false;
1408         }
1409 
1410         uint256 fees = 0;
1411         // only take fees on buys/sells, do not take on wallet transfers
1412         if (takeFee) {
1413             // on sell
1414             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1415                 fees = amount.mul(sellTotalFees).div(100);
1416                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1417                 tokensForDev += (fees * sellEcoFee) / sellTotalFees;
1418                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1419             }
1420             // on buy
1421             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1422                 fees = amount.mul(buyTotalFees).div(100);
1423                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1424                 tokensForDev += (fees * buyEcoFee) / buyTotalFees;
1425                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1426             }
1427 
1428             if (fees > 0) {
1429                 super._transfer(from, address(this), fees);
1430             }
1431 
1432             amount -= fees;
1433         }
1434 
1435         super._transfer(from, to, amount);
1436     }
1437 
1438     function swapTokensForEth(uint256 tokenAmount) private {
1439         // generate the uniswap pair path of token -> weth
1440         address[] memory path = new address[](2);
1441         path[0] = address(this);
1442         path[1] = uniswapV2Router.WETH();
1443 
1444         _approve(address(this), address(uniswapV2Router), tokenAmount);
1445 
1446         // make the swap
1447         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1448             tokenAmount,
1449             0, // accept any amount of ETH
1450             path,
1451             address(this),
1452             block.timestamp
1453         );
1454     }
1455 
1456     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1457         // approve token transfer to cover all possible scenarios
1458         _approve(address(this), address(uniswapV2Router), tokenAmount);
1459 
1460         // add the liquidity
1461         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1462             address(this),
1463             tokenAmount,
1464             0, // slippage is unavoidable
1465             0, // slippage is unavoidable
1466             deadAddress,
1467             block.timestamp
1468         );
1469     }
1470 
1471     function swapBack() private {
1472         uint256 contractBalance = balanceOf(address(this));
1473         uint256 totalTokensToSwap = tokensForLiquidity +
1474             tokensForMarketing +
1475             tokensForDev;
1476         bool success;
1477 
1478         if (contractBalance == 0 || totalTokensToSwap == 0) {
1479             return;
1480         }
1481 
1482         if (contractBalance > swapTokensAtAmount * 20) {
1483             contractBalance = swapTokensAtAmount * 20;
1484         }
1485 
1486         // Halve the amount of liquidity tokens
1487         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1488             totalTokensToSwap /
1489             2;
1490         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1491 
1492         uint256 initialETHBalance = address(this).balance;
1493 
1494         swapTokensForEth(amountToSwapForETH);
1495 
1496         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1497 
1498         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1499             totalTokensToSwap
1500         );
1501         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1502 
1503         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1504 
1505         tokensForLiquidity = 0;
1506         tokensForMarketing = 0;
1507         tokensForDev = 0;
1508 
1509         (success, ) = address(EcoWallet).call{value: ethForDev}("");
1510 
1511         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1512             addLiquidity(liquidityTokens, ethForLiquidity);
1513             emit SwapAndLiquify(
1514                 amountToSwapForETH,
1515                 ethForLiquidity,
1516                 tokensForLiquidity
1517             );
1518         }
1519 
1520         (success, ) = address(marketingWallet).call{
1521             value: address(this).balance
1522         }("");
1523     }
1524 
1525     function setAutoLPBurnSettings(
1526         uint256 _frequencyInSeconds,
1527         uint256 _percent,
1528         bool _Enabled
1529     ) external onlyOwner {
1530         require(
1531             _frequencyInSeconds >= 600,
1532             "cannot set buyback more often than every 10 minutes"
1533         );
1534         require(
1535             _percent <= 1000 && _percent >= 0,
1536             "Must set auto LP burn percent between 0% and 10%"
1537         );
1538         lpBurnFrequency = _frequencyInSeconds;
1539         percentForLPBurn = _percent;
1540         lpBurnEnabled = _Enabled;
1541     }
1542 
1543     function autoBurnLiquidityPairTokens() internal returns (bool) {
1544         lastLpBurnTime = block.timestamp;
1545 
1546         // get balance of liquidity pair
1547         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1548 
1549         // calculate amount to burn
1550         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1551             10000
1552         );
1553 
1554         // pull tokens from pancakePair liquidity and move to dead address permanently
1555         if (amountToBurn > 0) {
1556             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1557         }
1558 
1559         //sync price since this is not in a swap transaction!
1560         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1561         pair.sync();
1562         emit AutoNukeLP();
1563         return true;
1564     }
1565 
1566     function manualBurnLiquidityPairTokens(uint256 percent)
1567         external
1568         onlyOwner
1569         returns (bool)
1570     {
1571         require(
1572             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1573             "Must wait for cooldown to finish"
1574         );
1575         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1576         lastManualLpBurnTime = block.timestamp;
1577 
1578         // get balance of liquidity pair
1579         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1580 
1581         // calculate amount to burn
1582         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1583 
1584         // pull tokens from pancakePair liquidity and move to dead address permanently
1585         if (amountToBurn > 0) {
1586             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1587         }
1588 
1589         //sync price since this is not in a swap transaction!
1590         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1591         pair.sync();
1592         emit ManualNukeLP();
1593         return true;
1594     }
1595 }