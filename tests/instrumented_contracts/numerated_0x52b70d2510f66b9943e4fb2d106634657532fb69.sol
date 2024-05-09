1 /**
2 
3 The Egg
4  
5 The First 24/7 Egg Livestream 
6  
7 Powered by the Ethereum Blockchain, we aim to do what has never been done before - livestream an egg for 24 hours a day. 
8 
9 Breaking the limits of what was previously thought to be possible, The Egg will disrupt the cryptocurrency market and revolutionize modern finance.
10 
11 www.theeggstream.com
12 twitch.tv/theeggstream
13 twitter.com/theeggstream
14 t.me/theeggstream
15 https://bitcointalk.org/index.php?topic=5461429.new#new
16 
17 */
18 
19 // SPDX-License-Identifier: MIT
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
1045 contract EGG is ERC20, Ownable {
1046     using SafeMath for uint256;
1047 
1048     IUniswapV2Router02 public immutable uniswapV2Router;
1049     address public immutable uniswapV2Pair;
1050     address public constant deadAddress = address(0xdead);
1051 
1052     bool private swapping;
1053 
1054     address public marketingWallet;
1055     address public devWallet;
1056 
1057     uint256 public maxTransactionAmount;
1058     uint256 public swapTokensAtAmount;
1059     uint256 public maxWallet;
1060 
1061     uint256 public percentForLPBurn = 25; // 25 = .25%
1062     bool public lpBurnEnabled = true;
1063     uint256 public lpBurnFrequency = 3600 seconds;
1064     uint256 public lastLpBurnTime;
1065 
1066     uint256 public manualBurnFrequency = 30 minutes;
1067     uint256 public lastManualLpBurnTime;
1068 
1069     bool public limitsInEffect = true;
1070     bool public tradingActive = false;
1071     bool public swapEnabled = false;
1072 
1073     // Anti-bot and anti-whale mappings and variables
1074     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1075     bool public transferDelayEnabled = true;
1076 
1077     uint256 public buyTotalFees;
1078     uint256 public buyMarketingFee;
1079     uint256 public buyLiquidityFee;
1080     uint256 public buyDevFee;
1081 
1082     uint256 public sellTotalFees;
1083     uint256 public sellMarketingFee;
1084     uint256 public sellLiquidityFee;
1085     uint256 public sellDevFee;
1086 
1087     uint256 public tokensForMarketing;
1088     uint256 public tokensForLiquidity;
1089     uint256 public tokensForDev;
1090 
1091     /******************/
1092 
1093     // exlcude from fees and max transaction amount
1094     mapping(address => bool) private _isExcludedFromFees;
1095     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1096 
1097     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1098     // could be subject to a maximum transfer amount
1099     mapping(address => bool) public automatedMarketMakerPairs;
1100 
1101     event UpdateUniswapV2Router(
1102         address indexed newAddress,
1103         address indexed oldAddress
1104     );
1105 
1106     event ExcludeFromFees(address indexed account, bool isExcluded);
1107 
1108     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1109 
1110     event marketingWalletUpdated(
1111         address indexed newWallet,
1112         address indexed oldWallet
1113     );
1114 
1115     event devWalletUpdated(
1116         address indexed newWallet,
1117         address indexed oldWallet
1118     );
1119 
1120     event SwapAndLiquify(
1121         uint256 tokensSwapped,
1122         uint256 ethReceived,
1123         uint256 tokensIntoLiquidity
1124     );
1125 
1126     event AutoNukeLP();
1127 
1128     event ManualNukeLP();
1129 
1130     constructor() ERC20("The Egg", "EGG") {
1131         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1132             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1133         );
1134 
1135         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1136         uniswapV2Router = _uniswapV2Router;
1137 
1138         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1139             .createPair(address(this), _uniswapV2Router.WETH());
1140         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1141         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1142 
1143         uint256 _buyMarketingFee = 10;
1144         uint256 _buyLiquidityFee = 0;
1145         uint256 _buyDevFee = 0;
1146 
1147         uint256 _sellMarketingFee = 30;
1148         uint256 _sellLiquidityFee = 0;
1149         uint256 _sellDevFee = 0;
1150 
1151         uint256 totalSupply = 10_000_000_000 * 1e18;
1152 
1153         maxTransactionAmount = 200_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1154         maxWallet = 200_000_000 * 1e18; // 2% from total supply maxWallet
1155         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1156 
1157         buyMarketingFee = _buyMarketingFee;
1158         buyLiquidityFee = _buyLiquidityFee;
1159         buyDevFee = _buyDevFee;
1160         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1161 
1162         sellMarketingFee = _sellMarketingFee;
1163         sellLiquidityFee = _sellLiquidityFee;
1164         sellDevFee = _sellDevFee;
1165         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1166 
1167         marketingWallet = address(0x54b4a7Fb6DcAcF012eEa48e87Fc7d1206fA7F9aF); // set as marketing wallet
1168         devWallet = address(0x54b4a7Fb6DcAcF012eEa48e87Fc7d1206fA7F9aF); // set as dev wallet
1169 
1170         // exclude from paying fees or having max transaction amount
1171         excludeFromFees(owner(), true);
1172         excludeFromFees(address(this), true);
1173         excludeFromFees(address(0xdead), true);
1174 
1175         excludeFromMaxTransaction(owner(), true);
1176         excludeFromMaxTransaction(address(this), true);
1177         excludeFromMaxTransaction(address(0xdead), true);
1178 
1179         /*
1180             _mint is an internal function in ERC20.sol that is only called here,
1181             and CANNOT be called ever again
1182         */
1183         _mint(msg.sender, totalSupply);
1184     }
1185 
1186     receive() external payable {}
1187 
1188     // once enabled, can never be turned off
1189     function enableTrading() external onlyOwner {
1190         tradingActive = true;
1191         swapEnabled = true;
1192         lastLpBurnTime = block.timestamp;
1193     }
1194 
1195     // remove limits after token is stable
1196     function removeLimits() external onlyOwner returns (bool) {
1197         limitsInEffect = false;
1198         return true;
1199     }
1200 
1201     // disable Transfer delay - cannot be reenabled
1202     function disableTransferDelay() external onlyOwner returns (bool) {
1203         transferDelayEnabled = false;
1204         return true;
1205     }
1206 
1207     // change the minimum amount of tokens to sell from fees
1208     function updateSwapTokensAtAmount(uint256 newAmount)
1209         external
1210         onlyOwner
1211         returns (bool)
1212     {
1213         require(
1214             newAmount >= (totalSupply() * 1) / 100000,
1215             "Swap amount cannot be lower than 0.001% total supply."
1216         );
1217         require(
1218             newAmount <= (totalSupply() * 5) / 1000,
1219             "Swap amount cannot be higher than 0.5% total supply."
1220         );
1221         swapTokensAtAmount = newAmount;
1222         return true;
1223     }
1224 
1225     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1226         require(
1227             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1228             "Cannot set maxTransactionAmount lower than 0.1%"
1229         );
1230         maxTransactionAmount = newNum * (10**18);
1231     }
1232 
1233     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1234         require(
1235             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1236             "Cannot set maxWallet lower than 0.5%"
1237         );
1238         maxWallet = newNum * (10**18);
1239     }
1240 
1241     function excludeFromMaxTransaction(address updAds, bool isEx)
1242         public
1243         onlyOwner
1244     {
1245         _isExcludedMaxTransactionAmount[updAds] = isEx;
1246     }
1247 
1248     // only use to disable contract sales if absolutely necessary (emergency use only)
1249     function updateSwapEnabled(bool enabled) external onlyOwner {
1250         swapEnabled = enabled;
1251     }
1252 
1253     function updateBuyFees(
1254         uint256 _marketingFee,
1255         uint256 _liquidityFee,
1256         uint256 _devFee
1257     ) external onlyOwner {
1258         buyMarketingFee = _marketingFee;
1259         buyLiquidityFee = _liquidityFee;
1260         buyDevFee = _devFee;
1261         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1262         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
1263     }
1264 
1265     function updateSellFees(
1266         uint256 _marketingFee,
1267         uint256 _liquidityFee,
1268         uint256 _devFee
1269     ) external onlyOwner {
1270         sellMarketingFee = _marketingFee;
1271         sellLiquidityFee = _liquidityFee;
1272         sellDevFee = _devFee;
1273         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1274         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
1275     }
1276 
1277     function excludeFromFees(address account, bool excluded) public onlyOwner {
1278         _isExcludedFromFees[account] = excluded;
1279         emit ExcludeFromFees(account, excluded);
1280     }
1281 
1282     function setAutomatedMarketMakerPair(address pair, bool value)
1283         public
1284         onlyOwner
1285     {
1286         require(
1287             pair != uniswapV2Pair,
1288             "The pair cannot be removed from automatedMarketMakerPairs"
1289         );
1290 
1291         _setAutomatedMarketMakerPair(pair, value);
1292     }
1293 
1294     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1295         automatedMarketMakerPairs[pair] = value;
1296 
1297         emit SetAutomatedMarketMakerPair(pair, value);
1298     }
1299 
1300     function updateMarketingWallet(address newMarketingWallet)
1301         external
1302         onlyOwner
1303     {
1304         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1305         marketingWallet = newMarketingWallet;
1306     }
1307 
1308     function updateDevWallet(address newWallet) external onlyOwner {
1309         emit devWalletUpdated(newWallet, devWallet);
1310         devWallet = newWallet;
1311     }
1312 
1313     function isExcludedFromFees(address account) public view returns (bool) {
1314         return _isExcludedFromFees[account];
1315     }
1316 
1317     event BoughtEarly(address indexed sniper);
1318 
1319     function _transfer(
1320         address from,
1321         address to,
1322         uint256 amount
1323     ) internal override {
1324         require(from != address(0), "ERC20: transfer from the zero address");
1325         require(to != address(0), "ERC20: transfer to the zero address");
1326 
1327         if (amount == 0) {
1328             super._transfer(from, to, 0);
1329             return;
1330         }
1331 
1332         if (limitsInEffect) {
1333             if (
1334                 from != owner() &&
1335                 to != owner() &&
1336                 to != address(0) &&
1337                 to != address(0xdead) &&
1338                 !swapping
1339             ) {
1340                 if (!tradingActive) {
1341                     require(
1342                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1343                         "Trading is not active."
1344                     );
1345                 }
1346 
1347                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1348                 if (transferDelayEnabled) {
1349                     if (
1350                         to != owner() &&
1351                         to != address(uniswapV2Router) &&
1352                         to != address(uniswapV2Pair)
1353                     ) {
1354                         require(
1355                             _holderLastTransferTimestamp[tx.origin] <
1356                                 block.number,
1357                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1358                         );
1359                         _holderLastTransferTimestamp[tx.origin] = block.number;
1360                     }
1361                 }
1362 
1363                 //when buy
1364                 if (
1365                     automatedMarketMakerPairs[from] &&
1366                     !_isExcludedMaxTransactionAmount[to]
1367                 ) {
1368                     require(
1369                         amount <= maxTransactionAmount,
1370                         "Buy transfer amount exceeds the maxTransactionAmount."
1371                     );
1372                     require(
1373                         amount + balanceOf(to) <= maxWallet,
1374                         "Max wallet exceeded"
1375                     );
1376                 }
1377                 //when sell
1378                 else if (
1379                     automatedMarketMakerPairs[to] &&
1380                     !_isExcludedMaxTransactionAmount[from]
1381                 ) {
1382                     require(
1383                         amount <= maxTransactionAmount,
1384                         "Sell transfer amount exceeds the maxTransactionAmount."
1385                     );
1386                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1387                     require(
1388                         amount + balanceOf(to) <= maxWallet,
1389                         "Max wallet exceeded"
1390                     );
1391                 }
1392             }
1393         }
1394 
1395         uint256 contractTokenBalance = balanceOf(address(this));
1396 
1397         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1398 
1399         if (
1400             canSwap &&
1401             swapEnabled &&
1402             !swapping &&
1403             !automatedMarketMakerPairs[from] &&
1404             !_isExcludedFromFees[from] &&
1405             !_isExcludedFromFees[to]
1406         ) {
1407             swapping = true;
1408 
1409             swapBack();
1410 
1411             swapping = false;
1412         }
1413 
1414         if (
1415             !swapping &&
1416             automatedMarketMakerPairs[to] &&
1417             lpBurnEnabled &&
1418             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1419             !_isExcludedFromFees[from]
1420         ) {
1421             autoBurnLiquidityPairTokens();
1422         }
1423 
1424         bool takeFee = !swapping;
1425 
1426         // if any account belongs to _isExcludedFromFee account then remove the fee
1427         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1428             takeFee = false;
1429         }
1430 
1431         uint256 fees = 0;
1432         // only take fees on buys/sells, do not take on wallet transfers
1433         if (takeFee) {
1434             // on sell
1435             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1436                 fees = amount.mul(sellTotalFees).div(100);
1437                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1438                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1439                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1440             }
1441             // on buy
1442             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1443                 fees = amount.mul(buyTotalFees).div(100);
1444                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1445                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1446                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1447             }
1448 
1449             if (fees > 0) {
1450                 super._transfer(from, address(this), fees);
1451             }
1452 
1453             amount -= fees;
1454         }
1455 
1456         super._transfer(from, to, amount);
1457     }
1458 
1459     function swapTokensForEth(uint256 tokenAmount) private {
1460         // generate the uniswap pair path of token -> weth
1461         address[] memory path = new address[](2);
1462         path[0] = address(this);
1463         path[1] = uniswapV2Router.WETH();
1464 
1465         _approve(address(this), address(uniswapV2Router), tokenAmount);
1466 
1467         // make the swap
1468         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1469             tokenAmount,
1470             0, // accept any amount of ETH
1471             path,
1472             address(this),
1473             block.timestamp
1474         );
1475     }
1476 
1477     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1478         // approve token transfer to cover all possible scenarios
1479         _approve(address(this), address(uniswapV2Router), tokenAmount);
1480 
1481         // add the liquidity
1482         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1483             address(this),
1484             tokenAmount,
1485             0, // slippage is unavoidable
1486             0, // slippage is unavoidable
1487             deadAddress,
1488             block.timestamp
1489         );
1490     }
1491 
1492     function swapBack() private {
1493         uint256 contractBalance = balanceOf(address(this));
1494         uint256 totalTokensToSwap = tokensForLiquidity +
1495             tokensForMarketing +
1496             tokensForDev;
1497         bool success;
1498 
1499         if (contractBalance == 0 || totalTokensToSwap == 0) {
1500             return;
1501         }
1502 
1503         if (contractBalance > swapTokensAtAmount * 20) {
1504             contractBalance = swapTokensAtAmount * 20;
1505         }
1506 
1507         // Halve the amount of liquidity tokens
1508         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1509             totalTokensToSwap /
1510             2;
1511         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1512 
1513         uint256 initialETHBalance = address(this).balance;
1514 
1515         swapTokensForEth(amountToSwapForETH);
1516 
1517         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1518 
1519         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1520             totalTokensToSwap
1521         );
1522         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1523 
1524         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1525 
1526         tokensForLiquidity = 0;
1527         tokensForMarketing = 0;
1528         tokensForDev = 0;
1529 
1530         (success, ) = address(devWallet).call{value: ethForDev}("");
1531 
1532         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1533             addLiquidity(liquidityTokens, ethForLiquidity);
1534             emit SwapAndLiquify(
1535                 amountToSwapForETH,
1536                 ethForLiquidity,
1537                 tokensForLiquidity
1538             );
1539         }
1540 
1541         (success, ) = address(marketingWallet).call{
1542             value: address(this).balance
1543         }("");
1544     }
1545 
1546     function setAutoLPBurnSettings(
1547         uint256 _frequencyInSeconds,
1548         uint256 _percent,
1549         bool _Enabled
1550     ) external onlyOwner {
1551         require(
1552             _frequencyInSeconds >= 600,
1553             "cannot set buyback more often than every 10 minutes"
1554         );
1555         require(
1556             _percent <= 1000 && _percent >= 0,
1557             "Must set auto LP burn percent between 0% and 10%"
1558         );
1559         lpBurnFrequency = _frequencyInSeconds;
1560         percentForLPBurn = _percent;
1561         lpBurnEnabled = _Enabled;
1562     }
1563 
1564     function autoBurnLiquidityPairTokens() internal returns (bool) {
1565         lastLpBurnTime = block.timestamp;
1566 
1567         // get balance of liquidity pair
1568         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1569 
1570         // calculate amount to burn
1571         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1572             10000
1573         );
1574 
1575         // pull tokens from pancakePair liquidity and move to dead address permanently
1576         if (amountToBurn > 0) {
1577             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1578         }
1579 
1580         //sync price since this is not in a swap transaction!
1581         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1582         pair.sync();
1583         emit AutoNukeLP();
1584         return true;
1585     }
1586 
1587     function manualBurnLiquidityPairTokens(uint256 percent)
1588         external
1589         onlyOwner
1590         returns (bool)
1591     {
1592         require(
1593             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1594             "Must wait for cooldown to finish"
1595         );
1596         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1597         lastManualLpBurnTime = block.timestamp;
1598 
1599         // get balance of liquidity pair
1600         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1601 
1602         // calculate amount to burn
1603         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1604 
1605         // pull tokens from pancakePair liquidity and move to dead address permanently
1606         if (amountToBurn > 0) {
1607             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1608         }
1609 
1610         //sync price since this is not in a swap transaction!
1611         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1612         pair.sync();
1613         emit ManualNukeLP();
1614         return true;
1615     }
1616 }