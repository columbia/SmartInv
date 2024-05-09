1 /**
2 */
3 // SPDX-License-Identifier: MIT
4 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
5 pragma experimental ABIEncoderV2;
6 
7 /**
8 
9 
10 
11 SHIBTOR. Shibarium network Validators.
12 
13 
14 Homepage: https://shibtor.com
15 
16 Telegram: https://t.me/ShibtorPortal
17 
18 
19 
20 
21 
22 */
23 
24 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
25 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
26 
27 /* pragma solidity ^0.8.0; */
28 
29 /**
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes calldata) {
45         return msg.data;
46     }
47 }
48 
49 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
50 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
51 
52 /* pragma solidity ^0.8.0; */
53 
54 /* import "../utils/Context.sol"; */
55 
56 /**
57  * @dev Contract module which provides a basic access control mechanism, where
58  * there is an account (an owner) that can be granted exclusive access to
59  * specific functions.
60  *
61  * By default, the owner account will be the one that deploys the contract. This
62  * can later be changed with {transferOwnership}.
63  *
64  * This module is used through inheritance. It will make available the modifier
65  * `onlyOwner`, which can be applied to your functions to restrict their use to
66  * the owner.
67  */
68 abstract contract Ownable is Context {
69     address private _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     /**
74      * @dev Initializes the contract setting the deployer as the initial owner.
75      */
76     constructor() {
77         _transferOwnership(_msgSender());
78     }
79 
80     /**
81      * @dev Returns the address of the current owner.
82      */
83     function owner() public view virtual returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(owner() == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     /**
96      * @dev Leaves the contract without owner. It will not be possible to call
97      * `onlyOwner` functions anymore. Can only be called by the current owner.
98      *
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby removing any functionality that is only available to the owner.
101      */
102     function renounceOwnership() public virtual onlyOwner {
103         _transferOwnership(address(0));
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Can only be called by the current owner.
109      */
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         _transferOwnership(newOwner);
113     }
114 
115     /**
116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
117      * Internal function without access restriction.
118      */
119     function _transferOwnership(address newOwner) internal virtual {
120         address oldOwner = _owner;
121         _owner = newOwner;
122         emit OwnershipTransferred(oldOwner, newOwner);
123     }
124 }
125 
126 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
127 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
128 
129 /* pragma solidity ^0.8.0; */
130 
131 /**
132  * @dev Interface of the ERC20 standard as defined in the EIP.
133  */
134 interface IERC20 {
135     /**
136      * @dev Returns the amount of tokens in existence.
137      */
138     function totalSupply() external view returns (uint256);
139 
140     /**
141      * @dev Returns the amount of tokens owned by `account`.
142      */
143     function balanceOf(address account) external view returns (uint256);
144 
145     /**
146      * @dev Moves `amount` tokens from the caller's account to `recipient`.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * Emits a {Transfer} event.
151      */
152     function transfer(address recipient, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Returns the remaining number of tokens that `spender` will be
156      * allowed to spend on behalf of `owner` through {transferFrom}. This is
157      * zero by default.
158      *
159      * This value changes when {approve} or {transferFrom} are called.
160      */
161     function allowance(address owner, address spender) external view returns (uint256);
162 
163     /**
164      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * IMPORTANT: Beware that changing an allowance with this method brings the risk
169      * that someone may use both the old and the new allowance by unfortunate
170      * transaction ordering. One possible solution to mitigate this race
171      * condition is to first reduce the spender's allowance to 0 and set the
172      * desired value afterwards:
173      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174      *
175      * Emits an {Approval} event.
176      */
177     function approve(address spender, uint256 amount) external returns (bool);
178 
179     /**
180      * @dev Moves `amount` tokens from `sender` to `recipient` using the
181      * allowance mechanism. `amount` is then deducted from the caller's
182      * allowance.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transferFrom(
189         address sender,
190         address recipient,
191         uint256 amount
192     ) external returns (bool);
193 
194     /**
195      * @dev Emitted when `value` tokens are moved from one account (`from`) to
196      * another (`to`).
197      *
198      * Note that `value` may be zero.
199      */
200     event Transfer(address indexed from, address indexed to, uint256 value);
201 
202     /**
203      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
204      * a call to {approve}. `value` is the new allowance.
205      */
206     event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
210 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
211 
212 /* pragma solidity ^0.8.0; */
213 
214 /* import "../IERC20.sol"; */
215 
216 /**
217  * @dev Interface for the optional metadata functions from the ERC20 standard.
218  *
219  * _Available since v4.1._
220  */
221 interface IERC20Metadata is IERC20 {
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() external view returns (string memory);
226 
227     /**
228      * @dev Returns the symbol of the token.
229      */
230     function symbol() external view returns (string memory);
231 
232     /**
233      * @dev Returns the decimals places of the token.
234      */
235     function decimals() external view returns (uint8);
236 }
237 
238 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
239 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
240 
241 /* pragma solidity ^0.8.0; */
242 
243 /* import "./IERC20.sol"; */
244 /* import "./extensions/IERC20Metadata.sol"; */
245 /* import "../../utils/Context.sol"; */
246 
247 /**
248  * @dev Implementation of the {IERC20} interface.
249  *
250  * This implementation is agnostic to the way tokens are created. This means
251  * that a supply mechanism has to be added in a derived contract using {_mint}.
252  * For a generic mechanism see {ERC20PresetMinterPauser}.
253  *
254  * TIP: For a detailed writeup see our guide
255  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
256  * to implement supply mechanisms].
257  *
258  * We have followed general OpenZeppelin Contracts guidelines: functions revert
259  * instead returning `false` on failure. This behavior is nonetheless
260  * conventional and does not conflict with the expectations of ERC20
261  * applications.
262  *
263  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
264  * This allows applications to reconstruct the allowance for all accounts just
265  * by listening to said events. Other implementations of the EIP may not emit
266  * these events, as it isn't required by the specification.
267  *
268  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
269  * functions have been added to mitigate the well-known issues around setting
270  * allowances. See {IERC20-approve}.
271  */
272 contract ERC20 is Context, IERC20, IERC20Metadata {
273     mapping(address => uint256) private _balances;
274 
275     mapping(address => mapping(address => uint256)) private _allowances;
276 
277     uint256 private _totalSupply;
278 
279     string private _name;
280     string private _symbol;
281 
282     /**
283      * @dev Sets the values for {name} and {symbol}.
284      *
285      * The default value of {decimals} is 18. To select a different value for
286      * {decimals} you should overload it.
287      *
288      * All two of these values are immutable: they can only be set once during
289      * construction.
290      */
291     constructor(string memory name_, string memory symbol_) {
292         _name = name_;
293         _symbol = symbol_;
294     }
295 
296     /**
297      * @dev Returns the name of the token.
298      */
299     function name() public view virtual override returns (string memory) {
300         return _name;
301     }
302 
303     /**
304      * @dev Returns the symbol of the token, usually a shorter version of the
305      * name.
306      */
307     function symbol() public view virtual override returns (string memory) {
308         return _symbol;
309     }
310 
311     /**
312      * @dev Returns the number of decimals used to get its user representation.
313      * For example, if `decimals` equals `2`, a balance of `505` tokens should
314      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
315      *
316      * Tokens usually opt for a value of 18, imitating the relationship between
317      * Ether and Wei. This is the value {ERC20} uses, unless this function is
318      * overridden;
319      *
320      * NOTE: This information is only used for _display_ purposes: it in
321      * no way affects any of the arithmetic of the contract, including
322      * {IERC20-balanceOf} and {IERC20-transfer}.
323      */
324     function decimals() public view virtual override returns (uint8) {
325         return 18;
326     }
327 
328     /**
329      * @dev See {IERC20-totalSupply}.
330      */
331     function totalSupply() public view virtual override returns (uint256) {
332         return _totalSupply;
333     }
334 
335     /**
336      * @dev See {IERC20-balanceOf}.
337      */
338     function balanceOf(address account) public view virtual override returns (uint256) {
339         return _balances[account];
340     }
341 
342     /**
343      * @dev See {IERC20-transfer}.
344      *
345      * Requirements:
346      *
347      * - `recipient` cannot be the zero address.
348      * - the caller must have a balance of at least `amount`.
349      */
350     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
351         _transfer(_msgSender(), recipient, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-allowance}.
357      */
358     function allowance(address owner, address spender) public view virtual override returns (uint256) {
359         return _allowances[owner][spender];
360     }
361 
362     /**
363      * @dev See {IERC20-approve}.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function approve(address spender, uint256 amount) public virtual override returns (bool) {
370         _approve(_msgSender(), spender, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-transferFrom}.
376      *
377      * Emits an {Approval} event indicating the updated allowance. This is not
378      * required by the EIP. See the note at the beginning of {ERC20}.
379      *
380      * Requirements:
381      *
382      * - `sender` and `recipient` cannot be the zero address.
383      * - `sender` must have a balance of at least `amount`.
384      * - the caller must have allowance for ``sender``'s tokens of at least
385      * `amount`.
386      */
387     function transferFrom(
388         address sender,
389         address recipient,
390         uint256 amount
391     ) public virtual override returns (bool) {
392         _transfer(sender, recipient, amount);
393 
394         uint256 currentAllowance = _allowances[sender][_msgSender()];
395         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
396         unchecked {
397             _approve(sender, _msgSender(), currentAllowance - amount);
398         }
399 
400         return true;
401     }
402 
403     /**
404      * @dev Atomically increases the allowance granted to `spender` by the caller.
405      *
406      * This is an alternative to {approve} that can be used as a mitigation for
407      * problems described in {IERC20-approve}.
408      *
409      * Emits an {Approval} event indicating the updated allowance.
410      *
411      * Requirements:
412      *
413      * - `spender` cannot be the zero address.
414      */
415     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
416         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
417         return true;
418     }
419 
420     /**
421      * @dev Atomically decreases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      * - `spender` must have allowance for the caller of at least
432      * `subtractedValue`.
433      */
434     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
435         uint256 currentAllowance = _allowances[_msgSender()][spender];
436         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
437         unchecked {
438             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
439         }
440 
441         return true;
442     }
443 
444     /**
445      * @dev Moves `amount` of tokens from `sender` to `recipient`.
446      *
447      * This internal function is equivalent to {transfer}, and can be used to
448      * e.g. implement automatic token fees, slashing mechanisms, etc.
449      *
450      * Emits a {Transfer} event.
451      *
452      * Requirements:
453      *
454      * - `sender` cannot be the zero address.
455      * - `recipient` cannot be the zero address.
456      * - `sender` must have a balance of at least `amount`.
457      */
458     function _transfer(
459         address sender,
460         address recipient,
461         uint256 amount
462     ) internal virtual {
463         require(sender != address(0), "ERC20: transfer from the zero address");
464         require(recipient != address(0), "ERC20: transfer to the zero address");
465 
466         _beforeTokenTransfer(sender, recipient, amount);
467 
468         uint256 senderBalance = _balances[sender];
469         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
470         unchecked {
471             _balances[sender] = senderBalance - amount;
472         }
473         _balances[recipient] += amount;
474 
475         emit Transfer(sender, recipient, amount);
476 
477         _afterTokenTransfer(sender, recipient, amount);
478     }
479 
480     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
481      * the total supply.
482      *
483      * Emits a {Transfer} event with `from` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `account` cannot be the zero address.
488      */
489     function _mint(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: mint to the zero address");
491 
492         _beforeTokenTransfer(address(0), account, amount);
493 
494         _totalSupply += amount;
495         _balances[account] += amount;
496         emit Transfer(address(0), account, amount);
497 
498         _afterTokenTransfer(address(0), account, amount);
499     }
500 
501     /**
502      * @dev Destroys `amount` tokens from `account`, reducing the
503      * total supply.
504      *
505      * Emits a {Transfer} event with `to` set to the zero address.
506      *
507      * Requirements:
508      *
509      * - `account` cannot be the zero address.
510      * - `account` must have at least `amount` tokens.
511      */
512     function _burn(address account, uint256 amount) internal virtual {
513         require(account != address(0), "ERC20: burn from the zero address");
514 
515         _beforeTokenTransfer(account, address(0), amount);
516 
517         uint256 accountBalance = _balances[account];
518         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
519         unchecked {
520             _balances[account] = accountBalance - amount;
521         }
522         _totalSupply -= amount;
523 
524         emit Transfer(account, address(0), amount);
525 
526         _afterTokenTransfer(account, address(0), amount);
527     }
528 
529     /**
530      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
531      *
532      * This internal function is equivalent to `approve`, and can be used to
533      * e.g. set automatic allowances for certain subsystems, etc.
534      *
535      * Emits an {Approval} event.
536      *
537      * Requirements:
538      *
539      * - `owner` cannot be the zero address.
540      * - `spender` cannot be the zero address.
541      */
542     function _approve(
543         address owner,
544         address spender,
545         uint256 amount
546     ) internal virtual {
547         require(owner != address(0), "ERC20: approve from the zero address");
548         require(spender != address(0), "ERC20: approve to the zero address");
549 
550         _allowances[owner][spender] = amount;
551         emit Approval(owner, spender, amount);
552     }
553 
554     /**
555      * @dev Hook that is called before any transfer of tokens. This includes
556      * minting and burning.
557      *
558      * Calling conditions:
559      *
560      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
561      * will be transferred to `to`.
562      * - when `from` is zero, `amount` tokens will be minted for `to`.
563      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
564      * - `from` and `to` are never both zero.
565      *
566      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
567      */
568     function _beforeTokenTransfer(
569         address from,
570         address to,
571         uint256 amount
572     ) internal virtual {}
573 
574     /**
575      * @dev Hook that is called after any transfer of tokens. This includes
576      * minting and burning.
577      *
578      * Calling conditions:
579      *
580      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
581      * has been transferred to `to`.
582      * - when `from` is zero, `amount` tokens have been minted for `to`.
583      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
584      * - `from` and `to` are never both zero.
585      *
586      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
587      */
588     function _afterTokenTransfer(
589         address from,
590         address to,
591         uint256 amount
592     ) internal virtual {}
593 }
594 
595 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
596 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
597 
598 /* pragma solidity ^0.8.0; */
599 
600 // CAUTION
601 // This version of SafeMath should only be used with Solidity 0.8 or later,
602 // because it relies on the compiler's built in overflow checks.
603 
604 /**
605  * @dev Wrappers over Solidity's arithmetic operations.
606  *
607  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
608  * now has built in overflow checking.
609  */
610 library SafeMath {
611     /**
612      * @dev Returns the addition of two unsigned integers, with an overflow flag.
613      *
614      * _Available since v3.4._
615      */
616     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
617         unchecked {
618             uint256 c = a + b;
619             if (c < a) return (false, 0);
620             return (true, c);
621         }
622     }
623 
624     /**
625      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
626      *
627      * _Available since v3.4._
628      */
629     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
630         unchecked {
631             if (b > a) return (false, 0);
632             return (true, a - b);
633         }
634     }
635 
636     /**
637      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
638      *
639      * _Available since v3.4._
640      */
641     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
642         unchecked {
643             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
644             // benefit is lost if 'b' is also tested.
645             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
646             if (a == 0) return (true, 0);
647             uint256 c = a * b;
648             if (c / a != b) return (false, 0);
649             return (true, c);
650         }
651     }
652 
653     /**
654      * @dev Returns the division of two unsigned integers, with a division by zero flag.
655      *
656      * _Available since v3.4._
657      */
658     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
659         unchecked {
660             if (b == 0) return (false, 0);
661             return (true, a / b);
662         }
663     }
664 
665     /**
666      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
667      *
668      * _Available since v3.4._
669      */
670     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
671         unchecked {
672             if (b == 0) return (false, 0);
673             return (true, a % b);
674         }
675     }
676 
677     /**
678      * @dev Returns the addition of two unsigned integers, reverting on
679      * overflow.
680      *
681      * Counterpart to Solidity's `+` operator.
682      *
683      * Requirements:
684      *
685      * - Addition cannot overflow.
686      */
687     function add(uint256 a, uint256 b) internal pure returns (uint256) {
688         return a + b;
689     }
690 
691     /**
692      * @dev Returns the subtraction of two unsigned integers, reverting on
693      * overflow (when the result is negative).
694      *
695      * Counterpart to Solidity's `-` operator.
696      *
697      * Requirements:
698      *
699      * - Subtraction cannot overflow.
700      */
701     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a - b;
703     }
704 
705     /**
706      * @dev Returns the multiplication of two unsigned integers, reverting on
707      * overflow.
708      *
709      * Counterpart to Solidity's `*` operator.
710      *
711      * Requirements:
712      *
713      * - Multiplication cannot overflow.
714      */
715     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a * b;
717     }
718 
719     /**
720      * @dev Returns the integer division of two unsigned integers, reverting on
721      * division by zero. The result is rounded towards zero.
722      *
723      * Counterpart to Solidity's `/` operator.
724      *
725      * Requirements:
726      *
727      * - The divisor cannot be zero.
728      */
729     function div(uint256 a, uint256 b) internal pure returns (uint256) {
730         return a / b;
731     }
732 
733     /**
734      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
735      * reverting when dividing by zero.
736      *
737      * Counterpart to Solidity's `%` operator. This function uses a `revert`
738      * opcode (which leaves remaining gas untouched) while Solidity uses an
739      * invalid opcode to revert (consuming all remaining gas).
740      *
741      * Requirements:
742      *
743      * - The divisor cannot be zero.
744      */
745     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
746         return a % b;
747     }
748 
749     /**
750      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
751      * overflow (when the result is negative).
752      *
753      * CAUTION: This function is deprecated because it requires allocating memory for the error
754      * message unnecessarily. For custom revert reasons use {trySub}.
755      *
756      * Counterpart to Solidity's `-` operator.
757      *
758      * Requirements:
759      *
760      * - Subtraction cannot overflow.
761      */
762     function sub(
763         uint256 a,
764         uint256 b,
765         string memory errorMessage
766     ) internal pure returns (uint256) {
767         unchecked {
768             require(b <= a, errorMessage);
769             return a - b;
770         }
771     }
772 
773     /**
774      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
775      * division by zero. The result is rounded towards zero.
776      *
777      * Counterpart to Solidity's `/` operator. Note: this function uses a
778      * `revert` opcode (which leaves remaining gas untouched) while Solidity
779      * uses an invalid opcode to revert (consuming all remaining gas).
780      *
781      * Requirements:
782      *
783      * - The divisor cannot be zero.
784      */
785     function div(
786         uint256 a,
787         uint256 b,
788         string memory errorMessage
789     ) internal pure returns (uint256) {
790         unchecked {
791             require(b > 0, errorMessage);
792             return a / b;
793         }
794     }
795 
796     /**
797      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
798      * reverting with custom message when dividing by zero.
799      *
800      * CAUTION: This function is deprecated because it requires allocating memory for the error
801      * message unnecessarily. For custom revert reasons use {tryMod}.
802      *
803      * Counterpart to Solidity's `%` operator. This function uses a `revert`
804      * opcode (which leaves remaining gas untouched) while Solidity uses an
805      * invalid opcode to revert (consuming all remaining gas).
806      *
807      * Requirements:
808      *
809      * - The divisor cannot be zero.
810      */
811     function mod(
812         uint256 a,
813         uint256 b,
814         string memory errorMessage
815     ) internal pure returns (uint256) {
816         unchecked {
817             require(b > 0, errorMessage);
818             return a % b;
819         }
820     }
821 }
822 
823 /* pragma solidity 0.8.10; */
824 /* pragma experimental ABIEncoderV2; */
825 
826 interface IUniswapV2Factory {
827     event PairCreated(
828         address indexed token0,
829         address indexed token1,
830         address pair,
831         uint256
832     );
833 
834     function feeTo() external view returns (address);
835 
836     function feeToSetter() external view returns (address);
837 
838     function getPair(address tokenA, address tokenB)
839         external
840         view
841         returns (address pair);
842 
843     function allPairs(uint256) external view returns (address pair);
844 
845     function allPairsLength() external view returns (uint256);
846 
847     function createPair(address tokenA, address tokenB)
848         external
849         returns (address pair);
850 
851     function setFeeTo(address) external;
852 
853     function setFeeToSetter(address) external;
854 }
855 
856 /* pragma solidity 0.8.10; */
857 /* pragma experimental ABIEncoderV2; */
858 
859 interface IUniswapV2Pair {
860     event Approval(
861         address indexed owner,
862         address indexed spender,
863         uint256 value
864     );
865     event Transfer(address indexed from, address indexed to, uint256 value);
866 
867     function name() external pure returns (string memory);
868 
869     function symbol() external pure returns (string memory);
870 
871     function decimals() external pure returns (uint8);
872 
873     function totalSupply() external view returns (uint256);
874 
875     function balanceOf(address owner) external view returns (uint256);
876 
877     function allowance(address owner, address spender)
878         external
879         view
880         returns (uint256);
881 
882     function approve(address spender, uint256 value) external returns (bool);
883 
884     function transfer(address to, uint256 value) external returns (bool);
885 
886     function transferFrom(
887         address from,
888         address to,
889         uint256 value
890     ) external returns (bool);
891 
892     function DOMAIN_SEPARATOR() external view returns (bytes32);
893 
894     function PERMIT_TYPEHASH() external pure returns (bytes32);
895 
896     function nonces(address owner) external view returns (uint256);
897 
898     function permit(
899         address owner,
900         address spender,
901         uint256 value,
902         uint256 deadline,
903         uint8 v,
904         bytes32 r,
905         bytes32 s
906     ) external;
907 
908     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
909     event Burn(
910         address indexed sender,
911         uint256 amount0,
912         uint256 amount1,
913         address indexed to
914     );
915     event Swap(
916         address indexed sender,
917         uint256 amount0In,
918         uint256 amount1In,
919         uint256 amount0Out,
920         uint256 amount1Out,
921         address indexed to
922     );
923     event Sync(uint112 reserve0, uint112 reserve1);
924 
925     function MINIMUM_LIQUIDITY() external pure returns (uint256);
926 
927     function factory() external view returns (address);
928 
929     function token0() external view returns (address);
930 
931     function token1() external view returns (address);
932 
933     function getReserves()
934         external
935         view
936         returns (
937             uint112 reserve0,
938             uint112 reserve1,
939             uint32 blockTimestampLast
940         );
941 
942     function price0CumulativeLast() external view returns (uint256);
943 
944     function price1CumulativeLast() external view returns (uint256);
945 
946     function kLast() external view returns (uint256);
947 
948     function mint(address to) external returns (uint256 liquidity);
949 
950     function burn(address to)
951         external
952         returns (uint256 amount0, uint256 amount1);
953 
954     function swap(
955         uint256 amount0Out,
956         uint256 amount1Out,
957         address to,
958         bytes calldata data
959     ) external;
960 
961     function skim(address to) external;
962 
963     function sync() external;
964 
965     function initialize(address, address) external;
966 }
967 
968 /* pragma solidity 0.8.10; */
969 /* pragma experimental ABIEncoderV2; */
970 
971 interface IUniswapV2Router02 {
972     function factory() external pure returns (address);
973 
974     function WETH() external pure returns (address);
975 
976     function addLiquidity(
977         address tokenA,
978         address tokenB,
979         uint256 amountADesired,
980         uint256 amountBDesired,
981         uint256 amountAMin,
982         uint256 amountBMin,
983         address to,
984         uint256 deadline
985     )
986         external
987         returns (
988             uint256 amountA,
989             uint256 amountB,
990             uint256 liquidity
991         );
992 
993     function addLiquidityETH(
994         address token,
995         uint256 amountTokenDesired,
996         uint256 amountTokenMin,
997         uint256 amountETHMin,
998         address to,
999         uint256 deadline
1000     )
1001         external
1002         payable
1003         returns (
1004             uint256 amountToken,
1005             uint256 amountETH,
1006             uint256 liquidity
1007         );
1008 
1009     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1010         uint256 amountIn,
1011         uint256 amountOutMin,
1012         address[] calldata path,
1013         address to,
1014         uint256 deadline
1015     ) external;
1016 
1017     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1018         uint256 amountOutMin,
1019         address[] calldata path,
1020         address to,
1021         uint256 deadline
1022     ) external payable;
1023 
1024     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1025         uint256 amountIn,
1026         uint256 amountOutMin,
1027         address[] calldata path,
1028         address to,
1029         uint256 deadline
1030     ) external;
1031 }
1032 
1033 /* pragma solidity >=0.8.10; */
1034 
1035 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1036 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1037 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1038 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1039 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1040 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1041 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1042 
1043 contract SHIBTOR is ERC20, Ownable {
1044     using SafeMath for uint256;
1045 
1046     IUniswapV2Router02 public immutable uniswapV2Router;
1047     address public immutable uniswapV2Pair;
1048     address public constant deadAddress = address(0xdead);
1049 
1050     bool private swapping;
1051 
1052 	address public charityWallet;
1053     address public marketingWallet;
1054     address public devWallet;
1055 
1056     uint256 public maxTransactionAmount;
1057     uint256 public swapTokensAtAmount;
1058     uint256 public maxWallet;
1059 
1060     bool public limitsInEffect = true;
1061     bool public tradingActive = true;
1062     bool public swapEnabled = true;
1063 
1064     // Anti-bot and anti-whale mappings and variables
1065     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1066     bool public transferDelayEnabled = true;
1067 
1068     uint256 public buyTotalFees;
1069 	uint256 public buyCharityFee;
1070     uint256 public buyMarketingFee;
1071     uint256 public buyLiquidityFee;
1072     uint256 public buyDevFee;
1073 
1074     uint256 public sellTotalFees;
1075 	uint256 public sellCharityFee;
1076     uint256 public sellMarketingFee;
1077     uint256 public sellLiquidityFee;
1078     uint256 public sellDevFee;
1079 
1080 	uint256 public tokensForCharity;
1081     uint256 public tokensForMarketing;
1082     uint256 public tokensForLiquidity;
1083     uint256 public tokensForDev;
1084 
1085     /******************/
1086 
1087     // exlcude from fees and max transaction amount
1088     mapping(address => bool) private _isExcludedFromFees;
1089     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1090 
1091     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1092     // could be subject to a maximum transfer amount
1093     mapping(address => bool) public automatedMarketMakerPairs;
1094 
1095     event UpdateUniswapV2Router(
1096         address indexed newAddress,
1097         address indexed oldAddress
1098     );
1099 
1100     event ExcludeFromFees(address indexed account, bool isExcluded);
1101 
1102     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1103 
1104     event SwapAndLiquify(
1105         uint256 tokensSwapped,
1106         uint256 ethReceived,
1107         uint256 tokensIntoLiquidity
1108     );
1109 
1110     constructor() ERC20("Shiba Operator Inu", "SHIBTOR") {
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
1123 		uint256 _buyCharityFee = 0;
1124         uint256 _buyMarketingFee = 0;
1125         uint256 _buyLiquidityFee = 0;
1126         uint256 _buyDevFee = 21;
1127 
1128 		uint256 _sellCharityFee = 0;
1129         uint256 _sellMarketingFee = 0;
1130         uint256 _sellLiquidityFee = 0;
1131         uint256 _sellDevFee = 27;
1132 
1133         uint256 totalSupply = 10000000 * 1e18;
1134 
1135         maxTransactionAmount = 50000 * 1e18; // 0.5% from total supply maxTransactionAmountTxn
1136         maxWallet = 100000 * 1e18; // 1% from total supply maxWallet
1137         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1138 
1139 		buyCharityFee = _buyCharityFee;
1140         buyMarketingFee = _buyMarketingFee;
1141         buyLiquidityFee = _buyLiquidityFee;
1142         buyDevFee = _buyDevFee;
1143         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1144 
1145 		sellCharityFee = _sellCharityFee;
1146         sellMarketingFee = _sellMarketingFee;
1147         sellLiquidityFee = _sellLiquidityFee;
1148         sellDevFee = _sellDevFee;
1149         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1150 
1151 		charityWallet = address(0x65B6A9F820c6fb22C08551100cC7519f913B88f9); // set as charity wallet
1152         marketingWallet = address(0x4367B64315Ed79190b3dbC12b776A00eD30D2E05); // set as marketing wallet
1153         devWallet = address(0x65B6A9F820c6fb22C08551100cC7519f913B88f9); // set as dev wallet
1154 
1155         // exclude from paying fees or having max transaction amount
1156         excludeFromFees(owner(), true);
1157         excludeFromFees(address(this), true);
1158         excludeFromFees(address(0xdead), true);
1159 
1160         excludeFromMaxTransaction(owner(), true);
1161         excludeFromMaxTransaction(address(this), true);
1162         excludeFromMaxTransaction(address(0xdead), true);
1163 
1164         /*
1165             _mint is an internal function in ERC20.sol that is only called here,
1166             and CANNOT be called ever again
1167         */
1168         _mint(msg.sender, totalSupply);
1169     }
1170 
1171     receive() external payable {}
1172 
1173     // once enabled, can never be turned off
1174     function enableTrading() external onlyOwner {
1175         tradingActive = true;
1176         swapEnabled = true;
1177     }
1178 
1179     // remove limits after token is stable
1180     function removeLimits() external onlyOwner returns (bool) {
1181         limitsInEffect = false;
1182         return true;
1183     }
1184 
1185     // disable Transfer delay - cannot be reenabled
1186     function disableTransferDelay() external onlyOwner returns (bool) {
1187         transferDelayEnabled = false;
1188         return true;
1189     }
1190 
1191     // change the minimum amount of tokens to sell from fees
1192     function updateSwapTokensAtAmount(uint256 newAmount)
1193         external
1194         onlyOwner
1195         returns (bool)
1196     {
1197         require(
1198             newAmount >= (totalSupply() * 1) / 100000,
1199             "Swap amount cannot be lower than 0.001% total supply."
1200         );
1201         require(
1202             newAmount <= (totalSupply() * 5) / 1000,
1203             "Swap amount cannot be higher than 0.5% total supply."
1204         );
1205         swapTokensAtAmount = newAmount;
1206         return true;
1207     }
1208 
1209     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1210         require(
1211             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1212             "Cannot set maxTransactionAmount lower than 0.5%"
1213         );
1214         maxTransactionAmount = newNum * (10**18);
1215     }
1216 
1217     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1218         require(
1219             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1220             "Cannot set maxWallet lower than 0.5%"
1221         );
1222         maxWallet = newNum * (10**18);
1223     }
1224 	
1225     function excludeFromMaxTransaction(address updAds, bool isEx)
1226         public
1227         onlyOwner
1228     {
1229         _isExcludedMaxTransactionAmount[updAds] = isEx;
1230     }
1231 
1232     // only use to disable contract sales if absolutely necessary (emergency use only)
1233     function updateSwapEnabled(bool enabled) external onlyOwner {
1234         swapEnabled = enabled;
1235     }
1236 
1237     function updateBuyFees(
1238 		uint256 _charityFee,
1239         uint256 _marketingFee,
1240         uint256 _liquidityFee,
1241         uint256 _devFee
1242     ) external onlyOwner {
1243 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1244 		buyCharityFee = _charityFee;
1245         buyMarketingFee = _marketingFee;
1246         buyLiquidityFee = _liquidityFee;
1247         buyDevFee = _devFee;
1248         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1249      }
1250 
1251     function updateSellFees(
1252 		uint256 _charityFee,
1253         uint256 _marketingFee,
1254         uint256 _liquidityFee,
1255         uint256 _devFee
1256     ) external onlyOwner {
1257 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1258 		sellCharityFee = _charityFee;
1259         sellMarketingFee = _marketingFee;
1260         sellLiquidityFee = _liquidityFee;
1261         sellDevFee = _devFee;
1262         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1263     }
1264 
1265     function excludeFromFees(address account, bool excluded) public onlyOwner {
1266         _isExcludedFromFees[account] = excluded;
1267         emit ExcludeFromFees(account, excluded);
1268     }
1269 
1270     function setAutomatedMarketMakerPair(address pair, bool value)
1271         public
1272         onlyOwner
1273     {
1274         require(
1275             pair != uniswapV2Pair,
1276             "The pair cannot be removed from automatedMarketMakerPairs"
1277         );
1278 
1279         _setAutomatedMarketMakerPair(pair, value);
1280     }
1281 
1282     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1283         automatedMarketMakerPairs[pair] = value;
1284 
1285         emit SetAutomatedMarketMakerPair(pair, value);
1286     }
1287 
1288     function isExcludedFromFees(address account) public view returns (bool) {
1289         return _isExcludedFromFees[account];
1290     }
1291 
1292     function _transfer(
1293         address from,
1294         address to,
1295         uint256 amount
1296     ) internal override {
1297         require(from != address(0), "ERC20: transfer from the zero address");
1298         require(to != address(0), "ERC20: transfer to the zero address");
1299 
1300         if (amount == 0) {
1301             super._transfer(from, to, 0);
1302             return;
1303         }
1304 
1305         if (limitsInEffect) {
1306             if (
1307                 from != owner() &&
1308                 to != owner() &&
1309                 to != address(0) &&
1310                 to != address(0xdead) &&
1311                 !swapping
1312             ) {
1313                 if (!tradingActive) {
1314                     require(
1315                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1316                         "Trading is not active."
1317                     );
1318                 }
1319 
1320                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1321                 if (transferDelayEnabled) {
1322                     if (
1323                         to != owner() &&
1324                         to != address(uniswapV2Router) &&
1325                         to != address(uniswapV2Pair)
1326                     ) {
1327                         require(
1328                             _holderLastTransferTimestamp[tx.origin] <
1329                                 block.number,
1330                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1331                         );
1332                         _holderLastTransferTimestamp[tx.origin] = block.number;
1333                     }
1334                 }
1335 
1336                 //when buy
1337                 if (
1338                     automatedMarketMakerPairs[from] &&
1339                     !_isExcludedMaxTransactionAmount[to]
1340                 ) {
1341                     require(
1342                         amount <= maxTransactionAmount,
1343                         "Buy transfer amount exceeds the maxTransactionAmount."
1344                     );
1345                     require(
1346                         amount + balanceOf(to) <= maxWallet,
1347                         "Max wallet exceeded"
1348                     );
1349                 }
1350                 //when sell
1351                 else if (
1352                     automatedMarketMakerPairs[to] &&
1353                     !_isExcludedMaxTransactionAmount[from]
1354                 ) {
1355                     require(
1356                         amount <= maxTransactionAmount,
1357                         "Sell transfer amount exceeds the maxTransactionAmount."
1358                     );
1359                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1360                     require(
1361                         amount + balanceOf(to) <= maxWallet,
1362                         "Max wallet exceeded"
1363                     );
1364                 }
1365             }
1366         }
1367 
1368         uint256 contractTokenBalance = balanceOf(address(this));
1369 
1370         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1371 
1372         if (
1373             canSwap &&
1374             swapEnabled &&
1375             !swapping &&
1376             !automatedMarketMakerPairs[from] &&
1377             !_isExcludedFromFees[from] &&
1378             !_isExcludedFromFees[to]
1379         ) {
1380             swapping = true;
1381 
1382             swapBack();
1383 
1384             swapping = false;
1385         }
1386 
1387         bool takeFee = !swapping;
1388 
1389         // if any account belongs to _isExcludedFromFee account then remove the fee
1390         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1391             takeFee = false;
1392         }
1393 
1394         uint256 fees = 0;
1395         // only take fees on buys/sells, do not take on wallet transfers
1396         if (takeFee) {
1397             // on sell
1398             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1399                 fees = amount.mul(sellTotalFees).div(100);
1400 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1401                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1402                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1403                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1404             }
1405             // on buy
1406             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1407                 fees = amount.mul(buyTotalFees).div(100);
1408 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1409                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1410                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1411                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1412             }
1413 
1414             if (fees > 0) {
1415                 super._transfer(from, address(this), fees);
1416             }
1417 
1418             amount -= fees;
1419         }
1420 
1421         super._transfer(from, to, amount);
1422     }
1423 
1424     function swapTokensForEth(uint256 tokenAmount) private {
1425         // generate the uniswap pair path of token -> weth
1426         address[] memory path = new address[](2);
1427         path[0] = address(this);
1428         path[1] = uniswapV2Router.WETH();
1429 
1430         _approve(address(this), address(uniswapV2Router), tokenAmount);
1431 
1432         // make the swap
1433         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1434             tokenAmount,
1435             0, // accept any amount of ETH
1436             path,
1437             address(this),
1438             block.timestamp
1439         );
1440     }
1441 
1442     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1443         // approve token transfer to cover all possible scenarios
1444         _approve(address(this), address(uniswapV2Router), tokenAmount);
1445 
1446         // add the liquidity
1447         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1448             address(this),
1449             tokenAmount,
1450             0, // slippage is unavoidable
1451             0, // slippage is unavoidable
1452             devWallet,
1453             block.timestamp
1454         );
1455     }
1456 
1457     function swapBack() private {
1458         uint256 contractBalance = balanceOf(address(this));
1459         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1460         bool success;
1461 
1462         if (contractBalance == 0 || totalTokensToSwap == 0) {
1463             return;
1464         }
1465 
1466         if (contractBalance > swapTokensAtAmount * 20) {
1467             contractBalance = swapTokensAtAmount * 20;
1468         }
1469 
1470         // Halve the amount of liquidity tokens
1471         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1472         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1473 
1474         uint256 initialETHBalance = address(this).balance;
1475 
1476         swapTokensForEth(amountToSwapForETH);
1477 
1478         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1479 
1480 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1481         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1482         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1483 
1484         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1485 
1486         tokensForLiquidity = 0;
1487 		tokensForCharity = 0;
1488         tokensForMarketing = 0;
1489         tokensForDev = 0;
1490 
1491         (success, ) = address(devWallet).call{value: ethForDev}("");
1492         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1493 
1494 
1495         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1496             addLiquidity(liquidityTokens, ethForLiquidity);
1497             emit SwapAndLiquify(
1498                 amountToSwapForETH,
1499                 ethForLiquidity,
1500                 tokensForLiquidity
1501             );
1502         }
1503 
1504         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1505     }
1506 
1507 }