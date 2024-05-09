1 // TG: https://t.me/OfficialTaika
2 
3 // SPDX-License-Identifier: Unlicensed
4 
5 pragma solidity ^0.8.4;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
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
57         return c;
58     }
59 
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64     address private _previousOwner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor () {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function transferOwnership(address _newOwner) public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, _newOwner);
84         _owner = _newOwner;
85         
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }  
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract Taika is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _tOwned;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping (address => bool) private bots;
125     mapping (address => uint) private cooldown;
126     uint256 private time;
127     uint256 private _tax;
128 
129     uint256 private constant _tTotal = 1 * 10**9 * 10**9;
130     uint256 private fee1=40;
131     uint256 private fee2=60;
132     string private constant _name = "Yokoso Taika";
133     string private constant _symbol = "Taika";
134     uint256 private _maxTxAmount = _tTotal.div(100);
135     uint256 private _maxWalletAmount = _tTotal.div(50);
136     uint256 private minBalance = _tTotal.div(1000);
137 
138 
139     uint8 private constant _decimals = 9;
140     address payable private _deployer;
141     address payable private _feeWallet;
142     address[6] shillers = [
143         0xB8A7A62C1162600233f1E842E7E9969A88EA2B12,
144         0xd0D613F34d190488506452FDE666763959d83930,
145         0x470E3A08a40990563212B383866Cb3cB862FE6C7,
146         0x911F6179BAa9c413b76A0417902781E05F5b7539,
147         0x40B5b5273253908Da3ce71C730017fCB2CDbF467,
148         0xA5E1731517178CfAf396746cf055ff2229633632
149     ];
150     IUniswapV2Router02 private uniswapV2Router;
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private inSwap = false;
154     bool private swapEnabled = false;
155     modifier lockTheSwap {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160     constructor () payable {
161         _deployer = payable(msg.sender);
162         _feeWallet = payable(0xA425AB4e241B9e4cD63688C9F33EFCf3CeBBfaCd);
163         _tOwned[address(this)] = _tTotal;
164         _tOwned[address(0xA425AB4e241B9e4cD63688C9F33EFCf3CeBBfaCd)] = _tTotal.div(50);
165         _tOwned[address(0xa8a4038c96C5a4541859E5dE555A8646e9424053)] = _tTotal.div(50);
166         _tOwned[address(0x6906e343bA9F73E72E47885860CF8BA8375d9525)] = _tTotal.div(50);
167         _tOwned[address(0x2455Ca6E5F4EBae1a04135C58a6638327c9d2358)] = _tTotal.div(50);
168         for (uint i=0;i < 6; i++) {
169             _tOwned[shillers[i]] = _tTotal.div(200);
170         }
171         _isExcludedFromFee[owner()] = true;
172         _isExcludedFromFee[address(this)] = true;
173         _isExcludedFromFee[_deployer] = true;
174         _isExcludedFromFee[uniswapV2Pair] = true;
175         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
176         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
177 
178         emit Transfer(address(0),address(this),_tTotal);
179     }
180 
181     function name() public pure returns (string memory) {
182         return _name;
183     }
184 
185     function symbol() public pure returns (string memory) {
186         return _symbol;
187     }
188 
189     function decimals() public pure returns (uint8) {
190         return _decimals;
191     }
192 
193     function totalSupply() public pure override returns (uint256) {
194         return _tTotal;
195     }
196 
197     function balanceOf(address account) public view override returns (uint256) {
198         return _tOwned[account];
199     }
200 
201     function transfer(address recipient, uint256 amount) public override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view override returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 amount) public override returns (bool) {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
218         return true;
219     }
220    
221 
222     function changeMinBalance(uint256 newMin) external {
223         require(_msgSender() == _deployer);
224         minBalance = newMin;
225 
226     }
227 
228     function removeLimits() external {
229         require(_msgSender() == _deployer);
230         _maxTxAmount = _tTotal;
231         _maxWalletAmount = _tTotal;
232     }
233 
234     function excludeFromFees(address target) external {
235         require(_msgSender() == _deployer);
236         _isExcludedFromFee[target] = true;
237     }
238 
239    
240     function _approve(address owner, address spender, uint256 amount) private {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 
247     function _transfer(address from, address to, uint256 amount) private {
248         require(from != address(0), "ERC20: transfer from the zero address");
249         require(to != address(0), "ERC20: transfer to the zero address");
250         require(amount > 0, "Transfer amount must be greater than zero");
251 
252         _tax = fee1;
253         if (from != owner() && to != owner()) {
254             require(!bots[from] && !bots[to]);
255             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && (block.timestamp < time)){
256                 // Cooldown
257                 require((_tOwned[to] + amount) <= _maxWalletAmount,"not a chance bub");
258                 require(amount <= _maxTxAmount);
259                 require(cooldown[to] < block.timestamp);
260                 cooldown[to] = block.timestamp + (30 seconds);
261             }
262             
263             
264             if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from]) {
265                 require(block.timestamp > time,"Sells prohibited for the first 5 minutes");
266                 uint256 contractTokenBalance = balanceOf(address(this));
267                 if(contractTokenBalance > minBalance){
268                     swapTokensForEth(contractTokenBalance);
269                     uint256 contractETHBalance = address(this).balance;
270                     if(contractETHBalance > 0) {
271                         sendETHToFee(address(this).balance);
272                     }
273                 }
274             }
275         }
276         if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
277             _tax = fee2;
278         }		
279         _transferStandard(from,to,amount);
280     }
281 
282     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
283         address[] memory path = new address[](2);
284         path[0] = address(this);
285         path[1] = uniswapV2Router.WETH();
286         _approve(address(this), address(uniswapV2Router), tokenAmount);
287         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
288             tokenAmount,
289             0,
290             path,
291             address(this),
292             block.timestamp
293         );
294     }
295     
296 
297     function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
298         _approve(address(this),address(uniswapV2Router),tokenAmount);
299         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
300     }
301 
302     
303     function sendETHToFee(uint256 amount) private {
304         _deployer.transfer(amount.div(5).mul(3));
305         _feeWallet.transfer(amount.div(5).mul(2));
306     }
307     
308     function openTrading() external onlyOwner() {
309         require(!tradingOpen,"trading is already open");
310         addLiquidity(balanceOf(address(this)),address(this).balance,owner());
311         swapEnabled = true;
312         tradingOpen = true;
313         time = block.timestamp + (3 minutes);
314     }
315     
316     function setBots(address[] memory bots_) public onlyOwner {
317         for (uint i = 0; i < bots_.length; i++) {
318             bots[bots_[i]] = true;
319         }
320     }
321     
322     function delBot(address notbot) public onlyOwner {
323         bots[notbot] = false;
324     }
325 
326     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
327         (uint256 transferAmount,uint256 tfee) = _getTValues(tAmount);
328         _tOwned[sender] = _tOwned[sender].sub(tAmount);
329         _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
330         _tOwned[address(this)] = _tOwned[address(this)].add(tfee);
331         emit Transfer(sender, recipient, transferAmount);
332     }
333 
334     receive() external payable {}
335     
336     function manualswap() external {
337         require(_msgSender() == _deployer);
338         uint256 contractBalance = balanceOf(address(this));
339         swapTokensForEth(contractBalance);
340     }
341     
342     function manualsend() external {
343         require(_msgSender() == _deployer);
344         uint256 contractETHBalance = address(this).balance;
345         sendETHToFee(contractETHBalance);
346     }
347    
348     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
349         uint256 tFee = tAmount.mul(_tax).div(1000);
350         uint256 tTransferAmount = tAmount.sub(tFee);
351         return (tTransferAmount, tFee);
352     }
353 
354     function recoverTokens(address tokenAddress) external {
355         require(_msgSender() == _deployer);
356         IERC20 recoveryToken = IERC20(tokenAddress);
357         recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this)));
358     }
359 }