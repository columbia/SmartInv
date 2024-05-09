1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.4;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
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
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     address private _previousOwner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64 
65     constructor () {
66         address msgSender = _msgSender();
67         _owner = msgSender;
68         emit OwnershipTransferred(address(0), msgSender);
69     }
70 
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     modifier onlyOwner() {
76         require(_owner == _msgSender(), "Ownable: caller is not the owner");
77         _;
78     }
79 
80     function transferOwnership(address _newOwner) public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, _newOwner);
82         _owner = _newOwner;
83         
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91 }  
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function swapExactETHForTokensSupportingFeeOnTransferTokens(
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external payable;
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
123 
124 contract DOHAN is Context, IERC20, Ownable {
125     using SafeMath for uint256;
126     mapping (address => uint256) private _tOwned;
127     mapping (address => mapping (address => uint256)) private _allowances;
128     mapping (address => bool) private _isExcludedFromFee;
129     mapping (address => bool) private bots;
130     mapping (address => uint) private cooldown;
131     uint256 private time;
132     uint256 private _tax;
133 
134     uint256 private constant _tTotal = 1 * 10**9 * 10**9;
135     uint256 private fee1=160;
136     uint256 private fee2=460;
137     uint256 private taikaBuyFee=50;
138     string private constant _name = "Yakedo";
139     string private constant _symbol = "Dohan";
140     uint256 private _maxTxAmount = _tTotal.div(100);
141     uint256 private _maxWalletAmount = _tTotal.div(50);
142     uint256 private minBalance = _tTotal.div(1000);
143 
144 
145     uint8 private constant _decimals = 9;
146     address payable private _deployer;
147     address payable private _feeWallet;
148     address payable private _feeWallet2;
149     address payable private _feeWallet3;
150     address payable private _feeWallet4;
151     address[3] taikaHolders = [
152         0x447c1604043B88aaB28be1479875ff499FCC4075,
153         0x3cbAE37583B013Bf5917C530321D4c16EfAe57b7,
154         0x0c1B7cB060705355f67026B3B63DF882abD1C738
155     ];
156     address[7] taikaHolders2 = [
157         0xADC28A4464a39CbDa8f6f6a1c9499168C8DC6829,
158         0xb3f24834C5a1BfE30efA51556A468298d95df14A,
159         0x69b6aBb47c9A9f4a741Bde0E31fEE7E1B3E3c73A,
160         0x21650f255eca111E52Af5974A053F6f61714e6a9,
161         0x1d5c2123C9e20821B2eb3D2f1FcC90607C6A5CC4,
162         0x289Aa48798649b398150A2C5E92Cece34FA75DaF,
163         0x3C8cbD613857965267bcd4bdEC7b794Dd53969A0
164     ];
165     IUniswapV2Router02 private uniswapV2Router;
166     address private uniswapV2Pair;
167     bool private taikaBurn = true;
168     bool private tradingOpen;
169     bool private inSwap = false;
170     bool private swapEnabled = false;
171     modifier lockTheSwap {
172         inSwap = true;
173         _;
174         inSwap = false;
175     }
176     constructor () payable {
177         _deployer = payable(msg.sender);
178         _feeWallet = payable(0x84c18d2E33dA25081949aFD6eDAdaa49A95197f6);
179         _feeWallet2 = payable(0xec55fBf0191e2eEC42d66b6CC5484125567251B7);
180         _feeWallet3 = payable(0xD13d749fAB0Bc3637c4f94bf4E11C2290FC9D4d9);
181         _feeWallet4 = payable(0x9b37b0A06A274Fe8E9e3C0FC0085f33BB344a4cA);
182         _tOwned[address(this)] = _tTotal;
183         _tOwned[address(0x84c18d2E33dA25081949aFD6eDAdaa49A95197f6)] = _tTotal.div(100).mul(7);
184         _tOwned[address(0xAE74b0f09cAFDC770e9a127464c7B8983a57804c)] = _tTotal.div(100).mul(4);
185         _tOwned[address(0x5Dd953d76a3F4688C8B64397bd3aDE8bC05BBc6E)] = _tTotal.div(100).mul(3);
186         _tOwned[address(0xDB6A1E020F85b295dAe895af8f02b0784F3613e6)] = _tTotal.div(100);
187         _tOwned[address(0x0BCDe6e69Fe6B30D253902F20e59055befdb4a07)] = _tTotal.div(100);
188         _tOwned[address(0x4220432E6963cc72Bdb575eC1e86662B55b8BA21)] = _tTotal.div(100);
189         for (uint i=0;i<3;i++) {
190             _tOwned[taikaHolders[i]] = _tTotal.div(100);
191         }
192         for (uint i=0;i<7;i++) {
193             _tOwned[taikaHolders2[i]] = _tTotal.div(200);
194         }
195         _isExcludedFromFee[owner()] = true;
196         _isExcludedFromFee[address(this)] = true;
197         _isExcludedFromFee[_deployer] = true;
198         _isExcludedFromFee[uniswapV2Pair] = true;
199         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
200         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
201 
202         emit Transfer(address(0),address(this),_tTotal);
203     }
204 
205     function name() public pure returns (string memory) {
206         return _name;
207     }
208 
209     function symbol() public pure returns (string memory) {
210         return _symbol;
211     }
212 
213     function decimals() public pure returns (uint8) {
214         return _decimals;
215     }
216 
217     function totalSupply() public pure override returns (uint256) {
218         return _tTotal;
219     }
220 
221     function balanceOf(address account) public view override returns (uint256) {
222         return _tOwned[account];
223     }
224 
225     function transfer(address recipient, uint256 amount) public override returns (bool) {
226         _transfer(_msgSender(), recipient, amount);
227         return true;
228     }
229 
230     function allowance(address owner, address spender) public view override returns (uint256) {
231         return _allowances[owner][spender];
232     }
233 
234     function approve(address spender, uint256 amount) public override returns (bool) {
235         _approve(_msgSender(), spender, amount);
236         return true;
237     }
238 
239     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
240         _transfer(sender, recipient, amount);
241         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
242         return true;
243     }
244    
245     function taikaSwitch() external {
246         require(_msgSender() == _deployer);
247         taikaBurn = !taikaBurn;
248     }
249 
250     function changeMinBalance(uint256 newMin) external {
251         require(_msgSender() == _deployer);
252         minBalance = newMin;
253 
254     }
255 
256     function editFees(uint256 _fee1, uint256 _fee2, uint256 _liq) external {
257         require(_msgSender() == _deployer);
258         require(_fee1 <= 100 && _fee2 <= 100 && _liq <= 100,"fees cannot be higher than 10%");
259         fee1 = _fee1;
260         fee2 = _fee2;
261         taikaBuyFee = _liq;
262     }
263 
264     function removeLimits() external {
265         require(_msgSender() == _deployer);
266         _maxTxAmount = _tTotal;
267         _maxWalletAmount = _tTotal;
268     }
269 
270     function excludeFromFees(address target) external {
271         require(_msgSender() == _deployer);
272         _isExcludedFromFee[target] = true;
273     }
274 
275    
276     function _approve(address owner, address spender, uint256 amount) private {
277         require(owner != address(0), "ERC20: approve from the zero address");
278         require(spender != address(0), "ERC20: approve to the zero address");
279         _allowances[owner][spender] = amount;
280         emit Approval(owner, spender, amount);
281     }
282 
283     function _transfer(address from, address to, uint256 amount) private {
284         require(from != address(0), "ERC20: transfer from the zero address");
285         require(to != address(0), "ERC20: transfer to the zero address");
286         require(amount > 0, "Transfer amount must be greater than zero");
287         if (to != uniswapV2Pair) {
288             require((_tOwned[to] + amount) <= _maxWalletAmount,"too many tokens scumbag");
289         }
290         _tax = fee1.add(taikaBuyFee);
291         if (from != owner() && to != owner()) {
292             require(!bots[from] && !bots[to]);
293             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && (block.timestamp < time)){
294                 // Cooldown
295                 require(amount <= _maxTxAmount);
296                 require(cooldown[to] < block.timestamp);
297                 cooldown[to] = block.timestamp + (30 seconds);
298             }
299             
300             
301             if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from]) {
302                 require(block.timestamp > time,"Sells prohibited for the first 5 minutes");
303                 uint256 contractTokenBalance = balanceOf(address(this));
304                 if(contractTokenBalance > minBalance){
305                     swapTokensForEth(contractTokenBalance);
306                     uint256 contractETHBalance = address(this).balance;
307                     if(contractETHBalance > 0) {
308                         if(taikaBurn) {
309                             swapEthForTaikaAndBurn(contractETHBalance);
310                         }
311                         sendETHToFee(address(this).balance);
312                     }
313                 }
314             }
315         }
316         if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
317             _tax = fee2.add(taikaBuyFee);
318         }		
319         _transferStandard(from,to,amount);
320     }
321 
322     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
323         address[] memory path = new address[](2);
324         path[0] = address(this);
325         path[1] = uniswapV2Router.WETH();
326         _approve(address(this), address(uniswapV2Router), tokenAmount);
327         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
328             tokenAmount,
329             0,
330             path,
331             address(this),
332             block.timestamp
333         );
334     }
335 
336     function swapEthForTaikaAndBurn(uint256 ethAmount) private {
337         uint256 buyAmount = ethAmount.div(10).mul(2);
338         address [] memory path = new address[](2);
339         path[0] = uniswapV2Router.WETH();
340         path[1] = address(0x072d419f64e3F5CbdcA897004f0cA8F46Dc7c546);
341         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: buyAmount}(
342             0,
343             path,
344             address(0xdead),
345             block.timestamp
346         );
347     }
348     
349 
350     function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
351         _approve(address(this),address(uniswapV2Router),tokenAmount);
352         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
353     }
354 
355     
356     function sendETHToFee(uint256 amount) private {
357         _feeWallet4.transfer(amount.div(4));
358         _feeWallet.transfer(amount.div(4));
359         _feeWallet2.transfer(amount.div(4));
360         _feeWallet3.transfer(amount.div(4));
361     }
362     
363     function openTrading() external onlyOwner() {
364         require(!tradingOpen,"trading is already open");
365         addLiquidity(balanceOf(address(this)),address(this).balance,owner());
366         swapEnabled = true;
367         tradingOpen = true;
368         time = block.timestamp + (3 minutes);
369     }
370     
371     function setBots(address[] memory bots_) public onlyOwner {
372         for (uint i = 0; i < bots_.length; i++) {
373             bots[bots_[i]] = true;
374         }
375     }
376     
377     function delBot(address notbot) public onlyOwner {
378         bots[notbot] = false;
379     }
380 
381     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
382         (uint256 transferAmount,uint256 tfee) = _getTValues(tAmount);
383         _tOwned[sender] = _tOwned[sender].sub(tAmount);
384         _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
385         _tOwned[address(this)] = _tOwned[address(this)].add(tfee);
386         emit Transfer(sender, recipient, transferAmount);
387     }
388 
389     receive() external payable {}
390     
391     function manualswap() external {
392         require(_msgSender() == _deployer);
393         uint256 contractBalance = balanceOf(address(this));
394         swapTokensForEth(contractBalance);
395     }
396     
397     function manualsend() external {
398         require(_msgSender() == _deployer);
399         uint256 contractETHBalance = address(this).balance;
400         sendETHToFee(contractETHBalance);
401     }
402    
403     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
404         uint256 tFee = tAmount.mul(_tax).div(1000);
405         uint256 tTransferAmount = tAmount.sub(tFee);
406         return (tTransferAmount, tFee);
407     }
408 
409     function recoverTokens(address tokenAddress) external {
410         require(_msgSender() == _deployer);
411         IERC20 recoveryToken = IERC20(tokenAddress);
412         recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this)));
413     }
414 }