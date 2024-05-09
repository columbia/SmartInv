1 // SPDX-License-Identifier: MIT
2 /**
3   _   _  _  _  _  _ 
4  / \ | \| |/ \| \| |
5 | o || \\ ( o ) \\ |
6 |_n_||_|\_|\_/|_|\_|
7                     
8 Join us Anon.
9 
10 Anon Website - https://anon-erc.com
11 
12 Telegram - https://t.me/anonportal
13 Twitter - https://twitter.com/anon_erc
14 */
15 
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
818 ////// src/IUniswapV2Factory.sol
819 /* pragma solidity 0.8.10; */
820 /* pragma experimental ABIEncoderV2; */
821 
822 interface IUniswapV2Factory {
823     event PairCreated(
824         address indexed token0,
825         address indexed token1,
826         address pair,
827         uint256
828     );
829 
830     function feeTo() external view returns (address);
831 
832     function feeToSetter() external view returns (address);
833 
834     function getPair(address tokenA, address tokenB)
835         external
836         view
837         returns (address pair);
838 
839     function allPairs(uint256) external view returns (address pair);
840 
841     function allPairsLength() external view returns (uint256);
842 
843     function createPair(address tokenA, address tokenB)
844         external
845         returns (address pair);
846 
847     function setFeeTo(address) external;
848 
849     function setFeeToSetter(address) external;
850 }
851 
852 ////// src/IUniswapV2Pair.sol
853 /* pragma solidity 0.8.10; */
854 /* pragma experimental ABIEncoderV2; */
855 
856 interface IUniswapV2Pair {
857     event Approval(
858         address indexed owner,
859         address indexed spender,
860         uint256 value
861     );
862     event Transfer(address indexed from, address indexed to, uint256 value);
863 
864     function name() external pure returns (string memory);
865 
866     function symbol() external pure returns (string memory);
867 
868     function decimals() external pure returns (uint8);
869 
870     function totalSupply() external view returns (uint256);
871 
872     function balanceOf(address owner) external view returns (uint256);
873 
874     function allowance(address owner, address spender)
875         external
876         view
877         returns (uint256);
878 
879     function approve(address spender, uint256 value) external returns (bool);
880 
881     function transfer(address to, uint256 value) external returns (bool);
882 
883     function transferFrom(
884         address from,
885         address to,
886         uint256 value
887     ) external returns (bool);
888 
889     function DOMAIN_SEPARATOR() external view returns (bytes32);
890 
891     function PERMIT_TYPEHASH() external pure returns (bytes32);
892 
893     function nonces(address owner) external view returns (uint256);
894 
895     function permit(
896         address owner,
897         address spender,
898         uint256 value,
899         uint256 deadline,
900         uint8 v,
901         bytes32 r,
902         bytes32 s
903     ) external;
904 
905     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
906     event Burn(
907         address indexed sender,
908         uint256 amount0,
909         uint256 amount1,
910         address indexed to
911     );
912     event Swap(
913         address indexed sender,
914         uint256 amount0In,
915         uint256 amount1In,
916         uint256 amount0Out,
917         uint256 amount1Out,
918         address indexed to
919     );
920     event Sync(uint112 reserve0, uint112 reserve1);
921 
922     function MINIMUM_LIQUIDITY() external pure returns (uint256);
923 
924     function factory() external view returns (address);
925 
926     function token0() external view returns (address);
927 
928     function token1() external view returns (address);
929 
930     function getReserves()
931         external
932         view
933         returns (
934             uint112 reserve0,
935             uint112 reserve1,
936             uint32 blockTimestampLast
937         );
938 
939     function price0CumulativeLast() external view returns (uint256);
940 
941     function price1CumulativeLast() external view returns (uint256);
942 
943     function kLast() external view returns (uint256);
944 
945     function mint(address to) external returns (uint256 liquidity);
946 
947     function burn(address to)
948         external
949         returns (uint256 amount0, uint256 amount1);
950 
951     function swap(
952         uint256 amount0Out,
953         uint256 amount1Out,
954         address to,
955         bytes calldata data
956     ) external;
957 
958     function skim(address to) external;
959 
960     function sync() external;
961 
962     function initialize(address, address) external;
963 }
964 
965 ////// src/IUniswapV2Router02.sol
966 /* pragma solidity 0.8.10; */
967 /* pragma experimental ABIEncoderV2; */
968 
969 interface IUniswapV2Router02 {
970     function factory() external pure returns (address);
971 
972     function WETH() external pure returns (address);
973 
974     function addLiquidity(
975         address tokenA,
976         address tokenB,
977         uint256 amountADesired,
978         uint256 amountBDesired,
979         uint256 amountAMin,
980         uint256 amountBMin,
981         address to,
982         uint256 deadline
983     )
984         external
985         returns (
986             uint256 amountA,
987             uint256 amountB,
988             uint256 liquidity
989         );
990 
991     function addLiquidityETH(
992         address token,
993         uint256 amountTokenDesired,
994         uint256 amountTokenMin,
995         uint256 amountETHMin,
996         address to,
997         uint256 deadline
998     )
999         external
1000         payable
1001         returns (
1002             uint256 amountToken,
1003             uint256 amountETH,
1004             uint256 liquidity
1005         );
1006 
1007     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1008         uint256 amountIn,
1009         uint256 amountOutMin,
1010         address[] calldata path,
1011         address to,
1012         uint256 deadline
1013     ) external;
1014 
1015     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1016         uint256 amountOutMin,
1017         address[] calldata path,
1018         address to,
1019         uint256 deadline
1020     ) external payable;
1021 
1022     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1023         uint256 amountIn,
1024         uint256 amountOutMin,
1025         address[] calldata path,
1026         address to,
1027         uint256 deadline
1028     ) external;
1029 }
1030 
1031 /* pragma solidity >=0.8.10; */
1032 
1033 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1034 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1035 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1036 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1037 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1038 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1039 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1040 
1041 contract ANON is ERC20, Ownable {
1042     using SafeMath for uint256;
1043 
1044     IUniswapV2Router02 public immutable uniswapV2Router;
1045     address public immutable uniswapV2Pair;
1046     address public constant deadAddress = address(0xdead);
1047 
1048     bool private swapping;
1049 
1050     address public marketingWallet;
1051     address public devWallet;
1052 
1053     uint256 public maxTransactionAmount;
1054     uint256 public swapTokensAtAmount;
1055     uint256 public maxWallet;
1056 
1057     uint256 public percentForLPBurn = 25; // 25 = .25%
1058     bool public lpBurnEnabled = false;
1059     uint256 public lpBurnFrequency = 3600 seconds;
1060     uint256 public lastLpBurnTime;
1061 
1062     uint256 public manualBurnFrequency = 30 minutes;
1063     uint256 public lastManualLpBurnTime;
1064 
1065     bool public limitsInEffect = true;
1066     bool public tradingActive = false;
1067     bool public swapEnabled = false;
1068 
1069     // Anti-bot and anti-whale mappings and variables
1070     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1071     bool public transferDelayEnabled = true;
1072 
1073     uint256 public buyTotalFees;
1074     uint256 public buyMarketingFee;
1075     uint256 public buyLiquidityFee;
1076     uint256 public buyDevFee;
1077 
1078     uint256 public sellTotalFees;
1079     uint256 public sellMarketingFee;
1080     uint256 public sellLiquidityFee;
1081     uint256 public sellDevFee;
1082 
1083     uint256 public tokensForMarketing;
1084     uint256 public tokensForLiquidity;
1085     uint256 public tokensForDev;
1086 
1087     /******************/
1088 
1089     // exlcude from fees and max transaction amount
1090     mapping(address => bool) private _isExcludedFromFees;
1091     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1092 
1093     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1094     // could be subject to a maximum transfer amount
1095     mapping(address => bool) public automatedMarketMakerPairs;
1096 
1097     event UpdateUniswapV2Router(
1098         address indexed newAddress,
1099         address indexed oldAddress
1100     );
1101 
1102     event ExcludeFromFees(address indexed account, bool isExcluded);
1103 
1104     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1105 
1106     event marketingWalletUpdated(
1107         address indexed newWallet,
1108         address indexed oldWallet
1109     );
1110 
1111     event devWalletUpdated(
1112         address indexed newWallet,
1113         address indexed oldWallet
1114     );
1115 
1116     event SwapAndLiquify(
1117         uint256 tokensSwapped,
1118         uint256 ethReceived,
1119         uint256 tokensIntoLiquidity
1120     );
1121 
1122     event AutoNukeLP();
1123 
1124     event ManualNukeLP();
1125 
1126     constructor() ERC20("ANON", "ANON") {
1127         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1128             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1129         );
1130 
1131         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1132         uniswapV2Router = _uniswapV2Router;
1133 
1134         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1135             .createPair(address(this), _uniswapV2Router.WETH());
1136         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1137         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1138 
1139         uint256 _buyMarketingFee = 15;
1140         uint256 _buyLiquidityFee = 0;
1141         uint256 _buyDevFee = 0;
1142 
1143         uint256 _sellMarketingFee = 65;
1144         uint256 _sellLiquidityFee = 0;
1145         uint256 _sellDevFee = 0;
1146 
1147         uint256 totalSupply = 1_000_000_000 * 1e18;
1148 
1149         maxTransactionAmount = 20_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1150         maxWallet = 20_000_000 * 1e18; // 1% from total supply maxWallet
1151         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1152 
1153         buyMarketingFee = _buyMarketingFee;
1154         buyLiquidityFee = _buyLiquidityFee;
1155         buyDevFee = _buyDevFee;
1156         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1157 
1158         sellMarketingFee = _sellMarketingFee;
1159         sellLiquidityFee = _sellLiquidityFee;
1160         sellDevFee = _sellDevFee;
1161         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1162 
1163         marketingWallet = address(0x3a4f28aE7F995649d5a020bEE7C919FC576d2F44); // set as marketing wallet
1164         devWallet = address(0x3a4f28aE7F995649d5a020bEE7C919FC576d2F44); // set as dev wallet
1165 
1166         // exclude from paying fees or having max transaction amount
1167         excludeFromFees(owner(), true);
1168         excludeFromFees(address(this), true);
1169         excludeFromFees(address(0xdead), true);
1170 
1171         excludeFromMaxTransaction(owner(), true);
1172         excludeFromMaxTransaction(address(this), true);
1173         excludeFromMaxTransaction(address(0xdead), true);
1174 
1175         /*
1176             _mint is an internal function in ERC20.sol that is only called here,
1177             and CANNOT be called ever again
1178         */
1179         _mint(msg.sender, totalSupply);
1180     }
1181 
1182     receive() external payable {}
1183 
1184     // once enabled, can never be turned off
1185     function enableTrading() external onlyOwner {
1186         tradingActive = true;
1187         swapEnabled = true;
1188         lastLpBurnTime = block.timestamp;
1189     }
1190 
1191     // remove limits after token is stable
1192     function removeLimits() external onlyOwner returns (bool) {
1193         limitsInEffect = false;
1194         return true;
1195     }
1196 
1197     // disable Transfer delay - cannot be reenabled
1198     function disableTransferDelay() external onlyOwner returns (bool) {
1199         transferDelayEnabled = false;
1200         return true;
1201     }
1202 
1203     // change the minimum amount of tokens to sell from fees
1204     function updateSwapTokensAtAmount(uint256 newAmount)
1205         external
1206         onlyOwner
1207         returns (bool)
1208     {
1209         require(
1210             newAmount >= (totalSupply() * 1) / 100000,
1211             "Swap amount cannot be lower than 0.001% total supply."
1212         );
1213         require(
1214             newAmount <= (totalSupply() * 5) / 1000,
1215             "Swap amount cannot be higher than 0.5% total supply."
1216         );
1217         swapTokensAtAmount = newAmount;
1218         return true;
1219     }
1220 
1221     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1222         require(
1223             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1224             "Cannot set maxTransactionAmount lower than 0.1%"
1225         );
1226         maxTransactionAmount = newNum * (10**18);
1227     }
1228 
1229     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1230         require(
1231             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1232             "Cannot set maxWallet lower than 0.5%"
1233         );
1234         maxWallet = newNum * (10**18);
1235     }
1236 
1237     function excludeFromMaxTransaction(address updAds, bool isEx)
1238         public
1239         onlyOwner
1240     {
1241         _isExcludedMaxTransactionAmount[updAds] = isEx;
1242     }
1243 
1244     // only use to disable contract sales if absolutely necessary (emergency use only)
1245     function updateSwapEnabled(bool enabled) external onlyOwner {
1246         swapEnabled = enabled;
1247     }
1248 
1249     function updateBuyFees(
1250         uint256 _marketingFee,
1251         uint256 _liquidityFee,
1252         uint256 _devFee
1253     ) external onlyOwner {
1254         buyMarketingFee = _marketingFee;
1255         buyLiquidityFee = _liquidityFee;
1256         buyDevFee = _devFee;
1257         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1258         require(buyTotalFees <= 99, "Must keep fees at 99% or less");
1259     }
1260 
1261     function updateSellFees(
1262         uint256 _marketingFee,
1263         uint256 _liquidityFee,
1264         uint256 _devFee
1265     ) external onlyOwner {
1266         sellMarketingFee = _marketingFee;
1267         sellLiquidityFee = _liquidityFee;
1268         sellDevFee = _devFee;
1269         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1270         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1271     }
1272 
1273     function excludeFromFees(address account, bool excluded) public onlyOwner {
1274         _isExcludedFromFees[account] = excluded;
1275         emit ExcludeFromFees(account, excluded);
1276     }
1277 
1278     function setAutomatedMarketMakerPair(address pair, bool value)
1279         public
1280         onlyOwner
1281     {
1282         require(
1283             pair != uniswapV2Pair,
1284             "The pair cannot be removed from automatedMarketMakerPairs"
1285         );
1286 
1287         _setAutomatedMarketMakerPair(pair, value);
1288     }
1289 
1290     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1291         automatedMarketMakerPairs[pair] = value;
1292 
1293         emit SetAutomatedMarketMakerPair(pair, value);
1294     }
1295 
1296     function updateMarketingWallet(address newMarketingWallet)
1297         external
1298         onlyOwner
1299     {
1300         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1301         marketingWallet = newMarketingWallet;
1302     }
1303 
1304     function updateDevWallet(address newWallet) external onlyOwner {
1305         emit devWalletUpdated(newWallet, devWallet);
1306         devWallet = newWallet;
1307     }
1308 
1309     function isExcludedFromFees(address account) public view returns (bool) {
1310         return _isExcludedFromFees[account];
1311     }
1312 
1313     event BoughtEarly(address indexed sniper);
1314 
1315     function _transfer(
1316         address from,
1317         address to,
1318         uint256 amount
1319     ) internal override {
1320         require(from != address(0), "ERC20: transfer from the zero address");
1321         require(to != address(0), "ERC20: transfer to the zero address");
1322 
1323         if (amount == 0) {
1324             super._transfer(from, to, 0);
1325             return;
1326         }
1327 
1328         if (limitsInEffect) {
1329             if (
1330                 from != owner() &&
1331                 to != owner() &&
1332                 to != address(0) &&
1333                 to != address(0xdead) &&
1334                 !swapping
1335             ) {
1336                 if (!tradingActive) {
1337                     require(
1338                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1339                         "Trading is not active."
1340                     );
1341                 }
1342 
1343                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1344                 if (transferDelayEnabled) {
1345                     if (
1346                         to != owner() &&
1347                         to != address(uniswapV2Router) &&
1348                         to != address(uniswapV2Pair)
1349                     ) {
1350                         require(
1351                             _holderLastTransferTimestamp[tx.origin] <
1352                                 block.number,
1353                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1354                         );
1355                         _holderLastTransferTimestamp[tx.origin] = block.number;
1356                     }
1357                 }
1358 
1359                 //when buy
1360                 if (
1361                     automatedMarketMakerPairs[from] &&
1362                     !_isExcludedMaxTransactionAmount[to]
1363                 ) {
1364                     require(
1365                         amount <= maxTransactionAmount,
1366                         "Buy transfer amount exceeds the maxTransactionAmount."
1367                     );
1368                     require(
1369                         amount + balanceOf(to) <= maxWallet,
1370                         "Max wallet exceeded"
1371                     );
1372                 }
1373                 //when sell
1374                 else if (
1375                     automatedMarketMakerPairs[to] &&
1376                     !_isExcludedMaxTransactionAmount[from]
1377                 ) {
1378                     require(
1379                         amount <= maxTransactionAmount,
1380                         "Sell transfer amount exceeds the maxTransactionAmount."
1381                     );
1382                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1383                     require(
1384                         amount + balanceOf(to) <= maxWallet,
1385                         "Max wallet exceeded"
1386                     );
1387                 }
1388             }
1389         }
1390 
1391         uint256 contractTokenBalance = balanceOf(address(this));
1392 
1393         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1394 
1395         if (
1396             canSwap &&
1397             swapEnabled &&
1398             !swapping &&
1399             !automatedMarketMakerPairs[from] &&
1400             !_isExcludedFromFees[from] &&
1401             !_isExcludedFromFees[to]
1402         ) {
1403             swapping = true;
1404 
1405             swapBack();
1406 
1407             swapping = false;
1408         }
1409 
1410         if (
1411             !swapping &&
1412             automatedMarketMakerPairs[to] &&
1413             lpBurnEnabled &&
1414             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1415             !_isExcludedFromFees[from]
1416         ) {
1417             autoBurnLiquidityPairTokens();
1418         }
1419 
1420         bool takeFee = !swapping;
1421 
1422         // if any account belongs to _isExcludedFromFee account then remove the fee
1423         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1424             takeFee = false;
1425         }
1426 
1427         uint256 fees = 0;
1428         // only take fees on buys/sells, do not take on wallet transfers
1429         if (takeFee) {
1430             // on sell
1431             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1432                 fees = amount.mul(sellTotalFees).div(100);
1433                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1434                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1435                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1436             }
1437             // on buy
1438             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1439                 fees = amount.mul(buyTotalFees).div(100);
1440                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1441                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1442                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1443             }
1444 
1445             if (fees > 0) {
1446                 super._transfer(from, address(this), fees);
1447             }
1448 
1449             amount -= fees;
1450         }
1451 
1452         super._transfer(from, to, amount);
1453     }
1454 
1455     function swapTokensForEth(uint256 tokenAmount) private {
1456         // generate the uniswap pair path of token -> weth
1457         address[] memory path = new address[](2);
1458         path[0] = address(this);
1459         path[1] = uniswapV2Router.WETH();
1460 
1461         _approve(address(this), address(uniswapV2Router), tokenAmount);
1462 
1463         // make the swap
1464         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1465             tokenAmount,
1466             0, // accept any amount of ETH
1467             path,
1468             address(this),
1469             block.timestamp
1470         );
1471     }
1472 
1473     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1474         // approve token transfer to cover all possible scenarios
1475         _approve(address(this), address(uniswapV2Router), tokenAmount);
1476 
1477         // add the liquidity
1478         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1479             address(this),
1480             tokenAmount,
1481             0, // slippage is unavoidable
1482             0, // slippage is unavoidable
1483             deadAddress,
1484             block.timestamp
1485         );
1486     }
1487 
1488     function swapBack() private {
1489         uint256 contractBalance = balanceOf(address(this));
1490         uint256 totalTokensToSwap = tokensForLiquidity +
1491             tokensForMarketing +
1492             tokensForDev;
1493         bool success;
1494 
1495         if (contractBalance == 0 || totalTokensToSwap == 0) {
1496             return;
1497         }
1498 
1499         if (contractBalance > swapTokensAtAmount * 20) {
1500             contractBalance = swapTokensAtAmount * 20;
1501         }
1502 
1503         // Halve the amount of liquidity tokens
1504         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1505             totalTokensToSwap /
1506             2;
1507         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1508 
1509         uint256 initialETHBalance = address(this).balance;
1510 
1511         swapTokensForEth(amountToSwapForETH);
1512 
1513         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1514 
1515         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1516             totalTokensToSwap
1517         );
1518         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1519 
1520         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1521 
1522         tokensForLiquidity = 0;
1523         tokensForMarketing = 0;
1524         tokensForDev = 0;
1525 
1526         (success, ) = address(devWallet).call{value: ethForDev}("");
1527 
1528         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1529             addLiquidity(liquidityTokens, ethForLiquidity);
1530             emit SwapAndLiquify(
1531                 amountToSwapForETH,
1532                 ethForLiquidity,
1533                 tokensForLiquidity
1534             );
1535         }
1536 
1537         (success, ) = address(marketingWallet).call{
1538             value: address(this).balance
1539         }("");
1540     }
1541 
1542     function setAutoLPBurnSettings(
1543         uint256 _frequencyInSeconds,
1544         uint256 _percent,
1545         bool _Enabled
1546     ) external onlyOwner {
1547         require(
1548             _frequencyInSeconds >= 600,
1549             "cannot set buyback more often than every 10 minutes"
1550         );
1551         require(
1552             _percent <= 1000 && _percent >= 0,
1553             "Must set auto LP burn percent between 0% and 10%"
1554         );
1555         lpBurnFrequency = _frequencyInSeconds;
1556         percentForLPBurn = _percent;
1557         lpBurnEnabled = _Enabled;
1558     }
1559 
1560     function autoBurnLiquidityPairTokens() internal returns (bool) {
1561         lastLpBurnTime = block.timestamp;
1562 
1563         // get balance of liquidity pair
1564         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1565 
1566         // calculate amount to burn
1567         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1568             10000
1569         );
1570 
1571         // pull tokens from pancakePair liquidity and move to dead address permanently
1572         if (amountToBurn > 0) {
1573             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1574         }
1575 
1576         //sync price since this is not in a swap transaction!
1577         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1578         pair.sync();
1579         emit AutoNukeLP();
1580         return true;
1581     }
1582 
1583     function manualBurnLiquidityPairTokens(uint256 percent)
1584         external
1585         onlyOwner
1586         returns (bool)
1587     {
1588         require(
1589             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1590             "Must wait for cooldown to finish"
1591         );
1592         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1593         lastManualLpBurnTime = block.timestamp;
1594 
1595         // get balance of liquidity pair
1596         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1597 
1598         // calculate amount to burn
1599         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1600 
1601         // pull tokens from pancakePair liquidity and move to dead address permanently
1602         if (amountToBurn > 0) {
1603             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1604         }
1605 
1606         //sync price since this is not in a swap transaction!
1607         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1608         pair.sync();
1609         emit ManualNukeLP();
1610         return true;
1611     }
1612 }