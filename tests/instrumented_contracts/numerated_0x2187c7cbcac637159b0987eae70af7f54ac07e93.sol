1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 /**
6 
7 
8 Do you wish that you had jumped on board the Bitcoin revolution when it first began, but missed out? Don't worry, I'm back. 
9 
10 // https://newbtc.dev
11 // https://twitter.com/TheBitcoinNew
12 // https://t.me/TheBitcoinNew
13 
14 
15 𝓢𝓪𝓽𝓸𝓼𝓱𝓲 𝓝𝓪𝓴𝓪𝓶𝓸𝓽𝓸
16 
17 
18 
19 
20 
21 */
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
822 /* pragma solidity 0.8.10; */
823 /* pragma experimental ABIEncoderV2; */
824 
825 interface IUniswapV2Factory {
826     event PairCreated(
827         address indexed token0,
828         address indexed token1,
829         address pair,
830         uint256
831     );
832 
833     function feeTo() external view returns (address);
834 
835     function feeToSetter() external view returns (address);
836 
837     function getPair(address tokenA, address tokenB)
838         external
839         view
840         returns (address pair);
841 
842     function allPairs(uint256) external view returns (address pair);
843 
844     function allPairsLength() external view returns (uint256);
845 
846     function createPair(address tokenA, address tokenB)
847         external
848         returns (address pair);
849 
850     function setFeeTo(address) external;
851 
852     function setFeeToSetter(address) external;
853 }
854 
855 /* pragma solidity 0.8.10; */
856 /* pragma experimental ABIEncoderV2; */
857 
858 interface IUniswapV2Pair {
859     event Approval(
860         address indexed owner,
861         address indexed spender,
862         uint256 value
863     );
864     event Transfer(address indexed from, address indexed to, uint256 value);
865 
866     function name() external pure returns (string memory);
867 
868     function symbol() external pure returns (string memory);
869 
870     function decimals() external pure returns (uint8);
871 
872     function totalSupply() external view returns (uint256);
873 
874     function balanceOf(address owner) external view returns (uint256);
875 
876     function allowance(address owner, address spender)
877         external
878         view
879         returns (uint256);
880 
881     function approve(address spender, uint256 value) external returns (bool);
882 
883     function transfer(address to, uint256 value) external returns (bool);
884 
885     function transferFrom(
886         address from,
887         address to,
888         uint256 value
889     ) external returns (bool);
890 
891     function DOMAIN_SEPARATOR() external view returns (bytes32);
892 
893     function PERMIT_TYPEHASH() external pure returns (bytes32);
894 
895     function nonces(address owner) external view returns (uint256);
896 
897     function permit(
898         address owner,
899         address spender,
900         uint256 value,
901         uint256 deadline,
902         uint8 v,
903         bytes32 r,
904         bytes32 s
905     ) external;
906 
907     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
908     event Burn(
909         address indexed sender,
910         uint256 amount0,
911         uint256 amount1,
912         address indexed to
913     );
914     event Swap(
915         address indexed sender,
916         uint256 amount0In,
917         uint256 amount1In,
918         uint256 amount0Out,
919         uint256 amount1Out,
920         address indexed to
921     );
922     event Sync(uint112 reserve0, uint112 reserve1);
923 
924     function MINIMUM_LIQUIDITY() external pure returns (uint256);
925 
926     function factory() external view returns (address);
927 
928     function token0() external view returns (address);
929 
930     function token1() external view returns (address);
931 
932     function getReserves()
933         external
934         view
935         returns (
936             uint112 reserve0,
937             uint112 reserve1,
938             uint32 blockTimestampLast
939         );
940 
941     function price0CumulativeLast() external view returns (uint256);
942 
943     function price1CumulativeLast() external view returns (uint256);
944 
945     function kLast() external view returns (uint256);
946 
947     function mint(address to) external returns (uint256 liquidity);
948 
949     function burn(address to)
950         external
951         returns (uint256 amount0, uint256 amount1);
952 
953     function swap(
954         uint256 amount0Out,
955         uint256 amount1Out,
956         address to,
957         bytes calldata data
958     ) external;
959 
960     function skim(address to) external;
961 
962     function sync() external;
963 
964     function initialize(address, address) external;
965 }
966 
967 /* pragma solidity 0.8.10; */
968 /* pragma experimental ABIEncoderV2; */
969 
970 interface IUniswapV2Router02 {
971     function factory() external pure returns (address);
972 
973     function WETH() external pure returns (address);
974 
975     function addLiquidity(
976         address tokenA,
977         address tokenB,
978         uint256 amountADesired,
979         uint256 amountBDesired,
980         uint256 amountAMin,
981         uint256 amountBMin,
982         address to,
983         uint256 deadline
984     )
985         external
986         returns (
987             uint256 amountA,
988             uint256 amountB,
989             uint256 liquidity
990         );
991 
992     function addLiquidityETH(
993         address token,
994         uint256 amountTokenDesired,
995         uint256 amountTokenMin,
996         uint256 amountETHMin,
997         address to,
998         uint256 deadline
999     )
1000         external
1001         payable
1002         returns (
1003             uint256 amountToken,
1004             uint256 amountETH,
1005             uint256 liquidity
1006         );
1007 
1008     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1009         uint256 amountIn,
1010         uint256 amountOutMin,
1011         address[] calldata path,
1012         address to,
1013         uint256 deadline
1014     ) external;
1015 
1016     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1017         uint256 amountOutMin,
1018         address[] calldata path,
1019         address to,
1020         uint256 deadline
1021     ) external payable;
1022 
1023     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1024         uint256 amountIn,
1025         uint256 amountOutMin,
1026         address[] calldata path,
1027         address to,
1028         uint256 deadline
1029     ) external;
1030 }
1031 
1032 /* pragma solidity >=0.8.10; */
1033 
1034 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1035 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1036 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1037 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1038 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1039 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1040 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1041 
1042 contract NEWBTC is ERC20, Ownable {
1043     using SafeMath for uint256;
1044 
1045     IUniswapV2Router02 public immutable uniswapV2Router;
1046     address public immutable uniswapV2Pair;
1047     address public constant deadAddress = address(0xdead);
1048 
1049     bool private swapping;
1050 
1051 	address public charityWallet;
1052     address public marketingWallet;
1053     address public devWallet;
1054 
1055     uint256 public maxTransactionAmount;
1056     uint256 public swapTokensAtAmount;
1057     uint256 public maxWallet;
1058 
1059     bool public limitsInEffect = true;
1060     bool public tradingActive = true;
1061     bool public swapEnabled = true;
1062 
1063     // Anti-bot and anti-whale mappings and variables
1064     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1065     bool public transferDelayEnabled = true;
1066 
1067     uint256 public buyTotalFees;
1068 	uint256 public buyCharityFee;
1069     uint256 public buyMarketingFee;
1070     uint256 public buyLiquidityFee;
1071     uint256 public buyDevFee;
1072 
1073     uint256 public sellTotalFees;
1074 	uint256 public sellCharityFee;
1075     uint256 public sellMarketingFee;
1076     uint256 public sellLiquidityFee;
1077     uint256 public sellDevFee;
1078 
1079 	uint256 public tokensForCharity;
1080     uint256 public tokensForMarketing;
1081     uint256 public tokensForLiquidity;
1082     uint256 public tokensForDev;
1083 
1084     /******************/
1085 
1086     // exlcude from fees and max transaction amount
1087     mapping(address => bool) private _isExcludedFromFees;
1088     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1089 
1090     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1091     // could be subject to a maximum transfer amount
1092     mapping(address => bool) public automatedMarketMakerPairs;
1093 
1094     event UpdateUniswapV2Router(
1095         address indexed newAddress,
1096         address indexed oldAddress
1097     );
1098 
1099     event ExcludeFromFees(address indexed account, bool isExcluded);
1100 
1101     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1102 
1103     event SwapAndLiquify(
1104         uint256 tokensSwapped,
1105         uint256 ethReceived,
1106         uint256 tokensIntoLiquidity
1107     );
1108 
1109     constructor() ERC20("New Bitcoin", "nBTC") {
1110         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1111             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1112         );
1113 
1114         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1115         uniswapV2Router = _uniswapV2Router;
1116 
1117         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1118             .createPair(address(this), _uniswapV2Router.WETH());
1119         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1120         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1121 
1122 		uint256 _buyCharityFee = 0;
1123         uint256 _buyMarketingFee = 0;
1124         uint256 _buyLiquidityFee = 0;
1125         uint256 _buyDevFee = 15;
1126 
1127 		uint256 _sellCharityFee = 0;
1128         uint256 _sellMarketingFee = 0;
1129         uint256 _sellLiquidityFee = 0;
1130         uint256 _sellDevFee = 25;
1131 
1132         uint256 totalSupply =  21000000 * 1e18;
1133 
1134         maxTransactionAmount = 105000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1135         maxWallet = 210000 * 1e18; // 2% from total supply maxWallet
1136         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1137 
1138 		buyCharityFee = _buyCharityFee;
1139         buyMarketingFee = _buyMarketingFee;
1140         buyLiquidityFee = _buyLiquidityFee;
1141         buyDevFee = _buyDevFee;
1142         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1143 
1144 		sellCharityFee = _sellCharityFee;
1145         sellMarketingFee = _sellMarketingFee;
1146         sellLiquidityFee = _sellLiquidityFee;
1147         sellDevFee = _sellDevFee;
1148         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1149 
1150 		charityWallet = address(0x6CDF9F2F8E9EA78CF4d18e34F16676e2ecF996e1); //  Charity
1151         marketingWallet = address(0xd54e9E810d2559033b9fD2D9bc822941b81f1d01); // Marketing
1152         devWallet = address(0x6CDF9F2F8E9EA78CF4d18e34F16676e2ecF996e1); //  Dev 
1153 
1154         // exclude from paying fees or having max transaction amount
1155         excludeFromFees(owner(), true);
1156         excludeFromFees(address(this), true);
1157         excludeFromFees(address(0xdead), true);
1158 
1159         excludeFromMaxTransaction(owner(), true);
1160         excludeFromMaxTransaction(address(this), true);
1161         excludeFromMaxTransaction(address(0xdead), true);
1162 
1163         /*
1164             _mint is an internal function in ERC20.sol that is only called here,
1165             and CANNOT be called ever again
1166         */
1167         _mint(msg.sender, totalSupply);
1168     }
1169 
1170     receive() external payable {}
1171 
1172     // once enabled, can never be turned off
1173     function enableTrading() external onlyOwner {
1174         tradingActive = true;
1175         swapEnabled = true;
1176     }
1177 
1178     // remove limits after token is stable
1179     function removeLimits() external onlyOwner returns (bool) {
1180         limitsInEffect = false;
1181         return true;
1182     }
1183 
1184     // disable Transfer delay - cannot be reenabled
1185     function disableTransferDelay() external onlyOwner returns (bool) {
1186         transferDelayEnabled = false;
1187         return true;
1188     }
1189 
1190     // change the minimum amount of tokens to sell from fees
1191     function updateSwapTokensAtAmount(uint256 newAmount)
1192         external
1193         onlyOwner
1194         returns (bool)
1195     {
1196         require(
1197             newAmount >= (totalSupply() * 1) / 100000,
1198             "Swap amount cannot be lower than 0.001% total supply."
1199         );
1200         require(
1201             newAmount <= (totalSupply() * 5) / 1000,
1202             "Swap amount cannot be higher than 0.5% total supply."
1203         );
1204         swapTokensAtAmount = newAmount;
1205         return true;
1206     }
1207 
1208     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1209         require(
1210             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1211             "Cannot set maxTransactionAmount lower than 0.5%"
1212         );
1213         maxTransactionAmount = newNum * (10**18);
1214     }
1215 
1216     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1217         require(
1218             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1219             "Cannot set maxWallet lower than 0.5%"
1220         );
1221         maxWallet = newNum * (10**18);
1222     }
1223 	
1224     function excludeFromMaxTransaction(address updAds, bool isEx)
1225         public
1226         onlyOwner
1227     {
1228         _isExcludedMaxTransactionAmount[updAds] = isEx;
1229     }
1230 
1231     // only use to disable contract sales if absolutely necessary (emergency use only)
1232     function updateSwapEnabled(bool enabled) external onlyOwner {
1233         swapEnabled = enabled;
1234     }
1235 
1236     function updateBuyFees(
1237 		uint256 _charityFee,
1238         uint256 _marketingFee,
1239         uint256 _liquidityFee,
1240         uint256 _devFee
1241     ) external onlyOwner {
1242 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1243 		buyCharityFee = _charityFee;
1244         buyMarketingFee = _marketingFee;
1245         buyLiquidityFee = _liquidityFee;
1246         buyDevFee = _devFee;
1247         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1248      }
1249 
1250     function updateSellFees(
1251 		uint256 _charityFee,
1252         uint256 _marketingFee,
1253         uint256 _liquidityFee,
1254         uint256 _devFee
1255     ) external onlyOwner {
1256 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1257 		sellCharityFee = _charityFee;
1258         sellMarketingFee = _marketingFee;
1259         sellLiquidityFee = _liquidityFee;
1260         sellDevFee = _devFee;
1261         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1262     }
1263 
1264     function excludeFromFees(address account, bool excluded) public onlyOwner {
1265         _isExcludedFromFees[account] = excluded;
1266         emit ExcludeFromFees(account, excluded);
1267     }
1268 
1269     function setAutomatedMarketMakerPair(address pair, bool value)
1270         public
1271         onlyOwner
1272     {
1273         require(
1274             pair != uniswapV2Pair,
1275             "The pair cannot be removed from automatedMarketMakerPairs"
1276         );
1277 
1278         _setAutomatedMarketMakerPair(pair, value);
1279     }
1280 
1281     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1282         automatedMarketMakerPairs[pair] = value;
1283 
1284         emit SetAutomatedMarketMakerPair(pair, value);
1285     }
1286 
1287     function isExcludedFromFees(address account) public view returns (bool) {
1288         return _isExcludedFromFees[account];
1289     }
1290 
1291     function _transfer(
1292         address from,
1293         address to,
1294         uint256 amount
1295     ) internal override {
1296         require(from != address(0), "ERC20: transfer from the zero address");
1297         require(to != address(0), "ERC20: transfer to the zero address");
1298 
1299         if (amount == 0) {
1300             super._transfer(from, to, 0);
1301             return;
1302         }
1303 
1304         if (limitsInEffect) {
1305             if (
1306                 from != owner() &&
1307                 to != owner() &&
1308                 to != address(0) &&
1309                 to != address(0xdead) &&
1310                 !swapping
1311             ) {
1312                 if (!tradingActive) {
1313                     require(
1314                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1315                         "Trading is not active."
1316                     );
1317                 }
1318 
1319                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1320                 if (transferDelayEnabled) {
1321                     if (
1322                         to != owner() &&
1323                         to != address(uniswapV2Router) &&
1324                         to != address(uniswapV2Pair)
1325                     ) {
1326                         require(
1327                             _holderLastTransferTimestamp[tx.origin] <
1328                                 block.number,
1329                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1330                         );
1331                         _holderLastTransferTimestamp[tx.origin] = block.number;
1332                     }
1333                 }
1334 
1335                 //when buy
1336                 if (
1337                     automatedMarketMakerPairs[from] &&
1338                     !_isExcludedMaxTransactionAmount[to]
1339                 ) {
1340                     require(
1341                         amount <= maxTransactionAmount,
1342                         "Buy transfer amount exceeds the maxTransactionAmount."
1343                     );
1344                     require(
1345                         amount + balanceOf(to) <= maxWallet,
1346                         "Max wallet exceeded"
1347                     );
1348                 }
1349                 //when sell
1350                 else if (
1351                     automatedMarketMakerPairs[to] &&
1352                     !_isExcludedMaxTransactionAmount[from]
1353                 ) {
1354                     require(
1355                         amount <= maxTransactionAmount,
1356                         "Sell transfer amount exceeds the maxTransactionAmount."
1357                     );
1358                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1359                     require(
1360                         amount + balanceOf(to) <= maxWallet,
1361                         "Max wallet exceeded"
1362                     );
1363                 }
1364             }
1365         }
1366 
1367         uint256 contractTokenBalance = balanceOf(address(this));
1368 
1369         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1370 
1371         if (
1372             canSwap &&
1373             swapEnabled &&
1374             !swapping &&
1375             !automatedMarketMakerPairs[from] &&
1376             !_isExcludedFromFees[from] &&
1377             !_isExcludedFromFees[to]
1378         ) {
1379             swapping = true;
1380 
1381             swapBack();
1382 
1383             swapping = false;
1384         }
1385 
1386         bool takeFee = !swapping;
1387 
1388         // if any account belongs to _isExcludedFromFee account then remove the fee
1389         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1390             takeFee = false;
1391         }
1392 
1393         uint256 fees = 0;
1394         // only take fees on buys/sells, do not take on wallet transfers
1395         if (takeFee) {
1396             // on sell
1397             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1398                 fees = amount.mul(sellTotalFees).div(100);
1399 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1400                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1401                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1402                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1403             }
1404             // on buy
1405             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1406                 fees = amount.mul(buyTotalFees).div(100);
1407 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1408                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1409                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1410                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1411             }
1412 
1413             if (fees > 0) {
1414                 super._transfer(from, address(this), fees);
1415             }
1416 
1417             amount -= fees;
1418         }
1419 
1420         super._transfer(from, to, amount);
1421     }
1422 
1423     function swapTokensForEth(uint256 tokenAmount) private {
1424         // generate the uniswap pair path of token -> weth
1425         address[] memory path = new address[](2);
1426         path[0] = address(this);
1427         path[1] = uniswapV2Router.WETH();
1428 
1429         _approve(address(this), address(uniswapV2Router), tokenAmount);
1430 
1431         // make the swap
1432         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1433             tokenAmount,
1434             0, // accept any amount of ETH
1435             path,
1436             address(this),
1437             block.timestamp
1438         );
1439     }
1440 
1441     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1442         // approve token transfer to cover all possible scenarios
1443         _approve(address(this), address(uniswapV2Router), tokenAmount);
1444 
1445         // add the liquidity
1446         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1447             address(this),
1448             tokenAmount,
1449             0, // slippage is unavoidable
1450             0, // slippage is unavoidable
1451             devWallet,
1452             block.timestamp
1453         );
1454     }
1455 
1456     function swapBack() private {
1457         uint256 contractBalance = balanceOf(address(this));
1458         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1459         bool success;
1460 
1461         if (contractBalance == 0 || totalTokensToSwap == 0) {
1462             return;
1463         }
1464 
1465         if (contractBalance > swapTokensAtAmount * 20) {
1466             contractBalance = swapTokensAtAmount * 20;
1467         }
1468 
1469         // Halve the amount of liquidity tokens
1470         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1471         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1472 
1473         uint256 initialETHBalance = address(this).balance;
1474 
1475         swapTokensForEth(amountToSwapForETH);
1476 
1477         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1478 
1479 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1480         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1481         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1482 
1483         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1484 
1485         tokensForLiquidity = 0;
1486 		tokensForCharity = 0;
1487         tokensForMarketing = 0;
1488         tokensForDev = 0;
1489 
1490         (success, ) = address(devWallet).call{value: ethForDev}("");
1491         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1492 
1493 
1494         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1495             addLiquidity(liquidityTokens, ethForLiquidity);
1496             emit SwapAndLiquify(
1497                 amountToSwapForETH,
1498                 ethForLiquidity,
1499                 tokensForLiquidity
1500             );
1501         }
1502 
1503         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1504     }
1505 
1506 }