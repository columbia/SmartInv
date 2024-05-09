1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15     /**
16      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * IMPORTANT: Beware that changing an allowance with this method brings the risk
21      * that someone may use both the old and the new allowance by unfortunate
22      * transaction ordering. One possible solution to mitigate this race
23      * condition is to first reduce the spender's allowance to 0 and set the
24      * desired value afterwards:
25      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
26      *
27      * Emits an {Approval} event.
28      */
29 
30 abstract contract Ownable is Context {
31     address private _owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor() {
39         _transferOwnership(_msgSender());
40     }
41 
42     /**
43      * @dev Returns the address of the current owner.
44      */
45     function owner() public view virtual returns (address) {
46         return _owner;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(owner() == _msgSender(), "Ownable: caller is not the owner");
54         _;
55     }
56 
57     function renounceOwnership() public virtual onlyOwner {
58         _transferOwnership(address(0));
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Can only be called by the current owner.
64      */
65     function transferOwnership(address newOwner) public virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address");
67         _transferOwnership(newOwner);
68     }
69 
70     /**
71      * @dev Transfers ownership of the contract to a new account (`newOwner`).
72      * Internal function without access restriction.
73      */
74     function _transferOwnership(address newOwner) internal virtual {
75         address oldOwner = _owner;
76         _owner = newOwner;
77         emit OwnershipTransferred(oldOwner, newOwner);
78     }
79 }
80 
81 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
82 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
83 
84 /* pragma solidity ^0.8.0; */
85 
86 /**
87  * @dev Interface of the ERC20 standard as defined in the EIP.
88  */
89 interface IERC20 {
90     /**
91      * @dev Returns the amount of tokens in existence.
92      */
93     function totalSupply() external view returns (uint256);
94 
95     /**
96      * @dev Returns the amount of tokens owned by `account`.
97      */
98     function balanceOf(address account) external view returns (uint256);
99 
100     /**
101      * @dev Moves `amount` tokens from the caller's account to `recipient`.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transfer(address recipient, uint256 amount) external returns (bool);
108 
109     /**
110      * @dev Returns the remaining number of tokens that `spender` will be
111      * allowed to spend on behalf of `owner` through {transferFrom}. This is
112      * zero by default.
113      *
114      * This value changes when {approve} or {transferFrom} are called.
115      */
116     function allowance(address owner, address spender) external view returns (uint256);
117 
118     /**
119      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * IMPORTANT: Beware that changing an allowance with this method brings the risk
124      * that someone may use both the old and the new allowance by unfortunate
125      * transaction ordering. One possible solution to mitigate this race
126      * condition is to first reduce the spender's allowance to 0 and set the
127      * desired value afterwards:
128      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address spender, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Moves `amount` tokens from `sender` to `recipient` using the
136      * allowance mechanism. `amount` is then deducted from the caller's
137      * allowance.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) external returns (bool);
148 
149     /**
150      * @dev Emitted when `value` tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that `value` may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 
157     /**
158      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
159      * a call to {approve}. `value` is the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163 
164 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
165 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
166 
167 /* pragma solidity ^0.8.0; */
168 
169 /* import "../IERC20.sol"; */
170 
171 /**
172  * @dev Interface for the optional metadata functions from the ERC20 standard.
173  *
174  * _Available since v4.1._
175  */
176 interface IERC20Metadata is IERC20 {
177     /**
178      * @dev Returns the name of the token.
179      */
180     function name() external view returns (string memory);
181 
182     /**
183      * @dev Returns the symbol of the token.
184      */
185     function symbol() external view returns (string memory);
186 
187     /**
188      * @dev Returns the decimals places of the token.
189      */
190     function decimals() external view returns (uint8);
191 }
192 
193 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
194 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
195 
196 /* pragma solidity ^0.8.0; */
197 
198 /* import "./IERC20.sol"; */
199 /* import "./extensions/IERC20Metadata.sol"; */
200 /* import "../../utils/Context.sol"; */
201 
202 /**
203  * @dev Implementation of the {IERC20} interface.
204  *
205  * This implementation is agnostic to the way tokens are created. This means
206  * that a supply mechanism has to be added in a derived contract using {_mint}.
207  * For a generic mechanism see {ERC20PresetMinterPauser}.
208  *
209  * TIP: For a detailed writeup see our guide
210  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
211  * to implement supply mechanisms].
212  *
213  * We have followed general OpenZeppelin Contracts guidelines: functions revert
214  * instead returning `false` on failure. This behavior is nonetheless
215  * conventional and does not conflict with the expectations of ERC20
216  * applications.
217  *
218  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
219  * This allows applications to reconstruct the allowance for all accounts just
220  * by listening to said events. Other implementations of the EIP may not emit
221  * these events, as it isn't required by the specification.
222  *
223  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
224  * functions have been added to mitigate the well-known issues around setting
225  * allowances. See {IERC20-approve}.
226  */
227 contract ERC20 is Context, IERC20, IERC20Metadata {
228     mapping(address => uint256) private _balances;
229 
230     mapping(address => mapping(address => uint256)) private _allowances;
231 
232     uint256 private _totalSupply;
233 
234     string private _name;
235     string private _symbol;
236 
237     /**
238      * @dev Sets the values for {name} and {symbol}.
239      *
240      * The default value of {decimals} is 18. To select a different value for
241      * {decimals} you should overload it.
242      *
243      * All two of these values are immutable: they can only be set once during
244      * construction.
245      */
246     constructor(string memory name_, string memory symbol_) {
247         _name = name_;
248         _symbol = symbol_;
249     }
250 
251     /**
252      * @dev Returns the name of the token.
253      */
254     function name() public view virtual override returns (string memory) {
255         return _name;
256     }
257 
258     /**
259      * @dev Returns the symbol of the token, usually a shorter version of the
260      * name.
261      */
262     function symbol() public view virtual override returns (string memory) {
263         return _symbol;
264     }
265 
266     /**
267      * @dev Returns the number of decimals used to get its user representation.
268      * For example, if `decimals` equals `2`, a balance of `505` tokens should
269      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
270      *
271      * Tokens usually opt for a value of 18, imitating the relationship between
272      * Ether and Wei. This is the value {ERC20} uses, unless this function is
273      * overridden;
274      *
275      * NOTE: This information is only used for _display_ purposes: it in
276      * no way affects any of the arithmetic of the contract, including
277      * {IERC20-balanceOf} and {IERC20-transfer}.
278      */
279     function decimals() public view virtual override returns (uint8) {
280         return 18;
281     }
282 
283     /**
284      * @dev See {IERC20-totalSupply}.
285      */
286     function totalSupply() public view virtual override returns (uint256) {
287         return _totalSupply;
288     }
289 
290     /**
291      * @dev See {IERC20-balanceOf}.
292      */
293     function balanceOf(address account) public view virtual override returns (uint256) {
294         return _balances[account];
295     }
296 
297     /**
298      * @dev See {IERC20-transfer}.
299      *
300      * Requirements:
301      *
302      * - `recipient` cannot be the zero address.
303      * - the caller must have a balance of at least `amount`.
304      */
305     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
306         _transfer(_msgSender(), recipient, amount);
307         return true;
308     }
309 
310     /**
311      * @dev See {IERC20-allowance}.
312      */
313     function allowance(address owner, address spender) public view virtual override returns (uint256) {
314         return _allowances[owner][spender];
315     }
316 
317     /**
318      * @dev See {IERC20-approve}.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function approve(address spender, uint256 amount) public virtual override returns (bool) {
325         _approve(_msgSender(), spender, amount);
326         return true;
327     }
328 
329     /**
330      * @dev See {IERC20-transferFrom}.
331      *
332      * Emits an {Approval} event indicating the updated allowance. This is not
333      * required by the EIP. See the note at the beginning of {ERC20}.
334      *
335      * Requirements:
336      *
337      * - `sender` and `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `amount`.
339      * - the caller must have allowance for ``sender``'s tokens of at least
340      * `amount`.
341      */
342     function transferFrom(
343         address sender,
344         address recipient,
345         uint256 amount
346     ) public virtual override returns (bool) {
347         _transfer(sender, recipient, amount);
348 
349         uint256 currentAllowance = _allowances[sender][_msgSender()];
350         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
351         unchecked {
352             _approve(sender, _msgSender(), currentAllowance - amount);
353         }
354 
355         return true;
356     }
357 
358     /**
359      * @dev Atomically increases the allowance granted to `spender` by the caller.
360      *
361      * This is an alternative to {approve} that can be used as a mitigation for
362      * problems described in {IERC20-approve}.
363      *
364      * Emits an {Approval} event indicating the updated allowance.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      */
370     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
371         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
372         return true;
373     }
374 
375     /**
376      * @dev Atomically decreases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      * - `spender` must have allowance for the caller of at least
387      * `subtractedValue`.
388      */
389     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
390         uint256 currentAllowance = _allowances[_msgSender()][spender];
391         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
392         unchecked {
393             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
394         }
395 
396         return true;
397     }
398 
399     /**
400      * @dev Moves `amount` of tokens from `sender` to `recipient`.
401      *
402      * This internal function is equivalent to {transfer}, and can be used to
403      * e.g. implement automatic token fees, slashing mechanisms, etc.
404      *
405      * Emits a {Transfer} event.
406      *
407      * Requirements:
408      *
409      * - `sender` cannot be the zero address.
410      * - `recipient` cannot be the zero address.
411      * - `sender` must have a balance of at least `amount`.
412      */
413     function _transfer(
414         address sender,
415         address recipient,
416         uint256 amount
417     ) internal virtual {
418         require(sender != address(0), "ERC20: transfer from the zero address");
419         require(recipient != address(0), "ERC20: transfer to the zero address");
420 
421         _beforeTokenTransfer(sender, recipient, amount);
422 
423         uint256 senderBalance = _balances[sender];
424         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
425         unchecked {
426             _balances[sender] = senderBalance - amount;
427         }
428         _balances[recipient] += amount;
429 
430         emit Transfer(sender, recipient, amount);
431 
432         _afterTokenTransfer(sender, recipient, amount);
433     }
434 
435     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
436      * the total supply.
437      *
438      * Emits a {Transfer} event with `from` set to the zero address.
439      *
440      * Requirements:
441      *
442      * - `account` cannot be the zero address.
443      */
444     function _mint(address account, uint256 amount) internal virtual {
445         require(account != address(0), "ERC20: mint to the zero address");
446 
447         _beforeTokenTransfer(address(0), account, amount);
448 
449         _totalSupply += amount;
450         _balances[account] += amount;
451         emit Transfer(address(0), account, amount);
452 
453         _afterTokenTransfer(address(0), account, amount);
454     }
455 
456     /**
457      * @dev Destroys `amount` tokens from `account`, reducing the
458      * total supply.
459      *
460      * Emits a {Transfer} event with `to` set to the zero address.
461      *
462      * Requirements:
463      *
464      * - `account` cannot be the zero address.
465      * - `account` must have at least `amount` tokens.
466      */
467     function _burn(address account, uint256 amount) internal virtual {
468         require(account != address(0), "ERC20: burn from the zero address");
469 
470         _beforeTokenTransfer(account, address(0), amount);
471 
472         uint256 accountBalance = _balances[account];
473         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
474         unchecked {
475             _balances[account] = accountBalance - amount;
476         }
477         _totalSupply -= amount;
478 
479         emit Transfer(account, address(0), amount);
480 
481         _afterTokenTransfer(account, address(0), amount);
482     }
483 
484     /**
485      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
486      *
487      * This internal function is equivalent to `approve`, and can be used to
488      * e.g. set automatic allowances for certain subsystems, etc.
489      *
490      * Emits an {Approval} event.
491      *
492      * Requirements:
493      *
494      * - `owner` cannot be the zero address.
495      * - `spender` cannot be the zero address.
496      */
497     function _approve(
498         address owner,
499         address spender,
500         uint256 amount
501     ) internal virtual {
502         require(owner != address(0), "ERC20: approve from the zero address");
503         require(spender != address(0), "ERC20: approve to the zero address");
504 
505         _allowances[owner][spender] = amount;
506         emit Approval(owner, spender, amount);
507     }
508 
509     /**
510      * @dev Hook that is called before any transfer of tokens. This includes
511      * minting and burning.
512      *
513      * Calling conditions:
514      *
515      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
516      * will be transferred to `to`.
517      * - when `from` is zero, `amount` tokens will be minted for `to`.
518      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
519      * - `from` and `to` are never both zero.
520      *
521      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
522      */
523     function _beforeTokenTransfer(
524         address from,
525         address to,
526         uint256 amount
527     ) internal virtual {}
528 
529     /**
530      * @dev Hook that is called after any transfer of tokens. This includes
531      * minting and burning.
532      *
533      * Calling conditions:
534      *
535      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
536      * has been transferred to `to`.
537      * - when `from` is zero, `amount` tokens have been minted for `to`.
538      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
539      * - `from` and `to` are never both zero.
540      *
541      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
542      */
543     function _afterTokenTransfer(
544         address from,
545         address to,
546         uint256 amount
547     ) internal virtual {}
548 }
549 
550 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
551 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
552 
553 /* pragma solidity ^0.8.0; */
554 
555 // CAUTION
556 // This version of SafeMath should only be used with Solidity 0.8 or later,
557 // because it relies on the compiler's built in overflow checks.
558 
559 /**
560  * @dev Wrappers over Solidity's arithmetic operations.
561  *
562  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
563  * now has built in overflow checking.
564  */
565 library SafeMath {
566     /**
567      * @dev Returns the addition of two unsigned integers, with an overflow flag.
568      *
569      * _Available since v3.4._
570      */
571     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
572         unchecked {
573             uint256 c = a + b;
574             if (c < a) return (false, 0);
575             return (true, c);
576         }
577     }
578 
579     /**
580      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
581      *
582      * _Available since v3.4._
583      */
584     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
585         unchecked {
586             if (b > a) return (false, 0);
587             return (true, a - b);
588         }
589     }
590 
591     /**
592      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
593      *
594      * _Available since v3.4._
595      */
596     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
597         unchecked {
598             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
599             // benefit is lost if 'b' is also tested.
600             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
601             if (a == 0) return (true, 0);
602             uint256 c = a * b;
603             if (c / a != b) return (false, 0);
604             return (true, c);
605         }
606     }
607 
608     /**
609      * @dev Returns the division of two unsigned integers, with a division by zero flag.
610      *
611      * _Available since v3.4._
612      */
613     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
614         unchecked {
615             if (b == 0) return (false, 0);
616             return (true, a / b);
617         }
618     }
619 
620     /**
621      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
622      *
623      * _Available since v3.4._
624      */
625     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
626         unchecked {
627             if (b == 0) return (false, 0);
628             return (true, a % b);
629         }
630     }
631 
632     /**
633      * @dev Returns the addition of two unsigned integers, reverting on
634      * overflow.
635      *
636      * Counterpart to Solidity's `+` operator.
637      *
638      * Requirements:
639      *
640      * - Addition cannot overflow.
641      */
642     function add(uint256 a, uint256 b) internal pure returns (uint256) {
643         return a + b;
644     }
645 
646     /**
647      * @dev Returns the subtraction of two unsigned integers, reverting on
648      * overflow (when the result is negative).
649      *
650      * Counterpart to Solidity's `-` operator.
651      *
652      * Requirements:
653      *
654      * - Subtraction cannot overflow.
655      */
656     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
657         return a - b;
658     }
659 
660     /**
661      * @dev Returns the multiplication of two unsigned integers, reverting on
662      * overflow.
663      *
664      * Counterpart to Solidity's `*` operator.
665      *
666      * Requirements:
667      *
668      * - Multiplication cannot overflow.
669      */
670     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
671         return a * b;
672     }
673 
674     /**
675      * @dev Returns the integer division of two unsigned integers, reverting on
676      * division by zero. The result is rounded towards zero.
677      *
678      * Counterpart to Solidity's `/` operator.
679      *
680      * Requirements:
681      *
682      * - The divisor cannot be zero.
683      */
684     function div(uint256 a, uint256 b) internal pure returns (uint256) {
685         return a / b;
686     }
687 
688     /**
689      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
690      * reverting when dividing by zero.
691      *
692      * Counterpart to Solidity's `%` operator. This function uses a `revert`
693      * opcode (which leaves remaining gas untouched) while Solidity uses an
694      * invalid opcode to revert (consuming all remaining gas).
695      *
696      * Requirements:
697      *
698      * - The divisor cannot be zero.
699      */
700     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
701         return a % b;
702     }
703 
704     /**
705      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
706      * overflow (when the result is negative).
707      *
708      * CAUTION: This function is deprecated because it requires allocating memory for the error
709      * message unnecessarily. For custom revert reasons use {trySub}.
710      *
711      * Counterpart to Solidity's `-` operator.
712      *
713      * Requirements:
714      *
715      * - Subtraction cannot overflow.
716      */
717     function sub(
718         uint256 a,
719         uint256 b,
720         string memory errorMessage
721     ) internal pure returns (uint256) {
722         unchecked {
723             require(b <= a, errorMessage);
724             return a - b;
725         }
726     }
727 
728     /**
729      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
730      * division by zero. The result is rounded towards zero.
731      *
732      * Counterpart to Solidity's `/` operator. Note: this function uses a
733      * `revert` opcode (which leaves remaining gas untouched) while Solidity
734      * uses an invalid opcode to revert (consuming all remaining gas).
735      *
736      * Requirements:
737      *
738      * - The divisor cannot be zero.
739      */
740     function div(
741         uint256 a,
742         uint256 b,
743         string memory errorMessage
744     ) internal pure returns (uint256) {
745         unchecked {
746             require(b > 0, errorMessage);
747             return a / b;
748         }
749     }
750 
751     /**
752      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
753      * reverting with custom message when dividing by zero.
754      *
755      * CAUTION: This function is deprecated because it requires allocating memory for the error
756      * message unnecessarily. For custom revert reasons use {tryMod}.
757      *
758      * Counterpart to Solidity's `%` operator. This function uses a `revert`
759      * opcode (which leaves remaining gas untouched) while Solidity uses an
760      * invalid opcode to revert (consuming all remaining gas).
761      *
762      * Requirements:
763      *
764      * - The divisor cannot be zero.
765      */
766     function mod(
767         uint256 a,
768         uint256 b,
769         string memory errorMessage
770     ) internal pure returns (uint256) {
771         unchecked {
772             require(b > 0, errorMessage);
773             return a % b;
774         }
775     }
776 }
777 
778 ////// src/IUniswapV2Factory.sol
779 /* pragma solidity 0.8.10; */
780 /* pragma experimental ABIEncoderV2; */
781 
782 interface IUniswapV2Factory {
783     event PairCreated(
784         address indexed token0,
785         address indexed token1,
786         address pair,
787         uint256
788     );
789 
790     function feeTo() external view returns (address);
791 
792     function feeToSetter() external view returns (address);
793 
794     function getPair(address tokenA, address tokenB)
795         external
796         view
797         returns (address pair);
798 
799     function allPairs(uint256) external view returns (address pair);
800 
801     function allPairsLength() external view returns (uint256);
802 
803     function createPair(address tokenA, address tokenB)
804         external
805         returns (address pair);
806 
807     function setFeeTo(address) external;
808 
809     function setFeeToSetter(address) external;
810 }
811 
812 ////// src/IUniswapV2Pair.sol
813 /* pragma solidity 0.8.10; */
814 /* pragma experimental ABIEncoderV2; */
815 
816 interface IUniswapV2Pair {
817     event Approval(
818         address indexed owner,
819         address indexed spender,
820         uint256 value
821     );
822     event Transfer(address indexed from, address indexed to, uint256 value);
823 
824     function name() external pure returns (string memory);
825 
826     function symbol() external pure returns (string memory);
827 
828     function decimals() external pure returns (uint8);
829 
830     function totalSupply() external view returns (uint256);
831 
832     function balanceOf(address owner) external view returns (uint256);
833 
834     function allowance(address owner, address spender)
835         external
836         view
837         returns (uint256);
838 
839     function approve(address spender, uint256 value) external returns (bool);
840 
841     function transfer(address to, uint256 value) external returns (bool);
842 
843     function transferFrom(
844         address from,
845         address to,
846         uint256 value
847     ) external returns (bool);
848 
849     function DOMAIN_SEPARATOR() external view returns (bytes32);
850 
851     function PERMIT_TYPEHASH() external pure returns (bytes32);
852 
853     function nonces(address owner) external view returns (uint256);
854 
855     function permit(
856         address owner,
857         address spender,
858         uint256 value,
859         uint256 deadline,
860         uint8 v,
861         bytes32 r,
862         bytes32 s
863     ) external;
864 
865     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
866     event Burn(
867         address indexed sender,
868         uint256 amount0,
869         uint256 amount1,
870         address indexed to
871     );
872     event Swap(
873         address indexed sender,
874         uint256 amount0In,
875         uint256 amount1In,
876         uint256 amount0Out,
877         uint256 amount1Out,
878         address indexed to
879     );
880     event Sync(uint112 reserve0, uint112 reserve1);
881 
882     function MINIMUM_LIQUIDITY() external pure returns (uint256);
883 
884     function factory() external view returns (address);
885 
886     function token0() external view returns (address);
887 
888     function token1() external view returns (address);
889 
890     function getReserves()
891         external
892         view
893         returns (
894             uint112 reserve0,
895             uint112 reserve1,
896             uint32 blockTimestampLast
897         );
898 
899     function price0CumulativeLast() external view returns (uint256);
900 
901     function price1CumulativeLast() external view returns (uint256);
902 
903     function kLast() external view returns (uint256);
904 
905     function mint(address to) external returns (uint256 liquidity);
906 
907     function burn(address to)
908         external
909         returns (uint256 amount0, uint256 amount1);
910 
911     function swap(
912         uint256 amount0Out,
913         uint256 amount1Out,
914         address to,
915         bytes calldata data
916     ) external;
917 
918     function skim(address to) external;
919 
920     function sync() external;
921 
922     function initialize(address, address) external;
923 }
924 
925 ////// src/IUniswapV2Router02.sol
926 /* pragma solidity 0.8.10; */
927 /* pragma experimental ABIEncoderV2; */
928 
929 interface IUniswapV2Router02 {
930     function factory() external pure returns (address);
931 
932     function WETH() external pure returns (address);
933 
934     function addLiquidity(
935         address tokenA,
936         address tokenB,
937         uint256 amountADesired,
938         uint256 amountBDesired,
939         uint256 amountAMin,
940         uint256 amountBMin,
941         address to,
942         uint256 deadline
943     )
944         external
945         returns (
946             uint256 amountA,
947             uint256 amountB,
948             uint256 liquidity
949         );
950 
951     function addLiquidityETH(
952         address token,
953         uint256 amountTokenDesired,
954         uint256 amountTokenMin,
955         uint256 amountETHMin,
956         address to,
957         uint256 deadline
958     )
959         external
960         payable
961         returns (
962             uint256 amountToken,
963             uint256 amountETH,
964             uint256 liquidity
965         );
966 
967     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
968         uint256 amountIn,
969         uint256 amountOutMin,
970         address[] calldata path,
971         address to,
972         uint256 deadline
973     ) external;
974 
975     function swapExactETHForTokensSupportingFeeOnTransferTokens(
976         uint256 amountOutMin,
977         address[] calldata path,
978         address to,
979         uint256 deadline
980     ) external payable;
981 
982     function swapExactTokensForETHSupportingFeeOnTransferTokens(
983         uint256 amountIn,
984         uint256 amountOutMin,
985         address[] calldata path,
986         address to,
987         uint256 deadline
988     ) external;
989 }
990 
991 /* pragma solidity >=0.8.10; */
992 
993 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
994 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
995 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
996 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
997 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
998 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
999 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1000 
1001 contract BUTERINSTWEET is ERC20, Ownable {
1002     using SafeMath for uint256;
1003 
1004     IUniswapV2Router02 public immutable uniswapV2Router;
1005     address public immutable uniswapV2Pair;
1006     address public constant deadAddress = address(0xdead);
1007 
1008     bool private swapping;
1009 
1010     address public marketingWallet;
1011     address public devWallet;
1012 
1013     uint256 public maxTransactionAmount;
1014     uint256 public swapTokensAtAmount;
1015     uint256 public maxWallet;
1016 
1017     uint256 public percentForLPBurn = 25; // 25 = .25%
1018     bool public lpBurnEnabled = false;
1019     uint256 public lpBurnFrequency = 3600 seconds;
1020     uint256 public lastLpBurnTime;
1021 
1022     uint256 public manualBurnFrequency = 30 minutes;
1023     uint256 public lastManualLpBurnTime;
1024 
1025     bool public limitsInEffect = true;
1026     bool public tradingActive = true;
1027     bool public swapEnabled = true;
1028 
1029     // Anti-bot and anti-whale mappings and variables
1030     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1031     bool public transferDelayEnabled = false;
1032 
1033     uint256 public buyTotalFees;
1034     uint256 public buyMarketingFee;
1035     uint256 public buyLiquidityFee;
1036     uint256 public buyDevFee;
1037 
1038     uint256 public sellTotalFees;
1039     uint256 public sellMarketingFee;
1040     uint256 public sellLiquidityFee;
1041     uint256 public sellDevFee;
1042 
1043     uint256 public tokensForMarketing;
1044     uint256 public tokensForLiquidity;
1045     uint256 public tokensForDev;
1046 
1047     /******************/
1048 
1049     // exlcude from fees and max transaction amount
1050     mapping(address => bool) private _isExcludedFromFees;
1051     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1052 
1053     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1054     // could be subject to a maximum transfer amount
1055     mapping(address => bool) public automatedMarketMakerPairs;
1056 
1057     event UpdateUniswapV2Router(
1058         address indexed newAddress,
1059         address indexed oldAddress
1060     );
1061 
1062     event ExcludeFromFees(address indexed account, bool isExcluded);
1063 
1064     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1065 
1066     event marketingWalletUpdated(
1067         address indexed newWallet,
1068         address indexed oldWallet
1069     );
1070 
1071     event devWalletUpdated(
1072         address indexed newWallet,
1073         address indexed oldWallet
1074     );
1075 
1076     event SwapAndLiquify(
1077         uint256 tokensSwapped,
1078         uint256 ethReceived,
1079         uint256 tokensIntoLiquidity
1080     );
1081 
1082     event AutoNukeLP();
1083 
1084     event ManualNukeLP();
1085 
1086     constructor() ERC20("Monkey Protocol", "Monkey") {
1087         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1088             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1089         );
1090 
1091         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1092         uniswapV2Router = _uniswapV2Router;
1093 
1094         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1095             .createPair(address(this), _uniswapV2Router.WETH());
1096         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1097         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1098 
1099         uint256 _buyMarketingFee = 3;
1100         uint256 _buyLiquidityFee = 0;
1101         uint256 _buyDevFee = 1;
1102 
1103         uint256 _sellMarketingFee = 3;
1104         uint256 _sellLiquidityFee = 0;
1105         uint256 _sellDevFee = 1;
1106 
1107         uint256 totalSupply = 1_000_000_000 * 1e18;
1108 
1109         maxTransactionAmount = 30_000_000 * 1e18; // 3% from total supply maxTransactionAmountTxn
1110         maxWallet = 30_000_000 * 1e18; // 3% from total supply maxWallet
1111         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1112 
1113         buyMarketingFee = _buyMarketingFee;
1114         buyLiquidityFee = _buyLiquidityFee;
1115         buyDevFee = _buyDevFee;
1116         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1117 
1118         sellMarketingFee = _sellMarketingFee;
1119         sellLiquidityFee = _sellLiquidityFee;
1120         sellDevFee = _sellDevFee;
1121         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1122 
1123         marketingWallet = address(0x03072Abaa4Cabc2Fa90879Ca27B29bc6F04ADD88); // set as marketing wallet
1124         devWallet = address(0x03072Abaa4Cabc2Fa90879Ca27B29bc6F04ADD88); // set as dev wallet
1125 
1126         // exclude from paying fees or having max transaction amount
1127         excludeFromFees(owner(), true);
1128         excludeFromFees(address(this), true);
1129         excludeFromFees(address(0xdead), true);
1130 
1131         excludeFromMaxTransaction(owner(), true);
1132         excludeFromMaxTransaction(address(this), true);
1133         excludeFromMaxTransaction(address(0xdead), true);
1134 
1135         /*
1136             _mint is an internal function in ERC20.sol that is only called here,
1137             and CANNOT be called ever again
1138         */
1139         _mint(msg.sender, totalSupply);
1140     }
1141 
1142     receive() external payable {}
1143 
1144     // once enabled, can never be turned off
1145     function enableTrading() external onlyOwner {
1146         tradingActive = true;
1147         swapEnabled = true;
1148         lastLpBurnTime = block.timestamp;
1149     }
1150 
1151     // remove limits after token is stable
1152     function removeLimits() external onlyOwner returns (bool) {
1153         limitsInEffect = false;
1154         return true;
1155     }
1156 
1157     // disable Transfer delay - cannot be reenabled
1158     function disableTransferDelay() external onlyOwner returns (bool) {
1159         transferDelayEnabled = false;
1160         return true;
1161     }
1162 
1163     // change the minimum amount of tokens to sell from fees
1164     function updateSwapTokensAtAmount(uint256 newAmount)
1165         external
1166         onlyOwner
1167         returns (bool)
1168     {
1169         require(
1170             newAmount >= (totalSupply() * 1) / 100000,
1171             "Swap amount cannot be lower than 0.001% total supply."
1172         );
1173         require(
1174             newAmount <= (totalSupply() * 5) / 1000,
1175             "Swap amount cannot be higher than 0.5% total supply."
1176         );
1177         swapTokensAtAmount = newAmount;
1178         return true;
1179     }
1180 
1181     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1182         require(
1183             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1184             "Cannot set maxTransactionAmount lower than 0.1%"
1185         );
1186         maxTransactionAmount = newNum * (10**18);
1187     }
1188 
1189     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1190         require(
1191             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1192             "Cannot set maxWallet lower than 0.5%"
1193         );
1194         maxWallet = newNum * (10**18);
1195     }
1196 
1197     function excludeFromMaxTransaction(address updAds, bool isEx)
1198         public
1199         onlyOwner
1200     {
1201         _isExcludedMaxTransactionAmount[updAds] = isEx;
1202     }
1203 
1204     // only use to disable contract sales if absolutely necessary (emergency use only)
1205     function updateSwapEnabled(bool enabled) external onlyOwner {
1206         swapEnabled = enabled;
1207     }
1208 
1209     function updateBuyFees(
1210         uint256 _marketingFee,
1211         uint256 _liquidityFee,
1212         uint256 _devFee
1213     ) external onlyOwner {
1214         buyMarketingFee = _marketingFee;
1215         buyLiquidityFee = _liquidityFee;
1216         buyDevFee = _devFee;
1217         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1218         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1219     }
1220 
1221     function updateSellFees(
1222         uint256 _marketingFee,
1223         uint256 _liquidityFee,
1224         uint256 _devFee
1225     ) external onlyOwner {
1226         sellMarketingFee = _marketingFee;
1227         sellLiquidityFee = _liquidityFee;
1228         sellDevFee = _devFee;
1229         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1230         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1231     }
1232 
1233     function excludeFromFees(address account, bool excluded) public onlyOwner {
1234         _isExcludedFromFees[account] = excluded;
1235         emit ExcludeFromFees(account, excluded);
1236     }
1237 
1238     function setAutomatedMarketMakerPair(address pair, bool value)
1239         public
1240         onlyOwner
1241     {
1242         require(
1243             pair != uniswapV2Pair,
1244             "The pair cannot be removed from automatedMarketMakerPairs"
1245         );
1246 
1247         _setAutomatedMarketMakerPair(pair, value);
1248     }
1249 
1250     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1251         automatedMarketMakerPairs[pair] = value;
1252 
1253         emit SetAutomatedMarketMakerPair(pair, value);
1254     }
1255 
1256     function updateMarketingWallet(address newMarketingWallet)
1257         external
1258         onlyOwner
1259     {
1260         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1261         marketingWallet = newMarketingWallet;
1262     }
1263 
1264     function updateDevWallet(address newWallet) external onlyOwner {
1265         emit devWalletUpdated(newWallet, devWallet);
1266         devWallet = newWallet;
1267     }
1268 
1269     function isExcludedFromFees(address account) public view returns (bool) {
1270         return _isExcludedFromFees[account];
1271     }
1272 
1273     event BoughtEarly(address indexed sniper);
1274 
1275     function _transfer(
1276         address from,
1277         address to,
1278         uint256 amount
1279     ) internal override {
1280         require(from != address(0), "ERC20: transfer from the zero address");
1281         require(to != address(0), "ERC20: transfer to the zero address");
1282 
1283         if (amount == 0) {
1284             super._transfer(from, to, 0);
1285             return;
1286         }
1287 
1288         if (limitsInEffect) {
1289             if (
1290                 from != owner() &&
1291                 to != owner() &&
1292                 to != address(0) &&
1293                 to != address(0xdead) &&
1294                 !swapping
1295             ) {
1296                 if (!tradingActive) {
1297                     require(
1298                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1299                         "Trading is not active."
1300                     );
1301                 }
1302 
1303                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1304                 if (transferDelayEnabled) {
1305                     if (
1306                         to != owner() &&
1307                         to != address(uniswapV2Router) &&
1308                         to != address(uniswapV2Pair)
1309                     ) {
1310                         require(
1311                             _holderLastTransferTimestamp[tx.origin] <
1312                                 block.number,
1313                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1314                         );
1315                         _holderLastTransferTimestamp[tx.origin] = block.number;
1316                     }
1317                 }
1318 
1319                 //when buy
1320                 if (
1321                     automatedMarketMakerPairs[from] &&
1322                     !_isExcludedMaxTransactionAmount[to]
1323                 ) {
1324                     require(
1325                         amount <= maxTransactionAmount,
1326                         "Buy transfer amount exceeds the maxTransactionAmount."
1327                     );
1328                     require(
1329                         amount + balanceOf(to) <= maxWallet,
1330                         "Max wallet exceeded"
1331                     );
1332                 }
1333                 //when sell
1334                 else if (
1335                     automatedMarketMakerPairs[to] &&
1336                     !_isExcludedMaxTransactionAmount[from]
1337                 ) {
1338                     require(
1339                         amount <= maxTransactionAmount,
1340                         "Sell transfer amount exceeds the maxTransactionAmount."
1341                     );
1342                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1343                     require(
1344                         amount + balanceOf(to) <= maxWallet,
1345                         "Max wallet exceeded"
1346                     );
1347                 }
1348             }
1349         }
1350 
1351         uint256 contractTokenBalance = balanceOf(address(this));
1352 
1353         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1354 
1355         if (
1356             canSwap &&
1357             swapEnabled &&
1358             !swapping &&
1359             !automatedMarketMakerPairs[from] &&
1360             !_isExcludedFromFees[from] &&
1361             !_isExcludedFromFees[to]
1362         ) {
1363             swapping = true;
1364 
1365             swapBack();
1366 
1367             swapping = false;
1368         }
1369 
1370         if (
1371             !swapping &&
1372             automatedMarketMakerPairs[to] &&
1373             lpBurnEnabled &&
1374             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1375             !_isExcludedFromFees[from]
1376         ) {
1377             autoBurnLiquidityPairTokens();
1378         }
1379 
1380         bool takeFee = !swapping;
1381 
1382         // if any account belongs to _isExcludedFromFee account then remove the fee
1383         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1384             takeFee = false;
1385         }
1386 
1387         uint256 fees = 0;
1388         // only take fees on buys/sells, do not take on wallet transfers
1389         if (takeFee) {
1390             // on sell
1391             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1392                 fees = amount.mul(sellTotalFees).div(100);
1393                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1394                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1395                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1396             }
1397             // on buy
1398             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1399                 fees = amount.mul(buyTotalFees).div(100);
1400                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1401                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1402                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1403             }
1404 
1405             if (fees > 0) {
1406                 super._transfer(from, address(this), fees);
1407             }
1408 
1409             amount -= fees;
1410         }
1411 
1412         super._transfer(from, to, amount);
1413     }
1414 
1415     function swapTokensForEth(uint256 tokenAmount) private {
1416         // generate the uniswap pair path of token -> weth
1417         address[] memory path = new address[](2);
1418         path[0] = address(this);
1419         path[1] = uniswapV2Router.WETH();
1420 
1421         _approve(address(this), address(uniswapV2Router), tokenAmount);
1422 
1423         // make the swap
1424         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1425             tokenAmount,
1426             0, // accept any amount of ETH
1427             path,
1428             address(this),
1429             block.timestamp
1430         );
1431     }
1432 
1433     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1434         // approve token transfer to cover all possible scenarios
1435         _approve(address(this), address(uniswapV2Router), tokenAmount);
1436 
1437         // add the liquidity
1438         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1439             address(this),
1440             tokenAmount,
1441             0, // slippage is unavoidable
1442             0, // slippage is unavoidable
1443             deadAddress,
1444             block.timestamp
1445         );
1446     }
1447 
1448     function swapBack() private {
1449         uint256 contractBalance = balanceOf(address(this));
1450         uint256 totalTokensToSwap = tokensForLiquidity +
1451             tokensForMarketing +
1452             tokensForDev;
1453         bool success;
1454 
1455         if (contractBalance == 0 || totalTokensToSwap == 0) {
1456             return;
1457         }
1458 
1459         if (contractBalance > swapTokensAtAmount * 20) {
1460             contractBalance = swapTokensAtAmount * 20;
1461         }
1462 
1463         // Halve the amount of liquidity tokens
1464         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1465             totalTokensToSwap /
1466             2;
1467         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1468 
1469         uint256 initialETHBalance = address(this).balance;
1470 
1471         swapTokensForEth(amountToSwapForETH);
1472 
1473         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1474 
1475         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1476             totalTokensToSwap
1477         );
1478         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1479 
1480         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1481 
1482         tokensForLiquidity = 0;
1483         tokensForMarketing = 0;
1484         tokensForDev = 0;
1485 
1486         (success, ) = address(devWallet).call{value: ethForDev}("");
1487 
1488         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1489             addLiquidity(liquidityTokens, ethForLiquidity);
1490             emit SwapAndLiquify(
1491                 amountToSwapForETH,
1492                 ethForLiquidity,
1493                 tokensForLiquidity
1494             );
1495         }
1496 
1497         (success, ) = address(marketingWallet).call{
1498             value: address(this).balance
1499         }("");
1500     }
1501 
1502     function setAutoLPBurnSettings(
1503         uint256 _frequencyInSeconds,
1504         uint256 _percent,
1505         bool _Enabled
1506     ) external onlyOwner {
1507         require(
1508             _frequencyInSeconds >= 600,
1509             "cannot set buyback more often than every 10 minutes"
1510         );
1511         require(
1512             _percent <= 1000 && _percent >= 0,
1513             "Must set auto LP burn percent between 0% and 10%"
1514         );
1515         lpBurnFrequency = _frequencyInSeconds;
1516         percentForLPBurn = _percent;
1517         lpBurnEnabled = _Enabled;
1518     }
1519 
1520     function autoBurnLiquidityPairTokens() internal returns (bool) {
1521         lastLpBurnTime = block.timestamp;
1522 
1523         // get balance of liquidity pair
1524         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1525 
1526         // calculate amount to burn
1527         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1528             10000
1529         );
1530 
1531         // pull tokens from pancakePair liquidity and move to dead address permanently
1532         if (amountToBurn > 0) {
1533             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1534         }
1535 
1536         //sync price since this is not in a swap transaction!
1537         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1538         pair.sync();
1539         emit AutoNukeLP();
1540         return true;
1541     }
1542 
1543     function manualBurnLiquidityPairTokens(uint256 percent)
1544         external
1545         onlyOwner
1546         returns (bool)
1547     {
1548         require(
1549             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1550             "Must wait for cooldown to finish"
1551         );
1552         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1553         lastManualLpBurnTime = block.timestamp;
1554 
1555         // get balance of liquidity pair
1556         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1557 
1558         // calculate amount to burn
1559         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1560 
1561         // pull tokens from pancakePair liquidity and move to dead address permanently
1562         if (amountToBurn > 0) {
1563             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1564         }
1565 
1566         //sync price since this is not in a swap transaction!
1567         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1568         pair.sync();
1569         emit ManualNukeLP();
1570         return true;
1571     }
1572 }