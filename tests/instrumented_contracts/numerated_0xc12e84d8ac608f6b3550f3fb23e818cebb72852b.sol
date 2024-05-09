1 /**
2 https://twitter.com/elonmusk/status/1122675277966872576
3 https://t.me/HamletERC
4 */
5 
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
10 
11 
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
455         _beforeTokenTransfer(sender, recipient, amount);
456 
457         uint256 senderBalance = _balances[sender];
458         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
459         unchecked {
460             _balances[sender] = senderBalance - amount;
461         }
462         _balances[recipient] += amount;
463 
464         emit Transfer(sender, recipient, amount);
465 
466         _afterTokenTransfer(sender, recipient, amount);
467     }
468 
469     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
470      * the total supply.
471      *
472      * Emits a {Transfer} event with `from` set to the zero address.
473      *
474      * Requirements:
475      *
476      * - `account` cannot be the zero address.
477      */
478     function _mint(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: mint to the zero address");
480 
481         _beforeTokenTransfer(address(0), account, amount);
482 
483         _totalSupply += amount;
484         _balances[account] += amount;
485         emit Transfer(address(0), account, amount);
486 
487         _afterTokenTransfer(address(0), account, amount);
488     }
489 
490     /**
491      * @dev Destroys `amount` tokens from `account`, reducing the
492      * total supply.
493      *
494      * Emits a {Transfer} event with `to` set to the zero address.
495      *
496      * Requirements:
497      *
498      * - `account` cannot be the zero address.
499      * - `account` must have at least `amount` tokens.
500      */
501     function _burn(address account, uint256 amount) internal virtual {
502         require(account != address(0), "ERC20: burn from the zero address");
503 
504         _beforeTokenTransfer(account, address(0), amount);
505 
506         uint256 accountBalance = _balances[account];
507         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
508         unchecked {
509             _balances[account] = accountBalance - amount;
510         }
511         _totalSupply -= amount;
512 
513         emit Transfer(account, address(0), amount);
514 
515         _afterTokenTransfer(account, address(0), amount);
516     }
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
520      *
521      * This internal function is equivalent to `approve`, and can be used to
522      * e.g. set automatic allowances for certain subsystems, etc.
523      *
524      * Emits an {Approval} event.
525      *
526      * Requirements:
527      *
528      * - `owner` cannot be the zero address.
529      * - `spender` cannot be the zero address.
530      */
531     function _approve(
532         address owner,
533         address spender,
534         uint256 amount
535     ) internal virtual {
536         require(owner != address(0), "ERC20: approve from the zero address");
537         require(spender != address(0), "ERC20: approve to the zero address");
538 
539         _allowances[owner][spender] = amount;
540         emit Approval(owner, spender, amount);
541     }
542 
543     /**
544      * @dev Hook that is called before any transfer of tokens. This includes
545      * minting and burning.
546      *
547      * Calling conditions:
548      *
549      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
550      * will be transferred to `to`.
551      * - when `from` is zero, `amount` tokens will be minted for `to`.
552      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
553      * - `from` and `to` are never both zero.
554      *
555      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
556      */
557     function _beforeTokenTransfer(
558         address from,
559         address to,
560         uint256 amount
561     ) internal virtual {}
562 
563     /**
564      * @dev Hook that is called after any transfer of tokens. This includes
565      * minting and burning.
566      *
567      * Calling conditions:
568      *
569      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
570      * has been transferred to `to`.
571      * - when `from` is zero, `amount` tokens have been minted for `to`.
572      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
573      * - `from` and `to` are never both zero.
574      *
575      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
576      */
577     function _afterTokenTransfer(
578         address from,
579         address to,
580         uint256 amount
581     ) internal virtual {}
582 }
583 
584 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
585 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
586 
587 /* pragma solidity ^0.8.0; */
588 
589 // CAUTION
590 // This version of SafeMath should only be used with Solidity 0.8 or later,
591 // because it relies on the compiler's built in overflow checks.
592 
593 /**
594  * @dev Wrappers over Solidity's arithmetic operations.
595  *
596  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
597  * now has built in overflow checking.
598  */
599 library SafeMath {
600     /**
601      * @dev Returns the addition of two unsigned integers, with an overflow flag.
602      *
603      * _Available since v3.4._
604      */
605     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
606         unchecked {
607             uint256 c = a + b;
608             if (c < a) return (false, 0);
609             return (true, c);
610         }
611     }
612 
613     /**
614      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
615      *
616      * _Available since v3.4._
617      */
618     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
619         unchecked {
620             if (b > a) return (false, 0);
621             return (true, a - b);
622         }
623     }
624 
625     /**
626      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
627      *
628      * _Available since v3.4._
629      */
630     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
631         unchecked {
632             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
633             // benefit is lost if 'b' is also tested.
634             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
635             if (a == 0) return (true, 0);
636             uint256 c = a * b;
637             if (c / a != b) return (false, 0);
638             return (true, c);
639         }
640     }
641 
642     /**
643      * @dev Returns the division of two unsigned integers, with a division by zero flag.
644      *
645      * _Available since v3.4._
646      */
647     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
648         unchecked {
649             if (b == 0) return (false, 0);
650             return (true, a / b);
651         }
652     }
653 
654     /**
655      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
656      *
657      * _Available since v3.4._
658      */
659     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
660         unchecked {
661             if (b == 0) return (false, 0);
662             return (true, a % b);
663         }
664     }
665 
666     /**
667      * @dev Returns the addition of two unsigned integers, reverting on
668      * overflow.
669      *
670      * Counterpart to Solidity's `+` operator.
671      *
672      * Requirements:
673      *
674      * - Addition cannot overflow.
675      */
676     function add(uint256 a, uint256 b) internal pure returns (uint256) {
677         return a + b;
678     }
679 
680     /**
681      * @dev Returns the subtraction of two unsigned integers, reverting on
682      * overflow (when the result is negative).
683      *
684      * Counterpart to Solidity's `-` operator.
685      *
686      * Requirements:
687      *
688      * - Subtraction cannot overflow.
689      */
690     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
691         return a - b;
692     }
693 
694     /**
695      * @dev Returns the multiplication of two unsigned integers, reverting on
696      * overflow.
697      *
698      * Counterpart to Solidity's `*` operator.
699      *
700      * Requirements:
701      *
702      * - Multiplication cannot overflow.
703      */
704     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
705         return a * b;
706     }
707 
708     /**
709      * @dev Returns the integer division of two unsigned integers, reverting on
710      * division by zero. The result is rounded towards zero.
711      *
712      * Counterpart to Solidity's `/` operator.
713      *
714      * Requirements:
715      *
716      * - The divisor cannot be zero.
717      */
718     function div(uint256 a, uint256 b) internal pure returns (uint256) {
719         return a / b;
720     }
721 
722     /**
723      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
724      * reverting when dividing by zero.
725      *
726      * Counterpart to Solidity's `%` operator. This function uses a `revert`
727      * opcode (which leaves remaining gas untouched) while Solidity uses an
728      * invalid opcode to revert (consuming all remaining gas).
729      *
730      * Requirements:
731      *
732      * - The divisor cannot be zero.
733      */
734     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
735         return a % b;
736     }
737 
738     /**
739      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
740      * overflow (when the result is negative).
741      *
742      * CAUTION: This function is deprecated because it requires allocating memory for the error
743      * message unnecessarily. For custom revert reasons use {trySub}.
744      *
745      * Counterpart to Solidity's `-` operator.
746      *
747      * Requirements:
748      *
749      * - Subtraction cannot overflow.
750      */
751     function sub(
752         uint256 a,
753         uint256 b,
754         string memory errorMessage
755     ) internal pure returns (uint256) {
756         unchecked {
757             require(b <= a, errorMessage);
758             return a - b;
759         }
760     }
761 
762     /**
763      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
764      * division by zero. The result is rounded towards zero.
765      *
766      * Counterpart to Solidity's `/` operator. Note: this function uses a
767      * `revert` opcode (which leaves remaining gas untouched) while Solidity
768      * uses an invalid opcode to revert (consuming all remaining gas).
769      *
770      * Requirements:
771      *
772      * - The divisor cannot be zero.
773      */
774     function div(
775         uint256 a,
776         uint256 b,
777         string memory errorMessage
778     ) internal pure returns (uint256) {
779         unchecked {
780             require(b > 0, errorMessage);
781             return a / b;
782         }
783     }
784 
785     /**
786      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
787      * reverting with custom message when dividing by zero.
788      *
789      * CAUTION: This function is deprecated because it requires allocating memory for the error
790      * message unnecessarily. For custom revert reasons use {tryMod}.
791      *
792      * Counterpart to Solidity's `%` operator. This function uses a `revert`
793      * opcode (which leaves remaining gas untouched) while Solidity uses an
794      * invalid opcode to revert (consuming all remaining gas).
795      *
796      * Requirements:
797      *
798      * - The divisor cannot be zero.
799      */
800     function mod(
801         uint256 a,
802         uint256 b,
803         string memory errorMessage
804     ) internal pure returns (uint256) {
805         unchecked {
806             require(b > 0, errorMessage);
807             return a % b;
808         }
809     }
810 }
811 
812 /* pragma solidity 0.8.10; */
813 /* pragma experimental ABIEncoderV2; */
814 
815 interface IUniswapV2Factory {
816     event PairCreated(
817         address indexed token0,
818         address indexed token1,
819         address pair,
820         uint256
821     );
822 
823     function feeTo() external view returns (address);
824 
825     function feeToSetter() external view returns (address);
826 
827     function getPair(address tokenA, address tokenB)
828         external
829         view
830         returns (address pair);
831 
832     function allPairs(uint256) external view returns (address pair);
833 
834     function allPairsLength() external view returns (uint256);
835 
836     function createPair(address tokenA, address tokenB)
837         external
838         returns (address pair);
839 
840     function setFeeTo(address) external;
841 
842     function setFeeToSetter(address) external;
843 }
844 
845 /* pragma solidity 0.8.10; */
846 /* pragma experimental ABIEncoderV2; */
847 
848 interface IUniswapV2Pair {
849     event Approval(
850         address indexed owner,
851         address indexed spender,
852         uint256 value
853     );
854     event Transfer(address indexed from, address indexed to, uint256 value);
855 
856     function name() external pure returns (string memory);
857 
858     function symbol() external pure returns (string memory);
859 
860     function decimals() external pure returns (uint8);
861 
862     function totalSupply() external view returns (uint256);
863 
864     function balanceOf(address owner) external view returns (uint256);
865 
866     function allowance(address owner, address spender)
867         external
868         view
869         returns (uint256);
870 
871     function approve(address spender, uint256 value) external returns (bool);
872 
873     function transfer(address to, uint256 value) external returns (bool);
874 
875     function transferFrom(
876         address from,
877         address to,
878         uint256 value
879     ) external returns (bool);
880 
881     function DOMAIN_SEPARATOR() external view returns (bytes32);
882 
883     function PERMIT_TYPEHASH() external pure returns (bytes32);
884 
885     function nonces(address owner) external view returns (uint256);
886 
887     function permit(
888         address owner,
889         address spender,
890         uint256 value,
891         uint256 deadline,
892         uint8 v,
893         bytes32 r,
894         bytes32 s
895     ) external;
896 
897     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
898     event Burn(
899         address indexed sender,
900         uint256 amount0,
901         uint256 amount1,
902         address indexed to
903     );
904     event Swap(
905         address indexed sender,
906         uint256 amount0In,
907         uint256 amount1In,
908         uint256 amount0Out,
909         uint256 amount1Out,
910         address indexed to
911     );
912     event Sync(uint112 reserve0, uint112 reserve1);
913 
914     function MINIMUM_LIQUIDITY() external pure returns (uint256);
915 
916     function factory() external view returns (address);
917 
918     function token0() external view returns (address);
919 
920     function token1() external view returns (address);
921 
922     function getReserves()
923         external
924         view
925         returns (
926             uint112 reserve0,
927             uint112 reserve1,
928             uint32 blockTimestampLast
929         );
930 
931     function price0CumulativeLast() external view returns (uint256);
932 
933     function price1CumulativeLast() external view returns (uint256);
934 
935     function kLast() external view returns (uint256);
936 
937     function mint(address to) external returns (uint256 liquidity);
938 
939     function burn(address to)
940         external
941         returns (uint256 amount0, uint256 amount1);
942 
943     function swap(
944         uint256 amount0Out,
945         uint256 amount1Out,
946         address to,
947         bytes calldata data
948     ) external;
949 
950     function skim(address to) external;
951 
952     function sync() external;
953 
954     function initialize(address, address) external;
955 }
956 
957 /* pragma solidity 0.8.10; */
958 /* pragma experimental ABIEncoderV2; */
959 
960 interface IUniswapV2Router02 {
961     function factory() external pure returns (address);
962 
963     function WETH() external pure returns (address);
964 
965     function addLiquidity(
966         address tokenA,
967         address tokenB,
968         uint256 amountADesired,
969         uint256 amountBDesired,
970         uint256 amountAMin,
971         uint256 amountBMin,
972         address to,
973         uint256 deadline
974     )
975         external
976         returns (
977             uint256 amountA,
978             uint256 amountB,
979             uint256 liquidity
980         );
981 
982     function addLiquidityETH(
983         address token,
984         uint256 amountTokenDesired,
985         uint256 amountTokenMin,
986         uint256 amountETHMin,
987         address to,
988         uint256 deadline
989     )
990         external
991         payable
992         returns (
993             uint256 amountToken,
994             uint256 amountETH,
995             uint256 liquidity
996         );
997 
998     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
999         uint256 amountIn,
1000         uint256 amountOutMin,
1001         address[] calldata path,
1002         address to,
1003         uint256 deadline
1004     ) external;
1005 
1006     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1007         uint256 amountOutMin,
1008         address[] calldata path,
1009         address to,
1010         uint256 deadline
1011     ) external payable;
1012 
1013     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1014         uint256 amountIn,
1015         uint256 amountOutMin,
1016         address[] calldata path,
1017         address to,
1018         uint256 deadline
1019     ) external;
1020 }
1021 
1022 /* pragma solidity >=0.8.10; */
1023 
1024 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1025 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1026 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1027 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1028 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1029 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1030 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1031 
1032 contract HAMLET is ERC20, Ownable {
1033     using SafeMath for uint256;
1034 
1035     IUniswapV2Router02 public immutable uniswapV2Router;
1036     address public immutable uniswapV2Pair;
1037     address public constant deadAddress = address(0xdead);
1038 
1039     bool private swapping;
1040 
1041 	address public charityWallet;
1042     address public marketingWallet;
1043     address public devWallet;
1044 
1045     uint256 public maxTransactionAmount;
1046     uint256 public swapTokensAtAmount;
1047     uint256 public maxWallet;
1048 
1049     bool public limitsInEffect = true;
1050     bool public tradingActive = true;
1051     bool public swapEnabled = true;
1052 
1053     // Anti-bot and anti-whale mappings and variables
1054     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1055     bool public transferDelayEnabled = true;
1056 
1057     uint256 public buyTotalFees;
1058 	uint256 public buyCharityFee;
1059     uint256 public buyMarketingFee;
1060     uint256 public buyLiquidityFee;
1061     uint256 public buyDevFee;
1062 
1063     uint256 public sellTotalFees;
1064 	uint256 public sellCharityFee;
1065     uint256 public sellMarketingFee;
1066     uint256 public sellLiquidityFee;
1067     uint256 public sellDevFee;
1068 
1069 	uint256 public tokensForCharity;
1070     uint256 public tokensForMarketing;
1071     uint256 public tokensForLiquidity;
1072     uint256 public tokensForDev;
1073 
1074     /******************/
1075 
1076     // exlcude from fees and max transaction amount
1077     mapping(address => bool) private _isExcludedFromFees;
1078     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1079 
1080     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1081     // could be subject to a maximum transfer amount
1082     mapping(address => bool) public automatedMarketMakerPairs;
1083 
1084     event UpdateUniswapV2Router(
1085         address indexed newAddress,
1086         address indexed oldAddress
1087     );
1088 
1089     event ExcludeFromFees(address indexed account, bool isExcluded);
1090 
1091     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1092 
1093     event SwapAndLiquify(
1094         uint256 tokensSwapped,
1095         uint256 ethReceived,
1096         uint256 tokensIntoLiquidity
1097     );
1098 
1099     constructor() ERC20("THE GREAT DANE", "HAMLET") {
1100         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1101             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1102         );
1103 
1104         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1105         uniswapV2Router = _uniswapV2Router;
1106 
1107         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1108             .createPair(address(this), _uniswapV2Router.WETH());
1109         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1110         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1111 
1112 		uint256 _buyCharityFee = 0;
1113         uint256 _buyMarketingFee = 0;
1114         uint256 _buyLiquidityFee = 0;
1115         uint256 _buyDevFee = 10;
1116 
1117 		uint256 _sellCharityFee = 0;
1118         uint256 _sellMarketingFee = 0;
1119         uint256 _sellLiquidityFee = 15;
1120         uint256 _sellDevFee = 15;
1121 
1122         uint256 totalSupply = 1000000000000 * 1e18;
1123 
1124         maxTransactionAmount = 20000000000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1125         maxWallet = 20000000000 * 1e18; // 2% from total supply maxWallet
1126         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1127 
1128 		buyCharityFee = _buyCharityFee;
1129         buyMarketingFee = _buyMarketingFee;
1130         buyLiquidityFee = _buyLiquidityFee;
1131         buyDevFee = _buyDevFee;
1132         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1133 
1134 		sellCharityFee = _sellCharityFee;
1135         sellMarketingFee = _sellMarketingFee;
1136         sellLiquidityFee = _sellLiquidityFee;
1137         sellDevFee = _sellDevFee;
1138         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1139 
1140 		charityWallet = address(0x8D40D8954C97526AEf9A65B26123A496596c4ea5); // 
1141         marketingWallet = address(0x8D40D8954C97526AEf9A65B26123A496596c4ea5); // Weaponery
1142         devWallet = address(0x8D40D8954C97526AEf9A65B26123A496596c4ea5); // set as dev wallet
1143 
1144         // exclude from paying fees or having max transaction amount
1145         excludeFromFees(owner(), true);
1146         excludeFromFees(address(this), true);
1147         excludeFromFees(address(0xdead), true);
1148 
1149         excludeFromMaxTransaction(owner(), true);
1150         excludeFromMaxTransaction(address(this), true);
1151         excludeFromMaxTransaction(address(0xdead), true);
1152 
1153         /*
1154             _mint is an internal function in ERC20.sol that is only called here,
1155             and CANNOT be called ever again
1156         */
1157         _mint(msg.sender, totalSupply);
1158     }
1159 
1160     receive() external payable {}
1161 
1162     // once enabled, can never be turned off
1163     function enableTrading() external onlyOwner {
1164         tradingActive = true;
1165         swapEnabled = true;
1166     }
1167 
1168     // remove limits after token is stable
1169     function removeLimits() external onlyOwner returns (bool) {
1170         limitsInEffect = false;
1171         return true;
1172     }
1173 
1174     // disable Transfer delay - cannot be reenabled
1175     function disableTransferDelay() external onlyOwner returns (bool) {
1176         transferDelayEnabled = false;
1177         return true;
1178     }
1179 
1180     // change the minimum amount of tokens to sell from fees
1181     function updateSwapTokensAtAmount(uint256 newAmount)
1182         external
1183         onlyOwner
1184         returns (bool)
1185     {
1186         require(
1187             newAmount >= (totalSupply() * 1) / 100000,
1188             "Swap amount cannot be lower than 0.001% total supply."
1189         );
1190         require(
1191             newAmount <= (totalSupply() * 5) / 1000,
1192             "Swap amount cannot be higher than 0.5% total supply."
1193         );
1194         swapTokensAtAmount = newAmount;
1195         return true;
1196     }
1197 
1198     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1199         require(
1200             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1201             "Cannot set maxTransactionAmount lower than 0.5%"
1202         );
1203         maxTransactionAmount = newNum ;
1204          maxWallet = newNum ;
1205     }
1206 
1207     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1208         require(
1209             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1210             "Cannot set maxWallet lower than 0.5%"
1211         );
1212         maxWallet = newNum ;
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