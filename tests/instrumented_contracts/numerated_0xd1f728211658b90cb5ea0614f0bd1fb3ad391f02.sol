1 // FIGHT FOR FITNESS - FIT - WWW.FIGHTFORFIT.NET //
2 // A cryptocurrency-based project that is set out to helping athletes & communities achieve their fitness goals. //
3 
4 // SOCIALS //
5 
6 //TWITTER : @fightforfitnet
7 //INSTAGRAM : @fightforfitnet
8 //TELEGTAM : @fightforfitness
9 
10 // Verified using https://dapp.tools
11 
12 // hevm: flattened sources of src/FightForFitness.sol
13 // SPDX-License-Identifier: MIT
14 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
15 pragma experimental ABIEncoderV2;
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
816 ////// src/IUniswapV2Factory.sol
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
850 ////// src/IUniswapV2Pair.sol
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
963 ////// src/IUniswapV2Router02.sol
964 /* pragma solidity 0.8.10; */
965 /* pragma experimental ABIEncoderV2; */
966 
967 interface IUniswapV2Router02 {
968     function factory() external pure returns (address);
969 
970     function WETH() external pure returns (address);
971 
972     function addLiquidity(
973         address tokenA,
974         address tokenB,
975         uint256 amountADesired,
976         uint256 amountBDesired,
977         uint256 amountAMin,
978         uint256 amountBMin,
979         address to,
980         uint256 deadline
981     )
982         external
983         returns (
984             uint256 amountA,
985             uint256 amountB,
986             uint256 liquidity
987         );
988 
989     function addLiquidityETH(
990         address token,
991         uint256 amountTokenDesired,
992         uint256 amountTokenMin,
993         uint256 amountETHMin,
994         address to,
995         uint256 deadline
996     )
997         external
998         payable
999         returns (
1000             uint256 amountToken,
1001             uint256 amountETH,
1002             uint256 liquidity
1003         );
1004 
1005     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1006         uint256 amountIn,
1007         uint256 amountOutMin,
1008         address[] calldata path,
1009         address to,
1010         uint256 deadline
1011     ) external;
1012 
1013     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1014         uint256 amountOutMin,
1015         address[] calldata path,
1016         address to,
1017         uint256 deadline
1018     ) external payable;
1019 
1020     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1021         uint256 amountIn,
1022         uint256 amountOutMin,
1023         address[] calldata path,
1024         address to,
1025         uint256 deadline
1026     ) external;
1027 }
1028 
1029 ////// src/FightForFitness.sol
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
1040 contract FightForFitness is ERC20, Ownable {
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
1125     constructor() ERC20("Fight For Fitness", "FIT") {
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
1138         uint256 _buyMarketingFee = 5;
1139         uint256 _buyLiquidityFee = 3;
1140         uint256 _buyDevFee = 2;
1141 
1142         uint256 _sellMarketingFee = 10;
1143         uint256 _sellLiquidityFee = 2;
1144         uint256 _sellDevFee = 3;
1145 
1146         uint256 totalSupply = 1_000_000_000 * 1e18;
1147 
1148         maxTransactionAmount = 5_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1149         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1150         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
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
1162         marketingWallet = address(0x0181e25136552a6dAB668f87Df774FBA26bC03E6); // set as marketing wallet
1163         devWallet = address(0x5b5aB9dc82537f76fb27C251AACF0c8bB458d142); // set as dev wallet
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
1230             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1231             "Cannot set maxWallet lower than 0.5%"
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
1257         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
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
1269         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
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