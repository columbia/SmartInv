1 // SPDX-License-Identifier: MIT
2 pragma solidity  ^0.8.19;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 abstract contract Ownable is Context {
15     address private _owner;
16 
17     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19     /**
20      * @dev Initializes the contract setting the deployer as the initial owner.
21      */
22     constructor() {
23         _transferOwnership(_msgSender());
24     }
25 
26     /**
27      * @dev Returns the address of the current owner.
28      */
29     function owner() public view virtual returns (address) {
30         return _owner;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(owner() == _msgSender(), "Ownable: caller is not the owner");
38         _;
39     }
40 
41     /**
42      * @dev Leaves the contract without owner. It will not be possible to call
43      * `onlyOwner` functions anymore. Can only be called by the current owner.
44      *
45      * NOTE: Renouncing ownership will leave the contract without an owner,
46      * thereby removing any functionality that is only available to the owner.
47      */
48     function renounceOwnership() public virtual onlyOwner {
49         _transferOwnership(address(0));
50     }
51 
52     /**
53      * @dev Transfers ownership of the contract to a new account (`newOwner`).
54      * Can only be called by the current owner.
55      */
56     function transferOwnership(address newOwner) public virtual onlyOwner {
57         require(newOwner != address(0), "Ownable: new owner is the zero address");
58         _transferOwnership(newOwner);
59     }
60 
61     /**
62      * @dev Transfers ownership of the contract to a new account (`newOwner`).
63      * Internal function without access restriction.
64      */
65     function _transferOwnership(address newOwner) internal virtual {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 interface IERC20 {
73     /**
74      * @dev Returns the amount of tokens in existence.
75      */
76     function totalSupply() external view returns (uint256);
77 
78     /**
79      * @dev Returns the amount of tokens owned by `account`.
80      */
81     function balanceOf(address account) external view returns (uint256);
82 
83     /**
84      * @dev Moves `amount` tokens from the caller's account to `recipient`.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transfer(address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Returns the remaining number of tokens that `spender` will be
94      * allowed to spend on behalf of `owner` through {transferFrom}. This is
95      * zero by default.
96      *
97      * This value changes when {approve} or {transferFrom} are called.
98      */
99     function allowance(address owner, address spender) external view returns (uint256);
100 
101     /**
102      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * IMPORTANT: Beware that changing an allowance with this method brings the risk
107      * that someone may use both the old and the new allowance by unfortunate
108      * transaction ordering. One possible solution to mitigate this race
109      * condition is to first reduce the spender's allowance to 0 and set the
110      * desired value afterwards:
111      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
112      *
113      * Emits an {Approval} event.
114      */
115     function approve(address spender, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Moves `amount` tokens from `sender` to `recipient` using the
119      * allowance mechanism. `amount` is then deducted from the caller's
120      * allowance.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transferFrom(
127         address sender,
128         address recipient,
129         uint256 amount
130     ) external returns (bool);
131 
132     /**
133      * @dev Emitted when `value` tokens are moved from one account (`from`) to
134      * another (`to`).
135      *
136      * Note that `value` may be zero.
137      */
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 
140     /**
141      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
142      * a call to {approve}. `value` is the new allowance.
143      */
144     event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 interface IERC20Metadata is IERC20 {
148     /**
149      * @dev Returns the name of the token.
150      */
151     function name() external view returns (string memory);
152 
153     /**
154      * @dev Returns the symbol of the token.
155      */
156     function symbol() external view returns (string memory);
157 
158     /**
159      * @dev Returns the decimals places of the token.
160      */
161     function decimals() external view returns (uint8);
162 }
163 
164 contract ERC20 is Context, IERC20, IERC20Metadata {
165     mapping(address => uint256) private _balances;
166 
167     mapping(address => mapping(address => uint256)) private _allowances;
168 
169     uint256 private _totalSupply;
170 
171     string private _name;
172     string private _symbol;
173 
174     /**
175      * @dev Sets the values for {name} and {symbol}.
176      *
177      * The default value of {decimals} is 18. To select a different value for
178      * {decimals} you should overload it.
179      *
180      * All two of these values are immutable: they can only be set once during
181      * construction.
182      */
183     constructor(string memory name_, string memory symbol_) {
184         _name = name_;
185         _symbol = symbol_;
186     }
187 
188     /**
189      * @dev Returns the name of the token.
190      */
191     function name() public view virtual override returns (string memory) {
192         return _name;
193     }
194 
195     /**
196      * @dev Returns the symbol of the token, usually a shorter version of the
197      * name.
198      */
199     function symbol() public view virtual override returns (string memory) {
200         return _symbol;
201     }
202 
203     /**
204      * @dev Returns the number of decimals used to get its user representation.
205      * For example, if `decimals` equals `2`, a balance of `505` tokens should
206      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
207      *
208      * Tokens usually opt for a value of 18, imitating the relationship between
209      * Ether and Wei. This is the value {ERC20} uses, unless this function is
210      * overridden;
211      *
212      * NOTE: This information is only used for _display_ purposes: it in
213      * no way affects any of the arithmetic of the contract, including
214      * {IERC20-balanceOf} and {IERC20-transfer}.
215      */
216     function decimals() public view virtual override returns (uint8) {
217         return 18;
218     }
219 
220     /**
221      * @dev See {IERC20-totalSupply}.
222      */
223     function totalSupply() public view virtual override returns (uint256) {
224         return _totalSupply;
225     }
226 
227     /**
228      * @dev See {IERC20-balanceOf}.
229      */
230     function balanceOf(address account) public view virtual override returns (uint256) {
231         return _balances[account];
232     }
233 
234     /**
235      * @dev See {IERC20-transfer}.
236      *
237      * Requirements:
238      *
239      * - `recipient` cannot be the zero address.
240      * - the caller must have a balance of at least `amount`.
241      */
242     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
243         _transfer(_msgSender(), recipient, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See {IERC20-allowance}.
249      */
250     function allowance(address owner, address spender) public view virtual override returns (uint256) {
251         return _allowances[owner][spender];
252     }
253 
254     /**
255      * @dev See {IERC20-approve}.
256      *
257      * Requirements:
258      *
259      * - `spender` cannot be the zero address.
260      */
261     function approve(address spender, uint256 amount) public virtual override returns (bool) {
262         _approve(_msgSender(), spender, amount);
263         return true;
264     }
265 
266     /**
267      * @dev See {IERC20-transferFrom}.
268      *
269      * Emits an {Approval} event indicating the updated allowance. This is not
270      * required by the EIP. See the note at the beginning of {ERC20}.
271      *
272      * Requirements:
273      *
274      * - `sender` and `recipient` cannot be the zero address.
275      * - `sender` must have a balance of at least `amount`.
276      * - the caller must have allowance for ``sender``'s tokens of at least
277      * `amount`.
278      */
279     function transferFrom(
280         address sender,
281         address recipient,
282         uint256 amount
283     ) public virtual override returns (bool) {
284         _transfer(sender, recipient, amount);
285 
286         uint256 currentAllowance = _allowances[sender][_msgSender()];
287         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
288         unchecked {
289             _approve(sender, _msgSender(), currentAllowance - amount);
290         }
291 
292         return true;
293     }
294 
295     /**
296      * @dev Atomically increases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to {approve} that can be used as a mitigation for
299      * problems described in {IERC20-approve}.
300      *
301      * Emits an {Approval} event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
308         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      * - `spender` must have allowance for the caller of at least
324      * `subtractedValue`.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
327         uint256 currentAllowance = _allowances[_msgSender()][spender];
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         unchecked {
330             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
331         }
332 
333         return true;
334     }
335 
336     /**
337      * @dev Moves `amount` of tokens from `sender` to `recipient`.
338      *
339      * This internal function is equivalent to {transfer}, and can be used to
340      * e.g. implement automatic token fees, slashing mechanisms, etc.
341      *
342      * Emits a {Transfer} event.
343      *
344      * Requirements:
345      *
346      * - `sender` cannot be the zero address.
347      * - `recipient` cannot be the zero address.
348      * - `sender` must have a balance of at least `amount`.
349      */
350     function _transfer(
351         address sender,
352         address recipient,
353         uint256 amount
354     ) internal virtual {
355         require(sender != address(0), "ERC20: transfer from the zero address");
356         require(recipient != address(0), "ERC20: transfer to the zero address");
357 
358         _beforeTokenTransfer(sender, recipient, amount);
359 
360         uint256 senderBalance = _balances[sender];
361         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
362         unchecked {
363             _balances[sender] = senderBalance - amount;
364         }
365         _balances[recipient] += amount;
366 
367         emit Transfer(sender, recipient, amount);
368 
369         _afterTokenTransfer(sender, recipient, amount);
370     }
371 
372     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with `from` set to the zero address.
376      *
377      * Requirements:
378      *
379      * - `account` cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: mint to the zero address");
383 
384         _beforeTokenTransfer(address(0), account, amount);
385 
386         _totalSupply += amount;
387         _balances[account] += amount;
388         emit Transfer(address(0), account, amount);
389 
390         _afterTokenTransfer(address(0), account, amount);
391     }
392 
393     /**
394      * @dev Destroys `amount` tokens from `account`, reducing the
395      * total supply.
396      *
397      * Emits a {Transfer} event with `to` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      * - `account` must have at least `amount` tokens.
403      */
404     function _burn(address account, uint256 amount) internal virtual {
405         require(account != address(0), "ERC20: burn from the zero address");
406 
407         _beforeTokenTransfer(account, address(0), amount);
408 
409         uint256 accountBalance = _balances[account];
410         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
411         unchecked {
412             _balances[account] = accountBalance - amount;
413         }
414         _totalSupply -= amount;
415 
416         emit Transfer(account, address(0), amount);
417 
418         _afterTokenTransfer(account, address(0), amount);
419     }
420 
421     /**
422      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
423      *
424      * This internal function is equivalent to `approve`, and can be used to
425      * e.g. set automatic allowances for certain subsystems, etc.
426      *
427      * Emits an {Approval} event.
428      *
429      * Requirements:
430      *
431      * - `owner` cannot be the zero address.
432      * - `spender` cannot be the zero address.
433      */
434     function _approve(
435         address owner,
436         address spender,
437         uint256 amount
438     ) internal virtual {
439         require(owner != address(0), "ERC20: approve from the zero address");
440         require(spender != address(0), "ERC20: approve to the zero address");
441 
442         _allowances[owner][spender] = amount;
443         emit Approval(owner, spender, amount);
444     }
445 
446     /**
447      * @dev Hook that is called before any transfer of tokens. This includes
448      * minting and burning.
449      *
450      * Calling conditions:
451      *
452      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
453      * will be transferred to `to`.
454      * - when `from` is zero, `amount` tokens will be minted for `to`.
455      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
456      * - `from` and `to` are never both zero.
457      *
458      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
459      */
460     function _beforeTokenTransfer(
461         address from,
462         address to,
463         uint256 amount
464     ) internal virtual {}
465 
466     /**
467      * @dev Hook that is called after any transfer of tokens. This includes
468      * minting and burning.
469      *
470      * Calling conditions:
471      *
472      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
473      * has been transferred to `to`.
474      * - when `from` is zero, `amount` tokens have been minted for `to`.
475      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
476      * - `from` and `to` are never both zero.
477      *
478      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
479      */
480     function _afterTokenTransfer(
481         address from,
482         address to,
483         uint256 amount
484     ) internal virtual {}
485 }
486 
487 library SafeMath {
488     /**
489      * @dev Returns the addition of two unsigned integers, with an overflow flag.
490      *
491      * _Available since v3.4._
492      */
493     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
494         unchecked {
495             uint256 c = a + b;
496             if (c < a) return (false, 0);
497             return (true, c);
498         }
499     }
500 
501     /**
502      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
503      *
504      * _Available since v3.4._
505      */
506     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
507         unchecked {
508             if (b > a) return (false, 0);
509             return (true, a - b);
510         }
511     }
512 
513     /**
514      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
515      *
516      * _Available since v3.4._
517      */
518     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
519         unchecked {
520             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
521             // benefit is lost if 'b' is also tested.
522             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
523             if (a == 0) return (true, 0);
524             uint256 c = a * b;
525             if (c / a != b) return (false, 0);
526             return (true, c);
527         }
528     }
529 
530     /**
531      * @dev Returns the division of two unsigned integers, with a division by zero flag.
532      *
533      * _Available since v3.4._
534      */
535     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
536         unchecked {
537             if (b == 0) return (false, 0);
538             return (true, a / b);
539         }
540     }
541 
542     /**
543      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
544      *
545      * _Available since v3.4._
546      */
547     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
548         unchecked {
549             if (b == 0) return (false, 0);
550             return (true, a % b);
551         }
552     }
553 
554     /**
555      * @dev Returns the addition of two unsigned integers, reverting on
556      * overflow.
557      *
558      * Counterpart to Solidity's `+` operator.
559      *
560      * Requirements:
561      *
562      * - Addition cannot overflow.
563      */
564     function add(uint256 a, uint256 b) internal pure returns (uint256) {
565         return a + b;
566     }
567 
568     /**
569      * @dev Returns the subtraction of two unsigned integers, reverting on
570      * overflow (when the result is negative).
571      *
572      * Counterpart to Solidity's `-` operator.
573      *
574      * Requirements:
575      *
576      * - Subtraction cannot overflow.
577      */
578     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
579         return a - b;
580     }
581 
582     /**
583      * @dev Returns the multiplication of two unsigned integers, reverting on
584      * overflow.
585      *
586      * Counterpart to Solidity's `*` operator.
587      *
588      * Requirements:
589      *
590      * - Multiplication cannot overflow.
591      */
592     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
593         return a * b;
594     }
595 
596     /**
597      * @dev Returns the integer division of two unsigned integers, reverting on
598      * division by zero. The result is rounded towards zero.
599      *
600      * Counterpart to Solidity's `/` operator.
601      *
602      * Requirements:
603      *
604      * - The divisor cannot be zero.
605      */
606     function div(uint256 a, uint256 b) internal pure returns (uint256) {
607         return a / b;
608     }
609 
610     /**
611      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
612      * reverting when dividing by zero.
613      *
614      * Counterpart to Solidity's `%` operator. This function uses a `revert`
615      * opcode (which leaves remaining gas untouched) while Solidity uses an
616      * invalid opcode to revert (consuming all remaining gas).
617      *
618      * Requirements:
619      *
620      * - The divisor cannot be zero.
621      */
622     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
623         return a % b;
624     }
625 
626     /**
627      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
628      * overflow (when the result is negative).
629      *
630      * CAUTION: This function is deprecated because it requires allocating memory for the error
631      * message unnecessarily. For custom revert reasons use {trySub}.
632      *
633      * Counterpart to Solidity's `-` operator.
634      *
635      * Requirements:
636      *
637      * - Subtraction cannot overflow.
638      */
639     function sub(
640         uint256 a,
641         uint256 b,
642         string memory errorMessage
643     ) internal pure returns (uint256) {
644         unchecked {
645             require(b <= a, errorMessage);
646             return a - b;
647         }
648     }
649 
650     /**
651      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
652      * division by zero. The result is rounded towards zero.
653      *
654      * Counterpart to Solidity's `/` operator. Note: this function uses a
655      * `revert` opcode (which leaves remaining gas untouched) while Solidity
656      * uses an invalid opcode to revert (consuming all remaining gas).
657      *
658      * Requirements:
659      *
660      * - The divisor cannot be zero.
661      */
662     function div(
663         uint256 a,
664         uint256 b,
665         string memory errorMessage
666     ) internal pure returns (uint256) {
667         unchecked {
668             require(b > 0, errorMessage);
669             return a / b;
670         }
671     }
672 
673     /**
674      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
675      * reverting with custom message when dividing by zero.
676      *
677      * CAUTION: This function is deprecated because it requires allocating memory for the error
678      * message unnecessarily. For custom revert reasons use {tryMod}.
679      *
680      * Counterpart to Solidity's `%` operator. This function uses a `revert`
681      * opcode (which leaves remaining gas untouched) while Solidity uses an
682      * invalid opcode to revert (consuming all remaining gas).
683      *
684      * Requirements:
685      *
686      * - The divisor cannot be zero.
687      */
688     function mod(
689         uint256 a,
690         uint256 b,
691         string memory errorMessage
692     ) internal pure returns (uint256) {
693         unchecked {
694             require(b > 0, errorMessage);
695             return a % b;
696         }
697     }
698 }
699 
700 interface IUniswapV2Factory {
701     event PairCreated(
702         address indexed token0,
703         address indexed token1,
704         address pair,
705         uint256
706     );
707 
708     function feeTo() external view returns (address);
709 
710     function feeToSetter() external view returns (address);
711 
712     function getPair(address tokenA, address tokenB)
713         external
714         view
715         returns (address pair);
716 
717     function allPairs(uint256) external view returns (address pair);
718 
719     function allPairsLength() external view returns (uint256);
720 
721     function createPair(address tokenA, address tokenB)
722         external
723         returns (address pair);
724 
725     function setFeeTo(address) external;
726 
727     function setFeeToSetter(address) external;
728 }
729 
730 interface IUniswapV2Pair {
731     event Approval(
732         address indexed owner,
733         address indexed spender,
734         uint256 value
735     );
736     event Transfer(address indexed from, address indexed to, uint256 value);
737 
738     function name() external pure returns (string memory);
739 
740     function symbol() external pure returns (string memory);
741 
742     function decimals() external pure returns (uint8);
743 
744     function totalSupply() external view returns (uint256);
745 
746     function balanceOf(address owner) external view returns (uint256);
747 
748     function allowance(address owner, address spender)
749         external
750         view
751         returns (uint256);
752 
753     function approve(address spender, uint256 value) external returns (bool);
754 
755     function transfer(address to, uint256 value) external returns (bool);
756 
757     function transferFrom(
758         address from,
759         address to,
760         uint256 value
761     ) external returns (bool);
762 
763     function DOMAIN_SEPARATOR() external view returns (bytes32);
764 
765     function PERMIT_TYPEHASH() external pure returns (bytes32);
766 
767     function nonces(address owner) external view returns (uint256);
768 
769     function permit(
770         address owner,
771         address spender,
772         uint256 value,
773         uint256 deadline,
774         uint8 v,
775         bytes32 r,
776         bytes32 s
777     ) external;
778 
779     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
780     event Burn(
781         address indexed sender,
782         uint256 amount0,
783         uint256 amount1,
784         address indexed to
785     );
786     event Swap(
787         address indexed sender,
788         uint256 amount0In,
789         uint256 amount1In,
790         uint256 amount0Out,
791         uint256 amount1Out,
792         address indexed to
793     );
794     event Sync(uint112 reserve0, uint112 reserve1);
795 
796     function MINIMUM_LIQUIDITY() external pure returns (uint256);
797 
798     function factory() external view returns (address);
799 
800     function token0() external view returns (address);
801 
802     function token1() external view returns (address);
803 
804     function getReserves()
805         external
806         view
807         returns (
808             uint112 reserve0,
809             uint112 reserve1,
810             uint32 blockTimestampLast
811         );
812 
813     function price0CumulativeLast() external view returns (uint256);
814 
815     function price1CumulativeLast() external view returns (uint256);
816 
817     function kLast() external view returns (uint256);
818 
819     function mint(address to) external returns (uint256 liquidity);
820 
821     function burn(address to)
822         external
823         returns (uint256 amount0, uint256 amount1);
824 
825     function swap(
826         uint256 amount0Out,
827         uint256 amount1Out,
828         address to,
829         bytes calldata data
830     ) external;
831 
832     function skim(address to) external;
833 
834     function sync() external;
835 
836     function initialize(address, address) external;
837 }
838 
839 interface IUniswapV2Router02 {
840     function factory() external pure returns (address);
841 
842     function WETH() external pure returns (address);
843 
844     function addLiquidity(
845         address tokenA,
846         address tokenB,
847         uint256 amountADesired,
848         uint256 amountBDesired,
849         uint256 amountAMin,
850         uint256 amountBMin,
851         address to,
852         uint256 deadline
853     )
854         external
855         returns (
856             uint256 amountA,
857             uint256 amountB,
858             uint256 liquidity
859         );
860 
861     function addLiquidityETH(
862         address token,
863         uint256 amountTokenDesired,
864         uint256 amountTokenMin,
865         uint256 amountETHMin,
866         address to,
867         uint256 deadline
868     )
869         external
870         payable
871         returns (
872             uint256 amountToken,
873             uint256 amountETH,
874             uint256 liquidity
875         );
876 
877     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
878         uint256 amountIn,
879         uint256 amountOutMin,
880         address[] calldata path,
881         address to,
882         uint256 deadline
883     ) external;
884 
885     function swapExactETHForTokensSupportingFeeOnTransferTokens(
886         uint256 amountOutMin,
887         address[] calldata path,
888         address to,
889         uint256 deadline
890     ) external payable;
891 
892     function swapExactTokensForETHSupportingFeeOnTransferTokens(
893         uint256 amountIn,
894         uint256 amountOutMin,
895         address[] calldata path,
896         address to,
897         uint256 deadline
898     ) external;
899 }
900 
901 contract ELONGATE is ERC20, Ownable {
902     using SafeMath for uint256;
903 
904     IUniswapV2Router02 public immutable uniswapV2Router;
905     address public immutable uniswapV2Pair;
906     address public constant deadAddress = address(0xdead);
907 
908     bool private swapping;
909 
910     address public marketingWallet;
911     address public devWallet;
912 
913     uint256 public maxTransactionAmount;
914     uint256 public swapTokensAtAmount;
915     uint256 public maxWallet;
916 
917     bool public limitsInEffect = true;
918     bool public tradingActive = false;
919     bool public swapEnabled = false;
920 
921     // Anti-bot and anti-whale mappings and variables
922     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
923     bool public transferDelayEnabled = true;
924 
925     uint256 public buyTotalFees;
926     uint256 public buyMarketingFee;
927     uint256 public buyLiquidityFee;
928     uint256 public buyDevFee;
929 
930     uint256 public sellTotalFees;
931     uint256 public sellMarketingFee;
932     uint256 public sellLiquidityFee;
933     uint256 public sellDevFee;
934 
935     uint256 public tokensForMarketing;
936     uint256 public tokensForLiquidity;
937     uint256 public tokensForDev;
938 
939     /******************/
940 
941     // exlcude from fees and max transaction amount
942     mapping(address => bool) private _isExcludedFromFees;
943     mapping(address => bool) public _isExcludedMaxTransactionAmount;
944     
945     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
946     // could be subject to a maximum transfer amount
947     mapping(address => bool) public automatedMarketMakerPairs;
948 
949     event UpdateUniswapV2Router(
950         address indexed newAddress,
951         address indexed oldAddress
952     );
953 
954     event ExcludeFromFees(address indexed account, bool isExcluded);
955 
956     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
957 
958     event marketingWalletUpdated(
959         address indexed newWallet,
960         address indexed oldWallet
961     );
962 
963     event devWalletUpdated(
964         address indexed newWallet,
965         address indexed oldWallet
966     );
967 
968     event SwapAndLiquify(
969         uint256 tokensSwapped,
970         uint256 ethReceived,
971         uint256 tokensIntoLiquidity
972     );
973 
974     constructor() ERC20("Elongate", "ELONGATE") {
975         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
976             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
977         );
978 
979         excludeFromMaxTransaction(address(_uniswapV2Router), true);
980         uniswapV2Router = _uniswapV2Router;
981 
982         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
983             .createPair(address(this), _uniswapV2Router.WETH());
984         excludeFromMaxTransaction(address(uniswapV2Pair), true);
985         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
986 
987         uint256 _buyMarketingFee = 20;
988         uint256 _buyLiquidityFee = 0;
989         uint256 _buyDevFee = 0;
990 
991         uint256 _sellMarketingFee = 20;
992         uint256 _sellLiquidityFee = 0;
993         uint256 _sellDevFee = 0;
994 
995         uint256 totalSupply = 10000000 * 1e18;
996 
997         maxTransactionAmount = (totalSupply) / 50; // 2% from total supply maxTransactionAmountTxn
998         maxWallet = (totalSupply) / 50; // 2% from total supply maxWallet
999         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1000 
1001         buyMarketingFee = _buyMarketingFee;
1002         buyLiquidityFee = _buyLiquidityFee;
1003         buyDevFee = _buyDevFee;
1004         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1005 
1006         sellMarketingFee = _sellMarketingFee;
1007         sellLiquidityFee = _sellLiquidityFee;
1008         sellDevFee = _sellDevFee;
1009         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1010 
1011         marketingWallet = address(msg.sender); // Marketing Wallet
1012         devWallet = address(msg.sender); // Dev Wallet
1013 
1014         // exclude from paying fees or having max transaction amount
1015         excludeFromFees(owner(), true);
1016         excludeFromFees(address(this), true);
1017         excludeFromFees(address(0xdead), true);
1018 
1019         excludeFromMaxTransaction(owner(), true);
1020         excludeFromMaxTransaction(address(this), true);
1021         excludeFromMaxTransaction(address(0xdead), true);
1022 
1023         /*
1024             _mint is an internal function in ERC20.sol that is only called here,
1025             and CANNOT be called ever again
1026         */
1027         _mint(msg.sender, totalSupply);
1028     }
1029 
1030     receive() external payable {}
1031 
1032     // once enabled, can never be turned off
1033     function enableTrading() external onlyOwner {
1034         tradingActive = true;
1035         swapEnabled = true;
1036     }
1037 
1038     // remove limits after token is stable
1039     function removeLimits() external onlyOwner returns (bool) {
1040         limitsInEffect = false;
1041         return true;
1042     }
1043 
1044     // disable Transfer delay - cannot be reenabled
1045     function disableTransferDelay() external onlyOwner returns (bool) {
1046         transferDelayEnabled = false;
1047         return true;
1048     }
1049 
1050     // change the minimum amount of tokens to sell from fees
1051     function updateSwapTokensAtAmount(uint256 newAmount)
1052         external
1053         onlyOwner
1054         returns (bool)
1055     {
1056         require(
1057             newAmount >= (totalSupply() * 1) / 10000,
1058             "Swap amount cannot be lower than 0.01% total supply."
1059         );
1060         require(
1061             newAmount <= (totalSupply() * 5) / 1000,
1062             "Swap amount cannot be higher than 0.5% total supply."
1063         );
1064         swapTokensAtAmount = newAmount;
1065         return true;
1066     }
1067 
1068     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1069         require(
1070             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1071             "Cannot set maxTransactionAmount lower than 0.1%"
1072         );
1073         maxTransactionAmount = newNum * (10**18);
1074     }
1075 
1076     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1077         require(
1078             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1079             "Cannot set maxWallet lower than 0.5%"
1080         );
1081         maxWallet = newNum * (10**18);
1082     }
1083 
1084     function excludeFromMaxTransaction(address updAds, bool isEx)
1085         public
1086         onlyOwner
1087     {
1088         _isExcludedMaxTransactionAmount[updAds] = isEx;
1089     }
1090 
1091     // only use to disable contract sales if absolutely necessary (emergency use only)
1092     function updateSwapEnabled(bool enabled) external onlyOwner {
1093         swapEnabled = enabled;
1094     }
1095 
1096     function updateBuyFees(
1097         uint256 _marketingFee,
1098         uint256 _liquidityFee,
1099         uint256 _devFee
1100     ) external onlyOwner {
1101         buyMarketingFee = _marketingFee;
1102         buyLiquidityFee = _liquidityFee;
1103         buyDevFee = _devFee;
1104         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1105         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1106     }
1107 
1108     function updateSellFees(
1109         uint256 _marketingFee,
1110         uint256 _liquidityFee,
1111         uint256 _devFee
1112     ) external onlyOwner {
1113         sellMarketingFee = _marketingFee;
1114         sellLiquidityFee = _liquidityFee;
1115         sellDevFee = _devFee;
1116         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1117         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
1118     }
1119 
1120     function excludeFromFees(address account, bool excluded) public onlyOwner {
1121         _isExcludedFromFees[account] = excluded;
1122         emit ExcludeFromFees(account, excluded);
1123     }
1124 
1125     function setAutomatedMarketMakerPair(address pair, bool value)
1126         public
1127         onlyOwner
1128     {
1129         require(
1130             pair != uniswapV2Pair,
1131             "The pair cannot be removed from automatedMarketMakerPairs"
1132         );
1133 
1134         _setAutomatedMarketMakerPair(pair, value);
1135     }
1136 
1137     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1138         automatedMarketMakerPairs[pair] = value;
1139 
1140         emit SetAutomatedMarketMakerPair(pair, value);
1141     }
1142 
1143     function updateMarketingWallet(address newMarketingWallet)
1144         external
1145         onlyOwner
1146     {
1147         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1148         marketingWallet = newMarketingWallet;
1149     }
1150 
1151     function updateDevWallet(address newWallet) external onlyOwner {
1152         emit devWalletUpdated(newWallet, devWallet);
1153         devWallet = newWallet;
1154     }
1155 
1156     function isExcludedFromFees(address account) public view returns (bool) {
1157         return _isExcludedFromFees[account];
1158     }
1159 
1160     function _transfer(
1161         address from,
1162         address to,
1163         uint256 amount
1164     ) internal override {
1165         require(from != address(0), "ERC20: transfer from the zero address");
1166         require(to != address(0), "ERC20: transfer to the zero address");
1167 
1168         if (amount == 0 ) {
1169             super._transfer(from, to, 0);
1170             return;
1171         }
1172         if (limitsInEffect) {
1173             if (
1174                 from != owner() &&
1175                 to != owner() &&
1176                 to != address(0) &&
1177                 to != address(0xdead) &&
1178                 !swapping
1179             ) {
1180                 if (!tradingActive) {
1181                     require(
1182                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1183                         "Trading is not active."
1184                     );
1185                 }
1186 
1187                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1188                 if (transferDelayEnabled) {
1189                     if (
1190                         to != owner() &&
1191                         to != address(uniswapV2Router) &&
1192                         to != address(uniswapV2Pair)
1193                     ) {
1194                         require(
1195                             _holderLastTransferTimestamp[tx.origin] <
1196                                 block.number,
1197                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1198                         );
1199                         _holderLastTransferTimestamp[tx.origin] = block.number;
1200                     }
1201                 }
1202 
1203                 //when buy
1204                 if (
1205                     automatedMarketMakerPairs[from] &&
1206                     !_isExcludedMaxTransactionAmount[to]
1207                 ) {
1208                     require(
1209                         amount <= maxTransactionAmount,
1210                         "Buy transfer amount exceeds the maxTransactionAmount."
1211                     );
1212                     require(
1213                         amount + balanceOf(to) <= maxWallet,
1214                         "Max wallet exceeded"
1215                     );
1216                 }
1217                 //when sell
1218                 else if (
1219                     automatedMarketMakerPairs[to] &&
1220                     !_isExcludedMaxTransactionAmount[from]
1221                 ) {
1222                     require(
1223                         amount <= maxTransactionAmount,
1224                         "Sell transfer amount exceeds the maxTransactionAmount."
1225                     );
1226                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1227                     require(
1228                         amount + balanceOf(to) <= maxWallet,
1229                         "Max wallet exceeded"
1230                     );
1231                 }
1232             }
1233         }
1234 
1235         uint256 contractTokenBalance = balanceOf(address(this));
1236 
1237         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1238 
1239         if (
1240             canSwap &&
1241             swapEnabled &&
1242             !swapping &&
1243             !automatedMarketMakerPairs[from] &&
1244             !_isExcludedFromFees[from] &&
1245             !_isExcludedFromFees[to]
1246         ) {
1247             swapping = true;
1248 
1249             swapBack();
1250 
1251             swapping = false;
1252         }
1253 
1254         bool takeFee = !swapping;
1255 
1256         // if any account belongs to _isExcludedFromFee account then remove the fee
1257         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1258             takeFee = false;
1259         }
1260 
1261         uint256 fees = 0;
1262         // only take fees on buys/sells, do not take on wallet transfers
1263         if (takeFee) {
1264             // on sell
1265             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1266                 fees = amount.mul(sellTotalFees).div(100);
1267                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1268                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1269                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1270             }
1271             // on buy
1272             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1273                 fees = amount.mul(buyTotalFees).div(100);
1274                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1275                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1276                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1277             }
1278 
1279             if (fees > 0) {
1280                 super._transfer(from, address(this), fees);
1281             }
1282 
1283             amount -= fees;
1284         }
1285 
1286         super._transfer(from, to, amount);
1287     }
1288 
1289     function swapTokensForEth(uint256 tokenAmount) private {
1290         // generate the uniswap pair path of token -> weth
1291         address[] memory path = new address[](2);
1292         path[0] = address(this);
1293         path[1] = uniswapV2Router.WETH();
1294 
1295         _approve(address(this), address(uniswapV2Router), tokenAmount);
1296 
1297         // make the swap
1298         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1299             tokenAmount,
1300             0, // accept any amount of ETH
1301             path,
1302             address(this),
1303             block.timestamp
1304         );
1305     }
1306 
1307     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1308         // approve token transfer to cover all possible scenarios
1309         _approve(address(this), address(uniswapV2Router), tokenAmount);
1310 
1311         // add the liquidity
1312         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1313             address(this),
1314             tokenAmount,
1315             0, // slippage is unavoidable
1316             0, // slippage is unavoidable
1317             deadAddress,
1318             block.timestamp
1319         );
1320     }
1321 
1322     function swapBack() private {
1323         uint256 contractBalance = balanceOf(address(this));
1324         uint256 totalTokensToSwap = tokensForLiquidity +
1325             tokensForMarketing +
1326             tokensForDev;
1327         bool success;
1328 
1329         if (contractBalance == 0 || totalTokensToSwap == 0) {
1330             return;
1331         }
1332 
1333         if (contractBalance > swapTokensAtAmount * 20) {
1334             contractBalance = swapTokensAtAmount * 20;
1335         }
1336 
1337         // Halve the amount of liquidity tokens
1338         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1339             totalTokensToSwap /
1340             2;
1341         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1342 
1343         uint256 initialETHBalance = address(this).balance;
1344 
1345         swapTokensForEth(amountToSwapForETH);
1346 
1347         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1348 
1349         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1350             totalTokensToSwap
1351         );
1352         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1353 
1354         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1355 
1356         tokensForLiquidity = 0;
1357         tokensForMarketing = 0;
1358         tokensForDev = 0;
1359 
1360         (success, ) = address(devWallet).call{value: ethForDev}("");
1361 
1362         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1363             addLiquidity(liquidityTokens, ethForLiquidity);
1364             emit SwapAndLiquify(
1365                 amountToSwapForETH,
1366                 ethForLiquidity,
1367                 tokensForLiquidity
1368             );
1369         }
1370 
1371         (success, ) = address(marketingWallet).call{
1372             value: address(this).balance
1373         }("");
1374     }
1375 }