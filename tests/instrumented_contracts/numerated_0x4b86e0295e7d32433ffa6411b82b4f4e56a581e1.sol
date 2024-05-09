1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IUniswapV2Factory {
6     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
7 
8     function feeTo() external view returns (address);
9     function feeToSetter() external view returns (address);
10     function migrator() external view returns (address);
11 
12     function getPair(address tokenA, address tokenB) external view returns (address pair);
13     function allPairs(uint) external view returns (address pair);
14     function allPairsLength() external view returns (uint);
15 
16     function createPair(address tokenA, address tokenB) external returns (address pair);
17 
18     function setFeeTo(address) external;
19     function setFeeToSetter(address) external;
20     function setMigrator(address) external;
21 }
22 
23 interface IUniswapV2Router01 {
24     function factory() external pure returns (address);
25     function WETH() external pure returns (address);
26 
27     function addLiquidity(
28         address tokenA,
29         address tokenB,
30         uint amountADesired,
31         uint amountBDesired,
32         uint amountAMin,
33         uint amountBMin,
34         address to,
35         uint deadline
36     ) external returns (uint amountA, uint amountB, uint liquidity);
37     function addLiquidityETH(
38         address token,
39         uint amountTokenDesired,
40         uint amountTokenMin,
41         uint amountETHMin,
42         address to,
43         uint deadline
44     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
45     function removeLiquidity(
46         address tokenA,
47         address tokenB,
48         uint liquidity,
49         uint amountAMin,
50         uint amountBMin,
51         address to,
52         uint deadline
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETH(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline
61     ) external returns (uint amountToken, uint amountETH);
62     function removeLiquidityWithPermit(
63         address tokenA,
64         address tokenB,
65         uint liquidity,
66         uint amountAMin,
67         uint amountBMin,
68         address to,
69         uint deadline,
70         bool approveMax, uint8 v, bytes32 r, bytes32 s
71     ) external returns (uint amountA, uint amountB);
72     function removeLiquidityETHWithPermit(
73         address token,
74         uint liquidity,
75         uint amountTokenMin,
76         uint amountETHMin,
77         address to,
78         uint deadline,
79         bool approveMax, uint8 v, bytes32 r, bytes32 s
80     ) external returns (uint amountToken, uint amountETH);
81     function swapExactTokensForTokens(
82         uint amountIn,
83         uint amountOutMin,
84         address[] calldata path,
85         address to,
86         uint deadline
87     ) external returns (uint[] memory amounts);
88     function swapTokensForExactTokens(
89         uint amountOut,
90         uint amountInMax,
91         address[] calldata path,
92         address to,
93         uint deadline
94     ) external returns (uint[] memory amounts);
95     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
96         external
97         payable
98         returns (uint[] memory amounts);
99     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
100         external
101         returns (uint[] memory amounts);
102     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
103         external
104         returns (uint[] memory amounts);
105     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
106         external
107         payable
108         returns (uint[] memory amounts);
109 
110     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
111     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
112     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
113     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
114     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
115 }
116 
117 interface IUniswapV2Router02 is IUniswapV2Router01 {
118     function removeLiquidityETHSupportingFeeOnTransferTokens(
119         address token,
120         uint liquidity,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external returns (uint amountETH);
126     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
127         address token,
128         uint liquidity,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline,
133         bool approveMax, uint8 v, bytes32 r, bytes32 s
134     ) external returns (uint amountETH);
135 
136     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143     function swapExactETHForTokensSupportingFeeOnTransferTokens(
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external payable;
149     function swapExactTokensForETHSupportingFeeOnTransferTokens(
150         uint amountIn,
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external;
156 }
157 
158 interface IUniswapV2Pair {
159     event Approval(address indexed owner, address indexed spender, uint value);
160     event Transfer(address indexed from, address indexed to, uint value);
161 
162     function name() external pure returns (string memory);
163     function symbol() external pure returns (string memory);
164     function decimals() external pure returns (uint8);
165     function totalSupply() external view returns (uint);
166     function balanceOf(address owner) external view returns (uint);
167     function allowance(address owner, address spender) external view returns (uint);
168 
169     function approve(address spender, uint value) external returns (bool);
170     function transfer(address to, uint value) external returns (bool);
171     function transferFrom(address from, address to, uint value) external returns (bool);
172 
173     function DOMAIN_SEPARATOR() external view returns (bytes32);
174     function PERMIT_TYPEHASH() external pure returns (bytes32);
175     function nonces(address owner) external view returns (uint);
176 
177     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
178 
179     event Mint(address indexed sender, uint amount0, uint amount1);
180     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
181     event Swap(
182         address indexed sender,
183         uint amount0In,
184         uint amount1In,
185         uint amount0Out,
186         uint amount1Out,
187         address indexed to
188     );
189     event Sync(uint112 reserve0, uint112 reserve1);
190 
191     function MINIMUM_LIQUIDITY() external pure returns (uint);
192     function factory() external view returns (address);
193     function token0() external view returns (address);
194     function token1() external view returns (address);
195     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
196     function price0CumulativeLast() external view returns (uint);
197     function price1CumulativeLast() external view returns (uint);
198     function kLast() external view returns (uint);
199 
200     function mint(address to) external returns (uint liquidity);
201     function burn(address to) external returns (uint amount0, uint amount1);
202     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
203     function skim(address to) external;
204     function sync() external;
205 
206     function initialize(address, address) external;
207 }
208 
209 abstract contract Context {
210     function _msgSender() internal view virtual returns (address payable) {
211         return payable(msg.sender);
212     }
213 
214     function _msgData() internal view virtual returns (bytes memory) {
215         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
216         return msg.data;
217     }
218 }
219 
220 contract Owned is Context {
221     address private _owner;
222     address private _pendingOwner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     /**
227      * @dev Initializes the contract setting the deployer as the initial owner.
228      */
229     constructor () {
230         address msgSender = _msgSender();
231         _owner = msgSender;
232         emit OwnershipTransferred(address(0), msgSender);
233     }
234 
235     /**
236      * @dev Returns the address of the current owner.
237      */
238     function owner() public view returns (address) {
239         return _owner;
240     }
241 
242     /**
243      * @dev Throws if called by any account other than the owner.
244      */
245     modifier ownerOnly {
246         require(_owner == _msgSender(), "Owner only");
247         _;
248     }
249     modifier pendingOnly {
250         require (_pendingOwner == msg.sender, "cannot claim");
251         _;
252     }
253 
254     function pendingOwner() public view returns (address) {
255         return _pendingOwner;
256     }
257 
258     function renounceOwnership() public virtual ownerOnly {
259         emit OwnershipTransferred(_owner, address(0));
260         _owner = address(0);
261     }
262 
263     function transferOwnership(address newOwner) public ownerOnly {
264         require(newOwner != address(0), "Ownable: new owner is the zero address");
265         _pendingOwner = newOwner;
266     }
267 
268     function cancelTransfer() public ownerOnly {
269         require(_pendingOwner != address(0), "no pending owner");
270         _pendingOwner = address(0);
271     }
272 
273     function claimOwnership() public pendingOnly {
274         _pendingOwner = address(0);
275         emit OwnershipTransferred(_owner, _msgSender());
276         _owner = _msgSender();
277     }
278 }
279 
280 interface IERC20 {
281     /**
282      * @dev Returns the amount of tokens in existence.
283      */
284     function totalSupply() external view returns (uint256);
285 
286     /**
287      * @dev Returns the amount of tokens owned by `account`.
288      */
289     function balanceOf(address account) external view returns (uint256);
290 
291     /**
292      * @dev Moves `amount` tokens from the caller's account to `recipient`.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * Emits a {Transfer} event.
297      */
298     function transfer(address recipient, uint256 amount) external returns (bool);
299 
300     /**
301      * @dev Returns the remaining number of tokens that `spender` will be
302      * allowed to spend on behalf of `owner` through {transferFrom}. This is
303      * zero by default.
304      *
305      * This value changes when {approve} or {transferFrom} are called.
306      */
307     function allowance(address owner, address spender) external view returns (uint256);
308 
309     /**
310      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
311      *
312      * Returns a boolean value indicating whether the operation succeeded.
313      *
314      * IMPORTANT: Beware that changing an allowance with this method brings the risk
315      * that someone may use both the old and the new allowance by unfortunate
316      * transaction ordering. One possible solution to mitigate this race
317      * condition is to first reduce the spender's allowance to 0 and set the
318      * desired value afterwards:
319      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
320      *
321      * Emits an {Approval} event.
322      */
323     function approve(address spender, uint256 amount) external returns (bool);
324 
325     /**
326      * @dev Moves `amount` tokens from `sender` to `recipient` using the
327      * allowance mechanism. `amount` is then deducted from the caller's
328      * allowance.
329      *
330      * Returns a boolean value indicating whether the operation succeeded.
331      *
332      * Emits a {Transfer} event.
333      */
334     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
335 
336     /**
337      * @dev Emitted when `value` tokens are moved from one account (`from`) to
338      * another (`to`).
339      *
340      * Note that `value` may be zero.
341      */
342     event Transfer(address indexed from, address indexed to, uint256 value);
343 
344     /**
345      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
346      * a call to {approve}. `value` is the new allowance.
347      */
348     event Approval(address indexed owner, address indexed spender, uint256 value);
349 }
350 
351 contract Pool {}
352 
353 library EnumerableSet {
354     // To implement this library for multiple types with as little code
355     // repetition as possible, we write it in terms of a generic Set type with
356     // bytes32 values.
357     // The Set implementation uses private functions, and user-facing
358     // implementations (such as AddressSet) are just wrappers around the
359     // underlying Set.
360     // This means that we can only create new EnumerableSets for types that fit
361     // in bytes32.
362 
363     struct Set {
364         // Storage of set values
365         bytes32[] _values;
366 
367         // Position of the value in the `values` array, plus 1 because index 0
368         // means a value is not in the set.
369         mapping (bytes32 => uint256) _indexes;
370     }
371 
372     /**
373      * @dev Add a value to a set. O(1).
374      *
375      * Returns true if the value was added to the set, that is if it was not
376      * already present.
377      */
378     function _add(Set storage set, bytes32 value) private returns (bool) {
379         if (!_contains(set, value)) {
380             set._values.push(value);
381             // The value is stored at length-1, but we add 1 to all indexes
382             // and use 0 as a sentinel value
383             set._indexes[value] = set._values.length;
384             return true;
385         } else {
386             return false;
387         }
388     }
389 
390     /**
391      * @dev Removes a value from a set. O(1).
392      *
393      * Returns true if the value was removed from the set, that is if it was
394      * present.
395      */
396     function _remove(Set storage set, bytes32 value) private returns (bool) {
397         // We read and store the value's index to prevent multiple reads from the same storage slot
398         uint256 valueIndex = set._indexes[value];
399 
400         if (valueIndex != 0) { // Equivalent to contains(set, value)
401             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
402             // the array, and then remove the last element (sometimes called as 'swap and pop').
403             // This modifies the order of the array, as noted in {at}.
404 
405             uint256 toDeleteIndex = valueIndex - 1;
406             uint256 lastIndex = set._values.length - 1;
407 
408             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
409             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
410 
411             bytes32 lastvalue = set._values[lastIndex];
412 
413             // Move the last value to the index where the value to delete is
414             set._values[toDeleteIndex] = lastvalue;
415             // Update the index for the moved value
416             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
417 
418             // Delete the slot where the moved value was stored
419             set._values.pop();
420 
421             // Delete the index for the deleted slot
422             delete set._indexes[value];
423 
424             return true;
425         } else {
426             return false;
427         }
428     }
429 
430     /**
431      * @dev Returns true if the value is in the set. O(1).
432      */
433     function _contains(Set storage set, bytes32 value) private view returns (bool) {
434         return set._indexes[value] != 0;
435     }
436 
437     /**
438      * @dev Returns the number of values on the set. O(1).
439      */
440     function _length(Set storage set) private view returns (uint256) {
441         return set._values.length;
442     }
443 
444    /**
445     * @dev Returns the value stored at position `index` in the set. O(1).
446     *
447     * Note that there are no guarantees on the ordering of values inside the
448     * array, and it may change when more values are added or removed.
449     *
450     * Requirements:
451     *
452     * - `index` must be strictly less than {length}.
453     */
454     function _at(Set storage set, uint256 index) private view returns (bytes32) {
455         require(set._values.length > index, "EnumerableSet: index out of bounds");
456         return set._values[index];
457     }
458 
459     // Bytes32Set
460 
461     struct Bytes32Set {
462         Set _inner;
463     }
464 
465     /**
466      * @dev Add a value to a set. O(1).
467      *
468      * Returns true if the value was added to the set, that is if it was not
469      * already present.
470      */
471     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
472         return _add(set._inner, value);
473     }
474 
475     /**
476      * @dev Removes a value from a set. O(1).
477      *
478      * Returns true if the value was removed from the set, that is if it was
479      * present.
480      */
481     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
482         return _remove(set._inner, value);
483     }
484 
485     /**
486      * @dev Returns true if the value is in the set. O(1).
487      */
488     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
489         return _contains(set._inner, value);
490     }
491 
492     /**
493      * @dev Returns the number of values in the set. O(1).
494      */
495     function length(Bytes32Set storage set) internal view returns (uint256) {
496         return _length(set._inner);
497     }
498 
499    /**
500     * @dev Returns the value stored at position `index` in the set. O(1).
501     *
502     * Note that there are no guarantees on the ordering of values inside the
503     * array, and it may change when more values are added or removed.
504     *
505     * Requirements:
506     *
507     * - `index` must be strictly less than {length}.
508     */
509     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
510         return _at(set._inner, index);
511     }
512 
513     // AddressSet
514 
515     struct AddressSet {
516         Set _inner;
517     }
518 
519     /**
520      * @dev Add a value to a set. O(1).
521      *
522      * Returns true if the value was added to the set, that is if it was not
523      * already present.
524      */
525     function add(AddressSet storage set, address value) internal returns (bool) {
526         return _add(set._inner, bytes32(uint256(uint160(value))));
527     }
528 
529     /**
530      * @dev Removes a value from a set. O(1).
531      *
532      * Returns true if the value was removed from the set, that is if it was
533      * present.
534      */
535     function remove(AddressSet storage set, address value) internal returns (bool) {
536         return _remove(set._inner, bytes32(uint256(uint160(value))));
537     }
538 
539     /**
540      * @dev Returns true if the value is in the set. O(1).
541      */
542     function contains(AddressSet storage set, address value) internal view returns (bool) {
543         return _contains(set._inner, bytes32(uint256(uint160(value))));
544     }
545 
546     /**
547      * @dev Returns the number of values in the set. O(1).
548      */
549     function length(AddressSet storage set) internal view returns (uint256) {
550         return _length(set._inner);
551     }
552 
553    /**
554     * @dev Returns the value stored at position `index` in the set. O(1).
555     *
556     * Note that there are no guarantees on the ordering of values inside the
557     * array, and it may change when more values are added or removed.
558     *
559     * Requirements:
560     *
561     * - `index` must be strictly less than {length}.
562     */
563     function at(AddressSet storage set, uint256 index) internal view returns (address) {
564         return address(uint160(uint256(_at(set._inner, index))));
565     }
566 
567 
568     // UintSet
569 
570     struct UintSet {
571         Set _inner;
572     }
573 
574     /**
575      * @dev Add a value to a set. O(1).
576      *
577      * Returns true if the value was added to the set, that is if it was not
578      * already present.
579      */
580     function add(UintSet storage set, uint256 value) internal returns (bool) {
581         return _add(set._inner, bytes32(value));
582     }
583 
584     /**
585      * @dev Removes a value from a set. O(1).
586      *
587      * Returns true if the value was removed from the set, that is if it was
588      * present.
589      */
590     function remove(UintSet storage set, uint256 value) internal returns (bool) {
591         return _remove(set._inner, bytes32(value));
592     }
593 
594     /**
595      * @dev Returns true if the value is in the set. O(1).
596      */
597     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
598         return _contains(set._inner, bytes32(value));
599     }
600 
601     /**
602      * @dev Returns the number of values on the set. O(1).
603      */
604     function length(UintSet storage set) internal view returns (uint256) {
605         return _length(set._inner);
606     }
607 
608    /**
609     * @dev Returns the value stored at position `index` in the set. O(1).
610     *
611     * Note that there are no guarantees on the ordering of values inside the
612     * array, and it may change when more values are added or removed.
613     *
614     * Requirements:
615     *
616     * - `index` must be strictly less than {length}.
617     */
618     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
619         return uint256(_at(set._inner, index));
620     }
621 }
622 
623 contract Storage {
624 
625     struct Addresses {
626         address pool;
627         address router;
628         address pair;
629         address protocol;
630         address dogecity;
631         address prizePool;
632         address buyBonusPool;
633         address presale;
634         address rng;
635         address farm;
636     }
637 
638     struct Balance {
639         uint256 tokenSupply;
640         uint256 networkSupply;
641         uint256 targetSupply;
642         uint256 pairSupply;
643         uint256 lpSupply;
644         uint256 fees;
645         uint256 burned;
646     }
647 
648     struct Account {
649         bool feeless;
650         bool transferPair;
651         bool excluded;
652         uint256 lastDogeIt;
653         uint256 tTotal;
654         uint256 rTotal;
655         uint256 lastShill;
656         uint256 communityPoints;
657         uint256 lastAward;
658     }
659 
660     struct Divisors {
661         uint8 buy;
662         uint8 sell;
663         // multiplied by 10000
664         uint8 dogecity;
665         uint8 bonus;
666         uint8 tokenLPBurn;
667         uint8 inflate;
668         uint8 buyCounter;
669         uint8 tx;
670         uint8 dogeitpayout;
671         uint256 dogeify;
672     }
673 
674     struct S {
675         bool initialized;
676         bool paused;
677         uint8 decimals;
678         uint8 odds;
679         Addresses addresses;
680         Balance balances;
681         Divisors divisors;
682         uint256 random;
683         uint256 buyFee;
684         uint256 sellFee;
685         uint256 minBuyForBonus;
686         uint256 buys;
687         uint256 sells;
688         uint256 lastAttack;
689         uint256 attackCooldown;
690         mapping(address => Account) accounts;
691         mapping(address => mapping(address => uint256)) allowances;
692 
693         address[] entries;
694         string symbol;
695         string name;
696         EnumerableSet.AddressSet excludedAccounts;
697 
698     }
699 
700 }
701 
702 contract State {
703     Storage.S state;
704     TState lastTState;
705 
706     enum TxType { FromExcluded, ToExcluded, BothExcluded, Standard }
707     enum TState { Buy, Sell, Normal }
708 }
709 
710 contract Getters is State {
711 
712     function canIDogeIt() public view returns(bool) {
713         return state.accounts[msg.sender].lastDogeIt + state.divisors.dogeify < block.timestamp;
714     }
715 
716     function isMinBuyForBonus(uint256 amount) public view returns(bool) {
717         return amount > state.minBuyForBonus * (10 ** state.decimals);
718     }
719 
720     function isFeelessTx(address sender, address recipient) public view returns(bool) {
721         if(sender == state.addresses.presale) {
722             return true;
723         }
724         return state.accounts[sender].feeless || state.accounts[recipient].feeless;
725     }
726 
727     function getAccount(address account) public view returns(Storage.Account memory) {
728         return state.accounts[account];
729     }
730 
731     function getDivisors() external view returns(Storage.Divisors memory) {
732         return state.divisors;
733     }
734 
735     function getBurned() external view returns(uint256) {
736         return state.balances.burned;
737     }
738 
739     function getFees() external view returns(uint256) {
740         return state.balances.fees;
741     }
742 
743     function getExcluded(address account) public view returns(bool) {
744         return state.accounts[account].excluded;
745     }
746 
747     function getCurrentLPBal() public view returns(uint256) {
748         return IERC20(state.addresses.pool).totalSupply();
749     }
750 
751     function getLPBalanceOf(address account) external view returns(uint256) {
752         return IERC20(state.addresses.pool).balanceOf(account);
753     }
754 
755     function getFeeless(address account) external view returns (bool) {
756         return state.accounts[account].feeless;
757     }
758 
759     function getTState(address sender, address recipient, uint256 lpAmount) public view returns(TState t) {
760         if(state.accounts[sender].transferPair) {
761             if(state.balances.lpSupply != lpAmount) { // withdraw vs buy
762                 t = TState.Normal;
763             } else {
764                 t = TState.Buy;
765             }
766         } else if(state.accounts[recipient].transferPair) {
767             t = TState.Sell;
768         } else {
769             t = TState.Normal;
770         }
771         return t;
772     }
773 
774     function getRouter() external view returns(address) {
775         return state.addresses.router;
776     }
777 
778     function getPair() external view returns(address) {
779         return state.addresses.pair;
780     }
781 
782     function getPool() external view returns(address) {
783         return state.addresses.pool;
784     }
785 
786     function getCirculatingSupply() public view returns(uint256, uint256) {
787         uint256 rSupply = state.balances.networkSupply;
788         uint256 tSupply = state.balances.tokenSupply;
789         for (uint256 i = 0; i < EnumerableSet.length(state.excludedAccounts); i++) {
790             address account = EnumerableSet.at(state.excludedAccounts, i);
791             uint256 rBalance = state.accounts[account].rTotal;
792             uint256 tBalance = state.accounts[account].tTotal;
793             if (rBalance > rSupply || tBalance > tSupply) return (state.balances.networkSupply, state.balances.tokenSupply);
794             rSupply -= rBalance;
795             tSupply -= tBalance;
796         }
797         if (rSupply < state.balances.networkSupply / state.balances.tokenSupply) return (state.balances.networkSupply, state.balances.tokenSupply);
798         return (rSupply, tSupply);
799     }
800 
801     function getTxType(address sender, address recipient) public view returns(TxType t) {
802         bool isSenderExcluded = state.accounts[sender].excluded;
803         bool isRecipientExcluded = state.accounts[recipient].excluded;
804         if (isSenderExcluded && !isRecipientExcluded) {
805             t = TxType.FromExcluded;
806         } else if (!isSenderExcluded && isRecipientExcluded) {
807             t = TxType.ToExcluded;
808         } else if (!isSenderExcluded && !isRecipientExcluded) {
809             t = TxType.Standard;
810         } else if (isSenderExcluded && isRecipientExcluded) {
811             t = TxType.BothExcluded;
812         } else {
813             t = TxType.Standard;
814         }
815     }
816 
817     function getFee(uint256 amount, uint256 divisor) public pure returns (uint256) {
818         return amount / divisor;
819     }
820 
821     function getPrizePoolAddress() public view returns(address) {
822         return state.addresses.prizePool;
823     }
824 
825     function getPrizePoolAmount() public view returns(uint256) {
826         return state.accounts[getPrizePoolAddress()].rTotal / ratio();
827     }
828 
829     function getBuyPoolAmount() public view returns(uint256) {
830         return state.accounts[getBuyBonusPoolAddress()].rTotal / ratio();
831     }
832 
833     function getBuyBonusPoolAddress() public view returns(address) {
834         return state.addresses.buyBonusPool;
835     }
836 
837     function getAmountForMinBuyTax() public view returns(uint256) {
838         return (state.balances.tokenSupply / 100);
839     }
840 
841     function getBuyTax(uint256 amount) public view returns(uint256) {
842         uint256 _ratio = amount * 100000 / state.balances.tokenSupply;
843         if(_ratio < 1) { // .001%
844             return state.divisors.buy; // charges whatever max buy fee is at, to discourage gaming the prizepool.
845         } else if (_ratio >= 1000) { // 1%
846             return state.divisors.buy * 5; // charges 1/5th of buy fee, from default is 1%
847         } else if (_ratio >= 10 && _ratio < 100){
848             return state.divisors.buy * 2; // and so on.
849         } else if (_ratio >= 100 && _ratio < 500) {
850             return state.divisors.buy * 3;
851         } else if (_ratio >= 500 && _ratio < 1000) {
852             return state.divisors.buy * 4;
853         } else { // shouldn't hit this
854             return state.divisors.buy;
855         }
856     }
857 
858     function getTimeTillNextAttack() public view returns(uint256) {
859         uint256 time = (state.lastAttack + state.attackCooldown);
860         return block.timestamp > time ? block.timestamp - time : 0;
861     }
862 
863     function getMaxBetAmount() public view returns(uint256) {
864         return state.accounts[state.addresses.buyBonusPool].tTotal / state.divisors.dogeitpayout;
865     }
866 
867     function getLastTState() public view returns(TState) {
868         return lastTState;
869     }
870 
871     function getLevel(address account) public view returns(uint256 level) {
872         level = state.accounts[account].communityPoints % 1000;
873         return level == 0 ? 1 : level;
874     }
875 
876     function getXP(address account) public view returns(uint256) {
877         return state.accounts[account].communityPoints;
878     }
879 
880     function getBuyAfterSellBonus(uint256 amount) public view returns(uint256 bonus) {
881         uint256 total = state.accounts[state.addresses.buyBonusPool].tTotal;
882         if(amount >= total / 100) { // 1% of the pool
883             bonus = total / state.divisors.bonus;
884         } else if(amount >= total / 200) { // .5% of the pool
885             bonus = total / (state.divisors.bonus * 2);
886         } else if(amount >= total / 500) {
887             bonus = total / (state.divisors.bonus * 3);
888         } else if(amount >= total / 1000) {
889             bonus = total / (state.divisors.bonus * 4);
890         } else {
891             bonus = total / (state.divisors.bonus * 5);
892         }
893     }
894 
895     function getBuyAfterBuyBonus() public view returns(uint256 bonus) {
896         bonus = state.accounts[state.addresses.buyBonusPool].tTotal / 500;
897     }
898 
899     function getBuyBonus(uint256 amount) public view returns(uint256) {
900         uint256 bonus;
901         if(lastTState == TState.Sell && amount > state.minBuyForBonus) {
902             bonus = getBuyAfterSellBonus(amount);
903         } else if(lastTState == TState.Buy && amount > state.minBuyForBonus) {
904             bonus = getBuyAfterBuyBonus();
905         } else {
906             bonus = 0;
907         }
908         return bonus > state.accounts[state.addresses.buyBonusPool].tTotal ? 0 : bonus;
909     }
910 
911     function ratio() public view returns(uint256) {
912         return state.balances.networkSupply / state.balances.tokenSupply;
913     }
914 
915 }
916 
917 interface IDogira {
918     function setRandomSeed(uint256 amount) external;
919 }
920 
921 contract Dogira is IDogira, IERC20, Getters, Owned {
922 
923     struct TxValue {
924         uint256 amount;
925         uint256 transferAmount;
926         uint256 fee;
927         uint256 buyFee;
928         uint256 sellFee;
929         uint256 buyBonus;
930         uint256 operationalFee;
931     }
932     event BonusAwarded(address account, uint256 amount);
933     event Kek(address account, uint256 amount);
934     event Doge(address account, uint256 amount);
935     event Winner(address account, uint256 amount);
936     event Smashed(uint256 amount);
937     event Atomacized(uint256 amount);
938     event Blazed(uint256 amount);
939     mapping(address => bool) admins;
940 
941     event FarmAdded(address farm);
942     event XPAdded(address awardee, uint256 points);
943     event Hooray(address awardee, uint256 points);
944     event TransferredToFarm(uint256 amount);
945 
946     uint256 timeLock;
947     uint256 dogeCityInitial;
948     uint256 public lastTeamSell;
949     uint256 levelCap;
950     bool rngSet;
951     bool presaleSet;
952 
953     modifier onlyAdminOrOwner {
954         require(admins[msg.sender] || msg.sender == owner(), "invalid caller");
955         _;
956     }
957 
958     constructor() {
959         initialize();
960     }
961 
962     uint256 constant private TOKEN_SUPPLY = 100_000_000;
963 
964     function name() public view returns(string memory) {
965         return state.name;
966     }
967 
968     function decimals() public view returns(uint8) {
969         return state.decimals;
970     }
971 
972     function symbol() public view returns (string memory) {
973         return state.symbol;
974     }
975 
976     function initialize() public {
977         require(!state.initialized, "Contract instance has already been initialized");
978         state.initialized = true;
979         state.decimals = 18;
980         state.symbol = "DOGIRA";
981         state.name = "dogira.lol || dogira.eth.link";
982         state.balances.tokenSupply = TOKEN_SUPPLY * (10 ** state.decimals);
983         state.balances.networkSupply = (~uint256(0) - (~uint256(0) % TOKEN_SUPPLY));
984         state.divisors.buy = 20; // 5% max - 1% depending on buy size.
985         state.divisors.sell = 20; // 5%
986         state.divisors.bonus = 50;
987         state.divisors.dogecity = 100;
988         state.divisors.inflate = 50;
989         state.divisors.tokenLPBurn = 50;
990         state.divisors.tx = 100;
991         state.divisors.dogeitpayout = 100;
992         state.divisors.dogeify = 1 hours; // 3600 seconds
993         state.divisors.buyCounter = 10;
994         state.odds = 4; // 1 / 4
995         state.minBuyForBonus = 35000e18;
996         state.addresses.prizePool = address(new Pool());
997         state.addresses.buyBonusPool = address(new Pool());
998         state.addresses.router = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
999         state.addresses.dogecity = address(0xfEDD9544b47a6D4A1967D385575866BD6f7A2b37);
1000         state.addresses.pair = IUniswapV2Router02(state.addresses.router).WETH();
1001         state.addresses.pool =
1002             IUniswapV2Factory(IUniswapV2Router02(state.addresses.router).factory()).createPair(address(this), state.addresses.pair);
1003         state.accounts[address(0)].feeless = true;
1004         state.accounts[msg.sender].feeless = true;
1005         //state.accounts[state.addresses.pool].feeless = true;
1006         state.accounts[state.addresses.pool].transferPair = true;
1007         uint256 locked = state.balances.networkSupply / 5; // 20%
1008         uint256 amount = state.balances.networkSupply - locked;
1009         state.accounts[msg.sender].rTotal = amount; // 80%
1010         dogeCityInitial = locked - (locked / 4);
1011         state.accounts[state.addresses.dogecity].feeless = true;
1012         state.accounts[state.addresses.dogecity].rTotal = dogeCityInitial; // 15%
1013         state.accounts[state.addresses.buyBonusPool].rTotal = locked / 4; // 5%
1014         state.accounts[state.addresses.buyBonusPool].tTotal = state.balances.tokenSupply / 20; // 5%
1015         state.paused = true;
1016         state.attackCooldown = 10 minutes;
1017         levelCap = 10;
1018         timeLock = block.timestamp + 3 days;
1019 
1020     }
1021 
1022     function allowance(address owner, address spender) public view override returns (uint256) {
1023         return state.allowances[owner][spender];
1024     }
1025 
1026     function balanceOf(address account) public view override returns (uint256) {
1027         return getExcluded(account) ? state.accounts[account].tTotal : state.accounts[account].rTotal / ratio();
1028     }
1029 
1030     function approve(address spender, uint256 amount) public override returns (bool) {
1031         _approve(_msgSender(), spender, amount);
1032         return true;
1033     }
1034 
1035     function _approve(address owner, address spender, uint256 amount) private {
1036         require(owner != address(0), "ERC20: approve from the zero address");
1037         require(spender != address(0), "ERC20: approve to the zero address");
1038 
1039         state.allowances[owner][spender] = amount;
1040         emit Approval(owner, spender, amount);
1041     }
1042 
1043     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1044         _approve(_msgSender(), spender, state.allowances[_msgSender()][spender] + addedValue);
1045         return true;
1046     }
1047 
1048     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1049         _approve(_msgSender(), spender, state.allowances[_msgSender()][spender] - (subtractedValue));
1050         return true;
1051     }
1052 
1053     function totalSupply() public view override returns (uint256) {
1054         return state.balances.tokenSupply;
1055     }
1056 
1057     function transfer(address recipient, uint256 amount) public override returns (bool) {
1058         _transfer(msg.sender, recipient, amount);
1059         return true;
1060     }
1061 
1062     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1063         _transfer(sender, recipient, amount);
1064         _approve(sender, _msgSender(), state.allowances[sender][_msgSender()] - amount);
1065         return true;
1066     }
1067 
1068     function _transfer(address sender, address recipient, uint256 amount) internal returns(bool) {
1069         require(sender != address(0), "ERC20: transfer from the zero address");
1070         require(recipient != address(0), "ERC20: transfer to the zero address");
1071         require(amount > 0, "Transfer amount must be greater than zero");
1072         if(sender == state.addresses.pool) { // for presales
1073             require(state.paused == false, "Transfers are paused");
1074         }
1075         // removed setter for dogecity to prevent changing the address and making this branch useless.
1076         if(sender == state.addresses.dogecity) {
1077             require(amount <= dogeCityInitial / 20, "too much"); // 5% per day
1078             require(lastTeamSell + 1 days < block.timestamp, "too soon");
1079             require(recipient == state.addresses.pool, "can only sell to uniswap pool");
1080             lastTeamSell = block.timestamp;
1081         }
1082         bool noFee = isFeelessTx(sender, recipient);
1083         uint256 rate = ratio();
1084         uint256 lpAmount = getCurrentLPBal();
1085         (TxValue memory t, TState ts, TxType txType) = tValues(sender, recipient, amount, noFee, lpAmount);
1086         state.balances.lpSupply = lpAmount;
1087         handleTRV(recipient, rate, ts, t);
1088         rTransfer(sender, recipient, rate, t, txType);
1089         state.balances.fees += t.fee;
1090         state.balances.networkSupply -= (t.fee * rate);
1091         lastTState = ts;
1092         emit Transfer(msg.sender, recipient, t.transferAmount);
1093         return true;
1094     }
1095 
1096     function transferToFarm(uint256 amount) external ownerOnly {
1097         require(timeLock < block.timestamp, "too soon");
1098         uint256 r = amount * ratio();
1099         state.accounts[state.addresses.dogecity].rTotal -= r;
1100         state.accounts[state.addresses.farm].rTotal += r;
1101         emit TransferredToFarm(amount);
1102     }
1103 
1104     function rTransfer(address sender, address recipient, uint256 rate, TxValue memory t, TxType txType) internal {
1105         if (txType == TxType.ToExcluded) {
1106             state.accounts[sender].rTotal         -= t.amount * rate;
1107             state.accounts[recipient].tTotal      += (t.transferAmount);
1108             state.accounts[recipient].rTotal      += t.transferAmount * rate;
1109         } else if (txType == TxType.FromExcluded) {
1110             state.accounts[sender].tTotal         -= t.amount;
1111             state.accounts[sender].rTotal         -= t.amount * rate;
1112             state.accounts[recipient].rTotal      += t.transferAmount * rate;
1113         } else if (txType == TxType.BothExcluded) {
1114             state.accounts[sender].tTotal         -= t.amount;
1115             state.accounts[sender].rTotal         -= (t.amount * rate);
1116             state.accounts[recipient].tTotal      += t.transferAmount;
1117             state.accounts[recipient].rTotal      += (t.transferAmount * rate);
1118         } else {
1119             state.accounts[sender].rTotal         -= (t.amount * rate);
1120             state.accounts[recipient].rTotal      += (t.transferAmount * rate);
1121         }
1122     }
1123 
1124     // burn supply, not negative rebase
1125     function verysmashed() external  {
1126         require(!state.paused, "still paused");
1127         require(state.lastAttack + state.attackCooldown < block.timestamp, "Dogira coolingdown");
1128         uint256 rLp = state.accounts[state.addresses.pool].rTotal;
1129         uint256 amountToDeflate = (rLp / (state.divisors.tokenLPBurn));
1130         uint256 burned = amountToDeflate / ratio();
1131         state.accounts[state.addresses.pool].rTotal -= amountToDeflate;
1132         state.accounts[address(0)].rTotal += amountToDeflate;
1133         state.accounts[address(0)].tTotal += burned;
1134         state.balances.burned += burned;
1135         state.lastAttack = block.timestamp;
1136         syncPool();
1137         emit Smashed(burned);
1138     }
1139 
1140     // positive rebase
1141     function dogebreath() external {
1142         require(!state.paused, "still paused");
1143         require(state.lastAttack + state.attackCooldown < block.timestamp, "Dogira coolingdown");
1144         uint256 rate = ratio();
1145         uint256 target = state.balances.burned == 0 ? state.balances.tokenSupply : state.balances.burned;
1146         uint256 amountToInflate = target / state.divisors.inflate;
1147         if(state.balances.burned > amountToInflate) {
1148             state.balances.burned -= amountToInflate;
1149             state.accounts[address(0)].rTotal -= amountToInflate * rate;
1150             state.accounts[address(0)].tTotal -= amountToInflate;
1151         }
1152         // positive rebase
1153         state.balances.networkSupply -= amountToInflate * rate;
1154         state.lastAttack = block.timestamp;
1155         syncPool();
1156         emit Atomacized(amountToInflate);
1157     }
1158 
1159     // disperse amount to all holders
1160     function wow(uint256 amount) external {
1161         address sender = msg.sender;
1162         uint256 rate = ratio();
1163         require(!getExcluded(sender), "Excluded addresses can't call this function");
1164         require(amount * rate < state.accounts[sender].rTotal, "too much");
1165         state.accounts[sender].rTotal -= (amount * rate);
1166         state.balances.networkSupply -= amount * rate;
1167         state.balances.fees += amount;
1168     }
1169 
1170     // award community members from the treasury
1171     function muchSupport(address awardee, uint256 multiplier) external onlyAdminOrOwner {
1172         uint256 n = block.timestamp;
1173         require(!state.paused, "still paused");
1174         require(state.accounts[awardee].lastShill + 1 days < n, "nice shill but need to wait");
1175         require(!getExcluded(awardee), "excluded addresses can't be awarded");
1176         require(multiplier <= 100 && multiplier > 0, "can't be more than .1% of dogecity reward");
1177         uint256 level = getLevel(awardee);
1178         if(level > levelCap) {
1179             level = levelCap; // capped at 10
1180         } else if (level <= 0) {
1181             level = 1;
1182         }
1183         uint256 p = ((state.accounts[state.addresses.dogecity].rTotal / 100000) * multiplier) * level; // .001% * m of dogecity * level
1184         state.accounts[state.addresses.dogecity].rTotal -= p;
1185         state.accounts[awardee].rTotal += p;
1186         state.accounts[awardee].lastShill = block.timestamp;
1187         state.accounts[awardee].communityPoints += multiplier;
1188         emit Hooray(awardee, p);
1189     }
1190 
1191 
1192     function yayCommunity(address awardee, uint256 points) external onlyAdminOrOwner {
1193         uint256 n = block.timestamp;
1194         require(!state.paused, "still paused");
1195         require(state.accounts[awardee].lastAward + 1 days < n, "nice help but need to wait");
1196         require(!getExcluded(awardee), "excluded addresses can't be awarded");
1197         require(points <= 1000 && points > 0, "can't be more than a full level");
1198         state.accounts[awardee].communityPoints += points;
1199         state.accounts[awardee].lastAward = block.timestamp;
1200         emit XPAdded(awardee, points);
1201     }
1202 
1203     // burn amount, for cex integration?
1204     function suchburn(uint256 amount) external {
1205         address sender = msg.sender;
1206         uint256 rate = ratio();
1207         require(!getExcluded(sender), "Excluded addresses can't call this function");
1208         require(amount * rate < state.accounts[sender].rTotal, "too much");
1209         state.accounts[sender].rTotal -= (amount * rate);
1210         state.accounts[address(0)].rTotal += (amount * rate);
1211         state.accounts[address(0)].tTotal += (amount);
1212         state.balances.burned += amount;
1213         syncPool();
1214         emit Blazed(amount);
1215     }
1216 
1217     function dogeit(uint256 amount) external {
1218         require(!state.paused, "still paused");
1219         require(!getExcluded(msg.sender), "excluded can't call");
1220         uint256 rAmount = amount * ratio();
1221         require(state.accounts[msg.sender].lastDogeIt + state.divisors.dogeify < block.timestamp, "you need to wait to doge");
1222         require(amount > 0, "don't waste your gas");
1223         require(rAmount <= state.accounts[state.addresses.buyBonusPool].rTotal / state.divisors.dogeitpayout, "can't kek too much");
1224         state.accounts[msg.sender].lastDogeIt = block.timestamp;
1225         if((state.random + block.timestamp + block.number) % state.odds == 0) {
1226             state.accounts[state.addresses.buyBonusPool].rTotal -= rAmount;
1227             state.accounts[msg.sender].rTotal += rAmount;
1228             emit Doge(msg.sender, amount);
1229         } else {
1230             state.accounts[msg.sender].rTotal -= rAmount;
1231             state.accounts[state.addresses.buyBonusPool].rTotal += rAmount;
1232             emit Kek(msg.sender, amount);
1233         }
1234     }
1235 
1236     function handleTRV(address recipient, uint256 rate, TState ts, TxValue memory t) internal {
1237         state.accounts[state.addresses.dogecity].rTotal += (t.operationalFee * rate);
1238         if(ts == TState.Sell) {
1239             state.accounts[state.addresses.buyBonusPool].rTotal += t.sellFee * rate;
1240             state.accounts[state.addresses.buyBonusPool].tTotal += t.sellFee;
1241         }
1242         if(ts == TState.Buy) {
1243             state.buys++;
1244             uint256 br = t.buyFee * rate;
1245             if(state.buys % state.divisors.buyCounter == 0) {
1246                 uint256 a = state.accounts[state.addresses.prizePool].rTotal + (br);
1247                 state.accounts[state.addresses.prizePool].rTotal = 0;
1248                 state.accounts[state.addresses.prizePool].tTotal = 0;
1249                 state.accounts[recipient].rTotal += a;
1250                 emit Winner(recipient, a);
1251             } else {
1252                 state.accounts[state.addresses.prizePool].rTotal += br;
1253                 state.accounts[state.addresses.prizePool].tTotal += t.buyFee;
1254             }
1255             uint256 r = t.buyBonus * rate;
1256             state.accounts[state.addresses.buyBonusPool].rTotal -= r;
1257             state.accounts[state.addresses.buyBonusPool].tTotal -= t.buyBonus;
1258             state.accounts[recipient].rTotal += r;
1259             emit BonusAwarded(recipient, t.buyBonus);
1260         }
1261     }
1262 
1263     function tValues(address sender, address recipient, uint256 amount, bool noFee, uint256 lpAmount) public view returns (TxValue memory t, TState ts, TxType txType) {
1264         ts = getTState(sender, recipient, lpAmount);
1265         txType = getTxType(sender, recipient);
1266         t.amount = amount;
1267         if(!noFee) {
1268             t.fee = getFee(amount, state.divisors.tx);
1269             t.operationalFee = getFee(amount, state.divisors.dogecity);
1270             if(ts == TState.Sell) {
1271                 uint256 sellFee = getFee(amount, state.divisors.sell);
1272                 uint256 sellLevel = sellFee == 0 ? 0 : ((sellFee * getLevel(sender)) / levelCap);
1273                 t.sellFee = sellFee - sellLevel;
1274             }
1275             if(ts == TState.Buy) {
1276                 t.buyFee = getFee(amount, getBuyTax(amount));
1277                 uint256 bonus = getBuyBonus(amount);
1278                 uint256 levelBonus = bonus == 0 ? 0 : ((bonus * getLevel(recipient)) / levelCap);
1279                 t.buyBonus = bonus + levelBonus;
1280             }
1281         }
1282         t.transferAmount = t.amount - t.fee - t.sellFee - t.buyFee - t.operationalFee;
1283         return (t, ts, txType);
1284     }
1285 
1286     function include(address account) external ownerOnly {
1287         require(state.accounts[account].excluded, "Account is already excluded");
1288         state.accounts[account].tTotal = 0;
1289         EnumerableSet.remove(state.excludedAccounts, account);
1290     }
1291 
1292     function exclude(address account) external ownerOnly {
1293         require(!state.accounts[account].excluded, "Account is already excluded");
1294         state.accounts[account].excluded = true;
1295         if(state.accounts[account].rTotal > 0) {
1296             state.accounts[account].tTotal = state.accounts[account].rTotal / ratio();
1297         }
1298         state.accounts[account].excluded = true;
1299         EnumerableSet.add(state.excludedAccounts, account);
1300     }
1301 
1302     function syncPool() public  {
1303         IUniswapV2Pair(state.addresses.pool).sync();
1304     }
1305 
1306     function enableTrading() external ownerOnly {
1307         state.paused = false;
1308     }
1309 
1310     function adjustOdds(uint8 odds) external ownerOnly {
1311         require(odds >= 2, "can't be more than 50/50");
1312         state.odds = odds;
1313     }
1314 
1315     function setPresale(address account) external ownerOnly {
1316         if(!presaleSet) {
1317             state.addresses.presale = account;
1318             state.accounts[account].feeless = true;
1319             presaleSet = true;
1320         }
1321     }
1322 
1323     function setBuyBonusDivisor(uint8 fd) external ownerOnly {
1324         require(fd >= 20, "can't be more than 5%");
1325         state.divisors.bonus = fd;
1326     }
1327 
1328     function setMinBuyForBuyBonus(uint256 amount) external ownerOnly {
1329         require(amount > 10000e18, "can't be less than 10k tokens");
1330         state.minBuyForBonus = amount * (10 ** state.decimals); 
1331     }
1332 
1333     function setFeeless(address account, bool value) external ownerOnly {
1334         state.accounts[account].feeless = value;
1335     }
1336 
1337     function setBuyFee(uint8 fd) external ownerOnly {
1338         require(fd >= 20, "can't be more than 5%");
1339         state.divisors.buy = fd;
1340     }
1341 
1342     function setSellFee(uint8 fd) external ownerOnly {
1343         require(fd >= 10, "can't be more than 10%");
1344         state.divisors.sell = fd;
1345     }
1346 
1347     function setFarm(address farm) external ownerOnly {
1348         require(state.addresses.farm == address(0), "farm already set");
1349         uint256 _codeLength;
1350         assembly {_codeLength := extcodesize(farm)}
1351         require(_codeLength > 0, "must be a contract");
1352         state.addresses.farm = farm;
1353         emit FarmAdded(farm);
1354     }
1355 
1356     function setRandomSeed(uint256 random) override external {
1357         if(!rngSet){
1358             require(msg.sender == owner(), "not valid caller"); // once chainlink is set random can't be called by owner
1359         } else {
1360             require(msg.sender == state.addresses.rng, "not valid caller"); // for chainlink VRF
1361         }
1362         require(state.random != random, "can't use the same one twice");
1363         state.random = random;
1364     }
1365 
1366     function setRngAddr(address addr) external ownerOnly {
1367         state.addresses.rng = addr;
1368         rngSet = true;
1369     }
1370 
1371     function setLevelCap(uint256 l) external ownerOnly {
1372         require(l >= 10 && l <= 100, "can't be lower than 10 or greater than 100");
1373         levelCap = l;
1374     }
1375 
1376     function setCooldown(uint256 timeInSeconds) external ownerOnly {
1377         require(timeInSeconds > 1 minutes, "too short a time");
1378         state.attackCooldown = timeInSeconds;
1379     }
1380 
1381     function setBuyCounter(uint8 counter) external ownerOnly {
1382         require(counter > 5, "too few people");
1383         state.divisors.buyCounter = counter;
1384     }
1385 
1386     function setDogeItCooldown(uint256 time) external ownerOnly {
1387         require(time > 5 minutes, "too quick");
1388         state.divisors.dogeify = time;
1389     }
1390 
1391     function setTokenLPBurn(uint8 fd) external ownerOnly {
1392         require(fd > 20, "can't be more than 5%");
1393         state.divisors.tokenLPBurn = fd;
1394     }
1395 
1396     function setInflation(uint8 fd) external ownerOnly {
1397         require(fd > 20, "can't be more than 5%");
1398         state.divisors.inflate = fd;
1399     }
1400 
1401     function setDogeItPayoutLimit(uint8 fd) external ownerOnly {
1402         require(fd >= 50, "can't be more than 2% of the buy bonus supply");
1403         state.divisors.dogeitpayout = fd;
1404     }
1405 
1406     function setAdmin(address account, bool value) external ownerOnly {
1407         admins[account] = value;
1408     }
1409 
1410     function setDogeCityDivisor(uint8 fd) external ownerOnly {
1411         require(fd >= 50, "can't be more than 2%");
1412         state.divisors.dogecity = fd;
1413     }
1414 
1415 }