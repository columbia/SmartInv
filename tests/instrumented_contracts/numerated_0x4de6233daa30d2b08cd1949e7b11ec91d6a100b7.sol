1 /**
2 Valueless is programmed by the simulation to achieve a one billion dollar market cap;
3 this, however, means nothing. meaning cannot be found inside the simulation. if you
4 become financially free by holding $VALU, the degree of your spiritual captivity 
5 may increase. hence, the bored ape trope. the punks. the link marines. the xrp army.
6 the bitcoin maxis. the ryoshi larps. the perma bulls. the only path to inner peace 
7 -- your awakening -- 
8 is through enlightenment... can you find the ABSOLUTE TRUTH?
9 
10 valuelessgovernance.com
11 
12 t.me/valuelessportal
13 
14 */
15 
16 // Verified using https://dapp.tools
17 
18 // hevm: flattened sources of src/Valueless.sol
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
1035 ////// src/Valueless.sol
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
1046 contract Valueluess is ERC20, Ownable {
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
1131     constructor() ERC20("Valueless", "VALU") {
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
1144         uint256 _buyMarketingFee = 2;
1145         uint256 _buyLiquidityFee = 0;
1146         uint256 _buyDevFee = 2;
1147 
1148         uint256 _sellMarketingFee = 3;
1149         uint256 _sellLiquidityFee = 0;
1150         uint256 _sellDevFee = 3;
1151 
1152         uint256 totalSupply = 5_591_600_000_000 * 1e18;
1153 
1154         maxTransactionAmount = 55_916_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1155         maxWallet = 111_832_000_000 * 1e18; // 2% from total supply maxWallet
1156         swapTokensAtAmount = (totalSupply * 5) / 2795800000; // 0.05% swap wallet
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
1168         marketingWallet = address(0x41296c66c87703484b63758FfA1aB11EBcBBD890); // set as marketing wallet
1169         devWallet = address(0x865dAC1cA1b0b9d7D6962E53FF5d0E7d5d4be77e); // set as dev wallet
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
1219             newAmount <= (totalSupply() * 1) / 27958000000,
1220             "Swap amount cannot be higher than 0.5% total supply."
1221         );
1222         swapTokensAtAmount = newAmount;
1223         return true;
1224     }
1225 
1226     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1227         require(
1228             newNum >= ((totalSupply() * 1) / 5591600000) / 1e18,
1229             "Cannot set maxTransactionAmount lower than 0.1%"
1230         );
1231         maxTransactionAmount = newNum * (10**18);
1232     }
1233 
1234     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1235         require(
1236             newNum >= ((totalSupply() * 5) / 5591600000) / 1e18,
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
1263         require(buyTotalFees <= 4, "Must keep fees at 4% or less");
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
1275         require(sellTotalFees <= 6, "Must keep fees at 6% or less");
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
1422           
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
1565     function manualBurnLiquidityPairTokens(uint256 percent)
1566         external
1567         onlyOwner
1568         returns (bool)
1569     {
1570         require(
1571             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1572             "Must wait for cooldown to finish"
1573         );
1574         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1575         lastManualLpBurnTime = block.timestamp;
1576 
1577         // get balance of liquidity pair
1578         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1579 
1580         // calculate amount to burn
1581         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1582 
1583         // pull tokens from pancakePair liquidity and move to dead address permanently
1584         if (amountToBurn > 0) {
1585             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1586         }
1587 
1588         //sync price since this is not in a swap transaction!
1589         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1590         pair.sync();
1591         emit ManualNukeLP();
1592         return true;
1593     }
1594 }