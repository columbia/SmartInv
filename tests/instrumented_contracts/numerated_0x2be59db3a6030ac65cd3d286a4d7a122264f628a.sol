1 /*
2 
3 
4 https://t.me/hachikoinuentry
5 
6 
7 
8 */
9 // SPDX-License-Identifier: MIT
10 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
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
812 ////// src/IUniswapV2Factory.sol
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
846 ////// src/IUniswapV2Pair.sol
847 /* pragma solidity 0.8.10; */
848 /* pragma experimental ABIEncoderV2; */
849 
850 interface IUniswapV2Pair {
851     event Approval(
852         address indexed owner,
853         address indexed spender,
854         uint256 value
855     );
856     event Transfer(address indexed from, address indexed to, uint256 value);
857 
858     function name() external pure returns (string memory);
859 
860     function symbol() external pure returns (string memory);
861 
862     function decimals() external pure returns (uint8);
863 
864     function totalSupply() external view returns (uint256);
865 
866     function balanceOf(address owner) external view returns (uint256);
867 
868     function allowance(address owner, address spender)
869         external
870         view
871         returns (uint256);
872 
873     function approve(address spender, uint256 value) external returns (bool);
874 
875     function transfer(address to, uint256 value) external returns (bool);
876 
877     function transferFrom(
878         address from,
879         address to,
880         uint256 value
881     ) external returns (bool);
882 
883     function DOMAIN_SEPARATOR() external view returns (bytes32);
884 
885     function PERMIT_TYPEHASH() external pure returns (bytes32);
886 
887     function nonces(address owner) external view returns (uint256);
888 
889     function permit(
890         address owner,
891         address spender,
892         uint256 value,
893         uint256 deadline,
894         uint8 v,
895         bytes32 r,
896         bytes32 s
897     ) external;
898 
899     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
900     event Burn(
901         address indexed sender,
902         uint256 amount0,
903         uint256 amount1,
904         address indexed to
905     );
906     event Swap(
907         address indexed sender,
908         uint256 amount0In,
909         uint256 amount1In,
910         uint256 amount0Out,
911         uint256 amount1Out,
912         address indexed to
913     );
914     event Sync(uint112 reserve0, uint112 reserve1);
915 
916     function MINIMUM_LIQUIDITY() external pure returns (uint256);
917 
918     function factory() external view returns (address);
919 
920     function token0() external view returns (address);
921 
922     function token1() external view returns (address);
923 
924     function getReserves()
925         external
926         view
927         returns (
928             uint112 reserve0,
929             uint112 reserve1,
930             uint32 blockTimestampLast
931         );
932 
933     function price0CumulativeLast() external view returns (uint256);
934 
935     function price1CumulativeLast() external view returns (uint256);
936 
937     function kLast() external view returns (uint256);
938 
939     function mint(address to) external returns (uint256 liquidity);
940 
941     function burn(address to)
942         external
943         returns (uint256 amount0, uint256 amount1);
944 
945     function swap(
946         uint256 amount0Out,
947         uint256 amount1Out,
948         address to,
949         bytes calldata data
950     ) external;
951 
952     function skim(address to) external;
953 
954     function sync() external;
955 
956     function initialize(address, address) external;
957 }
958 
959 ////// src/IUniswapV2Router02.sol
960 /* pragma solidity 0.8.10; */
961 /* pragma experimental ABIEncoderV2; */
962 
963 interface IUniswapV2Router02 {
964     function factory() external pure returns (address);
965 
966     function WETH() external pure returns (address);
967 
968     function addLiquidity(
969         address tokenA,
970         address tokenB,
971         uint256 amountADesired,
972         uint256 amountBDesired,
973         uint256 amountAMin,
974         uint256 amountBMin,
975         address to,
976         uint256 deadline
977     )
978         external
979         returns (
980             uint256 amountA,
981             uint256 amountB,
982             uint256 liquidity
983         );
984 
985     function addLiquidityETH(
986         address token,
987         uint256 amountTokenDesired,
988         uint256 amountTokenMin,
989         uint256 amountETHMin,
990         address to,
991         uint256 deadline
992     )
993         external
994         payable
995         returns (
996             uint256 amountToken,
997             uint256 amountETH,
998             uint256 liquidity
999         );
1000 
1001     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1002         uint256 amountIn,
1003         uint256 amountOutMin,
1004         address[] calldata path,
1005         address to,
1006         uint256 deadline
1007     ) external;
1008 
1009     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1010         uint256 amountOutMin,
1011         address[] calldata path,
1012         address to,
1013         uint256 deadline
1014     ) external payable;
1015 
1016     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1017         uint256 amountIn,
1018         uint256 amountOutMin,
1019         address[] calldata path,
1020         address to,
1021         uint256 deadline
1022     ) external;
1023 }
1024 
1025 /* pragma solidity >=0.8.10; */
1026 
1027 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1028 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1029 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1030 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1031 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1032 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1033 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1034 
1035 contract HachikoInu is ERC20, Ownable {
1036     using SafeMath for uint256;
1037 
1038     IUniswapV2Router02 public immutable uniswapV2Router;
1039     address public immutable uniswapV2Pair;
1040     address public constant deadAddress = address(0xdead);
1041 
1042     bool private swapping;
1043 
1044     address public marketingWallet;
1045     address public devWallet;
1046 
1047     uint256 public maxTransactionAmount;
1048     uint256 public swapTokensAtAmount;
1049     uint256 public maxWallet;
1050 
1051     uint256 public percentForLPBurn = 25; // 25 = .25%
1052     bool public lpBurnEnabled = true;
1053     uint256 public lpBurnFrequency = 3600 seconds;
1054     uint256 public lastLpBurnTime;
1055 
1056     uint256 public manualBurnFrequency = 30 minutes;
1057     uint256 public lastManualLpBurnTime;
1058 
1059     bool public limitsInEffect = true;
1060     bool public tradingActive = false;
1061     bool public swapEnabled = false;
1062 
1063     // Anti-bot and anti-whale mappings and variables
1064     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1065     bool public transferDelayEnabled = true;
1066 
1067     uint256 public buyTotalFees;
1068     uint256 public buyMarketingFee;
1069     uint256 public buyLiquidityFee;
1070     uint256 public buyDevFee;
1071 
1072     uint256 public sellTotalFees;
1073     uint256 public sellMarketingFee;
1074     uint256 public sellLiquidityFee;
1075     uint256 public sellDevFee;
1076 
1077     uint256 public tokensForMarketing;
1078     uint256 public tokensForLiquidity;
1079     uint256 public tokensForDev;
1080 
1081     /******************/
1082 
1083     // exlcude from fees and max transaction amount
1084     mapping(address => bool) private _isExcludedFromFees;
1085     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1086 
1087     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1088     // could be subject to a maximum transfer amount
1089     mapping(address => bool) public automatedMarketMakerPairs;
1090 
1091     event UpdateUniswapV2Router(
1092         address indexed newAddress,
1093         address indexed oldAddress
1094     );
1095 
1096     event ExcludeFromFees(address indexed account, bool isExcluded);
1097 
1098     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1099 
1100     event marketingWalletUpdated(
1101         address indexed newWallet,
1102         address indexed oldWallet
1103     );
1104 
1105     event devWalletUpdated(
1106         address indexed newWallet,
1107         address indexed oldWallet
1108     );
1109 
1110     event SwapAndLiquify(
1111         uint256 tokensSwapped,
1112         uint256 ethReceived,
1113         uint256 tokensIntoLiquidity
1114     );
1115 
1116     event AutoNukeLP();
1117 
1118     event ManualNukeLP();
1119 
1120     constructor() ERC20("Hachiko Inu", "HACHI") {
1121         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1122             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1123         );
1124 
1125         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1126         uniswapV2Router = _uniswapV2Router;
1127 
1128         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1129             .createPair(address(this), _uniswapV2Router.WETH());
1130         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1131         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1132 
1133         uint256 _buyMarketingFee = 0;
1134         uint256 _buyLiquidityFee = 0;
1135         uint256 _buyDevFee = 20;
1136 
1137         uint256 _sellMarketingFee = 0;
1138         uint256 _sellLiquidityFee = 0;
1139         uint256 _sellDevFee = 35;
1140 
1141         uint256 totalSupply = 1_000_000_000 * 1e18;
1142 
1143         maxTransactionAmount = 10_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1144         maxWallet = 10_000_000 * 1e18; // 3% from total supply maxWallet
1145         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1146 
1147         buyMarketingFee = _buyMarketingFee;
1148         buyLiquidityFee = _buyLiquidityFee;
1149         buyDevFee = _buyDevFee;
1150         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1151 
1152         sellMarketingFee = _sellMarketingFee;
1153         sellLiquidityFee = _sellLiquidityFee;
1154         sellDevFee = _sellDevFee;
1155         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1156 
1157         marketingWallet = address(0xC4d729d5c30073bCc31513bEBA2AeC00561a48B3); // set as marketing wallet
1158         devWallet = address(0xC4d729d5c30073bCc31513bEBA2AeC00561a48B3); // set as dev wallet
1159 
1160         // exclude from paying fees or having max transaction amount
1161         excludeFromFees(owner(), true);
1162         excludeFromFees(address(this), true);
1163         excludeFromFees(address(0xdead), true);
1164 
1165         excludeFromMaxTransaction(owner(), true);
1166         excludeFromMaxTransaction(address(this), true);
1167         excludeFromMaxTransaction(address(0xdead), true);
1168 
1169         /*
1170             _mint is an internal function in ERC20.sol that is only called here,
1171             and CANNOT be called ever again
1172         */
1173         _mint(msg.sender, totalSupply);
1174     }
1175 
1176     receive() external payable {}
1177 
1178     // once enabled, can never be turned off
1179     function enableTrading() external onlyOwner {
1180         tradingActive = true;
1181         swapEnabled = true;
1182         lastLpBurnTime = block.timestamp;
1183     }
1184 
1185     // remove limits after token is stable
1186     function removeLimits() external onlyOwner returns (bool) {
1187         limitsInEffect = false;
1188         return true;
1189     }
1190 
1191     // disable Transfer delay - cannot be reenabled
1192     function disableTransferDelay() external onlyOwner returns (bool) {
1193         transferDelayEnabled = false;
1194         return true;
1195     }
1196 
1197     // change the minimum amount of tokens to sell from fees
1198     function updateSwapTokensAtAmount(uint256 newAmount)
1199         external
1200         onlyOwner
1201         returns (bool)
1202     {
1203         require(
1204             newAmount >= (totalSupply() * 1) / 100000,
1205             "Swap amount cannot be lower than 0.001% total supply."
1206         );
1207         require(
1208             newAmount <= (totalSupply() * 5) / 1000,
1209             "Swap amount cannot be higher than 0.5% total supply."
1210         );
1211         swapTokensAtAmount = newAmount;
1212         return true;
1213     }
1214 
1215     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1216         require(
1217             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1218             "Cannot set maxTransactionAmount lower than 0.1%"
1219         );
1220         maxTransactionAmount = newNum * (10**18);
1221     }
1222 
1223     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1224         require(
1225             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1226             "Cannot set maxWallet lower than 0.5%"
1227         );
1228         maxWallet = newNum * (10**18);
1229     }
1230 
1231     function excludeFromMaxTransaction(address updAds, bool isEx)
1232         public
1233         onlyOwner
1234     {
1235         _isExcludedMaxTransactionAmount[updAds] = isEx;
1236     }
1237 
1238     // only use to disable contract sales if absolutely necessary (emergency use only)
1239     function updateSwapEnabled(bool enabled) external onlyOwner {
1240         swapEnabled = enabled;
1241     }
1242 
1243     function updateBuyFees(
1244         uint256 _marketingFee,
1245         uint256 _liquidityFee,
1246         uint256 _devFee
1247     ) external onlyOwner {
1248         buyMarketingFee = _marketingFee;
1249         buyLiquidityFee = _liquidityFee;
1250         buyDevFee = _devFee;
1251         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1252         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1253     }
1254 
1255     function updateSellFees(
1256         uint256 _marketingFee,
1257         uint256 _liquidityFee,
1258         uint256 _devFee
1259     ) external onlyOwner {
1260         sellMarketingFee = _marketingFee;
1261         sellLiquidityFee = _liquidityFee;
1262         sellDevFee = _devFee;
1263         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1264         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1265     }
1266 
1267     function excludeFromFees(address account, bool excluded) public onlyOwner {
1268         _isExcludedFromFees[account] = excluded;
1269         emit ExcludeFromFees(account, excluded);
1270     }
1271 
1272     function setAutomatedMarketMakerPair(address pair, bool value)
1273         public
1274         onlyOwner
1275     {
1276         require(
1277             pair != uniswapV2Pair,
1278             "The pair cannot be removed from automatedMarketMakerPairs"
1279         );
1280 
1281         _setAutomatedMarketMakerPair(pair, value);
1282     }
1283 
1284     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1285         automatedMarketMakerPairs[pair] = value;
1286 
1287         emit SetAutomatedMarketMakerPair(pair, value);
1288     }
1289 
1290     function updateMarketingWallet(address newMarketingWallet)
1291         external
1292         onlyOwner
1293     {
1294         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1295         marketingWallet = newMarketingWallet;
1296     }
1297 
1298     function updateDevWallet(address newWallet) external onlyOwner {
1299         emit devWalletUpdated(newWallet, devWallet);
1300         devWallet = newWallet;
1301     }
1302 
1303     function isExcludedFromFees(address account) public view returns (bool) {
1304         return _isExcludedFromFees[account];
1305     }
1306 
1307     event BoughtEarly(address indexed sniper);
1308 
1309     function _transfer(
1310         address from,
1311         address to,
1312         uint256 amount
1313     ) internal override {
1314         require(from != address(0), "ERC20: transfer from the zero address");
1315         require(to != address(0), "ERC20: transfer to the zero address");
1316 
1317         if (amount == 0) {
1318             super._transfer(from, to, 0);
1319             return;
1320         }
1321 
1322         if (limitsInEffect) {
1323             if (
1324                 from != owner() &&
1325                 to != owner() &&
1326                 to != address(0) &&
1327                 to != address(0xdead) &&
1328                 !swapping
1329             ) {
1330                 if (!tradingActive) {
1331                     require(
1332                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1333                         "Trading is not active."
1334                     );
1335                 }
1336 
1337                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1338                 if (transferDelayEnabled) {
1339                     if (
1340                         to != owner() &&
1341                         to != address(uniswapV2Router) &&
1342                         to != address(uniswapV2Pair)
1343                     ) {
1344                         require(
1345                             _holderLastTransferTimestamp[tx.origin] <
1346                                 block.number,
1347                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1348                         );
1349                         _holderLastTransferTimestamp[tx.origin] = block.number;
1350                     }
1351                 }
1352 
1353                 //when buy
1354                 if (
1355                     automatedMarketMakerPairs[from] &&
1356                     !_isExcludedMaxTransactionAmount[to]
1357                 ) {
1358                     require(
1359                         amount <= maxTransactionAmount,
1360                         "Buy transfer amount exceeds the maxTransactionAmount."
1361                     );
1362                     require(
1363                         amount + balanceOf(to) <= maxWallet,
1364                         "Max wallet exceeded"
1365                     );
1366                 }
1367                 //when sell
1368                 else if (
1369                     automatedMarketMakerPairs[to] &&
1370                     !_isExcludedMaxTransactionAmount[from]
1371                 ) {
1372                     require(
1373                         amount <= maxTransactionAmount,
1374                         "Sell transfer amount exceeds the maxTransactionAmount."
1375                     );
1376                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1377                     require(
1378                         amount + balanceOf(to) <= maxWallet,
1379                         "Max wallet exceeded"
1380                     );
1381                 }
1382             }
1383         }
1384 
1385         uint256 contractTokenBalance = balanceOf(address(this));
1386 
1387         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1388 
1389         if (
1390             canSwap &&
1391             swapEnabled &&
1392             !swapping &&
1393             !automatedMarketMakerPairs[from] &&
1394             !_isExcludedFromFees[from] &&
1395             !_isExcludedFromFees[to]
1396         ) {
1397             swapping = true;
1398 
1399             swapBack();
1400 
1401             swapping = false;
1402         }
1403 
1404         if (
1405             !swapping &&
1406             automatedMarketMakerPairs[to] &&
1407             lpBurnEnabled &&
1408             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1409             !_isExcludedFromFees[from]
1410         ) {
1411             autoBurnLiquidityPairTokens();
1412         }
1413 
1414         bool takeFee = !swapping;
1415 
1416         // if any account belongs to _isExcludedFromFee account then remove the fee
1417         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1418             takeFee = false;
1419         }
1420 
1421         uint256 fees = 0;
1422         // only take fees on buys/sells, do not take on wallet transfers
1423         if (takeFee) {
1424             // on sell
1425             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1426                 fees = amount.mul(sellTotalFees).div(100);
1427                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1428                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1429                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1430             }
1431             // on buy
1432             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1433                 fees = amount.mul(buyTotalFees).div(100);
1434                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1435                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1436                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1437             }
1438 
1439             if (fees > 0) {
1440                 super._transfer(from, address(this), fees);
1441             }
1442 
1443             amount -= fees;
1444         }
1445 
1446         super._transfer(from, to, amount);
1447     }
1448 
1449     function swapTokensForEth(uint256 tokenAmount) private {
1450         // generate the uniswap pair path of token -> weth
1451         address[] memory path = new address[](2);
1452         path[0] = address(this);
1453         path[1] = uniswapV2Router.WETH();
1454 
1455         _approve(address(this), address(uniswapV2Router), tokenAmount);
1456 
1457         // make the swap
1458         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1459             tokenAmount,
1460             0, // accept any amount of ETH
1461             path,
1462             address(this),
1463             block.timestamp
1464         );
1465     }
1466 
1467     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1468         // approve token transfer to cover all possible scenarios
1469         _approve(address(this), address(uniswapV2Router), tokenAmount);
1470 
1471         // add the liquidity
1472         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1473             address(this),
1474             tokenAmount,
1475             0, // slippage is unavoidable
1476             0, // slippage is unavoidable
1477             deadAddress,
1478             block.timestamp
1479         );
1480     }
1481 
1482     function swapBack() private {
1483         uint256 contractBalance = balanceOf(address(this));
1484         uint256 totalTokensToSwap = tokensForLiquidity +
1485             tokensForMarketing +
1486             tokensForDev;
1487         bool success;
1488 
1489         if (contractBalance == 0 || totalTokensToSwap == 0) {
1490             return;
1491         }
1492 
1493         if (contractBalance > swapTokensAtAmount * 20) {
1494             contractBalance = swapTokensAtAmount * 20;
1495         }
1496 
1497         // Halve the amount of liquidity tokens
1498         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1499             totalTokensToSwap /
1500             2;
1501         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1502 
1503         uint256 initialETHBalance = address(this).balance;
1504 
1505         swapTokensForEth(amountToSwapForETH);
1506 
1507         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1508 
1509         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1510             totalTokensToSwap
1511         );
1512         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1513 
1514         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1515 
1516         tokensForLiquidity = 0;
1517         tokensForMarketing = 0;
1518         tokensForDev = 0;
1519 
1520         (success, ) = address(devWallet).call{value: ethForDev}("");
1521 
1522         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1523             addLiquidity(liquidityTokens, ethForLiquidity);
1524             emit SwapAndLiquify(
1525                 amountToSwapForETH,
1526                 ethForLiquidity,
1527                 tokensForLiquidity
1528             );
1529         }
1530 
1531         (success, ) = address(marketingWallet).call{
1532             value: address(this).balance
1533         }("");
1534     }
1535 
1536     function setAutoLPBurnSettings(
1537         uint256 _frequencyInSeconds,
1538         uint256 _percent,
1539         bool _Enabled
1540     ) external onlyOwner {
1541         require(
1542             _frequencyInSeconds >= 600,
1543             "cannot set buyback more often than every 10 minutes"
1544         );
1545         require(
1546             _percent <= 1000 && _percent >= 0,
1547             "Must set auto LP burn percent between 0% and 10%"
1548         );
1549         lpBurnFrequency = _frequencyInSeconds;
1550         percentForLPBurn = _percent;
1551         lpBurnEnabled = _Enabled;
1552     }
1553 
1554     function autoBurnLiquidityPairTokens() internal returns (bool) {
1555         lastLpBurnTime = block.timestamp;
1556 
1557         // get balance of liquidity pair
1558         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1559 
1560         // calculate amount to burn
1561         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1562             10000
1563         );
1564 
1565         // pull tokens from pancakePair liquidity and move to dead address permanently
1566         if (amountToBurn > 0) {
1567             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1568         }
1569 
1570         //sync price since this is not in a swap transaction!
1571         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1572         pair.sync();
1573         emit AutoNukeLP();
1574         return true;
1575     }
1576 
1577     function manualBurnLiquidityPairTokens(uint256 percent)
1578         external
1579         onlyOwner
1580         returns (bool)
1581     {
1582         require(
1583             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1584             "Must wait for cooldown to finish"
1585         );
1586         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1587         lastManualLpBurnTime = block.timestamp;
1588 
1589         // get balance of liquidity pair
1590         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1591 
1592         // calculate amount to burn
1593         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1594 
1595         // pull tokens from pancakePair liquidity and move to dead address permanently
1596         if (amountToBurn > 0) {
1597             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1598         }
1599 
1600         //sync price since this is not in a swap transaction!
1601         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1602         pair.sync();
1603         emit ManualNukeLP();
1604         return true;
1605     }
1606 }