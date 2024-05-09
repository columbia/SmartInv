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
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85 }  
86 
87 interface IUniswapV2Factory {
88     function createPair(address tokenA, address tokenB) external returns (address pair);
89 }
90 
91 interface IUniswapV2Router02 {
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99     function factory() external pure returns (address);
100     function WETH() external pure returns (address);
101     function addLiquidityETH(
102         address token,
103         uint amountTokenDesired,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
109 }
110 
111 contract discoInferno is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _tOwned;
114     mapping (address => mapping (address => uint256)) private _allowances;
115     mapping (address => bool) private _isExcludedFromFee;
116     mapping (address => bool) private bots;
117     mapping (address => uint) private cooldown;
118     uint256 private time;
119     uint256 private _tax;
120 
121     uint256 private _tTotal = 5 * 10**7 * 10**9;
122     uint256 private tokensBurned;
123     uint256 private fee1=25;
124     uint256 private fee2=175;
125     uint256 private burnFee=25;
126     uint256 private feeMax=200;
127     string private constant _name = "Disco Inferno";
128     string private constant _symbol = "INFERNO";
129     uint256 private minBalance = _tTotal.div(1000);
130     uint256 private maxTxAmount = _tTotal.div(100);
131     uint256 private maxWalletAmount = _tTotal.div(50);
132 
133 
134     uint8 private constant _decimals = 9;
135     uint256 private constant decimalsConvert = 10 ** 9;
136     address payable private _deployer;
137     address payable private _feeAddrWallet2;
138     address payable private _feeAddrWallet3;
139     address payable private _feeAddrWallet4;
140     address payable private _scorcher;
141     address[5] influencoors1 = [
142     0xB8A7A62C1162600233f1E842E7E9969A88EA2B12,
143     0xd0D613F34d190488506452FDE666763959d83930,
144     0xC3de8202E5B78ac60C5DFCbA34454965C823e9A2,
145     0xd0D613F34d190488506452FDE666763959d83930,
146     0xa73fcDc701bFFd18Bf805da79B30ED3671beaBc1];
147     address[3] influencoors2 = [
148     0x7c82094FD1E48c12b3679487abB1aFBBC3325170,
149     0xb983A5443f3DA1110E900112033e3b9643a2C2Ce,
150     0x606263810359D53E2514eb67fDb30282bBce808A];
151     IUniswapV2Router02 private uniswapV2Router;
152     address private uniswapV2Pair;
153     bool private tradingOpen;
154     bool private inSwap = false;
155     bool private swapEnabled = false;
156     modifier lockTheSwap {
157         inSwap = true;
158         _;
159         inSwap = false;
160     }
161     constructor () payable {
162         _deployer = payable(msg.sender);
163         _feeAddrWallet2 = payable(0x69e282287e6D50E461ad8877c02094066cd441F6);
164         _feeAddrWallet3 = payable(0x41D081c9DDE1352A228A6EC2AD0dA334ce94fb71);
165         _feeAddrWallet4 = payable(0x688593bbbFC8b29D2f4e17031e164e6C30c1a8DA);
166         _scorcher = payable(0x9590d8C06BA451bbaD0893F2eF0D2A8B5AcC67d3);
167         _tOwned[address(this)] = _tTotal;
168         for (uint i=0;i<5;i++) {
169             _tOwned[influencoors1[i]] = _tTotal.div(200);
170         }
171         for (uint i=0;i<3;i++) {
172             _tOwned[influencoors2[i]] = _tTotal.div(50);
173         }        
174         _isExcludedFromFee[owner()] = true;
175         _isExcludedFromFee[address(this)] = true;
176         _isExcludedFromFee[_deployer] = true;
177         _isExcludedFromFee[influencoors2[2]] = true;
178         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
179         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
180 
181         emit Transfer(address(0),address(this),_tTotal);  
182     }
183 
184     function name() public pure returns (string memory) {
185         return _name;
186     }
187 
188     function symbol() public pure returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public pure returns (uint8) {
193         return _decimals;
194     }
195 
196     function totalSupply() public view override returns (uint256) {
197         return _tTotal;
198     }
199 
200     function balanceOf(address account) public view override returns (uint256) {
201         return _tOwned[account];
202     }
203 
204     function transfer(address recipient, uint256 amount) public override returns (bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     function allowance(address owner, address spender) public view override returns (uint256) {
210         return _allowances[owner][spender];
211     }
212 
213     function excludeFromFees(address target) external {
214         require(_msgSender() == _deployer);
215         _isExcludedFromFee[target] = true;
216     }
217 
218     function howManyBurned() public view returns (uint256) {
219         return tokensBurned;
220     }
221 
222     function approve(address spender, uint256 amount) public override returns (bool) {
223         _approve(_msgSender(), spender, amount);
224         return true;
225     }
226 
227     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
228         _transfer(sender, recipient, amount);
229         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
230         return true;
231     }
232 
233     function burn(address account,uint256 amount) private {
234         _tOwned[account] = _tOwned[account].sub(amount);
235         _tTotal -= amount;
236         tokensBurned += amount;
237         emit Transfer(account, address(0), amount);
238     }
239 
240     function removeLimits() external {
241         require(_msgSender() == _deployer);
242         maxTxAmount = _tTotal;
243         maxWalletAmount = _tTotal;
244     }
245    
246     function changeFees(uint8 _fee1,uint8 _fee2,uint8 _burny) external { 
247         require(_msgSender() == _deployer);
248         require(_fee1 <= feeMax && _fee2 <= feeMax && _burny <= feeMax,"Cannot set fees above maximum (10%)");
249         fee1 = _fee1;
250         fee2 = _fee2;
251         burnFee = _burny;
252     }
253 
254 
255     function changeMinBalance(uint256 newMin) external {
256         require(_msgSender() == _deployer);
257         minBalance = newMin;
258 
259     }
260    
261     function _approve(address owner, address spender, uint256 amount) private {
262         require(owner != address(0), "ERC20: approve from the zero address");
263         require(spender != address(0), "ERC20: approve to the zero address");
264         _allowances[owner][spender] = amount;
265         emit Approval(owner, spender, amount);
266     }
267 
268     function _transfer(address from, address to, uint256 amount) private {
269         require(from != address(0), "ERC20: transfer from the zero address");
270         require(to != address(0), "ERC20: transfer to the zero address");
271         require(amount > 0, "Transfer amount must be greater than zero");
272         _tax = fee1.add(burnFee);
273         if (from != owner() && to != owner()) {
274             require(!bots[from] && !bots[to]);
275             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && (block.timestamp < time)){
276                 require(amount <= maxTxAmount,"negative ghost rider");
277                 require(_tOwned[to] <= maxWalletAmount,"not a chance bub");
278                 // Cooldown
279                 require(cooldown[to] < block.timestamp);
280                 cooldown[to] = block.timestamp + (30 seconds);
281             }
282             
283             
284             if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from]) {
285                 uint256 contractTokenBalance = balanceOf(address(this));
286                 if(contractTokenBalance > minBalance){
287                     swapTokensForEth(contractTokenBalance);
288                     uint256 contractETHBalance = address(this).balance;
289                     if(contractETHBalance > 0) {
290                         sendETHToFee(address(this).balance);
291                     }
292                 }
293             }
294         }
295         if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
296             _tax = fee2.add(burnFee);
297         }
298 		
299         _transferStandard(from,to,amount);
300     }
301 
302     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
303         address[] memory path = new address[](2);
304         path[0] = address(this);
305         path[1] = uniswapV2Router.WETH();
306         _approve(address(this), address(uniswapV2Router), tokenAmount);
307         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
308             tokenAmount,
309             0,
310             path,
311             address(this),
312             block.timestamp
313         );
314     }
315   
316     function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
317         _approve(address(this),address(uniswapV2Router),tokenAmount);
318         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
319     }
320     function sendETHToFee(uint256 amount) private {
321          _deployer.transfer(amount.div(100).mul(35));
322         _feeAddrWallet2.transfer(amount.div(100).mul(20));
323         _feeAddrWallet3.transfer(amount.div(100).mul(20));
324         _feeAddrWallet4.transfer(amount.div(100).mul(10));
325         _scorcher.transfer(amount.div(100).mul(15));
326     }
327     
328     function openTrading() external onlyOwner() {
329         require(!tradingOpen,"trading is already open");
330         addLiquidity(balanceOf(address(this)),address(this).balance,owner());
331         swapEnabled = true;
332         tradingOpen = true;
333         time = block.timestamp + (5 minutes);
334     }
335     
336     function setBots(address[] memory bots_) public onlyOwner {
337         for (uint i = 0; i < bots_.length; i++) {
338             bots[bots_[i]] = true;
339         }
340     }
341 
342     function delBot(address notbot) public onlyOwner {
343         bots[notbot] = false;
344     }
345 
346     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
347         (uint256 transferAmount,uint256 burnAmount,uint256 feeNoBurn,uint256 amountNoBurn) = _getTValues(tAmount);
348         _tOwned[sender] = _tOwned[sender].sub(amountNoBurn);
349         _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
350         _tOwned[address(this)] = _tOwned[address(this)].add(feeNoBurn);
351         burn(sender,burnAmount);
352         emit Transfer(sender, recipient, transferAmount);
353     }
354 
355     receive() external payable {}
356     
357     function manualswap() external {
358         require(_msgSender() == _deployer);
359         uint256 contractBalance = balanceOf(address(this));
360         swapTokensForEth(contractBalance);
361     }
362     
363     function manualsend() external {
364         require(_msgSender() == _deployer);
365         uint256 contractETHBalance = address(this).balance;
366         sendETHToFee(contractETHBalance);
367     }
368    
369     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
370         uint256 tFee = tAmount.mul(_tax).div(1000);
371         uint256 tTransferAmount = tAmount.sub(tFee);
372         uint256 tBurn = tAmount.mul(burnFee).div(1000);
373         uint256 tFeeNoBurn = tFee.sub(tBurn);
374         uint256 tAmountNoBurn = tAmount.sub(tBurn);
375         return (tTransferAmount, tBurn, tFeeNoBurn, tAmountNoBurn);
376     }
377 
378     function recoverTokens(address tokenAddress) external {
379         require(_msgSender() == _deployer);
380         IERC20 recoveryToken = IERC20(tokenAddress);
381         recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this)));
382     }
383 }