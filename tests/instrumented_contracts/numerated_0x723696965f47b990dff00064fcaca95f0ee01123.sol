1 /**
2     AlphaRadarBot
3     Find out the next 100X alpha project with Alpha Radar Bot
4     
5     Website: alpharadarbot.xyz/
6     Twitter: twitter.com/alpharadarbot
7     Telegram: t.me/alpharadarbot_chat
8     White paper: alpha-radar-bot.gitbook.io/doc/
9 **/
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity 0.8.20;
13 pragma experimental ABIEncoderV2;
14 
15 /**
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes calldata) {
31         return msg.data;
32     }
33 }
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
106 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
107 
108 /* pragma solidity ^0.8.0; */
109 
110 /**
111  * @dev Interface of the ERC20 standard as defined in the EIP.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through {transferFrom}. This is
136      * zero by default.
137      *
138      * This value changes when {approve} or {transferFrom} are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(
168         address sender,
169         address recipient,
170         uint256 amount
171     ) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to {approve}. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
189 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
190 
191 /* pragma solidity ^0.8.0; */
192 
193 /* import "../IERC20.sol"; */
194 
195 /**
196  * @dev Interface for the optional metadata functions from the ERC20 standard.
197  *
198  * _Available since v4.1._
199  */
200 interface IERC20Metadata is IERC20 {
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the symbol of the token.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the decimals places of the token.
213      */
214     function decimals() external view returns (uint8);
215 }
216 
217 /**
218  * @dev Implementation of the {IERC20} interface.
219  *
220  * This implementation is agnostic to the way tokens are created. This means
221  * that a supply mechanism has to be added in a derived contract using {_mint}.
222  * For a generic mechanism see {ERC20PresetMinterPauser}.
223  *
224  * TIP: For a detailed writeup see our guide
225  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
226  * to implement supply mechanisms].
227  *
228  * We have followed general OpenZeppelin Contracts guidelines: functions revert
229  * instead returning `false` on failure. This behavior is nonetheless
230  * conventional and does not conflict with the expectations of ERC20
231  * applications.
232  *
233  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
234  * This allows applications to reconstruct the allowance for all accounts just
235  * by listening to said events. Other implementations of the EIP may not emit
236  * these events, as it isn't required by the specification.
237  *
238  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
239  * functions have been added to mitigate the well-known issues around setting
240  * allowances. See {IERC20-approve}.
241  */
242 contract ERC20 is Context, IERC20, IERC20Metadata {
243     mapping(address => uint256) private _balances;
244 
245     mapping(address => mapping(address => uint256)) private _allowances;
246 
247     uint256 private _totalSupply;
248 
249     string private _name;
250     string private _symbol;
251 
252     /**
253      * @dev Sets the values for {name} and {symbol}.
254      *
255      * The default value of {decimals} is 18. To select a different value for
256      * {decimals} you should overload it.
257      *
258      * All two of these values are immutable: they can only be set once during
259      * construction.
260      */
261     constructor(string memory name_, string memory symbol_) {
262         _name = name_;
263         _symbol = symbol_;
264     }
265 
266     /**
267      * @dev Returns the name of the token.
268      */
269     function name() public view virtual override returns (string memory) {
270         return _name;
271     }
272 
273     /**
274      * @dev Returns the symbol of the token, usually a shorter version of the
275      * name.
276      */
277     function symbol() public view virtual override returns (string memory) {
278         return _symbol;
279     }
280 
281     /**
282      * @dev Returns the number of decimals used to get its user representation.
283      * For example, if `decimals` equals `2`, a balance of `505` tokens should
284      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
285      *
286      * Tokens usually opt for a value of 18, imitating the relationship between
287      * Ether and Wei. This is the value {ERC20} uses, unless this function is
288      * overridden;
289      *
290      * NOTE: This information is only used for _display_ purposes: it in
291      * no way affects any of the arithmetic of the contract, including
292      * {IERC20-balanceOf} and {IERC20-transfer}.
293      */
294     function decimals() public view virtual override returns (uint8) {
295         return 18;
296     }
297 
298     /**
299      * @dev See {IERC20-totalSupply}.
300      */
301     function totalSupply() public view virtual override returns (uint256) {
302         return _totalSupply;
303     }
304 
305     /**
306      * @dev See {IERC20-balanceOf}.
307      */
308     function balanceOf(address account) public view virtual override returns (uint256) {
309         return _balances[account];
310     }
311 
312     /**
313      * @dev See {IERC20-transfer}.
314      *
315      * Requirements:
316      *
317      * - `recipient` cannot be the zero address.
318      * - the caller must have a balance of at least `amount`.
319      */
320     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
321         _transfer(_msgSender(), recipient, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-allowance}.
327      */
328     function allowance(address owner, address spender) public view virtual override returns (uint256) {
329         return _allowances[owner][spender];
330     }
331 
332     /**
333      * @dev See {IERC20-approve}.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 amount) public virtual override returns (bool) {
340         _approve(_msgSender(), spender, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-transferFrom}.
346      *
347      * Emits an {Approval} event indicating the updated allowance. This is not
348      * required by the EIP. See the note at the beginning of {ERC20}.
349      *
350      * Requirements:
351      *
352      * - `sender` and `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      * - the caller must have allowance for ``sender``'s tokens of at least
355      * `amount`.
356      */
357     function transferFrom(
358         address sender,
359         address recipient,
360         uint256 amount
361     ) public virtual override returns (bool) {
362         _transfer(sender, recipient, amount);
363 
364         uint256 currentAllowance = _allowances[sender][_msgSender()];
365         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
366         unchecked {
367             _approve(sender, _msgSender(), currentAllowance - amount);
368         }
369 
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
405         uint256 currentAllowance = _allowances[_msgSender()][spender];
406         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
407         unchecked {
408             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
409         }
410 
411         return true;
412     }
413 
414     /**
415      * @dev Moves `amount` of tokens from `sender` to `recipient`.
416      *
417      * This internal function is equivalent to {transfer}, and can be used to
418      * e.g. implement automatic token fees, slashing mechanisms, etc.
419      *
420      * Emits a {Transfer} event.
421      *
422      * Requirements:
423      *
424      * - `sender` cannot be the zero address.
425      * - `recipient` cannot be the zero address.
426      * - `sender` must have a balance of at least `amount`.
427      */
428     function _transfer(
429         address sender,
430         address recipient,
431         uint256 amount
432     ) internal virtual {
433         require(sender != address(0), "ERC20: transfer from the zero address");
434         require(recipient != address(0), "ERC20: transfer to the zero address");
435 
436         _beforeTokenTransfer(sender, recipient, amount);
437 
438         uint256 senderBalance = _balances[sender];
439         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
440         unchecked {
441             _balances[sender] = senderBalance - amount;
442         }
443         _balances[recipient] += amount;
444 
445         emit Transfer(sender, recipient, amount);
446 
447         _afterTokenTransfer(sender, recipient, amount);
448     }
449 
450     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
451      * the total supply.
452      *
453      * Emits a {Transfer} event with `from` set to the zero address.
454      *
455      * Requirements:
456      *
457      * - `account` cannot be the zero address.
458      */
459     function _mint(address account, uint256 amount) internal virtual {
460         require(account != address(0), "ERC20: mint to the zero address");
461 
462         _beforeTokenTransfer(address(0), account, amount);
463 
464         _totalSupply += amount;
465         _balances[account] += amount;
466         emit Transfer(address(0), account, amount);
467 
468         _afterTokenTransfer(address(0), account, amount);
469     }
470 
471     /**
472      * @dev Destroys `amount` tokens from `account`, reducing the
473      * total supply.
474      *
475      * Emits a {Transfer} event with `to` set to the zero address.
476      *
477      * Requirements:
478      *
479      * - `account` cannot be the zero address.
480      * - `account` must have at least `amount` tokens.
481      */
482     function _burn(address account, uint256 amount) internal virtual {
483         require(account != address(0), "ERC20: burn from the zero address");
484 
485         _beforeTokenTransfer(account, address(0), amount);
486 
487         uint256 accountBalance = _balances[account];
488         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
489         unchecked {
490             _balances[account] = accountBalance - amount;
491         }
492         _totalSupply -= amount;
493 
494         emit Transfer(account, address(0), amount);
495 
496         _afterTokenTransfer(account, address(0), amount);
497     }
498 
499     /**
500      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
501      *
502      * This internal function is equivalent to `approve`, and can be used to
503      * e.g. set automatic allowances for certain subsystems, etc.
504      *
505      * Emits an {Approval} event.
506      *
507      * Requirements:
508      *
509      * - `owner` cannot be the zero address.
510      * - `spender` cannot be the zero address.
511      */
512     function _approve(
513         address owner,
514         address spender,
515         uint256 amount
516     ) internal virtual {
517         require(owner != address(0), "ERC20: approve from the zero address");
518         require(spender != address(0), "ERC20: approve to the zero address");
519 
520         _allowances[owner][spender] = amount;
521         emit Approval(owner, spender, amount);
522     }
523 
524     /**
525      * @dev Hook that is called before any transfer of tokens. This includes
526      * minting and burning.
527      *
528      * Calling conditions:
529      *
530      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
531      * will be transferred to `to`.
532      * - when `from` is zero, `amount` tokens will be minted for `to`.
533      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
534      * - `from` and `to` are never both zero.
535      *
536      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
537      */
538     function _beforeTokenTransfer(
539         address from,
540         address to,
541         uint256 amount
542     ) internal virtual {}
543 
544     /**
545      * @dev Hook that is called after any transfer of tokens. This includes
546      * minting and burning.
547      *
548      * Calling conditions:
549      *
550      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
551      * has been transferred to `to`.
552      * - when `from` is zero, `amount` tokens have been minted for `to`.
553      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
554      * - `from` and `to` are never both zero.
555      *
556      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
557      */
558     function _afterTokenTransfer(
559         address from,
560         address to,
561         uint256 amount
562     ) internal virtual {}
563 }
564 
565 /**
566  * @dev Wrappers over Solidity's arithmetic operations.
567  *
568  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
569  * now has built in overflow checking.
570  */
571 library SafeMath {
572     /**
573      * @dev Returns the addition of two unsigned integers, with an overflow flag.
574      *
575      * _Available since v3.4._
576      */
577     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
578         unchecked {
579             uint256 c = a + b;
580             if (c < a) return (false, 0);
581             return (true, c);
582         }
583     }
584 
585     /**
586      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
587      *
588      * _Available since v3.4._
589      */
590     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
591         unchecked {
592             if (b > a) return (false, 0);
593             return (true, a - b);
594         }
595     }
596 
597     /**
598      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
599      *
600      * _Available since v3.4._
601      */
602     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
603         unchecked {
604             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
605             // benefit is lost if 'b' is also tested.
606             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
607             if (a == 0) return (true, 0);
608             uint256 c = a * b;
609             if (c / a != b) return (false, 0);
610             return (true, c);
611         }
612     }
613 
614     /**
615      * @dev Returns the division of two unsigned integers, with a division by zero flag.
616      *
617      * _Available since v3.4._
618      */
619     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             if (b == 0) return (false, 0);
622             return (true, a / b);
623         }
624     }
625 
626     /**
627      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
628      *
629      * _Available since v3.4._
630      */
631     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
632         unchecked {
633             if (b == 0) return (false, 0);
634             return (true, a % b);
635         }
636     }
637 
638     /**
639      * @dev Returns the addition of two unsigned integers, reverting on
640      * overflow.
641      *
642      * Counterpart to Solidity's `+` operator.
643      *
644      * Requirements:
645      *
646      * - Addition cannot overflow.
647      */
648     function add(uint256 a, uint256 b) internal pure returns (uint256) {
649         return a + b;
650     }
651 
652     /**
653      * @dev Returns the subtraction of two unsigned integers, reverting on
654      * overflow (when the result is negative).
655      *
656      * Counterpart to Solidity's `-` operator.
657      *
658      * Requirements:
659      *
660      * - Subtraction cannot overflow.
661      */
662     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
663         return a - b;
664     }
665 
666     /**
667      * @dev Returns the multiplication of two unsigned integers, reverting on
668      * overflow.
669      *
670      * Counterpart to Solidity's `*` operator.
671      *
672      * Requirements:
673      *
674      * - Multiplication cannot overflow.
675      */
676     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
677         return a * b;
678     }
679 
680     /**
681      * @dev Returns the integer division of two unsigned integers, reverting on
682      * division by zero. The result is rounded towards zero.
683      *
684      * Counterpart to Solidity's `/` operator.
685      *
686      * Requirements:
687      *
688      * - The divisor cannot be zero.
689      */
690     function div(uint256 a, uint256 b) internal pure returns (uint256) {
691         return a / b;
692     }
693 
694     /**
695      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
696      * reverting when dividing by zero.
697      *
698      * Counterpart to Solidity's `%` operator. This function uses a `revert`
699      * opcode (which leaves remaining gas untouched) while Solidity uses an
700      * invalid opcode to revert (consuming all remaining gas).
701      *
702      * Requirements:
703      *
704      * - The divisor cannot be zero.
705      */
706     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
707         return a % b;
708     }
709 
710     /**
711      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
712      * overflow (when the result is negative).
713      *
714      * CAUTION: This function is deprecated because it requires allocating memory for the error
715      * message unnecessarily. For custom revert reasons use {trySub}.
716      *
717      * Counterpart to Solidity's `-` operator.
718      *
719      * Requirements:
720      *
721      * - Subtraction cannot overflow.
722      */
723     function sub(
724         uint256 a,
725         uint256 b,
726         string memory errorMessage
727     ) internal pure returns (uint256) {
728         unchecked {
729             require(b <= a, errorMessage);
730             return a - b;
731         }
732     }
733 
734     /**
735      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
736      * division by zero. The result is rounded towards zero.
737      *
738      * Counterpart to Solidity's `/` operator. Note: this function uses a
739      * `revert` opcode (which leaves remaining gas untouched) while Solidity
740      * uses an invalid opcode to revert (consuming all remaining gas).
741      *
742      * Requirements:
743      *
744      * - The divisor cannot be zero.
745      */
746     function div(
747         uint256 a,
748         uint256 b,
749         string memory errorMessage
750     ) internal pure returns (uint256) {
751         unchecked {
752             require(b > 0, errorMessage);
753             return a / b;
754         }
755     }
756 
757     /**
758      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
759      * reverting with custom message when dividing by zero.
760      *
761      * CAUTION: This function is deprecated because it requires allocating memory for the error
762      * message unnecessarily. For custom revert reasons use {tryMod}.
763      *
764      * Counterpart to Solidity's `%` operator. This function uses a `revert`
765      * opcode (which leaves remaining gas untouched) while Solidity uses an
766      * invalid opcode to revert (consuming all remaining gas).
767      *
768      * Requirements:
769      *
770      * - The divisor cannot be zero.
771      */
772     function mod(
773         uint256 a,
774         uint256 b,
775         string memory errorMessage
776     ) internal pure returns (uint256) {
777         unchecked {
778             require(b > 0, errorMessage);
779             return a % b;
780         }
781     }
782 }
783 
784 interface IUniswapV2Factory {
785     event PairCreated(
786         address indexed token0,
787         address indexed token1,
788         address pair,
789         uint256
790     );
791 
792     function feeTo() external view returns (address);
793 
794     function feeToSetter() external view returns (address);
795 
796     function getPair(address tokenA, address tokenB)
797         external
798         view
799         returns (address pair);
800 
801     function allPairs(uint256) external view returns (address pair);
802 
803     function allPairsLength() external view returns (uint256);
804 
805     function createPair(address tokenA, address tokenB)
806         external
807         returns (address pair);
808 
809     function setFeeTo(address) external;
810 
811     function setFeeToSetter(address) external;
812 }
813 
814 ////// src/IUniswapV2Pair.sol
815 /* pragma solidity 0.8.10; */
816 /* pragma experimental ABIEncoderV2; */
817 
818 interface IUniswapV2Pair {
819     event Approval(
820         address indexed owner,
821         address indexed spender,
822         uint256 value
823     );
824     event Transfer(address indexed from, address indexed to, uint256 value);
825 
826     function name() external pure returns (string memory);
827 
828     function symbol() external pure returns (string memory);
829 
830     function decimals() external pure returns (uint8);
831 
832     function totalSupply() external view returns (uint256);
833 
834     function balanceOf(address owner) external view returns (uint256);
835 
836     function allowance(address owner, address spender)
837         external
838         view
839         returns (uint256);
840 
841     function approve(address spender, uint256 value) external returns (bool);
842 
843     function transfer(address to, uint256 value) external returns (bool);
844 
845     function transferFrom(
846         address from,
847         address to,
848         uint256 value
849     ) external returns (bool);
850 
851     function DOMAIN_SEPARATOR() external view returns (bytes32);
852 
853     function PERMIT_TYPEHASH() external pure returns (bytes32);
854 
855     function nonces(address owner) external view returns (uint256);
856 
857     function permit(
858         address owner,
859         address spender,
860         uint256 value,
861         uint256 deadline,
862         uint8 v,
863         bytes32 r,
864         bytes32 s
865     ) external;
866 
867     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
868     event Burn(
869         address indexed sender,
870         uint256 amount0,
871         uint256 amount1,
872         address indexed to
873     );
874     event Swap(
875         address indexed sender,
876         uint256 amount0In,
877         uint256 amount1In,
878         uint256 amount0Out,
879         uint256 amount1Out,
880         address indexed to
881     );
882     event Sync(uint112 reserve0, uint112 reserve1);
883 
884     function MINIMUM_LIQUIDITY() external pure returns (uint256);
885 
886     function factory() external view returns (address);
887 
888     function token0() external view returns (address);
889 
890     function token1() external view returns (address);
891 
892     function getReserves()
893         external
894         view
895         returns (
896             uint112 reserve0,
897             uint112 reserve1,
898             uint32 blockTimestampLast
899         );
900 
901     function price0CumulativeLast() external view returns (uint256);
902 
903     function price1CumulativeLast() external view returns (uint256);
904 
905     function kLast() external view returns (uint256);
906 
907     function mint(address to) external returns (uint256 liquidity);
908 
909     function burn(address to)
910         external
911         returns (uint256 amount0, uint256 amount1);
912 
913     function swap(
914         uint256 amount0Out,
915         uint256 amount1Out,
916         address to,
917         bytes calldata data
918     ) external;
919 
920     function skim(address to) external;
921 
922     function sync() external;
923 
924     function initialize(address, address) external;
925 }
926 
927 interface IUniswapV2Router02 {
928     function factory() external pure returns (address);
929 
930     function WETH() external pure returns (address);
931 
932     function addLiquidity(
933         address tokenA,
934         address tokenB,
935         uint256 amountADesired,
936         uint256 amountBDesired,
937         uint256 amountAMin,
938         uint256 amountBMin,
939         address to,
940         uint256 deadline
941     )
942         external
943         returns (
944             uint256 amountA,
945             uint256 amountB,
946             uint256 liquidity
947         );
948 
949     function addLiquidityETH(
950         address token,
951         uint256 amountTokenDesired,
952         uint256 amountTokenMin,
953         uint256 amountETHMin,
954         address to,
955         uint256 deadline
956     )
957         external
958         payable
959         returns (
960             uint256 amountToken,
961             uint256 amountETH,
962             uint256 liquidity
963         );
964 
965     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
966         uint256 amountIn,
967         uint256 amountOutMin,
968         address[] calldata path,
969         address to,
970         uint256 deadline
971     ) external;
972 
973     function swapExactETHForTokensSupportingFeeOnTransferTokens(
974         uint256 amountOutMin,
975         address[] calldata path,
976         address to,
977         uint256 deadline
978     ) external payable;
979 
980     function swapExactTokensForETHSupportingFeeOnTransferTokens(
981         uint256 amountIn,
982         uint256 amountOutMin,
983         address[] calldata path,
984         address to,
985         uint256 deadline
986     ) external;
987 }
988 
989 contract AlphaRadarBot is ERC20, Ownable {
990     using SafeMath for uint256;
991 
992     IUniswapV2Router02 public immutable uniswapV2Router;
993     address public immutable uniswapV2Pair;
994     address public constant deadAddress = address(0xdead);
995 
996     bool private swapping;
997 
998     address public revShareWallet;
999     address public teamWallet;
1000 
1001     uint256 public maxTransactionAmount;
1002     uint256 public swapTokensAtAmount;
1003     uint256 public maxWallet;
1004 
1005     bool public limitsInEffect = true;
1006     bool public tradingActive = false;
1007     bool public swapEnabled = false;
1008 
1009     bool public blacklistRenounced = false;
1010 
1011     // Anti-bot and anti-whale mappings and variables
1012     mapping(address => bool) blacklisted;
1013 
1014     uint256 public buyTotalFees;
1015     uint256 public buyRevShareFee;
1016     uint256 public buyLiquidityFee;
1017     uint256 public buyTeamFee;
1018 
1019     uint256 public sellTotalFees;
1020     uint256 public sellRevShareFee;
1021     uint256 public sellLiquidityFee;
1022     uint256 public sellTeamFee;
1023 
1024     uint256 public tokensForRevShare;
1025     uint256 public tokensForLiquidity;
1026     uint256 public tokensForTeam;
1027 
1028     /******************/
1029 
1030     // exclude from fees and max transaction amount
1031     mapping(address => bool) private _isExcludedFromFees;
1032     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1033 
1034     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1035     // could be subject to a maximum transfer amount
1036     mapping(address => bool) public automatedMarketMakerPairs;
1037 
1038     bool public preMigrationPhase = true;
1039     mapping(address => bool) public preMigrationTransferrable;
1040 
1041     event UpdateUniswapV2Router(
1042         address indexed newAddress,
1043         address indexed oldAddress
1044     );
1045 
1046     event ExcludeFromFees(address indexed account, bool isExcluded);
1047 
1048     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1049 
1050     event revShareWalletUpdated(
1051         address indexed newWallet,
1052         address indexed oldWallet
1053     );
1054 
1055     event teamWalletUpdated(
1056         address indexed newWallet,
1057         address indexed oldWallet
1058     );
1059 
1060     event SwapAndLiquify(
1061         uint256 tokensSwapped,
1062         uint256 ethReceived,
1063         uint256 tokensIntoLiquidity
1064     );
1065 
1066     constructor() ERC20("Arbot", "ARBOT") {
1067         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1068             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1069         );
1070 
1071         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1072         uniswapV2Router = _uniswapV2Router;
1073 
1074         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1075             .createPair(address(this), _uniswapV2Router.WETH());
1076         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1077         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1078 
1079         uint256 _buyRevShareFee = 2;
1080         uint256 _buyLiquidityFee = 1;
1081         uint256 _buyTeamFee = 2;
1082 
1083         uint256 _sellRevShareFee = 2;
1084         uint256 _sellLiquidityFee = 1;
1085         uint256 _sellTeamFee = 2;
1086 
1087         uint256 totalSupply = 100_000_000 * 1e18;
1088 
1089         maxTransactionAmount = 1000_000 * 1e18; // 1%
1090         maxWallet = 1000_000 * 1e18; // 1% 
1091         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% 
1092 
1093         buyRevShareFee = _buyRevShareFee;
1094         buyLiquidityFee = _buyLiquidityFee;
1095         buyTeamFee = _buyTeamFee;
1096         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1097 
1098         sellRevShareFee = _sellRevShareFee;
1099         sellLiquidityFee = _sellLiquidityFee;
1100         sellTeamFee = _sellTeamFee;
1101         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1102 
1103         revShareWallet = address(0x037D1a874E265f1bcaddeF7735f5fbf1a83d7F37); // set as revShare wallet
1104         
1105         teamWallet = owner(); // set as team wallet
1106 
1107         // exclude from paying fees or having max transaction amount
1108         excludeFromFees(owner(), true);
1109         excludeFromFees(address(this), true);
1110         excludeFromFees(address(0xdead), true);
1111 
1112         excludeFromMaxTransaction(owner(), true);
1113         excludeFromMaxTransaction(address(this), true);
1114         excludeFromMaxTransaction(address(0xdead), true);
1115 
1116         preMigrationTransferrable[owner()] = true;
1117 
1118         /*
1119             _mint is an internal function in ERC20.sol that is only called here,
1120             and CANNOT be called ever again
1121         */
1122         _mint(msg.sender, totalSupply);
1123     }
1124 
1125     receive() external payable {}
1126 
1127     // once enabled, can never be turned off
1128     function enableTrading() external onlyOwner {
1129         tradingActive = true;
1130         swapEnabled = true;
1131         preMigrationPhase = false;
1132     }
1133 
1134     // remove limits after token is stable
1135     function removeLimits() external onlyOwner returns (bool) {
1136         limitsInEffect = false;
1137         return true;
1138     }
1139 
1140     // change the minimum amount of tokens to sell from fees
1141     function updateSwapTokensAtAmount(uint256 newAmount)
1142         external
1143         onlyOwner
1144         returns (bool)
1145     {
1146         require(
1147             newAmount >= (totalSupply() * 1) / 100000,
1148             "Swap amount cannot be lower than 0.001% total supply."
1149         );
1150         require(
1151             newAmount <= (totalSupply() * 5) / 1000,
1152             "Swap amount cannot be higher than 0.5% total supply."
1153         );
1154         swapTokensAtAmount = newAmount;
1155         return true;
1156     }
1157 
1158     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1159         require(
1160             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1161             "Cannot set maxTransactionAmount lower than 0.5%"
1162         );
1163         maxTransactionAmount = newNum * (10**18);
1164     }
1165 
1166     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1167         require(
1168             newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1169             "Cannot set maxWallet lower than 1.0%"
1170         );
1171         maxWallet = newNum * (10**18);
1172     }
1173 
1174     function excludeFromMaxTransaction(address updAds, bool isEx)
1175         public
1176         onlyOwner
1177     {
1178         _isExcludedMaxTransactionAmount[updAds] = isEx;
1179     }
1180 
1181     // only use to disable contract sales if absolutely necessary (emergency use only)
1182     function updateSwapEnabled(bool enabled) external onlyOwner {
1183         swapEnabled = enabled;
1184     }
1185 
1186     function updateBuyFees(
1187         uint256 _revShareFee,
1188         uint256 _liquidityFee,
1189         uint256 _teamFee
1190     ) external onlyOwner {
1191         buyRevShareFee = _revShareFee;
1192         buyLiquidityFee = _liquidityFee;
1193         buyTeamFee = _teamFee;
1194         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1195         require(buyTotalFees <= 5, "Buy fees must be <= 5.");
1196     }
1197 
1198     function updateSellFees(
1199         uint256 _revShareFee,
1200         uint256 _liquidityFee,
1201         uint256 _teamFee
1202     ) external onlyOwner {
1203         sellRevShareFee = _revShareFee;
1204         sellLiquidityFee = _liquidityFee;
1205         sellTeamFee = _teamFee;
1206         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1207         require(sellTotalFees <= 5, "Sell fees must be <= 5.");
1208     }
1209 
1210     function excludeFromFees(address account, bool excluded) public onlyOwner {
1211         _isExcludedFromFees[account] = excluded;
1212         emit ExcludeFromFees(account, excluded);
1213     }
1214 
1215     function setAutomatedMarketMakerPair(address pair, bool value)
1216         public
1217         onlyOwner
1218     {
1219         require(
1220             pair != uniswapV2Pair,
1221             "The pair cannot be removed from automatedMarketMakerPairs"
1222         );
1223 
1224         _setAutomatedMarketMakerPair(pair, value);
1225     }
1226 
1227     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1228         automatedMarketMakerPairs[pair] = value;
1229 
1230         emit SetAutomatedMarketMakerPair(pair, value);
1231     }
1232 
1233     function updateRevShareWallet(address newRevShareWallet) external onlyOwner {
1234         emit revShareWalletUpdated(newRevShareWallet, revShareWallet);
1235         revShareWallet = newRevShareWallet;
1236     }
1237 
1238     function updateTeamWallet(address newWallet) external onlyOwner {
1239         emit teamWalletUpdated(newWallet, teamWallet);
1240         teamWallet = newWallet;
1241     }
1242 
1243     function isExcludedFromFees(address account) public view returns (bool) {
1244         return _isExcludedFromFees[account];
1245     }
1246 
1247     function isBlacklisted(address account) public view returns (bool) {
1248         return blacklisted[account];
1249     }
1250 
1251     function _transfer(
1252         address from,
1253         address to,
1254         uint256 amount
1255     ) internal override {
1256         require(from != address(0), "ERC20: transfer from the zero address");
1257         require(to != address(0), "ERC20: transfer to the zero address");
1258         require(!blacklisted[from],"Sender blacklisted");
1259         require(!blacklisted[to],"Receiver blacklisted");
1260 
1261         if (preMigrationPhase) {
1262             require(preMigrationTransferrable[from], "Not authorized to transfer pre-migration.");
1263         }
1264 
1265         if (amount == 0) {
1266             super._transfer(from, to, 0);
1267             return;
1268         }
1269 
1270         if (limitsInEffect) {
1271             if (
1272                 from != owner() &&
1273                 to != owner() &&
1274                 to != address(0) &&
1275                 to != address(0xdead) &&
1276                 !swapping
1277             ) {
1278                 if (!tradingActive) {
1279                     require(
1280                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1281                         "Trading is not active."
1282                     );
1283                 }
1284 
1285                 //when buy
1286                 if (
1287                     automatedMarketMakerPairs[from] &&
1288                     !_isExcludedMaxTransactionAmount[to]
1289                 ) {
1290                     require(
1291                         amount <= maxTransactionAmount,
1292                         "Buy transfer amount exceeds the maxTransactionAmount."
1293                     );
1294                     require(
1295                         amount + balanceOf(to) <= maxWallet,
1296                         "Max wallet exceeded"
1297                     );
1298                 }
1299                 //when sell
1300                 else if (
1301                     automatedMarketMakerPairs[to] &&
1302                     !_isExcludedMaxTransactionAmount[from]
1303                 ) {
1304                     require(
1305                         amount <= maxTransactionAmount,
1306                         "Sell transfer amount exceeds the maxTransactionAmount."
1307                     );
1308                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1309                     require(
1310                         amount + balanceOf(to) <= maxWallet,
1311                         "Max wallet exceeded"
1312                     );
1313                 }
1314             }
1315         }
1316 
1317         uint256 contractTokenBalance = balanceOf(address(this));
1318 
1319         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1320 
1321         if (
1322             canSwap &&
1323             swapEnabled &&
1324             !swapping &&
1325             !automatedMarketMakerPairs[from] &&
1326             !_isExcludedFromFees[from] &&
1327             !_isExcludedFromFees[to]
1328         ) {
1329             swapping = true;
1330 
1331             swapBack();
1332 
1333             swapping = false;
1334         }
1335 
1336         bool takeFee = !swapping;
1337 
1338         // if any account belongs to _isExcludedFromFee account then remove the fee
1339         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1340             takeFee = false;
1341         }
1342 
1343         uint256 fees = 0;
1344         // only take fees on buys/sells, do not take on wallet transfers
1345         if (takeFee) {
1346             // on sell
1347             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1348                 fees = amount.mul(sellTotalFees).div(100);
1349                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1350                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
1351                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1352             }
1353             // on buy
1354             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1355                 fees = amount.mul(buyTotalFees).div(100);
1356                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1357                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
1358                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1359             }
1360 
1361             if (fees > 0) {
1362                 super._transfer(from, address(this), fees);
1363             }
1364 
1365             amount -= fees;
1366         }
1367 
1368         super._transfer(from, to, amount);
1369     }
1370 
1371     function swapTokensForEth(uint256 tokenAmount) private {
1372         // generate the uniswap pair path of token -> weth
1373         address[] memory path = new address[](2);
1374         path[0] = address(this);
1375         path[1] = uniswapV2Router.WETH();
1376 
1377         _approve(address(this), address(uniswapV2Router), tokenAmount);
1378 
1379         // make the swap
1380         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1381             tokenAmount,
1382             0, // accept any amount of ETH
1383             path,
1384             address(this),
1385             block.timestamp
1386         );
1387     }
1388 
1389     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1390         // approve token transfer to cover all possible scenarios
1391         _approve(address(this), address(uniswapV2Router), tokenAmount);
1392 
1393         // add the liquidity
1394         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1395             address(this),
1396             tokenAmount,
1397             0, // slippage is unavoidable
1398             0, // slippage is unavoidable
1399             owner(),
1400             block.timestamp
1401         );
1402     }
1403 
1404     function swapBack() private {
1405         uint256 contractBalance = balanceOf(address(this));
1406         uint256 totalTokensToSwap = tokensForLiquidity +
1407             tokensForRevShare +
1408             tokensForTeam;
1409         bool success;
1410 
1411         if (contractBalance == 0 || totalTokensToSwap == 0) {
1412             return;
1413         }
1414 
1415         if (contractBalance > swapTokensAtAmount * 20) {
1416             contractBalance = swapTokensAtAmount * 20;
1417         }
1418 
1419         // Halve the amount of liquidity tokens
1420         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1421             totalTokensToSwap /
1422             2;
1423         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1424 
1425         uint256 initialETHBalance = address(this).balance;
1426 
1427         swapTokensForEth(amountToSwapForETH);
1428 
1429         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1430 
1431         uint256 ethForRevShare = ethBalance.mul(tokensForRevShare).div(totalTokensToSwap - (tokensForLiquidity / 2));
1432         
1433         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap - (tokensForLiquidity / 2));
1434 
1435         uint256 ethForLiquidity = ethBalance - ethForRevShare - ethForTeam;
1436 
1437         tokensForLiquidity = 0;
1438         tokensForRevShare = 0;
1439         tokensForTeam = 0;
1440 
1441         (success, ) = address(teamWallet).call{value: ethForTeam}("");
1442 
1443         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1444             addLiquidity(liquidityTokens, ethForLiquidity);
1445             emit SwapAndLiquify(
1446                 amountToSwapForETH,
1447                 ethForLiquidity,
1448                 tokensForLiquidity
1449             );
1450         }
1451 
1452         (success, ) = address(revShareWallet).call{value: address(this).balance}("");
1453     }
1454 
1455     function withdrawStuckArbot() external onlyOwner {
1456         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1457         IERC20(address(this)).transfer(msg.sender, balance);
1458         payable(msg.sender).transfer(address(this).balance);
1459     }
1460 
1461     function withdrawStuckToken(address _token, address _to) external onlyOwner {
1462         require(_token != address(0), "_token address cannot be 0");
1463         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1464         IERC20(_token).transfer(_to, _contractBalance);
1465     }
1466 
1467     function withdrawStuckEth(address toAddr) external onlyOwner {
1468         (bool success, ) = toAddr.call{
1469             value: address(this).balance
1470         } ("");
1471         require(success);
1472     }
1473 
1474     // @dev team renounce blacklist commands
1475     function renounceBlacklist() public onlyOwner {
1476         blacklistRenounced = true;
1477     }
1478 
1479     function blacklist(address _addr) public onlyOwner {
1480         require(!blacklistRenounced, "Team has revoked blacklist rights");
1481         require(
1482             _addr != address(uniswapV2Pair) && _addr != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1483             "Cannot blacklist token's v2 router or v2 pool."
1484         );
1485         blacklisted[_addr] = true;
1486     }
1487 
1488     // @dev blacklist v3 pools; can unblacklist() down the road to suit project and community
1489     function blacklistLiquidityPool(address lpAddress) public onlyOwner {
1490         require(!blacklistRenounced, "Team has revoked blacklist rights");
1491         require(
1492             lpAddress != address(uniswapV2Pair) && lpAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1493             "Cannot blacklist token's v2 router or v2 pool."
1494         );
1495         blacklisted[lpAddress] = true;
1496     }
1497 
1498     // @dev unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1499     function unblacklist(address _addr) public onlyOwner {
1500         blacklisted[_addr] = false;
1501     }
1502 
1503     function setPreMigrationTransferable(address _addr, bool isAuthorized) public onlyOwner {
1504         preMigrationTransferrable[_addr] = isAuthorized;
1505         excludeFromFees(_addr, isAuthorized);
1506         excludeFromMaxTransaction(_addr, isAuthorized);
1507     }
1508 }