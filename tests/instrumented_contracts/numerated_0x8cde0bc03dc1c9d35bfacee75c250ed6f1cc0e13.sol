1 /*
2  ,-----.                       
3 '  .--./ ,---.  ,---. ,---.  ,---.    
4 |  |    | .-._|| .-. ||_.-. ||_.-. |   
5 '  '--'\' '    \ `-' / . '.'  . '.'     
6  `-----''-'     `---'  `----` `----`    
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
12 pragma experimental ABIEncoderV2;
13 
14 
15 /**
16 
17 
18 Website: https://crosschainbot.com/
19 
20 Twitter: https://twitter.com/crosschainbot
21 
22 Telegram: https://t.me/cross_chain_bot
23 
24 
25 */
26 
27 
28 /* pragma solidity ^0.8.0; */
29 
30 /**
31  * @dev Provides information about the current execution context, including the
32  * sender of the transaction and its data. While these are generally available
33  * via msg.sender and msg.data, they should not be accessed in such a direct
34  * manner, since when dealing with meta-transactions the account sending and
35  * paying for execution may not be the actual sender (as far as an application
36  * is concerned).
37  *
38  * This contract is only required for intermediate, library-like contracts.
39  */
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes calldata) {
46         return msg.data;
47     }
48 }
49 
50 /**
51  * @dev Contract module which provides a basic access control mechanism, where
52  * there is an account (an owner) that can be granted exclusive access to
53  * specific functions.
54  *
55  * By default, the owner account will be the one that deploys the contract. This
56  * can later be changed with {transferOwnership}.
57  *
58  * This module is used through inheritance. It will make available the modifier
59  * `onlyOwner`, which can be applied to your functions to restrict their use to
60  * the owner.
61  */
62 abstract contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     /**
68      * @dev Initializes the contract setting the deployer as the initial owner.
69      */
70     constructor() {
71         _transferOwnership(_msgSender());
72     }
73 
74     /**
75      * @dev Returns the address of the current owner.
76      */
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86         _;
87     }
88 
89     /**
90      * @dev Leaves the contract without owner. It will not be possible to call
91      * `onlyOwner` functions anymore. Can only be called by the current owner.
92      *
93      * NOTE: Renouncing ownership will leave the contract without an owner,
94      * thereby removing any functionality that is only available to the owner.
95      */
96     function renounceOwnership() public virtual onlyOwner {
97         _transferOwnership(address(0));
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Internal function without access restriction.
112      */
113     function _transferOwnership(address newOwner) internal virtual {
114         address oldOwner = _owner;
115         _owner = newOwner;
116         emit OwnershipTransferred(oldOwner, newOwner);
117     }
118 }
119 
120 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
121 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
122 
123 /* pragma solidity ^0.8.0; */
124 
125 /**
126  * @dev Interface of the ERC20 standard as defined in the EIP.
127  */
128 interface IERC20 {
129     /**
130      * @dev Returns the amount of tokens in existence.
131      */
132     function totalSupply() external view returns (uint256);
133 
134     /**
135      * @dev Returns the amount of tokens owned by `account`.
136      */
137     function balanceOf(address account) external view returns (uint256);
138 
139     /**
140      * @dev Moves `amount` tokens from the caller's account to `recipient`.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transfer(address recipient, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Returns the remaining number of tokens that `spender` will be
150      * allowed to spend on behalf of `owner` through {transferFrom}. This is
151      * zero by default.
152      *
153      * This value changes when {approve} or {transferFrom} are called.
154      */
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     /**
158      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * IMPORTANT: Beware that changing an allowance with this method brings the risk
163      * that someone may use both the old and the new allowance by unfortunate
164      * transaction ordering. One possible solution to mitigate this race
165      * condition is to first reduce the spender's allowance to 0 and set the
166      * desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address spender, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Moves `amount` tokens from `sender` to `recipient` using the
175      * allowance mechanism. `amount` is then deducted from the caller's
176      * allowance.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) external returns (bool);
187 
188     /**
189      * @dev Emitted when `value` tokens are moved from one account (`from`) to
190      * another (`to`).
191      *
192      * Note that `value` may be zero.
193      */
194     event Transfer(address indexed from, address indexed to, uint256 value);
195 
196     /**
197      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
198      * a call to {approve}. `value` is the new allowance.
199      */
200     event Approval(address indexed owner, address indexed spender, uint256 value);
201 }
202 
203 /* pragma solidity ^0.8.0; */
204 
205 /**
206  * @dev Interface for the optional metadata functions from the ERC20 standard.
207  *
208  * _Available since v4.1._
209  */
210 interface IERC20Metadata is IERC20 {
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the symbol of the token.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the decimals places of the token.
223      */
224     function decimals() external view returns (uint8);
225 }
226 
227 /* pragma solidity ^0.8.0; */
228 
229 /* import "./IERC20.sol"; */
230 /* import "./extensions/IERC20Metadata.sol"; */
231 /* import "../../utils/Context.sol"; */
232 
233 /**
234  * @dev Implementation of the {IERC20} interface.
235  *
236  * This implementation is agnostic to the way tokens are created. This means
237  * that a supply mechanism has to be added in a derived contract using {_mint}.
238  * For a generic mechanism see {ERC20PresetMinterPauser}.
239  *
240  * TIP: For a detailed writeup see our guide
241  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
242  * to implement supply mechanisms].
243  *
244  * We have followed general OpenZeppelin Contracts guidelines: functions revert
245  * instead returning `false` on failure. This behavior is nonetheless
246  * conventional and does not conflict with the expectations of ERC20
247  * applications.
248  *
249  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
250  * This allows applications to reconstruct the allowance for all accounts just
251  * by listening to said events. Other implementations of the EIP may not emit
252  * these events, as it isn't required by the specification.
253  *
254  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
255  * functions have been added to mitigate the well-known issues around setting
256  * allowances. See {IERC20-approve}.
257  */
258 contract ERC20 is Context, IERC20, IERC20Metadata {
259     mapping(address => uint256) private _balances;
260 
261     mapping(address => mapping(address => uint256)) private _allowances;
262 
263     uint256 private _totalSupply;
264 
265     string private _name;
266     string private _symbol;
267 
268     /**
269      * @dev Sets the values for {name} and {symbol}.
270      *
271      * The default value of {decimals} is 18. To select a different value for
272      * {decimals} you should overload it.
273      *
274      * All two of these values are immutable: they can only be set once during
275      * construction.
276      */
277     constructor(string memory name_, string memory symbol_) {
278         _name = name_;
279         _symbol = symbol_;
280     }
281 
282     /**
283      * @dev Returns the name of the token.
284      */
285     function name() public view virtual override returns (string memory) {
286         return _name;
287     }
288 
289     /**
290      * @dev Returns the symbol of the token, usually a shorter version of the
291      * name.
292      */
293     function symbol() public view virtual override returns (string memory) {
294         return _symbol;
295     }
296 
297     /**
298      * @dev Returns the number of decimals used to get its user representation.
299      * For example, if `decimals` equals `2`, a balance of `505` tokens should
300      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
301      *
302      * Tokens usually opt for a value of 18, imitating the relationship between
303      * Ether and Wei. This is the value {ERC20} uses, unless this function is
304      * overridden;
305      *
306      * NOTE: This information is only used for _display_ purposes: it in
307      * no way affects any of the arithmetic of the contract, including
308      * {IERC20-balanceOf} and {IERC20-transfer}.
309      */
310     function decimals() public view virtual override returns (uint8) {
311         return 18;
312     }
313 
314     /**
315      * @dev See {IERC20-totalSupply}.
316      */
317     function totalSupply() public view virtual override returns (uint256) {
318         return _totalSupply;
319     }
320 
321     /**
322      * @dev See {IERC20-balanceOf}.
323      */
324     function balanceOf(address account) public view virtual override returns (uint256) {
325         return _balances[account];
326     }
327 
328     /**
329      * @dev See {IERC20-transfer}.
330      *
331      * Requirements:
332      *
333      * - `recipient` cannot be the zero address.
334      * - the caller must have a balance of at least `amount`.
335      */
336     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
337         _transfer(_msgSender(), recipient, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-allowance}.
343      */
344     function allowance(address owner, address spender) public view virtual override returns (uint256) {
345         return _allowances[owner][spender];
346     }
347 
348     /**
349      * @dev See {IERC20-approve}.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      */
355     function approve(address spender, uint256 amount) public virtual override returns (bool) {
356         _approve(_msgSender(), spender, amount);
357         return true;
358     }
359 
360     /**
361      * @dev See {IERC20-transferFrom}.
362      *
363      * Emits an {Approval} event indicating the updated allowance. This is not
364      * required by the EIP. See the note at the beginning of {ERC20}.
365      *
366      * Requirements:
367      *
368      * - `sender` and `recipient` cannot be the zero address.
369      * - `sender` must have a balance of at least `amount`.
370      * - the caller must have allowance for ``sender``'s tokens of at least
371      * `amount`.
372      */
373     function transferFrom(
374         address sender,
375         address recipient,
376         uint256 amount
377     ) public virtual override returns (bool) {
378         _transfer(sender, recipient, amount);
379 
380         uint256 currentAllowance = _allowances[sender][_msgSender()];
381         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
382         unchecked {
383             _approve(sender, _msgSender(), currentAllowance - amount);
384         }
385 
386         return true;
387     }
388 
389     /**
390      * @dev Atomically increases the allowance granted to `spender` by the caller.
391      *
392      * This is an alternative to {approve} that can be used as a mitigation for
393      * problems described in {IERC20-approve}.
394      *
395      * Emits an {Approval} event indicating the updated allowance.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
402         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
403         return true;
404     }
405 
406     /**
407      * @dev Atomically decreases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      * - `spender` must have allowance for the caller of at least
418      * `subtractedValue`.
419      */
420     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
421         uint256 currentAllowance = _allowances[_msgSender()][spender];
422         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
423         unchecked {
424             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
425         }
426 
427         return true;
428     }
429 
430     /**
431      * @dev Moves `amount` of tokens from `sender` to `recipient`.
432      *
433      * This internal function is equivalent to {transfer}, and can be used to
434      * e.g. implement automatic token fees, slashing mechanisms, etc.
435      *
436      * Emits a {Transfer} event.
437      *
438      * Requirements:
439      *
440      * - `sender` cannot be the zero address.
441      * - `recipient` cannot be the zero address.
442      * - `sender` must have a balance of at least `amount`.
443      */
444     function _transfer(
445         address sender,
446         address recipient,
447         uint256 amount
448     ) internal virtual {
449         require(sender != address(0), "ERC20: transfer from the zero address");
450         require(recipient != address(0), "ERC20: transfer to the zero address");
451 
452         _beforeTokenTransfer(sender, recipient, amount);
453 
454         uint256 senderBalance = _balances[sender];
455         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
456         unchecked {
457             _balances[sender] = senderBalance - amount;
458         }
459         _balances[recipient] += amount;
460 
461         emit Transfer(sender, recipient, amount);
462 
463         _afterTokenTransfer(sender, recipient, amount);
464     }
465 
466     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
467      * the total supply.
468      *
469      * Emits a {Transfer} event with `from` set to the zero address.
470      *
471      * Requirements:
472      *
473      * - `account` cannot be the zero address.
474      */
475     function _mint(address account, uint256 amount) internal virtual {
476         require(account != address(0), "ERC20: mint to the zero address");
477 
478         _beforeTokenTransfer(address(0), account, amount);
479 
480         _totalSupply += amount;
481         _balances[account] += amount;
482         emit Transfer(address(0), account, amount);
483 
484         _afterTokenTransfer(address(0), account, amount);
485     }
486 
487     /**
488      * @dev Destroys `amount` tokens from `account`, reducing the
489      * total supply.
490      *
491      * Emits a {Transfer} event with `to` set to the zero address.
492      *
493      * Requirements:
494      *
495      * - `account` cannot be the zero address.
496      * - `account` must have at least `amount` tokens.
497      */
498     function _burn(address account, uint256 amount) internal virtual {
499         require(account != address(0), "ERC20: burn from the zero address");
500 
501         _beforeTokenTransfer(account, address(0), amount);
502 
503         uint256 accountBalance = _balances[account];
504         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
505         unchecked {
506             _balances[account] = accountBalance - amount;
507         }
508         _totalSupply -= amount;
509 
510         emit Transfer(account, address(0), amount);
511 
512         _afterTokenTransfer(account, address(0), amount);
513     }
514 
515     /**
516      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
517      *
518      * This internal function is equivalent to `approve`, and can be used to
519      * e.g. set automatic allowances for certain subsystems, etc.
520      *
521      * Emits an {Approval} event.
522      *
523      * Requirements:
524      *
525      * - `owner` cannot be the zero address.
526      * - `spender` cannot be the zero address.
527      */
528     function _approve(
529         address owner,
530         address spender,
531         uint256 amount
532     ) internal virtual {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = amount;
537         emit Approval(owner, spender, amount);
538     }
539 
540     /**
541      * @dev Hook that is called before any transfer of tokens. This includes
542      * minting and burning.
543      *
544      * Calling conditions:
545      *
546      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
547      * will be transferred to `to`.
548      * - when `from` is zero, `amount` tokens will be minted for `to`.
549      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
550      * - `from` and `to` are never both zero.
551      *
552      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
553      */
554     function _beforeTokenTransfer(
555         address from,
556         address to,
557         uint256 amount
558     ) internal virtual {}
559 
560     /**
561      * @dev Hook that is called after any transfer of tokens. This includes
562      * minting and burning.
563      *
564      * Calling conditions:
565      *
566      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
567      * has been transferred to `to`.
568      * - when `from` is zero, `amount` tokens have been minted for `to`.
569      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
570      * - `from` and `to` are never both zero.
571      *
572      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
573      */
574     function _afterTokenTransfer(
575         address from,
576         address to,
577         uint256 amount
578     ) internal virtual {}
579 }
580 
581 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
582 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
583 
584 /* pragma solidity ^0.8.0; */
585 
586 // CAUTION
587 // This version of SafeMath should only be used with Solidity 0.8 or later,
588 // because it relies on the compiler's built in overflow checks.
589 
590 /**
591  * @dev Wrappers over Solidity's arithmetic operations.
592  *
593  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
594  * now has built in overflow checking.
595  */
596 library SafeMath {
597     /**
598      * @dev Returns the addition of two unsigned integers, with an overflow flag.
599      *
600      * _Available since v3.4._
601      */
602     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
603         unchecked {
604             uint256 c = a + b;
605             if (c < a) return (false, 0);
606             return (true, c);
607         }
608     }
609 
610     /**
611      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
612      *
613      * _Available since v3.4._
614      */
615     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
616         unchecked {
617             if (b > a) return (false, 0);
618             return (true, a - b);
619         }
620     }
621 
622     /**
623      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
624      *
625      * _Available since v3.4._
626      */
627     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
628         unchecked {
629             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
630             // benefit is lost if 'b' is also tested.
631             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
632             if (a == 0) return (true, 0);
633             uint256 c = a * b;
634             if (c / a != b) return (false, 0);
635             return (true, c);
636         }
637     }
638 
639     /**
640      * @dev Returns the division of two unsigned integers, with a division by zero flag.
641      *
642      * _Available since v3.4._
643      */
644     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
645         unchecked {
646             if (b == 0) return (false, 0);
647             return (true, a / b);
648         }
649     }
650 
651     /**
652      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
653      *
654      * _Available since v3.4._
655      */
656     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
657         unchecked {
658             if (b == 0) return (false, 0);
659             return (true, a % b);
660         }
661     }
662 
663     /**
664      * @dev Returns the addition of two unsigned integers, reverting on
665      * overflow.
666      *
667      * Counterpart to Solidity's `+` operator.
668      *
669      * Requirements:
670      *
671      * - Addition cannot overflow.
672      */
673     function add(uint256 a, uint256 b) internal pure returns (uint256) {
674         return a + b;
675     }
676 
677     /**
678      * @dev Returns the subtraction of two unsigned integers, reverting on
679      * overflow (when the result is negative).
680      *
681      * Counterpart to Solidity's `-` operator.
682      *
683      * Requirements:
684      *
685      * - Subtraction cannot overflow.
686      */
687     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
688         return a - b;
689     }
690 
691     /**
692      * @dev Returns the multiplication of two unsigned integers, reverting on
693      * overflow.
694      *
695      * Counterpart to Solidity's `*` operator.
696      *
697      * Requirements:
698      *
699      * - Multiplication cannot overflow.
700      */
701     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a * b;
703     }
704 
705     /**
706      * @dev Returns the integer division of two unsigned integers, reverting on
707      * division by zero. The result is rounded towards zero.
708      *
709      * Counterpart to Solidity's `/` operator.
710      *
711      * Requirements:
712      *
713      * - The divisor cannot be zero.
714      */
715     function div(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a / b;
717     }
718 
719     /**
720      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
721      * reverting when dividing by zero.
722      *
723      * Counterpart to Solidity's `%` operator. This function uses a `revert`
724      * opcode (which leaves remaining gas untouched) while Solidity uses an
725      * invalid opcode to revert (consuming all remaining gas).
726      *
727      * Requirements:
728      *
729      * - The divisor cannot be zero.
730      */
731     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
732         return a % b;
733     }
734 
735     /**
736      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
737      * overflow (when the result is negative).
738      *
739      * CAUTION: This function is deprecated because it requires allocating memory for the error
740      * message unnecessarily. For custom revert reasons use {trySub}.
741      *
742      * Counterpart to Solidity's `-` operator.
743      *
744      * Requirements:
745      *
746      * - Subtraction cannot overflow.
747      */
748     function sub(
749         uint256 a,
750         uint256 b,
751         string memory errorMessage
752     ) internal pure returns (uint256) {
753         unchecked {
754             require(b <= a, errorMessage);
755             return a - b;
756         }
757     }
758 
759     /**
760      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
761      * division by zero. The result is rounded towards zero.
762      *
763      * Counterpart to Solidity's `/` operator. Note: this function uses a
764      * `revert` opcode (which leaves remaining gas untouched) while Solidity
765      * uses an invalid opcode to revert (consuming all remaining gas).
766      *
767      * Requirements:
768      *
769      * - The divisor cannot be zero.
770      */
771     function div(
772         uint256 a,
773         uint256 b,
774         string memory errorMessage
775     ) internal pure returns (uint256) {
776         unchecked {
777             require(b > 0, errorMessage);
778             return a / b;
779         }
780     }
781 
782     /**
783      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
784      * reverting with custom message when dividing by zero.
785      *
786      * CAUTION: This function is deprecated because it requires allocating memory for the error
787      * message unnecessarily. For custom revert reasons use {tryMod}.
788      *
789      * Counterpart to Solidity's `%` operator. This function uses a `revert`
790      * opcode (which leaves remaining gas untouched) while Solidity uses an
791      * invalid opcode to revert (consuming all remaining gas).
792      *
793      * Requirements:
794      *
795      * - The divisor cannot be zero.
796      */
797     function mod(
798         uint256 a,
799         uint256 b,
800         string memory errorMessage
801     ) internal pure returns (uint256) {
802         unchecked {
803             require(b > 0, errorMessage);
804             return a % b;
805         }
806     }
807 }
808 
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
842 /* pragma solidity 0.8.10; */
843 /* pragma experimental ABIEncoderV2; */
844 
845 interface IUniswapV2Pair {
846     event Approval(
847         address indexed owner,
848         address indexed spender,
849         uint256 value
850     );
851     event Transfer(address indexed from, address indexed to, uint256 value);
852 
853     function name() external pure returns (string memory);
854 
855     function symbol() external pure returns (string memory);
856 
857     function decimals() external pure returns (uint8);
858 
859     function totalSupply() external view returns (uint256);
860 
861     function balanceOf(address owner) external view returns (uint256);
862 
863     function allowance(address owner, address spender)
864         external
865         view
866         returns (uint256);
867 
868     function approve(address spender, uint256 value) external returns (bool);
869 
870     function transfer(address to, uint256 value) external returns (bool);
871 
872     function transferFrom(
873         address from,
874         address to,
875         uint256 value
876     ) external returns (bool);
877 
878     function DOMAIN_SEPARATOR() external view returns (bytes32);
879 
880     function PERMIT_TYPEHASH() external pure returns (bytes32);
881 
882     function nonces(address owner) external view returns (uint256);
883 
884     function permit(
885         address owner,
886         address spender,
887         uint256 value,
888         uint256 deadline,
889         uint8 v,
890         bytes32 r,
891         bytes32 s
892     ) external;
893 
894     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
895     event Burn(
896         address indexed sender,
897         uint256 amount0,
898         uint256 amount1,
899         address indexed to
900     );
901     event Swap(
902         address indexed sender,
903         uint256 amount0In,
904         uint256 amount1In,
905         uint256 amount0Out,
906         uint256 amount1Out,
907         address indexed to
908     );
909     event Sync(uint112 reserve0, uint112 reserve1);
910 
911     function MINIMUM_LIQUIDITY() external pure returns (uint256);
912 
913     function factory() external view returns (address);
914 
915     function token0() external view returns (address);
916 
917     function token1() external view returns (address);
918 
919     function getReserves()
920         external
921         view
922         returns (
923             uint112 reserve0,
924             uint112 reserve1,
925             uint32 blockTimestampLast
926         );
927 
928     function price0CumulativeLast() external view returns (uint256);
929 
930     function price1CumulativeLast() external view returns (uint256);
931 
932     function kLast() external view returns (uint256);
933 
934     function mint(address to) external returns (uint256 liquidity);
935 
936     function burn(address to)
937         external
938         returns (uint256 amount0, uint256 amount1);
939 
940     function swap(
941         uint256 amount0Out,
942         uint256 amount1Out,
943         address to,
944         bytes calldata data
945     ) external;
946 
947     function skim(address to) external;
948 
949     function sync() external;
950 
951     function initialize(address, address) external;
952 }
953 
954 /* pragma solidity 0.8.10; */
955 /* pragma experimental ABIEncoderV2; */
956 
957 interface IUniswapV2Router02 {
958     function factory() external pure returns (address);
959 
960     function WETH() external pure returns (address);
961 
962 
963     function addLiquidityETH(
964         address token,
965         uint256 amountTokenDesired,
966         uint256 amountTokenMin,
967         uint256 amountETHMin,
968         address to,
969         uint256 deadline
970     )
971         external
972         payable
973         returns (
974             uint256 amountToken,
975             uint256 amountETH,
976             uint256 liquidity
977         );
978 
979     function swapExactTokensForETHSupportingFeeOnTransferTokens(
980         uint256 amountIn,
981         uint256 amountOutMin,
982         address[] calldata path,
983         address to,
984         uint256 deadline
985     ) external;
986 }
987 
988 /* pragma solidity >=0.8.10; */
989 
990 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
991 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
992 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
993 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
994 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
995 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
996 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
997 
998 contract Cross is ERC20, Ownable {
999     using SafeMath for uint256;
1000 
1001     IUniswapV2Router02 public immutable uniswapV2Router;
1002     address public immutable uniswapV2Pair;
1003     address public constant deadAddress = address(0xdead);
1004 
1005     bool private swapping;
1006 
1007     address public marketingWallet;
1008     address public devWallet;
1009 
1010     uint256 public maxTransactionAmount;
1011     uint256 public swapTokensAtAmount;
1012     uint256 public maxWallet;
1013 
1014     bool public limitsInEffect = true;
1015     bool public tradingActive = true;
1016     bool public swapEnabled = true;
1017 
1018     // Anti-bot and anti-whale mappings and variables
1019     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1020     bool public transferDelayEnabled = true;
1021 
1022     uint256 public buyTotalFees;
1023     uint256 public buyMarketingFee;
1024     uint256 public buyLiquidityFee;
1025     uint256 public buyDevFee;
1026 
1027     uint256 public sellTotalFees;
1028     uint256 public sellMarketingFee;
1029     uint256 public sellLiquidityFee;
1030     uint256 public sellDevFee;
1031 
1032     uint256 public tokensForMarketing;
1033     uint256 public tokensForLiquidity;
1034     uint256 public tokensForDev;
1035 
1036     /******************/
1037 
1038     // exlcude from fees and max transaction amount
1039     mapping(address => bool) private _isExcludedFromFees;
1040     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1041 
1042     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1043     // could be subject to a maximum transfer amount
1044     mapping(address => bool) public automatedMarketMakerPairs;
1045 
1046     event UpdateUniswapV2Router(
1047         address indexed newAddress,
1048         address indexed oldAddress
1049     );
1050 
1051     event ExcludeFromFees(address indexed account, bool isExcluded);
1052 
1053     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1054 
1055     event SwapAndLiquify(
1056         uint256 tokensSwapped,
1057         uint256 ethReceived,
1058         uint256 tokensIntoLiquidity
1059     );
1060 
1061     constructor() ERC20("Cross", "CROSS") {
1062         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1063         //     0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1064         // );
1065 
1066         address router;
1067         if (block.chainid == 56) {
1068             router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // BSC Pancake Mainnet Router
1069         } else if (block.chainid == 97) {
1070             router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1; // BSC Pancake Testnet Router
1071         } else if (block.chainid == 1 || block.chainid == 5) {
1072             router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // ETH Uniswap Mainnet % Testnet
1073         } else if (block.chainid == 11155111){
1074             router = 0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008; // ETH Uniswap Mainnet % Testnet
1075         } 
1076         else {
1077             revert();
1078         }
1079 
1080         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
1081 
1082 
1083         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1084         uniswapV2Router = _uniswapV2Router;
1085 
1086         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1087             .createPair(address(this), _uniswapV2Router.WETH());
1088         // uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
1089         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1090         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1091 
1092         uint256 _buyMarketingFee = 3;
1093         uint256 _buyLiquidityFee = 0;
1094         uint256 _buyDevFee = 0;
1095 
1096         uint256 _sellMarketingFee = 3;
1097         uint256 _sellLiquidityFee = 0;
1098         uint256 _sellDevFee = 0;
1099 
1100         uint256 totalSupply = 10000000 * 1e18;
1101 
1102         maxTransactionAmount = 200000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1103         maxWallet = 350000 * 1e18; // 3.5% from total supply maxWallet
1104         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1105 
1106         buyMarketingFee = _buyMarketingFee;
1107         buyLiquidityFee = _buyLiquidityFee;
1108         buyDevFee = _buyDevFee;
1109         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1110 
1111         sellMarketingFee = _sellMarketingFee;
1112         sellLiquidityFee = _sellLiquidityFee;
1113         sellDevFee = _sellDevFee;
1114         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1115 
1116         marketingWallet = address(0xe06F54f7eD490d90725F7c64c140dD43Ce397681); // 
1117         devWallet = address(0xbC5E7e62CeDd93C77f14595cc0d765AFf3E2D199); // 
1118 
1119         // exclude from paying fees or having max transaction amount
1120         excludeFromFees(owner(), true);
1121         excludeFromFees(address(this), true);
1122         excludeFromFees(address(0xdead), true);
1123 
1124         excludeFromMaxTransaction(owner(), true);
1125         excludeFromMaxTransaction(address(this), true);
1126         excludeFromMaxTransaction(address(0xdead), true);
1127 
1128         /*
1129             _mint is an internal function in ERC20.sol that is only called here,
1130             and CANNOT be called ever again
1131         */
1132         _mint(msg.sender, totalSupply);
1133     }
1134 
1135     receive() external payable {}
1136 
1137     
1138 	
1139     function excludeFromMaxTransaction(address updAds, bool isEx)
1140         public
1141         onlyOwner
1142     {
1143         _isExcludedMaxTransactionAmount[updAds] = isEx;
1144     }
1145 
1146 
1147     function excludeFromFees(address account, bool excluded) public onlyOwner {
1148         _isExcludedFromFees[account] = excluded;
1149         emit ExcludeFromFees(account, excluded);
1150     }
1151 
1152     function setAutomatedMarketMakerPair(address pair, bool value)
1153         public
1154         onlyOwner
1155     {
1156         require(
1157             pair != uniswapV2Pair,
1158             "The pair cannot be removed from automatedMarketMakerPairs"
1159         );
1160 
1161         _setAutomatedMarketMakerPair(pair, value);
1162     }
1163 
1164     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1165         automatedMarketMakerPairs[pair] = value;
1166 
1167         emit SetAutomatedMarketMakerPair(pair, value);
1168     }
1169 
1170     function isExcludedFromFees(address account) public view returns (bool) {
1171         return _isExcludedFromFees[account];
1172     }
1173 
1174     function _transfer(
1175         address from,
1176         address to,
1177         uint256 amount
1178     ) internal override {
1179         require(from != address(0), "ERC20: transfer from the zero address");
1180         require(to != address(0), "ERC20: transfer to the zero address");
1181 
1182         if (amount == 0) {
1183             super._transfer(from, to, 0);
1184             return;
1185         }
1186 
1187         if (limitsInEffect) {
1188             if (
1189                 from != owner() &&
1190                 to != owner() &&
1191                 to != address(0) &&
1192                 to != address(0xdead) &&
1193                 !swapping
1194             ) {
1195                 if (!tradingActive) {
1196                     require(
1197                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1198                         "Trading is not active."
1199                     );
1200                 }
1201 
1202                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1203                 if (transferDelayEnabled) {
1204                     if (
1205                         to != owner() &&
1206                         to != address(uniswapV2Router) &&
1207                         to != address(uniswapV2Pair)
1208                     ) {
1209                         require(
1210                             _holderLastTransferTimestamp[tx.origin] <
1211                                 block.number,
1212                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1213                         );
1214                         _holderLastTransferTimestamp[tx.origin] = block.number;
1215                     }
1216                 }
1217 
1218                 //when buy
1219                 if (
1220                     automatedMarketMakerPairs[from] &&
1221                     !_isExcludedMaxTransactionAmount[to]
1222                 ) {
1223                     require(
1224                         amount <= maxTransactionAmount,
1225                         "Buy transfer amount exceeds the maxTransactionAmount."
1226                     );
1227                     require(
1228                         amount + balanceOf(to) <= maxWallet,
1229                         "Max wallet exceeded"
1230                     );
1231                 }
1232                 //when sell
1233                 else if (
1234                     automatedMarketMakerPairs[to] &&
1235                     !_isExcludedMaxTransactionAmount[from]
1236                 ) {
1237                     require(
1238                         amount <= maxTransactionAmount,
1239                         "Sell transfer amount exceeds the maxTransactionAmount."
1240                     );
1241                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1242                     require(
1243                         amount + balanceOf(to) <= maxWallet,
1244                         "Max wallet exceeded"
1245                     );
1246                 }
1247             }
1248         }
1249 
1250         uint256 contractTokenBalance = balanceOf(address(this));
1251 
1252         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1253 
1254         if (
1255             canSwap &&
1256             swapEnabled &&
1257             !swapping &&
1258             !automatedMarketMakerPairs[from] &&
1259             !_isExcludedFromFees[from] &&
1260             !_isExcludedFromFees[to]
1261         ) {
1262             swapping = true;
1263 
1264             swapBack();
1265 
1266             swapping = false;
1267         }
1268 
1269         bool takeFee = !swapping;
1270 
1271         // if any account belongs to _isExcludedFromFee account then remove the fee
1272         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1273             takeFee = false;
1274         }
1275 
1276         uint256 fees = 0;
1277         // only take fees on buys/sells, do not take on wallet transfers
1278         if (takeFee) {
1279             // on sell
1280             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1281             // if (sellTotalFees > 0) {
1282                 fees = amount.mul(sellTotalFees).div(100);
1283                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1284                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1285                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1286             }
1287             // on buy
1288             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1289                 fees = amount.mul(buyTotalFees).div(100);
1290                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1291                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1292                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1293             }
1294             // super._transfer(from, to, fees);
1295             if (fees > 0) {
1296                 super._transfer(from, address(this), fees);
1297             }
1298 
1299             amount -= fees;
1300         }
1301 
1302         super._transfer(from, to, amount);
1303     }
1304 
1305     function swapTokensForEth(uint256 tokenAmount) private {
1306         // generate the uniswap pair path of token -> weth
1307         address[] memory path = new address[](2);
1308         path[0] = address(this);
1309         path[1] = uniswapV2Router.WETH();
1310 
1311         _approve(address(this), address(uniswapV2Router), tokenAmount);
1312 
1313         // make the swap
1314         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1315             tokenAmount,
1316             0, // accept any amount of ETH
1317             path,
1318             address(this),
1319             block.timestamp
1320         );
1321     }
1322 
1323     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1324         // approve token transfer to cover all possible scenarios
1325         _approve(address(this), address(uniswapV2Router), tokenAmount);
1326 
1327         // add the liquidity
1328         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1329             address(this),
1330             tokenAmount,
1331             0, // slippage is unavoidable
1332             0, // slippage is unavoidable
1333             devWallet,
1334             block.timestamp
1335         );
1336     }
1337 
1338     function swapBack() private {
1339         uint256 contractBalance = balanceOf(address(this));
1340         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1341         bool success;
1342 
1343         if (contractBalance == 0 || totalTokensToSwap == 0) {
1344             return;
1345         }
1346 
1347         if (contractBalance > swapTokensAtAmount * 20) {
1348             contractBalance = swapTokensAtAmount * 20;
1349         }
1350 
1351         // Halve the amount of liquidity tokens
1352         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1353         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1354 
1355         uint256 initialETHBalance = address(this).balance;
1356 
1357         swapTokensForEth(amountToSwapForETH);
1358 
1359         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1360 
1361         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1362         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1363 
1364         // uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1365 
1366         tokensForLiquidity = 0;
1367         tokensForMarketing = 0;
1368         tokensForDev = 0;
1369 
1370         (success, ) = address(devWallet).call{value: ethForDev}("");
1371         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1372 
1373     }
1374 
1375 }