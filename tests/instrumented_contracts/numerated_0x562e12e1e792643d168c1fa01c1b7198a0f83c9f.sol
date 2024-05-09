1 /**
2     Bookiebot
3     The First and Only Telegram Bot Designed for Sports Betting.
4     Product is live and ready to be used. 
5     
6     // Website: https://bookiebot.app/
7     Twitter: https://twitter.com/TeamBookiebot
8     Telegram: https://t.me/+8JG9enOyIIFhM2Jh
9     Telegram Bot: https://t.me/BookieBot_tgbot
10     
11 **/
12 
13 // SPDX-License-Identifier: MIT
14 pragma solidity 0.8.20;
15 pragma experimental ABIEncoderV2;
16 
17 /**
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
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
219 /**
220  * @dev Implementation of the {IERC20} interface.
221  *
222  * This implementation is agnostic to the way tokens are created. This means
223  * that a supply mechanism has to be added in a derived contract using {_mint}.
224  * For a generic mechanism see {ERC20PresetMinterPauser}.
225  *
226  * TIP: For a detailed writeup see our guide
227  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
228  * to implement supply mechanisms].
229  *
230  * We have followed general OpenZeppelin Contracts guidelines: functions revert
231  * instead returning `false` on failure. This behavior is nonetheless
232  * conventional and does not conflict with the expectations of ERC20
233  * applications.
234  *
235  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
236  * This allows applications to reconstruct the allowance for all accounts just
237  * by listening to said events. Other implementations of the EIP may not emit
238  * these events, as it isn't required by the specification.
239  *
240  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
241  * functions have been added to mitigate the well-known issues around setting
242  * allowances. See {IERC20-approve}.
243  */
244 contract ERC20 is Context, IERC20, IERC20Metadata {
245     mapping(address => uint256) private _balances;
246 
247     mapping(address => mapping(address => uint256)) private _allowances;
248 
249     uint256 private _totalSupply;
250 
251     string private _name;
252     string private _symbol;
253 
254     /**
255      * @dev Sets the values for {name} and {symbol}.
256      *
257      * The default value of {decimals} is 18. To select a different value for
258      * {decimals} you should overload it.
259      *
260      * All two of these values are immutable: they can only be set once during
261      * construction.
262      */
263     constructor(string memory name_, string memory symbol_) {
264         _name = name_;
265         _symbol = symbol_;
266     }
267 
268     /**
269      * @dev Returns the name of the token.
270      */
271     function name() public view virtual override returns (string memory) {
272         return _name;
273     }
274 
275     /**
276      * @dev Returns the symbol of the token, usually a shorter version of the
277      * name.
278      */
279     function symbol() public view virtual override returns (string memory) {
280         return _symbol;
281     }
282 
283     /**
284      * @dev Returns the number of decimals used to get its user representation.
285      * For example, if `decimals` equals `2`, a balance of `505` tokens should
286      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
287      *
288      * Tokens usually opt for a value of 18, imitating the relationship between
289      * Ether and Wei. This is the value {ERC20} uses, unless this function is
290      * overridden;
291      *
292      * NOTE: This information is only used for _display_ purposes: it in
293      * no way affects any of the arithmetic of the contract, including
294      * {IERC20-balanceOf} and {IERC20-transfer}.
295      */
296     function decimals() public view virtual override returns (uint8) {
297         return 18;
298     }
299 
300     /**
301      * @dev See {IERC20-totalSupply}.
302      */
303     function totalSupply() public view virtual override returns (uint256) {
304         return _totalSupply;
305     }
306 
307     /**
308      * @dev See {IERC20-balanceOf}.
309      */
310     function balanceOf(address account) public view virtual override returns (uint256) {
311         return _balances[account];
312     }
313 
314     /**
315      * @dev See {IERC20-transfer}.
316      *
317      * Requirements:
318      *
319      * - `recipient` cannot be the zero address.
320      * - the caller must have a balance of at least `amount`.
321      */
322     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
323         _transfer(_msgSender(), recipient, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-allowance}.
329      */
330     function allowance(address owner, address spender) public view virtual override returns (uint256) {
331         return _allowances[owner][spender];
332     }
333 
334     /**
335      * @dev See {IERC20-approve}.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function approve(address spender, uint256 amount) public virtual override returns (bool) {
342         _approve(_msgSender(), spender, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-transferFrom}.
348      *
349      * Emits an {Approval} event indicating the updated allowance. This is not
350      * required by the EIP. See the note at the beginning of {ERC20}.
351      *
352      * Requirements:
353      *
354      * - `sender` and `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      * - the caller must have allowance for ``sender``'s tokens of at least
357      * `amount`.
358      */
359     function transferFrom(
360         address sender,
361         address recipient,
362         uint256 amount
363     ) public virtual override returns (bool) {
364         _transfer(sender, recipient, amount);
365 
366         uint256 currentAllowance = _allowances[sender][_msgSender()];
367         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
368         unchecked {
369             _approve(sender, _msgSender(), currentAllowance - amount);
370         }
371 
372         return true;
373     }
374 
375     /**
376      * @dev Atomically increases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
389         return true;
390     }
391 
392     /**
393      * @dev Atomically decreases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      * - `spender` must have allowance for the caller of at least
404      * `subtractedValue`.
405      */
406     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
407         uint256 currentAllowance = _allowances[_msgSender()][spender];
408         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
409         unchecked {
410             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
411         }
412 
413         return true;
414     }
415 
416     /**
417      * @dev Moves `amount` of tokens from `sender` to `recipient`.
418      *
419      * This internal function is equivalent to {transfer}, and can be used to
420      * e.g. implement automatic token fees, slashing mechanisms, etc.
421      *
422      * Emits a {Transfer} event.
423      *
424      * Requirements:
425      *
426      * - `sender` cannot be the zero address.
427      * - `recipient` cannot be the zero address.
428      * - `sender` must have a balance of at least `amount`.
429      */
430     function _transfer(
431         address sender,
432         address recipient,
433         uint256 amount
434     ) internal virtual {
435         require(sender != address(0), "ERC20: transfer from the zero address");
436         require(recipient != address(0), "ERC20: transfer to the zero address");
437 
438         _beforeTokenTransfer(sender, recipient, amount);
439 
440         uint256 senderBalance = _balances[sender];
441         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
442         unchecked {
443             _balances[sender] = senderBalance - amount;
444         }
445         _balances[recipient] += amount;
446 
447         emit Transfer(sender, recipient, amount);
448 
449         _afterTokenTransfer(sender, recipient, amount);
450     }
451 
452     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
453      * the total supply.
454      *
455      * Emits a {Transfer} event with `from` set to the zero address.
456      *
457      * Requirements:
458      *
459      * - `account` cannot be the zero address.
460      */
461     function _mint(address account, uint256 amount) internal virtual {
462         require(account != address(0), "ERC20: mint to the zero address");
463 
464         _beforeTokenTransfer(address(0), account, amount);
465 
466         _totalSupply += amount;
467         _balances[account] += amount;
468         emit Transfer(address(0), account, amount);
469 
470         _afterTokenTransfer(address(0), account, amount);
471     }
472 
473     /**
474      * @dev Destroys `amount` tokens from `account`, reducing the
475      * total supply.
476      *
477      * Emits a {Transfer} event with `to` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `account` cannot be the zero address.
482      * - `account` must have at least `amount` tokens.
483      */
484     function _burn(address account, uint256 amount) internal virtual {
485         require(account != address(0), "ERC20: burn from the zero address");
486 
487         _beforeTokenTransfer(account, address(0), amount);
488 
489         uint256 accountBalance = _balances[account];
490         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
491         unchecked {
492             _balances[account] = accountBalance - amount;
493         }
494         _totalSupply -= amount;
495 
496         emit Transfer(account, address(0), amount);
497 
498         _afterTokenTransfer(account, address(0), amount);
499     }
500 
501     /**
502      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
503      *
504      * This internal function is equivalent to `approve`, and can be used to
505      * e.g. set automatic allowances for certain subsystems, etc.
506      *
507      * Emits an {Approval} event.
508      *
509      * Requirements:
510      *
511      * - `owner` cannot be the zero address.
512      * - `spender` cannot be the zero address.
513      */
514     function _approve(
515         address owner,
516         address spender,
517         uint256 amount
518     ) internal virtual {
519         require(owner != address(0), "ERC20: approve from the zero address");
520         require(spender != address(0), "ERC20: approve to the zero address");
521 
522         _allowances[owner][spender] = amount;
523         emit Approval(owner, spender, amount);
524     }
525 
526     /**
527      * @dev Hook that is called before any transfer of tokens. This includes
528      * minting and burning.
529      *
530      * Calling conditions:
531      *
532      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
533      * will be transferred to `to`.
534      * - when `from` is zero, `amount` tokens will be minted for `to`.
535      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
536      * - `from` and `to` are never both zero.
537      *
538      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
539      */
540     function _beforeTokenTransfer(
541         address from,
542         address to,
543         uint256 amount
544     ) internal virtual {}
545 
546     /**
547      * @dev Hook that is called after any transfer of tokens. This includes
548      * minting and burning.
549      *
550      * Calling conditions:
551      *
552      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
553      * has been transferred to `to`.
554      * - when `from` is zero, `amount` tokens have been minted for `to`.
555      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
556      * - `from` and `to` are never both zero.
557      *
558      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
559      */
560     function _afterTokenTransfer(
561         address from,
562         address to,
563         uint256 amount
564     ) internal virtual {}
565 }
566 
567 /**
568  * @dev Wrappers over Solidity's arithmetic operations.
569  *
570  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
571  * now has built in overflow checking.
572  */
573 library SafeMath {
574     /**
575      * @dev Returns the addition of two unsigned integers, with an overflow flag.
576      *
577      * _Available since v3.4._
578      */
579     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
580         unchecked {
581             uint256 c = a + b;
582             if (c < a) return (false, 0);
583             return (true, c);
584         }
585     }
586 
587     /**
588      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
589      *
590      * _Available since v3.4._
591      */
592     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
593         unchecked {
594             if (b > a) return (false, 0);
595             return (true, a - b);
596         }
597     }
598 
599     /**
600      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
601      *
602      * _Available since v3.4._
603      */
604     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
605         unchecked {
606             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
607             // benefit is lost if 'b' is also tested.
608             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
609             if (a == 0) return (true, 0);
610             uint256 c = a * b;
611             if (c / a != b) return (false, 0);
612             return (true, c);
613         }
614     }
615 
616     /**
617      * @dev Returns the division of two unsigned integers, with a division by zero flag.
618      *
619      * _Available since v3.4._
620      */
621     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
622         unchecked {
623             if (b == 0) return (false, 0);
624             return (true, a / b);
625         }
626     }
627 
628     /**
629      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
630      *
631      * _Available since v3.4._
632      */
633     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
634         unchecked {
635             if (b == 0) return (false, 0);
636             return (true, a % b);
637         }
638     }
639 
640     /**
641      * @dev Returns the addition of two unsigned integers, reverting on
642      * overflow.
643      *
644      * Counterpart to Solidity's `+` operator.
645      *
646      * Requirements:
647      *
648      * - Addition cannot overflow.
649      */
650     function add(uint256 a, uint256 b) internal pure returns (uint256) {
651         return a + b;
652     }
653 
654     /**
655      * @dev Returns the subtraction of two unsigned integers, reverting on
656      * overflow (when the result is negative).
657      *
658      * Counterpart to Solidity's `-` operator.
659      *
660      * Requirements:
661      *
662      * - Subtraction cannot overflow.
663      */
664     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
665         return a - b;
666     }
667 
668     /**
669      * @dev Returns the multiplication of two unsigned integers, reverting on
670      * overflow.
671      *
672      * Counterpart to Solidity's `*` operator.
673      *
674      * Requirements:
675      *
676      * - Multiplication cannot overflow.
677      */
678     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
679         return a * b;
680     }
681 
682     /**
683      * @dev Returns the integer division of two unsigned integers, reverting on
684      * division by zero. The result is rounded towards zero.
685      *
686      * Counterpart to Solidity's `/` operator.
687      *
688      * Requirements:
689      *
690      * - The divisor cannot be zero.
691      */
692     function div(uint256 a, uint256 b) internal pure returns (uint256) {
693         return a / b;
694     }
695 
696     /**
697      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
698      * reverting when dividing by zero.
699      *
700      * Counterpart to Solidity's `%` operator. This function uses a `revert`
701      * opcode (which leaves remaining gas untouched) while Solidity uses an
702      * invalid opcode to revert (consuming all remaining gas).
703      *
704      * Requirements:
705      *
706      * - The divisor cannot be zero.
707      */
708     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
709         return a % b;
710     }
711 
712     /**
713      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
714      * overflow (when the result is negative).
715      *
716      * CAUTION: This function is deprecated because it requires allocating memory for the error
717      * message unnecessarily. For custom revert reasons use {trySub}.
718      *
719      * Counterpart to Solidity's `-` operator.
720      *
721      * Requirements:
722      *
723      * - Subtraction cannot overflow.
724      */
725     function sub(
726         uint256 a,
727         uint256 b,
728         string memory errorMessage
729     ) internal pure returns (uint256) {
730         unchecked {
731             require(b <= a, errorMessage);
732             return a - b;
733         }
734     }
735 
736     /**
737      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
738      * division by zero. The result is rounded towards zero.
739      *
740      * Counterpart to Solidity's `/` operator. Note: this function uses a
741      * `revert` opcode (which leaves remaining gas untouched) while Solidity
742      * uses an invalid opcode to revert (consuming all remaining gas).
743      *
744      * Requirements:
745      *
746      * - The divisor cannot be zero.
747      */
748     function div(
749         uint256 a,
750         uint256 b,
751         string memory errorMessage
752     ) internal pure returns (uint256) {
753         unchecked {
754             require(b > 0, errorMessage);
755             return a / b;
756         }
757     }
758 
759     /**
760      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
761      * reverting with custom message when dividing by zero.
762      *
763      * CAUTION: This function is deprecated because it requires allocating memory for the error
764      * message unnecessarily. For custom revert reasons use {tryMod}.
765      *
766      * Counterpart to Solidity's `%` operator. This function uses a `revert`
767      * opcode (which leaves remaining gas untouched) while Solidity uses an
768      * invalid opcode to revert (consuming all remaining gas).
769      *
770      * Requirements:
771      *
772      * - The divisor cannot be zero.
773      */
774     function mod(
775         uint256 a,
776         uint256 b,
777         string memory errorMessage
778     ) internal pure returns (uint256) {
779         unchecked {
780             require(b > 0, errorMessage);
781             return a % b;
782         }
783     }
784 }
785 
786 interface IUniswapV2Factory {
787     event PairCreated(
788         address indexed token0,
789         address indexed token1,
790         address pair,
791         uint256
792     );
793 
794     function feeTo() external view returns (address);
795 
796     function feeToSetter() external view returns (address);
797 
798     function getPair(address tokenA, address tokenB)
799         external
800         view
801         returns (address pair);
802 
803     function allPairs(uint256) external view returns (address pair);
804 
805     function allPairsLength() external view returns (uint256);
806 
807     function createPair(address tokenA, address tokenB)
808         external
809         returns (address pair);
810 
811     function setFeeTo(address) external;
812 
813     function setFeeToSetter(address) external;
814 }
815 
816 ////// src/IUniswapV2Pair.sol
817 /* pragma solidity 0.8.10; */
818 /* pragma experimental ABIEncoderV2; */
819 
820 interface IUniswapV2Pair {
821     event Approval(
822         address indexed owner,
823         address indexed spender,
824         uint256 value
825     );
826     event Transfer(address indexed from, address indexed to, uint256 value);
827 
828     function name() external pure returns (string memory);
829 
830     function symbol() external pure returns (string memory);
831 
832     function decimals() external pure returns (uint8);
833 
834     function totalSupply() external view returns (uint256);
835 
836     function balanceOf(address owner) external view returns (uint256);
837 
838     function allowance(address owner, address spender)
839         external
840         view
841         returns (uint256);
842 
843     function approve(address spender, uint256 value) external returns (bool);
844 
845     function transfer(address to, uint256 value) external returns (bool);
846 
847     function transferFrom(
848         address from,
849         address to,
850         uint256 value
851     ) external returns (bool);
852 
853     function DOMAIN_SEPARATOR() external view returns (bytes32);
854 
855     function PERMIT_TYPEHASH() external pure returns (bytes32);
856 
857     function nonces(address owner) external view returns (uint256);
858 
859     function permit(
860         address owner,
861         address spender,
862         uint256 value,
863         uint256 deadline,
864         uint8 v,
865         bytes32 r,
866         bytes32 s
867     ) external;
868 
869     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
870     event Burn(
871         address indexed sender,
872         uint256 amount0,
873         uint256 amount1,
874         address indexed to
875     );
876     event Swap(
877         address indexed sender,
878         uint256 amount0In,
879         uint256 amount1In,
880         uint256 amount0Out,
881         uint256 amount1Out,
882         address indexed to
883     );
884     event Sync(uint112 reserve0, uint112 reserve1);
885 
886     function MINIMUM_LIQUIDITY() external pure returns (uint256);
887 
888     function factory() external view returns (address);
889 
890     function token0() external view returns (address);
891 
892     function token1() external view returns (address);
893 
894     function getReserves()
895         external
896         view
897         returns (
898             uint112 reserve0,
899             uint112 reserve1,
900             uint32 blockTimestampLast
901         );
902 
903     function price0CumulativeLast() external view returns (uint256);
904 
905     function price1CumulativeLast() external view returns (uint256);
906 
907     function kLast() external view returns (uint256);
908 
909     function mint(address to) external returns (uint256 liquidity);
910 
911     function burn(address to)
912         external
913         returns (uint256 amount0, uint256 amount1);
914 
915     function swap(
916         uint256 amount0Out,
917         uint256 amount1Out,
918         address to,
919         bytes calldata data
920     ) external;
921 
922     function skim(address to) external;
923 
924     function sync() external;
925 
926     function initialize(address, address) external;
927 }
928 
929 interface IUniswapV2Router02 {
930     function factory() external pure returns (address);
931 
932     function WETH() external pure returns (address);
933 
934     function addLiquidity(
935         address tokenA,
936         address tokenB,
937         uint256 amountADesired,
938         uint256 amountBDesired,
939         uint256 amountAMin,
940         uint256 amountBMin,
941         address to,
942         uint256 deadline
943     )
944         external
945         returns (
946             uint256 amountA,
947             uint256 amountB,
948             uint256 liquidity
949         );
950 
951     function addLiquidityETH(
952         address token,
953         uint256 amountTokenDesired,
954         uint256 amountTokenMin,
955         uint256 amountETHMin,
956         address to,
957         uint256 deadline
958     )
959         external
960         payable
961         returns (
962             uint256 amountToken,
963             uint256 amountETH,
964             uint256 liquidity
965         );
966 
967     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
968         uint256 amountIn,
969         uint256 amountOutMin,
970         address[] calldata path,
971         address to,
972         uint256 deadline
973     ) external;
974 
975     function swapExactETHForTokensSupportingFeeOnTransferTokens(
976         uint256 amountOutMin,
977         address[] calldata path,
978         address to,
979         uint256 deadline
980     ) external payable;
981 
982     function swapExactTokensForETHSupportingFeeOnTransferTokens(
983         uint256 amountIn,
984         uint256 amountOutMin,
985         address[] calldata path,
986         address to,
987         uint256 deadline
988     ) external;
989 }
990 
991 contract Bookiebot is ERC20, Ownable {
992     using SafeMath for uint256;
993 
994     IUniswapV2Router02 public immutable uniswapV2Router;
995     address public immutable uniswapV2Pair;
996     address public constant deadAddress = address(0xdead);
997 
998     bool private swapping;
999 
1000     address public revShareWallet;
1001     address public teamWallet;
1002 
1003     uint256 public maxTransactionAmount;
1004     uint256 public swapTokensAtAmount;
1005     uint256 public maxWallet;
1006 
1007     bool public limitsInEffect = true;
1008     bool public tradingActive = false;
1009     bool public swapEnabled = false;
1010 
1011     bool public blacklistRenounced = false;
1012 
1013     // Anti-bot and anti-whale mappings and variables
1014     mapping(address => bool) blacklisted;
1015 
1016     uint256 public buyTotalFees;
1017     uint256 public buyRevShareFee;
1018     uint256 public buyLiquidityFee;
1019     uint256 public buyTeamFee;
1020 
1021     uint256 public sellTotalFees;
1022     uint256 public sellRevShareFee;
1023     uint256 public sellLiquidityFee;
1024     uint256 public sellTeamFee;
1025 
1026     uint256 public tokensForRevShare;
1027     uint256 public tokensForLiquidity;
1028     uint256 public tokensForTeam;
1029 
1030     /******************/
1031 
1032     // exclude from fees and max transaction amount
1033     mapping(address => bool) private _isExcludedFromFees;
1034     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1035 
1036     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1037     // could be subject to a maximum transfer amount
1038     mapping(address => bool) public automatedMarketMakerPairs;
1039 
1040     bool public preMigrationPhase = true;
1041     mapping(address => bool) public preMigrationTransferrable;
1042 
1043     event UpdateUniswapV2Router(
1044         address indexed newAddress,
1045         address indexed oldAddress
1046     );
1047 
1048     event ExcludeFromFees(address indexed account, bool isExcluded);
1049 
1050     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1051 
1052     event revShareWalletUpdated(
1053         address indexed newWallet,
1054         address indexed oldWallet
1055     );
1056 
1057     event teamWalletUpdated(
1058         address indexed newWallet,
1059         address indexed oldWallet
1060     );
1061 
1062     event SwapAndLiquify(
1063         uint256 tokensSwapped,
1064         uint256 ethReceived,
1065         uint256 tokensIntoLiquidity
1066     );
1067 
1068     constructor() ERC20("Bookiebot", "BB") {
1069         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1070            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1071         );
1072 
1073         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1074         uniswapV2Router = _uniswapV2Router;
1075 
1076         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1077             .createPair(address(this), _uniswapV2Router.WETH());
1078         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1079         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1080 
1081         uint256 _buyRevShareFee = 2;
1082         uint256 _buyLiquidityFee = 1;
1083         uint256 _buyTeamFee = 2;
1084 
1085         uint256 _sellRevShareFee = 2;
1086         uint256 _sellLiquidityFee = 1;
1087         uint256 _sellTeamFee = 2;
1088 
1089         uint256 totalSupply = 1_000_000 * 1e18;
1090 
1091         maxTransactionAmount = 10_000 * 1e18; // 1%
1092         maxWallet = 10_000 * 1e18; // 1% 
1093         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% 
1094 
1095         buyRevShareFee = _buyRevShareFee;
1096         buyLiquidityFee = _buyLiquidityFee;
1097         buyTeamFee = _buyTeamFee;
1098         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1099 
1100         sellRevShareFee = _sellRevShareFee;
1101         sellLiquidityFee = _sellLiquidityFee;
1102         sellTeamFee = _sellTeamFee;
1103         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1104 
1105         revShareWallet = address(0x3121e8d2a4f0F220e8C7C7c6D9a7046527A54B19); // set as revShare wallet
1106         teamWallet = owner(); // set as team wallet
1107 
1108         // exclude from paying fees or having max transaction amount
1109         excludeFromFees(owner(), true);
1110         excludeFromFees(address(this), true);
1111         excludeFromFees(address(0xdead), true);
1112 
1113         excludeFromMaxTransaction(owner(), true);
1114         excludeFromMaxTransaction(address(this), true);
1115         excludeFromMaxTransaction(address(0xdead), true);
1116 
1117         preMigrationTransferrable[owner()] = true;
1118 
1119         /*
1120             _mint is an internal function in ERC20.sol that is only called here,
1121             and CANNOT be called ever again
1122         */
1123         _mint(msg.sender, totalSupply);
1124     }
1125 
1126     receive() external payable {}
1127 
1128     // once enabled, can never be turned off
1129     function enableTrading() external onlyOwner {
1130         tradingActive = true;
1131         swapEnabled = true;
1132         preMigrationPhase = false;
1133     }
1134 
1135     // remove limits after token is stable
1136     function removeLimits() external onlyOwner returns (bool) {
1137         limitsInEffect = false;
1138         return true;
1139     }
1140 
1141     // change the minimum amount of tokens to sell from fees
1142     function updateSwapTokensAtAmount(uint256 newAmount)
1143         external
1144         onlyOwner
1145         returns (bool)
1146     {
1147         require(
1148             newAmount >= (totalSupply() * 1) / 100000,
1149             "Swap amount cannot be lower than 0.001% total supply."
1150         );
1151         require(
1152             newAmount <= (totalSupply() * 5) / 1000,
1153             "Swap amount cannot be higher than 0.5% total supply."
1154         );
1155         swapTokensAtAmount = newAmount;
1156         return true;
1157     }
1158 
1159     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1160         require(
1161             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1162             "Cannot set maxTransactionAmount lower than 0.5%"
1163         );
1164         maxTransactionAmount = newNum * (10**18);
1165     }
1166 
1167     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1168         require(
1169             newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1170             "Cannot set maxWallet lower than 1.0%"
1171         );
1172         maxWallet = newNum * (10**18);
1173     }
1174 
1175     function excludeFromMaxTransaction(address updAds, bool isEx)
1176         public
1177         onlyOwner
1178     {
1179         _isExcludedMaxTransactionAmount[updAds] = isEx;
1180     }
1181 
1182     // only use to disable contract sales if absolutely necessary (emergency use only)
1183     function updateSwapEnabled(bool enabled) external onlyOwner {
1184         swapEnabled = enabled;
1185     }
1186 
1187     function updateBuyFees(
1188         uint256 _revShareFee,
1189         uint256 _liquidityFee,
1190         uint256 _teamFee
1191     ) external onlyOwner {
1192         buyRevShareFee = _revShareFee;
1193         buyLiquidityFee = _liquidityFee;
1194         buyTeamFee = _teamFee;
1195         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1196         require(buyTotalFees <= 5, "Buy fees must be <= 5.");
1197     }
1198 
1199     function updateSellFees(
1200         uint256 _revShareFee,
1201         uint256 _liquidityFee,
1202         uint256 _teamFee
1203     ) external onlyOwner {
1204         sellRevShareFee = _revShareFee;
1205         sellLiquidityFee = _liquidityFee;
1206         sellTeamFee = _teamFee;
1207         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1208         require(sellTotalFees <= 5, "Sell fees must be <= 5.");
1209     }
1210 
1211     function excludeFromFees(address account, bool excluded) public onlyOwner {
1212         _isExcludedFromFees[account] = excluded;
1213         emit ExcludeFromFees(account, excluded);
1214     }
1215 
1216     function setAutomatedMarketMakerPair(address pair, bool value)
1217         public
1218         onlyOwner
1219     {
1220         require(
1221             pair != uniswapV2Pair,
1222             "The pair cannot be removed from automatedMarketMakerPairs"
1223         );
1224 
1225         _setAutomatedMarketMakerPair(pair, value);
1226     }
1227 
1228     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1229         automatedMarketMakerPairs[pair] = value;
1230 
1231         emit SetAutomatedMarketMakerPair(pair, value);
1232     }
1233 
1234     function updateRevShareWallet(address newRevShareWallet) external onlyOwner {
1235         emit revShareWalletUpdated(newRevShareWallet, revShareWallet);
1236         revShareWallet = newRevShareWallet;
1237     }
1238 
1239     function updateTeamWallet(address newWallet) external onlyOwner {
1240         emit teamWalletUpdated(newWallet, teamWallet);
1241         teamWallet = newWallet;
1242     }
1243 
1244     function isExcludedFromFees(address account) public view returns (bool) {
1245         return _isExcludedFromFees[account];
1246     }
1247 
1248     function isBlacklisted(address account) public view returns (bool) {
1249         return blacklisted[account];
1250     }
1251 
1252     function _transfer(
1253         address from,
1254         address to,
1255         uint256 amount
1256     ) internal override {
1257         require(from != address(0), "ERC20: transfer from the zero address");
1258         require(to != address(0), "ERC20: transfer to the zero address");
1259         require(!blacklisted[from],"Sender blacklisted");
1260         require(!blacklisted[to],"Receiver blacklisted");
1261 
1262         if (preMigrationPhase) {
1263             require(preMigrationTransferrable[from], "Not authorized to transfer pre-migration.");
1264         }
1265 
1266         if (amount == 0) {
1267             super._transfer(from, to, 0);
1268             return;
1269         }
1270 
1271         if (limitsInEffect) {
1272             if (
1273                 from != owner() &&
1274                 to != owner() &&
1275                 to != address(0) &&
1276                 to != address(0xdead) &&
1277                 !swapping
1278             ) {
1279                 if (!tradingActive) {
1280                     require(
1281                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1282                         "Trading is not active."
1283                     );
1284                 }
1285 
1286                 //when buy
1287                 if (
1288                     automatedMarketMakerPairs[from] &&
1289                     !_isExcludedMaxTransactionAmount[to]
1290                 ) {
1291                     require(
1292                         amount <= maxTransactionAmount,
1293                         "Buy transfer amount exceeds the maxTransactionAmount."
1294                     );
1295                     require(
1296                         amount + balanceOf(to) <= maxWallet,
1297                         "Max wallet exceeded"
1298                     );
1299                 }
1300                 //when sell
1301                 else if (
1302                     automatedMarketMakerPairs[to] &&
1303                     !_isExcludedMaxTransactionAmount[from]
1304                 ) {
1305                     require(
1306                         amount <= maxTransactionAmount,
1307                         "Sell transfer amount exceeds the maxTransactionAmount."
1308                     );
1309                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1310                     require(
1311                         amount + balanceOf(to) <= maxWallet,
1312                         "Max wallet exceeded"
1313                     );
1314                 }
1315             }
1316         }
1317 
1318         uint256 contractTokenBalance = balanceOf(address(this));
1319 
1320         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1321 
1322         if (
1323             canSwap &&
1324             swapEnabled &&
1325             !swapping &&
1326             !automatedMarketMakerPairs[from] &&
1327             !_isExcludedFromFees[from] &&
1328             !_isExcludedFromFees[to]
1329         ) {
1330             swapping = true;
1331 
1332             swapBack();
1333 
1334             swapping = false;
1335         }
1336 
1337         bool takeFee = !swapping;
1338 
1339         // if any account belongs to _isExcludedFromFee account then remove the fee
1340         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1341             takeFee = false;
1342         }
1343 
1344         uint256 fees = 0;
1345         // only take fees on buys/sells, do not take on wallet transfers
1346         if (takeFee) {
1347             // on sell
1348             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1349                 fees = amount.mul(sellTotalFees).div(100);
1350                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1351                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
1352                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1353             }
1354             // on buy
1355             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1356                 fees = amount.mul(buyTotalFees).div(100);
1357                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1358                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
1359                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1360             }
1361 
1362             if (fees > 0) {
1363                 super._transfer(from, address(this), fees);
1364             }
1365 
1366             amount -= fees;
1367         }
1368 
1369         super._transfer(from, to, amount);
1370     }
1371 
1372     function swapTokensForEth(uint256 tokenAmount) private {
1373         // generate the uniswap pair path of token -> weth
1374         address[] memory path = new address[](2);
1375         path[0] = address(this);
1376         path[1] = uniswapV2Router.WETH();
1377 
1378         _approve(address(this), address(uniswapV2Router), tokenAmount);
1379 
1380         // make the swap
1381         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1382             tokenAmount,
1383             0, // accept any amount of ETH
1384             path,
1385             address(this),
1386             block.timestamp
1387         );
1388     }
1389 
1390     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1391         // approve token transfer to cover all possible scenarios
1392         _approve(address(this), address(uniswapV2Router), tokenAmount);
1393 
1394         // add the liquidity
1395         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1396             address(this),
1397             tokenAmount,
1398             0, // slippage is unavoidable
1399             0, // slippage is unavoidable
1400             owner(),
1401             block.timestamp
1402         );
1403     }
1404 
1405     function swapBack() private {
1406         uint256 contractBalance = balanceOf(address(this));
1407         uint256 totalTokensToSwap = tokensForLiquidity +
1408             tokensForRevShare +
1409             tokensForTeam;
1410         bool success;
1411 
1412         if (contractBalance == 0 || totalTokensToSwap == 0) {
1413             return;
1414         }
1415 
1416         if (contractBalance > swapTokensAtAmount * 20) {
1417             contractBalance = swapTokensAtAmount * 20;
1418         }
1419 
1420         // Halve the amount of liquidity tokens
1421         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1422             totalTokensToSwap /
1423             2;
1424         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1425 
1426         uint256 initialETHBalance = address(this).balance;
1427 
1428         swapTokensForEth(amountToSwapForETH);
1429 
1430         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1431 
1432         uint256 ethForRevShare = ethBalance.mul(tokensForRevShare).div(totalTokensToSwap - (tokensForLiquidity / 2));
1433         
1434         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap - (tokensForLiquidity / 2));
1435 
1436         uint256 ethForLiquidity = ethBalance - ethForRevShare - ethForTeam;
1437 
1438         tokensForLiquidity = 0;
1439         tokensForRevShare = 0;
1440         tokensForTeam = 0;
1441 
1442         (success, ) = address(teamWallet).call{value: ethForTeam}("");
1443 
1444         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1445             addLiquidity(liquidityTokens, ethForLiquidity);
1446             emit SwapAndLiquify(
1447                 amountToSwapForETH,
1448                 ethForLiquidity,
1449                 tokensForLiquidity
1450             );
1451         }
1452 
1453         (success, ) = address(revShareWallet).call{value: address(this).balance}("");
1454     }
1455 
1456     function withdrawStuckBB() external onlyOwner {
1457         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1458         IERC20(address(this)).transfer(msg.sender, balance);
1459         payable(msg.sender).transfer(address(this).balance);
1460     }
1461 
1462     function withdrawStuckToken(address _token, address _to) external onlyOwner {
1463         require(_token != address(0), "_token address cannot be 0");
1464         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1465         IERC20(_token).transfer(_to, _contractBalance);
1466     }
1467 
1468     function withdrawStuckEth(address toAddr) external onlyOwner {
1469         (bool success, ) = toAddr.call{
1470             value: address(this).balance
1471         } ("");
1472         require(success);
1473     }
1474 
1475     // @dev team renounce blacklist commands
1476     function renounceBlacklist() public onlyOwner {
1477         blacklistRenounced = true;
1478     }
1479 
1480     function blacklist(address _addr) public onlyOwner {
1481         require(!blacklistRenounced, "Team has revoked blacklist rights");
1482         require(
1483             _addr != address(uniswapV2Pair) && _addr != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1484             "Cannot blacklist token's v2 router or v2 pool."
1485         );
1486         blacklisted[_addr] = true;
1487     }
1488 
1489     // @dev blacklist v3 pools; can unblacklist() down the road to suit project and community
1490     function blacklistLiquidityPool(address lpAddress) public onlyOwner {
1491         require(!blacklistRenounced, "Team has revoked blacklist rights");
1492         require(
1493             lpAddress != address(uniswapV2Pair) && lpAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1494             "Cannot blacklist token's v2 router or v2 pool."
1495         );
1496         blacklisted[lpAddress] = true;
1497     }
1498 
1499     // @dev unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1500     function unblacklist(address _addr) public onlyOwner {
1501         blacklisted[_addr] = false;
1502     }
1503 
1504     function setPreMigrationTransferable(address _addr, bool isAuthorized) public onlyOwner {
1505         preMigrationTransferrable[_addr] = isAuthorized;
1506         excludeFromFees(_addr, isAuthorized);
1507         excludeFromMaxTransaction(_addr, isAuthorized);
1508     }
1509 }