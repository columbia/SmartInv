1 //Welcome to a true DeFi casino experience!
2 
3 //TG: https://t.me/allinmain
4 //Website: https://allincryptocasino.com
5 //Discord: https://discord.gg/H5aw5zEvUu
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity ^0.8.7;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 library SafeMath {
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         require(c >= a, "SafeMath: addition overflow");
32         return c;
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         return sub(a, b, "SafeMath: subtraction overflow");
37     }
38 
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44 
45     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46         if (a == 0) {
47             return 0;
48         }
49         uint256 c = a * b;
50         require(c / a == b, "SafeMath: multiplication overflow");
51         return c;
52     }
53 
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57 
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 
64 }
65 
66 contract Ownable is Context {
67     address private _owner;
68     address private _previousOwner;
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor () {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function transferOwnership(address _newOwner) public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, _newOwner);
88         _owner = _newOwner;
89         
90     }
91 
92     function renounceOwnership() public virtual onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97 }  
98 
99 interface IUniswapV2Factory {
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101 }
102 
103 interface IUniswapV2Router02 {
104     function swapExactTokensForETHSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111     function factory() external pure returns (address);
112     function WETH() external pure returns (address);
113     function addLiquidityETH(
114         address token,
115         uint amountTokenDesired,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
121 }
122 
123 contract ALLIN is Context, IERC20, Ownable {
124     using SafeMath for uint256;
125     mapping (address => uint256) private _tOwned;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping (address => bool) private bots;
129     mapping (address => uint) private cooldown;
130     uint256 private _tax;
131     uint256 private time;
132 
133     uint256 private constant _tTotal = 1 * 10 ** 9 * 10**9;
134     uint256 private fee1=50;
135     uint256 private fee2=50;
136     uint256 private pc1 = 29;
137     uint256 private pc2 = 22;
138     uint256 private pc3 = 22;
139     uint256 private pc4 = 21;
140     uint256 private pc5 = 5;
141     uint256 private pc6 = 1;
142     string private constant _name = unicode"All In Coin";
143     string private constant _symbol = unicode"ALLIN";
144     uint256 private _maxTxAmount = _tTotal.div(100);
145     uint256 private _maxWalletAmount = _tTotal.div(50);
146     uint256 private minBalance = _tTotal.div(1000);
147     uint256 private maxCaSell = _tTotal.div(300);
148     uint8 private constant _decimals = 9;
149     address payable private _deployer;
150     address payable private _marketingWallet;
151     address payable private _feeWallet2;
152     address payable private _feeWallet3;
153     address payable private _feeWallet4;
154     address payable private _withdrawalWallet;
155     address private depositContract;
156     IUniswapV2Router02 private uniswapV2Router;
157     address private uniswapV2Pair;
158     bool private tradingOpen;
159     bool private inSwap = false;
160     bool private swapEnabled = false;
161     bool private limitsEnabled = true;
162     bool private allowBlacklist = true;
163     modifier lockTheSwap {
164         inSwap = true;
165         _;
166         inSwap = false;
167     }
168     constructor () payable {
169         _deployer = payable(msg.sender);
170         _marketingWallet = payable(0xB1cf86B9258B8a7f6888D0Bd92045b33Db90CA77);
171         _feeWallet2 = payable(0xDDa1aa0c5b9c8b90f2FCec4A7BF16FC675739f0D);
172         _feeWallet3 = payable(0xD24434C40E1c08d8b70F0B363E3B54Cff71243A0);
173         _feeWallet4 = payable(0xeDF647837b955d1A0BA0Baa9183E9aAaa83C9A92);
174         _withdrawalWallet = payable(0xD851cC237c245D49726ea6c34Bd3eB7Cda56bc1e);
175         _tOwned[address(this)] = _tTotal.div(100).mul(55);
176         _tOwned[_deployer] = _tTotal.div(100).mul(45);
177         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
178         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
179         _isExcludedFromFee[owner()] = true;
180         _isExcludedFromFee[address(this)] = true;
181         _isExcludedFromFee[_deployer] = true;
182         _isExcludedFromFee[depositContract] = true;
183 
184         emit Transfer(address(0),address(this),_tTotal.div(100).mul(55));
185         emit Transfer(address(0),_deployer,_tTotal.div(100).mul(45));
186     }
187 
188     function name() public pure returns (string memory) {
189         return _name;
190     }
191 
192     function symbol() public pure returns (string memory) {
193         return _symbol;
194     }
195 
196     function decimals() public pure returns (uint8) {
197         return _decimals;
198     }
199 
200     function totalSupply() public pure override returns (uint256) {
201         return _tTotal;
202     }
203 
204     function balanceOf(address account) public view override returns (uint256) {
205         return _tOwned[account];
206     }
207 
208     function transfer(address recipient, uint256 amount) public override returns (bool) {
209         _transfer(_msgSender(), recipient, amount);
210         return true;
211     }
212 
213     function allowance(address owner, address spender) public view override returns (uint256) {
214         return _allowances[owner][spender];
215     }
216 
217     function approve(address spender, uint256 amount) public override returns (bool) {
218         _approve(_msgSender(), spender, amount);
219         return true;
220     }
221 
222     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
223         _transfer(sender, recipient, amount);
224         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
225         return true;
226     }
227 
228    
229     function changeMinBalance(uint256 newMin) public onlyOwner {
230         minBalance = newMin;
231 
232     }
233 
234     function editFees(uint256 one, uint256 two) public onlyOwner {
235         require(one <= 50 && two <= 50,"Fees have to smaller than or equal to 5%");
236         fee1 = one;
237         fee2 = two;
238     }
239 
240     function removeLimits() public onlyOwner {
241         limitsEnabled = false;
242     }
243 
244     function changePercentages(uint256 nPc1, uint256 nPc2, uint256 nPc3, uint256 nPc4, uint256 nPc5, uint256 nPc6) public onlyOwner {
245         require(nPc1 + nPc2 + nPc3 + nPc4 + nPc5 + nPc6 == 100,"Percentages have to add up to 100");
246         pc1 = nPc1;
247         pc2 = nPc2;
248         pc3 = nPc3;
249         pc4 = nPc4;
250         pc5 = nPc5;
251         pc6 = nPc6;
252     }
253 
254     function setDepositAddress(address deposit) public onlyOwner {
255         depositContract = deposit;
256     }
257 
258 
259     function excludeFromFees(address target) public onlyOwner {
260         _isExcludedFromFee[target] = true;
261     }
262 
263     function disableBlacklist() public onlyOwner {
264         allowBlacklist = false;
265     }
266    
267     function _approve(address owner, address spender, uint256 amount) private {
268         require(owner != address(0), "ERC20: approve from the zero address");
269         require(spender != address(0), "ERC20: approve to the zero address");
270         _allowances[owner][spender] = amount;
271         emit Approval(owner, spender, amount);
272     }
273 
274     function _transfer(address from, address to, uint256 amount) private {
275         require(from != address(0), "ERC20: transfer from the zero address");
276         require(to != address(0), "ERC20: transfer to the zero address");
277         require(amount > 0, "Transfer amount must be greater than zero");
278 
279         _tax = 0;
280         if (from != _deployer && to != _deployer) {
281             require(!bots[from] && !bots[to]);
282             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && limitsEnabled){
283                 // Cooldown
284                 require((_tOwned[to] + amount) <= _maxWalletAmount,"Max wallet exceeded");
285                 require(amount <= _maxTxAmount);
286                 require(cooldown[to] < block.timestamp);
287                 cooldown[to] = block.timestamp + (30 seconds);
288             }
289             
290             
291             if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && from != depositContract) {
292                 require(block.timestamp > time,"tiny cooldown to blacklist bots");
293                 uint256 contractTokenBalance = balanceOf(address(this));
294                 if(contractTokenBalance > minBalance){
295                     if(contractTokenBalance > maxCaSell){
296                         contractTokenBalance = maxCaSell;
297                         if(contractTokenBalance > amount){
298                             contractTokenBalance = amount;
299                         }
300                     }
301                     swapTokensForEth(contractTokenBalance);
302                     uint256 contractETHBalance = address(this).balance;
303                     if(contractETHBalance > 0) {
304                         sendETHToFee(address(this).balance);
305                     }
306                 }
307             }
308         }
309         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
310             _tax = 0;
311         } else {
312 
313             //Set Fee for Buys
314             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
315                 _tax = fee1;
316             }
317 
318             //Set Fee for Sells
319             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
320                 _tax = fee2;
321             }
322 
323         }
324         if (to == depositContract || from == depositContract) {
325             _tax = 0;
326         }	
327         _transferStandard(from,to,amount);
328     }
329 
330     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
331         address[] memory path = new address[](2);
332         path[0] = address(this);
333         path[1] = uniswapV2Router.WETH();
334         _approve(address(this), address(uniswapV2Router), tokenAmount);
335         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
336             tokenAmount,
337             0,
338             path,
339             address(this),
340             block.timestamp
341         );
342     }
343     
344 
345     function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
346         _approve(address(this),address(uniswapV2Router),tokenAmount);
347         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
348     }
349 
350     
351     function sendETHToFee(uint256 amount) private {
352         _deployer.transfer(amount.mul(pc3).div(100));
353         _marketingWallet.transfer(amount.mul(pc2).div(100));
354         _feeWallet2.transfer(amount.mul(pc4).div(100));
355         _feeWallet3.transfer(amount.mul(pc5).div(100));
356         _feeWallet4.transfer(amount.mul(pc1).div(100));
357     }
358     
359     function openTrading() external onlyOwner() {
360         require(!tradingOpen,"trading is already open");
361         addLiquidity(balanceOf(address(this)),address(this).balance,owner());
362         fee1 = 100;
363         fee2 = 100;
364         swapEnabled = true;
365         tradingOpen = true;
366         limitsEnabled = true;
367         time = block.timestamp + (3 minutes);
368     }
369 
370 
371     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
372         (uint256 transferAmount,uint256 tfee) = _getTValues(tAmount);
373         _tOwned[sender] = _tOwned[sender].sub(tAmount);
374         _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
375         _tOwned[address(this)] = _tOwned[address(this)].add(tfee);
376         emit Transfer(sender, recipient, transferAmount);
377     }
378 
379     function setBots(address[] memory bots_) public onlyOwner {
380         require(allowBlacklist);
381         for (uint i = 0; i < bots_.length; i++) {
382             bots[bots_[i]] = true;
383         }
384     }
385     
386     function delBot(address[] memory notbots) public onlyOwner {
387         for (uint i = 0; i < notbots.length; i++) {
388             bots[notbots[i]] = false;
389         }
390     }
391 
392     receive() external payable {}
393     
394     function manualswap() external onlyOwner {
395         uint256 contractBalance = balanceOf(address(this));
396         swapTokensForEth(contractBalance);
397     }
398     
399     function manualsend() external onlyOwner {
400         uint256 contractETHBalance = address(this).balance;
401         sendETHToFee(contractETHBalance);
402     }
403    
404     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
405         uint256 tFee = tAmount.mul(_tax).div(1000);
406         uint256 tTransferAmount = tAmount.sub(tFee);
407         return (tTransferAmount, tFee);
408     }
409 
410     function recoverTokens(address tokenAddress) public onlyOwner {
411         IERC20 recoveryToken = IERC20(tokenAddress);
412         recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this)));
413     }
414 }