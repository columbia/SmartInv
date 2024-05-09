1 /*
2 
3 Telegram: https://t.me/AthariPlayer
4 Website: http://Athariplayer.com
5 Twitter: https://twitter.com/athariplayer
6 Medium: https://medium.com/@AthariPlayer
7 
8 
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
14 pragma experimental ABIEncoderV2;
15 
16 
17 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
18 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
19 
20 /* pragma solidity ^0.8.0; */
21 
22 /**
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
43 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
44 
45 /* pragma solidity ^0.8.0; */
46 
47 /* import "../utils/Context.sol"; */
48 
49 /**
50  * @dev Contract module which provides a basic access control mechanism, where
51  * there is an account (an owner) that can be granted exclusive access to
52  * specific functions.
53  *
54  * By default, the owner account will be the one that deploys the contract. This
55  * can later be changed with {transferOwnership}.
56  *
57  * This module is used through inheritance. It will make available the modifier
58  * `onlyOwner`, which can be applied to your functions to restrict their use to
59  * the owner.
60  */
61 abstract contract Ownable is Context {
62     address private _owner;
63 
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     /**
67      * @dev Initializes the contract setting the deployer as the initial owner.
68      */
69     constructor() {
70         _transferOwnership(_msgSender());
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view virtual returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOwner() {
84         require(owner() == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     /**
89      * @dev Leaves the contract without owner. It will not be possible to call
90      * `onlyOwner` functions anymore. Can only be called by the current owner.
91      *
92      * NOTE: Renouncing ownership will leave the contract without an owner,
93      * thereby removing any functionality that is only available to the owner.
94      */
95     function renounceOwnership() public virtual onlyOwner {
96         _transferOwnership(address(0));
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         _transferOwnership(newOwner);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Internal function without access restriction.
111      */
112     function _transferOwnership(address newOwner) internal virtual {
113         address oldOwner = _owner;
114         _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
120 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
121 
122 /* pragma solidity ^0.8.0; */
123 
124 /**
125  * @dev Interface of the ERC20 standard as defined in the EIP.
126  */
127 interface IERC20 {
128     /**
129      * @dev Returns the amount of tokens in existence.
130      */
131     function totalSupply() external view returns (uint256);
132 
133     /**
134      * @dev Returns the amount of tokens owned by `account`.
135      */
136     function balanceOf(address account) external view returns (uint256);
137 
138     /**
139      * @dev Moves `amount` tokens from the caller's account to `recipient`.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transfer(address recipient, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Returns the remaining number of tokens that `spender` will be
149      * allowed to spend on behalf of `owner` through {transferFrom}. This is
150      * zero by default.
151      *
152      * This value changes when {approve} or {transferFrom} are called.
153      */
154     function allowance(address owner, address spender) external view returns (uint256);
155 
156     /**
157      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * IMPORTANT: Beware that changing an allowance with this method brings the risk
162      * that someone may use both the old and the new allowance by unfortunate
163      * transaction ordering. One possible solution to mitigate this race
164      * condition is to first reduce the spender's allowance to 0 and set the
165      * desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      *
168      * Emits an {Approval} event.
169      */
170     function approve(address spender, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Moves `amount` tokens from `sender` to `recipient` using the
174      * allowance mechanism. `amount` is then deducted from the caller's
175      * allowance.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(
182         address sender,
183         address recipient,
184         uint256 amount
185     ) external returns (bool);
186 
187     /**
188      * @dev Emitted when `value` tokens are moved from one account (`from`) to
189      * another (`to`).
190      *
191      * Note that `value` may be zero.
192      */
193     event Transfer(address indexed from, address indexed to, uint256 value);
194 
195     /**
196      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
197      * a call to {approve}. `value` is the new allowance.
198      */
199     event Approval(address indexed owner, address indexed spender, uint256 value);
200 }
201 
202 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
203 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
204 
205 /* pragma solidity ^0.8.0; */
206 
207 /* import "../IERC20.sol"; */
208 
209 /**
210  * @dev Interface for the optional metadata functions from the ERC20 standard.
211  *
212  * _Available since v4.1._
213  */
214 interface IERC20Metadata is IERC20 {
215     /**
216      * @dev Returns the name of the token.
217      */
218     function name() external view returns (string memory);
219 
220     /**
221      * @dev Returns the symbol of the token.
222      */
223     function symbol() external view returns (string memory);
224 
225     /**
226      * @dev Returns the decimals places of the token.
227      */
228     function decimals() external view returns (uint8);
229 }
230 
231 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
232 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
233 
234 /* pragma solidity ^0.8.0; */
235 
236 /* import "./IERC20.sol"; */
237 /* import "./extensions/IERC20Metadata.sol"; */
238 /* import "../../utils/Context.sol"; */
239 
240 /**
241  * @dev Implementation of the {IERC20} interface.
242  *
243  * This implementation is agnostic to the way tokens are created. This means
244  * that a supply mechanism has to be added in a derived contract using {_mint}.
245  * For a generic mechanism see {ERC20PresetMinterPauser}.
246  *
247  * TIP: For a detailed writeup see our guide
248  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
249  * to implement supply mechanisms].
250  *
251  * We have followed general OpenZeppelin Contracts guidelines: functions revert
252  * instead returning `false` on failure. This behavior is nonetheless
253  * conventional and does not conflict with the expectations of ERC20
254  * applications.
255  *
256  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
257  * This allows applications to reconstruct the allowance for all accounts just
258  * by listening to said events. Other implementations of the EIP may not emit
259  * these events, as it isn't required by the specification.
260  *
261  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
262  * functions have been added to mitigate the well-known issues around setting
263  * allowances. See {IERC20-approve}.
264  */
265 contract ERC20 is Context, IERC20, IERC20Metadata {
266     mapping(address => uint256) private _balances;
267 
268     mapping(address => mapping(address => uint256)) private _allowances;
269 
270     uint256 private _totalSupply;
271 
272     string private _name;
273     string private _symbol;
274 
275     /**
276      * @dev Sets the values for {name} and {symbol}.
277      *
278      * The default value of {decimals} is 18. To select a different value for
279      * {decimals} you should overload it.
280      *
281      * All two of these values are immutable: they can only be set once during
282      * construction.
283      */
284     constructor(string memory name_, string memory symbol_) {
285         _name = name_;
286         _symbol = symbol_;
287     }
288 
289     /**
290      * @dev Returns the name of the token.
291      */
292     function name() public view virtual override returns (string memory) {
293         return _name;
294     }
295 
296     /**
297      * @dev Returns the symbol of the token, usually a shorter version of the
298      * name.
299      */
300     function symbol() public view virtual override returns (string memory) {
301         return _symbol;
302     }
303 
304     /**
305      * @dev Returns the number of decimals used to get its user representation.
306      * For example, if `decimals` equals `2`, a balance of `505` tokens should
307      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
308      *
309      * Tokens usually opt for a value of 18, imitating the relationship between
310      * Ether and Wei. This is the value {ERC20} uses, unless this function is
311      * overridden;
312      *
313      * NOTE: This information is only used for _display_ purposes: it in
314      * no way affects any of the arithmetic of the contract, including
315      * {IERC20-balanceOf} and {IERC20-transfer}.
316      */
317     function decimals() public view virtual override returns (uint8) {
318         return 18;
319     }
320 
321     /**
322      * @dev See {IERC20-totalSupply}.
323      */
324     function totalSupply() public view virtual override returns (uint256) {
325         return _totalSupply;
326     }
327 
328     /**
329      * @dev See {IERC20-balanceOf}.
330      */
331     function balanceOf(address account) public view virtual override returns (uint256) {
332         return _balances[account];
333     }
334 
335     /**
336      * @dev See {IERC20-transfer}.
337      *
338      * Requirements:
339      *
340      * - `recipient` cannot be the zero address.
341      * - the caller must have a balance of at least `amount`.
342      */
343     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
344         _transfer(_msgSender(), recipient, amount);
345         return true;
346     }
347 
348     /**
349      * @dev See {IERC20-allowance}.
350      */
351     function allowance(address owner, address spender) public view virtual override returns (uint256) {
352         return _allowances[owner][spender];
353     }
354 
355     /**
356      * @dev See {IERC20-approve}.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      */
362     function approve(address spender, uint256 amount) public virtual override returns (bool) {
363         _approve(_msgSender(), spender, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-transferFrom}.
369      *
370      * Emits an {Approval} event indicating the updated allowance. This is not
371      * required by the EIP. See the note at the beginning of {ERC20}.
372      *
373      * Requirements:
374      *
375      * - `sender` and `recipient` cannot be the zero address.
376      * - `sender` must have a balance of at least `amount`.
377      * - the caller must have allowance for ``sender``'s tokens of at least
378      * `amount`.
379      */
380     function transferFrom(
381         address sender,
382         address recipient,
383         uint256 amount
384     ) public virtual override returns (bool) {
385         _transfer(sender, recipient, amount);
386 
387         uint256 currentAllowance = _allowances[sender][_msgSender()];
388         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
389         unchecked {
390             _approve(sender, _msgSender(), currentAllowance - amount);
391         }
392 
393         return true;
394     }
395 
396     /**
397      * @dev Atomically increases the allowance granted to `spender` by the caller.
398      *
399      * This is an alternative to {approve} that can be used as a mitigation for
400      * problems described in {IERC20-approve}.
401      *
402      * Emits an {Approval} event indicating the updated allowance.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      */
408     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
409         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
410         return true;
411     }
412 
413     /**
414      * @dev Atomically decreases the allowance granted to `spender` by the caller.
415      *
416      * This is an alternative to {approve} that can be used as a mitigation for
417      * problems described in {IERC20-approve}.
418      *
419      * Emits an {Approval} event indicating the updated allowance.
420      *
421      * Requirements:
422      *
423      * - `spender` cannot be the zero address.
424      * - `spender` must have allowance for the caller of at least
425      * `subtractedValue`.
426      */
427     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
428         uint256 currentAllowance = _allowances[_msgSender()][spender];
429         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
430         unchecked {
431             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
432         }
433 
434         return true;
435     }
436 
437     /**
438      * @dev Moves `amount` of tokens from `sender` to `recipient`.
439      *
440      * This internal function is equivalent to {transfer}, and can be used to
441      * e.g. implement automatic token fees, slashing mechanisms, etc.
442      *
443      * Emits a {Transfer} event.
444      *
445      * Requirements:
446      *
447      * - `sender` cannot be the zero address.
448      * - `recipient` cannot be the zero address.
449      * - `sender` must have a balance of at least `amount`.
450      */
451     function _transfer(
452         address sender,
453         address recipient,
454         uint256 amount
455     ) internal virtual {
456         require(sender != address(0), "ERC20: transfer from the zero address");
457         require(recipient != address(0), "ERC20: transfer to the zero address");
458 
459         _beforeTokenTransfer(sender, recipient, amount);
460 
461         uint256 senderBalance = _balances[sender];
462         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
463         unchecked {
464             _balances[sender] = senderBalance - amount;
465         }
466         _balances[recipient] += amount;
467 
468         emit Transfer(sender, recipient, amount);
469 
470         _afterTokenTransfer(sender, recipient, amount);
471     }
472 
473     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
474      * the total supply.
475      *
476      * Emits a {Transfer} event with `from` set to the zero address.
477      *
478      * Requirements:
479      *
480      * - `account` cannot be the zero address.
481      */
482     function _mint(address account, uint256 amount) internal virtual {
483         require(account != address(0), "ERC20: mint to the zero address");
484 
485         _beforeTokenTransfer(address(0), account, amount);
486 
487         _totalSupply += amount;
488         _balances[account] += amount;
489         emit Transfer(address(0), account, amount);
490 
491         _afterTokenTransfer(address(0), account, amount);
492     }
493 
494     /**
495      * @dev Destroys `amount` tokens from `account`, reducing the
496      * total supply.
497      *
498      * Emits a {Transfer} event with `to` set to the zero address.
499      *
500      * Requirements:
501      *
502      * - `account` cannot be the zero address.
503      * - `account` must have at least `amount` tokens.
504      */
505     function _burn(address account, uint256 amount) internal virtual {
506         require(account != address(0), "ERC20: burn from the zero address");
507 
508         _beforeTokenTransfer(account, address(0), amount);
509 
510         uint256 accountBalance = _balances[account];
511         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
512         unchecked {
513             _balances[account] = accountBalance - amount;
514         }
515         _totalSupply -= amount;
516 
517         emit Transfer(account, address(0), amount);
518 
519         _afterTokenTransfer(account, address(0), amount);
520     }
521 
522     /**
523      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
524      *
525      * This internal function is equivalent to `approve`, and can be used to
526      * e.g. set automatic allowances for certain subsystems, etc.
527      *
528      * Emits an {Approval} event.
529      *
530      * Requirements:
531      *
532      * - `owner` cannot be the zero address.
533      * - `spender` cannot be the zero address.
534      */
535     function _approve(
536         address owner,
537         address spender,
538         uint256 amount
539     ) internal virtual {
540         require(owner != address(0), "ERC20: approve from the zero address");
541         require(spender != address(0), "ERC20: approve to the zero address");
542 
543         _allowances[owner][spender] = amount;
544         emit Approval(owner, spender, amount);
545     }
546 
547     /**
548      * @dev Hook that is called before any transfer of tokens. This includes
549      * minting and burning.
550      *
551      * Calling conditions:
552      *
553      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
554      * will be transferred to `to`.
555      * - when `from` is zero, `amount` tokens will be minted for `to`.
556      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
557      * - `from` and `to` are never both zero.
558      *
559      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
560      */
561     function _beforeTokenTransfer(
562         address from,
563         address to,
564         uint256 amount
565     ) internal virtual {}
566 
567     /**
568      * @dev Hook that is called after any transfer of tokens. This includes
569      * minting and burning.
570      *
571      * Calling conditions:
572      *
573      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
574      * has been transferred to `to`.
575      * - when `from` is zero, `amount` tokens have been minted for `to`.
576      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
577      * - `from` and `to` are never both zero.
578      *
579      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
580      */
581     function _afterTokenTransfer(
582         address from,
583         address to,
584         uint256 amount
585     ) internal virtual {}
586 }
587 
588 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
589 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
590 
591 /* pragma solidity ^0.8.0; */
592 
593 // CAUTION
594 // This version of SafeMath should only be used with Solidity 0.8 or later,
595 // because it relies on the compiler's built in overflow checks.
596 
597 /**
598  * @dev Wrappers over Solidity's arithmetic operations.
599  *
600  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
601  * now has built in overflow checking.
602  */
603 library SafeMath {
604     /**
605      * @dev Returns the addition of two unsigned integers, with an overflow flag.
606      *
607      * _Available since v3.4._
608      */
609     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
610         unchecked {
611             uint256 c = a + b;
612             if (c < a) return (false, 0);
613             return (true, c);
614         }
615     }
616 
617     /**
618      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
619      *
620      * _Available since v3.4._
621      */
622     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
623         unchecked {
624             if (b > a) return (false, 0);
625             return (true, a - b);
626         }
627     }
628 
629     /**
630      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
631      *
632      * _Available since v3.4._
633      */
634     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
635         unchecked {
636             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
637             // benefit is lost if 'b' is also tested.
638             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
639             if (a == 0) return (true, 0);
640             uint256 c = a * b;
641             if (c / a != b) return (false, 0);
642             return (true, c);
643         }
644     }
645 
646     /**
647      * @dev Returns the division of two unsigned integers, with a division by zero flag.
648      *
649      * _Available since v3.4._
650      */
651     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
652         unchecked {
653             if (b == 0) return (false, 0);
654             return (true, a / b);
655         }
656     }
657 
658     /**
659      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
660      *
661      * _Available since v3.4._
662      */
663     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
664         unchecked {
665             if (b == 0) return (false, 0);
666             return (true, a % b);
667         }
668     }
669 
670     /**
671      * @dev Returns the addition of two unsigned integers, reverting on
672      * overflow.
673      *
674      * Counterpart to Solidity's `+` operator.
675      *
676      * Requirements:
677      *
678      * - Addition cannot overflow.
679      */
680     function add(uint256 a, uint256 b) internal pure returns (uint256) {
681         return a + b;
682     }
683 
684     /**
685      * @dev Returns the subtraction of two unsigned integers, reverting on
686      * overflow (when the result is negative).
687      *
688      * Counterpart to Solidity's `-` operator.
689      *
690      * Requirements:
691      *
692      * - Subtraction cannot overflow.
693      */
694     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a - b;
696     }
697 
698     /**
699      * @dev Returns the multiplication of two unsigned integers, reverting on
700      * overflow.
701      *
702      * Counterpart to Solidity's `*` operator.
703      *
704      * Requirements:
705      *
706      * - Multiplication cannot overflow.
707      */
708     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
709         return a * b;
710     }
711 
712     /**
713      * @dev Returns the integer division of two unsigned integers, reverting on
714      * division by zero. The result is rounded towards zero.
715      *
716      * Counterpart to Solidity's `/` operator.
717      *
718      * Requirements:
719      *
720      * - The divisor cannot be zero.
721      */
722     function div(uint256 a, uint256 b) internal pure returns (uint256) {
723         return a / b;
724     }
725 
726     /**
727      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
728      * reverting when dividing by zero.
729      *
730      * Counterpart to Solidity's `%` operator. This function uses a `revert`
731      * opcode (which leaves remaining gas untouched) while Solidity uses an
732      * invalid opcode to revert (consuming all remaining gas).
733      *
734      * Requirements:
735      *
736      * - The divisor cannot be zero.
737      */
738     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
739         return a % b;
740     }
741 
742     /**
743      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
744      * overflow (when the result is negative).
745      *
746      * CAUTION: This function is deprecated because it requires allocating memory for the error
747      * message unnecessarily. For custom revert reasons use {trySub}.
748      *
749      * Counterpart to Solidity's `-` operator.
750      *
751      * Requirements:
752      *
753      * - Subtraction cannot overflow.
754      */
755     function sub(
756         uint256 a,
757         uint256 b,
758         string memory errorMessage
759     ) internal pure returns (uint256) {
760         unchecked {
761             require(b <= a, errorMessage);
762             return a - b;
763         }
764     }
765 
766     /**
767      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
768      * division by zero. The result is rounded towards zero.
769      *
770      * Counterpart to Solidity's `/` operator. Note: this function uses a
771      * `revert` opcode (which leaves remaining gas untouched) while Solidity
772      * uses an invalid opcode to revert (consuming all remaining gas).
773      *
774      * Requirements:
775      *
776      * - The divisor cannot be zero.
777      */
778     function div(
779         uint256 a,
780         uint256 b,
781         string memory errorMessage
782     ) internal pure returns (uint256) {
783         unchecked {
784             require(b > 0, errorMessage);
785             return a / b;
786         }
787     }
788 
789     /**
790      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
791      * reverting with custom message when dividing by zero.
792      *
793      * CAUTION: This function is deprecated because it requires allocating memory for the error
794      * message unnecessarily. For custom revert reasons use {tryMod}.
795      *
796      * Counterpart to Solidity's `%` operator. This function uses a `revert`
797      * opcode (which leaves remaining gas untouched) while Solidity uses an
798      * invalid opcode to revert (consuming all remaining gas).
799      *
800      * Requirements:
801      *
802      * - The divisor cannot be zero.
803      */
804     function mod(
805         uint256 a,
806         uint256 b,
807         string memory errorMessage
808     ) internal pure returns (uint256) {
809         unchecked {
810             require(b > 0, errorMessage);
811             return a % b;
812         }
813     }
814 }
815 
816 /* pragma solidity 0.8.10; */
817 /* pragma experimental ABIEncoderV2; */
818 
819 interface IUniswapV2Factory {
820     event PairCreated(
821         address indexed token0,
822         address indexed token1,
823         address pair,
824         uint256
825     );
826 
827     function feeTo() external view returns (address);
828 
829     function feeToSetter() external view returns (address);
830 
831     function getPair(address tokenA, address tokenB)
832         external
833         view
834         returns (address pair);
835 
836     function allPairs(uint256) external view returns (address pair);
837 
838     function allPairsLength() external view returns (uint256);
839 
840     function createPair(address tokenA, address tokenB)
841         external
842         returns (address pair);
843 
844     function setFeeTo(address) external;
845 
846     function setFeeToSetter(address) external;
847 }
848 
849 /* pragma solidity 0.8.10; */
850 /* pragma experimental ABIEncoderV2; */ 
851 
852 interface IUniswapV2Pair {
853     event Approval(
854         address indexed owner,
855         address indexed spender,
856         uint256 value
857     );
858     event Transfer(address indexed from, address indexed to, uint256 value);
859 
860     function name() external pure returns (string memory);
861 
862     function symbol() external pure returns (string memory);
863 
864     function decimals() external pure returns (uint8);
865 
866     function totalSupply() external view returns (uint256);
867 
868     function balanceOf(address owner) external view returns (uint256);
869 
870     function allowance(address owner, address spender)
871         external
872         view
873         returns (uint256);
874 
875     function approve(address spender, uint256 value) external returns (bool);
876 
877     function transfer(address to, uint256 value) external returns (bool);
878 
879     function transferFrom(
880         address from,
881         address to,
882         uint256 value
883     ) external returns (bool);
884 
885     function DOMAIN_SEPARATOR() external view returns (bytes32);
886 
887     function PERMIT_TYPEHASH() external pure returns (bytes32);
888 
889     function nonces(address owner) external view returns (uint256);
890 
891     function permit(
892         address owner,
893         address spender,
894         uint256 value,
895         uint256 deadline,
896         uint8 v,
897         bytes32 r,
898         bytes32 s
899     ) external;
900 
901     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
902     event Burn(
903         address indexed sender,
904         uint256 amount0,
905         uint256 amount1,
906         address indexed to
907     );
908     event Swap(
909         address indexed sender,
910         uint256 amount0In,
911         uint256 amount1In,
912         uint256 amount0Out,
913         uint256 amount1Out,
914         address indexed to
915     );
916     event Sync(uint112 reserve0, uint112 reserve1);
917 
918     function MINIMUM_LIQUIDITY() external pure returns (uint256);
919 
920     function factory() external view returns (address);
921 
922     function token0() external view returns (address);
923 
924     function token1() external view returns (address);
925 
926     function getReserves()
927         external
928         view
929         returns (
930             uint112 reserve0,
931             uint112 reserve1,
932             uint32 blockTimestampLast
933         );
934 
935     function price0CumulativeLast() external view returns (uint256);
936 
937     function price1CumulativeLast() external view returns (uint256);
938 
939     function kLast() external view returns (uint256);
940 
941     function mint(address to) external returns (uint256 liquidity);
942 
943     function burn(address to)
944         external
945         returns (uint256 amount0, uint256 amount1);
946 
947     function swap(
948         uint256 amount0Out,
949         uint256 amount1Out,
950         address to,
951         bytes calldata data
952     ) external;
953 
954     function skim(address to) external;
955 
956     function sync() external;
957 
958     function initialize(address, address) external;
959 }
960 
961 /* pragma solidity 0.8.10; */
962 /* pragma experimental ABIEncoderV2; */
963 
964 interface IUniswapV2Router02 {
965     function factory() external pure returns (address);
966 
967     function WETH() external pure returns (address);
968 
969     function addLiquidity(
970         address tokenA,
971         address tokenB,
972         uint256 amountADesired,
973         uint256 amountBDesired,
974         uint256 amountAMin,
975         uint256 amountBMin,
976         address to,
977         uint256 deadline
978     )
979         external
980         returns (
981             uint256 amountA,
982             uint256 amountB,
983             uint256 liquidity
984         );
985 
986     function addLiquidityETH(
987         address token,
988         uint256 amountTokenDesired,
989         uint256 amountTokenMin,
990         uint256 amountETHMin,
991         address to,
992         uint256 deadline
993     )
994         external
995         payable
996         returns (
997             uint256 amountToken,
998             uint256 amountETH,
999             uint256 liquidity
1000         );
1001 
1002     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1003         uint256 amountIn,
1004         uint256 amountOutMin,
1005         address[] calldata path,
1006         address to,
1007         uint256 deadline
1008     ) external;
1009 
1010     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1011         uint256 amountOutMin,
1012         address[] calldata path,
1013         address to,
1014         uint256 deadline
1015     ) external payable;
1016 
1017     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1018         uint256 amountIn,
1019         uint256 amountOutMin,
1020         address[] calldata path,
1021         address to,
1022         uint256 deadline
1023     ) external;
1024 }
1025 
1026 /* pragma solidity >=0.8.10; */
1027 
1028 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1029 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1030 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1031 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1032 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1033 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1034 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1035 
1036 contract AthariPlayer is ERC20, Ownable {
1037     using SafeMath for uint256;
1038 
1039     IUniswapV2Router02 public immutable uniswapV2Router;
1040     address public immutable uniswapV2Pair;
1041     address public constant deadAddress = address(0xdead);
1042 
1043     bool private swapping;
1044 
1045 	address public charityWallet;
1046     address public marketingWallet;
1047     address public devWallet;
1048 
1049     uint256 public maxTransactionAmount;
1050     uint256 public swapTokensAtAmount;
1051     uint256 public maxWallet;
1052 
1053     bool public limitsInEffect = true;
1054     bool public tradingActive = true;
1055     bool public swapEnabled = true;
1056 
1057     // Anti-bot and anti-whale mappings and variables
1058     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1059     bool public transferDelayEnabled = true;
1060 
1061     uint256 public buyTotalFees;
1062 	uint256 public buyCharityFee;
1063     uint256 public buyMarketingFee;
1064     uint256 public buyLiquidityFee;
1065     uint256 public buyDevFee;
1066 
1067     uint256 public sellTotalFees;
1068 	uint256 public sellCharityFee;
1069     uint256 public sellMarketingFee;
1070     uint256 public sellLiquidityFee;
1071     uint256 public sellDevFee;
1072 
1073 	uint256 public tokensForCharity;
1074     uint256 public tokensForMarketing;
1075     uint256 public tokensForLiquidity;
1076     uint256 public tokensForDev;
1077 
1078     /******************/
1079 
1080     // exlcude from fees and max transaction amount
1081     mapping(address => bool) private _isExcludedFromFees;
1082     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1083 
1084     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1085     // could be subject to a maximum transfer amount
1086     mapping(address => bool) public automatedMarketMakerPairs;
1087 
1088     event UpdateUniswapV2Router(
1089         address indexed newAddress,
1090         address indexed oldAddress
1091     );
1092 
1093     event ExcludeFromFees(address indexed account, bool isExcluded);
1094 
1095     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1096 
1097     event SwapAndLiquify(
1098         uint256 tokensSwapped,
1099         uint256 ethReceived,
1100         uint256 tokensIntoLiquidity
1101     );
1102 
1103     constructor() ERC20("Athari Player", "Athari") {
1104         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1105             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1106         );
1107 
1108         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1109         uniswapV2Router = _uniswapV2Router;
1110 
1111         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1112             .createPair(address(this), _uniswapV2Router.WETH());
1113         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1114         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1115 
1116 		uint256 _buyCharityFee = 2;
1117         uint256 _buyMarketingFee = 11;
1118         uint256 _buyLiquidityFee = 1;
1119         uint256 _buyDevFee = 1;
1120 
1121 		uint256 _sellCharityFee = 2;
1122         uint256 _sellMarketingFee = 21;
1123         uint256 _sellLiquidityFee = 1;
1124         uint256 _sellDevFee = 1;
1125 
1126         uint256 totalSupply = 1000000000 * 1e18;
1127 
1128         maxTransactionAmount = 10000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1129         maxWallet = 10000000 * 1e18; // 1% from total supply maxWallet
1130         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1131 
1132 		buyCharityFee = _buyCharityFee;
1133         buyMarketingFee = _buyMarketingFee;
1134         buyLiquidityFee = _buyLiquidityFee;
1135         buyDevFee = _buyDevFee;
1136         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1137 
1138 		sellCharityFee = _sellCharityFee;
1139         sellMarketingFee = _sellMarketingFee;
1140         sellLiquidityFee = _sellLiquidityFee;
1141         sellDevFee = _sellDevFee;
1142         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1143 
1144 		charityWallet = address(0xb7Fc99147c530139Ee5A2e8585EE3CB429DC7F84); // set as charity wallet
1145         marketingWallet = address(0xE1Da44846d9950daC5415155fFD9121C08114fc2); // set as marketing wallet
1146         devWallet = address(0xfc24411c7b2c633A68b81FAb07680D479a178F80); // set as dev wallet
1147 
1148         // exclude from paying fees or having max transaction amount
1149         excludeFromFees(owner(), true);
1150         excludeFromFees(address(this), true);
1151         excludeFromFees(address(0xdead), true);
1152 
1153         excludeFromMaxTransaction(owner(), true);
1154         excludeFromMaxTransaction(address(this), true);
1155         excludeFromMaxTransaction(address(0xdead), true);
1156 
1157         /*
1158             _mint is an internal function in ERC20.sol that is only called here,
1159             and CANNOT be called ever again
1160         */
1161         _mint(msg.sender, totalSupply);
1162     }
1163 
1164     receive() external payable {}
1165 
1166     // once enabled, can never be turned off
1167     function enableTrading() external onlyOwner {
1168         tradingActive = true;
1169         swapEnabled = true;
1170     }
1171 
1172     // remove limits after token is stable
1173     function removeLimits() external onlyOwner returns (bool) {
1174         limitsInEffect = false;
1175         return true;
1176     }
1177 
1178     // disable Transfer delay - cannot be reenabled
1179     function disableTransferDelay() external onlyOwner returns (bool) {
1180         transferDelayEnabled = false;
1181         return true;
1182     }
1183 
1184     // change the minimum amount of tokens to sell from fees
1185     function updateSwapTokensAtAmount(uint256 newAmount)
1186         external
1187         onlyOwner
1188         returns (bool)
1189     {
1190         require(
1191             newAmount >= (totalSupply() * 1) / 100000,
1192             "Swap amount cannot be lower than 0.001% total supply."
1193         );
1194         require(
1195             newAmount <= (totalSupply() * 5) / 1000,
1196             "Swap amount cannot be higher than 0.5% total supply."
1197         );
1198         swapTokensAtAmount = newAmount;
1199         return true;
1200     }
1201 
1202     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1203         require(
1204             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1205             "Cannot set maxTransactionAmount lower than 0.5%"
1206         );
1207         maxTransactionAmount = newNum * (10**18);
1208     }
1209 
1210     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1211         require(
1212             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1213             "Cannot set maxWallet lower than 0.5%"
1214         );
1215         maxWallet = newNum * (10**18);
1216     }
1217 	
1218     function excludeFromMaxTransaction(address updAds, bool isEx)
1219         public
1220         onlyOwner
1221     {
1222         _isExcludedMaxTransactionAmount[updAds] = isEx;
1223     }
1224 
1225     // only use to disable contract sales if absolutely necessary (emergency use only)
1226     function updateSwapEnabled(bool enabled) external onlyOwner {
1227         swapEnabled = enabled;
1228     }
1229 
1230     function updateBuyFees(
1231 		uint256 _charityFee,
1232         uint256 _marketingFee,
1233         uint256 _liquidityFee,
1234         uint256 _devFee
1235     ) external onlyOwner {
1236 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1237 		buyCharityFee = _charityFee;
1238         buyMarketingFee = _marketingFee;
1239         buyLiquidityFee = _liquidityFee;
1240         buyDevFee = _devFee;
1241         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1242      }
1243 
1244     function updateSellFees(
1245 		uint256 _charityFee,
1246         uint256 _marketingFee,
1247         uint256 _liquidityFee,
1248         uint256 _devFee
1249     ) external onlyOwner {
1250 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1251 		sellCharityFee = _charityFee;
1252         sellMarketingFee = _marketingFee;
1253         sellLiquidityFee = _liquidityFee;
1254         sellDevFee = _devFee;
1255         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1256     }
1257 
1258     function excludeFromFees(address account, bool excluded) public onlyOwner {
1259         _isExcludedFromFees[account] = excluded;
1260         emit ExcludeFromFees(account, excluded);
1261     }
1262 
1263     function setAutomatedMarketMakerPair(address pair, bool value)
1264         public
1265         onlyOwner
1266     {
1267         require(
1268             pair != uniswapV2Pair,
1269             "The pair cannot be removed from automatedMarketMakerPairs"
1270         );
1271 
1272         _setAutomatedMarketMakerPair(pair, value);
1273     }
1274 
1275     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1276         automatedMarketMakerPairs[pair] = value;
1277 
1278         emit SetAutomatedMarketMakerPair(pair, value);
1279     }
1280 
1281     function isExcludedFromFees(address account) public view returns (bool) {
1282         return _isExcludedFromFees[account];
1283     }
1284 
1285     function _transfer(
1286         address from,
1287         address to,
1288         uint256 amount
1289     ) internal override {
1290         require(from != address(0), "ERC20: transfer from the zero address");
1291         require(to != address(0), "ERC20: transfer to the zero address");
1292 
1293         if (amount == 0) {
1294             super._transfer(from, to, 0);
1295             return;
1296         }
1297 
1298         if (limitsInEffect) {
1299             if (
1300                 from != owner() &&
1301                 to != owner() &&
1302                 to != address(0) &&
1303                 to != address(0xdead) &&
1304                 !swapping
1305             ) {
1306                 if (!tradingActive) {
1307                     require(
1308                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1309                         "Trading is not active."
1310                     );
1311                 }
1312 
1313                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1314                 if (transferDelayEnabled) {
1315                     if (
1316                         to != owner() &&
1317                         to != address(uniswapV2Router) &&
1318                         to != address(uniswapV2Pair)
1319                     ) {
1320                         require(
1321                             _holderLastTransferTimestamp[tx.origin] <
1322                                 block.number,
1323                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1324                         );
1325                         _holderLastTransferTimestamp[tx.origin] = block.number;
1326                     }
1327                 }
1328 
1329                 //when buy
1330                 if (
1331                     automatedMarketMakerPairs[from] &&
1332                     !_isExcludedMaxTransactionAmount[to]
1333                 ) {
1334                     require(
1335                         amount <= maxTransactionAmount,
1336                         "Buy transfer amount exceeds the maxTransactionAmount."
1337                     );
1338                     require(
1339                         amount + balanceOf(to) <= maxWallet,
1340                         "Max wallet exceeded"
1341                     );
1342                 }
1343                 //when sell
1344                 else if (
1345                     automatedMarketMakerPairs[to] &&
1346                     !_isExcludedMaxTransactionAmount[from]
1347                 ) {
1348                     require(
1349                         amount <= maxTransactionAmount,
1350                         "Sell transfer amount exceeds the maxTransactionAmount."
1351                     );
1352                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1353                     require(
1354                         amount + balanceOf(to) <= maxWallet,
1355                         "Max wallet exceeded"
1356                     );
1357                 }
1358             }
1359         }
1360 
1361         uint256 contractTokenBalance = balanceOf(address(this));
1362 
1363         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1364 
1365         if (
1366             canSwap &&
1367             swapEnabled &&
1368             !swapping &&
1369             !automatedMarketMakerPairs[from] &&
1370             !_isExcludedFromFees[from] &&
1371             !_isExcludedFromFees[to]
1372         ) {
1373             swapping = true;
1374 
1375             swapBack();
1376 
1377             swapping = false;
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
1393 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1394                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1395                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1396                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1397             }
1398             // on buy
1399             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1400                 fees = amount.mul(buyTotalFees).div(100);
1401 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1402                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1403                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1404                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1405             }
1406 
1407             if (fees > 0) {
1408                 super._transfer(from, address(this), fees);
1409             }
1410 
1411             amount -= fees;
1412         }
1413 
1414         super._transfer(from, to, amount);
1415     }
1416 
1417     function swapTokensForEth(uint256 tokenAmount) private {
1418         // generate the uniswap pair path of token -> weth
1419         address[] memory path = new address[](2);
1420         path[0] = address(this);
1421         path[1] = uniswapV2Router.WETH();
1422 
1423         _approve(address(this), address(uniswapV2Router), tokenAmount);
1424 
1425         // make the swap
1426         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1427             tokenAmount,
1428             0, // accept any amount of ETH
1429             path,
1430             address(this),
1431             block.timestamp
1432         );
1433     }
1434 
1435     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1436         // approve token transfer to cover all possible scenarios
1437         _approve(address(this), address(uniswapV2Router), tokenAmount);
1438 
1439         // add the liquidity
1440         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1441             address(this),
1442             tokenAmount,
1443             0, // slippage is unavoidable
1444             0, // slippage is unavoidable
1445             devWallet,
1446             block.timestamp
1447         );
1448     }
1449 
1450     function swapBack() private {
1451         uint256 contractBalance = balanceOf(address(this));
1452         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
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
1464         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1465         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1466 
1467         uint256 initialETHBalance = address(this).balance;
1468 
1469         swapTokensForEth(amountToSwapForETH);
1470 
1471         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1472 
1473 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1474         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1475         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1476 
1477         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1478 
1479         tokensForLiquidity = 0;
1480 		tokensForCharity = 0;
1481         tokensForMarketing = 0;
1482         tokensForDev = 0;
1483 
1484         (success, ) = address(devWallet).call{value: ethForDev}("");
1485         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1486 
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
1497         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1498     }
1499 
1500 }