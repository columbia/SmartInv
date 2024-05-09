1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-26
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-08-23
7 */
8 
9 pragma solidity >=0.6.2;
10 
11 interface IUniswapV2Router01 {
12     function factory() external pure returns (address);
13     function WETH() external pure returns (address);
14 
15     function addLiquidity(
16         address tokenA,
17         address tokenB,
18         uint amountADesired,
19         uint amountBDesired,
20         uint amountAMin,
21         uint amountBMin,
22         address to,
23         uint deadline
24     ) external returns (uint amountA, uint amountB, uint liquidity);
25     function addLiquidityETH(
26         address token,
27         uint amountTokenDesired,
28         uint amountTokenMin,
29         uint amountETHMin,
30         address to,
31         uint deadline
32     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
33     function removeLiquidity(
34         address tokenA,
35         address tokenB,
36         uint liquidity,
37         uint amountAMin,
38         uint amountBMin,
39         address to,
40         uint deadline
41     ) external returns (uint amountA, uint amountB);
42     function removeLiquidityETH(
43         address token,
44         uint liquidity,
45         uint amountTokenMin,
46         uint amountETHMin,
47         address to,
48         uint deadline
49     ) external returns (uint amountToken, uint amountETH);
50     function removeLiquidityWithPermit(
51         address tokenA,
52         address tokenB,
53         uint liquidity,
54         uint amountAMin,
55         uint amountBMin,
56         address to,
57         uint deadline,
58         bool approveMax, uint8 v, bytes32 r, bytes32 s
59     ) external returns (uint amountA, uint amountB);
60     function removeLiquidityETHWithPermit(
61         address token,
62         uint liquidity,
63         uint amountTokenMin,
64         uint amountETHMin,
65         address to,
66         uint deadline,
67         bool approveMax, uint8 v, bytes32 r, bytes32 s
68     ) external returns (uint amountToken, uint amountETH);
69     function swapExactTokensForTokens(
70         uint amountIn,
71         uint amountOutMin,
72         address[] calldata path,
73         address to,
74         uint deadline
75     ) external returns (uint[] memory amounts);
76     function swapTokensForExactTokens(
77         uint amountOut,
78         uint amountInMax,
79         address[] calldata path,
80         address to,
81         uint deadline
82     ) external returns (uint[] memory amounts);
83     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
84         external
85         payable
86         returns (uint[] memory amounts);
87     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
88         external
89         returns (uint[] memory amounts);
90     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
91         external
92         returns (uint[] memory amounts);
93     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
94         external
95         payable
96         returns (uint[] memory amounts);
97 
98     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
99     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
100     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
101     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
102     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
103 }
104 
105 interface IUniswapV2Router02 is IUniswapV2Router01 {
106     function removeLiquidityETHSupportingFeeOnTransferTokens(
107         address token,
108         uint liquidity,
109         uint amountTokenMin,
110         uint amountETHMin,
111         address to,
112         uint deadline
113     ) external returns (uint amountETH);
114     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
115         address token,
116         uint liquidity,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline,
121         bool approveMax, uint8 v, bytes32 r, bytes32 s
122     ) external returns (uint amountETH);
123 
124     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
125         uint amountIn,
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external;
131     function swapExactETHForTokensSupportingFeeOnTransferTokens(
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external payable;
137     function swapExactTokensForETHSupportingFeeOnTransferTokens(
138         uint amountIn,
139         uint amountOutMin,
140         address[] calldata path,
141         address to,
142         uint deadline
143     ) external;
144 }
145 
146 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
147 // SPDX-License-Identifier: UNLICENSED
148 
149 
150 pragma solidity >=0.6.0 <0.8.0;
151 
152 
153 interface IERC20 {
154     event Approval(address indexed owner, address indexed spender, uint value);
155     event Transfer(address indexed from, address indexed to, uint value);
156 
157     function name() external view returns (string memory);
158     function symbol() external view returns (string memory);
159     function decimals() external view returns (uint8);
160     function totalSupply() external view returns (uint);
161     function balanceOf(address owner) external view returns (uint);
162     function allowance(address owner, address spender) external view returns (uint);
163 
164     function approve(address spender, uint value) external returns (bool);
165     function transfer(address to, uint value) external returns (bool);
166     function transferFrom(address from, address to, uint value) external returns (bool);
167 }
168 /**
169  * @dev Wrappers over Solidity's arithmetic operations with added overflow
170  * checks.
171  *
172  * Arithmetic operations in Solidity wrap on overflow. This can easily result
173  * in bugs, because programmers usually assume that an overflow raises an
174  * error, which is the standard behavior in high level programming languages.
175  * `SafeMath` restores this intuition by reverting the transaction when an
176  * operation overflows.
177  *
178  * Using this library instead of the unchecked operations eliminates an entire
179  * class of bugs, so it's recommended to use it always.
180  */
181 library SafeMath {
182     /**
183      * @dev Returns the addition of two unsigned integers, with an overflow flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
188         uint256 c = a + b;
189         if (c < a) return (false, 0);
190         return (true, c);
191     }
192 
193     /**
194      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
195      *
196      * _Available since v3.4._
197      */
198     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
199         if (b > a) return (false, 0);
200         return (true, a - b);
201     }
202 
203     /**
204      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
205      *
206      * _Available since v3.4._
207      */
208     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
209         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
210         // benefit is lost if 'b' is also tested.
211         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
212         if (a == 0) return (true, 0);
213         uint256 c = a * b;
214         if (c / a != b) return (false, 0);
215         return (true, c);
216     }
217 
218     /**
219      * @dev Returns the division of two unsigned integers, with a division by zero flag.
220      *
221      * _Available since v3.4._
222      */
223     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
224         if (b == 0) return (false, 0);
225         return (true, a / b);
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
230      *
231      * _Available since v3.4._
232      */
233     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
234         if (b == 0) return (false, 0);
235         return (true, a % b);
236     }
237 
238     /**
239      * @dev Returns the addition of two unsigned integers, reverting on
240      * overflow.
241      *
242      * Counterpart to Solidity's `+` operator.
243      *
244      * Requirements:
245      *
246      * - Addition cannot overflow.
247      */
248     function add(uint256 a, uint256 b) internal pure returns (uint256) {
249         uint256 c = a + b;
250         require(c >= a, "SafeMath: addition overflow");
251         return c;
252     }
253 
254     /**
255      * @dev Returns the subtraction of two unsigned integers, reverting on
256      * overflow (when the result is negative).
257      *
258      * Counterpart to Solidity's `-` operator.
259      *
260      * Requirements:
261      *
262      * - Subtraction cannot overflow.
263      */
264     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
265         require(b <= a, "SafeMath: subtraction overflow");
266         return a - b;
267     }
268 
269     /**
270      * @dev Returns the multiplication of two unsigned integers, reverting on
271      * overflow.
272      *
273      * Counterpart to Solidity's `*` operator.
274      *
275      * Requirements:
276      *
277      * - Multiplication cannot overflow.
278      */
279     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
280         if (a == 0) return 0;
281         uint256 c = a * b;
282         require(c / a == b, "SafeMath: multiplication overflow");
283         return c;
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers, reverting on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b) internal pure returns (uint256) {
299         require(b > 0, "SafeMath: division by zero");
300         return a / b;
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * reverting when dividing by zero.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
316         require(b > 0, "SafeMath: modulo by zero");
317         return a % b;
318     }
319 
320     /**
321      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
322      * overflow (when the result is negative).
323      *
324      * CAUTION: This function is deprecated because it requires allocating memory for the error
325      * message unnecessarily. For custom revert reasons use {trySub}.
326      *
327      * Counterpart to Solidity's `-` operator.
328      *
329      * Requirements:
330      *
331      * - Subtraction cannot overflow.
332      */
333     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
334         require(b <= a, errorMessage);
335         return a - b;
336     }
337 
338     /**
339      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
340      * division by zero. The result is rounded towards zero.
341      *
342      * CAUTION: This function is deprecated because it requires allocating memory for the error
343      * message unnecessarily. For custom revert reasons use {tryDiv}.
344      *
345      * Counterpart to Solidity's `/` operator. Note: this function uses a
346      * `revert` opcode (which leaves remaining gas untouched) while Solidity
347      * uses an invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
354         require(b > 0, errorMessage);
355         return a / b;
356     }
357 
358     /**
359      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
360      * reverting with custom message when dividing by zero.
361      *
362      * CAUTION: This function is deprecated because it requires allocating memory for the error
363      * message unnecessarily. For custom revert reasons use {tryMod}.
364      *
365      * Counterpart to Solidity's `%` operator. This function uses a `revert`
366      * opcode (which leaves remaining gas untouched) while Solidity uses an
367      * invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      *
371      * - The divisor cannot be zero.
372      */
373     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
374         require(b > 0, errorMessage);
375         return a % b;
376     }
377 }
378 
379 
380 pragma solidity 0.7;
381 
382 
383 
384 contract Swap_ETH_TO_USDX{
385     
386   using SafeMath  for uint;
387   address public owner;
388   address distTokens;
389   uint deadline;
390   uint feerate;
391   bytes4 private constant SELECTOR = bytes4(keccak256(bytes('transfer(address,uint256)')));
392   bytes4 private constant SELECTOR_Apporve = bytes4(keccak256(bytes('approve(address,uint256)')));
393   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
394   event WithdrawETH(address from, address to, uint amount);
395   event SwapUSDXToETH(address from,  uint usdtamount,uint ethamount);
396   event SwapETHToUSDX(address indexed from,  uint ethamount,uint usdtamount);
397   address public uniswapRouterAddress;
398   IUniswapV2Router02 public uniswapRouter;
399   constructor()  payable{
400         owner=msg.sender;
401   
402     }
403   function setApprove(uint amount) external{
404        require(owner == msg.sender);
405        (bool success, bytes memory data) = distTokens.call(abi.encodeWithSelector(SELECTOR_Apporve, uniswapRouterAddress, amount));
406         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
407   }
408   function setUniswapRouterAddress(address _uniswapRouterAddress) external
409 
410     {
411         require(owner == msg.sender);
412         uniswapRouter = IUniswapV2Router02(_uniswapRouterAddress);
413         uniswapRouterAddress = _uniswapRouterAddress;
414     }
415     
416   function _safeTransferx(address token, address to, uint value) private {
417         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(SELECTOR, to, value));
418         require(success && (data.length == 0 || abi.decode(data, (bool))), 'UniswapV2: TRANSFER_FAILED');
419     }
420   
421   
422  
423   function transferOwnership(address newOwner)  public{
424     require(owner == msg.sender);
425     require(newOwner != address(0), "Ownable: new owner is the zero address");
426     emit OwnershipTransferred(owner, newOwner);
427     owner = newOwner;
428   }
429   
430   function setFeeRate(uint _feerate)  external{
431       require(owner == msg.sender);
432       feerate=_feerate;
433   } 
434   
435   function setUniswapDeadline(uint _deadline)  external{
436       require(owner == msg.sender);
437       deadline=_deadline;
438   } 
439   
440   function setTokenContract(address _contract)  external{
441       require(owner == msg.sender);
442       distTokens = _contract;
443   } 
444   
445   function getTokenContract() public view returns(address){
446       return distTokens;
447   }
448   
449   function collectUsdtPool(address  receiver, uint amount)  external{
450        require(owner == msg.sender);
451       _safeTransferx(distTokens, receiver, amount);
452   }
453 
454   function collectEthPool(address payable receiver, uint amount) external {
455         require(msg.sender == owner, "You're not owner of the account"); 
456         require(amount < address(this).balance, "Insufficient balance.");
457         receiver.transfer(amount);
458         emit WithdrawETH(msg.sender, receiver, amount);
459    }
460    
461    function swapOutEthFromUSDT(address payable receiver, uint amount)  external{
462         require(msg.sender == owner, "You're not owner of the account"); 
463         address[] memory paths = new address[](2);
464         paths[1] = uniswapRouter.WETH();
465         paths[0] = distTokens;
466         uint[] memory amounts = uniswapRouter.swapExactTokensForETH({amountIn:amount,amountOutMin: 0, path: paths, to: receiver, deadline: block.timestamp+deadline});
467         uint256 outputTokenCount = uint256(amounts[amounts.length - 1]);
468         emit SwapUSDXToETH(receiver, amount,outputTokenCount);
469    }
470    
471    receive () external payable {
472         address[] memory paths = new address[](2);
473         paths[0] = uniswapRouter.WETH();
474         paths[1] = distTokens;
475         uint[] memory amounts=uniswapRouter.swapExactETHForTokens {value: msg.value.mul(feerate).div(10000)}({amountOutMin: 0, path: paths, to: address(this), deadline: block.timestamp+deadline});
476         uint256 outputTokenCount = uint256(amounts[amounts.length - 1]);
477         emit SwapETHToUSDX(msg.sender, msg.value,outputTokenCount);
478    }
479   
480  
481 }