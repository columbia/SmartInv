1 /*
2 
3     We all dream of being rich through DeFi.
4     We all want financial freedom.
5     We all want Chedda.
6     We all want LOBSTER. 
7 
8     Work together, build community, 
9     and we eat like kings.
10 
11     Lobster Inu - 3/3 Tax
12 
13 */
14 
15 // SPDX-License-Identifier: MIT
16 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
17 pragma experimental ABIEncoderV2;
18 
19 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
20 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
21 
22 /* pragma solidity ^0.8.0; */
23 
24 /**
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
45 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
46 
47 /* pragma solidity ^0.8.0; */
48 
49 /* import "../utils/Context.sol"; */
50 
51 /**
52  * @dev Contract module which provides a basic access control mechanism, where
53  * there is an account (an owner) that can be granted exclusive access to
54  * specific functions.
55  *
56  * By default, the owner account will be the one that deploys the contract. This
57  * can later be changed with {transferOwnership}.
58  *
59  * This module is used through inheritance. It will make available the modifier
60  * `onlyOwner`, which can be applied to your functions to restrict their use to
61  * the owner.
62  */
63 abstract contract Ownable is Context {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     /**
69      * @dev Initializes the contract setting the deployer as the initial owner.
70      */
71     constructor() {
72         _transferOwnership(_msgSender());
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
83      * @dev Throws if called by any account other than the owner.
84      */
85     modifier onlyOwner() {
86         require(owner() == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     /**
91      * @dev Leaves the contract without owner. It will not be possible to call
92      * `onlyOwner` functions anymore. Can only be called by the current owner.
93      *
94      * NOTE: Renouncing ownership will leave the contract without an owner,
95      * thereby removing any functionality that is only available to the owner.
96      */
97     function renounceOwnership() public virtual onlyOwner {
98         _transferOwnership(address(0));
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Can only be called by the current owner.
104      */
105     function transferOwnership(address newOwner) public virtual onlyOwner {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         _transferOwnership(newOwner);
108     }
109 
110     /**
111      * @dev Transfers ownership of the contract to a new account (`newOwner`).
112      * Internal function without access restriction.
113      */
114     function _transferOwnership(address newOwner) internal virtual {
115         address oldOwner = _owner;
116         _owner = newOwner;
117         emit OwnershipTransferred(oldOwner, newOwner);
118     }
119 }
120 
121 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
122 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
123 
124 /* pragma solidity ^0.8.0; */
125 
126 /**
127  * @dev Interface of the ERC20 standard as defined in the EIP.
128  */
129 interface IERC20 {
130     /**
131      * @dev Returns the amount of tokens in existence.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     /**
136      * @dev Returns the amount of tokens owned by `account`.
137      */
138     function balanceOf(address account) external view returns (uint256);
139 
140     /**
141      * @dev Moves `amount` tokens from the caller's account to `recipient`.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transfer(address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Returns the remaining number of tokens that `spender` will be
151      * allowed to spend on behalf of `owner` through {transferFrom}. This is
152      * zero by default.
153      *
154      * This value changes when {approve} or {transferFrom} are called.
155      */
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * IMPORTANT: Beware that changing an allowance with this method brings the risk
164      * that someone may use both the old and the new allowance by unfortunate
165      * transaction ordering. One possible solution to mitigate this race
166      * condition is to first reduce the spender's allowance to 0 and set the
167      * desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * Emits an {Approval} event.
171      */
172     function approve(address spender, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Moves `amount` tokens from `sender` to `recipient` using the
176      * allowance mechanism. `amount` is then deducted from the caller's
177      * allowance.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) external returns (bool);
188 
189     /**
190      * @dev Emitted when `value` tokens are moved from one account (`from`) to
191      * another (`to`).
192      *
193      * Note that `value` may be zero.
194      */
195     event Transfer(address indexed from, address indexed to, uint256 value);
196 
197     /**
198      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
199      * a call to {approve}. `value` is the new allowance.
200      */
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
205 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
206 
207 /* pragma solidity ^0.8.0; */
208 
209 /* import "../IERC20.sol"; */
210 
211 /**
212  * @dev Interface for the optional metadata functions from the ERC20 standard.
213  *
214  * _Available since v4.1._
215  */
216 interface IERC20Metadata is IERC20 {
217     /**
218      * @dev Returns the name of the token.
219      */
220     function name() external view returns (string memory);
221 
222     /**
223      * @dev Returns the symbol of the token.
224      */
225     function symbol() external view returns (string memory);
226 
227     /**
228      * @dev Returns the decimals places of the token.
229      */
230     function decimals() external view returns (uint8);
231 }
232 
233 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
234 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
235 
236 /* pragma solidity ^0.8.0; */
237 
238 /* import "./IERC20.sol"; */
239 /* import "./extensions/IERC20Metadata.sol"; */
240 /* import "../../utils/Context.sol"; */
241 
242 /**
243  * @dev Implementation of the {IERC20} interface.
244  *
245  * This implementation is agnostic to the way tokens are created. This means
246  * that a supply mechanism has to be added in a derived contract using {_mint}.
247  * For a generic mechanism see {ERC20PresetMinterPauser}.
248  *
249  * TIP: For a detailed writeup see our guide
250  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
251  * to implement supply mechanisms].
252  *
253  * We have followed general OpenZeppelin Contracts guidelines: functions revert
254  * instead returning `false` on failure. This behavior is nonetheless
255  * conventional and does not conflict with the expectations of ERC20
256  * applications.
257  *
258  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
259  * This allows applications to reconstruct the allowance for all accounts just
260  * by listening to said events. Other implementations of the EIP may not emit
261  * these events, as it isn't required by the specification.
262  *
263  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
264  * functions have been added to mitigate the well-known issues around setting
265  * allowances. See {IERC20-approve}.
266  */
267 contract ERC20 is Context, IERC20, IERC20Metadata {
268     mapping(address => uint256) private _balances;
269 
270     mapping(address => mapping(address => uint256)) private _allowances;
271 
272     uint256 private _totalSupply;
273 
274     string private _name;
275     string private _symbol;
276 
277     /**
278      * @dev Sets the values for {name} and {symbol}.
279      *
280      * The default value of {decimals} is 18. To select a different value for
281      * {decimals} you should overload it.
282      *
283      * All two of these values are immutable: they can only be set once during
284      * construction.
285      */
286     constructor(string memory name_, string memory symbol_) {
287         _name = name_;
288         _symbol = symbol_;
289     }
290 
291     /**
292      * @dev Returns the name of the token.
293      */
294     function name() public view virtual override returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @dev Returns the symbol of the token, usually a shorter version of the
300      * name.
301      */
302     function symbol() public view virtual override returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307      * @dev Returns the number of decimals used to get its user representation.
308      * For example, if `decimals` equals `2`, a balance of `505` tokens should
309      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
310      *
311      * Tokens usually opt for a value of 18, imitating the relationship between
312      * Ether and Wei. This is the value {ERC20} uses, unless this function is
313      * overridden;
314      *
315      * NOTE: This information is only used for _display_ purposes: it in
316      * no way affects any of the arithmetic of the contract, including
317      * {IERC20-balanceOf} and {IERC20-transfer}.
318      */
319     function decimals() public view virtual override returns (uint8) {
320         return 18;
321     }
322 
323     /**
324      * @dev See {IERC20-totalSupply}.
325      */
326     function totalSupply() public view virtual override returns (uint256) {
327         return _totalSupply;
328     }
329 
330     /**
331      * @dev See {IERC20-balanceOf}.
332      */
333     function balanceOf(address account) public view virtual override returns (uint256) {
334         return _balances[account];
335     }
336 
337     /**
338      * @dev See {IERC20-transfer}.
339      *
340      * Requirements:
341      *
342      * - `recipient` cannot be the zero address.
343      * - the caller must have a balance of at least `amount`.
344      */
345     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
346         _transfer(_msgSender(), recipient, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-allowance}.
352      */
353     function allowance(address owner, address spender) public view virtual override returns (uint256) {
354         return _allowances[owner][spender];
355     }
356 
357     /**
358      * @dev See {IERC20-approve}.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function approve(address spender, uint256 amount) public virtual override returns (bool) {
365         _approve(_msgSender(), spender, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-transferFrom}.
371      *
372      * Emits an {Approval} event indicating the updated allowance. This is not
373      * required by the EIP. See the note at the beginning of {ERC20}.
374      *
375      * Requirements:
376      *
377      * - `sender` and `recipient` cannot be the zero address.
378      * - `sender` must have a balance of at least `amount`.
379      * - the caller must have allowance for ``sender``'s tokens of at least
380      * `amount`.
381      */
382     function transferFrom(
383         address sender,
384         address recipient,
385         uint256 amount
386     ) public virtual override returns (bool) {
387         _transfer(sender, recipient, amount);
388 
389         uint256 currentAllowance = _allowances[sender][_msgSender()];
390         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
391         unchecked {
392             _approve(sender, _msgSender(), currentAllowance - amount);
393         }
394 
395         return true;
396     }
397 
398     /**
399      * @dev Atomically increases the allowance granted to `spender` by the caller.
400      *
401      * This is an alternative to {approve} that can be used as a mitigation for
402      * problems described in {IERC20-approve}.
403      *
404      * Emits an {Approval} event indicating the updated allowance.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      */
410     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
411         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
412         return true;
413     }
414 
415     /**
416      * @dev Atomically decreases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      * - `spender` must have allowance for the caller of at least
427      * `subtractedValue`.
428      */
429     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
430         uint256 currentAllowance = _allowances[_msgSender()][spender];
431         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
432         unchecked {
433             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
434         }
435 
436         return true;
437     }
438 
439     /**
440      * @dev Moves `amount` of tokens from `sender` to `recipient`.
441      *
442      * This internal function is equivalent to {transfer}, and can be used to
443      * e.g. implement automatic token fees, slashing mechanisms, etc.
444      *
445      * Emits a {Transfer} event.
446      *
447      * Requirements:
448      *
449      * - `sender` cannot be the zero address.
450      * - `recipient` cannot be the zero address.
451      * - `sender` must have a balance of at least `amount`.
452      */
453     function _transfer(
454         address sender,
455         address recipient,
456         uint256 amount
457     ) internal virtual {
458         require(sender != address(0), "ERC20: transfer from the zero address");
459         require(recipient != address(0), "ERC20: transfer to the zero address");
460 
461         _beforeTokenTransfer(sender, recipient, amount);
462 
463         uint256 senderBalance = _balances[sender];
464         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
465         unchecked {
466             _balances[sender] = senderBalance - amount;
467         }
468         _balances[recipient] += amount;
469 
470         emit Transfer(sender, recipient, amount);
471 
472         _afterTokenTransfer(sender, recipient, amount);
473     }
474 
475     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
476      * the total supply.
477      *
478      * Emits a {Transfer} event with `from` set to the zero address.
479      *
480      * Requirements:
481      *
482      * - `account` cannot be the zero address.
483      */
484     function _mint(address account, uint256 amount) internal virtual {
485         require(account != address(0), "ERC20: mint to the zero address");
486 
487         _beforeTokenTransfer(address(0), account, amount);
488 
489         _totalSupply += amount;
490         _balances[account] += amount;
491         emit Transfer(address(0), account, amount);
492 
493         _afterTokenTransfer(address(0), account, amount);
494     }
495 
496     /**
497      * @dev Destroys `amount` tokens from `account`, reducing the
498      * total supply.
499      *
500      * Emits a {Transfer} event with `to` set to the zero address.
501      *
502      * Requirements:
503      *
504      * - `account` cannot be the zero address.
505      * - `account` must have at least `amount` tokens.
506      */
507     function _burn(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: burn from the zero address");
509 
510         _beforeTokenTransfer(account, address(0), amount);
511 
512         uint256 accountBalance = _balances[account];
513         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
514         unchecked {
515             _balances[account] = accountBalance - amount;
516         }
517         _totalSupply -= amount;
518 
519         emit Transfer(account, address(0), amount);
520 
521         _afterTokenTransfer(account, address(0), amount);
522     }
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
526      *
527      * This internal function is equivalent to `approve`, and can be used to
528      * e.g. set automatic allowances for certain subsystems, etc.
529      *
530      * Emits an {Approval} event.
531      *
532      * Requirements:
533      *
534      * - `owner` cannot be the zero address.
535      * - `spender` cannot be the zero address.
536      */
537     function _approve(
538         address owner,
539         address spender,
540         uint256 amount
541     ) internal virtual {
542         require(owner != address(0), "ERC20: approve from the zero address");
543         require(spender != address(0), "ERC20: approve to the zero address");
544 
545         _allowances[owner][spender] = amount;
546         emit Approval(owner, spender, amount);
547     }
548 
549     /**
550      * @dev Hook that is called before any transfer of tokens. This includes
551      * minting and burning.
552      *
553      * Calling conditions:
554      *
555      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
556      * will be transferred to `to`.
557      * - when `from` is zero, `amount` tokens will be minted for `to`.
558      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
559      * - `from` and `to` are never both zero.
560      *
561      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
562      */
563     function _beforeTokenTransfer(
564         address from,
565         address to,
566         uint256 amount
567     ) internal virtual {}
568 
569     /**
570      * @dev Hook that is called after any transfer of tokens. This includes
571      * minting and burning.
572      *
573      * Calling conditions:
574      *
575      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
576      * has been transferred to `to`.
577      * - when `from` is zero, `amount` tokens have been minted for `to`.
578      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
579      * - `from` and `to` are never both zero.
580      *
581      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
582      */
583     function _afterTokenTransfer(
584         address from,
585         address to,
586         uint256 amount
587     ) internal virtual {}
588 }
589 
590 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
591 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
592 
593 /* pragma solidity ^0.8.0; */
594 
595 // CAUTION
596 // This version of SafeMath should only be used with Solidity 0.8 or later,
597 // because it relies on the compiler's built in overflow checks.
598 
599 /**
600  * @dev Wrappers over Solidity's arithmetic operations.
601  *
602  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
603  * now has built in overflow checking.
604  */
605 library SafeMath {
606     /**
607      * @dev Returns the addition of two unsigned integers, with an overflow flag.
608      *
609      * _Available since v3.4._
610      */
611     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
612         unchecked {
613             uint256 c = a + b;
614             if (c < a) return (false, 0);
615             return (true, c);
616         }
617     }
618 
619     /**
620      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
621      *
622      * _Available since v3.4._
623      */
624     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
625         unchecked {
626             if (b > a) return (false, 0);
627             return (true, a - b);
628         }
629     }
630 
631     /**
632      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
633      *
634      * _Available since v3.4._
635      */
636     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
637         unchecked {
638             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
639             // benefit is lost if 'b' is also tested.
640             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
641             if (a == 0) return (true, 0);
642             uint256 c = a * b;
643             if (c / a != b) return (false, 0);
644             return (true, c);
645         }
646     }
647 
648     /**
649      * @dev Returns the division of two unsigned integers, with a division by zero flag.
650      *
651      * _Available since v3.4._
652      */
653     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
654         unchecked {
655             if (b == 0) return (false, 0);
656             return (true, a / b);
657         }
658     }
659 
660     /**
661      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
662      *
663      * _Available since v3.4._
664      */
665     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
666         unchecked {
667             if (b == 0) return (false, 0);
668             return (true, a % b);
669         }
670     }
671 
672     /**
673      * @dev Returns the addition of two unsigned integers, reverting on
674      * overflow.
675      *
676      * Counterpart to Solidity's `+` operator.
677      *
678      * Requirements:
679      *
680      * - Addition cannot overflow.
681      */
682     function add(uint256 a, uint256 b) internal pure returns (uint256) {
683         return a + b;
684     }
685 
686     /**
687      * @dev Returns the subtraction of two unsigned integers, reverting on
688      * overflow (when the result is negative).
689      *
690      * Counterpart to Solidity's `-` operator.
691      *
692      * Requirements:
693      *
694      * - Subtraction cannot overflow.
695      */
696     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
697         return a - b;
698     }
699 
700     /**
701      * @dev Returns the multiplication of two unsigned integers, reverting on
702      * overflow.
703      *
704      * Counterpart to Solidity's `*` operator.
705      *
706      * Requirements:
707      *
708      * - Multiplication cannot overflow.
709      */
710     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
711         return a * b;
712     }
713 
714     /**
715      * @dev Returns the integer division of two unsigned integers, reverting on
716      * division by zero. The result is rounded towards zero.
717      *
718      * Counterpart to Solidity's `/` operator.
719      *
720      * Requirements:
721      *
722      * - The divisor cannot be zero.
723      */
724     function div(uint256 a, uint256 b) internal pure returns (uint256) {
725         return a / b;
726     }
727 
728     /**
729      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
730      * reverting when dividing by zero.
731      *
732      * Counterpart to Solidity's `%` operator. This function uses a `revert`
733      * opcode (which leaves remaining gas untouched) while Solidity uses an
734      * invalid opcode to revert (consuming all remaining gas).
735      *
736      * Requirements:
737      *
738      * - The divisor cannot be zero.
739      */
740     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
741         return a % b;
742     }
743 
744     /**
745      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
746      * overflow (when the result is negative).
747      *
748      * CAUTION: This function is deprecated because it requires allocating memory for the error
749      * message unnecessarily. For custom revert reasons use {trySub}.
750      *
751      * Counterpart to Solidity's `-` operator.
752      *
753      * Requirements:
754      *
755      * - Subtraction cannot overflow.
756      */
757     function sub(
758         uint256 a,
759         uint256 b,
760         string memory errorMessage
761     ) internal pure returns (uint256) {
762         unchecked {
763             require(b <= a, errorMessage);
764             return a - b;
765         }
766     }
767 
768     /**
769      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
770      * division by zero. The result is rounded towards zero.
771      *
772      * Counterpart to Solidity's `/` operator. Note: this function uses a
773      * `revert` opcode (which leaves remaining gas untouched) while Solidity
774      * uses an invalid opcode to revert (consuming all remaining gas).
775      *
776      * Requirements:
777      *
778      * - The divisor cannot be zero.
779      */
780     function div(
781         uint256 a,
782         uint256 b,
783         string memory errorMessage
784     ) internal pure returns (uint256) {
785         unchecked {
786             require(b > 0, errorMessage);
787             return a / b;
788         }
789     }
790 
791     /**
792      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
793      * reverting with custom message when dividing by zero.
794      *
795      * CAUTION: This function is deprecated because it requires allocating memory for the error
796      * message unnecessarily. For custom revert reasons use {tryMod}.
797      *
798      * Counterpart to Solidity's `%` operator. This function uses a `revert`
799      * opcode (which leaves remaining gas untouched) while Solidity uses an
800      * invalid opcode to revert (consuming all remaining gas).
801      *
802      * Requirements:
803      *
804      * - The divisor cannot be zero.
805      */
806     function mod(
807         uint256 a,
808         uint256 b,
809         string memory errorMessage
810     ) internal pure returns (uint256) {
811         unchecked {
812             require(b > 0, errorMessage);
813             return a % b;
814         }
815     }
816 }
817 
818 /* pragma solidity 0.8.10; */
819 /* pragma experimental ABIEncoderV2; */
820 
821 interface IUniswapV2Factory {
822     event PairCreated(
823         address indexed token0,
824         address indexed token1,
825         address pair,
826         uint256
827     );
828 
829     function feeTo() external view returns (address);
830 
831     function feeToSetter() external view returns (address);
832 
833     function getPair(address tokenA, address tokenB)
834         external
835         view
836         returns (address pair);
837 
838     function allPairs(uint256) external view returns (address pair);
839 
840     function allPairsLength() external view returns (uint256);
841 
842     function createPair(address tokenA, address tokenB)
843         external
844         returns (address pair);
845 
846     function setFeeTo(address) external;
847 
848     function setFeeToSetter(address) external;
849 }
850 
851 /* pragma solidity 0.8.10; */
852 /* pragma experimental ABIEncoderV2; */
853 
854 interface IUniswapV2Pair {
855     event Approval(
856         address indexed owner,
857         address indexed spender,
858         uint256 value
859     );
860     event Transfer(address indexed from, address indexed to, uint256 value);
861 
862     function name() external pure returns (string memory);
863 
864     function symbol() external pure returns (string memory);
865 
866     function decimals() external pure returns (uint8);
867 
868     function totalSupply() external view returns (uint256);
869 
870     function balanceOf(address owner) external view returns (uint256);
871 
872     function allowance(address owner, address spender)
873         external
874         view
875         returns (uint256);
876 
877     function approve(address spender, uint256 value) external returns (bool);
878 
879     function transfer(address to, uint256 value) external returns (bool);
880 
881     function transferFrom(
882         address from,
883         address to,
884         uint256 value
885     ) external returns (bool);
886 
887     function DOMAIN_SEPARATOR() external view returns (bytes32);
888 
889     function PERMIT_TYPEHASH() external pure returns (bytes32);
890 
891     function nonces(address owner) external view returns (uint256);
892 
893     function permit(
894         address owner,
895         address spender,
896         uint256 value,
897         uint256 deadline,
898         uint8 v,
899         bytes32 r,
900         bytes32 s
901     ) external;
902 
903     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
904     event Burn(
905         address indexed sender,
906         uint256 amount0,
907         uint256 amount1,
908         address indexed to
909     );
910     event Swap(
911         address indexed sender,
912         uint256 amount0In,
913         uint256 amount1In,
914         uint256 amount0Out,
915         uint256 amount1Out,
916         address indexed to
917     );
918     event Sync(uint112 reserve0, uint112 reserve1);
919 
920     function MINIMUM_LIQUIDITY() external pure returns (uint256);
921 
922     function factory() external view returns (address);
923 
924     function token0() external view returns (address);
925 
926     function token1() external view returns (address);
927 
928     function getReserves()
929         external
930         view
931         returns (
932             uint112 reserve0,
933             uint112 reserve1,
934             uint32 blockTimestampLast
935         );
936 
937     function price0CumulativeLast() external view returns (uint256);
938 
939     function price1CumulativeLast() external view returns (uint256);
940 
941     function kLast() external view returns (uint256);
942 
943     function mint(address to) external returns (uint256 liquidity);
944 
945     function burn(address to)
946         external
947         returns (uint256 amount0, uint256 amount1);
948 
949     function swap(
950         uint256 amount0Out,
951         uint256 amount1Out,
952         address to,
953         bytes calldata data
954     ) external;
955 
956     function skim(address to) external;
957 
958     function sync() external;
959 
960     function initialize(address, address) external;
961 }
962 
963 /* pragma solidity 0.8.10; */
964 /* pragma experimental ABIEncoderV2; */
965 
966 interface IUniswapV2Router02 {
967     function factory() external pure returns (address);
968 
969     function WETH() external pure returns (address);
970 
971     function addLiquidity(
972         address tokenA,
973         address tokenB,
974         uint256 amountADesired,
975         uint256 amountBDesired,
976         uint256 amountAMin,
977         uint256 amountBMin,
978         address to,
979         uint256 deadline
980     )
981         external
982         returns (
983             uint256 amountA,
984             uint256 amountB,
985             uint256 liquidity
986         );
987 
988     function addLiquidityETH(
989         address token,
990         uint256 amountTokenDesired,
991         uint256 amountTokenMin,
992         uint256 amountETHMin,
993         address to,
994         uint256 deadline
995     )
996         external
997         payable
998         returns (
999             uint256 amountToken,
1000             uint256 amountETH,
1001             uint256 liquidity
1002         );
1003 
1004     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1005         uint256 amountIn,
1006         uint256 amountOutMin,
1007         address[] calldata path,
1008         address to,
1009         uint256 deadline
1010     ) external;
1011 
1012     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1013         uint256 amountOutMin,
1014         address[] calldata path,
1015         address to,
1016         uint256 deadline
1017     ) external payable;
1018 
1019     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1020         uint256 amountIn,
1021         uint256 amountOutMin,
1022         address[] calldata path,
1023         address to,
1024         uint256 deadline
1025     ) external;
1026 }
1027 
1028 /* pragma solidity >=0.8.10; */
1029 
1030 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1031 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1032 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1033 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1034 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1035 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1036 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1037 
1038 contract Lobster is ERC20, Ownable {
1039     using SafeMath for uint256;
1040 
1041     IUniswapV2Router02 public immutable uniswapV2Router;
1042     address public immutable uniswapV2Pair;
1043     address public constant deadAddress = address(0xdead);
1044 
1045     bool private swapping;
1046 
1047     address public devWallet;
1048 
1049     uint256 public maxTransactionAmount;
1050     uint256 public swapTokensAtAmount;
1051     uint256 public maxWallet;
1052 
1053     bool public limitsInEffect = true;
1054     bool public tradingActive = false;
1055     bool public swapEnabled = false;
1056 
1057     uint256 public buyTotalFees;
1058     uint256 public buyLiquidityFee;
1059     uint256 public buyDevFee;
1060 
1061     uint256 public sellTotalFees;
1062     uint256 public sellLiquidityFee;
1063     uint256 public sellDevFee;
1064 
1065 	uint256 public tokensForLiquidity;
1066     uint256 public tokensForDev;
1067 
1068     /******************/
1069 
1070     // exlcude from fees and max transaction amount
1071     mapping(address => bool) private _isExcludedFromFees;
1072     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1073 
1074     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1075     // could be subject to a maximum transfer amount
1076     mapping(address => bool) public automatedMarketMakerPairs;
1077 
1078     event UpdateUniswapV2Router(
1079         address indexed newAddress,
1080         address indexed oldAddress
1081     );
1082 
1083     event ExcludeFromFees(address indexed account, bool isExcluded);
1084 
1085     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1086 
1087     event SwapAndLiquify(
1088         uint256 tokensSwapped,
1089         uint256 ethReceived,
1090         uint256 tokensIntoLiquidity
1091     );
1092 
1093     constructor() ERC20("Lobster Inu", "\xF0\x9F\xA6\x9E") {
1094         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1095             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1096         );
1097 
1098         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1099         uniswapV2Router = _uniswapV2Router;
1100 
1101         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1102             .createPair(address(this), _uniswapV2Router.WETH());
1103         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1104         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1105 
1106         uint256 _buyLiquidityFee = 0;
1107         uint256 _buyDevFee = 3;
1108 
1109         uint256 _sellLiquidityFee = 0;
1110         uint256 _sellDevFee = 3;
1111 
1112         uint256 totalSupply = 1 * 1e9 * 1e18;
1113 
1114         maxTransactionAmount = 2 * 1e7 * 1e18; // 2% from total supply maxTransactionAmountTxn
1115         maxWallet = 2 * 1e7 * 1e18; // 2% from total supply maxWallet
1116         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1117 
1118         buyLiquidityFee = _buyLiquidityFee;
1119         buyDevFee = _buyDevFee;
1120         buyTotalFees = buyLiquidityFee + buyDevFee;
1121 
1122         sellLiquidityFee = _sellLiquidityFee;
1123         sellDevFee = _sellDevFee;
1124         sellTotalFees = sellLiquidityFee + sellDevFee;
1125 
1126         devWallet = address(0x03B08Ca4A1E7D42C730c93ec7513A36D12cE5136); // set as dev wallet
1127 
1128         // exclude from paying fees or having max transaction amount
1129         excludeFromFees(owner(), true);
1130         excludeFromFees(address(this), true);
1131         excludeFromFees(address(0xdead), true);
1132 
1133         excludeFromMaxTransaction(owner(), true);
1134         excludeFromMaxTransaction(address(this), true);
1135         excludeFromMaxTransaction(address(0xdead), true);
1136 
1137         /*
1138             _mint is an internal function in ERC20.sol that is only called here,
1139             and CANNOT be called ever again
1140         */
1141         _mint(msg.sender, totalSupply);
1142     }
1143 
1144     receive() external payable {}
1145 
1146     // once enabled, can never be turned off
1147     function enableTrading() external onlyOwner {
1148         tradingActive = true;
1149         swapEnabled = true;
1150     }
1151 
1152     // remove limits after token is stable
1153     function removeLimits() external onlyOwner returns (bool) {
1154         limitsInEffect = false;
1155         return true;
1156     }
1157 
1158     // change the minimum amount of tokens to sell from fees
1159     function updateSwapTokensAtAmount(uint256 newAmount)
1160         external
1161         onlyOwner
1162         returns (bool)
1163     {
1164         require(
1165             newAmount >= (totalSupply() * 1) / 100000,
1166             "Swap amount cannot be lower than 0.001% total supply."
1167         );
1168         require(
1169             newAmount <= (totalSupply() * 5) / 1000,
1170             "Swap amount cannot be higher than 0.5% total supply."
1171         );
1172         swapTokensAtAmount = newAmount;
1173         return true;
1174     }
1175 	
1176     function excludeFromMaxTransaction(address updAds, bool isEx)
1177         public
1178         onlyOwner
1179     {
1180         _isExcludedMaxTransactionAmount[updAds] = isEx;
1181     }
1182 
1183     // only use to disable contract sales if absolutely necessary (emergency use only)
1184     function updateSwapEnabled(bool enabled) external onlyOwner {
1185         swapEnabled = enabled;
1186     }
1187 
1188     function excludeFromFees(address account, bool excluded) public onlyOwner {
1189         _isExcludedFromFees[account] = excluded;
1190         emit ExcludeFromFees(account, excluded);
1191     }
1192 
1193     function setAutomatedMarketMakerPair(address pair, bool value)
1194         public
1195         onlyOwner
1196     {
1197         require(
1198             pair != uniswapV2Pair,
1199             "The pair cannot be removed from automatedMarketMakerPairs"
1200         );
1201 
1202         _setAutomatedMarketMakerPair(pair, value);
1203     }
1204 
1205     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1206         automatedMarketMakerPairs[pair] = value;
1207 
1208         emit SetAutomatedMarketMakerPair(pair, value);
1209     }
1210 
1211     function isExcludedFromFees(address account) public view returns (bool) {
1212         return _isExcludedFromFees[account];
1213     }
1214 
1215     function _transfer(
1216         address from,
1217         address to,
1218         uint256 amount
1219     ) internal override {
1220         require(from != address(0), "ERC20: transfer from the zero address");
1221         require(to != address(0), "ERC20: transfer to the zero address");
1222 
1223         if (amount == 0) {
1224             super._transfer(from, to, 0);
1225             return;
1226         }
1227 
1228         if (limitsInEffect) {
1229             if (
1230                 from != owner() &&
1231                 to != owner() &&
1232                 to != address(0) &&
1233                 to != address(0xdead) &&
1234                 !swapping
1235             ) {
1236                 if (!tradingActive) {
1237                     require(
1238                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1239                         "Trading is not active."
1240                     );
1241                 }
1242 
1243                 //when buy
1244                 if (
1245                     automatedMarketMakerPairs[from] &&
1246                     !_isExcludedMaxTransactionAmount[to]
1247                 ) {
1248                     require(
1249                         amount <= maxTransactionAmount,
1250                         "Buy transfer amount exceeds the maxTransactionAmount."
1251                     );
1252                     require(
1253                         amount + balanceOf(to) <= maxWallet,
1254                         "Max wallet exceeded"
1255                     );
1256                 }
1257                 //when sell
1258                 else if (
1259                     automatedMarketMakerPairs[to] &&
1260                     !_isExcludedMaxTransactionAmount[from]
1261                 ) {
1262                     require(
1263                         amount <= maxTransactionAmount,
1264                         "Sell transfer amount exceeds the maxTransactionAmount."
1265                     );
1266                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1267                     require(
1268                         amount + balanceOf(to) <= maxWallet,
1269                         "Max wallet exceeded"
1270                     );
1271                 }
1272             }
1273         }
1274 
1275         uint256 contractTokenBalance = balanceOf(address(this));
1276 
1277         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1278 
1279         if (
1280             canSwap &&
1281             swapEnabled &&
1282             !swapping &&
1283             !automatedMarketMakerPairs[from] &&
1284             !_isExcludedFromFees[from] &&
1285             !_isExcludedFromFees[to]
1286         ) {
1287             swapping = true;
1288 
1289             swapBack();
1290 
1291             swapping = false;
1292         }
1293 
1294         bool takeFee = !swapping;
1295 
1296         // if any account belongs to _isExcludedFromFee account then remove the fee
1297         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1298             takeFee = false;
1299         }
1300 
1301         uint256 fees = 0;
1302         // only take fees on buys/sells, do not take on wallet transfers
1303         if (takeFee) {
1304             // on sell
1305             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1306                 fees = amount.mul(sellTotalFees).div(100);
1307                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1308                 tokensForDev += (fees * sellDevFee) / sellTotalFees;                
1309             }
1310             // on buy
1311             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1312                 fees = amount.mul(buyTotalFees).div(100);
1313                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1314                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1315             }
1316 
1317             if (fees > 0) {
1318                 super._transfer(from, address(this), fees);
1319             }
1320 
1321             amount -= fees;
1322         }
1323 
1324         super._transfer(from, to, amount);
1325     }
1326 
1327     function swapTokensForEth(uint256 tokenAmount) private {
1328         // generate the uniswap pair path of token -> weth
1329         address[] memory path = new address[](2);
1330         path[0] = address(this);
1331         path[1] = uniswapV2Router.WETH();
1332 
1333         _approve(address(this), address(uniswapV2Router), tokenAmount);
1334 
1335         // make the swap
1336         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1337             tokenAmount,
1338             0, // accept any amount of ETH
1339             path,
1340             address(this),
1341             block.timestamp
1342         );
1343     }
1344 
1345     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1346         // approve token transfer to cover all possible scenarios
1347         _approve(address(this), address(uniswapV2Router), tokenAmount);
1348 
1349         // add the liquidity
1350         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1351             address(this),
1352             tokenAmount,
1353             0, // slippage is unavoidable
1354             0, // slippage is unavoidable
1355             devWallet,
1356             block.timestamp
1357         );
1358     }
1359 
1360     function swapBack() private {
1361         uint256 contractBalance = balanceOf(address(this));
1362         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
1363         bool success;
1364 
1365         if (contractBalance == 0 || totalTokensToSwap == 0) {
1366             return;
1367         }
1368 
1369         if (contractBalance > swapTokensAtAmount * 20) {
1370             contractBalance = swapTokensAtAmount * 20;
1371         }
1372 
1373         // Halve the amount of liquidity tokens
1374         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1375         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1376 
1377         uint256 initialETHBalance = address(this).balance;
1378 
1379         swapTokensForEth(amountToSwapForETH);
1380 
1381         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1382 	
1383         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1384 
1385         uint256 ethForLiquidity = ethBalance - ethForDev;
1386 
1387         tokensForLiquidity = 0;
1388         tokensForDev = 0;
1389 
1390         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1391             addLiquidity(liquidityTokens, ethForLiquidity);
1392             emit SwapAndLiquify(
1393                 amountToSwapForETH,
1394                 ethForLiquidity,
1395                 tokensForLiquidity
1396             );
1397         }
1398 
1399         (success, ) = address(devWallet).call{value: address(this).balance}("");
1400     }
1401 
1402 }