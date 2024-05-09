1 // File: contracts/lib/Ownable.sol
2 
3 /*
4 
5     Copyright 2020 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 pragma experimental ABIEncoderV2;
12 
13 /**
14  * @title Ownable
15  * @author DODO Breeder
16  *
17  * @notice Ownership related functions
18  */
19 contract Ownable {
20     address public _OWNER_;
21     address public _NEW_OWNER_;
22 
23     // ============ Events ============
24 
25     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
26 
27     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29     // ============ Modifiers ============
30 
31     modifier onlyOwner() {
32         require(msg.sender == _OWNER_, "NOT_OWNER");
33         _;
34     }
35 
36     // ============ Functions ============
37 
38     constructor() internal {
39         _OWNER_ = msg.sender;
40         emit OwnershipTransferred(address(0), _OWNER_);
41     }
42 
43     function transferOwnership(address newOwner) external onlyOwner {
44         require(newOwner != address(0), "INVALID_OWNER");
45         emit OwnershipTransferPrepared(_OWNER_, newOwner);
46         _NEW_OWNER_ = newOwner;
47     }
48 
49     function claimOwnership() external {
50         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
51         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
52         _OWNER_ = _NEW_OWNER_;
53         _NEW_OWNER_ = address(0);
54     }
55 }
56 
57 // File: contracts/intf/IDODO.sol
58 
59 /*
60 
61     Copyright 2020 DODO ZOO.
62 
63 */
64 
65 interface IDODO {
66     function init(
67         address owner,
68         address supervisor,
69         address maintainer,
70         address baseToken,
71         address quoteToken,
72         address oracle,
73         uint256 lpFeeRate,
74         uint256 mtFeeRate,
75         uint256 k,
76         uint256 gasPriceLimit
77     ) external;
78 
79     function transferOwnership(address newOwner) external;
80 
81     function claimOwnership() external;
82 
83     function sellBaseToken(
84         uint256 amount,
85         uint256 minReceiveQuote,
86         bytes calldata data
87     ) external returns (uint256);
88 
89     function buyBaseToken(
90         uint256 amount,
91         uint256 maxPayQuote,
92         bytes calldata data
93     ) external returns (uint256);
94 
95     function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote);
96 
97     function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote);
98 
99     function depositBaseTo(address to, uint256 amount) external returns (uint256);
100 
101     function withdrawBase(uint256 amount) external returns (uint256);
102 
103     function withdrawAllBase() external returns (uint256);
104 
105     function depositQuoteTo(address to, uint256 amount) external returns (uint256);
106 
107     function withdrawQuote(uint256 amount) external returns (uint256);
108 
109     function withdrawAllQuote() external returns (uint256);
110 
111     function _BASE_CAPITAL_TOKEN_() external returns (address);
112 
113     function _QUOTE_CAPITAL_TOKEN_() external returns (address);
114 
115     function _BASE_TOKEN_() external returns (address);
116 
117     function _QUOTE_TOKEN_() external returns (address);
118 }
119 
120 // File: contracts/intf/IERC20.sol
121 
122 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
123 
124 /**
125  * @dev Interface of the ERC20 standard as defined in the EIP.
126  */
127 interface IERC20 {
128     /**
129      * @dev Returns the amount of tokens in existence.
130      */
131     function totalSupply() external view returns (uint256);
132 
133     function decimals() external view returns (uint8);
134 
135     function name() external view returns (string memory);
136 
137     /**
138      * @dev Returns the amount of tokens owned by `account`.
139      */
140     function balanceOf(address account) external view returns (uint256);
141 
142     /**
143      * @dev Moves `amount` tokens from the caller's account to `recipient`.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transfer(address recipient, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Returns the remaining number of tokens that `spender` will be
153      * allowed to spend on behalf of `owner` through {transferFrom}. This is
154      * zero by default.
155      *
156      * This value changes when {approve} or {transferFrom} are called.
157      */
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     /**
161      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * IMPORTANT: Beware that changing an allowance with this method brings the risk
166      * that someone may use both the old and the new allowance by unfortunate
167      * transaction ordering. One possible solution to mitigate this race
168      * condition is to first reduce the spender's allowance to 0 and set the
169      * desired value afterwards:
170      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171      *
172      * Emits an {Approval} event.
173      */
174     function approve(address spender, uint256 amount) external returns (bool);
175 
176     /**
177      * @dev Moves `amount` tokens from `sender` to `recipient` using the
178      * allowance mechanism. `amount` is then deducted from the caller's
179      * allowance.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transferFrom(
186         address sender,
187         address recipient,
188         uint256 amount
189     ) external returns (bool);
190 }
191 
192 // File: contracts/lib/SafeMath.sol
193 
194 /*
195 
196     Copyright 2020 DODO ZOO.
197 
198 */
199 
200 /**
201  * @title SafeMath
202  * @author DODO Breeder
203  *
204  * @notice Math operations with safety checks that revert on error
205  */
206 library SafeMath {
207     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208         if (a == 0) {
209             return 0;
210         }
211 
212         uint256 c = a * b;
213         require(c / a == b, "MUL_ERROR");
214 
215         return c;
216     }
217 
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         require(b > 0, "DIVIDING_ERROR");
220         return a / b;
221     }
222 
223     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
224         uint256 quotient = div(a, b);
225         uint256 remainder = a - quotient * b;
226         if (remainder > 0) {
227             return quotient + 1;
228         } else {
229             return quotient;
230         }
231     }
232 
233     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
234         require(b <= a, "SUB_ERROR");
235         return a - b;
236     }
237 
238     function add(uint256 a, uint256 b) internal pure returns (uint256) {
239         uint256 c = a + b;
240         require(c >= a, "ADD_ERROR");
241         return c;
242     }
243 
244     function sqrt(uint256 x) internal pure returns (uint256 y) {
245         uint256 z = x / 2 + 1;
246         y = x;
247         while (z < y) {
248             y = z;
249             z = (x / z + z) / 2;
250         }
251     }
252 }
253 
254 // File: contracts/lib/SafeERC20.sol
255 
256 /*
257 
258     Copyright 2020 DODO ZOO.
259     This is a simplified version of OpenZepplin's SafeERC20 library
260 
261 */
262 
263 /**
264  * @title SafeERC20
265  * @dev Wrappers around ERC20 operations that throw on failure (when the token
266  * contract returns false). Tokens that return no value (and instead revert or
267  * throw on failure) are also supported, non-reverting calls are assumed to be
268  * successful.
269  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
270  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
271  */
272 library SafeERC20 {
273     using SafeMath for uint256;
274 
275     function safeTransfer(
276         IERC20 token,
277         address to,
278         uint256 value
279     ) internal {
280         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
281     }
282 
283     function safeTransferFrom(
284         IERC20 token,
285         address from,
286         address to,
287         uint256 value
288     ) internal {
289         _callOptionalReturn(
290             token,
291             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
292         );
293     }
294 
295     /**
296      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
297      * on the return value: the return value is optional (but if data is returned, it must not be false).
298      * @param token The token targeted by the call.
299      * @param data The call data (encoded using abi.encode or one of its variants).
300      */
301     function _callOptionalReturn(IERC20 token, bytes memory data) private {
302         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
303         // we're implementing it ourselves.
304 
305         // A Solidity high level call has three parts:
306         //  1. The target address is checked to verify it contains contract code
307         //  2. The call itself is made, and success asserted
308         //  3. The return value is decoded, which in turn checks the size of the returned data.
309         // solhint-disable-next-line max-line-length
310 
311         // solhint-disable-next-line avoid-low-level-calls
312         (bool success, bytes memory returndata) = address(token).call(data);
313         require(success, "SafeERC20: low-level call failed");
314 
315         if (returndata.length > 0) {
316             // Return data is optional
317             // solhint-disable-next-line max-line-length
318             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
319         }
320     }
321 }
322 
323 // File: contracts/helper/UniswapArbitrageur.sol
324 
325 /*
326 
327     Copyright 2020 DODO ZOO.
328 
329 */
330 
331 interface IUniswapV2Pair {
332     function token0() external view returns (address);
333 
334     function token1() external view returns (address);
335 
336     function getReserves()
337         external
338         view
339         returns (
340             uint112 reserve0,
341             uint112 reserve1,
342             uint32 blockTimestampLast
343         );
344 
345     function swap(
346         uint256 amount0Out,
347         uint256 amount1Out,
348         address to,
349         bytes calldata data
350     ) external;
351 }
352 
353 contract UniswapArbitrageur {
354     using SafeMath for uint256;
355     using SafeERC20 for IERC20;
356 
357     address public _UNISWAP_;
358     address public _DODO_;
359     address public _BASE_;
360     address public _QUOTE_;
361 
362     bool public _REVERSE_; // true if dodo.baseToken=uniswap.token0
363 
364     constructor(address _uniswap, address _dodo) public {
365         _UNISWAP_ = _uniswap;
366         _DODO_ = _dodo;
367 
368         _BASE_ = IDODO(_DODO_)._BASE_TOKEN_();
369         _QUOTE_ = IDODO(_DODO_)._QUOTE_TOKEN_();
370 
371         address token0 = IUniswapV2Pair(_UNISWAP_).token0();
372         address token1 = IUniswapV2Pair(_UNISWAP_).token1();
373 
374         if (token0 == _BASE_ && token1 == _QUOTE_) {
375             _REVERSE_ = false;
376         } else if (token0 == _QUOTE_ && token1 == _BASE_) {
377             _REVERSE_ = true;
378         } else {
379             require(true, "DODO_UNISWAP_NOT_MATCH");
380         }
381 
382         IERC20(_BASE_).approve(_DODO_, uint256(-1));
383         IERC20(_QUOTE_).approve(_DODO_, uint256(-1));
384     }
385 
386     function executeBuyArbitrage(uint256 baseAmount) external returns (uint256 quoteProfit) {
387         IDODO(_DODO_).buyBaseToken(baseAmount, uint256(-1), "0xd");
388         quoteProfit = IERC20(_QUOTE_).balanceOf(address(this));
389         IERC20(_QUOTE_).transfer(msg.sender, quoteProfit);
390         return quoteProfit;
391     }
392 
393     function executeSellArbitrage(uint256 baseAmount) external returns (uint256 baseProfit) {
394         IDODO(_DODO_).sellBaseToken(baseAmount, 0, "0xd");
395         baseProfit = IERC20(_BASE_).balanceOf(address(this));
396         IERC20(_BASE_).transfer(msg.sender, baseProfit);
397         return baseProfit;
398     }
399 
400     function dodoCall(
401         bool isDODOBuy,
402         uint256 baseAmount,
403         uint256 quoteAmount,
404         bytes calldata
405     ) external {
406         require(msg.sender == _DODO_, "WRONG_DODO");
407         if (_REVERSE_) {
408             _inverseArbitrage(isDODOBuy, baseAmount, quoteAmount);
409         } else {
410             _arbitrage(isDODOBuy, baseAmount, quoteAmount);
411         }
412     }
413 
414     function _inverseArbitrage(
415         bool isDODOBuy,
416         uint256 baseAmount,
417         uint256 quoteAmount
418     ) internal {
419         (uint112 _reserve0, uint112 _reserve1, ) = IUniswapV2Pair(_UNISWAP_).getReserves();
420         uint256 token0Balance = uint256(_reserve0);
421         uint256 token1Balance = uint256(_reserve1);
422         uint256 token0Amount;
423         uint256 token1Amount;
424         if (isDODOBuy) {
425             IERC20(_BASE_).transfer(_UNISWAP_, baseAmount);
426             // transfer token1 into uniswap
427             uint256 newToken0Balance = token0Balance.mul(token1Balance).div(
428                 token1Balance.add(baseAmount)
429             );
430             token0Amount = token0Balance.sub(newToken0Balance).mul(9969).div(10000); // mul 0.9969
431             require(token0Amount > quoteAmount, "NOT_PROFITABLE");
432             IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
433         } else {
434             IERC20(_QUOTE_).transfer(_UNISWAP_, quoteAmount);
435             // transfer token0 into uniswap
436             uint256 newToken1Balance = token0Balance.mul(token1Balance).div(
437                 token0Balance.add(quoteAmount)
438             );
439             token1Amount = token1Balance.sub(newToken1Balance).mul(9969).div(10000); // mul 0.9969
440             require(token1Amount > baseAmount, "NOT_PROFITABLE");
441             IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
442         }
443     }
444 
445     function _arbitrage(
446         bool isDODOBuy,
447         uint256 baseAmount,
448         uint256 quoteAmount
449     ) internal {
450         (uint112 _reserve0, uint112 _reserve1, ) = IUniswapV2Pair(_UNISWAP_).getReserves();
451         uint256 token0Balance = uint256(_reserve0);
452         uint256 token1Balance = uint256(_reserve1);
453         uint256 token0Amount;
454         uint256 token1Amount;
455         if (isDODOBuy) {
456             IERC20(_BASE_).transfer(_UNISWAP_, baseAmount);
457             // transfer token0 into uniswap
458             uint256 newToken1Balance = token1Balance.mul(token0Balance).div(
459                 token0Balance.add(baseAmount)
460             );
461             token1Amount = token1Balance.sub(newToken1Balance).mul(9969).div(10000); // mul 0.9969
462             require(token1Amount > quoteAmount, "NOT_PROFITABLE");
463             IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
464         } else {
465             IERC20(_QUOTE_).transfer(_UNISWAP_, quoteAmount);
466             // transfer token1 into uniswap
467             uint256 newToken0Balance = token1Balance.mul(token0Balance).div(
468                 token1Balance.add(quoteAmount)
469             );
470             token0Amount = token0Balance.sub(newToken0Balance).mul(9969).div(10000); // mul 0.9969
471             require(token0Amount > baseAmount, "NOT_PROFITABLE");
472             IUniswapV2Pair(_UNISWAP_).swap(token0Amount, token1Amount, address(this), "");
473         }
474     }
475 
476     function retrieve(address token, uint256 amount) external {
477         IERC20(token).safeTransfer(msg.sender, amount);
478     }
479 }