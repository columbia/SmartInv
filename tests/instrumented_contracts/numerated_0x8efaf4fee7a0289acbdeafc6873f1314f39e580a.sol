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
245 contract SKY is Context, IERC20, Ownable {
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
270     address public usdt;
271     bool private startTx;
272 
273 
274     IUniswapV2Router02 public uniswapV2Router;
275     address public uniswapPair;
276 
277     bool inSwapAndLiquify;
278     bool public swapAndLiquifyEnabled = true;
279     bool public swapAndLiquifyByLimitOnly = false;
280 
281     event SwapAndLiquifyEnabledUpdated(bool enabled);
282     event SwapAndLiquify(
283         uint256 tokensSwapped,
284         uint256 ethReceived,
285         uint256 tokensIntoLiqudity
286     );
287 
288     event SwapETHForTokens(
289         uint256 amountIn,
290         address[] path
291     );
292 
293     event SwapTokensForETH(
294         uint256 amountIn,
295         address[] path
296     );
297 
298     modifier lockTheSwap {
299         inSwapAndLiquify = true;
300         _;
301         inSwapAndLiquify = false;
302     }
303 
304 
305     constructor (
306         string memory coinName,
307         string memory coinSymbol,
308         uint8 coinDecimals,
309         uint256 supply,
310         address router
311     ) payable {
312 
313         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
314 
315         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
316             .createPair(address(this), _uniswapV2Router.WETH());
317         _name = coinName;
318         _symbol = coinSymbol;
319         _decimals = coinDecimals;
320         _owner = 0x8CEaf6eE18Be77B0313685F4bBCCAff7A52B570c;
321         _totalSupply = supply  * 10 ** _decimals;
322         _minimumTokensBeforeSwap = 1202 * 10**_decimals;
323         marketingWalletAddress = payable(0x96Ccc2022c20E4082439f9797ec8424c43eccd50);
324         teamWalletAddress = payable(0xF8ca5F6774A4dc5516ca38062F0330096265e896);
325         uniswapV2Router = _uniswapV2Router;
326         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
327         isExcludedFromFee[_owner] = true;
328         isExcludedFromFee[address(this)] = true;
329         isExcludedFromFee[marketingWalletAddress] = true;
330         isExcludedFromFee[teamWalletAddress] = true;
331 
332         isMarketPair[address(uniswapPair)] = true;
333 
334         _balances[_owner] = _totalSupply;
335         emit Transfer(address(0), _owner, _totalSupply);
336     }
337 
338 
339     function name() public view returns (string memory) {
340         return _name;
341     }
342 
343     function symbol() public view returns (string memory) {
344         return _symbol;
345     }
346 
347     function decimals() public view returns (uint8) {
348         return _decimals;
349     }
350 
351     function totalSupply() public view override returns (uint256) {
352         return _totalSupply;
353     }
354 
355     function balanceOf(address account) public view override returns (uint256) {
356         return _balances[account];
357     }
358 
359     function allowance(address owner, address spender) public view override returns (uint256) {
360         return _allowances[owner][spender];
361     }
362 
363     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
364         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
365         return true;
366     }
367 
368     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
369         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
370         return true;
371     }
372 
373     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
374         return _minimumTokensBeforeSwap;
375     }
376 
377     function approve(address spender, uint256 amount) public override returns (bool) {
378         _approve(_msgSender(), spender, amount);
379         return true;
380     }
381 
382     function _approve(address owner, address spender, uint256 amount) private {
383         require(owner != address(0), "ERC20: approve from the zero address");
384         require(spender != address(0), "ERC20: approve to the zero address");
385 
386         _allowances[owner][spender] = amount;
387         emit Approval(owner, spender, amount);
388     }
389 
390     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
391         _minimumTokensBeforeSwap = newLimit;
392     }
393 
394     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
395         swapAndLiquifyEnabled = _enabled;
396         emit SwapAndLiquifyEnabledUpdated(_enabled);
397     }
398 
399 
400     function pause() onlyOwner public {
401         startTx = true;
402     }
403     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
404         for(uint256 i = 0; i < accounts.length; i++) {
405             isExcludedFromFee[accounts[i]] = excluded;
406         }
407 
408     }
409 
410     function transferToAddressETH(address payable recipient, uint256 amount) private {
411         recipient.transfer(amount);
412     }
413     
414      //to recieve ETH from uniswapV2Router when swaping
415     receive() external payable {}
416 
417     function transfer(address recipient, uint256 amount) public override returns (bool) {
418         _transfer(_msgSender(), recipient, amount);
419         return true;
420     }
421 
422     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
423         _transfer(sender, recipient, amount);
424         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
425         return true;
426     }
427 
428     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
429 
430         require(sender != address(0), "ERC20: transfer from the zero address");
431         require(recipient != address(0), "ERC20: transfer to the zero address");
432         require(amount > 0, "Transfer amount must be greater than zero");
433         
434         if(!isExcludedFromFee[sender] && !isExcludedFromFee[recipient]){
435             if(isMarketPair[sender] || isMarketPair[recipient]){
436                 require(startTx, "not start");
437             }
438         }
439 
440         if(inSwapAndLiquify)
441         {
442             return _basicTransfer(sender, recipient, amount);
443         }
444         else
445         {
446 
447             uint256 contractTokenBalance = balanceOf(address(this));
448             bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
449 
450             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled)
451             {
452                 if(swapAndLiquifyByLimitOnly)
453                     contractTokenBalance = _minimumTokensBeforeSwap;
454                 swapAndLiquify(contractTokenBalance);
455             }
456 
457             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
458 
459             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ?
460                                          amount : takeFee(sender, recipient, amount);
461 
462 
463             _balances[recipient] = _balances[recipient].add(finalAmount);
464 
465             emit Transfer(sender, recipient, finalAmount);
466             return true;
467         }
468     }
469 
470     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
471         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
472         _balances[recipient] = _balances[recipient].add(amount);
473         emit Transfer(sender, recipient, amount);
474         return true;
475     }
476 
477 
478     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
479 
480         // swap token -> eth
481         swapTokensForEth(tAmount);
482         uint256 amountReceived = address(this).balance;
483          
484         // team eth
485         uint256 amountUSDTTeam = amountReceived.mul(50).div(100);
486         // marketing eth
487         uint256 amountUSDTMarketing = amountReceived.sub(amountUSDTTeam);
488 
489         if(amountUSDTMarketing > 0)
490             transferToAddressETH(marketingWalletAddress, amountUSDTMarketing);
491 
492         if(amountUSDTTeam > 0)
493             transferToAddressETH(teamWalletAddress, amountUSDTTeam);
494 
495 
496     }
497     function swapTokensForEth(uint256 tokenAmount) private {
498         // generate the uniswap pair path of token -> weth
499         address[] memory path = new address[](2);
500         path[0] = address(this);
501         path[1] = uniswapV2Router.WETH();
502 
503         _approve(address(this), address(uniswapV2Router), tokenAmount);
504 
505         // make the swap
506         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
507             tokenAmount,
508             0, // accept any amount of ETH
509             path,
510             address(this), // The contract
511             block.timestamp
512         );
513 
514         emit SwapTokensForETH(tokenAmount, path);
515     }
516 
517 
518 
519     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
520 
521         uint256 feeAmount = 0;
522         if(isMarketPair[sender]) {
523             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
524             
525         }
526         else if(isMarketPair[recipient]) {
527             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
528         }
529         if(feeAmount > 0) {
530             _balances[address(this)] = _balances[address(this)].add(feeAmount);
531             emit Transfer(sender, address(this), feeAmount);
532         }
533 
534         return amount.sub(feeAmount);
535     }
536 
537    
538 }