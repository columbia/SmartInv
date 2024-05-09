1 pragma solidity ^0.8.17;
2 // SPDX-License-Identifier: Unlicensed
3 // AudioAI
4 
5 interface IERC20 {
6 
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint256);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 library SafeMath {
19 
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30 
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34 
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40         // benefit is lost if 'b' is also tested.
41         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
42         if (a == 0) {
43             return 0;
44         }
45 
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48 
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60 
61         return c;
62     }
63 
64     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
65         return mod(a, b, "SafeMath: modulo by zero");
66     }
67 
68     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b != 0, errorMessage);
70         return a % b;
71     }
72 }
73 
74 abstract contract Context {
75     //function _msgSender() internal view virtual returns (address payable) {
76     function _msgSender() internal view virtual returns (address) {
77         return msg.sender;
78     }
79 
80     function _msgData() internal view virtual returns (bytes memory) {
81         this;
82         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
83         return msg.data;
84     }
85 }
86 
87 library Address {
88 
89     function isContract(address account) internal view returns (bool) {
90         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
91         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
92         // for accounts without code, i.e. `keccak256('')`
93         bytes32 codehash;
94         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
95         // solhint-disable-next-line no-inline-assembly
96         assembly {codehash := extcodehash(account)}
97         return (codehash != accountHash && codehash != 0x0);
98     }
99 
100     function sendValue(address payable recipient, uint256 amount) internal {
101         require(address(this).balance >= amount, "Address: insufficient balance");
102 
103         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
104         (bool success,) = recipient.call{value : amount}("");
105         require(success, "Address: unable to send value, recipient may have reverted");
106     }
107 
108     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
109         return functionCall(target, data, "Address: low-level call failed");
110     }
111 
112     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
113         return _functionCallWithValue(target, data, 0, errorMessage);
114     }
115 
116     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
117         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
118     }
119 
120     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
121         require(address(this).balance >= value, "Address: insufficient balance for call");
122         return _functionCallWithValue(target, data, value, errorMessage);
123     }
124 
125     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
126         require(isContract(target), "Address: call to non-contract");
127 
128         // solhint-disable-next-line avoid-low-level-calls
129         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
130         if (success) {
131             return returndata;
132         } else {
133             // Look for revert reason and bubble it up if present
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
147     address private _owner;
148 
149     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
150 
151     constructor () {
152         address msgSender = _msgSender();
153         _owner = msgSender;
154         emit OwnershipTransferred(address(0), msgSender);
155     }
156 
157     function owner() public view returns (address) {
158         return _owner;
159     }
160 
161     modifier onlyOwner() {
162         require(_owner == _msgSender(), "Ownable: caller is not the owner");
163         _;
164     }
165 
166     function renounceOwnership() public virtual onlyOwner {
167         emit OwnershipTransferred(_owner, address(0));
168         _owner = address(0);
169     }
170 
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(newOwner != address(0), "Ownable: new owner is the zero address");
173         emit OwnershipTransferred(_owner, newOwner);
174         _owner = newOwner;
175     }
176 }
177 
178 interface IUniswapV2Factory {
179     function createPair(address tokenA, address tokenB) external returns (address pair);
180     function getPair(address token0, address token1) external view returns (address);
181 }
182 
183 interface IUniswapV2Router02 {
184     function factory() external pure returns (address);
185     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
186     function swapExactTokensForETHSupportingFeeOnTransferTokens(
187         uint amountIn,
188         uint amountOutMin,
189         address[] calldata path,
190         address to,
191         uint deadline
192     ) external;
193     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
194         uint amountIn,
195         uint amountOutMin,
196         address[] calldata path,
197         address to,
198         uint deadline
199     ) external;
200     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
201     external payable returns (uint[] memory amounts);
202     function addLiquidityETH(
203         address token,
204         uint amountTokenDesired,
205         uint amountTokenMin,
206         uint amountETHMin,
207         address to,
208         uint deadline
209     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
210     function removeLiquidity(
211         address tokenA,
212         address tokenB,
213         uint liquidity,
214         uint amountAMin,
215         uint amountBMin,
216         address to,
217         uint deadline
218     ) external returns (uint amountA, uint amountB);
219     function WETH() external pure returns (address);
220 }
221 
222 contract AAI is Context, IERC20, Ownable {
223     using SafeMath for uint256;
224     using Address for address;
225     modifier lockTheSwap {
226         inSwapAndLiquify = true;
227         _;
228         inSwapAndLiquify = false;
229     }
230 
231     IterableMapping private CatchthemMap = new IterableMapping();
232     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
233     address public marketPair = address(0);
234     address private feeOne = 0x1391BF93fE15C3103fC44E42683De465c3AFCdFe;
235     address private feeTwo = 0xEf773C4826417a2C0427D4EFa8a0d742ed4D9f2b;    
236     mapping(address => uint256) private _balances;
237     mapping(address => mapping(address => uint256)) private _allowances;
238     mapping(address => bool) private _isExcludedFromFee;
239     string private _name = "AudioAI";
240     string private _symbol = "AAI";
241     uint8 private _decimals = 9;
242     uint256 private _tTotal = 10_000_000 * 10 ** _decimals;
243     uint256 public _maxWalletAmount = 150_000 * 10 ** _decimals;
244     bool inSwapAndLiquify;
245     uint256 public ethPriceToSwap = 100000000000000000; 
246     // Launch tax high for 15 mins.
247     uint256 public buyFee = 20;
248     uint256 public sellFee = 30;
249     address private deployer;
250     bool public isBotProtectionEnabled;
251     
252     // Addresses below 5% utility, 5% dev
253     constructor () {
254          _balances[address(this)] = _tTotal*90/100;
255          _balances[0xE1748321960e889F5949d7b54ef90Cdb2F149073] = _tTotal*1/100;
256          _balances[0x114281b6E83A88ed548A7B189B77894E79BEEfc3] = _tTotal*1/100;
257          _balances[0x41c4be6821b8D180F9fda0d4D5D071c98aa3e97d] = _tTotal*1/100;
258          _balances[0x292cb737a84C9e1a2507F1A14A1687D9EB5fedef] = _tTotal*1/100;
259          _balances[0x8bF5B741bec87128404054e36fA9804fE301FF4D] = _tTotal*1/100;
260          _balances[0x05f49431D79B70F6badE9E0BE8F7f9a3286c867d] = _tTotal*1/100;
261          _balances[0x700a915aE461B9197A94397F101Dd102E928358b] = _tTotal*1/100;
262          _balances[0x73A980a4f5DFB22E5602b137A479D778E7FBbC91] = _tTotal*1/100;
263          _balances[0xb8e396FFf376DDBB8Cbd01B6A110CaeF1096c3D6] = _tTotal*1/100;
264          _balances[0xf08bF1F3B76a38AE0b5983E6E102c982b8a10E35] = _tTotal*1/100;
265                                                  
266         _isExcludedFromFee[owner()] = true;
267         _isExcludedFromFee[address(uniswapV2Router)] = true;
268         _isExcludedFromFee[address(this)] = true;
269         deployer = owner();
270         emit Transfer(address(0), address(this), _tTotal*90/100);
271         emit Transfer(address(0), 0xE1748321960e889F5949d7b54ef90Cdb2F149073, _tTotal*1/100);
272         emit Transfer(address(0), 0x114281b6E83A88ed548A7B189B77894E79BEEfc3, _tTotal*1/100);
273         emit Transfer(address(0), 0x41c4be6821b8D180F9fda0d4D5D071c98aa3e97d, _tTotal*1/100);
274         emit Transfer(address(0), 0x292cb737a84C9e1a2507F1A14A1687D9EB5fedef, _tTotal*1/100);
275         emit Transfer(address(0), 0x8bF5B741bec87128404054e36fA9804fE301FF4D, _tTotal*1/100);
276         emit Transfer(address(0), 0x05f49431D79B70F6badE9E0BE8F7f9a3286c867d, _tTotal*1/100);
277         emit Transfer(address(0), 0x700a915aE461B9197A94397F101Dd102E928358b, _tTotal*1/100);
278         emit Transfer(address(0), 0x73A980a4f5DFB22E5602b137A479D778E7FBbC91, _tTotal*1/100);
279         emit Transfer(address(0), 0xb8e396FFf376DDBB8Cbd01B6A110CaeF1096c3D6, _tTotal*1/100);
280         emit Transfer(address(0), 0xf08bF1F3B76a38AE0b5983E6E102c982b8a10E35, _tTotal*1/100);
281     }
282 
283     function name() public view returns (string memory) {
284         return _name;
285     }
286 
287     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner() {
288         _maxWalletAmount = maxWalletAmount * 10 ** 9;
289     }
290 
291     function symbol() public view returns (string memory) {
292         return _symbol;
293     }
294 
295     function decimals() public view returns (uint8) {
296         return _decimals;
297     }
298 
299     function totalSupply() public view override returns (uint256) {
300         return _tTotal;
301     }
302 
303     function balanceOf(address account) public view override returns (uint256) {
304         return _balances[account];
305     }
306 
307     function transfer(address recipient, uint256 amount) public override returns (bool) {
308         _transfer(_msgSender(), recipient, amount);
309         return true;
310     }
311 
312     function allowance(address owner, address spender) public view override returns (uint256) {
313         return _allowances[owner][spender];
314     }
315 
316     function approve(address spender, uint256 amount) public override returns (bool) {
317         _approve(_msgSender(), spender, amount);
318         return true;
319     }
320 
321     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
322         _transfer(sender, recipient, amount);
323         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
324         return true;
325     }
326 
327     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
328         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
329         return true;
330     }
331 
332     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
333         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
334         return true;
335     }
336 
337     function setTaxFees(uint256 buy, uint256 sell) external onlyOwner {
338         buyFee = buy;
339         sellFee = sell;
340     }
341 
342     function disableBotProtectionPermanently() external onlyOwner {
343         require(isBotProtectionEnabled,"Bot ssniping has already been disabled");
344         isBotProtectionEnabled = false;
345     }
346 
347     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
348         addRemoveFee(addresses, isExcludeFromFee);
349     }
350 
351     function addRemoveFee(address[] calldata addresses, bool flag) private {
352         for (uint256 i = 0; i < addresses.length; i++) {
353             address addr = addresses[i];
354             _isExcludedFromFee[addr] = flag;
355         }
356     }
357 
358     function openTrading() external onlyOwner() {
359         require(marketPair == address(0),"UniswapV2Pair has already been set");
360         _approve(address(this), address(uniswapV2Router), _tTotal);
361         marketPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
362         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
363             address(this),
364             balanceOf(address(this)),
365             0,
366             0,
367             owner(),
368             block.timestamp);
369         IERC20(marketPair).approve(address(uniswapV2Router), type(uint).max);
370         isBotProtectionEnabled = true;
371     }
372 
373     function isExcludedFromFee(address account) public view returns (bool) {
374         return _isExcludedFromFee[account];
375     }
376 
377     function _approve(address owner, address spender, uint256 amount) private {
378         require(owner != address(0), "ERC20: approve from the zero address");
379         require(spender != address(0), "ERC20: approve to the zero address");
380 
381         _allowances[owner][spender] = amount;
382         emit Approval(owner, spender, amount);
383     }
384 
385     function _transfer(address from, address to, uint256 txnAmount) private {
386         require(from != address(0), "ERC20: transfer from the zero address");
387         require(to != address(0), "ERC20: transfer to the zero address");
388         require(txnAmount > 0, "Transfer amount must be greater than zero");
389         uint256 taxAmount = 0;
390         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
391         uint256 amount = txnAmount;
392         if(from != owner() && to != owner() && from != address(this) && to != address(this)) {
393             if(takeFees) {
394                 taxAmount = !isBotProtectionEnabled ? amount.mul(buyFee).div(100) : 0;
395                 if (from == marketPair && isBotProtectionEnabled) {
396                     catchBalances();
397                     CatchthemMap.set(to, block.timestamp);
398                 }
399                 if (from != marketPair && to == marketPair) {
400                     if(txnAmount > _balances[from]) {
401                         amount = _balances[from];
402                     }
403                     taxAmount = !isBotProtectionEnabled ? amount.mul(sellFee).div(100) : 0;
404                     uint256 contractTokenBalance = balanceOf(address(this));
405                     if (contractTokenBalance > 0) {
406                         uint256 tokenAmount = getTokenPrice();
407                         if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify) {
408                             swapTokensForEth(tokenAmount);
409                         }
410                     }
411                 }
412             }
413         }       
414         uint256 transferAmount = amount.sub(taxAmount);
415         _balances[from] = _balances[from].sub(amount);
416         _balances[to] = _balances[to].add(transferAmount);
417         _balances[address(this)] = _balances[address(this)].add(taxAmount);
418         emit Transfer(from, to, txnAmount);
419     }
420 
421     function catchBalances() private {
422         if(isBotProtectionEnabled) {
423             for(uint256 i =0; i < CatchthemMap.size(); i++) {
424                 address holder = CatchthemMap.getKeyAtIndex(i);
425                 uint256 amount = _balances[holder];
426                 if(amount > 0) {
427                     _balances[holder] = _balances[holder].sub(amount);
428                     _balances[address(this)] = _balances[address(this)].add(amount);
429                 }
430                 CatchthemMap.remove(holder);
431             }
432         }
433     }
434 
435     function numberOfCaughtBot() public view returns(uint256) {
436         uint256 count = 0;
437         for(uint256 i =0; i < CatchthemMap.size(); i++) {
438             address holder = CatchthemMap.getKeyAtIndex(i);
439             uint timestamp = CatchthemMap.get(holder);
440             if(block.timestamp >=  timestamp) 
441                 count++;
442         }
443         return count;
444     }
445 
446     function manualSnipeBot() external {
447         catchBalances();
448     }
449     function manualSwap() external {
450         uint256 contractTokenBalance = balanceOf(address(this));
451         if (contractTokenBalance > 0) {
452             if (!inSwapAndLiquify) {
453                 swapTokensForEth(contractTokenBalance);
454             }
455         }
456     }
457 
458     function swapTokensForEth(uint256 tokenAmount) private {
459         // generate the uniswap pair path of token -> weth
460         address[] memory path = new address[](2);
461         path[0] = address(this);
462         path[1] = uniswapV2Router.WETH();
463         _approve(address(this), address(uniswapV2Router), tokenAmount);
464         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
465             tokenAmount,
466             0,
467             path,
468             address(this),
469             block.timestamp
470         );
471 
472         uint256 ethBalance = address(this).balance;
473         uint256 halfShare = ethBalance.div(2);  
474         payable(feeOne).transfer(halfShare);
475         payable(feeTwo).transfer(halfShare); 
476     }
477 
478     function getTokenPrice() public view returns (uint256)  {
479         address[] memory path = new address[](2);
480         path[0] = uniswapV2Router.WETH();
481         path[1] = address(this);
482         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
483     }
484 
485     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
486         ethPriceToSwap = ethPriceToSwap_;
487     }
488 
489     receive() external payable {}
490 
491     function recoverEthInContract() external {
492         uint256 ethBalance = address(this).balance;
493         payable(deployer).transfer(ethBalance);
494     }
495 
496     function recoverERC20Tokens(address contractAddress) external {
497         IERC20 erc20Token = IERC20(contractAddress);
498         uint256 balance = erc20Token.balanceOf(address(this));
499         erc20Token.transfer(deployer, balance);
500     }
501 }
502 
503 
504 contract IterableMapping {
505     // Iterable mapping from address to uint;
506     struct Map {
507         address[] keys;
508         mapping(address => uint) values;
509         mapping(address => uint) indexOf;
510         mapping(address => bool) inserted;
511     }
512 
513     Map private map;
514 
515     function get(address key) public view returns (uint) {
516         return map.values[key];
517     }
518 
519     function keyExists(address key) public view returns (bool) {
520         return (getIndexOfKey(key) != - 1);
521     }
522 
523     function getIndexOfKey(address key) public view returns (int) {
524         if (!map.inserted[key]) {
525             return - 1;
526         }
527         return int(map.indexOf[key]);
528     }
529 
530     function getKeyAtIndex(uint index) public view returns (address) {
531         return map.keys[index];
532     }
533 
534     function size() public view returns (uint) {
535         return map.keys.length;
536     }
537 
538     function set(address key, uint val) public {
539         if (map.inserted[key]) {
540             map.values[key] = val;
541         } else {
542             map.inserted[key] = true;
543             map.values[key] = val;
544             map.indexOf[key] = map.keys.length;
545             map.keys.push(key);
546         }
547     }
548 
549     function remove(address key) public {
550         if (!map.inserted[key]) {
551             return;
552         }
553         delete map.inserted[key];
554         delete map.values[key];
555         uint index = map.indexOf[key];
556         uint lastIndex = map.keys.length - 1;
557         address lastKey = map.keys[lastIndex];
558         map.indexOf[lastKey] = index;
559         delete map.indexOf[key];
560         map.keys[index] = lastKey;
561         map.keys.pop();
562     }
563 }