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
804 /* pragma solidity 0.8.10; */
805 /* pragma experimental ABIEncoderV2; */
806 
807 interface IUniswapV2Factory {
808     event PairCreated(
809         address indexed token0,
810         address indexed token1,
811         address pair,
812         uint256
813     );
814 
815     function feeTo() external view returns (address);
816 
817     function feeToSetter() external view returns (address);
818 
819     function getPair(address tokenA, address tokenB)
820         external
821         view
822         returns (address pair);
823 
824     function allPairs(uint256) external view returns (address pair);
825 
826     function allPairsLength() external view returns (uint256);
827 
828     function createPair(address tokenA, address tokenB)
829         external
830         returns (address pair);
831 
832     function setFeeTo(address) external;
833 
834     function setFeeToSetter(address) external;
835 }
836 
837 /* pragma solidity 0.8.10; */
838 /* pragma experimental ABIEncoderV2; */
839 
840 interface IUniswapV2Pair {
841     event Approval(
842         address indexed owner,
843         address indexed spender,
844         uint256 value
845     );
846     event Transfer(address indexed from, address indexed to, uint256 value);
847 
848     function name() external pure returns (string memory);
849 
850     function symbol() external pure returns (string memory);
851 
852     function decimals() external pure returns (uint8);
853 
854     function totalSupply() external view returns (uint256);
855 
856     function balanceOf(address owner) external view returns (uint256);
857 
858     function allowance(address owner, address spender)
859         external
860         view
861         returns (uint256);
862 
863     function approve(address spender, uint256 value) external returns (bool);
864 
865     function transfer(address to, uint256 value) external returns (bool);
866 
867     function transferFrom(
868         address from,
869         address to,
870         uint256 value
871     ) external returns (bool);
872 
873     function DOMAIN_SEPARATOR() external view returns (bytes32);
874 
875     function PERMIT_TYPEHASH() external pure returns (bytes32);
876 
877     function nonces(address owner) external view returns (uint256);
878 
879     function permit(
880         address owner,
881         address spender,
882         uint256 value,
883         uint256 deadline,
884         uint8 v,
885         bytes32 r,
886         bytes32 s
887     ) external;
888 
889     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
890     event Burn(
891         address indexed sender,
892         uint256 amount0,
893         uint256 amount1,
894         address indexed to
895     );
896     event Swap(
897         address indexed sender,
898         uint256 amount0In,
899         uint256 amount1In,
900         uint256 amount0Out,
901         uint256 amount1Out,
902         address indexed to
903     );
904     event Sync(uint112 reserve0, uint112 reserve1);
905 
906     function MINIMUM_LIQUIDITY() external pure returns (uint256);
907 
908     function factory() external view returns (address);
909 
910     function token0() external view returns (address);
911 
912     function token1() external view returns (address);
913 
914     function getReserves()
915         external
916         view
917         returns (
918             uint112 reserve0,
919             uint112 reserve1,
920             uint32 blockTimestampLast
921         );
922 
923     function price0CumulativeLast() external view returns (uint256);
924 
925     function price1CumulativeLast() external view returns (uint256);
926 
927     function kLast() external view returns (uint256);
928 
929     function mint(address to) external returns (uint256 liquidity);
930 
931     function burn(address to)
932         external
933         returns (uint256 amount0, uint256 amount1);
934 
935     function swap(
936         uint256 amount0Out,
937         uint256 amount1Out,
938         address to,
939         bytes calldata data
940     ) external;
941 
942     function skim(address to) external;
943 
944     function sync() external;
945 
946     function initialize(address, address) external;
947 }
948 
949 /* pragma solidity 0.8.10; */
950 /* pragma experimental ABIEncoderV2; */
951 
952 interface IUniswapV2Router02 {
953     function factory() external pure returns (address);
954 
955     function WETH() external pure returns (address);
956 
957     function addLiquidity(
958         address tokenA,
959         address tokenB,
960         uint256 amountADesired,
961         uint256 amountBDesired,
962         uint256 amountAMin,
963         uint256 amountBMin,
964         address to,
965         uint256 deadline
966     )
967         external
968         returns (
969             uint256 amountA,
970             uint256 amountB,
971             uint256 liquidity
972         );
973 
974     function addLiquidityETH(
975         address token,
976         uint256 amountTokenDesired,
977         uint256 amountTokenMin,
978         uint256 amountETHMin,
979         address to,
980         uint256 deadline
981     )
982         external
983         payable
984         returns (
985             uint256 amountToken,
986             uint256 amountETH,
987             uint256 liquidity
988         );
989 
990     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
991         uint256 amountIn,
992         uint256 amountOutMin,
993         address[] calldata path,
994         address to,
995         uint256 deadline
996     ) external;
997 
998     function swapExactETHForTokensSupportingFeeOnTransferTokens(
999         uint256 amountOutMin,
1000         address[] calldata path,
1001         address to,
1002         uint256 deadline
1003     ) external payable;
1004 
1005     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1006         uint256 amountIn,
1007         uint256 amountOutMin,
1008         address[] calldata path,
1009         address to,
1010         uint256 deadline
1011     ) external;
1012 }
1013 
1014 /* pragma solidity >=0.8.10; */
1015 
1016 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1017 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1018 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1019 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1020 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1021 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1022 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1023 
1024 contract AmaterasuInu is ERC20, Ownable {
1025     using SafeMath for uint256;
1026 
1027     IUniswapV2Router02 public immutable uniswapV2Router;
1028     address public immutable uniswapV2Pair;
1029     address public constant deadAddress = address(0xdead);
1030 
1031     bool private swapping;
1032 
1033 	address public charityWallet;
1034     address public marketingWallet;
1035     address public devWallet;
1036 
1037     uint256 public maxTransactionAmount;
1038     uint256 public swapTokensAtAmount;
1039     uint256 public maxWallet;
1040 
1041     bool public limitsInEffect = true;
1042     bool public tradingActive = true;
1043     bool public swapEnabled = true;
1044 
1045     // Anti-bot and anti-whale mappings and variables
1046     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1047     bool public transferDelayEnabled = true;
1048 
1049     uint256 public buyTotalFees;
1050 	uint256 public buyCharityFee;
1051     uint256 public buyMarketingFee;
1052     uint256 public buyLiquidityFee;
1053     uint256 public buyDevFee;
1054 
1055     uint256 public sellTotalFees;
1056 	uint256 public sellCharityFee;
1057     uint256 public sellMarketingFee;
1058     uint256 public sellLiquidityFee;
1059     uint256 public sellDevFee;
1060 
1061 	uint256 public tokensForCharity;
1062     uint256 public tokensForMarketing;
1063     uint256 public tokensForLiquidity;
1064     uint256 public tokensForDev;
1065 
1066     /******************/
1067 
1068     // exlcude from fees and max transaction amount
1069     mapping(address => bool) private _isExcludedFromFees;
1070     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1071 
1072     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1073     // could be subject to a maximum transfer amount
1074     mapping(address => bool) public automatedMarketMakerPairs;
1075 
1076     event UpdateUniswapV2Router(
1077         address indexed newAddress,
1078         address indexed oldAddress
1079     );
1080 
1081     event ExcludeFromFees(address indexed account, bool isExcluded);
1082 
1083     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1084 
1085     event SwapAndLiquify(
1086         uint256 tokensSwapped,
1087         uint256 ethReceived,
1088         uint256 tokensIntoLiquidity
1089     );
1090 
1091     constructor() ERC20("AmaterasuInu", "ERASU") {
1092         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1093             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1094         );
1095 
1096         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1097         uniswapV2Router = _uniswapV2Router;
1098 
1099         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1100             .createPair(address(this), _uniswapV2Router.WETH());
1101         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1102         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1103 
1104 		uint256 _buyCharityFee = 1;
1105         uint256 _buyMarketingFee = 2;
1106         uint256 _buyLiquidityFee = 1;
1107         uint256 _buyDevFee = 6;
1108 
1109 		uint256 _sellCharityFee = 1;
1110         uint256 _sellMarketingFee = 2;
1111         uint256 _sellLiquidityFee = 1;
1112         uint256 _sellDevFee = 26;
1113 
1114         uint256 totalSupply = 1000000000 * 1e18;
1115 
1116         maxTransactionAmount = 20000000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1117         maxWallet = 20000000 * 1e18; // 2% from total supply maxWallet
1118         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1119 
1120 		buyCharityFee = _buyCharityFee;
1121         buyMarketingFee = _buyMarketingFee;
1122         buyLiquidityFee = _buyLiquidityFee;
1123         buyDevFee = _buyDevFee;
1124         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1125 
1126 		sellCharityFee = _sellCharityFee;
1127         sellMarketingFee = _sellMarketingFee;
1128         sellLiquidityFee = _sellLiquidityFee;
1129         sellDevFee = _sellDevFee;
1130         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1131 
1132 		charityWallet = address(0xB333aC0e6fe5E92fe5E01CBe56E0a682D021117A); // set as charity wallet
1133         marketingWallet = address(0x73765c4Cd30c9f9917f9F842a7BE59b40472b752); // set as marketing wallet
1134         devWallet = address(0x7fb3D82460EaA7Ba062194e7c6eF370fDf415aD3); // set as dev wallet
1135 
1136         // exclude from paying fees or having max transaction amount
1137         excludeFromFees(owner(), true);
1138         excludeFromFees(address(this), true);
1139         excludeFromFees(address(0xdead), true);
1140 
1141         excludeFromMaxTransaction(owner(), true);
1142         excludeFromMaxTransaction(address(this), true);
1143         excludeFromMaxTransaction(address(0xdead), true);
1144 
1145         /*
1146             _mint is an internal function in ERC20.sol that is only called here,
1147             and CANNOT be called ever again
1148         */
1149         _mint(msg.sender, totalSupply);
1150     }
1151 
1152     receive() external payable {}
1153 
1154     // once enabled, can never be turned off
1155     function enableTrading() external onlyOwner {
1156         tradingActive = true;
1157         swapEnabled = true;
1158     }
1159 
1160     // remove limits after token is stable
1161     function removeLimits() external onlyOwner returns (bool) {
1162         limitsInEffect = false;
1163         return true;
1164     }
1165 
1166     // disable Transfer delay - cannot be reenabled
1167     function disableTransferDelay() external onlyOwner returns (bool) {
1168         transferDelayEnabled = false;
1169         return true;
1170     }
1171 
1172     // change the minimum amount of tokens to sell from fees
1173     function updateSwapTokensAtAmount(uint256 newAmount)
1174         external
1175         onlyOwner
1176         returns (bool)
1177     {
1178         require(
1179             newAmount >= (totalSupply() * 1) / 100000,
1180             "Swap amount cannot be lower than 0.001% total supply."
1181         );
1182         require(
1183             newAmount <= (totalSupply() * 5) / 1000,
1184             "Swap amount cannot be higher than 0.5% total supply."
1185         );
1186         swapTokensAtAmount = newAmount;
1187         return true;
1188     }
1189 
1190     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1191         require(
1192             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1193             "Cannot set maxTransactionAmount lower than 0.5%"
1194         );
1195         maxTransactionAmount = newNum * (10**18);
1196     }
1197 
1198     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1199         require(
1200             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1201             "Cannot set maxWallet lower than 0.5%"
1202         );
1203         maxWallet = newNum * (10**18);
1204     }
1205 	
1206     function excludeFromMaxTransaction(address updAds, bool isEx)
1207         public
1208         onlyOwner
1209     {
1210         _isExcludedMaxTransactionAmount[updAds] = isEx;
1211     }
1212 
1213     // only use to disable contract sales if absolutely necessary (emergency use only)
1214     function updateSwapEnabled(bool enabled) external onlyOwner {
1215         swapEnabled = enabled;
1216     }
1217 
1218     function updateBuyFees(
1219 		uint256 _charityFee,
1220         uint256 _marketingFee,
1221         uint256 _liquidityFee,
1222         uint256 _devFee
1223     ) external onlyOwner {
1224 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1225 		buyCharityFee = _charityFee;
1226         buyMarketingFee = _marketingFee;
1227         buyLiquidityFee = _liquidityFee;
1228         buyDevFee = _devFee;
1229         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1230      }
1231 
1232     function updateSellFees(
1233 		uint256 _charityFee,
1234         uint256 _marketingFee,
1235         uint256 _liquidityFee,
1236         uint256 _devFee
1237     ) external onlyOwner {
1238 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1239 		sellCharityFee = _charityFee;
1240         sellMarketingFee = _marketingFee;
1241         sellLiquidityFee = _liquidityFee;
1242         sellDevFee = _devFee;
1243         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1244     }
1245 
1246     function excludeFromFees(address account, bool excluded) public onlyOwner {
1247         _isExcludedFromFees[account] = excluded;
1248         emit ExcludeFromFees(account, excluded);
1249     }
1250 
1251     function setAutomatedMarketMakerPair(address pair, bool value)
1252         public
1253         onlyOwner
1254     {
1255         require(
1256             pair != uniswapV2Pair,
1257             "The pair cannot be removed from automatedMarketMakerPairs"
1258         );
1259 
1260         _setAutomatedMarketMakerPair(pair, value);
1261     }
1262 
1263     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1264         automatedMarketMakerPairs[pair] = value;
1265 
1266         emit SetAutomatedMarketMakerPair(pair, value);
1267     }
1268 
1269     function isExcludedFromFees(address account) public view returns (bool) {
1270         return _isExcludedFromFees[account];
1271     }
1272 
1273     function _transfer(
1274         address from,
1275         address to,
1276         uint256 amount
1277     ) internal override {
1278         require(from != address(0), "ERC20: transfer from the zero address");
1279         require(to != address(0), "ERC20: transfer to the zero address");
1280 
1281         if (amount == 0) {
1282             super._transfer(from, to, 0);
1283             return;
1284         }
1285 
1286         if (limitsInEffect) {
1287             if (
1288                 from != owner() &&
1289                 to != owner() &&
1290                 to != address(0) &&
1291                 to != address(0xdead) &&
1292                 !swapping
1293             ) {
1294                 if (!tradingActive) {
1295                     require(
1296                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1297                         "Trading is not active."
1298                     );
1299                 }
1300 
1301                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1302                 if (transferDelayEnabled) {
1303                     if (
1304                         to != owner() &&
1305                         to != address(uniswapV2Router) &&
1306                         to != address(uniswapV2Pair)
1307                     ) {
1308                         require(
1309                             _holderLastTransferTimestamp[tx.origin] <
1310                                 block.number,
1311                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1312                         );
1313                         _holderLastTransferTimestamp[tx.origin] = block.number;
1314                     }
1315                 }
1316 
1317                 //when buy
1318                 if (
1319                     automatedMarketMakerPairs[from] &&
1320                     !_isExcludedMaxTransactionAmount[to]
1321                 ) {
1322                     require(
1323                         amount <= maxTransactionAmount,
1324                         "Buy transfer amount exceeds the maxTransactionAmount."
1325                     );
1326                     require(
1327                         amount + balanceOf(to) <= maxWallet,
1328                         "Max wallet exceeded"
1329                     );
1330                 }
1331                 //when sell
1332                 else if (
1333                     automatedMarketMakerPairs[to] &&
1334                     !_isExcludedMaxTransactionAmount[from]
1335                 ) {
1336                     require(
1337                         amount <= maxTransactionAmount,
1338                         "Sell transfer amount exceeds the maxTransactionAmount."
1339                     );
1340                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1341                     require(
1342                         amount + balanceOf(to) <= maxWallet,
1343                         "Max wallet exceeded"
1344                     );
1345                 }
1346             }
1347         }
1348 
1349         uint256 contractTokenBalance = balanceOf(address(this));
1350 
1351         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1352 
1353         if (
1354             canSwap &&
1355             swapEnabled &&
1356             !swapping &&
1357             !automatedMarketMakerPairs[from] &&
1358             !_isExcludedFromFees[from] &&
1359             !_isExcludedFromFees[to]
1360         ) {
1361             swapping = true;
1362 
1363             swapBack();
1364 
1365             swapping = false;
1366         }
1367 
1368         bool takeFee = !swapping;
1369 
1370         // if any account belongs to _isExcludedFromFee account then remove the fee
1371         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1372             takeFee = false;
1373         }
1374 
1375         uint256 fees = 0;
1376         // only take fees on buys/sells, do not take on wallet transfers
1377         if (takeFee) {
1378             // on sell
1379             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1380                 fees = amount.mul(sellTotalFees).div(100);
1381 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1382                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1383                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1384                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1385             }
1386             // on buy
1387             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1388                 fees = amount.mul(buyTotalFees).div(100);
1389 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1390                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1391                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1392                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1393             }
1394 
1395             if (fees > 0) {
1396                 super._transfer(from, address(this), fees);
1397             }
1398 
1399             amount -= fees;
1400         }
1401 
1402         super._transfer(from, to, amount);
1403     }
1404 
1405     function swapTokensForEth(uint256 tokenAmount) private {
1406         // generate the uniswap pair path of token -> weth
1407         address[] memory path = new address[](2);
1408         path[0] = address(this);
1409         path[1] = uniswapV2Router.WETH();
1410 
1411         _approve(address(this), address(uniswapV2Router), tokenAmount);
1412 
1413         // make the swap
1414         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1415             tokenAmount,
1416             0, // accept any amount of ETH
1417             path,
1418             address(this),
1419             block.timestamp
1420         );
1421     }
1422 
1423     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1424         // approve token transfer to cover all possible scenarios
1425         _approve(address(this), address(uniswapV2Router), tokenAmount);
1426 
1427         // add the liquidity
1428         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1429             address(this),
1430             tokenAmount,
1431             0, // slippage is unavoidable
1432             0, // slippage is unavoidable
1433             devWallet,
1434             block.timestamp
1435         );
1436     }
1437 
1438     function swapBack() private {
1439         uint256 contractBalance = balanceOf(address(this));
1440         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1441         bool success;
1442 
1443         if (contractBalance == 0 || totalTokensToSwap == 0) {
1444             return;
1445         }
1446 
1447         if (contractBalance > swapTokensAtAmount * 20) {
1448             contractBalance = swapTokensAtAmount * 20;
1449         }
1450 
1451         // Halve the amount of liquidity tokens
1452         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1453         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1454 
1455         uint256 initialETHBalance = address(this).balance;
1456 
1457         swapTokensForEth(amountToSwapForETH);
1458 
1459         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1460 
1461 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1462         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1463         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1464 
1465         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1466 
1467         tokensForLiquidity = 0;
1468 		tokensForCharity = 0;
1469         tokensForMarketing = 0;
1470         tokensForDev = 0;
1471 
1472         (success, ) = address(devWallet).call{value: ethForDev}("");
1473         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1474 
1475 
1476         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1477             addLiquidity(liquidityTokens, ethForLiquidity);
1478             emit SwapAndLiquify(
1479                 amountToSwapForETH,
1480                 ethForLiquidity,
1481                 tokensForLiquidity
1482             );
1483         }
1484 
1485         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1486     }
1487 
1488 }