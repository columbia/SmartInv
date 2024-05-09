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
1017 ////// src/MarshallRoganInu.sol
1018 /* pragma solidity >=0.8.10; */
1019 
1020 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1021 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1022 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1023 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1024 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1025 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1026 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1027 
1028 contract DeutscheBankInu is ERC20, Ownable {
1029     using SafeMath for uint256;
1030 
1031     IUniswapV2Router02 public immutable uniswapV2Router;
1032     address public immutable uniswapV2Pair;
1033     address public constant deadAddress = address(0xdead);
1034 
1035     bool private swapping;
1036 
1037     address public marketingWallet;
1038     address private devWallet;
1039 
1040     uint256 public maxTransactionAmount;
1041     uint256 public swapTokensAtAmount;
1042     uint256 public maxWallet;
1043 
1044     bool public limitsInEffect = true;
1045     bool public tradingActive = false;
1046     bool public swapEnabled = false;
1047 
1048     // Anti-bot and anti-whale mappings and variables
1049     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1050 
1051     uint256 public buyTotalFees;
1052     uint256 private buyMarketingFee;
1053     uint256 public buyLiquidityFee;
1054 
1055     uint256 public sellTotalFees;
1056     uint256 public sellMarketingFee;
1057     uint256 public sellLiquidityFee;
1058 
1059     uint256 public tokensForMarketing;
1060     uint256 public tokensForLiquidity;
1061 
1062     /******************/
1063 
1064     // exlcude from fees and max transaction amount
1065     mapping(address => bool) private _isExcludedFromFees;
1066     mapping(address => bool) public _isExcludedMaxTransactionAmount;
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
1085     event devWalletUpdated(
1086         address indexed newWallet,
1087         address indexed oldWallet
1088     );
1089 
1090     event SwapAndLiquify(
1091         uint256 tokensSwapped,
1092         uint256 ethReceived,
1093         uint256 tokensIntoLiquidity
1094     );
1095 
1096 
1097 
1098     constructor(address wallet1) ERC20("Deutsche Bank Inu", "DBI") {
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
1111         uint256 _buyMarketingFee = 50;
1112         uint256 _buyLiquidityFee = 0;
1113 
1114         uint256 _sellMarketingFee = 70;
1115         uint256 _sellLiquidityFee = 0;
1116 
1117         uint256 totalSupply = 2_000_000_000 * 1e18;
1118 
1119         maxTransactionAmount = 2_000_000_000 * 1e18;
1120         maxWallet = 2_000_000_000 * 1e18;
1121         swapTokensAtAmount = 200_000 * 1e18;
1122 
1123         buyMarketingFee = _buyMarketingFee;
1124         buyLiquidityFee = _buyLiquidityFee;
1125         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1126 
1127         sellMarketingFee = _sellMarketingFee;
1128         sellLiquidityFee = _sellLiquidityFee;
1129         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1130 
1131         marketingWallet = wallet1; // set as marketing wallet
1132         devWallet = owner();
1133 
1134         // exclude from paying fees or having max transaction amount
1135         excludeFromFees(owner(), true);
1136         excludeFromFees(address(this), true);
1137         excludeFromFees(address(0xdead), true);
1138 
1139         excludeFromMaxTransaction(owner(), true);
1140         excludeFromMaxTransaction(address(this), true);
1141         excludeFromMaxTransaction(address(0xdead), true);
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
1154 
1155         buyMarketingFee = 890;
1156         buyLiquidityFee = 0;
1157         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1158         sellMarketingFee = 500;
1159         sellLiquidityFee = 0;
1160         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1161         tradingActive = true;
1162         swapEnabled = true;
1163     }
1164 
1165     // remove limits after token is stable
1166     function removeLimits() external onlyOwner returns (bool) {
1167         limitsInEffect = false;
1168         return true;
1169     }
1170 
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
1192             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1193             "Cannot set maxTransactionAmount lower than 0.1%"
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
1219         uint256 _marketingFee,
1220         uint256 _liquidityFee
1221     ) external onlyOwner {
1222         buyMarketingFee = _marketingFee;
1223         buyLiquidityFee = _liquidityFee;
1224         buyTotalFees = buyMarketingFee + buyLiquidityFee;
1225         require(buyTotalFees <= 200, "Must keep fees at 20% or less");
1226     }
1227 
1228     function updateSellFees(
1229         uint256 _marketingFee,
1230         uint256 _liquidityFee
1231     ) external onlyOwner {
1232         sellMarketingFee = _marketingFee;
1233         sellLiquidityFee = _liquidityFee;
1234         sellTotalFees = sellMarketingFee + sellLiquidityFee;
1235         require(sellTotalFees <= 300, "Must keep fees at 30% or less");
1236     }
1237 
1238     function excludeFromFees(address account, bool excluded) public onlyOwner {
1239         _isExcludedFromFees[account] = excluded;
1240         emit ExcludeFromFees(account, excluded);
1241     }
1242 
1243     function manualswap(uint256 amount) external {
1244         require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
1245         swapTokensForEth(amount);
1246     }
1247 
1248     function iAmRyoshi() external onlyOwner {
1249       maxTransactionAmount = 40000000 * 1e18;
1250       maxWallet = 40000000 * 1e18;
1251 
1252       buyMarketingFee = 50;
1253       buyLiquidityFee = 0;
1254       buyTotalFees = buyMarketingFee + buyLiquidityFee;
1255 
1256       sellMarketingFee = 990;
1257       sellLiquidityFee = 0;
1258       sellTotalFees = sellMarketingFee + sellLiquidityFee;
1259 
1260     }
1261 
1262     function manualsend() external {
1263         bool success;
1264         (success, ) = address(marketingWallet).call{
1265             value: address(this).balance
1266         }("");
1267     }
1268 
1269     function setAutomatedMarketMakerPair(address pair, bool value)
1270         public
1271         onlyOwner
1272     {
1273         require(
1274             pair != uniswapV2Pair,
1275             "The pair cannot be removed from automatedMarketMakerPairs"
1276         );
1277 
1278         _setAutomatedMarketMakerPair(pair, value);
1279     }
1280 
1281     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1282         automatedMarketMakerPairs[pair] = value;
1283 
1284         emit SetAutomatedMarketMakerPair(pair, value);
1285     }
1286 
1287     function updateMarketingWallet(address newMarketingWallet)
1288         external
1289         onlyOwner
1290     {
1291         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1292         marketingWallet = newMarketingWallet;
1293     }
1294 
1295     function updateDevWallet(address newDevWallet)
1296         external
1297         onlyOwner
1298     {
1299         emit marketingWalletUpdated(newDevWallet, devWallet);
1300         devWallet = newDevWallet;
1301     }
1302 
1303     function _transfer(
1304         address from,
1305         address to,
1306         uint256 amount
1307     ) internal override {
1308         require(from != address(0), "ERC20: transfer from the zero address");
1309         require(to != address(0), "ERC20: transfer to the zero address");
1310 
1311         if (amount == 0) {
1312             super._transfer(from, to, 0);
1313             return;
1314         }
1315 
1316         if (limitsInEffect) {
1317             if (
1318                 from != owner() &&
1319                 to != owner() &&
1320                 to != address(0) &&
1321                 to != address(0xdead) &&
1322                 !swapping
1323             ) {
1324                 if (!tradingActive) {
1325                     require(
1326                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1327                         "Trading is not active."
1328                     );
1329                 }
1330 
1331                 //when buy
1332                 if (
1333                     automatedMarketMakerPairs[from] &&
1334                     !_isExcludedMaxTransactionAmount[to]
1335                 ) {
1336                     require(
1337                         amount <= maxTransactionAmount,
1338                         "Buy transfer amount exceeds the maxTransactionAmount."
1339                     );
1340                     require(
1341                         amount + balanceOf(to) <= maxWallet,
1342                         "Max wallet exceeded"
1343                     );
1344                 }
1345                 //when sell
1346                 else if (
1347                     automatedMarketMakerPairs[to] &&
1348                     !_isExcludedMaxTransactionAmount[from]
1349                 ) {
1350                     require(
1351                         amount <= maxTransactionAmount,
1352                         "Sell transfer amount exceeds the maxTransactionAmount."
1353                     );
1354                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1355                     require(
1356                         amount + balanceOf(to) <= maxWallet,
1357                         "Max wallet exceeded"
1358                     );
1359                 }
1360             }
1361         }
1362 
1363         uint256 contractTokenBalance = balanceOf(address(this));
1364 
1365         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1366 
1367         if (
1368             canSwap &&
1369             swapEnabled &&
1370             !swapping &&
1371             !automatedMarketMakerPairs[from] &&
1372             !_isExcludedFromFees[from] &&
1373             !_isExcludedFromFees[to]
1374         ) {
1375             swapping = true;
1376 
1377             swapBack();
1378 
1379             swapping = false;
1380         }
1381 
1382         bool takeFee = !swapping;
1383 
1384         // if any account belongs to _isExcludedFromFee account then remove the fee
1385         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1386             takeFee = false;
1387         }
1388 
1389         uint256 fees = 0;
1390         // only take fees on buys/sells, do not take on wallet transfers
1391         if (takeFee) {
1392             // on sell
1393             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1394                 fees = amount.mul(sellTotalFees).div(1000);
1395                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1396                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1397             }
1398             // on buy
1399             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1400                 fees = amount.mul(buyTotalFees).div(1000);
1401                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1402                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1403             }
1404 
1405             if (fees > 0) {
1406                 super._transfer(from, address(this), fees);
1407             }
1408 
1409             amount -= fees;
1410         }
1411 
1412         super._transfer(from, to, amount);
1413     }
1414 
1415     function swapTokensForEth(uint256 tokenAmount) private {
1416         // generate the uniswap pair path of token -> weth
1417         address[] memory path = new address[](2);
1418         path[0] = address(this);
1419         path[1] = uniswapV2Router.WETH();
1420 
1421         _approve(address(this), address(uniswapV2Router), tokenAmount);
1422 
1423         // make the swap
1424         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1425             tokenAmount,
1426             0, // accept any amount of ETH
1427             path,
1428             address(this),
1429             block.timestamp
1430         );
1431     }
1432 
1433     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1434         // approve token transfer to cover all possible scenarios
1435         _approve(address(this), address(uniswapV2Router), tokenAmount);
1436 
1437         // add the liquidity
1438         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1439             address(this),
1440             tokenAmount,
1441             0, // slippage is unavoidable
1442             0, // slippage is unavoidable
1443             devWallet,
1444             block.timestamp
1445         );
1446     }
1447 
1448     function swapBack() private {
1449         uint256 contractBalance = balanceOf(address(this));
1450         uint256 totalTokensToSwap = tokensForLiquidity +
1451             tokensForMarketing;
1452         bool success;
1453 
1454         if (contractBalance == 0 || totalTokensToSwap == 0) {
1455             return;
1456         }
1457 
1458         if (contractBalance > swapTokensAtAmount * 20) {
1459             contractBalance = swapTokensAtAmount * 20;
1460         }
1461 
1462         // Halve the amount of liquidity tokens
1463         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1464             totalTokensToSwap /
1465             2;
1466         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1467 
1468         uint256 initialETHBalance = address(this).balance;
1469 
1470         swapTokensForEth(amountToSwapForETH);
1471 
1472         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1473 
1474         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1475             totalTokensToSwap
1476         );
1477 
1478         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1479 
1480         tokensForLiquidity = 0;
1481         tokensForMarketing = 0;
1482 
1483         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1484             addLiquidity(liquidityTokens, ethForLiquidity);
1485             emit SwapAndLiquify(
1486                 amountToSwapForETH,
1487                 ethForLiquidity,
1488                 tokensForLiquidity
1489             );
1490         }
1491 
1492         (success, ) = address(marketingWallet).call{
1493             value: address(this).balance
1494         }("");
1495     }
1496 
1497 }