1 /**
2 
3 Boomer Coin $BOOMER
4 https://twitter.com/BOOMERerc20
5 
6 https://t.me/BOOMERCOINETH
7 
8 https://boomercoin.vip/
9 
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
15 pragma experimental ABIEncoderV2;
16 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
17 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
18 /* pragma solidity ^0.8.0; */
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
40 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
41 
42 /* pragma solidity ^0.8.0; */
43 
44 /* import "../utils/Context.sol"; */
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
117 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
118 
119 /* pragma solidity ^0.8.0; */
120 
121 /**
122  * @dev Interface of the ERC20 standard as defined in the EIP.
123  */
124 interface IERC20 {
125     /**
126      * @dev Returns the amount of tokens in existence.
127      */
128     function totalSupply() external view returns (uint256);
129 
130     /**
131      * @dev Returns the amount of tokens owned by `account`.
132      */
133     function balanceOf(address account) external view returns (uint256);
134 
135     /**
136      * @dev Moves `amount` tokens from the caller's account to `recipient`.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transfer(address recipient, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Returns the remaining number of tokens that `spender` will be
146      * allowed to spend on behalf of `owner` through {transferFrom}. This is
147      * zero by default.
148      *
149      * This value changes when {approve} or {transferFrom} are called.
150      */
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     /**
154      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * IMPORTANT: Beware that changing an allowance with this method brings the risk
159      * that someone may use both the old and the new allowance by unfortunate
160      * transaction ordering. One possible solution to mitigate this race
161      * condition is to first reduce the spender's allowance to 0 and set the
162      * desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      *
165      * Emits an {Approval} event.
166      */
167     function approve(address spender, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Moves `amount` tokens from `sender` to `recipient` using the
171      * allowance mechanism. `amount` is then deducted from the caller's
172      * allowance.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transferFrom(
179         address sender,
180         address recipient,
181         uint256 amount
182     ) external returns (bool);
183 
184     /**
185      * @dev Emitted when `value` tokens are moved from one account (`from`) to
186      * another (`to`).
187      *
188      * Note that `value` may be zero.
189      */
190     event Transfer(address indexed from, address indexed to, uint256 value);
191 
192     /**
193      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
194      * a call to {approve}. `value` is the new allowance.
195      */
196     event Approval(address indexed owner, address indexed spender, uint256 value);
197 }
198 
199 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
200 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
201 
202 /* pragma solidity ^0.8.0; */
203 
204 /* import "../IERC20.sol"; */
205 
206 /**
207  * @dev Interface for the optional metadata functions from the ERC20 standard.
208  *
209  * _Available since v4.1._
210  */
211 interface IERC20Metadata is IERC20 {
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() external view returns (string memory);
216 
217     /**
218      * @dev Returns the symbol of the token.
219      */
220     function symbol() external view returns (string memory);
221 
222     /**
223      * @dev Returns the decimals places of the token.
224      */
225     function decimals() external view returns (uint8);
226 }
227 
228 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
229 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
230 
231 /* pragma solidity ^0.8.0; */
232 
233 /* import "./IERC20.sol"; */
234 /* import "./extensions/IERC20Metadata.sol"; */
235 /* import "../../utils/Context.sol"; */
236 
237 /**
238  * @dev Implementation of the {IERC20} interface.
239  *
240  * This implementation is agnostic to the way tokens are created. This means
241  * that a supply mechanism has to be added in a derived contract using {_mint}.
242  * For a generic mechanism see {ERC20PresetMinterPauser}.
243  *
244  * TIP: For a detailed writeup see our guide
245  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
246  * to implement supply mechanisms].
247  *
248  * We have followed general OpenZeppelin Contracts guidelines: functions revert
249  * instead returning `false` on failure. This behavior is nonetheless
250  * conventional and does not conflict with the expectations of ERC20
251  * applications.
252  *
253  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
254  * This allows applications to reconstruct the allowance for all accounts just
255  * by listening to said events. Other implementations of the EIP may not emit
256  * these events, as it isn't required by the specification.
257  *
258  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
259  * functions have been added to mitigate the well-known issues around setting
260  * allowances. See {IERC20-approve}.
261  */
262 contract ERC20 is Context, IERC20, IERC20Metadata {
263     mapping(address => uint256) private _balances;
264 
265     mapping(address => mapping(address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     string private _name;
270     string private _symbol;
271 
272     /**
273      * @dev Sets the values for {name} and {symbol}.
274      *
275      * The default value of {decimals} is 18. To select a different value for
276      * {decimals} you should overload it.
277      *
278      * All two of these values are immutable: they can only be set once during
279      * construction.
280      */
281     constructor(string memory name_, string memory symbol_) {
282         _name = name_;
283         _symbol = symbol_;
284     }
285 
286     /**
287      * @dev Returns the name of the token.
288      */
289     function name() public view virtual override returns (string memory) {
290         return _name;
291     }
292 
293     /**
294      * @dev Returns the symbol of the token, usually a shorter version of the
295      * name.
296      */
297     function symbol() public view virtual override returns (string memory) {
298         return _symbol;
299     }
300 
301     /**
302      * @dev Returns the number of decimals used to get its user representation.
303      * For example, if `decimals` equals `2`, a balance of `505` tokens should
304      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
305      *
306      * Tokens usually opt for a value of 18, imitating the relationship between
307      * Ether and Wei. This is the value {ERC20} uses, unless this function is
308      * overridden;
309      *
310      * NOTE: This information is only used for _display_ purposes: it in
311      * no way affects any of the arithmetic of the contract, including
312      * {IERC20-balanceOf} and {IERC20-transfer}.
313      */
314     function decimals() public view virtual override returns (uint8) {
315         return 18;
316     }
317 
318     /**
319      * @dev See {IERC20-totalSupply}.
320      */
321     function totalSupply() public view virtual override returns (uint256) {
322         return _totalSupply;
323     }
324 
325     /**
326      * @dev See {IERC20-balanceOf}.
327      */
328     function balanceOf(address account) public view virtual override returns (uint256) {
329         return _balances[account];
330     }
331 
332     /**
333      * @dev See {IERC20-transfer}.
334      *
335      * Requirements:
336      *
337      * - `recipient` cannot be the zero address.
338      * - the caller must have a balance of at least `amount`.
339      */
340     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
341         _transfer(_msgSender(), recipient, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-allowance}.
347      */
348     function allowance(address owner, address spender) public view virtual override returns (uint256) {
349         return _allowances[owner][spender];
350     }
351 
352     /**
353      * @dev See {IERC20-approve}.
354      *
355      * Requirements:
356      *
357      * - `spender` cannot be the zero address.
358      */
359     function approve(address spender, uint256 amount) public virtual override returns (bool) {
360         _approve(_msgSender(), spender, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-transferFrom}.
366      *
367      * Emits an {Approval} event indicating the updated allowance. This is not
368      * required by the EIP. See the note at the beginning of {ERC20}.
369      *
370      * Requirements:
371      *
372      * - `sender` and `recipient` cannot be the zero address.
373      * - `sender` must have a balance of at least `amount`.
374      * - the caller must have allowance for ``sender``'s tokens of at least
375      * `amount`.
376      */
377     function transferFrom(
378         address sender,
379         address recipient,
380         uint256 amount
381     ) public virtual override returns (bool) {
382         _transfer(sender, recipient, amount);
383 
384         uint256 currentAllowance = _allowances[sender][_msgSender()];
385         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
386         unchecked {
387             _approve(sender, _msgSender(), currentAllowance - amount);
388         }
389 
390         return true;
391     }
392 
393     /**
394      * @dev Atomically increases the allowance granted to `spender` by the caller.
395      *
396      * This is an alternative to {approve} that can be used as a mitigation for
397      * problems described in {IERC20-approve}.
398      *
399      * Emits an {Approval} event indicating the updated allowance.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      */
405     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
406         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
407         return true;
408     }
409 
410     /**
411      * @dev Atomically decreases the allowance granted to `spender` by the caller.
412      *
413      * This is an alternative to {approve} that can be used as a mitigation for
414      * problems described in {IERC20-approve}.
415      *
416      * Emits an {Approval} event indicating the updated allowance.
417      *
418      * Requirements:
419      *
420      * - `spender` cannot be the zero address.
421      * - `spender` must have allowance for the caller of at least
422      * `subtractedValue`.
423      */
424     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
425         uint256 currentAllowance = _allowances[_msgSender()][spender];
426         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
427         unchecked {
428             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
429         }
430 
431         return true;
432     }
433 
434     /**
435      * @dev Moves `amount` of tokens from `sender` to `recipient`.
436      *
437      * This internal function is equivalent to {transfer}, and can be used to
438      * e.g. implement automatic token fees, slashing mechanisms, etc.
439      *
440      * Emits a {Transfer} event.
441      *
442      * Requirements:
443      *
444      * - `sender` cannot be the zero address.
445      * - `recipient` cannot be the zero address.
446      * - `sender` must have a balance of at least `amount`.
447      */
448     function _transfer(
449         address sender,
450         address recipient,
451         uint256 amount
452     ) internal virtual {
453         require(sender != address(0), "ERC20: transfer from the zero address");
454         require(recipient != address(0), "ERC20: transfer to the zero address");
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
813 /* pragma solidity 0.8.10; */
814 /* pragma experimental ABIEncoderV2; */
815 
816 interface IUniswapV2Factory {
817     event PairCreated(
818         address indexed token0,
819         address indexed token1,
820         address pair,
821         uint256
822     );
823 
824     function feeTo() external view returns (address);
825 
826     function feeToSetter() external view returns (address);
827 
828     function getPair(address tokenA, address tokenB)
829         external
830         view
831         returns (address pair);
832 
833     function allPairs(uint256) external view returns (address pair);
834 
835     function allPairsLength() external view returns (uint256);
836 
837     function createPair(address tokenA, address tokenB)
838         external
839         returns (address pair);
840 
841     function setFeeTo(address) external;
842 
843     function setFeeToSetter(address) external;
844 }
845 
846 /* pragma solidity 0.8.10; */
847 /* pragma experimental ABIEncoderV2; */ 
848 
849 interface IUniswapV2Pair {
850     event Approval(
851         address indexed owner,
852         address indexed spender,
853         uint256 value
854     );
855     event Transfer(address indexed from, address indexed to, uint256 value);
856 
857     function name() external pure returns (string memory);
858 
859     function symbol() external pure returns (string memory);
860 
861     function decimals() external pure returns (uint8);
862 
863     function totalSupply() external view returns (uint256);
864 
865     function balanceOf(address owner) external view returns (uint256);
866 
867     function allowance(address owner, address spender)
868         external
869         view
870         returns (uint256);
871 
872     function approve(address spender, uint256 value) external returns (bool);
873 
874     function transfer(address to, uint256 value) external returns (bool);
875 
876     function transferFrom(
877         address from,
878         address to,
879         uint256 value
880     ) external returns (bool);
881 
882     function DOMAIN_SEPARATOR() external view returns (bytes32);
883 
884     function PERMIT_TYPEHASH() external pure returns (bytes32);
885 
886     function nonces(address owner) external view returns (uint256);
887 
888     function permit(
889         address owner,
890         address spender,
891         uint256 value,
892         uint256 deadline,
893         uint8 v,
894         bytes32 r,
895         bytes32 s
896     ) external;
897 
898     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
899     event Burn(
900         address indexed sender,
901         uint256 amount0,
902         uint256 amount1,
903         address indexed to
904     );
905     event Swap(
906         address indexed sender,
907         uint256 amount0In,
908         uint256 amount1In,
909         uint256 amount0Out,
910         uint256 amount1Out,
911         address indexed to
912     );
913     event Sync(uint112 reserve0, uint112 reserve1);
914 
915     function MINIMUM_LIQUIDITY() external pure returns (uint256);
916 
917     function factory() external view returns (address);
918 
919     function token0() external view returns (address);
920 
921     function token1() external view returns (address);
922 
923     function getReserves()
924         external
925         view
926         returns (
927             uint112 reserve0,
928             uint112 reserve1,
929             uint32 blockTimestampLast
930         );
931 
932     function price0CumulativeLast() external view returns (uint256);
933 
934     function price1CumulativeLast() external view returns (uint256);
935 
936     function kLast() external view returns (uint256);
937 
938     function mint(address to) external returns (uint256 liquidity);
939 
940     function burn(address to)
941         external
942         returns (uint256 amount0, uint256 amount1);
943 
944     function swap(
945         uint256 amount0Out,
946         uint256 amount1Out,
947         address to,
948         bytes calldata data
949     ) external;
950 
951     function skim(address to) external;
952 
953     function sync() external;
954 
955     function initialize(address, address) external;
956 }
957 
958 /* pragma solidity 0.8.10; */
959 /* pragma experimental ABIEncoderV2; */
960 
961 interface IUniswapV2Router02 {
962     function factory() external pure returns (address);
963 
964     function WETH() external pure returns (address);
965 
966     function addLiquidity(
967         address tokenA,
968         address tokenB,
969         uint256 amountADesired,
970         uint256 amountBDesired,
971         uint256 amountAMin,
972         uint256 amountBMin,
973         address to,
974         uint256 deadline
975     )
976         external
977         returns (
978             uint256 amountA,
979             uint256 amountB,
980             uint256 liquidity
981         );
982 
983     function addLiquidityETH(
984         address token,
985         uint256 amountTokenDesired,
986         uint256 amountTokenMin,
987         uint256 amountETHMin,
988         address to,
989         uint256 deadline
990     )
991         external
992         payable
993         returns (
994             uint256 amountToken,
995             uint256 amountETH,
996             uint256 liquidity
997         );
998 
999     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1000         uint256 amountIn,
1001         uint256 amountOutMin,
1002         address[] calldata path,
1003         address to,
1004         uint256 deadline
1005     ) external;
1006 
1007     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1008         uint256 amountOutMin,
1009         address[] calldata path,
1010         address to,
1011         uint256 deadline
1012     ) external payable;
1013 
1014     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1015         uint256 amountIn,
1016         uint256 amountOutMin,
1017         address[] calldata path,
1018         address to,
1019         uint256 deadline
1020     ) external;
1021 }
1022 
1023 /* pragma solidity >=0.8.10; */
1024 
1025 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1026 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1027 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1028 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1029 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1030 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1031 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1032 
1033 contract BOOMERCOIN is ERC20, Ownable {
1034     using SafeMath for uint256;
1035 
1036     IUniswapV2Router02 public immutable uniswapV2Router;
1037     address public immutable uniswapV2Pair;
1038     address public constant deadAddress = address(0xdead);
1039 
1040     bool private swapping;
1041 
1042 	address public charityWallet;
1043     address public marketingWallet;
1044     address public devWallet;
1045 
1046     uint256 public maxTransactionAmount;
1047     uint256 public swapTokensAtAmount;
1048     uint256 public maxWallet;
1049 
1050     bool public limitsInEffect = true;
1051     bool public tradingActive = true;
1052     bool public swapEnabled = true;
1053 
1054     // Anti-bot and anti-whale mappings and variables
1055     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1056     bool public transferDelayEnabled = true;
1057 
1058     uint256 public buyTotalFees;
1059 	uint256 public buyCharityFee;
1060     uint256 public buyMarketingFee;
1061     uint256 public buyLiquidityFee;
1062     uint256 public buyDevFee;
1063 
1064     uint256 public sellTotalFees;
1065 	uint256 public sellCharityFee;
1066     uint256 public sellMarketingFee;
1067     uint256 public sellLiquidityFee;
1068     uint256 public sellDevFee;
1069 
1070 	uint256 public tokensForCharity;
1071     uint256 public tokensForMarketing;
1072     uint256 public tokensForLiquidity;
1073     uint256 public tokensForDev;
1074 
1075     /******************/
1076 
1077     // exlcude from fees and max transaction amount
1078     mapping(address => bool) private _isExcludedFromFees;
1079     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1080 
1081     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1082     // could be subject to a maximum transfer amount
1083     mapping(address => bool) public automatedMarketMakerPairs;
1084 
1085     event UpdateUniswapV2Router(
1086         address indexed newAddress,
1087         address indexed oldAddress
1088     );
1089 
1090     event ExcludeFromFees(address indexed account, bool isExcluded);
1091 
1092     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1093 
1094     event SwapAndLiquify(
1095         uint256 tokensSwapped,
1096         uint256 ethReceived,
1097         uint256 tokensIntoLiquidity
1098     );
1099 
1100     constructor() ERC20("Boomer", "BOOMER") {
1101         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1102             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1103         );
1104 
1105         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1106         uniswapV2Router = _uniswapV2Router;
1107 
1108         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1109             .createPair(address(this), _uniswapV2Router.WETH());
1110         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1111         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1112 
1113 		uint256 _buyCharityFee = 12;
1114         uint256 _buyMarketingFee = 12;
1115         uint256 _buyLiquidityFee = 0;
1116         uint256 _buyDevFee = 0;
1117 
1118 		uint256 _sellCharityFee = 12;
1119         uint256 _sellMarketingFee = 12;
1120         uint256 _sellLiquidityFee = 0;
1121         uint256 _sellDevFee = 0;
1122 
1123         uint256 totalSupply = 694204200 * 1e18;
1124 
1125         maxTransactionAmount = 21000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1126         maxWallet = 21000000 * 1e18; // 2% from total supply maxWallet
1127         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1128 
1129 		buyCharityFee = _buyCharityFee;
1130         buyMarketingFee = _buyMarketingFee;
1131         buyLiquidityFee = _buyLiquidityFee;
1132         buyDevFee = _buyDevFee;
1133         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1134 
1135 		sellCharityFee = _sellCharityFee;
1136         sellMarketingFee = _sellMarketingFee;
1137         sellLiquidityFee = _sellLiquidityFee;
1138         sellDevFee = _sellDevFee;
1139         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1140 
1141 		charityWallet = address(0xA86E826ec3B22b28ec6f2773cB677654517d7d8A); // set as charity wallet
1142         marketingWallet = address(0xA86E826ec3B22b28ec6f2773cB677654517d7d8A); // set as marketing wallet
1143         devWallet = address(0xA86E826ec3B22b28ec6f2773cB677654517d7d8A); // set as dev wallet
1144 
1145         // exclude from paying fees or having max transaction amount
1146         excludeFromFees(owner(), true);
1147         excludeFromFees(address(this), true);
1148         excludeFromFees(address(0xdead), true);
1149 
1150         excludeFromMaxTransaction(owner(), true);
1151         excludeFromMaxTransaction(address(this), true);
1152         excludeFromMaxTransaction(address(0xdead), true);
1153 
1154         /*
1155             _mint is an internal function in ERC20.sol that is only called here,
1156             and CANNOT be called ever again
1157         */
1158         _mint(msg.sender, totalSupply);
1159     }
1160 
1161     receive() external payable {}
1162 
1163     // once enabled, can never be turned off
1164     function enableTrading() external onlyOwner {
1165         tradingActive = true;
1166         swapEnabled = true;
1167     }
1168 
1169     // remove limits after token is stable
1170     function removeLimits() external onlyOwner returns (bool) {
1171         limitsInEffect = false;
1172         return true;
1173     }
1174 
1175     // disable Transfer delay - cannot be reenabled
1176     function disableTransferDelay() external onlyOwner returns (bool) {
1177         transferDelayEnabled = false;
1178         return true;
1179     }
1180 
1181     // change the minimum amount of tokens to sell from fees
1182     function updateSwapTokensAtAmount(uint256 newAmount)
1183         external
1184         onlyOwner
1185         returns (bool)
1186     {
1187         require(
1188             newAmount >= (totalSupply() * 1) / 100000,
1189             "Swap amount cannot be lower than 0.001% total supply."
1190         );
1191         require(
1192             newAmount <= (totalSupply() * 5) / 1000,
1193             "Swap amount cannot be higher than 0.5% total supply."
1194         );
1195         swapTokensAtAmount = newAmount;
1196         return true;
1197     }
1198 
1199     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1200         require(
1201             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1202             "Cannot set maxTransactionAmount lower than 0.5%"
1203         );
1204         maxTransactionAmount = newNum * (10**18);
1205     }
1206 
1207     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1208         require(
1209             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1210             "Cannot set maxWallet lower than 0.5%"
1211         );
1212         maxWallet = newNum * (10**18);
1213     }
1214 	
1215     function excludeFromMaxTransaction(address updAds, bool isEx)
1216         public
1217         onlyOwner
1218     {
1219         _isExcludedMaxTransactionAmount[updAds] = isEx;
1220     }
1221 
1222     // only use to disable contract sales if absolutely necessary (emergency use only)
1223     function updateSwapEnabled(bool enabled) external onlyOwner {
1224         swapEnabled = enabled;
1225     }
1226 
1227     function updateBuyFees(
1228 		uint256 _charityFee,
1229         uint256 _marketingFee,
1230         uint256 _liquidityFee,
1231         uint256 _devFee
1232     ) external onlyOwner {
1233 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1234 		buyCharityFee = _charityFee;
1235         buyMarketingFee = _marketingFee;
1236         buyLiquidityFee = _liquidityFee;
1237         buyDevFee = _devFee;
1238         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1239      }
1240 
1241     function updateSellFees(
1242 		uint256 _charityFee,
1243         uint256 _marketingFee,
1244         uint256 _liquidityFee,
1245         uint256 _devFee
1246     ) external onlyOwner {
1247 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1248 		sellCharityFee = _charityFee;
1249         sellMarketingFee = _marketingFee;
1250         sellLiquidityFee = _liquidityFee;
1251         sellDevFee = _devFee;
1252         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1253     }
1254 
1255     function excludeFromFees(address account, bool excluded) public onlyOwner {
1256         _isExcludedFromFees[account] = excluded;
1257         emit ExcludeFromFees(account, excluded);
1258     }
1259 
1260     function setAutomatedMarketMakerPair(address pair, bool value)
1261         public
1262         onlyOwner
1263     {
1264         require(
1265             pair != uniswapV2Pair,
1266             "The pair cannot be removed from automatedMarketMakerPairs"
1267         );
1268 
1269         _setAutomatedMarketMakerPair(pair, value);
1270     }
1271 
1272     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1273         automatedMarketMakerPairs[pair] = value;
1274 
1275         emit SetAutomatedMarketMakerPair(pair, value);
1276     }
1277 
1278     function isExcludedFromFees(address account) public view returns (bool) {
1279         return _isExcludedFromFees[account];
1280     }
1281 
1282     function _transfer(
1283         address from,
1284         address to,
1285         uint256 amount
1286     ) internal override {
1287         require(from != address(0), "ERC20: transfer from the zero address");
1288         require(to != address(0), "ERC20: transfer to the zero address");
1289 
1290         if (amount == 0) {
1291             super._transfer(from, to, 0);
1292             return;
1293         }
1294 
1295         if (limitsInEffect) {
1296             if (
1297                 from != owner() &&
1298                 to != owner() &&
1299                 to != address(0) &&
1300                 to != address(0xdead) &&
1301                 !swapping
1302             ) {
1303                 if (!tradingActive) {
1304                     require(
1305                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1306                         "Trading is not active."
1307                     );
1308                 }
1309 
1310                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1311                 if (transferDelayEnabled) {
1312                     if (
1313                         to != owner() &&
1314                         to != address(uniswapV2Router) &&
1315                         to != address(uniswapV2Pair)
1316                     ) {
1317                         require(
1318                             _holderLastTransferTimestamp[tx.origin] <
1319                                 block.number,
1320                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1321                         );
1322                         _holderLastTransferTimestamp[tx.origin] = block.number;
1323                     }
1324                 }
1325 
1326                 //when buy
1327                 if (
1328                     automatedMarketMakerPairs[from] &&
1329                     !_isExcludedMaxTransactionAmount[to]
1330                 ) {
1331                     require(
1332                         amount <= maxTransactionAmount,
1333                         "Buy transfer amount exceeds the maxTransactionAmount."
1334                     );
1335                     require(
1336                         amount + balanceOf(to) <= maxWallet,
1337                         "Max wallet exceeded"
1338                     );
1339                 }
1340                 //when sell
1341                 else if (
1342                     automatedMarketMakerPairs[to] &&
1343                     !_isExcludedMaxTransactionAmount[from]
1344                 ) {
1345                     require(
1346                         amount <= maxTransactionAmount,
1347                         "Sell transfer amount exceeds the maxTransactionAmount."
1348                     );
1349                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1350                     require(
1351                         amount + balanceOf(to) <= maxWallet,
1352                         "Max wallet exceeded"
1353                     );
1354                 }
1355             }
1356         }
1357 
1358         uint256 contractTokenBalance = balanceOf(address(this));
1359 
1360         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1361 
1362         if (
1363             canSwap &&
1364             swapEnabled &&
1365             !swapping &&
1366             !automatedMarketMakerPairs[from] &&
1367             !_isExcludedFromFees[from] &&
1368             !_isExcludedFromFees[to]
1369         ) {
1370             swapping = true;
1371 
1372             swapBack();
1373 
1374             swapping = false;
1375         }
1376 
1377         bool takeFee = !swapping;
1378 
1379         // if any account belongs to _isExcludedFromFee account then remove the fee
1380         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1381             takeFee = false;
1382         }
1383 
1384         uint256 fees = 0;
1385         // only take fees on buys/sells, do not take on wallet transfers
1386         if (takeFee) {
1387             // on sell
1388             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1389                 fees = amount.mul(sellTotalFees).div(100);
1390 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1391                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1392                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1393                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1394             }
1395             // on buy
1396             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1397                 fees = amount.mul(buyTotalFees).div(100);
1398 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1399                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1400                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1401                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1402             }
1403 
1404             if (fees > 0) {
1405                 super._transfer(from, address(this), fees);
1406             }
1407 
1408             amount -= fees;
1409         }
1410 
1411         super._transfer(from, to, amount);
1412     }
1413 
1414     function swapTokensForEth(uint256 tokenAmount) private {
1415         // generate the uniswap pair path of token -> weth
1416         address[] memory path = new address[](2);
1417         path[0] = address(this);
1418         path[1] = uniswapV2Router.WETH();
1419 
1420         _approve(address(this), address(uniswapV2Router), tokenAmount);
1421 
1422         // make the swap
1423         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1424             tokenAmount,
1425             0, // accept any amount of ETH
1426             path,
1427             address(this),
1428             block.timestamp
1429         );
1430     }
1431 
1432     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1433         // approve token transfer to cover all possible scenarios
1434         _approve(address(this), address(uniswapV2Router), tokenAmount);
1435 
1436         // add the liquidity
1437         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1438             address(this),
1439             tokenAmount,
1440             0, // slippage is unavoidable
1441             0, // slippage is unavoidable
1442             devWallet,
1443             block.timestamp
1444         );
1445     }
1446 
1447     function swapBack() private {
1448         uint256 contractBalance = balanceOf(address(this));
1449         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1450         bool success;
1451 
1452         if (contractBalance == 0 || totalTokensToSwap == 0) {
1453             return;
1454         }
1455 
1456         if (contractBalance > swapTokensAtAmount * 20) {
1457             contractBalance = swapTokensAtAmount * 20;
1458         }
1459 
1460         // Halve the amount of liquidity tokens
1461         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1462         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1463 
1464         uint256 initialETHBalance = address(this).balance;
1465 
1466         swapTokensForEth(amountToSwapForETH);
1467 
1468         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1469 
1470 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1471         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1472         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1473 
1474         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1475 
1476         tokensForLiquidity = 0;
1477 		tokensForCharity = 0;
1478         tokensForMarketing = 0;
1479         tokensForDev = 0;
1480 
1481         (success, ) = address(devWallet).call{value: ethForDev}("");
1482         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1483 
1484 
1485         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1486             addLiquidity(liquidityTokens, ethForLiquidity);
1487             emit SwapAndLiquify(
1488                 amountToSwapForETH,
1489                 ethForLiquidity,
1490                 tokensForLiquidity
1491             );
1492         }
1493 
1494         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1495     }
1496 
1497 }