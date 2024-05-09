1 /**
2  * SPDX-License-Identifier: MIT
3  * https://twitter.com/BurgerKingUK/status/1644791723170619396
4  * BiteCoin By Burger King
5  */
6 pragma solidity >=0.8.19;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 
18 abstract contract Ownable is Context {
19     address private _owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     /**
24      * @dev Initializes the contract setting the deployer as the initial owner.
25      */
26     constructor() {
27         _transferOwnership(_msgSender());
28     }
29 
30     /**
31      * @dev Returns the address of the current owner.
32      */
33     function owner() public view virtual returns (address) {
34         return _owner;
35     }
36 
37     /**
38      * @dev Throws if called by any account other than the owner.
39      */
40     modifier onlyOwner() {
41         require(owner() == _msgSender(), "Ownable: caller is not the owner");
42         _;
43     }
44 
45     /**
46      * @dev Leaves the contract without owner. It will not be possible to call
47      * `onlyOwner` functions anymore. Can only be called by the current owner.
48      *
49      * NOTE: Renouncing ownership will leave the contract without an owner,
50      * thereby removing any functionality that is only available to the owner.
51      */
52     function renounceOwnership() public virtual onlyOwner {
53         _transferOwnership(address(0));
54     }
55 
56     /**
57      * @dev Transfers ownership of the contract to a new account (`newOwner`).
58      * Can only be called by the current owner.
59      */
60     function transferOwnership(address newOwner) public virtual onlyOwner {
61         require(newOwner != address(0), "Ownable: new owner is the zero address");
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers ownership of the contract to a new account (`newOwner`).
67      * Internal function without access restriction.
68      */
69     function _transferOwnership(address newOwner) internal virtual {
70         address oldOwner = _owner;
71         _owner = newOwner;
72         emit OwnershipTransferred(oldOwner, newOwner);
73     }
74 }
75 
76 interface IERC20 {
77     /**
78      * @dev Returns the amount of tokens in existence.
79      */
80     function totalSupply() external view returns (uint256);
81 
82     /**
83      * @dev Returns the amount of tokens owned by `account`.
84      */
85     function balanceOf(address account) external view returns (uint256);
86 
87     /**
88      * @dev Moves `amount` tokens from the caller's account to `recipient`.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transfer(address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Returns the remaining number of tokens that `spender` will be
98      * allowed to spend on behalf of `owner` through {transferFrom}. This is
99      * zero by default.
100      *
101      * This value changes when {approve} or {transferFrom} are called.
102      */
103     function allowance(address owner, address spender) external view returns (uint256);
104 
105     /**
106      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * IMPORTANT: Beware that changing an allowance with this method brings the risk
111      * that someone may use both the old and the new allowance by unfortunate
112      * transaction ordering. One possible solution to mitigate this race
113      * condition is to first reduce the spender's allowance to 0 and set the
114      * desired value afterwards:
115      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address spender, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Moves `amount` tokens from `sender` to `recipient` using the
123      * allowance mechanism. `amount` is then deducted from the caller's
124      * allowance.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transferFrom(
131         address sender,
132         address recipient,
133         uint256 amount
134     ) external returns (bool);
135 
136     /**
137      * @dev Emitted when `value` tokens are moved from one account (`from`) to
138      * another (`to`).
139      *
140      * Note that `value` may be zero.
141      */
142     event Transfer(address indexed from, address indexed to, uint256 value);
143 
144     /**
145      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
146      * a call to {approve}. `value` is the new allowance.
147      */
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 interface IERC20Metadata is IERC20 {
152     /**
153      * @dev Returns the name of the token.
154      */
155     function name() external view returns (string memory);
156 
157     /**
158      * @dev Returns the symbol of the token.
159      */
160     function symbol() external view returns (string memory);
161 
162     /**
163      * @dev Returns the decimals places of the token.
164      */
165     function decimals() external view returns (uint8);
166 }
167 
168 contract ERC20 is Context, IERC20, IERC20Metadata {
169     mapping(address => uint256) private _balances;
170 
171     mapping(address => mapping(address => uint256)) private _allowances;
172 
173     uint256 private _totalSupply;
174 
175     string private _name;
176     string private _symbol;
177 
178     /**
179      * @dev Sets the values for {name} and {symbol}.
180      *
181      * The default value of {decimals} is 18. To select a different value for
182      * {decimals} you should overload it.
183      *
184      * All two of these values are immutable: they can only be set once during
185      * construction.
186      */
187     constructor(string memory name_, string memory symbol_) {
188         _name = name_;
189         _symbol = symbol_;
190     }
191 
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() public view virtual override returns (string memory) {
196         return _name;
197     }
198 
199     /**
200      * @dev Returns the symbol of the token, usually a shorter version of the
201      * name.
202      */
203     function symbol() public view virtual override returns (string memory) {
204         return _symbol;
205     }
206 
207     /**
208      * @dev Returns the number of decimals used to get its user representation.
209      * For example, if `decimals` equals `2`, a balance of `505` tokens should
210      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
211      *
212      * Tokens usually opt for a value of 18, imitating the relationship between
213      * Ether and Wei. This is the value {ERC20} uses, unless this function is
214      * overridden;
215      *
216      * NOTE: This information is only used for _display_ purposes: it in
217      * no way affects any of the arithmetic of the contract, including
218      * {IERC20-balanceOf} and {IERC20-transfer}.
219      */
220     function decimals() public view virtual override returns (uint8) {
221         return 18;
222     }
223 
224     /**
225      * @dev See {IERC20-totalSupply}.
226      */
227     function totalSupply() public view virtual override returns (uint256) {
228         return _totalSupply;
229     }
230 
231     /**
232      * @dev See {IERC20-balanceOf}.
233      */
234     function balanceOf(address account) public view virtual override returns (uint256) {
235         return _balances[account];
236     }
237 
238     /**
239      * @dev See {IERC20-transfer}.
240      *
241      * Requirements:
242      *
243      * - `recipient` cannot be the zero address.
244      * - the caller must have a balance of at least `amount`.
245      */
246     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250 
251     /**
252      * @dev See {IERC20-allowance}.
253      */
254     function allowance(address owner, address spender) public view virtual override returns (uint256) {
255         return _allowances[owner][spender];
256     }
257 
258     /**
259      * @dev See {IERC20-approve}.
260      *
261      * Requirements:
262      *
263      * - `spender` cannot be the zero address.
264      */
265     function approve(address spender, uint256 amount) public virtual override returns (bool) {
266         _approve(_msgSender(), spender, amount);
267         return true;
268     }
269 
270     /**
271      * @dev See {IERC20-transferFrom}.
272      *
273      * Emits an {Approval} event indicating the updated allowance. This is not
274      * required by the EIP. See the note at the beginning of {ERC20}.
275      *
276      * Requirements:
277      *
278      * - `sender` and `recipient` cannot be the zero address.
279      * - `sender` must have a balance of at least `amount`.
280      * - the caller must have allowance for ``sender``'s tokens of at least
281      * `amount`.
282      */
283     function transferFrom(
284         address sender,
285         address recipient,
286         uint256 amount
287     ) public virtual override returns (bool) {
288         _transfer(sender, recipient, amount);
289 
290         uint256 currentAllowance = _allowances[sender][_msgSender()];
291         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
292         unchecked {
293             _approve(sender, _msgSender(), currentAllowance - amount);
294         }
295 
296         return true;
297     }
298 
299     /**
300      * @dev Atomically increases the allowance granted to `spender` by the caller.
301      *
302      * This is an alternative to {approve} that can be used as a mitigation for
303      * problems described in {IERC20-approve}.
304      *
305      * Emits an {Approval} event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      */
311     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
312         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
313         return true;
314     }
315 
316     /**
317      * @dev Atomically decreases the allowance granted to `spender` by the caller.
318      *
319      * This is an alternative to {approve} that can be used as a mitigation for
320      * problems described in {IERC20-approve}.
321      *
322      * Emits an {Approval} event indicating the updated allowance.
323      *
324      * Requirements:
325      *
326      * - `spender` cannot be the zero address.
327      * - `spender` must have allowance for the caller of at least
328      * `subtractedValue`.
329      */
330     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
331         uint256 currentAllowance = _allowances[_msgSender()][spender];
332         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
333         unchecked {
334             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
335         }
336 
337         return true;
338     }
339 
340     /**
341      * @dev Moves `amount` of tokens from `sender` to `recipient`.
342      *
343      * This internal function is equivalent to {transfer}, and can be used to
344      * e.g. implement automatic token fees, slashing mechanisms, etc.
345      *
346      * Emits a {Transfer} event.
347      *
348      * Requirements:
349      *
350      * - `sender` cannot be the zero address.
351      * - `recipient` cannot be the zero address.
352      * - `sender` must have a balance of at least `amount`.
353      */
354     function _transfer(
355         address sender,
356         address recipient,
357         uint256 amount
358     ) internal virtual {
359         require(sender != address(0), "ERC20: transfer from the zero address");
360         require(recipient != address(0), "ERC20: transfer to the zero address");
361 
362         _beforeTokenTransfer(sender, recipient, amount);
363 
364         uint256 senderBalance = _balances[sender];
365         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
366         unchecked {
367             _balances[sender] = senderBalance - amount;
368         }
369         _balances[recipient] += amount;
370 
371         emit Transfer(sender, recipient, amount);
372 
373         _afterTokenTransfer(sender, recipient, amount);
374     }
375 
376     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
377      * the total supply.
378      *
379      * Emits a {Transfer} event with `from` set to the zero address.
380      *
381      * Requirements:
382      *
383      * - `account` cannot be the zero address.
384      */
385     function _mint(address account, uint256 amount) internal virtual {
386         require(account != address(0), "ERC20: mint to the zero address");
387 
388         _beforeTokenTransfer(address(0), account, amount);
389 
390         _totalSupply += amount;
391         _balances[account] += amount;
392         emit Transfer(address(0), account, amount);
393 
394         _afterTokenTransfer(address(0), account, amount);
395     }
396 
397     /**
398      * @dev Destroys `amount` tokens from `account`, reducing the
399      * total supply.
400      *
401      * Emits a {Transfer} event with `to` set to the zero address.
402      *
403      * Requirements:
404      *
405      * - `account` cannot be the zero address.
406      * - `account` must have at least `amount` tokens.
407      */
408     function _burn(address account, uint256 amount) internal virtual {
409         require(account != address(0), "ERC20: burn from the zero address");
410 
411         _beforeTokenTransfer(account, address(0), amount);
412 
413         uint256 accountBalance = _balances[account];
414         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
415         unchecked {
416             _balances[account] = accountBalance - amount;
417         }
418         _totalSupply -= amount;
419 
420         emit Transfer(account, address(0), amount);
421 
422         _afterTokenTransfer(account, address(0), amount);
423     }
424 
425     /**
426      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
427      *
428      * This internal function is equivalent to `approve`, and can be used to
429      * e.g. set automatic allowances for certain subsystems, etc.
430      *
431      * Emits an {Approval} event.
432      *
433      * Requirements:
434      *
435      * - `owner` cannot be the zero address.
436      * - `spender` cannot be the zero address.
437      */
438     function _approve(
439         address owner,
440         address spender,
441         uint256 amount
442     ) internal virtual {
443         require(owner != address(0), "ERC20: approve from the zero address");
444         require(spender != address(0), "ERC20: approve to the zero address");
445 
446         _allowances[owner][spender] = amount;
447         emit Approval(owner, spender, amount);
448     }
449 
450     /**
451      * @dev Hook that is called before any transfer of tokens. This includes
452      * minting and burning.
453      *
454      * Calling conditions:
455      *
456      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
457      * will be transferred to `to`.
458      * - when `from` is zero, `amount` tokens will be minted for `to`.
459      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
460      * - `from` and `to` are never both zero.
461      *
462      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
463      */
464     function _beforeTokenTransfer(
465         address from,
466         address to,
467         uint256 amount
468     ) internal virtual {}
469 
470     /**
471      * @dev Hook that is called after any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * has been transferred to `to`.
478      * - when `from` is zero, `amount` tokens have been minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _afterTokenTransfer(
485         address from,
486         address to,
487         uint256 amount
488     ) internal virtual {}
489 }
490 
491 library SafeMath {
492     /**
493      * @dev Returns the addition of two unsigned integers, with an overflow flag.
494      *
495      * _Available since v3.4._
496      */
497     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
498         unchecked {
499             uint256 c = a + b;
500             if (c < a) return (false, 0);
501             return (true, c);
502         }
503     }
504 
505     /**
506      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
507      *
508      * _Available since v3.4._
509      */
510     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
511         unchecked {
512             if (b > a) return (false, 0);
513             return (true, a - b);
514         }
515     }
516 
517     /**
518      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
519      *
520      * _Available since v3.4._
521      */
522     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
523         unchecked {
524             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
525             // benefit is lost if 'b' is also tested.
526             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
527             if (a == 0) return (true, 0);
528             uint256 c = a * b;
529             if (c / a != b) return (false, 0);
530             return (true, c);
531         }
532     }
533 
534     /**
535      * @dev Returns the division of two unsigned integers, with a division by zero flag.
536      *
537      * _Available since v3.4._
538      */
539     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
540         unchecked {
541             if (b == 0) return (false, 0);
542             return (true, a / b);
543         }
544     }
545 
546     /**
547      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
548      *
549      * _Available since v3.4._
550      */
551     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
552         unchecked {
553             if (b == 0) return (false, 0);
554             return (true, a % b);
555         }
556     }
557 
558     /**
559      * @dev Returns the addition of two unsigned integers, reverting on
560      * overflow.
561      *
562      * Counterpart to Solidity's `+` operator.
563      *
564      * Requirements:
565      *
566      * - Addition cannot overflow.
567      */
568     function add(uint256 a, uint256 b) internal pure returns (uint256) {
569         return a + b;
570     }
571 
572     /**
573      * @dev Returns the subtraction of two unsigned integers, reverting on
574      * overflow (when the result is negative).
575      *
576      * Counterpart to Solidity's `-` operator.
577      *
578      * Requirements:
579      *
580      * - Subtraction cannot overflow.
581      */
582     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
583         return a - b;
584     }
585 
586     /**
587      * @dev Returns the multiplication of two unsigned integers, reverting on
588      * overflow.
589      *
590      * Counterpart to Solidity's `*` operator.
591      *
592      * Requirements:
593      *
594      * - Multiplication cannot overflow.
595      */
596     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
597         return a * b;
598     }
599 
600     /**
601      * @dev Returns the integer division of two unsigned integers, reverting on
602      * division by zero. The result is rounded towards zero.
603      *
604      * Counterpart to Solidity's `/` operator.
605      *
606      * Requirements:
607      *
608      * - The divisor cannot be zero.
609      */
610     function div(uint256 a, uint256 b) internal pure returns (uint256) {
611         return a / b;
612     }
613 
614     /**
615      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
616      * reverting when dividing by zero.
617      *
618      * Counterpart to Solidity's `%` operator. This function uses a `revert`
619      * opcode (which leaves remaining gas untouched) while Solidity uses an
620      * invalid opcode to revert (consuming all remaining gas).
621      *
622      * Requirements:
623      *
624      * - The divisor cannot be zero.
625      */
626     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
627         return a % b;
628     }
629 
630     /**
631      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
632      * overflow (when the result is negative).
633      *
634      * CAUTION: This function is deprecated because it requires allocating memory for the error
635      * message unnecessarily. For custom revert reasons use {trySub}.
636      *
637      * Counterpart to Solidity's `-` operator.
638      *
639      * Requirements:
640      *
641      * - Subtraction cannot overflow.
642      */
643     function sub(
644         uint256 a,
645         uint256 b,
646         string memory errorMessage
647     ) internal pure returns (uint256) {
648         unchecked {
649             require(b <= a, errorMessage);
650             return a - b;
651         }
652     }
653 
654     /**
655      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
656      * division by zero. The result is rounded towards zero.
657      *
658      * Counterpart to Solidity's `/` operator. Note: this function uses a
659      * `revert` opcode (which leaves remaining gas untouched) while Solidity
660      * uses an invalid opcode to revert (consuming all remaining gas).
661      *
662      * Requirements:
663      *
664      * - The divisor cannot be zero.
665      */
666     function div(
667         uint256 a,
668         uint256 b,
669         string memory errorMessage
670     ) internal pure returns (uint256) {
671         unchecked {
672             require(b > 0, errorMessage);
673             return a / b;
674         }
675     }
676 
677     /**
678      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
679      * reverting with custom message when dividing by zero.
680      *
681      * CAUTION: This function is deprecated because it requires allocating memory for the error
682      * message unnecessarily. For custom revert reasons use {tryMod}.
683      *
684      * Counterpart to Solidity's `%` operator. This function uses a `revert`
685      * opcode (which leaves remaining gas untouched) while Solidity uses an
686      * invalid opcode to revert (consuming all remaining gas).
687      *
688      * Requirements:
689      *
690      * - The divisor cannot be zero.
691      */
692     function mod(
693         uint256 a,
694         uint256 b,
695         string memory errorMessage
696     ) internal pure returns (uint256) {
697         unchecked {
698             require(b > 0, errorMessage);
699             return a % b;
700         }
701     }
702 }
703 
704 interface IUniswapV2Factory {
705     event PairCreated(
706         address indexed token0,
707         address indexed token1,
708         address pair,
709         uint256
710     );
711 
712     function feeTo() external view returns (address);
713 
714     function feeToSetter() external view returns (address);
715 
716     function getPair(address tokenA, address tokenB)
717         external
718         view
719         returns (address pair);
720 
721     function allPairs(uint256) external view returns (address pair);
722 
723     function allPairsLength() external view returns (uint256);
724 
725     function createPair(address tokenA, address tokenB)
726         external
727         returns (address pair);
728 
729     function setFeeTo(address) external;
730 
731     function setFeeToSetter(address) external;
732 }
733 
734 interface IUniswapV2Pair {
735     event Approval(
736         address indexed owner,
737         address indexed spender,
738         uint256 value
739     );
740     event Transfer(address indexed from, address indexed to, uint256 value);
741 
742     function name() external pure returns (string memory);
743 
744     function symbol() external pure returns (string memory);
745 
746     function decimals() external pure returns (uint8);
747 
748     function totalSupply() external view returns (uint256);
749 
750     function balanceOf(address owner) external view returns (uint256);
751 
752     function allowance(address owner, address spender)
753         external
754         view
755         returns (uint256);
756 
757     function approve(address spender, uint256 value) external returns (bool);
758 
759     function transfer(address to, uint256 value) external returns (bool);
760 
761     function transferFrom(
762         address from,
763         address to,
764         uint256 value
765     ) external returns (bool);
766 
767     function DOMAIN_SEPARATOR() external view returns (bytes32);
768 
769     function PERMIT_TYPEHASH() external pure returns (bytes32);
770 
771     function nonces(address owner) external view returns (uint256);
772 
773     function permit(
774         address owner,
775         address spender,
776         uint256 value,
777         uint256 deadline,
778         uint8 v,
779         bytes32 r,
780         bytes32 s
781     ) external;
782 
783     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
784     event Burn(
785         address indexed sender,
786         uint256 amount0,
787         uint256 amount1,
788         address indexed to
789     );
790     event Swap(
791         address indexed sender,
792         uint256 amount0In,
793         uint256 amount1In,
794         uint256 amount0Out,
795         uint256 amount1Out,
796         address indexed to
797     );
798     event Sync(uint112 reserve0, uint112 reserve1);
799 
800     function MINIMUM_LIQUIDITY() external pure returns (uint256);
801 
802     function factory() external view returns (address);
803 
804     function token0() external view returns (address);
805 
806     function token1() external view returns (address);
807 
808     function getReserves()
809         external
810         view
811         returns (
812             uint112 reserve0,
813             uint112 reserve1,
814             uint32 blockTimestampLast
815         );
816 
817     function price0CumulativeLast() external view returns (uint256);
818 
819     function price1CumulativeLast() external view returns (uint256);
820 
821     function kLast() external view returns (uint256);
822 
823     function mint(address to) external returns (uint256 liquidity);
824 
825     function burn(address to)
826         external
827         returns (uint256 amount0, uint256 amount1);
828 
829     function swap(
830         uint256 amount0Out,
831         uint256 amount1Out,
832         address to,
833         bytes calldata data
834     ) external;
835 
836     function skim(address to) external;
837 
838     function sync() external;
839 
840     function initialize(address, address) external;
841 }
842 
843 interface IUniswapV2Router02 {
844     function factory() external pure returns (address);
845 
846     function WETH() external pure returns (address);
847 
848     function addLiquidity(
849         address tokenA,
850         address tokenB,
851         uint256 amountADesired,
852         uint256 amountBDesired,
853         uint256 amountAMin,
854         uint256 amountBMin,
855         address to,
856         uint256 deadline
857     )
858         external
859         returns (
860             uint256 amountA,
861             uint256 amountB,
862             uint256 liquidity
863         );
864 
865     function addLiquidityETH(
866         address token,
867         uint256 amountTokenDesired,
868         uint256 amountTokenMin,
869         uint256 amountETHMin,
870         address to,
871         uint256 deadline
872     )
873         external
874         payable
875         returns (
876             uint256 amountToken,
877             uint256 amountETH,
878             uint256 liquidity
879         );
880 
881     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
882         uint256 amountIn,
883         uint256 amountOutMin,
884         address[] calldata path,
885         address to,
886         uint256 deadline
887     ) external;
888 
889     function swapExactETHForTokensSupportingFeeOnTransferTokens(
890         uint256 amountOutMin,
891         address[] calldata path,
892         address to,
893         uint256 deadline
894     ) external payable;
895 
896     function swapExactTokensForETHSupportingFeeOnTransferTokens(
897         uint256 amountIn,
898         uint256 amountOutMin,
899         address[] calldata path,
900         address to,
901         uint256 deadline
902     ) external;
903 }
904 
905 contract BiteCoin is ERC20, Ownable {
906     using SafeMath for uint256;
907 
908     IUniswapV2Router02 public immutable uniswapV2Router;
909     address public immutable uniswapV2Pair;
910     address public constant deadAddress = address(0xdead);
911 
912     bool private swapping;
913 
914     address public marketingWallet;
915     address public devWallet;
916     address public lpWallet;
917 
918     uint256 public swapTokensAtAmount;
919     uint256 public maxTokensForSwapback;
920 
921     uint256 public maxTransactionAmount;
922     uint256 public maxWallet;
923 
924     uint256 public percentForLPBurn = 0;
925     bool public lpBurnEnabled = true;
926     uint256 public lpBurnFrequency = 36000 seconds;
927     uint256 public lastLpBurnTime;
928 
929     uint256 public manualBurnFrequency = 30 minutes;
930     uint256 public lastManualLpBurnTime;
931 
932     bool public limitsInEffect = true;
933     bool public tradingActive = false;
934     bool public swapEnabled = false;
935 
936     // Anti-bot and anti-whale mappings and variables
937     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
938     bool public transferDelayEnabled = true;
939 
940     uint256 public buyTotalFees;
941     uint256 public buyMarketingFee;
942     uint256 public buyLiquidityFee;
943     uint256 public buyDevFee;
944 
945     uint256 public sellTotalFees;
946     uint256 public sellMarketingFee;
947     uint256 public sellLiquidityFee;
948     uint256 public sellDevFee;
949 
950     uint256 public tokensForMarketing;
951     uint256 public tokensForLiquidity;
952     uint256 public tokensForDev;
953 
954     /******************/
955 
956     // exlcude from fees and max transaction amount
957     mapping(address => bool) private _isExcludedFromFees;
958     mapping(address => bool) public _isExcludedMaxTransactionAmount;
959 
960     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
961     // could be subject to a maximum transfer amount
962     mapping(address => bool) public automatedMarketMakerPairs;
963 
964     event UpdateUniswapV2Router(
965         address indexed newAddress,
966         address indexed oldAddress
967     );
968 
969     event ExcludeFromFees(address indexed account, bool isExcluded);
970 
971     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
972 
973     event marketingWalletUpdated(
974         address indexed newWallet,
975         address indexed oldWallet
976     );
977 
978     event devWalletUpdated(
979         address indexed newWallet,
980         address indexed oldWallet
981     );
982 
983     event SwapAndLiquify(
984         uint256 tokensSwapped,
985         uint256 ethReceived,
986         uint256 tokensIntoLiquidity
987     );
988 
989     constructor() ERC20("BiteCoin", "BITE") {
990         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
991             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
992         );
993 
994         excludeFromMaxTransaction(address(_uniswapV2Router), true);
995         uniswapV2Router = _uniswapV2Router;
996 
997         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
998             .createPair(address(this), _uniswapV2Router.WETH());
999         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1000         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1001 
1002         uint256 _buyMarketingFee = 8;
1003         uint256 _buyLiquidityFee = 2;
1004         uint256 _buyDevFee = 0;
1005 
1006         uint256 _sellMarketingFee = 9;
1007         uint256 _sellLiquidityFee = 6;
1008         uint256 _sellDevFee = 0;
1009 
1010         uint256 totalSupply = 1000000000 * 1e18;
1011 
1012         maxTransactionAmount = (totalSupply * 1) / 100; // 1% of total supply
1013         maxWallet = (totalSupply * 1) / 100; // 1% of total supply
1014 
1015         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swapback trigger
1016         maxTokensForSwapback = (totalSupply * 6) / 1000; // 0.6% max swapback
1017 
1018         buyMarketingFee = _buyMarketingFee;
1019         buyLiquidityFee = _buyLiquidityFee;
1020         buyDevFee = _buyDevFee;
1021         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1022 
1023         sellMarketingFee = _sellMarketingFee;
1024         sellLiquidityFee = _sellLiquidityFee;
1025         sellDevFee = _sellDevFee;
1026         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1027 
1028         marketingWallet = address(msg.sender); 
1029         devWallet = address(msg.sender);
1030         lpWallet = msg.sender;
1031 
1032         // exclude from paying fees or having max transaction amount
1033         excludeFromFees(owner(), true);
1034         excludeFromFees(address(this), true);
1035         excludeFromFees(address(0xdead), true);
1036         excludeFromFees(marketingWallet, true);
1037 
1038         excludeFromMaxTransaction(owner(), true);
1039         excludeFromMaxTransaction(address(this), true);
1040         excludeFromMaxTransaction(address(0xdead), true);
1041         excludeFromMaxTransaction(marketingWallet, true);
1042 
1043         /*
1044             _mint is an internal function in ERC20.sol that is only called here,
1045             and CANNOT be called ever again
1046         */
1047         _mint(msg.sender, totalSupply);
1048     }
1049 
1050     receive() external payable {}
1051 
1052     /// @notice Launches the token and enables trading. Irriversable.
1053     function enableTrading() external onlyOwner {
1054         tradingActive = true;
1055         swapEnabled = true;
1056         lastLpBurnTime = block.timestamp;
1057     }
1058 
1059     /// @notice Removes the max wallet and max transaction limits
1060     function removeLimits() external onlyOwner returns (bool) {
1061         limitsInEffect = false;
1062         return true;
1063     }
1064 
1065     /// @notice Disables the Same wallet block transfer delay
1066     function disableTransferDelay() external onlyOwner returns (bool) {
1067         transferDelayEnabled = false;
1068         return true;
1069     }
1070 
1071     /// @notice Changes the minimum balance of tokens the contract must have before swapping tokens for ETH
1072     /// @param newAmount Base 100000, so 0.5% = 500.
1073     function updateSwapTokensAtAmount(uint256 newAmount)
1074         external
1075         onlyOwner
1076         returns (bool)
1077     {
1078         require(
1079             newAmount >= 1,
1080             "Swap amount cannot be lower than 0.001% total supply."
1081         );
1082         require(
1083             newAmount <= 500,
1084             "Swap amount cannot be higher than 0.5% total supply."
1085         );
1086         require(
1087             newAmount <= maxTokensForSwapback,
1088             "Swap amount cannot be higher than maxTokensForSwapback"
1089         );
1090         swapTokensAtAmount = newAmount * totalSupply()/ 100000;
1091         return true;
1092     }
1093 
1094     /// @notice Changes the maximum amount of tokens the contract can swap for ETH
1095     /// @param newAmount Base 10000, so 0.5% = 50.
1096     function updateMaxTokensForSwapback(uint256 newAmount)
1097         external
1098         onlyOwner
1099         returns (bool)
1100     {
1101         require(
1102             newAmount >= swapTokensAtAmount,
1103             "Swap amount cannot be lower than swapTokensAtAmount"
1104         );
1105         maxTokensForSwapback = newAmount * totalSupply()/ 100000;
1106         return true;
1107     }
1108 
1109     /// @notice Changes the maximum amount of tokens that can be bought or sold in a single transaction
1110     /// @param newNum Base 1000, so 1% = 10
1111     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1112         require(
1113             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1114             "Cannot set maxTransactionAmount lower than 0.1%"
1115         );
1116         maxTransactionAmount = newNum * (10**18);
1117     }
1118 
1119     /// @notice Changes the maximum amount of tokens a wallet can hold
1120     /// @param newNum Base 1000, so 1% = 10
1121     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1122         require(
1123             newNum >= 5,
1124             "Cannot set maxWallet lower than 0.5%"
1125         );
1126         maxWallet = newNum * totalSupply()/1000;
1127     }
1128 
1129 
1130     /// @notice Sets if a wallet is excluded from the max wallet and tx limits
1131     /// @param updAds The wallet to update
1132     /// @param isEx If the wallet is excluded or not
1133     function excludeFromMaxTransaction(address updAds, bool isEx)
1134         public
1135         onlyOwner
1136     {
1137         _isExcludedMaxTransactionAmount[updAds] = isEx;
1138     }
1139 
1140     /// @notice Sets if the contract can sell tokens
1141     /// @param enabled set to false to disable selling
1142     function updateSwapEnabled(bool enabled) external onlyOwner {
1143         swapEnabled = enabled;
1144     }
1145     
1146     /// @notice Sets the fees for buys
1147     /// @param _marketingFee The fee for the marketing wallet
1148     /// @param _liquidityFee The fee for the liquidity pool
1149     /// @param _devFee The fee for the dev wallet
1150     function updateBuyFees(
1151         uint256 _marketingFee,
1152         uint256 _liquidityFee,
1153         uint256 _devFee
1154     ) external onlyOwner {
1155         buyMarketingFee = _marketingFee;
1156         buyLiquidityFee = _liquidityFee;
1157         buyDevFee = _devFee;
1158         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1159         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1160     }
1161 
1162     /// @notice Sets the fees for sells
1163     /// @param _marketingFee The fee for the marketing wallet
1164     /// @param _liquidityFee The fee for the liquidity pool
1165     /// @param _devFee The fee for the dev wallet
1166     function updateSellFees(
1167         uint256 _marketingFee,
1168         uint256 _liquidityFee,
1169         uint256 _devFee
1170     ) external onlyOwner {
1171         sellMarketingFee = _marketingFee;
1172         sellLiquidityFee = _liquidityFee;
1173         sellDevFee = _devFee;
1174         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1175         require(sellTotalFees <= 11, "Must keep fees at 11% or less");
1176     }
1177 
1178     /// @notice Sets if a wallet is excluded from fees
1179     /// @param account The wallet to update
1180     /// @param excluded If the wallet is excluded or not
1181     function excludeFromFees(address account, bool excluded) public onlyOwner {
1182         _isExcludedFromFees[account] = excluded;
1183         emit ExcludeFromFees(account, excluded);
1184     }
1185 
1186     /// @notice Sets an address as a new liquidity pair. You probably dont want to do this.
1187     /// @param pair The new pair
1188     function setAutomatedMarketMakerPair(address pair, bool value)
1189         public
1190         onlyOwner
1191     {
1192         require(
1193             pair != uniswapV2Pair,
1194             "The pair cannot be removed from automatedMarketMakerPairs"
1195         );
1196 
1197         _setAutomatedMarketMakerPair(pair, value);
1198     }
1199 
1200     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1201         automatedMarketMakerPairs[pair] = value;
1202 
1203         emit SetAutomatedMarketMakerPair(pair, value);
1204     }
1205 
1206     function updateMarketingWallet(address newMarketingWallet)
1207         external
1208         onlyOwner
1209     {
1210         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1211         marketingWallet = newMarketingWallet;
1212     }
1213 
1214     function updateLPWallet(address newLPWallet)
1215         external
1216         onlyOwner
1217     {
1218         lpWallet = newLPWallet;
1219     }
1220 
1221     function updateDevWallet(address newWallet) external onlyOwner {
1222         emit devWalletUpdated(newWallet, devWallet);
1223         devWallet = newWallet;
1224     }
1225 
1226     function isExcludedFromFees(address account) public view returns (bool) {
1227         return _isExcludedFromFees[account];
1228     }
1229 
1230     event BoughtEarly(address indexed sniper);
1231 
1232     function _transfer(
1233         address from,
1234         address to,
1235         uint256 amount
1236     ) internal override {
1237         require(from != address(0), "ERC20: transfer from the zero address");
1238         require(to != address(0), "ERC20: transfer to the zero address");
1239 
1240         if (amount == 0) {
1241             super._transfer(from, to, 0);
1242             return;
1243         }
1244 
1245         if (limitsInEffect) {
1246             if (
1247                 from != owner() &&
1248                 to != owner() &&
1249                 to != address(0) &&
1250                 to != address(0xdead) &&
1251                 !swapping
1252             ) {
1253                 if (!tradingActive) {
1254                     require(
1255                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1256                         "Trading is not active."
1257                     );
1258                 }
1259 
1260                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1261                 if (transferDelayEnabled) {
1262                     if (
1263                         to != owner() &&
1264                         to != address(uniswapV2Router) &&
1265                         to != address(uniswapV2Pair)
1266                     ) {
1267                         require(
1268                             _holderLastTransferTimestamp[tx.origin] <
1269                                 block.number,
1270                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1271                         );
1272                         _holderLastTransferTimestamp[tx.origin] = block.number;
1273                     }
1274                 }
1275 
1276                 //when buy
1277                 if (
1278                     automatedMarketMakerPairs[from] &&
1279                     !_isExcludedMaxTransactionAmount[to]
1280                 ) {
1281                     require(
1282                         amount <= maxTransactionAmount,
1283                         "Buy transfer amount exceeds the maxTransactionAmount."
1284                     );
1285                     require(
1286                         amount + balanceOf(to) <= maxWallet,
1287                         "Max wallet exceeded"
1288                     );
1289                 }
1290                 //when sell
1291                 else if (
1292                     automatedMarketMakerPairs[to] &&
1293                     !_isExcludedMaxTransactionAmount[from]
1294                 ) {
1295                     require(
1296                         amount <= maxTransactionAmount,
1297                         "Sell transfer amount exceeds the maxTransactionAmount."
1298                     );
1299                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1300                     require(
1301                         amount + balanceOf(to) <= maxWallet,
1302                         "Max wallet exceeded"
1303                     );
1304                 }
1305             }
1306         }
1307 
1308         uint256 contractTokenBalance = balanceOf(address(this));
1309 
1310         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1311 
1312         if (
1313             canSwap &&
1314             swapEnabled &&
1315             !swapping &&
1316             !automatedMarketMakerPairs[from] &&
1317             !_isExcludedFromFees[from] &&
1318             !_isExcludedFromFees[to]
1319         ) {
1320             swapping = true;
1321 
1322             swapBack();
1323 
1324             swapping = false;
1325         }
1326 
1327         if (
1328             !swapping &&
1329             automatedMarketMakerPairs[to] &&
1330             lpBurnEnabled &&
1331             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1332             !_isExcludedFromFees[from]
1333         ) {
1334             autoBurnLiquidityPairTokens();
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
1351                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1352                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1353             }
1354             // on buy
1355             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1356                 fees = amount.mul(buyTotalFees).div(100);
1357                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1358                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1359                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
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
1400             lpWallet,
1401             block.timestamp
1402         );
1403     }
1404 
1405     function swapBack() private {
1406         uint256 contractBalance = balanceOf(address(this));
1407         uint256 totalTokensToSwap = tokensForLiquidity +
1408             tokensForMarketing +
1409             tokensForDev;
1410         bool success;
1411 
1412         if (contractBalance == 0 || totalTokensToSwap == 0) {
1413             return;
1414         }
1415 
1416         if (contractBalance > maxTokensForSwapback) {
1417             contractBalance = maxTokensForSwapback;
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
1432         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1433             totalTokensToSwap
1434         );
1435         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1436 
1437         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1438 
1439         tokensForLiquidity = 0;
1440         tokensForMarketing = 0;
1441         tokensForDev = 0;
1442 
1443         (success, ) = address(devWallet).call{value: ethForDev}("");
1444 
1445         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1446             addLiquidity(liquidityTokens, ethForLiquidity);
1447             emit SwapAndLiquify(
1448                 amountToSwapForETH,
1449                 ethForLiquidity,
1450                 tokensForLiquidity
1451             );
1452         }
1453 
1454         (success, ) = address(marketingWallet).call{
1455             value: address(this).balance
1456         }("");
1457     }
1458 
1459     function setAutoLPBurnSettings(
1460         uint256 _frequencyInSeconds,
1461         uint256 _percent,
1462         bool _Enabled
1463     ) external onlyOwner {
1464         require(
1465             _frequencyInSeconds >= 600,
1466             "cannot set buyback more often than every 10 minutes"
1467         );
1468         require(
1469             _percent <= 1000 && _percent >= 0,
1470             "Must set auto LP burn percent between 0% and 10%"
1471         );
1472         lpBurnFrequency = _frequencyInSeconds;
1473         percentForLPBurn = _percent;
1474         lpBurnEnabled = _Enabled;
1475     }
1476 
1477     function autoBurnLiquidityPairTokens() internal returns (bool) {
1478         lastLpBurnTime = block.timestamp;
1479 
1480         // get balance of liquidity pair
1481         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1482 
1483         // calculate amount to burn
1484         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1485             10000
1486         );
1487 
1488         // pull tokens from pancakePair liquidity and move to dead address permanently
1489         if (amountToBurn > 0) {
1490             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1491         }
1492 
1493         //sync price since this is not in a swap transaction!
1494         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1495         pair.sync();
1496         return true;
1497     }
1498 
1499     function manualBurnLiquidityPairTokens(uint256 percent)
1500         external
1501         onlyOwner
1502         returns (bool)
1503     {
1504         require(
1505             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1506             "Must wait for cooldown to finish"
1507         );
1508         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1509         lastManualLpBurnTime = block.timestamp;
1510 
1511         // get balance of liquidity pair
1512         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1513 
1514         // calculate amount to burn
1515         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1516 
1517         // pull tokens from pancakePair liquidity and move to dead address permanently
1518         if (amountToBurn > 0) {
1519             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1520         }
1521 
1522         //sync price since this is not in a swap transaction!
1523         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1524         pair.sync();
1525         return true;
1526     }// @hatmonke
1527 }