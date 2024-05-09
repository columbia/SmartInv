1 // SPDX-License-Identifier: Unlicensed
2 
3 
4 pragma solidity ^0.8.4;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39 
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         if (a == 0) {
42             return 0;
43         }
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46         return c;
47     }
48 
49     function div(uint256 a, uint256 b) internal pure returns (uint256) {
50         return div(a, b, "SafeMath: division by zero");
51     }
52 
53     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b > 0, errorMessage);
55         uint256 c = a / b;
56         return c;
57     }
58 
59 }
60 
61 contract Ownable is Context {
62     address private _owner;
63     address private _previousOwner;
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     constructor () {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     function owner() public view returns (address) {
73         return _owner;
74     }
75 
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86 }  
87 
88 interface IUniswapV2Factory {
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 }
91 
92 interface IUniswapV2Router02 {
93     function swapExactTokensForETHSupportingFeeOnTransferTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external;
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102     function addLiquidityETH(
103         address token,
104         uint amountTokenDesired,
105         uint amountTokenMin,
106         uint amountETHMin,
107         address to,
108         uint deadline
109     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
110 }
111 
112 contract TehGreatRace is Context, IERC20, Ownable {
113     using SafeMath for uint256;
114     mapping (address => uint256) private _rOwned;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping (address => uint) private cooldown;
119     uint256 private constant _tTotal = 1e9 * 10**8;
120     
121     uint256 private _buyDevelopmentFee = 99;
122     uint256 private _previousBuyDevelopmentFee = _buyDevelopmentFee;
123     
124     uint256 private _sellDevelopmentFee = 99;
125     uint256 private _previousSellDevelopmentFee = _sellDevelopmentFee;
126        
127     address payable private _DevelopmentWallet;
128     uint256 private tokensForLiquidity;
129     
130     string private constant _name = "Teh Great Race";
131     string private constant _symbol = "F12";
132     uint8 private constant _decimals = 9;
133     
134     IUniswapV2Router02 public uniswapV2Router;
135     address public uniswapV2Pair;
136     bool private tradingOpen;
137     bool private swapping;
138     bool private inSwap = false;
139     bool private swapEnabled = false;
140     bool private cooldownEnabled = false;
141     uint256 private tradingActiveBlock = 0; 
142     uint256 private blocksToBlacklist = 11;
143     uint256 private _maxBuyAmount = _tTotal;
144     uint256 private _maxSellAmount = _tTotal;
145     uint256 private _maxWalletAmount = _tTotal;
146     uint256 private swapTokensAtAmount = 0;
147     
148     event MaxBuyAmountUpdated(uint _maxBuyAmount);
149     event MaxSellAmountUpdated(uint _maxSellAmount);
150     
151     modifier lockTheSwap {
152         inSwap = true;
153         _;
154         inSwap = false;
155     }
156     constructor (address _uniswapV2Router, address DevelopmentWallet) {
157         uniswapV2Router = IUniswapV2Router02(_uniswapV2Router);
158 
159         _DevelopmentWallet = payable(DevelopmentWallet);
160         _rOwned[_msgSender()] = _tTotal;
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[_DevelopmentWallet] = true;
164         emit Transfer(address(0), _msgSender(), _tTotal);
165     }
166 
167     function name() public pure returns (string memory) {
168         return _name;
169     }
170 
171     function symbol() public pure returns (string memory) {
172         return _symbol;
173     }
174 
175     function decimals() public pure returns (uint8) {
176         return _decimals;
177     }
178 
179     function totalSupply() public pure override returns (uint256) {
180         return _tTotal;
181     }
182 
183     function balanceOf(address account) public view override returns (uint256) {
184         return _rOwned[account];
185     }
186 
187     function transfer(address recipient, uint256 amount) public override returns (bool) {
188         _transfer(_msgSender(), recipient, amount);
189         return true;
190     }
191 
192     function allowance(address owner, address spender) public view override returns (uint256) {
193         return _allowances[owner][spender];
194     }
195 
196     function approve(address spender, uint256 amount) public override returns (bool) {
197         _approve(_msgSender(), spender, amount);
198         return true;
199     }
200 
201     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
202         _transfer(sender, recipient, amount);
203         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount));
204         return true;
205     }
206 
207     function setCooldownEnabled(bool onoff) external onlyOwner() {
208         cooldownEnabled = onoff;
209     }
210 
211     function setSwapEnabled(bool onoff) external onlyOwner(){
212         swapEnabled = onoff;
213     }
214 
215     function _approve(address owner, address spender, uint256 amount) private {
216         require(owner != address(0));
217         require(spender != address(0));
218         _allowances[owner][spender] = amount;
219         emit Approval(owner, spender, amount);
220     }
221 
222     function _transfer(address from, address to, uint256 amount) private {
223         require(from != address(0));
224         require(to != address(0));
225         require(amount > 0);
226         bool takeFee = false;
227         bool shouldSwap = false;
228         if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {
229             require(!bots[from] && !bots[to]);
230 
231             takeFee = true;
232             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
233                 require(amount <= _maxBuyAmount);
234                 require(balanceOf(to) + amount <= _maxWalletAmount);
235                 require(cooldown[to] < block.timestamp);
236                 cooldown[to] = block.timestamp + (30 seconds);
237             }
238             
239             if (to == uniswapV2Pair && from != address(uniswapV2Router) && !_isExcludedFromFee[from] && cooldownEnabled) {
240                 require(amount <= _maxSellAmount);
241                 shouldSwap = true;
242             }
243         }
244 
245         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
246             takeFee = false;
247         }
248 
249         uint256 contractTokenBalance = balanceOf(address(this));
250         bool canSwap = (contractTokenBalance > swapTokensAtAmount) && shouldSwap;
251 
252         if (canSwap && swapEnabled && !swapping && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
253             swapping = true;
254             swapBack();
255             swapping = false;
256         }
257 
258         _tokenTransfer(from,to,amount,takeFee, shouldSwap);
259     }
260 
261     function swapBack() private {
262         uint256 tokensForDevelopment = balanceOf(address(this));
263         
264         bool success;
265         
266         if(tokensForDevelopment == 0) {return;}
267 
268         if(tokensForDevelopment > swapTokensAtAmount * 10) {
269             tokensForDevelopment = swapTokensAtAmount * 10;
270         }
271                 
272         uint256 initialETHBalance = address(this).balance;
273 
274         swapTokensForEth(tokensForDevelopment); 
275                               
276         (success,) = address(_DevelopmentWallet).call{value: address(this).balance - initialETHBalance}("");
277     }
278 
279     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
280         address[] memory path = new address[](2);
281         path[0] = address(this);
282         path[1] = uniswapV2Router.WETH();
283         _approve(address(this), address(uniswapV2Router), tokenAmount);
284         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
285             tokenAmount,
286             0,
287             path,
288             address(this),
289             block.timestamp
290         );
291     }
292        
293     function openTrading() external onlyOwner() {
294         require(!tradingOpen,"trading is already open");        
295         _approve(address(this), address(uniswapV2Router), _tTotal);
296         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
297         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
298         swapEnabled = true;
299         cooldownEnabled = true;
300         _maxBuyAmount = 5e6 * 10**8;
301         _maxSellAmount = 5e6 * 10**8;
302         _maxWalletAmount = 1e7 * 10**8;
303         swapTokensAtAmount = 5e5 * 10**8;
304         tradingOpen = true;
305         tradingActiveBlock = block.number;
306         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
307     }
308     
309 
310     function setMaxBuyAmount(uint256 maxBuy) public onlyOwner {
311         _maxBuyAmount = maxBuy;
312     }
313 
314     function setMaxSellAmount(uint256 maxSell) public onlyOwner {
315         _maxSellAmount = maxSell;
316     }
317     
318     function setMaxWalletAmount(uint256 maxToken) public onlyOwner {
319         _maxWalletAmount = maxToken;
320     }
321     
322     function setSwapTokensAtAmount(uint256 newAmount) public onlyOwner {
323         require(newAmount >= 1e3 * 10**9);
324         require(newAmount <= 5e6 * 10**9);
325         swapTokensAtAmount = newAmount;
326     }
327 
328     function setDevelopmentWallet(address DevelopmentWallet) public onlyOwner() {
329         require(DevelopmentWallet != address(0));
330         _isExcludedFromFee[_DevelopmentWallet] = false;
331         _DevelopmentWallet = payable(DevelopmentWallet);
332         _isExcludedFromFee[_DevelopmentWallet] = true;
333     }
334 
335     function excludeFromFee(address account) public onlyOwner {
336         _isExcludedFromFee[account] = true;
337     }
338     
339     function includeInFee(address account) public onlyOwner {
340         _isExcludedFromFee[account] = false;
341     }
342 
343     function setBuyFee(uint256 buyDevelopmentFee) external onlyOwner {
344         _buyDevelopmentFee = buyDevelopmentFee;
345     }
346 
347     function setSellFee(uint256 sellDevelopmentFee) external onlyOwner {
348         _sellDevelopmentFee = sellDevelopmentFee;
349         
350     }
351 
352     function setBlocksToBlacklist(uint256 blocks) public onlyOwner {
353         blocksToBlacklist = blocks;
354     }
355 
356     function removeAllFee() private {
357         if(_buyDevelopmentFee == 0 && _sellDevelopmentFee == 0) return;
358         
359         _previousBuyDevelopmentFee = _buyDevelopmentFee;
360         _previousSellDevelopmentFee = _sellDevelopmentFee;
361                 
362         _buyDevelopmentFee = 0;
363         _sellDevelopmentFee = 0;        
364     }
365     
366     function restoreAllFee() private {
367         _buyDevelopmentFee = _previousBuyDevelopmentFee;
368         _sellDevelopmentFee = _previousSellDevelopmentFee;
369     }
370 
371         
372     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee, bool isSell) private {
373         if(!takeFee) {
374             removeAllFee();
375         } else {
376             amount = _takeFees(sender, amount, isSell);
377         }
378 
379         _transferStandard(sender, recipient, amount);
380         
381         if(!takeFee) {
382             restoreAllFee();
383         }
384     }
385 
386     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
387         _rOwned[sender] = _rOwned[sender].sub(tAmount);
388         _rOwned[recipient] = _rOwned[recipient].add(tAmount);
389         emit Transfer(sender, recipient, tAmount);
390     }
391 
392     function _takeFees(address sender, uint256 amount, bool isSell) private returns (uint256) {
393         uint256 devFee;
394         if(tradingActiveBlock + blocksToBlacklist >= block.number){
395             devFee = 99;            
396         } else {
397             if (isSell) {
398                 devFee = _sellDevelopmentFee;                
399             } else {
400                 devFee = _buyDevelopmentFee;                
401             }
402         }
403                 
404         uint256 tokensForDevelopment = amount.mul(devFee).div(100);
405         if(tokensForDevelopment > 0) {
406             _transferStandard(sender, address(this), tokensForDevelopment);
407         }
408             
409         return amount -= tokensForDevelopment;
410     }
411 
412     receive() external payable {}
413 
414     function manualswap() public onlyOwner() {
415         uint256 contractBalance = balanceOf(address(this));
416         swapTokensForEth(contractBalance);
417     }
418     
419     
420     function withdrawStuckETH() external onlyOwner {
421         bool success;
422         (success,) = address(msg.sender).call{value: address(this).balance}("");
423     }
424 }