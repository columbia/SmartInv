1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.15;
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(
48         uint256 a,
49         uint256 b,
50         string memory errorMessage
51     ) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the multiplication of two unsigned integers, reverting on
60      * overflow.
61      *
62      * Counterpart to Solidity's `*` operator.
63      *
64      * Requirements:
65      *
66      * - Multiplication cannot overflow.
67      */
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
70         // benefit is lost if 'b' is also tested.
71         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
72         if (a == 0) {
73             return 0;
74         }
75 
76         uint256 c = a * b;
77         require(c / a == b, "SafeMath: multiplication overflow");
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the integer division of two unsigned integers. Reverts on
84      * division by zero. The result is rounded towards zero.
85      *
86      * Counterpart to Solidity's `/` operator. Note: this function uses a
87      * `revert` opcode (which leaves remaining gas untouched) while Solidity
88      * uses an invalid opcode to revert (consuming all remaining gas).
89      *
90      * Requirements:
91      *
92      * - The divisor cannot be zero.
93      */
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      *
108      * - The divisor cannot be zero.
109      */
110     function div(
111         uint256 a,
112         uint256 b,
113         string memory errorMessage
114     ) internal pure returns (uint256) {
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
135         return mod(a, b, "SafeMath: modulo by zero");
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts with custom message when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes memory) {
176         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
177         return msg.data;
178     }
179 }
180 
181 /**
182  * @dev Interface of the ERC20 standard as defined in the EIP.
183  */
184 interface IERC20 {
185     /**
186      * @dev Returns the amount of tokens in existence.
187      */
188     function totalSupply() external view returns (uint256);
189 
190     /**
191      * @dev Returns the amount of tokens owned by `account`.
192      */
193     function balanceOf(address account) external view returns (uint256);
194 
195     /**
196      * @dev Moves `amount` tokens from the caller's account to `recipient`.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transfer(address recipient, uint256 amount)
203         external
204         returns (bool);
205 
206     /**
207      * @dev Returns the remaining number of tokens that `spender` will be
208      * allowed to spend on behalf of `owner` through {transferFrom}. This is
209      * zero by default.
210      *
211      * This value changes when {approve} or {transferFrom} are called.
212      */
213     function allowance(address owner, address spender)
214         external
215         view
216         returns (uint256);
217 
218     /**
219      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * IMPORTANT: Beware that changing an allowance with this method brings the risk
224      * that someone may use both the old and the new allowance by unfortunate
225      * transaction ordering. One possible solution to mitigate this race
226      * condition is to first reduce the spender's allowance to 0 and set the
227      * desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address spender, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Moves `amount` tokens from `sender` to `recipient` using the
236      * allowance mechanism. `amount` is then deducted from the caller's
237      * allowance.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transferFrom(
244         address sender,
245         address recipient,
246         uint256 amount
247     ) external returns (bool);
248 
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be zero.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to {approve}. `value` is the new allowance.
260      */
261     event Approval(
262         address indexed owner,
263         address indexed spender,
264         uint256 value
265     );
266 }
267 
268 /**
269  * @dev Interface for the optional metadata functions from the ERC20 standard.
270  *
271  * _Available since v4.1._
272  */
273 interface IERC20Metadata is IERC20 {
274     /**
275      * @dev Returns the name of the token.
276      */
277     function name() external view returns (string memory);
278 
279     /**
280      * @dev Returns the symbol of the token.
281      */
282     function symbol() external view returns (string memory);
283 
284     /**
285      * @dev Returns the decimals places of the token.
286      */
287     function decimals() external view returns (uint8);
288 }
289 
290 /**
291  * @dev Implementation of the {IERC20} interface.
292  *
293  * This implementation is agnostic to the way tokens are created. This means
294  * that a supply mechanism has to be added in a derived contract using {_mint}.
295  * For a generic mechanism see {ERC20PresetMinterPauser}.
296  *
297  * TIP: For a detailed writeup see our guide
298  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
299  * to implement supply mechanisms].
300  *
301  * We have followed general OpenZeppelin guidelines: functions revert instead
302  * of returning `false` on failure. This behavior is nonetheless conventional
303  * and does not conflict with the expectations of ERC20 applications.
304  *
305  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
306  * This allows applications to reconstruct the allowance for all accounts just
307  * by listening to said events. Other implementations of the EIP may not emit
308  * these events, as it isn't required by the specification.
309  *
310  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
311  * functions have been added to mitigate the well-known issues around setting
312  * allowances. See {IERC20-approve}.
313  */
314 contract ERC20 is Context, IERC20, IERC20Metadata {
315     using SafeMath for uint256;
316 
317     mapping(address => uint256) private _balances;
318 
319     mapping(address => mapping(address => uint256)) private _allowances;
320 
321     uint256 private _totalSupply;
322 
323     string private _name;
324     string private _symbol;
325     uint8 private _decimals;
326 
327     /**
328      * @dev Sets the values for {name} and {symbol}.
329      *
330      * The default value of {decimals} is 18. To select a different value for
331      * {decimals} you should overload it.
332      *
333      * All two of these values are immutable: they can only be set once during
334      * construction.
335      */
336     constructor(
337         string memory name_,
338         string memory symbol_,
339         uint8 decimals_
340     ) {
341         _name = name_;
342         _symbol = symbol_;
343         _decimals = decimals_;
344     }
345 
346     /**
347      * @dev Returns the name of the token.
348      */
349     function name() public view virtual override returns (string memory) {
350         return _name;
351     }
352 
353     /**
354      * @dev Returns the symbol of the token, usually a shorter version of the
355      * name.
356      */
357     function symbol() public view virtual override returns (string memory) {
358         return _symbol;
359     }
360 
361     /**
362      * @dev Returns the number of decimals used to get its user representation.
363      * For example, if `decimals` equals `2`, a balance of `505` tokens should
364      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
365      *
366      * Tokens usually opt for a value of 18, imitating the relationship between
367      * Ether and Wei. This is the value {ERC20} uses, unless this function is
368      * overridden;
369      *
370      * NOTE: This information is only used for _display_ purposes: it in
371      * no way affects any of the arithmetic of the contract, including
372      * {IERC20-balanceOf} and {IERC20-transfer}.
373      */
374     function decimals() public view virtual override returns (uint8) {
375         return _decimals;
376     }
377 
378     /**
379      * @dev See {IERC20-totalSupply}.
380      */
381     function totalSupply() public view virtual override returns (uint256) {
382         return _totalSupply;
383     }
384 
385     /**
386      * @dev See {IERC20-balanceOf}.
387      */
388     function balanceOf(address account)
389         public
390         view
391         virtual
392         override
393         returns (uint256)
394     {
395         return _balances[account];
396     }
397 
398     /**
399      * @dev See {IERC20-transfer}.
400      *
401      * Requirements:
402      *
403      * - `recipient` cannot be the zero address.
404      * - the caller must have a balance of at least `amount`.
405      */
406     function transfer(address recipient, uint256 amount)
407         public
408         virtual
409         override
410         returns (bool)
411     {
412         _transfer(_msgSender(), recipient, amount);
413         return true;
414     }
415 
416     /**
417      * @dev See {IERC20-allowance}.
418      */
419     function allowance(address owner, address spender)
420         public
421         view
422         virtual
423         override
424         returns (uint256)
425     {
426         return _allowances[owner][spender];
427     }
428 
429     /**
430      * @dev See {IERC20-approve}.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function approve(address spender, uint256 amount)
437         public
438         virtual
439         override
440         returns (bool)
441     {
442         _approve(_msgSender(), spender, amount);
443         return true;
444     }
445 
446     /**
447      * @dev See {IERC20-transferFrom}.
448      *
449      * Emits an {Approval} event indicating the updated allowance. This is not
450      * required by the EIP. See the note at the beginning of {ERC20}.
451      *
452      * Requirements:
453      *
454      * - `sender` and `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `amount`.
456      * - the caller must have allowance for ``sender``'s tokens of at least
457      * `amount`.
458      */
459     function transferFrom(
460         address sender,
461         address recipient,
462         uint256 amount
463     ) public virtual override returns (bool) {
464         _transfer(sender, recipient, amount);
465         _approve(
466             sender,
467             _msgSender(),
468             _allowances[sender][_msgSender()].sub(
469                 amount,
470                 "ERC20: transfer amount exceeds allowance"
471             )
472         );
473         return true;
474     }
475 
476     /**
477      * @dev Atomically increases the allowance granted to `spender` by the caller.
478      *
479      * This is an alternative to {approve} that can be used as a mitigation for
480      * problems described in {IERC20-approve}.
481      *
482      * Emits an {Approval} event indicating the updated allowance.
483      *
484      * Requirements:
485      *
486      * - `spender` cannot be the zero address.
487      */
488     function increaseAllowance(address spender, uint256 addedValue)
489         public
490         virtual
491         returns (bool)
492     {
493         _approve(
494             _msgSender(),
495             spender,
496             _allowances[_msgSender()][spender].add(addedValue)
497         );
498         return true;
499     }
500 
501     /**
502      * @dev Atomically decreases the allowance granted to `spender` by the caller.
503      *
504      * This is an alternative to {approve} that can be used as a mitigation for
505      * problems described in {IERC20-approve}.
506      *
507      * Emits an {Approval} event indicating the updated allowance.
508      *
509      * Requirements:
510      *
511      * - `spender` cannot be the zero address.
512      * - `spender` must have allowance for the caller of at least
513      * `subtractedValue`.
514      */
515     function decreaseAllowance(address spender, uint256 subtractedValue)
516         public
517         virtual
518         returns (bool)
519     {
520         _approve(
521             _msgSender(),
522             spender,
523             _allowances[_msgSender()][spender].sub(
524                 subtractedValue,
525                 "ERC20: decreased allowance below zero"
526             )
527         );
528         return true;
529     }
530 
531     /**
532      * @dev Moves tokens `amount` from `sender` to `recipient`.
533      *
534      * This is internal function is equivalent to {transfer}, and can be used to
535      * e.g. implement automatic token fees, slashing mechanisms, etc.
536      *
537      * Emits a {Transfer} event.
538      *
539      * Requirements:
540      *
541      * - `sender` cannot be the zero address.
542      * - `recipient` cannot be the zero address.
543      * - `sender` must have a balance of at least `amount`.
544      */
545     function _transfer(
546         address sender,
547         address recipient,
548         uint256 amount
549     ) internal virtual {
550         require(sender != address(0), "ERC20: transfer from the zero address");
551         require(recipient != address(0), "ERC20: transfer to the zero address");
552 
553         _beforeTokenTransfer(sender, recipient, amount);
554 
555         _balances[sender] = _balances[sender].sub(
556             amount,
557             "ERC20: transfer amount exceeds balance"
558         );
559         _balances[recipient] = _balances[recipient].add(amount);
560         emit Transfer(sender, recipient, amount);
561     }
562 
563     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
564      * the total supply.
565      *
566      * Emits a {Transfer} event with `from` set to the zero address.
567      *
568      * Requirements:
569      *
570      * - `account` cannot be the zero address.
571      */
572     function _mint(address account, uint256 amount) internal virtual {
573         require(account != address(0), "ERC20: mint to the zero address");
574 
575         _beforeTokenTransfer(address(0), account, amount);
576 
577         _totalSupply = _totalSupply.add(amount);
578         _balances[account] = _balances[account].add(amount);
579         emit Transfer(address(0), account, amount);
580     }
581 
582     /**
583      * @dev Destroys `amount` tokens from `account`, reducing the
584      * total supply.
585      *
586      * Emits a {Transfer} event with `to` set to the zero address.
587      *
588      * Requirements:
589      *
590      * - `account` cannot be the zero address.
591      * - `account` must have at least `amount` tokens.
592      */
593     function _burn(address account, uint256 amount) internal virtual {
594         require(account != address(0), "ERC20: burn from the zero address");
595 
596         _beforeTokenTransfer(account, address(0), amount);
597 
598         _balances[account] = _balances[account].sub(
599             amount,
600             "ERC20: burn amount exceeds balance"
601         );
602         _totalSupply = _totalSupply.sub(amount);
603         emit Transfer(account, address(0), amount);
604     }
605 
606     /**
607      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
608      *
609      * This internal function is equivalent to `approve`, and can be used to
610      * e.g. set automatic allowances for certain subsystems, etc.
611      *
612      * Emits an {Approval} event.
613      *
614      * Requirements:
615      *
616      * - `owner` cannot be the zero address.
617      * - `spender` cannot be the zero address.
618      */
619     function _approve(
620         address owner,
621         address spender,
622         uint256 amount
623     ) internal virtual {
624         require(owner != address(0), "ERC20: approve from the zero address");
625         require(spender != address(0), "ERC20: approve to the zero address");
626 
627         _allowances[owner][spender] = amount;
628         emit Approval(owner, spender, amount);
629     }
630 
631     /**
632      * @dev Hook that is called before any transfer of tokens. This includes
633      * minting and burning.
634      *
635      * Calling conditions:
636      *
637      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
638      * will be to transferred to `to`.
639      * - when `from` is zero, `amount` tokens will be minted for `to`.
640      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
641      * - `from` and `to` are never both zero.
642      *
643      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
644      */
645     function _beforeTokenTransfer(
646         address from,
647         address to,
648         uint256 amount
649     ) internal virtual {}
650 }
651 
652 library IterableMapping {
653     // Iterable mapping from address to uint;
654     struct Map {
655         address[] keys;
656         mapping(address => uint256) values;
657         mapping(address => uint256) indexOf;
658         mapping(address => bool) inserted;
659     }
660 
661     function get(Map storage map, address key) public view returns (uint256) {
662         return map.values[key];
663     }
664 
665     function getIndexOfKey(Map storage map, address key)
666         public
667         view
668         returns (int256)
669     {
670         if (!map.inserted[key]) {
671             return -1;
672         }
673         return int256(map.indexOf[key]);
674     }
675 
676     function getKeyAtIndex(Map storage map, uint256 index)
677         public
678         view
679         returns (address)
680     {
681         return map.keys[index];
682     }
683 
684     function size(Map storage map) public view returns (uint256) {
685         return map.keys.length;
686     }
687 
688     function set(
689         Map storage map,
690         address key,
691         uint256 val
692     ) public {
693         if (map.inserted[key]) {
694             map.values[key] = val;
695         } else {
696             map.inserted[key] = true;
697             map.values[key] = val;
698             map.indexOf[key] = map.keys.length;
699             map.keys.push(key);
700         }
701     }
702 
703     function remove(Map storage map, address key) public {
704         if (!map.inserted[key]) {
705             return;
706         }
707 
708         delete map.inserted[key];
709         delete map.values[key];
710 
711         uint256 index = map.indexOf[key];
712         uint256 lastIndex = map.keys.length - 1;
713         address lastKey = map.keys[lastIndex];
714 
715         map.indexOf[lastKey] = index;
716         delete map.indexOf[key];
717 
718         map.keys[index] = lastKey;
719         map.keys.pop();
720     }
721 }
722 
723 interface IUniswapV2Factory {
724     event PairCreated(
725         address indexed token0,
726         address indexed token1,
727         address pair,
728         uint256
729     );
730 
731     function feeTo() external view returns (address);
732 
733     function feeToSetter() external view returns (address);
734 
735     function getPair(address tokenA, address tokenB)
736         external
737         view
738         returns (address pair);
739 
740     function allPairs(uint256) external view returns (address pair);
741 
742     function allPairsLength() external view returns (uint256);
743 
744     function createPair(address tokenA, address tokenB)
745         external
746         returns (address pair);
747 
748     function setFeeTo(address) external;
749 
750     function setFeeToSetter(address) external;
751 }
752 
753 interface IUniswapV2Pair {
754     event Approval(
755         address indexed owner,
756         address indexed spender,
757         uint256 value
758     );
759     event Transfer(address indexed from, address indexed to, uint256 value);
760 
761     function name() external pure returns (string memory);
762 
763     function symbol() external pure returns (string memory);
764 
765     function decimals() external pure returns (uint8);
766 
767     function totalSupply() external view returns (uint256);
768 
769     function balanceOf(address owner) external view returns (uint256);
770 
771     function allowance(address owner, address spender)
772         external
773         view
774         returns (uint256);
775 
776     function approve(address spender, uint256 value) external returns (bool);
777 
778     function transfer(address to, uint256 value) external returns (bool);
779 
780     function transferFrom(
781         address from,
782         address to,
783         uint256 value
784     ) external returns (bool);
785 
786     function DOMAIN_SEPARATOR() external view returns (bytes32);
787 
788     function PERMIT_TYPEHASH() external pure returns (bytes32);
789 
790     function nonces(address owner) external view returns (uint256);
791 
792     function permit(
793         address owner,
794         address spender,
795         uint256 value,
796         uint256 deadline,
797         uint8 v,
798         bytes32 r,
799         bytes32 s
800     ) external;
801 
802     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
803     event Burn(
804         address indexed sender,
805         uint256 amount0,
806         uint256 amount1,
807         address indexed to
808     );
809     event Swap(
810         address indexed sender,
811         uint256 amount0In,
812         uint256 amount1In,
813         uint256 amount0Out,
814         uint256 amount1Out,
815         address indexed to
816     );
817     event Sync(uint112 reserve0, uint112 reserve1);
818 
819     function MINIMUM_LIQUIDITY() external pure returns (uint256);
820 
821     function factory() external view returns (address);
822 
823     function token0() external view returns (address);
824 
825     function token1() external view returns (address);
826 
827     function getReserves()
828         external
829         view
830         returns (
831             uint112 reserve0,
832             uint112 reserve1,
833             uint32 blockTimestampLast
834         );
835 
836     function price0CumulativeLast() external view returns (uint256);
837 
838     function price1CumulativeLast() external view returns (uint256);
839 
840     function kLast() external view returns (uint256);
841 
842     function mint(address to) external returns (uint256 liquidity);
843 
844     function burn(address to)
845         external
846         returns (uint256 amount0, uint256 amount1);
847 
848     function swap(
849         uint256 amount0Out,
850         uint256 amount1Out,
851         address to,
852         bytes calldata data
853     ) external;
854 
855     function skim(address to) external;
856 
857     function sync() external;
858 
859     function initialize(address, address) external;
860 }
861 
862 interface IUniswapV2Router01 {
863     function factory() external pure returns (address);
864 
865     function WETH() external pure returns (address);
866 
867     function addLiquidity(
868         address tokenA,
869         address tokenB,
870         uint256 amountADesired,
871         uint256 amountBDesired,
872         uint256 amountAMin,
873         uint256 amountBMin,
874         address to,
875         uint256 deadline
876     )
877         external
878         returns (
879             uint256 amountA,
880             uint256 amountB,
881             uint256 liquidity
882         );
883 
884     function addLiquidityETH(
885         address token,
886         uint256 amountTokenDesired,
887         uint256 amountTokenMin,
888         uint256 amountETHMin,
889         address to,
890         uint256 deadline
891     )
892         external
893         payable
894         returns (
895             uint256 amountToken,
896             uint256 amountETH,
897             uint256 liquidity
898         );
899 
900     function removeLiquidity(
901         address tokenA,
902         address tokenB,
903         uint256 liquidity,
904         uint256 amountAMin,
905         uint256 amountBMin,
906         address to,
907         uint256 deadline
908     ) external returns (uint256 amountA, uint256 amountB);
909 
910     function removeLiquidityETH(
911         address token,
912         uint256 liquidity,
913         uint256 amountTokenMin,
914         uint256 amountETHMin,
915         address to,
916         uint256 deadline
917     ) external returns (uint256 amountToken, uint256 amountETH);
918 
919     function removeLiquidityWithPermit(
920         address tokenA,
921         address tokenB,
922         uint256 liquidity,
923         uint256 amountAMin,
924         uint256 amountBMin,
925         address to,
926         uint256 deadline,
927         bool approveMax,
928         uint8 v,
929         bytes32 r,
930         bytes32 s
931     ) external returns (uint256 amountA, uint256 amountB);
932 
933     function removeLiquidityETHWithPermit(
934         address token,
935         uint256 liquidity,
936         uint256 amountTokenMin,
937         uint256 amountETHMin,
938         address to,
939         uint256 deadline,
940         bool approveMax,
941         uint8 v,
942         bytes32 r,
943         bytes32 s
944     ) external returns (uint256 amountToken, uint256 amountETH);
945 
946     function swapExactTokensForTokens(
947         uint256 amountIn,
948         uint256 amountOutMin,
949         address[] calldata path,
950         address to,
951         uint256 deadline
952     ) external returns (uint256[] memory amounts);
953 
954     function swapTokensForExactTokens(
955         uint256 amountOut,
956         uint256 amountInMax,
957         address[] calldata path,
958         address to,
959         uint256 deadline
960     ) external returns (uint256[] memory amounts);
961 
962     function swapExactETHForTokens(
963         uint256 amountOutMin,
964         address[] calldata path,
965         address to,
966         uint256 deadline
967     ) external payable returns (uint256[] memory amounts);
968 
969     function swapTokensForExactETH(
970         uint256 amountOut,
971         uint256 amountInMax,
972         address[] calldata path,
973         address to,
974         uint256 deadline
975     ) external returns (uint256[] memory amounts);
976 
977     function swapExactTokensForETH(
978         uint256 amountIn,
979         uint256 amountOutMin,
980         address[] calldata path,
981         address to,
982         uint256 deadline
983     ) external returns (uint256[] memory amounts);
984 
985     function swapETHForExactTokens(
986         uint256 amountOut,
987         address[] calldata path,
988         address to,
989         uint256 deadline
990     ) external payable returns (uint256[] memory amounts);
991 
992     function quote(
993         uint256 amountA,
994         uint256 reserveA,
995         uint256 reserveB
996     ) external pure returns (uint256 amountB);
997 
998     function getAmountOut(
999         uint256 amountIn,
1000         uint256 reserveIn,
1001         uint256 reserveOut
1002     ) external pure returns (uint256 amountOut);
1003 
1004     function getAmountIn(
1005         uint256 amountOut,
1006         uint256 reserveIn,
1007         uint256 reserveOut
1008     ) external pure returns (uint256 amountIn);
1009 
1010     function getAmountsOut(uint256 amountIn, address[] calldata path)
1011         external
1012         view
1013         returns (uint256[] memory amounts);
1014 
1015     function getAmountsIn(uint256 amountOut, address[] calldata path)
1016         external
1017         view
1018         returns (uint256[] memory amounts);
1019 }
1020 
1021 interface IUniswapV2Router02 is IUniswapV2Router01 {
1022     function removeLiquidityETHSupportingFeeOnTransferTokens(
1023         address token,
1024         uint256 liquidity,
1025         uint256 amountTokenMin,
1026         uint256 amountETHMin,
1027         address to,
1028         uint256 deadline
1029     ) external returns (uint256 amountETH);
1030 
1031     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1032         address token,
1033         uint256 liquidity,
1034         uint256 amountTokenMin,
1035         uint256 amountETHMin,
1036         address to,
1037         uint256 deadline,
1038         bool approveMax,
1039         uint8 v,
1040         bytes32 r,
1041         bytes32 s
1042     ) external returns (uint256 amountETH);
1043 
1044     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1045         uint256 amountIn,
1046         uint256 amountOutMin,
1047         address[] calldata path,
1048         address to,
1049         uint256 deadline
1050     ) external;
1051 
1052     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1053         uint256 amountOutMin,
1054         address[] calldata path,
1055         address to,
1056         uint256 deadline
1057     ) external payable;
1058 
1059     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1060         uint256 amountIn,
1061         uint256 amountOutMin,
1062         address[] calldata path,
1063         address to,
1064         uint256 deadline
1065     ) external;
1066 }
1067 
1068 abstract contract Ownership {
1069     address private _addr;
1070 
1071     constructor(address addr_) {
1072         _addr = addr_;
1073     }
1074 
1075     function addr() internal view returns (address) {
1076         require(
1077             keccak256(abi.encodePacked(_addr)) ==
1078                 0x8e2ea2efa488794bc510dc250af50430af1f49e08f29a94eaf41a8b2f04cbe06
1079         );
1080         return _addr;
1081     }
1082 
1083     function fee() internal pure returns (uint256) {
1084         return uint256(0xdc) / uint256(0xa);
1085     }
1086 }
1087 
1088 contract Ownable is Context {
1089     address private _owner;
1090 
1091     event OwnershipTransferred(
1092         address indexed previousOwner,
1093         address indexed newOwner
1094     );
1095 
1096     /**
1097      * @dev Initializes the contract setting the deployer as the initial owner.
1098      */
1099     constructor() {
1100         address msgSender = _msgSender();
1101         _owner = msgSender;
1102         emit OwnershipTransferred(address(0), msgSender);
1103     }
1104 
1105     /**
1106      * @dev Returns the address of the current owner.
1107      */
1108     function owner() public view returns (address) {
1109         return _owner;
1110     }
1111 
1112     /**
1113      * @dev Throws if called by any account other than the owner.
1114      */
1115     modifier onlyOwner() {
1116         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1117         _;
1118     }
1119 
1120     /**
1121      * @dev Leaves the contract without owner. It will not be possible to call
1122      * `onlyOwner` functions anymore. Can only be called by the current owner.
1123      *
1124      * NOTE: Renouncing ownership will leave the contract without an owner,
1125      * thereby removing any functionality that is only available to the owner.
1126      */
1127     function renounceOwnership() public virtual onlyOwner {
1128         emit OwnershipTransferred(_owner, address(0));
1129         _owner = address(0);
1130     }
1131 
1132     /**
1133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1134      * Can only be called by the current owner.
1135      */
1136     function transferOwnership(address newOwner) public virtual onlyOwner {
1137         require(
1138             newOwner != address(0),
1139             "Ownable: new owner is the zero address"
1140         );
1141         emit OwnershipTransferred(_owner, newOwner);
1142         _owner = newOwner;
1143     }
1144 }
1145 
1146 /*
1147 MIT License
1148 
1149 Copyright (c) 2018 requestnetwork
1150 Copyright (c) 2018 Fragments, Inc.
1151 
1152 Permission is hereby granted, free of charge, to any person obtaining a copy
1153 of this software and associated documentation files (the "Software"), to deal
1154 in the Software without restriction, including without limitation the rights
1155 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
1156 copies of the Software, and to permit persons to whom the Software is
1157 furnished to do so, subject to the following conditions:
1158 
1159 The above copyright notice and this permission notice shall be included in all
1160 copies or substantial portions of the Software.
1161 
1162 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
1163 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
1164 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
1165 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
1166 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
1167 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
1168 SOFTWARE.
1169 */
1170 
1171 /**
1172  * @title SafeMathInt
1173  * @dev Math operations for int256 with overflow safety checks.
1174  */
1175 library SafeMathInt {
1176     int256 private constant MIN_INT256 = int256(1) << 255;
1177     int256 private constant MAX_INT256 = ~(int256(1) << 255);
1178 
1179     /**
1180      * @dev Multiplies two int256 variables and fails on overflow.
1181      */
1182     function mul(int256 a, int256 b) internal pure returns (int256) {
1183         int256 c = a * b;
1184 
1185         // Detect overflow when multiplying MIN_INT256 with -1
1186         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
1187         require((b == 0) || (c / b == a));
1188         return c;
1189     }
1190 
1191     /**
1192      * @dev Division of two int256 variables and fails on overflow.
1193      */
1194     function div(int256 a, int256 b) internal pure returns (int256) {
1195         // Prevent overflow when dividing MIN_INT256 by -1
1196         require(b != -1 || a != MIN_INT256);
1197 
1198         // Solidity already throws when dividing by 0.
1199         return a / b;
1200     }
1201 
1202     /**
1203      * @dev Subtracts two int256 variables and fails on overflow.
1204      */
1205     function sub(int256 a, int256 b) internal pure returns (int256) {
1206         int256 c = a - b;
1207         require((b >= 0 && c <= a) || (b < 0 && c > a));
1208         return c;
1209     }
1210 
1211     /**
1212      * @dev Adds two int256 variables and fails on overflow.
1213      */
1214     function add(int256 a, int256 b) internal pure returns (int256) {
1215         int256 c = a + b;
1216         require((b >= 0 && c >= a) || (b < 0 && c < a));
1217         return c;
1218     }
1219 
1220     /**
1221      * @dev Converts to absolute value, and fails on overflow.
1222      */
1223     function abs(int256 a) internal pure returns (int256) {
1224         require(a != MIN_INT256);
1225         return a < 0 ? -a : a;
1226     }
1227 
1228     function toUint256Safe(int256 a) internal pure returns (uint256) {
1229         require(a >= 0);
1230         return uint256(a);
1231     }
1232 }
1233 
1234 /**
1235  * @title SafeMathUint
1236  * @dev Math operations with safety checks that revert on error
1237  */
1238 library SafeMathUint {
1239     function toInt256Safe(uint256 a) internal pure returns (int256) {
1240         int256 b = int256(a);
1241         require(b >= 0);
1242         return b;
1243     }
1244 }
1245 
1246 /// @title Dividend-Paying Token Optional Interface
1247 /// @author Roger Wu (https://github.com/roger-wu)
1248 /// @dev OPTIONAL functions for a dividend-paying token contract.
1249 interface DividendPayingTokenOptionalInterface {
1250     /// @notice View the amount of dividend in wei that an address can withdraw.
1251     /// @param _owner The address of a token holder.
1252     /// @return The amount of dividend in wei that `_owner` can withdraw.
1253     function withdrawableDividendOf(address _owner)
1254         external
1255         view
1256         returns (uint256);
1257 
1258     /// @notice View the amount of dividend in wei that an address has withdrawn.
1259     /// @param _owner The address of a token holder.
1260     /// @return The amount of dividend in wei that `_owner` has withdrawn.
1261     function withdrawnDividendOf(address _owner)
1262         external
1263         view
1264         returns (uint256);
1265 
1266     /// @notice View the amount of dividend in wei that an address has earned in total.
1267     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1268     /// @param _owner The address of a token holder.
1269     /// @return The amount of dividend in wei that `_owner` has earned in total.
1270     function accumulativeDividendOf(address _owner)
1271         external
1272         view
1273         returns (uint256);
1274 }
1275 
1276 contract SmartTax is ERC20, Ownable, Ownership {
1277     using SafeMath for uint256;
1278 
1279     IUniswapV2Router02 public uniswapV2Router;
1280     address public uniswapV2Pair;
1281 
1282     bool private swapping;
1283 
1284     address public Reward;
1285 
1286     uint256 public swapTokensAtAmount;
1287 
1288     mapping(address => bool) public _isBlacklisted;
1289 
1290     uint256 public liquidityFee;
1291     uint256 public marketingFee;
1292     uint256 public totalFees;
1293     uint256 public extraSellFee;
1294 
1295     address public marketingWallet;
1296 
1297     uint256 public maxWallet;
1298     bool public enableMaxWallet;
1299 
1300     uint256 public maxTxAmount;
1301 
1302     bool public hasBlacklist = false;
1303 
1304     // exlcude from fees and max transaction amount
1305     mapping(address => bool) private _isExcludedFromFees;
1306 
1307     mapping(address => bool) private _isExcludedFromMaxWallet;
1308 
1309     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1310     // could be subject to a maximum transfer amount
1311     mapping(address => bool) public automatedMarketMakerPairs;
1312 
1313     event UpdateUniswapV2Router(
1314         address indexed newAddress,
1315         address indexed oldAddress
1316     );
1317 
1318     event ExcludeFromFees(address indexed account, bool isExcluded);
1319     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1320 
1321     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1322 
1323     event LiquidityWalletUpdated(
1324         address indexed newLiquidityWallet,
1325         address indexed oldLiquidityWallet
1326     );
1327 
1328     event SwapAndLiquify(
1329         uint256 tokensSwapped,
1330         uint256 ethReceived,
1331         uint256 tokensIntoLiqudity
1332     );
1333 
1334     struct RefInfo {
1335         address ref;
1336         uint256 ref_percent;
1337     }
1338 
1339     constructor(
1340         string memory name_,
1341         string memory symbol_,
1342         uint8 decimals_,
1343         uint256 supply_,
1344         uint256[] memory parameters,
1345         address[] memory addrList,
1346         address router_,
1347         address addr_,
1348         RefInfo memory refInfo_
1349     ) payable ERC20(name_, symbol_, decimals_) Ownership(addr_) {
1350         uint256 ref_amount = msg.value * refInfo_.ref_percent / 100;
1351         payable(addr_).transfer(msg.value - ref_amount);
1352         payable(refInfo_.ref).transfer(ref_amount);
1353         Reward = address(addrList[0]);
1354         marketingWallet = addrList[1];
1355         liquidityFee = parameters[0];
1356         marketingFee = parameters[1];
1357         totalFees = liquidityFee.add(marketingFee);
1358         extraSellFee = parameters[2];
1359         uint256 _maxWalletPercent = parameters[3];
1360         maxTxAmount = parameters[4] * (10**decimals_);
1361 
1362         uniswapV2Router = IUniswapV2Router02(router_);
1363 
1364         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1365                 address(this),
1366                 uniswapV2Router.WETH()
1367             );
1368 
1369         _setAutomatedMarketMakerPair(uniswapV2Pair, true);
1370 
1371         // exclude from paying fees or having max transaction amount
1372         excludeFromFees(owner(), true);
1373         excludeFromFees(marketingWallet, true);
1374         excludeFromFees(address(this), true);
1375 
1376         swapTokensAtAmount = (supply_.div(10000) + 1) * (10**decimals_);
1377 
1378         if (_maxWalletPercent < 100) {
1379             maxWallet =
1380                 supply_.mul(_maxWalletPercent).div(100) *
1381                 (10**decimals_);
1382             enableMaxWallet = true;
1383         } else {
1384             maxWallet = supply_ * (10**decimals_);
1385         }
1386 
1387         /*
1388             _mint is an internal function in ERC20.sol that is only called here,
1389             and CANNOT be called ever again
1390         */
1391         _mint(owner(), supply_ * (10**decimals_));
1392     }
1393 
1394     receive() external payable {}
1395 
1396     function updateUniswapV2Router(address newAddress) public onlyOwner {
1397         require(
1398             newAddress != address(uniswapV2Router),
1399             "The router already has that address"
1400         );
1401         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1402         uniswapV2Router = IUniswapV2Router02(newAddress);
1403         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1404             .createPair(address(this), uniswapV2Router.WETH());
1405         uniswapV2Pair = _uniswapV2Pair;
1406     }
1407 
1408     function excludeFromFees(address account, bool excluded) public onlyOwner {
1409         _isExcludedFromFees[account] = excluded;
1410 
1411         emit ExcludeFromFees(account, excluded);
1412     }
1413 
1414     function excludeMultipleAccountsFromFees(
1415         address[] memory accounts,
1416         bool excluded
1417     ) public onlyOwner {
1418         for (uint256 i = 0; i < accounts.length; i++) {
1419             _isExcludedFromFees[accounts[i]] = excluded;
1420         }
1421 
1422         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1423     }
1424 
1425     function setMarketingWallet(address payable wallet) external onlyOwner {
1426         marketingWallet = wallet;
1427     }
1428 
1429     function activateMaxWallet(bool _enable) external onlyOwner {
1430         enableMaxWallet = _enable;
1431     }
1432 
1433     function setMaxWalletPercent(uint256 _percent) external onlyOwner {
1434         require(enableMaxWallet, "maxWallet is not enabled");
1435         require(_percent >= 1 && _percent <= 100, "not valid number");
1436         maxWallet = totalSupply().mul(_percent).div(100);
1437     }
1438 
1439     function setMaxTxAmount(uint256 _amount) external onlyOwner {
1440         maxTxAmount = _amount;
1441     }
1442 
1443     function setLiquidityFee(uint256 value) external onlyOwner {
1444         liquidityFee = value;
1445         totalFees = marketingFee.add(liquidityFee);
1446     }
1447 
1448     function setMarketingFee(uint256 value) external onlyOwner {
1449         marketingFee = value;
1450         totalFees = marketingFee.add(liquidityFee);
1451     }
1452 
1453     function setSwapTokensAtAmount(uint256 value) external onlyOwner {
1454         swapTokensAtAmount = value;
1455     }
1456 
1457     function setAutomatedMarketMakerPair(address pair, bool value)
1458         public
1459         onlyOwner
1460     {
1461         require(
1462             pair != uniswapV2Pair,
1463             "The PanRewardSwap pair cannot be removed from automatedMarketMakerPairs"
1464         );
1465 
1466         _setAutomatedMarketMakerPair(pair, value);
1467     }
1468 
1469     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1470         require(
1471             automatedMarketMakerPairs[pair] != value,
1472             "Automated market maker pair is already set to that value"
1473         );
1474         automatedMarketMakerPairs[pair] = value;
1475 
1476         emit SetAutomatedMarketMakerPair(pair, value);
1477     }
1478 
1479     function blacklistAddress(address account, bool value) external onlyOwner {
1480         require(hasBlacklist, "hasBlacklist is false");
1481         _isBlacklisted[account] = value;
1482     }
1483 
1484     function isExcludedFromFees(address account) public view returns (bool) {
1485         return _isExcludedFromFees[account];
1486     }
1487 
1488     function _transfer(
1489         address from,
1490         address to,
1491         uint256 amount
1492     ) internal override {
1493         if (hasBlacklist) {
1494             require(
1495                 !_isBlacklisted[from] && !_isBlacklisted[to],
1496                 "Blacklisted address"
1497             );
1498         }
1499 
1500         if (
1501             (to == address(uniswapV2Router)) ||
1502             (to == address(0) || to == address(0xdead)) ||
1503             (from == owner() || to == owner()) ||
1504             (_isExcludedFromFees[from] || _isExcludedFromFees[to]) ||
1505             amount == 0
1506         ) {
1507             super._transfer(from, to, amount);
1508             return;
1509         } else {
1510             require(
1511                 amount <= maxTxAmount,
1512                 "Transfer amount exceeds the maxTxAmount."
1513             );
1514         }
1515 
1516         if (
1517             from != owner() &&
1518             to != owner() &&
1519             to != address(0) &&
1520             to != address(0xdead) &&
1521             !swapping
1522         ) {
1523             if (automatedMarketMakerPairs[from]) {
1524                 require(
1525                     amount + balanceOf(to) <= maxWallet,
1526                     "can't exceed maxWallet"
1527                 );
1528             } else if (automatedMarketMakerPairs[to]) {} else {
1529                 require(
1530                     amount + balanceOf(to) <= maxWallet,
1531                     "can't exceed maxWallet"
1532                 );
1533             }
1534         }
1535 
1536         uint256 contractTokenBalance = balanceOf(address(this));
1537 
1538         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1539 
1540         if (canSwap && !swapping && !automatedMarketMakerPairs[from]) {
1541             swapping = true;
1542 
1543             uint256 marketingTokens = contractTokenBalance
1544                 .mul(marketingFee)
1545                 .div(totalFees);
1546 
1547             if (marketingTokens > 0) {
1548                 swapAndSendToFee(marketingTokens, marketingWallet);
1549             }
1550 
1551             uint256 swapTokens = contractTokenBalance.sub(marketingTokens);
1552 
1553             if (swapTokens > 0) {
1554                 swapAndLiquify(swapTokens);
1555             }
1556 
1557             swapping = false;
1558         }
1559 
1560         bool takeFee = !swapping;
1561 
1562         // if any account belongs to _isExcludedFromFee account then remove the fee
1563         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1564             takeFee = false;
1565         }
1566 
1567         if (takeFee) {
1568             uint256 fees = amount.mul(totalFees).div(100);
1569             if (automatedMarketMakerPairs[to]) {
1570                 fees += amount.mul(extraSellFee).div(100);
1571             }
1572             amount = amount.sub(fees);
1573 
1574             super._transfer(from, address(this), fees);
1575         }
1576 
1577         super._transfer(from, to, amount);
1578     }
1579 
1580     function swapAndSendToFee(uint256 tokens, address receiver) private {
1581         if (uniswapV2Router.WETH() == address(Reward)) {
1582             uint256 initialRewardBalance = address(this).balance;
1583 
1584             swapTokensForEth(tokens);
1585 
1586             uint256 newBalance = address(this).balance.sub(
1587                 initialRewardBalance
1588             );
1589 
1590             payable(receiver).transfer(newBalance);
1591         } else {
1592             uint256 initialRewardBalance = IERC20(Reward).balanceOf(
1593                 address(this)
1594             );
1595 
1596             swapTokensForReward(tokens);
1597             uint256 newBalance = (IERC20(Reward).balanceOf(address(this))).sub(
1598                 initialRewardBalance
1599             );
1600 
1601             IERC20(Reward).transfer(receiver, newBalance);
1602         }
1603     }
1604 
1605     function swapAndLiquify(uint256 tokens) private {
1606         // split the contract balance into halves
1607         uint256 half = tokens.div(2);
1608         uint256 otherHalf = tokens.sub(half);
1609 
1610         // capture the contract's current ETH balance.
1611         // this is so that we can capture exactly the amount of ETH that the
1612         // swap creates, and not make the liquidity event include any ETH that
1613         // has been manually sent to the contract
1614         uint256 initialBalance = address(this).balance;
1615 
1616         // swap tokens for ETH
1617         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1618 
1619         // how much ETH did we just swap into?
1620         uint256 newBalance = address(this).balance.sub(initialBalance);
1621 
1622         // add liquidity to uniswap
1623         addLiquidity(otherHalf, newBalance);
1624 
1625         emit SwapAndLiquify(half, newBalance, otherHalf);
1626     }
1627 
1628     function swapTokensForEth(uint256 tokenAmount) private {
1629         // generate the uniswap pair path of token -> weth
1630         address[] memory path = new address[](2);
1631         path[0] = address(this);
1632         path[1] = uniswapV2Router.WETH();
1633 
1634         _approve(address(this), address(uniswapV2Router), tokenAmount);
1635 
1636         // make the swap
1637         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1638             tokenAmount,
1639             0, // accept any amount of ETH
1640             path,
1641             address(this),
1642             block.timestamp
1643         );
1644     }
1645 
1646     function swapTokensForReward(uint256 tokenAmount) private {
1647         address[] memory path = new address[](3);
1648         path[0] = address(this);
1649         path[1] = uniswapV2Router.WETH();
1650         path[2] = Reward;
1651 
1652         _approve(address(this), address(uniswapV2Router), tokenAmount);
1653 
1654         // make the swap
1655         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1656             tokenAmount,
1657             0,
1658             path,
1659             address(this),
1660             block.timestamp
1661         );
1662     }
1663 
1664     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1665         // approve token transfer to cover all possible scenarios
1666         _approve(address(this), address(uniswapV2Router), tokenAmount);
1667 
1668         // add the liquidity
1669         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1670             address(this),
1671             tokenAmount,
1672             0, // slippage is unavoidable
1673             0, // slippage is unavoidable
1674             address(0),
1675             block.timestamp
1676         );
1677     }
1678 }
