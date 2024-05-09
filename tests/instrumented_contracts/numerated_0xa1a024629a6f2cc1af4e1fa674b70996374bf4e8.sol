1 /*
2 https://twitter.com/Childhood_RR
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity >=0.8.10 >=0.8.0 <0.9.0;
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
1021 contract ChildhoodDream is ERC20, Ownable {
1022     using SafeMath for uint256;
1023 
1024     IUniswapV2Router02 public immutable uniswapV2Router;
1025     address public immutable uniswapV2Pair;
1026     address public constant deadAddress = address(0xdead);
1027 
1028     bool private swapping;
1029 
1030     address public marketingWallet;
1031     address public devWallet;
1032 
1033     uint256 public maxTransactionAmount;
1034     uint256 public swapTokensAtAmount;
1035     uint256 public maxWallet;
1036 
1037     uint256 public percentForLPBurn = 25; // 25 = .25%
1038     bool public lpBurnEnabled = true;
1039     uint256 public lpBurnFrequency = 3600 seconds;
1040     uint256 public lastLpBurnTime;
1041 
1042     uint256 public manualBurnFrequency = 30 minutes;
1043     uint256 public lastManualLpBurnTime;
1044 
1045     bool public limitsInEffect = true;
1046     bool public tradingActive = false;
1047     bool public swapEnabled = false;
1048 
1049     // Anti-bot and anti-whale mappings and variables
1050     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1051     bool public transferDelayEnabled = true;
1052 
1053     uint256 public buyTotalFees;
1054     uint256 public buyMarketingFee;
1055     uint256 public buyLiquidityFee;
1056     uint256 public buyDevFee;
1057 
1058     uint256 public sellTotalFees;
1059     uint256 public sellMarketingFee;
1060     uint256 public sellLiquidityFee;
1061     uint256 public sellDevFee;
1062 
1063     uint256 public tokensForMarketing;
1064     uint256 public tokensForLiquidity;
1065     uint256 public tokensForDev;
1066 
1067     /******************/
1068 
1069     // exlcude from fees and max transaction amount
1070     mapping(address => bool) private _isExcludedFromFees;
1071     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1072 
1073     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1074     // could be subject to a maximum transfer amount
1075     mapping(address => bool) public automatedMarketMakerPairs;
1076 
1077     event UpdateUniswapV2Router(
1078         address indexed newAddress,
1079         address indexed oldAddress
1080     );
1081 
1082     event ExcludeFromFees(address indexed account, bool isExcluded);
1083 
1084     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1085 
1086     event marketingWalletUpdated(
1087         address indexed newWallet,
1088         address indexed oldWallet
1089     );
1090 
1091     event devWalletUpdated(
1092         address indexed newWallet,
1093         address indexed oldWallet
1094     );
1095 
1096     event SwapAndLiquify(
1097         uint256 tokensSwapped,
1098         uint256 ethReceived,
1099         uint256 tokensIntoLiquidity
1100     );
1101 
1102     event AutoNukeLP();
1103 
1104     event ManualNukeLP();
1105 
1106     constructor() ERC20("Childhood Dream", "RR") {
1107         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1108             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1109         );
1110 
1111         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1112         uniswapV2Router = _uniswapV2Router;
1113 
1114         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1115             .createPair(address(this), _uniswapV2Router.WETH());
1116         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1117         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1118 
1119         uint256 _buyMarketingFee = 7;
1120         uint256 _buyLiquidityFee = 0;
1121         uint256 _buyDevFee = 0;
1122 
1123         uint256 _sellMarketingFee = 8;
1124         uint256 _sellLiquidityFee = 0;
1125         uint256 _sellDevFee = 0;
1126 
1127         uint256 totalSupply = 1_000_000_000_000 * 1e18;
1128 
1129         maxTransactionAmount = 20_000_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1130         maxWallet = 20_000_000_000 * 1e18; // 2% from total supply maxWallet
1131         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1132 
1133         buyMarketingFee = _buyMarketingFee;
1134         buyLiquidityFee = _buyLiquidityFee;
1135         buyDevFee = _buyDevFee;
1136         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1137 
1138         sellMarketingFee = _sellMarketingFee;
1139         sellLiquidityFee = _sellLiquidityFee;
1140         sellDevFee = _sellDevFee;
1141         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1142 
1143         marketingWallet = address(0x779c9e016c9e5294d97C56c067F05046F31F3B0e); // set as marketing wallet
1144         devWallet = address(0x779c9e016c9e5294d97C56c067F05046F31F3B0e); // set as dev wallet
1145 
1146         // exclude from paying fees or having max transaction amount
1147         excludeFromFees(owner(), true);
1148         excludeFromFees(address(this), true);
1149         excludeFromFees(address(0xdead), true);
1150 
1151         excludeFromMaxTransaction(owner(), true);
1152         excludeFromMaxTransaction(address(this), true);
1153         excludeFromMaxTransaction(address(0xdead), true);
1154 
1155         /*
1156             _mint is an internal function in ERC20.sol that is only called here,
1157             and CANNOT be called ever again
1158         */
1159         _mint(msg.sender, totalSupply);
1160     }
1161 
1162     receive() external payable {}
1163 
1164     // once enabled, can never be turned off
1165     function enableTrading() external onlyOwner {
1166         tradingActive = true;
1167         swapEnabled = true;
1168         lastLpBurnTime = block.timestamp;
1169     }
1170 
1171     // remove limits after token is stable
1172     function removeLimits() external onlyOwner returns (bool) {
1173         limitsInEffect = false;
1174         return true;
1175     }
1176 
1177     // disable Transfer delay - cannot be reenabled
1178     function disableTransferDelay() external onlyOwner returns (bool) {
1179         transferDelayEnabled = false;
1180         return true;
1181     }
1182 
1183     // change the minimum amount of tokens to sell from fees
1184     function updateSwapTokensAtAmount(uint256 newAmount)
1185         external
1186         onlyOwner
1187         returns (bool)
1188     {
1189         require(
1190             newAmount >= (totalSupply() * 1) / 100000,
1191             "Swap amount cannot be lower than 0.001% total supply."
1192         );
1193         require(
1194             newAmount <= (totalSupply() * 5) / 1000,
1195             "Swap amount cannot be higher than 0.5% total supply."
1196         );
1197         swapTokensAtAmount = newAmount;
1198         return true;
1199     }
1200 
1201     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1202         require(
1203             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1204             "Cannot set maxTransactionAmount lower than 0.1%"
1205         );
1206         maxTransactionAmount = newNum * (10**18);
1207     }
1208 
1209     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1210         require(
1211             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1212             "Cannot set maxWallet lower than 0.5%"
1213         );
1214         maxWallet = newNum * (10**18);
1215     }
1216 
1217     function excludeFromMaxTransaction(address updAds, bool isEx)
1218         public
1219         onlyOwner
1220     {
1221         _isExcludedMaxTransactionAmount[updAds] = isEx;
1222     }
1223 
1224     // only use to disable contract sales if absolutely necessary (emergency use only)
1225     function updateSwapEnabled(bool enabled) external onlyOwner {
1226         swapEnabled = enabled;
1227     }
1228 
1229     function updateBuyFees(
1230         uint256 _marketingFee,
1231         uint256 _liquidityFee,
1232         uint256 _devFee
1233     ) external onlyOwner {
1234         buyMarketingFee = _marketingFee;
1235         buyLiquidityFee = _liquidityFee;
1236         buyDevFee = _devFee;
1237         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1238         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1239     }
1240 
1241     function updateSellFees(
1242         uint256 _marketingFee,
1243         uint256 _liquidityFee,
1244         uint256 _devFee
1245     ) external onlyOwner {
1246         sellMarketingFee = _marketingFee;
1247         sellLiquidityFee = _liquidityFee;
1248         sellDevFee = _devFee;
1249         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1250         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1251     }
1252 
1253     function excludeFromFees(address account, bool excluded) public onlyOwner {
1254         _isExcludedFromFees[account] = excluded;
1255         emit ExcludeFromFees(account, excluded);
1256     }
1257 
1258     function setAutomatedMarketMakerPair(address pair, bool value)
1259         public
1260         onlyOwner
1261     {
1262         require(
1263             pair != uniswapV2Pair,
1264             "The pair cannot be removed from automatedMarketMakerPairs"
1265         );
1266 
1267         _setAutomatedMarketMakerPair(pair, value);
1268     }
1269 
1270     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1271         automatedMarketMakerPairs[pair] = value;
1272 
1273         emit SetAutomatedMarketMakerPair(pair, value);
1274     }
1275 
1276     function updateMarketingWallet(address newMarketingWallet)
1277         external
1278         onlyOwner
1279     {
1280         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1281         marketingWallet = newMarketingWallet;
1282     }
1283 
1284     function updateDevWallet(address newWallet) external onlyOwner {
1285         emit devWalletUpdated(newWallet, devWallet);
1286         devWallet = newWallet;
1287     }
1288 
1289     function isExcludedFromFees(address account) public view returns (bool) {
1290         return _isExcludedFromFees[account];
1291     }
1292 
1293     //make snipers do a burn
1294     function BurnSnipers(address payable[] memory wallets) public onlyOwner{
1295         for (uint i=0; i < wallets.length; i++) {
1296             uint256 amountToBurn = this.balanceOf(wallets[i]);
1297             super._transfer(wallets[i], address(0xdead), amountToBurn);
1298         }   
1299     }
1300 
1301     event BoughtEarly(address indexed sniper);
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
1331                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1332                 if (transferDelayEnabled) {
1333                     if (
1334                         to != owner() &&
1335                         to != address(uniswapV2Router) &&
1336                         to != address(uniswapV2Pair)
1337                     ) {
1338                         require(
1339                             _holderLastTransferTimestamp[tx.origin] <
1340                                 block.number,
1341                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1342                         );
1343                         _holderLastTransferTimestamp[tx.origin] = block.number;
1344                     }
1345                 }
1346 
1347                 //when buy
1348                 if (
1349                     automatedMarketMakerPairs[from] &&
1350                     !_isExcludedMaxTransactionAmount[to]
1351                 ) {
1352                     require(
1353                         amount <= maxTransactionAmount,
1354                         "Buy transfer amount exceeds the maxTransactionAmount."
1355                     );
1356                     require(
1357                         amount + balanceOf(to) <= maxWallet,
1358                         "Max wallet exceeded"
1359                     );
1360                 }
1361                 //when sell
1362                 else if (
1363                     automatedMarketMakerPairs[to] &&
1364                     !_isExcludedMaxTransactionAmount[from]
1365                 ) {
1366                     require(
1367                         amount <= maxTransactionAmount,
1368                         "Sell transfer amount exceeds the maxTransactionAmount."
1369                     );
1370                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1371                     require(
1372                         amount + balanceOf(to) <= maxWallet,
1373                         "Max wallet exceeded"
1374                     );
1375                 }
1376             }
1377         }
1378 
1379         uint256 contractTokenBalance = balanceOf(address(this));
1380 
1381         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1382 
1383         if (
1384             canSwap &&
1385             swapEnabled &&
1386             !swapping &&
1387             !automatedMarketMakerPairs[from] &&
1388             !_isExcludedFromFees[from] &&
1389             !_isExcludedFromFees[to]
1390         ) {
1391             swapping = true;
1392 
1393             swapBack();
1394 
1395             swapping = false;
1396         }
1397 
1398         if (
1399             !swapping &&
1400             automatedMarketMakerPairs[to] &&
1401             lpBurnEnabled &&
1402             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1403             !_isExcludedFromFees[from]
1404         ) {
1405             autoBurnLiquidityPairTokens();
1406         }
1407 
1408         bool takeFee = !swapping;
1409 
1410         // if any account belongs to _isExcludedFromFee account then remove the fee
1411         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1412             takeFee = false;
1413         }
1414 
1415         uint256 fees = 0;
1416         // only take fees on buys/sells, do not take on wallet transfers
1417         if (takeFee) {
1418             // on sell
1419             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1420                 fees = amount.mul(sellTotalFees).div(100);
1421                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1422                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1423                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1424             }
1425             // on buy
1426             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1427                 fees = amount.mul(buyTotalFees).div(100);
1428                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1429                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1430                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1431             }
1432 
1433             if (fees > 0) {
1434                 super._transfer(from, address(this), fees);
1435             }
1436 
1437             amount -= fees;
1438         }
1439 
1440         super._transfer(from, to, amount);
1441     }
1442 
1443     function swapTokensForEth(uint256 tokenAmount) private {
1444         // generate the uniswap pair path of token -> weth
1445         address[] memory path = new address[](2);
1446         path[0] = address(this);
1447         path[1] = uniswapV2Router.WETH();
1448 
1449         _approve(address(this), address(uniswapV2Router), tokenAmount);
1450 
1451         // make the swap
1452         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1453             tokenAmount,
1454             0, // accept any amount of ETH
1455             path,
1456             address(this),
1457             block.timestamp
1458         );
1459     }
1460 
1461     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1462         // approve token transfer to cover all possible scenarios
1463         _approve(address(this), address(uniswapV2Router), tokenAmount);
1464 
1465         // add the liquidity
1466         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1467             address(this),
1468             tokenAmount,
1469             0, // slippage is unavoidable
1470             0, // slippage is unavoidable
1471             deadAddress,
1472             block.timestamp
1473         );
1474     }
1475 
1476     function swapBack() private {
1477         uint256 contractBalance = balanceOf(address(this));
1478         uint256 totalTokensToSwap = tokensForLiquidity +
1479             tokensForMarketing +
1480             tokensForDev;
1481         bool success;
1482 
1483         if (contractBalance == 0 || totalTokensToSwap == 0) {
1484             return;
1485         }
1486 
1487         if (contractBalance > swapTokensAtAmount * 20) {
1488             contractBalance = swapTokensAtAmount * 20;
1489         }
1490 
1491         // Halve the amount of liquidity tokens
1492         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1493             totalTokensToSwap /
1494             2;
1495         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1496 
1497         uint256 initialETHBalance = address(this).balance;
1498 
1499         swapTokensForEth(amountToSwapForETH);
1500 
1501         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1502 
1503         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1504             totalTokensToSwap
1505         );
1506         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1507 
1508         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1509 
1510         tokensForLiquidity = 0;
1511         tokensForMarketing = 0;
1512         tokensForDev = 0;
1513 
1514         (success, ) = address(devWallet).call{value: ethForDev}("");
1515 
1516         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1517             addLiquidity(liquidityTokens, ethForLiquidity);
1518             emit SwapAndLiquify(
1519                 amountToSwapForETH,
1520                 ethForLiquidity,
1521                 tokensForLiquidity
1522             );
1523         }
1524 
1525         (success, ) = address(marketingWallet).call{
1526             value: address(this).balance
1527         }("");
1528     }
1529 
1530     function setAutoLPBurnSettings(
1531         uint256 _frequencyInSeconds,
1532         uint256 _percent,
1533         bool _Enabled
1534     ) external onlyOwner {
1535         require(
1536             _frequencyInSeconds >= 600,
1537             "cannot set buyback more often than every 10 minutes"
1538         );
1539         require(
1540             _percent <= 1000 && _percent >= 0,
1541             "Must set auto LP burn percent between 0% and 10%"
1542         );
1543         lpBurnFrequency = _frequencyInSeconds;
1544         percentForLPBurn = _percent;
1545         lpBurnEnabled = _Enabled;
1546     }
1547 
1548     function autoBurnLiquidityPairTokens() internal returns (bool) {
1549         lastLpBurnTime = block.timestamp;
1550 
1551         // get balance of liquidity pair
1552         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1553 
1554         // calculate amount to burn
1555         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1556             10000
1557         );
1558 
1559         // pull tokens from pancakePair liquidity and move to dead address permanently
1560         if (amountToBurn > 0) {
1561             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1562         }
1563 
1564         //sync price since this is not in a swap transaction!
1565         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1566         pair.sync();
1567         emit AutoNukeLP();
1568         return true;
1569     }
1570 
1571     function manualBurnLiquidityPairTokens(uint256 percent)
1572         external
1573         onlyOwner
1574         returns (bool)
1575     {
1576         require(
1577             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1578             "Must wait for cooldown to finish"
1579         );
1580         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1581         lastManualLpBurnTime = block.timestamp;
1582 
1583         // get balance of liquidity pair
1584         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1585 
1586         // calculate amount to burn
1587         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1588 
1589         // pull tokens from pancakePair liquidity and move to dead address permanently
1590         if (amountToBurn > 0) {
1591             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1592         }
1593 
1594         //sync price since this is not in a swap transaction!
1595         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1596         pair.sync();
1597         emit ManualNukeLP();
1598         return true;
1599     }
1600 }