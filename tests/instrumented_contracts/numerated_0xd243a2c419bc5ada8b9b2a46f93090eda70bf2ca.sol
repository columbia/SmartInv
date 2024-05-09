1 /*
2 
3 Website: https://www.kenny-coin.com/
4 TG:      https://t.me/KennyCoinOfficial
5 Twitter: https://twitter.com/kennycoin/
6 
7 */
8 
9 /* 
10 * SPDX-License-Identifier: MIT
11 * */
12 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
13 pragma experimental ABIEncoderV2;
14 
15 /* pragma solidity ^0.8.0; */
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 /* pragma solidity ^0.8.0; */
27 
28 abstract contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     /**
34      * @dev Initializes the contract setting the deployer as the initial owner.
35      */
36     constructor() {
37         _transferOwnership(_msgSender());
38     }
39 
40     /**
41      * @dev Returns the address of the current owner.
42      */
43     function owner() public view virtual returns (address) {
44         return _owner;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(owner() == _msgSender(), "Ownable: caller is not the owner");
52         _;
53     }
54 
55     /**
56      * @dev Leaves the contract without owner. It will not be possible to call
57      * `onlyOwner` functions anymore. Can only be called by the current owner.
58      *
59      * NOTE: Renouncing ownership will leave the contract without an owner,
60      * thereby removing any functionality that is only available to the owner.
61      */
62     function renounceOwnership() public virtual onlyOwner {
63         _transferOwnership(address(0));
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Can only be called by the current owner.
69      */
70     function transferOwnership(address newOwner) public virtual onlyOwner {
71         require(newOwner != address(0), "Ownable: new owner is the zero address");
72         _transferOwnership(newOwner);
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Internal function without access restriction.
78      */
79     function _transferOwnership(address newOwner) internal virtual {
80         address oldOwner = _owner;
81         _owner = newOwner;
82         emit OwnershipTransferred(oldOwner, newOwner);
83     }
84 }
85 
86 /* pragma solidity ^0.8.0; */
87 
88 /**
89  * @dev Interface of the ERC20 standard as defined in the EIP.
90  */
91 interface IERC20 {
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101 
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `recipient`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transfer(address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through {transferFrom}. This is
114      * zero by default.
115      *
116      * This value changes when {approve} or {transferFrom} are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119 
120     /**
121      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * IMPORTANT: Beware that changing an allowance with this method brings the risk
126      * that someone may use both the old and the new allowance by unfortunate
127      * transaction ordering. One possible solution to mitigate this race
128      * condition is to first reduce the spender's allowance to 0 and set the
129      * desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address spender, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Moves `amount` tokens from `sender` to `recipient` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(
146         address sender,
147         address recipient,
148         uint256 amount
149     ) external returns (bool);
150 
151     /**
152      * @dev Emitted when `value` tokens are moved from one account (`from`) to
153      * another (`to`).
154      *
155      * Note that `value` may be zero.
156      */
157     event Transfer(address indexed from, address indexed to, uint256 value);
158 
159     /**
160      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
161      * a call to {approve}. `value` is the new allowance.
162      */
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 /* pragma solidity ^0.8.0; */
167 
168 /* import "../IERC20.sol"; */
169 
170 /**
171  * @dev Interface for the optional metadata functions from the ERC20 standard.
172  *
173  * _Available since v4.1._
174  */
175 interface IERC20Metadata is IERC20 {
176     /**
177      * @dev Returns the name of the token.
178      */
179     function name() external view returns (string memory);
180 
181     /**
182      * @dev Returns the symbol of the token.
183      */
184     function symbol() external view returns (string memory);
185 
186     /**
187      * @dev Returns the decimals places of the token.
188      */
189     function decimals() external view returns (uint8);
190 }
191 
192 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
193 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
194 
195 /* pragma solidity ^0.8.0; */
196 
197 /* import "./IERC20.sol"; */
198 /* import "./extensions/IERC20Metadata.sol"; */
199 /* import "../../utils/Context.sol"; */
200 
201 /**
202  * @dev Implementation of the {IERC20} interface.
203  *
204  * This implementation is agnostic to the way tokens are created. This means
205  * that a supply mechanism has to be added in a derived contract using {_mint}.
206  * For a generic mechanism see {ERC20PresetMinterPauser}.
207  *
208  * TIP: For a detailed writeup see our guide
209  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
210  * to implement supply mechanisms].
211  *
212  * We have followed general OpenZeppelin Contracts guidelines: functions revert
213  * instead returning `false` on failure. This behavior is nonetheless
214  * conventional and does not conflict with the expectations of ERC20
215  * applications.
216  *
217  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
218  * This allows applications to reconstruct the allowance for all accounts just
219  * by listening to said events. Other implementations of the EIP may not emit
220  * these events, as it isn't required by the specification.
221  *
222  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
223  * functions have been added to mitigate the well-known issues around setting
224  * allowances. See {IERC20-approve}.
225  */
226 contract ERC20 is Context, IERC20, IERC20Metadata {
227     mapping(address => uint256) private _balances;
228 
229     mapping(address => mapping(address => uint256)) private _allowances;
230 
231     uint256 private _totalSupply;
232 
233     string private _name;
234     string private _symbol;
235 
236     /**
237      * @dev Sets the values for {name} and {symbol}.
238      *
239      * The default value of {decimals} is 18. To select a different value for
240      * {decimals} you should overload it.
241      *
242      * All two of these values are immutable: they can only be set once during
243      * construction.
244      */
245     constructor(string memory name_, string memory symbol_) {
246         _name = name_;
247         _symbol = symbol_;
248     }
249 
250     /**
251      * @dev Returns the name of the token.
252      */
253     function name() public view virtual override returns (string memory) {
254         return _name;
255     }
256 
257     /**
258      * @dev Returns the symbol of the token, usually a shorter version of the
259      * name.
260      */
261     function symbol() public view virtual override returns (string memory) {
262         return _symbol;
263     }
264 
265     /**
266      * @dev Returns the number of decimals used to get its user representation.
267      * For example, if `decimals` equals `2`, a balance of `505` tokens should
268      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
269      *
270      * Tokens usually opt for a value of 18, imitating the relationship between
271      * Ether and Wei. This is the value {ERC20} uses, unless this function is
272      * overridden;
273      *
274      * NOTE: This information is only used for _display_ purposes: it in
275      * no way affects any of the arithmetic of the contract, including
276      * {IERC20-balanceOf} and {IERC20-transfer}.
277      */
278     function decimals() public view virtual override returns (uint8) {
279         return 18;
280     }
281 
282     /**
283      * @dev See {IERC20-totalSupply}.
284      */
285     function totalSupply() public view virtual override returns (uint256) {
286         return _totalSupply;
287     }
288 
289     /**
290      * @dev See {IERC20-balanceOf}.
291      */
292     function balanceOf(address account) public view virtual override returns (uint256) {
293         return _balances[account];
294     }
295 
296     /**
297      * @dev See {IERC20-transfer}.
298      *
299      * Requirements:
300      *
301      * - `recipient` cannot be the zero address.
302      * - the caller must have a balance of at least `amount`.
303      */
304     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
305         _transfer(_msgSender(), recipient, amount);
306         return true;
307     }
308 
309     /**
310      * @dev See {IERC20-allowance}.
311      */
312     function allowance(address owner, address spender) public view virtual override returns (uint256) {
313         return _allowances[owner][spender];
314     }
315 
316     /**
317      * @dev See {IERC20-approve}.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function approve(address spender, uint256 amount) public virtual override returns (bool) {
324         _approve(_msgSender(), spender, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-transferFrom}.
330      *
331      * Emits an {Approval} event indicating the updated allowance. This is not
332      * required by the EIP. See the note at the beginning of {ERC20}.
333      *
334      * Requirements:
335      *
336      * - `sender` and `recipient` cannot be the zero address.
337      * - `sender` must have a balance of at least `amount`.
338      * - the caller must have allowance for ``sender``'s tokens of at least
339      * `amount`.
340      */
341     function transferFrom(
342         address sender,
343         address recipient,
344         uint256 amount
345     ) public virtual override returns (bool) {
346         _transfer(sender, recipient, amount);
347 
348         uint256 currentAllowance = _allowances[sender][_msgSender()];
349         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
350         unchecked {
351             _approve(sender, _msgSender(), currentAllowance - amount);
352         }
353 
354         return true;
355     }
356 
357     /**
358      * @dev Atomically increases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to {approve} that can be used as a mitigation for
361      * problems described in {IERC20-approve}.
362      *
363      * Emits an {Approval} event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
370         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
371         return true;
372     }
373 
374     /**
375      * @dev Atomically decreases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      * - `spender` must have allowance for the caller of at least
386      * `subtractedValue`.
387      */
388     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
389         uint256 currentAllowance = _allowances[_msgSender()][spender];
390         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
391         unchecked {
392             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
393         }
394 
395         return true;
396     }
397 
398     /**
399      * @dev Moves `amount` of tokens from `sender` to `recipient`.
400      *
401      * This internal function is equivalent to {transfer}, and can be used to
402      * e.g. implement automatic token fees, slashing mechanisms, etc.
403      *
404      * Emits a {Transfer} event.
405      *
406      * Requirements:
407      *
408      * - `sender` cannot be the zero address.
409      * - `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      */
412     function _transfer(
413         address sender,
414         address recipient,
415         uint256 amount
416     ) internal virtual {
417         require(sender != address(0), "ERC20: transfer from the zero address");
418         require(recipient != address(0), "ERC20: transfer to the zero address");
419 
420         _beforeTokenTransfer(sender, recipient, amount);
421 
422         uint256 senderBalance = _balances[sender];
423         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
424         unchecked {
425             _balances[sender] = senderBalance - amount;
426         }
427         _balances[recipient] += amount;
428 
429         emit Transfer(sender, recipient, amount);
430 
431         _afterTokenTransfer(sender, recipient, amount);
432     }
433 
434     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
435      * the total supply.
436      *
437      * Emits a {Transfer} event with `from` set to the zero address.
438      *
439      * Requirements:
440      *
441      * - `account` cannot be the zero address.
442      */
443     function _mint(address account, uint256 amount) internal virtual {
444         require(account != address(0), "ERC20: mint to the zero address");
445 
446         _beforeTokenTransfer(address(0), account, amount);
447 
448         _totalSupply += amount;
449         _balances[account] += amount;
450         emit Transfer(address(0), account, amount);
451 
452         _afterTokenTransfer(address(0), account, amount);
453     }
454 
455     /**
456      * @dev Destroys `amount` tokens from `account`, reducing the
457      * total supply.
458      *
459      * Emits a {Transfer} event with `to` set to the zero address.
460      *
461      * Requirements:
462      *
463      * - `account` cannot be the zero address.
464      * - `account` must have at least `amount` tokens.
465      */
466     function _burn(address account, uint256 amount) internal virtual {
467         require(account != address(0), "ERC20: burn from the zero address");
468 
469         _beforeTokenTransfer(account, address(0), amount);
470 
471         uint256 accountBalance = _balances[account];
472         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
473         unchecked {
474             _balances[account] = accountBalance - amount;
475         }
476         _totalSupply -= amount;
477 
478         emit Transfer(account, address(0), amount);
479 
480         _afterTokenTransfer(account, address(0), amount);
481     }
482 
483     /**
484      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
485      *
486      * This internal function is equivalent to `approve`, and can be used to
487      * e.g. set automatic allowances for certain subsystems, etc.
488      *
489      * Emits an {Approval} event.
490      *
491      * Requirements:
492      *
493      * - `owner` cannot be the zero address.
494      * - `spender` cannot be the zero address.
495      */
496     function _approve(
497         address owner,
498         address spender,
499         uint256 amount
500     ) internal virtual {
501         require(owner != address(0), "ERC20: approve from the zero address");
502         require(spender != address(0), "ERC20: approve to the zero address");
503 
504         _allowances[owner][spender] = amount;
505         emit Approval(owner, spender, amount);
506     }
507 
508     /**
509      * @dev Hook that is called before any transfer of tokens. This includes
510      * minting and burning.
511      *
512      * Calling conditions:
513      *
514      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
515      * will be transferred to `to`.
516      * - when `from` is zero, `amount` tokens will be minted for `to`.
517      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
518      * - `from` and `to` are never both zero.
519      *
520      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
521      */
522     function _beforeTokenTransfer(
523         address from,
524         address to,
525         uint256 amount
526     ) internal virtual {}
527 
528     /**
529      * @dev Hook that is called after any transfer of tokens. This includes
530      * minting and burning.
531      *
532      * Calling conditions:
533      *
534      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
535      * has been transferred to `to`.
536      * - when `from` is zero, `amount` tokens have been minted for `to`.
537      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
538      * - `from` and `to` are never both zero.
539      *
540      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
541      */
542     function _afterTokenTransfer(
543         address from,
544         address to,
545         uint256 amount
546     ) internal virtual {}
547 }
548 
549 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
550 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
551 
552 /* pragma solidity ^0.8.0; */
553 
554 // CAUTION
555 // This version of SafeMath should only be used with Solidity 0.8 or later,
556 // because it relies on the compiler's built in overflow checks.
557 
558 /**
559  * @dev Wrappers over Solidity's arithmetic operations.
560  *
561  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
562  * now has built in overflow checking.
563  */
564 library SafeMath {
565     /**
566      * @dev Returns the addition of two unsigned integers, with an overflow flag.
567      *
568      * _Available since v3.4._
569      */
570     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
571         unchecked {
572             uint256 c = a + b;
573             if (c < a) return (false, 0);
574             return (true, c);
575         }
576     }
577 
578     /**
579      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
580      *
581      * _Available since v3.4._
582      */
583     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
584         unchecked {
585             if (b > a) return (false, 0);
586             return (true, a - b);
587         }
588     }
589 
590     /**
591      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
592      *
593      * _Available since v3.4._
594      */
595     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
596         unchecked {
597             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
598             // benefit is lost if 'b' is also tested.
599             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
600             if (a == 0) return (true, 0);
601             uint256 c = a * b;
602             if (c / a != b) return (false, 0);
603             return (true, c);
604         }
605     }
606 
607     /**
608      * @dev Returns the division of two unsigned integers, with a division by zero flag.
609      *
610      * _Available since v3.4._
611      */
612     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
613         unchecked {
614             if (b == 0) return (false, 0);
615             return (true, a / b);
616         }
617     }
618 
619     /**
620      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
621      *
622      * _Available since v3.4._
623      */
624     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
625         unchecked {
626             if (b == 0) return (false, 0);
627             return (true, a % b);
628         }
629     }
630 
631     /**
632      * @dev Returns the addition of two unsigned integers, reverting on
633      * overflow.
634      *
635      * Counterpart to Solidity's `+` operator.
636      *
637      * Requirements:
638      *
639      * - Addition cannot overflow.
640      */
641     function add(uint256 a, uint256 b) internal pure returns (uint256) {
642         return a + b;
643     }
644 
645     /**
646      * @dev Returns the subtraction of two unsigned integers, reverting on
647      * overflow (when the result is negative).
648      *
649      * Counterpart to Solidity's `-` operator.
650      *
651      * Requirements:
652      *
653      * - Subtraction cannot overflow.
654      */
655     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
656         return a - b;
657     }
658 
659     /**
660      * @dev Returns the multiplication of two unsigned integers, reverting on
661      * overflow.
662      *
663      * Counterpart to Solidity's `*` operator.
664      *
665      * Requirements:
666      *
667      * - Multiplication cannot overflow.
668      */
669     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
670         return a * b;
671     }
672 
673     /**
674      * @dev Returns the integer division of two unsigned integers, reverting on
675      * division by zero. The result is rounded towards zero.
676      *
677      * Counterpart to Solidity's `/` operator.
678      *
679      * Requirements:
680      *
681      * - The divisor cannot be zero.
682      */
683     function div(uint256 a, uint256 b) internal pure returns (uint256) {
684         return a / b;
685     }
686 
687     /**
688      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
689      * reverting when dividing by zero.
690      *
691      * Counterpart to Solidity's `%` operator. This function uses a `revert`
692      * opcode (which leaves remaining gas untouched) while Solidity uses an
693      * invalid opcode to revert (consuming all remaining gas).
694      *
695      * Requirements:
696      *
697      * - The divisor cannot be zero.
698      */
699     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
700         return a % b;
701     }
702 
703     /**
704      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
705      * overflow (when the result is negative).
706      *
707      * CAUTION: This function is deprecated because it requires allocating memory for the error
708      * message unnecessarily. For custom revert reasons use {trySub}.
709      *
710      * Counterpart to Solidity's `-` operator.
711      *
712      * Requirements:
713      *
714      * - Subtraction cannot overflow.
715      */
716     function sub(
717         uint256 a,
718         uint256 b,
719         string memory errorMessage
720     ) internal pure returns (uint256) {
721         unchecked {
722             require(b <= a, errorMessage);
723             return a - b;
724         }
725     }
726 
727     /**
728      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
729      * division by zero. The result is rounded towards zero.
730      *
731      * Counterpart to Solidity's `/` operator. Note: this function uses a
732      * `revert` opcode (which leaves remaining gas untouched) while Solidity
733      * uses an invalid opcode to revert (consuming all remaining gas).
734      *
735      * Requirements:
736      *
737      * - The divisor cannot be zero.
738      */
739     function div(
740         uint256 a,
741         uint256 b,
742         string memory errorMessage
743     ) internal pure returns (uint256) {
744         unchecked {
745             require(b > 0, errorMessage);
746             return a / b;
747         }
748     }
749 
750     /**
751      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
752      * reverting with custom message when dividing by zero.
753      *
754      * CAUTION: This function is deprecated because it requires allocating memory for the error
755      * message unnecessarily. For custom revert reasons use {tryMod}.
756      *
757      * Counterpart to Solidity's `%` operator. This function uses a `revert`
758      * opcode (which leaves remaining gas untouched) while Solidity uses an
759      * invalid opcode to revert (consuming all remaining gas).
760      *
761      * Requirements:
762      *
763      * - The divisor cannot be zero.
764      */
765     function mod(
766         uint256 a,
767         uint256 b,
768         string memory errorMessage
769     ) internal pure returns (uint256) {
770         unchecked {
771             require(b > 0, errorMessage);
772             return a % b;
773         }
774     }
775 }
776 
777 ////// src/IUniswapV2Factory.sol
778 /* pragma solidity 0.8.10; */
779 /* pragma experimental ABIEncoderV2; */
780 
781 interface IUniswapV2Factory {
782     event PairCreated(
783         address indexed token0,
784         address indexed token1,
785         address pair,
786         uint256
787     );
788 
789     function feeTo() external view returns (address);
790 
791     function feeToSetter() external view returns (address);
792 
793     function getPair(address tokenA, address tokenB)
794         external
795         view
796         returns (address pair);
797 
798     function allPairs(uint256) external view returns (address pair);
799 
800     function allPairsLength() external view returns (uint256);
801 
802     function createPair(address tokenA, address tokenB)
803         external
804         returns (address pair);
805 
806     function setFeeTo(address) external;
807 
808     function setFeeToSetter(address) external;
809 }
810 
811 ////// src/IUniswapV2Pair.sol
812 /* pragma solidity 0.8.10; */
813 /* pragma experimental ABIEncoderV2; */
814 
815 interface IUniswapV2Pair {
816     event Approval(
817         address indexed owner,
818         address indexed spender,
819         uint256 value
820     );
821     event Transfer(address indexed from, address indexed to, uint256 value);
822 
823     function name() external pure returns (string memory);
824 
825     function symbol() external pure returns (string memory);
826 
827     function decimals() external pure returns (uint8);
828 
829     function totalSupply() external view returns (uint256);
830 
831     function balanceOf(address owner) external view returns (uint256);
832 
833     function allowance(address owner, address spender)
834         external
835         view
836         returns (uint256);
837 
838     function approve(address spender, uint256 value) external returns (bool);
839 
840     function transfer(address to, uint256 value) external returns (bool);
841 
842     function transferFrom(
843         address from,
844         address to,
845         uint256 value
846     ) external returns (bool);
847 
848     function DOMAIN_SEPARATOR() external view returns (bytes32);
849 
850     function PERMIT_TYPEHASH() external pure returns (bytes32);
851 
852     function nonces(address owner) external view returns (uint256);
853 
854     function permit(
855         address owner,
856         address spender,
857         uint256 value,
858         uint256 deadline,
859         uint8 v,
860         bytes32 r,
861         bytes32 s
862     ) external;
863 
864     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
865     event Burn(
866         address indexed sender,
867         uint256 amount0,
868         uint256 amount1,
869         address indexed to
870     );
871     event Swap(
872         address indexed sender,
873         uint256 amount0In,
874         uint256 amount1In,
875         uint256 amount0Out,
876         uint256 amount1Out,
877         address indexed to
878     );
879     event Sync(uint112 reserve0, uint112 reserve1);
880 
881     function MINIMUM_LIQUIDITY() external pure returns (uint256);
882 
883     function factory() external view returns (address);
884 
885     function token0() external view returns (address);
886 
887     function token1() external view returns (address);
888 
889     function getReserves()
890         external
891         view
892         returns (
893             uint112 reserve0,
894             uint112 reserve1,
895             uint32 blockTimestampLast
896         );
897 
898     function price0CumulativeLast() external view returns (uint256);
899 
900     function price1CumulativeLast() external view returns (uint256);
901 
902     function kLast() external view returns (uint256);
903 
904     function mint(address to) external returns (uint256 liquidity);
905 
906     function burn(address to)
907         external
908         returns (uint256 amount0, uint256 amount1);
909 
910     function swap(
911         uint256 amount0Out,
912         uint256 amount1Out,
913         address to,
914         bytes calldata data
915     ) external;
916 
917     function skim(address to) external;
918 
919     function sync() external;
920 
921     function initialize(address, address) external;
922 }
923 
924 ////// src/IUniswapV2Router02.sol
925 /* pragma solidity 0.8.10; */
926 /* pragma experimental ABIEncoderV2; */
927 
928 interface IUniswapV2Router02 {
929     function factory() external pure returns (address);
930 
931     function WETH() external pure returns (address);
932 
933     function addLiquidity(
934         address tokenA,
935         address tokenB,
936         uint256 amountADesired,
937         uint256 amountBDesired,
938         uint256 amountAMin,
939         uint256 amountBMin,
940         address to,
941         uint256 deadline
942     )
943         external
944         returns (
945             uint256 amountA,
946             uint256 amountB,
947             uint256 liquidity
948         );
949 
950     function addLiquidityETH(
951         address token,
952         uint256 amountTokenDesired,
953         uint256 amountTokenMin,
954         uint256 amountETHMin,
955         address to,
956         uint256 deadline
957     )
958         external
959         payable
960         returns (
961             uint256 amountToken,
962             uint256 amountETH,
963             uint256 liquidity
964         );
965 
966     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
967         uint256 amountIn,
968         uint256 amountOutMin,
969         address[] calldata path,
970         address to,
971         uint256 deadline
972     ) external;
973 
974     function swapExactETHForTokensSupportingFeeOnTransferTokens(
975         uint256 amountOutMin,
976         address[] calldata path,
977         address to,
978         uint256 deadline
979     ) external payable;
980 
981     function swapExactTokensForETHSupportingFeeOnTransferTokens(
982         uint256 amountIn,
983         uint256 amountOutMin,
984         address[] calldata path,
985         address to,
986         uint256 deadline
987     ) external;
988 }
989 
990 /* pragma solidity >=0.8.10; */
991 
992 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
993 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
994 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
995 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
996 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
997 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
998 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
999 
1000 contract KENNY is ERC20, Ownable {
1001     using SafeMath for uint256;
1002 
1003     IUniswapV2Router02 public immutable uniswapV2Router;
1004     address public immutable uniswapV2Pair;
1005     address public constant deadAddress = address(0xdead);
1006 
1007     bool private swapping;
1008 
1009     address public marketingWallet;
1010     address public devWallet;
1011 
1012     uint256 public maxTransactionAmount;
1013     uint256 public swapTokensAtAmount;
1014     uint256 public maxWallet;
1015 
1016     uint256 public percentForLPBurn = 25; // 25 = .25%
1017     bool public lpBurnEnabled = false;
1018     uint256 public lpBurnFrequency = 3600 seconds;
1019     uint256 public lastLpBurnTime;
1020 
1021     uint256 public manualBurnFrequency = 30 minutes;
1022     uint256 public lastManualLpBurnTime;
1023 
1024     bool public limitsInEffect = true;
1025     bool public tradingActive = false;
1026     bool public swapEnabled = false;
1027 
1028     // Anti-bot and anti-whale mappings and variables
1029     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1030     bool public transferDelayEnabled = true;
1031 
1032     uint256 public buyTotalFees;
1033     uint256 public buyMarketingFee;
1034     uint256 public buyLiquidityFee;
1035     uint256 public buydevvault;
1036 
1037     uint256 public sellTotalFees;
1038     uint256 public sellMarketingFee;
1039     uint256 public sellLiquidityFee;
1040     uint256 public selldevvault;
1041 
1042     uint256 public tokensForMarketing;
1043     uint256 public tokensForLiquidity;
1044     uint256 public tokensForDev;
1045 
1046     /******************/
1047 
1048     // exlcude from fees and max transaction amount
1049     mapping(address => bool) private _isExcludedFromFees;
1050     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1051 
1052     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1053     // could be subject to a maximum transfer amount
1054     mapping(address => bool) public automatedMarketMakerPairs;
1055 
1056     event UpdateUniswapV2Router(
1057         address indexed newAddress,
1058         address indexed oldAddress
1059     );
1060 
1061     event ExcludeFromFees(address indexed account, bool isExcluded);
1062 
1063     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1064 
1065     event marketingWalletUpdated(
1066         address indexed newWallet,
1067         address indexed oldWallet
1068     );
1069 
1070     event devWalletUpdated(
1071         address indexed newWallet,
1072         address indexed oldWallet
1073     );
1074 
1075     event SwapAndLiquify(
1076         uint256 tokensSwapped,
1077         uint256 ethReceived,
1078         uint256 tokensIntoLiquidity
1079     );
1080 
1081     event AutoNukeLP();
1082 
1083     event ManualNukeLP();
1084 
1085     constructor() ERC20("Kenny", "KENNY") {
1086         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1087             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1088         );
1089 
1090         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1091         uniswapV2Router = _uniswapV2Router;
1092 
1093         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1094             .createPair(address(this), _uniswapV2Router.WETH());
1095         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1096         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1097 
1098         uint256 _buyMarketingFee = 10;
1099         uint256 _buyLiquidityFee = 0;
1100         uint256 _buydevvault = 0;
1101 
1102         uint256 _sellMarketingFee = 19;
1103         uint256 _sellLiquidityFee = 0;
1104         uint256 _selldevvault = 0;
1105 
1106         uint256 totalSupply = 1_000_000_000 * 1e18;
1107 
1108         maxTransactionAmount = 10_000_000 * 1e18; // 1% 
1109         maxWallet = 10_000_000 * 1e18; // 1% 
1110         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1111 
1112         buyMarketingFee = _buyMarketingFee;
1113         buyLiquidityFee = _buyLiquidityFee;
1114         buydevvault = _buydevvault;
1115         buyTotalFees = buyMarketingFee + buyLiquidityFee + buydevvault;
1116 
1117         sellMarketingFee = _sellMarketingFee;
1118         sellLiquidityFee = _sellLiquidityFee;
1119         selldevvault = _selldevvault;
1120         sellTotalFees = sellMarketingFee + sellLiquidityFee + selldevvault;
1121 
1122         marketingWallet = address(0x3cf3a15800ea395B78b03f147628778b5680CCb4); 
1123         devWallet = address(0x3cf3a15800ea395B78b03f147628778b5680CCb4); 
1124 
1125         // exclude from paying fees or having max transaction amount
1126         excludeFromFees(owner(), true);
1127         excludeFromFees(address(this), true);
1128         excludeFromFees(address(0xdead), true);
1129 
1130         excludeFromMaxTransaction(owner(), true);
1131         excludeFromMaxTransaction(address(this), true);
1132         excludeFromMaxTransaction(address(0xdead), true);
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
1147         lastLpBurnTime = block.timestamp;
1148     }
1149 
1150     // remove limits after token is stable
1151     function removeLimits() external onlyOwner returns (bool) {
1152         limitsInEffect = false;
1153         return true;
1154     }
1155 
1156     // disable Transfer delay - cannot be reenabled
1157     function disableTransferDelay() external onlyOwner returns (bool) {
1158         transferDelayEnabled = false;
1159         return true;
1160     }
1161 
1162     // change the minimum amount of tokens to sell from fees
1163     function updateSwapTokensAtAmount(uint256 newAmount)
1164         external
1165         onlyOwner
1166         returns (bool)
1167     {
1168         require(
1169             newAmount >= (totalSupply() * 1) / 100000,
1170             "Swap amount cannot be lower than 0.001% total supply."
1171         );
1172         require(
1173             newAmount <= (totalSupply() * 5) / 1000,
1174             "Swap amount cannot be higher than 0.5% total supply."
1175         );
1176         swapTokensAtAmount = newAmount;
1177         return true;
1178     }
1179 
1180     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1181         require(
1182             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1183             "Cannot set maxTransactionAmount lower than 0.1%"
1184         );
1185         maxTransactionAmount = newNum * (10**18);
1186     }
1187 
1188     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1189         require(
1190             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1191             "Cannot set maxWallet lower than 0.5%"
1192         );
1193         maxWallet = newNum * (10**18);
1194     }
1195 
1196     function excludeFromMaxTransaction(address updAds, bool isEx)
1197         public
1198         onlyOwner
1199     {
1200         _isExcludedMaxTransactionAmount[updAds] = isEx;
1201     }
1202 
1203     // only use to disable contract sales if absolutely necessary (emergency use only)
1204     function updateSwapEnabled(bool enabled) external onlyOwner {
1205         swapEnabled = enabled;
1206     }
1207 
1208     function updateBuyFees(
1209         uint256 _marketingFee,
1210         uint256 _liquidityFee,
1211         uint256 _devvault
1212     ) external onlyOwner {
1213         buyMarketingFee = _marketingFee;
1214         buyLiquidityFee = _liquidityFee;
1215         buydevvault = _devvault;
1216         buyTotalFees = buyMarketingFee + buyLiquidityFee + buydevvault;
1217         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1218     }
1219 
1220     function updateSellFees(
1221         uint256 _marketingFee,
1222         uint256 _liquidityFee,
1223         uint256 _devvault
1224     ) external onlyOwner {
1225         sellMarketingFee = _marketingFee;
1226         sellLiquidityFee = _liquidityFee;
1227         selldevvault = _devvault;
1228         sellTotalFees = sellMarketingFee + sellLiquidityFee + selldevvault;
1229         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1230     }
1231 
1232     function excludeFromFees(address account, bool excluded) public onlyOwner {
1233         _isExcludedFromFees[account] = excluded;
1234         emit ExcludeFromFees(account, excluded);
1235     }
1236 
1237     function setAutomatedMarketMakerPair(address pair, bool value)
1238         public
1239         onlyOwner
1240     {
1241         require(
1242             pair != uniswapV2Pair,
1243             "The pair cannot be removed from automatedMarketMakerPairs"
1244         );
1245 
1246         _setAutomatedMarketMakerPair(pair, value);
1247     }
1248 
1249     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1250         automatedMarketMakerPairs[pair] = value;
1251 
1252         emit SetAutomatedMarketMakerPair(pair, value);
1253     }
1254 
1255     function updateMarketingWallet(address newMarketingWallet)
1256         external
1257         onlyOwner
1258     {
1259         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1260         marketingWallet = newMarketingWallet;
1261     }
1262 
1263     function updateDevWallet(address newWallet) external onlyOwner {
1264         emit devWalletUpdated(newWallet, devWallet);
1265         devWallet = newWallet;
1266     }
1267 
1268     function isExcludedFromFees(address account) public view returns (bool) {
1269         return _isExcludedFromFees[account];
1270     }
1271 
1272     event BoughtEarly(address indexed sniper);
1273 
1274     function _transfer(
1275         address from,
1276         address to,
1277         uint256 amount
1278     ) internal override {
1279         require(from != address(0), "ERC20: transfer from the zero address");
1280         require(to != address(0), "ERC20: transfer to the zero address");
1281 
1282         if (amount == 0) {
1283             super._transfer(from, to, 0);
1284             return;
1285         }
1286 
1287         if (limitsInEffect) {
1288             if (
1289                 from != owner() &&
1290                 to != owner() &&
1291                 to != address(0) &&
1292                 to != address(0xdead) &&
1293                 !swapping
1294             ) {
1295                 if (!tradingActive) {
1296                     require(
1297                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1298                         "Trading is not active."
1299                     );
1300                 }
1301 
1302                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1303                 if (transferDelayEnabled) {
1304                     if (
1305                         to != owner() &&
1306                         to != address(uniswapV2Router) &&
1307                         to != address(uniswapV2Pair)
1308                     ) {
1309                         require(
1310                             _holderLastTransferTimestamp[tx.origin] <
1311                                 block.number,
1312                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1313                         );
1314                         _holderLastTransferTimestamp[tx.origin] = block.number;
1315                     }
1316                 }
1317 
1318                 //when buy
1319                 if (
1320                     automatedMarketMakerPairs[from] &&
1321                     !_isExcludedMaxTransactionAmount[to]
1322                 ) {
1323                     require(
1324                         amount <= maxTransactionAmount,
1325                         "Buy transfer amount exceeds the maxTransactionAmount."
1326                     );
1327                     require(
1328                         amount + balanceOf(to) <= maxWallet,
1329                         "Max wallet exceeded"
1330                     );
1331                 }
1332                 //when sell
1333                 else if (
1334                     automatedMarketMakerPairs[to] &&
1335                     !_isExcludedMaxTransactionAmount[from]
1336                 ) {
1337                     require(
1338                         amount <= maxTransactionAmount,
1339                         "Sell transfer amount exceeds the maxTransactionAmount."
1340                     );
1341                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1342                     require(
1343                         amount + balanceOf(to) <= maxWallet,
1344                         "Max wallet exceeded"
1345                     );
1346                 }
1347             }
1348         }
1349 
1350         uint256 contractTokenBalance = balanceOf(address(this));
1351 
1352         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1353 
1354         if (
1355             canSwap &&
1356             swapEnabled &&
1357             !swapping &&
1358             !automatedMarketMakerPairs[from] &&
1359             !_isExcludedFromFees[from] &&
1360             !_isExcludedFromFees[to]
1361         ) {
1362             swapping = true;
1363 
1364             swapBack();
1365 
1366             swapping = false;
1367         }
1368 
1369         if (
1370             !swapping &&
1371             automatedMarketMakerPairs[to] &&
1372             lpBurnEnabled &&
1373             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1374             !_isExcludedFromFees[from]
1375         ) {
1376             autoBurnLiquidityPairTokens();
1377         }
1378 
1379         bool takeFee = !swapping;
1380 
1381         // if any account belongs to _isExcludedFromFee account then remove the fee
1382         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1383             takeFee = false;
1384         }
1385 
1386         uint256 fees = 0;
1387         // only take fees on buys/sells, do not take on wallet transfers
1388         if (takeFee) {
1389             // on sell
1390             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1391                 fees = amount.mul(sellTotalFees).div(100);
1392                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1393                 tokensForDev += (fees * selldevvault) / sellTotalFees;
1394                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1395             }
1396             // on buy
1397             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1398                 fees = amount.mul(buyTotalFees).div(100);
1399                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1400                 tokensForDev += (fees * buydevvault) / buyTotalFees;
1401                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1402             }
1403 
1404             if (fees > 0) {
1405                 super._transfer(from, address(this), fees);
1406             }
1407 
1408             amount -= fees;
1409         }
1410 
1411         super._transfer(from, to, amount);
1412     }
1413 
1414     function swapTokensForEth(uint256 tokenAmount) private {
1415         // generate the uniswap pair path of token -> weth
1416         address[] memory path = new address[](2);
1417         path[0] = address(this);
1418         path[1] = uniswapV2Router.WETH();
1419 
1420         _approve(address(this), address(uniswapV2Router), tokenAmount);
1421 
1422         // make the swap
1423         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1424             tokenAmount,
1425             0, // accept any amount of ETH
1426             path,
1427             address(this),
1428             block.timestamp
1429         );
1430     }
1431 
1432     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1433         // approve token transfer to cover all possible scenarios
1434         _approve(address(this), address(uniswapV2Router), tokenAmount);
1435 
1436         // add the liquidity
1437         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1438             address(this),
1439             tokenAmount,
1440             0, // slippage is unavoidable
1441             0, // slippage is unavoidable
1442             deadAddress,
1443             block.timestamp
1444         );
1445     }
1446 
1447     function swapBack() private {
1448         uint256 contractBalance = balanceOf(address(this));
1449         uint256 totalTokensToSwap = tokensForLiquidity +
1450             tokensForMarketing +
1451             tokensForDev;
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
1477         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1478 
1479         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1480 
1481         tokensForLiquidity = 0;
1482         tokensForMarketing = 0;
1483         tokensForDev = 0;
1484 
1485         (success, ) = address(devWallet).call{value: ethForDev}("");
1486 
1487         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1488             addLiquidity(liquidityTokens, ethForLiquidity);
1489             emit SwapAndLiquify(
1490                 amountToSwapForETH,
1491                 ethForLiquidity,
1492                 tokensForLiquidity
1493             );
1494         }
1495 
1496         (success, ) = address(marketingWallet).call{
1497             value: address(this).balance
1498         }("");
1499     }
1500 
1501     function setAutoLPBurnSettings(
1502         uint256 _frequencyInSeconds,
1503         uint256 _percent,
1504         bool _Enabled
1505     ) external onlyOwner {
1506         require(
1507             _frequencyInSeconds >= 600,
1508             "cannot set buyback more often than every 10 minutes"
1509         );
1510         require(
1511             _percent <= 1000 && _percent >= 0,
1512             "Must set auto LP burn percent between 0% and 10%"
1513         );
1514         lpBurnFrequency = _frequencyInSeconds;
1515         percentForLPBurn = _percent;
1516         lpBurnEnabled = _Enabled;
1517     }
1518 
1519     function autoBurnLiquidityPairTokens() internal returns (bool) {
1520         lastLpBurnTime = block.timestamp;
1521 
1522         // get balance of liquidity pair
1523         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1524 
1525         // calculate amount to burn
1526         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1527             10000
1528         );
1529 
1530         // pull tokens from pancakePair liquidity and move to dead address permanently
1531         if (amountToBurn > 0) {
1532             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1533         }
1534 
1535         //sync price since this is not in a swap transaction!
1536         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1537         pair.sync();
1538         emit AutoNukeLP();
1539         return true;
1540     }
1541 
1542     function manualBurnLiquidityPairTokens(uint256 percent)
1543         external
1544         onlyOwner
1545         returns (bool)
1546     {
1547         require(
1548             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1549             "Must wait for cooldown to finish"
1550         );
1551         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1552         lastManualLpBurnTime = block.timestamp;
1553 
1554         // get balance of liquidity pair
1555         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1556 
1557         // calculate amount to burn
1558         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1559 
1560         // pull tokens from pancakePair liquidity and move to dead address permanently
1561         if (amountToBurn > 0) {
1562             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1563         }
1564 
1565         //sync price since this is not in a swap transaction!
1566         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1567         pair.sync();
1568         emit ManualNukeLP();
1569         return true;
1570     }
1571 }