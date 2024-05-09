1 /**
2 RYUKYU - $RYU 
3 
4 Tough dog, for a tough community. 
5 
6 0/0 tax.
7 
8 Please do not make a telegram group, one will be published when the time is right.
9 
10 Let’s moon this together.
11 
12 www.ryukyuerc.com
13 */
14 // SPDX-License-Identifier: MIT
15 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
16 pragma experimental ABIEncoderV2;
17 
18 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
19 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
20 
21 /* pragma solidity ^0.8.0; */
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
44 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
45 
46 /* pragma solidity ^0.8.0; */
47 
48 /* import "../utils/Context.sol"; */
49 
50 /**
51  * @dev Contract module which provides a basic access control mechanism, where
52  * there is an account (an owner) that can be granted exclusive access to
53  * specific functions.
54  *
55  * By default, the owner account will be the one that deploys the contract. This
56  * can later be changed with {transferOwnership}.
57  *
58  * This module is used through inheritance. It will make available the modifier
59  * `onlyOwner`, which can be applied to your functions to restrict their use to
60  * the owner.
61  */
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor() {
71         _transferOwnership(_msgSender());
72     }
73 
74     /**
75      * @dev Returns the address of the current owner.
76      */
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions anymore. Can only be called by the current owner.
92      *
93      * NOTE: Renouncing ownership will leave the contract without an owner,
94      * thereby removing any functionality that is only available to the owner.
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
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Internal function without access restriction.
112      */
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner;
115         _owner = newOwner;
116         emit OwnershipTransferred(oldOwner, newOwner);
117     }
118 }
119 
120 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
121 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
122 
123 /* pragma solidity ^0.8.0; */
124 
125 /**
126  * @dev Interface of the ERC20 standard as defined in the EIP.
127  */
128 interface IERC20 {
129     /**
130      * @dev Returns the amount of tokens in existence.
131      */
132     function totalSupply() external view returns (uint256);
133 
134     /**
135      * @dev Returns the amount of tokens owned by `account`.
136      */
137     function balanceOf(address account) external view returns (uint256);
138 
139     /**
140      * @dev Moves `amount` tokens from the caller's account to `recipient`.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transfer(address recipient, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Returns the remaining number of tokens that `spender` will be
150      * allowed to spend on behalf of `owner` through {transferFrom}. This is
151      * zero by default.
152      *
153      * This value changes when {approve} or {transferFrom} are called.
154      */
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     /**
158      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * IMPORTANT: Beware that changing an allowance with this method brings the risk
163      * that someone may use both the old and the new allowance by unfortunate
164      * transaction ordering. One possible solution to mitigate this race
165      * condition is to first reduce the spender's allowance to 0 and set the
166      * desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address spender, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Moves `amount` tokens from `sender` to `recipient` using the
175      * allowance mechanism. `amount` is then deducted from the caller's
176      * allowance.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) external returns (bool);
187 
188     /**
189      * @dev Emitted when `value` tokens are moved from one account (`from`) to
190      * another (`to`).
191      *
192      * Note that `value` may be zero.
193      */
194     event Transfer(address indexed from, address indexed to, uint256 value);
195 
196     /**
197      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
198      * a call to {approve}. `value` is the new allowance.
199      */
200     event Approval(address indexed owner, address indexed spender, uint256 value);
201 }
202 
203 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
204 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
205 
206 /* pragma solidity ^0.8.0; */
207 
208 /* import "../IERC20.sol"; */
209 
210 /**
211  * @dev Interface for the optional metadata functions from the ERC20 standard.
212  *
213  * _Available since v4.1._
214  */
215 interface IERC20Metadata is IERC20 {
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the symbol of the token.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the decimals places of the token.
228      */
229     function decimals() external view returns (uint8);
230 }
231 
232 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
233 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
234 
235 /* pragma solidity ^0.8.0; */
236 
237 /* import "./IERC20.sol"; */
238 /* import "./extensions/IERC20Metadata.sol"; */
239 /* import "../../utils/Context.sol"; */
240 
241 /**
242  * @dev Implementation of the {IERC20} interface.
243  *
244  * This implementation is agnostic to the way tokens are created. This means
245  * that a supply mechanism has to be added in a derived contract using {_mint}.
246  * For a generic mechanism see {ERC20PresetMinterPauser}.
247  *
248  * TIP: For a detailed writeup see our guide
249  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
250  * to implement supply mechanisms].
251  *
252  * We have followed general OpenZeppelin Contracts guidelines: functions revert
253  * instead returning `false` on failure. This behavior is nonetheless
254  * conventional and does not conflict with the expectations of ERC20
255  * applications.
256  *
257  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
258  * This allows applications to reconstruct the allowance for all accounts just
259  * by listening to said events. Other implementations of the EIP may not emit
260  * these events, as it isn't required by the specification.
261  *
262  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
263  * functions have been added to mitigate the well-known issues around setting
264  * allowances. See {IERC20-approve}.
265  */
266 contract ERC20 is Context, IERC20, IERC20Metadata {
267     mapping(address => uint256) private _balances;
268 
269     mapping(address => mapping(address => uint256)) private _allowances;
270 
271     uint256 private _totalSupply;
272 
273     string private _name;
274     string private _symbol;
275 
276     /**
277      * @dev Sets the values for {name} and {symbol}.
278      *
279      * The default value of {decimals} is 18. To select a different value for
280      * {decimals} you should overload it.
281      *
282      * All two of these values are immutable: they can only be set once during
283      * construction.
284      */
285     constructor(string memory name_, string memory symbol_) {
286         _name = name_;
287         _symbol = symbol_;
288     }
289 
290     /**
291      * @dev Returns the name of the token.
292      */
293     function name() public view virtual override returns (string memory) {
294         return _name;
295     }
296 
297     /**
298      * @dev Returns the symbol of the token, usually a shorter version of the
299      * name.
300      */
301     function symbol() public view virtual override returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @dev Returns the number of decimals used to get its user representation.
307      * For example, if `decimals` equals `2`, a balance of `505` tokens should
308      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
309      *
310      * Tokens usually opt for a value of 18, imitating the relationship between
311      * Ether and Wei. This is the value {ERC20} uses, unless this function is
312      * overridden;
313      *
314      * NOTE: This information is only used for _display_ purposes: it in
315      * no way affects any of the arithmetic of the contract, including
316      * {IERC20-balanceOf} and {IERC20-transfer}.
317      */
318     function decimals() public view virtual override returns (uint8) {
319         return 18;
320     }
321 
322     /**
323      * @dev See {IERC20-totalSupply}.
324      */
325     function totalSupply() public view virtual override returns (uint256) {
326         return _totalSupply;
327     }
328 
329     /**
330      * @dev See {IERC20-balanceOf}.
331      */
332     function balanceOf(address account) public view virtual override returns (uint256) {
333         return _balances[account];
334     }
335 
336     /**
337      * @dev See {IERC20-transfer}.
338      *
339      * Requirements:
340      *
341      * - `recipient` cannot be the zero address.
342      * - the caller must have a balance of at least `amount`.
343      */
344     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
345         _transfer(_msgSender(), recipient, amount);
346         return true;
347     }
348 
349     /**
350      * @dev See {IERC20-allowance}.
351      */
352     function allowance(address owner, address spender) public view virtual override returns (uint256) {
353         return _allowances[owner][spender];
354     }
355 
356     /**
357      * @dev See {IERC20-approve}.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function approve(address spender, uint256 amount) public virtual override returns (bool) {
364         _approve(_msgSender(), spender, amount);
365         return true;
366     }
367 
368     /**
369      * @dev See {IERC20-transferFrom}.
370      *
371      * Emits an {Approval} event indicating the updated allowance. This is not
372      * required by the EIP. See the note at the beginning of {ERC20}.
373      *
374      * Requirements:
375      *
376      * - `sender` and `recipient` cannot be the zero address.
377      * - `sender` must have a balance of at least `amount`.
378      * - the caller must have allowance for ``sender``'s tokens of at least
379      * `amount`.
380      */
381     function transferFrom(
382         address sender,
383         address recipient,
384         uint256 amount
385     ) public virtual override returns (bool) {
386         _transfer(sender, recipient, amount);
387 
388         uint256 currentAllowance = _allowances[sender][_msgSender()];
389         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
390         unchecked {
391             _approve(sender, _msgSender(), currentAllowance - amount);
392         }
393 
394         return true;
395     }
396 
397     /**
398      * @dev Atomically increases the allowance granted to `spender` by the caller.
399      *
400      * This is an alternative to {approve} that can be used as a mitigation for
401      * problems described in {IERC20-approve}.
402      *
403      * Emits an {Approval} event indicating the updated allowance.
404      *
405      * Requirements:
406      *
407      * - `spender` cannot be the zero address.
408      */
409     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
410         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
411         return true;
412     }
413 
414     /**
415      * @dev Atomically decreases the allowance granted to `spender` by the caller.
416      *
417      * This is an alternative to {approve} that can be used as a mitigation for
418      * problems described in {IERC20-approve}.
419      *
420      * Emits an {Approval} event indicating the updated allowance.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      * - `spender` must have allowance for the caller of at least
426      * `subtractedValue`.
427      */
428     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
429         uint256 currentAllowance = _allowances[_msgSender()][spender];
430         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
431         unchecked {
432             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
433         }
434 
435         return true;
436     }
437 
438     /**
439      * @dev Moves `amount` of tokens from `sender` to `recipient`.
440      *
441      * This internal function is equivalent to {transfer}, and can be used to
442      * e.g. implement automatic token fees, slashing mechanisms, etc.
443      *
444      * Emits a {Transfer} event.
445      *
446      * Requirements:
447      *
448      * - `sender` cannot be the zero address.
449      * - `recipient` cannot be the zero address.
450      * - `sender` must have a balance of at least `amount`.
451      */
452     function _transfer(
453         address sender,
454         address recipient,
455         uint256 amount
456     ) internal virtual {
457         require(sender != address(0), "ERC20: transfer from the zero address");
458         require(recipient != address(0), "ERC20: transfer to the zero address");
459 
460         _beforeTokenTransfer(sender, recipient, amount);
461 
462         uint256 senderBalance = _balances[sender];
463         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
464         unchecked {
465             _balances[sender] = senderBalance - amount;
466         }
467         _balances[recipient] += amount;
468 
469         emit Transfer(sender, recipient, amount);
470 
471         _afterTokenTransfer(sender, recipient, amount);
472     }
473 
474     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
475      * the total supply.
476      *
477      * Emits a {Transfer} event with `from` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `account` cannot be the zero address.
482      */
483     function _mint(address account, uint256 amount) internal virtual {
484         require(account != address(0), "ERC20: mint to the zero address");
485 
486         _beforeTokenTransfer(address(0), account, amount);
487 
488         _totalSupply += amount;
489         _balances[account] += amount;
490         emit Transfer(address(0), account, amount);
491 
492         _afterTokenTransfer(address(0), account, amount);
493     }
494 
495     /**
496      * @dev Destroys `amount` tokens from `account`, reducing the
497      * total supply.
498      *
499      * Emits a {Transfer} event with `to` set to the zero address.
500      *
501      * Requirements:
502      *
503      * - `account` cannot be the zero address.
504      * - `account` must have at least `amount` tokens.
505      */
506     function _burn(address account, uint256 amount) internal virtual {
507         require(account != address(0), "ERC20: burn from the zero address");
508 
509         _beforeTokenTransfer(account, address(0), amount);
510 
511         uint256 accountBalance = _balances[account];
512         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
513         unchecked {
514             _balances[account] = accountBalance - amount;
515         }
516         _totalSupply -= amount;
517 
518         emit Transfer(account, address(0), amount);
519 
520         _afterTokenTransfer(account, address(0), amount);
521     }
522 
523     /**
524      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
525      *
526      * This internal function is equivalent to `approve`, and can be used to
527      * e.g. set automatic allowances for certain subsystems, etc.
528      *
529      * Emits an {Approval} event.
530      *
531      * Requirements:
532      *
533      * - `owner` cannot be the zero address.
534      * - `spender` cannot be the zero address.
535      */
536     function _approve(
537         address owner,
538         address spender,
539         uint256 amount
540     ) internal virtual {
541         require(owner != address(0), "ERC20: approve from the zero address");
542         require(spender != address(0), "ERC20: approve to the zero address");
543 
544         _allowances[owner][spender] = amount;
545         emit Approval(owner, spender, amount);
546     }
547 
548     /**
549      * @dev Hook that is called before any transfer of tokens. This includes
550      * minting and burning.
551      *
552      * Calling conditions:
553      *
554      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
555      * will be transferred to `to`.
556      * - when `from` is zero, `amount` tokens will be minted for `to`.
557      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
558      * - `from` and `to` are never both zero.
559      *
560      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
561      */
562     function _beforeTokenTransfer(
563         address from,
564         address to,
565         uint256 amount
566     ) internal virtual {}
567 
568     /**
569      * @dev Hook that is called after any transfer of tokens. This includes
570      * minting and burning.
571      *
572      * Calling conditions:
573      *
574      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
575      * has been transferred to `to`.
576      * - when `from` is zero, `amount` tokens have been minted for `to`.
577      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
578      * - `from` and `to` are never both zero.
579      *
580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
581      */
582     function _afterTokenTransfer(
583         address from,
584         address to,
585         uint256 amount
586     ) internal virtual {}
587 }
588 
589 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
590 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
591 
592 /* pragma solidity ^0.8.0; */
593 
594 // CAUTION
595 // This version of SafeMath should only be used with Solidity 0.8 or later,
596 // because it relies on the compiler's built in overflow checks.
597 
598 /**
599  * @dev Wrappers over Solidity's arithmetic operations.
600  *
601  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
602  * now has built in overflow checking.
603  */
604 library SafeMath {
605     /**
606      * @dev Returns the addition of two unsigned integers, with an overflow flag.
607      *
608      * _Available since v3.4._
609      */
610     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
611         unchecked {
612             uint256 c = a + b;
613             if (c < a) return (false, 0);
614             return (true, c);
615         }
616     }
617 
618     /**
619      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
620      *
621      * _Available since v3.4._
622      */
623     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
624         unchecked {
625             if (b > a) return (false, 0);
626             return (true, a - b);
627         }
628     }
629 
630     /**
631      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
632      *
633      * _Available since v3.4._
634      */
635     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
636         unchecked {
637             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
638             // benefit is lost if 'b' is also tested.
639             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
640             if (a == 0) return (true, 0);
641             uint256 c = a * b;
642             if (c / a != b) return (false, 0);
643             return (true, c);
644         }
645     }
646 
647     /**
648      * @dev Returns the division of two unsigned integers, with a division by zero flag.
649      *
650      * _Available since v3.4._
651      */
652     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
653         unchecked {
654             if (b == 0) return (false, 0);
655             return (true, a / b);
656         }
657     }
658 
659     /**
660      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
661      *
662      * _Available since v3.4._
663      */
664     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
665         unchecked {
666             if (b == 0) return (false, 0);
667             return (true, a % b);
668         }
669     }
670 
671     /**
672      * @dev Returns the addition of two unsigned integers, reverting on
673      * overflow.
674      *
675      * Counterpart to Solidity's `+` operator.
676      *
677      * Requirements:
678      *
679      * - Addition cannot overflow.
680      */
681     function add(uint256 a, uint256 b) internal pure returns (uint256) {
682         return a + b;
683     }
684 
685     /**
686      * @dev Returns the subtraction of two unsigned integers, reverting on
687      * overflow (when the result is negative).
688      *
689      * Counterpart to Solidity's `-` operator.
690      *
691      * Requirements:
692      *
693      * - Subtraction cannot overflow.
694      */
695     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
696         return a - b;
697     }
698 
699     /**
700      * @dev Returns the multiplication of two unsigned integers, reverting on
701      * overflow.
702      *
703      * Counterpart to Solidity's `*` operator.
704      *
705      * Requirements:
706      *
707      * - Multiplication cannot overflow.
708      */
709     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
710         return a * b;
711     }
712 
713     /**
714      * @dev Returns the integer division of two unsigned integers, reverting on
715      * division by zero. The result is rounded towards zero.
716      *
717      * Counterpart to Solidity's `/` operator.
718      *
719      * Requirements:
720      *
721      * - The divisor cannot be zero.
722      */
723     function div(uint256 a, uint256 b) internal pure returns (uint256) {
724         return a / b;
725     }
726 
727     /**
728      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
729      * reverting when dividing by zero.
730      *
731      * Counterpart to Solidity's `%` operator. This function uses a `revert`
732      * opcode (which leaves remaining gas untouched) while Solidity uses an
733      * invalid opcode to revert (consuming all remaining gas).
734      *
735      * Requirements:
736      *
737      * - The divisor cannot be zero.
738      */
739     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
740         return a % b;
741     }
742 
743     /**
744      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
745      * overflow (when the result is negative).
746      *
747      * CAUTION: This function is deprecated because it requires allocating memory for the error
748      * message unnecessarily. For custom revert reasons use {trySub}.
749      *
750      * Counterpart to Solidity's `-` operator.
751      *
752      * Requirements:
753      *
754      * - Subtraction cannot overflow.
755      */
756     function sub(
757         uint256 a,
758         uint256 b,
759         string memory errorMessage
760     ) internal pure returns (uint256) {
761         unchecked {
762             require(b <= a, errorMessage);
763             return a - b;
764         }
765     }
766 
767     /**
768      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
769      * division by zero. The result is rounded towards zero.
770      *
771      * Counterpart to Solidity's `/` operator. Note: this function uses a
772      * `revert` opcode (which leaves remaining gas untouched) while Solidity
773      * uses an invalid opcode to revert (consuming all remaining gas).
774      *
775      * Requirements:
776      *
777      * - The divisor cannot be zero.
778      */
779     function div(
780         uint256 a,
781         uint256 b,
782         string memory errorMessage
783     ) internal pure returns (uint256) {
784         unchecked {
785             require(b > 0, errorMessage);
786             return a / b;
787         }
788     }
789 
790     /**
791      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
792      * reverting with custom message when dividing by zero.
793      *
794      * CAUTION: This function is deprecated because it requires allocating memory for the error
795      * message unnecessarily. For custom revert reasons use {tryMod}.
796      *
797      * Counterpart to Solidity's `%` operator. This function uses a `revert`
798      * opcode (which leaves remaining gas untouched) while Solidity uses an
799      * invalid opcode to revert (consuming all remaining gas).
800      *
801      * Requirements:
802      *
803      * - The divisor cannot be zero.
804      */
805     function mod(
806         uint256 a,
807         uint256 b,
808         string memory errorMessage
809     ) internal pure returns (uint256) {
810         unchecked {
811             require(b > 0, errorMessage);
812             return a % b;
813         }
814     }
815 }
816 
817 ////// src/IUniswapV2Factory.sol
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
851 ////// src/IUniswapV2Pair.sol
852 /* pragma solidity 0.8.10; */
853 /* pragma experimental ABIEncoderV2; */
854 
855 interface IUniswapV2Pair {
856     event Approval(
857         address indexed owner,
858         address indexed spender,
859         uint256 value
860     );
861     event Transfer(address indexed from, address indexed to, uint256 value);
862 
863     function name() external pure returns (string memory);
864 
865     function symbol() external pure returns (string memory);
866 
867     function decimals() external pure returns (uint8);
868 
869     function totalSupply() external view returns (uint256);
870 
871     function balanceOf(address owner) external view returns (uint256);
872 
873     function allowance(address owner, address spender)
874         external
875         view
876         returns (uint256);
877 
878     function approve(address spender, uint256 value) external returns (bool);
879 
880     function transfer(address to, uint256 value) external returns (bool);
881 
882     function transferFrom(
883         address from,
884         address to,
885         uint256 value
886     ) external returns (bool);
887 
888     function DOMAIN_SEPARATOR() external view returns (bytes32);
889 
890     function PERMIT_TYPEHASH() external pure returns (bytes32);
891 
892     function nonces(address owner) external view returns (uint256);
893 
894     function permit(
895         address owner,
896         address spender,
897         uint256 value,
898         uint256 deadline,
899         uint8 v,
900         bytes32 r,
901         bytes32 s
902     ) external;
903 
904     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
905     event Burn(
906         address indexed sender,
907         uint256 amount0,
908         uint256 amount1,
909         address indexed to
910     );
911     event Swap(
912         address indexed sender,
913         uint256 amount0In,
914         uint256 amount1In,
915         uint256 amount0Out,
916         uint256 amount1Out,
917         address indexed to
918     );
919     event Sync(uint112 reserve0, uint112 reserve1);
920 
921     function MINIMUM_LIQUIDITY() external pure returns (uint256);
922 
923     function factory() external view returns (address);
924 
925     function token0() external view returns (address);
926 
927     function token1() external view returns (address);
928 
929     function getReserves()
930         external
931         view
932         returns (
933             uint112 reserve0,
934             uint112 reserve1,
935             uint32 blockTimestampLast
936         );
937 
938     function price0CumulativeLast() external view returns (uint256);
939 
940     function price1CumulativeLast() external view returns (uint256);
941 
942     function kLast() external view returns (uint256);
943 
944     function mint(address to) external returns (uint256 liquidity);
945 
946     function burn(address to)
947         external
948         returns (uint256 amount0, uint256 amount1);
949 
950     function swap(
951         uint256 amount0Out,
952         uint256 amount1Out,
953         address to,
954         bytes calldata data
955     ) external;
956 
957     function skim(address to) external;
958 
959     function sync() external;
960 
961     function initialize(address, address) external;
962 }
963 
964 ////// src/IUniswapV2Router02.sol
965 /* pragma solidity 0.8.10; */
966 /* pragma experimental ABIEncoderV2; */
967 
968 interface IUniswapV2Router02 {
969     function factory() external pure returns (address);
970 
971     function WETH() external pure returns (address);
972 
973     function addLiquidity(
974         address tokenA,
975         address tokenB,
976         uint256 amountADesired,
977         uint256 amountBDesired,
978         uint256 amountAMin,
979         uint256 amountBMin,
980         address to,
981         uint256 deadline
982     )
983         external
984         returns (
985             uint256 amountA,
986             uint256 amountB,
987             uint256 liquidity
988         );
989 
990     function addLiquidityETH(
991         address token,
992         uint256 amountTokenDesired,
993         uint256 amountTokenMin,
994         uint256 amountETHMin,
995         address to,
996         uint256 deadline
997     )
998         external
999         payable
1000         returns (
1001             uint256 amountToken,
1002             uint256 amountETH,
1003             uint256 liquidity
1004         );
1005 
1006     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1007         uint256 amountIn,
1008         uint256 amountOutMin,
1009         address[] calldata path,
1010         address to,
1011         uint256 deadline
1012     ) external;
1013 
1014     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1015         uint256 amountOutMin,
1016         address[] calldata path,
1017         address to,
1018         uint256 deadline
1019     ) external payable;
1020 
1021     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1022         uint256 amountIn,
1023         uint256 amountOutMin,
1024         address[] calldata path,
1025         address to,
1026         uint256 deadline
1027     ) external;
1028 }
1029 
1030 /* pragma solidity >=0.8.10; */
1031 
1032 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1033 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1034 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1035 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1036 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1037 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1038 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1039 
1040 contract Ryukyu is ERC20, Ownable {
1041     using SafeMath for uint256;
1042 
1043     IUniswapV2Router02 public immutable uniswapV2Router;
1044     address public immutable uniswapV2Pair;
1045     address public constant deadAddress = address(0xdead);
1046 
1047     bool private swapping;
1048 
1049     address public marketingWallet;
1050     address public devWallet;
1051 
1052     uint256 public maxTransactionAmount;
1053     uint256 public swapTokensAtAmount;
1054     uint256 public maxWallet;
1055 
1056     uint256 public percentForLPBurn = 25; // 25 = .25%
1057     bool public lpBurnEnabled = true;
1058     uint256 public lpBurnFrequency = 3600 seconds;
1059     uint256 public lastLpBurnTime;
1060 
1061     uint256 public manualBurnFrequency = 30 minutes;
1062     uint256 public lastManualLpBurnTime;
1063 
1064     bool public limitsInEffect = true;
1065     bool public tradingActive = false;
1066     bool public swapEnabled = false;
1067 
1068     // Anti-bot and anti-whale mappings and variables
1069     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1070     bool public transferDelayEnabled = true;
1071 
1072     uint256 public buyTotalFees;
1073     uint256 public buyMarketingFee;
1074     uint256 public buyLiquidityFee;
1075     uint256 public buyDevFee;
1076 
1077     uint256 public sellTotalFees;
1078     uint256 public sellMarketingFee;
1079     uint256 public sellLiquidityFee;
1080     uint256 public sellDevFee;
1081 
1082     uint256 public tokensForMarketing;
1083     uint256 public tokensForLiquidity;
1084     uint256 public tokensForDev;
1085 
1086     /******************/
1087 
1088     // exlcude from fees and max transaction amount
1089     mapping(address => bool) private _isExcludedFromFees;
1090     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1091 
1092     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1093     // could be subject to a maximum transfer amount
1094     mapping(address => bool) public automatedMarketMakerPairs;
1095 
1096     event UpdateUniswapV2Router(
1097         address indexed newAddress,
1098         address indexed oldAddress
1099     );
1100 
1101     event ExcludeFromFees(address indexed account, bool isExcluded);
1102 
1103     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1104 
1105     event marketingWalletUpdated(
1106         address indexed newWallet,
1107         address indexed oldWallet
1108     );
1109 
1110     event devWalletUpdated(
1111         address indexed newWallet,
1112         address indexed oldWallet
1113     );
1114 
1115     event SwapAndLiquify(
1116         uint256 tokensSwapped,
1117         uint256 ethReceived,
1118         uint256 tokensIntoLiquidity
1119     );
1120 
1121     event AutoNukeLP();
1122 
1123     event ManualNukeLP();
1124 
1125     constructor() ERC20("Ryukyu", "RYU") {
1126         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1127             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1128         );
1129 
1130         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1131         uniswapV2Router = _uniswapV2Router;
1132 
1133         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1134             .createPair(address(this), _uniswapV2Router.WETH());
1135         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1136         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1137 
1138         uint256 _buyMarketingFee = 88;
1139         uint256 _buyLiquidityFee = 0;
1140         uint256 _buyDevFee = 0;
1141 
1142         uint256 _sellMarketingFee = 88;
1143         uint256 _sellLiquidityFee = 0;
1144         uint256 _sellDevFee = 0;
1145 
1146         uint256 totalSupply = 1_000_000_000 * 1e18;
1147 
1148         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1149         maxWallet = 20_000_000 * 1e18; // 3% from total supply maxWallet
1150         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1151 
1152         buyMarketingFee = _buyMarketingFee;
1153         buyLiquidityFee = _buyLiquidityFee;
1154         buyDevFee = _buyDevFee;
1155         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1156 
1157         sellMarketingFee = _sellMarketingFee;
1158         sellLiquidityFee = _sellLiquidityFee;
1159         sellDevFee = _sellDevFee;
1160         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1161 
1162         marketingWallet = address(0xb68e5D12da294EC4Ef9fdBaDAB4B1B015F946714); // set as marketing wallet
1163         devWallet = address(0xb68e5D12da294EC4Ef9fdBaDAB4B1B015F946714); // set as dev wallet
1164 
1165         // exclude from paying fees or having max transaction amount
1166         excludeFromFees(owner(), true);
1167         excludeFromFees(address(this), true);
1168         excludeFromFees(address(0xdead), true);
1169 
1170         excludeFromMaxTransaction(owner(), true);
1171         excludeFromMaxTransaction(address(this), true);
1172         excludeFromMaxTransaction(address(0xdead), true);
1173 
1174         /*
1175             _mint is an internal function in ERC20.sol that is only called here,
1176             and CANNOT be called ever again
1177         */
1178         _mint(msg.sender, totalSupply);
1179     }
1180 
1181     receive() external payable {}
1182 
1183     // once enabled, can never be turned off
1184     function enableTrading() external onlyOwner {
1185         tradingActive = true;
1186         swapEnabled = true;
1187         lastLpBurnTime = block.timestamp;
1188     }
1189 
1190     // remove limits after token is stable
1191     function removeLimits() external onlyOwner returns (bool) {
1192         limitsInEffect = false;
1193         return true;
1194     }
1195 
1196     // disable Transfer delay - cannot be reenabled
1197     function disableTransferDelay() external onlyOwner returns (bool) {
1198         transferDelayEnabled = false;
1199         return true;
1200     }
1201 
1202     // change the minimum amount of tokens to sell from fees
1203     function updateSwapTokensAtAmount(uint256 newAmount)
1204         external
1205         onlyOwner
1206         returns (bool)
1207     {
1208         require(
1209             newAmount >= (totalSupply() * 1) / 100000,
1210             "Swap amount cannot be lower than 0.001% total supply."
1211         );
1212         require(
1213             newAmount <= (totalSupply() * 5) / 1000,
1214             "Swap amount cannot be higher than 0.5% total supply."
1215         );
1216         swapTokensAtAmount = newAmount;
1217         return true;
1218     }
1219 
1220     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1221         require(
1222             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1223             "Cannot set maxTransactionAmount lower than 0.1%"
1224         );
1225         maxTransactionAmount = newNum * (10**18);
1226     }
1227 
1228     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1229         require(
1230             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1231             "Cannot set maxWallet lower than 0.1%"
1232         );
1233         maxWallet = newNum * (10**18);
1234     }
1235 
1236     function excludeFromMaxTransaction(address updAds, bool isEx)
1237         public
1238         onlyOwner
1239     {
1240         _isExcludedMaxTransactionAmount[updAds] = isEx;
1241     }
1242 
1243     // only use to disable contract sales if absolutely necessary (emergency use only)
1244     function updateSwapEnabled(bool enabled) external onlyOwner {
1245         swapEnabled = enabled;
1246     }
1247 
1248     function updateBuyFees(
1249         uint256 _marketingFee,
1250         uint256 _liquidityFee,
1251         uint256 _devFee
1252     ) external onlyOwner {
1253         buyMarketingFee = _marketingFee;
1254         buyLiquidityFee = _liquidityFee;
1255         buyDevFee = _devFee;
1256         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1257         require(buyTotalFees <= 40, "Must keep fees at 40% or less");
1258     }
1259 
1260     function updateSellFees(
1261         uint256 _marketingFee,
1262         uint256 _liquidityFee,
1263         uint256 _devFee
1264     ) external onlyOwner {
1265         sellMarketingFee = _marketingFee;
1266         sellLiquidityFee = _liquidityFee;
1267         sellDevFee = _devFee;
1268         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1269         require(sellTotalFees <= 40, "Must keep fees at 40% or less");
1270     }
1271 
1272     function excludeFromFees(address account, bool excluded) public onlyOwner {
1273         _isExcludedFromFees[account] = excluded;
1274         emit ExcludeFromFees(account, excluded);
1275     }
1276 
1277     function setAutomatedMarketMakerPair(address pair, bool value)
1278         public
1279         onlyOwner
1280     {
1281         require(
1282             pair != uniswapV2Pair,
1283             "The pair cannot be removed from automatedMarketMakerPairs"
1284         );
1285 
1286         _setAutomatedMarketMakerPair(pair, value);
1287     }
1288 
1289     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1290         automatedMarketMakerPairs[pair] = value;
1291 
1292         emit SetAutomatedMarketMakerPair(pair, value);
1293     }
1294 
1295     function updateMarketingWallet(address newMarketingWallet)
1296         external
1297         onlyOwner
1298     {
1299         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1300         marketingWallet = newMarketingWallet;
1301     }
1302 
1303     function updateDevWallet(address newWallet) external onlyOwner {
1304         emit devWalletUpdated(newWallet, devWallet);
1305         devWallet = newWallet;
1306     }
1307 
1308     function isExcludedFromFees(address account) public view returns (bool) {
1309         return _isExcludedFromFees[account];
1310     }
1311 
1312     event BoughtEarly(address indexed sniper);
1313 
1314     function _transfer(
1315         address from,
1316         address to,
1317         uint256 amount
1318     ) internal override {
1319         require(from != address(0), "ERC20: transfer from the zero address");
1320         require(to != address(0), "ERC20: transfer to the zero address");
1321 
1322         if (amount == 0) {
1323             super._transfer(from, to, 0);
1324             return;
1325         }
1326 
1327         if (limitsInEffect) {
1328             if (
1329                 from != owner() &&
1330                 to != owner() &&
1331                 to != address(0) &&
1332                 to != address(0xdead) &&
1333                 !swapping
1334             ) {
1335                 if (!tradingActive) {
1336                     require(
1337                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1338                         "Trading is not active."
1339                     );
1340                 }
1341 
1342                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1343                 if (transferDelayEnabled) {
1344                     if (
1345                         to != owner() &&
1346                         to != address(uniswapV2Router) &&
1347                         to != address(uniswapV2Pair)
1348                     ) {
1349                         require(
1350                             _holderLastTransferTimestamp[tx.origin] <
1351                                 block.number,
1352                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1353                         );
1354                         _holderLastTransferTimestamp[tx.origin] = block.number;
1355                     }
1356                 }
1357 
1358                 //when buy
1359                 if (
1360                     automatedMarketMakerPairs[from] &&
1361                     !_isExcludedMaxTransactionAmount[to]
1362                 ) {
1363                     require(
1364                         amount <= maxTransactionAmount,
1365                         "Buy transfer amount exceeds the maxTransactionAmount."
1366                     );
1367                     require(
1368                         amount + balanceOf(to) <= maxWallet,
1369                         "Max wallet exceeded"
1370                     );
1371                 }
1372                 //when sell
1373                 else if (
1374                     automatedMarketMakerPairs[to] &&
1375                     !_isExcludedMaxTransactionAmount[from]
1376                 ) {
1377                     require(
1378                         amount <= maxTransactionAmount,
1379                         "Sell transfer amount exceeds the maxTransactionAmount."
1380                     );
1381                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1382                     require(
1383                         amount + balanceOf(to) <= maxWallet,
1384                         "Max wallet exceeded"
1385                     );
1386                 }
1387             }
1388         }
1389 
1390         uint256 contractTokenBalance = balanceOf(address(this));
1391 
1392         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1393 
1394         if (
1395             canSwap &&
1396             swapEnabled &&
1397             !swapping &&
1398             !automatedMarketMakerPairs[from] &&
1399             !_isExcludedFromFees[from] &&
1400             !_isExcludedFromFees[to]
1401         ) {
1402             swapping = true;
1403 
1404             swapBack();
1405 
1406             swapping = false;
1407         }
1408 
1409         if (
1410             !swapping &&
1411             automatedMarketMakerPairs[to] &&
1412             lpBurnEnabled &&
1413             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1414             !_isExcludedFromFees[from]
1415         ) {
1416             autoBurnLiquidityPairTokens();
1417         }
1418 
1419         bool takeFee = !swapping;
1420 
1421         // if any account belongs to _isExcludedFromFee account then remove the fee
1422         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1423             takeFee = false;
1424         }
1425 
1426         uint256 fees = 0;
1427         // only take fees on buys/sells, do not take on wallet transfers
1428         if (takeFee) {
1429             // on sell
1430             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1431                 fees = amount.mul(sellTotalFees).div(100);
1432                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1433                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1434                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1435             }
1436             // on buy
1437             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1438                 fees = amount.mul(buyTotalFees).div(100);
1439                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1440                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1441                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1442             }
1443 
1444             if (fees > 0) {
1445                 super._transfer(from, address(this), fees);
1446             }
1447 
1448             amount -= fees;
1449         }
1450 
1451         super._transfer(from, to, amount);
1452     }
1453 
1454     function swapTokensForEth(uint256 tokenAmount) private {
1455         // generate the uniswap pair path of token -> weth
1456         address[] memory path = new address[](2);
1457         path[0] = address(this);
1458         path[1] = uniswapV2Router.WETH();
1459 
1460         _approve(address(this), address(uniswapV2Router), tokenAmount);
1461 
1462         // make the swap
1463         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1464             tokenAmount,
1465             0, // accept any amount of ETH
1466             path,
1467             address(this),
1468             block.timestamp
1469         );
1470     }
1471 
1472     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1473         // approve token transfer to cover all possible scenarios
1474         _approve(address(this), address(uniswapV2Router), tokenAmount);
1475 
1476         // add the liquidity
1477         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1478             address(this),
1479             tokenAmount,
1480             0, // slippage is unavoidable
1481             0, // slippage is unavoidable
1482             deadAddress,
1483             block.timestamp
1484         );
1485     }
1486 
1487     function swapBack() private {
1488         uint256 contractBalance = balanceOf(address(this));
1489         uint256 totalTokensToSwap = tokensForLiquidity +
1490             tokensForMarketing +
1491             tokensForDev;
1492         bool success;
1493 
1494         if (contractBalance == 0 || totalTokensToSwap == 0) {
1495             return;
1496         }
1497 
1498         if (contractBalance > swapTokensAtAmount * 20) {
1499             contractBalance = swapTokensAtAmount * 20;
1500         }
1501 
1502         // Halve the amount of liquidity tokens
1503         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1504             totalTokensToSwap /
1505             2;
1506         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1507 
1508         uint256 initialETHBalance = address(this).balance;
1509 
1510         swapTokensForEth(amountToSwapForETH);
1511 
1512         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1513 
1514         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1515             totalTokensToSwap
1516         );
1517         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1518 
1519         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1520 
1521         tokensForLiquidity = 0;
1522         tokensForMarketing = 0;
1523         tokensForDev = 0;
1524 
1525         (success, ) = address(devWallet).call{value: ethForDev}("");
1526 
1527         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1528             addLiquidity(liquidityTokens, ethForLiquidity);
1529             emit SwapAndLiquify(
1530                 amountToSwapForETH,
1531                 ethForLiquidity,
1532                 tokensForLiquidity
1533             );
1534         }
1535 
1536         (success, ) = address(marketingWallet).call{
1537             value: address(this).balance
1538         }("");
1539     }
1540 
1541     function setAutoLPBurnSettings(
1542         uint256 _frequencyInSeconds,
1543         uint256 _percent,
1544         bool _Enabled
1545     ) external onlyOwner {
1546         require(
1547             _frequencyInSeconds >= 600,
1548             "cannot set buyback more often than every 10 minutes"
1549         );
1550         require(
1551             _percent <= 1000 && _percent >= 0,
1552             "Must set auto LP burn percent between 0% and 10%"
1553         );
1554         lpBurnFrequency = _frequencyInSeconds;
1555         percentForLPBurn = _percent;
1556         lpBurnEnabled = _Enabled;
1557     }
1558 
1559     function autoBurnLiquidityPairTokens() internal returns (bool) {
1560         lastLpBurnTime = block.timestamp;
1561 
1562         // get balance of liquidity pair
1563         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1564 
1565         // calculate amount to burn
1566         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1567             10000
1568         );
1569 
1570         // pull tokens from pancakePair liquidity and move to dead address permanently
1571         if (amountToBurn > 0) {
1572             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1573         }
1574 
1575         //sync price since this is not in a swap transaction!
1576         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1577         pair.sync();
1578         emit AutoNukeLP();
1579         return true;
1580     }
1581 
1582     function manualBurnLiquidityPairTokens(uint256 percent)
1583         external
1584         onlyOwner
1585         returns (bool)
1586     {
1587         require(
1588             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1589             "Must wait for cooldown to finish"
1590         );
1591         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1592         lastManualLpBurnTime = block.timestamp;
1593 
1594         // get balance of liquidity pair
1595         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1596 
1597         // calculate amount to burn
1598         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1599 
1600         // pull tokens from pancakePair liquidity and move to dead address permanently
1601         if (amountToBurn > 0) {
1602             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1603         }
1604 
1605         //sync price since this is not in a swap transaction!
1606         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1607         pair.sync();
1608         emit ManualNukeLP();
1609         return true;
1610     }
1611 }