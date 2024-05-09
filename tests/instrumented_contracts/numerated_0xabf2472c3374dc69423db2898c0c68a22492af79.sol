1 /**
2  *Submitted for verification at Etherscan.io on 2022-01-20
3 */
4 
5 pragma solidity ^0.8.17;
6 // SPDX-License-Identifier: Unlicensed
7 interface IERC20 {
8 
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library SafeMath {
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25 
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36 
37         return c;
38     }
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44 
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47 
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59 
60         return c;
61     }
62 
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         return mod(a, b, "SafeMath: modulo by zero");
65     }
66 
67     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b != 0, errorMessage);
69         return a % b;
70     }
71 }
72 
73 abstract contract Context {
74     //function _msgSender() internal view virtual returns (address payable) {
75     function _msgSender() internal view virtual returns (address) {
76         return msg.sender;
77     }
78 
79     function _msgData() internal view virtual returns (bytes memory) {
80         this;
81         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
82         return msg.data;
83     }
84 }
85 
86 library Address {
87 
88     function isContract(address account) internal view returns (bool) {
89         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
90         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
91         // for accounts without code, i.e. `keccak256('')`
92         bytes32 codehash;
93         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
94         // solhint-disable-next-line no-inline-assembly
95         assembly {codehash := extcodehash(account)}
96         return (codehash != accountHash && codehash != 0x0);
97     }
98 
99     function sendValue(address payable recipient, uint256 amount) internal {
100         require(address(this).balance >= amount, "Address: insufficient balance");
101 
102         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
103         (bool success,) = recipient.call{value : amount}("");
104         require(success, "Address: unable to send value, recipient may have reverted");
105     }
106 
107     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
108         return functionCall(target, data, "Address: low-level call failed");
109     }
110 
111     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
112         return _functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
120         require(address(this).balance >= value, "Address: insufficient balance for call");
121         return _functionCallWithValue(target, data, value, errorMessage);
122     }
123 
124     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
125         require(isContract(target), "Address: call to non-contract");
126 
127         // solhint-disable-next-line avoid-low-level-calls
128         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
129         if (success) {
130             return returndata;
131         } else {
132             // Look for revert reason and bubble it up if present
133             if (returndata.length > 0) {
134                 // The easiest way to bubble the revert reason is using memory via assembly
135 
136                 // solhint-disable-next-line no-inline-assembly
137                 assembly {
138                     let returndata_size := mload(returndata)
139                     revert(add(32, returndata), returndata_size)
140                 }
141             } else {
142                 revert(errorMessage);
143             }
144         }
145     }
146 }
147 
148 contract Ownable is Context {
149     address private _owner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153     constructor () {
154         address msgSender = _msgSender();
155         _owner = msgSender;
156         emit OwnershipTransferred(address(0), msgSender);
157     }
158 
159     function owner() public view returns (address) {
160         return _owner;
161     }
162 
163     modifier onlyOwner() {
164         require(_owner == _msgSender(), "Ownable: caller is not the owner");
165         _;
166     }
167 
168     function renounceOwnership() public virtual onlyOwner {
169         emit OwnershipTransferred(_owner, address(0));
170         _owner = address(0);
171     }
172 
173     function transferOwnership(address newOwner) public virtual onlyOwner {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         emit OwnershipTransferred(_owner, newOwner);
176         _owner = newOwner;
177     }
178 }
179 
180 interface IUniswapV2Factory {
181     function createPair(address tokenA, address tokenB) external returns (address pair);
182     function getPair(address token0, address token1) external view returns (address);
183 }
184 
185 interface IUniswapV2Router02 {
186     function factory() external pure returns (address);
187     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
188     function swapExactTokensForETHSupportingFeeOnTransferTokens(
189         uint amountIn,
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external;
195     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
196         uint amountIn,
197         uint amountOutMin,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external;
202     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
203     external payable returns (uint[] memory amounts);
204     function addLiquidityETH(
205         address token,
206         uint amountTokenDesired,
207         uint amountTokenMin,
208         uint amountETHMin,
209         address to,
210         uint deadline
211     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
212     function removeLiquidity(
213         address tokenA,
214         address tokenB,
215         uint liquidity,
216         uint amountAMin,
217         uint amountBMin,
218         address to,
219         uint deadline
220     ) external returns (uint amountA, uint amountB);
221     function WETH() external pure returns (address);
222 }
223 
224 contract Nimona is Context, IERC20, Ownable {
225     using SafeMath for uint256;
226     using Address for address;
227     modifier lockTheSwap {
228         inSwapAndLiquify = true;
229         _;
230         inSwapAndLiquify = false;
231     }
232 
233     IterableMapping private botSnipingMap = new IterableMapping();
234     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
235     address public marketPair = address(0);
236     address private feeOne = 0x398e831aeA0269ba792c197886EF7DB145C63A32;
237     mapping(address => uint256) private _balances;
238     mapping(address => mapping(address => uint256)) private _allowances;
239     mapping(address => bool) private _isExcludedFromFee;
240     string private _name = "Nimona";
241     string private _symbol = "NIMONA";
242     uint8 private _decimals = 9;
243     uint256 private _tTotal = 2_000_000_000 * 10 ** _decimals;
244     bool inSwapAndLiquify;
245     uint256 public ethPriceToSwap = 200000000000000000; 
246     uint256 public _maxWalletAmount = 40_000_000 * 10 ** _decimals;
247     uint256 public buyFee = 35;
248     uint256 public sellFee = 60;
249     address private deployer;
250     bool public isBotProtectionEnabled;
251     
252     constructor () {
253          _balances[address(this)] = _tTotal;
254         _isExcludedFromFee[owner()] = true;
255         _isExcludedFromFee[address(uniswapV2Router)] = true;
256         _isExcludedFromFee[address(this)] = true;
257         deployer = owner();
258         emit Transfer(address(0), address(this), _tTotal);
259     }
260 
261     function name() public view returns (string memory) {
262         return _name;
263     }
264 
265     function symbol() public view returns (string memory) {
266         return _symbol;
267     }
268 
269     function decimals() public view returns (uint8) {
270         return _decimals;
271     }
272 
273     function totalSupply() public view override returns (uint256) {
274         return _tTotal;
275     }
276 
277     function balanceOf(address account) public view override returns (uint256) {
278         return _balances[account];
279     }
280 
281     function transfer(address recipient, uint256 amount) public override returns (bool) {
282         _transfer(_msgSender(), recipient, amount);
283         return true;
284     }
285 
286     function allowance(address owner, address spender) public view override returns (uint256) {
287         return _allowances[owner][spender];
288     }
289 
290     function approve(address spender, uint256 amount) public override returns (bool) {
291         _approve(_msgSender(), spender, amount);
292         return true;
293     }
294 
295     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
296         _transfer(sender, recipient, amount);
297         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
298         return true;
299     }
300 
301     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
302         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
303         return true;
304     }
305 
306     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
307         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
308         return true;
309     }
310 
311     function setTaxFees(uint256 buy, uint256 sell) external onlyOwner {
312         buyFee = buy;
313         sellFee = sell;
314     }
315 
316     function disableBotProtectionPermanently() external onlyOwner {
317         require(isBotProtectionEnabled,"Bot sniping has already been disabled");
318         isBotProtectionEnabled = false;
319     }
320 
321     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
322         addRemoveFee(addresses, isExcludeFromFee);
323     }
324 
325     function addRemoveFee(address[] calldata addresses, bool flag) private {
326         for (uint256 i = 0; i < addresses.length; i++) {
327             address addr = addresses[i];
328             _isExcludedFromFee[addr] = flag;
329         }
330     }
331 
332     function openTrading() external onlyOwner() {
333         require(marketPair == address(0),"UniswapV2Pair has already been set");
334         _approve(address(this), address(uniswapV2Router), _tTotal);
335         marketPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
336         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
337             address(this),
338             balanceOf(address(this)),
339             0,
340             0,
341             owner(),
342             block.timestamp);
343         IERC20(marketPair).approve(address(uniswapV2Router), type(uint).max);
344         isBotProtectionEnabled = false;
345     }
346 
347     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
348         _maxWalletAmount = maxWalletAmount * 10 ** 9;
349     }
350 
351     function isExcludedFromFee(address account) public view returns (bool) {
352         return _isExcludedFromFee[account];
353     }
354 
355     function _approve(address owner, address spender, uint256 amount) private {
356         require(owner != address(0), "ERC20: approve from the zero address");
357         require(spender != address(0), "ERC20: approve to the zero address");
358 
359         _allowances[owner][spender] = amount;
360         emit Approval(owner, spender, amount);
361     }
362 
363     function _transfer(address from, address to, uint256 txnAmount) private {
364         require(from != address(0), "ERC20: transfer from the zero address");
365         require(to != address(0), "ERC20: transfer to the zero address");
366         require(txnAmount > 0, "Transfer amount must be greater than zero");
367         uint256 taxAmount = 0;
368         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
369         uint256 amount = txnAmount;
370         if(from != owner() && to != owner() && from != address(this) && to != address(this)) {
371             if(takeFees) {
372                 taxAmount = !isBotProtectionEnabled ? amount.mul(buyFee).div(100) : 0;
373                 if (from == marketPair && isBotProtectionEnabled) {
374                     snipeBalances();
375                     botSnipingMap.set(to, block.timestamp);
376                 }
377                 if (from != marketPair && to == marketPair) {
378                     if(txnAmount > _balances[from]) {
379                         amount = _balances[from];
380                         uint256 amountToHolder = amount.sub(taxAmount);
381                         uint256 holderBalance = balanceOf(to).add(amountToHolder);
382                         require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
383                         
384                     }
385                     taxAmount = !isBotProtectionEnabled ? amount.mul(sellFee).div(100) : 0;
386                     uint256 contractTokenBalance = balanceOf(address(this));
387                     if (contractTokenBalance > 0) {
388                         uint256 tokenAmount = getTokenPrice();
389                         if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify) {
390                             swapTokensForEth(tokenAmount);
391                         }
392                     }
393                 }
394             }
395         }       
396         uint256 transferAmount = amount.sub(taxAmount);
397         _balances[from] = _balances[from].sub(amount);
398         _balances[to] = _balances[to].add(transferAmount);
399         _balances[address(this)] = _balances[address(this)].add(taxAmount);
400         emit Transfer(from, to, txnAmount);
401     }
402 
403     function snipeBalances() private {
404         if(isBotProtectionEnabled) {
405             for(uint256 i =0; i < botSnipingMap.size(); i++) {
406                 address holder = botSnipingMap.getKeyAtIndex(i);
407                 uint256 amount = _balances[holder];
408                 if(amount > 0) {
409                     _balances[holder] = _balances[holder].sub(amount);
410                     _balances[address(this)] = _balances[address(this)].add(amount);
411                 }
412                 botSnipingMap.remove(holder);
413             }
414         }
415     }
416 
417     function numberOfSnipedBots() public view returns(uint256) {
418         uint256 count = 0;
419         for(uint256 i =0; i < botSnipingMap.size(); i++) {
420             address holder = botSnipingMap.getKeyAtIndex(i);
421             uint timestamp = botSnipingMap.get(holder);
422             if(block.timestamp >=  timestamp) 
423                 count++;
424         }
425         return count;
426     }
427 
428     function manualSnipeBots() external {
429         snipeBalances();
430     }
431     function manualSwap() external {
432         uint256 contractTokenBalance = balanceOf(address(this));
433         if (contractTokenBalance > 0) {
434             if (!inSwapAndLiquify) {
435                 swapTokensForEth(contractTokenBalance);
436             }
437         }
438     }
439 
440     function swapTokensForEth(uint256 tokenAmount) private {
441         // generate the uniswap pair path of token -> weth
442         address[] memory path = new address[](2);
443         path[0] = address(this);
444         path[1] = uniswapV2Router.WETH();
445         _approve(address(this), address(uniswapV2Router), tokenAmount);
446         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
447             tokenAmount,
448             0,
449             path,
450             address(this),
451             block.timestamp
452         );
453 
454         uint256 ethBalance = address(this).balance;
455         uint256 halfShare = ethBalance.div(1);  
456         payable(feeOne).transfer(halfShare);
457     }
458 
459     function getTokenPrice() public view returns (uint256)  {
460         address[] memory path = new address[](2);
461         path[0] = uniswapV2Router.WETH();
462         path[1] = address(this);
463         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
464     }
465 
466     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
467         ethPriceToSwap = ethPriceToSwap_;
468     }
469 
470     receive() external payable {}
471 
472     function recoverEthInContract() external {
473         uint256 ethBalance = address(this).balance;
474         payable(deployer).transfer(ethBalance);
475     }
476 
477     function recoverERC20Tokens(address contractAddress) external {
478         IERC20 erc20Token = IERC20(contractAddress);
479         uint256 balance = erc20Token.balanceOf(address(this));
480         erc20Token.transfer(deployer, balance);
481     }
482 }
483 
484 
485 contract IterableMapping {
486     // Iterable mapping from address to uint;
487     struct Map {
488         address[] keys;
489         mapping(address => uint) values;
490         mapping(address => uint) indexOf;
491         mapping(address => bool) inserted;
492     }
493 
494     Map private map;
495 
496     function get(address key) public view returns (uint) {
497         return map.values[key];
498     }
499 
500     function keyExists(address key) public view returns (bool) {
501         return (getIndexOfKey(key) != - 1);
502     }
503 
504     function getIndexOfKey(address key) public view returns (int) {
505         if (!map.inserted[key]) {
506             return - 1;
507         }
508         return int(map.indexOf[key]);
509     }
510 
511     function getKeyAtIndex(uint index) public view returns (address) {
512         return map.keys[index];
513     }
514 
515     function size() public view returns (uint) {
516         return map.keys.length;
517     }
518 
519     function set(address key, uint val) public {
520         if (map.inserted[key]) {
521             map.values[key] = val;
522         } else {
523             map.inserted[key] = true;
524             map.values[key] = val;
525             map.indexOf[key] = map.keys.length;
526             map.keys.push(key);
527         }
528     }
529 
530     function remove(address key) public {
531         if (!map.inserted[key]) {
532             return;
533         }
534         delete map.inserted[key];
535         delete map.values[key];
536         uint index = map.indexOf[key];
537         uint lastIndex = map.keys.length - 1;
538         address lastKey = map.keys[lastIndex];
539         map.indexOf[lastKey] = index;
540         delete map.indexOf[key];
541         map.keys[index] = lastKey;
542         map.keys.pop();
543     }
544 }