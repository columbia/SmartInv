1 /**
2 
3 Whole information to be slowly revealed on our telegram as development starts
4 
5 https://t.me/DogPadFinance
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity =0.8.17 >=0.8.10 >=0.8.0 <0.9.0;
11 pragma experimental ABIEncoderV2;
12 
13 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
14 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
15 
16 /* pragma solidity ^0.8.0; */
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
39 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
40 
41 /* pragma solidity ^0.8.0; */
42 
43 /* import "../utils/Context.sol"; */
44 
45 /**
46  * @dev Contract module which provides a basic access control mechanism, where
47  * there is an account (an owner) that can be granted exclusive access to
48  * specific functions.
49  *
50  * By default, the owner account will be the one that deploys the contract. This
51  * can later be changed with {transferOwnership}.
52  *
53  * This module is used through inheritance. It will make available the modifier
54  * `onlyOwner`, which can be applied to your functions to restrict their use to
55  * the owner.
56  */
57 abstract contract Ownable is Context {
58     address private _owner;
59 
60     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62     /**
63      * @dev Initializes the contract setting the deployer as the initial owner.
64      */
65     constructor() {
66         _transferOwnership(_msgSender());
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
116 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
117 
118 /* pragma solidity ^0.8.0; */
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Returns the amount of tokens in existence.
126      */
127     function totalSupply() external view returns (uint256);
128 
129     /**
130      * @dev Returns the amount of tokens owned by `account`.
131      */
132     function balanceOf(address account) external view returns (uint256);
133 
134     /**
135      * @dev Moves `amount` tokens from the caller's account to `recipient`.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transfer(address recipient, uint256 amount) external returns (bool);
142 
143     /**
144      * @dev Returns the remaining number of tokens that `spender` will be
145      * allowed to spend on behalf of `owner` through {transferFrom}. This is
146      * zero by default.
147      *
148      * This value changes when {approve} or {transferFrom} are called.
149      */
150     function allowance(address owner, address spender) external view returns (uint256);
151 
152     /**
153      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * IMPORTANT: Beware that changing an allowance with this method brings the risk
158      * that someone may use both the old and the new allowance by unfortunate
159      * transaction ordering. One possible solution to mitigate this race
160      * condition is to first reduce the spender's allowance to 0 and set the
161      * desired value afterwards:
162      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163      *
164      * Emits an {Approval} event.
165      */
166     function approve(address spender, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Moves `amount` tokens from `sender` to `recipient` using the
170      * allowance mechanism. `amount` is then deducted from the caller's
171      * allowance.
172      *
173      * Returns a boolean value indicating whether the operation succeeded.
174      *
175      * Emits a {Transfer} event.
176      */
177     function transferFrom(
178         address sender,
179         address recipient,
180         uint256 amount
181     ) external returns (bool);
182 
183     /**
184      * @dev Emitted when `value` tokens are moved from one account (`from`) to
185      * another (`to`).
186      *
187      * Note that `value` may be zero.
188      */
189     event Transfer(address indexed from, address indexed to, uint256 value);
190 
191     /**
192      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
193      * a call to {approve}. `value` is the new allowance.
194      */
195     event Approval(address indexed owner, address indexed spender, uint256 value);
196 }
197 
198 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
199 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
200 
201 /* pragma solidity ^0.8.0; */
202 
203 /* import "../IERC20.sol"; */
204 
205 /**
206  * @dev Interface for the optional metadata functions from the ERC20 standard.
207  *
208  * _Available since v4.1._
209  */
210 interface IERC20Metadata is IERC20 {
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the symbol of the token.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the decimals places of the token.
223      */
224     function decimals() external view returns (uint8);
225 }
226 
227 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
228 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
229 
230 /* pragma solidity ^0.8.0; */
231 
232 /* import "./IERC20.sol"; */
233 /* import "./extensions/IERC20Metadata.sol"; */
234 /* import "../../utils/Context.sol"; */
235 
236 /**
237  * @dev Implementation of the {IERC20} interface.
238  *
239  * This implementation is agnostic to the way tokens are created. This means
240  * that a supply mechanism has to be added in a derived contract using {_mint}.
241  * For a generic mechanism see {ERC20PresetMinterPauser}.
242  *
243  * TIP: For a detailed writeup see our guide
244  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
245  * to implement supply mechanisms].
246  *
247  * We have followed general OpenZeppelin Contracts guidelines: functions revert
248  * instead returning `false` on failure. This behavior is nonetheless
249  * conventional and does not conflict with the expectations of ERC20
250  * applications.
251  *
252  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
253  * This allows applications to reconstruct the allowance for all accounts just
254  * by listening to said events. Other implementations of the EIP may not emit
255  * these events, as it isn't required by the specification.
256  *
257  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
258  * functions have been added to mitigate the well-known issues around setting
259  * allowances. See {IERC20-approve}.
260  */
261 contract ERC20 is Context, IERC20, IERC20Metadata {
262     mapping(address => uint256) private _balances;
263 
264     mapping(address => mapping(address => uint256)) private _allowances;
265 
266     uint256 private _totalSupply;
267 
268     string private _name;
269     string private _symbol;
270 
271     /**
272      * @dev Sets the values for {name} and {symbol}.
273      *
274      * The default value of {decimals} is 18. To select a different value for
275      * {decimals} you should overload it.
276      *
277      * All two of these values are immutable: they can only be set once during
278      * construction.
279      */
280     constructor(string memory name_, string memory symbol_) {
281         _name = name_;
282         _symbol = symbol_;
283     }
284 
285     /**
286      * @dev Returns the name of the token.
287      */
288     function name() public view virtual override returns (string memory) {
289         return _name;
290     }
291 
292     /**
293      * @dev Returns the symbol of the token, usually a shorter version of the
294      * name.
295      */
296     function symbol() public view virtual override returns (string memory) {
297         return _symbol;
298     }
299 
300     /**
301      * @dev Returns the number of decimals used to get its user representation.
302      * For example, if `decimals` equals `2`, a balance of `505` tokens should
303      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
304      *
305      * Tokens usually opt for a value of 18, imitating the relationship between
306      * Ether and Wei. This is the value {ERC20} uses, unless this function is
307      * overridden;
308      *
309      * NOTE: This information is only used for _display_ purposes: it in
310      * no way affects any of the arithmetic of the contract, including
311      * {IERC20-balanceOf} and {IERC20-transfer}.
312      */
313     function decimals() public view virtual override returns (uint8) {
314         return 18;
315     }
316 
317     /**
318      * @dev See {IERC20-totalSupply}.
319      */
320     function totalSupply() public view virtual override returns (uint256) {
321         return _totalSupply;
322     }
323 
324     /**
325      * @dev See {IERC20-balanceOf}.
326      */
327     function balanceOf(address account) public view virtual override returns (uint256) {
328         return _balances[account];
329     }
330 
331     /**
332      * @dev See {IERC20-transfer}.
333      *
334      * Requirements:
335      *
336      * - `recipient` cannot be the zero address.
337      * - the caller must have a balance of at least `amount`.
338      */
339     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
340         _transfer(_msgSender(), recipient, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-allowance}.
346      */
347     function allowance(address owner, address spender) public view virtual override returns (uint256) {
348         return _allowances[owner][spender];
349     }
350 
351     /**
352      * @dev See {IERC20-approve}.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function approve(address spender, uint256 amount) public virtual override returns (bool) {
359         _approve(_msgSender(), spender, amount);
360         return true;
361     }
362 
363     /**
364      * @dev See {IERC20-transferFrom}.
365      *
366      * Emits an {Approval} event indicating the updated allowance. This is not
367      * required by the EIP. See the note at the beginning of {ERC20}.
368      *
369      * Requirements:
370      *
371      * - `sender` and `recipient` cannot be the zero address.
372      * - `sender` must have a balance of at least `amount`.
373      * - the caller must have allowance for ``sender``'s tokens of at least
374      * `amount`.
375      */
376     function transferFrom(
377         address sender,
378         address recipient,
379         uint256 amount
380     ) public virtual override returns (bool) {
381         _transfer(sender, recipient, amount);
382 
383         uint256 currentAllowance = _allowances[sender][_msgSender()];
384         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
385         unchecked {
386             _approve(sender, _msgSender(), currentAllowance - amount);
387         }
388 
389         return true;
390     }
391 
392     /**
393      * @dev Atomically increases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
406         return true;
407     }
408 
409     /**
410      * @dev Atomically decreases the allowance granted to `spender` by the caller.
411      *
412      * This is an alternative to {approve} that can be used as a mitigation for
413      * problems described in {IERC20-approve}.
414      *
415      * Emits an {Approval} event indicating the updated allowance.
416      *
417      * Requirements:
418      *
419      * - `spender` cannot be the zero address.
420      * - `spender` must have allowance for the caller of at least
421      * `subtractedValue`.
422      */
423     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
424         uint256 currentAllowance = _allowances[_msgSender()][spender];
425         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
426         unchecked {
427             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
428         }
429 
430         return true;
431     }
432 
433     /**
434      * @dev Moves `amount` of tokens from `sender` to `recipient`.
435      *
436      * This internal function is equivalent to {transfer}, and can be used to
437      * e.g. implement automatic token fees, slashing mechanisms, etc.
438      *
439      * Emits a {Transfer} event.
440      *
441      * Requirements:
442      *
443      * - `sender` cannot be the zero address.
444      * - `recipient` cannot be the zero address.
445      * - `sender` must have a balance of at least `amount`.
446      */
447     function _transfer(
448         address sender,
449         address recipient,
450         uint256 amount
451     ) internal virtual {
452         require(sender != address(0), "ERC20: transfer from the zero address");
453         require(recipient != address(0), "ERC20: transfer to the zero address");
454         
455 
456         _beforeTokenTransfer(sender, recipient, amount);
457 
458         uint256 senderBalance = _balances[sender];
459         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
460         unchecked {
461             _balances[sender] = senderBalance - amount;
462         }
463         _balances[recipient] += amount;
464 
465         emit Transfer(sender, recipient, amount);
466 
467         _afterTokenTransfer(sender, recipient, amount);
468     }
469 
470     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
471      * the total supply.
472      *
473      * Emits a {Transfer} event with `from` set to the zero address.
474      *
475      * Requirements:
476      *
477      * - `account` cannot be the zero address.
478      */
479     function _mint(address account, uint256 amount) internal virtual {
480         require(account != address(0), "ERC20: mint to the zero address");
481 
482         _beforeTokenTransfer(address(0), account, amount);
483 
484         _totalSupply += amount;
485         _balances[account] += amount;
486         emit Transfer(address(0), account, amount);
487 
488         _afterTokenTransfer(address(0), account, amount);
489     }
490 
491     /**
492      * @dev Destroys `amount` tokens from `account`, reducing the
493      * total supply.
494      *
495      * Emits a {Transfer} event with `to` set to the zero address.
496      *
497      * Requirements:
498      *
499      * - `account` cannot be the zero address.
500      * - `account` must have at least `amount` tokens.
501      */
502     function _burn(address account, uint256 amount) internal virtual {
503         require(account != address(0), "ERC20: burn from the zero address");
504 
505         _beforeTokenTransfer(account, address(0), amount);
506 
507         uint256 accountBalance = _balances[account];
508         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
509         unchecked {
510             _balances[account] = accountBalance - amount;
511         }
512         _totalSupply -= amount;
513 
514         emit Transfer(account, address(0), amount);
515 
516         _afterTokenTransfer(account, address(0), amount);
517     }
518 
519     /**
520      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
521      *
522      * This internal function is equivalent to `approve`, and can be used to
523      * e.g. set automatic allowances for certain subsystems, etc.
524      *
525      * Emits an {Approval} event.
526      *
527      * Requirements:
528      *
529      * - `owner` cannot be the zero address.
530      * - `spender` cannot be the zero address.
531      */
532     function _approve(
533         address owner,
534         address spender,
535         uint256 amount
536     ) internal virtual {
537         require(owner != address(0), "ERC20: approve from the zero address");
538         require(spender != address(0), "ERC20: approve to the zero address");
539 
540         _allowances[owner][spender] = amount;
541         emit Approval(owner, spender, amount);
542     }
543 
544     /**
545      * @dev Hook that is called before any transfer of tokens. This includes
546      * minting and burning.
547      *
548      * Calling conditions:
549      *
550      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
551      * will be transferred to `to`.
552      * - when `from` is zero, `amount` tokens will be minted for `to`.
553      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
554      * - `from` and `to` are never both zero.
555      *
556      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
557      */
558     function _beforeTokenTransfer(
559         address from,
560         address to,
561         uint256 amount
562     ) internal virtual {}
563 
564     /**
565      * @dev Hook that is called after any transfer of tokens. This includes
566      * minting and burning.
567      *
568      * Calling conditions:
569      *
570      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
571      * has been transferred to `to`.
572      * - when `from` is zero, `amount` tokens have been minted for `to`.
573      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
574      * - `from` and `to` are never both zero.
575      *
576      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
577      */
578     function _afterTokenTransfer(
579         address from,
580         address to,
581         uint256 amount
582     ) internal virtual {}
583 }
584 
585 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
586 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
587 
588 /* pragma solidity ^0.8.0; */
589 
590 // CAUTION
591 // This version of SafeMath should only be used with Solidity 0.8 or later,
592 // because it relies on the compiler's built in overflow checks.
593 
594 /**
595  * @dev Wrappers over Solidity's arithmetic operations.
596  *
597  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
598  * now has built in overflow checking.
599  */
600 library SafeMath {
601     /**
602      * @dev Returns the addition of two unsigned integers, with an overflow flag.
603      *
604      * _Available since v3.4._
605      */
606     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
607         unchecked {
608             uint256 c = a + b;
609             if (c < a) return (false, 0);
610             return (true, c);
611         }
612     }
613 
614     /**
615      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
616      *
617      * _Available since v3.4._
618      */
619     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             if (b > a) return (false, 0);
622             return (true, a - b);
623         }
624     }
625 
626     /**
627      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
628      *
629      * _Available since v3.4._
630      */
631     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
632         unchecked {
633             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
634             // benefit is lost if 'b' is also tested.
635             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
636             if (a == 0) return (true, 0);
637             uint256 c = a * b;
638             if (c / a != b) return (false, 0);
639             return (true, c);
640         }
641     }
642 
643     /**
644      * @dev Returns the division of two unsigned integers, with a division by zero flag.
645      *
646      * _Available since v3.4._
647      */
648     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
649         unchecked {
650             if (b == 0) return (false, 0);
651             return (true, a / b);
652         }
653     }
654 
655     /**
656      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
657      *
658      * _Available since v3.4._
659      */
660     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
661         unchecked {
662             if (b == 0) return (false, 0);
663             return (true, a % b);
664         }
665     }
666 
667     /**
668      * @dev Returns the addition of two unsigned integers, reverting on
669      * overflow.
670      *
671      * Counterpart to Solidity's `+` operator.
672      *
673      * Requirements:
674      *
675      * - Addition cannot overflow.
676      */
677     function add(uint256 a, uint256 b) internal pure returns (uint256) {
678         return a + b;
679     }
680 
681     /**
682      * @dev Returns the subtraction of two unsigned integers, reverting on
683      * overflow (when the result is negative).
684      *
685      * Counterpart to Solidity's `-` operator.
686      *
687      * Requirements:
688      *
689      * - Subtraction cannot overflow.
690      */
691     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
692         return a - b;
693     }
694 
695     /**
696      * @dev Returns the multiplication of two unsigned integers, reverting on
697      * overflow.
698      *
699      * Counterpart to Solidity's `*` operator.
700      *
701      * Requirements:
702      *
703      * - Multiplication cannot overflow.
704      */
705     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
706         return a * b;
707     }
708 
709     /**
710      * @dev Returns the integer division of two unsigned integers, reverting on
711      * division by zero. The result is rounded towards zero.
712      *
713      * Counterpart to Solidity's `/` operator.
714      *
715      * Requirements:
716      *
717      * - The divisor cannot be zero.
718      */
719     function div(uint256 a, uint256 b) internal pure returns (uint256) {
720         return a / b;
721     }
722 
723     /**
724      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
725      * reverting when dividing by zero.
726      *
727      * Counterpart to Solidity's `%` operator. This function uses a `revert`
728      * opcode (which leaves remaining gas untouched) while Solidity uses an
729      * invalid opcode to revert (consuming all remaining gas).
730      *
731      * Requirements:
732      *
733      * - The divisor cannot be zero.
734      */
735     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
736         return a % b;
737     }
738 
739     /**
740      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
741      * overflow (when the result is negative).
742      *
743      * CAUTION: This function is deprecated because it requires allocating memory for the error
744      * message unnecessarily. For custom revert reasons use {trySub}.
745      *
746      * Counterpart to Solidity's `-` operator.
747      *
748      * Requirements:
749      *
750      * - Subtraction cannot overflow.
751      */
752     function sub(
753         uint256 a,
754         uint256 b,
755         string memory errorMessage
756     ) internal pure returns (uint256) {
757         unchecked {
758             require(b <= a, errorMessage);
759             return a - b;
760         }
761     }
762 
763     /**
764      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
765      * division by zero. The result is rounded towards zero.
766      *
767      * Counterpart to Solidity's `/` operator. Note: this function uses a
768      * `revert` opcode (which leaves remaining gas untouched) while Solidity
769      * uses an invalid opcode to revert (consuming all remaining gas).
770      *
771      * Requirements:
772      *
773      * - The divisor cannot be zero.
774      */
775     function div(
776         uint256 a,
777         uint256 b,
778         string memory errorMessage
779     ) internal pure returns (uint256) {
780         unchecked {
781             require(b > 0, errorMessage);
782             return a / b;
783         }
784     }
785 
786     /**
787      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
788      * reverting with custom message when dividing by zero.
789      *
790      * CAUTION: This function is deprecated because it requires allocating memory for the error
791      * message unnecessarily. For custom revert reasons use {tryMod}.
792      *
793      * Counterpart to Solidity's `%` operator. This function uses a `revert`
794      * opcode (which leaves remaining gas untouched) while Solidity uses an
795      * invalid opcode to revert (consuming all remaining gas).
796      *
797      * Requirements:
798      *
799      * - The divisor cannot be zero.
800      */
801     function mod(
802         uint256 a,
803         uint256 b,
804         string memory errorMessage
805     ) internal pure returns (uint256) {
806         unchecked {
807             require(b > 0, errorMessage);
808             return a % b;
809         }
810     }
811 }
812 
813 ////// src/IUniswapV2Factory.sol
814 /* pragma solidity 0.8.10; */
815 /* pragma experimental ABIEncoderV2; */
816 
817 interface IUniswapV2Factory {
818     event PairCreated(
819         address indexed token0,
820         address indexed token1,
821         address pair,
822         uint256
823     );
824 
825     function feeTo() external view returns (address);
826 
827     function feeToSetter() external view returns (address);
828 
829     function getPair(address tokenA, address tokenB)
830         external
831         view
832         returns (address pair);
833 
834     function allPairs(uint256) external view returns (address pair);
835 
836     function allPairsLength() external view returns (uint256);
837 
838     function createPair(address tokenA, address tokenB)
839         external
840         returns (address pair);
841 
842     function setFeeTo(address) external;
843 
844     function setFeeToSetter(address) external;
845 }
846 
847 ////// src/IUniswapV2Pair.sol
848 /* pragma solidity 0.8.10; */
849 /* pragma experimental ABIEncoderV2; */
850 
851 interface IUniswapV2Pair {
852     event Approval(
853         address indexed owner,
854         address indexed spender,
855         uint256 value
856     );
857     event Transfer(address indexed from, address indexed to, uint256 value);
858 
859     function name() external pure returns (string memory);
860 
861     function symbol() external pure returns (string memory);
862 
863     function decimals() external pure returns (uint8);
864 
865     function totalSupply() external view returns (uint256);
866 
867     function balanceOf(address owner) external view returns (uint256);
868 
869     function allowance(address owner, address spender)
870         external
871         view
872         returns (uint256);
873 
874     function approve(address spender, uint256 value) external returns (bool);
875 
876     function transfer(address to, uint256 value) external returns (bool);
877 
878     function transferFrom(
879         address from,
880         address to,
881         uint256 value
882     ) external returns (bool);
883 
884     function DOMAIN_SEPARATOR() external view returns (bytes32);
885 
886     function PERMIT_TYPEHASH() external pure returns (bytes32);
887 
888     function nonces(address owner) external view returns (uint256);
889 
890     function permit(
891         address owner,
892         address spender,
893         uint256 value,
894         uint256 deadline,
895         uint8 v,
896         bytes32 r,
897         bytes32 s
898     ) external;
899 
900     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
901     event Burn(
902         address indexed sender,
903         uint256 amount0,
904         uint256 amount1,
905         address indexed to
906     );
907     event Swap(
908         address indexed sender,
909         uint256 amount0In,
910         uint256 amount1In,
911         uint256 amount0Out,
912         uint256 amount1Out,
913         address indexed to
914     );
915     event Sync(uint112 reserve0, uint112 reserve1);
916 
917     function MINIMUM_LIQUIDITY() external pure returns (uint256);
918 
919     function factory() external view returns (address);
920 
921     function token0() external view returns (address);
922 
923     function token1() external view returns (address);
924 
925     function getReserves()
926         external
927         view
928         returns (
929             uint112 reserve0,
930             uint112 reserve1,
931             uint32 blockTimestampLast
932         );
933 
934     function price0CumulativeLast() external view returns (uint256);
935 
936     function price1CumulativeLast() external view returns (uint256);
937 
938     function kLast() external view returns (uint256);
939 
940     function mint(address to) external returns (uint256 liquidity);
941 
942     function burn(address to)
943         external
944         returns (uint256 amount0, uint256 amount1);
945 
946     function swap(
947         uint256 amount0Out,
948         uint256 amount1Out,
949         address to,
950         bytes calldata data
951     ) external;
952 
953     function skim(address to) external;
954 
955     function sync() external;
956 
957     function initialize(address, address) external;
958 }
959 
960 ////// src/IUniswapV2Router02.sol
961 /* pragma solidity 0.8.10; */
962 /* pragma experimental ABIEncoderV2; */
963 
964 interface IUniswapV2Router02 {
965     function factory() external pure returns (address);
966 
967     function WETH() external pure returns (address);
968 
969     function addLiquidity(
970         address tokenA,
971         address tokenB,
972         uint256 amountADesired,
973         uint256 amountBDesired,
974         uint256 amountAMin,
975         uint256 amountBMin,
976         address to,
977         uint256 deadline
978     )
979         external
980         returns (
981             uint256 amountA,
982             uint256 amountB,
983             uint256 liquidity
984         );
985 
986     function addLiquidityETH(
987         address token,
988         uint256 amountTokenDesired,
989         uint256 amountTokenMin,
990         uint256 amountETHMin,
991         address to,
992         uint256 deadline
993     )
994         external
995         payable
996         returns (
997             uint256 amountToken,
998             uint256 amountETH,
999             uint256 liquidity
1000         );
1001 
1002     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1003         uint256 amountIn,
1004         uint256 amountOutMin,
1005         address[] calldata path,
1006         address to,
1007         uint256 deadline
1008     ) external;
1009 
1010     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1011         uint256 amountOutMin,
1012         address[] calldata path,
1013         address to,
1014         uint256 deadline
1015     ) external payable;
1016 
1017     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1018         uint256 amountIn,
1019         uint256 amountOutMin,
1020         address[] calldata path,
1021         address to,
1022         uint256 deadline
1023     ) external;
1024 }
1025 
1026 contract DogPad is ERC20, Ownable {
1027     using SafeMath for uint256;
1028 
1029     IUniswapV2Router02 public immutable uniswapV2Router;
1030     address public immutable uniswapV2Pair;
1031     address public constant deadAddress = address(0xdead);
1032     mapping (address => bool) private _blacklist;
1033 
1034     bool private swapping;
1035 
1036     address public marketingWallet;
1037     address public devWallet;
1038 
1039     uint256 public swapTokensAtAmount;
1040 
1041     bool public limitsInEffect = true;
1042     bool public tradingActive = false;
1043     bool public swapEnabled = false;
1044 
1045     // Anti-bot and anti-whale mappings and variables
1046     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1047     bool public transferDelayEnabled = true;
1048 
1049     uint256 public buyTotalFees;
1050     uint256 public buyMarketingFee;
1051     uint256 public buyLiquidityFee;
1052     uint256 public buyDevFee;
1053 
1054     uint256 public sellTotalFees;
1055     uint256 public sellMarketingFee;
1056     uint256 public sellLiquidityFee;
1057     uint256 public sellDevFee;
1058 
1059     uint256 public tokensForMarketing;
1060     uint256 public tokensForLiquidity;
1061     uint256 public tokensForDev;
1062 
1063     /******************/
1064 
1065     // exlcude from fees and max transaction amount
1066     mapping(address => bool) private _isExcludedFromFees;
1067 
1068     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1069     // could be subject to a maximum transfer amount
1070     mapping(address => bool) public automatedMarketMakerPairs;
1071 
1072     event UpdateUniswapV2Router(
1073         address indexed newAddress,
1074         address indexed oldAddress
1075     );
1076 
1077     event ExcludeFromFees(address indexed account, bool isExcluded);
1078 
1079     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1080 
1081     event marketingWalletUpdated(
1082         address indexed newWallet,
1083         address indexed oldWallet
1084     );
1085 
1086     event devWalletUpdated(
1087         address indexed newWallet,
1088         address indexed oldWallet
1089     );
1090 
1091     event SwapAndLiquify(
1092         uint256 tokensSwapped,
1093         uint256 ethReceived,
1094         uint256 tokensIntoLiquidity
1095     );
1096 
1097     event AutoNukeLP();
1098 
1099     event ManualNukeLP();
1100 
1101     constructor() ERC20("DogPad", "DOGPAD") {
1102         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1103             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1104         );
1105 
1106         uniswapV2Router = _uniswapV2Router;
1107 
1108         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1109             .createPair(address(this), _uniswapV2Router.WETH());
1110         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1111 
1112         uint256 _buyMarketingFee = 10;
1113         uint256 _buyLiquidityFee = 0;
1114         uint256 _buyDevFee = 10;
1115 
1116         uint256 _sellMarketingFee = 25;
1117         uint256 _sellLiquidityFee = 0;
1118         uint256 _sellDevFee = 25;
1119 
1120         uint256 totalSupply = 1_000_000_000_000 * 1e18;
1121 
1122         swapTokensAtAmount = (totalSupply * 1) / 500; // 0.2% swap wallet
1123 
1124         buyMarketingFee = _buyMarketingFee;
1125         buyLiquidityFee = _buyLiquidityFee;
1126         buyDevFee = _buyDevFee;
1127         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1128 
1129         sellMarketingFee = _sellMarketingFee;
1130         sellLiquidityFee = _sellLiquidityFee;
1131         sellDevFee = _sellDevFee;
1132         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1133 
1134         marketingWallet = address(0x6B05076ec07263254E1391e9f4ecA7C1dF589091); // set as marketing wallet
1135         devWallet = address(0xb6cAA207f78B074F8D3ff0997c6185937e1841fa); // set as dev wallet
1136 
1137         // exclude from paying fees or having max transaction amount
1138         excludeFromFees(owner(), true);
1139         excludeFromFees(address(this), true);
1140         excludeFromFees(address(0xdead), true);
1141 
1142 
1143         /*
1144             _mint is an internal function in ERC20.sol that is only called here,
1145             and CANNOT be called ever again
1146         */
1147         _mint(msg.sender, totalSupply);
1148     }
1149 
1150     receive() external payable {}
1151 
1152     // once enabled, can never be turned off
1153     function enableTrading() external onlyOwner {
1154         tradingActive = true;
1155         swapEnabled = true;
1156     }
1157 
1158     // remove limits after token is stable
1159     function removeLimits() external onlyOwner returns (bool) {
1160         limitsInEffect = false;
1161         return true;
1162     }
1163 
1164     // disable Transfer delay - cannot be reenabled
1165     function disableTransferDelay() external onlyOwner returns (bool) {
1166         transferDelayEnabled = false;
1167         return true;
1168     }
1169 
1170     // change the minimum amount of tokens to sell from fees
1171     function updateSwapTokensAtAmount(uint256 newAmount)
1172         external
1173         onlyOwner
1174         returns (bool)
1175     {
1176         require(
1177             newAmount >= (totalSupply() * 1) / 100000,
1178             "Swap amount cannot be lower than 0.001% total supply."
1179         );
1180         require(
1181             newAmount <= (totalSupply() * 5) / 1000,
1182             "Swap amount cannot be higher than 0.5% total supply."
1183         );
1184         swapTokensAtAmount = newAmount;
1185         return true;
1186     }
1187 
1188 
1189     // only use to disable contract sales if absolutely necessary (emergency use only)
1190     function updateSwapEnabled(bool enabled) external onlyOwner {
1191         swapEnabled = enabled;
1192     }
1193 
1194     function updateBuyFees(
1195         uint256 _marketingFee,
1196         uint256 _liquidityFee,
1197         uint256 _devFee
1198     ) external onlyOwner {
1199         buyMarketingFee = _marketingFee;
1200         buyLiquidityFee = _liquidityFee;
1201         buyDevFee = _devFee;
1202         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1203         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1204     }
1205 
1206     function updateSellFees(
1207         uint256 _marketingFee,
1208         uint256 _liquidityFee,
1209         uint256 _devFee
1210     ) external onlyOwner {
1211         sellMarketingFee = _marketingFee;
1212         sellLiquidityFee = _liquidityFee;
1213         sellDevFee = _devFee;
1214         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1215         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1216     }
1217 
1218     function excludeFromFees(address account, bool excluded) public onlyOwner {
1219         _isExcludedFromFees[account] = excluded;
1220         emit ExcludeFromFees(account, excluded);
1221     }
1222 
1223     function setAutomatedMarketMakerPair(address pair, bool value)
1224         public
1225         onlyOwner
1226     {
1227         require(
1228             pair != uniswapV2Pair,
1229             "The pair cannot be removed from automatedMarketMakerPairs"
1230         );
1231 
1232         _setAutomatedMarketMakerPair(pair, value);
1233     }
1234 
1235     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1236         automatedMarketMakerPairs[pair] = value;
1237 
1238         emit SetAutomatedMarketMakerPair(pair, value);
1239     }
1240 
1241     function updateMarketingWallet(address newMarketingWallet)
1242         external
1243         onlyOwner
1244     {
1245         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1246         marketingWallet = newMarketingWallet;
1247     }
1248 
1249     function updateDevWallet(address newWallet) external onlyOwner {
1250         emit devWalletUpdated(newWallet, devWallet);
1251         devWallet = newWallet;
1252     }
1253 
1254     function isExcludedFromFees(address account) public view returns (bool) {
1255         return _isExcludedFromFees[account];
1256     }
1257 
1258     event BoughtEarly(address indexed sniper);
1259 
1260     function _transfer(
1261         address from,
1262         address to,
1263         uint256 amount
1264     ) internal override {
1265         require(from != address(0), "ERC20: transfer from the zero address");
1266         require(to != address(0), "ERC20: transfer to the zero address");
1267         require(!_blacklist[from] && !_blacklist[to], "You are a bot");
1268 
1269         if (amount == 0) {
1270             super._transfer(from, to, 0);
1271             return;
1272         }
1273 
1274         if (limitsInEffect) {
1275             if (
1276                 from != owner() &&
1277                 to != owner() &&
1278                 to != address(0) &&
1279                 to != address(0xdead) &&
1280                 !swapping
1281             ) {
1282                 if (!tradingActive) {
1283                     require(
1284                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1285                         "Trading is not active."
1286                     );
1287                 }
1288 
1289                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1290                 if (transferDelayEnabled) {
1291                     if (
1292                         to != owner() &&
1293                         to != address(uniswapV2Router) &&
1294                         to != address(uniswapV2Pair)
1295                     ) {
1296                         require(
1297                             _holderLastTransferTimestamp[tx.origin] <
1298                                 block.number,
1299                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1300                         );
1301                         _holderLastTransferTimestamp[tx.origin] = block.number;
1302                     }
1303                 }
1304             }
1305         }
1306 
1307         uint256 contractTokenBalance = balanceOf(address(this));
1308 
1309         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1310 
1311         if (
1312             canSwap &&
1313             swapEnabled &&
1314             !swapping &&
1315             !automatedMarketMakerPairs[from] &&
1316             !_isExcludedFromFees[from] &&
1317             !_isExcludedFromFees[to]
1318         ) {
1319             swapping = true;
1320 
1321             swapBack();
1322 
1323             swapping = false;
1324         }
1325 
1326         bool takeFee = !swapping;
1327 
1328         // if any account belongs to _isExcludedFromFee account then remove the fee
1329         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1330             takeFee = false;
1331         }
1332 
1333         uint256 fees = 0;
1334         // only take fees on buys/sells, do not take on wallet transfers
1335         if (takeFee) {
1336             // on sell
1337             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1338                 fees = amount.mul(sellTotalFees).div(100);
1339                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1340                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1341                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1342             }
1343             // on buy
1344             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1345                 fees = amount.mul(buyTotalFees).div(100);
1346                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1347                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1348                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1349             }
1350 
1351             if (fees > 0) {
1352                 super._transfer(from, address(this), fees);
1353             }
1354 
1355             amount -= fees;
1356         }
1357 
1358         super._transfer(from, to, amount);
1359     }
1360 
1361     function addBL(address account, bool isBlacklisted) public onlyOwner {
1362         _blacklist[account] = isBlacklisted;
1363     }
1364  
1365     function multiBL(address[] memory multiblacklist_) public onlyOwner {
1366         for (uint256 i = 0; i < multiblacklist_.length; i++) {
1367             _blacklist[multiblacklist_[i]] = true;
1368         }
1369     }
1370 
1371     function swapTokensForEth(uint256 tokenAmount) private {
1372         // generate the uniswap pair path of token -> weth
1373         address[] memory path = new address[](2);
1374         path[0] = address(this);
1375         path[1] = uniswapV2Router.WETH();
1376 
1377         _approve(address(this), address(uniswapV2Router), tokenAmount);
1378 
1379         // make the swap
1380         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1381             tokenAmount,
1382             0, // accept any amount of ETH
1383             path,
1384             address(this),
1385             block.timestamp
1386         );
1387     }
1388 
1389     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1390         // approve token transfer to cover all possible scenarios
1391         _approve(address(this), address(uniswapV2Router), tokenAmount);
1392 
1393         // add the liquidity
1394         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1395             address(this),
1396             tokenAmount,
1397             0, // slippage is unavoidable
1398             0, // slippage is unavoidable
1399             deadAddress,
1400             block.timestamp
1401         );
1402     }
1403 
1404     function swapBack() private {
1405         uint256 contractBalance = balanceOf(address(this));
1406         uint256 totalTokensToSwap = tokensForLiquidity +
1407             tokensForMarketing +
1408             tokensForDev;
1409         bool success;
1410 
1411         if (contractBalance == 0 || totalTokensToSwap == 0) {
1412             return;
1413         }
1414 
1415         if (contractBalance > swapTokensAtAmount * 20) {
1416             contractBalance = swapTokensAtAmount * 20;
1417         }
1418 
1419         // Halve the amount of liquidity tokens
1420         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1421             totalTokensToSwap /
1422             2;
1423         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1424 
1425         uint256 initialETHBalance = address(this).balance;
1426 
1427         swapTokensForEth(amountToSwapForETH);
1428 
1429         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1430 
1431         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1432             totalTokensToSwap
1433         );
1434         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1435 
1436         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1437 
1438         tokensForLiquidity = 0;
1439         tokensForMarketing = 0;
1440         tokensForDev = 0;
1441 
1442         (success, ) = address(devWallet).call{value: ethForDev}("");
1443 
1444         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1445             addLiquidity(liquidityTokens, ethForLiquidity);
1446             emit SwapAndLiquify(
1447                 amountToSwapForETH,
1448                 ethForLiquidity,
1449                 tokensForLiquidity
1450             );
1451         }
1452 
1453         (success, ) = address(marketingWallet).call{
1454             value: address(this).balance
1455         }("");
1456     }
1457 }