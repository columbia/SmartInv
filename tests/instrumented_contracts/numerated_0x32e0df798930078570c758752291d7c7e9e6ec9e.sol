1 /**
2 
3 Twitter: https://twitter.com/BabyBoneETH
4 
5 TG: https://t.me/BabyBoneETH
6 
7 
8 2% max tx
9 3% max wallet
10 at launch
11 
12 
13 1% goes to liq
14 1% of every transaction gets sent to Shibaswap deployer/wallet to support daddy
15 3% goes to marketing
16 
17 
18 
19 */
20 // SPDX-License-Identifier: MIT
21 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
22 pragma experimental ABIEncoderV2;
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
823 ////// src/IUniswapV2Factory.sol
824 /* pragma solidity 0.8.10; */
825 /* pragma experimental ABIEncoderV2; */
826 
827 interface IUniswapV2Factory {
828     event PairCreated(
829         address indexed token0,
830         address indexed token1,
831         address pair,
832         uint256
833     );
834 
835     function feeTo() external view returns (address);
836 
837     function feeToSetter() external view returns (address);
838 
839     function getPair(address tokenA, address tokenB)
840         external
841         view
842         returns (address pair);
843 
844     function allPairs(uint256) external view returns (address pair);
845 
846     function allPairsLength() external view returns (uint256);
847 
848     function createPair(address tokenA, address tokenB)
849         external
850         returns (address pair);
851 
852     function setFeeTo(address) external;
853 
854     function setFeeToSetter(address) external;
855 }
856 
857 ////// src/IUniswapV2Pair.sol
858 /* pragma solidity 0.8.10; */
859 /* pragma experimental ABIEncoderV2; */
860 
861 interface IUniswapV2Pair {
862     event Approval(
863         address indexed owner,
864         address indexed spender,
865         uint256 value
866     );
867     event Transfer(address indexed from, address indexed to, uint256 value);
868 
869     function name() external pure returns (string memory);
870 
871     function symbol() external pure returns (string memory);
872 
873     function decimals() external pure returns (uint8);
874 
875     function totalSupply() external view returns (uint256);
876 
877     function balanceOf(address owner) external view returns (uint256);
878 
879     function allowance(address owner, address spender)
880         external
881         view
882         returns (uint256);
883 
884     function approve(address spender, uint256 value) external returns (bool);
885 
886     function transfer(address to, uint256 value) external returns (bool);
887 
888     function transferFrom(
889         address from,
890         address to,
891         uint256 value
892     ) external returns (bool);
893 
894     function DOMAIN_SEPARATOR() external view returns (bytes32);
895 
896     function PERMIT_TYPEHASH() external pure returns (bytes32);
897 
898     function nonces(address owner) external view returns (uint256);
899 
900     function permit(
901         address owner,
902         address spender,
903         uint256 value,
904         uint256 deadline,
905         uint8 v,
906         bytes32 r,
907         bytes32 s
908     ) external;
909 
910     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
911     event Burn(
912         address indexed sender,
913         uint256 amount0,
914         uint256 amount1,
915         address indexed to
916     );
917     event Swap(
918         address indexed sender,
919         uint256 amount0In,
920         uint256 amount1In,
921         uint256 amount0Out,
922         uint256 amount1Out,
923         address indexed to
924     );
925     event Sync(uint112 reserve0, uint112 reserve1);
926 
927     function MINIMUM_LIQUIDITY() external pure returns (uint256);
928 
929     function factory() external view returns (address);
930 
931     function token0() external view returns (address);
932 
933     function token1() external view returns (address);
934 
935     function getReserves()
936         external
937         view
938         returns (
939             uint112 reserve0,
940             uint112 reserve1,
941             uint32 blockTimestampLast
942         );
943 
944     function price0CumulativeLast() external view returns (uint256);
945 
946     function price1CumulativeLast() external view returns (uint256);
947 
948     function kLast() external view returns (uint256);
949 
950     function mint(address to) external returns (uint256 liquidity);
951 
952     function burn(address to)
953         external
954         returns (uint256 amount0, uint256 amount1);
955 
956     function swap(
957         uint256 amount0Out,
958         uint256 amount1Out,
959         address to,
960         bytes calldata data
961     ) external;
962 
963     function skim(address to) external;
964 
965     function sync() external;
966 
967     function initialize(address, address) external;
968 }
969 
970 ////// src/IUniswapV2Router02.sol
971 /* pragma solidity 0.8.10; */
972 /* pragma experimental ABIEncoderV2; */
973 
974 interface IUniswapV2Router02 {
975     function factory() external pure returns (address);
976 
977     function WETH() external pure returns (address);
978 
979     function addLiquidity(
980         address tokenA,
981         address tokenB,
982         uint256 amountADesired,
983         uint256 amountBDesired,
984         uint256 amountAMin,
985         uint256 amountBMin,
986         address to,
987         uint256 deadline
988     )
989         external
990         returns (
991             uint256 amountA,
992             uint256 amountB,
993             uint256 liquidity
994         );
995 
996     function addLiquidityETH(
997         address token,
998         uint256 amountTokenDesired,
999         uint256 amountTokenMin,
1000         uint256 amountETHMin,
1001         address to,
1002         uint256 deadline
1003     )
1004         external
1005         payable
1006         returns (
1007             uint256 amountToken,
1008             uint256 amountETH,
1009             uint256 liquidity
1010         );
1011 
1012     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1013         uint256 amountIn,
1014         uint256 amountOutMin,
1015         address[] calldata path,
1016         address to,
1017         uint256 deadline
1018     ) external;
1019 
1020     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1021         uint256 amountOutMin,
1022         address[] calldata path,
1023         address to,
1024         uint256 deadline
1025     ) external payable;
1026 
1027     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1028         uint256 amountIn,
1029         uint256 amountOutMin,
1030         address[] calldata path,
1031         address to,
1032         uint256 deadline
1033     ) external;
1034 }
1035 
1036 /* pragma solidity >=0.8.10; */
1037 
1038 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1039 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1040 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1041 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1042 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1043 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1044 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1045 
1046 contract BabyBone is ERC20, Ownable {
1047     using SafeMath for uint256;
1048 
1049     IUniswapV2Router02 public immutable uniswapV2Router;
1050     address public immutable uniswapV2Pair;
1051     address public constant deadAddress = address(0xdead);
1052 
1053     bool private swapping;
1054 
1055     address public marketingWallet;
1056     address public devWallet;
1057 
1058     uint256 public maxTransactionAmount;
1059     uint256 public swapTokensAtAmount;
1060     uint256 public maxWallet;
1061 
1062     uint256 public percentForLPBurn = 25; // 25 = .25%
1063     bool public lpBurnEnabled = true;
1064     uint256 public lpBurnFrequency = 3600 seconds;
1065     uint256 public lastLpBurnTime;
1066 
1067     uint256 public manualBurnFrequency = 30 minutes;
1068     uint256 public lastManualLpBurnTime;
1069 
1070     bool public limitsInEffect = true;
1071     bool public tradingActive = false;
1072     bool public swapEnabled = false;
1073 
1074     // Anti-bot and anti-whale mappings and variables
1075     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1076     bool public transferDelayEnabled = true;
1077 
1078     uint256 public buyTotalFees;
1079     uint256 public buyMarketingFee;
1080     uint256 public buyLiquidityFee;
1081     uint256 public buyDevFee;
1082 
1083     uint256 public sellTotalFees;
1084     uint256 public sellMarketingFee;
1085     uint256 public sellLiquidityFee;
1086     uint256 public sellDevFee;
1087 
1088     uint256 public tokensForMarketing;
1089     uint256 public tokensForLiquidity;
1090     uint256 public tokensForDev;
1091 
1092     /******************/
1093 
1094     // exlcude from fees and max transaction amount
1095     mapping(address => bool) private _isExcludedFromFees;
1096     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1097 
1098     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1099     // could be subject to a maximum transfer amount
1100     mapping(address => bool) public automatedMarketMakerPairs;
1101 
1102     event UpdateUniswapV2Router(
1103         address indexed newAddress,
1104         address indexed oldAddress
1105     );
1106 
1107     event ExcludeFromFees(address indexed account, bool isExcluded);
1108 
1109     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1110 
1111     event marketingWalletUpdated(
1112         address indexed newWallet,
1113         address indexed oldWallet
1114     );
1115 
1116     event devWalletUpdated(
1117         address indexed newWallet,
1118         address indexed oldWallet
1119     );
1120 
1121     event SwapAndLiquify(
1122         uint256 tokensSwapped,
1123         uint256 ethReceived,
1124         uint256 tokensIntoLiquidity
1125     );
1126 
1127     event AutoNukeLP();
1128 
1129     event ManualNukeLP();
1130 
1131     constructor() ERC20("BBone", "BabyBone") {
1132         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1133             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1134         );
1135 
1136         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1137         uniswapV2Router = _uniswapV2Router;
1138 
1139         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1140             .createPair(address(this), _uniswapV2Router.WETH());
1141         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1142         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1143 
1144         uint256 _buyMarketingFee = 3;
1145         uint256 _buyLiquidityFee = 1;
1146         uint256 _buyDevFee = 1;
1147 
1148         uint256 _sellMarketingFee = 3;
1149         uint256 _sellLiquidityFee = 1;
1150         uint256 _sellDevFee = 1;
1151 
1152         uint256 totalSupply = 1_000_000_000 * 1e18;
1153 
1154         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1155         maxWallet = 20_000_000 * 1e18; // 3% from total supply maxWallet
1156         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1157 
1158         buyMarketingFee = _buyMarketingFee;
1159         buyLiquidityFee = _buyLiquidityFee;
1160         buyDevFee = _buyDevFee;
1161         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1162 
1163         sellMarketingFee = _sellMarketingFee;
1164         sellLiquidityFee = _sellLiquidityFee;
1165         sellDevFee = _sellDevFee;
1166         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1167 
1168         marketingWallet = address(0x6A6852e3E42c01Be26a9DAc7312A85629174e4ea); // set as marketing wallet
1169         devWallet = address(0xc7D0445ac2947760b3dD388B8586Adf079972Bf3); // set as dev wallet
1170 
1171         // exclude from paying fees or having max transaction amount
1172         excludeFromFees(owner(), true);
1173         excludeFromFees(address(this), true);
1174         excludeFromFees(address(0xdead), true);
1175 
1176         excludeFromMaxTransaction(owner(), true);
1177         excludeFromMaxTransaction(address(this), true);
1178         excludeFromMaxTransaction(address(0xdead), true);
1179 
1180         /*
1181             _mint is an internal function in ERC20.sol that is only called here,
1182             and CANNOT be called ever again
1183         */
1184         _mint(msg.sender, totalSupply);
1185     }
1186 
1187     receive() external payable {}
1188 
1189     // once enabled, can never be turned off
1190     function enableTrading() external onlyOwner {
1191         tradingActive = true;
1192         swapEnabled = true;
1193         lastLpBurnTime = block.timestamp;
1194     }
1195 
1196     // remove limits after token is stable
1197     function removeLimits() external onlyOwner returns (bool) {
1198         limitsInEffect = false;
1199         return true;
1200     }
1201 
1202     // disable Transfer delay - cannot be reenabled
1203     function disableTransferDelay() external onlyOwner returns (bool) {
1204         transferDelayEnabled = false;
1205         return true;
1206     }
1207 
1208     // change the minimum amount of tokens to sell from fees
1209     function updateSwapTokensAtAmount(uint256 newAmount)
1210         external
1211         onlyOwner
1212         returns (bool)
1213     {
1214         require(
1215             newAmount >= (totalSupply() * 1) / 100000,
1216             "Swap amount cannot be lower than 0.001% total supply."
1217         );
1218         require(
1219             newAmount <= (totalSupply() * 5) / 1000,
1220             "Swap amount cannot be higher than 0.5% total supply."
1221         );
1222         swapTokensAtAmount = newAmount;
1223         return true;
1224     }
1225 
1226     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1227         require(
1228             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1229             "Cannot set maxTransactionAmount lower than 0.1%"
1230         );
1231         maxTransactionAmount = newNum * (10**18);
1232     }
1233 
1234     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1235         require(
1236             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1237             "Cannot set maxWallet lower than 0.5%"
1238         );
1239         maxWallet = newNum * (10**18);
1240     }
1241 
1242     function excludeFromMaxTransaction(address updAds, bool isEx)
1243         public
1244         onlyOwner
1245     {
1246         _isExcludedMaxTransactionAmount[updAds] = isEx;
1247     }
1248 
1249     // only use to disable contract sales if absolutely necessary (emergency use only)
1250     function updateSwapEnabled(bool enabled) external onlyOwner {
1251         swapEnabled = enabled;
1252     }
1253 
1254     function updateBuyFees(
1255         uint256 _marketingFee,
1256         uint256 _liquidityFee,
1257         uint256 _devFee
1258     ) external onlyOwner {
1259         buyMarketingFee = _marketingFee;
1260         buyLiquidityFee = _liquidityFee;
1261         buyDevFee = _devFee;
1262         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1263         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1264     }
1265 
1266     function updateSellFees(
1267         uint256 _marketingFee,
1268         uint256 _liquidityFee,
1269         uint256 _devFee
1270     ) external onlyOwner {
1271         sellMarketingFee = _marketingFee;
1272         sellLiquidityFee = _liquidityFee;
1273         sellDevFee = _devFee;
1274         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1275         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1276     }
1277 
1278     function excludeFromFees(address account, bool excluded) public onlyOwner {
1279         _isExcludedFromFees[account] = excluded;
1280         emit ExcludeFromFees(account, excluded);
1281     }
1282 
1283     function setAutomatedMarketMakerPair(address pair, bool value)
1284         public
1285         onlyOwner
1286     {
1287         require(
1288             pair != uniswapV2Pair,
1289             "The pair cannot be removed from automatedMarketMakerPairs"
1290         );
1291 
1292         _setAutomatedMarketMakerPair(pair, value);
1293     }
1294 
1295     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1296         automatedMarketMakerPairs[pair] = value;
1297 
1298         emit SetAutomatedMarketMakerPair(pair, value);
1299     }
1300 
1301     function updateMarketingWallet(address newMarketingWallet)
1302         external
1303         onlyOwner
1304     {
1305         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1306         marketingWallet = newMarketingWallet;
1307     }
1308 
1309     function updateDevWallet(address newWallet) external onlyOwner {
1310         emit devWalletUpdated(newWallet, devWallet);
1311         devWallet = newWallet;
1312     }
1313 
1314     function isExcludedFromFees(address account) public view returns (bool) {
1315         return _isExcludedFromFees[account];
1316     }
1317 
1318     event BoughtEarly(address indexed sniper);
1319 
1320     function _transfer(
1321         address from,
1322         address to,
1323         uint256 amount
1324     ) internal override {
1325         require(from != address(0), "ERC20: transfer from the zero address");
1326         require(to != address(0), "ERC20: transfer to the zero address");
1327 
1328         if (amount == 0) {
1329             super._transfer(from, to, 0);
1330             return;
1331         }
1332 
1333         if (limitsInEffect) {
1334             if (
1335                 from != owner() &&
1336                 to != owner() &&
1337                 to != address(0) &&
1338                 to != address(0xdead) &&
1339                 !swapping
1340             ) {
1341                 if (!tradingActive) {
1342                     require(
1343                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1344                         "Trading is not active."
1345                     );
1346                 }
1347 
1348                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1349                 if (transferDelayEnabled) {
1350                     if (
1351                         to != owner() &&
1352                         to != address(uniswapV2Router) &&
1353                         to != address(uniswapV2Pair)
1354                     ) {
1355                         require(
1356                             _holderLastTransferTimestamp[tx.origin] <
1357                                 block.number,
1358                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1359                         );
1360                         _holderLastTransferTimestamp[tx.origin] = block.number;
1361                     }
1362                 }
1363 
1364                 //when buy
1365                 if (
1366                     automatedMarketMakerPairs[from] &&
1367                     !_isExcludedMaxTransactionAmount[to]
1368                 ) {
1369                     require(
1370                         amount <= maxTransactionAmount,
1371                         "Buy transfer amount exceeds the maxTransactionAmount."
1372                     );
1373                     require(
1374                         amount + balanceOf(to) <= maxWallet,
1375                         "Max wallet exceeded"
1376                     );
1377                 }
1378                 //when sell
1379                 else if (
1380                     automatedMarketMakerPairs[to] &&
1381                     !_isExcludedMaxTransactionAmount[from]
1382                 ) {
1383                     require(
1384                         amount <= maxTransactionAmount,
1385                         "Sell transfer amount exceeds the maxTransactionAmount."
1386                     );
1387                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1388                     require(
1389                         amount + balanceOf(to) <= maxWallet,
1390                         "Max wallet exceeded"
1391                     );
1392                 }
1393             }
1394         }
1395 
1396         uint256 contractTokenBalance = balanceOf(address(this));
1397 
1398         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1399 
1400         if (
1401             canSwap &&
1402             swapEnabled &&
1403             !swapping &&
1404             !automatedMarketMakerPairs[from] &&
1405             !_isExcludedFromFees[from] &&
1406             !_isExcludedFromFees[to]
1407         ) {
1408             swapping = true;
1409 
1410             swapBack();
1411 
1412             swapping = false;
1413         }
1414 
1415         if (
1416             !swapping &&
1417             automatedMarketMakerPairs[to] &&
1418             lpBurnEnabled &&
1419             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1420             !_isExcludedFromFees[from]
1421         ) {
1422             autoBurnLiquidityPairTokens();
1423         }
1424 
1425         bool takeFee = !swapping;
1426 
1427         // if any account belongs to _isExcludedFromFee account then remove the fee
1428         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1429             takeFee = false;
1430         }
1431 
1432         uint256 fees = 0;
1433         // only take fees on buys/sells, do not take on wallet transfers
1434         if (takeFee) {
1435             // on sell
1436             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1437                 fees = amount.mul(sellTotalFees).div(100);
1438                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1439                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1440                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1441             }
1442             // on buy
1443             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1444                 fees = amount.mul(buyTotalFees).div(100);
1445                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1446                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1447                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1448             }
1449 
1450             if (fees > 0) {
1451                 super._transfer(from, address(this), fees);
1452             }
1453 
1454             amount -= fees;
1455         }
1456 
1457         super._transfer(from, to, amount);
1458     }
1459 
1460     function swapTokensForEth(uint256 tokenAmount) private {
1461         // generate the uniswap pair path of token -> weth
1462         address[] memory path = new address[](2);
1463         path[0] = address(this);
1464         path[1] = uniswapV2Router.WETH();
1465 
1466         _approve(address(this), address(uniswapV2Router), tokenAmount);
1467 
1468         // make the swap
1469         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1470             tokenAmount,
1471             0, // accept any amount of ETH
1472             path,
1473             address(this),
1474             block.timestamp
1475         );
1476     }
1477 
1478     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1479         // approve token transfer to cover all possible scenarios
1480         _approve(address(this), address(uniswapV2Router), tokenAmount);
1481 
1482         // add the liquidity
1483         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1484             address(this),
1485             tokenAmount,
1486             0, // slippage is unavoidable
1487             0, // slippage is unavoidable
1488             deadAddress,
1489             block.timestamp
1490         );
1491     }
1492 
1493     function swapBack() private {
1494         uint256 contractBalance = balanceOf(address(this));
1495         uint256 totalTokensToSwap = tokensForLiquidity +
1496             tokensForMarketing +
1497             tokensForDev;
1498         bool success;
1499 
1500         if (contractBalance == 0 || totalTokensToSwap == 0) {
1501             return;
1502         }
1503 
1504         if (contractBalance > swapTokensAtAmount * 20) {
1505             contractBalance = swapTokensAtAmount * 20;
1506         }
1507 
1508         // Halve the amount of liquidity tokens
1509         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1510             totalTokensToSwap /
1511             2;
1512         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1513 
1514         uint256 initialETHBalance = address(this).balance;
1515 
1516         swapTokensForEth(amountToSwapForETH);
1517 
1518         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1519 
1520         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1521             totalTokensToSwap
1522         );
1523         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1524 
1525         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1526 
1527         tokensForLiquidity = 0;
1528         tokensForMarketing = 0;
1529         tokensForDev = 0;
1530 
1531         (success, ) = address(devWallet).call{value: ethForDev}("");
1532 
1533         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1534             addLiquidity(liquidityTokens, ethForLiquidity);
1535             emit SwapAndLiquify(
1536                 amountToSwapForETH,
1537                 ethForLiquidity,
1538                 tokensForLiquidity
1539             );
1540         }
1541 
1542         (success, ) = address(marketingWallet).call{
1543             value: address(this).balance
1544         }("");
1545     }
1546 
1547     function setAutoLPBurnSettings(
1548         uint256 _frequencyInSeconds,
1549         uint256 _percent,
1550         bool _Enabled
1551     ) external onlyOwner {
1552         require(
1553             _frequencyInSeconds >= 600,
1554             "cannot set buyback more often than every 10 minutes"
1555         );
1556         require(
1557             _percent <= 1000 && _percent >= 0,
1558             "Must set auto LP burn percent between 0% and 10%"
1559         );
1560         lpBurnFrequency = _frequencyInSeconds;
1561         percentForLPBurn = _percent;
1562         lpBurnEnabled = _Enabled;
1563     }
1564 
1565     function autoBurnLiquidityPairTokens() internal returns (bool) {
1566         lastLpBurnTime = block.timestamp;
1567 
1568         // get balance of liquidity pair
1569         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1570 
1571         // calculate amount to burn
1572         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1573             10000
1574         );
1575 
1576         // pull tokens from pancakePair liquidity and move to dead address permanently
1577         if (amountToBurn > 0) {
1578             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1579         }
1580 
1581         //sync price since this is not in a swap transaction!
1582         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1583         pair.sync();
1584         emit AutoNukeLP();
1585         return true;
1586     }
1587 
1588     function manualBurnLiquidityPairTokens(uint256 percent)
1589         external
1590         onlyOwner
1591         returns (bool)
1592     {
1593         require(
1594             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1595             "Must wait for cooldown to finish"
1596         );
1597         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1598         lastManualLpBurnTime = block.timestamp;
1599 
1600         // get balance of liquidity pair
1601         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1602 
1603         // calculate amount to burn
1604         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1605 
1606         // pull tokens from pancakePair liquidity and move to dead address permanently
1607         if (amountToBurn > 0) {
1608             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1609         }
1610 
1611         //sync price since this is not in a swap transaction!
1612         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1613         pair.sync();
1614         emit ManualNukeLP();
1615         return true;
1616     }
1617 }