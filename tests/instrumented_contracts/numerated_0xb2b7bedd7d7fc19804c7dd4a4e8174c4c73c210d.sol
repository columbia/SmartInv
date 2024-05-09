1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 /**
4 
5 Author: CoFiX Core, https://cofix.io
6 Commit hash: v0.9.5-1-g7141c43
7 Repository: https://github.com/Computable-Finance/CoFiX
8 Issues: https://github.com/Computable-Finance/CoFiX/issues
9 
10 */
11 
12 pragma experimental ABIEncoderV2;
13 pragma solidity 0.6.12;
14 
15 
16 // 
17 interface ICoFiXERC20 {
18     event Approval(address indexed owner, address indexed spender, uint value);
19     event Transfer(address indexed from, address indexed to, uint value);
20 
21     // function name() external pure returns (string memory);
22     // function symbol() external pure returns (string memory);
23     function decimals() external pure returns (uint8);
24     function totalSupply() external view returns (uint);
25     function balanceOf(address owner) external view returns (uint);
26     function allowance(address owner, address spender) external view returns (uint);
27 
28     function approve(address spender, uint value) external returns (bool);
29     function transfer(address to, uint value) external returns (bool);
30     function transferFrom(address from, address to, uint value) external returns (bool);
31 
32     function DOMAIN_SEPARATOR() external view returns (bytes32);
33     function PERMIT_TYPEHASH() external pure returns (bytes32);
34     function nonces(address owner) external view returns (uint);
35 
36     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
37 }
38 
39 // 
40 interface ICoFiXPair is ICoFiXERC20 {
41 
42     struct OraclePrice {
43         uint256 ethAmount;
44         uint256 erc20Amount;
45         uint256 blockNum;
46         uint256 K;
47         uint256 theta;
48     }
49 
50     // All pairs: {ETH <-> ERC20 Token}
51     event Mint(address indexed sender, uint amount0, uint amount1);
52     event Burn(address indexed sender, address outToken, uint outAmount, address indexed to);
53     event Swap(
54         address indexed sender,
55         uint amountIn,
56         uint amountOut,
57         address outToken,
58         address indexed to
59     );
60     event Sync(uint112 reserve0, uint112 reserve1);
61 
62     function MINIMUM_LIQUIDITY() external pure returns (uint);
63     function factory() external view returns (address);
64     function token0() external view returns (address);
65     function token1() external view returns (address);
66     function getReserves() external view returns (uint112 reserve0, uint112 reserve1);
67 
68     function mint(address to) external payable returns (uint liquidity, uint oracleFeeChange);
69     function burn(address outToken, address to) external payable returns (uint amountOut, uint oracleFeeChange);
70     function swapWithExact(address outToken, address to) external payable returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo);
71     function swapForExact(address outToken, uint amountOutExact, address to) external payable returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo);
72     function skim(address to) external;
73     function sync() external;
74 
75     function initialize(address, address, string memory, string memory) external;
76 
77     /// @dev get Net Asset Value Per Share
78     /// @param  ethAmount ETH side of Oracle price {ETH <-> ERC20 Token}
79     /// @param  erc20Amount Token side of Oracle price {ETH <-> ERC20 Token}
80     /// @return navps The Net Asset Value Per Share (liquidity) represents
81     function getNAVPerShare(uint256 ethAmount, uint256 erc20Amount) external view returns (uint256 navps);
82 }
83 
84 // 
85 interface ICoFiXFactory {
86     // All pairs: {ETH <-> ERC20 Token}
87     event PairCreated(address indexed token, address pair, uint256);
88     event NewGovernance(address _new);
89     event NewController(address _new);
90     event NewFeeReceiver(address _new);
91     event NewFeeVaultForLP(address token, address feeVault);
92     event NewVaultForLP(address _new);
93     event NewVaultForTrader(address _new);
94     event NewVaultForCNode(address _new);
95 
96     /// @dev Create a new token pair for trading
97     /// @param  token the address of token to trade
98     /// @return pair the address of new token pair
99     function createPair(
100         address token
101         )
102         external
103         returns (address pair);
104 
105     function getPair(address token) external view returns (address pair);
106     function allPairs(uint256) external view returns (address pair);
107     function allPairsLength() external view returns (uint256);
108 
109     function getTradeMiningStatus(address token) external view returns (bool status);
110     function setTradeMiningStatus(address token, bool status) external;
111     function getFeeVaultForLP(address token) external view returns (address feeVault); // for LPs
112     function setFeeVaultForLP(address token, address feeVault) external;
113 
114     function setGovernance(address _new) external;
115     function setController(address _new) external;
116     function setFeeReceiver(address _new) external;
117     function setVaultForLP(address _new) external;
118     function setVaultForTrader(address _new) external;
119     function setVaultForCNode(address _new) external;
120     function getController() external view returns (address controller);
121     function getFeeReceiver() external view returns (address feeReceiver); // For CoFi Holders
122     function getVaultForLP() external view returns (address vaultForLP);
123     function getVaultForTrader() external view returns (address vaultForTrader);
124     function getVaultForCNode() external view returns (address vaultForCNode);
125 }
126 
127 // 
128 interface ICoFiXController {
129 
130     event NewK(address token, int128 K, int128 sigma, uint256 T, uint256 ethAmount, uint256 erc20Amount, uint256 blockNum, uint256 tIdx, uint256 sigmaIdx, int128 K0);
131     event NewGovernance(address _new);
132     event NewOracle(address _priceOracle);
133     event NewKTable(address _kTable);
134     event NewTimespan(uint256 _timeSpan);
135     event NewKRefreshInterval(uint256 _interval);
136     event NewKLimit(int128 maxK0);
137     event NewGamma(int128 _gamma);
138     event NewTheta(address token, uint32 theta);
139 
140     function addCaller(address caller) external;
141 
142     function queryOracle(address token, uint8 op, bytes memory data) external payable returns (uint256 k, uint256 ethAmount, uint256 erc20Amount, uint256 blockNum, uint256 theta);
143 }
144 
145 // 
146 /**
147  * @dev Interface of the ERC20 standard as defined in the EIP.
148  */
149 interface IERC20 {
150     /**
151      * @dev Returns the amount of tokens in existence.
152      */
153     function totalSupply() external view returns (uint256);
154 
155     /**
156      * @dev Returns the amount of tokens owned by `account`.
157      */
158     function balanceOf(address account) external view returns (uint256);
159 
160     /**
161      * @dev Moves `amount` tokens from the caller's account to `recipient`.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transfer(address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Returns the remaining number of tokens that `spender` will be
171      * allowed to spend on behalf of `owner` through {transferFrom}. This is
172      * zero by default.
173      *
174      * This value changes when {approve} or {transferFrom} are called.
175      */
176     function allowance(address owner, address spender) external view returns (uint256);
177 
178     /**
179      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * IMPORTANT: Beware that changing an allowance with this method brings the risk
184      * that someone may use both the old and the new allowance by unfortunate
185      * transaction ordering. One possible solution to mitigate this race
186      * condition is to first reduce the spender's allowance to 0 and set the
187      * desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      *
190      * Emits an {Approval} event.
191      */
192     function approve(address spender, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Moves `amount` tokens from `sender` to `recipient` using the
196      * allowance mechanism. `amount` is then deducted from the caller's
197      * allowance.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Emitted when `value` tokens are moved from one account (`from`) to
207      * another (`to`).
208      *
209      * Note that `value` may be zero.
210      */
211     event Transfer(address indexed from, address indexed to, uint256 value);
212 
213     /**
214      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
215      * a call to {approve}. `value` is the new allowance.
216      */
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 // 
221 /**
222  * @dev Wrappers over Solidity's arithmetic operations with added overflow
223  * checks.
224  *
225  * Arithmetic operations in Solidity wrap on overflow. This can easily result
226  * in bugs, because programmers usually assume that an overflow raises an
227  * error, which is the standard behavior in high level programming languages.
228  * `SafeMath` restores this intuition by reverting the transaction when an
229  * operation overflows.
230  *
231  * Using this library instead of the unchecked operations eliminates an entire
232  * class of bugs, so it's recommended to use it always.
233  */
234 library SafeMath {
235     /**
236      * @dev Returns the addition of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `+` operator.
240      *
241      * Requirements:
242      *
243      * - Addition cannot overflow.
244      */
245     function add(uint256 a, uint256 b) internal pure returns (uint256) {
246         uint256 c = a + b;
247         require(c >= a, "SafeMath: addition overflow");
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the subtraction of two unsigned integers, reverting on
254      * overflow (when the result is negative).
255      *
256      * Counterpart to Solidity's `-` operator.
257      *
258      * Requirements:
259      *
260      * - Subtraction cannot overflow.
261      */
262     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263         return sub(a, b, "SafeMath: subtraction overflow");
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * Counterpart to Solidity's `-` operator.
271      *
272      * Requirements:
273      *
274      * - Subtraction cannot overflow.
275      */
276     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b <= a, errorMessage);
278         uint256 c = a - b;
279 
280         return c;
281     }
282 
283     /**
284      * @dev Returns the multiplication of two unsigned integers, reverting on
285      * overflow.
286      *
287      * Counterpart to Solidity's `*` operator.
288      *
289      * Requirements:
290      *
291      * - Multiplication cannot overflow.
292      */
293     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
294         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
295         // benefit is lost if 'b' is also tested.
296         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
297         if (a == 0) {
298             return 0;
299         }
300 
301         uint256 c = a * b;
302         require(c / a == b, "SafeMath: multiplication overflow");
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the integer division of two unsigned integers. Reverts on
309      * division by zero. The result is rounded towards zero.
310      *
311      * Counterpart to Solidity's `/` operator. Note: this function uses a
312      * `revert` opcode (which leaves remaining gas untouched) while Solidity
313      * uses an invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function div(uint256 a, uint256 b) internal pure returns (uint256) {
320         return div(a, b, "SafeMath: division by zero");
321     }
322 
323     /**
324      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
325      * division by zero. The result is rounded towards zero.
326      *
327      * Counterpart to Solidity's `/` operator. Note: this function uses a
328      * `revert` opcode (which leaves remaining gas untouched) while Solidity
329      * uses an invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         require(b > 0, errorMessage);
337         uint256 c = a / b;
338         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
339 
340         return c;
341     }
342 
343     /**
344      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
345      * Reverts when dividing by zero.
346      *
347      * Counterpart to Solidity's `%` operator. This function uses a `revert`
348      * opcode (which leaves remaining gas untouched) while Solidity uses an
349      * invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      *
353      * - The divisor cannot be zero.
354      */
355     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
356         return mod(a, b, "SafeMath: modulo by zero");
357     }
358 
359     /**
360      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
361      * Reverts with custom message when dividing by zero.
362      *
363      * Counterpart to Solidity's `%` operator. This function uses a `revert`
364      * opcode (which leaves remaining gas untouched) while Solidity uses an
365      * invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372         require(b != 0, errorMessage);
373         return a % b;
374     }
375 }
376 
377 // 
378 // ERC20 token implementation, inherited by CoFiXPair contract, no owner or governance
379 contract CoFiXERC20 is ICoFiXERC20 {
380     using SafeMath for uint;
381 
382     string public constant nameForDomain = 'CoFiX Pool Token';
383     uint8 public override constant decimals = 18;
384     uint  public override totalSupply;
385     mapping(address => uint) public override balanceOf;
386     mapping(address => mapping(address => uint)) public override allowance;
387 
388     bytes32 public override DOMAIN_SEPARATOR;
389     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
390     bytes32 public override constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
391     mapping(address => uint) public override nonces;
392 
393     event Approval(address indexed owner, address indexed spender, uint value);
394     event Transfer(address indexed from, address indexed to, uint value);
395 
396     constructor() public {
397         uint chainId;
398         assembly {
399             chainId := chainid()
400         }
401         DOMAIN_SEPARATOR = keccak256(
402             abi.encode(
403                 keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
404                 keccak256(bytes(nameForDomain)),
405                 keccak256(bytes('1')),
406                 chainId,
407                 address(this)
408             )
409         );
410     }
411 
412     function _mint(address to, uint value) internal {
413         totalSupply = totalSupply.add(value);
414         balanceOf[to] = balanceOf[to].add(value);
415         emit Transfer(address(0), to, value);
416     }
417 
418     function _burn(address from, uint value) internal {
419         balanceOf[from] = balanceOf[from].sub(value);
420         totalSupply = totalSupply.sub(value);
421         emit Transfer(from, address(0), value);
422     }
423 
424     function _approve(address owner, address spender, uint value) private {
425         allowance[owner][spender] = value;
426         emit Approval(owner, spender, value);
427     }
428 
429     function _transfer(address from, address to, uint value) private {
430         balanceOf[from] = balanceOf[from].sub(value);
431         balanceOf[to] = balanceOf[to].add(value);
432         emit Transfer(from, to, value);
433     }
434 
435     function approve(address spender, uint value) external override returns (bool) {
436         _approve(msg.sender, spender, value);
437         return true;
438     }
439 
440     function transfer(address to, uint value) external override returns (bool) {
441         _transfer(msg.sender, to, value);
442         return true;
443     }
444 
445     function transferFrom(address from, address to, uint value) external override returns (bool) {
446         if (allowance[from][msg.sender] != uint(-1)) {
447             allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
448         }
449         _transfer(from, to, value);
450         return true;
451     }
452 
453     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external override {
454         require(deadline >= block.timestamp, 'CERC20: EXPIRED');
455         bytes32 digest = keccak256(
456             abi.encodePacked(
457                 '\x19\x01',
458                 DOMAIN_SEPARATOR,
459                 keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
460             )
461         );
462         address recoveredAddress = ecrecover(digest, v, r, s);
463         require(recoveredAddress != address(0) && recoveredAddress == owner, 'CERC20: INVALID_SIGNATURE');
464         _approve(owner, spender, value);
465     }
466 }
467 
468 // 
469 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
470 library TransferHelper {
471     function safeApprove(address token, address to, uint value) internal {
472         // bytes4(keccak256(bytes('approve(address,uint256)')));
473         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
474         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
475     }
476 
477     function safeTransfer(address token, address to, uint value) internal {
478         // bytes4(keccak256(bytes('transfer(address,uint256)')));
479         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
480         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
481     }
482 
483     function safeTransferFrom(address token, address from, address to, uint value) internal {
484         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
485         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
486         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
487     }
488 
489     function safeTransferETH(address to, uint value) internal {
490         (bool success,) = to.call{value:value}(new bytes(0));
491         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
492     }
493 }
494 
495 // 
496 // Pair contract for each trading pair, storing assets and handling settlement
497 // No owner or governance
498 contract CoFiXPair is ICoFiXPair, CoFiXERC20 {
499     using SafeMath for uint;
500 
501     enum CoFiX_OP { QUERY, MINT, BURN, SWAP_WITH_EXACT, SWAP_FOR_EXACT } // operations in CoFiX
502 
503     uint public override constant MINIMUM_LIQUIDITY = 10**9; // it's negligible because we calc liquidity in ETH
504     bytes4 private constant SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
505 
506     uint256 constant public K_BASE = 1E8; // K
507     uint256 constant public NAVPS_BASE = 1E18; // NAVPS (Net Asset Value Per Share), need accuracy
508     uint256 constant public THETA_BASE = 1E8; // theta
509 
510     string public name;
511     string public symbol;
512 
513     address public override immutable factory;
514     address public override token0; // WETH token
515     address public override token1; // any ERC20 token
516 
517     uint112 private reserve0;           // uses single storage slot, accessible via getReserves
518     uint112 private reserve1;           // uses single storage slot, accessible via getReserves
519 
520     uint private unlocked = 1;
521 
522     event Mint(address indexed sender, uint amount0, uint amount1);
523     event Burn(address indexed sender, address outToken, uint outAmount, address indexed to);
524     event Swap(
525         address indexed sender,
526         uint amountIn,
527         uint amountOut,
528         address outToken,
529         address indexed to
530     );
531     event Sync(uint112 reserve0, uint112 reserve1);
532 
533     modifier lock() {
534         require(unlocked == 1, "CPair: LOCKED");
535         unlocked = 0;
536         _;
537         unlocked = 1;
538     }
539 
540     constructor() public {
541         factory = msg.sender;
542     }
543 
544     receive() external payable {}
545 
546     // called once by the factory at time of deployment
547     function initialize(address _token0, address _token1, string memory _name, string memory _symbol) external override {
548         require(msg.sender == factory, "CPair: FORBIDDEN"); // sufficient check
549         token0 = _token0;
550         token1 = _token1;
551         name = _name;
552         symbol = _symbol;
553     }
554 
555     function getReserves() public override view returns (uint112 _reserve0, uint112 _reserve1) {
556         _reserve0 = reserve0;
557         _reserve1 = reserve1;
558     }
559 
560     function _safeTransfer(address token, address to, uint value) private {
561         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
562         require(success && (data.length == 0 || abi.decode(data, (bool))), "CPair: TRANSFER_FAILED");
563     }
564 
565     // update reserves
566     function _update(uint balance0, uint balance1) private {
567         require(balance0 <= uint112(-1) && balance1 <= uint112(-1), "CPair: OVERFLOW");
568         reserve0 = uint112(balance0);
569         reserve1 = uint112(balance1);
570         emit Sync(reserve0, reserve1);
571     }
572 
573     // this low-level function should be called from a contract which performs important safety checks
574     function mint(address to) external payable override lock returns (uint liquidity, uint oracleFeeChange) {
575         address _token0 = token0;                                // gas savings
576         address _token1 = token1;                                // gas savings
577         (uint112 _reserve0, uint112 _reserve1) = getReserves(); // gas savings
578         uint balance0 = IERC20(_token0).balanceOf(address(this));
579         uint balance1 = IERC20(_token1).balanceOf(address(this));
580         uint amount0 = balance0.sub(_reserve0);
581         uint amount1 = balance1.sub(_reserve1);
582 
583         uint256 _ethBalanceBefore = address(this).balance;
584         { // scope for ethAmount/erc20Amount/blockNum to avoid stack too deep error
585             bytes memory data = abi.encode(msg.sender, to, amount0, amount1);
586             // query price
587             OraclePrice memory _op;
588             (_op.K, _op.ethAmount, _op.erc20Amount, _op.blockNum, _op.theta) = _queryOracle(_token1, CoFiX_OP.MINT, data);
589             uint256 navps = calcNAVPerShareForMint(_reserve0, _reserve1, _op);
590             if (totalSupply == 0) {
591                 liquidity = calcLiquidity(amount0, amount1, navps, _op).sub(MINIMUM_LIQUIDITY);
592                 _mint(address(0), MINIMUM_LIQUIDITY); // permanently lock the first MINIMUM_LIQUIDITY tokens
593             } else {
594                 liquidity = calcLiquidity(amount0, amount1, navps, _op);
595             }
596         }
597         oracleFeeChange = msg.value.sub(_ethBalanceBefore.sub(address(this).balance));
598 
599         require(liquidity > 0, "CPair: SHORT_LIQUIDITY_MINTED");
600         _mint(to, liquidity);
601 
602         _update(balance0, balance1);
603         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
604 
605         emit Mint(msg.sender, amount0, amount1);
606     }
607 
608     // this low-level function should be called from a contract which performs important safety checks
609     function burn(address outToken, address to) external payable override lock returns (uint amountOut, uint oracleFeeChange) {
610         address _token0 = token0;                                // gas savings
611         address _token1 = token1;                                // gas savings
612         uint balance0 = IERC20(_token0).balanceOf(address(this));
613         uint balance1 = IERC20(_token1).balanceOf(address(this));
614         uint liquidity = balanceOf[address(this)];
615 
616         uint256 _ethBalanceBefore = address(this).balance;
617         uint256 fee;
618         {
619             bytes memory data = abi.encode(msg.sender, outToken, to, liquidity);
620             // query price
621             OraclePrice memory _op;
622             (_op.K, _op.ethAmount, _op.erc20Amount, _op.blockNum, _op.theta) = _queryOracle(_token1, CoFiX_OP.BURN, data);
623             if (outToken == _token0) {
624                 (amountOut, fee) = calcOutToken0ForBurn(liquidity, _op); // navps calculated
625             } else if (outToken == _token1) {
626                 (amountOut, fee) = calcOutToken1ForBurn(liquidity, _op); // navps calculated
627             }  else {
628                 revert("CPair: wrong outToken");
629             }
630         }
631         oracleFeeChange = msg.value.sub(_ethBalanceBefore.sub(address(this).balance));
632 
633         require(amountOut > 0, "CPair: SHORT_LIQUIDITY_BURNED");
634         _burn(address(this), liquidity);
635         _safeTransfer(outToken, to, amountOut);
636         if (fee > 0) {
637             if (ICoFiXFactory(factory).getTradeMiningStatus(_token1)) {
638                 // only transfer fee to protocol feeReceiver when trade mining is enabled for this trading pair
639                 _safeSendFeeForCoFiHolder(_token0, fee);
640             } else {
641                 _safeSendFeeForLP(_token0, _token1, fee);
642             }
643         }
644         balance0 = IERC20(_token0).balanceOf(address(this));
645         balance1 = IERC20(_token1).balanceOf(address(this));
646 
647         _update(balance0, balance1);
648         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
649 
650         emit Burn(msg.sender, outToken, amountOut, to);
651     }
652 
653 
654     // this low-level function should be called from a contract which performs important safety checks
655     function swapWithExact(address outToken, address to)
656         external
657         payable override lock
658         returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo)
659     {
660         // tradeInfo[0]: thetaFee, tradeInfo[1]: x, tradeInfo[2]: y, tradeInfo[3]: navps
661         address _token0 = token0;
662         address _token1 = token1;
663         uint256 balance0 = IERC20(_token0).balanceOf(address(this));
664         uint256 balance1 = IERC20(_token1).balanceOf(address(this));
665 
666         // uint256 fee;
667         { // scope for ethAmount/erc20Amount/blockNum to avoid stack too deep error
668             uint256 _ethBalanceBefore = address(this).balance;
669             (uint112 _reserve0, uint112 _reserve1) = getReserves(); // gas savings
670             // calc amountIn
671             if (outToken == _token1) {
672                 amountIn = balance0.sub(_reserve0);
673             } else if (outToken == _token0) {
674                 amountIn = balance1.sub(_reserve1);
675             } else {
676                 revert("CPair: wrong outToken");
677             }
678             require(amountIn > 0, "CPair: wrong amountIn");
679             bytes memory data = abi.encode(msg.sender, outToken, to, amountIn);
680             // query price
681             OraclePrice memory _op;
682             (_op.K, _op.ethAmount, _op.erc20Amount, _op.blockNum, _op.theta) = _queryOracle(_token1, CoFiX_OP.SWAP_WITH_EXACT, data);
683             if (outToken == _token1) {
684                 (amountOut, tradeInfo[0]) = calcOutToken1(amountIn, _op);
685                 tradeInfo[1] = _reserve0; // swap token0 for token1 out
686                 tradeInfo[2] = uint256(_reserve1).mul(_op.ethAmount).div(_op.erc20Amount); // _reserve1 value as _reserve0
687             } else if (outToken == _token0) {
688                 (amountOut, tradeInfo[0]) = calcOutToken0(amountIn, _op);
689                 tradeInfo[1] = uint256(_reserve1).mul(_op.ethAmount).div(_op.erc20Amount); // _reserve1 value as _reserve0
690                 tradeInfo[2] = _reserve0; // swap token1 for token0 out
691             }
692             oracleFeeChange = msg.value.sub(_ethBalanceBefore.sub(address(this).balance));
693             tradeInfo[3] = calcNAVPerShare(_reserve0, _reserve1, _op.ethAmount, _op.erc20Amount);
694         }
695         
696         require(to != _token0 && to != _token1, "CPair: INVALID_TO");
697 
698         _safeTransfer(outToken, to, amountOut); // optimistically transfer tokens
699         if (tradeInfo[0] > 0) {
700             if (ICoFiXFactory(factory).getTradeMiningStatus(_token1)) {
701                 // only transfer fee to protocol feeReceiver when trade mining is enabled for this trading pair
702                 _safeSendFeeForCoFiHolder(_token0, tradeInfo[0]);
703             } else {
704                 _safeSendFeeForLP(_token0, _token1, tradeInfo[0]);
705                 tradeInfo[0] = 0; // so router won't go into the trade mining logic (reduce one more call gas cost)
706             }
707         }
708         balance0 = IERC20(_token0).balanceOf(address(this));
709         balance1 = IERC20(_token1).balanceOf(address(this));
710 
711         _update(balance0, balance1);
712         if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
713 
714         emit Swap(msg.sender, amountIn, amountOut, outToken, to);
715     }
716 
717     // this low-level function should be called from a contract which performs important safety checks
718     function swapForExact(address outToken, uint amountOutExact, address to)
719         external
720         payable override lock
721         returns (uint amountIn, uint amountOut, uint oracleFeeChange, uint256[4] memory tradeInfo)
722     {
723         // tradeInfo[0]: thetaFee, tradeInfo[1]: x, tradeInfo[2]: y, tradeInfo[3]: navps
724         address _token0 = token0;
725         address _token1 = token1;
726         OraclePrice memory _op;
727 
728         // uint256 fee;
729 
730         { // scope for ethAmount/erc20Amount/blockNum to avoid stack too deep error
731             uint256 _ethBalanceBefore = address(this).balance;
732             bytes memory data = abi.encode(msg.sender, outToken, amountOutExact, to);
733             // query price
734             (_op.K, _op.ethAmount, _op.erc20Amount, _op.blockNum, _op.theta) = _queryOracle(_token1, CoFiX_OP.SWAP_FOR_EXACT, data);
735             oracleFeeChange = msg.value.sub(_ethBalanceBefore.sub(address(this).balance));
736         }
737 
738         { // calc and check amountIn, also outToken
739             uint256 balance0 = IERC20(_token0).balanceOf(address(this));
740             uint256 balance1 = IERC20(_token1).balanceOf(address(this));
741             (uint112 _reserve0, uint112 _reserve1) = getReserves(); // gas savings
742      
743             if (outToken == _token1) {
744                 amountIn = balance0.sub(_reserve0);
745                 tradeInfo[1] = _reserve0; // swap token0 for token1 out
746                 tradeInfo[2] = uint256(_reserve1).mul(_op.ethAmount).div(_op.erc20Amount); // _reserve1 value as _reserve0
747             } else if (outToken == _token0) {
748                 amountIn = balance1.sub(_reserve1);
749                 tradeInfo[1] = uint256(_reserve1).mul(_op.ethAmount).div(_op.erc20Amount); // _reserve1 value as _reserve0
750                 tradeInfo[2] = _reserve0; // swap token1 for token0 out
751             } else {
752                 revert("CPair: wrong outToken");
753             }
754             require(amountIn > 0, "CPair: wrong amountIn");
755             tradeInfo[3] = calcNAVPerShare(_reserve0, _reserve1, _op.ethAmount, _op.erc20Amount);
756         }
757 
758         { // split with branch upbove to make code more clear
759             uint _amountInNeeded;
760             uint _amountInLeft;
761             if (outToken == _token1) {
762                 (_amountInNeeded, tradeInfo[0]) = calcInNeededToken0(amountOutExact, _op);
763                 _amountInLeft = amountIn.sub(_amountInNeeded);
764                 if (_amountInLeft > 0) {
765                     _safeTransfer(_token0, to, _amountInLeft); // send back the amount0 token change
766                 }
767             } else if (outToken == _token0) {
768                 (_amountInNeeded, tradeInfo[0]) = calcInNeededToken1(amountOutExact, _op);
769                 _amountInLeft = amountIn.sub(_amountInNeeded);
770                 if (_amountInLeft > 0) {
771                     _safeTransfer(_token1, to, _amountInLeft); // send back the amount1 token change
772                 }
773             }
774             require(_amountInNeeded <= amountIn, "CPair: insufficient amountIn");
775             require(_amountInNeeded > 0, "CPair: wrong amountIn needed");
776         }
777         
778         {
779             require(to != _token0 && to != _token1, "CPair: INVALID_TO");
780 
781             amountOut = amountOutExact;
782             _safeTransfer(outToken, to, amountOut); // optimistically transfer tokens
783             if (tradeInfo[0] > 0) {
784                 if (ICoFiXFactory(factory).getTradeMiningStatus(_token1)) {
785                     // only transfer fee to protocol feeReceiver when trade mining is enabled for this trading pair
786                     _safeSendFeeForCoFiHolder(_token0, tradeInfo[0]);
787                 } else {
788                     _safeSendFeeForLP(_token0, _token1, tradeInfo[0]);
789                     tradeInfo[0] = 0; // so router won't go into the trade mining logic (reduce one more call gas cost)
790                 }
791             }
792             uint256 balance0 = IERC20(_token0).balanceOf(address(this));
793             uint256 balance1 = IERC20(_token1).balanceOf(address(this));
794 
795             _update(balance0, balance1);
796             if (oracleFeeChange > 0) TransferHelper.safeTransferETH(msg.sender, oracleFeeChange);
797         }
798 
799         emit Swap(msg.sender, amountIn, amountOut, outToken, to);
800     }
801 
802     // force balances to match reserves
803     function skim(address to) external override lock {
804         address _token0 = token0; // gas savings
805         address _token1 = token1; // gas savings
806         _safeTransfer(_token0, to, IERC20(_token0).balanceOf(address(this)).sub(reserve0));
807         _safeTransfer(_token1, to, IERC20(_token1).balanceOf(address(this)).sub(reserve1));
808     }
809 
810     // force reserves to match balances
811     function sync() external override lock {
812         _update(IERC20(token0).balanceOf(address(this)), IERC20(token1).balanceOf(address(this)));
813     }
814 
815     // calc Net Asset Value Per Share for mint
816     // use it in this contract, for optimized gas usage
817     function calcNAVPerShareForMint(uint256 balance0, uint256 balance1, OraclePrice memory _op) public view returns (uint256 navps) {
818         uint _totalSupply = totalSupply;
819         if (_totalSupply == 0) {
820             navps = NAVPS_BASE;
821         } else {
822             /*
823             N_{p} &= (A_{u}/P_{s}^{'} + A_{e})/S \\\\
824                   &= (A_{u}/(P * (1 - K)) + A_{e})/S \\\\
825                   &= (\frac{A_{u}}{\frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} - k)}{(k_{BASE})}} + A_{e})/S \\\\
826                   &= (\frac{A_{u}*ethAmount*k_{BASE}}{erc20Amount*(k_{BASE} - k)}+ A_{e}) / S \\\\
827                   &= (A_{u}*ethAmount*k_{BASE}+ A_{e}*erc20Amount*(k_{BASE} - k)) / S / (erc20Amount*(k_{BASE} - k)) \\\\
828             N_{p} &= NAVPS_{BASE}*(A_{u}*ethAmount*k_{BASE}+ A_{e}*erc20Amount*(k_{BASE} - k)) / S / (erc20Amount*(k_{BASE} - k)) \\\\
829             // navps = NAVPS_BASE * ( (balance1*_op.ethAmount*K_BASE) + (balance0*_op.erc20Amount*(K_BASE-_op.K)) ) / _totalSupply / _op.erc20Amount / (K_BASE-_op.K);
830             */
831             uint256 kbaseSubK = K_BASE.sub(_op.K);
832             uint256 balance1MulEthKbase = balance1.mul(_op.ethAmount).mul(K_BASE);
833             uint256 balance0MulErcKbsk = balance0.mul(_op.erc20Amount).mul(kbaseSubK);
834             navps = NAVPS_BASE.mul( (balance1MulEthKbase).add(balance0MulErcKbsk) ).div(_totalSupply).div(_op.erc20Amount).div(kbaseSubK);
835         }
836     }
837 
838     // calc Net Asset Value Per Share for burn
839     // use it in this contract, for optimized gas usage
840     function calcNAVPerShareForBurn(uint256 balance0, uint256 balance1, OraclePrice memory _op) public view returns (uint256 navps) {
841         uint _totalSupply = totalSupply;
842         if (_totalSupply == 0) {
843             navps = NAVPS_BASE;
844         } else {
845             /*
846             N_{p}^{'} &= (A_{u}/P_{b}^{'} + A_{e})/S \\\\
847                       &= (A_{u}/(P * (1 + K)) + A_{e})/S \\\\
848                       &= (\frac{A_{u}}{\frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} + k)}{(k_{BASE})}} + A_{e})/S \\\\
849                       &= (\frac{A_{u}*ethAmount*k_{BASE}}{erc20Amount*(k_{BASE} + k)}+ A_{e}) / S \\\\
850                       &= (A_{u}*ethAmount*k_{BASE}+ A_{e}*erc20Amount*(k_{BASE} + k)) / S / (erc20Amount*(k_{BASE} + k)) \\\\
851             N_{p}^{'} &= NAVPS_{BASE}*(A_{u}*ethAmount*k_{BASE}+ A_{e}*erc20Amount*(k_{BASE} + k)) / S / (erc20Amount*(k_{BASE} + k)) \\\\
852             // navps = NAVPS_BASE * ( (balance1*_op.ethAmount*K_BASE) + (balance0*_op.erc20Amount*(K_BASE+_op.K)) ) / _totalSupply / _op.erc20Amount / (K_BASE+_op.K);
853             */
854             uint256 kbaseAddK = K_BASE.add(_op.K);
855             uint256 balance1MulEthKbase = balance1.mul(_op.ethAmount).mul(K_BASE);
856             uint256 balance0MulErcKbsk = balance0.mul(_op.erc20Amount).mul(kbaseAddK);
857             navps = NAVPS_BASE.mul( (balance1MulEthKbase).add(balance0MulErcKbsk) ).div(_totalSupply).div(_op.erc20Amount).div(kbaseAddK);
858         }
859     }
860 
861     // calc Net Asset Value Per Share (no K)
862     // use it in this contract, for optimized gas usage
863     function calcNAVPerShare(uint256 balance0, uint256 balance1, uint256 ethAmount, uint256 erc20Amount) public view returns (uint256 navps) {
864         uint _totalSupply = totalSupply;
865         if (_totalSupply == 0) {
866             navps = NAVPS_BASE;
867         } else {
868             /*
869             N_{p}^{'} &= (A_{u}/P + A_{e})/S \\\\
870                       &= (\frac{A_{u}}{\frac{erc20Amount}{ethAmount}} + A_{e})/S \\\\
871                       &= (\frac{A_{u}*ethAmount}{erc20Amount}+ A_{e}) / S \\\\
872                       &= (A_{u}*ethAmount+ A_{e}*erc20Amount) / S / (erc20Amount) \\\\
873             N_{p}^{'} &= NAVPS_{BASE}*(A_{u}*ethAmount+ A_{e}*erc20Amount) / S / (erc20Amount) \\\\
874             // navps = NAVPS_BASE * ( (balance1*_op.ethAmount) + (balance0*_op.erc20Amount) ) / _totalSupply / _op.erc20Amount;
875             */
876             uint256 balance1MulEth = balance1.mul(ethAmount);
877             uint256 balance0MulErc = balance0.mul(erc20Amount);
878             navps = NAVPS_BASE.mul( (balance1MulEth).add(balance0MulErc) ).div(_totalSupply).div(erc20Amount);
879         }
880     }
881 
882     // use it in this contract, for optimized gas usage
883     function calcLiquidity(uint256 amount0, uint256 amount1, uint256 navps, OraclePrice memory _op) public pure returns (uint256 liquidity) {
884         /*
885         s_{1} &= a / (N_{p} / NAVPS_{BASE}) \\\\
886               &= a * NAVPS_{BASE} / N_{p} \\\\
887         s_{2} &= b / P_{b}^{'} / (N_{p} / NAVPS_{BASE}) \\\\
888               &= b / (N_{p} / NAVPS_{BASE}) / P_{b}^{'} \\\\
889               &= b * NAVPS_{BASE} / N_{p} / P_{b}^{'} \\\\
890               &= b * NAVPS_{BASE} / N_{p} / (\frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} + k)}{(k_{BASE})}) \\\\
891               &= b * NAVPS_{BASE} * ethAmount * k_{BASE} / N_{p} / (erc20Amount * (k_{BASE} + k))
892         s &= s_1 + s_2 \\\\
893           &= a * NAVPS_{BASE} / N_{p} + b * NAVPS_{BASE} / N_{p} / P_{b}^{'} \\\\
894           &= a * NAVPS_{BASE} / N_{p} + b * NAVPS_{BASE} * ethAmount * k_{BASE} / N_{p} / (erc20Amount * (k_{BASE} + k)) \\\\
895         // liquidity = (amount0 * NAVPS_BASE / navps) + (amount1 * NAVPS_BASE * _op.ethAmount * K_BASE / navps / _op.erc20Amount / (K_BASE + _op.K));
896         */
897         uint256 amnt0MulNbaseDivN = amount0.mul(NAVPS_BASE).div(navps);
898         uint256 amnt1MulNbaseEthKbase = amount1.mul(NAVPS_BASE).mul(_op.ethAmount).mul(K_BASE);
899         liquidity = ( amnt0MulNbaseDivN ).add( amnt1MulNbaseEthKbase.div(navps).div(_op.erc20Amount).div(K_BASE.add(_op.K)) );
900     }
901 
902     // get Net Asset Value Per Share for mint
903     // only for read, could cost more gas if use it directly in contract
904     function getNAVPerShareForMint(OraclePrice memory _op) public view returns (uint256 navps) {
905         return calcNAVPerShareForMint(reserve0, reserve1, _op);
906     }
907 
908     // get Net Asset Value Per Share for burn
909     // only for read, could cost more gas if use it directly in contract
910     function getNAVPerShareForBurn(OraclePrice memory _op) external view returns (uint256 navps) {
911         return calcNAVPerShareForBurn(reserve0, reserve1, _op);
912     }
913 
914     // get Net Asset Value Per Share
915     // only for read, could cost more gas if use it directly in contract
916     function getNAVPerShare(uint256 ethAmount, uint256 erc20Amount) external override view returns (uint256 navps) {
917         return calcNAVPerShare(reserve0, reserve1, ethAmount, erc20Amount);
918     }
919 
920     // get estimated liquidity amount (it represents the amount of pool tokens will be minted if someone provide liquidity to the pool)
921     // only for read, could cost more gas if use it directly in contract
922     function getLiquidity(uint256 amount0, uint256 amount1, OraclePrice memory _op) external view returns (uint256 liquidity) {
923         uint256 navps = getNAVPerShareForMint(_op);
924         return calcLiquidity(amount0, amount1, navps, _op);
925     }
926 
927     // calc amountOut for token0 (WETH) when send liquidity token to pool for burning
928     function calcOutToken0ForBurn(uint256 liquidity, OraclePrice memory _op) public view returns (uint256 amountOut, uint256 fee) {
929         /*
930         e &= c * (N_{p}^{'} / NAVPS_{BASE}) * (THETA_{BASE} - \theta)/THETA_{BASE} \\\\
931           &= c * \frac{N_{p}^{'}}{NAVPS_{BASE}} * \frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
932           &= c * N_{p}^{'} * (THETA_{BASE} - \theta) / NAVPS_{BASE} / THETA_{BASE} \\\\
933         // amountOut = liquidity * navps * (THETA_BASE - _op.theta) / NAVPS_BASE / THETA_BASE;
934         */
935         uint256 navps = calcNAVPerShareForBurn(reserve0, reserve1, _op);
936         amountOut = liquidity.mul(navps).mul(THETA_BASE.sub(_op.theta)).div(NAVPS_BASE).div(THETA_BASE);
937         if (_op.theta != 0) {
938             // fee = liquidity * navps * (_op.theta) / NAVPS_BASE / THETA_BASE;
939             fee = liquidity.mul(navps).mul(_op.theta).div(NAVPS_BASE).div(THETA_BASE);
940         }
941         return (amountOut, fee);
942     }
943 
944 
945     // calc amountOut for token1 (ERC20 token) when send liquidity token to pool for burning
946     function calcOutToken1ForBurn(uint256 liquidity, OraclePrice memory _op) public view returns (uint256 amountOut, uint256 fee) {
947         /*
948         u &= c * (N_{p}^{'} / NAVPS_{BASE}) * P_{s}^{'} * (THETA_{BASE} - \theta)/THETA_{BASE} \\\\
949           &= c * \frac{N_{p}^{'}}{NAVPS_{BASE}} * \frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} - k)}{(k_{BASE})} * \frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
950           &= \frac{c * N_{p}^{'} * erc20Amount * (k_{BASE} - k) * (THETA_{BASE} - \theta)}{NAVPS_{BASE}*ethAmount*k_{BASE}*THETA_{BASE}}
951         // amountOut = liquidity * navps * _op.erc20Amount * (K_BASE - _op.K) * (THETA_BASE - _op.theta) / NAVPS_BASE / _op.ethAmount / K_BASE / THETA_BASE;
952         */
953         uint256 navps = calcNAVPerShareForBurn(reserve0, reserve1, _op);
954         uint256 liqMulMany = liquidity.mul(navps).mul(_op.erc20Amount).mul(K_BASE.sub(_op.K)).mul(THETA_BASE.sub(_op.theta));
955         amountOut = liqMulMany.div(NAVPS_BASE).div(_op.ethAmount).div(K_BASE).div(THETA_BASE);
956         if (_op.theta != 0) {
957             // fee = liquidity * navps * (_op.theta) / NAVPS_BASE / THETA_BASE;
958             fee = liquidity.mul(navps).mul(_op.theta).div(NAVPS_BASE).div(THETA_BASE);
959         }
960         return (amountOut, fee);
961     }
962 
963     // get estimated amountOut for token0 (WETH) when swapWithExact
964     function calcOutToken0(uint256 amountIn, OraclePrice memory _op) public pure returns (uint256 amountOut, uint256 fee) {
965         /*
966         x &= (a/P_{b}^{'})*\frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
967           &= a / (\frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} + k)}{(k_{BASE})}) * \frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
968           &= \frac{a*ethAmount*k_{BASE}}{erc20Amount*(k_{BASE} + k)} * \frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
969           &= \frac{a*ethAmount*k_{BASE}*(THETA_{BASE} - \theta)}{erc20Amount*(k_{BASE} + k)*THETA_{BASE}} \\\\
970         // amountOut = amountIn * _op.ethAmount * K_BASE * (THETA_BASE - _op.theta) / _op.erc20Amount / (K_BASE + _op.K) / THETA_BASE;
971         */
972         amountOut = amountIn.mul(_op.ethAmount).mul(K_BASE).mul(THETA_BASE.sub(_op.theta)).div(_op.erc20Amount).div(K_BASE.add(_op.K)).div(THETA_BASE);
973         if (_op.theta != 0) {
974             // fee = amountIn * _op.ethAmount * K_BASE * (_op.theta) / _op.erc20Amount / (K_BASE + _op.K) / THETA_BASE;
975             fee = amountIn.mul(_op.ethAmount).mul(K_BASE).mul(_op.theta).div(_op.erc20Amount).div(K_BASE.add(_op.K)).div(THETA_BASE);
976         }
977         return (amountOut, fee);
978     }
979 
980     // get estimated amountOut for token1 (ERC20 token) when swapWithExact
981     function calcOutToken1(uint256 amountIn, OraclePrice memory _op) public pure returns (uint256 amountOut, uint256 fee) {
982         /*
983         y &= b*P_{s}^{'}*\frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
984           &= b * \frac{erc20Amount}{ethAmount} * \frac{(k_{BASE} - k)}{(k_{BASE})} * \frac{THETA_{BASE} - \theta}{THETA_{BASE}} \\\\
985           &= \frac{b*erc20Amount*(k_{BASE} - k)*(THETA_{BASE} - \theta)}{ethAmount*k_{BASE}*THETA_{BASE}} \\\\
986         // amountOut = amountIn * _op.erc20Amount * (K_BASE - _op.K) * (THETA_BASE - _op.theta) / _op.ethAmount / K_BASE / THETA_BASE;
987         */
988         amountOut = amountIn.mul(_op.erc20Amount).mul(K_BASE.sub(_op.K)).mul(THETA_BASE.sub(_op.theta)).div(_op.ethAmount).div(K_BASE).div(THETA_BASE);
989         if (_op.theta != 0) {
990             // fee = amountIn * _op.theta / THETA_BASE;
991             fee = amountIn.mul(_op.theta).div(THETA_BASE);
992         }
993         return (amountOut, fee);
994     }
995 
996     // get estimate amountInNeeded for token0 (WETH) when swapForExact
997     function calcInNeededToken0(uint256 amountOut, OraclePrice memory _op) public pure returns (uint256 amountInNeeded, uint256 fee) {
998         // inverse of calcOutToken1
999         // amountOut = amountIn.mul(_op.erc20Amount).mul(K_BASE.sub(_op.K)).mul(THETA_BASE.sub(_op.theta)).div(_op.ethAmount).div(K_BASE).div(THETA_BASE);
1000         amountInNeeded = amountOut.mul(_op.ethAmount).mul(K_BASE).mul(THETA_BASE).div(_op.erc20Amount).div(K_BASE.sub(_op.K)).div(THETA_BASE.sub(_op.theta));
1001         if (_op.theta != 0) {
1002             // fee = amountIn * _op.theta / THETA_BASE;
1003             fee = amountInNeeded.mul(_op.theta).div(THETA_BASE);
1004         }
1005         return (amountInNeeded, fee);
1006     }
1007 
1008     // get estimate amountInNeeded for token1 (ERC20 token) when swapForExact
1009     function calcInNeededToken1(uint256 amountOut, OraclePrice memory _op) public pure returns (uint256 amountInNeeded, uint256 fee) {
1010         // inverse of calcOutToken0
1011         // amountOut = amountIn.mul(_op.ethAmount).mul(K_BASE).mul(THETA_BASE.sub(_op.theta)).div(_op.erc20Amount).div(K_BASE.add(_op.K)).div(THETA_BASE);
1012         amountInNeeded = amountOut.mul(_op.erc20Amount).mul(K_BASE.add(_op.K)).mul(THETA_BASE).div(_op.ethAmount).div(K_BASE).div(THETA_BASE.sub(_op.theta));
1013         if (_op.theta != 0) {
1014             // fee = amountIn * _op.ethAmount * K_BASE * (_op.theta) / _op.erc20Amount / (K_BASE + _op.K) / THETA_BASE;
1015             fee = amountInNeeded.mul(_op.ethAmount).mul(K_BASE).mul(_op.theta).div(_op.erc20Amount).div(K_BASE.add(_op.K)).div(THETA_BASE);
1016         }
1017         return (amountInNeeded, fee);
1018     }
1019 
1020     function _queryOracle(address token, CoFiX_OP op, bytes memory data) internal returns (uint256, uint256, uint256, uint256, uint256) {
1021         return ICoFiXController(ICoFiXFactory(factory).getController()).queryOracle{value: msg.value}(token, uint8(op), data);
1022     }
1023 
1024     // Safe WETH transfer function, just in case not having enough WETH. CoFi holder will earn these fees.
1025     function _safeSendFeeForCoFiHolder(address _token0, uint256 _fee) internal {
1026         address feeReceiver = ICoFiXFactory(factory).getFeeReceiver();
1027         if (feeReceiver == address(0)) {
1028             return; // if feeReceiver not set, theta fee keeps in pair pool
1029         }
1030         _safeSendFee(_token0, feeReceiver, _fee); // transfer fee to protocol fee reward pool for CoFi holders
1031     }
1032 
1033     // Safe WETH transfer function, just in case not having enough WETH. LP will earn these fees.
1034     function _safeSendFeeForLP(address _token0, address _token1, uint256 _fee) internal {
1035         address feeVault = ICoFiXFactory(factory).getFeeVaultForLP(_token1);
1036         if (feeVault == address(0)) {
1037             return; // if fee vault not set, theta fee keeps in pair pool
1038         }
1039         _safeSendFee(_token0, feeVault, _fee); // transfer fee to protocol fee reward pool for LP
1040     }
1041 
1042     function _safeSendFee(address _token0, address _receiver, uint256 _fee) internal {
1043         uint256 wethBal = IERC20(_token0).balanceOf(address(this));
1044         if (_fee > wethBal) {
1045             _fee = wethBal;
1046         }
1047         if (_fee > 0) _safeTransfer(_token0, _receiver, _fee); 
1048     }
1049 }
1050 
1051 // UNI & CoFi Rocks