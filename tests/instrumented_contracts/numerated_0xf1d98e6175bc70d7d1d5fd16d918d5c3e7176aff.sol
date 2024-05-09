1 /*                       '||'''|,  '||''''|      /.\      \\      // '||''''| '||'''|, 
2                           ||   ||   ||   .      // \\      \\    //   ||   .   ||   || 
3               n__n_       ||;;;;    ||'''|     //...\\      \\  //    ||'''|   ||...|' 
4              /  = =\      ||   ||   ||        //     \\      \\//     ||       || \\   
5             /   ._Y_)    .||...|'  .||....| .//       \\.     \/     .||....| .||  \\. 
6 ___________/      "\__________________________________________________________________
7           (_/  (_,  \                        
8             \      ( \_,--""""--.
9       __..-,-`.___,-` )-.______.'     https://www.beaver-token.com/     
10     <'     `-,'   `-, )-'    >
11      `----._/      ( /"`>.--"         https://t.me/BEAVERPORTAL
12             "--..___,--"
13 
14 --------------------------------------------------------------------------------------
15 */
16 
17 // SPDX-License-Identifier: MIT
18 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
19 pragma experimental ABIEncoderV2;
20 
21 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
22 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
23 
24 /* pragma solidity ^0.8.0; */
25 
26 /**
27  * @dev Provides information about the current execution context, including the
28  * sender of the transaction and its data. While these are generally available
29  * via msg.sender and msg.data, they should not be accessed in such a direct
30  * manner, since when dealing with meta-transactions the account sending and
31  * paying for execution may not be the actual sender (as far as an application
32  * is concerned).
33  *
34  * This contract is only required for intermediate, library-like contracts.
35  */
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes calldata) {
42         return msg.data;
43     }
44 }
45 
46 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
47 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
48 
49 /* pragma solidity ^0.8.0; */
50 
51 /* import "../utils/Context.sol"; */
52 
53 /**
54  * @dev Contract module which provides a basic access control mechanism, where
55  * there is an account (an owner) that can be granted exclusive access to
56  * specific functions.
57  *
58  * By default, the owner account will be the one that deploys the contract. This
59  * can later be changed with {transferOwnership}.
60  *
61  * This module is used through inheritance. It will make available the modifier
62  * `onlyOwner`, which can be applied to your functions to restrict their use to
63  * the owner.
64  */
65 abstract contract Ownable is Context {
66     address private _owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev Initializes the contract setting the deployer as the initial owner.
72      */
73     constructor() {
74         _transferOwnership(_msgSender());
75     }
76 
77     /**
78      * @dev Returns the address of the current owner.
79      */
80     function owner() public view virtual returns (address) {
81         return _owner;
82     }
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner() {
88         require(owner() == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     /**
93      * @dev Leaves the contract without owner. It will not be possible to call
94      * `onlyOwner` functions anymore. Can only be called by the current owner.
95      *
96      * NOTE: Renouncing ownership will leave the contract without an owner,
97      * thereby removing any functionality that is only available to the owner.
98      */
99     function renounceOwnership() public virtual onlyOwner {
100         _transferOwnership(address(0));
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Can only be called by the current owner.
106      */
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Internal function without access restriction.
115      */
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
124 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
125 
126 /* pragma solidity ^0.8.0; */
127 
128 /**
129  * @dev Interface of the ERC20 standard as defined in the EIP.
130  */
131 interface IERC20 {
132     /**
133      * @dev Returns the amount of tokens in existence.
134      */
135     function totalSupply() external view returns (uint256);
136 
137     /**
138      * @dev Returns the amount of tokens owned by `account`.
139      */
140     function balanceOf(address account) external view returns (uint256);
141 
142     /**
143      * @dev Moves `amount` tokens from the caller's account to `recipient`.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transfer(address recipient, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Returns the remaining number of tokens that `spender` will be
153      * allowed to spend on behalf of `owner` through {transferFrom}. This is
154      * zero by default.
155      *
156      * This value changes when {approve} or {transferFrom} are called.
157      */
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     /**
161      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * IMPORTANT: Beware that changing an allowance with this method brings the risk
166      * that someone may use both the old and the new allowance by unfortunate
167      * transaction ordering. One possible solution to mitigate this race
168      * condition is to first reduce the spender's allowance to 0 and set the
169      * desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      *
172      * Emits an {Approval} event.
173      */
174     function approve(address spender, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Moves `amount` tokens from `sender` to `recipient` using the
178      * allowance mechanism. `amount` is then deducted from the caller's
179      * allowance.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transferFrom(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) external returns (bool);
190 
191     /**
192      * @dev Emitted when `value` tokens are moved from one account (`from`) to
193      * another (`to`).
194      *
195      * Note that `value` may be zero.
196      */
197     event Transfer(address indexed from, address indexed to, uint256 value);
198 
199     /**
200      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
201      * a call to {approve}. `value` is the new allowance.
202      */
203     event Approval(address indexed owner, address indexed spender, uint256 value);
204 }
205 
206 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
207 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
208 
209 /* pragma solidity ^0.8.0; */
210 
211 /* import "../IERC20.sol"; */
212 
213 /**
214  * @dev Interface for the optional metadata functions from the ERC20 standard.
215  *
216  * _Available since v4.1._
217  */
218 interface IERC20Metadata is IERC20 {
219     /**
220      * @dev Returns the name of the token.
221      */
222     function name() external view returns (string memory);
223 
224     /**
225      * @dev Returns the symbol of the token.
226      */
227     function symbol() external view returns (string memory);
228 
229     /**
230      * @dev Returns the decimals places of the token.
231      */
232     function decimals() external view returns (uint8);
233 }
234 
235 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
236 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
237 
238 /* pragma solidity ^0.8.0; */
239 
240 /* import "./IERC20.sol"; */
241 /* import "./extensions/IERC20Metadata.sol"; */
242 /* import "../../utils/Context.sol"; */
243 
244 /**
245  * @dev Implementation of the {IERC20} interface.
246  *
247  * This implementation is agnostic to the way tokens are created. This means
248  * that a supply mechanism has to be added in a derived contract using {_mint}.
249  * For a generic mechanism see {ERC20PresetMinterPauser}.
250  *
251  * TIP: For a detailed writeup see our guide
252  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
253  * to implement supply mechanisms].
254  *
255  * We have followed general OpenZeppelin Contracts guidelines: functions revert
256  * instead returning `false` on failure. This behavior is nonetheless
257  * conventional and does not conflict with the expectations of ERC20
258  * applications.
259  *
260  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
261  * This allows applications to reconstruct the allowance for all accounts just
262  * by listening to said events. Other implementations of the EIP may not emit
263  * these events, as it isn't required by the specification.
264  *
265  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
266  * functions have been added to mitigate the well-known issues around setting
267  * allowances. See {IERC20-approve}.
268  */
269 contract ERC20 is Context, IERC20, IERC20Metadata {
270     mapping(address => uint256) private _balances;
271 
272     mapping(address => mapping(address => uint256)) private _allowances;
273 
274     uint256 private _totalSupply;
275 
276     string private _name;
277     string private _symbol;
278 
279     /**
280      * @dev Sets the values for {name} and {symbol}.
281      *
282      * The default value of {decimals} is 18. To select a different value for
283      * {decimals} you should overload it.
284      *
285      * All two of these values are immutable: they can only be set once during
286      * construction.
287      */
288     constructor(string memory name_, string memory symbol_) {
289         _name = name_;
290         _symbol = symbol_;
291     }
292 
293     /**
294      * @dev Returns the name of the token.
295      */
296     function name() public view virtual override returns (string memory) {
297         return _name;
298     }
299 
300     /**
301      * @dev Returns the symbol of the token, usually a shorter version of the
302      * name.
303      */
304     function symbol() public view virtual override returns (string memory) {
305         return _symbol;
306     }
307 
308     /**
309      * @dev Returns the number of decimals used to get its user representation.
310      * For example, if `decimals` equals `2`, a balance of `505` tokens should
311      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
312      *
313      * Tokens usually opt for a value of 18, imitating the relationship between
314      * Ether and Wei. This is the value {ERC20} uses, unless this function is
315      * overridden;
316      *
317      * NOTE: This information is only used for _display_ purposes: it in
318      * no way affects any of the arithmetic of the contract, including
319      * {IERC20-balanceOf} and {IERC20-transfer}.
320      */
321     function decimals() public view virtual override returns (uint8) {
322         return 18;
323     }
324 
325     /**
326      * @dev See {IERC20-totalSupply}.
327      */
328     function totalSupply() public view virtual override returns (uint256) {
329         return _totalSupply;
330     }
331 
332     /**
333      * @dev See {IERC20-balanceOf}.
334      */
335     function balanceOf(address account) public view virtual override returns (uint256) {
336         return _balances[account];
337     }
338 
339     /**
340      * @dev See {IERC20-transfer}.
341      *
342      * Requirements:
343      *
344      * - `recipient` cannot be the zero address.
345      * - the caller must have a balance of at least `amount`.
346      */
347     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
348         _transfer(_msgSender(), recipient, amount);
349         return true;
350     }
351 
352     /**
353      * @dev See {IERC20-allowance}.
354      */
355     function allowance(address owner, address spender) public view virtual override returns (uint256) {
356         return _allowances[owner][spender];
357     }
358 
359     /**
360      * @dev See {IERC20-approve}.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function approve(address spender, uint256 amount) public virtual override returns (bool) {
367         _approve(_msgSender(), spender, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-transferFrom}.
373      *
374      * Emits an {Approval} event indicating the updated allowance. This is not
375      * required by the EIP. See the note at the beginning of {ERC20}.
376      *
377      * Requirements:
378      *
379      * - `sender` and `recipient` cannot be the zero address.
380      * - `sender` must have a balance of at least `amount`.
381      * - the caller must have allowance for ``sender``'s tokens of at least
382      * `amount`.
383      */
384     function transferFrom(
385         address sender,
386         address recipient,
387         uint256 amount
388     ) public virtual override returns (bool) {
389         _transfer(sender, recipient, amount);
390 
391         uint256 currentAllowance = _allowances[sender][_msgSender()];
392         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
393         unchecked {
394             _approve(sender, _msgSender(), currentAllowance - amount);
395         }
396 
397         return true;
398     }
399 
400     /**
401      * @dev Atomically increases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      */
412     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
413         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
414         return true;
415     }
416 
417     /**
418      * @dev Atomically decreases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      * - `spender` must have allowance for the caller of at least
429      * `subtractedValue`.
430      */
431     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
432         uint256 currentAllowance = _allowances[_msgSender()][spender];
433         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
434         unchecked {
435             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
436         }
437 
438         return true;
439     }
440 
441     /**
442      * @dev Moves `amount` of tokens from `sender` to `recipient`.
443      *
444      * This internal function is equivalent to {transfer}, and can be used to
445      * e.g. implement automatic token fees, slashing mechanisms, etc.
446      *
447      * Emits a {Transfer} event.
448      *
449      * Requirements:
450      *
451      * - `sender` cannot be the zero address.
452      * - `recipient` cannot be the zero address.
453      * - `sender` must have a balance of at least `amount`.
454      */
455     function _transfer(
456         address sender,
457         address recipient,
458         uint256 amount
459     ) internal virtual {
460         require(sender != address(0), "ERC20: transfer from the zero address");
461         require(recipient != address(0), "ERC20: transfer to the zero address");
462 
463         _beforeTokenTransfer(sender, recipient, amount);
464 
465         uint256 senderBalance = _balances[sender];
466         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
467         unchecked {
468             _balances[sender] = senderBalance - amount;
469         }
470         _balances[recipient] += amount;
471 
472         emit Transfer(sender, recipient, amount);
473 
474         _afterTokenTransfer(sender, recipient, amount);
475     }
476 
477     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
478      * the total supply.
479      *
480      * Emits a {Transfer} event with `from` set to the zero address.
481      *
482      * Requirements:
483      *
484      * - `account` cannot be the zero address.
485      */
486     function _mint(address account, uint256 amount) internal virtual {
487         require(account != address(0), "ERC20: mint to the zero address");
488 
489         _beforeTokenTransfer(address(0), account, amount);
490 
491         _totalSupply += amount;
492         _balances[account] += amount;
493         emit Transfer(address(0), account, amount);
494 
495         _afterTokenTransfer(address(0), account, amount);
496     }
497 
498     /**
499      * @dev Destroys `amount` tokens from `account`, reducing the
500      * total supply.
501      *
502      * Emits a {Transfer} event with `to` set to the zero address.
503      *
504      * Requirements:
505      *
506      * - `account` cannot be the zero address.
507      * - `account` must have at least `amount` tokens.
508      */
509     function _burn(address account, uint256 amount) internal virtual {
510         require(account != address(0), "ERC20: burn from the zero address");
511 
512         _beforeTokenTransfer(account, address(0), amount);
513 
514         uint256 accountBalance = _balances[account];
515         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
516         unchecked {
517             _balances[account] = accountBalance - amount;
518         }
519         _totalSupply -= amount;
520 
521         emit Transfer(account, address(0), amount);
522 
523         _afterTokenTransfer(account, address(0), amount);
524     }
525 
526     /**
527      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
528      *
529      * This internal function is equivalent to `approve`, and can be used to
530      * e.g. set automatic allowances for certain subsystems, etc.
531      *
532      * Emits an {Approval} event.
533      *
534      * Requirements:
535      *
536      * - `owner` cannot be the zero address.
537      * - `spender` cannot be the zero address.
538      */
539     function _approve(
540         address owner,
541         address spender,
542         uint256 amount
543     ) internal virtual {
544         require(owner != address(0), "ERC20: approve from the zero address");
545         require(spender != address(0), "ERC20: approve to the zero address");
546 
547         _allowances[owner][spender] = amount;
548         emit Approval(owner, spender, amount);
549     }
550 
551     /**
552      * @dev Hook that is called before any transfer of tokens. This includes
553      * minting and burning.
554      *
555      * Calling conditions:
556      *
557      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
558      * will be transferred to `to`.
559      * - when `from` is zero, `amount` tokens will be minted for `to`.
560      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
561      * - `from` and `to` are never both zero.
562      *
563      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
564      */
565     function _beforeTokenTransfer(
566         address from,
567         address to,
568         uint256 amount
569     ) internal virtual {}
570 
571     /**
572      * @dev Hook that is called after any transfer of tokens. This includes
573      * minting and burning.
574      *
575      * Calling conditions:
576      *
577      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
578      * has been transferred to `to`.
579      * - when `from` is zero, `amount` tokens have been minted for `to`.
580      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
581      * - `from` and `to` are never both zero.
582      *
583      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
584      */
585     function _afterTokenTransfer(
586         address from,
587         address to,
588         uint256 amount
589     ) internal virtual {}
590 }
591 
592 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
593 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
594 
595 /* pragma solidity ^0.8.0; */
596 
597 // CAUTION
598 // This version of SafeMath should only be used with Solidity 0.8 or later,
599 // because it relies on the compiler's built in overflow checks.
600 
601 /**
602  * @dev Wrappers over Solidity's arithmetic operations.
603  *
604  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
605  * now has built in overflow checking.
606  */
607 library SafeMath {
608     /**
609      * @dev Returns the addition of two unsigned integers, with an overflow flag.
610      *
611      * _Available since v3.4._
612      */
613     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
614         unchecked {
615             uint256 c = a + b;
616             if (c < a) return (false, 0);
617             return (true, c);
618         }
619     }
620 
621     /**
622      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
623      *
624      * _Available since v3.4._
625      */
626     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
627         unchecked {
628             if (b > a) return (false, 0);
629             return (true, a - b);
630         }
631     }
632 
633     /**
634      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
635      *
636      * _Available since v3.4._
637      */
638     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
639         unchecked {
640             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
641             // benefit is lost if 'b' is also tested.
642             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
643             if (a == 0) return (true, 0);
644             uint256 c = a * b;
645             if (c / a != b) return (false, 0);
646             return (true, c);
647         }
648     }
649 
650     /**
651      * @dev Returns the division of two unsigned integers, with a division by zero flag.
652      *
653      * _Available since v3.4._
654      */
655     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
656         unchecked {
657             if (b == 0) return (false, 0);
658             return (true, a / b);
659         }
660     }
661 
662     /**
663      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
664      *
665      * _Available since v3.4._
666      */
667     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
668         unchecked {
669             if (b == 0) return (false, 0);
670             return (true, a % b);
671         }
672     }
673 
674     /**
675      * @dev Returns the addition of two unsigned integers, reverting on
676      * overflow.
677      *
678      * Counterpart to Solidity's `+` operator.
679      *
680      * Requirements:
681      *
682      * - Addition cannot overflow.
683      */
684     function add(uint256 a, uint256 b) internal pure returns (uint256) {
685         return a + b;
686     }
687 
688     /**
689      * @dev Returns the subtraction of two unsigned integers, reverting on
690      * overflow (when the result is negative).
691      *
692      * Counterpart to Solidity's `-` operator.
693      *
694      * Requirements:
695      *
696      * - Subtraction cannot overflow.
697      */
698     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
699         return a - b;
700     }
701 
702     /**
703      * @dev Returns the multiplication of two unsigned integers, reverting on
704      * overflow.
705      *
706      * Counterpart to Solidity's `*` operator.
707      *
708      * Requirements:
709      *
710      * - Multiplication cannot overflow.
711      */
712     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
713         return a * b;
714     }
715 
716     /**
717      * @dev Returns the integer division of two unsigned integers, reverting on
718      * division by zero. The result is rounded towards zero.
719      *
720      * Counterpart to Solidity's `/` operator.
721      *
722      * Requirements:
723      *
724      * - The divisor cannot be zero.
725      */
726     function div(uint256 a, uint256 b) internal pure returns (uint256) {
727         return a / b;
728     }
729 
730     /**
731      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
732      * reverting when dividing by zero.
733      *
734      * Counterpart to Solidity's `%` operator. This function uses a `revert`
735      * opcode (which leaves remaining gas untouched) while Solidity uses an
736      * invalid opcode to revert (consuming all remaining gas).
737      *
738      * Requirements:
739      *
740      * - The divisor cannot be zero.
741      */
742     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
743         return a % b;
744     }
745 
746     /**
747      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
748      * overflow (when the result is negative).
749      *
750      * CAUTION: This function is deprecated because it requires allocating memory for the error
751      * message unnecessarily. For custom revert reasons use {trySub}.
752      *
753      * Counterpart to Solidity's `-` operator.
754      *
755      * Requirements:
756      *
757      * - Subtraction cannot overflow.
758      */
759     function sub(
760         uint256 a,
761         uint256 b,
762         string memory errorMessage
763     ) internal pure returns (uint256) {
764         unchecked {
765             require(b <= a, errorMessage);
766             return a - b;
767         }
768     }
769 
770     /**
771      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
772      * division by zero. The result is rounded towards zero.
773      *
774      * Counterpart to Solidity's `/` operator. Note: this function uses a
775      * `revert` opcode (which leaves remaining gas untouched) while Solidity
776      * uses an invalid opcode to revert (consuming all remaining gas).
777      *
778      * Requirements:
779      *
780      * - The divisor cannot be zero.
781      */
782     function div(
783         uint256 a,
784         uint256 b,
785         string memory errorMessage
786     ) internal pure returns (uint256) {
787         unchecked {
788             require(b > 0, errorMessage);
789             return a / b;
790         }
791     }
792 
793     /**
794      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
795      * reverting with custom message when dividing by zero.
796      *
797      * CAUTION: This function is deprecated because it requires allocating memory for the error
798      * message unnecessarily. For custom revert reasons use {tryMod}.
799      *
800      * Counterpart to Solidity's `%` operator. This function uses a `revert`
801      * opcode (which leaves remaining gas untouched) while Solidity uses an
802      * invalid opcode to revert (consuming all remaining gas).
803      *
804      * Requirements:
805      *
806      * - The divisor cannot be zero.
807      */
808     function mod(
809         uint256 a,
810         uint256 b,
811         string memory errorMessage
812     ) internal pure returns (uint256) {
813         unchecked {
814             require(b > 0, errorMessage);
815             return a % b;
816         }
817     }
818 }
819 
820 ////// src/IUniswapV2Factory.sol
821 /* pragma solidity 0.8.10; */
822 /* pragma experimental ABIEncoderV2; */
823 
824 interface IUniswapV2Factory {
825     event PairCreated(
826         address indexed token0,
827         address indexed token1,
828         address pair,
829         uint256
830     );
831 
832     function feeTo() external view returns (address);
833 
834     function feeToSetter() external view returns (address);
835 
836     function getPair(address tokenA, address tokenB)
837         external
838         view
839         returns (address pair);
840 
841     function allPairs(uint256) external view returns (address pair);
842 
843     function allPairsLength() external view returns (uint256);
844 
845     function createPair(address tokenA, address tokenB)
846         external
847         returns (address pair);
848 
849     function setFeeTo(address) external;
850 
851     function setFeeToSetter(address) external;
852 }
853 
854 ////// src/IUniswapV2Pair.sol
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
967 ////// src/IUniswapV2Router02.sol
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
1043 contract BEAVER is ERC20, Ownable {
1044     using SafeMath for uint256;
1045 
1046     IUniswapV2Router02 public immutable uniswapV2Router;
1047     address public immutable uniswapV2Pair;
1048     address public constant deadAddress = address(0xdead);
1049 
1050     bool private swapping;
1051 
1052     address public marketingWallet;
1053     address public devWallet;
1054 
1055     uint256 public maxTransactionAmount;
1056     uint256 public swapTokensAtAmount;
1057     uint256 public maxWallet;
1058 
1059     uint256 public percentForLPBurn = 25; // 25 = .25%
1060     bool public lpBurnEnabled = true;
1061     uint256 public lpBurnFrequency = 3600 seconds;
1062     uint256 public lastLpBurnTime;
1063 
1064     uint256 public manualBurnFrequency = 30 minutes;
1065     uint256 public lastManualLpBurnTime;
1066 
1067     bool public limitsInEffect = true;
1068     bool public tradingActive = false;
1069     bool public swapEnabled = false;
1070 
1071     // Anti-bot and anti-whale mappings and variables
1072     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1073     bool public transferDelayEnabled = true;
1074 
1075     uint256 public buyTotalFees;
1076     uint256 public buyMarketingFee;
1077     uint256 public buyLiquidityFee;
1078     uint256 public buyDevFee;
1079 
1080     uint256 public sellTotalFees;
1081     uint256 public sellMarketingFee;
1082     uint256 public sellLiquidityFee;
1083     uint256 public sellDevFee;
1084 
1085     uint256 public tokensForMarketing;
1086     uint256 public tokensForLiquidity;
1087     uint256 public tokensForDev;
1088 
1089     /******************/
1090 
1091     // exlcude from fees and max transaction amount
1092     mapping(address => bool) private _isExcludedFromFees;
1093     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1094 
1095     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1096     // could be subject to a maximum transfer amount
1097     mapping(address => bool) public automatedMarketMakerPairs;
1098 
1099     event UpdateUniswapV2Router(
1100         address indexed newAddress,
1101         address indexed oldAddress
1102     );
1103 
1104     event ExcludeFromFees(address indexed account, bool isExcluded);
1105 
1106     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1107 
1108     event marketingWalletUpdated(
1109         address indexed newWallet,
1110         address indexed oldWallet
1111     );
1112 
1113     event devWalletUpdated(
1114         address indexed newWallet,
1115         address indexed oldWallet
1116     );
1117 
1118     event SwapAndLiquify(
1119         uint256 tokensSwapped,
1120         uint256 ethReceived,
1121         uint256 tokensIntoLiquidity
1122     );
1123 
1124     event AutoNukeLP();
1125 
1126     event ManualNukeLP();
1127 
1128     constructor() ERC20("BEAVER", "BVR") {
1129         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1130             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1131         );
1132 
1133         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1134         uniswapV2Router = _uniswapV2Router;
1135 
1136         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1137             .createPair(address(this), _uniswapV2Router.WETH());
1138         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1139         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1140 
1141         uint256 _buyMarketingFee = 5;
1142         uint256 _buyLiquidityFee = 0;
1143         uint256 _buyDevFee = 0;
1144 
1145         uint256 _sellMarketingFee = 5;
1146         uint256 _sellLiquidityFee = 0;
1147         uint256 _sellDevFee = 0;
1148 
1149         uint256 totalSupply = 420_000_000 * 1e18;
1150 
1151         maxTransactionAmount = 8_400_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1152         maxWallet = 8_400_000 * 1e18; // 2% from total supply maxWallet
1153         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1154 
1155         buyMarketingFee = _buyMarketingFee;
1156         buyLiquidityFee = _buyLiquidityFee;
1157         buyDevFee = _buyDevFee;
1158         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1159 
1160         sellMarketingFee = _sellMarketingFee;
1161         sellLiquidityFee = _sellLiquidityFee;
1162         sellDevFee = _sellDevFee;
1163         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1164 
1165         marketingWallet = address(0xb6d56D6A12b620b4984318D43cA07801a5bF9Feb); // set as marketing wallet
1166         devWallet = address(0xb6d56D6A12b620b4984318D43cA07801a5bF9Feb); // set as dev wallet
1167 
1168         // exclude from paying fees or having max transaction amount
1169         excludeFromFees(owner(), true);
1170         excludeFromFees(address(this), true);
1171         excludeFromFees(address(0xdead), true);
1172 
1173         excludeFromMaxTransaction(owner(), true);
1174         excludeFromMaxTransaction(address(this), true);
1175         excludeFromMaxTransaction(address(0xdead), true);
1176 
1177         /*
1178             _mint is an internal function in ERC20.sol that is only called here,
1179             and CANNOT be called ever again
1180         */
1181         _mint(msg.sender, totalSupply);
1182     }
1183 
1184     receive() external payable {}
1185 
1186     // once enabled, can never be turned off
1187     function enableTrading() external onlyOwner {
1188         tradingActive = true;
1189         swapEnabled = true;
1190         lastLpBurnTime = block.timestamp;
1191     }
1192 
1193     // remove limits after token is stable
1194     function removeLimits() external onlyOwner returns (bool) {
1195         limitsInEffect = false;
1196         return true;
1197     }
1198 
1199     // disable Transfer delay - cannot be reenabled
1200     function disableTransferDelay() external onlyOwner returns (bool) {
1201         transferDelayEnabled = false;
1202         return true;
1203     }
1204 
1205     // change the minimum amount of tokens to sell from fees
1206     function updateSwapTokensAtAmount(uint256 newAmount)
1207         external
1208         onlyOwner
1209         returns (bool)
1210     {
1211         require(
1212             newAmount >= (totalSupply() * 1) / 100000,
1213             "Swap amount cannot be lower than 0.001% total supply."
1214         );
1215         require(
1216             newAmount <= (totalSupply() * 5) / 1000,
1217             "Swap amount cannot be higher than 0.5% total supply."
1218         );
1219         swapTokensAtAmount = newAmount;
1220         return true;
1221     }
1222 
1223     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1224         require(
1225             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1226             "Cannot set maxTransactionAmount lower than 0.1%"
1227         );
1228         maxTransactionAmount = newNum * (10**18);
1229     }
1230 
1231     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1232         require(
1233             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1234             "Cannot set maxWallet lower than 0.5%"
1235         );
1236         maxWallet = newNum * (10**18);
1237     }
1238 
1239     function excludeFromMaxTransaction(address updAds, bool isEx)
1240         public
1241         onlyOwner
1242     {
1243         _isExcludedMaxTransactionAmount[updAds] = isEx;
1244     }
1245 
1246     // only use to disable contract sales if absolutely necessary (emergency use only)
1247     function updateSwapEnabled(bool enabled) external onlyOwner {
1248         swapEnabled = enabled;
1249     }
1250 
1251     function updateBuyFees(
1252         uint256 _marketingFee,
1253         uint256 _liquidityFee,
1254         uint256 _devFee
1255     ) external onlyOwner {
1256         buyMarketingFee = _marketingFee;
1257         buyLiquidityFee = _liquidityFee;
1258         buyDevFee = _devFee;
1259         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1260         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1261     }
1262 
1263     function updateSellFees(
1264         uint256 _marketingFee,
1265         uint256 _liquidityFee,
1266         uint256 _devFee
1267     ) external onlyOwner {
1268         sellMarketingFee = _marketingFee;
1269         sellLiquidityFee = _liquidityFee;
1270         sellDevFee = _devFee;
1271         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1272         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1273     }
1274 
1275     function excludeFromFees(address account, bool excluded) public onlyOwner {
1276         _isExcludedFromFees[account] = excluded;
1277         emit ExcludeFromFees(account, excluded);
1278     }
1279 
1280     function setAutomatedMarketMakerPair(address pair, bool value)
1281         public
1282         onlyOwner
1283     {
1284         require(
1285             pair != uniswapV2Pair,
1286             "The pair cannot be removed from automatedMarketMakerPairs"
1287         );
1288 
1289         _setAutomatedMarketMakerPair(pair, value);
1290     }
1291 
1292     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1293         automatedMarketMakerPairs[pair] = value;
1294 
1295         emit SetAutomatedMarketMakerPair(pair, value);
1296     }
1297 
1298     function updateMarketingWallet(address newMarketingWallet)
1299         external
1300         onlyOwner
1301     {
1302         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1303         marketingWallet = newMarketingWallet;
1304     }
1305 
1306     function updateDevWallet(address newWallet) external onlyOwner {
1307         emit devWalletUpdated(newWallet, devWallet);
1308         devWallet = newWallet;
1309     }
1310 
1311     function isExcludedFromFees(address account) public view returns (bool) {
1312         return _isExcludedFromFees[account];
1313     }
1314 
1315     event BoughtEarly(address indexed sniper);
1316 
1317     function _transfer(
1318         address from,
1319         address to,
1320         uint256 amount
1321     ) internal override {
1322         require(from != address(0), "ERC20: transfer from the zero address");
1323         require(to != address(0), "ERC20: transfer to the zero address");
1324 
1325         if (amount == 0) {
1326             super._transfer(from, to, 0);
1327             return;
1328         }
1329 
1330         if (limitsInEffect) {
1331             if (
1332                 from != owner() &&
1333                 to != owner() &&
1334                 to != address(0) &&
1335                 to != address(0xdead) &&
1336                 !swapping
1337             ) {
1338                 if (!tradingActive) {
1339                     require(
1340                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1341                         "Trading is not active."
1342                     );
1343                 }
1344 
1345                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1346                 if (transferDelayEnabled) {
1347                     if (
1348                         to != owner() &&
1349                         to != address(uniswapV2Router) &&
1350                         to != address(uniswapV2Pair)
1351                     ) {
1352                         require(
1353                             _holderLastTransferTimestamp[tx.origin] <
1354                                 block.number,
1355                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1356                         );
1357                         _holderLastTransferTimestamp[tx.origin] = block.number;
1358                     }
1359                 }
1360 
1361                 //when buy
1362                 if (
1363                     automatedMarketMakerPairs[from] &&
1364                     !_isExcludedMaxTransactionAmount[to]
1365                 ) {
1366                     require(
1367                         amount <= maxTransactionAmount,
1368                         "Buy transfer amount exceeds the maxTransactionAmount."
1369                     );
1370                     require(
1371                         amount + balanceOf(to) <= maxWallet,
1372                         "Max wallet exceeded"
1373                     );
1374                 }
1375                 //when sell
1376                 else if (
1377                     automatedMarketMakerPairs[to] &&
1378                     !_isExcludedMaxTransactionAmount[from]
1379                 ) {
1380                     require(
1381                         amount <= maxTransactionAmount,
1382                         "Sell transfer amount exceeds the maxTransactionAmount."
1383                     );
1384                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1385                     require(
1386                         amount + balanceOf(to) <= maxWallet,
1387                         "Max wallet exceeded"
1388                     );
1389                 }
1390             }
1391         }
1392 
1393         uint256 contractTokenBalance = balanceOf(address(this));
1394 
1395         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1396 
1397         if (
1398             canSwap &&
1399             swapEnabled &&
1400             !swapping &&
1401             !automatedMarketMakerPairs[from] &&
1402             !_isExcludedFromFees[from] &&
1403             !_isExcludedFromFees[to]
1404         ) {
1405             swapping = true;
1406 
1407             swapBack();
1408 
1409             swapping = false;
1410         }
1411 
1412         if (
1413             !swapping &&
1414             automatedMarketMakerPairs[to] &&
1415             lpBurnEnabled &&
1416             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1417             !_isExcludedFromFees[from]
1418         ) {
1419             autoBurnLiquidityPairTokens();
1420         }
1421 
1422         bool takeFee = !swapping;
1423 
1424         // if any account belongs to _isExcludedFromFee account then remove the fee
1425         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1426             takeFee = false;
1427         }
1428 
1429         uint256 fees = 0;
1430         // only take fees on buys/sells, do not take on wallet transfers
1431         if (takeFee) {
1432             // on sell
1433             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1434                 fees = amount.mul(sellTotalFees).div(100);
1435                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1436                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1437                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1438             }
1439             // on buy
1440             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1441                 fees = amount.mul(buyTotalFees).div(100);
1442                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1443                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1444                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1445             }
1446 
1447             if (fees > 0) {
1448                 super._transfer(from, address(this), fees);
1449             }
1450 
1451             amount -= fees;
1452         }
1453 
1454         super._transfer(from, to, amount);
1455     }
1456 
1457     function swapTokensForEth(uint256 tokenAmount) private {
1458         // generate the uniswap pair path of token -> weth
1459         address[] memory path = new address[](2);
1460         path[0] = address(this);
1461         path[1] = uniswapV2Router.WETH();
1462 
1463         _approve(address(this), address(uniswapV2Router), tokenAmount);
1464 
1465         // make the swap
1466         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1467             tokenAmount,
1468             0, // accept any amount of ETH
1469             path,
1470             address(this),
1471             block.timestamp
1472         );
1473     }
1474 
1475     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1476         // approve token transfer to cover all possible scenarios
1477         _approve(address(this), address(uniswapV2Router), tokenAmount);
1478 
1479         // add the liquidity
1480         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1481             address(this),
1482             tokenAmount,
1483             0, // slippage is unavoidable
1484             0, // slippage is unavoidable
1485             deadAddress,
1486             block.timestamp
1487         );
1488     }
1489 
1490     function swapBack() private {
1491         uint256 contractBalance = balanceOf(address(this));
1492         uint256 totalTokensToSwap = tokensForLiquidity +
1493             tokensForMarketing +
1494             tokensForDev;
1495         bool success;
1496 
1497         if (contractBalance == 0 || totalTokensToSwap == 0) {
1498             return;
1499         }
1500 
1501         if (contractBalance > swapTokensAtAmount * 20) {
1502             contractBalance = swapTokensAtAmount * 20;
1503         }
1504 
1505         // Halve the amount of liquidity tokens
1506         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1507             totalTokensToSwap /
1508             2;
1509         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1510 
1511         uint256 initialETHBalance = address(this).balance;
1512 
1513         swapTokensForEth(amountToSwapForETH);
1514 
1515         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1516 
1517         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1518             totalTokensToSwap
1519         );
1520         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1521 
1522         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1523 
1524         tokensForLiquidity = 0;
1525         tokensForMarketing = 0;
1526         tokensForDev = 0;
1527 
1528         (success, ) = address(devWallet).call{value: ethForDev}("");
1529 
1530         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1531             addLiquidity(liquidityTokens, ethForLiquidity);
1532             emit SwapAndLiquify(
1533                 amountToSwapForETH,
1534                 ethForLiquidity,
1535                 tokensForLiquidity
1536             );
1537         }
1538 
1539         (success, ) = address(marketingWallet).call{
1540             value: address(this).balance
1541         }("");
1542     }
1543 
1544     function setAutoLPBurnSettings(
1545         uint256 _frequencyInSeconds,
1546         uint256 _percent,
1547         bool _Enabled
1548     ) external onlyOwner {
1549         require(
1550             _frequencyInSeconds >= 600,
1551             "cannot set buyback more often than every 10 minutes"
1552         );
1553         require(
1554             _percent <= 1000 && _percent >= 0,
1555             "Must set auto LP burn percent between 0% and 10%"
1556         );
1557         lpBurnFrequency = _frequencyInSeconds;
1558         percentForLPBurn = _percent;
1559         lpBurnEnabled = _Enabled;
1560     }
1561 
1562     function autoBurnLiquidityPairTokens() internal returns (bool) {
1563         lastLpBurnTime = block.timestamp;
1564 
1565         // get balance of liquidity pair
1566         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1567 
1568         // calculate amount to burn
1569         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1570             10000
1571         );
1572 
1573         // pull tokens from pancakePair liquidity and move to dead address permanently
1574         if (amountToBurn > 0) {
1575             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1576         }
1577 
1578         //sync price since this is not in a swap transaction!
1579         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1580         pair.sync();
1581         emit AutoNukeLP();
1582         return true;
1583     }
1584 
1585     function manualBurnLiquidityPairTokens(uint256 percent)
1586         external
1587         onlyOwner
1588         returns (bool)
1589     {
1590         require(
1591             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1592             "Must wait for cooldown to finish"
1593         );
1594         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1595         lastManualLpBurnTime = block.timestamp;
1596 
1597         // get balance of liquidity pair
1598         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1599 
1600         // calculate amount to burn
1601         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1602 
1603         // pull tokens from pancakePair liquidity and move to dead address permanently
1604         if (amountToBurn > 0) {
1605             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1606         }
1607 
1608         //sync price since this is not in a swap transaction!
1609         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1610         pair.sync();
1611         emit ManualNukeLP();
1612         return true;
1613     }
1614 }