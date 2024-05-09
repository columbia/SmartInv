1 // File: TIP.sol
2 // SPDX-License-Identifier: MIT
3 
4 /**
5 
6 TIPSTER | $TIP
7 
8 Tipster is a decentralized platform that provides expert betting 
9 tips to sports bettors worldwide. Our premium Telegram bot delivers 
10 tips exclusively to $TIP holders, and our pool betting, BAAS, and P2P 
11 options offer even more ways to bet on your favorite sports.  
12 
13     Website:     https://www.tipsterxbets.com/
14     Telegram:    https://t.me/TipsterXbets
15     Twitter:     https://twitter.com/TipsterXbets
16     Medium:      https://medium.com/@tipsterxbets
17 
18 */
19 
20 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
21 pragma experimental ABIEncoderV2;
22 
23 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
24 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
25 
26 /* pragma solidity ^0.8.0; */
27 
28 /**
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes calldata) {
44         return msg.data;
45     }
46 }
47 
48 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
49 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
50 
51 /* pragma solidity ^0.8.0; */
52 
53 /* import "../utils/Context.sol"; */
54 
55 /**
56  * @dev Contract module which provides a basic access control mechanism, where
57  * there is an account (an owner) that can be granted exclusive access to
58  * specific functions.
59  *
60  * By default, the owner account will be the one that deploys the contract. This
61  * can later be changed with {transferOwnership}.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 abstract contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor() {
76         _transferOwnership(_msgSender());
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Leaves the contract without owner. It will not be possible to call
96      * `onlyOwner` functions anymore. Can only be called by the current owner.
97      *
98      * NOTE: Renouncing ownership will leave the contract without an owner,
99      * thereby removing any functionality that is only available to the owner.
100      */
101     function renounceOwnership() public virtual onlyOwner {
102         _transferOwnership(address(0));
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Can only be called by the current owner.
108      */
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         _transferOwnership(newOwner);
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Internal function without access restriction.
117      */
118     function _transferOwnership(address newOwner) internal virtual {
119         address oldOwner = _owner;
120         _owner = newOwner;
121         emit OwnershipTransferred(oldOwner, newOwner);
122     }
123 }
124 
125 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
126 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
127 
128 /* pragma solidity ^0.8.0; */
129 
130 /**
131  * @dev Interface of the ERC20 standard as defined in the EIP.
132  */
133 interface IERC20 {
134     /**
135      * @dev Returns the amount of tokens in existence.
136      */
137     function totalSupply() external view returns (uint256);
138 
139     /**
140      * @dev Returns the amount of tokens owned by `account`.
141      */
142     function balanceOf(address account) external view returns (uint256);
143 
144     /**
145      * @dev Moves `amount` tokens from the caller's account to `recipient`.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transfer(address recipient, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Returns the remaining number of tokens that `spender` will be
155      * allowed to spend on behalf of `owner` through {transferFrom}. This is
156      * zero by default.
157      *
158      * This value changes when {approve} or {transferFrom} are called.
159      */
160     function allowance(address owner, address spender) external view returns (uint256);
161 
162     /**
163      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * IMPORTANT: Beware that changing an allowance with this method brings the risk
168      * that someone may use both the old and the new allowance by unfortunate
169      * transaction ordering. One possible solution to mitigate this race
170      * condition is to first reduce the spender's allowance to 0 and set the
171      * desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      *
174      * Emits an {Approval} event.
175      */
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Moves `amount` tokens from `sender` to `recipient` using the
180      * allowance mechanism. `amount` is then deducted from the caller's
181      * allowance.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) external returns (bool);
192 
193     /**
194      * @dev Emitted when `value` tokens are moved from one account (`from`) to
195      * another (`to`).
196      *
197      * Note that `value` may be zero.
198      */
199     event Transfer(address indexed from, address indexed to, uint256 value);
200 
201     /**
202      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
203      * a call to {approve}. `value` is the new allowance.
204      */
205     event Approval(address indexed owner, address indexed spender, uint256 value);
206 }
207 
208 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
209 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
210 
211 /* pragma solidity ^0.8.0; */
212 
213 /* import "../IERC20.sol"; */
214 
215 /**
216  * @dev Interface for the optional metadata functions from the ERC20 standard.
217  *
218  * _Available since v4.1._
219  */
220 interface IERC20Metadata is IERC20 {
221     /**
222      * @dev Returns the name of the token.
223      */
224     function name() external view returns (string memory);
225 
226     /**
227      * @dev Returns the symbol of the token.
228      */
229     function symbol() external view returns (string memory);
230 
231     /**
232      * @dev Returns the decimals places of the token.
233      */
234     function decimals() external view returns (uint8);
235 }
236 
237 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
238 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
239 
240 /* pragma solidity ^0.8.0; */
241 
242 /* import "./IERC20.sol"; */
243 /* import "./extensions/IERC20Metadata.sol"; */
244 /* import "../../utils/Context.sol"; */
245 
246 /**
247  * @dev Implementation of the {IERC20} interface.
248  *
249  * This implementation is agnostic to the way tokens are created. This means
250  * that a supply mechanism has to be added in a derived contract using {_mint}.
251  * For a generic mechanism see {ERC20PresetMinterPauser}.
252  *
253  * TIP: For a detailed writeup see our guide
254  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
255  * to implement supply mechanisms].
256  *
257  * We have followed general OpenZeppelin Contracts guidelines: functions revert
258  * instead returning `false` on failure. This behavior is nonetheless
259  * conventional and does not conflict with the expectations of ERC20
260  * applications.
261  *
262  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
263  * This allows applications to reconstruct the allowance for all accounts just
264  * by listening to said events. Other implementations of the EIP may not emit
265  * these events, as it isn't required by the specification.
266  *
267  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
268  * functions have been added to mitigate the well-known issues around setting
269  * allowances. See {IERC20-approve}.
270  */
271 contract ERC20 is Context, IERC20, IERC20Metadata {
272     mapping(address => uint256) private _balances;
273 
274     mapping(address => mapping(address => uint256)) private _allowances;
275 
276     uint256 private _totalSupply;
277 
278     string private _name;
279     string private _symbol;
280 
281     /**
282      * @dev Sets the values for {name} and {symbol}.
283      *
284      * The default value of {decimals} is 18. To select a different value for
285      * {decimals} you should overload it.
286      *
287      * All two of these values are immutable: they can only be set once during
288      * construction.
289      */
290     constructor(string memory name_, string memory symbol_) {
291         _name = name_;
292         _symbol = symbol_;
293     }
294 
295     /**
296      * @dev Returns the name of the token.
297      */
298     function name() public view virtual override returns (string memory) {
299         return _name;
300     }
301 
302     /**
303      * @dev Returns the symbol of the token, usually a shorter version of the
304      * name.
305      */
306     function symbol() public view virtual override returns (string memory) {
307         return _symbol;
308     }
309 
310     /**
311      * @dev Returns the number of decimals used to get its user representation.
312      * For example, if `decimals` equals `2`, a balance of `505` tokens should
313      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
314      *
315      * Tokens usually opt for a value of 18, imitating the relationship between
316      * Ether and Wei. This is the value {ERC20} uses, unless this function is
317      * overridden;
318      *
319      * NOTE: This information is only used for _display_ purposes: it in
320      * no way affects any of the arithmetic of the contract, including
321      * {IERC20-balanceOf} and {IERC20-transfer}.
322      */
323     function decimals() public view virtual override returns (uint8) {
324         return 18;
325     }
326 
327     /**
328      * @dev See {IERC20-totalSupply}.
329      */
330     function totalSupply() public view virtual override returns (uint256) {
331         return _totalSupply;
332     }
333 
334     /**
335      * @dev See {IERC20-balanceOf}.
336      */
337     function balanceOf(address account) public view virtual override returns (uint256) {
338         return _balances[account];
339     }
340 
341     /**
342      * @dev See {IERC20-transfer}.
343      *
344      * Requirements:
345      *
346      * - `recipient` cannot be the zero address.
347      * - the caller must have a balance of at least `amount`.
348      */
349     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
350         _transfer(_msgSender(), recipient, amount);
351         return true;
352     }
353 
354     /**
355      * @dev See {IERC20-allowance}.
356      */
357     function allowance(address owner, address spender) public view virtual override returns (uint256) {
358         return _allowances[owner][spender];
359     }
360 
361     /**
362      * @dev See {IERC20-approve}.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      */
368     function approve(address spender, uint256 amount) public virtual override returns (bool) {
369         _approve(_msgSender(), spender, amount);
370         return true;
371     }
372 
373     /**
374      * @dev See {IERC20-transferFrom}.
375      *
376      * Emits an {Approval} event indicating the updated allowance. This is not
377      * required by the EIP. See the note at the beginning of {ERC20}.
378      *
379      * Requirements:
380      *
381      * - `sender` and `recipient` cannot be the zero address.
382      * - `sender` must have a balance of at least `amount`.
383      * - the caller must have allowance for ``sender``'s tokens of at least
384      * `amount`.
385      */
386     function transferFrom(
387         address sender,
388         address recipient,
389         uint256 amount
390     ) public virtual override returns (bool) {
391         _transfer(sender, recipient, amount);
392 
393         uint256 currentAllowance = _allowances[sender][_msgSender()];
394         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
395         unchecked {
396             _approve(sender, _msgSender(), currentAllowance - amount);
397         }
398 
399         return true;
400     }
401 
402     /**
403      * @dev Atomically increases the allowance granted to `spender` by the caller.
404      *
405      * This is an alternative to {approve} that can be used as a mitigation for
406      * problems described in {IERC20-approve}.
407      *
408      * Emits an {Approval} event indicating the updated allowance.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      */
414     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
415         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
416         return true;
417     }
418 
419     /**
420      * @dev Atomically decreases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      * - `spender` must have allowance for the caller of at least
431      * `subtractedValue`.
432      */
433     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
434         uint256 currentAllowance = _allowances[_msgSender()][spender];
435         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
436         unchecked {
437             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
438         }
439 
440         return true;
441     }
442 
443     /**
444      * @dev Moves `amount` of tokens from `sender` to `recipient`.
445      *
446      * This internal function is equivalent to {transfer}, and can be used to
447      * e.g. implement automatic token fees, slashing mechanisms, etc.
448      *
449      * Emits a {Transfer} event.
450      *
451      * Requirements:
452      *
453      * - `sender` cannot be the zero address.
454      * - `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `amount`.
456      */
457     function _transfer(
458         address sender,
459         address recipient,
460         uint256 amount
461     ) internal virtual {
462         require(sender != address(0), "ERC20: transfer from the zero address");
463         require(recipient != address(0), "ERC20: transfer to the zero address");
464 
465         _beforeTokenTransfer(sender, recipient, amount);
466 
467         uint256 senderBalance = _balances[sender];
468         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
469         unchecked {
470             _balances[sender] = senderBalance - amount;
471         }
472         _balances[recipient] += amount;
473 
474         emit Transfer(sender, recipient, amount);
475 
476         _afterTokenTransfer(sender, recipient, amount);
477     }
478 
479     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
480      * the total supply.
481      *
482      * Emits a {Transfer} event with `from` set to the zero address.
483      *
484      * Requirements:
485      *
486      * - `account` cannot be the zero address.
487      */
488     function _mint(address account, uint256 amount) internal virtual {
489         require(account != address(0), "ERC20: mint to the zero address");
490 
491         _beforeTokenTransfer(address(0), account, amount);
492 
493         _totalSupply += amount;
494         _balances[account] += amount;
495         emit Transfer(address(0), account, amount);
496 
497         _afterTokenTransfer(address(0), account, amount);
498     }
499 
500     /**
501      * @dev Destroys `amount` tokens from `account`, reducing the
502      * total supply.
503      *
504      * Emits a {Transfer} event with `to` set to the zero address.
505      *
506      * Requirements:
507      *
508      * - `account` cannot be the zero address.
509      * - `account` must have at least `amount` tokens.
510      */
511     function _burn(address account, uint256 amount) internal virtual {
512         require(account != address(0), "ERC20: burn from the zero address");
513 
514         _beforeTokenTransfer(account, address(0), amount);
515 
516         uint256 accountBalance = _balances[account];
517         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
518         unchecked {
519             _balances[account] = accountBalance - amount;
520         }
521         _totalSupply -= amount;
522 
523         emit Transfer(account, address(0), amount);
524 
525         _afterTokenTransfer(account, address(0), amount);
526     }
527 
528     /**
529      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
530      *
531      * This internal function is equivalent to `approve`, and can be used to
532      * e.g. set automatic allowances for certain subsystems, etc.
533      *
534      * Emits an {Approval} event.
535      *
536      * Requirements:
537      *
538      * - `owner` cannot be the zero address.
539      * - `spender` cannot be the zero address.
540      */
541     function _approve(
542         address owner,
543         address spender,
544         uint256 amount
545     ) internal virtual {
546         require(owner != address(0), "ERC20: approve from the zero address");
547         require(spender != address(0), "ERC20: approve to the zero address");
548 
549         _allowances[owner][spender] = amount;
550         emit Approval(owner, spender, amount);
551     }
552 
553     /**
554      * @dev Hook that is called before any transfer of tokens. This includes
555      * minting and burning.
556      *
557      * Calling conditions:
558      *
559      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
560      * will be transferred to `to`.
561      * - when `from` is zero, `amount` tokens will be minted for `to`.
562      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
563      * - `from` and `to` are never both zero.
564      *
565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
566      */
567     function _beforeTokenTransfer(
568         address from,
569         address to,
570         uint256 amount
571     ) internal virtual {}
572 
573     /**
574      * @dev Hook that is called after any transfer of tokens. This includes
575      * minting and burning.
576      *
577      * Calling conditions:
578      *
579      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
580      * has been transferred to `to`.
581      * - when `from` is zero, `amount` tokens have been minted for `to`.
582      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
583      * - `from` and `to` are never both zero.
584      *
585      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
586      */
587     function _afterTokenTransfer(
588         address from,
589         address to,
590         uint256 amount
591     ) internal virtual {}
592 }
593 
594 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
595 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
596 
597 /* pragma solidity ^0.8.0; */
598 
599 // CAUTION
600 // This version of SafeMath should only be used with Solidity 0.8 or later,
601 // because it relies on the compiler's built in overflow checks.
602 
603 /**
604  * @dev Wrappers over Solidity's arithmetic operations.
605  *
606  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
607  * now has built in overflow checking.
608  */
609 library SafeMath {
610     /**
611      * @dev Returns the addition of two unsigned integers, with an overflow flag.
612      *
613      * _Available since v3.4._
614      */
615     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
616         unchecked {
617             uint256 c = a + b;
618             if (c < a) return (false, 0);
619             return (true, c);
620         }
621     }
622 
623     /**
624      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
625      *
626      * _Available since v3.4._
627      */
628     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
629         unchecked {
630             if (b > a) return (false, 0);
631             return (true, a - b);
632         }
633     }
634 
635     /**
636      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
637      *
638      * _Available since v3.4._
639      */
640     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
641         unchecked {
642             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
643             // benefit is lost if 'b' is also tested.
644             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
645             if (a == 0) return (true, 0);
646             uint256 c = a * b;
647             if (c / a != b) return (false, 0);
648             return (true, c);
649         }
650     }
651 
652     /**
653      * @dev Returns the division of two unsigned integers, with a division by zero flag.
654      *
655      * _Available since v3.4._
656      */
657     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
658         unchecked {
659             if (b == 0) return (false, 0);
660             return (true, a / b);
661         }
662     }
663 
664     /**
665      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
666      *
667      * _Available since v3.4._
668      */
669     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
670         unchecked {
671             if (b == 0) return (false, 0);
672             return (true, a % b);
673         }
674     }
675 
676     /**
677      * @dev Returns the addition of two unsigned integers, reverting on
678      * overflow.
679      *
680      * Counterpart to Solidity's `+` operator.
681      *
682      * Requirements:
683      *
684      * - Addition cannot overflow.
685      */
686     function add(uint256 a, uint256 b) internal pure returns (uint256) {
687         return a + b;
688     }
689 
690     /**
691      * @dev Returns the subtraction of two unsigned integers, reverting on
692      * overflow (when the result is negative).
693      *
694      * Counterpart to Solidity's `-` operator.
695      *
696      * Requirements:
697      *
698      * - Subtraction cannot overflow.
699      */
700     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
701         return a - b;
702     }
703 
704     /**
705      * @dev Returns the multiplication of two unsigned integers, reverting on
706      * overflow.
707      *
708      * Counterpart to Solidity's `*` operator.
709      *
710      * Requirements:
711      *
712      * - Multiplication cannot overflow.
713      */
714     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
715         return a * b;
716     }
717 
718     /**
719      * @dev Returns the integer division of two unsigned integers, reverting on
720      * division by zero. The result is rounded towards zero.
721      *
722      * Counterpart to Solidity's `/` operator.
723      *
724      * Requirements:
725      *
726      * - The divisor cannot be zero.
727      */
728     function div(uint256 a, uint256 b) internal pure returns (uint256) {
729         return a / b;
730     }
731 
732     /**
733      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
734      * reverting when dividing by zero.
735      *
736      * Counterpart to Solidity's `%` operator. This function uses a `revert`
737      * opcode (which leaves remaining gas untouched) while Solidity uses an
738      * invalid opcode to revert (consuming all remaining gas).
739      *
740      * Requirements:
741      *
742      * - The divisor cannot be zero.
743      */
744     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
745         return a % b;
746     }
747 
748     /**
749      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
750      * overflow (when the result is negative).
751      *
752      * CAUTION: This function is deprecated because it requires allocating memory for the error
753      * message unnecessarily. For custom revert reasons use {trySub}.
754      *
755      * Counterpart to Solidity's `-` operator.
756      *
757      * Requirements:
758      *
759      * - Subtraction cannot overflow.
760      */
761     function sub(
762         uint256 a,
763         uint256 b,
764         string memory errorMessage
765     ) internal pure returns (uint256) {
766         unchecked {
767             require(b <= a, errorMessage);
768             return a - b;
769         }
770     }
771 
772     /**
773      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
774      * division by zero. The result is rounded towards zero.
775      *
776      * Counterpart to Solidity's `/` operator. Note: this function uses a
777      * `revert` opcode (which leaves remaining gas untouched) while Solidity
778      * uses an invalid opcode to revert (consuming all remaining gas).
779      *
780      * Requirements:
781      *
782      * - The divisor cannot be zero.
783      */
784     function div(
785         uint256 a,
786         uint256 b,
787         string memory errorMessage
788     ) internal pure returns (uint256) {
789         unchecked {
790             require(b > 0, errorMessage);
791             return a / b;
792         }
793     }
794 
795     /**
796      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
797      * reverting with custom message when dividing by zero.
798      *
799      * CAUTION: This function is deprecated because it requires allocating memory for the error
800      * message unnecessarily. For custom revert reasons use {tryMod}.
801      *
802      * Counterpart to Solidity's `%` operator. This function uses a `revert`
803      * opcode (which leaves remaining gas untouched) while Solidity uses an
804      * invalid opcode to revert (consuming all remaining gas).
805      *
806      * Requirements:
807      *
808      * - The divisor cannot be zero.
809      */
810     function mod(
811         uint256 a,
812         uint256 b,
813         string memory errorMessage
814     ) internal pure returns (uint256) {
815         unchecked {
816             require(b > 0, errorMessage);
817             return a % b;
818         }
819     }
820 }
821 
822 ////// src/IUniswapV2Factory.sol
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
856 ////// src/IUniswapV2Pair.sol
857 /* pragma solidity 0.8.10; */
858 /* pragma experimental ABIEncoderV2; */
859 
860 interface IUniswapV2Pair {
861     event Approval(
862         address indexed owner,
863         address indexed spender,
864         uint256 value
865     );
866     event Transfer(address indexed from, address indexed to, uint256 value);
867 
868     function name() external pure returns (string memory);
869 
870     function symbol() external pure returns (string memory);
871 
872     function decimals() external pure returns (uint8);
873 
874     function totalSupply() external view returns (uint256);
875 
876     function balanceOf(address owner) external view returns (uint256);
877 
878     function allowance(address owner, address spender)
879         external
880         view
881         returns (uint256);
882 
883     function approve(address spender, uint256 value) external returns (bool);
884 
885     function transfer(address to, uint256 value) external returns (bool);
886 
887     function transferFrom(
888         address from,
889         address to,
890         uint256 value
891     ) external returns (bool);
892 
893     function DOMAIN_SEPARATOR() external view returns (bytes32);
894 
895     function PERMIT_TYPEHASH() external pure returns (bytes32);
896 
897     function nonces(address owner) external view returns (uint256);
898 
899     function permit(
900         address owner,
901         address spender,
902         uint256 value,
903         uint256 deadline,
904         uint8 v,
905         bytes32 r,
906         bytes32 s
907     ) external;
908 
909     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
910     event Burn(
911         address indexed sender,
912         uint256 amount0,
913         uint256 amount1,
914         address indexed to
915     );
916     event Swap(
917         address indexed sender,
918         uint256 amount0In,
919         uint256 amount1In,
920         uint256 amount0Out,
921         uint256 amount1Out,
922         address indexed to
923     );
924     event Sync(uint112 reserve0, uint112 reserve1);
925 
926     function MINIMUM_LIQUIDITY() external pure returns (uint256);
927 
928     function factory() external view returns (address);
929 
930     function token0() external view returns (address);
931 
932     function token1() external view returns (address);
933 
934     function getReserves()
935         external
936         view
937         returns (
938             uint112 reserve0,
939             uint112 reserve1,
940             uint32 blockTimestampLast
941         );
942 
943     function price0CumulativeLast() external view returns (uint256);
944 
945     function price1CumulativeLast() external view returns (uint256);
946 
947     function kLast() external view returns (uint256);
948 
949     function mint(address to) external returns (uint256 liquidity);
950 
951     function burn(address to)
952         external
953         returns (uint256 amount0, uint256 amount1);
954 
955     function swap(
956         uint256 amount0Out,
957         uint256 amount1Out,
958         address to,
959         bytes calldata data
960     ) external;
961 
962     function skim(address to) external;
963 
964     function sync() external;
965 
966     function initialize(address, address) external;
967 }
968 
969 ////// src/IUniswapV2Router02.sol
970 /* pragma solidity 0.8.10; */
971 /* pragma experimental ABIEncoderV2; */
972 
973 interface IUniswapV2Router02 {
974     function factory() external pure returns (address);
975 
976     function WETH() external pure returns (address);
977 
978     function addLiquidity(
979         address tokenA,
980         address tokenB,
981         uint256 amountADesired,
982         uint256 amountBDesired,
983         uint256 amountAMin,
984         uint256 amountBMin,
985         address to,
986         uint256 deadline
987     )
988         external
989         returns (
990             uint256 amountA,
991             uint256 amountB,
992             uint256 liquidity
993         );
994 
995     function addLiquidityETH(
996         address token,
997         uint256 amountTokenDesired,
998         uint256 amountTokenMin,
999         uint256 amountETHMin,
1000         address to,
1001         uint256 deadline
1002     )
1003         external
1004         payable
1005         returns (
1006             uint256 amountToken,
1007             uint256 amountETH,
1008             uint256 liquidity
1009         );
1010 
1011     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1012         uint256 amountIn,
1013         uint256 amountOutMin,
1014         address[] calldata path,
1015         address to,
1016         uint256 deadline
1017     ) external;
1018 
1019     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1020         uint256 amountOutMin,
1021         address[] calldata path,
1022         address to,
1023         uint256 deadline
1024     ) external payable;
1025 
1026     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1027         uint256 amountIn,
1028         uint256 amountOutMin,
1029         address[] calldata path,
1030         address to,
1031         uint256 deadline
1032     ) external;
1033 }
1034 
1035 /* pragma solidity >=0.8.10; */
1036 
1037 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1038 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1039 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1040 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1041 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1042 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1043 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1044 
1045 contract TIP is ERC20, Ownable {
1046 
1047     /**
1048 
1049     TIPSTER | $TIP
1050 
1051     Tipster is a decentralized platform that provides expert betting 
1052     tips to sports bettors worldwide. Our premium Telegram bot delivers 
1053     tips exclusively to $TIP holders, and our pool betting, BAAS, and P2P 
1054     options offer even more ways to bet on your favorite sports.  
1055 
1056     Website:     https://www.tipsterxbets.com/
1057     Telegram:    https://t.me/TipsterXbets
1058     Twitter:     https://twitter.com/TipsterXbets
1059     Medium:      https://medium.com/@tipsterxbets
1060 
1061     */
1062 
1063 
1064     using SafeMath for uint256;
1065 
1066     IUniswapV2Router02 public immutable uniswapV2Router;
1067     address public immutable uniswapV2Pair;
1068     address public constant deadAddress = address(0xdead);
1069 
1070     bool private swapping;
1071 
1072     address public operationsWallet;
1073     address public devWallet;
1074 
1075     uint256 public maxTransactionAmount;
1076     uint256 public swapTokensAtAmount;
1077     uint256 public maxWallet;
1078 
1079     uint256 public percentForLPBurn = 0;
1080     bool public lpBurnEnabled = false;
1081     uint256 public lpBurnFrequency = 1200 seconds;
1082     uint256 public lastLpBurnTime;
1083 
1084     uint256 public manualBurnFrequency = 20 minutes;
1085     uint256 public lastManualLpBurnTime;
1086 
1087     bool public limitsInEffect = true;
1088     bool public tradingActive = false;
1089     bool public swapEnabled = false;
1090 
1091     // Anti-bot and anti-whale mappings and variables
1092     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1093     bool public transferDelayEnabled = false;
1094 
1095     uint256 public buyTotalFees;
1096     uint256 public buyOperationsFee;
1097     uint256 public buyLiquidityFee;
1098     uint256 public buyDevFee;
1099 
1100     uint256 public sellTotalFees;
1101     uint256 public sellOperationsFee;
1102     uint256 public sellLiquidityFee;
1103     uint256 public sellDevFee;
1104 
1105     uint256 public tokensForOperations;
1106     uint256 public tokensForLiquidity;
1107     uint256 public tokensForDev;
1108 
1109     uint256 public FEE_DIVISOR = 100;
1110 
1111     /******************/
1112 
1113     // exlcude from fees and max transaction amount
1114     mapping(address => bool) private _isExcludedFromFees;
1115     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1116 
1117     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1118     // could be subject to a maximum transfer amount
1119     mapping(address => bool) public automatedMarketMakerPairs;
1120 
1121     event UpdateUniswapV2Router(
1122         address indexed newAddress,
1123         address indexed oldAddress
1124     );
1125 
1126     event ExcludeFromFees(address indexed account, bool isExcluded);
1127 
1128     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1129 
1130     event operationsWalletUpdated(
1131         address indexed newWallet,
1132         address indexed oldWallet
1133     );
1134 
1135     event devWalletUpdated(
1136         address indexed newWallet,
1137         address indexed oldWallet
1138     );
1139 
1140     event SwapAndLiquify(
1141         uint256 tokensSwapped,
1142         uint256 ethReceived,
1143         uint256 tokensIntoLiquidity
1144     );
1145 
1146     event AutoNukeLP();
1147 
1148     event ManualNukeLP();
1149 
1150     constructor() ERC20("Tipster", "TIP") {
1151         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1152             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1153         );
1154 
1155         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1156         uniswapV2Router = _uniswapV2Router;
1157 
1158         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1159             .createPair(address(this), _uniswapV2Router.WETH());
1160         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1161         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1162 
1163         uint256 _buyOperationsFee = 5;
1164         uint256 _buyLiquidityFee = 0;
1165         uint256 _buyDevFee = 1;
1166 
1167         uint256 _sellOperationsFee = 5;
1168         uint256 _sellLiquidityFee = 0;
1169         uint256 _sellDevFee = 1;
1170 
1171         uint256 totalSupply = 1_000_000_000 * 1e18;
1172 
1173         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1174         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1175         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1176 
1177         buyOperationsFee = _buyOperationsFee;
1178         buyLiquidityFee = _buyLiquidityFee;
1179         buyDevFee = _buyDevFee;
1180         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee;
1181 
1182         sellOperationsFee = _sellOperationsFee;
1183         sellLiquidityFee = _sellLiquidityFee;
1184         sellDevFee = _sellDevFee;
1185         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee;
1186 
1187         operationsWallet = address(0xc9994f08E8f0d916eA0ED2742Ce59B098fA36930); // set as operations wallet
1188         devWallet = address(0xde960ff8169E98e00EA1b8C5F199Bc8B00C849F8); // set as dev wallet
1189 
1190         // exclude from paying fees or having max transaction amount
1191         excludeFromFees(owner(), true);
1192         excludeFromFees(address(this), true);
1193         excludeFromFees(address(0xdead), true);
1194         excludeFromFees(operationsWallet, true);
1195         excludeFromFees(devWallet, true);
1196         excludeFromFees(0x590a7cC27d9607C03085f725ac6B85Ac9EF85967, true);
1197 
1198         excludeFromMaxTransaction(owner(), true);
1199         excludeFromMaxTransaction(address(this), true);
1200         excludeFromMaxTransaction(address(0xdead), true);
1201         excludeFromMaxTransaction(operationsWallet, true);
1202         excludeFromMaxTransaction(devWallet, true);
1203         excludeFromMaxTransaction(0x590a7cC27d9607C03085f725ac6B85Ac9EF85967, true);
1204 
1205         /*
1206             _mint is an internal function in ERC20.sol that is only called here,
1207             and CANNOT be called ever again
1208         */
1209         _mint(msg.sender, totalSupply);
1210     }
1211 
1212     receive() external payable {}
1213 
1214     // once enabled, can never be turned off
1215     function enableTrading() external onlyOwner {
1216         tradingActive = true;
1217         swapEnabled = true;
1218         lastLpBurnTime = block.timestamp;
1219     }
1220 
1221     // remove limits after token is stable
1222     function removeLimits() external onlyOwner returns (bool) {
1223         limitsInEffect = false;
1224         return true;
1225     }
1226 
1227     // disable Transfer delay - cannot be reenabled
1228     function disableTransferDelay() external onlyOwner returns (bool) {
1229         transferDelayEnabled = false;
1230         return true;
1231     }
1232 
1233     // change the minimum amount of tokens to sell from fees
1234     function updateSwapTokensAtAmount(uint256 newAmount)
1235         external
1236         onlyOwner
1237         returns (bool)
1238     {
1239         require(
1240             newAmount >= (totalSupply() * 1) / 100000,
1241             "Swap amount cannot be lower than 0.001% total supply."
1242         );
1243         require(
1244             newAmount <= (totalSupply() * 5) / 1000,
1245             "Swap amount cannot be higher than 0.5% total supply."
1246         );
1247         swapTokensAtAmount = newAmount;
1248         return true;
1249     }
1250 
1251     // updateMaxTxnAmount
1252     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1253         require(
1254             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1255             "Cannot set maxTransactionAmount lower than 0.1%"
1256         );
1257         maxTransactionAmount = newNum * (10**18);
1258     }
1259 
1260     // updateMaxWalletAmount
1261     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1262         require(
1263             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1264             "Cannot set maxWallet lower than 0.5%"
1265         );
1266         maxWallet = newNum * (10**18);
1267     }
1268 
1269     // excludeFromMaxTransaction
1270     function excludeFromMaxTransaction(address updAds, bool isEx)
1271         public
1272         onlyOwner
1273     {
1274         _isExcludedMaxTransactionAmount[updAds] = isEx;
1275     }
1276 
1277     // only use to disable contract sales if absolutely necessary (emergency use only)
1278     function updateSwapEnabled(bool enabled) external onlyOwner {
1279         swapEnabled = enabled;
1280     }
1281 
1282     function updateBuyFees(
1283         uint256 _operationsFee,
1284         uint256 _liquidityFee,
1285         uint256 _devFee
1286     ) external onlyOwner {
1287         buyOperationsFee = _operationsFee;
1288         buyLiquidityFee = _liquidityFee;
1289         buyDevFee = _devFee;
1290         buyTotalFees = buyOperationsFee + buyLiquidityFee + buyDevFee;
1291         require(buyTotalFees <= 6, "Must keep fees at 6% or less");
1292     }
1293 
1294     function updateSellFees(
1295         uint256 _operationsFee,
1296         uint256 _liquidityFee,
1297         uint256 _devFee
1298     ) external onlyOwner {
1299         sellOperationsFee = _operationsFee;
1300         sellLiquidityFee = _liquidityFee;
1301         sellDevFee = _devFee;
1302         sellTotalFees = sellOperationsFee + sellLiquidityFee + sellDevFee;
1303         require(sellTotalFees <= 6, "Must keep fees at 6% or less");
1304     }
1305 
1306     function excludeFromFees(address account, bool excluded) public onlyOwner {
1307         _isExcludedFromFees[account] = excluded;
1308         emit ExcludeFromFees(account, excluded);
1309     }
1310 
1311     function setAutomatedMarketMakerPair(address pair, bool value)
1312         public
1313         onlyOwner
1314     {
1315         require(
1316             pair != uniswapV2Pair,
1317             "The pair cannot be removed from automatedMarketMakerPairs"
1318         );
1319 
1320         _setAutomatedMarketMakerPair(pair, value);
1321     }
1322 
1323     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1324         automatedMarketMakerPairs[pair] = value;
1325 
1326         emit SetAutomatedMarketMakerPair(pair, value);
1327     }
1328 
1329     function isExcludedFromFees(address account) public view returns (bool) {
1330         return _isExcludedFromFees[account];
1331     }
1332 
1333     // Event
1334     event BoughtEarly(address indexed sniper);
1335 
1336     function _transfer(
1337         address from,
1338         address to,
1339         uint256 amount
1340     ) internal override {
1341         require(from != address(0), "ERC20: transfer from the zero address");
1342         require(to != address(0), "ERC20: transfer to the zero address");
1343 
1344         if (amount == 0) {
1345             super._transfer(from, to, 0);
1346             return;
1347         }
1348 
1349         if (limitsInEffect) {
1350             if (
1351                 from != owner() &&
1352                 to != owner() &&
1353                 to != address(0) &&
1354                 to != address(0xdead) &&
1355                 !swapping
1356             ) {
1357                 if (!tradingActive) {
1358                     require(
1359                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1360                         "Trading is not active."
1361                     );
1362                 }
1363 
1364                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1365                 if (transferDelayEnabled) {
1366                     if (
1367                         to != owner() &&
1368                         to != address(uniswapV2Router) &&
1369                         to != address(uniswapV2Pair)
1370                     ) {
1371                         require(
1372                             _holderLastTransferTimestamp[tx.origin] <
1373                                 block.number,
1374                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1375                         );
1376                         _holderLastTransferTimestamp[tx.origin] = block.number;
1377                     }
1378                 }
1379 
1380                 //when buy
1381                 if (
1382                     automatedMarketMakerPairs[from] &&
1383                     !_isExcludedMaxTransactionAmount[to]
1384                 ) {
1385                     require(
1386                         amount <= maxTransactionAmount,
1387                         "Buy transfer amount exceeds the maxTransactionAmount."
1388                     );
1389                     require(
1390                         amount + balanceOf(to) <= maxWallet,
1391                         "Max wallet exceeded"
1392                     );
1393                 }
1394                 //when sell
1395                 else if (
1396                     automatedMarketMakerPairs[to] &&
1397                     !_isExcludedMaxTransactionAmount[from]
1398                 ) {
1399                     require(
1400                         amount <= maxTransactionAmount,
1401                         "Sell transfer amount exceeds the maxTransactionAmount."
1402                     );
1403                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1404                     require(
1405                         amount + balanceOf(to) <= maxWallet,
1406                         "Max wallet exceeded"
1407                     );
1408                 }
1409             }
1410         }
1411 
1412         uint256 contractTokenBalance = balanceOf(address(this));
1413 
1414         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1415 
1416         if (
1417             canSwap &&
1418             swapEnabled &&
1419             !swapping &&
1420             !automatedMarketMakerPairs[from] &&
1421             !_isExcludedFromFees[from] &&
1422             !_isExcludedFromFees[to]
1423         ) {
1424             swapping = true;
1425 
1426             swapBack();
1427 
1428             swapping = false;
1429         }
1430 
1431         if (
1432             !swapping &&
1433             automatedMarketMakerPairs[to] &&
1434             lpBurnEnabled &&
1435             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1436             !_isExcludedFromFees[from]
1437         ) {
1438             autoBurnLiquidityPairTokens();
1439         }
1440 
1441         bool takeFee = !swapping;
1442 
1443         // if any account belongs to _isExcludedFromFee account then remove the fee
1444         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1445             takeFee = false;
1446         }
1447 
1448         uint256 fees = 0;
1449         // only take fees on buys/sells, do not take on wallet transfers
1450         if (takeFee) {
1451             // on sell
1452             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1453                 fees = amount.mul(sellTotalFees).div(100);
1454                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1455                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1456                 tokensForOperations += (fees * sellOperationsFee) / sellTotalFees;
1457             }
1458             // on buy
1459             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1460                 fees = amount.mul(buyTotalFees).div(100);
1461                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1462                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1463                 tokensForOperations += (fees * buyOperationsFee) / buyTotalFees;
1464             }
1465 
1466             if (fees > 0) {
1467                 super._transfer(from, address(this), fees);
1468             }
1469 
1470             amount -= fees;
1471         }
1472 
1473         super._transfer(from, to, amount);
1474     }
1475 
1476     function swapTokensForEth(uint256 tokenAmount) private {
1477         // generate the uniswap pair path of token -> weth
1478         address[] memory path = new address[](2);
1479         path[0] = address(this);
1480         path[1] = uniswapV2Router.WETH();
1481 
1482         _approve(address(this), address(uniswapV2Router), tokenAmount);
1483 
1484         // make the swap
1485         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1486             tokenAmount,
1487             0, // accept any amount of ETH
1488             path,
1489             address(this),
1490             block.timestamp
1491         );
1492     }
1493 
1494     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1495         // approve token transfer to cover all possible scenarios
1496         _approve(address(this), address(uniswapV2Router), tokenAmount);
1497 
1498         // add the liquidity
1499         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1500             address(this),
1501             tokenAmount,
1502             0, // slippage is unavoidable
1503             0, // slippage is unavoidable
1504             deadAddress,
1505             block.timestamp
1506         );
1507     }
1508 
1509     // function used for swap back
1510     function swapBack() private {
1511         uint256 contractBalance = balanceOf(address(this));
1512         uint256 totalTokensToSwap = tokensForLiquidity +
1513             tokensForOperations +
1514             tokensForDev;
1515         bool success;
1516 
1517         if (contractBalance == 0 || totalTokensToSwap == 0) {
1518             return;
1519         }
1520 
1521         if (contractBalance > swapTokensAtAmount * 20) {
1522             contractBalance = swapTokensAtAmount * 20;
1523         }
1524 
1525         // Halve the amount of liquidity tokens
1526         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1527             totalTokensToSwap /
1528             2;
1529         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1530 
1531         uint256 initialETHBalance = address(this).balance;
1532 
1533         swapTokensForEth(amountToSwapForETH);
1534 
1535         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1536 
1537         uint256 ethForOperations = ethBalance.mul(tokensForOperations).div(
1538             totalTokensToSwap
1539         );
1540         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1541 
1542         uint256 ethForLiquidity = ethBalance - ethForOperations - ethForDev;
1543 
1544         tokensForLiquidity = 0;
1545         tokensForOperations = 0;
1546         tokensForDev = 0;
1547 
1548         (success, ) = address(devWallet).call{value: ethForDev}("");
1549 
1550         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1551             addLiquidity(liquidityTokens, ethForLiquidity);
1552             emit SwapAndLiquify(
1553                 amountToSwapForETH,
1554                 ethForLiquidity,
1555                 tokensForLiquidity
1556             );
1557         }
1558 
1559         (success, ) = address(operationsWallet).call{
1560             value: address(this).balance
1561         }("");
1562     }
1563 
1564     function setAutoLPBurnSettings(
1565         uint256 _frequencyInSeconds,
1566         uint256 _percent,
1567         bool _Enabled
1568     ) external onlyOwner {
1569         require(
1570             _frequencyInSeconds >= 600,
1571             "cannot set buyback more often than every 10 minutes"
1572         );
1573         require(
1574             _percent <= 1000 && _percent >= 0,
1575             "Must set auto LP burn percent between 0% and 10%"
1576         );
1577         lpBurnFrequency = _frequencyInSeconds;
1578         percentForLPBurn = _percent;
1579         lpBurnEnabled = _Enabled;
1580     }
1581 
1582     function setTransferDelayEnabled(bool _transferDelayEnabled) external onlyOwner returns (bool) { 
1583         transferDelayEnabled = _transferDelayEnabled; 
1584         return true; 
1585     }
1586 
1587     function autoBurnLiquidityPairTokens() internal returns (bool) {
1588         lastLpBurnTime = block.timestamp;
1589 
1590         // get balance of liquidity pair
1591         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1592 
1593         // calculate amount to burn
1594         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1595             10000
1596         );
1597 
1598         // pull tokens from pancakePair liquidity and move to dead address permanently
1599         if (amountToBurn > 0) {
1600             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1601         }
1602 
1603         //sync price since this is not in a swap transaction!
1604         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1605         pair.sync();
1606         emit AutoNukeLP();
1607         return true;
1608     }
1609 
1610     function manualBurnLiquidityPairTokens(uint256 percent)
1611         external
1612         onlyOwner
1613         returns (bool)
1614     {
1615         require(
1616             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1617             "Must wait for cooldown to finish"
1618         );
1619         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1620         lastManualLpBurnTime = block.timestamp;
1621 
1622         // get balance of liquidity pair
1623         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1624 
1625         // calculate amount to burn
1626         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1627 
1628         // pull tokens from pancakePair liquidity and move to dead address permanently
1629         if (amountToBurn > 0) {
1630             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1631         }
1632 
1633         //sync price since this is not in a swap transaction!
1634         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1635         pair.sync();
1636         emit ManualNukeLP();
1637         return true;
1638     }
1639 }