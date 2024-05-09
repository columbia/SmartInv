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
191 }
192 
193 interface IUniswapV2Router02 is IUniswapV2Router01 {
194 
195     function swapExactTokensForETHSupportingFeeOnTransferTokens(
196         uint amountIn,
197         uint amountOutMin,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external;
202 }
203 
204 
205 contract DeVerse is Context, IERC20, Ownable {
206 
207     using SafeMath for uint256;
208     using Address for address;
209 
210     string private _name;
211     string private _symbol;
212     uint8 private _decimals;
213     address payable public marketingWalletAddress;
214     address payable public teamWalletAddress;
215     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
216 
217     mapping (address => uint256) _balances;
218     mapping (address => mapping (address => uint256)) private _allowances;
219 
220     mapping (address => bool) public isExcludedFromFee;
221     mapping (address => bool) public isMarketPair;
222 
223     uint256 public _totalTaxIfBuying = 1;
224     uint256 public _totalTaxIfSelling = 1;
225 
226     uint256 private _totalSupply;
227     uint256 private _minimumTokensBeforeSwap = 0;
228 
229     address public usdt;
230     bool private startTx;
231 
232 
233     IUniswapV2Router02 public uniswapV2Router;
234     address public uniswapPair;
235 
236     bool inSwapAndLiquify;
237     bool public swapAndLiquifyEnabled = true;
238     bool public swapAndLiquifyByLimitOnly = false;
239 
240     event SwapAndLiquifyEnabledUpdated(bool enabled);
241     event SwapAndLiquify(
242         uint256 tokensSwapped,
243         uint256 ethReceived,
244         uint256 tokensIntoLiqudity
245     );
246 
247     event SwapETHForTokens(
248         uint256 amountIn,
249         address[] path
250     );
251 
252     event SwapTokensForETH(
253         uint256 amountIn,
254         address[] path
255     );
256 
257     modifier lockTheSwap {
258         inSwapAndLiquify = true;
259         _;
260         inSwapAndLiquify = false;
261     }
262 
263 
264     constructor (
265         string memory coinName,
266         string memory coinSymbol,
267         uint8 coinDecimals,
268         uint256 supply,
269         address owner,
270         address marketingAddress,
271         address teamAddress
272     ) payable {
273 
274         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
275 
276         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
277             .createPair(address(this), _uniswapV2Router.WETH());
278         _name = coinName;
279         _symbol = coinSymbol;
280         _decimals = coinDecimals;
281         _owner = owner;
282         _totalSupply = supply  * 10 ** _decimals;
283         _minimumTokensBeforeSwap = 72000 * 10**_decimals;
284         marketingWalletAddress = payable(marketingAddress);
285         teamWalletAddress = payable(teamAddress);
286         uniswapV2Router = _uniswapV2Router;
287         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
288         isExcludedFromFee[owner] = true;
289         isExcludedFromFee[address(this)] = true;
290         isExcludedFromFee[marketingWalletAddress] = true;
291         isExcludedFromFee[teamAddress] = true;
292 
293         isMarketPair[address(uniswapPair)] = true;
294 
295         _balances[owner] = _totalSupply;
296         emit Transfer(address(0), owner, _totalSupply);
297     }
298 
299 
300     function name() public view returns (string memory) {
301         return _name;
302     }
303 
304     function symbol() public view returns (string memory) {
305         return _symbol;
306     }
307 
308     function decimals() public view returns (uint8) {
309         return _decimals;
310     }
311 
312     function totalSupply() public view override returns (uint256) {
313         return _totalSupply;
314     }
315 
316     function balanceOf(address account) public view override returns (uint256) {
317         return _balances[account];
318     }
319 
320     function allowance(address owner, address spender) public view override returns (uint256) {
321         return _allowances[owner][spender];
322     }
323 
324     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
325         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
326         return true;
327     }
328 
329     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
330         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
331         return true;
332     }
333 
334     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
335         return _minimumTokensBeforeSwap;
336     }
337 
338     function approve(address spender, uint256 amount) public override returns (bool) {
339         _approve(_msgSender(), spender, amount);
340         return true;
341     }
342 
343     function _approve(address owner, address spender, uint256 amount) private {
344         require(owner != address(0), "ERC20: approve from the zero address");
345         require(spender != address(0), "ERC20: approve to the zero address");
346 
347         _allowances[owner][spender] = amount;
348         emit Approval(owner, spender, amount);
349     }
350 
351     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
352         isMarketPair[account] = newValue;
353     }
354 
355     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
356         _minimumTokensBeforeSwap = newLimit;
357     }
358 
359     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
360         swapAndLiquifyEnabled = _enabled;
361         emit SwapAndLiquifyEnabledUpdated(_enabled);
362     }
363 
364     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
365         swapAndLiquifyByLimitOnly = newValue;
366     }
367 
368     function getCirculatingSupply() public view returns (uint256) {
369         return _totalSupply.sub(balanceOf(deadAddress));
370     }
371 
372     function transferToAddressETH(address payable recipient, uint256 amount) private {
373         recipient.transfer(amount);
374     }
375     
376      //to recieve ETH from uniswapV2Router when swaping
377     receive() external payable {}
378 
379     function transfer(address recipient, uint256 amount) public override returns (bool) {
380         _transfer(_msgSender(), recipient, amount);
381         return true;
382     }
383 
384     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
385         _transfer(sender, recipient, amount);
386         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
387         return true;
388     }
389 
390     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
391 
392         require(sender != address(0), "ERC20: transfer from the zero address");
393         require(recipient != address(0), "ERC20: transfer to the zero address");
394         require(amount > 0, "Transfer amount must be greater than zero");
395         
396 
397         if(inSwapAndLiquify)
398         {
399             return _basicTransfer(sender, recipient, amount);
400         }
401         else
402         {
403 
404             uint256 contractTokenBalance = balanceOf(address(this));
405             bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
406 
407             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled)
408             {
409                 if(swapAndLiquifyByLimitOnly)
410                     contractTokenBalance = _minimumTokensBeforeSwap;
411                 swapAndLiquify(contractTokenBalance);
412             }
413 
414             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
415 
416             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ?
417                                          amount : takeFee(sender, recipient, amount);
418 
419 
420             _balances[recipient] = _balances[recipient].add(finalAmount);
421 
422             emit Transfer(sender, recipient, finalAmount);
423             return true;
424         }
425     }
426 
427     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
428         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
429         _balances[recipient] = _balances[recipient].add(amount);
430         emit Transfer(sender, recipient, amount);
431         return true;
432     }
433 
434 
435     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
436 
437         // swap token -> eth
438         swapTokensForEth(tAmount);
439         uint256 amountReceived = address(this).balance;
440          
441         // team eth
442         uint256 amountUSDTTeam = amountReceived.mul(50).div(100);
443         // marketing eth
444         uint256 amountUSDTMarketing = amountReceived.sub(amountUSDTTeam);
445 
446         if(amountUSDTMarketing > 0)
447             transferToAddressETH(marketingWalletAddress, amountUSDTMarketing);
448 
449         if(amountUSDTTeam > 0)
450             transferToAddressETH(teamWalletAddress, amountUSDTTeam);
451 
452     }
453 
454     function swapTokensForEth(uint256 tokenAmount) private {
455         // generate the uniswap pair path of token -> weth
456         address[] memory path = new address[](2);
457         path[0] = address(this);
458         path[1] = uniswapV2Router.WETH();
459 
460         _approve(address(this), address(uniswapV2Router), tokenAmount);
461 
462         // make the swap
463         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
464             tokenAmount,
465             0, // accept any amount of ETH
466             path,
467             address(this), // The contract
468             block.timestamp
469         );
470 
471         emit SwapTokensForETH(tokenAmount, path);
472     }
473 
474 
475 
476     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
477 
478         uint256 feeAmount = 0;
479         if(isMarketPair[sender]) {
480             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
481             
482         }
483         else if(isMarketPair[recipient]) {
484             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
485         }
486         if(feeAmount > 0) {
487             _balances[address(this)] = _balances[address(this)].add(feeAmount);
488             emit Transfer(sender, address(this), feeAmount);
489         }
490 
491         return amount.sub(feeAmount);
492     }
493 
494    
495 }