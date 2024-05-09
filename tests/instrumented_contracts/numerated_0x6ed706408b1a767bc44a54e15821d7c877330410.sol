1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.13;
3 
4 interface IUniswapV2Router01 {
5     function factory() external pure returns (address);
6 
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint256 amountADesired,
13         uint256 amountBDesired,
14         uint256 amountAMin,
15         uint256 amountBMin,
16         address to,
17         uint256 deadline
18     )
19         external
20         returns (
21             uint256 amountA,
22             uint256 amountB,
23             uint256 liquidity
24         );
25 
26     function addLiquidityETH(
27         address token,
28         uint256 amountTokenDesired,
29         uint256 amountTokenMin,
30         uint256 amountETHMin,
31         address to,
32         uint256 deadline
33     )
34         external
35         payable
36         returns (
37             uint256 amountToken,
38             uint256 amountETH,
39             uint256 liquidity
40         );
41 
42     function removeLiquidity(
43         address tokenA,
44         address tokenB,
45         uint256 liquidity,
46         uint256 amountAMin,
47         uint256 amountBMin,
48         address to,
49         uint256 deadline
50     ) external returns (uint256 amountA, uint256 amountB);
51 
52     function removeLiquidityETH(
53         address token,
54         uint256 liquidity,
55         uint256 amountTokenMin,
56         uint256 amountETHMin,
57         address to,
58         uint256 deadline
59     ) external returns (uint256 amountToken, uint256 amountETH);
60 
61     function removeLiquidityWithPermit(
62         address tokenA,
63         address tokenB,
64         uint256 liquidity,
65         uint256 amountAMin,
66         uint256 amountBMin,
67         address to,
68         uint256 deadline,
69         bool approveMax,
70         uint8 v,
71         bytes32 r,
72         bytes32 s
73     ) external returns (uint256 amountA, uint256 amountB);
74 
75     function removeLiquidityETHWithPermit(
76         address token,
77         uint256 liquidity,
78         uint256 amountTokenMin,
79         uint256 amountETHMin,
80         address to,
81         uint256 deadline,
82         bool approveMax,
83         uint8 v,
84         bytes32 r,
85         bytes32 s
86     ) external returns (uint256 amountToken, uint256 amountETH);
87 
88     function swapExactTokensForTokens(
89         uint256 amountIn,
90         uint256 amountOutMin,
91         address[] calldata path,
92         address to,
93         uint256 deadline
94     ) external returns (uint256[] memory amounts);
95 
96     function swapTokensForExactTokens(
97         uint256 amountOut,
98         uint256 amountInMax,
99         address[] calldata path,
100         address to,
101         uint256 deadline
102     ) external returns (uint256[] memory amounts);
103 
104     function swapExactETHForTokens(
105         uint256 amountOutMin,
106         address[] calldata path,
107         address to,
108         uint256 deadline
109     ) external payable returns (uint256[] memory amounts);
110 
111     function swapTokensForExactETH(
112         uint256 amountOut,
113         uint256 amountInMax,
114         address[] calldata path,
115         address to,
116         uint256 deadline
117     ) external returns (uint256[] memory amounts);
118 
119     function swapExactTokensForETH(
120         uint256 amountIn,
121         uint256 amountOutMin,
122         address[] calldata path,
123         address to,
124         uint256 deadline
125     ) external returns (uint256[] memory amounts);
126 
127     function swapETHForExactTokens(
128         uint256 amountOut,
129         address[] calldata path,
130         address to,
131         uint256 deadline
132     ) external payable returns (uint256[] memory amounts);
133 
134     function quote(
135         uint256 amountA,
136         uint256 reserveA,
137         uint256 reserveB
138     ) external pure returns (uint256 amountB);
139 
140     function getAmountOut(
141         uint256 amountIn,
142         uint256 reserveIn,
143         uint256 reserveOut
144     ) external pure returns (uint256 amountOut);
145 
146     function getAmountIn(
147         uint256 amountOut,
148         uint256 reserveIn,
149         uint256 reserveOut
150     ) external pure returns (uint256 amountIn);
151 
152     function getAmountsOut(uint256 amountIn, address[] calldata path)
153         external
154         view
155         returns (uint256[] memory amounts);
156 
157     function getAmountsIn(uint256 amountOut, address[] calldata path)
158         external
159         view
160         returns (uint256[] memory amounts);
161 }
162 
163 interface IUniswapV2Router02 is IUniswapV2Router01 {
164     function removeLiquidityETHSupportingFeeOnTransferTokens(
165         address token,
166         uint256 liquidity,
167         uint256 amountTokenMin,
168         uint256 amountETHMin,
169         address to,
170         uint256 deadline
171     ) external returns (uint256 amountETH);
172 
173     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
174         address token,
175         uint256 liquidity,
176         uint256 amountTokenMin,
177         uint256 amountETHMin,
178         address to,
179         uint256 deadline,
180         bool approveMax,
181         uint8 v,
182         bytes32 r,
183         bytes32 s
184     ) external returns (uint256 amountETH);
185 
186     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
187         uint256 amountIn,
188         uint256 amountOutMin,
189         address[] calldata path,
190         address to,
191         uint256 deadline
192     ) external;
193 
194     function swapExactETHForTokensSupportingFeeOnTransferTokens(
195         uint256 amountOutMin,
196         address[] calldata path,
197         address to,
198         uint256 deadline
199     ) external payable;
200 
201     function swapExactTokensForETHSupportingFeeOnTransferTokens(
202         uint256 amountIn,
203         uint256 amountOutMin,
204         address[] calldata path,
205         address to,
206         uint256 deadline
207     ) external;
208 }
209 
210 /*
211  * @dev Provides information about the current execution context, including the
212  * sender of the transaction and its data. While these are generally available
213  * via msg.sender and msg.data, they should not be accessed in such a direct
214  * manner, since when dealing with meta-transactions the account sending and
215  * paying for execution may not be the actual sender (as far as an application
216  * is concerned).
217  *
218  * This contract is only required for intermediate, library-like contracts.
219  */
220 abstract contract Context {
221     function _msgSender() internal view virtual returns (address) {
222         return msg.sender;
223     }
224 
225     function _msgData() internal view virtual returns (bytes calldata) {
226         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
227         return msg.data;
228     }
229 }
230 
231 /**
232  * @dev Contract module which provides a basic access control mechanism, where
233  * there is an account (an owner) that can be granted exclusive access to
234  * specific functions.
235  *
236  * By default, the owner account will be the one that deploys the contract. This
237  * can later be changed with {transferOwnership}.
238  *
239  * This module is used through inheritance. It will make available the modifier
240  * `onlyOwner`, which can be applied to your functions to restrict their use to
241  * the owner.
242  */
243 abstract contract Ownable is Context {
244     address private _owner;
245 
246     event OwnershipTransferred(
247         address indexed previousOwner,
248         address indexed newOwner
249     );
250 
251     /**
252      * @dev Initializes the contract setting the deployer as the initial owner.
253      */
254     constructor() {
255         address msgSender = _msgSender();
256         _owner = msgSender;
257         emit OwnershipTransferred(address(0), msgSender);
258     }
259 
260     /**
261      * @dev Returns the address of the current owner.
262      */
263     function owner() public view virtual returns (address) {
264         return _owner;
265     }
266 
267     /**
268      * @dev Throws if called by any account other than the owner.
269      */
270     modifier onlyOwner() {
271         require(owner() == _msgSender(), "Ownable: caller is not the owner");
272         _;
273     }
274 
275     /**
276      * @dev Leaves the contract without owner. It will not be possible to call
277      * `onlyOwner` functions anymore. Can only be called by the current owner.
278      *
279      * NOTE: Renouncing ownership will leave the contract without an owner,
280      * thereby removing any functionality that is only available to the owner.
281      */
282     function renounceOwnership() public virtual onlyOwner {
283         emit OwnershipTransferred(_owner, address(0));
284         _owner = address(0);
285     }
286 
287     /**
288      * @dev Transfers ownership of the contract to a new account (`newOwner`).
289      * Can only be called by the current owner.
290      */
291     function transferOwnership(address newOwner) public virtual onlyOwner {
292         require(
293             newOwner != address(0),
294             "Ownable: new owner is the zero address"
295         );
296         emit OwnershipTransferred(_owner, newOwner);
297         _owner = newOwner;
298     }
299 }
300 
301 /**
302  * @dev Interface of the ERC20 standard as defined in the EIP.
303  */
304 interface IERC20 {
305     /**
306      * @dev Returns the amount of tokens in existence.
307      */
308     function totalSupply() external view returns (uint256);
309 
310     /**
311      * @dev Returns the amount of tokens owned by `account`.
312      */
313     function balanceOf(address account) external view returns (uint256);
314 
315     /**
316      * @dev Moves `amount` tokens from the caller's account to `recipient`.
317      *
318      * Returns a boolean value indicating whether the operation succeeded.
319      *
320      * Emits a {Transfer} event.
321      */
322     function transfer(address recipient, uint256 amount)
323         external
324         returns (bool);
325 
326     /**
327      * @dev Returns the remaining number of tokens that `spender` will be
328      * allowed to spend on behalf of `owner` through {transferFrom}. This is
329      * zero by default.
330      *
331      * This value changes when {approve} or {transferFrom} are called.
332      */
333     function allowance(address owner, address spender)
334         external
335         view
336         returns (uint256);
337 
338     /**
339      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
340      *
341      * Returns a boolean value indicating whether the operation succeeded.
342      *
343      * IMPORTANT: Beware that changing an allowance with this method brings the risk
344      * that someone may use both the old and the new allowance by unfortunate
345      * transaction ordering. One possible solution to mitigate this race
346      * condition is to first reduce the spender's allowance to 0 and set the
347      * desired value afterwards:
348      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349      *
350      * Emits an {Approval} event.
351      */
352     function approve(address spender, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Moves `amount` tokens from `sender` to `recipient` using the
356      * allowance mechanism. `amount` is then deducted from the caller's
357      * allowance.
358      *
359      * Returns a boolean value indicating whether the operation succeeded.
360      *
361      * Emits a {Transfer} event.
362      */
363     function transferFrom(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) external returns (bool);
368 
369     /**
370      * @dev Emitted when `value` tokens are moved from one account (`from`) to
371      * another (`to`).
372      *
373      * Note that `value` may be zero.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 
377     /**
378      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
379      * a call to {approve}. `value` is the new allowance.
380      */
381     event Approval(
382         address indexed owner,
383         address indexed spender,
384         uint256 value
385     );
386 }
387 
388 contract LuffyV2Swap is Ownable {
389     // Mainnet
390     IUniswapV2Router02 public router =
391         IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
392     IERC20 public luffy = IERC20(0xC1bfcCd4c29813eDe019D00D2179Eea838a67703);
393     IERC20 public goku = IERC20(0xA64dFe8D86963151E6496BEe513E366F6e42ED79);
394     IERC20 public chopper = IERC20(0x28c5805B64d163588A909012a628b5a03c1041f9);
395     IERC20 public deku = IERC20(0xA1a88cea335EDAF30ce90F103f1434a773ea46BD);
396     IERC20 public LuffyV2 = IERC20(0x65e307C39F52Edae72e1b803C5Ef7dAB5B5f337E);
397 
398     // dev Wallets
399     mapping(address => address) public devWallets;
400 
401     constructor() {
402         // Put the dev addresses here
403         devWallets[address(luffy)] = 0x8E1703E600f3A667482C4cedF9c5042c4F9E1fA5;
404         devWallets[address(goku)] = 0x3D38910c5F9950ceF884598F8d76dF010E9E9F1c;
405         devWallets[address(chopper)] = 0xB8Ed4BC65b06779a1679948f167af3757f353124;
406         devWallets[address(deku)] = 0x3ca891236214fBaa94FB1f4Ed1e7Fc88F8A115D5;
407     }
408 
409     bool public locked = false;
410 
411     uint256 public minSwapAmount = 10**9;
412 
413     modifier locktheswap() {
414         require(!locked, "Swap locked.");
415         _;
416     }
417 
418     event TokenSwapped(
419         address receiver,
420         address depositToken,
421         uint256 depositAmount,
422         uint256 withdrawalAmount
423     );
424 
425     function getSwapAmountOut(address _address, uint256 amountIn)
426         public
427         view
428         returns (uint256)
429     {
430         if (address(luffy) == _address) {
431             return amountIn;
432         } else {
433             address[] memory path = new address[](3);
434             path[0] = _address;
435             path[1] = address(router.WETH());
436             path[2] = address(luffy);
437             uint256[] memory price = router.getAmountsOut(amountIn, path);
438             return price[2];
439         }
440     }
441 
442     function swapToken(address _token, uint256 amount) public locktheswap {
443         require(amount >= minSwapAmount, "Insufficient Swap Amount");
444         IERC20 token = _token == address(luffy)
445             ? luffy
446             : _token == address(goku)
447             ? goku
448             : _token == address(chopper)
449             ? chopper
450             : _token == address(deku)
451             ? deku
452             : IERC20(address(0));
453         require(address(token) != address(0), "Security Check: Invalid token");
454         uint256 swapAmount = getSwapAmountOut(_token, amount);
455         require(
456             LuffyV2.allowance(owner(), address(this)) >= swapAmount,
457             "Insufficient withdrawal amount"
458         );
459         token.transferFrom(msg.sender, devWallets[_token], amount);
460         LuffyV2.transferFrom(owner(), msg.sender, swapAmount);
461         emit TokenSwapped(msg.sender, _token, amount, swapAmount);
462     }
463 
464     function withdrawEth(address to) public onlyOwner {
465         payable(to).transfer(address(this).balance);
466     }
467 
468     function changeSwapState(bool _state) public onlyOwner {
469         locked = !_state;
470     }
471 
472     function changeLuffyV2(address _address) public onlyOwner {
473         LuffyV2 = IERC20(_address);
474     }
475 
476     function setMinimumSwapAmount(uint256 _amount) public onlyOwner {
477         minSwapAmount = _amount;
478     }
479 
480     // owner can change dev wallet all the token deposits will go to the dev wallet of a token.
481     function changedevWallet(address _tokenAddress, address _newDevAddress)
482         public
483         onlyOwner
484     {
485         devWallets[_tokenAddress] = _newDevAddress;
486     }
487 }