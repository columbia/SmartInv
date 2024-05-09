1 /**
2 
3 From the Origina deployer of MSN(The Mission)
4 Which went to 10 million ath.
5 
6 */
7 // SPDX-License-Identifier: MIT
8 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
10 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
11 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
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
808 /* pragma solidity 0.8.10; */
809 /* pragma experimental ABIEncoderV2; */
810 
811 interface IUniswapV2Factory {
812     event PairCreated(
813         address indexed token0,
814         address indexed token1,
815         address pair,
816         uint256
817     );
818 
819     function feeTo() external view returns (address);
820 
821     function feeToSetter() external view returns (address);
822 
823     function getPair(address tokenA, address tokenB)
824         external
825         view
826         returns (address pair);
827 
828     function allPairs(uint256) external view returns (address pair);
829 
830     function allPairsLength() external view returns (uint256);
831 
832     function createPair(address tokenA, address tokenB)
833         external
834         returns (address pair);
835 
836     function setFeeTo(address) external;
837 
838     function setFeeToSetter(address) external;
839 }
840 
841 /* pragma solidity 0.8.10; */
842 /* pragma experimental ABIEncoderV2; */ 
843 
844 interface IUniswapV2Pair {
845     event Approval(
846         address indexed owner,
847         address indexed spender,
848         uint256 value
849     );
850     event Transfer(address indexed from, address indexed to, uint256 value);
851 
852     function name() external pure returns (string memory);
853 
854     function symbol() external pure returns (string memory);
855 
856     function decimals() external pure returns (uint8);
857 
858     function totalSupply() external view returns (uint256);
859 
860     function balanceOf(address owner) external view returns (uint256);
861 
862     function allowance(address owner, address spender)
863         external
864         view
865         returns (uint256);
866 
867     function approve(address spender, uint256 value) external returns (bool);
868 
869     function transfer(address to, uint256 value) external returns (bool);
870 
871     function transferFrom(
872         address from,
873         address to,
874         uint256 value
875     ) external returns (bool);
876 
877     function DOMAIN_SEPARATOR() external view returns (bytes32);
878 
879     function PERMIT_TYPEHASH() external pure returns (bytes32);
880 
881     function nonces(address owner) external view returns (uint256);
882 
883     function permit(
884         address owner,
885         address spender,
886         uint256 value,
887         uint256 deadline,
888         uint8 v,
889         bytes32 r,
890         bytes32 s
891     ) external;
892 
893     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
894     event Burn(
895         address indexed sender,
896         uint256 amount0,
897         uint256 amount1,
898         address indexed to
899     );
900     event Swap(
901         address indexed sender,
902         uint256 amount0In,
903         uint256 amount1In,
904         uint256 amount0Out,
905         uint256 amount1Out,
906         address indexed to
907     );
908     event Sync(uint112 reserve0, uint112 reserve1);
909 
910     function MINIMUM_LIQUIDITY() external pure returns (uint256);
911 
912     function factory() external view returns (address);
913 
914     function token0() external view returns (address);
915 
916     function token1() external view returns (address);
917 
918     function getReserves()
919         external
920         view
921         returns (
922             uint112 reserve0,
923             uint112 reserve1,
924             uint32 blockTimestampLast
925         );
926 
927     function price0CumulativeLast() external view returns (uint256);
928 
929     function price1CumulativeLast() external view returns (uint256);
930 
931     function kLast() external view returns (uint256);
932 
933     function mint(address to) external returns (uint256 liquidity);
934 
935     function burn(address to)
936         external
937         returns (uint256 amount0, uint256 amount1);
938 
939     function swap(
940         uint256 amount0Out,
941         uint256 amount1Out,
942         address to,
943         bytes calldata data
944     ) external;
945 
946     function skim(address to) external;
947 
948     function sync() external;
949 
950     function initialize(address, address) external;
951 }
952 
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
1028 contract THETRUTH is ERC20, Ownable {
1029     using SafeMath for uint256;
1030 
1031     IUniswapV2Router02 public immutable uniswapV2Router;
1032     address public immutable uniswapV2Pair;
1033     address public constant deadAddress = address(0xdead);
1034 
1035     bool private swapping;
1036 
1037 	address public charityWallet;
1038     address public marketingWallet;
1039     address public devWallet;
1040 
1041     uint256 public maxTransactionAmount;
1042     uint256 public swapTokensAtAmount;
1043     uint256 public maxWallet;
1044 
1045     bool public limitsInEffect = true;
1046     bool public tradingActive = true;
1047     bool public swapEnabled = true;
1048 
1049     // Anti-bot and anti-whale mappings and variables
1050     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1051     bool public transferDelayEnabled = true;
1052 
1053     uint256 public buyTotalFees;
1054 	uint256 public buyCharityFee;
1055     uint256 public buyMarketingFee;
1056     uint256 public buyLiquidityFee;
1057     uint256 public buyDevFee;
1058 
1059     uint256 public sellTotalFees;
1060 	uint256 public sellCharityFee;
1061     uint256 public sellMarketingFee;
1062     uint256 public sellLiquidityFee;
1063     uint256 public sellDevFee;
1064 
1065 	uint256 public tokensForCharity;
1066     uint256 public tokensForMarketing;
1067     uint256 public tokensForLiquidity;
1068     uint256 public tokensForDev;
1069 
1070     /******************/
1071 
1072     // exlcude from fees and max transaction amount
1073     mapping(address => bool) private _isExcludedFromFees;
1074     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1075 
1076     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1077     // could be subject to a maximum transfer amount
1078     mapping(address => bool) public automatedMarketMakerPairs;
1079 
1080     event UpdateUniswapV2Router(
1081         address indexed newAddress,
1082         address indexed oldAddress
1083     );
1084 
1085     event ExcludeFromFees(address indexed account, bool isExcluded);
1086 
1087     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1088 
1089     event SwapAndLiquify(
1090         uint256 tokensSwapped,
1091         uint256 ethReceived,
1092         uint256 tokensIntoLiquidity
1093     );
1094 
1095     constructor() ERC20("The Truth", "TRUTH") {
1096         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1097             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1098         );
1099 
1100         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1101         uniswapV2Router = _uniswapV2Router;
1102 
1103         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1104             .createPair(address(this), _uniswapV2Router.WETH());
1105         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1106         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1107 
1108 		uint256 _buyCharityFee = 0;
1109         uint256 _buyMarketingFee = 20;
1110         uint256 _buyLiquidityFee = 0;
1111         uint256 _buyDevFee = 0;
1112 
1113 		uint256 _sellCharityFee = 0;
1114         uint256 _sellMarketingFee = 25;
1115         uint256 _sellLiquidityFee = 0;
1116         uint256 _sellDevFee = 0;
1117 
1118         uint256 totalSupply = 1010101010 * 1e18;
1119 
1120         maxTransactionAmount = 5000000 * 1e18; // 1% from total supply maxTransactionAmountTxn
1121         maxWallet = 25000000 * 1e18; // 2% from total supply maxWallet
1122         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1123 
1124 		buyCharityFee = _buyCharityFee;
1125         buyMarketingFee = _buyMarketingFee;
1126         buyLiquidityFee = _buyLiquidityFee;
1127         buyDevFee = _buyDevFee;
1128         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1129 
1130 		sellCharityFee = _sellCharityFee;
1131         sellMarketingFee = _sellMarketingFee;
1132         sellLiquidityFee = _sellLiquidityFee;
1133         sellDevFee = _sellDevFee;
1134         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1135 
1136 		charityWallet = address(0xceceCb30B956Aa917DEddeEc76E35bd23425AE7C); // set as charity wallet
1137         marketingWallet = address(0xceceCb30B956Aa917DEddeEc76E35bd23425AE7C); // set as marketing wallet
1138         devWallet = address(0xceceCb30B956Aa917DEddeEc76E35bd23425AE7C); // set as dev wallet
1139 
1140         // exclude from paying fees or having max transaction amount
1141         excludeFromFees(owner(), true);
1142         excludeFromFees(address(this), true);
1143         excludeFromFees(address(0xdead), true);
1144 
1145         excludeFromMaxTransaction(owner(), true);
1146         excludeFromMaxTransaction(address(this), true);
1147         excludeFromMaxTransaction(address(0xdead), true);
1148 
1149         /*
1150             _mint is an internal function in ERC20.sol that is only called here,
1151             and CANNOT be called ever again
1152         */
1153         _mint(msg.sender, totalSupply);
1154     }
1155 
1156     receive() external payable {}
1157 
1158     // once enabled, can never be turned off
1159     function enableTrading() external onlyOwner {
1160         tradingActive = true;
1161         swapEnabled = true;
1162     }
1163 
1164     // remove limits after token is stable
1165     function removeLimits() external onlyOwner returns (bool) {
1166         limitsInEffect = false;
1167         return true;
1168     }
1169 
1170     // disable Transfer delay - cannot be reenabled
1171     function disableTransferDelay() external onlyOwner returns (bool) {
1172         transferDelayEnabled = false;
1173         return true;
1174     }
1175 
1176     // change the minimum amount of tokens to sell from fees
1177     function updateSwapTokensAtAmount(uint256 newAmount)
1178         external
1179         onlyOwner
1180         returns (bool)
1181     {
1182         require(
1183             newAmount >= (totalSupply() * 1) / 100000,
1184             "Swap amount cannot be lower than 0.001% total supply."
1185         );
1186         require(
1187             newAmount <= (totalSupply() * 5) / 1000,
1188             "Swap amount cannot be higher than 0.5% total supply."
1189         );
1190         swapTokensAtAmount = newAmount;
1191         return true;
1192     }
1193 
1194     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1195         require(
1196             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1197             "Cannot set maxTransactionAmount lower than 0.5%"
1198         );
1199         maxTransactionAmount = newNum * (10**18);
1200     }
1201 
1202     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1203         require(
1204             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1205             "Cannot set maxWallet lower than 0.5%"
1206         );
1207         maxWallet = newNum * (10**18);
1208     }
1209 	
1210     function excludeFromMaxTransaction(address updAds, bool isEx)
1211         public
1212         onlyOwner
1213     {
1214         _isExcludedMaxTransactionAmount[updAds] = isEx;
1215     }
1216 
1217     // only use to disable contract sales if absolutely necessary (emergency use only)
1218     function updateSwapEnabled(bool enabled) external onlyOwner {
1219         swapEnabled = enabled;
1220     }
1221 
1222     function updateBuyFees(
1223 		uint256 _charityFee,
1224         uint256 _marketingFee,
1225         uint256 _liquidityFee,
1226         uint256 _devFee
1227     ) external onlyOwner {
1228 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1229 		buyCharityFee = _charityFee;
1230         buyMarketingFee = _marketingFee;
1231         buyLiquidityFee = _liquidityFee;
1232         buyDevFee = _devFee;
1233         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1234      }
1235 
1236     function updateSellFees(
1237 		uint256 _charityFee,
1238         uint256 _marketingFee,
1239         uint256 _liquidityFee,
1240         uint256 _devFee
1241     ) external onlyOwner {
1242 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1243 		sellCharityFee = _charityFee;
1244         sellMarketingFee = _marketingFee;
1245         sellLiquidityFee = _liquidityFee;
1246         sellDevFee = _devFee;
1247         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1248     }
1249 
1250     function excludeFromFees(address account, bool excluded) public onlyOwner {
1251         _isExcludedFromFees[account] = excluded;
1252         emit ExcludeFromFees(account, excluded);
1253     }
1254 
1255     function setAutomatedMarketMakerPair(address pair, bool value)
1256         public
1257         onlyOwner
1258     {
1259         require(
1260             pair != uniswapV2Pair,
1261             "The pair cannot be removed from automatedMarketMakerPairs"
1262         );
1263 
1264         _setAutomatedMarketMakerPair(pair, value);
1265     }
1266 
1267     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1268         automatedMarketMakerPairs[pair] = value;
1269 
1270         emit SetAutomatedMarketMakerPair(pair, value);
1271     }
1272 
1273     function isExcludedFromFees(address account) public view returns (bool) {
1274         return _isExcludedFromFees[account];
1275     }
1276 
1277     function _transfer(
1278         address from,
1279         address to,
1280         uint256 amount
1281     ) internal override {
1282         require(from != address(0), "ERC20: transfer from the zero address");
1283         require(to != address(0), "ERC20: transfer to the zero address");
1284 
1285         if (amount == 0) {
1286             super._transfer(from, to, 0);
1287             return;
1288         }
1289 
1290         if (limitsInEffect) {
1291             if (
1292                 from != owner() &&
1293                 to != owner() &&
1294                 to != address(0) &&
1295                 to != address(0xdead) &&
1296                 !swapping
1297             ) {
1298                 if (!tradingActive) {
1299                     require(
1300                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1301                         "Trading is not active."
1302                     );
1303                 }
1304 
1305                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1306                 if (transferDelayEnabled) {
1307                     if (
1308                         to != owner() &&
1309                         to != address(uniswapV2Router) &&
1310                         to != address(uniswapV2Pair)
1311                     ) {
1312                         require(
1313                             _holderLastTransferTimestamp[tx.origin] <
1314                                 block.number,
1315                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1316                         );
1317                         _holderLastTransferTimestamp[tx.origin] = block.number;
1318                     }
1319                 }
1320 
1321                 //when buy
1322                 if (
1323                     automatedMarketMakerPairs[from] &&
1324                     !_isExcludedMaxTransactionAmount[to]
1325                 ) {
1326                     require(
1327                         amount <= maxTransactionAmount,
1328                         "Buy transfer amount exceeds the maxTransactionAmount."
1329                     );
1330                     require(
1331                         amount + balanceOf(to) <= maxWallet,
1332                         "Max wallet exceeded"
1333                     );
1334                 }
1335                 //when sell
1336                 else if (
1337                     automatedMarketMakerPairs[to] &&
1338                     !_isExcludedMaxTransactionAmount[from]
1339                 ) {
1340                     require(
1341                         amount <= maxTransactionAmount,
1342                         "Sell transfer amount exceeds the maxTransactionAmount."
1343                     );
1344                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1345                     require(
1346                         amount + balanceOf(to) <= maxWallet,
1347                         "Max wallet exceeded"
1348                     );
1349                 }
1350             }
1351         }
1352 
1353         uint256 contractTokenBalance = balanceOf(address(this));
1354 
1355         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1356 
1357         if (
1358             canSwap &&
1359             swapEnabled &&
1360             !swapping &&
1361             !automatedMarketMakerPairs[from] &&
1362             !_isExcludedFromFees[from] &&
1363             !_isExcludedFromFees[to]
1364         ) {
1365             swapping = true;
1366 
1367             swapBack();
1368 
1369             swapping = false;
1370         }
1371 
1372         bool takeFee = !swapping;
1373 
1374         // if any account belongs to _isExcludedFromFee account then remove the fee
1375         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1376             takeFee = false;
1377         }
1378 
1379         uint256 fees = 0;
1380         // only take fees on buys/sells, do not take on wallet transfers
1381         if (takeFee) {
1382             // on sell
1383             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1384                 fees = amount.mul(sellTotalFees).div(100);
1385 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1386                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1387                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1388                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1389             }
1390             // on buy
1391             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1392                 fees = amount.mul(buyTotalFees).div(100);
1393 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1394                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1395                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1396                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1397             }
1398 
1399             if (fees > 0) {
1400                 super._transfer(from, address(this), fees);
1401             }
1402 
1403             amount -= fees;
1404         }
1405 
1406         super._transfer(from, to, amount);
1407     }
1408 
1409     function swapTokensForEth(uint256 tokenAmount) private {
1410         // generate the uniswap pair path of token -> weth
1411         address[] memory path = new address[](2);
1412         path[0] = address(this);
1413         path[1] = uniswapV2Router.WETH();
1414 
1415         _approve(address(this), address(uniswapV2Router), tokenAmount);
1416 
1417         // make the swap
1418         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1419             tokenAmount,
1420             0, // accept any amount of ETH
1421             path,
1422             address(this),
1423             block.timestamp
1424         );
1425     }
1426 
1427     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1428         // approve token transfer to cover all possible scenarios
1429         _approve(address(this), address(uniswapV2Router), tokenAmount);
1430 
1431         // add the liquidity
1432         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1433             address(this),
1434             tokenAmount,
1435             0, // slippage is unavoidable
1436             0, // slippage is unavoidable
1437             devWallet,
1438             block.timestamp
1439         );
1440     }
1441 
1442     function swapBack() private {
1443         uint256 contractBalance = balanceOf(address(this));
1444         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1445         bool success;
1446 
1447         if (contractBalance == 0 || totalTokensToSwap == 0) {
1448             return;
1449         }
1450 
1451         if (contractBalance > swapTokensAtAmount * 20) {
1452             contractBalance = swapTokensAtAmount * 20;
1453         }
1454 
1455         // Halve the amount of liquidity tokens
1456         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1457         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1458 
1459         uint256 initialETHBalance = address(this).balance;
1460 
1461         swapTokensForEth(amountToSwapForETH);
1462 
1463         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1464 
1465 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1466         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1467         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1468 
1469         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1470 
1471         tokensForLiquidity = 0;
1472 		tokensForCharity = 0;
1473         tokensForMarketing = 0;
1474         tokensForDev = 0;
1475 
1476         (success, ) = address(devWallet).call{value: ethForDev}("");
1477         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1478 
1479 
1480         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1481             addLiquidity(liquidityTokens, ethForLiquidity);
1482             emit SwapAndLiquify(
1483                 amountToSwapForETH,
1484                 ethForLiquidity,
1485                 tokensForLiquidity
1486             );
1487         }
1488 
1489         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1490     }
1491 
1492 }