1 /**
2  *Submitted for verification at Etherscan.io on 2022-12-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
8 
9 /**
10 
11 
12 
13 
14 
15 有过暴君杀人犯，一时看似无敌，到头来却总是陨落
16 
17 There have been tyrants and murderers, and for a time, they can seem invincible, but in the end, they always fall
18 
19 等待的时间结束了。我们将不再袖手旁观，眼睁睁地看着我们的领导人和决策者继续营造一个富者愈富、穷者愈穷的世界。
20 
21 The time of waiting is at an end. No longer will we stand by and watch as our leaders and decision makers continue to foster a world where the rich get richer, and the poor grow poorer. 
22 
23 兔年将为忠诚的人们带来力量和繁荣。
24 
25 The Year of the Rabbit will bring power and prosperity to its devoted people.
26 
27 
28 
29 https://medium.com/@JadeRabbit
30 
31 
32 
33 
34 
35 
36 
37 
38 
39 
40 */
41 
42 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
43 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
44 
45 /* pragma solidity ^0.8.0; */
46 
47 /**
48  * @dev Provides information about the current execution context, including the
49  * sender of the transaction and its data. While these are generally available
50  * via msg.sender and msg.data, they should not be accessed in such a direct
51  * manner, since when dealing with meta-transactions the account sending and
52  * paying for execution may not be the actual sender (as far as an application
53  * is concerned).
54  *
55  * This contract is only required for intermediate, library-like contracts.
56  */
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 
62     function _msgData() internal view virtual returns (bytes calldata) {
63         return msg.data;
64     }
65 }
66 
67 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
68 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
69 
70 /* pragma solidity ^0.8.0; */
71 
72 /* import "../utils/Context.sol"; */
73 
74 /**
75  * @dev Contract module which provides a basic access control mechanism, where
76  * there is an account (an owner) that can be granted exclusive access to
77  * specific functions.
78  *
79  * By default, the owner account will be the one that deploys the contract. This
80  * can later be changed with {transferOwnership}.
81  *
82  * This module is used through inheritance. It will make available the modifier
83  * `onlyOwner`, which can be applied to your functions to restrict their use to
84  * the owner.
85  */
86 abstract contract Ownable is Context {
87     address private _owner;
88 
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     /**
92      * @dev Initializes the contract setting the deployer as the initial owner.
93      */
94     constructor() {
95         _transferOwnership(_msgSender());
96     }
97 
98     /**
99      * @dev Returns the address of the current owner.
100      */
101     function owner() public view virtual returns (address) {
102         return _owner;
103     }
104 
105     /**
106      * @dev Throws if called by any account other than the owner.
107      */
108     modifier onlyOwner() {
109         require(owner() == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     /**
114      * @dev Leaves the contract without owner. It will not be possible to call
115      * `onlyOwner` functions anymore. Can only be called by the current owner.
116      *
117      * NOTE: Renouncing ownership will leave the contract without an owner,
118      * thereby removing any functionality that is only available to the owner.
119      */
120     function renounceOwnership() public virtual onlyOwner {
121         _transferOwnership(address(0));
122     }
123 
124     /**
125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
126      * Can only be called by the current owner.
127      */
128     function transferOwnership(address newOwner) public virtual onlyOwner {
129         require(newOwner != address(0), "Ownable: new owner is the zero address");
130         _transferOwnership(newOwner);
131     }
132 
133     /**
134      * @dev Transfers ownership of the contract to a new account (`newOwner`).
135      * Internal function without access restriction.
136      */
137     function _transferOwnership(address newOwner) internal virtual {
138         address oldOwner = _owner;
139         _owner = newOwner;
140         emit OwnershipTransferred(oldOwner, newOwner);
141     }
142 }
143 
144 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
145 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
146 
147 /* pragma solidity ^0.8.0; */
148 
149 /**
150  * @dev Interface of the ERC20 standard as defined in the EIP.
151  */
152 interface IERC20 {
153     /**
154      * @dev Returns the amount of tokens in existence.
155      */
156     function totalSupply() external view returns (uint256);
157 
158     /**
159      * @dev Returns the amount of tokens owned by `account`.
160      */
161     function balanceOf(address account) external view returns (uint256);
162 
163     /**
164      * @dev Moves `amount` tokens from the caller's account to `recipient`.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transfer(address recipient, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Returns the remaining number of tokens that `spender` will be
174      * allowed to spend on behalf of `owner` through {transferFrom}. This is
175      * zero by default.
176      *
177      * This value changes when {approve} or {transferFrom} are called.
178      */
179     function allowance(address owner, address spender) external view returns (uint256);
180 
181     /**
182      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * IMPORTANT: Beware that changing an allowance with this method brings the risk
187      * that someone may use both the old and the new allowance by unfortunate
188      * transaction ordering. One possible solution to mitigate this race
189      * condition is to first reduce the spender's allowance to 0 and set the
190      * desired value afterwards:
191      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192      *
193      * Emits an {Approval} event.
194      */
195     function approve(address spender, uint256 amount) external returns (bool);
196 
197     /**
198      * @dev Moves `amount` tokens from `sender` to `recipient` using the
199      * allowance mechanism. `amount` is then deducted from the caller's
200      * allowance.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * Emits a {Transfer} event.
205      */
206     function transferFrom(
207         address sender,
208         address recipient,
209         uint256 amount
210     ) external returns (bool);
211 
212     /**
213      * @dev Emitted when `value` tokens are moved from one account (`from`) to
214      * another (`to`).
215      *
216      * Note that `value` may be zero.
217      */
218     event Transfer(address indexed from, address indexed to, uint256 value);
219 
220     /**
221      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
222      * a call to {approve}. `value` is the new allowance.
223      */
224     event Approval(address indexed owner, address indexed spender, uint256 value);
225 }
226 
227 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
228 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
229 
230 /* pragma solidity ^0.8.0; */
231 
232 /* import "../IERC20.sol"; */
233 
234 /**
235  * @dev Interface for the optional metadata functions from the ERC20 standard.
236  *
237  * _Available since v4.1._
238  */
239 interface IERC20Metadata is IERC20 {
240     /**
241      * @dev Returns the name of the token.
242      */
243     function name() external view returns (string memory);
244 
245     /**
246      * @dev Returns the symbol of the token.
247      */
248     function symbol() external view returns (string memory);
249 
250     /**
251      * @dev Returns the decimals places of the token.
252      */
253     function decimals() external view returns (uint8);
254 }
255 
256 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
257 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
258 
259 /* pragma solidity ^0.8.0; */
260 
261 /* import "./IERC20.sol"; */
262 /* import "./extensions/IERC20Metadata.sol"; */
263 /* import "../../utils/Context.sol"; */
264 
265 /**
266  * @dev Implementation of the {IERC20} interface.
267  *
268  * This implementation is agnostic to the way tokens are created. This means
269  * that a supply mechanism has to be added in a derived contract using {_mint}.
270  * For a generic mechanism see {ERC20PresetMinterPauser}.
271  *
272  * TIP: For a detailed writeup see our guide
273  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
274  * to implement supply mechanisms].
275  *
276  * We have followed general OpenZeppelin Contracts guidelines: functions revert
277  * instead returning `false` on failure. This behavior is nonetheless
278  * conventional and does not conflict with the expectations of ERC20
279  * applications.
280  *
281  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
282  * This allows applications to reconstruct the allowance for all accounts just
283  * by listening to said events. Other implementations of the EIP may not emit
284  * these events, as it isn't required by the specification.
285  *
286  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
287  * functions have been added to mitigate the well-known issues around setting
288  * allowances. See {IERC20-approve}.
289  */
290 contract ERC20 is Context, IERC20, IERC20Metadata {
291     mapping(address => uint256) private _balances;
292 
293     mapping(address => mapping(address => uint256)) private _allowances;
294 
295     uint256 private _totalSupply;
296 
297     string private _name;
298     string private _symbol;
299 
300     /**
301      * @dev Sets the values for {name} and {symbol}.
302      *
303      * The default value of {decimals} is 18. To select a different value for
304      * {decimals} you should overload it.
305      *
306      * All two of these values are immutable: they can only be set once during
307      * construction.
308      */
309     constructor(string memory name_, string memory symbol_) {
310         _name = name_;
311         _symbol = symbol_;
312     }
313 
314     /**
315      * @dev Returns the name of the token.
316      */
317     function name() public view virtual override returns (string memory) {
318         return _name;
319     }
320 
321     /**
322      * @dev Returns the symbol of the token, usually a shorter version of the
323      * name.
324      */
325     function symbol() public view virtual override returns (string memory) {
326         return _symbol;
327     }
328 
329     /**
330      * @dev Returns the number of decimals used to get its user representation.
331      * For example, if `decimals` equals `2`, a balance of `505` tokens should
332      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
333      *
334      * Tokens usually opt for a value of 18, imitating the relationship between
335      * Ether and Wei. This is the value {ERC20} uses, unless this function is
336      * overridden;
337      *
338      * NOTE: This information is only used for _display_ purposes: it in
339      * no way affects any of the arithmetic of the contract, including
340      * {IERC20-balanceOf} and {IERC20-transfer}.
341      */
342     function decimals() public view virtual override returns (uint8) {
343         return 18;
344     }
345 
346     /**
347      * @dev See {IERC20-totalSupply}.
348      */
349     function totalSupply() public view virtual override returns (uint256) {
350         return _totalSupply;
351     }
352 
353     /**
354      * @dev See {IERC20-balanceOf}.
355      */
356     function balanceOf(address account) public view virtual override returns (uint256) {
357         return _balances[account];
358     }
359 
360     /**
361      * @dev See {IERC20-transfer}.
362      *
363      * Requirements:
364      *
365      * - `recipient` cannot be the zero address.
366      * - the caller must have a balance of at least `amount`.
367      */
368     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
369         _transfer(_msgSender(), recipient, amount);
370         return true;
371     }
372 
373     /**
374      * @dev See {IERC20-allowance}.
375      */
376     function allowance(address owner, address spender) public view virtual override returns (uint256) {
377         return _allowances[owner][spender];
378     }
379 
380     /**
381      * @dev See {IERC20-approve}.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function approve(address spender, uint256 amount) public virtual override returns (bool) {
388         _approve(_msgSender(), spender, amount);
389         return true;
390     }
391 
392     /**
393      * @dev See {IERC20-transferFrom}.
394      *
395      * Emits an {Approval} event indicating the updated allowance. This is not
396      * required by the EIP. See the note at the beginning of {ERC20}.
397      *
398      * Requirements:
399      *
400      * - `sender` and `recipient` cannot be the zero address.
401      * - `sender` must have a balance of at least `amount`.
402      * - the caller must have allowance for ``sender``'s tokens of at least
403      * `amount`.
404      */
405     function transferFrom(
406         address sender,
407         address recipient,
408         uint256 amount
409     ) public virtual override returns (bool) {
410         _transfer(sender, recipient, amount);
411 
412         uint256 currentAllowance = _allowances[sender][_msgSender()];
413         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
414         unchecked {
415             _approve(sender, _msgSender(), currentAllowance - amount);
416         }
417 
418         return true;
419     }
420 
421     /**
422      * @dev Atomically increases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to {approve} that can be used as a mitigation for
425      * problems described in {IERC20-approve}.
426      *
427      * Emits an {Approval} event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      */
433     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
434         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
435         return true;
436     }
437 
438     /**
439      * @dev Atomically decreases the allowance granted to `spender` by the caller.
440      *
441      * This is an alternative to {approve} that can be used as a mitigation for
442      * problems described in {IERC20-approve}.
443      *
444      * Emits an {Approval} event indicating the updated allowance.
445      *
446      * Requirements:
447      *
448      * - `spender` cannot be the zero address.
449      * - `spender` must have allowance for the caller of at least
450      * `subtractedValue`.
451      */
452     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
453         uint256 currentAllowance = _allowances[_msgSender()][spender];
454         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
455         unchecked {
456             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
457         }
458 
459         return true;
460     }
461 
462     /**
463      * @dev Moves `amount` of tokens from `sender` to `recipient`.
464      *
465      * This internal function is equivalent to {transfer}, and can be used to
466      * e.g. implement automatic token fees, slashing mechanisms, etc.
467      *
468      * Emits a {Transfer} event.
469      *
470      * Requirements:
471      *
472      * - `sender` cannot be the zero address.
473      * - `recipient` cannot be the zero address.
474      * - `sender` must have a balance of at least `amount`.
475      */
476     function _transfer(
477         address sender,
478         address recipient,
479         uint256 amount
480     ) internal virtual {
481         require(sender != address(0), "ERC20: transfer from the zero address");
482         require(recipient != address(0), "ERC20: transfer to the zero address");
483 
484         _beforeTokenTransfer(sender, recipient, amount);
485 
486         uint256 senderBalance = _balances[sender];
487         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
488         unchecked {
489             _balances[sender] = senderBalance - amount;
490         }
491         _balances[recipient] += amount;
492 
493         emit Transfer(sender, recipient, amount);
494 
495         _afterTokenTransfer(sender, recipient, amount);
496     }
497 
498     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
499      * the total supply.
500      *
501      * Emits a {Transfer} event with `from` set to the zero address.
502      *
503      * Requirements:
504      *
505      * - `account` cannot be the zero address.
506      */
507     function _mint(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: mint to the zero address");
509 
510         _beforeTokenTransfer(address(0), account, amount);
511 
512         _totalSupply += amount;
513         _balances[account] += amount;
514         emit Transfer(address(0), account, amount);
515 
516         _afterTokenTransfer(address(0), account, amount);
517     }
518 
519     /**
520      * @dev Destroys `amount` tokens from `account`, reducing the
521      * total supply.
522      *
523      * Emits a {Transfer} event with `to` set to the zero address.
524      *
525      * Requirements:
526      *
527      * - `account` cannot be the zero address.
528      * - `account` must have at least `amount` tokens.
529      */
530     function _burn(address account, uint256 amount) internal virtual {
531         require(account != address(0), "ERC20: burn from the zero address");
532 
533         _beforeTokenTransfer(account, address(0), amount);
534 
535         uint256 accountBalance = _balances[account];
536         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
537         unchecked {
538             _balances[account] = accountBalance - amount;
539         }
540         _totalSupply -= amount;
541 
542         emit Transfer(account, address(0), amount);
543 
544         _afterTokenTransfer(account, address(0), amount);
545     }
546 
547     /**
548      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
549      *
550      * This internal function is equivalent to `approve`, and can be used to
551      * e.g. set automatic allowances for certain subsystems, etc.
552      *
553      * Emits an {Approval} event.
554      *
555      * Requirements:
556      *
557      * - `owner` cannot be the zero address.
558      * - `spender` cannot be the zero address.
559      */
560     function _approve(
561         address owner,
562         address spender,
563         uint256 amount
564     ) internal virtual {
565         require(owner != address(0), "ERC20: approve from the zero address");
566         require(spender != address(0), "ERC20: approve to the zero address");
567 
568         _allowances[owner][spender] = amount;
569         emit Approval(owner, spender, amount);
570     }
571 
572     /**
573      * @dev Hook that is called before any transfer of tokens. This includes
574      * minting and burning.
575      *
576      * Calling conditions:
577      *
578      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
579      * will be transferred to `to`.
580      * - when `from` is zero, `amount` tokens will be minted for `to`.
581      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
582      * - `from` and `to` are never both zero.
583      *
584      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
585      */
586     function _beforeTokenTransfer(
587         address from,
588         address to,
589         uint256 amount
590     ) internal virtual {}
591 
592     /**
593      * @dev Hook that is called after any transfer of tokens. This includes
594      * minting and burning.
595      *
596      * Calling conditions:
597      *
598      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
599      * has been transferred to `to`.
600      * - when `from` is zero, `amount` tokens have been minted for `to`.
601      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
602      * - `from` and `to` are never both zero.
603      *
604      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
605      */
606     function _afterTokenTransfer(
607         address from,
608         address to,
609         uint256 amount
610     ) internal virtual {}
611 }
612 
613 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
614 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
615 
616 /* pragma solidity ^0.8.0; */
617 
618 // CAUTION
619 // This version of SafeMath should only be used with Solidity 0.8 or later,
620 // because it relies on the compiler's built in overflow checks.
621 
622 /**
623  * @dev Wrappers over Solidity's arithmetic operations.
624  *
625  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
626  * now has built in overflow checking.
627  */
628 library SafeMath {
629     /**
630      * @dev Returns the addition of two unsigned integers, with an overflow flag.
631      *
632      * _Available since v3.4._
633      */
634     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
635         unchecked {
636             uint256 c = a + b;
637             if (c < a) return (false, 0);
638             return (true, c);
639         }
640     }
641 
642     /**
643      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
644      *
645      * _Available since v3.4._
646      */
647     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
648         unchecked {
649             if (b > a) return (false, 0);
650             return (true, a - b);
651         }
652     }
653 
654     /**
655      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
656      *
657      * _Available since v3.4._
658      */
659     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
660         unchecked {
661             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
662             // benefit is lost if 'b' is also tested.
663             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
664             if (a == 0) return (true, 0);
665             uint256 c = a * b;
666             if (c / a != b) return (false, 0);
667             return (true, c);
668         }
669     }
670 
671     /**
672      * @dev Returns the division of two unsigned integers, with a division by zero flag.
673      *
674      * _Available since v3.4._
675      */
676     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
677         unchecked {
678             if (b == 0) return (false, 0);
679             return (true, a / b);
680         }
681     }
682 
683     /**
684      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
685      *
686      * _Available since v3.4._
687      */
688     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
689         unchecked {
690             if (b == 0) return (false, 0);
691             return (true, a % b);
692         }
693     }
694 
695     /**
696      * @dev Returns the addition of two unsigned integers, reverting on
697      * overflow.
698      *
699      * Counterpart to Solidity's `+` operator.
700      *
701      * Requirements:
702      *
703      * - Addition cannot overflow.
704      */
705     function add(uint256 a, uint256 b) internal pure returns (uint256) {
706         return a + b;
707     }
708 
709     /**
710      * @dev Returns the subtraction of two unsigned integers, reverting on
711      * overflow (when the result is negative).
712      *
713      * Counterpart to Solidity's `-` operator.
714      *
715      * Requirements:
716      *
717      * - Subtraction cannot overflow.
718      */
719     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
720         return a - b;
721     }
722 
723     /**
724      * @dev Returns the multiplication of two unsigned integers, reverting on
725      * overflow.
726      *
727      * Counterpart to Solidity's `*` operator.
728      *
729      * Requirements:
730      *
731      * - Multiplication cannot overflow.
732      */
733     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
734         return a * b;
735     }
736 
737     /**
738      * @dev Returns the integer division of two unsigned integers, reverting on
739      * division by zero. The result is rounded towards zero.
740      *
741      * Counterpart to Solidity's `/` operator.
742      *
743      * Requirements:
744      *
745      * - The divisor cannot be zero.
746      */
747     function div(uint256 a, uint256 b) internal pure returns (uint256) {
748         return a / b;
749     }
750 
751     /**
752      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
753      * reverting when dividing by zero.
754      *
755      * Counterpart to Solidity's `%` operator. This function uses a `revert`
756      * opcode (which leaves remaining gas untouched) while Solidity uses an
757      * invalid opcode to revert (consuming all remaining gas).
758      *
759      * Requirements:
760      *
761      * - The divisor cannot be zero.
762      */
763     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
764         return a % b;
765     }
766 
767     /**
768      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
769      * overflow (when the result is negative).
770      *
771      * CAUTION: This function is deprecated because it requires allocating memory for the error
772      * message unnecessarily. For custom revert reasons use {trySub}.
773      *
774      * Counterpart to Solidity's `-` operator.
775      *
776      * Requirements:
777      *
778      * - Subtraction cannot overflow.
779      */
780     function sub(
781         uint256 a,
782         uint256 b,
783         string memory errorMessage
784     ) internal pure returns (uint256) {
785         unchecked {
786             require(b <= a, errorMessage);
787             return a - b;
788         }
789     }
790 
791     /**
792      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
793      * division by zero. The result is rounded towards zero.
794      *
795      * Counterpart to Solidity's `/` operator. Note: this function uses a
796      * `revert` opcode (which leaves remaining gas untouched) while Solidity
797      * uses an invalid opcode to revert (consuming all remaining gas).
798      *
799      * Requirements:
800      *
801      * - The divisor cannot be zero.
802      */
803     function div(
804         uint256 a,
805         uint256 b,
806         string memory errorMessage
807     ) internal pure returns (uint256) {
808         unchecked {
809             require(b > 0, errorMessage);
810             return a / b;
811         }
812     }
813 
814     /**
815      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
816      * reverting with custom message when dividing by zero.
817      *
818      * CAUTION: This function is deprecated because it requires allocating memory for the error
819      * message unnecessarily. For custom revert reasons use {tryMod}.
820      *
821      * Counterpart to Solidity's `%` operator. This function uses a `revert`
822      * opcode (which leaves remaining gas untouched) while Solidity uses an
823      * invalid opcode to revert (consuming all remaining gas).
824      *
825      * Requirements:
826      *
827      * - The divisor cannot be zero.
828      */
829     function mod(
830         uint256 a,
831         uint256 b,
832         string memory errorMessage
833     ) internal pure returns (uint256) {
834         unchecked {
835             require(b > 0, errorMessage);
836             return a % b;
837         }
838     }
839 }
840 
841 /* pragma solidity 0.8.10; */
842 /* pragma experimental ABIEncoderV2; */
843 
844 interface IUniswapV2Factory {
845     event PairCreated(
846         address indexed token0,
847         address indexed token1,
848         address pair,
849         uint256
850     );
851 
852     function feeTo() external view returns (address);
853 
854     function feeToSetter() external view returns (address);
855 
856     function getPair(address tokenA, address tokenB)
857         external
858         view
859         returns (address pair);
860 
861     function allPairs(uint256) external view returns (address pair);
862 
863     function allPairsLength() external view returns (uint256);
864 
865     function createPair(address tokenA, address tokenB)
866         external
867         returns (address pair);
868 
869     function setFeeTo(address) external;
870 
871     function setFeeToSetter(address) external;
872 }
873 
874 /* pragma solidity 0.8.10; */
875 /* pragma experimental ABIEncoderV2; */
876 
877 interface IUniswapV2Pair {
878     event Approval(
879         address indexed owner,
880         address indexed spender,
881         uint256 value
882     );
883     event Transfer(address indexed from, address indexed to, uint256 value);
884 
885     function name() external pure returns (string memory);
886 
887     function symbol() external pure returns (string memory);
888 
889     function decimals() external pure returns (uint8);
890 
891     function totalSupply() external view returns (uint256);
892 
893     function balanceOf(address owner) external view returns (uint256);
894 
895     function allowance(address owner, address spender)
896         external
897         view
898         returns (uint256);
899 
900     function approve(address spender, uint256 value) external returns (bool);
901 
902     function transfer(address to, uint256 value) external returns (bool);
903 
904     function transferFrom(
905         address from,
906         address to,
907         uint256 value
908     ) external returns (bool);
909 
910     function DOMAIN_SEPARATOR() external view returns (bytes32);
911 
912     function PERMIT_TYPEHASH() external pure returns (bytes32);
913 
914     function nonces(address owner) external view returns (uint256);
915 
916     function permit(
917         address owner,
918         address spender,
919         uint256 value,
920         uint256 deadline,
921         uint8 v,
922         bytes32 r,
923         bytes32 s
924     ) external;
925 
926     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
927     event Burn(
928         address indexed sender,
929         uint256 amount0,
930         uint256 amount1,
931         address indexed to
932     );
933     event Swap(
934         address indexed sender,
935         uint256 amount0In,
936         uint256 amount1In,
937         uint256 amount0Out,
938         uint256 amount1Out,
939         address indexed to
940     );
941     event Sync(uint112 reserve0, uint112 reserve1);
942 
943     function MINIMUM_LIQUIDITY() external pure returns (uint256);
944 
945     function factory() external view returns (address);
946 
947     function token0() external view returns (address);
948 
949     function token1() external view returns (address);
950 
951     function getReserves()
952         external
953         view
954         returns (
955             uint112 reserve0,
956             uint112 reserve1,
957             uint32 blockTimestampLast
958         );
959 
960     function price0CumulativeLast() external view returns (uint256);
961 
962     function price1CumulativeLast() external view returns (uint256);
963 
964     function kLast() external view returns (uint256);
965 
966     function mint(address to) external returns (uint256 liquidity);
967 
968     function burn(address to)
969         external
970         returns (uint256 amount0, uint256 amount1);
971 
972     function swap(
973         uint256 amount0Out,
974         uint256 amount1Out,
975         address to,
976         bytes calldata data
977     ) external;
978 
979     function skim(address to) external;
980 
981     function sync() external;
982 
983     function initialize(address, address) external;
984 }
985 
986 /* pragma solidity 0.8.10; */
987 /* pragma experimental ABIEncoderV2; */
988 
989 interface IUniswapV2Router02 {
990     function factory() external pure returns (address);
991 
992     function WETH() external pure returns (address);
993 
994     function addLiquidity(
995         address tokenA,
996         address tokenB,
997         uint256 amountADesired,
998         uint256 amountBDesired,
999         uint256 amountAMin,
1000         uint256 amountBMin,
1001         address to,
1002         uint256 deadline
1003     )
1004         external
1005         returns (
1006             uint256 amountA,
1007             uint256 amountB,
1008             uint256 liquidity
1009         );
1010 
1011     function addLiquidityETH(
1012         address token,
1013         uint256 amountTokenDesired,
1014         uint256 amountTokenMin,
1015         uint256 amountETHMin,
1016         address to,
1017         uint256 deadline
1018     )
1019         external
1020         payable
1021         returns (
1022             uint256 amountToken,
1023             uint256 amountETH,
1024             uint256 liquidity
1025         );
1026 
1027     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1028         uint256 amountIn,
1029         uint256 amountOutMin,
1030         address[] calldata path,
1031         address to,
1032         uint256 deadline
1033     ) external;
1034 
1035     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1036         uint256 amountOutMin,
1037         address[] calldata path,
1038         address to,
1039         uint256 deadline
1040     ) external payable;
1041 
1042     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1043         uint256 amountIn,
1044         uint256 amountOutMin,
1045         address[] calldata path,
1046         address to,
1047         uint256 deadline
1048     ) external;
1049 }
1050 
1051 /* pragma solidity >=0.8.10; */
1052 
1053 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1054 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1055 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1056 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1057 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1058 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1059 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1060 
1061 contract JADERABBIT is ERC20, Ownable {
1062     using SafeMath for uint256;
1063 
1064     IUniswapV2Router02 public immutable uniswapV2Router;
1065     address public immutable uniswapV2Pair;
1066     address public constant deadAddress = address(0xdead);
1067 
1068     bool private swapping;
1069 
1070 	address public charityWallet;
1071     address public marketingWallet;
1072     address public devWallet;
1073 
1074     uint256 public maxTransactionAmount;
1075     uint256 public swapTokensAtAmount;
1076     uint256 public maxWallet;
1077 
1078     bool public limitsInEffect = true;
1079     bool public tradingActive = true;
1080     bool public swapEnabled = true;
1081 
1082     // Anti-bot and anti-whale mappings and variables
1083     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1084     bool public transferDelayEnabled = true;
1085 
1086     uint256 public buyTotalFees;
1087 	uint256 public buyCharityFee;
1088     uint256 public buyMarketingFee;
1089     uint256 public buyLiquidityFee;
1090     uint256 public buyDevFee;
1091 
1092     uint256 public sellTotalFees;
1093 	uint256 public sellCharityFee;
1094     uint256 public sellMarketingFee;
1095     uint256 public sellLiquidityFee;
1096     uint256 public sellDevFee;
1097 
1098 	uint256 public tokensForCharity;
1099     uint256 public tokensForMarketing;
1100     uint256 public tokensForLiquidity;
1101     uint256 public tokensForDev;
1102 
1103     /******************/
1104 
1105     // exlcude from fees and max transaction amount
1106     mapping(address => bool) private _isExcludedFromFees;
1107     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1108 
1109     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1110     // could be subject to a maximum transfer amount
1111     mapping(address => bool) public automatedMarketMakerPairs;
1112 
1113     event UpdateUniswapV2Router(
1114         address indexed newAddress,
1115         address indexed oldAddress
1116     );
1117 
1118     event ExcludeFromFees(address indexed account, bool isExcluded);
1119 
1120     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1121 
1122     event SwapAndLiquify(
1123         uint256 tokensSwapped,
1124         uint256 ethReceived,
1125         uint256 tokensIntoLiquidity
1126     );
1127 
1128     constructor() ERC20("Jade Rabbit", "\xF0\x9F\x90\xB0") {
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
1141 		uint256 _buyCharityFee = 0;
1142         uint256 _buyMarketingFee = 0;
1143         uint256 _buyLiquidityFee = 0;
1144         uint256 _buyDevFee = 0;
1145 
1146 		uint256 _sellCharityFee = 0;
1147         uint256 _sellMarketingFee = 33;
1148         uint256 _sellLiquidityFee = 0;
1149         uint256 _sellDevFee = 0;
1150 
1151         uint256 totalSupply = 1000000000 * 1e18;
1152 
1153         maxTransactionAmount = 5000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1154         maxWallet = 10000000 * 1e18; // 2% from total supply maxWallet
1155         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1156 
1157 		buyCharityFee = _buyCharityFee;
1158         buyMarketingFee = _buyMarketingFee;
1159         buyLiquidityFee = _buyLiquidityFee;
1160         buyDevFee = _buyDevFee;
1161         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1162 
1163 		sellCharityFee = _sellCharityFee;
1164         sellMarketingFee = _sellMarketingFee;
1165         sellLiquidityFee = _sellLiquidityFee;
1166         sellDevFee = _sellDevFee;
1167         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1168 
1169 		charityWallet = address(0xEc671d973f21f3256c1Fba656FC61a8218C04338); // set as charity wallet
1170         marketingWallet = address(0xEc671d973f21f3256c1Fba656FC61a8218C04338); // set as marketing wallet
1171         devWallet = address(0xEc671d973f21f3256c1Fba656FC61a8218C04338); // set as dev wallet
1172 
1173         // exclude from paying fees or having max transaction amount
1174         excludeFromFees(owner(), true);
1175         excludeFromFees(address(this), true);
1176         excludeFromFees(address(0xdead), true);
1177 
1178         excludeFromMaxTransaction(owner(), true);
1179         excludeFromMaxTransaction(address(this), true);
1180         excludeFromMaxTransaction(address(0xdead), true);
1181 
1182         /*
1183             _mint is an internal function in ERC20.sol that is only called here,
1184             and CANNOT be called ever again
1185         */
1186         _mint(msg.sender, totalSupply);
1187     }
1188 
1189     receive() external payable {}
1190 
1191     // once enabled, can never be turned off
1192     function enableTrading() external onlyOwner {
1193         tradingActive = true;
1194         swapEnabled = true;
1195     }
1196 
1197     // remove limits after token is stable
1198     function removeLimits() external onlyOwner returns (bool) {
1199         limitsInEffect = false;
1200         return true;
1201     }
1202 
1203     // disable Transfer delay - cannot be reenabled
1204     function disableTransferDelay() external onlyOwner returns (bool) {
1205         transferDelayEnabled = false;
1206         return true;
1207     }
1208 
1209     // change the minimum amount of tokens to sell from fees
1210     function updateSwapTokensAtAmount(uint256 newAmount)
1211         external
1212         onlyOwner
1213         returns (bool)
1214     {
1215         require(
1216             newAmount >= (totalSupply() * 1) / 100000,
1217             "Swap amount cannot be lower than 0.001% total supply."
1218         );
1219         require(
1220             newAmount <= (totalSupply() * 5) / 1000,
1221             "Swap amount cannot be higher than 0.5% total supply."
1222         );
1223         swapTokensAtAmount = newAmount;
1224         return true;
1225     }
1226 
1227     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1228         require(
1229             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1230             "Cannot set maxTransactionAmount lower than 0.5%"
1231         );
1232         maxTransactionAmount = newNum * (10**18);
1233     }
1234 
1235     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1236         require(
1237             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1238             "Cannot set maxWallet lower than 0.5%"
1239         );
1240         maxWallet = newNum * (10**18);
1241     }
1242 	
1243     function excludeFromMaxTransaction(address updAds, bool isEx)
1244         public
1245         onlyOwner
1246     {
1247         _isExcludedMaxTransactionAmount[updAds] = isEx;
1248     }
1249 
1250     // only use to disable contract sales if absolutely necessary (emergency use only)
1251     function updateSwapEnabled(bool enabled) external onlyOwner {
1252         swapEnabled = enabled;
1253     }
1254 
1255     function updateBuyFees(
1256 		uint256 _charityFee,
1257         uint256 _marketingFee,
1258         uint256 _liquidityFee,
1259         uint256 _devFee
1260     ) external onlyOwner {
1261 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1262 		buyCharityFee = _charityFee;
1263         buyMarketingFee = _marketingFee;
1264         buyLiquidityFee = _liquidityFee;
1265         buyDevFee = _devFee;
1266         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1267      }
1268 
1269     function updateSellFees(
1270 		uint256 _charityFee,
1271         uint256 _marketingFee,
1272         uint256 _liquidityFee,
1273         uint256 _devFee
1274     ) external onlyOwner {
1275 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1276 		sellCharityFee = _charityFee;
1277         sellMarketingFee = _marketingFee;
1278         sellLiquidityFee = _liquidityFee;
1279         sellDevFee = _devFee;
1280         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1281     }
1282 
1283     function excludeFromFees(address account, bool excluded) public onlyOwner {
1284         _isExcludedFromFees[account] = excluded;
1285         emit ExcludeFromFees(account, excluded);
1286     }
1287 
1288     function setAutomatedMarketMakerPair(address pair, bool value)
1289         public
1290         onlyOwner
1291     {
1292         require(
1293             pair != uniswapV2Pair,
1294             "The pair cannot be removed from automatedMarketMakerPairs"
1295         );
1296 
1297         _setAutomatedMarketMakerPair(pair, value);
1298     }
1299 
1300     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1301         automatedMarketMakerPairs[pair] = value;
1302 
1303         emit SetAutomatedMarketMakerPair(pair, value);
1304     }
1305 
1306     function isExcludedFromFees(address account) public view returns (bool) {
1307         return _isExcludedFromFees[account];
1308     }
1309 
1310     function _transfer(
1311         address from,
1312         address to,
1313         uint256 amount
1314     ) internal override {
1315         require(from != address(0), "ERC20: transfer from the zero address");
1316         require(to != address(0), "ERC20: transfer to the zero address");
1317 
1318         if (amount == 0) {
1319             super._transfer(from, to, 0);
1320             return;
1321         }
1322 
1323         if (limitsInEffect) {
1324             if (
1325                 from != owner() &&
1326                 to != owner() &&
1327                 to != address(0) &&
1328                 to != address(0xdead) &&
1329                 !swapping
1330             ) {
1331                 if (!tradingActive) {
1332                     require(
1333                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1334                         "Trading is not active."
1335                     );
1336                 }
1337 
1338                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1339                 if (transferDelayEnabled) {
1340                     if (
1341                         to != owner() &&
1342                         to != address(uniswapV2Router) &&
1343                         to != address(uniswapV2Pair)
1344                     ) {
1345                         require(
1346                             _holderLastTransferTimestamp[tx.origin] <
1347                                 block.number,
1348                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1349                         );
1350                         _holderLastTransferTimestamp[tx.origin] = block.number;
1351                     }
1352                 }
1353 
1354                 //when buy
1355                 if (
1356                     automatedMarketMakerPairs[from] &&
1357                     !_isExcludedMaxTransactionAmount[to]
1358                 ) {
1359                     require(
1360                         amount <= maxTransactionAmount,
1361                         "Buy transfer amount exceeds the maxTransactionAmount."
1362                     );
1363                     require(
1364                         amount + balanceOf(to) <= maxWallet,
1365                         "Max wallet exceeded"
1366                     );
1367                 }
1368                 //when sell
1369                 else if (
1370                     automatedMarketMakerPairs[to] &&
1371                     !_isExcludedMaxTransactionAmount[from]
1372                 ) {
1373                     require(
1374                         amount <= maxTransactionAmount,
1375                         "Sell transfer amount exceeds the maxTransactionAmount."
1376                     );
1377                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1378                     require(
1379                         amount + balanceOf(to) <= maxWallet,
1380                         "Max wallet exceeded"
1381                     );
1382                 }
1383             }
1384         }
1385 
1386         uint256 contractTokenBalance = balanceOf(address(this));
1387 
1388         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1389 
1390         if (
1391             canSwap &&
1392             swapEnabled &&
1393             !swapping &&
1394             !automatedMarketMakerPairs[from] &&
1395             !_isExcludedFromFees[from] &&
1396             !_isExcludedFromFees[to]
1397         ) {
1398             swapping = true;
1399 
1400             swapBack();
1401 
1402             swapping = false;
1403         }
1404 
1405         bool takeFee = !swapping;
1406 
1407         // if any account belongs to _isExcludedFromFee account then remove the fee
1408         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1409             takeFee = false;
1410         }
1411 
1412         uint256 fees = 0;
1413         // only take fees on buys/sells, do not take on wallet transfers
1414         if (takeFee) {
1415             // on sell
1416             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1417                 fees = amount.mul(sellTotalFees).div(100);
1418 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1419                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1420                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1421                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1422             }
1423             // on buy
1424             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1425                 fees = amount.mul(buyTotalFees).div(100);
1426 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1427                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1428                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1429                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1430             }
1431 
1432             if (fees > 0) {
1433                 super._transfer(from, address(this), fees);
1434             }
1435 
1436             amount -= fees;
1437         }
1438 
1439         super._transfer(from, to, amount);
1440     }
1441 
1442     function swapTokensForEth(uint256 tokenAmount) private {
1443         // generate the uniswap pair path of token -> weth
1444         address[] memory path = new address[](2);
1445         path[0] = address(this);
1446         path[1] = uniswapV2Router.WETH();
1447 
1448         _approve(address(this), address(uniswapV2Router), tokenAmount);
1449 
1450         // make the swap
1451         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1452             tokenAmount,
1453             0, // accept any amount of ETH
1454             path,
1455             address(this),
1456             block.timestamp
1457         );
1458     }
1459 
1460     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1461         // approve token transfer to cover all possible scenarios
1462         _approve(address(this), address(uniswapV2Router), tokenAmount);
1463 
1464         // add the liquidity
1465         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1466             address(this),
1467             tokenAmount,
1468             0, // slippage is unavoidable
1469             0, // slippage is unavoidable
1470             devWallet,
1471             block.timestamp
1472         );
1473     }
1474 
1475     function swapBack() private {
1476         uint256 contractBalance = balanceOf(address(this));
1477         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1478         bool success;
1479 
1480         if (contractBalance == 0 || totalTokensToSwap == 0) {
1481             return;
1482         }
1483 
1484         if (contractBalance > swapTokensAtAmount * 20) {
1485             contractBalance = swapTokensAtAmount * 20;
1486         }
1487 
1488         // Halve the amount of liquidity tokens
1489         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1490         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1491 
1492         uint256 initialETHBalance = address(this).balance;
1493 
1494         swapTokensForEth(amountToSwapForETH);
1495 
1496         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1497 
1498 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1499         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1500         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1501 
1502         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1503 
1504         tokensForLiquidity = 0;
1505 		tokensForCharity = 0;
1506         tokensForMarketing = 0;
1507         tokensForDev = 0;
1508 
1509         (success, ) = address(devWallet).call{value: ethForDev}("");
1510         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1511 
1512 
1513         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1514             addLiquidity(liquidityTokens, ethForLiquidity);
1515             emit SwapAndLiquify(
1516                 amountToSwapForETH,
1517                 ethForLiquidity,
1518                 tokensForLiquidity
1519             );
1520         }
1521 
1522         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1523     }
1524 
1525 }