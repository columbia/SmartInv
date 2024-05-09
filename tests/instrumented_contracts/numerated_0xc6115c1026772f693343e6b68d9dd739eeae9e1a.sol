1 pragma solidity ^0.8.16;
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
16 library SafeMathInt {
17     int256 private constant MIN_INT256 = int256(1) << 255;
18     int256 private constant MAX_INT256 = ~(int256(1) << 255);
19 
20     function mul(int256 a, int256 b) internal pure returns (int256) {
21         int256 c = a * b;
22         // Detect overflow when multiplying MIN_INT256 with -1
23         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
24         require((b == 0) || (c / b == a));
25         return c;
26     }
27 
28     function div(int256 a, int256 b) internal pure returns (int256) {
29         // Prevent overflow when dividing MIN_INT256 by -1
30         require(b != - 1 || a != MIN_INT256);
31         // Solidity already throws when dividing by 0.
32         return a / b;
33     }
34 
35     function sub(int256 a, int256 b) internal pure returns (int256) {
36         int256 c = a - b;
37         require((b >= 0 && c <= a) || (b < 0 && c > a));
38         return c;
39     }
40 
41     function add(int256 a, int256 b) internal pure returns (int256) {
42         int256 c = a + b;
43         require((b >= 0 && c >= a) || (b < 0 && c < a));
44         return c;
45     }
46 
47     function abs(int256 a) internal pure returns (int256) {
48         require(a != MIN_INT256);
49         return a < 0 ? - a : a;
50     }
51 
52     function toUint256Safe(int256 a) internal pure returns (uint256) {
53         require(a >= 0);
54         return uint256(a);
55     }
56 }
57 
58 library SafeMathUint {
59     function toInt256Safe(uint256 a) internal pure returns (int256) {
60         int256 b = int256(a);
61         require(b >= 0);
62         return b;
63     }
64 }
65 
66 library SafeMath {
67 
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a, "SafeMath: addition overflow");
71 
72         return c;
73     }
74 
75     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76         return sub(a, b, "SafeMath: subtraction overflow");
77     }
78 
79     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b <= a, errorMessage);
81         uint256 c = a - b;
82 
83         return c;
84     }
85 
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96 
97         return c;
98     }
99 
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
113         return mod(a, b, "SafeMath: modulo by zero");
114     }
115 
116     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         require(b != 0, errorMessage);
118         return a % b;
119     }
120 }
121 
122 abstract contract Context {
123     //function _msgSender() internal view virtual returns (address payable) {
124     function _msgSender() internal view virtual returns (address) {
125         return msg.sender;
126     }
127 
128     function _msgData() internal view virtual returns (bytes memory) {
129         this;
130         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 library Address {
136 
137     function isContract(address account) internal view returns (bool) {
138         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
139         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
140         // for accounts without code, i.e. `keccak256('')`
141         bytes32 codehash;
142         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
143         // solhint-disable-next-line no-inline-assembly
144         assembly {codehash := extcodehash(account)}
145         return (codehash != accountHash && codehash != 0x0);
146     }
147 
148     function sendValue(address payable recipient, uint256 amount) internal {
149         require(address(this).balance >= amount, "Address: insufficient balance");
150 
151         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
152         (bool success,) = recipient.call{value : amount}("");
153         require(success, "Address: unable to send value, recipient may have reverted");
154     }
155 
156     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
157         return functionCall(target, data, "Address: low-level call failed");
158     }
159 
160     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
161         return _functionCallWithValue(target, data, 0, errorMessage);
162     }
163 
164     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
165         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
166     }
167 
168     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
169         require(address(this).balance >= value, "Address: insufficient balance for call");
170         return _functionCallWithValue(target, data, value, errorMessage);
171     }
172 
173     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
174         require(isContract(target), "Address: call to non-contract");
175 
176         // solhint-disable-next-line avoid-low-level-calls
177         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
178         if (success) {
179             return returndata;
180         } else {
181             // Look for revert reason and bubble it up if present
182             if (returndata.length > 0) {
183                 // The easiest way to bubble the revert reason is using memory via assembly
184 
185                 // solhint-disable-next-line no-inline-assembly
186                 assembly {
187                     let returndata_size := mload(returndata)
188                     revert(add(32, returndata), returndata_size)
189                 }
190             } else {
191                 revert(errorMessage);
192             }
193         }
194     }
195 }
196 
197 contract Ownable is Context {
198     address private _owner;
199 
200     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
201 
202     constructor () {
203         address msgSender = _msgSender();
204         _owner = msgSender;
205         emit OwnershipTransferred(address(0), msgSender);
206     }
207 
208     function owner() public view returns (address) {
209         return _owner;
210     }
211 
212     modifier onlyOwner() {
213         require(_owner == _msgSender(), "Ownable: caller is not the owner");
214         _;
215     }
216 
217     function renounceOwnership() public virtual onlyOwner {
218         emit OwnershipTransferred(_owner, address(0));
219         _owner = address(0);
220     }
221 
222     function transferOwnership(address newOwner) public virtual onlyOwner {
223         require(newOwner != address(0), "Ownable: new owner is the zero address");
224         emit OwnershipTransferred(_owner, newOwner);
225         _owner = newOwner;
226     }
227 
228 }
229 
230 interface IUniswapV2Factory {
231     function createPair(address tokenA, address tokenB) external returns (address pair);
232 }
233 
234 interface IUniswapV2Router02 {
235 
236     function factory() external pure returns (address);
237     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
238     function swapExactTokensForETHSupportingFeeOnTransferTokens(
239         uint amountIn,
240         uint amountOutMin,
241         address[] calldata path,
242         address to,
243         uint deadline
244     ) external;
245     function WETH() external pure returns (address);
246 }
247 
248 contract Mako is Context, IERC20, Ownable {
249     using SafeMath for uint256;
250     using Address for address;
251     event SwapAndLiquifyEnabledUpdated(bool enabled);
252     modifier lockTheSwap {
253         inSwapAndLiquify = true;
254         _;
255         inSwapAndLiquify = false;
256     }
257     IUniswapV2Router02 public uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
258     address public uniswapV2PairUSDC = address(0);
259     address private _developmentOne = 0xA983F57A4F15DEf00F10eDe1fBbCaAA52800999c;
260     address private _developmentTwo = 0x69cec0Db2830a78218B77D76302755Bd9A9F211e;    
261     mapping(address => uint256) private _balances;
262     mapping(address => mapping(address => uint256)) private _allowances;
263     mapping(address => bool) private _isExcludedFromFee;
264     string private _name = "MAKO";
265     string private _symbol = "MAKO";
266     uint8 private _decimals = 9;
267     uint256 private _tTotal = 1000000000 * 10 ** _decimals;
268     bool inSwapAndLiquify;
269     bool public swapAndLiquifyEnabled = true;
270     uint256 public usdcPriceToSwap = 500000000; //500 USDC
271     uint256 public _maxWalletAmount = 20000001 * 10 ** _decimals;
272     address public usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; //Mainnet
273     
274     IERC20 usdcToken = IERC20(usdcAddress);
275    
276     struct TaxFees {
277         uint256 buyFee;
278         uint256 sellFee;
279     }
280 
281     bool private doTakeFees;
282     bool private isSellTxn;
283     TaxFees public taxFees;
284      
285     constructor () {
286         _balances[_msgSender()] = _tTotal;
287         _isExcludedFromFee[owner()] = true;
288         _isExcludedFromFee[address(this)] = true;
289         taxFees = TaxFees(98, 98); //just at launch to catch any bots
290         emit Transfer(address(0), _msgSender(), _tTotal);
291     }
292 
293     function name() public view returns (string memory) {
294         return _name;
295     }
296 
297     function symbol() public view returns (string memory) {
298         return _symbol;
299     }
300 
301     function decimals() public view returns (uint8) {
302         return _decimals;
303     }
304 
305     function totalSupply() public view override returns (uint256) {
306         return _tTotal;
307     }
308 
309     function balanceOf(address account) public view override returns (uint256) {
310         return _balances[account];
311     }
312 
313     function transfer(address recipient, uint256 amount) public override returns (bool) {
314         _transfer(_msgSender(), recipient, amount);
315         return true;
316     }
317 
318     function allowance(address owner, address spender) public view override returns (uint256) {
319         return _allowances[owner][spender];
320     }
321 
322     function approve(address spender, uint256 amount) public override returns (bool) {
323         _approve(_msgSender(), spender, amount);
324         return true;
325     }
326 
327     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
328         _transfer(sender, recipient, amount);
329         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
330         return true;
331     }
332 
333     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
334         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
335         return true;
336     }
337 
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
339         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
340         return true;
341     }
342 
343     function setMaxWalletAmount(uint256 maxWalletAmount) external onlyOwner {
344         _maxWalletAmount = maxWalletAmount * 10 ** 9;
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
358     function setWalletAddresses(address developmentOne, address developmentTwo) external onlyOwner {
359         _developmentOne = developmentOne;
360         _developmentTwo = developmentTwo;
361     }
362 
363     function setTaxFees(uint256 buyFee, uint256 sellFee) external onlyOwner {
364         taxFees.buyFee = buyFee;
365         taxFees.sellFee = sellFee;
366     }
367 
368     function openTrading() external onlyOwner {
369         require(uniswapV2PairUSDC == address(0),"UniswapV2Pair has already been set");
370         uniswapV2PairUSDC = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), usdcAddress);
371     }
372     
373     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
374         swapAndLiquifyEnabled = _enabled;
375         emit SwapAndLiquifyEnabledUpdated(_enabled);
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
390     function _transfer(address from, address to, uint256 amount) private {
391         require(from != address(0), "ERC20: transfer from the zero address");
392         require(to != address(0), "ERC20: transfer to the zero address");
393         require(amount > 0, "Transfer amount must be greater than zero");
394         require(uniswapV2PairUSDC != address(0),"UniswapV2Pair has not been set");
395         bool isSell = false;
396         bool takeFees = !_isExcludedFromFee[from] && !_isExcludedFromFee[to] && from != owner() && to != owner();
397         uint256 holderBalance = balanceOf(to).add(amount);
398         
399         if (from == uniswapV2PairUSDC) {
400             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
401         }
402         if (from != uniswapV2PairUSDC && to == uniswapV2PairUSDC) {//if sell
403             //only tax if tokens are going back to Uniswap
404             isSell = true;
405             sellTokens();
406         }
407         if (from != uniswapV2PairUSDC && to != uniswapV2PairUSDC) {
408             require(holderBalance <= _maxWalletAmount, "Wallet cannot exceed max Wallet limit");
409         }
410         _tokenTransfer(from, to, amount, takeFees, isSell);
411     }
412 
413     function claimTokens() external {
414         uint256 contractTokenBalance = balanceOf(address(this));
415         if (contractTokenBalance > 0) {
416             if (!inSwapAndLiquify && swapAndLiquifyEnabled) {
417                 swapTokens(contractTokenBalance);
418             }
419         }
420     }
421 
422     function sellTokens() private {
423         uint256 contractTokenBalance = balanceOf(address(this));
424         if (contractTokenBalance > 0) {
425             uint256 tokenAmount = getTokenAmountByUSDCPrice();
426             if (contractTokenBalance >= tokenAmount && !inSwapAndLiquify && swapAndLiquifyEnabled) {
427                 swapTokens(tokenAmount);
428             }
429         }
430     }
431     function swapTokens(uint256 tokenAmount) private lockTheSwap {
432         address[] memory path;
433         path = new address[](3);
434         path[0] = address(this);
435         path[1] = usdcAddress;
436         path[2] = uniswapV2Router.WETH();
437         // Approve the swap first
438         _approve(address(this), address(uniswapV2Router), tokenAmount);
439          uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
440             tokenAmount,
441             0, // accept any amount of ETH
442             path,
443             address(this),
444             block.timestamp
445         );
446         
447         uint256 ethBalance = address(this).balance;
448         uint256 halfShare = ethBalance.div(2);  
449         payable(_developmentOne).transfer(halfShare);
450         payable(_developmentTwo).transfer(halfShare);  
451 
452     }
453 
454     function getTokenAmountByUSDCPrice() public view returns (uint256)  {
455         address[] memory path = new address[](2);
456         path[0] = usdcAddress;
457         path[1] = address(this);
458         return uniswapV2Router.getAmountsOut(usdcPriceToSwap, path)[1];
459     }
460 
461     function setUSDCPriceToSwap(uint256 usdcPriceToSwap_) external onlyOwner {
462         usdcPriceToSwap = usdcPriceToSwap_;
463     }
464 
465     receive() external payable {}
466 
467     function sendEthBack() external {
468         uint256 ethBalance = address(this).balance;
469         payable(_developmentOne).transfer(ethBalance);
470     }
471 
472     function extractERC20Tokens(address contractAddress) external {
473         IERC20 erc20Token = IERC20(contractAddress);
474         uint256 balance = erc20Token.balanceOf(address(this));
475         erc20Token.transfer(_developmentOne, balance);
476     }
477 
478     //this method is responsible for taking all fee, if takeFee is true
479     function _tokenTransfer(address sender, address recipient, uint256 amount,
480         bool takeFees, bool isSell) private {
481         uint256 taxAmount = takeFees ? amount.mul(taxFees.buyFee).div(100) : 0;
482         if (takeFees && isSell) {
483             taxAmount = amount.mul(taxFees.sellFee).div(100);
484         }
485         uint256 transferAmount = amount.sub(taxAmount);
486         _balances[sender] = _balances[sender].sub(amount);
487         _balances[recipient] = _balances[recipient].add(transferAmount);
488         _balances[address(this)] = _balances[address(this)].add(taxAmount);
489         emit Transfer(sender, recipient, amount);
490     }
491 }