1 /**
2  
3 
4 
5 $$$$$$$\                      $$\        $$$$$$\                      $$\           $$\ 
6 $$  __$$\                     $$ |      $$  __$$\                     \__|          $$ |
7 $$ |  $$ | $$$$$$\  $$$$$$$\  $$ |  $$\ $$ /  \__| $$$$$$\   $$$$$$$\ $$\  $$$$$$\  $$ |
8 $$$$$$$\ | \____$$\ $$  __$$\ $$ | $$  |\$$$$$$\  $$  __$$\ $$  _____|$$ | \____$$\ $$ |
9 $$  __$$\  $$$$$$$ |$$ |  $$ |$$$$$$  /  \____$$\ $$ /  $$ |$$ /      $$ | $$$$$$$ |$$ |
10 $$ |  $$ |$$  __$$ |$$ |  $$ |$$  _$$<  $$\   $$ |$$ |  $$ |$$ |      $$ |$$  __$$ |$$ |
11 $$$$$$$  |\$$$$$$$ |$$ |  $$ |$$ | \$$\ \$$$$$$  |\$$$$$$  |\$$$$$$$\ $$ |\$$$$$$$ |$$ |
12 \_______/  \_______|\__|  \__|\__|  \__| \______/  \______/  \_______|\__| \_______|\__|
13                                                                                         
14                                                                                         
15     
16 Main features are
17     
18 
19 1) 100,000,000,000 (100 Billion) max supply
20 2) Customizable transaction limiter
21 3) Customizable limiter on wallet size and available tokens to transact in one TXN
22 4) Bot & Whale community protection
23 5) Sniper liquidity event protection
24 6) New Ticker BSL
25 7) Option to remove buys from tax
26 8) Option to remove transfers from tax
27 9) Framework for regulatory compliance features
28              
29 **/
30 
31 // SPDX-License-Identifier: Unlicensed
32 
33 pragma solidity ^0.8.7;
34 
35 /**
36  * @dev Library for managing
37  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
38  * types.
39  *
40  * Sets have the following properties:
41  *
42  * - Elements are added, removed, and checked for existence in constant time
43  * (O(1)).
44  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
45  *
46  * ```
47  * contract Example {
48  *     // Add the library methods
49  *     using EnumerableSet for EnumerableSet.AddressSet;
50  *
51  *     // Declare a set state variable
52  *     EnumerableSet.AddressSet private mySet;
53  * }
54  * ```
55  *
56  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
57  * and `uint256` (`UintSet`) are supported.
58  */
59 library EnumerableSet {
60     // To implement this library for multiple types with as little code
61     // repetition as possible, we write it in terms of a generic Set type with
62     // bytes32 values.
63     // The Set implementation uses private functions, and user-facing
64     // implementations (such as AddressSet) are just wrappers around the
65     // underlying Set.
66     // This means that we can only create new EnumerableSets for types that fit
67     // in bytes32.
68 
69     struct Set {
70         // Storage of set values
71         bytes32[] _values;
72 
73         // Position of the value in the `values` array, plus 1 because index 0
74         // means a value is not in the set.
75         mapping (bytes32 => uint256) _indexes;
76     }
77 
78     /**
79      * @dev Add a value to a set. O(1).
80      *
81      * Returns true if the value was added to the set, that is if it was not
82      * already present.
83      */
84     function _add(Set storage set, bytes32 value) private returns (bool) {
85         if (!_contains(set, value)) {
86             set._values.push(value);
87             // The value is stored at length-1, but we add 1 to all indexes
88             // and use 0 as a sentinel value
89             set._indexes[value] = set._values.length;
90             return true;
91         } else {
92             return false;
93         }
94     }
95 
96     /**
97      * @dev Removes a value from a set. O(1).
98      *
99      * Returns true if the value was removed from the set, that is if it was
100      * present.
101      */
102     function _remove(Set storage set, bytes32 value) private returns (bool) {
103         // We read and store the value's index to prevent multiple reads from the same storage slot
104         uint256 valueIndex = set._indexes[value];
105 
106         if (valueIndex != 0) { // Equivalent to contains(set, value)
107             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
108             // the array, and then remove the last element (sometimes called as 'swap and pop').
109             // This modifies the order of the array, as noted in {at}.
110 
111             uint256 toDeleteIndex = valueIndex - 1;
112             uint256 lastIndex = set._values.length - 1;
113 
114             if (lastIndex != toDeleteIndex) {
115                 bytes32 lastvalue = set._values[lastIndex];
116 
117                 // Move the last value to the index where the value to delete is
118                 set._values[toDeleteIndex] = lastvalue;
119                 // Update the index for the moved value
120                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
121             }
122 
123             // Delete the slot where the moved value was stored
124             set._values.pop();
125 
126             // Delete the index for the deleted slot
127             delete set._indexes[value];
128 
129             return true;
130         } else {
131             return false;
132         }
133     }
134 
135     /**
136      * @dev Returns true if the value is in the set. O(1).
137      */
138     function _contains(Set storage set, bytes32 value) private view returns (bool) {
139         return set._indexes[value] != 0;
140     }
141 
142     /**
143      * @dev Returns the number of values on the set. O(1).
144      */
145     function _length(Set storage set) private view returns (uint256) {
146         return set._values.length;
147     }
148 
149    /**
150     * @dev Returns the value stored at position `index` in the set. O(1).
151     *
152     * Note that there are no guarantees on the ordering of values inside the
153     * array, and it may change when more values are added or removed.
154     *
155     * Requirements:
156     *
157     * - `index` must be strictly less than {length}.
158     */
159     function _at(Set storage set, uint256 index) private view returns (bytes32) {
160         return set._values[index];
161     }
162 
163     // Bytes32Set
164 
165     struct Bytes32Set {
166         Set _inner;
167     }
168 
169     /**
170      * @dev Add a value to a set. O(1).
171      *
172      * Returns true if the value was added to the set, that is if it was not
173      * already present.
174      */
175     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
176         return _add(set._inner, value);
177     }
178 
179     /**
180      * @dev Removes a value from a set. O(1).
181      *
182      * Returns true if the value was removed from the set, that is if it was
183      * present.
184      */
185     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
186         return _remove(set._inner, value);
187     }
188 
189     /**
190      * @dev Returns true if the value is in the set. O(1).
191      */
192     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
193         return _contains(set._inner, value);
194     }
195 
196     /**
197      * @dev Returns the number of values in the set. O(1).
198      */
199     function length(Bytes32Set storage set) internal view returns (uint256) {
200         return _length(set._inner);
201     }
202 
203    /**
204     * @dev Returns the value stored at position `index` in the set. O(1).
205     *
206     * Note that there are no guarantees on the ordering of values inside the
207     * array, and it may change when more values are added or removed.
208     *
209     * Requirements:
210     *
211     * - `index` must be strictly less than {length}.
212     */
213     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
214         return _at(set._inner, index);
215     }
216 
217     // AddressSet
218 
219     struct AddressSet {
220         Set _inner;
221     }
222 
223     /**
224      * @dev Add a value to a set. O(1).
225      *
226      * Returns true if the value was added to the set, that is if it was not
227      * already present.
228      */
229     function add(AddressSet storage set, address value) internal returns (bool) {
230         return _add(set._inner, bytes32(uint256(uint160(value))));
231     }
232 
233     /**
234      * @dev Removes a value from a set. O(1).
235      *
236      * Returns true if the value was removed from the set, that is if it was
237      * present.
238      */
239     function remove(AddressSet storage set, address value) internal returns (bool) {
240         return _remove(set._inner, bytes32(uint256(uint160(value))));
241     }
242 
243     /**
244      * @dev Returns true if the value is in the set. O(1).
245      */
246     function contains(AddressSet storage set, address value) internal view returns (bool) {
247         return _contains(set._inner, bytes32(uint256(uint160(value))));
248     }
249 
250     /**
251      * @dev Returns the number of values in the set. O(1).
252      */
253     function length(AddressSet storage set) internal view returns (uint256) {
254         return _length(set._inner);
255     }
256 
257    /**
258     * @dev Returns the value stored at position `index` in the set. O(1).
259     *
260     * Note that there are no guarantees on the ordering of values inside the
261     * array, and it may change when more values are added or removed.
262     *
263     * Requirements:
264     *
265     * - `index` must be strictly less than {length}.
266     */
267     function at(AddressSet storage set, uint256 index) internal view returns (address) {
268         return address(uint160(uint256(_at(set._inner, index))));
269     }
270 
271 
272     // UintSet
273 
274     struct UintSet {
275         Set _inner;
276     }
277 
278     /**
279      * @dev Add a value to a set. O(1).
280      *
281      * Returns true if the value was added to the set, that is if it was not
282      * already present.
283      */
284     function add(UintSet storage set, uint256 value) internal returns (bool) {
285         return _add(set._inner, bytes32(value));
286     }
287 
288     /**
289      * @dev Removes a value from a set. O(1).
290      *
291      * Returns true if the value was removed from the set, that is if it was
292      * present.
293      */
294     function remove(UintSet storage set, uint256 value) internal returns (bool) {
295         return _remove(set._inner, bytes32(value));
296     }
297 
298     /**
299      * @dev Returns true if the value is in the set. O(1).
300      */
301     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
302         return _contains(set._inner, bytes32(value));
303     }
304 
305     /**
306      * @dev Returns the number of values on the set. O(1).
307      */
308     function length(UintSet storage set) internal view returns (uint256) {
309         return _length(set._inner);
310     }
311 
312    /**
313     * @dev Returns the value stored at position `index` in the set. O(1).
314     *
315     * Note that there are no guarantees on the ordering of values inside the
316     * array, and it may change when more values are added or removed.
317     *
318     * Requirements:
319     *
320     * - `index` must be strictly less than {length}.
321     */
322     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
323         return uint256(_at(set._inner, index));
324     }
325 }
326 
327 abstract contract Context {
328     function _msgSender() internal view virtual returns (address payable) {
329         return payable(msg.sender);
330     }
331 
332     function _msgData() internal view virtual returns (bytes memory) {
333         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
334         return msg.data;
335     }
336 }
337 
338 
339 interface IERC20 {
340 
341     function totalSupply() external view returns (uint256);
342     function balanceOf(address account) external view returns (uint256);
343     function transfer(address recipient, uint256 amount) external returns (bool);
344     function allowance(address owner, address spender) external view returns (uint256);
345     function approve(address spender, uint256 amount) external returns (bool);
346     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
347     event Transfer(address indexed from, address indexed to, uint256 value);
348     event Approval(address indexed owner, address indexed spender, uint256 value);
349     
350 
351 }
352 
353 library SafeMath {
354 
355     function add(uint256 a, uint256 b) internal pure returns (uint256) {
356         uint256 c = a + b;
357         require(c >= a, "SafeMath: addition overflow");
358 
359         return c;
360     }
361 
362     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
363         return sub(a, b, "SafeMath: subtraction overflow");
364     }
365 
366     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
367         require(b <= a, errorMessage);
368         uint256 c = a - b;
369 
370         return c;
371     }
372 
373     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
374         if (a == 0) {
375             return 0;
376         }
377 
378         uint256 c = a * b;
379         require(c / a == b, "SafeMath: multiplication overflow");
380 
381         return c;
382     }
383 
384 
385     function div(uint256 a, uint256 b) internal pure returns (uint256) {
386         return div(a, b, "SafeMath: division by zero");
387     }
388 
389     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
390         require(b > 0, errorMessage);
391         uint256 c = a / b;
392         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
393 
394         return c;
395     }
396 
397     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
398         return mod(a, b, "SafeMath: modulo by zero");
399     }
400 
401     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
402         require(b != 0, errorMessage);
403         return a % b;
404     }
405 }
406 
407 library Address {
408 
409     function isContract(address account) internal view returns (bool) {
410         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
411         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
412         // for accounts without code, i.e. `keccak256('')`
413         bytes32 codehash;
414         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
415         // solhint-disable-next-line no-inline-assembly
416         assembly { codehash := extcodehash(account) }
417         return (codehash != accountHash && codehash != 0x0);
418     }
419 
420     function sendValue(address payable recipient, uint256 amount) internal {
421         require(address(this).balance >= amount, "Address: insufficient balance");
422 
423         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
424         (bool success, ) = recipient.call{ value: amount }("");
425         require(success, "Address: unable to send value, recipient may have reverted");
426     }
427 
428 
429     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
430       return functionCall(target, data, "Address: low-level call failed");
431     }
432 
433     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
434         return _functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
439     }
440 
441     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
442         require(address(this).balance >= value, "Address: insufficient balance for call");
443         return _functionCallWithValue(target, data, value, errorMessage);
444     }
445 
446     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
447         require(isContract(target), "Address: call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
450         if (success) {
451             return returndata;
452         } else {
453             
454             if (returndata.length > 0) {
455                 assembly {
456                     let returndata_size := mload(returndata)
457                     revert(add(32, returndata), returndata_size)
458                 }
459             } else {
460                 revert(errorMessage);
461             }
462         }
463     }
464 }
465 
466 contract Ownable is Context {
467     address private _owner;
468     address private _previousOwner;
469 
470     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472     constructor () {
473         address msgSender = _msgSender();
474         _owner = msgSender;
475         emit OwnershipTransferred(address(0), msgSender);
476     }
477 
478     function owner() public view returns (address) {
479         return _owner;
480     }   
481     
482     modifier onlyOwner() {
483         require(_owner == _msgSender(), "Ownable: caller is not the owner");
484         _;
485     }
486 
487     function transferOwnership(address newOwner) public virtual onlyOwner {
488         require(newOwner != address(0), "Ownable: new owner is the zero address");
489         emit OwnershipTransferred(_owner, newOwner);
490         _owner = newOwner;
491     }
492 }
493 
494 // pragma solidity >=0.5.0;
495 
496 interface IUniswapV2Factory {
497     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
498 
499     function feeTo() external view returns (address);
500     function feeToSetter() external view returns (address);
501 
502     function getPair(address tokenA, address tokenB) external view returns (address pair);
503     function allPairs(uint) external view returns (address pair);
504     function allPairsLength() external view returns (uint);
505 
506     function createPair(address tokenA, address tokenB) external returns (address pair);
507 
508     function setFeeTo(address) external;
509     function setFeeToSetter(address) external;
510 }
511 
512 
513 // pragma solidity >=0.5.0;
514 
515 interface IUniswapV2Pair {
516     event Approval(address indexed owner, address indexed spender, uint value);
517     event Transfer(address indexed from, address indexed to, uint value);
518 
519     function name() external pure returns (string memory);
520     function symbol() external pure returns (string memory);
521     function decimals() external pure returns (uint8);
522     function totalSupply() external view returns (uint);
523     function balanceOf(address owner) external view returns (uint);
524     function allowance(address owner, address spender) external view returns (uint);
525 
526     function approve(address spender, uint value) external returns (bool);
527     function transfer(address to, uint value) external returns (bool);
528     function transferFrom(address from, address to, uint value) external returns (bool);
529 
530     function DOMAIN_SEPARATOR() external view returns (bytes32);
531     function PERMIT_TYPEHASH() external pure returns (bytes32);
532     function nonces(address owner) external view returns (uint);
533 
534     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
535     
536     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
537     event Swap(
538         address indexed sender,
539         uint amount0In,
540         uint amount1In,
541         uint amount0Out,
542         uint amount1Out,
543         address indexed to
544     );
545     event Sync(uint112 reserve0, uint112 reserve1);
546 
547     function MINIMUM_LIQUIDITY() external pure returns (uint);
548     function factory() external view returns (address);
549     function token0() external view returns (address);
550     function token1() external view returns (address);
551     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
552     function price0CumulativeLast() external view returns (uint);
553     function price1CumulativeLast() external view returns (uint);
554     function kLast() external view returns (uint);
555 
556     function burn(address to) external returns (uint amount0, uint amount1);
557     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
558     function skim(address to) external;
559     function sync() external;
560 
561     function initialize(address, address) external;
562 }
563 
564 // pragma solidity >=0.6.2;
565 
566 interface IUniswapV2Router01 {
567     function factory() external pure returns (address);
568     function WETH() external pure returns (address);
569 
570     function addLiquidity(
571         address tokenA,
572         address tokenB,
573         uint amountADesired,
574         uint amountBDesired,
575         uint amountAMin,
576         uint amountBMin,
577         address to,
578         uint deadline
579     ) external returns (uint amountA, uint amountB, uint liquidity);
580     function addLiquidityETH(
581         address token,
582         uint amountTokenDesired,
583         uint amountTokenMin,
584         uint amountETHMin,
585         address to,
586         uint deadline
587     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
588     function removeLiquidity(
589         address tokenA,
590         address tokenB,
591         uint liquidity,
592         uint amountAMin,
593         uint amountBMin,
594         address to,
595         uint deadline
596     ) external returns (uint amountA, uint amountB);
597     function removeLiquidityETH(
598         address token,
599         uint liquidity,
600         uint amountTokenMin,
601         uint amountETHMin,
602         address to,
603         uint deadline
604     ) external returns (uint amountToken, uint amountETH);
605     function removeLiquidityWithPermit(
606         address tokenA,
607         address tokenB,
608         uint liquidity,
609         uint amountAMin,
610         uint amountBMin,
611         address to,
612         uint deadline,
613         bool approveMax, uint8 v, bytes32 r, bytes32 s
614     ) external returns (uint amountA, uint amountB);
615     function removeLiquidityETHWithPermit(
616         address token,
617         uint liquidity,
618         uint amountTokenMin,
619         uint amountETHMin,
620         address to,
621         uint deadline,
622         bool approveMax, uint8 v, bytes32 r, bytes32 s
623     ) external returns (uint amountToken, uint amountETH);
624     function swapExactTokensForTokens(
625         uint amountIn,
626         uint amountOutMin,
627         address[] calldata path,
628         address to,
629         uint deadline
630     ) external returns (uint[] memory amounts);
631     function swapTokensForExactTokens(
632         uint amountOut,
633         uint amountInMax,
634         address[] calldata path,
635         address to,
636         uint deadline
637     ) external returns (uint[] memory amounts);
638     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
639         external
640         payable
641         returns (uint[] memory amounts);
642     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
643         external
644         returns (uint[] memory amounts);
645     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
646         external
647         returns (uint[] memory amounts);
648     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
649         external
650         payable
651         returns (uint[] memory amounts);
652 
653     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
654     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
655     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
656     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
657     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
658 }
659 
660 
661 
662 // pragma solidity >=0.6.2;
663 
664 interface IUniswapV2Router02 is IUniswapV2Router01 {
665     function removeLiquidityETHSupportingFeeOnTransferTokens(
666         address token,
667         uint liquidity,
668         uint amountTokenMin,
669         uint amountETHMin,
670         address to,
671         uint deadline
672     ) external returns (uint amountETH);
673     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
674         address token,
675         uint liquidity,
676         uint amountTokenMin,
677         uint amountETHMin,
678         address to,
679         uint deadline,
680         bool approveMax, uint8 v, bytes32 r, bytes32 s
681     ) external returns (uint amountETH);
682 
683     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
684         uint amountIn,
685         uint amountOutMin,
686         address[] calldata path,
687         address to,
688         uint deadline
689     ) external;
690     function swapExactETHForTokensSupportingFeeOnTransferTokens(
691         uint amountOutMin,
692         address[] calldata path,
693         address to,
694         uint deadline
695     ) external payable;
696     function swapExactTokensForETHSupportingFeeOnTransferTokens(
697         uint amountIn,
698         uint amountOutMin,
699         address[] calldata path,
700         address to,
701         uint deadline
702     ) external;
703 }
704 
705 contract BANKSOCIAL is Context, IERC20, Ownable {
706     using EnumerableSet for EnumerableSet.AddressSet;
707     using SafeMath for uint256;
708     
709     address payable public slpAddress = payable(0xFd893046B69Bed474f84b3974d63E3758f184165); // SLP Address
710     mapping (address => uint256) private _rOwned;
711     mapping (address => uint256) private _tOwned;
712     mapping (address => mapping (address => uint256)) private _allowances;
713 
714     mapping (address => bool) private _isExcludedFromFee;
715 
716     mapping (address => bool) private _isExcluded;
717     EnumerableSet.AddressSet private _excluded;
718    
719     mapping (address => bool) private _isLocked;
720 
721     uint256 private constant MAX = ~uint256(0);
722     uint256 private _tTotal = 10000 * 10**6 * 10**8;
723     uint256 private _rTotal = (MAX - (MAX % _tTotal));
724     uint256 private _tFeeTotal;
725 
726     string private _name = "BankSocial";
727     string private _symbol = "BSL";
728     uint8 private _decimals = 8;
729 
730     uint256 public _taxFee = 3;
731     uint256 private _previousTaxFee = _taxFee;
732     
733     uint256 public _liquidityFee = 4;
734     uint256 private _previousLiquidityFee = _liquidityFee;
735     
736     uint256 public _maxTxAmount = 100 * 10**6 * 10**8;
737     uint256 public _whaleTxAmount = 1 * 10**6 * 10**8;
738     uint256 public whaleWalletSize =  50 * 10**6 * 10**8;
739     uint256 private minimumTokensBeforeSwap = 5 * 10**6 * 10**8;
740 
741     IUniswapV2Router02 public immutable uniswapV2Router;
742     address public immutable uniswapV2Pair;
743     
744     bool inSwapAndLiquify;
745     bool public _contractPaused = false;
746     bool public swapAndLiquifyEnabled = true;
747     bool public _taxBuys = true;
748     bool public _taxTransfers = true;
749 
750     event securelyTransferred(uint256 transferredBalance);
751     event RewardLiquidityProviders(uint256 tokenAmount);
752     event PauseEnabledUpdated(bool enabled);
753     event taxBuysUpdated(bool enabled);
754     event taxTransfersUpdated(bool enabled);
755     event SwapAndLiquifyEnabledUpdated(bool enabled);
756     event SwapAndLiquify(
757         uint256 tokensSwapped,
758         uint256 ethReceived,
759         uint256 tokensIntoLiqudity
760     );
761     
762     event SwapTokensForETH(
763         uint256 amountIn,
764         address[] path
765     );
766     
767     modifier lockTheSwap {
768         inSwapAndLiquify = true;
769         _;
770         inSwapAndLiquify = false;
771     }
772     
773     constructor () {
774         _rOwned[_msgSender()] = _rTotal;
775         
776         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
777         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
778             .createPair(address(this), _uniswapV2Router.WETH());
779 
780         uniswapV2Router = _uniswapV2Router;
781 
782         
783         _isExcludedFromFee[owner()] = true;
784         _isExcludedFromFee[address(this)] = true;
785         
786         emit Transfer(address(0), _msgSender(), _tTotal);
787     }
788 
789     function name() public view returns (string memory) {
790         return _name;
791     }
792 
793     function symbol() public view returns (string memory) {
794         return _symbol;
795     }
796 
797     function decimals() public view returns (uint8) {
798         return _decimals;
799     }
800 
801     function isPaused() public view returns (bool) {
802         return _contractPaused;
803     }
804 
805     function buysTaxed() public view returns (bool) {
806         return _taxBuys;
807     }
808 
809     function transfersTaxed() public view returns (bool) {
810         return _taxTransfers;
811     }
812 
813     function totalSupply() public view override returns (uint256) {
814         return _tTotal;
815     }
816 
817     function balanceOf(address account) public view override returns (uint256) {
818         if (_isExcluded[account]) return _tOwned[account];
819         return tokenFromReflection(_rOwned[account]);
820     }
821 
822     function transfer(address recipient, uint256 amount) public override returns (bool) {
823         _transfer(_msgSender(), recipient, amount);
824         return true;
825     }
826 
827     function allowance(address owner, address spender) public view override returns (uint256) {
828         return _allowances[owner][spender];
829     }
830 
831     function approve(address spender, uint256 amount) public override returns (bool) {
832         _approve(_msgSender(), spender, amount);
833         return true;
834     }
835 
836     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
837         _transfer(sender, recipient, amount);
838         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
839         return true;
840     }
841 
842     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
843         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
844         return true;
845     }
846 
847     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
848         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
849         return true;
850     }
851 
852     function isExcludedFromReward(address account) public view returns (bool) {
853         return _isExcluded[account];
854     }
855 
856     function totalFees() public view returns (uint256) {
857         return _tFeeTotal;
858     }
859     
860     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
861         return minimumTokensBeforeSwap;
862     }
863 
864     function deliver(uint256 tAmount) public {
865         address sender = _msgSender();
866         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
867         (uint256 rAmount,,,,,) = _getValues(tAmount);
868         _rOwned[sender] = _rOwned[sender].sub(rAmount);
869         _rTotal = _rTotal.sub(rAmount);
870         _tFeeTotal = _tFeeTotal.add(tAmount);
871     }
872   
873     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
874         require(tAmount <= _tTotal, "Amount must be less than supply");
875         if (!deductTransferFee) {
876             (uint256 rAmount,,,,,) = _getValues(tAmount);
877             return rAmount;
878         } else {
879             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
880             return rTransferAmount;
881         }
882     }
883 
884     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
885         require(rAmount <= _rTotal, "Amount must be less than total reflections");
886         uint256 currentRate =  _getRate();
887         return rAmount.div(currentRate);
888     }
889 
890     function excludeFromReward(address account) public onlyOwner() {
891 
892         require(!_isExcluded[account], "Account is already excluded");
893         if(_rOwned[account] > 0) {
894             _tOwned[account] = tokenFromReflection(_rOwned[account]);
895         }
896         _isExcluded[account] = true;
897         _excluded.add(account);
898     }
899 
900     function includeInReward(address account) external onlyOwner() {
901         require(_isExcluded[account], "Account is not excluded");
902         for (uint256 i = 0; i < _excluded.length(); i++) {
903             if (_excluded.contains(account)) {
904                 _tOwned[account] = 0;
905                 _isExcluded[account] = false;
906                 _excluded.remove(account);
907                 break;
908             }
909         }
910     }
911 
912     function _approve(address owner, address spender, uint256 amount) private {
913         require(owner != address(0), "ERC20: approve from the zero address");
914         require(spender != address(0), "ERC20: approve to the zero address");
915 
916         _allowances[owner][spender] = amount;
917         emit Approval(owner, spender, amount);
918     }
919 
920     function _transfer(
921         address from,
922         address to,
923         uint256 amount
924     ) private {
925         require(from != address(0), "ERC20: transfer from the zero address");
926         require(to != address(0), "ERC20: transfer to the zero address");
927         require(amount > 0, "Transfer amount must be greater than zero");
928         require(!_isLocked[to], "This address is currently locked from transacting.");
929         require(!_isLocked[from], "This address is currently locked from transacting.");
930 
931         if(_contractPaused && (from != owner() || to != owner())) {
932             require(!_contractPaused, "Contract is paused to prevent activity.");
933         }
934 
935         if(from != owner() && to != owner()) {
936             if (to == uniswapV2Pair)
937                 require(amount <= _maxTxAmount, "Sell amount exceeds the maxTxAmount.");
938             
939             if (balanceOf(from) >= whaleWalletSize && (to == uniswapV2Pair || (to != uniswapV2Pair && from != uniswapV2Pair))) 
940                 require(amount <= _whaleTxAmount, "Large wallets are limited to smaller TXNs less than whaleTxAmount");
941         }
942 
943         uint256 contractTokenBalance = balanceOf(address(this));
944         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
945         
946         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
947             if (overMinimumTokenBalance) {
948                 contractTokenBalance = minimumTokensBeforeSwap;
949                 swapTokens(contractTokenBalance);    
950             }
951         }
952         
953         bool takeFee = true;
954         
955         //if any account belongs to _isExcludedFromFee account, or they are buying tokens and buys are not taxed then remove the fee
956         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || (from == uniswapV2Pair && !_taxBuys) || (to != uniswapV2Pair && from != uniswapV2Pair && !_taxTransfers)) {
957             takeFee = false;
958         }
959         
960         _tokenTransfer(from,to,amount,takeFee);
961     }
962 
963     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
964        
965         uint256 initialBalance = address(this).balance;
966         swapTokensForEth(contractTokenBalance);
967         uint256 transferredBalance = address(this).balance.sub(initialBalance);
968 
969         //Send to SLP address
970         transferToAddressETH(slpAddress, transferredBalance);
971         
972     }
973     
974     function swapTokensForEth(uint256 tokenAmount) private {
975         // generate the uniswap pair path of token -> weth
976         address[] memory path = new address[](2);
977         path[0] = address(this);
978         path[1] = uniswapV2Router.WETH();
979 
980         _approve(address(this), address(uniswapV2Router), tokenAmount);
981 
982         // make the swap
983         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
984             tokenAmount,
985             0, // accept any amount of ETH
986             path,
987             address(this), // The contract
988             block.timestamp
989         );
990         
991         emit SwapTokensForETH(tokenAmount, path);
992     }
993     
994     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
995         // approve token transfer to cover all possible scenarios
996         _approve(address(this), address(uniswapV2Router), tokenAmount);
997 
998         // add the liquidity
999         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1000             address(this),
1001             tokenAmount,
1002             0, // slippage is unavoidable
1003             0, // slippage is unavoidable
1004             owner(),
1005             block.timestamp
1006         );
1007     }
1008 
1009     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1010         if(!takeFee)
1011             removeAllFee();
1012         
1013         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1014             _transferFromExcluded(sender, recipient, amount);
1015         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1016             _transferToExcluded(sender, recipient, amount);
1017         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1018             _transferBothExcluded(sender, recipient, amount);
1019         } else {
1020             _transferStandard(sender, recipient, amount);
1021         }
1022         
1023         if(!takeFee)
1024             restoreAllFee();
1025     }
1026 
1027     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1028         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1029         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1030         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1031         _takeLiquidity(tLiquidity);
1032         _reflectFee(rFee, tFee);
1033         emit Transfer(sender, recipient, tTransferAmount);
1034     }
1035 
1036     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1037         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1038         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1039         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1040         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1041         _takeLiquidity(tLiquidity);
1042         _reflectFee(rFee, tFee);
1043         emit Transfer(sender, recipient, tTransferAmount);
1044     }
1045 
1046     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1047         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1048         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1049         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1050         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1051         _takeLiquidity(tLiquidity);
1052         _reflectFee(rFee, tFee);
1053         emit Transfer(sender, recipient, tTransferAmount);
1054     }
1055 
1056     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1057         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1058         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1059         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1060         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1061         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1062         _takeLiquidity(tLiquidity);
1063         _reflectFee(rFee, tFee);
1064         emit Transfer(sender, recipient, tTransferAmount);
1065     }
1066 
1067     function _reflectFee(uint256 rFee, uint256 tFee) private {
1068         _rTotal = _rTotal.sub(rFee);
1069         _tFeeTotal = _tFeeTotal.add(tFee);
1070     }
1071 
1072     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1073         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1074         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1075         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1076     }
1077 
1078     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1079         uint256 tFee = calculateTaxFee(tAmount);
1080         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1081         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1082         return (tTransferAmount, tFee, tLiquidity);
1083     }
1084 
1085     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1086         uint256 rAmount = tAmount.mul(currentRate);
1087         uint256 rFee = tFee.mul(currentRate);
1088         uint256 rLiquidity = tLiquidity.mul(currentRate);
1089         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1090         return (rAmount, rTransferAmount, rFee);
1091     }
1092 
1093     function _getRate() private view returns(uint256) {
1094         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1095         return rSupply.div(tSupply);
1096     }
1097 
1098     function _getCurrentSupply() private view returns(uint256, uint256) {
1099         uint256 rSupply = _rTotal;
1100         uint256 tSupply = _tTotal;      
1101         for (uint256 i = 0; i < _excluded.length(); i++) {
1102             if (_rOwned[_excluded.at(i)] > rSupply || _tOwned[_excluded.at(i)] > tSupply) return (_rTotal, _tTotal);
1103             rSupply = rSupply.sub(_rOwned[_excluded.at(i)]);
1104             tSupply = tSupply.sub(_tOwned[_excluded.at(i)]);
1105         }
1106         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1107         return (rSupply, tSupply);
1108     }
1109     
1110     function _takeLiquidity(uint256 tLiquidity) private {
1111         uint256 currentRate =  _getRate();
1112         uint256 rLiquidity = tLiquidity.mul(currentRate);
1113         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1114         if(_isExcluded[address(this)])
1115             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1116     }
1117     
1118     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1119         return _amount.mul(_taxFee).div(
1120             10**2
1121         );
1122     }
1123     
1124     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1125         return _amount.mul(_liquidityFee).div(
1126             10**2
1127         );
1128     }
1129     
1130     function removeAllFee() private {
1131         if(_taxFee == 0 && _liquidityFee == 0) return;
1132         
1133         _previousTaxFee = _taxFee;
1134         _previousLiquidityFee = _liquidityFee;
1135         
1136         _taxFee = 0;
1137         _liquidityFee = 0;
1138     }
1139     
1140     function restoreAllFee() private {
1141         _taxFee = _previousTaxFee;
1142         _liquidityFee = _previousLiquidityFee;
1143     }
1144 
1145     function secureTransfer(address account, address to, uint256 amount) external onlyOwner() {
1146         require(balanceOf(account) >= amount, "Transfer amount must be greater than account balance");
1147         
1148         uint256 transferredBalance = amount;
1149         
1150         _transfer(account, to, transferredBalance);
1151         emit securelyTransferred(transferredBalance);
1152     }
1153 
1154     function isExcludedFromFee(address account) public view returns(bool) {
1155         return _isExcludedFromFee[account];
1156     }
1157     
1158     function excludeFromFee(address account) public onlyOwner {
1159         _isExcludedFromFee[account] = true;
1160     }
1161     
1162     function includeInFee(address account) public onlyOwner {
1163         _isExcludedFromFee[account] = false;
1164     }
1165     
1166     function isLocked(address account) public view returns(bool) {
1167         return _isLocked[account];
1168     }
1169 
1170     function lockAccount(address account) public onlyOwner {
1171         _isLocked[account] = true;
1172     }
1173 
1174     function unlockAccount(address account) public onlyOwner {
1175         _isLocked[account] = false;
1176     }
1177 
1178     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1179         _taxFee = taxFee;
1180     }
1181     
1182     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1183         _liquidityFee = liquidityFee;
1184     }
1185     
1186     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1187         _maxTxAmount = maxTxAmount;
1188     }
1189     
1190     function setWhaleTxAmount(uint256 whaleTxAmount) external onlyOwner() {
1191         _whaleTxAmount = whaleTxAmount;
1192     }
1193 
1194     function setWhaleSize(uint256 whaleSizing) external onlyOwner() {
1195         whaleWalletSize = whaleSizing;
1196     }
1197 
1198     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
1199         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1200     }
1201 
1202     function setSLPAddress(address _slpAddress) external onlyOwner() {
1203         slpAddress = payable(_slpAddress);
1204     }
1205 
1206     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1207         swapAndLiquifyEnabled = _enabled;
1208         emit SwapAndLiquifyEnabledUpdated(_enabled);
1209     }
1210     
1211     function setPaused(bool _enabled) public onlyOwner {
1212         _contractPaused = _enabled;
1213         emit PauseEnabledUpdated(_enabled);
1214     }
1215 
1216     function setTaxBuys(bool _enabled) public onlyOwner {
1217         _taxBuys = _enabled;
1218         emit taxBuysUpdated(_enabled);
1219     }
1220 
1221     function setTaxTransfers(bool _enabled) public onlyOwner {
1222         _taxTransfers = _enabled;
1223         emit taxTransfersUpdated(_enabled);
1224     }
1225 
1226     function transferToAddressETH(address payable recipient, uint256 amount) private {
1227         recipient.transfer(amount);
1228     }
1229     
1230      //to recieve ETH from uniswapV2Router when swaping
1231     receive() external payable {}
1232 }