1 /**
2 
3 Step into the world of crypto with GODCANDLE, the 
4 token that's blazing a trail of financial growth on the 
5 Ethereum blockchain. As the chart candles turn green, a new era of prosperity begins.
6 
7 
8 
9 GODCANDLE represents the power of positive momentum in the crypto 
10 space. Each green candle signifies upward movement, symbolizing opportunities for profit and success. 
11 
12 
13 
14 With GODCANDLE in your portfolio, you're embracing the potential for exponential growth.
15 
16 
17 
18 In this volatile landscape, the green chart
19  candles act as beacons of hope, reminding us that with 
20  strategic investments and unwavering determination, 
21  we can reach new heights. Let GOD guide you
22   on a path of financial freedom, where your dreams become reality.
23 
24 
25 
26 Invest in GOD and witness the transformation of 
27 your portfolio. With every green candle, your confidence 
28 will soar as you ride the wave of crypto success. Together, let's 
29 harness the power of the green chart candles and 
30 light up the future of finance! 🚀💚
31 
32 https://t.me/GodCandleERC
33 https://twitter.com/GODCANDLEERC
34 https://godcandlecoin.com/
35 */
36 
37 // SPDX-License-Identifier: MIT
38 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
39 pragma experimental ABIEncoderV2;
40 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
41 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
42 /* pragma solidity ^0.8.0; */
43 /**
44  * @dev Provides information about the current execution context, including the
45  * sender of the transaction and its data. While these are generally available
46  * via msg.sender and msg.data, they should not be accessed in such a direct
47  * manner, since when dealing with meta-transactions the account sending and
48  * paying for execution may not be the actual sender (as far as an application
49  * is concerned).
50  *
51  * This contract is only required for intermediate, library-like contracts.
52  */
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 
58     function _msgData() internal view virtual returns (bytes calldata) {
59         return msg.data;
60     }
61 }
62 
63 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
64 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
65 
66 /* pragma solidity ^0.8.0; */
67 
68 /* import "../utils/Context.sol"; */
69 
70 /**
71  * @dev Contract module which provides a basic access control mechanism, where
72  * there is an account (an owner) that can be granted exclusive access to
73  * specific functions.
74  *
75  * By default, the owner account will be the one that deploys the contract. This
76  * can later be changed with {transferOwnership}.
77  *
78  * This module is used through inheritance. It will make available the modifier
79  * `onlyOwner`, which can be applied to your functions to restrict their use to
80  * the owner.
81  */
82 abstract contract Ownable is Context {
83     address private _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     /**
88      * @dev Initializes the contract setting the deployer as the initial owner.
89      */
90     constructor() {
91         _transferOwnership(_msgSender());
92     }
93 
94     /**
95      * @dev Returns the address of the current owner.
96      */
97     function owner() public view virtual returns (address) {
98         return _owner;
99     }
100 
101     /**
102      * @dev Throws if called by any account other than the owner.
103      */
104     modifier onlyOwner() {
105         require(owner() == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     /**
110      * @dev Leaves the contract without owner. It will not be possible to call
111      * `onlyOwner` functions anymore. Can only be called by the current owner.
112      *
113      * NOTE: Renouncing ownership will leave the contract without an owner,
114      * thereby removing any functionality that is only available to the owner.
115      */
116     function renounceOwnership() public virtual onlyOwner {
117         _transferOwnership(address(0));
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Can only be called by the current owner.
123      */
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers ownership of the contract to a new account (`newOwner`).
131      * Internal function without access restriction.
132      */
133     function _transferOwnership(address newOwner) internal virtual {
134         address oldOwner = _owner;
135         _owner = newOwner;
136         emit OwnershipTransferred(oldOwner, newOwner);
137     }
138 }
139 
140 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
141 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
142 
143 /* pragma solidity ^0.8.0; */
144 
145 /**
146  * @dev Interface of the ERC20 standard as defined in the EIP.
147  */
148 interface IERC20 {
149     /**
150      * @dev Returns the amount of tokens in existence.
151      */
152     function totalSupply() external view returns (uint256);
153 
154     /**
155      * @dev Returns the amount of tokens owned by `account`.
156      */
157     function balanceOf(address account) external view returns (uint256);
158 
159     /**
160      * @dev Moves `amount` tokens from the caller's account to `recipient`.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transfer(address recipient, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Returns the remaining number of tokens that `spender` will be
170      * allowed to spend on behalf of `owner` through {transferFrom}. This is
171      * zero by default.
172      *
173      * This value changes when {approve} or {transferFrom} are called.
174      */
175     function allowance(address owner, address spender) external view returns (uint256);
176 
177     /**
178      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * IMPORTANT: Beware that changing an allowance with this method brings the risk
183      * that someone may use both the old and the new allowance by unfortunate
184      * transaction ordering. One possible solution to mitigate this race
185      * condition is to first reduce the spender's allowance to 0 and set the
186      * desired value afterwards:
187      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188      *
189      * Emits an {Approval} event.
190      */
191     function approve(address spender, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Moves `amount` tokens from `sender` to `recipient` using the
195      * allowance mechanism. `amount` is then deducted from the caller's
196      * allowance.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transferFrom(
203         address sender,
204         address recipient,
205         uint256 amount
206     ) external returns (bool);
207 
208     /**
209      * @dev Emitted when `value` tokens are moved from one account (`from`) to
210      * another (`to`).
211      *
212      * Note that `value` may be zero.
213      */
214     event Transfer(address indexed from, address indexed to, uint256 value);
215 
216     /**
217      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
218      * a call to {approve}. `value` is the new allowance.
219      */
220     event Approval(address indexed owner, address indexed spender, uint256 value);
221 }
222 
223 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
224 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
225 
226 /* pragma solidity ^0.8.0; */
227 
228 /* import "../IERC20.sol"; */
229 
230 /**
231  * @dev Interface for the optional metadata functions from the ERC20 standard.
232  *
233  * _Available since v4.1._
234  */
235 interface IERC20Metadata is IERC20 {
236     /**
237      * @dev Returns the name of the token.
238      */
239     function name() external view returns (string memory);
240 
241     /**
242      * @dev Returns the symbol of the token.
243      */
244     function symbol() external view returns (string memory);
245 
246     /**
247      * @dev Returns the decimals places of the token.
248      */
249     function decimals() external view returns (uint8);
250 }
251 
252 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
253 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
254 
255 /* pragma solidity ^0.8.0; */
256 
257 /* import "./IERC20.sol"; */
258 /* import "./extensions/IERC20Metadata.sol"; */
259 /* import "../../utils/Context.sol"; */
260 
261 /**
262  * @dev Implementation of the {IERC20} interface.
263  *
264  * This implementation is agnostic to the way tokens are created. This means
265  * that a supply mechanism has to be added in a derived contract using {_mint}.
266  * For a generic mechanism see {ERC20PresetMinterPauser}.
267  *
268  * TIP: For a detailed writeup see our guide
269  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
270  * to implement supply mechanisms].
271  *
272  * We have followed general OpenZeppelin Contracts guidelines: functions revert
273  * instead returning `false` on failure. This behavior is nonetheless
274  * conventional and does not conflict with the expectations of ERC20
275  * applications.
276  *
277  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
278  * This allows applications to reconstruct the allowance for all accounts just
279  * by listening to said events. Other implementations of the EIP may not emit
280  * these events, as it isn't required by the specification.
281  *
282  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
283  * functions have been added to mitigate the well-known issues around setting
284  * allowances. See {IERC20-approve}.
285  */
286 contract ERC20 is Context, IERC20, IERC20Metadata {
287     mapping(address => uint256) private _balances;
288 
289     mapping(address => mapping(address => uint256)) private _allowances;
290 
291     uint256 private _totalSupply;
292 
293     string private _name;
294     string private _symbol;
295 
296     /**
297      * @dev Sets the values for {name} and {symbol}.
298      *
299      * The default value of {decimals} is 18. To select a different value for
300      * {decimals} you should overload it.
301      *
302      * All two of these values are immutable: they can only be set once during
303      * construction.
304      */
305     constructor(string memory name_, string memory symbol_) {
306         _name = name_;
307         _symbol = symbol_;
308     }
309 
310     /**
311      * @dev Returns the name of the token.
312      */
313     function name() public view virtual override returns (string memory) {
314         return _name;
315     }
316 
317     /**
318      * @dev Returns the symbol of the token, usually a shorter version of the
319      * name.
320      */
321     function symbol() public view virtual override returns (string memory) {
322         return _symbol;
323     }
324 
325     /**
326      * @dev Returns the number of decimals used to get its user representation.
327      * For example, if `decimals` equals `2`, a balance of `505` tokens should
328      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
329      *
330      * Tokens usually opt for a value of 18, imitating the relationship between
331      * Ether and Wei. This is the value {ERC20} uses, unless this function is
332      * overridden;
333      *
334      * NOTE: This information is only used for _display_ purposes: it in
335      * no way affects any of the arithmetic of the contract, including
336      * {IERC20-balanceOf} and {IERC20-transfer}.
337      */
338     function decimals() public view virtual override returns (uint8) {
339         return 18;
340     }
341 
342     /**
343      * @dev See {IERC20-totalSupply}.
344      */
345     function totalSupply() public view virtual override returns (uint256) {
346         return _totalSupply;
347     }
348 
349     /**
350      * @dev See {IERC20-balanceOf}.
351      */
352     function balanceOf(address account) public view virtual override returns (uint256) {
353         return _balances[account];
354     }
355 
356     /**
357      * @dev See {IERC20-transfer}.
358      *
359      * Requirements:
360      *
361      * - `recipient` cannot be the zero address.
362      * - the caller must have a balance of at least `amount`.
363      */
364     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
365         _transfer(_msgSender(), recipient, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-allowance}.
371      */
372     function allowance(address owner, address spender) public view virtual override returns (uint256) {
373         return _allowances[owner][spender];
374     }
375 
376     /**
377      * @dev See {IERC20-approve}.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function approve(address spender, uint256 amount) public virtual override returns (bool) {
384         _approve(_msgSender(), spender, amount);
385         return true;
386     }
387 
388     /**
389      * @dev See {IERC20-transferFrom}.
390      *
391      * Emits an {Approval} event indicating the updated allowance. This is not
392      * required by the EIP. See the note at the beginning of {ERC20}.
393      *
394      * Requirements:
395      *
396      * - `sender` and `recipient` cannot be the zero address.
397      * - `sender` must have a balance of at least `amount`.
398      * - the caller must have allowance for ``sender``'s tokens of at least
399      * `amount`.
400      */
401     function transferFrom(
402         address sender,
403         address recipient,
404         uint256 amount
405     ) public virtual override returns (bool) {
406         _transfer(sender, recipient, amount);
407 
408         uint256 currentAllowance = _allowances[sender][_msgSender()];
409         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
410         unchecked {
411             _approve(sender, _msgSender(), currentAllowance - amount);
412         }
413 
414         return true;
415     }
416 
417     /**
418      * @dev Atomically increases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
430         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
431         return true;
432     }
433 
434     /**
435      * @dev Atomically decreases the allowance granted to `spender` by the caller.
436      *
437      * This is an alternative to {approve} that can be used as a mitigation for
438      * problems described in {IERC20-approve}.
439      *
440      * Emits an {Approval} event indicating the updated allowance.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      * - `spender` must have allowance for the caller of at least
446      * `subtractedValue`.
447      */
448     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
449         uint256 currentAllowance = _allowances[_msgSender()][spender];
450         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
451         unchecked {
452             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
453         }
454 
455         return true;
456     }
457 
458     /**
459      * @dev Moves `amount` of tokens from `sender` to `recipient`.
460      *
461      * This internal function is equivalent to {transfer}, and can be used to
462      * e.g. implement automatic token fees, slashing mechanisms, etc.
463      *
464      * Emits a {Transfer} event.
465      *
466      * Requirements:
467      *
468      * - `sender` cannot be the zero address.
469      * - `recipient` cannot be the zero address.
470      * - `sender` must have a balance of at least `amount`.
471      */
472     function _transfer(
473         address sender,
474         address recipient,
475         uint256 amount
476     ) internal virtual {
477         require(sender != address(0), "ERC20: transfer from the zero address");
478         require(recipient != address(0), "ERC20: transfer to the zero address");
479 
480         _beforeTokenTransfer(sender, recipient, amount);
481 
482         uint256 senderBalance = _balances[sender];
483         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
484         unchecked {
485             _balances[sender] = senderBalance - amount;
486         }
487         _balances[recipient] += amount;
488 
489         emit Transfer(sender, recipient, amount);
490 
491         _afterTokenTransfer(sender, recipient, amount);
492     }
493 
494     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
495      * the total supply.
496      *
497      * Emits a {Transfer} event with `from` set to the zero address.
498      *
499      * Requirements:
500      *
501      * - `account` cannot be the zero address.
502      */
503     function _mint(address account, uint256 amount) internal virtual {
504         require(account != address(0), "ERC20: mint to the zero address");
505 
506         _beforeTokenTransfer(address(0), account, amount);
507 
508         _totalSupply += amount;
509         _balances[account] += amount;
510         emit Transfer(address(0), account, amount);
511 
512         _afterTokenTransfer(address(0), account, amount);
513     }
514 
515     /**
516      * @dev Destroys `amount` tokens from `account`, reducing the
517      * total supply.
518      *
519      * Emits a {Transfer} event with `to` set to the zero address.
520      *
521      * Requirements:
522      *
523      * - `account` cannot be the zero address.
524      * - `account` must have at least `amount` tokens.
525      */
526     function _burn(address account, uint256 amount) internal virtual {
527         require(account != address(0), "ERC20: burn from the zero address");
528 
529         _beforeTokenTransfer(account, address(0), amount);
530 
531         uint256 accountBalance = _balances[account];
532         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
533         unchecked {
534             _balances[account] = accountBalance - amount;
535         }
536         _totalSupply -= amount;
537 
538         emit Transfer(account, address(0), amount);
539 
540         _afterTokenTransfer(account, address(0), amount);
541     }
542 
543     /**
544      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
545      *
546      * This internal function is equivalent to `approve`, and can be used to
547      * e.g. set automatic allowances for certain subsystems, etc.
548      *
549      * Emits an {Approval} event.
550      *
551      * Requirements:
552      *
553      * - `owner` cannot be the zero address.
554      * - `spender` cannot be the zero address.
555      */
556     function _approve(
557         address owner,
558         address spender,
559         uint256 amount
560     ) internal virtual {
561         require(owner != address(0), "ERC20: approve from the zero address");
562         require(spender != address(0), "ERC20: approve to the zero address");
563 
564         _allowances[owner][spender] = amount;
565         emit Approval(owner, spender, amount);
566     }
567 
568     /**
569      * @dev Hook that is called before any transfer of tokens. This includes
570      * minting and burning.
571      *
572      * Calling conditions:
573      *
574      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
575      * will be transferred to `to`.
576      * - when `from` is zero, `amount` tokens will be minted for `to`.
577      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
578      * - `from` and `to` are never both zero.
579      *
580      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
581      */
582     function _beforeTokenTransfer(
583         address from,
584         address to,
585         uint256 amount
586     ) internal virtual {}
587 
588     /**
589      * @dev Hook that is called after any transfer of tokens. This includes
590      * minting and burning.
591      *
592      * Calling conditions:
593      *
594      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
595      * has been transferred to `to`.
596      * - when `from` is zero, `amount` tokens have been minted for `to`.
597      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
598      * - `from` and `to` are never both zero.
599      *
600      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
601      */
602     function _afterTokenTransfer(
603         address from,
604         address to,
605         uint256 amount
606     ) internal virtual {}
607 }
608 
609 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
610 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
611 
612 /* pragma solidity ^0.8.0; */
613 
614 // CAUTION
615 // This version of SafeMath should only be used with Solidity 0.8 or later,
616 // because it relies on the compiler's built in overflow checks.
617 
618 /**
619  * @dev Wrappers over Solidity's arithmetic operations.
620  *
621  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
622  * now has built in overflow checking.
623  */
624 library SafeMath {
625     /**
626      * @dev Returns the addition of two unsigned integers, with an overflow flag.
627      *
628      * _Available since v3.4._
629      */
630     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
631         unchecked {
632             uint256 c = a + b;
633             if (c < a) return (false, 0);
634             return (true, c);
635         }
636     }
637 
638     /**
639      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
640      *
641      * _Available since v3.4._
642      */
643     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
644         unchecked {
645             if (b > a) return (false, 0);
646             return (true, a - b);
647         }
648     }
649 
650     /**
651      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
652      *
653      * _Available since v3.4._
654      */
655     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
656         unchecked {
657             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
658             // benefit is lost if 'b' is also tested.
659             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
660             if (a == 0) return (true, 0);
661             uint256 c = a * b;
662             if (c / a != b) return (false, 0);
663             return (true, c);
664         }
665     }
666 
667     /**
668      * @dev Returns the division of two unsigned integers, with a division by zero flag.
669      *
670      * _Available since v3.4._
671      */
672     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
673         unchecked {
674             if (b == 0) return (false, 0);
675             return (true, a / b);
676         }
677     }
678 
679     /**
680      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
681      *
682      * _Available since v3.4._
683      */
684     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
685         unchecked {
686             if (b == 0) return (false, 0);
687             return (true, a % b);
688         }
689     }
690 
691     /**
692      * @dev Returns the addition of two unsigned integers, reverting on
693      * overflow.
694      *
695      * Counterpart to Solidity's `+` operator.
696      *
697      * Requirements:
698      *
699      * - Addition cannot overflow.
700      */
701     function add(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a + b;
703     }
704 
705     /**
706      * @dev Returns the subtraction of two unsigned integers, reverting on
707      * overflow (when the result is negative).
708      *
709      * Counterpart to Solidity's `-` operator.
710      *
711      * Requirements:
712      *
713      * - Subtraction cannot overflow.
714      */
715     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
716         return a - b;
717     }
718 
719     /**
720      * @dev Returns the multiplication of two unsigned integers, reverting on
721      * overflow.
722      *
723      * Counterpart to Solidity's `*` operator.
724      *
725      * Requirements:
726      *
727      * - Multiplication cannot overflow.
728      */
729     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
730         return a * b;
731     }
732 
733     /**
734      * @dev Returns the integer division of two unsigned integers, reverting on
735      * division by zero. The result is rounded towards zero.
736      *
737      * Counterpart to Solidity's `/` operator.
738      *
739      * Requirements:
740      *
741      * - The divisor cannot be zero.
742      */
743     function div(uint256 a, uint256 b) internal pure returns (uint256) {
744         return a / b;
745     }
746 
747     /**
748      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
749      * reverting when dividing by zero.
750      *
751      * Counterpart to Solidity's `%` operator. This function uses a `revert`
752      * opcode (which leaves remaining gas untouched) while Solidity uses an
753      * invalid opcode to revert (consuming all remaining gas).
754      *
755      * Requirements:
756      *
757      * - The divisor cannot be zero.
758      */
759     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
760         return a % b;
761     }
762 
763     /**
764      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
765      * overflow (when the result is negative).
766      *
767      * CAUTION: This function is deprecated because it requires allocating memory for the error
768      * message unnecessarily. For custom revert reasons use {trySub}.
769      *
770      * Counterpart to Solidity's `-` operator.
771      *
772      * Requirements:
773      *
774      * - Subtraction cannot overflow.
775      */
776     function sub(
777         uint256 a,
778         uint256 b,
779         string memory errorMessage
780     ) internal pure returns (uint256) {
781         unchecked {
782             require(b <= a, errorMessage);
783             return a - b;
784         }
785     }
786 
787     /**
788      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
789      * division by zero. The result is rounded towards zero.
790      *
791      * Counterpart to Solidity's `/` operator. Note: this function uses a
792      * `revert` opcode (which leaves remaining gas untouched) while Solidity
793      * uses an invalid opcode to revert (consuming all remaining gas).
794      *
795      * Requirements:
796      *
797      * - The divisor cannot be zero.
798      */
799     function div(
800         uint256 a,
801         uint256 b,
802         string memory errorMessage
803     ) internal pure returns (uint256) {
804         unchecked {
805             require(b > 0, errorMessage);
806             return a / b;
807         }
808     }
809 
810     /**
811      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
812      * reverting with custom message when dividing by zero.
813      *
814      * CAUTION: This function is deprecated because it requires allocating memory for the error
815      * message unnecessarily. For custom revert reasons use {tryMod}.
816      *
817      * Counterpart to Solidity's `%` operator. This function uses a `revert`
818      * opcode (which leaves remaining gas untouched) while Solidity uses an
819      * invalid opcode to revert (consuming all remaining gas).
820      *
821      * Requirements:
822      *
823      * - The divisor cannot be zero.
824      */
825     function mod(
826         uint256 a,
827         uint256 b,
828         string memory errorMessage
829     ) internal pure returns (uint256) {
830         unchecked {
831             require(b > 0, errorMessage);
832             return a % b;
833         }
834     }
835 }
836 
837 /* pragma solidity 0.8.10; */
838 /* pragma experimental ABIEncoderV2; */
839 
840 interface IUniswapV2Factory {
841     event PairCreated(
842         address indexed token0,
843         address indexed token1,
844         address pair,
845         uint256
846     );
847 
848     function feeTo() external view returns (address);
849 
850     function feeToSetter() external view returns (address);
851 
852     function getPair(address tokenA, address tokenB)
853         external
854         view
855         returns (address pair);
856 
857     function allPairs(uint256) external view returns (address pair);
858 
859     function allPairsLength() external view returns (uint256);
860 
861     function createPair(address tokenA, address tokenB)
862         external
863         returns (address pair);
864 
865     function setFeeTo(address) external;
866 
867     function setFeeToSetter(address) external;
868 }
869 
870 /* pragma solidity 0.8.10; */
871 /* pragma experimental ABIEncoderV2; */ 
872 
873 interface IUniswapV2Pair {
874     event Approval(
875         address indexed owner,
876         address indexed spender,
877         uint256 value
878     );
879     event Transfer(address indexed from, address indexed to, uint256 value);
880 
881     function name() external pure returns (string memory);
882 
883     function symbol() external pure returns (string memory);
884 
885     function decimals() external pure returns (uint8);
886 
887     function totalSupply() external view returns (uint256);
888 
889     function balanceOf(address owner) external view returns (uint256);
890 
891     function allowance(address owner, address spender)
892         external
893         view
894         returns (uint256);
895 
896     function approve(address spender, uint256 value) external returns (bool);
897 
898     function transfer(address to, uint256 value) external returns (bool);
899 
900     function transferFrom(
901         address from,
902         address to,
903         uint256 value
904     ) external returns (bool);
905 
906     function DOMAIN_SEPARATOR() external view returns (bytes32);
907 
908     function PERMIT_TYPEHASH() external pure returns (bytes32);
909 
910     function nonces(address owner) external view returns (uint256);
911 
912     function permit(
913         address owner,
914         address spender,
915         uint256 value,
916         uint256 deadline,
917         uint8 v,
918         bytes32 r,
919         bytes32 s
920     ) external;
921 
922     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
923     event Burn(
924         address indexed sender,
925         uint256 amount0,
926         uint256 amount1,
927         address indexed to
928     );
929     event Swap(
930         address indexed sender,
931         uint256 amount0In,
932         uint256 amount1In,
933         uint256 amount0Out,
934         uint256 amount1Out,
935         address indexed to
936     );
937     event Sync(uint112 reserve0, uint112 reserve1);
938 
939     function MINIMUM_LIQUIDITY() external pure returns (uint256);
940 
941     function factory() external view returns (address);
942 
943     function token0() external view returns (address);
944 
945     function token1() external view returns (address);
946 
947     function getReserves()
948         external
949         view
950         returns (
951             uint112 reserve0,
952             uint112 reserve1,
953             uint32 blockTimestampLast
954         );
955 
956     function price0CumulativeLast() external view returns (uint256);
957 
958     function price1CumulativeLast() external view returns (uint256);
959 
960     function kLast() external view returns (uint256);
961 
962     function mint(address to) external returns (uint256 liquidity);
963 
964     function burn(address to)
965         external
966         returns (uint256 amount0, uint256 amount1);
967 
968     function swap(
969         uint256 amount0Out,
970         uint256 amount1Out,
971         address to,
972         bytes calldata data
973     ) external;
974 
975     function skim(address to) external;
976 
977     function sync() external;
978 
979     function initialize(address, address) external;
980 }
981 
982 /* pragma solidity 0.8.10; */
983 /* pragma experimental ABIEncoderV2; */
984 
985 interface IUniswapV2Router02 {
986     function factory() external pure returns (address);
987 
988     function WETH() external pure returns (address);
989 
990     function addLiquidity(
991         address tokenA,
992         address tokenB,
993         uint256 amountADesired,
994         uint256 amountBDesired,
995         uint256 amountAMin,
996         uint256 amountBMin,
997         address to,
998         uint256 deadline
999     )
1000         external
1001         returns (
1002             uint256 amountA,
1003             uint256 amountB,
1004             uint256 liquidity
1005         );
1006 
1007     function addLiquidityETH(
1008         address token,
1009         uint256 amountTokenDesired,
1010         uint256 amountTokenMin,
1011         uint256 amountETHMin,
1012         address to,
1013         uint256 deadline
1014     )
1015         external
1016         payable
1017         returns (
1018             uint256 amountToken,
1019             uint256 amountETH,
1020             uint256 liquidity
1021         );
1022 
1023     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1024         uint256 amountIn,
1025         uint256 amountOutMin,
1026         address[] calldata path,
1027         address to,
1028         uint256 deadline
1029     ) external;
1030 
1031     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1032         uint256 amountOutMin,
1033         address[] calldata path,
1034         address to,
1035         uint256 deadline
1036     ) external payable;
1037 
1038     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1039         uint256 amountIn,
1040         uint256 amountOutMin,
1041         address[] calldata path,
1042         address to,
1043         uint256 deadline
1044     ) external;
1045 }
1046 
1047 /* pragma solidity >=0.8.10; */
1048 
1049 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1050 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1051 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1052 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1053 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1054 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1055 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1056 
1057 contract GODCANDLE is ERC20, Ownable {
1058     using SafeMath for uint256;
1059 
1060     IUniswapV2Router02 public immutable uniswapV2Router;
1061     address public immutable uniswapV2Pair;
1062     address public constant deadAddress = address(0xdead);
1063 
1064     bool private swapping;
1065 
1066 	address public charityWallet;
1067     address public marketingWallet;
1068     address public devWallet;
1069 
1070     uint256 public maxTransactionAmount;
1071     uint256 public swapTokensAtAmount;
1072     uint256 public maxWallet;
1073 
1074     bool public limitsInEffect = true;
1075     bool public tradingActive = true;
1076     bool public swapEnabled = true;
1077 
1078     // Anti-bot and anti-whale mappings and variables
1079     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1080     bool public transferDelayEnabled = true;
1081 
1082     uint256 public buyTotalFees;
1083 	uint256 public buyCharityFee;
1084     uint256 public buyMarketingFee;
1085     uint256 public buyLiquidityFee;
1086     uint256 public buyDevFee;
1087 
1088     uint256 public sellTotalFees;
1089 	uint256 public sellCharityFee;
1090     uint256 public sellMarketingFee;
1091     uint256 public sellLiquidityFee;
1092     uint256 public sellDevFee;
1093 
1094 	uint256 public tokensForCharity;
1095     uint256 public tokensForMarketing;
1096     uint256 public tokensForLiquidity;
1097     uint256 public tokensForDev;
1098 
1099     /******************/
1100 
1101     // exlcude from fees and max transaction amount
1102     mapping(address => bool) private _isExcludedFromFees;
1103     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1104 
1105     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1106     // could be subject to a maximum transfer amount
1107     mapping(address => bool) public automatedMarketMakerPairs;
1108 
1109     event UpdateUniswapV2Router(
1110         address indexed newAddress,
1111         address indexed oldAddress
1112     );
1113 
1114     event ExcludeFromFees(address indexed account, bool isExcluded);
1115 
1116     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1117 
1118     event SwapAndLiquify(
1119         uint256 tokensSwapped,
1120         uint256 ethReceived,
1121         uint256 tokensIntoLiquidity
1122     );
1123 
1124     constructor() ERC20("God Candle", "GODCANDLE") {
1125         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1126             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1127         );
1128 
1129         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1130         uniswapV2Router = _uniswapV2Router;
1131 
1132         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1133             .createPair(address(this), _uniswapV2Router.WETH());
1134         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1135         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1136 
1137 		uint256 _buyCharityFee = 12;
1138         uint256 _buyMarketingFee = 12;
1139         uint256 _buyLiquidityFee = 0;
1140         uint256 _buyDevFee = 0;
1141 
1142 		uint256 _sellCharityFee = 12;
1143         uint256 _sellMarketingFee = 12;
1144         uint256 _sellLiquidityFee = 0;
1145         uint256 _sellDevFee = 0;
1146 
1147         uint256 totalSupply = 100000000000000 * 1e18;
1148 
1149         maxTransactionAmount = 3000000000000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1150         maxWallet = 3000000000000 * 1e18; // 2% from total supply maxWallet
1151         swapTokensAtAmount = (totalSupply * 10) / 10000; // 0.1% swap wallet
1152 
1153 		buyCharityFee = _buyCharityFee;
1154         buyMarketingFee = _buyMarketingFee;
1155         buyLiquidityFee = _buyLiquidityFee;
1156         buyDevFee = _buyDevFee;
1157         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1158 
1159 		sellCharityFee = _sellCharityFee;
1160         sellMarketingFee = _sellMarketingFee;
1161         sellLiquidityFee = _sellLiquidityFee;
1162         sellDevFee = _sellDevFee;
1163         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1164 
1165 		charityWallet = address(0x863C6867142F5Ba60408Ea4c5305e47922A17f67); // set as charity wallet
1166         marketingWallet = address(0x443edc3C37da9B721b5C5222e2785c1d9269861a); // set as marketing wallet
1167         devWallet = address(0x443edc3C37da9B721b5C5222e2785c1d9269861a); // set as dev wallet
1168 
1169         // exclude from paying fees or having max transaction amount
1170         excludeFromFees(owner(), true);
1171         excludeFromFees(address(this), true);
1172         excludeFromFees(address(0xdead), true);
1173 
1174         excludeFromMaxTransaction(owner(), true);
1175         excludeFromMaxTransaction(address(this), true);
1176         excludeFromMaxTransaction(address(0xdead), true);
1177 
1178         /*
1179             _mint is an internal function in ERC20.sol that is only called here,
1180             and CANNOT be called ever again
1181         */
1182         _mint(msg.sender, totalSupply);
1183     }
1184 
1185     receive() external payable {}
1186 
1187     // once enabled, can never be turned off
1188     function enableTrading() external onlyOwner {
1189         tradingActive = true;
1190         swapEnabled = true;
1191     }
1192 
1193     // remove limits after token is stable
1194     function removeLimits() external onlyOwner returns (bool) {
1195         limitsInEffect = false;
1196         return true;
1197     }
1198 
1199     // disable Transfer delay - cannot be reenabled
1200     function disableTransferDelay() external onlyOwner returns (bool) {
1201         transferDelayEnabled = false;
1202         return true;
1203     }
1204 
1205     // change the minimum amount of tokens to sell from fees
1206     function updateSwapTokensAtAmount(uint256 newAmount)
1207         external
1208         onlyOwner
1209         returns (bool)
1210     {
1211         require(
1212             newAmount >= (totalSupply() * 1) / 100000,
1213             "Swap amount cannot be lower than 0.001% total supply."
1214         );
1215         require(
1216             newAmount <= (totalSupply() * 5) / 1000,
1217             "Swap amount cannot be higher than 0.5% total supply."
1218         );
1219         swapTokensAtAmount = newAmount;
1220         return true;
1221     }
1222 
1223     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1224         require(
1225             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1226             "Cannot set maxTransactionAmount lower than 0.5%"
1227         );
1228         maxTransactionAmount = newNum * (10**18);
1229     }
1230 
1231     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1232         require(
1233             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1234             "Cannot set maxWallet lower than 0.5%"
1235         );
1236         maxWallet = newNum * (10**18);
1237     }
1238 	
1239     function excludeFromMaxTransaction(address updAds, bool isEx)
1240         public
1241         onlyOwner
1242     {
1243         _isExcludedMaxTransactionAmount[updAds] = isEx;
1244     }
1245 
1246     // only use to disable contract sales if absolutely necessary (emergency use only)
1247     function updateSwapEnabled(bool enabled) external onlyOwner {
1248         swapEnabled = enabled;
1249     }
1250 
1251     function updateBuyFees(
1252 		uint256 _charityFee,
1253         uint256 _marketingFee,
1254         uint256 _liquidityFee,
1255         uint256 _devFee
1256     ) external onlyOwner {
1257 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max BuyFee 10%");
1258 		buyCharityFee = _charityFee;
1259         buyMarketingFee = _marketingFee;
1260         buyLiquidityFee = _liquidityFee;
1261         buyDevFee = _devFee;
1262         buyTotalFees = buyCharityFee + buyMarketingFee + buyLiquidityFee + buyDevFee;
1263      }
1264 
1265     function updateSellFees(
1266 		uint256 _charityFee,
1267         uint256 _marketingFee,
1268         uint256 _liquidityFee,
1269         uint256 _devFee
1270     ) external onlyOwner {
1271 		require((_charityFee + _marketingFee + _liquidityFee + _devFee) <= 10, "Max SellFee 10%");
1272 		sellCharityFee = _charityFee;
1273         sellMarketingFee = _marketingFee;
1274         sellLiquidityFee = _liquidityFee;
1275         sellDevFee = _devFee;
1276         sellTotalFees = sellCharityFee + sellMarketingFee + sellLiquidityFee + sellDevFee;
1277     }
1278 
1279     function excludeFromFees(address account, bool excluded) public onlyOwner {
1280         _isExcludedFromFees[account] = excluded;
1281         emit ExcludeFromFees(account, excluded);
1282     }
1283 
1284     function setAutomatedMarketMakerPair(address pair, bool value)
1285         public
1286         onlyOwner
1287     {
1288         require(
1289             pair != uniswapV2Pair,
1290             "The pair cannot be removed from automatedMarketMakerPairs"
1291         );
1292 
1293         _setAutomatedMarketMakerPair(pair, value);
1294     }
1295 
1296     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1297         automatedMarketMakerPairs[pair] = value;
1298 
1299         emit SetAutomatedMarketMakerPair(pair, value);
1300     }
1301 
1302     function isExcludedFromFees(address account) public view returns (bool) {
1303         return _isExcludedFromFees[account];
1304     }
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
1401         bool takeFee = !swapping;
1402 
1403         // if any account belongs to _isExcludedFromFee account then remove the fee
1404         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1405             takeFee = false;
1406         }
1407 
1408         uint256 fees = 0;
1409         // only take fees on buys/sells, do not take on wallet transfers
1410         if (takeFee) {
1411             // on sell
1412             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1413                 fees = amount.mul(sellTotalFees).div(100);
1414 				tokensForCharity += (fees * sellCharityFee) / sellTotalFees;
1415                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1416                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1417                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1418             }
1419             // on buy
1420             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1421                 fees = amount.mul(buyTotalFees).div(100);
1422 				tokensForCharity += (fees * buyCharityFee) / buyTotalFees;
1423                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1424                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1425                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1426             }
1427 
1428             if (fees > 0) {
1429                 super._transfer(from, address(this), fees);
1430             }
1431 
1432             amount -= fees;
1433         }
1434 
1435         super._transfer(from, to, amount);
1436     }
1437 
1438     function swapTokensForEth(uint256 tokenAmount) private {
1439         // generate the uniswap pair path of token -> weth
1440         address[] memory path = new address[](2);
1441         path[0] = address(this);
1442         path[1] = uniswapV2Router.WETH();
1443 
1444         _approve(address(this), address(uniswapV2Router), tokenAmount);
1445 
1446         // make the swap
1447         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1448             tokenAmount,
1449             0, // accept any amount of ETH
1450             path,
1451             address(this),
1452             block.timestamp
1453         );
1454     }
1455 
1456     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1457         // approve token transfer to cover all possible scenarios
1458         _approve(address(this), address(uniswapV2Router), tokenAmount);
1459 
1460         // add the liquidity
1461         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1462             address(this),
1463             tokenAmount,
1464             0, // slippage is unavoidable
1465             0, // slippage is unavoidable
1466             devWallet,
1467             block.timestamp
1468         );
1469     }
1470 
1471     function swapBack() private {
1472         uint256 contractBalance = balanceOf(address(this));
1473         uint256 totalTokensToSwap = tokensForCharity + tokensForLiquidity + tokensForMarketing + tokensForDev;
1474         bool success;
1475 
1476         if (contractBalance == 0 || totalTokensToSwap == 0) {
1477             return;
1478         }
1479 
1480         if (contractBalance > swapTokensAtAmount * 20) {
1481             contractBalance = swapTokensAtAmount * 20;
1482         }
1483 
1484         // Halve the amount of liquidity tokens
1485         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) / totalTokensToSwap / 2;
1486         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1487 
1488         uint256 initialETHBalance = address(this).balance;
1489 
1490         swapTokensForEth(amountToSwapForETH);
1491 
1492         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1493 
1494 		uint256 ethForCharity = ethBalance.mul(tokensForCharity).div(totalTokensToSwap);
1495         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1496         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1497 
1498         uint256 ethForLiquidity = ethBalance - ethForCharity - ethForMarketing - ethForDev;
1499 
1500         tokensForLiquidity = 0;
1501 		tokensForCharity = 0;
1502         tokensForMarketing = 0;
1503         tokensForDev = 0;
1504 
1505         (success, ) = address(devWallet).call{value: ethForDev}("");
1506         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1507 
1508 
1509         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1510             addLiquidity(liquidityTokens, ethForLiquidity);
1511             emit SwapAndLiquify(
1512                 amountToSwapForETH,
1513                 ethForLiquidity,
1514                 tokensForLiquidity
1515             );
1516         }
1517 
1518         (success, ) = address(charityWallet).call{value: address(this).balance}("");
1519     }
1520 
1521 }