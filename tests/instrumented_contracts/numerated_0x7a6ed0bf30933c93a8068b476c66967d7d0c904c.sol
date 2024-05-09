1 // https://t.me/BabyMiladys
2 
3 // https://twitter.com/BLadysOfficial_?t=dcdAyzKyaZVpdPCdLrehgg&s=09
4 
5 // SPDX-License-Identifier: MIT
6  
7 pragma solidity =0.8.17;
8 
9 /* pragma solidity ^0.8.0; */
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 /* pragma solidity ^0.8.0; */
21 
22 abstract contract Ownable is Context {
23     address private _owner;
24 
25     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27     /**
28      * @dev Initializes the contract setting the deployer as the initial owner.
29      */
30     constructor() {
31         _transferOwnership(_msgSender());
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view virtual returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public virtual onlyOwner {
57         _transferOwnership(address(0));
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(newOwner != address(0), "Ownable: new owner is the zero address");
66         _transferOwnership(newOwner);
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Internal function without access restriction.
72      */
73     function _transferOwnership(address newOwner) internal virtual {
74         address oldOwner = _owner;
75         _owner = newOwner;
76         emit OwnershipTransferred(oldOwner, newOwner);
77     }
78 }
79 
80 /* pragma solidity ^0.8.0; */
81 
82 /**
83  * @dev Interface of the ERC20 standard as defined in the EIP.
84  */
85 interface IERC20 {
86     /**
87      * @dev Returns the amount of tokens in existence.
88      */
89     function totalSupply() external view returns (uint256);
90 
91     /**
92      * @dev Returns the amount of tokens owned by `account`.
93      */
94     function balanceOf(address account) external view returns (uint256);
95 
96     /**
97      * @dev Moves `amount` tokens from the caller's account to `recipient`.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transfer(address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Returns the remaining number of tokens that `spender` will be
107      * allowed to spend on behalf of `owner` through {transferFrom}. This is
108      * zero by default.
109      *
110      * This value changes when {approve} or {transferFrom} are called.
111      */
112     function allowance(address owner, address spender) external view returns (uint256);
113 
114     /**
115      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * IMPORTANT: Beware that changing an allowance with this method brings the risk
120      * that someone may use both the old and the new allowance by unfortunate
121      * transaction ordering. One possible solution to mitigate this race
122      * condition is to first reduce the spender's allowance to 0 and set the
123      * desired value afterwards:
124      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address spender, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Moves `amount` tokens from `sender` to `recipient` using the
132      * allowance mechanism. `amount` is then deducted from the caller's
133      * allowance.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) external returns (bool);
144 
145     /**
146      * @dev Emitted when `value` tokens are moved from one account (`from`) to
147      * another (`to`).
148      *
149      * Note that `value` may be zero.
150      */
151     event Transfer(address indexed from, address indexed to, uint256 value);
152 
153     /**
154      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
155      * a call to {approve}. `value` is the new allowance.
156      */
157     event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 /* pragma solidity ^0.8.0; */
161 
162 /* import "../IERC20.sol"; */
163 
164 /**
165  * @dev Interface for the optional metadata functions from the ERC20 standard.
166  *
167  * _Available since v4.1._
168  */
169 interface IERC20Metadata is IERC20 {
170     /**
171      * @dev Returns the name of the token.
172      */
173     function name() external view returns (string memory);
174 
175     /**
176      * @dev Returns the symbol of the token.
177      */
178     function symbol() external view returns (string memory);
179 
180     /**
181      * @dev Returns the decimals places of the token.
182      */
183     function decimals() external view returns (uint8);
184 }
185 
186 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
187 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
188 
189 /* pragma solidity ^0.8.0; */
190 
191 /* import "./IERC20.sol"; */
192 /* import "./extensions/IERC20Metadata.sol"; */
193 /* import "../../utils/Context.sol"; */
194 
195 /**
196  * @dev Implementation of the {IERC20} interface.
197  *
198  * This implementation is agnostic to the way tokens are created. This means
199  * that a supply mechanism has to be added in a derived contract using {_mint}.
200  * For a generic mechanism see {ERC20PresetMinterPauser}.
201  *
202  * TIP: For a detailed writeup see our guide
203  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
204  * to implement supply mechanisms].
205  *
206  * We have followed general OpenZeppelin Contracts guidelines: functions revert
207  * instead returning `false` on failure. This behavior is nonetheless
208  * conventional and does not conflict with the expectations of ERC20
209  * applications.
210  *
211  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
212  * This allows applications to reconstruct the allowance for all accounts just
213  * by listening to said events. Other implementations of the EIP may not emit
214  * these events, as it isn't required by the specification.
215  *
216  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
217  * functions have been added to mitigate the well-known issues around setting
218  * allowances. See {IERC20-approve}.
219  */
220 contract ERC20 is Context, IERC20, IERC20Metadata {
221     mapping(address => uint256) private _balances;
222 
223     mapping(address => mapping(address => uint256)) private _allowances;
224 
225     uint256 private _totalSupply;
226 
227     string private _name;
228     string private _symbol;
229 
230     /**
231      * @dev Sets the values for {name} and {symbol}.
232      *
233      * The default value of {decimals} is 18. To select a different value for
234      * {decimals} you should overload it.
235      *
236      * All two of these values are immutable: they can only be set once during
237      * construction.
238      */
239     constructor(string memory name_, string memory symbol_) {
240         _name = name_;
241         _symbol = symbol_;
242     }
243 
244     /**
245      * @dev Returns the name of the token.
246      */
247     function name() public view virtual override returns (string memory) {
248         return _name;
249     }
250 
251     /**
252      * @dev Returns the symbol of the token, usually a shorter version of the
253      * name.
254      */
255     function symbol() public view virtual override returns (string memory) {
256         return _symbol;
257     }
258 
259     /**
260      * @dev Returns the number of decimals used to get its user representation.
261      * For example, if `decimals` equals `2`, a balance of `505` tokens should
262      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
263      *
264      * Tokens usually opt for a value of 18, imitating the relationship between
265      * Ether and Wei. This is the value {ERC20} uses, unless this function is
266      * overridden;
267      *
268      * NOTE: This information is only used for _display_ purposes: it in
269      * no way affects any of the arithmetic of the contract, including
270      * {IERC20-balanceOf} and {IERC20-transfer}.
271      */
272     function decimals() public view virtual override returns (uint8) {
273         return 18;
274     }
275 
276     /**
277      * @dev See {IERC20-totalSupply}.
278      */
279     function totalSupply() public view virtual override returns (uint256) {
280         return _totalSupply;
281     }
282 
283     /**
284      * @dev See {IERC20-balanceOf}.
285      */
286     function balanceOf(address account) public view virtual override returns (uint256) {
287         return _balances[account];
288     }
289 
290     /**
291      * @dev See {IERC20-transfer}.
292      *
293      * Requirements:
294      *
295      * - `recipient` cannot be the zero address.
296      * - the caller must have a balance of at least `amount`.
297      */
298     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
299         _transfer(_msgSender(), recipient, amount);
300         return true;
301     }
302 
303     /**
304      * @dev See {IERC20-allowance}.
305      */
306     function allowance(address owner, address spender) public view virtual override returns (uint256) {
307         return _allowances[owner][spender];
308     }
309 
310     /**
311      * @dev See {IERC20-approve}.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      */
317     function approve(address spender, uint256 amount) public virtual override returns (bool) {
318         _approve(_msgSender(), spender, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-transferFrom}.
324      *
325      * Emits an {Approval} event indicating the updated allowance. This is not
326      * required by the EIP. See the note at the beginning of {ERC20}.
327      *
328      * Requirements:
329      *
330      * - `sender` and `recipient` cannot be the zero address.
331      * - `sender` must have a balance of at least `amount`.
332      * - the caller must have allowance for ``sender``'s tokens of at least
333      * `amount`.
334      */
335     function transferFrom(
336         address sender,
337         address recipient,
338         uint256 amount
339     ) public virtual override returns (bool) {
340         _transfer(sender, recipient, amount);
341 
342         uint256 currentAllowance = _allowances[sender][_msgSender()];
343         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
344         unchecked {
345             _approve(sender, _msgSender(), currentAllowance - amount);
346         }
347 
348         return true;
349     }
350 
351     /**
352      * @dev Atomically increases the allowance granted to `spender` by the caller.
353      *
354      * This is an alternative to {approve} that can be used as a mitigation for
355      * problems described in {IERC20-approve}.
356      *
357      * Emits an {Approval} event indicating the updated allowance.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
364         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
365         return true;
366     }
367 
368     /**
369      * @dev Atomically decreases the allowance granted to `spender` by the caller.
370      *
371      * This is an alternative to {approve} that can be used as a mitigation for
372      * problems described in {IERC20-approve}.
373      *
374      * Emits an {Approval} event indicating the updated allowance.
375      *
376      * Requirements:
377      *
378      * - `spender` cannot be the zero address.
379      * - `spender` must have allowance for the caller of at least
380      * `subtractedValue`.
381      */
382     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
383         uint256 currentAllowance = _allowances[_msgSender()][spender];
384         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
385         unchecked {
386             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
387         }
388 
389         return true;
390     }
391 
392     /**
393      * @dev Moves `amount` of tokens from `sender` to `recipient`.
394      *
395      * This internal function is equivalent to {transfer}, and can be used to
396      * e.g. implement automatic token fees, slashing mechanisms, etc.
397      *
398      * Emits a {Transfer} event.
399      *
400      * Requirements:
401      *
402      * - `sender` cannot be the zero address.
403      * - `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      */
406     function _transfer(
407         address sender,
408         address recipient,
409         uint256 amount
410     ) internal virtual {
411         require(sender != address(0), "ERC20: transfer from the zero address");
412         require(recipient != address(0), "ERC20: transfer to the zero address");
413 
414         _beforeTokenTransfer(sender, recipient, amount);
415 
416         uint256 senderBalance = _balances[sender];
417         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
418         unchecked {
419             _balances[sender] = senderBalance - amount;
420         }
421         _balances[recipient] += amount;
422 
423         emit Transfer(sender, recipient, amount);
424 
425         _afterTokenTransfer(sender, recipient, amount);
426     }
427 
428     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
429      * the total supply.
430      *
431      * Emits a {Transfer} event with `from` set to the zero address.
432      *
433      * Requirements:
434      *
435      * - `account` cannot be the zero address.
436      */
437     function _mint(address account, uint256 amount) internal virtual {
438         require(account != address(0), "ERC20: mint to the zero address");
439 
440         _beforeTokenTransfer(address(0), account, amount);
441 
442         _totalSupply += amount;
443         _balances[account] += amount;
444         emit Transfer(address(0), account, amount);
445 
446         _afterTokenTransfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements:
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal virtual {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _beforeTokenTransfer(account, address(0), amount);
464 
465         uint256 accountBalance = _balances[account];
466         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
467         unchecked {
468             _balances[account] = accountBalance - amount;
469         }
470         _totalSupply -= amount;
471 
472         emit Transfer(account, address(0), amount);
473 
474         _afterTokenTransfer(account, address(0), amount);
475     }
476 
477     /**
478      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
479      *
480      * This internal function is equivalent to `approve`, and can be used to
481      * e.g. set automatic allowances for certain subsystems, etc.
482      *
483      * Emits an {Approval} event.
484      *
485      * Requirements:
486      *
487      * - `owner` cannot be the zero address.
488      * - `spender` cannot be the zero address.
489      */
490     function _approve(
491         address owner,
492         address spender,
493         uint256 amount
494     ) internal virtual {
495         require(owner != address(0), "ERC20: approve from the zero address");
496         require(spender != address(0), "ERC20: approve to the zero address");
497 
498         _allowances[owner][spender] = amount;
499         emit Approval(owner, spender, amount);
500     }
501 
502     /**
503      * @dev Hook that is called before any transfer of tokens. This includes
504      * minting and burning.
505      *
506      * Calling conditions:
507      *
508      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
509      * will be transferred to `to`.
510      * - when `from` is zero, `amount` tokens will be minted for `to`.
511      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
512      * - `from` and `to` are never both zero.
513      *
514      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
515      */
516     function _beforeTokenTransfer(
517         address from,
518         address to,
519         uint256 amount
520     ) internal virtual {}
521 
522     /**
523      * @dev Hook that is called after any transfer of tokens. This includes
524      * minting and burning.
525      *
526      * Calling conditions:
527      *
528      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
529      * has been transferred to `to`.
530      * - when `from` is zero, `amount` tokens have been minted for `to`.
531      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
532      * - `from` and `to` are never both zero.
533      *
534      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
535      */
536     function _afterTokenTransfer(
537         address from,
538         address to,
539         uint256 amount
540     ) internal virtual {}
541 }
542 
543 /* pragma solidity ^0.8.0; */
544 
545 // CAUTION
546 // This version of SafeMath should only be used with Solidity 0.8 or later,
547 // because it relies on the compiler's built in overflow checks.
548 
549 /**
550  * @dev Wrappers over Solidity's arithmetic operations.
551  *
552  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
553  * now has built in overflow checking.
554  */
555 library SafeMath {
556     /**
557      * @dev Returns the addition of two unsigned integers, with an overflow flag.
558      *
559      * _Available since v3.4._
560      */
561     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
562         unchecked {
563             uint256 c = a + b;
564             if (c < a) return (false, 0);
565             return (true, c);
566         }
567     }
568 
569     /**
570      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
571      *
572      * _Available since v3.4._
573      */
574     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
575         unchecked {
576             if (b > a) return (false, 0);
577             return (true, a - b);
578         }
579     }
580 
581     /**
582      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
583      *
584      * _Available since v3.4._
585      */
586     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
587         unchecked {
588             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
589             // benefit is lost if 'b' is also tested.
590             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
591             if (a == 0) return (true, 0);
592             uint256 c = a * b;
593             if (c / a != b) return (false, 0);
594             return (true, c);
595         }
596     }
597 
598     /**
599      * @dev Returns the division of two unsigned integers, with a division by zero flag.
600      *
601      * _Available since v3.4._
602      */
603     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
604         unchecked {
605             if (b == 0) return (false, 0);
606             return (true, a / b);
607         }
608     }
609 
610     /**
611      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
612      *
613      * _Available since v3.4._
614      */
615     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
616         unchecked {
617             if (b == 0) return (false, 0);
618             return (true, a % b);
619         }
620     }
621 
622     /**
623      * @dev Returns the addition of two unsigned integers, reverting on
624      * overflow.
625      *
626      * Counterpart to Solidity's `+` operator.
627      *
628      * Requirements:
629      *
630      * - Addition cannot overflow.
631      */
632     function add(uint256 a, uint256 b) internal pure returns (uint256) {
633         return a + b;
634     }
635 
636     /**
637      * @dev Returns the subtraction of two unsigned integers, reverting on
638      * overflow (when the result is negative).
639      *
640      * Counterpart to Solidity's `-` operator.
641      *
642      * Requirements:
643      *
644      * - Subtraction cannot overflow.
645      */
646     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
647         return a - b;
648     }
649 
650     /**
651      * @dev Returns the multiplication of two unsigned integers, reverting on
652      * overflow.
653      *
654      * Counterpart to Solidity's `*` operator.
655      *
656      * Requirements:
657      *
658      * - Multiplication cannot overflow.
659      */
660     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
661         return a * b;
662     }
663 
664     /**
665      * @dev Returns the integer division of two unsigned integers, reverting on
666      * division by zero. The result is rounded towards zero.
667      *
668      * Counterpart to Solidity's `/` operator.
669      *
670      * Requirements:
671      *
672      * - The divisor cannot be zero.
673      */
674     function div(uint256 a, uint256 b) internal pure returns (uint256) {
675         return a / b;
676     }
677 
678     /**
679      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
680      * reverting when dividing by zero.
681      *
682      * Counterpart to Solidity's `%` operator. This function uses a `revert`
683      * opcode (which leaves remaining gas untouched) while Solidity uses an
684      * invalid opcode to revert (consuming all remaining gas).
685      *
686      * Requirements:
687      *
688      * - The divisor cannot be zero.
689      */
690     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
691         return a % b;
692     }
693 
694     /**
695      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
696      * overflow (when the result is negative).
697      *
698      * CAUTION: This function is deprecated because it requires allocating memory for the error
699      * message unnecessarily. For custom revert reasons use {trySub}.
700      *
701      * Counterpart to Solidity's `-` operator.
702      *
703      * Requirements:
704      *
705      * - Subtraction cannot overflow.
706      */
707     function sub(
708         uint256 a,
709         uint256 b,
710         string memory errorMessage
711     ) internal pure returns (uint256) {
712         unchecked {
713             require(b <= a, errorMessage);
714             return a - b;
715         }
716     }
717 
718     /**
719      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
720      * division by zero. The result is rounded towards zero.
721      *
722      * Counterpart to Solidity's `/` operator. Note: this function uses a
723      * `revert` opcode (which leaves remaining gas untouched) while Solidity
724      * uses an invalid opcode to revert (consuming all remaining gas).
725      *
726      * Requirements:
727      *
728      * - The divisor cannot be zero.
729      */
730     function div(
731         uint256 a,
732         uint256 b,
733         string memory errorMessage
734     ) internal pure returns (uint256) {
735         unchecked {
736             require(b > 0, errorMessage);
737             return a / b;
738         }
739     }
740 
741     /**
742      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
743      * reverting with custom message when dividing by zero.
744      *
745      * CAUTION: This function is deprecated because it requires allocating memory for the error
746      * message unnecessarily. For custom revert reasons use {tryMod}.
747      *
748      * Counterpart to Solidity's `%` operator. This function uses a `revert`
749      * opcode (which leaves remaining gas untouched) while Solidity uses an
750      * invalid opcode to revert (consuming all remaining gas).
751      *
752      * Requirements:
753      *
754      * - The divisor cannot be zero.
755      */
756     function mod(
757         uint256 a,
758         uint256 b,
759         string memory errorMessage
760     ) internal pure returns (uint256) {
761         unchecked {
762             require(b > 0, errorMessage);
763             return a % b;
764         }
765     }
766 }
767 
768 ////// src/IUniswapV2Factory.sol
769 /* pragma solidity 0.8.10; */
770 /* pragma experimental ABIEncoderV2; */
771 
772 interface IUniswapV2Factory {
773     event PairCreated(
774         address indexed token0,
775         address indexed token1,
776         address pair,
777         uint256
778     );
779 
780     function feeTo() external view returns (address);
781 
782     function feeToSetter() external view returns (address);
783 
784     function getPair(address tokenA, address tokenB)
785         external
786         view
787         returns (address pair);
788 
789     function allPairs(uint256) external view returns (address pair);
790 
791     function allPairsLength() external view returns (uint256);
792 
793     function createPair(address tokenA, address tokenB)
794         external
795         returns (address pair);
796 
797     function setFeeTo(address) external;
798 
799     function setFeeToSetter(address) external;
800 }
801 
802 /* pragma solidity 0.8.10; */
803 /* pragma experimental ABIEncoderV2; */
804 
805 interface IUniswapV2Pair {
806     event Approval(
807         address indexed owner,
808         address indexed spender,
809         uint256 value
810     );
811     event Transfer(address indexed from, address indexed to, uint256 value);
812 
813     function name() external pure returns (string memory);
814 
815     function symbol() external pure returns (string memory);
816 
817     function decimals() external pure returns (uint8);
818 
819     function totalSupply() external view returns (uint256);
820 
821     function balanceOf(address owner) external view returns (uint256);
822 
823     function allowance(address owner, address spender)
824         external
825         view
826         returns (uint256);
827 
828     function approve(address spender, uint256 value) external returns (bool);
829 
830     function transfer(address to, uint256 value) external returns (bool);
831 
832     function transferFrom(
833         address from,
834         address to,
835         uint256 value
836     ) external returns (bool);
837 
838     function DOMAIN_SEPARATOR() external view returns (bytes32);
839 
840     function PERMIT_TYPEHASH() external pure returns (bytes32);
841 
842     function nonces(address owner) external view returns (uint256);
843 
844     function permit(
845         address owner,
846         address spender,
847         uint256 value,
848         uint256 deadline,
849         uint8 v,
850         bytes32 r,
851         bytes32 s
852     ) external;
853 
854     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
855     event Burn(
856         address indexed sender,
857         uint256 amount0,
858         uint256 amount1,
859         address indexed to
860     );
861     event Swap(
862         address indexed sender,
863         uint256 amount0In,
864         uint256 amount1In,
865         uint256 amount0Out,
866         uint256 amount1Out,
867         address indexed to
868     );
869     event Sync(uint112 reserve0, uint112 reserve1);
870 
871     function MINIMUM_LIQUIDITY() external pure returns (uint256);
872 
873     function factory() external view returns (address);
874 
875     function token0() external view returns (address);
876 
877     function token1() external view returns (address);
878 
879     function getReserves()
880         external
881         view
882         returns (
883             uint112 reserve0,
884             uint112 reserve1,
885             uint32 blockTimestampLast
886         );
887 
888     function price0CumulativeLast() external view returns (uint256);
889 
890     function price1CumulativeLast() external view returns (uint256);
891 
892     function kLast() external view returns (uint256);
893 
894     function mint(address to) external returns (uint256 liquidity);
895 
896     function burn(address to)
897         external
898         returns (uint256 amount0, uint256 amount1);
899 
900     function swap(
901         uint256 amount0Out,
902         uint256 amount1Out,
903         address to,
904         bytes calldata data
905     ) external;
906 
907     function skim(address to) external;
908 
909     function sync() external;
910 
911     function initialize(address, address) external;
912 }
913 
914 /* pragma solidity 0.8.10; */
915 /* pragma experimental ABIEncoderV2; */
916 
917 interface IUniswapV2Router02 {
918     function factory() external pure returns (address);
919 
920     function WETH() external pure returns (address);
921 
922     function addLiquidity(
923         address tokenA,
924         address tokenB,
925         uint256 amountADesired,
926         uint256 amountBDesired,
927         uint256 amountAMin,
928         uint256 amountBMin,
929         address to,
930         uint256 deadline
931     )
932         external
933         returns (
934             uint256 amountA,
935             uint256 amountB,
936             uint256 liquidity
937         );
938 
939     function addLiquidityETH(
940         address token,
941         uint256 amountTokenDesired,
942         uint256 amountTokenMin,
943         uint256 amountETHMin,
944         address to,
945         uint256 deadline
946     )
947         external
948         payable
949         returns (
950             uint256 amountToken,
951             uint256 amountETH,
952             uint256 liquidity
953         );
954 
955     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
956         uint256 amountIn,
957         uint256 amountOutMin,
958         address[] calldata path,
959         address to,
960         uint256 deadline
961     ) external;
962 
963     function swapExactETHForTokensSupportingFeeOnTransferTokens(
964         uint256 amountOutMin,
965         address[] calldata path,
966         address to,
967         uint256 deadline
968     ) external payable;
969 
970     function swapExactTokensForETHSupportingFeeOnTransferTokens(
971         uint256 amountIn,
972         uint256 amountOutMin,
973         address[] calldata path,
974         address to,
975         uint256 deadline
976     ) external;
977 }
978 
979 /* pragma solidity >=0.8.10; */
980 
981 contract Bladys is ERC20, Ownable {
982     using SafeMath for uint256;
983 
984     IUniswapV2Router02 public immutable uniswapV2Router;
985     address public immutable uniswapV2Pair;
986 
987     address private constant ROUTER_ADDRESS = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
988     address public constant DEAD_ADDRESS = address(0xdead);
989     address public constant ZERO_ADDRESS = address(0x0);
990 
991     bool private swapping;
992 
993     address public marketingWallet;
994     address public devWallet;
995 
996     uint256 public maxTransactionAmount;
997     uint256 public swapTokensAtAmount;
998     uint256 public maxWallet;
999 
1000     uint256 public percentForLPBurn = 25; // 25 = .25%
1001     bool public lpBurnEnabled = false;
1002     uint256 public lpBurnFrequency = 3600 seconds;
1003     uint256 public lastLpBurnTime;
1004 
1005     uint256 public manualBurnFrequency = 30 minutes;
1006     uint256 public lastManualLpBurnTime;
1007 
1008     bool public limitsInEffect = true;
1009     bool public tradingActive = false;
1010     bool public swapEnabled = false;
1011     
1012     // Anti-bot and anti-whale mappings and variables
1013     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1014     bool public transferDelayEnabled = true;
1015     uint256 private launchBlock;
1016     uint256 private deadBlocks;
1017     mapping(address => bool) public blocked;
1018 
1019     uint256 public buyTotalFees;
1020     uint256 public buyMarketingFee;
1021     uint256 public buyLiquidityFee;
1022     uint256 public buyDevFee;
1023 
1024     uint256 public sellTotalFees;
1025     uint256 public sellMarketingFee;
1026     uint256 public sellLiquidityFee;
1027     uint256 public sellDevFee;
1028 
1029     uint256 public tokensForMarketing;
1030     uint256 public tokensForLiquidity;
1031     uint256 public tokensForDev;
1032 
1033     /******************/
1034 
1035     // exlcude from fees and max transaction amount
1036     mapping(address => bool) private _isExcludedFromFees;
1037     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1038 
1039     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1040     // could be subject to a maximum transfer amount
1041     mapping(address => bool) public automatedMarketMakerPairs;
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
1052     event marketingWalletUpdated(
1053         address indexed newWallet,
1054         address indexed oldWallet
1055     );
1056 
1057     event devWalletUpdated(
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
1068     event AutoNukeLP();
1069 
1070     event ManualNukeLP();
1071 
1072     constructor() ERC20("Baby Milady", "BLADYS") {
1073         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1074             ROUTER_ADDRESS
1075         );
1076 
1077         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1078         uniswapV2Router = _uniswapV2Router;
1079 
1080         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1081             .createPair(address(this), _uniswapV2Router.WETH());
1082         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1083         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1084 
1085         uint256 _buyMarketingFee = 19;
1086         uint256 _buyLiquidityFee = 1;
1087         uint256 _buyDevFee = 0;
1088 
1089         uint256 _sellMarketingFee = 69;
1090         uint256 _sellLiquidityFee = 1;
1091         uint256 _sellDevFee = 0;
1092 
1093         uint256 totalSupply = 888_000_888_000_888 * 1e18;
1094 
1095         maxTransactionAmount = 17_760_017_760_018 * 1e18; // 
1096         maxWallet = 17_760_017_760_018 * 1e18; // 
1097         swapTokensAtAmount = (totalSupply * 3) / 1000; // 
1098 
1099         buyMarketingFee = _buyMarketingFee;
1100         buyLiquidityFee = _buyLiquidityFee;
1101         buyDevFee = _buyDevFee;
1102         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1103 
1104         sellMarketingFee = _sellMarketingFee;
1105         sellLiquidityFee = _sellLiquidityFee;
1106         sellDevFee = _sellDevFee;
1107         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1108 
1109         marketingWallet = address(msg.sender); // set as marketing wallet
1110         devWallet = address(msg.sender); // set as dev wallet
1111 
1112         // exclude from paying fees or having max transaction amount
1113         excludeFromFees(owner(), true);
1114         excludeFromFees(address(this), true);
1115         excludeFromFees(DEAD_ADDRESS, true);
1116 
1117         excludeFromMaxTransaction(owner(), true);
1118         excludeFromMaxTransaction(address(this), true);
1119         excludeFromMaxTransaction(DEAD_ADDRESS, true);
1120 
1121         /*
1122             _mint is an internal function in ERC20.sol that is only called here,
1123             and CANNOT be called ever again
1124         */
1125         _mint(msg.sender, totalSupply);
1126     }
1127 
1128     receive() external payable {}
1129 
1130     // public true burn 
1131     function burn(uint256 amount) public {
1132         _burn(_msgSender(), amount);
1133     }
1134 
1135     // once enabled, can never be turned off
1136     function goLive(uint256 _deadBlocks) external onlyOwner {
1137         require(!tradingActive, "Token launched");
1138         tradingActive = true;
1139         launchBlock = block.number;
1140         swapEnabled = true;
1141         deadBlocks = _deadBlocks;
1142         lastLpBurnTime = block.timestamp;
1143     }
1144 
1145     // remove limits after token is stable
1146     function removeLimits() external onlyOwner returns (bool) {
1147         limitsInEffect = false;
1148         return true;
1149     }
1150 
1151     // disable Transfer delay - cannot be reenabled
1152     function disableTransferDelay() external onlyOwner returns (bool) {
1153         transferDelayEnabled = false;
1154         return true;
1155     }
1156 
1157     // change the minimum amount of tokens to sell from fees
1158     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner
1159         returns (bool)
1160     {
1161         require(
1162             newAmount >= (totalSupply() * 1) / 100000,
1163             "Swap amount cannot be lower than 0.001% total supply."
1164         );
1165         require(
1166             newAmount <= (totalSupply() * 5) / 1000,
1167             "Swap amount cannot be higher than 0.5% total supply."
1168         );
1169         swapTokensAtAmount = newAmount;
1170         return true;
1171     }
1172 
1173     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1174         require(
1175             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1176             "Cannot set maxTransactionAmount lower than 0.5%"
1177         );
1178         maxTransactionAmount = newNum * (10**18);
1179     }
1180 
1181     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1182         require(
1183             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1184             "Cannot set maxWallet lower than 0.5%"
1185         );
1186         maxWallet = newNum * (10**18);
1187     }
1188 
1189     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1190         _isExcludedMaxTransactionAmount[updAds] = isEx;
1191     }
1192 
1193     // only use to disable contract sales if absolutely necessary (emergency use only)
1194     function updateSwapEnabled(bool enabled) external onlyOwner {
1195         swapEnabled = enabled;
1196     }
1197 
1198     function updateBuyFees(
1199         uint256 _marketingFee,
1200         uint256 _liquidityFee,
1201         uint256 _devFee
1202     ) external onlyOwner {
1203         buyMarketingFee = _marketingFee;
1204         buyLiquidityFee = _liquidityFee;
1205         buyDevFee = _devFee;
1206         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1207         require(buyTotalFees <= 99, "Must keep fees at 99% or less");
1208     }
1209 
1210     function updateSellFees(
1211         uint256 _marketingFee,
1212         uint256 _liquidityFee,
1213         uint256 _devFee
1214     ) external onlyOwner {
1215         sellMarketingFee = _marketingFee;
1216         sellLiquidityFee = _liquidityFee;
1217         sellDevFee = _devFee;
1218         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1219         require(sellTotalFees <= 99, "Must keep fees at 99% or less");
1220     }
1221 
1222     function excludeFromFees(address account, bool excluded) public onlyOwner {
1223         _isExcludedFromFees[account] = excluded;
1224         emit ExcludeFromFees(account, excluded);
1225     }
1226 
1227     function setAutomatedMarketMakerPair(address pair, bool value)
1228         public
1229         onlyOwner
1230     {
1231         require(
1232             pair != uniswapV2Pair,
1233             "The pair cannot be removed from automatedMarketMakerPairs"
1234         );
1235 
1236         _setAutomatedMarketMakerPair(pair, value);
1237     }
1238 
1239     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1240         automatedMarketMakerPairs[pair] = value;
1241 
1242         emit SetAutomatedMarketMakerPair(pair, value);
1243     }
1244 
1245     function updateMarketingWallet(address newMarketingWallet)
1246         external
1247         onlyOwner
1248     {
1249         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1250         marketingWallet = newMarketingWallet;
1251     }
1252 
1253     function updateDevWallet(address newWallet) external onlyOwner {
1254         emit devWalletUpdated(newWallet, devWallet);
1255         devWallet = newWallet;
1256     }
1257 
1258     function isExcludedFromFees(address account) public view returns (bool) {
1259         return _isExcludedFromFees[account];
1260     }
1261 
1262     event BoughtEarly(address indexed sniper);
1263 
1264     function _transfer(
1265         address from,
1266         address to,
1267         uint256 amount
1268     ) internal override {
1269         require(to != DEAD_ADDRESS && 
1270                 to != ZERO_ADDRESS, "Use burn function for true burn");
1271         require(!blocked[from], "Sniper blocked");
1272 
1273         if (amount == 0) {
1274             super._transfer(from, to, 0);
1275             return;
1276         }
1277 
1278         if (limitsInEffect) {
1279             if (
1280                 from != owner() &&
1281                 to != owner() &&
1282                 to != ZERO_ADDRESS &&
1283                 to != DEAD_ADDRESS &&
1284                 !swapping
1285             ) {
1286                 if (!tradingActive) {
1287                     require(
1288                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1289                         "Trading is not active."
1290                     );
1291                 }
1292 
1293                 if(block.number <= launchBlock + deadBlocks && from == address(uniswapV2Pair) &&  
1294                 to != ROUTER_ADDRESS && to != address(this) && to != address(uniswapV2Pair)){
1295                     blocked[to] = true;
1296                     emit BoughtEarly(to);
1297                 }
1298 
1299                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1300                 if (transferDelayEnabled) {
1301                     if (
1302                         to != owner() &&
1303                         to != ROUTER_ADDRESS &&
1304                         to != address(uniswapV2Pair)
1305                     ) {
1306                         require(
1307                             _holderLastTransferTimestamp[tx.origin] <
1308                                 block.number,
1309                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1310                         );
1311                         _holderLastTransferTimestamp[tx.origin] = block.number;
1312                     }
1313                 }
1314 
1315 
1316                 //when buy
1317                 if (
1318                     automatedMarketMakerPairs[from] &&
1319                     !_isExcludedMaxTransactionAmount[to]
1320                 ) {
1321                     require(
1322                         amount <= maxTransactionAmount,
1323                         "Buy transfer amount exceeds the maxTransactionAmount."
1324                     );
1325                     require(
1326                         amount + balanceOf(to) <= maxWallet,
1327                         "Max wallet exceeded"
1328                     );
1329                 }
1330                 //when sell
1331                 else if (
1332                     automatedMarketMakerPairs[to] &&
1333                     !_isExcludedMaxTransactionAmount[from]
1334                 ) {
1335                     require(
1336                         amount <= maxTransactionAmount,
1337                         "Sell transfer amount exceeds the maxTransactionAmount."
1338                     );
1339                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1340                     require(
1341                         amount + balanceOf(to) <= maxWallet,
1342                         "Max wallet exceeded"
1343                     );
1344                 }
1345             }
1346         }
1347 
1348         uint256 contractTokenBalance = balanceOf(address(this));
1349 
1350         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1351 
1352         if (
1353             canSwap &&
1354             swapEnabled &&
1355             !swapping &&
1356             !automatedMarketMakerPairs[from] &&
1357             !_isExcludedFromFees[from] &&
1358             !_isExcludedFromFees[to]
1359         ) {
1360             swapping = true;
1361 
1362             swapBack();
1363 
1364             swapping = false;
1365         }
1366 
1367         if (
1368             !swapping &&
1369             automatedMarketMakerPairs[to] &&
1370             lpBurnEnabled &&
1371             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1372             !_isExcludedFromFees[from]
1373         ) {
1374             autoBurnLiquidityPairTokens();
1375         }
1376 
1377         bool takeFee = !swapping;
1378 
1379         // if any account belongs to _isExcludedFromFee account then remove the fee
1380         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1381             takeFee = false;
1382         }
1383 
1384         uint256 fees = 0;
1385         // only take fees on buys/sells, do not take on wallet transfers
1386         if (takeFee) {
1387             // on sell
1388             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1389                 fees = amount.mul(sellTotalFees).div(100);
1390                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1391                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1392                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1393             }
1394             // on buy
1395             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1396                 fees = amount.mul(buyTotalFees).div(100);
1397                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1398                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1399                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1400             }
1401 
1402             if (fees > 0) {
1403                 super._transfer(from, address(this), fees);
1404             }
1405 
1406             amount -= fees;
1407         }
1408 
1409         super._transfer(from, to, amount);
1410     }
1411 
1412     function swapTokensForEth(uint256 tokenAmount) private {
1413         // generate the uniswap pair path of token -> weth
1414         address[] memory path = new address[](2);
1415         path[0] = address(this);
1416         path[1] = uniswapV2Router.WETH();
1417 
1418         _approve(address(this), address(uniswapV2Router), tokenAmount);
1419 
1420         // make the swap
1421         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1422             tokenAmount,
1423             0, // accept any amount of ETH
1424             path,
1425             address(this),
1426             block.timestamp
1427         );
1428     }
1429 
1430     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1431         // approve token transfer to cover all possible scenarios
1432         _approve(address(this), address(uniswapV2Router), tokenAmount);
1433 
1434         // add the liquidity
1435         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1436             address(this),
1437             tokenAmount,
1438             0, // slippage is unavoidable
1439             0, // slippage is unavoidable
1440             DEAD_ADDRESS,
1441             block.timestamp
1442         );
1443     }
1444 
1445     function multiBlock(address[] calldata blockees, bool shouldBlock) external onlyOwner {
1446         for(uint256 i = 0;i<blockees.length;i++){
1447             address blockee = blockees[i];
1448             if(blockee != address(this) && 
1449                blockee != ROUTER_ADDRESS && 
1450                blockee != address(uniswapV2Pair))
1451                 blocked[blockee] = shouldBlock;
1452         }
1453     }
1454 
1455     function swapBack() private {
1456         uint256 contractBalance = balanceOf(address(this));
1457         uint256 totalTokensToSwap = tokensForLiquidity +
1458             tokensForMarketing +
1459             tokensForDev;
1460         bool success;
1461 
1462         if (contractBalance == 0 || totalTokensToSwap == 0) {
1463             return;
1464         }
1465 
1466         if (contractBalance > swapTokensAtAmount * 20) {
1467             contractBalance = swapTokensAtAmount * 20;
1468         }
1469 
1470         // Halve the amount of liquidity tokens
1471         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1472             totalTokensToSwap /
1473             2;
1474         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1475 
1476         uint256 initialETHBalance = address(this).balance;
1477 
1478         swapTokensForEth(amountToSwapForETH);
1479 
1480         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1481 
1482         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1483             totalTokensToSwap
1484         );
1485         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1486 
1487         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1488 
1489         tokensForLiquidity = 0;
1490         tokensForMarketing = 0;
1491         tokensForDev = 0;
1492 
1493         (success, ) = address(devWallet).call{value: ethForDev}("");
1494 
1495         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1496             addLiquidity(liquidityTokens, ethForLiquidity);
1497             emit SwapAndLiquify(
1498                 amountToSwapForETH,
1499                 ethForLiquidity,
1500                 tokensForLiquidity
1501             );
1502         }
1503 
1504         (success, ) = address(marketingWallet).call{
1505             value: address(this).balance
1506         }("");
1507     }
1508 
1509     function setAutoLPBurnSettings(
1510         uint256 _frequencyInSeconds,
1511         uint256 _percent,
1512         bool _Enabled
1513     ) external onlyOwner {
1514         require(
1515             _frequencyInSeconds >= 600,
1516             "cannot set buyback more often than every 10 minutes"
1517         );
1518         require(
1519             _percent <= 1000 && _percent >= 0,
1520             "Must set auto LP burn percent between 0% and 10%"
1521         );
1522         lpBurnFrequency = _frequencyInSeconds;
1523         percentForLPBurn = _percent;
1524         lpBurnEnabled = _Enabled;
1525     }
1526 
1527     function autoBurnLiquidityPairTokens() internal returns (bool) {
1528         lastLpBurnTime = block.timestamp;
1529 
1530         // get balance of liquidity pair
1531         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1532 
1533         // calculate amount to burn
1534         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1535             10000
1536         );
1537 
1538         // pull tokens from uniswapPair liquidity and perform true burn
1539         if (amountToBurn > 0) {
1540             _burn(uniswapV2Pair, amountToBurn);
1541         }
1542 
1543         //sync price since this is not in a swap transaction!
1544         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1545         pair.sync();
1546         emit AutoNukeLP();
1547         return true;
1548     }
1549     
1550     function manualBurnLiquidityPairTokens(uint256 percent)
1551         external
1552         onlyOwner
1553         returns (bool)
1554     {
1555         require(
1556             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1557             "Must wait for cooldown to finish"
1558         );
1559         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1560         lastManualLpBurnTime = block.timestamp;
1561 
1562         // get balance of liquidity pair
1563         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1564 
1565         // calculate amount to burn
1566         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1567 
1568         // pull tokens from uniswapPair liquidity and perform true burn
1569         if (amountToBurn > 0) {
1570             _burn(uniswapV2Pair, amountToBurn);
1571         }
1572 
1573         //sync price since this is not in a swap transaction!
1574         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1575         pair.sync();
1576         emit ManualNukeLP();
1577         return true;
1578     }
1579 }