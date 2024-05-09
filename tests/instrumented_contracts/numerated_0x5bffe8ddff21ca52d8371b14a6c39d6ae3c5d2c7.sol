1 /**
2  * SPDX-License-Identifier: MIT
3  */ 
4 
5 // https://t.me/HolaToken_Offical
6 // https://www.holatoken.io
7 
8 pragma solidity ^0.8.6;
9 
10 
11 library SafeMath {
12 
13     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
14         uint256 c = a + b;
15         if (c < a) return (false, 0);
16         return (true, c);
17     }
18 
19     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
20         if (b > a) return (false, 0);
21         return (true, a - b);
22     }
23 
24     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         if (a == 0) return (true, 0);
26         uint256 c = a * b;
27         if (c / a != b) return (false, 0);
28         return (true, c);
29     }
30 
31 
32     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         if (b == 0) return (false, 0);
34         return (true, a / b);
35     }
36 
37     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b == 0) return (false, 0);
39         return (true, a % b);
40     }
41 
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         require(b <= a, "SafeMath: subtraction overflow");
50         return a - b;
51     }
52 
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) return 0;
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b > 0, "SafeMath: division by zero");
63         return a / b;
64     }
65 
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b > 0, "SafeMath: modulo by zero");
68         return a % b;
69     }
70 
71 
72     function sub(
73         uint256 a,
74         uint256 b,
75         string memory errorMessage
76     ) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         return a - b;
79     }
80 
81  
82     function div(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b > 0, errorMessage);
88         return a / b;
89     }
90 
91     function mod(
92         uint256 a,
93         uint256 b,
94         string memory errorMessage
95     ) internal pure returns (uint256) {
96         require(b > 0, errorMessage);
97         return a % b;
98     }
99 }
100 
101 interface IERC20 {
102     function totalSupply() external view returns (uint256);
103     function balanceOf(address account) external view returns (uint256);
104     function transfer(address recipient, uint256 amount) external returns (bool);
105     function allowance(address owner, address spender) external view returns (uint256);
106     function approve(address spender, uint256 amount) external returns (bool);
107     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
108     event Transfer(address indexed from, address indexed to, uint256 value);
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 interface IERC20Metadata is IERC20 {
113     function name() external view returns (string memory);
114     function symbol() external view returns (string memory);
115     function decimals() external view returns (uint8);
116 }
117 
118 abstract contract Context {
119     function _msgSender() internal view virtual returns (address) {return msg.sender;}
120     function _msgData() internal view virtual returns (bytes calldata) {this; return msg.data;}
121 }
122 
123 library Address {
124     function isContract(address account) internal view returns (bool) { 
125         uint256 size; assembly { size := extcodesize(account) } return size > 0;
126     }
127     function sendValue(address payable recipient, uint256 amount) internal {
128         require(address(this).balance >= amount, "Address: insufficient balance");(bool success, ) = recipient.call{ value: amount }("");
129         require(success, "Address: unable to send value, recipient may have reverted");
130     }
131     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
132         return functionCall(target, data, "Address: low-level call failed");
133         
134     }
135     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, 0, errorMessage);
137         
138     }
139     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
140         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
141         
142     }
143     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
144         require(address(this).balance >= value, "Address: insufficient balance for call");
145         require(isContract(target), "Address: call to non-contract");
146         (bool success, bytes memory returndata) = target.call{ value: value }(data);
147         return _verifyCallResult(success, returndata, errorMessage);
148     }
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
153         require(isContract(target), "Address: static call to non-contract");
154         (bool success, bytes memory returndata) = target.staticcall(data);
155         return _verifyCallResult(success, returndata, errorMessage);
156     }
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
161         require(isContract(target), "Address: delegate call to non-contract");
162         (bool success, bytes memory returndata) = target.delegatecall(data);
163         return _verifyCallResult(success, returndata, errorMessage);
164     }
165     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
166         if (success) { return returndata; } else {
167             if (returndata.length > 0) {
168                 assembly {
169                     let returndata_size := mload(returndata)
170                     revert(add(32, returndata), returndata_size)
171                 }
172             } else {revert(errorMessage);}
173         }
174     }
175 }
176 
177 abstract contract Ownable is Context {
178     address private _owner;
179 
180     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
181 
182     constructor () {
183         address msgSender = _msgSender();
184         _owner = msgSender;
185         emit OwnershipTransferred(address(0), msgSender);
186     }
187 
188     function owner() public view returns (address) {
189         return _owner;
190     }   
191     
192     modifier onlyOwner() {
193         require(_owner == _msgSender(), "Ownable: caller is not the owner");
194         _;
195     }
196     
197     function renounceOwnership() public virtual onlyOwner {
198         emit OwnershipTransferred(_owner, address(0));
199         _owner = address(0);
200     }
201 
202     function transferOwnership(address newOwner) public virtual onlyOwner {
203         require(newOwner != address(0), "Ownable: new owner is the zero address");
204         emit OwnershipTransferred(_owner, newOwner);
205         _owner = newOwner;
206     }
207 }
208 
209 interface IPancakeV2Factory {
210     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
211     function createPair(address tokenA, address tokenB) external returns (address pair);
212 }
213 
214 interface IPancakeV2Router {
215     function factory() external pure returns (address);
216     function WETH() external pure returns (address);
217     
218     function addLiquidity(
219         address tokenA,
220         address tokenB,
221         uint amountADesired,
222         uint amountBDesired,
223         uint amountAMin,
224         uint amountBMin,
225         address to,
226         uint deadline
227     ) external returns (uint amountA, uint amountB, uint liquidity);
228 
229     function addLiquidityETH(
230         address token,
231         uint amountTokenDesired,
232         uint amountTokenMin,
233         uint amountETHMin,
234         address to,
235         uint deadline
236     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
237 
238     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
239         uint amountIn,
240         uint amountOutMin,
241         address[] calldata path,
242         address to,
243         uint deadline
244     ) external;
245 
246     function swapExactETHForTokensSupportingFeeOnTransferTokens(
247         uint amountOutMin,
248         address[] calldata path,
249         address to,
250         uint deadline
251     ) external payable;
252 
253     function swapExactTokensForETHSupportingFeeOnTransferTokens(
254         uint amountIn,
255         uint amountOutMin,
256         address[] calldata path,
257         address to,
258         uint deadline
259     ) external;
260 }
261 
262 contract HOLA is IERC20Metadata, Ownable {
263     using SafeMath for uint256;
264     using Address for address;
265     
266     address internal deadAddress = 0x000000000000000000000000000000000000dEaD;
267     
268     string constant _name = "Hola Token";
269     string constant _symbol = "$HOLA";
270     uint8 constant _decimals = 18;
271     
272     uint256 internal constant _totalSupply = 10_000_000_000 * (10**18);
273   
274     uint256 public maxTxAmount = _totalSupply / 1000; // 0.1% of the total supply
275     uint256 public maxWalletBalance = _totalSupply / 50; // 2% of the total supply
276 
277     uint256 private constant FEES_DIVISOR = 10**3;
278     
279     bool public antiBotEnabled = false;
280     uint256 public antiBotFee = 990; // 99%
281     uint256 public _startTimeForSwap;
282     
283 
284     IPancakeV2Router public router;
285     address public pair;
286     
287     mapping (address => uint256) internal _balances;
288     mapping (address => mapping (address => uint256)) internal _allowances;
289 
290     mapping(address => bool) public _isBlacklisted;
291     mapping(address => bool) public _iswhitelisted;
292     
293     event UpdatePancakeswapRouter(address indexed newAddress, address indexed oldAddress);
294     
295     event SwapTokensForETH(uint256 amountIn, address[] path);
296     
297     constructor () {
298         _balances[msg.sender] = _totalSupply;
299         
300         IPancakeV2Router _newPancakeRouter = IPancakeV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
301         pair = IPancakeV2Factory(_newPancakeRouter.factory()).createPair(address(this), _newPancakeRouter.WETH());
302         router = _newPancakeRouter;
303 
304         _approve(owner(), address(router), ~uint256(0));
305         
306         emit Transfer(address(0), owner(), _totalSupply);
307     }
308     
309     receive() external payable { }
310     
311     function name() external pure override returns (string memory) {
312         return _name;
313     }
314 
315     function symbol() external pure override returns (string memory) {
316         return _symbol;
317     }
318 
319     function decimals() external pure override returns (uint8) {
320         return _decimals;
321     }
322 
323     function totalSupply() external pure override returns (uint256) {
324         return _totalSupply;
325     }
326 
327     function balanceOf(address account) public view override returns (uint256) { 
328         return _balances[account]; 
329     }
330     
331         
332     function transfer(address recipient, uint256 amount) external override returns (bool){
333         _transfer(_msgSender(), recipient, amount);
334         return true;
335         }
336         
337     function allowance(address owner, address spender) external view override returns (uint256){
338         return _allowances[owner][spender];
339         }
340     
341     function approve(address spender, uint256 amount) external override returns (bool) {
342         _approve(_msgSender(), spender, amount);
343         return true;
344         }
345         
346     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool){
347         _transfer(sender, recipient, amount);
348         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
349         return true;
350         }
351         
352     
353     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
354         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
355         return true;
356     }
357     
358     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
359         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
360         return true;
361     }
362     
363     function _approve(address owner, address spender, uint256 amount) internal {
364         require(owner != address(0), "BaseRfiToken: approve from the zero address");
365         require(spender != address(0), "BaseRfiToken: approve to the zero address");
366 
367         _allowances[owner][spender] = amount;
368         emit Approval(owner, spender, amount);
369     }
370     
371 
372     function blacklistAddress(address account, bool value) external onlyOwner{
373         _isBlacklisted[account] = value;
374     }
375 
376     function whitelistAddress(address account, bool value) external onlyOwner{
377         _iswhitelisted[account] = value;
378     }
379     
380     function updateWalletMax(uint256 _walletMax) external onlyOwner {
381         maxWalletBalance = _walletMax * (10**18);
382     }
383     
384     function updateTransactionMax(uint256 _txMax) external onlyOwner {
385         maxTxAmount = _txMax * (10**18);
386     }
387 
388     function toggleAntiBot(bool toggleStatus) external onlyOwner() {
389         antiBotEnabled = toggleStatus;
390         if(antiBotEnabled){
391             _startTimeForSwap = block.timestamp + 40;    
392         }    
393     }
394     
395     function updateRouterAddress(address newAddress) external onlyOwner {
396         require(newAddress != address(router), "The router already has that address");
397         emit UpdatePancakeswapRouter(newAddress, address(router));
398         
399         router = IPancakeV2Router(newAddress);   
400     }
401 
402     function takeFee(address sender, uint256 amount) internal returns (uint256)  {
403         uint256 feeAmount = amount.mul(antiBotFee).div(FEES_DIVISOR);
404 
405         _balances[address(this)] = _balances[address(this)].add(feeAmount);
406         emit Transfer(sender, address(this), feeAmount);
407         // convert to ETH
408         swapTokensForETH(balanceOf(address(this)));
409         return amount.sub(feeAmount);
410     }
411         
412     
413     function _transfer(address sender, address recipient, uint256 amount) private {
414         require(sender != address(0), "Token: transfer from the zero address");
415         require(recipient != address(0), "Token: transfer to the zero address");
416         require(sender != address(deadAddress), "Token: transfer from the burn address");
417         require(amount > 0, "Transfer amount must be greater than zero");
418 
419         require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "Blacklisted address");
420         
421         if (
422             sender != address(router) && //router -> pair is removing liquidity which shouldn't have max
423             !_iswhitelisted[recipient] && //no max for those whitelisted
424             !_iswhitelisted[sender] 
425         ) {
426             require(amount <= maxTxAmount, "Transfer amount exceeds the Max Transaction Amount.");
427             
428         }
429         
430         if ( maxWalletBalance > 0 && !_iswhitelisted[recipient] && !_iswhitelisted[sender] && recipient != address(pair) ) {
431                 uint256 recipientBalance = balanceOf(recipient);
432                 require(recipientBalance + amount <= maxWalletBalance, "New balance would exceed the maxWalletBalance");
433             }
434 
435         //Exchange tokens
436         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
437             
438          // indicates whether or not fee should be deducted from the transfer - only when antibot enabled
439         bool _isTakeFee = antiBotEnabled && block.timestamp <= _startTimeForSwap ? true : false;
440         
441          // if any account belongs to _iswhitelisted account then remove the fee
442         if(_iswhitelisted[sender] || _iswhitelisted[recipient]) { 
443             _isTakeFee = false; 
444         }
445 
446         // transfer between wallets
447         if(sender != pair && recipient != pair) {
448            _isTakeFee = false;
449         }
450         
451          uint256 amountReceived = _isTakeFee ? takeFee(sender, amount) : amount;
452         _balances[recipient] = _balances[recipient].add(amountReceived);
453 
454         emit Transfer(sender, recipient, amountReceived);
455         
456     }
457     
458     function TransferETH(address payable recipient, uint256 amount) external onlyOwner {
459         require(recipient != address(0), "Cannot withdraw the ETH balance to a zero address");
460         recipient.transfer(amount);
461     }
462 
463     function swapTokensForETH(uint256 tokenAmount) private {
464         // generate the uniswap pair path of token -> weth
465         address[] memory path = new address[](2);
466         path[0] = address(this);
467         path[1] = router.WETH();
468 
469         _approve(address(this), address(router), tokenAmount);
470 
471         // make the swap
472         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
473             tokenAmount,
474             0, // accept any amount of ETH
475             path,
476             address(this),
477             block.timestamp
478         );
479         
480         emit SwapTokensForETH(tokenAmount, path);
481     }
482     
483 }