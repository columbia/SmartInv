1 /**
2  * SPDX-License-Identifier: MIT
3  */
4 pragma solidity >=0.8.19;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor() {
25         _transferOwnership(_msgSender());
26     }
27 
28     /**
29      * @dev Returns the address of the current owner.
30      */
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(owner() == _msgSender(), "Ownable: caller is not the owner");
40         _;
41     }
42 
43     /**
44      * @dev Leaves the contract without owner. It will not be possible to call
45      * `onlyOwner` functions anymore. Can only be called by the current owner.
46      *
47      * NOTE: Renouncing ownership will leave the contract without an owner,
48      * thereby removing any functionality that is only available to the owner.
49      */
50     function renounceOwnership() public virtual onlyOwner {
51         _transferOwnership(address(0));
52     }
53 
54     /**
55      * @dev Transfers ownership of the contract to a new account (`newOwner`).
56      * Can only be called by the current owner.
57      */
58     function transferOwnership(address newOwner) public virtual onlyOwner {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers ownership of the contract to a new account (`newOwner`).
65      * Internal function without access restriction.
66      */
67     function _transferOwnership(address newOwner) internal virtual {
68         address oldOwner = _owner;
69         _owner = newOwner;
70         emit OwnershipTransferred(oldOwner, newOwner);
71     }
72 }
73 
74 interface IERC20 {
75     /**
76      * @dev Returns the amount of tokens in existence.
77      */
78     function totalSupply() external view returns (uint256);
79 
80     /**
81      * @dev Returns the amount of tokens owned by `account`.
82      */
83     function balanceOf(address account) external view returns (uint256);
84 
85     /**
86      * @dev Moves `amount` tokens from the caller's account to `recipient`.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transfer(address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Returns the remaining number of tokens that `spender` will be
96      * allowed to spend on behalf of `owner` through {transferFrom}. This is
97      * zero by default.
98      *
99      * This value changes when {approve} or {transferFrom} are called.
100      */
101     function allowance(address owner, address spender) external view returns (uint256);
102 
103     /**
104      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
105      *
106      * Returns a boolean value indicating whether the operation succeeded.
107      *
108      * IMPORTANT: Beware that changing an allowance with this method brings the risk
109      * that someone may use both the old and the new allowance by unfortunate
110      * transaction ordering. One possible solution to mitigate this race
111      * condition is to first reduce the spender's allowance to 0 and set the
112      * desired value afterwards:
113      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
114      *
115      * Emits an {Approval} event.
116      */
117     function approve(address spender, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Moves `amount` tokens from `sender` to `recipient` using the
121      * allowance mechanism. `amount` is then deducted from the caller's
122      * allowance.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transferFrom(
129         address sender,
130         address recipient,
131         uint256 amount
132     ) external returns (bool);
133 
134     /**
135      * @dev Emitted when `value` tokens are moved from one account (`from`) to
136      * another (`to`).
137      *
138      * Note that `value` may be zero.
139      */
140     event Transfer(address indexed from, address indexed to, uint256 value);
141 
142     /**
143      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
144      * a call to {approve}. `value` is the new allowance.
145      */
146     event Approval(address indexed owner, address indexed spender, uint256 value);
147 }
148 
149 interface IERC20Metadata is IERC20 {
150     /**
151      * @dev Returns the name of the token.
152      */
153     function name() external view returns (string memory);
154 
155     /**
156      * @dev Returns the symbol of the token.
157      */
158     function symbol() external view returns (string memory);
159 
160     /**
161      * @dev Returns the decimals places of the token.
162      */
163     function decimals() external view returns (uint8);
164 }
165 
166 contract ERC20 is Context, IERC20, IERC20Metadata {
167     mapping(address => uint256) private _balances;
168 
169     mapping(address => mapping(address => uint256)) private _allowances;
170 
171     uint256 private _totalSupply;
172 
173     string private _name;
174     string private _symbol;
175 
176     /**
177      * @dev Sets the values for {name} and {symbol}.
178      *
179      * The default value of {decimals} is 18. To select a different value for
180      * {decimals} you should overload it.
181      *
182      * All two of these values are immutable: they can only be set once during
183      * construction.
184      */
185     constructor(string memory name_, string memory symbol_) {
186         _name = name_;
187         _symbol = symbol_;
188     }
189 
190     /**
191      * @dev Returns the name of the token.
192      */
193     function name() public view virtual override returns (string memory) {
194         return _name;
195     }
196 
197     /**
198      * @dev Returns the symbol of the token, usually a shorter version of the
199      * name.
200      */
201     function symbol() public view virtual override returns (string memory) {
202         return _symbol;
203     }
204 
205     /**
206      * @dev Returns the number of decimals used to get its user representation.
207      * For example, if `decimals` equals `2`, a balance of `505` tokens should
208      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
209      *
210      * Tokens usually opt for a value of 18, imitating the relationship between
211      * Ether and Wei. This is the value {ERC20} uses, unless this function is
212      * overridden;
213      *
214      * NOTE: This information is only used for _display_ purposes: it in
215      * no way affects any of the arithmetic of the contract, including
216      * {IERC20-balanceOf} and {IERC20-transfer}.
217      */
218     function decimals() public view virtual override returns (uint8) {
219         return 18;
220     }
221 
222     /**
223      * @dev See {IERC20-totalSupply}.
224      */
225     function totalSupply() public view virtual override returns (uint256) {
226         return _totalSupply;
227     }
228 
229     /**
230      * @dev See {IERC20-balanceOf}.
231      */
232     function balanceOf(address account) public view virtual override returns (uint256) {
233         return _balances[account];
234     }
235 
236     /**
237      * @dev See {IERC20-transfer}.
238      *
239      * Requirements:
240      *
241      * - `recipient` cannot be the zero address.
242      * - the caller must have a balance of at least `amount`.
243      */
244     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
245         _transfer(_msgSender(), recipient, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See {IERC20-allowance}.
251      */
252     function allowance(address owner, address spender) public view virtual override returns (uint256) {
253         return _allowances[owner][spender];
254     }
255 
256     /**
257      * @dev See {IERC20-approve}.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      */
263     function approve(address spender, uint256 amount) public virtual override returns (bool) {
264         _approve(_msgSender(), spender, amount);
265         return true;
266     }
267 
268     /**
269      * @dev See {IERC20-transferFrom}.
270      *
271      * Emits an {Approval} event indicating the updated allowance. This is not
272      * required by the EIP. See the note at the beginning of {ERC20}.
273      *
274      * Requirements:
275      *
276      * - `sender` and `recipient` cannot be the zero address.
277      * - `sender` must have a balance of at least `amount`.
278      * - the caller must have allowance for ``sender``'s tokens of at least
279      * `amount`.
280      */
281     function transferFrom(
282         address sender,
283         address recipient,
284         uint256 amount
285     ) public virtual override returns (bool) {
286         _transfer(sender, recipient, amount);
287 
288         uint256 currentAllowance = _allowances[sender][_msgSender()];
289         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
290         unchecked {
291             _approve(sender, _msgSender(), currentAllowance - amount);
292         }
293 
294         return true;
295     }
296 
297     /**
298      * @dev Atomically increases the allowance granted to `spender` by the caller.
299      *
300      * This is an alternative to {approve} that can be used as a mitigation for
301      * problems described in {IERC20-approve}.
302      *
303      * Emits an {Approval} event indicating the updated allowance.
304      *
305      * Requirements:
306      *
307      * - `spender` cannot be the zero address.
308      */
309     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
310         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
311         return true;
312     }
313 
314     /**
315      * @dev Atomically decreases the allowance granted to `spender` by the caller.
316      *
317      * This is an alternative to {approve} that can be used as a mitigation for
318      * problems described in {IERC20-approve}.
319      *
320      * Emits an {Approval} event indicating the updated allowance.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      * - `spender` must have allowance for the caller of at least
326      * `subtractedValue`.
327      */
328     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
329         uint256 currentAllowance = _allowances[_msgSender()][spender];
330         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
331         unchecked {
332             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
333         }
334 
335         return true;
336     }
337 
338     /**
339      * @dev Moves `amount` of tokens from `sender` to `recipient`.
340      *
341      * This internal function is equivalent to {transfer}, and can be used to
342      * e.g. implement automatic token fees, slashing mechanisms, etc.
343      *
344      * Emits a {Transfer} event.
345      *
346      * Requirements:
347      *
348      * - `sender` cannot be the zero address.
349      * - `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      */
352     function _transfer(
353         address sender,
354         address recipient,
355         uint256 amount
356     ) internal virtual {
357         require(sender != address(0), "ERC20: transfer from the zero address");
358         require(recipient != address(0), "ERC20: transfer to the zero address");
359 
360         _beforeTokenTransfer(sender, recipient, amount);
361 
362         uint256 senderBalance = _balances[sender];
363         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
364         unchecked {
365             _balances[sender] = senderBalance - amount;
366         }
367         _balances[recipient] += amount;
368 
369         emit Transfer(sender, recipient, amount);
370 
371         _afterTokenTransfer(sender, recipient, amount);
372     }
373 
374     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
375      * the total supply.
376      *
377      * Emits a {Transfer} event with `from` set to the zero address.
378      *
379      * Requirements:
380      *
381      * - `account` cannot be the zero address.
382      */
383     function _mint(address account, uint256 amount) internal virtual {
384         require(account != address(0), "ERC20: mint to the zero address");
385 
386         _beforeTokenTransfer(address(0), account, amount);
387 
388         _totalSupply += amount;
389         _balances[account] += amount;
390         emit Transfer(address(0), account, amount);
391 
392         _afterTokenTransfer(address(0), account, amount);
393     }
394 
395     /**
396      * @dev Destroys `amount` tokens from `account`, reducing the
397      * total supply.
398      *
399      * Emits a {Transfer} event with `to` set to the zero address.
400      *
401      * Requirements:
402      *
403      * - `account` cannot be the zero address.
404      * - `account` must have at least `amount` tokens.
405      */
406     function _burn(address account, uint256 amount) internal virtual {
407         require(account != address(0), "ERC20: burn from the zero address");
408 
409         _beforeTokenTransfer(account, address(0), amount);
410 
411         uint256 accountBalance = _balances[account];
412         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
413         unchecked {
414             _balances[account] = accountBalance - amount;
415         }
416         _totalSupply -= amount;
417 
418         emit Transfer(account, address(0), amount);
419 
420         _afterTokenTransfer(account, address(0), amount);
421     }
422 
423     /**
424      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
425      *
426      * This internal function is equivalent to `approve`, and can be used to
427      * e.g. set automatic allowances for certain subsystems, etc.
428      *
429      * Emits an {Approval} event.
430      *
431      * Requirements:
432      *
433      * - `owner` cannot be the zero address.
434      * - `spender` cannot be the zero address.
435      */
436     function _approve(
437         address owner,
438         address spender,
439         uint256 amount
440     ) internal virtual {
441         require(owner != address(0), "ERC20: approve from the zero address");
442         require(spender != address(0), "ERC20: approve to the zero address");
443 
444         _allowances[owner][spender] = amount;
445         emit Approval(owner, spender, amount);
446     }
447 
448     /**
449      * @dev Hook that is called before any transfer of tokens. This includes
450      * minting and burning.
451      *
452      * Calling conditions:
453      *
454      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
455      * will be transferred to `to`.
456      * - when `from` is zero, `amount` tokens will be minted for `to`.
457      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
458      * - `from` and `to` are never both zero.
459      *
460      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
461      */
462     function _beforeTokenTransfer(
463         address from,
464         address to,
465         uint256 amount
466     ) internal virtual {}
467 
468     /**
469      * @dev Hook that is called after any transfer of tokens. This includes
470      * minting and burning.
471      *
472      * Calling conditions:
473      *
474      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
475      * has been transferred to `to`.
476      * - when `from` is zero, `amount` tokens have been minted for `to`.
477      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
478      * - `from` and `to` are never both zero.
479      *
480      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
481      */
482     function _afterTokenTransfer(
483         address from,
484         address to,
485         uint256 amount
486     ) internal virtual {}
487 }
488 
489 library SafeMath {
490     /**
491      * @dev Returns the addition of two unsigned integers, with an overflow flag.
492      *
493      * _Available since v3.4._
494      */
495     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
496         unchecked {
497             uint256 c = a + b;
498             if (c < a) return (false, 0);
499             return (true, c);
500         }
501     }
502 
503     /**
504      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
505      *
506      * _Available since v3.4._
507      */
508     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
509         unchecked {
510             if (b > a) return (false, 0);
511             return (true, a - b);
512         }
513     }
514 
515     /**
516      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
517      *
518      * _Available since v3.4._
519      */
520     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
521         unchecked {
522             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
523             // benefit is lost if 'b' is also tested.
524             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
525             if (a == 0) return (true, 0);
526             uint256 c = a * b;
527             if (c / a != b) return (false, 0);
528             return (true, c);
529         }
530     }
531 
532     /**
533      * @dev Returns the division of two unsigned integers, with a division by zero flag.
534      *
535      * _Available since v3.4._
536      */
537     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
538         unchecked {
539             if (b == 0) return (false, 0);
540             return (true, a / b);
541         }
542     }
543 
544     /**
545      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
546      *
547      * _Available since v3.4._
548      */
549     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
550         unchecked {
551             if (b == 0) return (false, 0);
552             return (true, a % b);
553         }
554     }
555 
556     /**
557      * @dev Returns the addition of two unsigned integers, reverting on
558      * overflow.
559      *
560      * Counterpart to Solidity's `+` operator.
561      *
562      * Requirements:
563      *
564      * - Addition cannot overflow.
565      */
566     function add(uint256 a, uint256 b) internal pure returns (uint256) {
567         return a + b;
568     }
569 
570     /**
571      * @dev Returns the subtraction of two unsigned integers, reverting on
572      * overflow (when the result is negative).
573      *
574      * Counterpart to Solidity's `-` operator.
575      *
576      * Requirements:
577      *
578      * - Subtraction cannot overflow.
579      */
580     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
581         return a - b;
582     }
583 
584     /**
585      * @dev Returns the multiplication of two unsigned integers, reverting on
586      * overflow.
587      *
588      * Counterpart to Solidity's `*` operator.
589      *
590      * Requirements:
591      *
592      * - Multiplication cannot overflow.
593      */
594     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
595         return a * b;
596     }
597 
598     /**
599      * @dev Returns the integer division of two unsigned integers, reverting on
600      * division by zero. The result is rounded towards zero.
601      *
602      * Counterpart to Solidity's `/` operator.
603      *
604      * Requirements:
605      *
606      * - The divisor cannot be zero.
607      */
608     function div(uint256 a, uint256 b) internal pure returns (uint256) {
609         return a / b;
610     }
611 
612     /**
613      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
614      * reverting when dividing by zero.
615      *
616      * Counterpart to Solidity's `%` operator. This function uses a `revert`
617      * opcode (which leaves remaining gas untouched) while Solidity uses an
618      * invalid opcode to revert (consuming all remaining gas).
619      *
620      * Requirements:
621      *
622      * - The divisor cannot be zero.
623      */
624     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
625         return a % b;
626     }
627 
628     /**
629      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
630      * overflow (when the result is negative).
631      *
632      * CAUTION: This function is deprecated because it requires allocating memory for the error
633      * message unnecessarily. For custom revert reasons use {trySub}.
634      *
635      * Counterpart to Solidity's `-` operator.
636      *
637      * Requirements:
638      *
639      * - Subtraction cannot overflow.
640      */
641     function sub(
642         uint256 a,
643         uint256 b,
644         string memory errorMessage
645     ) internal pure returns (uint256) {
646         unchecked {
647             require(b <= a, errorMessage);
648             return a - b;
649         }
650     }
651 
652     /**
653      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
654      * division by zero. The result is rounded towards zero.
655      *
656      * Counterpart to Solidity's `/` operator. Note: this function uses a
657      * `revert` opcode (which leaves remaining gas untouched) while Solidity
658      * uses an invalid opcode to revert (consuming all remaining gas).
659      *
660      * Requirements:
661      *
662      * - The divisor cannot be zero.
663      */
664     function div(
665         uint256 a,
666         uint256 b,
667         string memory errorMessage
668     ) internal pure returns (uint256) {
669         unchecked {
670             require(b > 0, errorMessage);
671             return a / b;
672         }
673     }
674 
675     /**
676      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
677      * reverting with custom message when dividing by zero.
678      *
679      * CAUTION: This function is deprecated because it requires allocating memory for the error
680      * message unnecessarily. For custom revert reasons use {tryMod}.
681      *
682      * Counterpart to Solidity's `%` operator. This function uses a `revert`
683      * opcode (which leaves remaining gas untouched) while Solidity uses an
684      * invalid opcode to revert (consuming all remaining gas).
685      *
686      * Requirements:
687      *
688      * - The divisor cannot be zero.
689      */
690     function mod(
691         uint256 a,
692         uint256 b,
693         string memory errorMessage
694     ) internal pure returns (uint256) {
695         unchecked {
696             require(b > 0, errorMessage);
697             return a % b;
698         }
699     }
700 }
701 
702 interface IUniswapV2Factory {
703     event PairCreated(
704         address indexed token0,
705         address indexed token1,
706         address pair,
707         uint256
708     );
709 
710     function feeTo() external view returns (address);
711 
712     function feeToSetter() external view returns (address);
713 
714     function getPair(address tokenA, address tokenB)
715         external
716         view
717         returns (address pair);
718 
719     function allPairs(uint256) external view returns (address pair);
720 
721     function allPairsLength() external view returns (uint256);
722 
723     function createPair(address tokenA, address tokenB)
724         external
725         returns (address pair);
726 
727     function setFeeTo(address) external;
728 
729     function setFeeToSetter(address) external;
730 }
731 
732 interface IUniswapV2Pair {
733     event Approval(
734         address indexed owner,
735         address indexed spender,
736         uint256 value
737     );
738     event Transfer(address indexed from, address indexed to, uint256 value);
739 
740     function name() external pure returns (string memory);
741 
742     function symbol() external pure returns (string memory);
743 
744     function decimals() external pure returns (uint8);
745 
746     function totalSupply() external view returns (uint256);
747 
748     function balanceOf(address owner) external view returns (uint256);
749 
750     function allowance(address owner, address spender)
751         external
752         view
753         returns (uint256);
754 
755     function approve(address spender, uint256 value) external returns (bool);
756 
757     function transfer(address to, uint256 value) external returns (bool);
758 
759     function transferFrom(
760         address from,
761         address to,
762         uint256 value
763     ) external returns (bool);
764 
765     function DOMAIN_SEPARATOR() external view returns (bytes32);
766 
767     function PERMIT_TYPEHASH() external pure returns (bytes32);
768 
769     function nonces(address owner) external view returns (uint256);
770 
771     function permit(
772         address owner,
773         address spender,
774         uint256 value,
775         uint256 deadline,
776         uint8 v,
777         bytes32 r,
778         bytes32 s
779     ) external;
780 
781     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
782     event Burn(
783         address indexed sender,
784         uint256 amount0,
785         uint256 amount1,
786         address indexed to
787     );
788     event Swap(
789         address indexed sender,
790         uint256 amount0In,
791         uint256 amount1In,
792         uint256 amount0Out,
793         uint256 amount1Out,
794         address indexed to
795     );
796     event Sync(uint112 reserve0, uint112 reserve1);
797 
798     function MINIMUM_LIQUIDITY() external pure returns (uint256);
799 
800     function factory() external view returns (address);
801 
802     function token0() external view returns (address);
803 
804     function token1() external view returns (address);
805 
806     function getReserves()
807         external
808         view
809         returns (
810             uint112 reserve0,
811             uint112 reserve1,
812             uint32 blockTimestampLast
813         );
814 
815     function price0CumulativeLast() external view returns (uint256);
816 
817     function price1CumulativeLast() external view returns (uint256);
818 
819     function kLast() external view returns (uint256);
820 
821     function mint(address to) external returns (uint256 liquidity);
822 
823     function burn(address to)
824         external
825         returns (uint256 amount0, uint256 amount1);
826 
827     function swap(
828         uint256 amount0Out,
829         uint256 amount1Out,
830         address to,
831         bytes calldata data
832     ) external;
833 
834     function skim(address to) external;
835 
836     function sync() external;
837 
838     function initialize(address, address) external;
839 }
840 
841 interface IUniswapV2Router02 {
842     function factory() external pure returns (address);
843 
844     function WETH() external pure returns (address);
845 
846     function addLiquidity(
847         address tokenA,
848         address tokenB,
849         uint256 amountADesired,
850         uint256 amountBDesired,
851         uint256 amountAMin,
852         uint256 amountBMin,
853         address to,
854         uint256 deadline
855     )
856         external
857         returns (
858             uint256 amountA,
859             uint256 amountB,
860             uint256 liquidity
861         );
862 
863     function addLiquidityETH(
864         address token,
865         uint256 amountTokenDesired,
866         uint256 amountTokenMin,
867         uint256 amountETHMin,
868         address to,
869         uint256 deadline
870     )
871         external
872         payable
873         returns (
874             uint256 amountToken,
875             uint256 amountETH,
876             uint256 liquidity
877         );
878 
879     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
880         uint256 amountIn,
881         uint256 amountOutMin,
882         address[] calldata path,
883         address to,
884         uint256 deadline
885     ) external;
886 
887     function swapExactETHForTokensSupportingFeeOnTransferTokens(
888         uint256 amountOutMin,
889         address[] calldata path,
890         address to,
891         uint256 deadline
892     ) external payable;
893 
894     function swapExactTokensForETHSupportingFeeOnTransferTokens(
895         uint256 amountIn,
896         uint256 amountOutMin,
897         address[] calldata path,
898         address to,
899         uint256 deadline
900     ) external;
901 }
902 
903 contract EFLOKI is ERC20, Ownable {
904     using SafeMath for uint256;
905 
906     IUniswapV2Router02 public immutable uniswapV2Router;
907     address public immutable uniswapV2Pair;
908     address public constant deadAddress = address(0xdead);
909 
910     bool private swapping;
911 
912     address public marketingWallet;
913     address public devWallet;
914     address public lpWallet;
915 
916     uint256 public swapTokensAtAmount;
917     uint256 public maxTokensForSwapback;
918 
919     uint256 public maxTransactionAmount;
920     uint256 public maxWallet;
921 
922     uint256 public percentForLPBurn = 25;
923     bool public lpBurnEnabled = true;
924     uint256 public lpBurnFrequency = 3600 seconds;
925     uint256 public lastLpBurnTime;
926 
927     uint256 public manualBurnFrequency = 30 minutes;
928     uint256 public lastManualLpBurnTime;
929 
930     bool public limitsInEffect = true;
931     bool public tradingActive = false;
932     bool public swapEnabled = false;
933 
934     // Anti-bot and anti-whale mappings and variables
935     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
936     bool public transferDelayEnabled = true;
937 
938     uint256 public buyTotalFees;
939     uint256 public buyMarketingFee;
940     uint256 public buyLiquidityFee;
941     uint256 public buyDevFee;
942 
943     uint256 public sellTotalFees;
944     uint256 public sellMarketingFee;
945     uint256 public sellLiquidityFee;
946     uint256 public sellDevFee;
947 
948     uint256 public tokensForMarketing;
949     uint256 public tokensForLiquidity;
950     uint256 public tokensForDev;
951 
952     /******************/
953 
954     // exlcude from fees and max transaction amount
955     mapping(address => bool) private _isExcludedFromFees;
956     mapping(address => bool) public _isExcludedMaxTransactionAmount;
957 
958     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
959     // could be subject to a maximum transfer amount
960     mapping(address => bool) public automatedMarketMakerPairs;
961 
962     event UpdateUniswapV2Router(
963         address indexed newAddress,
964         address indexed oldAddress
965     );
966 
967     event ExcludeFromFees(address indexed account, bool isExcluded);
968 
969     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
970 
971     event marketingWalletUpdated(
972         address indexed newWallet,
973         address indexed oldWallet
974     );
975 
976     event devWalletUpdated(
977         address indexed newWallet,
978         address indexed oldWallet
979     );
980 
981     event SwapAndLiquify(
982         uint256 tokensSwapped,
983         uint256 ethReceived,
984         uint256 tokensIntoLiquidity
985     );
986 
987     constructor() ERC20("Easter Floki", "EFLOKI") {
988         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
989             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
990         );
991 
992         excludeFromMaxTransaction(address(_uniswapV2Router), true);
993         uniswapV2Router = _uniswapV2Router;
994 
995         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
996             .createPair(address(this), _uniswapV2Router.WETH());
997         excludeFromMaxTransaction(address(uniswapV2Pair), true);
998         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
999 
1000         uint256 _buyMarketingFee = 8;
1001         uint256 _buyLiquidityFee = 5;
1002         uint256 _buyDevFee = 2;
1003 
1004         uint256 _sellMarketingFee = 17;
1005         uint256 _sellLiquidityFee = 11;
1006         uint256 _sellDevFee = 5;
1007 
1008         uint256 totalSupply = 1000000000 * 1e18;
1009 
1010         maxTransactionAmount = (totalSupply * 1) / 100; // 1% of total supply
1011         maxWallet = (totalSupply * 1) / 100; // 1% of total supply
1012 
1013         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swapback trigger
1014         maxTokensForSwapback = (totalSupply * 6) / 1000; // 0.6% max swapback
1015 
1016         buyMarketingFee = _buyMarketingFee;
1017         buyLiquidityFee = _buyLiquidityFee;
1018         buyDevFee = _buyDevFee;
1019         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1020 
1021         sellMarketingFee = _sellMarketingFee;
1022         sellLiquidityFee = _sellLiquidityFee;
1023         sellDevFee = _sellDevFee;
1024         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1025 
1026         marketingWallet = address(0x35A9bde203Ed283a98BeE997A5390132e29E1357); 
1027         devWallet = address(0x35A9bde203Ed283a98BeE997A5390132e29E1357);
1028         lpWallet = msg.sender;
1029 
1030         // exclude from paying fees or having max transaction amount
1031         excludeFromFees(owner(), true);
1032         excludeFromFees(address(this), true);
1033         excludeFromFees(address(0xdead), true);
1034         excludeFromFees(marketingWallet, true);
1035 
1036         excludeFromMaxTransaction(owner(), true);
1037         excludeFromMaxTransaction(address(this), true);
1038         excludeFromMaxTransaction(address(0xdead), true);
1039         excludeFromMaxTransaction(marketingWallet, true);
1040 
1041         /*
1042             _mint is an internal function in ERC20.sol that is only called here,
1043             and CANNOT be called ever again
1044         */
1045         _mint(msg.sender, totalSupply);
1046     }
1047 
1048     receive() external payable {}
1049 
1050     /// @notice Launches the token and enables trading. Irriversable.
1051     function enableTrading() external onlyOwner {
1052         tradingActive = true;
1053         swapEnabled = true;
1054         lastLpBurnTime = block.timestamp;
1055     }
1056 
1057     /// @notice Removes the max wallet and max transaction limits
1058     function removeLimits() external onlyOwner returns (bool) {
1059         limitsInEffect = false;
1060         return true;
1061     }
1062 
1063     /// @notice Disables the Same wallet block transfer delay
1064     function disableTransferDelay() external onlyOwner returns (bool) {
1065         transferDelayEnabled = false;
1066         return true;
1067     }
1068 
1069     /// @notice Changes the minimum balance of tokens the contract must have before swapping tokens for ETH
1070     /// @param newAmount Base 100000, so 0.5% = 500.
1071     function updateSwapTokensAtAmount(uint256 newAmount)
1072         external
1073         onlyOwner
1074         returns (bool)
1075     {
1076         require(
1077             newAmount >= 1,
1078             "Swap amount cannot be lower than 0.001% total supply."
1079         );
1080         require(
1081             newAmount <= 500,
1082             "Swap amount cannot be higher than 0.5% total supply."
1083         );
1084         require(
1085             newAmount <= maxTokensForSwapback,
1086             "Swap amount cannot be higher than maxTokensForSwapback"
1087         );
1088         swapTokensAtAmount = newAmount * totalSupply()/ 100000;
1089         return true;
1090     }
1091 
1092     /// @notice Changes the maximum amount of tokens the contract can swap for ETH
1093     /// @param newAmount Base 10000, so 0.5% = 50.
1094     function updateMaxTokensForSwapback(uint256 newAmount)
1095         external
1096         onlyOwner
1097         returns (bool)
1098     {
1099         require(
1100             newAmount >= swapTokensAtAmount,
1101             "Swap amount cannot be lower than swapTokensAtAmount"
1102         );
1103         maxTokensForSwapback = newAmount * totalSupply()/ 100000;
1104         return true;
1105     }
1106 
1107     /// @notice Changes the maximum amount of tokens that can be bought or sold in a single transaction
1108     /// @param newNum Base 1000, so 1% = 10
1109     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1110         require(
1111             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1112             "Cannot set maxTransactionAmount lower than 0.1%"
1113         );
1114         maxTransactionAmount = newNum * (10**18);
1115     }
1116 
1117     /// @notice Changes the maximum amount of tokens a wallet can hold
1118     /// @param newNum Base 1000, so 1% = 10
1119     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1120         require(
1121             newNum >= 5,
1122             "Cannot set maxWallet lower than 0.5%"
1123         );
1124         maxWallet = newNum * totalSupply()/1000;
1125     }
1126 
1127 
1128     /// @notice Sets if a wallet is excluded from the max wallet and tx limits
1129     /// @param updAds The wallet to update
1130     /// @param isEx If the wallet is excluded or not
1131     function excludeFromMaxTransaction(address updAds, bool isEx)
1132         public
1133         onlyOwner
1134     {
1135         _isExcludedMaxTransactionAmount[updAds] = isEx;
1136     }
1137 
1138     /// @notice Sets if the contract can sell tokens
1139     /// @param enabled set to false to disable selling
1140     function updateSwapEnabled(bool enabled) external onlyOwner {
1141         swapEnabled = enabled;
1142     }
1143     
1144     /// @notice Sets the fees for buys
1145     /// @param _marketingFee The fee for the marketing wallet
1146     /// @param _liquidityFee The fee for the liquidity pool
1147     /// @param _devFee The fee for the dev wallet
1148     function updateBuyFees(
1149         uint256 _marketingFee,
1150         uint256 _liquidityFee,
1151         uint256 _devFee
1152     ) external onlyOwner {
1153         buyMarketingFee = _marketingFee;
1154         buyLiquidityFee = _liquidityFee;
1155         buyDevFee = _devFee;
1156         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1157         require(buyTotalFees <= 11, "Must keep fees at 11% or less");
1158     }
1159 
1160     /// @notice Sets the fees for sells
1161     /// @param _marketingFee The fee for the marketing wallet
1162     /// @param _liquidityFee The fee for the liquidity pool
1163     /// @param _devFee The fee for the dev wallet
1164     function updateSellFees(
1165         uint256 _marketingFee,
1166         uint256 _liquidityFee,
1167         uint256 _devFee
1168     ) external onlyOwner {
1169         sellMarketingFee = _marketingFee;
1170         sellLiquidityFee = _liquidityFee;
1171         sellDevFee = _devFee;
1172         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1173         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
1174     }
1175 
1176     /// @notice Sets if a wallet is excluded from fees
1177     /// @param account The wallet to update
1178     /// @param excluded If the wallet is excluded or not
1179     function excludeFromFees(address account, bool excluded) public onlyOwner {
1180         _isExcludedFromFees[account] = excluded;
1181         emit ExcludeFromFees(account, excluded);
1182     }
1183 
1184     /// @notice Sets an address as a new liquidity pair. You probably dont want to do this.
1185     /// @param pair The new pair
1186     function setAutomatedMarketMakerPair(address pair, bool value)
1187         public
1188         onlyOwner
1189     {
1190         require(
1191             pair != uniswapV2Pair,
1192             "The pair cannot be removed from automatedMarketMakerPairs"
1193         );
1194 
1195         _setAutomatedMarketMakerPair(pair, value);
1196     }
1197 
1198     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1199         automatedMarketMakerPairs[pair] = value;
1200 
1201         emit SetAutomatedMarketMakerPair(pair, value);
1202     }
1203 
1204     function updateMarketingWallet(address newMarketingWallet)
1205         external
1206         onlyOwner
1207     {
1208         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1209         marketingWallet = newMarketingWallet;
1210     }
1211 
1212     function updateLPWallet(address newLPWallet)
1213         external
1214         onlyOwner
1215     {
1216         lpWallet = newLPWallet;
1217     }
1218 
1219     function updateDevWallet(address newWallet) external onlyOwner {
1220         emit devWalletUpdated(newWallet, devWallet);
1221         devWallet = newWallet;
1222     }
1223 
1224     function isExcludedFromFees(address account) public view returns (bool) {
1225         return _isExcludedFromFees[account];
1226     }
1227 
1228     event BoughtEarly(address indexed sniper);
1229 
1230     function _transfer(
1231         address from,
1232         address to,
1233         uint256 amount
1234     ) internal override {
1235         require(from != address(0), "ERC20: transfer from the zero address");
1236         require(to != address(0), "ERC20: transfer to the zero address");
1237 
1238         if (amount == 0) {
1239             super._transfer(from, to, 0);
1240             return;
1241         }
1242 
1243         if (limitsInEffect) {
1244             if (
1245                 from != owner() &&
1246                 to != owner() &&
1247                 to != address(0) &&
1248                 to != address(0xdead) &&
1249                 !swapping
1250             ) {
1251                 if (!tradingActive) {
1252                     require(
1253                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1254                         "Trading is not active."
1255                     );
1256                 }
1257 
1258                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1259                 if (transferDelayEnabled) {
1260                     if (
1261                         to != owner() &&
1262                         to != address(uniswapV2Router) &&
1263                         to != address(uniswapV2Pair)
1264                     ) {
1265                         require(
1266                             _holderLastTransferTimestamp[tx.origin] <
1267                                 block.number,
1268                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1269                         );
1270                         _holderLastTransferTimestamp[tx.origin] = block.number;
1271                     }
1272                 }
1273 
1274                 //when buy
1275                 if (
1276                     automatedMarketMakerPairs[from] &&
1277                     !_isExcludedMaxTransactionAmount[to]
1278                 ) {
1279                     require(
1280                         amount <= maxTransactionAmount,
1281                         "Buy transfer amount exceeds the maxTransactionAmount."
1282                     );
1283                     require(
1284                         amount + balanceOf(to) <= maxWallet,
1285                         "Max wallet exceeded"
1286                     );
1287                 }
1288                 //when sell
1289                 else if (
1290                     automatedMarketMakerPairs[to] &&
1291                     !_isExcludedMaxTransactionAmount[from]
1292                 ) {
1293                     require(
1294                         amount <= maxTransactionAmount,
1295                         "Sell transfer amount exceeds the maxTransactionAmount."
1296                     );
1297                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1298                     require(
1299                         amount + balanceOf(to) <= maxWallet,
1300                         "Max wallet exceeded"
1301                     );
1302                 }
1303             }
1304         }
1305 
1306         uint256 contractTokenBalance = balanceOf(address(this));
1307 
1308         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1309 
1310         if (
1311             canSwap &&
1312             swapEnabled &&
1313             !swapping &&
1314             !automatedMarketMakerPairs[from] &&
1315             !_isExcludedFromFees[from] &&
1316             !_isExcludedFromFees[to]
1317         ) {
1318             swapping = true;
1319 
1320             swapBack();
1321 
1322             swapping = false;
1323         }
1324 
1325         if (
1326             !swapping &&
1327             automatedMarketMakerPairs[to] &&
1328             lpBurnEnabled &&
1329             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1330             !_isExcludedFromFees[from]
1331         ) {
1332             autoBurnLiquidityPairTokens();
1333         }
1334 
1335         bool takeFee = !swapping;
1336 
1337         // if any account belongs to _isExcludedFromFee account then remove the fee
1338         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1339             takeFee = false;
1340         }
1341 
1342         uint256 fees = 0;
1343         // only take fees on buys/sells, do not take on wallet transfers
1344         if (takeFee) {
1345             // on sell
1346             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1347                 fees = amount.mul(sellTotalFees).div(100);
1348                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1349                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1350                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1351             }
1352             // on buy
1353             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1354                 fees = amount.mul(buyTotalFees).div(100);
1355                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1356                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1357                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1358             }
1359 
1360             if (fees > 0) {
1361                 super._transfer(from, address(this), fees);
1362             }
1363 
1364             amount -= fees;
1365         }
1366 
1367         super._transfer(from, to, amount);
1368     }
1369 
1370     function swapTokensForEth(uint256 tokenAmount) private {
1371         // generate the uniswap pair path of token -> weth
1372         address[] memory path = new address[](2);
1373         path[0] = address(this);
1374         path[1] = uniswapV2Router.WETH();
1375 
1376         _approve(address(this), address(uniswapV2Router), tokenAmount);
1377 
1378         // make the swap
1379         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1380             tokenAmount,
1381             0, // accept any amount of ETH
1382             path,
1383             address(this),
1384             block.timestamp
1385         );
1386     }
1387 
1388     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1389         // approve token transfer to cover all possible scenarios
1390         _approve(address(this), address(uniswapV2Router), tokenAmount);
1391 
1392         // add the liquidity
1393         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1394             address(this),
1395             tokenAmount,
1396             0, // slippage is unavoidable
1397             0, // slippage is unavoidable
1398             lpWallet,
1399             block.timestamp
1400         );
1401     }
1402 
1403     function swapBack() private {
1404         uint256 contractBalance = balanceOf(address(this));
1405         uint256 totalTokensToSwap = tokensForLiquidity +
1406             tokensForMarketing +
1407             tokensForDev;
1408         bool success;
1409 
1410         if (contractBalance == 0 || totalTokensToSwap == 0) {
1411             return;
1412         }
1413 
1414         if (contractBalance > maxTokensForSwapback) {
1415             contractBalance = maxTokensForSwapback;
1416         }
1417 
1418         // Halve the amount of liquidity tokens
1419         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1420             totalTokensToSwap /
1421             2;
1422         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1423 
1424         uint256 initialETHBalance = address(this).balance;
1425 
1426         swapTokensForEth(amountToSwapForETH);
1427 
1428         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1429 
1430         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1431             totalTokensToSwap
1432         );
1433         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1434 
1435         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1436 
1437         tokensForLiquidity = 0;
1438         tokensForMarketing = 0;
1439         tokensForDev = 0;
1440 
1441         (success, ) = address(devWallet).call{value: ethForDev}("");
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
1452         (success, ) = address(marketingWallet).call{
1453             value: address(this).balance
1454         }("");
1455     }
1456 
1457     function setAutoLPBurnSettings(
1458         uint256 _frequencyInSeconds,
1459         uint256 _percent,
1460         bool _Enabled
1461     ) external onlyOwner {
1462         require(
1463             _frequencyInSeconds >= 600,
1464             "cannot set buyback more often than every 10 minutes"
1465         );
1466         require(
1467             _percent <= 1000 && _percent >= 0,
1468             "Must set auto LP burn percent between 0% and 10%"
1469         );
1470         lpBurnFrequency = _frequencyInSeconds;
1471         percentForLPBurn = _percent;
1472         lpBurnEnabled = _Enabled;
1473     }
1474 
1475     function autoBurnLiquidityPairTokens() internal returns (bool) {
1476         lastLpBurnTime = block.timestamp;
1477 
1478         // get balance of liquidity pair
1479         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1480 
1481         // calculate amount to burn
1482         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1483             10000
1484         );
1485 
1486         // pull tokens from pancakePair liquidity and move to dead address permanently
1487         if (amountToBurn > 0) {
1488             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1489         }
1490 
1491         //sync price since this is not in a swap transaction!
1492         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1493         pair.sync();
1494         return true;
1495     }
1496 
1497     function manualBurnLiquidityPairTokens(uint256 percent)
1498         external
1499         onlyOwner
1500         returns (bool)
1501     {
1502         require(
1503             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1504             "Must wait for cooldown to finish"
1505         );
1506         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1507         lastManualLpBurnTime = block.timestamp;
1508 
1509         // get balance of liquidity pair
1510         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1511 
1512         // calculate amount to burn
1513         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1514 
1515         // pull tokens from pancakePair liquidity and move to dead address permanently
1516         if (amountToBurn > 0) {
1517             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1518         }
1519 
1520         //sync price since this is not in a swap transaction!
1521         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1522         pair.sync();
1523         return true;
1524     }
1525 }