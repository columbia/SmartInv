1 /**
2 5 important rules before you join $BITCORN
3 
4 1. Do not beg for calls or expect that team will pay for one.
5 
6 2. BITCORN chads will not be interested in promo offers or Raider offers,just GTFO
7 
8 3. $BITCORN is community driven project that focuses on the community alone.
9 
10 4. Callers are free to call for FREE,do not beg DEV to msg you like a jeet,he won't
11    (No paid calls will be made)
12 5. We aren't interested in web designers,mods,raiders,callers,shillers and any other jeet offers.
13 
14 https://t.me/BitcornProject
15 */
16 
17 // SPDX-License-Identifier: MIT
18 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
19 pragma experimental ABIEncoderV2;
20 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
21 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
22 /* pragma solidity ^0.8.0; */
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
817 /* pragma solidity 0.8.10; */
818 /* pragma experimental ABIEncoderV2; */
819 
820 interface IUniswapV2Factory {
821     event PairCreated(
822         address indexed token0,
823         address indexed token1,
824         address pair,
825         uint256
826     );
827 
828     function feeTo() external view returns (address);
829 
830     function feeToSetter() external view returns (address);
831 
832     function getPair(address tokenA, address tokenB)
833         external
834         view
835         returns (address pair);
836 
837     function allPairs(uint256) external view returns (address pair);
838 
839     function allPairsLength() external view returns (uint256);
840 
841     function createPair(address tokenA, address tokenB)
842         external
843         returns (address pair);
844 
845     function setFeeTo(address) external;
846 
847     function setFeeToSetter(address) external;
848 }
849 
850 /* pragma solidity 0.8.10; */
851 /* pragma experimental ABIEncoderV2; */ 
852 
853 interface IUniswapV2Pair {
854     event Approval(
855         address indexed owner,
856         address indexed spender,
857         uint256 value
858     );
859     event Transfer(address indexed from, address indexed to, uint256 value);
860 
861     function name() external pure returns (string memory);
862 
863     function symbol() external pure returns (string memory);
864 
865     function decimals() external pure returns (uint8);
866 
867     function totalSupply() external view returns (uint256);
868 
869     function balanceOf(address owner) external view returns (uint256);
870 
871     function allowance(address owner, address spender)
872         external
873         view
874         returns (uint256);
875 
876     function approve(address spender, uint256 value) external returns (bool);
877 
878     function transfer(address to, uint256 value) external returns (bool);
879 
880     function transferFrom(
881         address from,
882         address to,
883         uint256 value
884     ) external returns (bool);
885 
886     function DOMAIN_SEPARATOR() external view returns (bytes32);
887 
888     function PERMIT_TYPEHASH() external pure returns (bytes32);
889 
890     function nonces(address owner) external view returns (uint256);
891 
892     function permit(
893         address owner,
894         address spender,
895         uint256 value,
896         uint256 deadline,
897         uint8 v,
898         bytes32 r,
899         bytes32 s
900     ) external;
901 
902     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
903     event Burn(
904         address indexed sender,
905         uint256 amount0,
906         uint256 amount1,
907         address indexed to
908     );
909     event Swap(
910         address indexed sender,
911         uint256 amount0In,
912         uint256 amount1In,
913         uint256 amount0Out,
914         uint256 amount1Out,
915         address indexed to
916     );
917     event Sync(uint112 reserve0, uint112 reserve1);
918 
919     function MINIMUM_LIQUIDITY() external pure returns (uint256);
920 
921     function factory() external view returns (address);
922 
923     function token0() external view returns (address);
924 
925     function token1() external view returns (address);
926 
927     function getReserves()
928         external
929         view
930         returns (
931             uint112 reserve0,
932             uint112 reserve1,
933             uint32 blockTimestampLast
934         );
935 
936     function price0CumulativeLast() external view returns (uint256);
937 
938     function price1CumulativeLast() external view returns (uint256);
939 
940     function kLast() external view returns (uint256);
941 
942     function mint(address to) external returns (uint256 liquidity);
943 
944     function burn(address to)
945         external
946         returns (uint256 amount0, uint256 amount1);
947 
948     function swap(
949         uint256 amount0Out,
950         uint256 amount1Out,
951         address to,
952         bytes calldata data
953     ) external;
954 
955     function skim(address to) external;
956 
957     function sync() external;
958 
959     function initialize(address, address) external;
960 }
961 
962 /* pragma solidity 0.8.10; */
963 /* pragma experimental ABIEncoderV2; */
964 
965 interface IUniswapV2Router02 {
966     function factory() external pure returns (address);
967 
968     function WETH() external pure returns (address);
969 
970     function addLiquidity(
971         address tokenA,
972         address tokenB,
973         uint256 amountADesired,
974         uint256 amountBDesired,
975         uint256 amountAMin,
976         uint256 amountBMin,
977         address to,
978         uint256 deadline
979     )
980         external
981         returns (
982             uint256 amountA,
983             uint256 amountB,
984             uint256 liquidity
985         );
986 
987     function addLiquidityETH(
988         address token,
989         uint256 amountTokenDesired,
990         uint256 amountTokenMin,
991         uint256 amountETHMin,
992         address to,
993         uint256 deadline
994     )
995         external
996         payable
997         returns (
998             uint256 amountToken,
999             uint256 amountETH,
1000             uint256 liquidity
1001         );
1002 
1003     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1004         uint256 amountIn,
1005         uint256 amountOutMin,
1006         address[] calldata path,
1007         address to,
1008         uint256 deadline
1009     ) external;
1010 
1011     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1012         uint256 amountOutMin,
1013         address[] calldata path,
1014         address to,
1015         uint256 deadline
1016     ) external payable;
1017 
1018     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1019         uint256 amountIn,
1020         uint256 amountOutMin,
1021         address[] calldata path,
1022         address to,
1023         uint256 deadline
1024     ) external;
1025 }
1026 
1027 /* pragma solidity >=0.8.10; */
1028 
1029 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1030 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1031 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1032 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1033 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1034 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1035 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1036 
1037 contract BITCORNPROJECT is ERC20, Ownable {
1038     using SafeMath for uint256;
1039 
1040     IUniswapV2Router02 public immutable uniswapV2Router;
1041     address public immutable uniswapV2Pair;
1042     address public constant deadAddress = address(0xdead);
1043 
1044     bool private swapping;
1045 
1046 	address public charityWallet;
1047     address public marketingWallet;
1048     address public devWallet;
1049 
1050     uint256 public maxTransactionAmount;
1051     uint256 public swapTokensAtAmount;
1052     uint256 public maxWallet;
1053 
1054     bool public limitsInEffect = true;
1055     bool public tradingActive = true;
1056     bool public swapEnabled = true;
1057 
1058     // Anti-bot and anti-whale mappings and variables
1059     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1060     bool public transferDelayEnabled = true;
1061 
1062     uint256 public buyTotalFees;
1063 	uint256 public buyCharityFee;
1064     uint256 public buyMarketingFee;
1065     uint256 public buyLiquidityFee;
1066     uint256 public buyDevFee;
1067 
1068     uint256 public sellTotalFees;
1069 	uint256 public sellCharityFee;
1070     uint256 public sellMarketingFee;
1071     uint256 public sellLiquidityFee;
1072     uint256 public sellDevFee;
1073 
1074 	uint256 public tokensForCharity;
1075     uint256 public tokensForMarketing;
1076     uint256 public tokensForLiquidity;
1077     uint256 public tokensForDev;
1078 
1079     /******************/
1080 
1081     // exlcude from fees and max transaction amount
1082     mapping(address => bool) private _isExcludedFromFees;
1083     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1084 
1085     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1086     // could be subject to a maximum transfer amount
1087     mapping(address => bool) public automatedMarketMakerPairs;
1088 
1089     event UpdateUniswapV2Router(
1090         address indexed newAddress,
1091         address indexed oldAddress
1092     );
1093 
1094     event ExcludeFromFees(address indexed account, bool isExcluded);
1095 
1096     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1097 
1098     event SwapAndLiquify(
1099         uint256 tokensSwapped,
1100         uint256 ethReceived,
1101         uint256 tokensIntoLiquidity
1102     );
1103 
1104     constructor() ERC20("Bitcorn", "BITCORN") {
1105         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1106             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1107         );
1108 
1109         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1110         uniswapV2Router = _uniswapV2Router;
1111 
1112         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1113             .createPair(address(this), _uniswapV2Router.WETH());
1114         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1115         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1116 
1117 		uint256 _buyCharityFee = 0;
1118         uint256 _buyMarketingFee = 13;
1119         uint256 _buyLiquidityFee = 2;
1120         uint256 _buyDevFee = 0;
1121 
1122 		uint256 _sellCharityFee = 0;
1123         uint256 _sellMarketingFee = 13;
1124         uint256 _sellLiquidityFee = 2;
1125         uint256 _sellDevFee = 0;
1126 
1127         uint256 totalSupply = 21000000 * 1e18;
1128 
1129         maxTransactionAmount = 210000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1130         maxWallet = 210000 * 1e18; // 2% from total supply maxWallet
1131         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1132 
1133 		buyCharityFee = _buyCharityFee;
1134         buyMarketingFee = _buyMarketingFee;
1135         buyLiquidityFee = _buyLiquidityFee;
1136         buyDevFee = _buyDevFee;
1137         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1138 
1139 		sellCharityFee = _sellCharityFee;
1140         sellMarketingFee = _sellMarketingFee;
1141         sellLiquidityFee = _sellLiquidityFee;
1142         sellDevFee = _sellDevFee;
1143         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1144 
1145 		charityWallet = address(0xB413193Bc2f98933084f6F26A0a8E3c76AD4A255); // set as charity wallet
1146         marketingWallet = address(0xB413193Bc2f98933084f6F26A0a8E3c76AD4A255); // set as marketing wallet
1147         devWallet = address(0xB413193Bc2f98933084f6F26A0a8E3c76AD4A255); // set as dev wallet
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
1171     }
1172 
1173     // remove limits after token is stable
1174     function removeLimits() external onlyOwner returns (bool) {
1175         limitsInEffect = false;
1176         return true;
1177     }
1178 
1179     // disable Transfer delay - cannot be reenabled
1180     function disableTransferDelay() external onlyOwner returns (bool) {
1181         transferDelayEnabled = false;
1182         return true;
1183     }
1184 
1185     // change the minimum amount of tokens to sell from fees
1186     function updateSwapTokensAtAmount(uint256 newAmount)
1187         external
1188         onlyOwner
1189         returns (bool)
1190     {
1191         require(
1192             newAmount >= (totalSupply() * 1) / 100000,
1193             "Swap amount cannot be lower than 0.001% total supply."
1194         );
1195         require(
1196             newAmount <= (totalSupply() * 5) / 1000,
1197             "Swap amount cannot be higher than 0.5% total supply."
1198         );
1199         swapTokensAtAmount = newAmount;
1200         return true;
1201     }
1202 
1203     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1204         require(
1205             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1206             "Cannot set maxTransactionAmount lower than 0.5%"
1207         );
1208         maxTransactionAmount = newNum * (10**18);
1209     }
1210 
1211     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1212         require(
1213             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1214             "Cannot set maxWallet lower than 0.5%"
1215         );
1216         maxWallet = newNum * (10**18);
1217     }
1218 	
1219     function excludeFromMaxTransaction(address updAds, bool isEx)
1220         public
1221         onlyOwner
1222     {
1223         _isExcludedMaxTransactionAmount[updAds] = isEx;
1224     }
1225 
1226     // only use to disable contract sales if absolutely necessary (emergency use only)
1227     function updateSwapEnabled(bool enabled) external onlyOwner {
1228         swapEnabled = enabled;
1229     }
1230 
1231     function updateBuyFees(
1232 		uint256 _charityFee,
1233         uint256 _marketingFee,
1234         uint256 _liquidityFee,
1235         uint256 _devFee
1236     ) external onlyOwner {
1237 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1238 		buyCharityFee = _charityFee;
1239         buyMarketingFee = _marketingFee;
1240         buyLiquidityFee = _liquidityFee;
1241         buyDevFee = _devFee;
1242         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1243      }
1244 
1245     function updateSellFees(
1246 		uint256 _charityFee,
1247         uint256 _marketingFee,
1248         uint256 _liquidityFee,
1249         uint256 _devFee
1250     ) external onlyOwner {
1251 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1252 		sellCharityFee = _charityFee;
1253         sellMarketingFee = _marketingFee;
1254         sellLiquidityFee = _liquidityFee;
1255         sellDevFee = _devFee;
1256         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1257     }
1258 
1259     function excludeFromFees(address account, bool excluded) public onlyOwner {
1260         _isExcludedFromFees[account] = excluded;
1261         emit ExcludeFromFees(account, excluded);
1262     }
1263 
1264     function setAutomatedMarketMakerPair(address pair, bool value)
1265         public
1266         onlyOwner
1267     {
1268         require(
1269             pair != uniswapV2Pair,
1270             "The pair cannot be removed from automatedMarketMakerPairs"
1271         );
1272 
1273         _setAutomatedMarketMakerPair(pair, value);
1274     }
1275 
1276     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1277         automatedMarketMakerPairs[pair] = value;
1278 
1279         emit SetAutomatedMarketMakerPair(pair, value);
1280     }
1281 
1282     function isExcludedFromFees(address account) public view returns (bool) {
1283         return _isExcludedFromFees[account];
1284     }
1285 
1286     function _transfer(
1287         address from,
1288         address to,
1289         uint256 amount
1290     ) internal override {
1291         require(from != address(0), "ERC20: transfer from the zero address");
1292         require(to != address(0), "ERC20: transfer to the zero address");
1293 
1294         if (amount == 0) {
1295             super._transfer(from, to, 0);
1296             return;
1297         }
1298 
1299         if (limitsInEffect) {
1300             if (
1301                 from != owner() &&
1302                 to != owner() &&
1303                 to != address(0) &&
1304                 to != address(0xdead) &&
1305                 !swapping
1306             ) {
1307                 if (!tradingActive) {
1308                     require(
1309                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1310                         "Trading is not active."
1311                     );
1312                 }
1313 
1314                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1315                 if (transferDelayEnabled) {
1316                     if (
1317                         to != owner() &&
1318                         to != address(uniswapV2Router) &&
1319                         to != address(uniswapV2Pair)
1320                     ) {
1321                         require(
1322                             _holderLastTransferTimestamp[tx.origin] <
1323                                 block.number,
1324                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1325                         );
1326                         _holderLastTransferTimestamp[tx.origin] = block.number;
1327                     }
1328                 }
1329 
1330                 //when buy
1331                 if (
1332                     automatedMarketMakerPairs[from] &&
1333                     !_isExcludedMaxTransactionAmount[to]
1334                 ) {
1335                     require(
1336                         amount <= maxTransactionAmount,
1337                         "Buy transfer amount exceeds the maxTransactionAmount."
1338                     );
1339                     require(
1340                         amount + balanceOf(to) <= maxWallet,
1341                         "Max wallet exceeded"
1342                     );
1343                 }
1344                 //when sell
1345                 else if (
1346                     automatedMarketMakerPairs[to] &&
1347                     !_isExcludedMaxTransactionAmount[from]
1348                 ) {
1349                     require(
1350                         amount <= maxTransactionAmount,
1351                         "Sell transfer amount exceeds the maxTransactionAmount."
1352                     );
1353                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1354                     require(
1355                         amount + balanceOf(to) <= maxWallet,
1356                         "Max wallet exceeded"
1357                     );
1358                 }
1359             }
1360         }
1361 
1362         uint256 contractTokenBalance = balanceOf(address(this));
1363 
1364         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1365 
1366         if (
1367             canSwap &&
1368             swapEnabled &&
1369             !swapping &&
1370             !automatedMarketMakerPairs[from] &&
1371             !_isExcludedFromFees[from] &&
1372             !_isExcludedFromFees[to]
1373         ) {
1374             swapping = true;
1375 
1376             swapBack();
1377 
1378             swapping = false;
1379         }
1380 
1381         bool takeFee = !swapping;
1382 
1383         // if any account belongs to _isExcludedFromFee account then remove the fee
1384         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1385             takeFee = false;
1386         }
1387 
1388         uint256 fees = 0;
1389         // only take fees on buys/sells, do not take on wallet transfers
1390         if (takeFee) {
1391             // on sell
1392             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1393                 fees = amount.mul(sellTotalFees).div(100);
1394 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1395                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1396                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1397                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1398             }
1399             // on buy
1400             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1401                 fees = amount.mul(buyTotalFees).div(100);
1402 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1403                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1404                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1405                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1406             }
1407 
1408             if (fees > 0) {
1409                 super._transfer(from, address(this), fees);
1410             }
1411 
1412             amount -= fees;
1413         }
1414 
1415         super._transfer(from, to, amount);
1416     }
1417 
1418     function swapTokensForEth(uint256 tokenAmount) private {
1419         // generate the uniswap pair path of token -> weth
1420         address[] memory path = new address[](2);
1421         path[0] = address(this);
1422         path[1] = uniswapV2Router.WETH();
1423 
1424         _approve(address(this), address(uniswapV2Router), tokenAmount);
1425 
1426         // make the swap
1427         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1428             tokenAmount,
1429             0, // accept any amount of ETH
1430             path,
1431             address(this),
1432             block.timestamp
1433         );
1434     }
1435 
1436     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1437         // approve token transfer to cover all possible scenarios
1438         _approve(address(this), address(uniswapV2Router), tokenAmount);
1439 
1440         // add the liquidity
1441         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1442             address(this),
1443             tokenAmount,
1444             0, // slippage is unavoidable
1445             0, // slippage is unavoidable
1446             devWallet,
1447             block.timestamp
1448         );
1449     }
1450 
1451     function swapBack() private {
1452         uint256 contractBalance = balanceOf(address(this));
1453         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1454         bool success;
1455 
1456         if (contractBalance == 0 || totalTokensToSwap == 0) {
1457             return;
1458         }
1459 
1460         if (contractBalance > swapTokensAtAmount * 20) {
1461             contractBalance = swapTokensAtAmount * 20;
1462         }
1463 
1464         // Halve the amount of liquidity tokens
1465         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1466         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1467 
1468         uint256 initialETHBalance = address(this).balance;
1469 
1470         swapTokensForEth(amountToSwapForETH);
1471 
1472         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1473 
1474 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1475         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1476         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1477 
1478         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1479 
1480         tokensForLiquidity = 0;
1481 		tokensForCharity = 0;
1482         tokensForMarketing = 0;
1483         tokensForDev = 0;
1484 
1485         (success, ) = address(devWallet).call{value: ethForDev}("");
1486         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1487 
1488 
1489         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1490             addLiquidity(liquidityTokens, ethForLiquidity);
1491             emit SwapAndLiquify(
1492                 amountToSwapForETH,
1493                 ethForLiquidity,
1494                 tokensForLiquidity
1495             );
1496         }
1497 
1498         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1499     }
1500 
1501 }