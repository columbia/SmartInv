1 /*
2 
3 Telegram:  https://t.me/Crypt0Punk9998
4 Twitter:  https://twitter.com/Crypt0Punk9998
5 Website:  https://cryptopunk9998.org/
6 
7 */
8 // SPDX-License-Identifier: Unlicensed
9 
10 pragma solidity ^0.8.4;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69     address private _previousOwner;
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92 }  
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract Crypto9998 is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _tOwned;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private bots;
124     mapping (address => uint) private cooldown;
125     uint256 private time;
126     uint256 private _tax;
127 
128     uint256 private constant _tTotal = 12445707 * 10**7;
129     uint256 private fee1=250;
130     uint256 private fee2=450;
131     uint256 private feeMax=1000;
132     string private constant _name = "CRYPTOPUNK 9998";
133     string private constant _symbol = "9998";
134     uint256 private _maxTxAmount = _tTotal.mul(2).div(100);
135     uint256 private minBalance = _tTotal.div(1000);
136 
137 
138     uint8 private constant _decimals = 9;
139     address payable private _feeAddrWallet1;
140     IUniswapV2Router02 private uniswapV2Router;
141     address private uniswapV2Pair;
142     bool private tradingOpen;
143     bool private inSwap = false;
144     bool private swapEnabled = false;
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150     constructor () payable {
151         _feeAddrWallet1 = payable(msg.sender);
152         _tOwned[address(this)] = _tTotal.div(10000).mul(8811);
153         _tOwned[msg.sender] = _tTotal.div(10000).mul(420);
154         _tOwned[0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB] = _tTotal.div(10000).mul(69);
155         _tOwned[0x3CA742472C927b6c73C1Ab8512e562B2e2f2beB2] = _tTotal.div(10000).mul(100);
156         _tOwned[0x61734A78f272D3A9acE38bee0A74B003CcAD000B] = _tTotal.div(10000).mul(100);
157         _tOwned[0xA9B8De3b7E9EBaaD6081B035F61c8644CAAbD099] = _tTotal.div(10000).mul(100);
158         _tOwned[0x24675A0A4EAD5fC06cF4B1cBd8DbEb0cB27BCD9d] = _tTotal.div(10000).mul(100);
159         _tOwned[0x2B5Acf586452f9879a1b71670ceAf1B676c8254c] = _tTotal.div(10000).mul(100);
160         _tOwned[0x0E42D4FbcFD0e3BAba777D0F8150083C35d89998] = _tTotal.div(10000).mul(200);
161 
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_feeAddrWallet1] = true;
165         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
166         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
167 
168         emit Transfer(0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,address(this),_tTotal.div(10000).mul(8811));
169         emit Transfer(0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,address(msg.sender),_tTotal.div(10000).mul(420));
170         emit Transfer(0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,_tTotal.div(10000).mul(69));
171         emit Transfer(0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,0x3CA742472C927b6c73C1Ab8512e562B2e2f2beB2,_tTotal.div(10000).mul(100));
172         emit Transfer(0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,0x61734A78f272D3A9acE38bee0A74B003CcAD000B,_tTotal.div(10000).mul(100));
173         emit Transfer(0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,0xA9B8De3b7E9EBaaD6081B035F61c8644CAAbD099,_tTotal.div(10000).mul(100));
174         emit Transfer(0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,0x24675A0A4EAD5fC06cF4B1cBd8DbEb0cB27BCD9d,_tTotal.div(10000).mul(100));
175         emit Transfer(0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,0x2B5Acf586452f9879a1b71670ceAf1B676c8254c,_tTotal.div(10000).mul(100));
176         emit Transfer(0xef764BAC8a438E7E498c2E5fcCf0f174c3E3F8dB,0x0E42D4FbcFD0e3BAba777D0F8150083C35d89998,_tTotal.div(10000).mul(200));
177 
178 
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
221     function changeFees(uint16 _fee1,uint16 _fee2) external {
222         
223         require(_msgSender() == _feeAddrWallet1);
224         require(_fee1 <= feeMax && _fee2 <= feeMax,"Cannot set fees above maximum");
225         fee1 = _fee1;
226         fee2 = _fee2;
227     }
228 
229     function changeMinBalance(uint256 newMin) external {
230         require(_msgSender() == _feeAddrWallet1);
231         minBalance = newMin;
232 
233     }
234    
235     function _approve(address owner, address spender, uint256 amount) private {
236         require(owner != address(0), "ERC20: approve from the zero address");
237         require(spender != address(0), "ERC20: approve to the zero address");
238         _allowances[owner][spender] = amount;
239         emit Approval(owner, spender, amount);
240     }
241 
242     function _transfer(address from, address to, uint256 amount) private {
243         require(from != address(0), "ERC20: transfer from the zero address");
244         require(to != address(0), "ERC20: transfer to the zero address");
245         require(amount > 0, "Transfer amount must be greater than zero");
246 
247         _tax = fee1;
248         if (from != owner() && to != owner()) {
249             require(!bots[from] && !bots[to]);
250             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && (block.timestamp < time)){
251                 // Cooldown
252                 require(amount <= _maxTxAmount);
253                 require(cooldown[to] < block.timestamp);
254                 cooldown[to] = block.timestamp + (30 seconds);
255             }
256             
257             if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from]) {
258                 require(block.timestamp > time,"Sells prohibited for the first 5 minutes");
259                 uint256 contractTokenBalance = balanceOf(address(this));
260                 if(contractTokenBalance > minBalance){
261                     swapTokensForEth(contractTokenBalance);
262                     uint256 contractETHBalance = address(this).balance;
263                     if(contractETHBalance > 0) {
264                         sendETHToFee(address(this).balance);
265                     }
266                 }
267             }
268         }
269         if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
270             _tax = fee2;
271         }
272         _transferStandard(from,to,amount);
273     }
274 
275     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
276         address[] memory path = new address[](2);
277         path[0] = address(this);
278         path[1] = uniswapV2Router.WETH();
279         _approve(address(this), address(uniswapV2Router), tokenAmount);
280         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
281             tokenAmount,
282             0,
283             path,
284             address(this),
285             block.timestamp
286         );
287     }
288 
289     function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
290         _approve(address(this),address(uniswapV2Router),tokenAmount);
291         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
292     }
293     
294     function sendETHToFee(uint256 amount) private {
295         _feeAddrWallet1.transfer(amount);
296     }
297     
298     function openTrading() external onlyOwner() {
299         require(!tradingOpen,"trading is already open");
300         addLiquidity(balanceOf(address(this)),address(this).balance,owner());
301         swapEnabled = true;
302         tradingOpen = true;
303         time = block.timestamp + (5 minutes);
304     }
305     
306     function setBots(address[] memory bots_) public onlyOwner {
307         for (uint i = 0; i < bots_.length; i++) {
308             bots[bots_[i]] = true;
309         }
310     }
311     
312     function delBot(address notbot) public onlyOwner {
313         bots[notbot] = false;
314     }
315 
316     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
317         (uint256 transferAmount,uint256 tfee) = _getTValues(tAmount);
318         _tOwned[sender] = _tOwned[sender].sub(tAmount);
319         _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
320         _tOwned[address(this)] = _tOwned[address(this)].add(tfee);
321         emit Transfer(sender, recipient, transferAmount);
322     }
323 
324     receive() external payable {}
325     
326     function manualswap() external {
327         require(_msgSender() == _feeAddrWallet1);
328         uint256 contractBalance = balanceOf(address(this));
329         swapTokensForEth(contractBalance);
330     }
331     
332     function manualsend() external {
333         require(_msgSender() == _feeAddrWallet1);
334         uint256 contractETHBalance = address(this).balance;
335         sendETHToFee(contractETHBalance);
336     }
337    
338     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
339         uint256 tFee = tAmount.mul(_tax).div(1000);
340         uint256 tTransferAmount = tAmount.sub(tFee);
341         return (tTransferAmount, tFee);
342     }
343 
344     function recoverTokens(address tokenAddress) external {
345         require(_msgSender() == _feeAddrWallet1);
346         IERC20 recoveryToken = IERC20(tokenAddress);
347         recoveryToken.transfer(_feeAddrWallet1,recoveryToken.balanceOf(address(this)));
348     }
349 }