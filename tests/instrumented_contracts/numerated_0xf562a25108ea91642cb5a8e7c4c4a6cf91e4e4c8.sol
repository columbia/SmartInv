1 /** 
2 Are you sick of all these stupid Japanese larps? We are too! 
3 Stop supporting these projects created by 15 year old white boys in their mamas basements 
4 posing as ryoshi and join $ZILLA, the larp destroyer!
5 
6 It’s no secret that the Japanese fear nothing more than Godzilla, known in Japan as Gojira (ゴジラ), the king of the monsters. 
7 Thus zilla token was created to bring about the final destruction of the Larp. The rampage begins now!
8 
9 100% fair launch on uniswap.
10 Total supply: 100,000,000
11 Max wallet/tx: 2,000,000
12 
13 At launch initial 5% buy & sell jeet tax to bootstrap liquidity and establish our foundation, 
14 after which taxes will be reduced to 1% auto liquidity fee, limits removed, and ownership renounced.
15 
16 No official socials, no 5th-grade level medium articles, just vibes and a based community.
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
1042 contract Zilla is ERC20, Ownable {
1043     using SafeMath for uint256;
1044 
1045     IUniswapV2Router02 public immutable uniswapV2Router;
1046     address public immutable uniswapV2Pair;
1047     address public constant deadAddress = address(0xdead);
1048 
1049     bool private swapping;
1050 
1051     address public devWallet;
1052     address public lpWallet = deadAddress;
1053 
1054     uint256 public maxTransactionAmount;
1055     uint256 public swapTokensAtAmount;
1056     uint256 public maxWallet;
1057 
1058     bool public limitsInEffect = true;
1059     bool public tradingActive = false;
1060     bool public swapEnabled = false;
1061 
1062     uint256 public buyLiquidityFee;
1063     uint256 public buyDevFee;
1064     uint256 public buyTotalFees = buyLiquidityFee + buyDevFee;
1065 
1066     uint256 public sellLiquidityFee;
1067     uint256 public sellDevFee;
1068     uint256 public sellTotalFees = sellLiquidityFee + sellDevFee;
1069 
1070 	uint256 public tokensForLiquidity;
1071     uint256 public tokensForDev;
1072 
1073     /******************/
1074 
1075     // exlcude from fees and max transaction amount
1076     mapping(address => bool) private _isExcludedFromFees;
1077     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1078 
1079     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1080     // could be subject to a maximum transfer amount
1081     mapping(address => bool) public automatedMarketMakerPairs;
1082 
1083     event UpdateUniswapV2Router(
1084         address indexed newAddress,
1085         address indexed oldAddress
1086     );
1087 
1088     event ExcludeFromFees(address indexed account, bool isExcluded);
1089 
1090     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1091 
1092     event SwapAndLiquify(
1093         uint256 tokensSwapped,
1094         uint256 ethReceived,
1095         uint256 tokensIntoLiquidity
1096     );
1097 
1098     constructor() ERC20("Larp Destroyer", "ZILLA") {
1099         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1100             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1101         );
1102 
1103         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1104         uniswapV2Router = _uniswapV2Router;
1105 
1106         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1107             .createPair(address(this), _uniswapV2Router.WETH());
1108         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1109         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1110 
1111         uint256 _buyLiquidityFee = 0;
1112         uint256 _buyDevFee = 5;
1113 
1114         uint256 _sellLiquidityFee = 1;
1115         uint256 _sellDevFee = 4;
1116 
1117         uint256 totalSupply = 1 * 1e8 * 1e18;
1118 
1119         maxTransactionAmount = 2 * 1e6 * 1e18; // 2% from total supply maxTransactionAmountTxn
1120         maxWallet = 2 * 1e6 * 1e18; // 2% from total supply maxWallet
1121         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1122 
1123         buyLiquidityFee = _buyLiquidityFee;
1124         buyDevFee = _buyDevFee;
1125         buyTotalFees = buyLiquidityFee + buyDevFee;
1126 
1127         sellLiquidityFee = _sellLiquidityFee;
1128         sellDevFee = _sellDevFee;
1129         sellTotalFees = sellLiquidityFee + sellDevFee;
1130 
1131         devWallet = address(0x36dDfB985eA2cf01E69C3548E3bb74aB209949Ed); // set as dev wallet
1132 
1133         // exclude from paying fees or having max transaction amount
1134         excludeFromFees(owner(), true);
1135         excludeFromFees(address(this), true);
1136         excludeFromFees(address(0xdead), true);
1137 
1138         excludeFromMaxTransaction(owner(), true);
1139         excludeFromMaxTransaction(address(this), true);
1140         excludeFromMaxTransaction(address(0xdead), true);
1141 
1142         /*
1143             _mint is an internal function in ERC20.sol that is only called here,
1144             and CANNOT be called ever again
1145         */
1146         _mint(msg.sender, totalSupply);
1147     }
1148 
1149     receive() external payable {}
1150 
1151     // once enabled, can never be turned off
1152     function enableTrading() external onlyOwner {
1153         tradingActive = true;
1154         swapEnabled = true;
1155     }
1156 
1157     // remove limits after token is stable
1158     function removeLimits() external onlyOwner returns (bool) {
1159         limitsInEffect = false;
1160         return true;
1161     }
1162 
1163     // update fees, cannot exceed 10%
1164     function setFees(uint256 newBuyLiquidityFee, uint256 newBuyDevFee, uint256 newSellLiquidityFee, uint256 newSellDevFee) external onlyOwner {
1165         buyLiquidityFee = newBuyLiquidityFee;
1166         buyDevFee = newBuyDevFee;
1167         sellLiquidityFee = newSellLiquidityFee;
1168         sellDevFee = newSellDevFee;
1169 
1170         require(buyLiquidityFee + buyDevFee <= 10, "fee too high");
1171         require(sellLiquidityFee + sellDevFee <= 10, "fee too high");
1172     }
1173 
1174     // change the minimum amount of tokens to sell from fees
1175     function updateSwapTokensAtAmount(uint256 newAmount)
1176         external
1177         onlyOwner
1178         returns (bool)
1179     {
1180         require(
1181             newAmount >= (totalSupply() * 1) / 100000,
1182             "Swap amount cannot be lower than 0.001% total supply."
1183         );
1184         require(
1185             newAmount <= (totalSupply() * 5) / 1000,
1186             "Swap amount cannot be higher than 0.5% total supply."
1187         );
1188         swapTokensAtAmount = newAmount;
1189         return true;
1190     }
1191 	
1192     function excludeFromMaxTransaction(address updAds, bool isEx)
1193         public
1194         onlyOwner
1195     {
1196         _isExcludedMaxTransactionAmount[updAds] = isEx;
1197     }
1198 
1199     // only use to disable contract sales if absolutely necessary (emergency use only)
1200     function updateSwapEnabled(bool enabled) external onlyOwner {
1201         swapEnabled = enabled;
1202     }
1203 
1204     function excludeFromFees(address account, bool excluded) public onlyOwner {
1205         _isExcludedFromFees[account] = excluded;
1206         emit ExcludeFromFees(account, excluded);
1207     }
1208 
1209     function setAutomatedMarketMakerPair(address pair, bool value)
1210         public
1211         onlyOwner
1212     {
1213         require(
1214             pair != uniswapV2Pair,
1215             "The pair cannot be removed from automatedMarketMakerPairs"
1216         );
1217 
1218         _setAutomatedMarketMakerPair(pair, value);
1219     }
1220 
1221     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1222         automatedMarketMakerPairs[pair] = value;
1223 
1224         emit SetAutomatedMarketMakerPair(pair, value);
1225     }
1226 
1227     function isExcludedFromFees(address account) public view returns (bool) {
1228         return _isExcludedFromFees[account];
1229     }
1230 
1231     function _transfer(
1232         address from,
1233         address to,
1234         uint256 amount
1235     ) internal override {
1236         require(from != address(0), "ERC20: transfer from the zero address");
1237         require(to != address(0), "ERC20: transfer to the zero address");
1238 
1239         if (amount == 0) {
1240             super._transfer(from, to, 0);
1241             return;
1242         }
1243 
1244         if (limitsInEffect) {
1245             if (
1246                 from != owner() &&
1247                 to != owner() &&
1248                 to != address(0) &&
1249                 to != address(0xdead) &&
1250                 !swapping
1251             ) {
1252                 if (!tradingActive) {
1253                     require(
1254                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1255                         "Trading is not active."
1256                     );
1257                 }
1258 
1259                 //when buy
1260                 if (
1261                     automatedMarketMakerPairs[from] &&
1262                     !_isExcludedMaxTransactionAmount[to]
1263                 ) {
1264                     require(
1265                         amount <= maxTransactionAmount,
1266                         "Buy transfer amount exceeds the maxTransactionAmount."
1267                     );
1268                     require(
1269                         amount + balanceOf(to) <= maxWallet,
1270                         "Max wallet exceeded"
1271                     );
1272                 }
1273                 //when sell
1274                 else if (
1275                     automatedMarketMakerPairs[to] &&
1276                     !_isExcludedMaxTransactionAmount[from]
1277                 ) {
1278                     require(
1279                         amount <= maxTransactionAmount,
1280                         "Sell transfer amount exceeds the maxTransactionAmount."
1281                     );
1282                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1283                     require(
1284                         amount + balanceOf(to) <= maxWallet,
1285                         "Max wallet exceeded"
1286                     );
1287                 }
1288             }
1289         }
1290 
1291         uint256 contractTokenBalance = balanceOf(address(this));
1292 
1293         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1294 
1295         if (
1296             canSwap &&
1297             swapEnabled &&
1298             !swapping &&
1299             !automatedMarketMakerPairs[from] &&
1300             !_isExcludedFromFees[from] &&
1301             !_isExcludedFromFees[to]
1302         ) {
1303             swapping = true;
1304 
1305             swapBack();
1306 
1307             swapping = false;
1308         }
1309 
1310         bool takeFee = !swapping;
1311 
1312         // if any account belongs to _isExcludedFromFee account then remove the fee
1313         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1314             takeFee = false;
1315         }
1316 
1317         uint256 fees = 0;
1318         // only take fees on buys/sells, do not take on wallet transfers
1319         if (takeFee) {
1320             // on sell
1321             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1322                 fees = amount.mul(sellTotalFees).div(100);
1323                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1324                 tokensForDev += (fees * sellDevFee) / sellTotalFees;                
1325             }
1326             // on buy
1327             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1328                 fees = amount.mul(buyTotalFees).div(100);
1329                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1330                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1331             }
1332 
1333             if (fees > 0) {
1334                 super._transfer(from, address(this), fees);
1335             }
1336 
1337             amount -= fees;
1338         }
1339 
1340         super._transfer(from, to, amount);
1341     }
1342 
1343     function swapTokensForEth(uint256 tokenAmount) private {
1344         // generate the uniswap pair path of token -> weth
1345         address[] memory path = new address[](2);
1346         path[0] = address(this);
1347         path[1] = uniswapV2Router.WETH();
1348 
1349         _approve(address(this), address(uniswapV2Router), tokenAmount);
1350 
1351         // make the swap
1352         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1353             tokenAmount,
1354             0, // accept any amount of ETH
1355             path,
1356             address(this),
1357             block.timestamp
1358         );
1359     }
1360 
1361     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1362         // approve token transfer to cover all possible scenarios
1363         _approve(address(this), address(uniswapV2Router), tokenAmount);
1364 
1365         // add the liquidity
1366         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1367             address(this),
1368             tokenAmount,
1369             0, // slippage is unavoidable
1370             0, // slippage is unavoidable
1371             lpWallet,
1372             block.timestamp
1373         );
1374     }
1375 
1376     function swapBack() private {
1377         uint256 contractBalance = balanceOf(address(this));
1378         uint256 totalTokensToSwap = tokensForLiquidity + tokensForDev;
1379         bool success;
1380 
1381         if (contractBalance == 0 || totalTokensToSwap == 0) {
1382             return;
1383         }
1384 
1385         if (contractBalance > swapTokensAtAmount * 20) {
1386             contractBalance = swapTokensAtAmount * 20;
1387         }
1388 
1389         // Halve the amount of liquidity tokens
1390         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1391         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1392 
1393         uint256 initialETHBalance = address(this).balance;
1394 
1395         swapTokensForEth(amountToSwapForETH);
1396 
1397         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1398 	
1399         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1400 
1401         uint256 ethForLiquidity = ethBalance - ethForDev;
1402 
1403         tokensForLiquidity = 0;
1404         tokensForDev = 0;
1405 
1406         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1407             addLiquidity(liquidityTokens, ethForLiquidity);
1408             emit SwapAndLiquify(
1409                 amountToSwapForETH,
1410                 ethForLiquidity,
1411                 tokensForLiquidity
1412             );
1413         }
1414 
1415         (success, ) = address(devWallet).call{value: address(this).balance}("");
1416     }
1417 
1418 }