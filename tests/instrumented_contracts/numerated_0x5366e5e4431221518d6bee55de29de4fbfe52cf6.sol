1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.9;
3 contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 contract ERC20Ownable is Context {
9     address private _owner;
10     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
11     constructor() {
12         address msgSender = _msgSender();
13         _owner = msgSender;
14         emit OwnershipTransferred(address(0), msgSender);
15     }
16     function owner() public view virtual returns (address) {
17         return _owner;
18     }
19     modifier onlyOwner() {
20         require(owner() == _msgSender(), "ERC20Ownable: caller is not the owner");
21         _;
22     }
23     function renounceOwnership() public virtual onlyOwner {
24         emit OwnershipTransferred(_owner, address(0));
25         _owner = address(0);
26     }
27     function transferOwnership(address newOwner) public virtual onlyOwner {
28         require(newOwner != address(0), "ERC20Ownable: new owner is the zero address");
29         emit OwnershipTransferred(_owner, newOwner);
30         _owner = newOwner;
31     }
32 }
33 library SafeMath {
34     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             uint256 c = a + b;
37             if (c < a) return (false, 0);
38             return (true, c);
39         }
40     }
41     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
42         unchecked {
43             if (b > a) return (false, 0);
44             return (true, a - b);
45         }
46     }
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50             // benefit is lost if 'b' is also tested.
51             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
52             if (a == 0) return (true, 0);
53             uint256 c = a * b;
54             if (c / a != b) return (false, 0);
55             return (true, c);
56         }
57     }
58     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (b == 0) return (false, 0);
61             return (true, a / b);
62         }
63     }
64     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
65         unchecked {
66             if (b == 0) return (false, 0);
67             return (true, a % b);
68         }
69     }
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         return a + b;
72     }
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a - b;
75     }
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a * b;
78     }
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return a / b;
81     }
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a % b;
84     }
85     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         unchecked {
87             require(b <= a, errorMessage);
88             return a - b;
89         }
90     }
91     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         unchecked {
93             require(b > 0, errorMessage);
94             return a / b;
95         }
96     }
97     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
98         unchecked {
99             require(b > 0, errorMessage);
100             return a % b;
101         }
102     }
103 }
104 interface IERC20 {
105     event Approval(address indexed owner, address indexed spender, uint value);
106     event Transfer(address indexed from, address indexed to, uint value);
107     function name() external view returns (string memory);
108     function symbol() external view returns (string memory);
109     function decimals() external view returns (uint8);
110     function totalSupply() external view returns (uint);
111     function balanceOf(address owner) external view returns (uint);
112     function allowance(address owner, address spender) external view returns (uint);
113     function approve(address spender, uint value) external returns (bool);
114     function transfer(address to, uint value) external returns (bool);
115     function transferFrom(address from, address to, uint value) external returns (bool);
116 }
117 interface IUniswapV2Router01 {
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120     function addLiquidity(
121         address tokenA,
122         address tokenB,
123         uint amountADesired,
124         uint amountBDesired,
125         uint amountAMin,
126         uint amountBMin,
127         address to,
128         uint deadline
129     ) external returns (uint amountA, uint amountB, uint liquidity);
130     function addLiquidityETH(
131         address token,
132         uint amountTokenDesired,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
138     function removeLiquidity(
139         address tokenA,
140         address tokenB,
141         uint liquidity,
142         uint amountAMin,
143         uint amountBMin,
144         address to,
145         uint deadline
146     ) external returns (uint amountA, uint amountB);
147     function removeLiquidityETH(
148         address token,
149         uint liquidity,
150         uint amountTokenMin,
151         uint amountETHMin,
152         address to,
153         uint deadline
154     ) external returns (uint amountToken, uint amountETH);
155     function removeLiquidityWithPermit(
156         address tokenA,
157         address tokenB,
158         uint liquidity,
159         uint amountAMin,
160         uint amountBMin,
161         address to,
162         uint deadline,
163         bool approveMax, uint8 v, bytes32 r, bytes32 s
164     ) external returns (uint amountA, uint amountB);
165     function removeLiquidityETHWithPermit(
166         address token,
167         uint liquidity,
168         uint amountTokenMin,
169         uint amountETHMin,
170         address to,
171         uint deadline,
172         bool approveMax, uint8 v, bytes32 r, bytes32 s
173     ) external returns (uint amountToken, uint amountETH);
174     function swapExactTokensForTokens(
175         uint amountIn,
176         uint amountOutMin,
177         address[] calldata path,
178         address to,
179         uint deadline
180     ) external returns (uint[] memory amounts);
181     function swapTokensForExactTokens(
182         uint amountOut,
183         uint amountInMax,
184         address[] calldata path,
185         address to,
186         uint deadline
187     ) external returns (uint[] memory amounts);
188     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
189         external
190         payable
191         returns (uint[] memory amounts);
192     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
193         external
194         returns (uint[] memory amounts);
195     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
196         external
197         returns (uint[] memory amounts);
198     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
199         external
200         payable
201         returns (uint[] memory amounts);
202     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
203     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
204     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
205     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
206     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
207 }
208 interface IUniswapV2Router02 {
209     function factory() external pure returns (address);
210     function WETH() external pure returns (address);
211     function swapExactTokensForETHSupportingFeeOnTransferTokens(
212         uint amountIn,
213         uint amountOutMin,
214         address[] calldata path,
215         address to,
216         uint deadline
217     ) external;
218     function addLiquidity(
219         address tokenA,
220         address tokenB,
221         uint amountADesired,
222         uint amountBDesired,
223         uint amountAMin,
224         uint amountBMin,
225         address to,
226         uint deadline
227     ) external returns (uint amountA, uint amountB, uint liquidity);
228     function addLiquidityETH(
229         address token,
230         uint amountTokenDesired,
231         uint amountTokenMin,
232         uint amountETHMin,
233         address to,
234         uint deadline
235     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
236     function removeLiquidity(
237         address tokenA,
238         address tokenB,
239         uint liquidity,
240         uint amountAMin,
241         uint amountBMin,
242         address to,
243         uint deadline
244     ) external returns (uint amountA, uint amountB);
245     function removeLiquidityETH(
246         address token,
247         uint liquidity,
248         uint amountTokenMin,
249         uint amountETHMin,
250         address to,
251         uint deadline
252     ) external returns (uint amountToken, uint amountETH);
253     function removeLiquidityWithPermit(
254         address tokenA,
255         address tokenB,
256         uint liquidity,
257         uint amountAMin,
258         uint amountBMin,
259         address to,
260         uint deadline,
261         bool approveMax, uint8 v, bytes32 r, bytes32 s
262     ) external returns (uint amountA, uint amountB);
263     function removeLiquidityETHWithPermit(
264         address token,
265         uint liquidity,
266         uint amountTokenMin,
267         uint amountETHMin,
268         address to,
269         uint deadline,
270         bool approveMax, uint8 v, bytes32 r, bytes32 s
271     ) external returns (uint amountToken, uint amountETH);
272     function swapExactTokensForTokens(
273         uint amountIn,
274         uint amountOutMin,
275         address[] calldata path,
276         address to,
277         uint deadline
278     ) external returns (uint[] memory amounts);
279     function swapTokensForExactTokens(
280         uint amountOut,
281         uint amountInMax,
282         address[] calldata path,
283         address to,
284         uint deadline
285     ) external returns (uint[] memory amounts);
286     function swapExactETHForTokensSupportingFeeOnTransferTokens(
287         uint amountOutMin,
288         address[] calldata path,
289         address to,
290         uint deadline
291     ) external payable;
292     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
293         external
294         payable
295         returns (uint[] memory amounts);
296     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
297         external
298         returns (uint[] memory amounts);
299     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
300         external
301         returns (uint[] memory amounts);
302     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
303         external
304         payable
305         returns (uint[] memory amounts);
306     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
307     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
308     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
309     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
310     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
311 }
312 interface IUniswapV2Factory {
313     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
314     function feeTo() external view returns (address);
315     function feeToSetter() external view returns (address);
316     function getPair(address tokenA, address tokenB) external view returns (address pair);
317     function allPairs(uint) external view returns (address pair);
318     function allPairsLength() external view returns (uint);
319     function createPair(address tokenA, address tokenB) external returns (address pair);
320     function setFeeTo(address) external;
321     function setFeeToSetter(address) external;
322 }
323 library Address {
324     function isContract(address account) internal view returns (bool) {
325         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
326         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
327         // for accounts without code, i.e. `keccak256('')`
328         bytes32 codehash;
329         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
330         // solhint-disable-next-line no-inline-assembly
331         assembly {
332             codehash := extcodehash(account)
333         }
334         return (codehash != accountHash && codehash != 0x0);
335     }
336     function sendValue(address payable recipient, uint256 amount) internal {
337         require(
338             address(this).balance >= amount,
339             "Address: insufficient balance"
340         );
341 
342         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
343         (bool success, ) = recipient.call{value: amount}("");
344         require(
345             success,
346             "Address: unable to send value, recipient may have reverted"
347         );
348     }
349     function functionCall(address target, bytes memory data)
350         internal
351         returns (bytes memory)
352     {
353         return functionCall(target, data, "Address: low-level call failed");
354     }
355     function functionCall(
356         address target,
357         bytes memory data,
358         string memory errorMessage
359     ) internal returns (bytes memory) {
360         return _functionCallWithValue(target, data, 0, errorMessage);
361     }
362     function functionCallWithValue(
363         address target,
364         bytes memory data,
365         uint256 value
366     ) internal returns (bytes memory) {
367         return
368             functionCallWithValue(
369                 target,
370                 data,
371                 value,
372                 "Address: low-level call with value failed"
373             );
374     }
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(
382             address(this).balance >= value,
383             "Address: insufficient balance for call"
384         );
385         return _functionCallWithValue(target, data, value, errorMessage);
386     }
387     function _functionCallWithValue(
388         address target,
389         bytes memory data,
390         uint256 weiValue,
391         string memory errorMessage
392     ) private returns (bytes memory) {
393         require(isContract(target), "Address: call to non-contract");
394 
395         (bool success, bytes memory returndata) = target.call{value: weiValue}(
396             data
397         );
398         if (success) {
399             return returndata;
400         } else {
401             if (returndata.length > 0) {
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 contract Anomaly is Context, IERC20, ERC20Ownable {
414     using SafeMath for uint256;
415     using Address for address;
416     string private constant tokenName = "Anomaly";
417     string private constant tokenSymbol = "ANOMALY";
418     uint8 private constant tokenDecimal = 9;
419     uint256 private constant tokenSupply = 1e6 * 10**tokenDecimal;
420     mapping(address => mapping(address => uint256)) private tokenAllowances;
421     mapping(address => uint256) private tokenBalance;
422     mapping(address => bool) private isMaxWalletExcluded;
423     mapping(address => bool) private isLiveExcluded;
424     mapping(address => bool) public isBot;
425     address payable liquidityAddress;
426     address public uniV2Pair;
427     IUniswapV2Router02 public uniV2Router;
428     uint256 private maxWallet;
429     uint256 public activeTradingBlock;
430     bool public maxWalletOn = false;
431     bool public live = false;
432     constructor() payable {
433         tokenBalance[address(this)] = tokenSupply;
434         maxWallet = tokenSupply.mul(2).div(100);
435         liquidityAddress = payable(owner());
436         isLiveExcluded[address(this)] = true;
437         isLiveExcluded[owner()] = true;
438         isLiveExcluded[liquidityAddress] = true;
439         isMaxWalletExcluded[address(this)] = true;
440         isMaxWalletExcluded[owner()] = true;
441         isMaxWalletExcluded[liquidityAddress] = true;
442         emit Transfer(address(0), address(this), tokenSupply);
443     }
444     receive() external payable {}
445     function name() external pure override returns (string memory) {
446         return tokenName;
447     }
448     function symbol() external pure override returns (string memory) {
449         return tokenSymbol;
450     }
451     function decimals() external pure override returns (uint8) {
452         return tokenDecimal;
453     }
454     function totalSupply() external pure override returns (uint256) {
455         return tokenSupply;
456     }
457     function balanceOf(address account) public view override returns (uint256) {
458         return tokenBalance[account];
459     }
460     function allowance(address owner, address spender) external view override returns (uint256) {
461         return tokenAllowances[owner][spender];
462     }
463     function approve(address spender, uint256 amount) public override returns (bool) {
464         require(_msgSender() != address(0), "ERC20: Can not approve from zero address");
465         require(spender != address(0), "ERC20: Can not approve to zero address");
466         tokenAllowances[_msgSender()][spender] = amount;
467         emit Approval(_msgSender(), spender, amount);
468         return true;
469     }
470     function internalApprove(address owner,address spender,uint256 amount) internal {
471         require(owner != address(0), "ERC20: Can not approve from zero address");
472         require(spender != address(0), "ERC20: Can not approve to zero address");
473         tokenAllowances[owner][spender] = amount;
474         emit Approval(owner, spender, amount);
475     }
476     function transfer(address recipient, uint256 amount) external override returns (bool) {
477         internalTransfer(_msgSender(), recipient, amount);
478         return true;
479     }
480     function transferFrom(address sender,address recipient,uint256 amount) external override returns (bool) {
481         internalTransfer(sender, recipient, amount);
482         internalApprove(sender,_msgSender(),tokenAllowances[sender][_msgSender()].sub(amount, "ERC20: Can not transfer. Amount exceeds allowance"));
483         return true;
484     }
485     function GoLive() external onlyOwner returns (bool){
486         require(!live, "ERC20: Trades already Live!");
487         activeTradingBlock = block.number;
488         IUniswapV2Router02 _uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
489         uniV2Router = _uniV2Router;
490         isMaxWalletExcluded[address(uniV2Router)] = true;
491         internalApprove(address(this), address(uniV2Router), tokenSupply);
492         uniV2Pair = IUniswapV2Factory(_uniV2Router.factory()).createPair(address(this), _uniV2Router.WETH());
493         isMaxWalletExcluded[address(uniV2Pair)] = true;
494         require(address(this).balance > 0, "ERC20: Must have ETH on contract to Go Live!");
495         addLiquidity(balanceOf(address(this)), address(this).balance);
496         maxWalletOn = true;
497         live = true;
498         return true;
499     }
500     function internalTransfer(address from, address to, uint256 amount) internal {
501         require(from != address(0), "ERC20: transfer from the zero address");
502         require(to != address(0), "ERC20: transfer to the zero address");
503         require(amount > 0, "ERC20: Transfer amount must be greater than zero");
504         require(!isBot[from], "ERC20: Can not transfer from BOT");
505         if(!live){
506             require(isLiveExcluded[from] || isLiveExcluded[to], "ERC20: Trading Is Not Live!");
507         }
508         if (maxWalletOn == true && !isMaxWalletExcluded[to]) {
509             require(balanceOf(to).add(amount) <= maxWallet, "ERC20: Max amount of tokens for wallet reached");
510         }
511         tokenTransfer(from, to, amount);
512     }
513     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
514         internalApprove(address(this), address(uniV2Router), tokenAmount);
515         uniV2Router.addLiquidityETH{value: ethAmount}(
516             address(this),
517             tokenAmount,
518             0,
519             0,
520             liquidityAddress,
521             block.timestamp
522         );
523     }
524     function tokenTransfer(address sender,address recipient,uint256 amount) internal {
525         tokenBalance[sender] -= amount;
526         tokenBalance[recipient] += amount;
527         emit Transfer(sender, recipient, amount);
528     }
529     function withdrawStuckETH() external onlyOwner {
530         bool success;
531         (success,) = address(owner()).call{value: address(this).balance}("");
532     }
533     function addBot(address account) external onlyOwner {
534         require(!isBot[account], "ERC20: Account already added");
535         isBot[account] = true;
536     }
537 	function removeBot(address account) external onlyOwner {
538         require(isBot[account], "ERC20: Account is not bot");
539         isBot[account] = false;
540     }
541     function setMaxWalletAmount(uint256 percent, uint256 divider) external onlyOwner {
542         maxWallet = tokenSupply.mul(percent).div(divider);
543         require(maxWallet <=tokenSupply.mul(3).div(100), "ERC20: Can not set max wallet more than 3%");
544     }
545     function setStatusMaxWallet(bool trueORfalse) external onlyOwner {
546        maxWalletOn = trueORfalse;
547     }
548 }