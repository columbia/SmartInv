1 // Sources flattened with hardhat v2.5.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.2.0
89 
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
117 
118 
119 pragma solidity ^0.8.0;
120 
121 /*
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 
142 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.2.0
143 
144 
145 pragma solidity ^0.8.0;
146 
147 
148 
149 /**
150  * @dev Implementation of the {IERC20} interface.
151  *
152  * This implementation is agnostic to the way tokens are created. This means
153  * that a supply mechanism has to be added in a derived contract using {_mint}.
154  * For a generic mechanism see {ERC20PresetMinterPauser}.
155  *
156  * TIP: For a detailed writeup see our guide
157  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
158  * to implement supply mechanisms].
159  *
160  * We have followed general OpenZeppelin guidelines: functions revert instead
161  * of returning `false` on failure. This behavior is nonetheless conventional
162  * and does not conflict with the expectations of ERC20 applications.
163  *
164  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
165  * This allows applications to reconstruct the allowance for all accounts just
166  * by listening to said events. Other implementations of the EIP may not emit
167  * these events, as it isn't required by the specification.
168  *
169  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
170  * functions have been added to mitigate the well-known issues around setting
171  * allowances. See {IERC20-approve}.
172  */
173 contract ERC20 is Context, IERC20, IERC20Metadata {
174     mapping(address => uint256) private _balances;
175 
176     mapping(address => mapping(address => uint256)) private _allowances;
177 
178     uint256 private _totalSupply;
179 
180     string private _name;
181     string private _symbol;
182 
183     /**
184      * @dev Sets the values for {name} and {symbol}.
185      *
186      * The default value of {decimals} is 18. To select a different value for
187      * {decimals} you should overload it.
188      *
189      * All two of these values are immutable: they can only be set once during
190      * construction.
191      */
192     constructor(string memory name_, string memory symbol_) {
193         _name = name_;
194         _symbol = symbol_;
195     }
196 
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() public view virtual override returns (string memory) {
201         return _name;
202     }
203 
204     /**
205      * @dev Returns the symbol of the token, usually a shorter version of the
206      * name.
207      */
208     function symbol() public view virtual override returns (string memory) {
209         return _symbol;
210     }
211 
212     /**
213      * @dev Returns the number of decimals used to get its user representation.
214      * For example, if `decimals` equals `2`, a balance of `505` tokens should
215      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
216      *
217      * Tokens usually opt for a value of 18, imitating the relationship between
218      * Ether and Wei. This is the value {ERC20} uses, unless this function is
219      * overridden;
220      *
221      * NOTE: This information is only used for _display_ purposes: it in
222      * no way affects any of the arithmetic of the contract, including
223      * {IERC20-balanceOf} and {IERC20-transfer}.
224      */
225     function decimals() public view virtual override returns (uint8) {
226         return 18;
227     }
228 
229     /**
230      * @dev See {IERC20-totalSupply}.
231      */
232     function totalSupply() public view virtual override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See {IERC20-balanceOf}.
238      */
239     function balanceOf(address account) public view virtual override returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev See {IERC20-transfer}.
245      *
246      * Requirements:
247      *
248      * - `recipient` cannot be the zero address.
249      * - the caller must have a balance of at least `amount`.
250      */
251     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-allowance}.
258      */
259     function allowance(address owner, address spender) public view virtual override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     /**
264      * @dev See {IERC20-approve}.
265      *
266      * Requirements:
267      *
268      * - `spender` cannot be the zero address.
269      */
270     function approve(address spender, uint256 amount) public virtual override returns (bool) {
271         _approve(_msgSender(), spender, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-transferFrom}.
277      *
278      * Emits an {Approval} event indicating the updated allowance. This is not
279      * required by the EIP. See the note at the beginning of {ERC20}.
280      *
281      * Requirements:
282      *
283      * - `sender` and `recipient` cannot be the zero address.
284      * - `sender` must have a balance of at least `amount`.
285      * - the caller must have allowance for ``sender``'s tokens of at least
286      * `amount`.
287      */
288     function transferFrom(
289         address sender,
290         address recipient,
291         uint256 amount
292     ) public virtual override returns (bool) {
293         _transfer(sender, recipient, amount);
294 
295         uint256 currentAllowance = _allowances[sender][_msgSender()];
296         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
297         unchecked {
298             _approve(sender, _msgSender(), currentAllowance - amount);
299         }
300 
301         return true;
302     }
303 
304     /**
305      * @dev Atomically increases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
317         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
318         return true;
319     }
320 
321     /**
322      * @dev Atomically decreases the allowance granted to `spender` by the caller.
323      *
324      * This is an alternative to {approve} that can be used as a mitigation for
325      * problems described in {IERC20-approve}.
326      *
327      * Emits an {Approval} event indicating the updated allowance.
328      *
329      * Requirements:
330      *
331      * - `spender` cannot be the zero address.
332      * - `spender` must have allowance for the caller of at least
333      * `subtractedValue`.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
336         uint256 currentAllowance = _allowances[_msgSender()][spender];
337         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
338         unchecked {
339             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
340         }
341 
342         return true;
343     }
344 
345     /**
346      * @dev Moves `amount` of tokens from `sender` to `recipient`.
347      *
348      * This internal function is equivalent to {transfer}, and can be used to
349      * e.g. implement automatic token fees, slashing mechanisms, etc.
350      *
351      * Emits a {Transfer} event.
352      *
353      * Requirements:
354      *
355      * - `sender` cannot be the zero address.
356      * - `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      */
359     function _transfer(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) internal virtual {
364         require(sender != address(0), "ERC20: transfer from the zero address");
365         require(recipient != address(0), "ERC20: transfer to the zero address");
366 
367         _beforeTokenTransfer(sender, recipient, amount);
368 
369         uint256 senderBalance = _balances[sender];
370         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
371         unchecked {
372             _balances[sender] = senderBalance - amount;
373         }
374         _balances[recipient] += amount;
375 
376         emit Transfer(sender, recipient, amount);
377 
378         _afterTokenTransfer(sender, recipient, amount);
379     }
380 
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements:
387      *
388      * - `account` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: mint to the zero address");
392 
393         _beforeTokenTransfer(address(0), account, amount);
394 
395         _totalSupply += amount;
396         _balances[account] += amount;
397         emit Transfer(address(0), account, amount);
398 
399         _afterTokenTransfer(address(0), account, amount);
400     }
401 
402     /**
403      * @dev Destroys `amount` tokens from `account`, reducing the
404      * total supply.
405      *
406      * Emits a {Transfer} event with `to` set to the zero address.
407      *
408      * Requirements:
409      *
410      * - `account` cannot be the zero address.
411      * - `account` must have at least `amount` tokens.
412      */
413     function _burn(address account, uint256 amount) internal virtual {
414         require(account != address(0), "ERC20: burn from the zero address");
415 
416         _beforeTokenTransfer(account, address(0), amount);
417 
418         uint256 accountBalance = _balances[account];
419         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
420         unchecked {
421             _balances[account] = accountBalance - amount;
422         }
423         _totalSupply -= amount;
424 
425         emit Transfer(account, address(0), amount);
426 
427         _afterTokenTransfer(account, address(0), amount);
428     }
429 
430     /**
431      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
432      *
433      * This internal function is equivalent to `approve`, and can be used to
434      * e.g. set automatic allowances for certain subsystems, etc.
435      *
436      * Emits an {Approval} event.
437      *
438      * Requirements:
439      *
440      * - `owner` cannot be the zero address.
441      * - `spender` cannot be the zero address.
442      */
443     function _approve(
444         address owner,
445         address spender,
446         uint256 amount
447     ) internal virtual {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454 
455     /**
456      * @dev Hook that is called before any transfer of tokens. This includes
457      * minting and burning.
458      *
459      * Calling conditions:
460      *
461      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
462      * will be transferred to `to`.
463      * - when `from` is zero, `amount` tokens will be minted for `to`.
464      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
465      * - `from` and `to` are never both zero.
466      *
467      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
468      */
469     function _beforeTokenTransfer(
470         address from,
471         address to,
472         uint256 amount
473     ) internal virtual {}
474 
475     /**
476      * @dev Hook that is called after any transfer of tokens. This includes
477      * minting and burning.
478      *
479      * Calling conditions:
480      *
481      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
482      * has been transferred to `to`.
483      * - when `from` is zero, `amount` tokens have been minted for `to`.
484      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
485      * - `from` and `to` are never both zero.
486      *
487      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
488      */
489     function _afterTokenTransfer(
490         address from,
491         address to,
492         uint256 amount
493     ) internal virtual {}
494 }
495 
496 
497 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
498 
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Contract module which provides a basic access control mechanism, where
504  * there is an account (an owner) that can be granted exclusive access to
505  * specific functions.
506  *
507  * By default, the owner account will be the one that deploys the contract. This
508  * can later be changed with {transferOwnership}.
509  *
510  * This module is used through inheritance. It will make available the modifier
511  * `onlyOwner`, which can be applied to your functions to restrict their use to
512  * the owner.
513  */
514 abstract contract Ownable is Context {
515     address private _owner;
516 
517     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
518 
519     /**
520      * @dev Initializes the contract setting the deployer as the initial owner.
521      */
522     constructor() {
523         _setOwner(_msgSender());
524     }
525 
526     /**
527      * @dev Returns the address of the current owner.
528      */
529     function owner() public view virtual returns (address) {
530         return _owner;
531     }
532 
533     /**
534      * @dev Throws if called by any account other than the owner.
535      */
536     modifier onlyOwner() {
537         require(owner() == _msgSender(), "Ownable: caller is not the owner");
538         _;
539     }
540 
541     /**
542      * @dev Leaves the contract without owner. It will not be possible to call
543      * `onlyOwner` functions anymore. Can only be called by the current owner.
544      *
545      * NOTE: Renouncing ownership will leave the contract without an owner,
546      * thereby removing any functionality that is only available to the owner.
547      */
548     function renounceOwnership() public virtual onlyOwner {
549         _setOwner(address(0));
550     }
551 
552     /**
553      * @dev Transfers ownership of the contract to a new account (`newOwner`).
554      * Can only be called by the current owner.
555      */
556     function transferOwnership(address newOwner) public virtual onlyOwner {
557         require(newOwner != address(0), "Ownable: new owner is the zero address");
558         _setOwner(newOwner);
559     }
560 
561     function _setOwner(address newOwner) private {
562         address oldOwner = _owner;
563         _owner = newOwner;
564         emit OwnershipTransferred(oldOwner, newOwner);
565     }
566 }
567 
568 
569 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
570 
571 
572 pragma solidity ^0.8.0;
573 
574 // CAUTION
575 // This version of SafeMath should only be used with Solidity 0.8 or later,
576 // because it relies on the compiler's built in overflow checks.
577 
578 /**
579  * @dev Wrappers over Solidity's arithmetic operations.
580  *
581  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
582  * now has built in overflow checking.
583  */
584 library SafeMath {
585     /**
586      * @dev Returns the addition of two unsigned integers, with an overflow flag.
587      *
588      * _Available since v3.4._
589      */
590     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
591         unchecked {
592             uint256 c = a + b;
593             if (c < a) return (false, 0);
594             return (true, c);
595         }
596     }
597 
598     /**
599      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
600      *
601      * _Available since v3.4._
602      */
603     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
604         unchecked {
605             if (b > a) return (false, 0);
606             return (true, a - b);
607         }
608     }
609 
610     /**
611      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
612      *
613      * _Available since v3.4._
614      */
615     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
616         unchecked {
617             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
618             // benefit is lost if 'b' is also tested.
619             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
620             if (a == 0) return (true, 0);
621             uint256 c = a * b;
622             if (c / a != b) return (false, 0);
623             return (true, c);
624         }
625     }
626 
627     /**
628      * @dev Returns the division of two unsigned integers, with a division by zero flag.
629      *
630      * _Available since v3.4._
631      */
632     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
633         unchecked {
634             if (b == 0) return (false, 0);
635             return (true, a / b);
636         }
637     }
638 
639     /**
640      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
641      *
642      * _Available since v3.4._
643      */
644     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
645         unchecked {
646             if (b == 0) return (false, 0);
647             return (true, a % b);
648         }
649     }
650 
651     /**
652      * @dev Returns the addition of two unsigned integers, reverting on
653      * overflow.
654      *
655      * Counterpart to Solidity's `+` operator.
656      *
657      * Requirements:
658      *
659      * - Addition cannot overflow.
660      */
661     function add(uint256 a, uint256 b) internal pure returns (uint256) {
662         return a + b;
663     }
664 
665     /**
666      * @dev Returns the subtraction of two unsigned integers, reverting on
667      * overflow (when the result is negative).
668      *
669      * Counterpart to Solidity's `-` operator.
670      *
671      * Requirements:
672      *
673      * - Subtraction cannot overflow.
674      */
675     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
676         return a - b;
677     }
678 
679     /**
680      * @dev Returns the multiplication of two unsigned integers, reverting on
681      * overflow.
682      *
683      * Counterpart to Solidity's `*` operator.
684      *
685      * Requirements:
686      *
687      * - Multiplication cannot overflow.
688      */
689     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
690         return a * b;
691     }
692 
693     /**
694      * @dev Returns the integer division of two unsigned integers, reverting on
695      * division by zero. The result is rounded towards zero.
696      *
697      * Counterpart to Solidity's `/` operator.
698      *
699      * Requirements:
700      *
701      * - The divisor cannot be zero.
702      */
703     function div(uint256 a, uint256 b) internal pure returns (uint256) {
704         return a / b;
705     }
706 
707     /**
708      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
709      * reverting when dividing by zero.
710      *
711      * Counterpart to Solidity's `%` operator. This function uses a `revert`
712      * opcode (which leaves remaining gas untouched) while Solidity uses an
713      * invalid opcode to revert (consuming all remaining gas).
714      *
715      * Requirements:
716      *
717      * - The divisor cannot be zero.
718      */
719     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
720         return a % b;
721     }
722 
723     /**
724      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
725      * overflow (when the result is negative).
726      *
727      * CAUTION: This function is deprecated because it requires allocating memory for the error
728      * message unnecessarily. For custom revert reasons use {trySub}.
729      *
730      * Counterpart to Solidity's `-` operator.
731      *
732      * Requirements:
733      *
734      * - Subtraction cannot overflow.
735      */
736     function sub(
737         uint256 a,
738         uint256 b,
739         string memory errorMessage
740     ) internal pure returns (uint256) {
741         unchecked {
742             require(b <= a, errorMessage);
743             return a - b;
744         }
745     }
746 
747     /**
748      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
749      * division by zero. The result is rounded towards zero.
750      *
751      * Counterpart to Solidity's `/` operator. Note: this function uses a
752      * `revert` opcode (which leaves remaining gas untouched) while Solidity
753      * uses an invalid opcode to revert (consuming all remaining gas).
754      *
755      * Requirements:
756      *
757      * - The divisor cannot be zero.
758      */
759     function div(
760         uint256 a,
761         uint256 b,
762         string memory errorMessage
763     ) internal pure returns (uint256) {
764         unchecked {
765             require(b > 0, errorMessage);
766             return a / b;
767         }
768     }
769 
770     /**
771      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
772      * reverting with custom message when dividing by zero.
773      *
774      * CAUTION: This function is deprecated because it requires allocating memory for the error
775      * message unnecessarily. For custom revert reasons use {tryMod}.
776      *
777      * Counterpart to Solidity's `%` operator. This function uses a `revert`
778      * opcode (which leaves remaining gas untouched) while Solidity uses an
779      * invalid opcode to revert (consuming all remaining gas).
780      *
781      * Requirements:
782      *
783      * - The divisor cannot be zero.
784      */
785     function mod(
786         uint256 a,
787         uint256 b,
788         string memory errorMessage
789     ) internal pure returns (uint256) {
790         unchecked {
791             require(b > 0, errorMessage);
792             return a % b;
793         }
794     }
795 }
796 
797 
798 // File contracts/StripToken.sol
799 
800 
801 /******************************************************************************
802            ██                                                                
803    ▒▓▓▒    ██     ▒▒                                                         
804   ██████   ██ ▒▓█▓   ████  ██████ █████   █  ████     ███   ████   █  █    ██  
805   ██████▒  ▓███▒    █▒▒▒█▒  ▒██▒▒ ██▒▒▒█  █▒ █▒▒██   █▒ ▒█  █▒▒██  █▒ ██▒  ██▒ 
806    ▓██▓▒▒▓███▒      ██       ██▒  ██▒  █     █▒  █  ██▒    ██▒  █▒    ███▒ ██▒ 
807       ▒██████       ▒████▒   ██▒  █████▒  █▒ ████▒  ██▒    ██▒  █▒ █▒ ██▒█▒██▒ 
808     ▓█████ ▓█         ▒▒██▒  ██▒  ██▒▒██  █▒ ██▒    ██▒    ██▒  █▒ █▒ ██▒▒███▒ 
809    ███████ ██      ▒█   ██▒  ██▒  ██▒  █▒ █▒ ██▒    ▒██  █ ██▒ ██▒ █▒ ██▒ ▒██▒ 
810    ████████▓▓       █████▒   ██▒  ██▒  ██▒█▒ ██▒     ▒███▒  ████▒  █▒ ██▒  ▒█▒ 
811     ▒███████████▓▒▒                                                          
812        ▒▓█████████████▒    ===================================================
813            ▓▓███████████▓       
814            ██  ▒█████████▒      
815            ██    ████████       Token..: STRIPCOIN
816            ██  ▒███████▒        Version: 1.0
817            ██▒██████▒           License: MIT
818            ██████▒              
819          ▒████▒                 
820        ▓█████                   
821     ▒▓█▓▒  ▓█                   
822   ▒█▓▒     ██                   
823 ▒▓▒        ██      
824 *******************************************************************************/             
825 
826 pragma solidity ^0.8.0;
827 
828 
829 
830 
831 /**
832  * @title StripToken Contract
833  * @author 
834  * @dev
835  */
836 
837 contract StripToken is ERC20, Ownable {
838     using SafeMath for uint256;
839 
840     // modify token name
841     string public constant NAME = 'StripCoin';
842     // modify token symbol
843     string public constant SYMBOL = 'STRIP';
844     // modify token decimals
845     uint8 public constant DECIMALS = 18;
846     // modify initial token supply
847     uint256 public constant TOTAL_SUPPLY = 500e9 * (10**uint256(DECIMALS)); // 500,000,000,000 tokens
848     // multisig contract address
849     address public multiSigAdmin;
850 
851     event MultiSigAdminUpdated(address _multiSigAdmin);
852 
853     /**
854      * @dev Constructor that gives msg.sender all of existing tokens.
855      */
856     constructor() Ownable() ERC20(NAME, SYMBOL) {
857         _mint(msg.sender, TOTAL_SUPPLY);
858     }
859 
860     /**
861      * @dev Override decimals() function to customize decimals
862      */
863     function decimals() public view virtual override returns (uint8) {
864         return DECIMALS;
865     }
866 
867     function setMultiSigAdminAddress(address _multiSigAdmin) external onlyOwner {
868         require (_multiSigAdmin != address(0x00), "Invalid MultiSig admin address");
869         multiSigAdmin = _multiSigAdmin;
870         emit MultiSigAdminUpdated(multiSigAdmin);
871     }
872     
873     /**
874      * @dev Recovers the ERC20 token balance mistakenly sent to the contract. Only multisig contract can call this function
875      * @param tokenAddress The token contract address
876      * @param tokenAmount Number of tokens to be sent
877      */
878     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyMultiSigAdmin {
879         IERC20(tokenAddress).transfer(owner(), tokenAmount);
880     }
881 
882     // modifier for multiSig only
883     modifier onlyMultiSigAdmin() {
884         require(msg.sender == multiSigAdmin, "Should be multiSig contract");
885         _;
886     }
887 }