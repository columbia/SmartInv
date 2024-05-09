1 // File: contracts/interfaces/IOneSwapRouter.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.6.12;
5 
6 interface IOneSwapRouter {
7     event AddLiquidity(uint stockAmount, uint moneyAmount, uint liquidity);
8     event PairCreated(address indexed pair, address stock, address money, bool isOnlySwap);
9 
10     function factory() external pure returns (address);
11 
12     // liquidity
13     function addLiquidity(
14         address stock,
15         address money,
16         bool isOnlySwap,
17         uint amountStockDesired,
18         uint amountMoneyDesired,
19         uint amountStockMin,
20         uint amountMoneyMin,
21         address to,
22         uint deadline
23     ) external payable returns (uint amountStock, uint amountMoney, uint liquidity);
24     function removeLiquidity(
25         address pair,
26         uint liquidity,
27         uint amountStockMin,
28         uint amountMoneyMin,
29         address to,
30         uint deadline
31     ) external returns (uint amountStock, uint amountMoney);
32 
33     // swap token
34     function swapToken(
35         address token,
36         uint amountIn,
37         uint amountOutMin,
38         address[] calldata path,
39         address to,
40         uint deadline
41     ) external payable returns (uint[] memory amounts);
42 
43     // limit order
44     function limitOrder(
45         bool isBuy,
46         address pair,
47         uint prevKey,
48         uint price,
49         uint32 id,
50         uint stockAmount,
51         uint deadline
52     ) external payable;
53 }
54 
55 // File: contracts/interfaces/IOneSwapFactory.sol
56 
57 pragma solidity 0.6.12;
58 
59 interface IOneSwapFactory {
60     event PairCreated(address indexed pair, address stock, address money, bool isOnlySwap);
61 
62     function createPair(address stock, address money, bool isOnlySwap) external returns (address pair);
63     function setFeeTo(address) external;
64     function setFeeToSetter(address) external;
65     function setFeeBPS(uint32 bps) external;
66     function setPairLogic(address implLogic) external;
67 
68     function allPairsLength() external view returns (uint);
69     function feeTo() external view returns (address);
70     function feeToSetter() external view returns (address);
71     function feeBPS() external view returns (uint32);
72     function pairLogic() external returns (address);
73     function getTokensFromPair(address pair) external view returns (address stock, address money);
74     function tokensToPair(address stock, address money, bool isOnlySwap) external view returns (address pair);
75 }
76 
77 // File: contracts/interfaces/IOneSwapPair.sol
78 
79 pragma solidity 0.6.12;
80 
81 interface IOneSwapERC20 {
82     event Approval(address indexed owner, address indexed spender, uint value);
83     event Transfer(address indexed from, address indexed to, uint value);
84 
85     function name() external view returns (string memory);
86     function symbol() external returns (string memory);
87     function decimals() external view returns (uint8);
88     function totalSupply() external view returns (uint);
89     function balanceOf(address owner) external view returns (uint);
90     function allowance(address owner, address spender) external view returns (uint);
91 
92     function approve(address spender, uint value) external returns (bool);
93     function transfer(address to, uint value) external returns (bool);
94     function transferFrom(address from, address to, uint value) external returns (bool);
95 }
96 
97 interface IOneSwapPool {
98     // more liquidity was minted
99     event Mint(address indexed sender, uint stockAndMoneyAmount, address indexed to);
100     // liquidity was burned
101     event Burn(address indexed sender, uint stockAndMoneyAmount, address indexed to);
102     // amounts of reserved stock and money in this pair changed
103     event Sync(uint reserveStockAndMoney);
104 
105     function internalStatus() external view returns(uint[3] memory res);
106     function getReserves() external view returns (uint112 reserveStock, uint112 reserveMoney, uint32 firstSellID);
107     function getBooked() external view returns (uint112 bookedStock, uint112 bookedMoney, uint32 firstBuyID);
108     function stock() external returns (address);
109     function money() external returns (address);
110     function mint(address to) external returns (uint liquidity);
111     function burn(address to) external returns (uint stockAmount, uint moneyAmount);
112     function skim(address to) external;
113     function sync() external;
114 }
115 
116 interface IOneSwapPair {
117     event NewLimitOrder(uint data); // new limit order was sent by an account
118     event NewMarketOrder(uint data); // new market order was sent by an account
119     event OrderChanged(uint data); // old orders in orderbook changed
120     event DealWithPool(uint data); // new order deal with the AMM pool
121     event RemoveOrder(uint data); // an order was removed from the orderbook
122     
123     // Return three prices in rational number form, i.e., numerator/denominator.
124     // They are: the first sell order's price; the first buy order's price; the current price of the AMM pool.
125     function getPrices() external returns (
126         uint firstSellPriceNumerator,
127         uint firstSellPriceDenominator,
128         uint firstBuyPriceNumerator,
129         uint firstBuyPriceDenominator,
130         uint poolPriceNumerator,
131         uint poolPriceDenominator);
132 
133     // This function queries a list of orders in orderbook. It starts from 'id' and iterates the single-linked list, util it reaches the end, 
134     // or until it has found 'maxCount' orders. If 'id' is 0, it starts from the beginning of the single-linked list.
135     // It may cost a lot of gas. So you'd not to call in on chain. It is mainly for off-chain query.
136     // The first uint256 returned by this function is special: the lowest 24 bits is the first order's id and the the higher bits is block height.
137     // THe other uint256s are all corresponding to an order record of the single-linked list.
138     function getOrderList(bool isBuy, uint32 id, uint32 maxCount) external view returns (uint[] memory);
139 
140     // remove an order from orderbook and return its booked (i.e. frozen) money to maker
141     // 'id' points to the order to be removed
142     // prevKey points to 3 previous orders in the single-linked list
143     function removeOrder(bool isBuy, uint32 id, uint72 positionID) external;
144 
145     function removeOrders(uint[] calldata rmList) external;
146 
147     // Try to deal a new limit order or insert it into orderbook
148     // its suggested order id is 'id' and suggested positions are in 'prevKey'
149     // prevKey points to 3 existing orders in the single-linked list
150     // the order's sender is 'sender'. the order's amount is amount*stockUnit, which is the stock amount to be sold or bought.
151     // the order's price is 'price32', which is decimal floating point value.
152     function addLimitOrder(bool isBuy, address sender, uint64 amount, uint32 price32, uint32 id, uint72 prevKey) external payable;
153 
154     // Try to deal a new market order. 'sender' pays 'inAmount' of 'inputToken', in exchange of the other token kept by this pair
155     function addMarketOrder(address inputToken, address sender, uint112 inAmount) external payable returns (uint);
156 
157     // Given the 'amount' of stock and decimal floating point price 'price32', calculate the 'stockAmount' and 'moneyAmount' to be traded
158     function calcStockAndMoney(uint64 amount, uint32 price32) external pure returns (uint stockAmount, uint moneyAmount);
159 }
160 
161 // File: contracts/interfaces/IERC20.sol
162 
163 pragma solidity 0.6.12;
164 
165 interface IERC20 {
166     event Approval(address indexed owner, address indexed spender, uint value);
167     event Transfer(address indexed from, address indexed to, uint value);
168 
169     function name() external view returns (string memory);
170     function symbol() external view returns (string memory);
171     function decimals() external view returns (uint8);
172     function totalSupply() external view returns (uint);
173     function balanceOf(address owner) external view returns (uint);
174     function allowance(address owner, address spender) external view returns (uint);
175 
176     function approve(address spender, uint value) external returns (bool);
177     function transfer(address to, uint value) external returns (bool);
178     function transferFrom(address from, address to, uint value) external returns (bool);
179 }
180 
181 // File: contracts/libraries/SafeMath256.sol
182 
183 pragma solidity 0.6.12;
184 
185 library SafeMath256 {
186     /**
187      * @dev Returns the addition of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `+` operator.
191      *
192      * Requirements:
193      *
194      * - Addition cannot overflow.
195      */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         require(c >= a, "SafeMath: addition overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      *
211      * - Subtraction cannot overflow.
212      */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         return sub(a, b, "SafeMath: subtraction overflow");
215     }
216 
217     /**
218      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
219      * overflow (when the result is negative).
220      *
221      * Counterpart to Solidity's `-` operator.
222      *
223      * Requirements:
224      *
225      * - Subtraction cannot overflow.
226      */
227     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b <= a, errorMessage);
229         uint256 c = a - b;
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the multiplication of two unsigned integers, reverting on
236      * overflow.
237      *
238      * Counterpart to Solidity's `*` operator.
239      *
240      * Requirements:
241      *
242      * - Multiplication cannot overflow.
243      */
244     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246         // benefit is lost if 'b' is also tested.
247         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
248         if (a == 0) {
249             return 0;
250         }
251 
252         uint256 c = a * b;
253         require(c / a == b, "SafeMath: multiplication overflow");
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers. Reverts on
260      * division by zero. The result is rounded towards zero.
261      *
262      * Counterpart to Solidity's `/` operator. Note: this function uses a
263      * `revert` opcode (which leaves remaining gas untouched) while Solidity
264      * uses an invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         return div(a, b, "SafeMath: division by zero");
272     }
273 
274     /**
275      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
276      * division by zero. The result is rounded towards zero.
277      *
278      * Counterpart to Solidity's `/` operator. Note: this function uses a
279      * `revert` opcode (which leaves remaining gas untouched) while Solidity
280      * uses an invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      *
284      * - The divisor cannot be zero.
285      */
286     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
287         require(b > 0, errorMessage);
288         uint256 c = a / b;
289         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
290 
291         return c;
292     }
293 
294     /**
295      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
296      * Reverts when dividing by zero.
297      *
298      * Counterpart to Solidity's `%` operator. This function uses a `revert`
299      * opcode (which leaves remaining gas untouched) while Solidity uses an
300      * invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
307         return mod(a, b, "SafeMath: modulo by zero");
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * Reverts with custom message when dividing by zero.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      *
320      * - The divisor cannot be zero.
321      */
322     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
323         require(b != 0, errorMessage);
324         return a % b;
325     }
326 }
327 
328 // File: contracts/libraries/DecFloat32.sol
329 
330 pragma solidity 0.6.12;
331 
332 /*
333 This library defines a decimal floating point number. It has 8 decimal significant digits. Its maximum value is 9.9999999e+15.
334 And its minimum value is 1.0e-16. The following golang code explains its detail implementation.
335 
336 func buildPrice(significant int, exponent int) uint32 {
337 	if !(10000000 <= significant && significant <= 99999999) {
338 		panic("Invalid significant")
339 	}
340 	if !(-16 <= exponent && exponent <= 15) {
341 		panic("Invalid exponent")
342 	}
343 	return uint32(((exponent+16)<<27)|significant);
344 }
345 
346 func priceToFloat(price uint32) float64 {
347 	exponent := int(price>>27)
348 	significant := float64(price&((1<<27)-1))
349 	return significant * math.Pow10(exponent-23)
350 }
351 
352 */
353 
354 // A price presented as a rational number
355 struct RatPrice {
356     uint numerator;   // at most 54bits
357     uint denominator; // at most 76bits
358 }
359 
360 library DecFloat32 {
361     uint32 public constant MANTISSA_MASK = (1<<27) - 1;
362     uint32 public constant MAX_MANTISSA = 9999_9999;
363     uint32 public constant MIN_MANTISSA = 1000_0000;
364     uint32 public constant MIN_PRICE = MIN_MANTISSA;
365     uint32 public constant MAX_PRICE = (31<<27)|MAX_MANTISSA;
366 
367     // 10 ** (i + 1)
368     function powSmall(uint32 i) internal pure returns (uint) {
369         uint x = 2695994666777834996822029817977685892750687677375768584125520488993233305610;
370         return (x >> (32*i)) & ((1<<32)-1);
371     }
372 
373     // 10 ** (i * 8)
374     function powBig(uint32 i) internal pure returns (uint) {
375         uint y = 3402823669209384634633746076162356521930955161600000001;
376         return (y >> (64*i)) & ((1<<64)-1);
377     }
378 
379     // if price32=( 0<<27)|12345678 then numerator=12345678 denominator=100000000000000000000000
380     // if price32=( 1<<27)|12345678 then numerator=12345678 denominator=10000000000000000000000
381     // if price32=( 2<<27)|12345678 then numerator=12345678 denominator=1000000000000000000000
382     // if price32=( 3<<27)|12345678 then numerator=12345678 denominator=100000000000000000000
383     // if price32=( 4<<27)|12345678 then numerator=12345678 denominator=10000000000000000000
384     // if price32=( 5<<27)|12345678 then numerator=12345678 denominator=1000000000000000000
385     // if price32=( 6<<27)|12345678 then numerator=12345678 denominator=100000000000000000
386     // if price32=( 7<<27)|12345678 then numerator=12345678 denominator=10000000000000000
387     // if price32=( 8<<27)|12345678 then numerator=12345678 denominator=1000000000000000
388     // if price32=( 9<<27)|12345678 then numerator=12345678 denominator=100000000000000
389     // if price32=(10<<27)|12345678 then numerator=12345678 denominator=10000000000000
390     // if price32=(11<<27)|12345678 then numerator=12345678 denominator=1000000000000
391     // if price32=(12<<27)|12345678 then numerator=12345678 denominator=100000000000
392     // if price32=(13<<27)|12345678 then numerator=12345678 denominator=10000000000
393     // if price32=(14<<27)|12345678 then numerator=12345678 denominator=1000000000
394     // if price32=(15<<27)|12345678 then numerator=12345678 denominator=100000000
395     // if price32=(16<<27)|12345678 then numerator=12345678 denominator=10000000
396     // if price32=(17<<27)|12345678 then numerator=12345678 denominator=1000000
397     // if price32=(18<<27)|12345678 then numerator=12345678 denominator=100000
398     // if price32=(19<<27)|12345678 then numerator=12345678 denominator=10000
399     // if price32=(20<<27)|12345678 then numerator=12345678 denominator=1000
400     // if price32=(21<<27)|12345678 then numerator=12345678 denominator=100
401     // if price32=(22<<27)|12345678 then numerator=12345678 denominator=10
402     // if price32=(23<<27)|12345678 then numerator=12345678 denominator=1
403     // if price32=(24<<27)|12345678 then numerator=123456780 denominator=1
404     // if price32=(25<<27)|12345678 then numerator=1234567800 denominator=1
405     // if price32=(26<<27)|12345678 then numerator=12345678000 denominator=1
406     // if price32=(27<<27)|12345678 then numerator=123456780000 denominator=1
407     // if price32=(28<<27)|12345678 then numerator=1234567800000 denominator=1
408     // if price32=(29<<27)|12345678 then numerator=12345678000000 denominator=1
409     // if price32=(30<<27)|12345678 then numerator=123456780000000 denominator=1
410     // if price32=(31<<27)|12345678 then numerator=1234567800000000 denominator=1
411     function expandPrice(uint32 price32) internal pure returns (RatPrice memory) {
412         uint s = price32&((1<<27)-1);
413         uint32 a = price32 >> 27;
414         RatPrice memory price;
415         if(a >= 24) {
416             uint32 b = a - 24;
417             price.numerator = s * powSmall(b);
418             price.denominator = 1;
419         } else if(a == 23) {
420             price.numerator = s;
421             price.denominator = 1;
422         } else {
423             uint32 b = 22 - a;
424             price.numerator = s;
425             price.denominator = powSmall(b&0x7) * powBig(b>>3);
426         }
427         return price;
428     }
429 
430     function getExpandPrice(uint price) internal pure returns(uint numerator, uint denominator) {
431         uint32 m = uint32(price) & MANTISSA_MASK;
432         require(MIN_MANTISSA <= m && m <= MAX_MANTISSA, "Invalid Price");
433         RatPrice memory actualPrice = expandPrice(uint32(price));
434         return (actualPrice.numerator, actualPrice.denominator);
435     }
436 
437 }
438 
439 // File: contracts/OneSwapRouter.sol
440 
441 pragma solidity 0.6.12;
442 
443 
444 
445 
446 
447 
448 
449 
450 contract OneSwapRouter is IOneSwapRouter {
451     using SafeMath256 for uint;
452     address public immutable override factory;
453 
454     modifier ensure(uint deadline) {
455         // solhint-disable-next-line not-rely-on-time,
456         require(deadline >= block.timestamp, "OneSwapRouter: EXPIRED");
457         _;
458     }
459 
460     constructor(address _factory) public {
461         factory = _factory;
462     }
463 
464     function _addLiquidity(address pair, uint amountStockDesired, uint amountMoneyDesired,
465         uint amountStockMin, uint amountMoneyMin) private view returns (uint amountStock, uint amountMoney) {
466 
467         (uint reserveStock, uint reserveMoney, ) = IOneSwapPool(pair).getReserves();
468         if (reserveStock == 0 && reserveMoney == 0) {
469             (amountStock, amountMoney) = (amountStockDesired, amountMoneyDesired);
470         } else {
471             uint amountMoneyOptimal = _quote(amountStockDesired, reserveStock, reserveMoney);
472             if (amountMoneyOptimal <= amountMoneyDesired) {
473                 require(amountMoneyOptimal >= amountMoneyMin, "OneSwapRouter: INSUFFICIENT_MONEY_AMOUNT");
474                 (amountStock, amountMoney) = (amountStockDesired, amountMoneyOptimal);
475             } else {
476                 uint amountStockOptimal = _quote(amountMoneyDesired, reserveMoney, reserveStock);
477                 assert(amountStockOptimal <= amountStockDesired);
478                 require(amountStockOptimal >= amountStockMin, "OneSwapRouter: INSUFFICIENT_STOCK_AMOUNT");
479                 (amountStock, amountMoney) = (amountStockOptimal, amountMoneyDesired);
480             }
481         }
482     }
483 
484     function addLiquidity(address stock, address money, bool isOnlySwap, uint amountStockDesired,
485         uint amountMoneyDesired, uint amountStockMin, uint amountMoneyMin, address to, uint deadline) external
486         payable override ensure(deadline) returns (uint amountStock, uint amountMoney, uint liquidity) {
487 
488         if (stock != address(0) && money != address(0)) {
489             require(msg.value == 0, 'OneSwapRouter: NOT_ENTER_ETH_VALUE');
490         }
491         address pair = IOneSwapFactory(factory).tokensToPair(stock, money, isOnlySwap);
492         if (pair == address(0)) {
493             pair = IOneSwapFactory(factory).createPair(stock, money, isOnlySwap);
494         }
495         (amountStock, amountMoney) = _addLiquidity(pair, amountStockDesired,
496             amountMoneyDesired, amountStockMin, amountMoneyMin);
497         _safeTransferFrom(stock, msg.sender, pair, amountStock);
498         _safeTransferFrom(money, msg.sender, pair, amountMoney);
499         liquidity = IOneSwapPool(pair).mint(to);
500         emit AddLiquidity(amountStock, amountMoney, liquidity);
501     }
502 
503     function _removeLiquidity(address pair, uint liquidity, uint amountStockMin,
504         uint amountMoneyMin, address to) private returns (uint amountStock, uint amountMoney) {
505         IERC20(pair).transferFrom(msg.sender, pair, liquidity);
506         (amountStock, amountMoney) = IOneSwapPool(pair).burn(to);
507         require(amountStock >= amountStockMin, "OneSwapRouter: INSUFFICIENT_STOCK_AMOUNT");
508         require(amountMoney >= amountMoneyMin, "OneSwapRouter: INSUFFICIENT_MONEY_AMOUNT");
509     }
510 
511     function removeLiquidity(address pair, uint liquidity, uint amountStockMin, uint amountMoneyMin,
512         address to, uint deadline) external override ensure(deadline) returns (uint amountStock, uint amountMoney) {
513         // ensure pair exist
514         _getTokensFromPair(pair);
515         (amountStock, amountMoney) = _removeLiquidity(pair, liquidity, amountStockMin, amountMoneyMin, to);
516     }
517 
518     function _swap(address input, uint amountIn, address[] memory path, address _to) internal virtual returns (uint[] memory amounts) {
519         amounts = new uint[](path.length + 1);
520         amounts[0] = amountIn;
521 
522         for (uint i = 0; i < path.length; i++) {
523             (address to, bool isLastSwap) = i < path.length - 1 ? (path[i+1], false) : (_to, true);
524             amounts[i + 1] = IOneSwapPair(path[i]).addMarketOrder(input, to, uint112(amounts[i]));
525             if (!isLastSwap) {
526                 (address stock, address money) = _getTokensFromPair(path[i]);
527                 input = (stock != input) ? stock : money;
528             }
529         }
530     }
531 
532     function swapToken(address token, uint amountIn, uint amountOutMin, address[] calldata path,
533         address to, uint deadline) external payable override ensure(deadline) returns (uint[] memory amounts) {
534 
535         if (token != address(0)) { require(msg.value == 0, 'OneSwapRouter: NOT_ENTER_ETH_VALUE'); }
536         require(path.length >= 1, "OneSwapRouter: INVALID_PATH");
537         // ensure pair exist
538         _getTokensFromPair(path[0]);
539         _safeTransferFrom(token, msg.sender, path[0], amountIn);
540         amounts = _swap(token, amountIn, path, to);
541         require(amounts[path.length] >= amountOutMin, "OneSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
542     }
543 
544     function limitOrder(bool isBuy, address pair, uint prevKey, uint price, uint32 id,
545         uint stockAmount, uint deadline) external payable override ensure(deadline) {
546 
547         (address stock, address money) = _getTokensFromPair(pair);
548         {
549             (uint _stockAmount, uint _moneyAmount) = IOneSwapPair(pair).calcStockAndMoney(uint64(stockAmount), uint32(price));
550             if (isBuy) {
551                 if (money != address(0)) { require(msg.value == 0, 'OneSwapRouter: NOT_ENTER_ETH_VALUE'); }
552                 _safeTransferFrom(money, msg.sender, pair, _moneyAmount);
553             } else {
554                 if (stock != address(0)) { require(msg.value == 0, 'OneSwapRouter: NOT_ENTER_ETH_VALUE'); }
555                 _safeTransferFrom(stock, msg.sender, pair, _stockAmount);
556             }
557         }
558         IOneSwapPair(pair).addLimitOrder(isBuy, msg.sender, uint64(stockAmount), uint32(price), id, uint72(prevKey));
559     }
560 
561     // todo. add encoded bytes interface for limitOrder.
562 
563     function _safeTransferFrom(address token, address from, address to, uint value) internal {
564         if (token == address(0)) {
565             _safeTransferETH(to, value);
566             uint inputValue = msg.value;
567             if (inputValue > value) { _safeTransferETH(msg.sender, inputValue - value); }
568             return;
569         }
570 
571         uint beforeAmount = IERC20(token).balanceOf(to);
572         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
573         // solhint-disable-next-line avoid-low-level-calls
574         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
575         require(success && (data.length == 0 || abi.decode(data, (bool))), "OneSwapRouter: TRANSFER_FROM_FAILED");
576         uint afterAmount = IERC20(token).balanceOf(to);
577         require(afterAmount == beforeAmount + value, "OneSwapRouter: TRANSFER_FAILED");
578     }
579 
580     function _safeTransferETH(address to, uint value) internal {
581         // solhint-disable-next-line avoid-low-level-calls
582         (bool success,) = to.call{value:value}(new bytes(0));
583         require(success, "TransferHelper: ETH_TRANSFER_FAILED");
584     }
585 
586     function _quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
587         require(amountA > 0, "OneSwapRouter: INSUFFICIENT_AMOUNT");
588         require(reserveA > 0 && reserveB > 0, "OneSwapRouter: INSUFFICIENT_LIQUIDITY");
589         amountB = amountA.mul(reserveB) / reserveA;
590     }
591 
592     function _getTokensFromPair(address pair) internal view returns(address stock, address money) {
593         (stock, money) = IOneSwapFactory(factory).getTokensFromPair(pair);
594         require(stock != address(0) || money != address(0), "OneSwapRouter: PAIR_NOT_EXIST");
595     }
596 }