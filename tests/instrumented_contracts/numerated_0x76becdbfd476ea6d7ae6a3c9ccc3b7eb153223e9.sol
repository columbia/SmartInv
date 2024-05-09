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
211     function removeLiquidity(
212         address tokenA,
213         address tokenB,
214         uint liquidity,
215         uint amountAMin,
216         uint amountBMin,
217         address to,
218         uint deadline
219     ) external returns (uint amountA, uint amountB);
220 
221     function removeLiquidityETH(
222         address token,
223         uint liquidity,
224         uint amountTokenMin,
225         uint amountETHMin,
226         address to,
227         uint deadline
228     ) external returns (uint amountToken, uint amountETH);
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
245 contract CyberAI is Context, IERC20, Ownable {
246 
247     using SafeMath for uint256;
248     using Address for address;
249 
250     string private _name;
251     string private _symbol;
252     uint8 private _decimals;
253     address payable public marketingWalletAddress;
254     address payable public teamWalletAddress;
255     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
256 
257     mapping (address => uint256) _balances;
258     mapping (address => mapping (address => uint256)) private _allowances;
259 
260     mapping (address => bool) public isExcludedFromFee;
261     mapping (address => bool) public isMarketPair;
262 
263 
264     uint256 public _totalTaxIfBuying = 1;
265     uint256 public _totalTaxIfSelling = 1;
266 
267     uint256 private _totalSupply;
268     uint256 private _minimumTokensBeforeSwap = 0;
269 
270     bool private startTx;
271 
272 
273     IUniswapV2Router02 public uniswapV2Router;
274     address public uniswapPair;
275 
276     bool inSwapAndLiquify;
277     bool public swapAndLiquifyEnabled = true;
278     bool public swapAndLiquifyByLimitOnly = false;
279 
280     event SwapAndLiquifyEnabledUpdated(bool enabled);
281     event SwapAndLiquify(
282         uint256 tokensSwapped,
283         uint256 ethReceived,
284         uint256 tokensIntoLiqudity
285     );
286 
287     event SwapETHForTokens(
288         uint256 amountIn,
289         address[] path
290     );
291 
292     event SwapTokensForETH(
293         uint256 amountIn,
294         address[] path
295     );
296 
297     modifier lockTheSwap {
298         inSwapAndLiquify = true;
299         _;
300         inSwapAndLiquify = false;
301     }
302 
303 
304     constructor (
305         string memory coinName,
306         string memory coinSymbol,
307         uint8 coinDecimals,
308         uint256 supply,
309         address router
310     ) payable {
311 
312         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
313 
314         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
315             .createPair(address(this), _uniswapV2Router.WETH());
316         _name = coinName;
317         _symbol = coinSymbol;
318         _decimals = coinDecimals;
319         _owner = 0x1d23E7E75E76631Fe4666Fd698D5C1Db65c03a3b;
320         _totalSupply = supply  * 10 ** _decimals;
321         _minimumTokensBeforeSwap = 102410 * 10**_decimals;
322         marketingWalletAddress = payable(0x01bB30B54f6439EEbB5db393223cF652FA54B3Af);
323         teamWalletAddress = payable(0x949596a57aa1A73A2789E4a2682D656E30794692);
324         uniswapV2Router = _uniswapV2Router;
325         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
326         isExcludedFromFee[_owner] = true;
327         isExcludedFromFee[address(this)] = true;
328         isExcludedFromFee[marketingWalletAddress] = true;
329         isExcludedFromFee[teamWalletAddress] = true;
330 
331         isMarketPair[address(uniswapPair)] = true;
332 
333         _balances[_owner] = _totalSupply;
334         emit Transfer(address(0), _owner, _totalSupply);
335     }
336 
337 
338     function name() public view returns (string memory) {
339         return _name;
340     }
341 
342     function symbol() public view returns (string memory) {
343         return _symbol;
344     }
345 
346     function decimals() public view returns (uint8) {
347         return _decimals;
348     }
349 
350     function totalSupply() public view override returns (uint256) {
351         return _totalSupply;
352     }
353 
354     function balanceOf(address account) public view override returns (uint256) {
355         return _balances[account];
356     }
357 
358     function allowance(address owner, address spender) public view override returns (uint256) {
359         return _allowances[owner][spender];
360     }
361 
362     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
363         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
364         return true;
365     }
366 
367     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
368         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
369         return true;
370     }
371 
372     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
373         return _minimumTokensBeforeSwap;
374     }
375 
376     function approve(address spender, uint256 amount) public override returns (bool) {
377         _approve(_msgSender(), spender, amount);
378         return true;
379     }
380 
381     function _approve(address owner, address spender, uint256 amount) private {
382         require(owner != address(0), "ERC20: approve from the zero address");
383         require(spender != address(0), "ERC20: approve to the zero address");
384 
385         _allowances[owner][spender] = amount;
386         emit Approval(owner, spender, amount);
387     }
388 
389     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
390         _minimumTokensBeforeSwap = newLimit;
391     }
392 
393     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
394         swapAndLiquifyEnabled = _enabled;
395         emit SwapAndLiquifyEnabledUpdated(_enabled);
396     }
397 
398 
399     function pause() onlyOwner public {
400         startTx = true;
401     }
402     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
403         for(uint256 i = 0; i < accounts.length; i++) {
404             isExcludedFromFee[accounts[i]] = excluded;
405         }
406 
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
433         if(!isExcludedFromFee[sender] && !isExcludedFromFee[recipient]){
434             if(isMarketPair[sender] || isMarketPair[recipient]){
435                 require(startTx, "not start");
436             }
437         }
438 
439         if(inSwapAndLiquify)
440         {
441             return _basicTransfer(sender, recipient, amount);
442         }
443         else
444         {
445 
446             uint256 contractTokenBalance = balanceOf(address(this));
447             bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
448 
449             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled)
450             {
451                 if(swapAndLiquifyByLimitOnly)
452                     contractTokenBalance = _minimumTokensBeforeSwap;
453                 swapAndLiquify(contractTokenBalance);
454             }
455 
456             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
457 
458             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ?
459                                          amount : takeFee(sender, recipient, amount);
460 
461 
462             _balances[recipient] = _balances[recipient].add(finalAmount);
463 
464             emit Transfer(sender, recipient, finalAmount);
465             return true;
466         }
467     }
468 
469     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
470         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
471         _balances[recipient] = _balances[recipient].add(amount);
472         emit Transfer(sender, recipient, amount);
473         return true;
474     }
475 
476 
477     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
478 
479         // swap token -> eth
480         swapTokensForEth(tAmount);
481         uint256 amountReceived = address(this).balance;
482          
483         // team eth
484         uint256 amountUSDTTeam = amountReceived.mul(50).div(100);
485         // marketing eth
486         uint256 amountUSDTMarketing = amountReceived.sub(amountUSDTTeam);
487 
488         if(amountUSDTMarketing > 0)
489             transferToAddressETH(marketingWalletAddress, amountUSDTMarketing);
490 
491         if(amountUSDTTeam > 0)
492             transferToAddressETH(teamWalletAddress, amountUSDTTeam);
493 
494 
495     }
496     function swapTokensForEth(uint256 tokenAmount) private {
497         // generate the uniswap pair path of token -> weth
498         address[] memory path = new address[](2);
499         path[0] = address(this);
500         path[1] = uniswapV2Router.WETH();
501 
502         _approve(address(this), address(uniswapV2Router), tokenAmount);
503 
504         // make the swap
505         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
506             tokenAmount,
507             0, // accept any amount of ETH
508             path,
509             address(this), // The contract
510             block.timestamp
511         );
512 
513         emit SwapTokensForETH(tokenAmount, path);
514     }
515 
516 
517 
518     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
519 
520         uint256 feeAmount = 0;
521         if(isMarketPair[sender]) {
522             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
523         }
524         else if(isMarketPair[recipient]) {
525             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
526         }
527         if(feeAmount > 0) {
528             _balances[address(this)] = _balances[address(this)].add(feeAmount);
529             emit Transfer(sender, address(this), feeAmount);
530         }
531 
532         return amount.sub(feeAmount);
533     }
534 
535    
536 }