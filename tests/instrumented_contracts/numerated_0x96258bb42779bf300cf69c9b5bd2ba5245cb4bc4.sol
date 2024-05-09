1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 pragma solidity ^0.6.0;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 // File: contracts/uniswapv2/UniswapV2ERC20.sol
242 
243 pragma solidity =0.6.12;
244 
245 
246 contract UniswapV2ERC20 {
247     using SafeMath for uint;
248 
249     string public constant name = 'LuaSwap LP Token V1';
250     string public constant symbol = 'LUA-V1';
251     uint8 public constant decimals = 18;
252     uint  public totalSupply;
253     mapping(address => uint) public balanceOf;
254     mapping(address => mapping(address => uint)) public allowance;
255 
256     bytes32 public DOMAIN_SEPARATOR;
257     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
258     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
259     mapping(address => uint) public nonces;
260 
261     event Approval(address indexed owner, address indexed spender, uint value);
262     event Transfer(address indexed from, address indexed to, uint value);
263 
264     constructor() public {
265         uint chainId;
266         assembly {
267             chainId := chainid()
268         }
269         DOMAIN_SEPARATOR = keccak256(
270             abi.encode(
271                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
272                 keccak256(bytes(name)),
273                 keccak256(bytes('1')),
274                 chainId,
275                 address(this)
276             )
277         );
278     }
279 
280     function _mint(address to, uint value) internal {
281         totalSupply = totalSupply.add(value);
282         balanceOf[to] = balanceOf[to].add(value);
283         emit Transfer(address(0), to, value);
284     }
285 
286     function _burn(address from, uint value) internal {
287         balanceOf[from] = balanceOf[from].sub(value);
288         totalSupply = totalSupply.sub(value);
289         emit Transfer(from, address(0), value);
290     }
291 
292     function _approve(address owner, address spender, uint value) private {
293         allowance[owner][spender] = value;
294         emit Approval(owner, spender, value);
295     }
296 
297     function _transfer(address from, address to, uint value) private {
298         balanceOf[from] = balanceOf[from].sub(value);
299         balanceOf[to] = balanceOf[to].add(value);
300         emit Transfer(from, to, value);
301     }
302 
303     function approve(address spender, uint value) external returns (bool) {
304         _approve(msg.sender, spender, value);
305         return true;
306     }
307 
308     function transfer(address to, uint value) external returns (bool) {
309         _transfer(msg.sender, to, value);
310         return true;
311     }
312 
313     function transferFrom(address from, address to, uint value) external returns (bool) {
314         if (allowance[from][msg.sender] != uint(-1)) {
315             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
316         }
317         _transfer(from, to, value);
318         return true;
319     }
320 
321     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
322         require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
323         bytes32 digest = keccak256(
324             abi.encodePacked(
325                 '\x19\x01',
326                 DOMAIN_SEPARATOR,
327                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
328             )
329         );
330         address recoveredAddress = ecrecover(digest, v, r, s);
331         require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
332         _approve(owner, spender, value);
333     }
334 }
335 
336 // File: contracts/uniswapv2/libraries/Math.sol
337 
338 pragma solidity =0.6.12;
339 
340 // a library for performing various math operations
341 
342 library Math {
343     function min(uint x, uint y) internal pure returns (uint z) {
344         z = x < y ? x : y;
345     }
346 
347     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
348     function sqrt(uint y) internal pure returns (uint z) {
349         if (y > 3) {
350             z = y;
351             uint x = y / 2 + 1;
352             while (x < z) {
353                 z = x;
354                 x = (y / x + x) / 2;
355             }
356         } else if (y != 0) {
357             z = 1;
358         }
359     }
360 }
361 
362 // File: contracts/uniswapv2/libraries/UQ112x112.sol
363 
364 pragma solidity =0.6.12;
365 
366 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
367 
368 // range: [0, 2**112 - 1]
369 // resolution: 1 / 2**112
370 
371 library UQ112x112 {
372     uint224 constant Q112 = 2**112;
373 
374     // encode a uint112 as a UQ112x112
375     function encode(uint112 y) internal pure returns (uint224 z) {
376         z = uint224(y) * Q112; // never overflows
377     }
378 
379     // divide a UQ112x112 by a uint112, returning a UQ112x112
380     function uqdiv(uint224 x, uint112 y) internal pure returns (uint224 z) {
381         z = x / uint224(y);
382     }
383 }
384 
385 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
386 
387 pragma solidity >=0.5.0;
388 
389 interface IUniswapV2Factory {
390     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
391 
392     function feeTo() external view returns (address);
393     function withdrawFeeTo() external view returns (address);
394     function swapFee() external view returns (uint);
395     function withdrawFee() external view returns (uint);
396     
397     function feeSetter() external view returns (address);
398     function migrator() external view returns (address);
399 
400     function getPair(address tokenA, address tokenB) external view returns (address pair);
401     function allPairs(uint) external view returns (address pair);
402     function allPairsLength() external view returns (uint);
403 
404     function createPair(address tokenA, address tokenB) external returns (address pair);
405 
406     function setFeeTo(address) external;
407     function setWithdrawFeeTo(address) external;
408     function setSwapFee(uint) external;
409     function setFeeSetter(address) external;
410     function setMigrator(address) external;
411 }
412 
413 // File: contracts/uniswapv2/interfaces/IUniswapV2Callee.sol
414 
415 pragma solidity >=0.5.0;
416 
417 interface IUniswapV2Callee {
418     function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
419 }
420 
421 // File: contracts/uniswapv2/UniswapV2Pair.sol
422 
423 pragma solidity =0.6.12;
424 
425 
426 
427 
428 
429 
430 
431 
432 
433 interface IMigrator {
434     // Return the desired amount of liquidity token that the migrator wants.
435     function desiredLiquidity() external view returns (uint256);
436 }
437 
438 contract UniswapV2Pair is UniswapV2ERC20 {
439     using SafeMath  for uint;
440     using UQ112x112 for uint224;
441 
442     uint public constant MINIMUM_LIQUIDITY = 10**3;
443     bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
444 
445     address public factory;
446     address public token0;
447     address public token1;
448 
449     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
450     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
451     uint32  private blockTimestampLast; // uses single storage slot, accessible via getReserves
452 
453     uint public price0CumulativeLast;
454     uint public price1CumulativeLast;
455     uint public kLast; // reserve0 * reserve1, as of immediately after the most recent liquidity event
456 
457     uint private unlocked = 1;
458     modifier lock() {
459         require(unlocked == 1, 'UniswapV2: LOCKED');
460         unlocked = 0;
461         _;
462         unlocked = 1;
463     }
464 
465     function getReserves() public view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast) {
466         _reserve0 = reserve0;
467         _reserve1 = reserve1;
468         _blockTimestampLast = blockTimestampLast;
469     }
470 
471     function _safeTransfer(address token, address to, uint value) private {
472         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
473         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
474     }
475 
476     event Mint(address indexed sender, uint amount0, uint amount1);
477     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
478     event Swap(
479         address indexed sender,
480         uint amount0In,
481         uint amount1In,
482         uint amount0Out,
483         uint amount1Out,
484         address indexed to
485     );
486     event Sync(uint112 reserve0, uint112 reserve1);
487 
488     constructor() public {
489         factory = msg.sender;
490     }
491 
492     // called once by the factory at time of deployment
493     function initialize(address _token0, address _token1) external {
494         require(msg.sender == factory, 'UniswapV2: FORBIDDEN'); // sufficient check
495         token0 = _token0;
496         token1 = _token1;
497     }
498 
499     // update reserves and, on the first call per block, price accumulators
500     function _update(uint balance0, uint balance1, uint112 _reserve0, uint112 _reserve1) private {
501         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), 'UniswapV2: OVERFLOW');
502         uint32 blockTimestamp = uint32(block.timestamp % 2**32);
503         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
504         if (timeElapsed > 0 && _reserve0 != 0 && _reserve1 != 0) {
505             // * never overflows, and + overflow is desired
506             price0CumulativeLast += uint(UQ112x112.encode(_reserve1).uqdiv(_reserve0)) * timeElapsed;
507             price1CumulativeLast += uint(UQ112x112.encode(_reserve0).uqdiv(_reserve1)) * timeElapsed;
508         }
509         reserve0 = uint112(balance0);
510         reserve1 = uint112(balance1);
511         blockTimestampLast = blockTimestamp;
512         emit Sync(reserve0, reserve1);
513     }
514 
515     // if fee is on, mint liquidity equivalent to 1/6th of the growth in sqrt(k)
516     function _mintFee(uint112 _reserve0, uint112 _reserve1) private returns (bool feeOn) {
517         address feeTo = IUniswapV2Factory(factory).feeTo();
518         uint fee = IUniswapV2Factory(factory).swapFee();
519         feeOn = feeTo != address(0);
520         uint _kLast = kLast; // gas savings
521         if (feeOn) {
522             if (_kLast != 0) {
523                 uint rootK = Math.sqrt(uint(_reserve0).mul(_reserve1));
524                 uint rootKLast = Math.sqrt(_kLast);
525                 if (rootK > rootKLast) {
526                     uint numerator = totalSupply.mul(rootK.sub(rootKLast));
527                     uint denominator = rootK.mul(fee * 2 - 1).add(rootKLast);
528                     uint liquidity = numerator / denominator;
529                     if (liquidity > 0) _mint(feeTo, liquidity);
530                 }
531             }
532         } else if (_kLast != 0) {
533             kLast = 0;
534         }
535     }
536 
537     function _chargeWithdrawFee(uint liquidity) private returns (uint returnLiquidity) {
538         address withdrawFeeTo = IUniswapV2Factory(factory).withdrawFeeTo();
539         uint withdrawFee = IUniswapV2Factory(factory).withdrawFee();
540         if (withdrawFeeTo != address(0)) {
541             uint fee = liquidity.mul(withdrawFee).div(1000);
542             _safeTransfer(address(this), withdrawFeeTo, fee);
543             returnLiquidity = liquidity.sub(fee);
544         }
545         else {
546             returnLiquidity = liquidity;
547         }
548     }
549 
550     // this low-level function should be called from a contract which performs important safety checks
551     function mint(address to) external lock returns (uint liquidity) {
552         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
553         uint balance0 = IERC20(token0).balanceOf(address(this));
554         uint balance1 = IERC20(token1).balanceOf(address(this));
555         uint amount0 = balance0.sub(_reserve0);
556         uint amount1 = balance1.sub(_reserve1);
557 
558         bool feeOn = _mintFee(_reserve0, _reserve1);
559         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
560         if (_totalSupply == 0) {
561             address migrator = IUniswapV2Factory(factory).migrator();
562             if (msg.sender == migrator) {
563                 liquidity = IMigrator(migrator).desiredLiquidity();
564                 require(liquidity > 0 && liquidity != uint256(-1), "Bad desired liquidity");
565             } else {
566                 require(migrator == address(0), "Must not have migrator");
567                 liquidity = Math.sqrt(amount0.mul(amount1)).sub(MINIMUM_LIQUIDITY);
568                 _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
569             }
570         } else {
571             liquidity = Math.min(amount0.mul(_totalSupply) / _reserve0, amount1.mul(_totalSupply) / _reserve1);
572         }
573         require(liquidity > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_MINTED');
574         _mint(to, liquidity);
575 
576         _update(balance0, balance1, _reserve0, _reserve1);
577         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
578         emit Mint(msg.sender, amount0, amount1);
579     }
580 
581     // this low-level function should be called from a contract which performs important safety checks
582     function burn(address to) external lock returns (uint amount0, uint amount1) {
583         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
584         address _token0 = token0;                                // gas savings
585         address _token1 = token1;                                // gas savings
586         uint balance0 = IERC20(_token0).balanceOf(address(this));
587         uint balance1 = IERC20(_token1).balanceOf(address(this));
588         uint liquidity = balanceOf[address(this)];
589         
590         address migrator = IUniswapV2Factory(factory).migrator();
591         if (msg.sender != migrator) {
592             liquidity = _chargeWithdrawFee(liquidity);
593         }
594 
595         bool feeOn = _mintFee(_reserve0, _reserve1);
596         uint _totalSupply = totalSupply; // gas savings, must be defined here since totalSupply can update in _mintFee
597         amount0 = liquidity.mul(balance0) / _totalSupply; // using balances ensures pro-rata distribution
598         amount1 = liquidity.mul(balance1) / _totalSupply; // using balances ensures pro-rata distribution
599         require(amount0 > 0 && amount1 > 0, 'UniswapV2: INSUFFICIENT_LIQUIDITY_BURNED');
600         _burn(address(this), liquidity);
601         _safeTransfer(_token0, to, amount0);
602         _safeTransfer(_token1, to, amount1);
603         balance0 = IERC20(_token0).balanceOf(address(this));
604         balance1 = IERC20(_token1).balanceOf(address(this));
605 
606         _update(balance0, balance1, _reserve0, _reserve1);
607         if (feeOn) kLast = uint(reserve0).mul(reserve1); // reserve0 and reserve1 are up-to-date
608         emit Burn(msg.sender, amount0, amount1, to);
609     }
610 
611     // this low-level function should be called from a contract which performs important safety checks
612     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external lock {
613         require(amount0Out > 0 || amount1Out > 0, 'UniswapV2: INSUFFICIENT_OUTPUT_AMOUNT');
614         (uint112 _reserve0, uint112 _reserve1,) = getReserves(); // gas savings
615         require(amount0Out < _reserve0 && amount1Out < _reserve1, 'UniswapV2: INSUFFICIENT_LIQUIDITY');
616 
617         uint balance0;
618         uint balance1;
619         { // scope for _token{0,1}, avoids stack too deep errors
620         address _token0 = token0;
621         address _token1 = token1;
622         require(to != _token0 && to != _token1, 'UniswapV2: INVALID_TO');
623         if (amount0Out > 0) _safeTransfer(_token0, to, amount0Out); // optimistically transfer tokens
624         if (amount1Out > 0) _safeTransfer(_token1, to, amount1Out); // optimistically transfer tokens
625         if (data.length > 0) IUniswapV2Callee(to).uniswapV2Call(msg.sender, amount0Out, amount1Out, data);
626         balance0 = IERC20(_token0).balanceOf(address(this));
627         balance1 = IERC20(_token1).balanceOf(address(this));
628         }
629         uint amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
630         uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
631         require(amount0In > 0 || amount1In > 0, 'UniswapV2: INSUFFICIENT_INPUT_AMOUNT');
632         { // scope for reserve{0,1}Adjusted, avoids stack too deep errors
633         uint fee = IUniswapV2Factory(factory).swapFee();
634         uint balance0Adjusted = balance0.mul(1000).sub(amount0In.mul(fee));
635         uint balance1Adjusted = balance1.mul(1000).sub(amount1In.mul(fee));
636         require(balance0Adjusted.mul(balance1Adjusted) >= uint(_reserve0).mul(_reserve1).mul(1000**2), 'UniswapV2: K');
637         }
638 
639         _update(balance0, balance1, _reserve0, _reserve1);
640         emit Swap(msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
641     }
642 
643     // force balances to match reserves
644     function skim(address to) external lock {
645         address _token0 = token0; // gas savings
646         address _token1 = token1; // gas savings
647         _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
648         _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
649     }
650 
651     // force reserves to match balances
652     function sync() external lock {
653         _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)), reserve0, reserve1);
654     }
655 }