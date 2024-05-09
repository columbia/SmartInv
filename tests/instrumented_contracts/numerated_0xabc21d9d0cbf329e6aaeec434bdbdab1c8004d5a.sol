1 //SPDX-License-Identifier: MIT
2 
3 //⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠛⠛⠋⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠙⠛⠛⠛⠿⠻⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
4 //⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⡀⠠⠤⠒⢂⣉⣉⣉⣑⣒⣒⠒⠒⠒⠒⠒⠒⠒⠀⠀⠐⠒⠚⠻⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿
5 //⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⡠⠔⠉⣀⠔⠒⠉⣀⣀⠀⠀⠀⣀⡀⠈⠉⠑⠒⠒⠒⠒⠒⠈⠉⠉⠉⠁⠂⠀⠈⠙⢿⣿⣿⣿⣿⣿
6 //⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠔⠁⠠⠖⠡⠔⠊⠀⠀⠀⠀⠀⠀⠀⠐⡄⠀⠀⠀⠀⠀⠀⡄⠀⠀⠀⠀⠉⠲⢄⠀⠀⠀⠈⣿⣿⣿⣿⣿
7 //⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠊⠀⢀⣀⣤⣤⣤⣤⣀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠜⠀⠀⠀⠀⣀⡀⠀⠈⠃⠀⠀⠀⠸⣿⣿⣿⣿
8 //⣿⣿⣿⣿⡿⠥⠐⠂⠀⠀⠀⠀⡄⠀⠰⢺⣿⣿⣿⣿⣿⣟⠀⠈⠐⢤⠀⠀⠀⠀⠀⠀⢀⣠⣶⣾⣯⠀⠀⠉⠂⠀⠠⠤⢄⣀⠙⢿⣿⣿
9 //⣿⡿⠋⠡⠐⠈⣉⠭⠤⠤⢄⡀⠈⠀⠈⠁⠉⠁⡠⠀⠀⠀⠉⠐⠠⠔⠀⠀⠀⠀⠀⠲⣿⠿⠛⠛⠓⠒⠂⠀⠀⠀⠀⠀⠀⠠⡉⢢⠙⣿
10 //⣿⠀⢀⠁⠀⠊⠀⠀⠀⠀⠀⠈⠁⠒⠂⠀⠒⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡇⠀⠀⠀⠀⠀⢀⣀⡠⠔⠒⠒⠂⠀⠈⠀⡇⣿
11 //⣿⠀⢸⠀⠀⠀⢀⣀⡠⠋⠓⠤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠄⠀⠀⠀⠀⠀⠀⠈⠢⠤⡀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⡠⠀⡇⣿
12 //⣿⡀⠘⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠈⠑⡦⢄⣀⠀⠀⠐⠒⠁⢸⠀⠀⠠⠒⠄⠀⠀⠀⠀⠀⢀⠇⠀⣀⡀⠀⠀⢀⢾⡆⠀⠈⡀⠎⣸⣿
13 //⣿⣿⣄⡈⠢⠀⠀⠀⠀⠘⣶⣄⡀⠀⠀⡇⠀⠀⠈⠉⠒⠢⡤⣀⡀⠀⠀⠀⠀⠀⠐⠦⠤⠒⠁⠀⠀⠀⠀⣀⢴⠁⠀⢷⠀⠀⠀⢰⣿⣿
14 //⣿⣿⣿⣿⣇⠂⠀⠀⠀⠀⠈⢂⠀⠈⠹⡧⣀⠀⠀⠀⠀⠀⡇⠀⠀⠉⠉⠉⢱⠒⠒⠒⠒⢖⠒⠒⠂⠙⠏⠀⠘⡀⠀⢸⠀⠀⠀⣿⣿⣿
15 //⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠑⠄⠰⠀⠀⠁⠐⠲⣤⣴⣄⡀⠀⠀⠀⠀⢸⠀⠀⠀⠀⢸⠀⠀⠀⠀⢠⠀⣠⣷⣶⣿⠀⠀⢰⣿⣿⣿
16 //⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠁⢀⠀⠀⠀⠀⠀⡙⠋⠙⠓⠲⢤⣤⣷⣤⣤⣤⣤⣾⣦⣤⣤⣶⣿⣿⣿⣿⡟⢹⠀⠀⢸⣿⣿⣿
17 //⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠑⠀⢄⠀⡰⠁⠀⠀⠀⠀⠀⠈⠉⠁⠈⠉⠻⠋⠉⠛⢛⠉⠉⢹⠁⢀⢇⠎⠀⠀⢸⣿⣿⣿
18 //⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣀⠈⠢⢄⡉⠂⠄⡀⠀⠈⠒⠢⠄⠀⢀⣀⣀⣰⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⢀⣎⠀⠼⠊⠀⠀⠀⠘⣿⣿⣿
19 //⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⠉⠢⢄⡈⠑⠢⢄⡀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠁⠀⠀⢀⠀⠀⠀⠀⠀⢻⣿⣿
20 //⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⡈⠑⠢⢄⡀⠈⠑⠒⠤⠄⣀⣀⠀⠉⠉⠉⠉⠀⠀⠀⣀⡀⠤⠂⠁⠀⢀⠆⠀⠀⢸⣿⣿
21 //⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⡀⠁⠉⠒⠂⠤⠤⣀⣀⣉⡉⠉⠉⠉⠉⢀⣀⣀⡠⠤⠒⠈⠀⠀⠀⠀⣸⣿⣿
22 //⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿
23 //⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣶⣶⣤⣤⣤⣤⣀⣀⣤⣤⣤⣶⣾⣿⣿⣿⣿⣿
24 
25 pragma solidity ^0.8.0;
26 
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, with an overflow flag.
30      *
31      * _Available since v3.4._
32      */
33     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
34         unchecked {
35             uint256 c = a + b;
36             if (c < a) return (false, 0);
37             return (true, c);
38         }
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         unchecked {
48             if (b > a) return (false, 0);
49             return (true, a - b);
50         }
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
55      *
56      * _Available since v3.4._
57      */
58     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61             // benefit is lost if 'b' is also tested.
62             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63             if (a == 0) return (true, 0);
64             uint256 c = a * b;
65             if (c / a != b) return (false, 0);
66             return (true, c);
67         }
68     }
69 
70     /**
71      * @dev Returns the division of two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76         unchecked {
77             if (b == 0) return (false, 0);
78             return (true, a / b);
79         }
80     }
81 
82     /**
83      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b == 0) return (false, 0);
90             return (true, a % b);
91         }
92     }
93 
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         return a + b;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return a - b;
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `*` operator.
127      *
128      * Requirements:
129      *
130      * - Multiplication cannot overflow.
131      */
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         return a * b;
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers, reverting on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator.
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function div(uint256 a, uint256 b) internal pure returns (uint256) {
147         return a / b;
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * reverting when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a % b;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168      * overflow (when the result is negative).
169      *
170      * CAUTION: This function is deprecated because it requires allocating memory for the error
171      * message unnecessarily. For custom revert reasons use {trySub}.
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(
180         uint256 a,
181         uint256 b,
182         string memory errorMessage
183     ) internal pure returns (uint256) {
184         unchecked {
185             require(b <= a, errorMessage);
186             return a - b;
187         }
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(
203         uint256 a,
204         uint256 b,
205         string memory errorMessage
206     ) internal pure returns (uint256) {
207         unchecked {
208             require(b > 0, errorMessage);
209             return a / b;
210         }
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * reverting with custom message when dividing by zero.
216      *
217      * CAUTION: This function is deprecated because it requires allocating memory for the error
218      * message unnecessarily. For custom revert reasons use {tryMod}.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(
229         uint256 a,
230         uint256 b,
231         string memory errorMessage
232     ) internal pure returns (uint256) {
233         unchecked {
234             require(b > 0, errorMessage);
235             return a % b;
236         }
237     }
238 }
239 
240 interface IERC20 {
241     function decimals() external view returns (uint8);
242 
243     function symbol() external view returns (string memory);
244 
245     function name() external view returns (string memory);
246 
247     function totalSupply() external view returns (uint256);
248 
249     function balanceOf(address account) external view returns (uint256);
250 
251     function transfer(address to, uint256 amount) external returns (bool);
252 
253     function allowance(address owner, address spender)
254         external
255         view
256         returns (uint256);
257 
258     function approve(address spender, uint256 amount) external returns (bool);
259 
260     function transferFrom(
261         address from,
262         address to,
263         uint256 amount
264     ) external returns (bool);
265 
266     event Transfer(address indexed from, address indexed to, uint256 value);
267     event Approval(
268         address indexed owner,
269         address indexed spender,
270         uint256 value
271     );
272 }
273 
274 interface IUniswapV2Router01 {
275     function factory() external pure returns (address);
276 
277     function WETH() external pure returns (address);
278 
279     function addLiquidityETH(
280         address token,
281         uint256 amountTokenDesired,
282         uint256 amountTokenMin,
283         uint256 amountETHMin,
284         address to,
285         uint256 deadline
286     )
287         external
288         payable
289         returns (
290             uint256 amountToken,
291             uint256 amountETH,
292             uint256 liquidity
293         );
294 }
295 
296 interface IUniswapV2Router02 is IUniswapV2Router01 {
297     function swapExactTokensForETHSupportingFeeOnTransferTokens(
298         uint amountIn,
299         uint amountOutMin,
300         address[] calldata path,
301         address to,
302         uint deadline
303     ) external;
304 }
305 
306 interface IUniswapV2Factory {
307     function createPair(address tokenA, address tokenB)
308         external
309         returns (address pair);
310 }
311 
312 contract Trollface is IERC20 {
313     using SafeMath for uint256;
314     using SafeMath for uint8;
315 
316     string public name = "Trollface";
317     string public symbol = "TROLL";
318     uint8 public decimals = 9;
319     uint256 public totalSupply;
320 
321     address public MARKETINGWALLET = 0xdd266D3b7F2DD24dF2952C546f952AE3F9832aAb;// CHANGE
322     address public DEAD = 0x000000000000000000000000000000000000dEaD;
323 
324     address private oldTokenAddress = 0xC35DbE3216bFd3a120d5E1b2287E389aFc2c6709;//CHANGE
325 
326     uint256 public THRESHOLD;
327 
328     uint8 marketingTax = 1; //1% marketing
329 
330     mapping(address => uint256) public balanceOf;
331     mapping(address => mapping(address => uint256)) public allowance;
332     mapping(address => bool) private isPair;
333     mapping(address => bool) private isExempt;
334 
335     address private _owner;
336 
337     IUniswapV2Router02 public uniswapV2Router;
338     address public uniswapV2Pair;
339     bool inLiquidate;
340     bool tradingOpen;
341     bool migrationOpen;
342 
343     event Liquidate(uint256 ethForMarketing);
344     event SetMarketingWallet(address _marketingWallet);
345     event SetAutoLpReceiverWallet(address newAutoLpReceiverWallet);
346     event TransferOwnership(address _newOwner);
347     event SetExempt(address _address, bool _isExempt);
348     event AddPair(address _pair);
349     event Migrate(address receiver, uint256 tokensSent);
350     event LaunchReady();
351     event OpenTrading(bool tradingOpen);
352 
353     constructor() {
354         _owner = msg.sender;
355         _update(address(0), address(this), 420690000000000 * 10**9);
356 
357         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
358         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this),uniswapV2Router.WETH());
359 
360         THRESHOLD = totalSupply.div(10**3); //0.1% swap threshold
361 
362         isPair[address(uniswapV2Pair)] = true;
363         isExempt[msg.sender] = true;
364         isExempt[address(this)] = true;
365 
366         allowance[address(this)][address(uniswapV2Pair)] = type(uint256).max;
367         allowance[address(this)][address(uniswapV2Router)] = type(uint256).max;
368 
369         migrationOpen = true;
370     }
371 
372     receive() external payable {}
373 
374     modifier protected() {
375         require(msg.sender == _owner);
376         _;
377     }
378 
379     modifier lockLiquidate() {
380         inLiquidate = true;
381         _;
382         inLiquidate = false;
383     }
384 
385     function owner() external view returns (address) {
386         return _owner;
387     }
388 
389     function approve(address spender, uint256 amount)
390         public
391         override
392         returns (bool)
393     {
394         allowance[msg.sender][spender] = amount;
395         emit Approval(msg.sender, spender, amount);
396         return true;
397     }
398 
399     function transfer(address to, uint256 amount)
400         external
401         override
402         returns (bool)
403     {
404         return _transferFrom(msg.sender, to, amount);
405     }
406 
407     function transferFrom(
408         address from,
409         address to,
410         uint256 amount
411     ) external override returns (bool) {
412         uint256 availableAllowance = allowance[from][msg.sender];
413         if (availableAllowance < type(uint256).max) {
414             allowance[from][msg.sender] = availableAllowance.sub(amount);
415         }
416 
417         return _transferFrom(from, to, amount);
418     }
419 
420     function _transferFrom(address from, address to, uint256 amount) private returns (bool) {
421 
422         if (inLiquidate || isExempt[from] || isExempt[to]) {
423             return _update(from, to, amount);
424         }
425 
426         require(tradingOpen);
427 
428         uint256 marketingFee;
429 
430         (bool fromPair, bool toPair) = (isPair[from], isPair[to]);
431 
432         if (fromPair || toPair) {
433             marketingFee = amount.mul(marketingTax).div(100);
434         }
435 
436         if (balanceOf[address(this)] >= THRESHOLD && !fromPair) {
437             _liquidate();
438         }
439 
440         balanceOf[address(this)] = balanceOf[address(this)].add(marketingFee);
441         balanceOf[from] = balanceOf[from].sub(amount);
442         balanceOf[to] = balanceOf[to].add(amount.sub(marketingFee));
443 
444         emit Transfer(from, to, amount);
445         return true;
446     }
447 
448     function _update(
449         address from,
450         address to,
451         uint256 amount
452     ) private returns (bool) {
453         if (from != address(0)) {
454             balanceOf[from] = balanceOf[from].sub(amount);
455         } else {
456             totalSupply = totalSupply.add(amount);
457         }
458         if (to == address(0)) {
459             totalSupply = totalSupply.sub(amount);
460         } else {
461             balanceOf[to] = balanceOf[to].add(amount);
462         }
463         emit Transfer(from, to, amount);
464         return true;
465     }
466 
467     function _liquidate() private lockLiquidate {
468   
469         address[] memory path = new address[](2);
470         path[0] = address(this);
471         path[1] = uniswapV2Router.WETH();
472 
473         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
474             THRESHOLD,
475             0,
476             path,
477             address(this),
478             block.timestamp
479             );
480 
481         uint256 ethForMarketing = address(this).balance;
482 
483         (bool succ, ) = payable(MARKETINGWALLET).call{value: ethForMarketing, gas: 30000}("");
484         require(succ);
485 
486         emit Liquidate(ethForMarketing);
487     }
488 
489 
490     function setMarketingWallet(address payable newMarketingWallet) external protected {
491         MARKETINGWALLET = newMarketingWallet;
492         emit SetMarketingWallet(newMarketingWallet);
493     }
494 
495     function transferOwnership(address _newOwner) external protected {
496         isExempt[_owner] = false;
497         _owner = _newOwner;
498         isExempt[_newOwner] = true;
499         emit TransferOwnership(_newOwner);
500     }
501 
502     function clearStuckETH() external protected {
503         uint256 contractETHBalance = address(this).balance;
504         if (contractETHBalance > 0) {
505             (bool sent, ) = payable(MARKETINGWALLET).call{
506                 value: contractETHBalance
507             }("");
508             require(sent);
509         }
510     }
511 
512     function setExempt(address _address, bool _isExempt) external protected {
513         isExempt[_address] = _isExempt;
514         emit SetExempt(_address, _isExempt);
515     }
516 
517     function addPair(address _address) external protected {
518         require(isPair[_address] = false);
519         isPair[_address] = true;
520         emit AddPair(_address);
521     }
522 
523     function migrate() external {
524         require(migrationOpen);    
525         IERC20 oldToken = IERC20(oldTokenAddress);
526 
527         uint256 tokensSent = oldToken.balanceOf(msg.sender);
528 
529         require(tokensSent > 0);
530         require(oldToken.transferFrom(msg.sender, _owner, tokensSent));
531 
532         require(_update(address(this), msg.sender, tokensSent));
533         emit Migrate(msg.sender, tokensSent);
534     }
535 
536     function readyLaunch() external protected {
537         require(migrationOpen == true);
538         migrationOpen = false;
539         _update(address(this), _owner, balanceOf[address(this)]);
540 
541         emit LaunchReady();
542     }
543 
544     function openTrading() external protected {
545         tradingOpen = true;
546         emit OpenTrading(tradingOpen);
547     }
548 
549 }