1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-29
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
7 pragma experimental ABIEncoderV2;
8 
9 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
10 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
11 
12 /* pragma solidity ^0.8.0; */
13 
14 /**
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
35 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
36 
37 /* pragma solidity ^0.8.0; */
38 
39 /* import "../utils/Context.sol"; */
40 
41 /**
42  * @dev Contract module which provides a basic access control mechanism, where
43  * there is an account (an owner) that can be granted exclusive access to
44  * specific functions.
45  *
46  * By default, the owner account will be the one that deploys the contract. This
47  * can later be changed with {transferOwnership}.
48  *
49  * This module is used through inheritance. It will make available the modifier
50  * `onlyOwner`, which can be applied to your functions to restrict their use to
51  * the owner.
52  */
53 abstract contract Ownable is Context {
54     address private _owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     /**
59      * @dev Initializes the contract setting the deployer as the initial owner.
60      */
61     constructor() {
62         _transferOwnership(_msgSender());
63     }
64 
65     /**
66      * @dev Returns the address of the current owner.
67      */
68     function owner() public view virtual returns (address) {
69         return _owner;
70     }
71 
72     /**
73      * @dev Throws if called by any account other than the owner.
74      */
75     modifier onlyOwner() {
76         require(owner() == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         _transferOwnership(address(0));
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Internal function without access restriction.
103      */
104     function _transferOwnership(address newOwner) internal virtual {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
112 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
113 
114 /* pragma solidity ^0.8.0; */
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP.
118  */
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     /**
126      * @dev Returns the amount of tokens owned by `account`.
127      */
128     function balanceOf(address account) external view returns (uint256);
129 
130     /**
131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transfer(address recipient, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through {transferFrom}. This is
142      * zero by default.
143      *
144      * This value changes when {approve} or {transferFrom} are called.
145      */
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * IMPORTANT: Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an {Approval} event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transferFrom(
174         address sender,
175         address recipient,
176         uint256 amount
177     ) external returns (bool);
178 
179     /**
180      * @dev Emitted when `value` tokens are moved from one account (`from`) to
181      * another (`to`).
182      *
183      * Note that `value` may be zero.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 value);
186 
187     /**
188      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
189      * a call to {approve}. `value` is the new allowance.
190      */
191     event Approval(address indexed owner, address indexed spender, uint256 value);
192 }
193 
194 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
195 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
196 
197 /* pragma solidity ^0.8.0; */
198 
199 /* import "../IERC20.sol"; */
200 
201 /**
202  * @dev Interface for the optional metadata functions from the ERC20 standard.
203  *
204  * _Available since v4.1._
205  */
206 interface IERC20Metadata is IERC20 {
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() external view returns (string memory);
211 
212     /**
213      * @dev Returns the symbol of the token.
214      */
215     function symbol() external view returns (string memory);
216 
217     /**
218      * @dev Returns the decimals places of the token.
219      */
220     function decimals() external view returns (uint8);
221 }
222 
223 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
224 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
225 
226 /* pragma solidity ^0.8.0; */
227 
228 /* import "./IERC20.sol"; */
229 /* import "./extensions/IERC20Metadata.sol"; */
230 /* import "../../utils/Context.sol"; */
231 
232 /**
233  * @dev Implementation of the {IERC20} interface.
234  *
235  * This implementation is agnostic to the way tokens are created. This means
236  * that a supply mechanism has to be added in a derived contract using {_mint}.
237  * For a generic mechanism see {ERC20PresetMinterPauser}.
238  *
239  * TIP: For a detailed writeup see our guide
240  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
241  * to implement supply mechanisms].
242  *
243  * We have followed general OpenZeppelin Contracts guidelines: functions revert
244  * instead returning `false` on failure. This behavior is nonetheless
245  * conventional and does not conflict with the expectations of ERC20
246  * applications.
247  *
248  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
249  * This allows applications to reconstruct the allowance for all accounts just
250  * by listening to said events. Other implementations of the EIP may not emit
251  * these events, as it isn't required by the specification.
252  *
253  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
254  * functions have been added to mitigate the well-known issues around setting
255  * allowances. See {IERC20-approve}.
256  */
257 contract ERC20 is Context, IERC20, IERC20Metadata {
258     mapping(address => uint256) private _balances;
259 
260     mapping(address => mapping(address => uint256)) private _allowances;
261 
262     uint256 private _totalSupply;
263 
264     string private _name;
265     string private _symbol;
266 
267     /**
268      * @dev Sets the values for {name} and {symbol}.
269      *
270      * The default value of {decimals} is 18. To select a different value for
271      * {decimals} you should overload it.
272      *
273      * All two of these values are immutable: they can only be set once during
274      * construction.
275      */
276     constructor(string memory name_, string memory symbol_) {
277         _name = name_;
278         _symbol = symbol_;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view virtual override returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view virtual override returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei. This is the value {ERC20} uses, unless this function is
303      * overridden;
304      *
305      * NOTE: This information is only used for _display_ purposes: it in
306      * no way affects any of the arithmetic of the contract, including
307      * {IERC20-balanceOf} and {IERC20-transfer}.
308      */
309     function decimals() public view virtual override returns (uint8) {
310         return 18;
311     }
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view virtual override returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account) public view virtual override returns (uint256) {
324         return _balances[account];
325     }
326 
327     /**
328      * @dev See {IERC20-transfer}.
329      *
330      * Requirements:
331      *
332      * - `recipient` cannot be the zero address.
333      * - the caller must have a balance of at least `amount`.
334      */
335     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
336         _transfer(_msgSender(), recipient, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-allowance}.
342      */
343     function allowance(address owner, address spender) public view virtual override returns (uint256) {
344         return _allowances[owner][spender];
345     }
346 
347     /**
348      * @dev See {IERC20-approve}.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      */
354     function approve(address spender, uint256 amount) public virtual override returns (bool) {
355         _approve(_msgSender(), spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {ERC20}.
364      *
365      * Requirements:
366      *
367      * - `sender` and `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      * - the caller must have allowance for ``sender``'s tokens of at least
370      * `amount`.
371      */
372     function transferFrom(
373         address sender,
374         address recipient,
375         uint256 amount
376     ) public virtual override returns (bool) {
377         _transfer(sender, recipient, amount);
378 
379         uint256 currentAllowance = _allowances[sender][_msgSender()];
380         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
381         unchecked {
382             _approve(sender, _msgSender(), currentAllowance - amount);
383         }
384 
385         return true;
386     }
387 
388     /**
389      * @dev Atomically increases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to {approve} that can be used as a mitigation for
392      * problems described in {IERC20-approve}.
393      *
394      * Emits an {Approval} event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
401         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
402         return true;
403     }
404 
405     /**
406      * @dev Atomically decreases the allowance granted to `spender` by the caller.
407      *
408      * This is an alternative to {approve} that can be used as a mitigation for
409      * problems described in {IERC20-approve}.
410      *
411      * Emits an {Approval} event indicating the updated allowance.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      * - `spender` must have allowance for the caller of at least
417      * `subtractedValue`.
418      */
419     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
420         uint256 currentAllowance = _allowances[_msgSender()][spender];
421         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
422         unchecked {
423             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
424         }
425 
426         return true;
427     }
428 
429     /**
430      * @dev Moves `amount` of tokens from `sender` to `recipient`.
431      *
432      * This internal function is equivalent to {transfer}, and can be used to
433      * e.g. implement automatic token fees, slashing mechanisms, etc.
434      *
435      * Emits a {Transfer} event.
436      *
437      * Requirements:
438      *
439      * - `sender` cannot be the zero address.
440      * - `recipient` cannot be the zero address.
441      * - `sender` must have a balance of at least `amount`.
442      */
443     function _transfer(
444         address sender,
445         address recipient,
446         uint256 amount
447     ) internal virtual {
448         require(sender != address(0), "ERC20: transfer from the zero address");
449         require(recipient != address(0), "ERC20: transfer to the zero address");
450 
451         _beforeTokenTransfer(sender, recipient, amount);
452 
453         uint256 senderBalance = _balances[sender];
454         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
455         unchecked {
456             _balances[sender] = senderBalance - amount;
457         }
458         _balances[recipient] += amount;
459 
460         emit Transfer(sender, recipient, amount);
461 
462         _afterTokenTransfer(sender, recipient, amount);
463     }
464 
465     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
466      * the total supply.
467      *
468      * Emits a {Transfer} event with `from` set to the zero address.
469      *
470      * Requirements:
471      *
472      * - `account` cannot be the zero address.
473      */
474     function _mint(address account, uint256 amount) internal virtual {
475         require(account != address(0), "ERC20: mint to the zero address");
476 
477         _beforeTokenTransfer(address(0), account, amount);
478 
479         _totalSupply += amount;
480         _balances[account] += amount;
481         emit Transfer(address(0), account, amount);
482 
483         _afterTokenTransfer(address(0), account, amount);
484     }
485 
486     /**
487      * @dev Destroys `amount` tokens from `account`, reducing the
488      * total supply.
489      *
490      * Emits a {Transfer} event with `to` set to the zero address.
491      *
492      * Requirements:
493      *
494      * - `account` cannot be the zero address.
495      * - `account` must have at least `amount` tokens.
496      */
497     function _burn(address account, uint256 amount) internal virtual {
498         require(account != address(0), "ERC20: burn from the zero address");
499 
500         _beforeTokenTransfer(account, address(0), amount);
501 
502         uint256 accountBalance = _balances[account];
503         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
504         unchecked {
505             _balances[account] = accountBalance - amount;
506         }
507         _totalSupply -= amount;
508 
509         emit Transfer(account, address(0), amount);
510 
511         _afterTokenTransfer(account, address(0), amount);
512     }
513 
514     /**
515      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
516      *
517      * This internal function is equivalent to `approve`, and can be used to
518      * e.g. set automatic allowances for certain subsystems, etc.
519      *
520      * Emits an {Approval} event.
521      *
522      * Requirements:
523      *
524      * - `owner` cannot be the zero address.
525      * - `spender` cannot be the zero address.
526      */
527     function _approve(
528         address owner,
529         address spender,
530         uint256 amount
531     ) internal virtual {
532         require(owner != address(0), "ERC20: approve from the zero address");
533         require(spender != address(0), "ERC20: approve to the zero address");
534 
535         _allowances[owner][spender] = amount;
536         emit Approval(owner, spender, amount);
537     }
538 
539     /**
540      * @dev Hook that is called before any transfer of tokens. This includes
541      * minting and burning.
542      *
543      * Calling conditions:
544      *
545      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
546      * will be transferred to `to`.
547      * - when `from` is zero, `amount` tokens will be minted for `to`.
548      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
549      * - `from` and `to` are never both zero.
550      *
551      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
552      */
553     function _beforeTokenTransfer(
554         address from,
555         address to,
556         uint256 amount
557     ) internal virtual {}
558 
559     /**
560      * @dev Hook that is called after any transfer of tokens. This includes
561      * minting and burning.
562      *
563      * Calling conditions:
564      *
565      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
566      * has been transferred to `to`.
567      * - when `from` is zero, `amount` tokens have been minted for `to`.
568      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
569      * - `from` and `to` are never both zero.
570      *
571      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
572      */
573     function _afterTokenTransfer(
574         address from,
575         address to,
576         uint256 amount
577     ) internal virtual {}
578 }
579 
580 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
581 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
582 
583 /* pragma solidity ^0.8.0; */
584 
585 // CAUTION
586 // This version of SafeMath should only be used with Solidity 0.8 or later,
587 // because it relies on the compiler's built in overflow checks.
588 
589 /**
590  * @dev Wrappers over Solidity's arithmetic operations.
591  *
592  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
593  * now has built in overflow checking.
594  */
595 library SafeMath {
596     /**
597      * @dev Returns the addition of two unsigned integers, with an overflow flag.
598      *
599      * _Available since v3.4._
600      */
601     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
602         unchecked {
603             uint256 c = a + b;
604             if (c < a) return (false, 0);
605             return (true, c);
606         }
607     }
608 
609     /**
610      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
611      *
612      * _Available since v3.4._
613      */
614     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
615         unchecked {
616             if (b > a) return (false, 0);
617             return (true, a - b);
618         }
619     }
620 
621     /**
622      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
623      *
624      * _Available since v3.4._
625      */
626     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
627         unchecked {
628             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
629             // benefit is lost if 'b' is also tested.
630             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
631             if (a == 0) return (true, 0);
632             uint256 c = a * b;
633             if (c / a != b) return (false, 0);
634             return (true, c);
635         }
636     }
637 
638     /**
639      * @dev Returns the division of two unsigned integers, with a division by zero flag.
640      *
641      * _Available since v3.4._
642      */
643     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
644         unchecked {
645             if (b == 0) return (false, 0);
646             return (true, a / b);
647         }
648     }
649 
650     /**
651      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
652      *
653      * _Available since v3.4._
654      */
655     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
656         unchecked {
657             if (b == 0) return (false, 0);
658             return (true, a % b);
659         }
660     }
661 
662     /**
663      * @dev Returns the addition of two unsigned integers, reverting on
664      * overflow.
665      *
666      * Counterpart to Solidity's `+` operator.
667      *
668      * Requirements:
669      *
670      * - Addition cannot overflow.
671      */
672     function add(uint256 a, uint256 b) internal pure returns (uint256) {
673         return a + b;
674     }
675 
676     /**
677      * @dev Returns the subtraction of two unsigned integers, reverting on
678      * overflow (when the result is negative).
679      *
680      * Counterpart to Solidity's `-` operator.
681      *
682      * Requirements:
683      *
684      * - Subtraction cannot overflow.
685      */
686     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
687         return a - b;
688     }
689 
690     /**
691      * @dev Returns the multiplication of two unsigned integers, reverting on
692      * overflow.
693      *
694      * Counterpart to Solidity's `*` operator.
695      *
696      * Requirements:
697      *
698      * - Multiplication cannot overflow.
699      */
700     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
701         return a * b;
702     }
703 
704     /**
705      * @dev Returns the integer division of two unsigned integers, reverting on
706      * division by zero. The result is rounded towards zero.
707      *
708      * Counterpart to Solidity's `/` operator.
709      *
710      * Requirements:
711      *
712      * - The divisor cannot be zero.
713      */
714     function div(uint256 a, uint256 b) internal pure returns (uint256) {
715         return a / b;
716     }
717 
718     /**
719      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
720      * reverting when dividing by zero.
721      *
722      * Counterpart to Solidity's `%` operator. This function uses a `revert`
723      * opcode (which leaves remaining gas untouched) while Solidity uses an
724      * invalid opcode to revert (consuming all remaining gas).
725      *
726      * Requirements:
727      *
728      * - The divisor cannot be zero.
729      */
730     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
731         return a % b;
732     }
733 
734     /**
735      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
736      * overflow (when the result is negative).
737      *
738      * CAUTION: This function is deprecated because it requires allocating memory for the error
739      * message unnecessarily. For custom revert reasons use {trySub}.
740      *
741      * Counterpart to Solidity's `-` operator.
742      *
743      * Requirements:
744      *
745      * - Subtraction cannot overflow.
746      */
747     function sub(
748         uint256 a,
749         uint256 b,
750         string memory errorMessage
751     ) internal pure returns (uint256) {
752         unchecked {
753             require(b <= a, errorMessage);
754             return a - b;
755         }
756     }
757 
758     /**
759      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
760      * division by zero. The result is rounded towards zero.
761      *
762      * Counterpart to Solidity's `/` operator. Note: this function uses a
763      * `revert` opcode (which leaves remaining gas untouched) while Solidity
764      * uses an invalid opcode to revert (consuming all remaining gas).
765      *
766      * Requirements:
767      *
768      * - The divisor cannot be zero.
769      */
770     function div(
771         uint256 a,
772         uint256 b,
773         string memory errorMessage
774     ) internal pure returns (uint256) {
775         unchecked {
776             require(b > 0, errorMessage);
777             return a / b;
778         }
779     }
780 
781     /**
782      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
783      * reverting with custom message when dividing by zero.
784      *
785      * CAUTION: This function is deprecated because it requires allocating memory for the error
786      * message unnecessarily. For custom revert reasons use {tryMod}.
787      *
788      * Counterpart to Solidity's `%` operator. This function uses a `revert`
789      * opcode (which leaves remaining gas untouched) while Solidity uses an
790      * invalid opcode to revert (consuming all remaining gas).
791      *
792      * Requirements:
793      *
794      * - The divisor cannot be zero.
795      */
796     function mod(
797         uint256 a,
798         uint256 b,
799         string memory errorMessage
800     ) internal pure returns (uint256) {
801         unchecked {
802             require(b > 0, errorMessage);
803             return a % b;
804         }
805     }
806 }
807 
808 ////// src/IUniswapV2Factory.sol
809 /* pragma solidity 0.8.10; */
810 /* pragma experimental ABIEncoderV2; */
811 
812 interface IUniswapV2Factory {
813     event PairCreated(
814         address indexed token0,
815         address indexed token1,
816         address pair,
817         uint256
818     );
819 
820     function feeTo() external view returns (address);
821 
822     function feeToSetter() external view returns (address);
823 
824     function getPair(address tokenA, address tokenB)
825         external
826         view
827         returns (address pair);
828 
829     function allPairs(uint256) external view returns (address pair);
830 
831     function allPairsLength() external view returns (uint256);
832 
833     function createPair(address tokenA, address tokenB)
834         external
835         returns (address pair);
836 
837     function setFeeTo(address) external;
838 
839     function setFeeToSetter(address) external;
840 }
841 
842 ////// src/IUniswapV2Pair.sol
843 /* pragma solidity 0.8.10; */
844 /* pragma experimental ABIEncoderV2; */
845 
846 interface IUniswapV2Pair {
847     event Approval(
848         address indexed owner,
849         address indexed spender,
850         uint256 value
851     );
852     event Transfer(address indexed from, address indexed to, uint256 value);
853 
854     function name() external pure returns (string memory);
855 
856     function symbol() external pure returns (string memory);
857 
858     function decimals() external pure returns (uint8);
859 
860     function totalSupply() external view returns (uint256);
861 
862     function balanceOf(address owner) external view returns (uint256);
863 
864     function allowance(address owner, address spender)
865         external
866         view
867         returns (uint256);
868 
869     function approve(address spender, uint256 value) external returns (bool);
870 
871     function transfer(address to, uint256 value) external returns (bool);
872 
873     function transferFrom(
874         address from,
875         address to,
876         uint256 value
877     ) external returns (bool);
878 
879     function DOMAIN_SEPARATOR() external view returns (bytes32);
880 
881     function PERMIT_TYPEHASH() external pure returns (bytes32);
882 
883     function nonces(address owner) external view returns (uint256);
884 
885     function permit(
886         address owner,
887         address spender,
888         uint256 value,
889         uint256 deadline,
890         uint8 v,
891         bytes32 r,
892         bytes32 s
893     ) external;
894 
895     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
896     event Burn(
897         address indexed sender,
898         uint256 amount0,
899         uint256 amount1,
900         address indexed to
901     );
902     event Swap(
903         address indexed sender,
904         uint256 amount0In,
905         uint256 amount1In,
906         uint256 amount0Out,
907         uint256 amount1Out,
908         address indexed to
909     );
910     event Sync(uint112 reserve0, uint112 reserve1);
911 
912     function MINIMUM_LIQUIDITY() external pure returns (uint256);
913 
914     function factory() external view returns (address);
915 
916     function token0() external view returns (address);
917 
918     function token1() external view returns (address);
919 
920     function getReserves()
921         external
922         view
923         returns (
924             uint112 reserve0,
925             uint112 reserve1,
926             uint32 blockTimestampLast
927         );
928 
929     function price0CumulativeLast() external view returns (uint256);
930 
931     function price1CumulativeLast() external view returns (uint256);
932 
933     function kLast() external view returns (uint256);
934 
935     function mint(address to) external returns (uint256 liquidity);
936 
937     function burn(address to)
938         external
939         returns (uint256 amount0, uint256 amount1);
940 
941     function swap(
942         uint256 amount0Out,
943         uint256 amount1Out,
944         address to,
945         bytes calldata data
946     ) external;
947 
948     function skim(address to) external;
949 
950     function sync() external;
951 
952     function initialize(address, address) external;
953 }
954 
955 ////// src/IUniswapV2Router02.sol
956 /* pragma solidity 0.8.10; */
957 /* pragma experimental ABIEncoderV2; */
958 
959 interface IUniswapV2Router02 {
960     function factory() external pure returns (address);
961 
962     function WETH() external pure returns (address);
963 
964     function addLiquidity(
965         address tokenA,
966         address tokenB,
967         uint256 amountADesired,
968         uint256 amountBDesired,
969         uint256 amountAMin,
970         uint256 amountBMin,
971         address to,
972         uint256 deadline
973     )
974         external
975         returns (
976             uint256 amountA,
977             uint256 amountB,
978             uint256 liquidity
979         );
980 
981     function addLiquidityETH(
982         address token,
983         uint256 amountTokenDesired,
984         uint256 amountTokenMin,
985         uint256 amountETHMin,
986         address to,
987         uint256 deadline
988     )
989         external
990         payable
991         returns (
992             uint256 amountToken,
993             uint256 amountETH,
994             uint256 liquidity
995         );
996 
997     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
998         uint256 amountIn,
999         uint256 amountOutMin,
1000         address[] calldata path,
1001         address to,
1002         uint256 deadline
1003     ) external;
1004 
1005     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1006         uint256 amountOutMin,
1007         address[] calldata path,
1008         address to,
1009         uint256 deadline
1010     ) external payable;
1011 
1012     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1013         uint256 amountIn,
1014         uint256 amountOutMin,
1015         address[] calldata path,
1016         address to,
1017         uint256 deadline
1018     ) external;
1019 }
1020 
1021 ////// ShikaInu.sol
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
1032 contract ShikaInu is ERC20, Ownable {
1033     using SafeMath for uint256;
1034 
1035     IUniswapV2Router02 public immutable uniswapV2Router;
1036     address public immutable uniswapV2Pair;
1037     address public constant deadAddress = address(0xdead);
1038 
1039     bool private swapping;
1040 
1041     address public marketingWallet;
1042     address public devWallet;
1043 
1044     uint256 public maxTransactionAmount;
1045     uint256 public swapTokensAtAmount;
1046     uint256 public maxWallet;
1047 
1048     uint256 public percentForLPBurn = 25; // 25 = .25%
1049     bool public lpBurnEnabled = true;
1050     uint256 public lpBurnFrequency = 3600 seconds;
1051     uint256 public lastLpBurnTime;
1052 
1053     uint256 public manualBurnFrequency = 30 minutes;
1054     uint256 public lastManualLpBurnTime;
1055 
1056     bool public limitsInEffect = true;
1057     bool public tradingActive = false;
1058     bool public swapEnabled = false;
1059 
1060     // Anti-bot and anti-whale mappings and variables
1061     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1062     bool public transferDelayEnabled = true;
1063 
1064     uint256 public buyTotalFees;
1065     uint256 public buyMarketingFee;
1066     uint256 public buyLiquidityFee;
1067     uint256 public buyDevFee;
1068 
1069     uint256 public sellTotalFees;
1070     uint256 public sellMarketingFee;
1071     uint256 public sellLiquidityFee;
1072     uint256 public sellDevFee;
1073 
1074     uint256 public tokensForMarketing;
1075     uint256 public tokensForLiquidity;
1076     uint256 public tokensForDev;
1077 
1078     /******************/
1079 
1080     // exlcude from fees and max transaction amount
1081     mapping(address => bool) private _isExcludedFromFees;
1082     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1083 
1084     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1085     // could be subject to a maximum transfer amount
1086     mapping(address => bool) public automatedMarketMakerPairs;
1087 
1088     event UpdateUniswapV2Router(
1089         address indexed newAddress,
1090         address indexed oldAddress
1091     );
1092 
1093     event ExcludeFromFees(address indexed account, bool isExcluded);
1094 
1095     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1096 
1097     event marketingWalletUpdated(
1098         address indexed newWallet,
1099         address indexed oldWallet
1100     );
1101 
1102     event devWalletUpdated(
1103         address indexed newWallet,
1104         address indexed oldWallet
1105     );
1106 
1107     event SwapAndLiquify(
1108         uint256 tokensSwapped,
1109         uint256 ethReceived,
1110         uint256 tokensIntoLiquidity
1111     );
1112 
1113     event AutoNukeLP();
1114 
1115     event ManualNukeLP();
1116 
1117     constructor() ERC20("Shika Inu", "SHIKA") {
1118         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1119             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1120         );
1121 
1122         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1123         uniswapV2Router = _uniswapV2Router;
1124 
1125         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1126             .createPair(address(this), _uniswapV2Router.WETH());
1127         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1128         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1129 
1130         uint256 _buyMarketingFee = 0;
1131         uint256 _buyLiquidityFee = 0;
1132         uint256 _buyDevFee = 0;
1133 
1134         uint256 _sellMarketingFee = 0;
1135         uint256 _sellLiquidityFee = 0;
1136         uint256 _sellDevFee = 0;
1137 
1138         uint256 totalSupply = 10_000_000 * 1e18;
1139 
1140         maxTransactionAmount = 100_000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1141         maxWallet = 200_000 * 1e18; // 2% from total supply maxWallet
1142         swapTokensAtAmount = (totalSupply * 5) / 100; // 0.05% swap wallet
1143 
1144         buyMarketingFee = _buyMarketingFee;
1145         buyLiquidityFee = _buyLiquidityFee;
1146         buyDevFee = _buyDevFee;
1147         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1148 
1149         sellMarketingFee = _sellMarketingFee;
1150         sellLiquidityFee = _sellLiquidityFee;
1151         sellDevFee = _sellDevFee;
1152         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1153 
1154         marketingWallet = address(0x77B745Fc2e203313b756D42C28c333364932A7DD); // set as marketing wallet
1155         devWallet = address(0xC82f787Df553Cf89072888FDb40d1D6E6a72F824); // set as dev wallet
1156 
1157         // exclude from paying fees or having max transaction amount
1158         excludeFromFees(owner(), true);
1159         excludeFromFees(address(this), true);
1160         excludeFromFees(address(0xdead), true);
1161 
1162         excludeFromMaxTransaction(owner(), true);
1163         excludeFromMaxTransaction(address(this), true);
1164         excludeFromMaxTransaction(address(0xdead), true);
1165 
1166         /*
1167             _mint is an internal function in ERC20.sol that is only called here,
1168             and CANNOT be called ever again
1169         */
1170         _mint(msg.sender, totalSupply);
1171     }
1172 
1173     receive() external payable {}
1174 
1175     // once enabled, can never be turned off
1176     function enableTrading() external onlyOwner {
1177         tradingActive = true;
1178         swapEnabled = true;
1179         lastLpBurnTime = block.timestamp;
1180     }
1181 
1182     // remove limits after token is stable
1183     function removeLimits() external onlyOwner returns (bool) {
1184         limitsInEffect = false;
1185         return true;
1186     }
1187 
1188     // disable Transfer delay - cannot be reenabled
1189     function disableTransferDelay() external onlyOwner returns (bool) {
1190         transferDelayEnabled = false;
1191         return true;
1192     }
1193 
1194     // change the minimum amount of tokens to sell from fees
1195     function updateSwapTokensAtAmount(uint256 newAmount)
1196         external
1197         onlyOwner
1198         returns (bool)
1199     {
1200         require(
1201             newAmount >= (totalSupply() * 1) / 100000,
1202             "Swap amount cannot be lower than 0.001% total supply."
1203         );
1204         require(
1205             newAmount <= (totalSupply() * 5) / 1000,
1206             "Swap amount cannot be higher than 0.5% total supply."
1207         );
1208         swapTokensAtAmount = newAmount;
1209         return true;
1210     }
1211 
1212     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1213         require(
1214             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1215             "Cannot set maxTransactionAmount lower than 0.1%"
1216         );
1217         maxTransactionAmount = newNum * (10**18);
1218     }
1219 
1220     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1221         require(
1222             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1223             "Cannot set maxWallet lower than 0.5%"
1224         );
1225         maxWallet = newNum * (10**18);
1226     }
1227 
1228     function excludeFromMaxTransaction(address updAds, bool isEx)
1229         public
1230         onlyOwner
1231     {
1232         _isExcludedMaxTransactionAmount[updAds] = isEx;
1233     }
1234 
1235     // only use to disable contract sales if absolutely necessary (emergency use only)
1236     function updateSwapEnabled(bool enabled) external onlyOwner {
1237         swapEnabled = enabled;
1238     }
1239 
1240     function updateBuyFees(
1241         uint256 _marketingFee,
1242         uint256 _liquidityFee,
1243         uint256 _devFee
1244     ) external onlyOwner {
1245         buyMarketingFee = _marketingFee;
1246         buyLiquidityFee = _liquidityFee;
1247         buyDevFee = _devFee;
1248         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1249         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1250     }
1251 
1252     function updateSellFees(
1253         uint256 _marketingFee,
1254         uint256 _liquidityFee,
1255         uint256 _devFee
1256     ) external onlyOwner {
1257         sellMarketingFee = _marketingFee;
1258         sellLiquidityFee = _liquidityFee;
1259         sellDevFee = _devFee;
1260         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1261         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1262     }
1263 
1264     function excludeFromFees(address account, bool excluded) public onlyOwner {
1265         _isExcludedFromFees[account] = excluded;
1266         emit ExcludeFromFees(account, excluded);
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
1295     function updateDevWallet(address newWallet) external onlyOwner {
1296         emit devWalletUpdated(newWallet, devWallet);
1297         devWallet = newWallet;
1298     }
1299 
1300     function isExcludedFromFees(address account) public view returns (bool) {
1301         return _isExcludedFromFees[account];
1302     }
1303 
1304     event BoughtEarly(address indexed sniper);
1305 
1306     function _transfer(
1307         address from,
1308         address to,
1309         uint256 amount
1310     ) internal override {
1311         require(from != address(0), "ERC20: transfer from the zero address");
1312         require(to != address(0), "ERC20: transfer to the zero address");
1313 
1314         if (amount == 0) {
1315             super._transfer(from, to, 0);
1316             return;
1317         }
1318 
1319         if (limitsInEffect) {
1320             if (
1321                 from != owner() &&
1322                 to != owner() &&
1323                 to != address(0) &&
1324                 to != address(0xdead) &&
1325                 !swapping
1326             ) {
1327                 if (!tradingActive) {
1328                     require(
1329                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1330                         "Trading is not active."
1331                     );
1332                 }
1333 
1334                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1335                 if (transferDelayEnabled) {
1336                     if (
1337                         to != owner() &&
1338                         to != address(uniswapV2Router) &&
1339                         to != address(uniswapV2Pair)
1340                     ) {
1341                         require(
1342                             _holderLastTransferTimestamp[tx.origin] <
1343                                 block.number,
1344                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1345                         );
1346                         _holderLastTransferTimestamp[tx.origin] = block.number;
1347                     }
1348                 }
1349 
1350                 //when buy
1351                 if (
1352                     automatedMarketMakerPairs[from] &&
1353                     !_isExcludedMaxTransactionAmount[to]
1354                 ) {
1355                     require(
1356                         amount <= maxTransactionAmount,
1357                         "Buy transfer amount exceeds the maxTransactionAmount."
1358                     );
1359                     require(
1360                         amount + balanceOf(to) <= maxWallet,
1361                         "Max wallet exceeded"
1362                     );
1363                 }
1364                 //when sell
1365                 else if (
1366                     automatedMarketMakerPairs[to] &&
1367                     !_isExcludedMaxTransactionAmount[from]
1368                 ) {
1369                     require(
1370                         amount <= maxTransactionAmount,
1371                         "Sell transfer amount exceeds the maxTransactionAmount."
1372                     );
1373                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1374                     require(
1375                         amount + balanceOf(to) <= maxWallet,
1376                         "Max wallet exceeded"
1377                     );
1378                 }
1379             }
1380         }
1381 
1382         uint256 contractTokenBalance = balanceOf(address(this));
1383 
1384         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1385 
1386         if (
1387             canSwap &&
1388             swapEnabled &&
1389             !swapping &&
1390             !automatedMarketMakerPairs[from] &&
1391             !_isExcludedFromFees[from] &&
1392             !_isExcludedFromFees[to]
1393         ) {
1394             swapping = true;
1395 
1396             swapBack();
1397 
1398             swapping = false;
1399         }
1400 
1401         if (
1402             !swapping &&
1403             automatedMarketMakerPairs[to] &&
1404             lpBurnEnabled &&
1405             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1406             !_isExcludedFromFees[from]
1407         ) {
1408             autoBurnLiquidityPairTokens();
1409         }
1410 
1411         bool takeFee = !swapping;
1412 
1413         // if any account belongs to _isExcludedFromFee account then remove the fee
1414         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1415             takeFee = false;
1416         }
1417 
1418         uint256 fees = 0;
1419         // only take fees on buys/sells, do not take on wallet transfers
1420         if (takeFee) {
1421             // on sell
1422             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1423                 fees = amount.mul(sellTotalFees).div(100);
1424                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1425                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1426                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1427             }
1428             // on buy
1429             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1430                 fees = amount.mul(buyTotalFees).div(100);
1431                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1432                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1433                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1434             }
1435 
1436             if (fees > 0) {
1437                 super._transfer(from, address(this), fees);
1438             }
1439 
1440             amount -= fees;
1441         }
1442 
1443         super._transfer(from, to, amount);
1444     }
1445 
1446     function swapTokensForEth(uint256 tokenAmount) private {
1447         // generate the uniswap pair path of token -> weth
1448         address[] memory path = new address[](2);
1449         path[0] = address(this);
1450         path[1] = uniswapV2Router.WETH();
1451 
1452         _approve(address(this), address(uniswapV2Router), tokenAmount);
1453 
1454         // make the swap
1455         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1456             tokenAmount,
1457             0, // accept any amount of ETH
1458             path,
1459             address(this),
1460             block.timestamp
1461         );
1462     }
1463 
1464     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1465         // approve token transfer to cover all possible scenarios
1466         _approve(address(this), address(uniswapV2Router), tokenAmount);
1467 
1468         // add the liquidity
1469         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1470             address(this),
1471             tokenAmount,
1472             0, // slippage is unavoidable
1473             0, // slippage is unavoidable
1474             deadAddress,
1475             block.timestamp
1476         );
1477     }
1478 
1479     function swapBack() private {
1480         uint256 contractBalance = balanceOf(address(this));
1481         uint256 totalTokensToSwap = tokensForLiquidity +
1482             tokensForMarketing +
1483             tokensForDev;
1484         bool success;
1485 
1486         if (contractBalance == 0 || totalTokensToSwap == 0) {
1487             return;
1488         }
1489 
1490         if (contractBalance > swapTokensAtAmount * 20) {
1491             contractBalance = swapTokensAtAmount * 20;
1492         }
1493 
1494         // Halve the amount of liquidity tokens
1495         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1496             totalTokensToSwap /
1497             2;
1498         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1499 
1500         uint256 initialETHBalance = address(this).balance;
1501 
1502         swapTokensForEth(amountToSwapForETH);
1503 
1504         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1505 
1506         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1507             totalTokensToSwap
1508         );
1509         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1510 
1511         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1512 
1513         tokensForLiquidity = 0;
1514         tokensForMarketing = 0;
1515         tokensForDev = 0;
1516 
1517         (success, ) = address(devWallet).call{value: ethForDev}("");
1518 
1519         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1520             addLiquidity(liquidityTokens, ethForLiquidity);
1521             emit SwapAndLiquify(
1522                 amountToSwapForETH,
1523                 ethForLiquidity,
1524                 tokensForLiquidity
1525             );
1526         }
1527 
1528         (success, ) = address(marketingWallet).call{
1529             value: address(this).balance
1530         }("");
1531     }
1532 
1533     function setAutoLPBurnSettings(
1534         uint256 _frequencyInSeconds,
1535         uint256 _percent,
1536         bool _Enabled
1537     ) external onlyOwner {
1538         require(
1539             _frequencyInSeconds >= 600,
1540             "cannot set buyback more often than every 10 minutes"
1541         );
1542         require(
1543             _percent <= 1000 && _percent >= 0,
1544             "Must set auto LP burn percent between 0% and 10%"
1545         );
1546         lpBurnFrequency = _frequencyInSeconds;
1547         percentForLPBurn = _percent;
1548         lpBurnEnabled = _Enabled;
1549     }
1550 
1551     function autoBurnLiquidityPairTokens() internal returns (bool) {
1552         lastLpBurnTime = block.timestamp;
1553 
1554         // get balance of liquidity pair
1555         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1556 
1557         // calculate amount to burn
1558         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1559             10000
1560         );
1561 
1562         // pull tokens from pancakePair liquidity and move to dead address permanently
1563         if (amountToBurn > 0) {
1564             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1565         }
1566 
1567         //sync price since this is not in a swap transaction!
1568         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1569         pair.sync();
1570         emit AutoNukeLP();
1571         return true;
1572     }
1573 
1574     function manualBurnLiquidityPairTokens(uint256 percent)
1575         external
1576         onlyOwner
1577         returns (bool)
1578     {
1579         require(
1580             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1581             "Must wait for cooldown to finish"
1582         );
1583         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1584         lastManualLpBurnTime = block.timestamp;
1585 
1586         // get balance of liquidity pair
1587         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1588 
1589         // calculate amount to burn
1590         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1591 
1592         // pull tokens from pancakePair liquidity and move to dead address permanently
1593         if (amountToBurn > 0) {
1594             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1595         }
1596 
1597         //sync price since this is not in a swap transaction!
1598         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1599         pair.sync();
1600         emit ManualNukeLP();
1601         return true;
1602     }
1603 }