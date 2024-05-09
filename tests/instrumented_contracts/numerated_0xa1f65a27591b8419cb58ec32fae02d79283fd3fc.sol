1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.17 >=0.8.10 >=0.8.0 <0.9.0;
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
447 
448         _beforeTokenTransfer(sender, recipient, amount);
449 
450         uint256 senderBalance = _balances[sender];
451         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
452         unchecked {
453             _balances[sender] = senderBalance - amount;
454         }
455         _balances[recipient] += amount;
456 
457         emit Transfer(sender, recipient, amount);
458 
459         _afterTokenTransfer(sender, recipient, amount);
460     }
461 
462     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
463      * the total supply.
464      *
465      * Emits a {Transfer} event with `from` set to the zero address.
466      *
467      * Requirements:
468      *
469      * - `account` cannot be the zero address.
470      */
471     function _mint(address account, uint256 amount) internal virtual {
472         require(account != address(0), "ERC20: mint to the zero address");
473 
474         _beforeTokenTransfer(address(0), account, amount);
475 
476         _totalSupply += amount;
477         _balances[account] += amount;
478         emit Transfer(address(0), account, amount);
479 
480         _afterTokenTransfer(address(0), account, amount);
481     }
482 
483     /**
484      * @dev Destroys `amount` tokens from `account`, reducing the
485      * total supply.
486      *
487      * Emits a {Transfer} event with `to` set to the zero address.
488      *
489      * Requirements:
490      *
491      * - `account` cannot be the zero address.
492      * - `account` must have at least `amount` tokens.
493      */
494     function _burn(address account, uint256 amount) internal virtual {
495         require(account != address(0), "ERC20: burn from the zero address");
496 
497         _beforeTokenTransfer(account, address(0), amount);
498 
499         uint256 accountBalance = _balances[account];
500         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
501         unchecked {
502             _balances[account] = accountBalance - amount;
503         }
504         _totalSupply -= amount;
505 
506         emit Transfer(account, address(0), amount);
507 
508         _afterTokenTransfer(account, address(0), amount);
509     }
510 
511     /**
512      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
513      *
514      * This internal function is equivalent to `approve`, and can be used to
515      * e.g. set automatic allowances for certain subsystems, etc.
516      *
517      * Emits an {Approval} event.
518      *
519      * Requirements:
520      *
521      * - `owner` cannot be the zero address.
522      * - `spender` cannot be the zero address.
523      */
524     function _approve(
525         address owner,
526         address spender,
527         uint256 amount
528     ) internal virtual {
529         require(owner != address(0), "ERC20: approve from the zero address");
530         require(spender != address(0), "ERC20: approve to the zero address");
531 
532         _allowances[owner][spender] = amount;
533         emit Approval(owner, spender, amount);
534     }
535 
536     /**
537      * @dev Hook that is called before any transfer of tokens. This includes
538      * minting and burning.
539      *
540      * Calling conditions:
541      *
542      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
543      * will be transferred to `to`.
544      * - when `from` is zero, `amount` tokens will be minted for `to`.
545      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
546      * - `from` and `to` are never both zero.
547      *
548      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
549      */
550     function _beforeTokenTransfer(
551         address from,
552         address to,
553         uint256 amount
554     ) internal virtual {}
555 
556     /**
557      * @dev Hook that is called after any transfer of tokens. This includes
558      * minting and burning.
559      *
560      * Calling conditions:
561      *
562      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
563      * has been transferred to `to`.
564      * - when `from` is zero, `amount` tokens have been minted for `to`.
565      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
566      * - `from` and `to` are never both zero.
567      *
568      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
569      */
570     function _afterTokenTransfer(
571         address from,
572         address to,
573         uint256 amount
574     ) internal virtual {}
575 }
576 
577 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
578 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
579 
580 /* pragma solidity ^0.8.0; */
581 
582 // CAUTION
583 // This version of SafeMath should only be used with Solidity 0.8 or later,
584 // because it relies on the compiler's built in overflow checks.
585 
586 /**
587  * @dev Wrappers over Solidity's arithmetic operations.
588  *
589  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
590  * now has built in overflow checking.
591  */
592 library SafeMath {
593     /**
594      * @dev Returns the addition of two unsigned integers, with an overflow flag.
595      *
596      * _Available since v3.4._
597      */
598     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
599         unchecked {
600             uint256 c = a + b;
601             if (c < a) return (false, 0);
602             return (true, c);
603         }
604     }
605 
606     /**
607      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
608      *
609      * _Available since v3.4._
610      */
611     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
612         unchecked {
613             if (b > a) return (false, 0);
614             return (true, a - b);
615         }
616     }
617 
618     /**
619      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
620      *
621      * _Available since v3.4._
622      */
623     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
624         unchecked {
625             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
626             // benefit is lost if 'b' is also tested.
627             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
628             if (a == 0) return (true, 0);
629             uint256 c = a * b;
630             if (c / a != b) return (false, 0);
631             return (true, c);
632         }
633     }
634 
635     /**
636      * @dev Returns the division of two unsigned integers, with a division by zero flag.
637      *
638      * _Available since v3.4._
639      */
640     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
641         unchecked {
642             if (b == 0) return (false, 0);
643             return (true, a / b);
644         }
645     }
646 
647     /**
648      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
649      *
650      * _Available since v3.4._
651      */
652     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
653         unchecked {
654             if (b == 0) return (false, 0);
655             return (true, a % b);
656         }
657     }
658 
659     /**
660      * @dev Returns the addition of two unsigned integers, reverting on
661      * overflow.
662      *
663      * Counterpart to Solidity's `+` operator.
664      *
665      * Requirements:
666      *
667      * - Addition cannot overflow.
668      */
669     function add(uint256 a, uint256 b) internal pure returns (uint256) {
670         return a + b;
671     }
672 
673     /**
674      * @dev Returns the subtraction of two unsigned integers, reverting on
675      * overflow (when the result is negative).
676      *
677      * Counterpart to Solidity's `-` operator.
678      *
679      * Requirements:
680      *
681      * - Subtraction cannot overflow.
682      */
683     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a - b;
685     }
686 
687     /**
688      * @dev Returns the multiplication of two unsigned integers, reverting on
689      * overflow.
690      *
691      * Counterpart to Solidity's `*` operator.
692      *
693      * Requirements:
694      *
695      * - Multiplication cannot overflow.
696      */
697     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
698         return a * b;
699     }
700 
701     /**
702      * @dev Returns the integer division of two unsigned integers, reverting on
703      * division by zero. The result is rounded towards zero.
704      *
705      * Counterpart to Solidity's `/` operator.
706      *
707      * Requirements:
708      *
709      * - The divisor cannot be zero.
710      */
711     function div(uint256 a, uint256 b) internal pure returns (uint256) {
712         return a / b;
713     }
714 
715     /**
716      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
717      * reverting when dividing by zero.
718      *
719      * Counterpart to Solidity's `%` operator. This function uses a `revert`
720      * opcode (which leaves remaining gas untouched) while Solidity uses an
721      * invalid opcode to revert (consuming all remaining gas).
722      *
723      * Requirements:
724      *
725      * - The divisor cannot be zero.
726      */
727     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
728         return a % b;
729     }
730 
731     /**
732      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
733      * overflow (when the result is negative).
734      *
735      * CAUTION: This function is deprecated because it requires allocating memory for the error
736      * message unnecessarily. For custom revert reasons use {trySub}.
737      *
738      * Counterpart to Solidity's `-` operator.
739      *
740      * Requirements:
741      *
742      * - Subtraction cannot overflow.
743      */
744     function sub(
745         uint256 a,
746         uint256 b,
747         string memory errorMessage
748     ) internal pure returns (uint256) {
749         unchecked {
750             require(b <= a, errorMessage);
751             return a - b;
752         }
753     }
754 
755     /**
756      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
757      * division by zero. The result is rounded towards zero.
758      *
759      * Counterpart to Solidity's `/` operator. Note: this function uses a
760      * `revert` opcode (which leaves remaining gas untouched) while Solidity
761      * uses an invalid opcode to revert (consuming all remaining gas).
762      *
763      * Requirements:
764      *
765      * - The divisor cannot be zero.
766      */
767     function div(
768         uint256 a,
769         uint256 b,
770         string memory errorMessage
771     ) internal pure returns (uint256) {
772         unchecked {
773             require(b > 0, errorMessage);
774             return a / b;
775         }
776     }
777 
778     /**
779      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
780      * reverting with custom message when dividing by zero.
781      *
782      * CAUTION: This function is deprecated because it requires allocating memory for the error
783      * message unnecessarily. For custom revert reasons use {tryMod}.
784      *
785      * Counterpart to Solidity's `%` operator. This function uses a `revert`
786      * opcode (which leaves remaining gas untouched) while Solidity uses an
787      * invalid opcode to revert (consuming all remaining gas).
788      *
789      * Requirements:
790      *
791      * - The divisor cannot be zero.
792      */
793     function mod(
794         uint256 a,
795         uint256 b,
796         string memory errorMessage
797     ) internal pure returns (uint256) {
798         unchecked {
799             require(b > 0, errorMessage);
800             return a % b;
801         }
802     }
803 }
804 
805 ////// src/IUniswapV2Factory.sol
806 /* pragma solidity 0.8.10; */
807 /* pragma experimental ABIEncoderV2; */
808 
809 interface IUniswapV2Factory {
810     event PairCreated(
811         address indexed token0,
812         address indexed token1,
813         address pair,
814         uint256
815     );
816 
817     function feeTo() external view returns (address);
818 
819     function feeToSetter() external view returns (address);
820 
821     function getPair(address tokenA, address tokenB)
822         external
823         view
824         returns (address pair);
825 
826     function allPairs(uint256) external view returns (address pair);
827 
828     function allPairsLength() external view returns (uint256);
829 
830     function createPair(address tokenA, address tokenB)
831         external
832         returns (address pair);
833 
834     function setFeeTo(address) external;
835 
836     function setFeeToSetter(address) external;
837 }
838 
839 ////// src/IUniswapV2Pair.sol
840 /* pragma solidity 0.8.10; */
841 /* pragma experimental ABIEncoderV2; */
842 
843 interface IUniswapV2Pair {
844     event Approval(
845         address indexed owner,
846         address indexed spender,
847         uint256 value
848     );
849     event Transfer(address indexed from, address indexed to, uint256 value);
850 
851     function name() external pure returns (string memory);
852 
853     function symbol() external pure returns (string memory);
854 
855     function decimals() external pure returns (uint8);
856 
857     function totalSupply() external view returns (uint256);
858 
859     function balanceOf(address owner) external view returns (uint256);
860 
861     function allowance(address owner, address spender)
862         external
863         view
864         returns (uint256);
865 
866     function approve(address spender, uint256 value) external returns (bool);
867 
868     function transfer(address to, uint256 value) external returns (bool);
869 
870     function transferFrom(
871         address from,
872         address to,
873         uint256 value
874     ) external returns (bool);
875 
876     function DOMAIN_SEPARATOR() external view returns (bytes32);
877 
878     function PERMIT_TYPEHASH() external pure returns (bytes32);
879 
880     function nonces(address owner) external view returns (uint256);
881 
882     function permit(
883         address owner,
884         address spender,
885         uint256 value,
886         uint256 deadline,
887         uint8 v,
888         bytes32 r,
889         bytes32 s
890     ) external;
891 
892     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
893     event Burn(
894         address indexed sender,
895         uint256 amount0,
896         uint256 amount1,
897         address indexed to
898     );
899     event Swap(
900         address indexed sender,
901         uint256 amount0In,
902         uint256 amount1In,
903         uint256 amount0Out,
904         uint256 amount1Out,
905         address indexed to
906     );
907     event Sync(uint112 reserve0, uint112 reserve1);
908 
909     function MINIMUM_LIQUIDITY() external pure returns (uint256);
910 
911     function factory() external view returns (address);
912 
913     function token0() external view returns (address);
914 
915     function token1() external view returns (address);
916 
917     function getReserves()
918         external
919         view
920         returns (
921             uint112 reserve0,
922             uint112 reserve1,
923             uint32 blockTimestampLast
924         );
925 
926     function price0CumulativeLast() external view returns (uint256);
927 
928     function price1CumulativeLast() external view returns (uint256);
929 
930     function kLast() external view returns (uint256);
931 
932     function mint(address to) external returns (uint256 liquidity);
933 
934     function burn(address to)
935         external
936         returns (uint256 amount0, uint256 amount1);
937 
938     function swap(
939         uint256 amount0Out,
940         uint256 amount1Out,
941         address to,
942         bytes calldata data
943     ) external;
944 
945     function skim(address to) external;
946 
947     function sync() external;
948 
949     function initialize(address, address) external;
950 }
951 
952 ////// src/IUniswapV2Router02.sol
953 /* pragma solidity 0.8.10; */
954 /* pragma experimental ABIEncoderV2; */
955 
956 interface IUniswapV2Router02 {
957     function factory() external pure returns (address);
958 
959     function WETH() external pure returns (address);
960 
961     function addLiquidity(
962         address tokenA,
963         address tokenB,
964         uint256 amountADesired,
965         uint256 amountBDesired,
966         uint256 amountAMin,
967         uint256 amountBMin,
968         address to,
969         uint256 deadline
970     )
971         external
972         returns (
973             uint256 amountA,
974             uint256 amountB,
975             uint256 liquidity
976         );
977 
978     function addLiquidityETH(
979         address token,
980         uint256 amountTokenDesired,
981         uint256 amountTokenMin,
982         uint256 amountETHMin,
983         address to,
984         uint256 deadline
985     )
986         external
987         payable
988         returns (
989             uint256 amountToken,
990             uint256 amountETH,
991             uint256 liquidity
992         );
993 
994     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
995         uint256 amountIn,
996         uint256 amountOutMin,
997         address[] calldata path,
998         address to,
999         uint256 deadline
1000     ) external;
1001 
1002     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1003         uint256 amountOutMin,
1004         address[] calldata path,
1005         address to,
1006         uint256 deadline
1007     ) external payable;
1008 
1009     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1010         uint256 amountIn,
1011         uint256 amountOutMin,
1012         address[] calldata path,
1013         address to,
1014         uint256 deadline
1015     ) external;
1016 }
1017 
1018 contract $SHIPAD is ERC20, Ownable {
1019     using SafeMath for uint256;
1020 
1021     IUniswapV2Router02 public immutable uniswapV2Router;
1022     address public immutable uniswapV2Pair;
1023     address public constant deadAddress = address(0xdead);
1024     mapping (address => bool) private _blacklist;
1025 
1026     bool private swapping;
1027 
1028     address public marketingWallet;
1029     address public devWallet;
1030 
1031     uint256 public swapTokensAtAmount;
1032 
1033     bool public limitsInEffect = true;
1034     bool public tradingActive = false;
1035     bool public swapEnabled = false;
1036 
1037     // Anti-bot and anti-whale mappings and variables
1038     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1039     bool public transferDelayEnabled = true;
1040 
1041     uint256 public buyTotalFees;
1042     uint256 public buyMarketingFee;
1043     uint256 public buyLiquidityFee;
1044     uint256 public buyDevFee;
1045 
1046     uint256 public sellTotalFees;
1047     uint256 public sellMarketingFee;
1048     uint256 public sellLiquidityFee;
1049     uint256 public sellDevFee;
1050 
1051     uint256 public tokensForMarketing;
1052     uint256 public tokensForLiquidity;
1053     uint256 public tokensForDev;
1054 
1055     /******************/
1056 
1057     // exlcude from fees and max transaction amount
1058     mapping(address => bool) private _isExcludedFromFees;
1059 
1060     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1061     // could be subject to a maximum transfer amount
1062     mapping(address => bool) public automatedMarketMakerPairs;
1063 
1064     event UpdateUniswapV2Router(
1065         address indexed newAddress,
1066         address indexed oldAddress
1067     );
1068 
1069     event ExcludeFromFees(address indexed account, bool isExcluded);
1070 
1071     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1072 
1073     event marketingWalletUpdated(
1074         address indexed newWallet,
1075         address indexed oldWallet
1076     );
1077 
1078     event devWalletUpdated(
1079         address indexed newWallet,
1080         address indexed oldWallet
1081     );
1082 
1083     event SwapAndLiquify(
1084         uint256 tokensSwapped,
1085         uint256 ethReceived,
1086         uint256 tokensIntoLiquidity
1087     );
1088 
1089     event AutoNukeLP();
1090 
1091     event ManualNukeLP();
1092 
1093     constructor() ERC20("ShibPad", "$SHIPAD") {
1094         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1095             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1096         );
1097 
1098         uniswapV2Router = _uniswapV2Router;
1099 
1100         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1101             .createPair(address(this), _uniswapV2Router.WETH());
1102         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1103 
1104         uint256 _buyMarketingFee = 1;
1105         uint256 _buyLiquidityFee = 1;
1106         uint256 _buyDevFee = 1;
1107 
1108         uint256 _sellMarketingFee = 1;
1109         uint256 _sellLiquidityFee = 1;
1110         uint256 _sellDevFee = 1;
1111 
1112         uint256 totalSupply = 1_000_000_000_000 * 1e18;
1113 
1114         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1115 
1116         buyMarketingFee = _buyMarketingFee;
1117         buyLiquidityFee = _buyLiquidityFee;
1118         buyDevFee = _buyDevFee;
1119         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1120 
1121         sellMarketingFee = _sellMarketingFee;
1122         sellLiquidityFee = _sellLiquidityFee;
1123         sellDevFee = _sellDevFee;
1124         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1125 
1126         marketingWallet = address(0x4c823115e18eFeCb354e13d254Eacfd2c14fc294); // set as marketing wallet
1127         devWallet = address(0x4c823115e18eFeCb354e13d254Eacfd2c14fc294); // set as dev wallet
1128 
1129         // exclude from paying fees or having max transaction amount
1130         excludeFromFees(owner(), true);
1131         excludeFromFees(address(this), true);
1132         excludeFromFees(address(0xdead), true);
1133 
1134         /*
1135             _mint is an internal function in ERC20.sol that is only called here,
1136             and CANNOT be called ever again
1137         */
1138         _mint(msg.sender, totalSupply);
1139     }
1140 
1141     receive() external payable {}
1142 
1143     // once enabled, can never be turned off
1144     function enableTrading() external onlyOwner {
1145         tradingActive = true;
1146         swapEnabled = true;
1147     }
1148 
1149     // remove limits after token is stable
1150     function removeLimits() external onlyOwner returns (bool) {
1151         limitsInEffect = false;
1152         return true;
1153     }
1154 
1155     // disable Transfer delay - cannot be reenabled
1156     function disableTransferDelay() external onlyOwner returns (bool) {
1157         transferDelayEnabled = false;
1158         return true;
1159     }
1160 
1161     // change the minimum amount of tokens to sell from fees
1162     function updateSwapTokensAtAmount(uint256 newAmount)
1163         external
1164         onlyOwner
1165         returns (bool)
1166     {
1167         require(
1168             newAmount >= (totalSupply() * 1) / 100000,
1169             "Swap amount cannot be lower than 0.001% total supply."
1170         );
1171         require(
1172             newAmount <= (totalSupply() * 5) / 1000,
1173             "Swap amount cannot be higher than 0.5% total supply."
1174         );
1175         swapTokensAtAmount = newAmount;
1176         return true;
1177     }
1178 
1179 
1180     // only use to disable contract sales if absolutely necessary (emergency use only)
1181     function updateSwapEnabled(bool enabled) external onlyOwner {
1182         swapEnabled = enabled;
1183     }
1184 
1185     function updateBuyFees(
1186         uint256 _marketingFee,
1187         uint256 _liquidityFee,
1188         uint256 _devFee
1189     ) external onlyOwner {
1190         buyMarketingFee = _marketingFee;
1191         buyLiquidityFee = _liquidityFee;
1192         buyDevFee = _devFee;
1193         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1194         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1195     }
1196 
1197     function updateSellFees(
1198         uint256 _marketingFee,
1199         uint256 _liquidityFee,
1200         uint256 _devFee
1201     ) external onlyOwner {
1202         sellMarketingFee = _marketingFee;
1203         sellLiquidityFee = _liquidityFee;
1204         sellDevFee = _devFee;
1205         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1206         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1207     }
1208 
1209     function excludeFromFees(address account, bool excluded) public onlyOwner {
1210         _isExcludedFromFees[account] = excluded;
1211         emit ExcludeFromFees(account, excluded);
1212     }
1213 
1214     function setAutomatedMarketMakerPair(address pair, bool value)
1215         public
1216         onlyOwner
1217     {
1218         require(
1219             pair != uniswapV2Pair,
1220             "The pair cannot be removed from automatedMarketMakerPairs"
1221         );
1222 
1223         _setAutomatedMarketMakerPair(pair, value);
1224     }
1225 
1226     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1227         automatedMarketMakerPairs[pair] = value;
1228 
1229         emit SetAutomatedMarketMakerPair(pair, value);
1230     }
1231 
1232     function updateMarketingWallet(address newMarketingWallet)
1233         external
1234         onlyOwner
1235     {
1236         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1237         marketingWallet = newMarketingWallet;
1238     }
1239 
1240     function updateDevWallet(address newWallet) external onlyOwner {
1241         emit devWalletUpdated(newWallet, devWallet);
1242         devWallet = newWallet;
1243     }
1244 
1245     function isExcludedFromFees(address account) public view returns (bool) {
1246         return _isExcludedFromFees[account];
1247     }
1248 
1249     event BoughtEarly(address indexed sniper);
1250 
1251     function _transfer(
1252         address from,
1253         address to,
1254         uint256 amount
1255     ) internal override {
1256         require(from != address(0), "ERC20: transfer from the zero address");
1257         require(to != address(0), "ERC20: transfer to the zero address");
1258         require(!_blacklist[from] && !_blacklist[to], "You are a bot");
1259 
1260         if (amount == 0) {
1261             super._transfer(from, to, 0);
1262             return;
1263         }
1264 
1265         if (limitsInEffect) {
1266             if (
1267                 from != owner() &&
1268                 to != owner() &&
1269                 to != address(0) &&
1270                 to != address(0xdead) &&
1271                 !swapping
1272             ) {
1273                 if (!tradingActive) {
1274                     require(
1275                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1276                         "Trading is not active."
1277                     );
1278                 }
1279 
1280                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1281                 if (transferDelayEnabled) {
1282                     if (
1283                         to != owner() &&
1284                         to != address(uniswapV2Router) &&
1285                         to != address(uniswapV2Pair)
1286                     ) {
1287                         require(
1288                             _holderLastTransferTimestamp[tx.origin] <
1289                                 block.number,
1290                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1291                         );
1292                         _holderLastTransferTimestamp[tx.origin] = block.number;
1293                     }
1294                 }
1295             }
1296         }
1297 
1298         uint256 contractTokenBalance = balanceOf(address(this));
1299 
1300         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1301 
1302         if (
1303             canSwap &&
1304             swapEnabled &&
1305             !swapping &&
1306             !automatedMarketMakerPairs[from] &&
1307             !_isExcludedFromFees[from] &&
1308             !_isExcludedFromFees[to]
1309         ) {
1310             swapping = true;
1311 
1312             swapBack();
1313 
1314             swapping = false;
1315         }
1316 
1317         bool takeFee = !swapping;
1318 
1319         // if any account belongs to _isExcludedFromFee account then remove the fee
1320         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1321             takeFee = false;
1322         }
1323 
1324         uint256 fees = 0;
1325         // only take fees on buys/sells, do not take on wallet transfers
1326         if (takeFee) {
1327             // on sell
1328             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1329                 fees = amount.mul(sellTotalFees).div(100);
1330                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1331                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1332                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1333             }
1334             // on buy
1335             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1336                 fees = amount.mul(buyTotalFees).div(100);
1337                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1338                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1339                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1340             }
1341 
1342             if (fees > 0) {
1343                 super._transfer(from, address(this), fees);
1344             }
1345 
1346             amount -= fees;
1347         }
1348 
1349         super._transfer(from, to, amount);
1350     }
1351 
1352     function addBL(address account, bool isBlacklisted) public onlyOwner {
1353         _blacklist[account] = isBlacklisted;
1354     }
1355  
1356     function multiBL(address[] memory multiblacklist_) public onlyOwner {
1357         for (uint256 i = 0; i < multiblacklist_.length; i++) {
1358             _blacklist[multiblacklist_[i]] = true;
1359         }
1360     }
1361 
1362     function swapTokensForEth(uint256 tokenAmount) private {
1363         // generate the uniswap pair path of token -> weth
1364         address[] memory path = new address[](2);
1365         path[0] = address(this);
1366         path[1] = uniswapV2Router.WETH();
1367 
1368         _approve(address(this), address(uniswapV2Router), tokenAmount);
1369 
1370         // make the swap
1371         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1372             tokenAmount,
1373             0, // accept any amount of ETH
1374             path,
1375             address(this),
1376             block.timestamp
1377         );
1378     }
1379 
1380     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1381         // approve token transfer to cover all possible scenarios
1382         _approve(address(this), address(uniswapV2Router), tokenAmount);
1383 
1384         // add the liquidity
1385         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1386             address(this),
1387             tokenAmount,
1388             0, // slippage is unavoidable
1389             0, // slippage is unavoidable
1390             deadAddress,
1391             block.timestamp
1392         );
1393     }
1394 
1395     function swapBack() private {
1396         uint256 contractBalance = balanceOf(address(this));
1397         uint256 totalTokensToSwap = tokensForLiquidity +
1398             tokensForMarketing +
1399             tokensForDev;
1400         bool success;
1401 
1402         if (contractBalance == 0 || totalTokensToSwap == 0) {
1403             return;
1404         }
1405 
1406         if (contractBalance > swapTokensAtAmount * 20) {
1407             contractBalance = swapTokensAtAmount * 20;
1408         }
1409 
1410         // Halve the amount of liquidity tokens
1411         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1412             totalTokensToSwap /
1413             2;
1414         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1415 
1416         uint256 initialETHBalance = address(this).balance;
1417 
1418         swapTokensForEth(amountToSwapForETH);
1419 
1420         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1421 
1422         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1423             totalTokensToSwap
1424         );
1425         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1426 
1427         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1428 
1429         tokensForLiquidity = 0;
1430         tokensForMarketing = 0;
1431         tokensForDev = 0;
1432 
1433         (success, ) = address(devWallet).call{value: ethForDev}("");
1434 
1435         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1436             addLiquidity(liquidityTokens, ethForLiquidity);
1437             emit SwapAndLiquify(
1438                 amountToSwapForETH,
1439                 ethForLiquidity,
1440                 tokensForLiquidity
1441             );
1442         }
1443 
1444         (success, ) = address(marketingWallet).call{
1445             value: address(this).balance
1446         }("");
1447     }
1448 }