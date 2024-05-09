1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
3 pragma experimental ABIEncoderV2;
4 
5 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
6 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
7 
8 /* pragma solidity ^0.8.0; */
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
31 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
32 
33 /* pragma solidity ^0.8.0; */
34 
35 /* import "../utils/Context.sol"; */
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
108 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
109 
110 /* pragma solidity ^0.8.0; */
111 
112 /**
113  * @dev Interface of the ERC20 standard as defined in the EIP.
114  */
115 interface IERC20 {
116     /**
117      * @dev Returns the amount of tokens in existence.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     /**
122      * @dev Returns the amount of tokens owned by `account`.
123      */
124     function balanceOf(address account) external view returns (uint256);
125 
126     /**
127      * @dev Moves `amount` tokens from the caller's account to `recipient`.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transfer(address recipient, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Returns the remaining number of tokens that `spender` will be
137      * allowed to spend on behalf of `owner` through {transferFrom}. This is
138      * zero by default.
139      *
140      * This value changes when {approve} or {transferFrom} are called.
141      */
142     function allowance(address owner, address spender) external view returns (uint256);
143 
144     /**
145      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * IMPORTANT: Beware that changing an allowance with this method brings the risk
150      * that someone may use both the old and the new allowance by unfortunate
151      * transaction ordering. One possible solution to mitigate this race
152      * condition is to first reduce the spender's allowance to 0 and set the
153      * desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address spender, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Moves `amount` tokens from `sender` to `recipient` using the
162      * allowance mechanism. `amount` is then deducted from the caller's
163      * allowance.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transferFrom(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to {approve}. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
191 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
192 
193 /* pragma solidity ^0.8.0; */
194 
195 /* import "../IERC20.sol"; */
196 
197 /**
198  * @dev Interface for the optional metadata functions from the ERC20 standard.
199  *
200  * _Available since v4.1._
201  */
202 interface IERC20Metadata is IERC20 {
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the symbol of the token.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the decimals places of the token.
215      */
216     function decimals() external view returns (uint8);
217 }
218 
219 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
220 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
221 
222 /* pragma solidity ^0.8.0; */
223 
224 /* import "./IERC20.sol"; */
225 /* import "./extensions/IERC20Metadata.sol"; */
226 /* import "../../utils/Context.sol"; */
227 
228 /**
229  * @dev Implementation of the {IERC20} interface.
230  *
231  * This implementation is agnostic to the way tokens are created. This means
232  * that a supply mechanism has to be added in a derived contract using {_mint}.
233  * For a generic mechanism see {ERC20PresetMinterPauser}.
234  *
235  * TIP: For a detailed writeup see our guide
236  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
237  * to implement supply mechanisms].
238  *
239  * We have followed general OpenZeppelin Contracts guidelines: functions revert
240  * instead returning `false` on failure. This behavior is nonetheless
241  * conventional and does not conflict with the expectations of ERC20
242  * applications.
243  *
244  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
245  * This allows applications to reconstruct the allowance for all accounts just
246  * by listening to said events. Other implementations of the EIP may not emit
247  * these events, as it isn't required by the specification.
248  *
249  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
250  * functions have been added to mitigate the well-known issues around setting
251  * allowances. See {IERC20-approve}.
252  */
253 contract ERC20 is Context, IERC20, IERC20Metadata {
254     mapping(address => uint256) private _balances;
255 
256     mapping(address => mapping(address => uint256)) private _allowances;
257 
258     uint256 private _totalSupply;
259 
260     string private _name;
261     string private _symbol;
262 
263     /**
264      * @dev Sets the values for {name} and {symbol}.
265      *
266      * The default value of {decimals} is 18. To select a different value for
267      * {decimals} you should overload it.
268      *
269      * All two of these values are immutable: they can only be set once during
270      * construction.
271      */
272     constructor(string memory name_, string memory symbol_) {
273         _name = name_;
274         _symbol = symbol_;
275     }
276 
277     /**
278      * @dev Returns the name of the token.
279      */
280     function name() public view virtual override returns (string memory) {
281         return _name;
282     }
283 
284     /**
285      * @dev Returns the symbol of the token, usually a shorter version of the
286      * name.
287      */
288     function symbol() public view virtual override returns (string memory) {
289         return _symbol;
290     }
291 
292     /**
293      * @dev Returns the number of decimals used to get its user representation.
294      * For example, if `decimals` equals `2`, a balance of `505` tokens should
295      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
296      *
297      * Tokens usually opt for a value of 18, imitating the relationship between
298      * Ether and Wei. This is the value {ERC20} uses, unless this function is
299      * overridden;
300      *
301      * NOTE: This information is only used for _display_ purposes: it in
302      * no way affects any of the arithmetic of the contract, including
303      * {IERC20-balanceOf} and {IERC20-transfer}.
304      */
305     function decimals() public view virtual override returns (uint8) {
306         return 18;
307     }
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view virtual override returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view virtual override returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view virtual override returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public virtual override returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20}.
360      *
361      * Requirements:
362      *
363      * - `sender` and `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      * - the caller must have allowance for ``sender``'s tokens of at least
366      * `amount`.
367      */
368     function transferFrom(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) public virtual override returns (bool) {
373         _transfer(sender, recipient, amount);
374 
375         uint256 currentAllowance = _allowances[sender][_msgSender()];
376         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
377         unchecked {
378             _approve(sender, _msgSender(), currentAllowance - amount);
379         }
380 
381         return true;
382     }
383 
384     /**
385      * @dev Atomically increases the allowance granted to `spender` by the caller.
386      *
387      * This is an alternative to {approve} that can be used as a mitigation for
388      * problems described in {IERC20-approve}.
389      *
390      * Emits an {Approval} event indicating the updated allowance.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      */
396     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
397         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
398         return true;
399     }
400 
401     /**
402      * @dev Atomically decreases the allowance granted to `spender` by the caller.
403      *
404      * This is an alternative to {approve} that can be used as a mitigation for
405      * problems described in {IERC20-approve}.
406      *
407      * Emits an {Approval} event indicating the updated allowance.
408      *
409      * Requirements:
410      *
411      * - `spender` cannot be the zero address.
412      * - `spender` must have allowance for the caller of at least
413      * `subtractedValue`.
414      */
415     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
416         uint256 currentAllowance = _allowances[_msgSender()][spender];
417         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
418         unchecked {
419             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
420         }
421 
422         return true;
423     }
424 
425     /**
426      * @dev Moves `amount` of tokens from `sender` to `recipient`.
427      *
428      * This internal function is equivalent to {transfer}, and can be used to
429      * e.g. implement automatic token fees, slashing mechanisms, etc.
430      *
431      * Emits a {Transfer} event.
432      *
433      * Requirements:
434      *
435      * - `sender` cannot be the zero address.
436      * - `recipient` cannot be the zero address.
437      * - `sender` must have a balance of at least `amount`.
438      */
439     function _transfer(
440         address sender,
441         address recipient,
442         uint256 amount
443     ) internal virtual {
444         require(sender != address(0), "ERC20: transfer from the zero address");
445         require(recipient != address(0), "ERC20: transfer to the zero address");
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
1017 //RocketTokenV2.sol
1018 
1019 contract RocketTokenV2 is ERC20, Ownable {
1020     using SafeMath for uint256;
1021 
1022     IUniswapV2Router02 public immutable uniswapV2Router;
1023     address public immutable uniswapV2Pair;
1024     address public constant deadAddress = address(0xdead);
1025 
1026     bool private swapping;
1027 
1028     address public marketingWallet;
1029     address public devWallet;
1030     address public communityWallet;
1031 
1032     uint256 public maxTransactionAmount;
1033     uint256 public swapTokensAtAmount;
1034     uint256 public maxWallet;
1035 
1036     uint256 public percentForLPBurn = 25; // 25 = .25%
1037     bool public lpBurnEnabled = true;
1038     uint256 public lpBurnFrequency = 3600 seconds;
1039     uint256 public lastLpBurnTime;
1040 
1041     uint256 public manualBurnFrequency = 30 minutes;
1042     uint256 public lastManualLpBurnTime;
1043 
1044     bool public limitsInEffect = true;
1045     bool public tradingActive = false;
1046     bool public swapEnabled = false;
1047 
1048     // Anti-bot and anti-whale mappings and variables
1049     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1050     bool public transferDelayEnabled = true;
1051 
1052     uint256 public buyTotalFees;
1053     uint256 public buyMarketingFee;
1054     uint256 public buyLiquidityFee;
1055     uint256 public buyDevFee;
1056     uint256 public buyCommunityFee;
1057 
1058     uint256 public sellTotalFees;
1059     uint256 public sellMarketingFee;
1060     uint256 public sellLiquidityFee;
1061     uint256 public sellDevFee;
1062     uint256 public sellCommunityFee;
1063 
1064     uint256 public tokensForMarketing;
1065     uint256 public tokensForLiquidity;
1066     uint256 public tokensForDev;
1067     uint256 public tokensForCommunity;
1068 
1069     /******************/
1070 
1071     // exlcude from fees and max transaction amount
1072     mapping(address => bool) private _isExcludedFromFees;
1073     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1074 
1075     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1076     // could be subject to a maximum transfer amount
1077     mapping(address => bool) public automatedMarketMakerPairs;
1078 
1079     event UpdateUniswapV2Router(
1080         address indexed newAddress,
1081         address indexed oldAddress
1082     );
1083 
1084     event ExcludeFromFees(address indexed account, bool isExcluded);
1085 
1086     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1087 
1088     event marketingWalletUpdated(
1089         address indexed newWallet,
1090         address indexed oldWallet
1091     );
1092 
1093     event devWalletUpdated(
1094         address indexed newWallet,
1095         address indexed oldWallet
1096     );
1097 
1098         event communityWalletUpdated(
1099         address indexed newWallet,
1100         address indexed oldWallet
1101     );
1102 
1103     event SwapAndLiquify(
1104         uint256 tokensSwapped,
1105         uint256 ethReceived,
1106         uint256 tokensIntoLiquidity
1107     );
1108 
1109     event AutoNukeLP();
1110 
1111     event ManualNukeLP();
1112 
1113     constructor() ERC20("Rocket Token V2", "RKTN") {
1114         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1115             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1116         );
1117 
1118         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1119         uniswapV2Router = _uniswapV2Router;
1120 
1121         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1122             .createPair(address(this), _uniswapV2Router.WETH());
1123         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1124         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1125 
1126         uint256 _buyMarketingFee = 2;
1127         uint256 _buyLiquidityFee = 1;
1128         uint256 _buyDevFee = 1;
1129         uint256 _buyCommunityFee = 2;
1130 
1131         uint256 _sellMarketingFee = 2;
1132         uint256 _sellLiquidityFee = 2;
1133         uint256 _sellDevFee = 3;
1134         uint256 _sellCommunityFee = 3;
1135 
1136         uint256 totalSupply = 40_000_000_000 * 1e18;
1137 
1138         maxTransactionAmount = 400_000_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1139         maxWallet = 1_200_000_000 * 1e18; // 3% from total supply maxWallet
1140         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1141 
1142         buyMarketingFee = _buyMarketingFee;
1143         buyLiquidityFee = _buyLiquidityFee;
1144         buyDevFee = _buyDevFee;
1145         buyCommunityFee = _buyCommunityFee;
1146         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyCommunityFee;
1147 
1148         sellMarketingFee = _sellMarketingFee;
1149         sellLiquidityFee = _sellLiquidityFee;
1150         sellDevFee = _sellDevFee;
1151         sellCommunityFee = _sellCommunityFee;
1152         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellCommunityFee;
1153 
1154         marketingWallet = address(0xdb83DB283183A98910442E1FDe77bAF8803BB037); // set as marketing wallet
1155         devWallet = address(0x30469c313972662f7E7Ac1fa49b0e4AD88786F15); // set as dev wallet
1156         communityWallet = address(0xE0C7094a6EE7031bA4E43cc510d39c39996ED0dE); // set as community wallet 
1157 
1158         // exclude from paying fees or having max transaction amount
1159         excludeFromFees(owner(), true);
1160         excludeFromFees(address(this), true);
1161         excludeFromFees(address(0xdead), true);
1162 
1163         excludeFromMaxTransaction(owner(), true);
1164         excludeFromMaxTransaction(address(this), true);
1165         excludeFromMaxTransaction(address(0xdead), true);
1166 
1167         /*
1168             _mint is an internal function in ERC20.sol that is only called here,
1169             and CANNOT be called ever again
1170         */
1171         _mint(msg.sender, totalSupply);
1172     }
1173 
1174     receive() external payable {}
1175 
1176     // once enabled, can never be turned off
1177     function enableTrading() external onlyOwner {
1178         tradingActive = true;
1179         swapEnabled = true;
1180         lastLpBurnTime = block.timestamp;
1181     }
1182 
1183     // remove limits after token is stable
1184     function removeLimits() external onlyOwner returns (bool) {
1185         limitsInEffect = false;
1186         return true;
1187     }
1188 
1189     // disable Transfer delay - cannot be reenabled
1190     function disableTransferDelay() external onlyOwner returns (bool) {
1191         transferDelayEnabled = false;
1192         return true;
1193     }
1194 
1195     // change the minimum amount of tokens to sell from fees
1196     function updateSwapTokensAtAmount(uint256 newAmount)
1197         external
1198         onlyOwner
1199         returns (bool)
1200     {
1201         require(
1202             newAmount >= (totalSupply() * 1) / 100000,
1203             "Swap amount cannot be lower than 0.001% total supply."
1204         );
1205         require(
1206             newAmount <= (totalSupply() * 5) / 1000,
1207             "Swap amount cannot be higher than 0.5% total supply."
1208         );
1209         swapTokensAtAmount = newAmount;
1210         return true;
1211     }
1212 
1213     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1214         require(
1215             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1216             "Cannot set maxTransactionAmount lower than 0.1%"
1217         );
1218         maxTransactionAmount = newNum * (10**18);
1219     }
1220 
1221     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1222         require(
1223             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1224             "Cannot set maxWallet lower than 0.5%"
1225         );
1226         maxWallet = newNum * (10**18);
1227     }
1228 
1229     function excludeFromMaxTransaction(address updAds, bool isEx)
1230         public
1231         onlyOwner
1232     {
1233         _isExcludedMaxTransactionAmount[updAds] = isEx;
1234     }
1235 
1236     // only use to disable contract sales if absolutely necessary (emergency use only)
1237     function updateSwapEnabled(bool enabled) external onlyOwner {
1238         swapEnabled = enabled;
1239     }
1240 
1241     function updateBuyFees(
1242         uint256 _marketingFee,
1243         uint256 _liquidityFee,
1244         uint256 _devFee,
1245         uint256 _communityFee
1246     ) external onlyOwner {
1247         buyMarketingFee = _marketingFee;
1248         buyLiquidityFee = _liquidityFee;
1249         buyDevFee = _devFee;
1250         buyCommunityFee = _communityFee;
1251         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee + buyCommunityFee;
1252         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1253     }
1254 
1255     function updateSellFees(
1256         uint256 _marketingFee,
1257         uint256 _liquidityFee,
1258         uint256 _devFee,
1259         uint256 _communityFee
1260     ) external onlyOwner {
1261         sellMarketingFee = _marketingFee;
1262         sellLiquidityFee = _liquidityFee;
1263         sellDevFee = _devFee;
1264         sellCommunityFee = _communityFee;
1265         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee + sellCommunityFee;
1266         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1267     }
1268 
1269     function excludeFromFees(address account, bool excluded) public onlyOwner {
1270         _isExcludedFromFees[account] = excluded;
1271         emit ExcludeFromFees(account, excluded);
1272     }
1273 
1274     function setAutomatedMarketMakerPair(address pair, bool value)
1275         public
1276         onlyOwner
1277     {
1278         require(
1279             pair != uniswapV2Pair,
1280             "pair cannot be removed from automatedMarketMakerPairs"
1281         );
1282 
1283         _setAutomatedMarketMakerPair(pair, value);
1284     }
1285 
1286     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1287         automatedMarketMakerPairs[pair] = value;
1288 
1289         emit SetAutomatedMarketMakerPair(pair, value);
1290     }
1291 
1292     function updateMarketingWallet(address newMarketingWallet)
1293         external
1294         onlyOwner
1295     {
1296         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1297         marketingWallet = newMarketingWallet;
1298     }
1299 
1300     function updateDevWallet(address newWallet) external onlyOwner {
1301         emit devWalletUpdated(newWallet, devWallet);
1302         devWallet = newWallet;
1303     }
1304 
1305     function updateCommunityWallet(address newWallet) external onlyOwner {
1306         emit communityWalletUpdated(newWallet, communityWallet);
1307         communityWallet = newWallet;
1308     }
1309 
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
1438                 tokensForCommunity += (fees * sellCommunityFee) / sellTotalFees;
1439             }
1440             // on buy
1441             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1442                 fees = amount.mul(buyTotalFees).div(100);
1443                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1444                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1445                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1446                 tokensForCommunity += (fees * buyCommunityFee) / buyTotalFees;
1447 
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
1520         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1521 
1522         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1523 
1524         uint256 ethForCommunity = ethBalance.mul(tokensForCommunity).div(totalTokensToSwap);
1525 
1526         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev - ethForCommunity;
1527 
1528         tokensForLiquidity = 0;
1529         tokensForMarketing = 0;
1530         tokensForDev = 0;
1531         tokensForCommunity = 0;
1532 
1533         (success, ) = address(devWallet).call{value: ethForDev}("");
1534 
1535         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1536             addLiquidity(liquidityTokens, ethForLiquidity);
1537             emit SwapAndLiquify(
1538                 amountToSwapForETH,
1539                 ethForLiquidity,
1540                 tokensForLiquidity
1541             );
1542         }
1543 
1544         (success, ) = address(communityWallet).call{value: ethForCommunity}("");
1545 
1546         (success, ) = address(marketingWallet).call{value: address(this).balance}("");
1547 
1548     }
1549 
1550     function setAutoLPBurnSettings(
1551         uint256 _frequencyInSeconds,
1552         uint256 _percent,
1553         bool _Enabled
1554     ) external onlyOwner {
1555         require(
1556             _frequencyInSeconds >= 600,
1557             "cannot set buyback more often than every 10 minutes"
1558         );
1559         require(
1560             _percent <= 1000 && _percent >= 0,
1561             "Must set auto LP burn percent between 0% and 10%"
1562         );
1563         lpBurnFrequency = _frequencyInSeconds;
1564         percentForLPBurn = _percent;
1565         lpBurnEnabled = _Enabled;
1566     }
1567 
1568     function autoBurnLiquidityPairTokens() internal returns (bool) {
1569         lastLpBurnTime = block.timestamp;
1570 
1571         // get balance of liquidity pair
1572         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1573 
1574         // calculate amount to burn
1575         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1576             10000
1577         );
1578 
1579         // pull tokens from pancakePair liquidity and move to dead address permanently
1580         if (amountToBurn > 0) {
1581             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1582         }
1583 
1584         //sync price since this is not in a swap transaction!
1585         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1586         pair.sync();
1587         emit AutoNukeLP();
1588         return true;
1589     }
1590 
1591     function manualBurnLiquidityPairTokens(uint256 percent)
1592         external
1593         onlyOwner
1594         returns (bool)
1595     {
1596         require(
1597             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1598             "Must wait for cooldown to finish"
1599         );
1600         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1601         lastManualLpBurnTime = block.timestamp;
1602 
1603         // get balance of liquidity pair
1604         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1605 
1606         // calculate amount to burn
1607         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1608 
1609         // pull tokens from pancakePair liquidity and move to dead address permanently
1610         if (amountToBurn > 0) {
1611             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1612         }
1613 
1614         //sync price since this is not in a swap transaction!
1615         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1616         pair.sync();
1617         emit ManualNukeLP();
1618         return true;
1619     }
1620 }