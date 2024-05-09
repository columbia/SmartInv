1 /*
2                 
3 ************,,,,,,,,,,,,,,,,,,,,,,,.................................                     
4 ************,,,,,,,,,,,,,,,,,,,,,,,.................................                     
5 ************,,,,,,,,,,,,,,,,,,,,,,,...&@@@..........................                     
6 ************,,,,,,,,,,,,,,,,,,,,,,,..#@@@@@.........................                     
7 ************,,,,,,,,,,,,,,,,,,,,,,,.*@@@@@@@........................                      
8 ************,,,,,,,,,,,,,,,,,,,,,,,,@@@..@@@@.......................                     
9 ************,,,,,,,,,,,,,,,,,,,,,,,@@@....@@@@......................                     
10 ************,,,,,,,,,,,,,,,,,,,,,,@@@......@@@@.....................                     
11 ************,,,,,,,,,,,,,,,,,,,,,@@@........@@@@....................                     
12 ************,,,,,,,,,,,,,,,,,,,,@@@,.........@@@@...................                     
13 ************,,,,,,,,,,,,,,,,,,,@@@*...........@@@&..................                     
14 ************,,,,,,,,,,,,,,,,,,@@@(,............@@@#.................                     
15 ************,,,,,,,,,,,,,,,,,@@@%,,.............@@@(................                     
16 ************,,,,,,,,,,,,,,,,@@@@,,,..............@@@/...............                     
17 ************,,,,,,,,,,,,,,,@@@@,,,,...............@@@/..............                     
18 ************,,,,,,,,,,,,,,@@@@,,,,,................@@@*.............                     
19 ************,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,............                     
20 ************,,,,,,,,,,,,%@@@,,,,,,,..................@@@............                     
21 ************,,,,,,,,,,,(@@@,,,,,,,,...................@@@...........                     
22 ************,,,,,,,,,,*@@@,,,,,,,,,....................@@@..........                     
23 ************,,,,,,,,,,@@@,,,,,,,,,,.....................@@@.........                     
24 ************,,,,,,,,,@@@,,,,,,,,,,,......................@@@........                  
25 ************,,,,,,,,,%@,,,,,,,,,,,,.................................                     
26 ************,,,,,,,,,,,,,,,,,,,,,,,.................................                    
27 ************,,,,,,,,,,,,,,,,,,,,,,,.................................                     
28 */
29 
30 // SPDX-License-Identifier: MIT
31 
32 /**
33 
34 
35 Website: https://axecapital.pro/
36 
37 Twitter: https://twitter.com/coinaxecapital
38 
39 Telegram: https://t.me/+TR-DjyYpFwkzZjEy
40 
41 
42 */
43 
44 
45 pragma solidity ^0.8.0;
46 
47 // CAUTION
48 // This version of SafeMath should only be used with Solidity 0.8 or later,
49 // because it relies on the compiler's built in overflow checks.
50 
51 /**
52  * @dev Wrappers over Solidity's arithmetic operations.
53  *
54  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
55  * now has built in overflow checking.
56  */
57 library SafeMath {
58     /**
59      * @dev Returns the addition of two unsigned integers, with an overflow flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             uint256 c = a + b;
66             if (c < a) return (false, 0);
67             return (true, c);
68         }
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
73      *
74      * _Available since v3.4._
75      */
76     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b > a) return (false, 0);
79             return (true, a - b);
80         }
81     }
82 
83     /**
84      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91             // benefit is lost if 'b' is also tested.
92             if (a == 0) return (true, 0);
93             uint256 c = a * b;
94             if (c / a != b) return (false, 0);
95             return (true, c);
96         }
97     }
98 
99     /**
100      * @dev Returns the division of two unsigned integers, with a division by zero flag.
101      *
102      * _Available since v3.4._
103      */
104     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             if (b == 0) return (false, 0);
107             return (true, a / b);
108         }
109     }
110 
111     /**
112      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
113      *
114      * _Available since v3.4._
115      */
116     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             if (b == 0) return (false, 0);
119             return (true, a % b);
120         }
121     }
122 
123     /**
124      * @dev Returns the addition of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `+` operator.
128      *
129      * Requirements:
130      *
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a + b;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a - b;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a * b;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers, reverting on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator.
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a / b;
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * reverting when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a % b;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
197      * overflow (when the result is negative).
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {trySub}.
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      *
206      * - Subtraction cannot overflow.
207      */
208     function sub(
209         uint256 a,
210         uint256 b,
211         string memory errorMessage
212     ) internal pure returns (uint256) {
213         unchecked {
214             require(b <= a, errorMessage);
215             return a - b;
216         }
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         unchecked {
237             require(b > 0, errorMessage);
238             return a / b;
239         }
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * reverting with custom message when dividing by zero.
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {tryMod}.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         unchecked {
263             require(b > 0, errorMessage);
264             return a % b;
265         }
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Context.sol
270 
271 
272 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
273 
274 pragma solidity ^0.8.0;
275 
276 /**
277  * @dev Provides information about the current execution context, including the
278  * sender of the transaction and its data. While these are generally available
279  * via msg.sender and msg.data, they should not be accessed in such a direct
280  * manner, since when dealing with meta-transactions the account sending and
281  * paying for execution may not be the actual sender (as far as an application
282  * is concerned).
283  *
284  * This contract is only required for intermediate, library-like contracts.
285  */
286 abstract contract Context {
287     function _msgSender() internal view virtual returns (address) {
288         return msg.sender;
289     }
290 
291     function _msgData() internal view virtual returns (bytes calldata) {
292         return msg.data;
293     }
294 }
295 
296 // File: @openzeppelin/contracts/access/Ownable.sol
297 
298 
299 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 
304 /**
305  * @dev Contract module which provides a basic access control mechanism, where
306  * there is an account (an owner) that can be granted exclusive access to
307  * specific functions.
308  *
309  * By default, the owner account will be the one that deploys the contract. This
310  * can later be changed with {transferOwnership}.
311  *
312  * This module is used through inheritance. It will make available the modifier
313  * `onlyOwner`, which can be applied to your functions to restrict their use to
314  * the owner.
315  */
316 abstract contract Ownable is Context {
317     address private _owner;
318 
319     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
320 
321     /**
322      * @dev Initializes the contract setting the deployer as the initial owner.
323      */
324     constructor() {
325         _transferOwnership(_msgSender());
326     }
327 
328     /**
329      * @dev Throws if called by any account other than the owner.
330      */
331     modifier onlyOwner() {
332         _checkOwner();
333         _;
334     }
335 
336     /**
337      * @dev Returns the address of the current owner.
338      */
339     function owner() public view virtual returns (address) {
340         return _owner;
341     }
342 
343     /**
344      * @dev Throws if the sender is not the owner.
345      */
346     function _checkOwner() internal view virtual {
347         require(owner() == _msgSender(), "Ownable: caller is not the owner");
348     }
349 
350     /**
351      * @dev Leaves the contract without owner. It will not be possible to call
352      * `onlyOwner` functions anymore. Can only be called by the current owner.
353      *
354      * NOTE: Renouncing ownership will leave the contract without an owner,
355      * thereby removing any functionality that is only available to the owner.
356      */
357     function renounceOwnership() public virtual onlyOwner {
358         _transferOwnership(address(0));
359     }
360 
361     /**
362      * @dev Transfers ownership of the contract to a new account (`newOwner`).
363      * Can only be called by the current owner.
364      */
365     function transferOwnership(address newOwner) public virtual onlyOwner {
366         require(newOwner != address(0), "Ownable: new owner is the zero address");
367         _transferOwnership(newOwner);
368     }
369 
370     /**
371      * @dev Transfers ownership of the contract to a new account (`newOwner`).
372      * Internal function without access restriction.
373      */
374     function _transferOwnership(address newOwner) internal virtual {
375         address oldOwner = _owner;
376         _owner = newOwner;
377         emit OwnershipTransferred(oldOwner, newOwner);
378     }
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
382 
383 
384 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
385 
386 pragma solidity ^0.8.0;
387 
388 /**
389  * @dev Interface of the ERC20 standard as defined in the EIP.
390  */
391 interface IERC20 {
392     /**
393      * @dev Emitted when `value` tokens are moved from one account (`from`) to
394      * another (`to`).
395      *
396      * Note that `value` may be zero.
397      */
398     event Transfer(address indexed from, address indexed to, uint256 value);
399 
400     /**
401      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
402      * a call to {approve}. `value` is the new allowance.
403      */
404     event Approval(address indexed owner, address indexed spender, uint256 value);
405 
406     /**
407      * @dev Returns the amount of tokens in existence.
408      */
409     function totalSupply() external view returns (uint256);
410 
411     /**
412      * @dev Returns the amount of tokens owned by `account`.
413      */
414     function balanceOf(address account) external view returns (uint256);
415 
416     /**
417      * @dev Moves `amount` tokens from the caller's account to `to`.
418      *
419      * Returns a boolean value indicating whether the operation succeeded.
420      *
421      * Emits a {Transfer} event.
422      */
423     function transfer(address to, uint256 amount) external returns (bool);
424 
425     /**
426      * @dev Returns the remaining number of tokens that `spender` will be
427      * allowed to spend on behalf of `owner` through {transferFrom}. This is
428      * zero by default.
429      *
430      * This value changes when {approve} or {transferFrom} are called.
431      */
432     function allowance(address owner, address spender) external view returns (uint256);
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
436      *
437      * Returns a boolean value indicating whether the operation succeeded.
438      *
439      * IMPORTANT: Beware that changing an allowance with this method brings the risk
440      * that someone may use both the old and the new allowance by unfortunate
441      * transaction ordering. One possible solution to mitigate this race
442      * condition is to first reduce the spender's allowance to 0 and set the
443      * desired value afterwards:
444      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
445      *
446      * Emits an {Approval} event.
447      */
448     function approve(address spender, uint256 amount) external returns (bool);
449 
450     /**
451      * @dev Moves `amount` tokens from `from` to `to` using the
452      * allowance mechanism. `amount` is then deducted from the caller's
453      * allowance.
454      *
455      * Returns a boolean value indicating whether the operation succeeded.
456      *
457      * Emits a {Transfer} event.
458      */
459     function transferFrom(
460         address from,
461         address to,
462         uint256 amount
463     ) external returns (bool);
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
467 
468 
469 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
470 
471 pragma solidity ^0.8.0;
472 
473 
474 /**
475  * @dev Interface for the optional metadata functions from the ERC20 standard.
476  *
477  * _Available since v4.1._
478  */
479 interface IERC20Metadata is IERC20 {
480     /**
481      * @dev Returns the name of the token.
482      */
483     function name() external view returns (string memory);
484 
485     /**
486      * @dev Returns the symbol of the token.
487      */
488     function symbol() external view returns (string memory);
489 
490     /**
491      * @dev Returns the decimals places of the token.
492      */
493     function decimals() external view returns (uint8);
494 }
495 
496 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
497 
498 
499 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
500 
501 pragma solidity ^0.8.0;
502 
503 
504 
505 
506 /**
507  * @dev Implementation of the {IERC20} interface.
508  *
509  * This implementation is agnostic to the way tokens are created. This means
510  * that a supply mechanism has to be added in a derived contract using {_mint}.
511  * For a generic mechanism see {ERC20PresetMinterPauser}.
512  *
513  * TIP: For a detailed writeup see our guide
514  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
515  * to implement supply mechanisms].
516  *
517  * We have followed general OpenZeppelin Contracts guidelines: functions revert
518  * instead returning `false` on failure. This behavior is nonetheless
519  * conventional and does not conflict with the expectations of ERC20
520  * applications.
521  *
522  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
523  * This allows applications to reconstruct the allowance for all accounts just
524  * by listening to said events. Other implementations of the EIP may not emit
525  * these events, as it isn't required by the specification.
526  *
527  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
528  * functions have been added to mitigate the well-known issues around setting
529  * allowances. See {IERC20-approve}.
530  */
531 contract ERC20 is Context, IERC20, IERC20Metadata {
532     mapping(address => uint256) private _balances;
533 
534     mapping(address => mapping(address => uint256)) private _allowances;
535 
536     uint256 private _totalSupply;
537 
538     string private _name;
539     string private _symbol;
540 
541     /**
542      * @dev Sets the values for {name} and {symbol}.
543      *
544      * The default value of {decimals} is 18. To select a different value for
545      * {decimals} you should overload it.
546      *
547      * All two of these values are immutable: they can only be set once during
548      * construction.
549      */
550     constructor(string memory name_, string memory symbol_) {
551         _name = name_;
552         _symbol = symbol_;
553     }
554 
555     /**
556      * @dev Returns the name of the token.
557      */
558     function name() public view virtual override returns (string memory) {
559         return _name;
560     }
561 
562     /**
563      * @dev Returns the symbol of the token, usually a shorter version of the
564      * name.
565      */
566     function symbol() public view virtual override returns (string memory) {
567         return _symbol;
568     }
569 
570     /**
571      * @dev Returns the number of decimals used to get its user representation.
572      * For example, if `decimals` equals `2`, a balance of `505` tokens should
573      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
574      *
575      * Tokens usually opt for a value of 18, imitating the relationship between
576      * Ether and Wei. This is the value {ERC20} uses, unless this function is
577      * overridden;
578      *
579      * NOTE: This information is only used for _display_ purposes: it in
580      * no way affects any of the arithmetic of the contract, including
581      * {IERC20-balanceOf} and {IERC20-transfer}.
582      */
583     function decimals() public view virtual override returns (uint8) {
584         return 9;
585     }
586 
587     /**
588      * @dev See {IERC20-totalSupply}.
589      */
590     function totalSupply() public view virtual override returns (uint256) {
591         return _totalSupply;
592     }
593 
594     /**
595      * @dev See {IERC20-balanceOf}.
596      */
597     function balanceOf(address account) public view virtual override returns (uint256) {
598         return _balances[account];
599     }
600 
601     /**
602      * @dev See {IERC20-transfer}.
603      *
604      * Requirements:
605      *
606      * - `to` cannot be the zero address.
607      * - the caller must have a balance of at least `amount`.
608      */
609     function transfer(address to, uint256 amount) public virtual override returns (bool) {
610         address owner = _msgSender();
611         _transfer(owner, to, amount);
612         return true;
613     }
614 
615     /**
616      * @dev See {IERC20-allowance}.
617      */
618     function allowance(address owner, address spender) public view virtual override returns (uint256) {
619         return _allowances[owner][spender];
620     }
621 
622     /**
623      * @dev See {IERC20-approve}.
624      *
625      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
626      * `transferFrom`. This is semantically equivalent to an infinite approval.
627      *
628      * Requirements:
629      *
630      * - `spender` cannot be the zero address.
631      */
632     function approve(address spender, uint256 amount) public virtual override returns (bool) {
633         address owner = _msgSender();
634         _approve(owner, spender, amount);
635         return true;
636     }
637 
638     /**
639      * @dev See {IERC20-transferFrom}.
640      *
641      * Emits an {Approval} event indicating the updated allowance. This is not
642      * required by the EIP. See the note at the beginning of {ERC20}.
643      *
644      * NOTE: Does not update the allowance if the current allowance
645      * is the maximum `uint256`.
646      *
647      * Requirements:
648      *
649      * - `from` and `to` cannot be the zero address.
650      * - `from` must have a balance of at least `amount`.
651      * - the caller must have allowance for ``from``'s tokens of at least
652      * `amount`.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 amount
658     ) public virtual override returns (bool) {
659         address spender = _msgSender();
660         _spendAllowance(from, spender, amount);
661         _transfer(from, to, amount);
662         return true;
663     }
664 
665     /**
666      * @dev Atomically increases the allowance granted to `spender` by the caller.
667      *
668      * This is an alternative to {approve} that can be used as a mitigation for
669      * problems described in {IERC20-approve}.
670      *
671      * Emits an {Approval} event indicating the updated allowance.
672      *
673      * Requirements:
674      *
675      * - `spender` cannot be the zero address.
676      */
677     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
678         address owner = _msgSender();
679         _approve(owner, spender, allowance(owner, spender) + addedValue);
680         return true;
681     }
682 
683     /**
684      * @dev Atomically decreases the allowance granted to `spender` by the caller.
685      *
686      * This is an alternative to {approve} that can be used as a mitigation for
687      * problems described in {IERC20-approve}.
688      *
689      * Emits an {Approval} event indicating the updated allowance.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      * - `spender` must have allowance for the caller of at least
695      * `subtractedValue`.
696      */
697     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
698         address owner = _msgSender();
699         uint256 currentAllowance = allowance(owner, spender);
700         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
701         unchecked {
702             _approve(owner, spender, currentAllowance - subtractedValue);
703         }
704 
705         return true;
706     }
707 
708     /**
709      * @dev Moves `amount` of tokens from `from` to `to`.
710      *
711      * This internal function is equivalent to {transfer}, and can be used to
712      * e.g. implement automatic token fees, slashing mechanisms, etc.
713      *
714      * Emits a {Transfer} event.
715      *
716      * Requirements:
717      *
718      * - `from` cannot be the zero address.
719      * - `to` cannot be the zero address.
720      * - `from` must have a balance of at least `amount`.
721      */
722     function _transfer(
723         address from,
724         address to,
725         uint256 amount
726     ) internal virtual {
727         require(from != address(0), "ERC20: transfer from the zero address");
728         require(to != address(0), "ERC20: transfer to the zero address");
729 
730         _beforeTokenTransfer(from, to, amount);
731 
732         uint256 fromBalance = _balances[from];
733         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
734         unchecked {
735             _balances[from] = fromBalance - amount;
736             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
737             // decrementing then incrementing.
738             _balances[to] += amount;
739         }
740 
741         emit Transfer(from, to, amount);
742 
743         _afterTokenTransfer(from, to, amount);
744     }
745 
746     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
747      * the total supply.
748      *
749      * Emits a {Transfer} event with `from` set to the zero address.
750      *
751      * Requirements:
752      *
753      * - `account` cannot be the zero address.
754      */
755     function _mint(address account, uint256 amount) internal virtual {
756         require(account != address(0), "ERC20: mint to the zero address");
757 
758         _beforeTokenTransfer(address(0), account, amount);
759 
760         _totalSupply += amount;
761         unchecked {
762             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
763             _balances[account] += amount;
764         }
765         emit Transfer(address(0), account, amount);
766 
767         _afterTokenTransfer(address(0), account, amount);
768     }
769 
770     /**
771      * @dev Destroys `amount` tokens from `account`, reducing the
772      * total supply.
773      *
774      * Emits a {Transfer} event with `to` set to the zero address.
775      *
776      * Requirements:
777      *
778      * - `account` cannot be the zero address.
779      * - `account` must have at least `amount` tokens.
780      */
781     function _burn(address account, uint256 amount) internal virtual {
782         require(account != address(0), "ERC20: burn from the zero address");
783 
784         _beforeTokenTransfer(account, address(0), amount);
785 
786         uint256 accountBalance = _balances[account];
787         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
788         unchecked {
789             _balances[account] = accountBalance - amount;
790             // Overflow not possible: amount <= accountBalance <= totalSupply.
791             _totalSupply -= amount;
792         }
793 
794         emit Transfer(account, address(0), amount);
795 
796         _afterTokenTransfer(account, address(0), amount);
797     }
798 
799     /**
800      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
801      *
802      * This internal function is equivalent to `approve`, and can be used to
803      * e.g. set automatic allowances for certain subsystems, etc.
804      *
805      * Emits an {Approval} event.
806      *
807      * Requirements:
808      *
809      * - `owner` cannot be the zero address.
810      * - `spender` cannot be the zero address.
811      */
812     function _approve(
813         address owner,
814         address spender,
815         uint256 amount
816     ) internal virtual {
817         require(owner != address(0), "ERC20: approve from the zero address");
818         require(spender != address(0), "ERC20: approve to the zero address");
819 
820         _allowances[owner][spender] = amount;
821         emit Approval(owner, spender, amount);
822     }
823 
824     /**
825      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
826      *
827      * Does not update the allowance amount in case of infinite allowance.
828      * Revert if not enough allowance is available.
829      *
830      * Might emit an {Approval} event.
831      */
832     function _spendAllowance(
833         address owner,
834         address spender,
835         uint256 amount
836     ) internal virtual {
837         uint256 currentAllowance = allowance(owner, spender);
838         if (currentAllowance != type(uint256).max) {
839             require(currentAllowance >= amount, "ERC20: insufficient allowance");
840             unchecked {
841                 _approve(owner, spender, currentAllowance - amount);
842             }
843         }
844     }
845 
846     /**
847      * @dev Hook that is called before any transfer of tokens. This includes
848      * minting and burning.
849      *
850      * Calling conditions:
851      *
852      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
853      * will be transferred to `to`.
854      * - when `from` is zero, `amount` tokens will be minted for `to`.
855      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
856      * - `from` and `to` are never both zero.
857      *
858      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
859      */
860     function _beforeTokenTransfer(
861         address from,
862         address to,
863         uint256 amount
864     ) internal virtual {}
865 
866     /**
867      * @dev Hook that is called after any transfer of tokens. This includes
868      * minting and burning.
869      *
870      * Calling conditions:
871      *
872      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
873      * has been transferred to `to`.
874      * - when `from` is zero, `amount` tokens have been minted for `to`.
875      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
876      * - `from` and `to` are never both zero.
877      *
878      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
879      */
880     function _afterTokenTransfer(
881         address from,
882         address to,
883         uint256 amount
884     ) internal virtual {}
885 }
886 
887 pragma solidity 0.8.10;
888 
889 
890 interface IUniswapV2Pair {
891     event Approval(address indexed owner, address indexed spender, uint value);
892     event Transfer(address indexed from, address indexed to, uint value);
893 
894     function name() external pure returns (string memory);
895     function symbol() external pure returns (string memory);
896     function decimals() external pure returns (uint8);
897     function totalSupply() external view returns (uint);
898     function balanceOf(address owner) external view returns (uint);
899     function allowance(address owner, address spender) external view returns (uint);
900 
901     function approve(address spender, uint value) external returns (bool);
902     function transfer(address to, uint value) external returns (bool);
903     function transferFrom(address from, address to, uint value) external returns (bool);
904 
905     function DOMAIN_SEPARATOR() external view returns (bytes32);
906     function PERMIT_TYPEHASH() external pure returns (bytes32);
907     function nonces(address owner) external view returns (uint);
908 
909     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
910 
911     event Mint(address indexed sender, uint amount0, uint amount1);
912     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
913     event Swap(
914         address indexed sender,
915         uint amount0In,
916         uint amount1In,
917         uint amount0Out,
918         uint amount1Out,
919         address indexed to
920     );
921     event Sync(uint112 reserve0, uint112 reserve1);
922 
923     function MINIMUM_LIQUIDITY() external pure returns (uint);
924     function factory() external view returns (address);
925     function token0() external view returns (address);
926     function token1() external view returns (address);
927     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
928     function price0CumulativeLast() external view returns (uint);
929     function price1CumulativeLast() external view returns (uint);
930     function kLast() external view returns (uint);
931 
932     function mint(address to) external returns (uint liquidity);
933     function burn(address to) external returns (uint amount0, uint amount1);
934     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
935     function skim(address to) external;
936     function sync() external;
937 
938     function initialize(address, address) external;
939 }
940 
941 
942 interface IUniswapV2Factory {
943     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
944 
945     function feeTo() external view returns (address);
946     function feeToSetter() external view returns (address);
947 
948     function getPair(address tokenA, address tokenB) external view returns (address pair);
949     function allPairs(uint) external view returns (address pair);
950     function allPairsLength() external view returns (uint);
951 
952     function createPair(address tokenA, address tokenB) external returns (address pair);
953 
954     function setFeeTo(address) external;
955     function setFeeToSetter(address) external;
956 }
957 
958 
959 library SafeMathInt {
960     int256 private constant MIN_INT256 = int256(1) << 255;
961     int256 private constant MAX_INT256 = ~(int256(1) << 255);
962 
963     /**
964      * @dev Multiplies two int256 variables and fails on overflow.
965      */
966     function mul(int256 a, int256 b) internal pure returns (int256) {
967         int256 c = a * b;
968 
969         // Detect overflow when multiplying MIN_INT256 with -1
970         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
971         require((b == 0) || (c / b == a));
972         return c;
973     }
974 
975     /**
976      * @dev Division of two int256 variables and fails on overflow.
977      */
978     function div(int256 a, int256 b) internal pure returns (int256) {
979         // Prevent overflow when dividing MIN_INT256 by -1
980         require(b != -1 || a != MIN_INT256);
981 
982         // Solidity already throws when dividing by 0.
983         return a / b;
984     }
985 
986     /**
987      * @dev Subtracts two int256 variables and fails on overflow.
988      */
989     function sub(int256 a, int256 b) internal pure returns (int256) {
990         int256 c = a - b;
991         require((b >= 0 && c <= a) || (b < 0 && c > a));
992         return c;
993     }
994 
995     /**
996      * @dev Adds two int256 variables and fails on overflow.
997      */
998     function add(int256 a, int256 b) internal pure returns (int256) {
999         int256 c = a + b;
1000         require((b >= 0 && c >= a) || (b < 0 && c < a));
1001         return c;
1002     }
1003 
1004     /**
1005      * @dev Converts to absolute value, and fails on overflow.
1006      */
1007     function abs(int256 a) internal pure returns (int256) {
1008         require(a != MIN_INT256);
1009         return a < 0 ? -a : a;
1010     }
1011 
1012 
1013     function toUint256Safe(int256 a) internal pure returns (uint256) {
1014         require(a >= 0);
1015         return uint256(a);
1016     }
1017 }
1018 
1019 library SafeMathUint {
1020   function toInt256Safe(uint256 a) internal pure returns (int256) {
1021     int256 b = int256(a);
1022     require(b >= 0);
1023     return b;
1024   }
1025 }
1026 
1027 
1028 interface IUniswapV2Router01 {
1029     function factory() external pure returns (address);
1030     function WETH() external pure returns (address);
1031 
1032     function addLiquidity(
1033         address tokenA,
1034         address tokenB,
1035         uint amountADesired,
1036         uint amountBDesired,
1037         uint amountAMin,
1038         uint amountBMin,
1039         address to,
1040         uint deadline
1041     ) external returns (uint amountA, uint amountB, uint liquidity);
1042     function addLiquidityETH(
1043         address token,
1044         uint amountTokenDesired,
1045         uint amountTokenMin,
1046         uint amountETHMin,
1047         address to,
1048         uint deadline
1049     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1050     function removeLiquidity(
1051         address tokenA,
1052         address tokenB,
1053         uint liquidity,
1054         uint amountAMin,
1055         uint amountBMin,
1056         address to,
1057         uint deadline
1058     ) external returns (uint amountA, uint amountB);
1059     function removeLiquidityETH(
1060         address token,
1061         uint liquidity,
1062         uint amountTokenMin,
1063         uint amountETHMin,
1064         address to,
1065         uint deadline
1066     ) external returns (uint amountToken, uint amountETH);
1067     function removeLiquidityWithPermit(
1068         address tokenA,
1069         address tokenB,
1070         uint liquidity,
1071         uint amountAMin,
1072         uint amountBMin,
1073         address to,
1074         uint deadline,
1075         bool approveMax, uint8 v, bytes32 r, bytes32 s
1076     ) external returns (uint amountA, uint amountB);
1077     function removeLiquidityETHWithPermit(
1078         address token,
1079         uint liquidity,
1080         uint amountTokenMin,
1081         uint amountETHMin,
1082         address to,
1083         uint deadline,
1084         bool approveMax, uint8 v, bytes32 r, bytes32 s
1085     ) external returns (uint amountToken, uint amountETH);
1086     function swapExactTokensForTokens(
1087         uint amountIn,
1088         uint amountOutMin,
1089         address[] calldata path,
1090         address to,
1091         uint deadline
1092     ) external returns (uint[] memory amounts);
1093     function swapTokensForExactTokens(
1094         uint amountOut,
1095         uint amountInMax,
1096         address[] calldata path,
1097         address to,
1098         uint deadline
1099     ) external returns (uint[] memory amounts);
1100     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1101         external
1102         payable
1103         returns (uint[] memory amounts);
1104     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1105         external
1106         returns (uint[] memory amounts);
1107     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1108         external
1109         returns (uint[] memory amounts);
1110     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1111         external
1112         payable
1113         returns (uint[] memory amounts);
1114 
1115     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1116     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1117     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1118     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1119     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1120 }
1121 
1122 interface IUniswapV2Router02 is IUniswapV2Router01 {
1123     function removeLiquidityETHSupportingFeeOnTransferTokens(
1124         address token,
1125         uint liquidity,
1126         uint amountTokenMin,
1127         uint amountETHMin,
1128         address to,
1129         uint deadline
1130     ) external returns (uint amountETH);
1131     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1132         address token,
1133         uint liquidity,
1134         uint amountTokenMin,
1135         uint amountETHMin,
1136         address to,
1137         uint deadline,
1138         bool approveMax, uint8 v, bytes32 r, bytes32 s
1139     ) external returns (uint amountETH);
1140 
1141     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1142         uint amountIn,
1143         uint amountOutMin,
1144         address[] calldata path,
1145         address to,
1146         uint deadline
1147     ) external;
1148     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1149         uint amountOutMin,
1150         address[] calldata path,
1151         address to,
1152         uint deadline
1153     ) external payable;
1154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1155         uint amountIn,
1156         uint amountOutMin,
1157         address[] calldata path,
1158         address to,
1159         uint deadline
1160     ) external;
1161 }
1162 
1163 
1164 contract Axe is ERC20, Ownable  {
1165     using SafeMath for uint256;
1166 
1167     IUniswapV2Router02 public immutable uniswapV2Router;
1168     address public immutable uniswapV2Pair;
1169     address public constant deadAddress = address(0xdead);
1170 
1171     bool private swapping;
1172 
1173     address public marketingWallet;
1174     address public devWallet;
1175     
1176     uint256 public maxTransactionAmount;
1177     uint256 public swapTokensAtAmount;
1178     uint256 public maxWallet;
1179     
1180     uint256 public percentForLPBurn = 1; // 25 = .25%
1181     bool public lpBurnEnabled = false;
1182     uint256 public lpBurnFrequency = 1360000000000 seconds;
1183     uint256 public lastLpBurnTime;
1184     
1185     uint256 public manualBurnFrequency = 43210 minutes;
1186     uint256 public lastManualLpBurnTime;
1187 
1188     bool public limitsInEffect = true;
1189     bool public tradingActive = true; // go live after adding LP
1190     bool public swapEnabled = true;
1191     
1192      // Anti-bot and anti-whale mappings and variables
1193     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1194     bool public transferDelayEnabled = true;
1195 
1196     uint256 public buyTotalFees;
1197     uint256 public buyMarketingFee;
1198     uint256 public buyDevFee;
1199     
1200     uint256 public sellTotalFees;
1201     uint256 public sellMarketingFee;
1202     uint256 public sellDevFee;
1203     
1204     uint256 public tokensForMarketing;
1205     uint256 public tokensForDev;
1206 
1207     bool public whitelistEnabled = false;
1208     
1209     /******************/
1210 
1211     // exlcude from fees and max transaction amount
1212     mapping (address => bool) private _isExcludedFromFees;
1213     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1214 
1215     // whitelist
1216     mapping(address => bool) public whitelists;
1217 
1218     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1219     // could be subject to a maximum transfer amount
1220     mapping (address => bool) public automatedMarketMakerPairs;
1221 
1222     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1223 
1224     event ExcludeFromFees(address indexed account, bool isExcluded);
1225 
1226     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1227 
1228     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
1229     
1230     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
1231 
1232     event SwapAndLiquify(
1233         uint256 tokensSwapped,
1234         uint256 ethReceived
1235     );
1236     
1237     event AutoNukeLP();
1238     
1239     event ManualNukeLP();
1240 
1241     uint8 private constant _decimals = 9;
1242 
1243     constructor() ERC20("Axe", "AXE") {
1244         
1245         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1246         
1247         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1248         uniswapV2Router = _uniswapV2Router;
1249         
1250         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1251         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1252         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1253 
1254         
1255         uint256 _buyMarketingFee = 0;
1256         uint256 _buyDevFee = 1;
1257 
1258         uint256 _sellMarketingFee = 0;
1259         uint256 _sellDevFee = 1;
1260         
1261         uint256 totalSupply = 100000000 * 10 ** _decimals;
1262         
1263         //  Maximum tx size and wallet size
1264         maxTransactionAmount = totalSupply * 55 / 10000;
1265         maxWallet = totalSupply * 55 / 10000;
1266 
1267         swapTokensAtAmount = totalSupply * 1 / 10000;
1268 
1269         buyMarketingFee = _buyMarketingFee;
1270         buyDevFee = _buyDevFee;
1271         buyTotalFees = buyMarketingFee + buyDevFee;
1272         
1273         sellMarketingFee = _sellMarketingFee;
1274         sellDevFee = _sellDevFee;
1275         sellTotalFees = sellMarketingFee + sellDevFee;
1276         
1277         marketingWallet = address(owner()); // set as marketing wallet
1278         devWallet = address(owner()); // set as dev wallet
1279 
1280         // exclude from paying fees or having max transaction amount
1281         excludeFromFees(owner(), true);
1282         excludeFromFees(address(this), true);
1283         excludeFromFees(address(0xdead), true);
1284         
1285         excludeFromMaxTransaction(owner(), true);
1286         excludeFromMaxTransaction(address(this), true);
1287         excludeFromMaxTransaction(address(0xdead), true);
1288         
1289         /*
1290             _mint is an internal function in ERC20.sol that is only called here,
1291             and CANNOT be called ever again
1292         */
1293         _mint(msg.sender, totalSupply);
1294     }
1295 
1296     receive() external payable {
1297 
1298     }
1299 
1300     function whitelist(address[] calldata _addresses, bool _isWhitelisting) external onlyOwner {
1301         for (uint i=0; i<_addresses.length; i++) {
1302             whitelists[_addresses[i]] = _isWhitelisting;
1303         }
1304     }
1305 
1306     function updateWhitelistEnabled(bool _isWhitelisting) external onlyOwner {
1307         whitelistEnabled = _isWhitelisting;
1308     }
1309 
1310     function isWhitetlistEnabled() public view returns (bool) {
1311         return whitelistEnabled;
1312     }
1313 
1314     // once enabled, can never be turned off
1315     function enableTrading() external onlyOwner {
1316         tradingActive = true;
1317         swapEnabled = true;
1318         lastLpBurnTime = block.timestamp;
1319     }
1320     
1321     // remove limits after token is stable
1322     function removeLimits() external onlyOwner returns (bool){
1323         limitsInEffect = false;
1324         return true;
1325     }
1326     
1327     // disable Transfer delay - cannot be reenabled
1328     function disableTransferDelay() external onlyOwner returns (bool){
1329         transferDelayEnabled = false;
1330         return true;
1331     }
1332     
1333      // change the minimum amount of tokens to sell from fees
1334     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1335         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1336         require(newAmount <= totalSupply() * 10 / 1000, "Swap amount cannot be higher than 1% total supply.");
1337         swapTokensAtAmount = newAmount;
1338         return true;
1339     }
1340     
1341     function updateMaxLimits(uint256 maxPerTx, uint256 maxPerWallet) external onlyOwner {
1342         require(maxPerTx >= (totalSupply() * 1 / 1000)/10**_decimals, "Cannot set maxTransactionAmount lower than 0.1%");
1343         maxTransactionAmount = maxPerTx * (10**_decimals);
1344 
1345         require(maxPerWallet >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1346         maxWallet = maxPerWallet * (10**_decimals);
1347     }
1348     
1349     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1350         require(newNum >= (totalSupply() * 1 / 1000)/10**_decimals, "Cannot set maxTransactionAmount lower than 0.1%");
1351         maxTransactionAmount = newNum * (10**_decimals);
1352     }
1353 
1354     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1355         require(newNum >= (totalSupply() * 5 / 1000)/10**_decimals, "Cannot set maxWallet lower than 0.5%");
1356         maxWallet = newNum * (10**_decimals);
1357     }
1358     
1359     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1360         _isExcludedMaxTransactionAmount[updAds] = isEx;
1361     }
1362     
1363     // only use to disable contract sales if absolutely necessary (emergency use only)
1364     function updateSwapEnabled(bool enabled) external onlyOwner(){
1365         swapEnabled = enabled;
1366     }
1367     
1368     function updateBuyFees(uint256 _marketingFee, uint256 _devFee) external onlyOwner {
1369         buyMarketingFee = _marketingFee;
1370         buyDevFee = _devFee;
1371         buyTotalFees = buyMarketingFee + buyDevFee;
1372         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1373     }
1374     
1375     function updateSellFees(uint256 _marketingFee, uint256 _devFee) external onlyOwner {
1376         sellMarketingFee = _marketingFee;
1377         sellDevFee = _devFee;
1378         sellTotalFees = sellMarketingFee + sellDevFee;
1379         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1380     }
1381 
1382     function updateTaxes (uint256 buy, uint256 sell) external onlyOwner {
1383         sellDevFee = sell;
1384         buyDevFee = buy;
1385         sellTotalFees = sellMarketingFee  + sellDevFee;
1386         buyTotalFees = buyMarketingFee + buyDevFee;
1387         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1388         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1389     }
1390 
1391     function excludeFromFees(address account, bool excluded) public onlyOwner {
1392         _isExcludedFromFees[account] = excluded;
1393         emit ExcludeFromFees(account, excluded);
1394     }
1395 
1396     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1397         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1398 
1399         _setAutomatedMarketMakerPair(pair, value);
1400     }
1401 
1402     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1403         automatedMarketMakerPairs[pair] = value;
1404 
1405         emit SetAutomatedMarketMakerPair(pair, value);
1406     }
1407 
1408     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1409         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1410         marketingWallet = newMarketingWallet;
1411     }
1412     
1413     function updateDevWallet(address newWallet) external onlyOwner {
1414         emit devWalletUpdated(newWallet, devWallet);
1415         devWallet = newWallet;
1416     }
1417     
1418 
1419     function isExcludedFromFees(address account) public view returns(bool) {
1420         return _isExcludedFromFees[account];
1421     }
1422     
1423     event BoughtEarly(address indexed sniper);
1424 
1425     function _transfer(
1426         address from,
1427         address to,
1428         uint256 amount
1429     ) internal override {
1430         require(from != address(0), "ERC20: transfer from the zero address");
1431         require(to != address(0), "ERC20: transfer to the zero address");
1432 
1433         if (whitelistEnabled)
1434             require(whitelists[to] || whitelists[from], "Rejected");
1435         
1436          if(amount == 0) {
1437             super._transfer(from, to, 0);
1438             return;
1439         }
1440         
1441         if(limitsInEffect){
1442             if (
1443                 from != owner() &&
1444                 to != owner() &&
1445                 to != address(0) &&
1446                 to != address(0xdead) &&
1447                 !swapping
1448             ){
1449                 if(!tradingActive){
1450                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1451                 }
1452 
1453                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1454                 if (transferDelayEnabled){
1455                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1456                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1457                         _holderLastTransferTimestamp[tx.origin] = block.number;
1458                     }
1459                 }
1460                  
1461                 //when buy
1462                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1463                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1464                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1465                 }
1466                 
1467                 //when sell
1468                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1469                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1470                 }
1471                 else if(!_isExcludedMaxTransactionAmount[to]){
1472                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1473                 }
1474             }
1475         }
1476         
1477         
1478         uint256 contractTokenBalance = balanceOf(address(this));
1479         
1480         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1481 
1482         if( 
1483             canSwap &&
1484             swapEnabled &&
1485             !swapping &&
1486             !automatedMarketMakerPairs[from] &&
1487             !_isExcludedFromFees[from] &&
1488             !_isExcludedFromFees[to]
1489         ) {
1490             swapping = true;
1491             
1492             swapBack();
1493 
1494             swapping = false;
1495         }
1496         
1497         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1498             autoBurnLiquidityPairTokens();
1499         }
1500 
1501         bool takeFee = !swapping;
1502 
1503         // if any account belongs to _isExcludedFromFee account then remove the fee
1504         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1505             takeFee = false;
1506         }
1507         
1508         uint256 fees = 0;
1509         // only take fees on buys/sells, do not take on wallet transfers
1510         if(takeFee){
1511             // on sell
1512             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1513                 fees = amount.mul(sellTotalFees).div(100);
1514                 tokensForDev += fees * sellDevFee / sellTotalFees;
1515                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1516             }
1517             // on buy
1518             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1519                 fees = amount.mul(buyTotalFees).div(100);
1520                 tokensForDev += fees * buyDevFee / buyTotalFees;
1521                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1522             }
1523             
1524             if(fees > 0){    
1525                 super._transfer(from, address(this), fees);
1526             }
1527             
1528             amount -= fees;
1529         }
1530 
1531         super._transfer(from, to, amount);
1532     }
1533 
1534     function swapTokensForEth(uint256 tokenAmount) private {
1535 
1536         // generate the uniswap pair path of token -> weth
1537         address[] memory path = new address[](2);
1538         path[0] = address(this);
1539         path[1] = uniswapV2Router.WETH();
1540 
1541         _approve(address(this), address(uniswapV2Router), tokenAmount);
1542 
1543         // make the swap
1544         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1545             tokenAmount,
1546             0, // accept any amount of ETH
1547             path,
1548             address(this),
1549             block.timestamp
1550         );
1551         
1552     }
1553 
1554     
1555     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1556         // approve token transfer to cover all possible scenarios
1557         _approve(address(this), address(uniswapV2Router), tokenAmount);
1558 
1559         // add the liquidity
1560         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1561             address(this),
1562             tokenAmount,
1563             0, // slippage is unavoidable
1564             0, // slippage is unavoidable
1565             deadAddress,
1566             block.timestamp
1567         );
1568     }
1569 
1570     function swapBack() private {
1571         uint256 contractBalance = balanceOf(address(this));
1572         uint256 totalTokensToSwap = tokensForMarketing + tokensForDev;
1573         bool success;
1574         
1575         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1576 
1577         if(contractBalance > swapTokensAtAmount * 20){
1578           contractBalance = swapTokensAtAmount * 20;
1579         }
1580         
1581         // Halve the amount of liquidity tokens
1582         uint256 amountToSwapForETH = contractBalance;
1583         
1584         uint256 initialETHBalance = address(this).balance;
1585 
1586         swapTokensForEth(amountToSwapForETH); 
1587         
1588         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1589         
1590         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1591 
1592         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1593             
1594 
1595         (success, ) = address(devWallet).call{value: ethForDev}("");
1596         if (tokensForMarketing > 0) {
1597             (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1598         }
1599 
1600         tokensForMarketing = 0;
1601         tokensForDev = 0;
1602     }
1603     
1604     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1605         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1606         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1607         lpBurnFrequency = _frequencyInSeconds;
1608         percentForLPBurn = _percent;
1609         lpBurnEnabled = _Enabled;
1610     }
1611     
1612     function autoBurnLiquidityPairTokens() internal returns (bool){
1613         
1614         lastLpBurnTime = block.timestamp;
1615         
1616         // get balance of liquidity pair
1617         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1618         
1619         // calculate amount to burn
1620         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1621         
1622         // pull tokens from pancakePair liquidity and move to dead address permanently
1623         if (amountToBurn > 0){
1624             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1625         }
1626         
1627         //sync price since this is not in a swap transaction!
1628         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1629         pair.sync();
1630         emit AutoNukeLP();
1631         return true;
1632     }
1633 
1634 }