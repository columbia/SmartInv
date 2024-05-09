1 // File: contracts/lib/ReentrancyGuard.sol
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
14  * @title ReentrancyGuard
15  * @author DODO Breeder
16  *
17  * @notice Protect functions from Reentrancy Attack
18  */
19 contract ReentrancyGuard {
20     // https://solidity.readthedocs.io/en/latest/control-structures.html?highlight=zero-state#scoping-and-declarations
21     // zero-state of _ENTERED_ is false
22     bool private _ENTERED_;
23 
24     modifier preventReentrant() {
25         require(!_ENTERED_, "REENTRANT");
26         _ENTERED_ = true;
27         _;
28         _ENTERED_ = false;
29     }
30 }
31 
32 // File: contracts/intf/IERC20.sol
33 
34 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     function decimals() external view returns (uint8);
46 
47     function name() external view returns (string memory);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address sender,
99         address recipient,
100         uint256 amount
101     ) external returns (bool);
102 }
103 
104 // File: contracts/lib/SafeMath.sol
105 
106 /*
107 
108     Copyright 2020 DODO ZOO.
109 
110 */
111 
112 /**
113  * @title SafeMath
114  * @author DODO Breeder
115  *
116  * @notice Math operations with safety checks that revert on error
117  */
118 library SafeMath {
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         if (a == 0) {
121             return 0;
122         }
123 
124         uint256 c = a * b;
125         require(c / a == b, "MUL_ERROR");
126 
127         return c;
128     }
129 
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         require(b > 0, "DIVIDING_ERROR");
132         return a / b;
133     }
134 
135     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 quotient = div(a, b);
137         uint256 remainder = a - quotient * b;
138         if (remainder > 0) {
139             return quotient + 1;
140         } else {
141             return quotient;
142         }
143     }
144 
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         require(b <= a, "SUB_ERROR");
147         return a - b;
148     }
149 
150     function add(uint256 a, uint256 b) internal pure returns (uint256) {
151         uint256 c = a + b;
152         require(c >= a, "ADD_ERROR");
153         return c;
154     }
155 
156     function sqrt(uint256 x) internal pure returns (uint256 y) {
157         uint256 z = x / 2 + 1;
158         y = x;
159         while (z < y) {
160             y = z;
161             z = (x / z + z) / 2;
162         }
163     }
164 }
165 
166 // File: contracts/lib/SafeERC20.sol
167 
168 /*
169 
170     Copyright 2020 DODO ZOO.
171     This is a simplified version of OpenZepplin's SafeERC20 library
172 
173 */
174 
175 /**
176  * @title SafeERC20
177  * @dev Wrappers around ERC20 operations that throw on failure (when the token
178  * contract returns false). Tokens that return no value (and instead revert or
179  * throw on failure) are also supported, non-reverting calls are assumed to be
180  * successful.
181  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
182  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
183  */
184 library SafeERC20 {
185     using SafeMath for uint256;
186 
187     function safeTransfer(
188         IERC20 token,
189         address to,
190         uint256 value
191     ) internal {
192         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
193     }
194 
195     function safeTransferFrom(
196         IERC20 token,
197         address from,
198         address to,
199         uint256 value
200     ) internal {
201         _callOptionalReturn(
202             token,
203             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
204         );
205     }
206 
207     /**
208      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
209      * on the return value: the return value is optional (but if data is returned, it must not be false).
210      * @param token The token targeted by the call.
211      * @param data The call data (encoded using abi.encode or one of its variants).
212      */
213     function _callOptionalReturn(IERC20 token, bytes memory data) private {
214         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
215         // we're implementing it ourselves.
216 
217         // A Solidity high level call has three parts:
218         //  1. The target address is checked to verify it contains contract code
219         //  2. The call itself is made, and success asserted
220         //  3. The return value is decoded, which in turn checks the size of the returned data.
221         // solhint-disable-next-line max-line-length
222 
223         // solhint-disable-next-line avoid-low-level-calls
224         (bool success, bytes memory returndata) = address(token).call(data);
225         require(success, "SafeERC20: low-level call failed");
226 
227         if (returndata.length > 0) {
228             // Return data is optional
229             // solhint-disable-next-line max-line-length
230             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
231         }
232     }
233 }
234 
235 // File: contracts/intf/IDODO.sol
236 
237 /*
238 
239     Copyright 2020 DODO ZOO.
240 
241 */
242 
243 interface IDODO {
244     function init(
245         address owner,
246         address supervisor,
247         address maintainer,
248         address baseToken,
249         address quoteToken,
250         address oracle,
251         uint256 lpFeeRate,
252         uint256 mtFeeRate,
253         uint256 k,
254         uint256 gasPriceLimit
255     ) external;
256 
257     function transferOwnership(address newOwner) external;
258 
259     function claimOwnership() external;
260 
261     function sellBaseToken(
262         uint256 amount,
263         uint256 minReceiveQuote,
264         bytes calldata data
265     ) external returns (uint256);
266 
267     function buyBaseToken(
268         uint256 amount,
269         uint256 maxPayQuote,
270         bytes calldata data
271     ) external returns (uint256);
272 
273     function querySellBaseToken(uint256 amount) external view returns (uint256 receiveQuote);
274 
275     function queryBuyBaseToken(uint256 amount) external view returns (uint256 payQuote);
276 
277     function depositBaseTo(address to, uint256 amount) external returns (uint256);
278 
279     function withdrawBase(uint256 amount) external returns (uint256);
280 
281     function withdrawAllBase() external returns (uint256);
282 
283     function depositQuoteTo(address to, uint256 amount) external returns (uint256);
284 
285     function withdrawQuote(uint256 amount) external returns (uint256);
286 
287     function withdrawAllQuote() external returns (uint256);
288 
289     function _BASE_CAPITAL_TOKEN_() external returns (address);
290 
291     function _QUOTE_CAPITAL_TOKEN_() external returns (address);
292 
293     function _BASE_TOKEN_() external returns (address);
294 
295     function _QUOTE_TOKEN_() external returns (address);
296 }
297 
298 // File: contracts/intf/IWETH.sol
299 
300 /*
301 
302     Copyright 2020 DODO ZOO.
303 
304 */
305 
306 interface IWETH {
307     function totalSupply() external view returns (uint256);
308 
309     function balanceOf(address account) external view returns (uint256);
310 
311     function transfer(address recipient, uint256 amount) external returns (bool);
312 
313     function allowance(address owner, address spender) external view returns (uint256);
314 
315     function approve(address spender, uint256 amount) external returns (bool);
316 
317     function transferFrom(
318         address src,
319         address dst,
320         uint256 wad
321     ) external returns (bool);
322 
323     function deposit() external payable;
324 
325     function withdraw(uint256 wad) external;
326 }
327 
328 // File: contracts/DODOEthProxy.sol
329 
330 /*
331 
332     Copyright 2020 DODO ZOO.
333 
334 */
335 
336 interface IDODOZoo {
337     function getDODO(address baseToken, address quoteToken) external view returns (address);
338 }
339 
340 /**
341  * @title DODO Eth Proxy
342  * @author DODO Breeder
343  *
344  * @notice Handle ETH-WETH converting for users. Use it only when WETH is base token
345  */
346 contract DODOEthProxy is ReentrancyGuard {
347     using SafeERC20 for IERC20;
348 
349     address public _DODO_ZOO_;
350     address payable public _WETH_;
351 
352     // ============ Events ============
353 
354     event ProxySellEth(
355         address indexed seller,
356         address indexed quoteToken,
357         uint256 payEth,
358         uint256 receiveQuote
359     );
360 
361     event ProxyBuyEth(
362         address indexed buyer,
363         address indexed quoteToken,
364         uint256 receiveEth,
365         uint256 payQuote
366     );
367 
368     event ProxyDepositEth(address indexed lp, address indexed DODO, uint256 ethAmount);
369 
370     event ProxyWithdrawEth(address indexed lp, address indexed DODO, uint256 ethAmount);
371 
372     // ============ Functions ============
373 
374     constructor(address dodoZoo, address payable weth) public {
375         _DODO_ZOO_ = dodoZoo;
376         _WETH_ = weth;
377     }
378 
379     fallback() external payable {
380         require(msg.sender == _WETH_, "WE_SAVED_YOUR_ETH_:)");
381     }
382 
383     receive() external payable {
384         require(msg.sender == _WETH_, "WE_SAVED_YOUR_ETH_:)");
385     }
386 
387     function sellEthTo(
388         address quoteTokenAddress,
389         uint256 ethAmount,
390         uint256 minReceiveTokenAmount
391     ) external payable preventReentrant returns (uint256 receiveTokenAmount) {
392         require(msg.value == ethAmount, "ETH_AMOUNT_NOT_MATCH");
393         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(_WETH_, quoteTokenAddress);
394         require(DODO != address(0), "DODO_NOT_EXIST");
395         IWETH(_WETH_).deposit{value: ethAmount}();
396         IWETH(_WETH_).approve(DODO, ethAmount);
397         receiveTokenAmount = IDODO(DODO).sellBaseToken(ethAmount, minReceiveTokenAmount, "");
398         _transferOut(quoteTokenAddress, msg.sender, receiveTokenAmount);
399         emit ProxySellEth(msg.sender, quoteTokenAddress, ethAmount, receiveTokenAmount);
400         return receiveTokenAmount;
401     }
402 
403     function buyEthWith(
404         address quoteTokenAddress,
405         uint256 ethAmount,
406         uint256 maxPayTokenAmount
407     ) external preventReentrant returns (uint256 payTokenAmount) {
408         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(_WETH_, quoteTokenAddress);
409         require(DODO != address(0), "DODO_NOT_EXIST");
410         payTokenAmount = IDODO(DODO).queryBuyBaseToken(ethAmount);
411         _transferIn(quoteTokenAddress, msg.sender, payTokenAmount);
412         IERC20(quoteTokenAddress).approve(DODO, payTokenAmount);
413         IDODO(DODO).buyBaseToken(ethAmount, maxPayTokenAmount, "");
414         IWETH(_WETH_).withdraw(ethAmount);
415         msg.sender.transfer(ethAmount);
416         emit ProxyBuyEth(msg.sender, quoteTokenAddress, ethAmount, payTokenAmount);
417         return payTokenAmount;
418     }
419 
420     function depositEth(uint256 ethAmount, address quoteTokenAddress)
421         external
422         payable
423         preventReentrant
424     {
425         require(msg.value == ethAmount, "ETH_AMOUNT_NOT_MATCH");
426         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(_WETH_, quoteTokenAddress);
427         require(DODO != address(0), "DODO_NOT_EXIST");
428         IWETH(_WETH_).deposit{value: ethAmount}();
429         IWETH(_WETH_).approve(DODO, ethAmount);
430         IDODO(DODO).depositBaseTo(msg.sender, ethAmount);
431         emit ProxyDepositEth(msg.sender, DODO, ethAmount);
432     }
433 
434     function withdrawEth(uint256 ethAmount, address quoteTokenAddress)
435         external
436         preventReentrant
437         returns (uint256 withdrawAmount)
438     {
439         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(_WETH_, quoteTokenAddress);
440         require(DODO != address(0), "DODO_NOT_EXIST");
441         address ethLpToken = IDODO(DODO)._BASE_CAPITAL_TOKEN_();
442 
443         // transfer all pool shares to proxy
444         uint256 lpBalance = IERC20(ethLpToken).balanceOf(msg.sender);
445         IERC20(ethLpToken).transferFrom(msg.sender, address(this), lpBalance);
446         IDODO(DODO).withdrawBase(ethAmount);
447 
448         // transfer remain shares back to msg.sender
449         lpBalance = IERC20(ethLpToken).balanceOf(address(this));
450         IERC20(ethLpToken).transfer(msg.sender, lpBalance);
451 
452         // because of withdraw penalty, withdrawAmount may not equal to ethAmount
453         // query weth amount first and than transfer ETH to msg.sender
454         uint256 wethAmount = IERC20(_WETH_).balanceOf(address(this));
455         IWETH(_WETH_).withdraw(wethAmount);
456         msg.sender.transfer(wethAmount);
457         emit ProxyWithdrawEth(msg.sender, DODO, wethAmount);
458         return wethAmount;
459     }
460 
461     function withdrawAllEth(address quoteTokenAddress)
462         external
463         preventReentrant
464         returns (uint256 withdrawAmount)
465     {
466         address DODO = IDODOZoo(_DODO_ZOO_).getDODO(_WETH_, quoteTokenAddress);
467         require(DODO != address(0), "DODO_NOT_EXIST");
468         address ethLpToken = IDODO(DODO)._BASE_CAPITAL_TOKEN_();
469 
470         // transfer all pool shares to proxy
471         uint256 lpBalance = IERC20(ethLpToken).balanceOf(msg.sender);
472         IERC20(ethLpToken).transferFrom(msg.sender, address(this), lpBalance);
473         IDODO(DODO).withdrawAllBase();
474 
475         // because of withdraw penalty, withdrawAmount may not equal to ethAmount
476         // query weth amount first and than transfer ETH to msg.sender
477         uint256 wethAmount = IERC20(_WETH_).balanceOf(address(this));
478         IWETH(_WETH_).withdraw(wethAmount);
479         msg.sender.transfer(wethAmount);
480         emit ProxyWithdrawEth(msg.sender, DODO, wethAmount);
481         return wethAmount;
482     }
483 
484     // ============ Helper Functions ============
485 
486     function _transferIn(
487         address tokenAddress,
488         address from,
489         uint256 amount
490     ) internal {
491         IERC20(tokenAddress).safeTransferFrom(from, address(this), amount);
492     }
493 
494     function _transferOut(
495         address tokenAddress,
496         address to,
497         uint256 amount
498     ) internal {
499         IERC20(tokenAddress).safeTransfer(to, amount);
500     }
501 }