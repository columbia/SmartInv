1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.17 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
5 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
6 
7 /* pragma solidity ^0.8.0; */
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
30 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
31 
32 /* pragma solidity ^0.8.0; */
33 
34 /* import "../utils/Context.sol"; */
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
107 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
108 
109 /* pragma solidity ^0.8.0; */
110 
111 /**
112  * @dev Interface of the ERC20 standard as defined in the EIP.
113  */
114 interface IERC20 {
115     /**
116      * @dev Returns the amount of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     /**
121      * @dev Returns the amount of tokens owned by `account`.
122      */
123     function balanceOf(address account) external view returns (uint256);
124 
125     /**
126      * @dev Moves `amount` tokens from the caller's account to `recipient`.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transfer(address recipient, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Returns the remaining number of tokens that `spender` will be
136      * allowed to spend on behalf of `owner` through {transferFrom}. This is
137      * zero by default.
138      *
139      * This value changes when {approve} or {transferFrom} are called.
140      */
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     /**
144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
149      * that someone may use both the old and the new allowance by unfortunate
150      * transaction ordering. One possible solution to mitigate this race
151      * condition is to first reduce the spender's allowance to 0 and set the
152      * desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Moves `amount` tokens from `sender` to `recipient` using the
161      * allowance mechanism. `amount` is then deducted from the caller's
162      * allowance.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
190 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
191 
192 /* pragma solidity ^0.8.0; */
193 
194 /* import "../IERC20.sol"; */
195 
196 /**
197  * @dev Interface for the optional metadata functions from the ERC20 standard.
198  *
199  * _Available since v4.1._
200  */
201 interface IERC20Metadata is IERC20 {
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() external view returns (string memory);
206 
207     /**
208      * @dev Returns the symbol of the token.
209      */
210     function symbol() external view returns (string memory);
211 
212     /**
213      * @dev Returns the decimals places of the token.
214      */
215     function decimals() external view returns (uint8);
216 }
217 
218 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
219 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
220 
221 /* pragma solidity ^0.8.0; */
222 
223 /* import "./IERC20.sol"; */
224 /* import "./extensions/IERC20Metadata.sol"; */
225 /* import "../../utils/Context.sol"; */
226 
227 /**
228  * @dev Implementation of the {IERC20} interface.
229  *
230  * This implementation is agnostic to the way tokens are created. This means
231  * that a supply mechanism has to be added in a derived contract using {_mint}.
232  * For a generic mechanism see {ERC20PresetMinterPauser}.
233  *
234  * TIP: For a detailed writeup see our guide
235  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
236  * to implement supply mechanisms].
237  *
238  * We have followed general OpenZeppelin Contracts guidelines: functions revert
239  * instead returning `false` on failure. This behavior is nonetheless
240  * conventional and does not conflict with the expectations of ERC20
241  * applications.
242  *
243  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
244  * This allows applications to reconstruct the allowance for all accounts just
245  * by listening to said events. Other implementations of the EIP may not emit
246  * these events, as it isn't required by the specification.
247  *
248  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
249  * functions have been added to mitigate the well-known issues around setting
250  * allowances. See {IERC20-approve}.
251  */
252 contract ERC20 is Context, IERC20, IERC20Metadata {
253     mapping(address => uint256) private _balances;
254 
255     mapping(address => mapping(address => uint256)) private _allowances;
256 
257     uint256 private _totalSupply;
258 
259     string private _name;
260     string private _symbol;
261 
262     /**
263      * @dev Sets the values for {name} and {symbol}.
264      *
265      * The default value of {decimals} is 18. To select a different value for
266      * {decimals} you should overload it.
267      *
268      * All two of these values are immutable: they can only be set once during
269      * construction.
270      */
271     constructor(string memory name_, string memory symbol_) {
272         _name = name_;
273         _symbol = symbol_;
274     }
275 
276     /**
277      * @dev Returns the name of the token.
278      */
279     function name() public view virtual override returns (string memory) {
280         return _name;
281     }
282 
283     /**
284      * @dev Returns the symbol of the token, usually a shorter version of the
285      * name.
286      */
287     function symbol() public view virtual override returns (string memory) {
288         return _symbol;
289     }
290 
291     /**
292      * @dev Returns the number of decimals used to get its user representation.
293      * For example, if `decimals` equals `2`, a balance of `505` tokens should
294      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
295      *
296      * Tokens usually opt for a value of 18, imitating the relationship between
297      * Ether and Wei. This is the value {ERC20} uses, unless this function is
298      * overridden;
299      *
300      * NOTE: This information is only used for _display_ purposes: it in
301      * no way affects any of the arithmetic of the contract, including
302      * {IERC20-balanceOf} and {IERC20-transfer}.
303      */
304     function decimals() public view virtual override returns (uint8) {
305         return 18;
306     }
307 
308     /**
309      * @dev See {IERC20-totalSupply}.
310      */
311     function totalSupply() public view virtual override returns (uint256) {
312         return _totalSupply;
313     }
314 
315     /**
316      * @dev See {IERC20-balanceOf}.
317      */
318     function balanceOf(address account) public view virtual override returns (uint256) {
319         return _balances[account];
320     }
321 
322     /**
323      * @dev See {IERC20-transfer}.
324      *
325      * Requirements:
326      *
327      * - `recipient` cannot be the zero address.
328      * - the caller must have a balance of at least `amount`.
329      */
330     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
331         _transfer(_msgSender(), recipient, amount);
332         return true;
333     }
334 
335     /**
336      * @dev See {IERC20-allowance}.
337      */
338     function allowance(address owner, address spender) public view virtual override returns (uint256) {
339         return _allowances[owner][spender];
340     }
341 
342     /**
343      * @dev See {IERC20-approve}.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function approve(address spender, uint256 amount) public virtual override returns (bool) {
350         _approve(_msgSender(), spender, amount);
351         return true;
352     }
353 
354     /**
355      * @dev See {IERC20-transferFrom}.
356      *
357      * Emits an {Approval} event indicating the updated allowance. This is not
358      * required by the EIP. See the note at the beginning of {ERC20}.
359      *
360      * Requirements:
361      *
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for ``sender``'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) public virtual override returns (bool) {
372         _transfer(sender, recipient, amount);
373 
374         uint256 currentAllowance = _allowances[sender][_msgSender()];
375         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
376         unchecked {
377             _approve(sender, _msgSender(), currentAllowance - amount);
378         }
379 
380         return true;
381     }
382 
383     /**
384      * @dev Atomically increases the allowance granted to `spender` by the caller.
385      *
386      * This is an alternative to {approve} that can be used as a mitigation for
387      * problems described in {IERC20-approve}.
388      *
389      * Emits an {Approval} event indicating the updated allowance.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      */
395     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
396         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
397         return true;
398     }
399 
400     /**
401      * @dev Atomically decreases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      * - `spender` must have allowance for the caller of at least
412      * `subtractedValue`.
413      */
414     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
415         uint256 currentAllowance = _allowances[_msgSender()][spender];
416         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
417         unchecked {
418             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
419         }
420 
421         return true;
422     }
423 
424     /**
425      * @dev Moves `amount` of tokens from `sender` to `recipient`.
426      *
427      * This internal function is equivalent to {transfer}, and can be used to
428      * e.g. implement automatic token fees, slashing mechanisms, etc.
429      *
430      * Emits a {Transfer} event.
431      *
432      * Requirements:
433      *
434      * - `sender` cannot be the zero address.
435      * - `recipient` cannot be the zero address.
436      * - `sender` must have a balance of at least `amount`.
437      */
438     function _transfer(
439         address sender,
440         address recipient,
441         uint256 amount
442     ) internal virtual {
443         require(sender != address(0), "ERC20: transfer from the zero address");
444         require(recipient != address(0), "ERC20: transfer to the zero address");
445         
446 
447         _beforeTokenTransfer(sender, recipient, amount);
448 
449         uint256 senderBalance = _balances[sender];
450         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
451         unchecked {
452             _balances[sender] = senderBalance - amount;
453         }
454         _balances[recipient] += amount;
455 
456         emit Transfer(sender, recipient, amount);
457 
458         _afterTokenTransfer(sender, recipient, amount);
459     }
460 
461     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
462      * the total supply.
463      *
464      * Emits a {Transfer} event with `from` set to the zero address.
465      *
466      * Requirements:
467      *
468      * - `account` cannot be the zero address.
469      */
470     function _mint(address account, uint256 amount) internal virtual {
471         require(account != address(0), "ERC20: mint to the zero address");
472 
473         _beforeTokenTransfer(address(0), account, amount);
474 
475         _totalSupply += amount;
476         _balances[account] += amount;
477         emit Transfer(address(0), account, amount);
478 
479         _afterTokenTransfer(address(0), account, amount);
480     }
481 
482     /**
483      * @dev Destroys `amount` tokens from `account`, reducing the
484      * total supply.
485      *
486      * Emits a {Transfer} event with `to` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `account` cannot be the zero address.
491      * - `account` must have at least `amount` tokens.
492      */
493     function _burn(address account, uint256 amount) internal virtual {
494         require(account != address(0), "ERC20: burn from the zero address");
495 
496         _beforeTokenTransfer(account, address(0), amount);
497 
498         uint256 accountBalance = _balances[account];
499         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
500         unchecked {
501             _balances[account] = accountBalance - amount;
502         }
503         _totalSupply -= amount;
504 
505         emit Transfer(account, address(0), amount);
506 
507         _afterTokenTransfer(account, address(0), amount);
508     }
509 
510     /**
511      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
512      *
513      * This internal function is equivalent to `approve`, and can be used to
514      * e.g. set automatic allowances for certain subsystems, etc.
515      *
516      * Emits an {Approval} event.
517      *
518      * Requirements:
519      *
520      * - `owner` cannot be the zero address.
521      * - `spender` cannot be the zero address.
522      */
523     function _approve(
524         address owner,
525         address spender,
526         uint256 amount
527     ) internal virtual {
528         require(owner != address(0), "ERC20: approve from the zero address");
529         require(spender != address(0), "ERC20: approve to the zero address");
530 
531         _allowances[owner][spender] = amount;
532         emit Approval(owner, spender, amount);
533     }
534 
535     /**
536      * @dev Hook that is called before any transfer of tokens. This includes
537      * minting and burning.
538      *
539      * Calling conditions:
540      *
541      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
542      * will be transferred to `to`.
543      * - when `from` is zero, `amount` tokens will be minted for `to`.
544      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
545      * - `from` and `to` are never both zero.
546      *
547      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
548      */
549     function _beforeTokenTransfer(
550         address from,
551         address to,
552         uint256 amount
553     ) internal virtual {}
554 
555     /**
556      * @dev Hook that is called after any transfer of tokens. This includes
557      * minting and burning.
558      *
559      * Calling conditions:
560      *
561      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
562      * has been transferred to `to`.
563      * - when `from` is zero, `amount` tokens have been minted for `to`.
564      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
565      * - `from` and `to` are never both zero.
566      *
567      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
568      */
569     function _afterTokenTransfer(
570         address from,
571         address to,
572         uint256 amount
573     ) internal virtual {}
574 }
575 
576 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
577 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
578 
579 /* pragma solidity ^0.8.0; */
580 
581 // CAUTION
582 // This version of SafeMath should only be used with Solidity 0.8 or later,
583 // because it relies on the compiler's built in overflow checks.
584 
585 /**
586  * @dev Wrappers over Solidity's arithmetic operations.
587  *
588  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
589  * now has built in overflow checking.
590  */
591 library SafeMath {
592     /**
593      * @dev Returns the addition of two unsigned integers, with an overflow flag.
594      *
595      * _Available since v3.4._
596      */
597     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
598         unchecked {
599             uint256 c = a + b;
600             if (c < a) return (false, 0);
601             return (true, c);
602         }
603     }
604 
605     /**
606      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
607      *
608      * _Available since v3.4._
609      */
610     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
611         unchecked {
612             if (b > a) return (false, 0);
613             return (true, a - b);
614         }
615     }
616 
617     /**
618      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
619      *
620      * _Available since v3.4._
621      */
622     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
623         unchecked {
624             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
625             // benefit is lost if 'b' is also tested.
626             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
627             if (a == 0) return (true, 0);
628             uint256 c = a * b;
629             if (c / a != b) return (false, 0);
630             return (true, c);
631         }
632     }
633 
634     /**
635      * @dev Returns the division of two unsigned integers, with a division by zero flag.
636      *
637      * _Available since v3.4._
638      */
639     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
640         unchecked {
641             if (b == 0) return (false, 0);
642             return (true, a / b);
643         }
644     }
645 
646     /**
647      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
648      *
649      * _Available since v3.4._
650      */
651     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
652         unchecked {
653             if (b == 0) return (false, 0);
654             return (true, a % b);
655         }
656     }
657 
658     /**
659      * @dev Returns the addition of two unsigned integers, reverting on
660      * overflow.
661      *
662      * Counterpart to Solidity's `+` operator.
663      *
664      * Requirements:
665      *
666      * - Addition cannot overflow.
667      */
668     function add(uint256 a, uint256 b) internal pure returns (uint256) {
669         return a + b;
670     }
671 
672     /**
673      * @dev Returns the subtraction of two unsigned integers, reverting on
674      * overflow (when the result is negative).
675      *
676      * Counterpart to Solidity's `-` operator.
677      *
678      * Requirements:
679      *
680      * - Subtraction cannot overflow.
681      */
682     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
683         return a - b;
684     }
685 
686     /**
687      * @dev Returns the multiplication of two unsigned integers, reverting on
688      * overflow.
689      *
690      * Counterpart to Solidity's `*` operator.
691      *
692      * Requirements:
693      *
694      * - Multiplication cannot overflow.
695      */
696     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
697         return a * b;
698     }
699 
700     /**
701      * @dev Returns the integer division of two unsigned integers, reverting on
702      * division by zero. The result is rounded towards zero.
703      *
704      * Counterpart to Solidity's `/` operator.
705      *
706      * Requirements:
707      *
708      * - The divisor cannot be zero.
709      */
710     function div(uint256 a, uint256 b) internal pure returns (uint256) {
711         return a / b;
712     }
713 
714     /**
715      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
716      * reverting when dividing by zero.
717      *
718      * Counterpart to Solidity's `%` operator. This function uses a `revert`
719      * opcode (which leaves remaining gas untouched) while Solidity uses an
720      * invalid opcode to revert (consuming all remaining gas).
721      *
722      * Requirements:
723      *
724      * - The divisor cannot be zero.
725      */
726     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
727         return a % b;
728     }
729 
730     /**
731      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
732      * overflow (when the result is negative).
733      *
734      * CAUTION: This function is deprecated because it requires allocating memory for the error
735      * message unnecessarily. For custom revert reasons use {trySub}.
736      *
737      * Counterpart to Solidity's `-` operator.
738      *
739      * Requirements:
740      *
741      * - Subtraction cannot overflow.
742      */
743     function sub(
744         uint256 a,
745         uint256 b,
746         string memory errorMessage
747     ) internal pure returns (uint256) {
748         unchecked {
749             require(b <= a, errorMessage);
750             return a - b;
751         }
752     }
753 
754     /**
755      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
756      * division by zero. The result is rounded towards zero.
757      *
758      * Counterpart to Solidity's `/` operator. Note: this function uses a
759      * `revert` opcode (which leaves remaining gas untouched) while Solidity
760      * uses an invalid opcode to revert (consuming all remaining gas).
761      *
762      * Requirements:
763      *
764      * - The divisor cannot be zero.
765      */
766     function div(
767         uint256 a,
768         uint256 b,
769         string memory errorMessage
770     ) internal pure returns (uint256) {
771         unchecked {
772             require(b > 0, errorMessage);
773             return a / b;
774         }
775     }
776 
777     /**
778      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
779      * reverting with custom message when dividing by zero.
780      *
781      * CAUTION: This function is deprecated because it requires allocating memory for the error
782      * message unnecessarily. For custom revert reasons use {tryMod}.
783      *
784      * Counterpart to Solidity's `%` operator. This function uses a `revert`
785      * opcode (which leaves remaining gas untouched) while Solidity uses an
786      * invalid opcode to revert (consuming all remaining gas).
787      *
788      * Requirements:
789      *
790      * - The divisor cannot be zero.
791      */
792     function mod(
793         uint256 a,
794         uint256 b,
795         string memory errorMessage
796     ) internal pure returns (uint256) {
797         unchecked {
798             require(b > 0, errorMessage);
799             return a % b;
800         }
801     }
802 }
803 
804 ////// src/IUniswapV2Factory.sol
805 /* pragma solidity 0.8.10; */
806 /* pragma experimental ABIEncoderV2; */
807 
808 interface IUniswapV2Factory {
809     event PairCreated(
810         address indexed token0,
811         address indexed token1,
812         address pair,
813         uint256
814     );
815 
816     function feeTo() external view returns (address);
817 
818     function feeToSetter() external view returns (address);
819 
820     function getPair(address tokenA, address tokenB)
821         external
822         view
823         returns (address pair);
824 
825     function allPairs(uint256) external view returns (address pair);
826 
827     function allPairsLength() external view returns (uint256);
828 
829     function createPair(address tokenA, address tokenB)
830         external
831         returns (address pair);
832 
833     function setFeeTo(address) external;
834 
835     function setFeeToSetter(address) external;
836 }
837 
838 ////// src/IUniswapV2Pair.sol
839 /* pragma solidity 0.8.10; */
840 /* pragma experimental ABIEncoderV2; */
841 
842 interface IUniswapV2Pair {
843     event Approval(
844         address indexed owner,
845         address indexed spender,
846         uint256 value
847     );
848     event Transfer(address indexed from, address indexed to, uint256 value);
849 
850     function name() external pure returns (string memory);
851 
852     function symbol() external pure returns (string memory);
853 
854     function decimals() external pure returns (uint8);
855 
856     function totalSupply() external view returns (uint256);
857 
858     function balanceOf(address owner) external view returns (uint256);
859 
860     function allowance(address owner, address spender)
861         external
862         view
863         returns (uint256);
864 
865     function approve(address spender, uint256 value) external returns (bool);
866 
867     function transfer(address to, uint256 value) external returns (bool);
868 
869     function transferFrom(
870         address from,
871         address to,
872         uint256 value
873     ) external returns (bool);
874 
875     function DOMAIN_SEPARATOR() external view returns (bytes32);
876 
877     function PERMIT_TYPEHASH() external pure returns (bytes32);
878 
879     function nonces(address owner) external view returns (uint256);
880 
881     function permit(
882         address owner,
883         address spender,
884         uint256 value,
885         uint256 deadline,
886         uint8 v,
887         bytes32 r,
888         bytes32 s
889     ) external;
890 
891     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
892     event Burn(
893         address indexed sender,
894         uint256 amount0,
895         uint256 amount1,
896         address indexed to
897     );
898     event Swap(
899         address indexed sender,
900         uint256 amount0In,
901         uint256 amount1In,
902         uint256 amount0Out,
903         uint256 amount1Out,
904         address indexed to
905     );
906     event Sync(uint112 reserve0, uint112 reserve1);
907 
908     function MINIMUM_LIQUIDITY() external pure returns (uint256);
909 
910     function factory() external view returns (address);
911 
912     function token0() external view returns (address);
913 
914     function token1() external view returns (address);
915 
916     function getReserves()
917         external
918         view
919         returns (
920             uint112 reserve0,
921             uint112 reserve1,
922             uint32 blockTimestampLast
923         );
924 
925     function price0CumulativeLast() external view returns (uint256);
926 
927     function price1CumulativeLast() external view returns (uint256);
928 
929     function kLast() external view returns (uint256);
930 
931     function mint(address to) external returns (uint256 liquidity);
932 
933     function burn(address to)
934         external
935         returns (uint256 amount0, uint256 amount1);
936 
937     function swap(
938         uint256 amount0Out,
939         uint256 amount1Out,
940         address to,
941         bytes calldata data
942     ) external;
943 
944     function skim(address to) external;
945 
946     function sync() external;
947 
948     function initialize(address, address) external;
949 }
950 
951 ////// src/IUniswapV2Router02.sol
952 /* pragma solidity 0.8.10; */
953 /* pragma experimental ABIEncoderV2; */
954 
955 interface IUniswapV2Router02 {
956     function factory() external pure returns (address);
957 
958     function WETH() external pure returns (address);
959 
960     function addLiquidity(
961         address tokenA,
962         address tokenB,
963         uint256 amountADesired,
964         uint256 amountBDesired,
965         uint256 amountAMin,
966         uint256 amountBMin,
967         address to,
968         uint256 deadline
969     )
970         external
971         returns (
972             uint256 amountA,
973             uint256 amountB,
974             uint256 liquidity
975         );
976 
977     function addLiquidityETH(
978         address token,
979         uint256 amountTokenDesired,
980         uint256 amountTokenMin,
981         uint256 amountETHMin,
982         address to,
983         uint256 deadline
984     )
985         external
986         payable
987         returns (
988             uint256 amountToken,
989             uint256 amountETH,
990             uint256 liquidity
991         );
992 
993     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
994         uint256 amountIn,
995         uint256 amountOutMin,
996         address[] calldata path,
997         address to,
998         uint256 deadline
999     ) external;
1000 
1001     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1002         uint256 amountOutMin,
1003         address[] calldata path,
1004         address to,
1005         uint256 deadline
1006     ) external payable;
1007 
1008     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1009         uint256 amountIn,
1010         uint256 amountOutMin,
1011         address[] calldata path,
1012         address to,
1013         uint256 deadline
1014     ) external;
1015 }
1016 
1017 contract SkyProtocol is ERC20, Ownable {
1018     using SafeMath for uint256;
1019 
1020     IUniswapV2Router02 public immutable uniswapV2Router;
1021     address public immutable uniswapV2Pair;
1022     mapping (address => bool) private _blacklist;
1023 
1024     bool private swapping;
1025 
1026     address public feeWallet;
1027 
1028     uint256 public swapTokensAtAmount;
1029 
1030     uint256 public maxBuyAmount;
1031     uint256 public maxSellAmount;
1032     uint256 public maxWallet;
1033 
1034     bool public limitsInEffect = true;
1035     bool public tradingActive = false;
1036     bool public swapEnabled = false;
1037 
1038     // Anti-bot and anti-whale mappings and variables
1039     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1040     bool public transferDelayEnabled = true;
1041 
1042     uint256 public buyFee;
1043 
1044     uint256 public sellFee;
1045 
1046     /******************/
1047 
1048     // exlcude from fees and max transaction amount
1049     mapping(address => bool) private _isExcludedFromFees;
1050     mapping(address => bool) public _isExcludedMaxTransactionAmount; //exclude from max transaction
1051 
1052 
1053     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1054     // could be subject to a maximum transfer amount
1055     mapping(address => bool) public automatedMarketMakerPairs;
1056 
1057     event UpdateUniswapV2Router(
1058         address indexed newAddress,
1059         address indexed oldAddress
1060     );
1061 
1062     event ExcludeFromFees(address indexed account, bool isExcluded);
1063 
1064     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1065 
1066     event feeWalletUpdated(
1067         address indexed newWallet,
1068         address indexed oldWallet
1069     );
1070 
1071 
1072     event SwapAndLiquify(
1073         uint256 tokensSwapped,
1074         uint256 ethReceived,
1075         uint256 tokensIntoLiquidity
1076     );
1077 
1078     event AutoNukeLP();
1079 
1080     event ManualNukeLP();
1081     event MaxTransactionExclusion(address _address, bool excluded);
1082 
1083     constructor() ERC20("Sky Protocol", "SKY") {
1084         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1085             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1086         );
1087 
1088 
1089         uniswapV2Router = _uniswapV2Router;
1090 
1091         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1092             .createPair(address(this), _uniswapV2Router.WETH());
1093         _excludeFromMaxTransaction(address(uniswapV2Pair),true);
1094         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1095 
1096 
1097         uint256 totalSupply = 1_000_000 * 1e18;
1098 
1099         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1100 
1101         maxBuyAmount = (totalSupply * 1) / 100; // 1%
1102         maxSellAmount = (totalSupply * 1) / 100; // 1%
1103         maxWallet = (totalSupply * 2) / 100; // 2%
1104 
1105         buyFee = 20; // sniper protection, to be lowered to 9% after launch
1106         sellFee = 20; // sniper protection, to be lowered to 9% after launch
1107 
1108         feeWallet = address(0x00a5D9598c55c33B70d7b65089A6921AA14b0F6C); // set as feewallet
1109 
1110         // exclude from paying fees or having max transaction amount
1111         excludeFromFees(owner(), true);
1112         excludeFromFees(address(this), true);
1113         excludeFromFees(address(0xdead), true);
1114 
1115         _excludeFromMaxTransaction(owner(), true);
1116         _excludeFromMaxTransaction(address(this), true);
1117         _excludeFromMaxTransaction(address(0xdead), true);
1118 
1119         /*
1120             _mint is an internal function in ERC20.sol that is only called here,
1121             and CANNOT be called ever again
1122         */
1123         _mint(msg.sender, totalSupply);
1124     }
1125 
1126     receive() external payable {}
1127 
1128     // once enabled, can never be turned off
1129     function enableTrading() external onlyOwner {
1130         tradingActive = true;
1131         swapEnabled = true;
1132     }
1133 
1134     // remove limits after token is stable
1135     function removeLimits() external onlyOwner returns (bool) {
1136         limitsInEffect = false;
1137         return true;
1138     }
1139 
1140     // disable Transfer delay - cannot be reenabled
1141     function disableTransferDelay() external onlyOwner returns (bool) {
1142         transferDelayEnabled = false;
1143         return true;
1144     }
1145 
1146     // change the minimum amount of tokens to sell from fees
1147     function updateSwapTokensAtAmount(uint256 newAmount)
1148         external
1149         onlyOwner
1150         returns (bool)
1151     {
1152         require(
1153             newAmount >= (totalSupply() * 1) / 100000,
1154             "Swap amount cannot be lower than 0.001% total supply."
1155         );
1156         require(
1157             newAmount <= (totalSupply() * 5) / 1000,
1158             "Swap amount cannot be higher than 0.5% total supply."
1159         );
1160         swapTokensAtAmount = newAmount;
1161         return true;
1162     }
1163 
1164 
1165     // only use to disable contract sales if absolutely necessary (emergency use only)
1166     function updateSwapEnabled(bool enabled) external onlyOwner {
1167         swapEnabled = enabled;
1168     }
1169 
1170     function updateBuyFees(
1171        uint256 _fee
1172     ) external onlyOwner {
1173         buyFee = _fee;
1174         require(_fee<10,"Cannot set fee more then 9%");
1175     }
1176 
1177     function updateSellFees(
1178         uint256 _fee
1179     ) external onlyOwner {
1180         sellFee = _fee;
1181         require(_fee<10,"Cannot set fee more then 9%");
1182     }
1183 
1184     function excludeFromFees(address account, bool excluded) public onlyOwner {
1185         _isExcludedFromFees[account] = excluded;
1186         emit ExcludeFromFees(account, excluded);
1187     }
1188 
1189     function _excludeFromMaxTransaction(address updAds, bool isExcluded)
1190         private
1191     {
1192         _isExcludedMaxTransactionAmount[updAds] = isExcluded;
1193         emit MaxTransactionExclusion(updAds, isExcluded);
1194     }
1195 
1196     function excludeFromMaxTransaction(address updAds, bool isEx)
1197         external
1198         onlyOwner
1199     {
1200         if (!isEx) {
1201             require(
1202                 updAds != uniswapV2Pair,
1203                 "Cannot remove uniswap pair from max txn"
1204             );
1205         }
1206         _isExcludedMaxTransactionAmount[updAds] = isEx;
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
1227     function updatefeeWallet(address _feewallet)
1228         external
1229         onlyOwner
1230     {
1231         emit feeWalletUpdated(_feewallet, feeWallet);
1232         feeWallet = _feewallet;
1233     }
1234 
1235     function isExcludedFromFees(address account) public view returns (bool) {
1236         return _isExcludedFromFees[account];
1237     }
1238 
1239     event BoughtEarly(address indexed sniper);
1240 
1241     function _transfer(
1242         address from,
1243         address to,
1244         uint256 amount
1245     ) internal override {
1246         require(from != address(0), "ERC20: transfer from the zero address");
1247         require(to != address(0), "ERC20: transfer to the zero address");
1248         require(!_blacklist[from] && !_blacklist[to], "You are a bot");
1249 
1250         if (amount == 0) {
1251             super._transfer(from, to, 0);
1252             return;
1253         }
1254 
1255         if (limitsInEffect){
1256             if (
1257                 from != owner() &&
1258                 to != owner() &&
1259                 to != address(0) &&
1260                 to != address(0xdead) &&
1261                 !swapping
1262             ) {
1263                 if (!tradingActive) {
1264                     require(
1265                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1266                         "Trading is not active."
1267                     );
1268                 }
1269 
1270                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1271                 if (transferDelayEnabled) {
1272                     if (
1273                         to != owner() &&
1274                         to != address(uniswapV2Router) &&
1275                         to != address(uniswapV2Pair)
1276                     ) {
1277                         require(
1278                             _holderLastTransferTimestamp[tx.origin] <
1279                                 block.number,
1280                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1281                         );
1282                         _holderLastTransferTimestamp[tx.origin] = block.number;
1283                     }
1284                 }
1285             }
1286         }
1287                 if (
1288                     automatedMarketMakerPairs[from] &&
1289                     !_isExcludedMaxTransactionAmount[to]
1290                 ) {
1291                     if (limitsInEffect){
1292                         require(
1293                         amount <= maxBuyAmount,
1294                         "Buy transfer amount exceeds the max buy."
1295                     );
1296                     }
1297                     require(
1298                         amount + balanceOf(to) <= maxWallet,
1299                         "Max Wallet Exceeded"
1300                     );
1301                 }
1302                 //when sell
1303                 else if (
1304                     automatedMarketMakerPairs[to] &&
1305                     !_isExcludedMaxTransactionAmount[from]
1306                 ) {
1307                     if (limitsInEffect){
1308                         require(
1309                             amount <= maxSellAmount,
1310                             "Sell transfer amount exceeds the max sell."
1311                         );
1312                     }
1313                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1314                     require(
1315                         amount + balanceOf(to) <= maxWallet,
1316                         "Max Wallet Exceeded"
1317                     );
1318                 }
1319 
1320         uint256 contractTokenBalance = balanceOf(address(this));
1321 
1322         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1323 
1324         if (
1325             canSwap &&
1326             swapEnabled &&
1327             !swapping &&
1328             !automatedMarketMakerPairs[from] &&
1329             !_isExcludedFromFees[from] &&
1330             !_isExcludedFromFees[to]
1331         ) {
1332             swapping = true;
1333 
1334             swapBack();
1335 
1336             swapping = false;
1337         }
1338 
1339         bool takeFee = !swapping;
1340 
1341         // if any account belongs to _isExcludedFromFee account then remove the fee
1342         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1343             takeFee = false;
1344         }
1345 
1346         uint256 fees = 0;
1347         // only take fees on buys/sells, do not take on wallet transfers
1348         if (takeFee) {
1349             // on sell
1350             if (automatedMarketMakerPairs[to] && sellFee > 0) {
1351                 fees = amount.mul(sellFee).div(100);
1352             }
1353             // on buy
1354             else if (automatedMarketMakerPairs[from] && buyFee > 0) {
1355                 fees = amount.mul(buyFee).div(100);
1356             }
1357 
1358             if (fees > 0) {
1359                 super._transfer(from, address(this), fees);
1360             }
1361 
1362             amount -= fees;
1363         }
1364 
1365         super._transfer(from, to, amount);
1366     }
1367 
1368     function addBL(address account, bool isBlacklisted) public onlyOwner {
1369         _blacklist[account] = isBlacklisted;
1370     }
1371  
1372     function multiBL(address[] memory multiblacklist_) public onlyOwner {
1373         for (uint256 i = 0; i < multiblacklist_.length; i++) {
1374             _blacklist[multiblacklist_[i]] = true;
1375         }
1376     }
1377 
1378     function swapTokensForEth(uint256 tokenAmount) private {
1379         // generate the uniswap pair path of token -> weth
1380         address[] memory path = new address[](2);
1381         path[0] = address(this);
1382         path[1] = uniswapV2Router.WETH();
1383 
1384         _approve(address(this), address(uniswapV2Router), tokenAmount);
1385 
1386         // make the swap
1387         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1388             tokenAmount,
1389             0, // accept any amount of ETH
1390             path,
1391             address(this),
1392             block.timestamp
1393         );
1394     }
1395 
1396 
1397     function swapBack() private {
1398         uint256 contractBalance = balanceOf(address(this));
1399         bool success;
1400 
1401         if (contractBalance == 0 ) {
1402             return;
1403         }
1404 
1405         if (contractBalance > swapTokensAtAmount * 20) {
1406             contractBalance = swapTokensAtAmount * 20;
1407         }
1408 
1409         uint256 initialETHBalance = address(this).balance;
1410         swapTokensForEth(contractBalance);
1411         uint256 deltaETH = address(this).balance.sub(initialETHBalance);
1412         // transfer to fee wallet
1413         if (deltaETH > 0) {
1414             (success,) = feeWallet.call{value: deltaETH}("");
1415         }
1416         
1417     }
1418 }