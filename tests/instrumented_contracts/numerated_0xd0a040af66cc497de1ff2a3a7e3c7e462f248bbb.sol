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
180     function createPair(address tokenA, address tokenB) external returns (address pair);
181 
182 }
183 
184 interface IUniswapV2Router01 {
185     function factory() external pure returns (address);
186 
187     function WETH() external pure returns (address);
188 
189 }
190 
191 interface IUniswapV2Router02 is IUniswapV2Router01 {
192 
193     function swapExactTokensForETHSupportingFeeOnTransferTokens(
194         uint amountIn,
195         uint amountOutMin,
196         address[] calldata path,
197         address to,
198         uint deadline
199     ) external;
200 }
201 
202 
203 contract TRX is Context, IERC20, Ownable {
204 
205     using SafeMath for uint256;
206     using Address for address;
207 
208     string private _name;
209     string private _symbol;
210     uint8 private _decimals;
211     address payable public marketingWalletAddress = payable(0x5e502565a853d9B66C75f1ec76EffDFc19b3ca86);
212     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
213 
214     mapping (address => uint256) _balances;
215     mapping (address => mapping (address => uint256)) private _allowances;
216 
217     mapping (address => bool) public isExcludedFromFee;
218     mapping (address => bool) public isMarketPair;
219 
220 
221     uint256 public _totalTaxIfBuying = 2;
222     uint256 public _totalTaxIfSelling = 2;
223 
224     uint256 private _totalSupply;
225     uint256 private _minimumTokensBeforeSwap = 0;
226 
227 
228 
229     IUniswapV2Router02 public uniswapV2Router;
230     address public uniswapPair;
231 
232     bool inSwapAndLiquify;
233     bool public swapAndLiquifyEnabled = true;
234     bool public swapAndLiquifyByLimitOnly = false;
235 
236     event SwapAndLiquifyEnabledUpdated(bool enabled);
237     event SwapAndLiquify(
238         uint256 tokensSwapped,
239         uint256 ethReceived,
240         uint256 tokensIntoLiqudity
241     );
242 
243     event SwapETHForTokens(
244         uint256 amountIn,
245         address[] path
246     );
247 
248     event SwapTokensForETH(
249         uint256 amountIn,
250         address[] path
251     );
252 
253     modifier lockTheSwap {
254         inSwapAndLiquify = true;
255         _;
256         inSwapAndLiquify = false;
257     }
258 
259 
260     constructor (
261         string memory coinName,
262         string memory coinSymbol
263     ) payable {
264 
265         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
266 
267         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
268             .createPair(address(this), _uniswapV2Router.WETH());
269         _name = coinName;
270         _symbol = coinSymbol;
271         _decimals = 18;
272         _owner = 0xcAc7A5c0c2C447fC3bdA51d35AADC621Da666862;
273         _totalSupply = 420690000000000000000000000000000;
274         _minimumTokensBeforeSwap = 4206900000000000000000000000;
275         uniswapV2Router = _uniswapV2Router;
276         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
277         isExcludedFromFee[msg.sender] = true;
278         isExcludedFromFee[_owner] = true;
279         isExcludedFromFee[address(this)] = true;
280         isExcludedFromFee[marketingWalletAddress] = true;
281 
282         isMarketPair[address(uniswapPair)] = true;
283 
284         _balances[_owner] = _totalSupply;
285         emit Transfer(address(0), _owner, _totalSupply);
286     }
287 
288 
289     function name() public view returns (string memory) {
290         return _name;
291     }
292 
293     function symbol() public view returns (string memory) {
294         return _symbol;
295     }
296 
297     function decimals() public view returns (uint8) {
298         return _decimals;
299     }
300 
301     function totalSupply() public view override returns (uint256) {
302         return _totalSupply;
303     }
304 
305     function balanceOf(address account) public view override returns (uint256) {
306         return _balances[account];
307     }
308 
309     function allowance(address owner, address spender) public view override returns (uint256) {
310         return _allowances[owner][spender];
311     }
312 
313     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
314         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
315         return true;
316     }
317 
318     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
319         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
320         return true;
321     }
322 
323     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
324         return _minimumTokensBeforeSwap;
325     }
326 
327     function approve(address spender, uint256 amount) public override returns (bool) {
328         _approve(_msgSender(), spender, amount);
329         return true;
330     }
331 
332     function _approve(address owner, address spender, uint256 amount) private {
333         require(owner != address(0), "ERC20: approve from the zero address");
334         require(spender != address(0), "ERC20: approve to the zero address");
335 
336         _allowances[owner][spender] = amount;
337         emit Approval(owner, spender, amount);
338     }
339 
340     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
341         isMarketPair[account] = newValue;
342     }
343 
344     function setNumTokensBeforeSwap(uint256 newLimit) external onlyOwner() {
345         _minimumTokensBeforeSwap = newLimit;
346     }
347 
348     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
349         swapAndLiquifyEnabled = _enabled;
350         emit SwapAndLiquifyEnabledUpdated(_enabled);
351     }
352 
353     function setSwapAndLiquifyByLimitOnly(bool newValue) public onlyOwner {
354         swapAndLiquifyByLimitOnly = newValue;
355     }
356 
357     function setFee(uint256 buy,uint256 sell) public onlyOwner {
358         _totalTaxIfBuying = buy;
359         _totalTaxIfSelling = sell;
360     }
361 
362     function setMarketAddress(address addr) public onlyOwner {
363         marketingWalletAddress = payable(addr);
364     }
365 
366     function getCirculatingSupply() public view returns (uint256) {
367         return _totalSupply.sub(balanceOf(deadAddress));
368     }
369 
370     function transferToAddressETH(address payable recipient, uint256 amount) private {
371         recipient.transfer(amount);
372     }
373     
374      //to recieve ETH from uniswapV2Router when swaping
375     receive() external payable {}
376 
377     function transfer(address recipient, uint256 amount) public override returns (bool) {
378         _transfer(_msgSender(), recipient, amount);
379         return true;
380     }
381 
382     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
383         _transfer(sender, recipient, amount);
384         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
385         return true;
386     }
387 
388     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
389 
390         require(sender != address(0), "ERC20: transfer from the zero address");
391         require(recipient != address(0), "ERC20: transfer to the zero address");
392         require(amount > 0, "Transfer amount must be greater than zero");
393         
394 
395         if(inSwapAndLiquify)
396         {
397             return _basicTransfer(sender, recipient, amount);
398         }
399         else
400         {
401 
402             uint256 contractTokenBalance = balanceOf(address(this));
403             bool overMinimumTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
404 
405             if (overMinimumTokenBalance && !inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled)
406             {
407                 if(swapAndLiquifyByLimitOnly)
408                     contractTokenBalance = _minimumTokensBeforeSwap;
409                 swapAndLiquify(contractTokenBalance);
410             }
411 
412             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
413 
414             uint256 finalAmount = (isExcludedFromFee[sender] || isExcludedFromFee[recipient]) ?
415                                          amount : takeFee(sender, recipient, amount);
416 
417 
418             _balances[recipient] = _balances[recipient].add(finalAmount);
419 
420             emit Transfer(sender, recipient, finalAmount);
421             return true;
422         }
423     }
424 
425     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
426         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
427         _balances[recipient] = _balances[recipient].add(amount);
428         emit Transfer(sender, recipient, amount);
429         return true;
430     }
431 
432 
433     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
434 
435         // swap token -> eth
436         swapTokensForEth(tAmount);
437         uint256 amountReceived = address(this).balance;
438          
439         if(amountReceived > 0)
440             transferToAddressETH(marketingWalletAddress, amountReceived);
441 
442     }
443 
444     function swapTokensForEth(uint256 tokenAmount) private {
445         // generate the uniswap pair path of token -> weth
446         address[] memory path = new address[](2);
447         path[0] = address(this);
448         path[1] = uniswapV2Router.WETH();
449 
450         _approve(address(this), address(uniswapV2Router), tokenAmount);
451 
452         // make the swap
453         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
454             tokenAmount,
455             0, // accept any amount of ETH
456             path,
457             address(this), // The contract
458             block.timestamp
459         );
460 
461         emit SwapTokensForETH(tokenAmount, path);
462     }
463 
464 
465 
466     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
467 
468         uint256 feeAmount = 0;
469         if(isMarketPair[sender]) {
470             feeAmount = amount.mul(_totalTaxIfBuying).div(100);
471         }
472         else if(isMarketPair[recipient]) {
473             feeAmount = amount.mul(_totalTaxIfSelling).div(100);
474         }
475         if(feeAmount > 0) {
476             _balances[address(this)] = _balances[address(this)].add(feeAmount);
477             emit Transfer(sender, address(this), feeAmount);
478         }
479 
480         return amount.sub(feeAmount);
481     }
482 
483    
484 }