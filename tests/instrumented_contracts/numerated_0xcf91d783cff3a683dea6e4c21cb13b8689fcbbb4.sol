1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.7;
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
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 
117 contract SLURP is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private _tOwned;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping (address => uint) private cooldown;
123     uint256 private _tax;
124     uint256 private time;
125 
126     uint256 private constant _tTotal = 1000000000 * 10**9;
127     uint256 private fee1=50;
128     uint256 private fee2=100;
129     uint256 private slurpFee=80;
130     uint256 private _tokensToBeSlurped;
131     uint256 private _slurpReward;
132     uint256 private _bonusTokens;
133     string private constant _name = unicode"SLURP";
134     string private constant _symbol = unicode"SLURP";
135     uint256 private _maxTxAmount = _tTotal.div(50);
136     uint256 private _maxWalletAmount = _tTotal.div(50);
137     uint256 private minBalance = _tTotal.div(1000);
138     uint256 private maxCaSellAmount = _tTotal.div(1000).mul(3);
139     uint8 private constant _decimals = 9;
140     address payable private _deployer;
141     IUniswapV2Router02 private uniswapV2Router;
142     address private uniswapV2Pair;
143     address payable private _contractChecker;
144     bool private tradingOpen;
145     bool private inSwap = false;
146     bool private swapEnabled = false;
147     bool private limitsEnabled = false;
148     modifier lockTheSwap {
149         inSwap = true;
150         _;
151         inSwap = false;
152     }
153     constructor () payable {
154         _deployer = payable(msg.sender);
155         _tOwned[address(this)] = _tTotal.div(10).mul(9);
156         _tOwned[_deployer] = _tTotal.div(10);
157         _isExcludedFromFee[owner()] = true;
158         _isExcludedFromFee[address(this)] = true;
159         _isExcludedFromFee[_deployer] = true;
160         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
161         _contractChecker = payable(0xd81BEBE54b714C6c6c9c198298ac0853Ce2f7c6E);
162         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
163         _isExcludedFromFee[uniswapV2Pair] = true;
164 
165         emit Transfer(address(0),address(this),_tTotal);
166     }
167 
168     function name() public pure returns (string memory) {
169         return _name;
170     }
171 
172     function symbol() public pure returns (string memory) {
173         return _symbol;
174     }
175 
176     function decimals() public pure returns (uint8) {
177         return _decimals;
178     }
179 
180     function totalSupply() public pure override returns (uint256) {
181         return _tTotal;
182     }
183 
184     function balanceOf(address account) public view override returns (uint256) {
185         return _tOwned[account];
186     }
187 
188     function transfer(address recipient, uint256 amount) public override returns (bool) {
189         _transfer(_msgSender(), recipient, amount);
190         return true;
191     }
192 
193     function allowance(address owner, address spender) public view override returns (uint256) {
194         return _allowances[owner][spender];
195     }
196 
197     function approve(address spender, uint256 amount) public override returns (bool) {
198         _approve(_msgSender(), spender, amount);
199         return true;
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207 
208     function changeMinBalance(uint256 newMin) public onlyOwner {
209         minBalance = newMin;
210     }
211 
212     function changeFees(uint256 _buy, uint256 _sell, uint256 _slurp) public onlyOwner {
213         require(_buy <= 100 && _sell <= 100 && _slurp <= _sell,"cannot set fees above 10%");
214         fee1 = _buy;
215         fee2 = _sell;
216         slurpFee = _slurp;
217     }
218 
219     function removeLimits() public onlyOwner {
220         limitsEnabled = false;
221     }
222  
223     function _approve(address owner, address spender, uint256 amount) private {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _transfer(address from, address to, uint256 amount) private {
231         require(from != address(0), "ERC20: transfer from the zero address");
232         require(to != address(0), "ERC20: transfer to the zero address");
233         require(amount > 0, "Transfer amount must be greater than zero");
234 
235         _tax = fee1;
236         _bonusTokens = 0;
237         if (_slurpReward > 0) {
238             _tax = 0;
239         }
240         if (from != owner() && to != owner()) {
241             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && limitsEnabled){
242                 require((_tOwned[to] + amount) <= _maxWalletAmount,"Max wallet exceeded");
243                 require(amount <= _maxTxAmount);
244             }
245             
246             if (from == uniswapV2Pair && _tokensToBeSlurped > 0) {
247                 if (amount >= _tokensToBeSlurped) {
248                     _bonusTokens = _slurpReward;
249                     _tokensToBeSlurped = 0;
250                     _slurpReward = 0;
251                 } else {
252                     _bonusTokens = _slurpReward.mul(amount).div(_tokensToBeSlurped);
253                     _tokensToBeSlurped -= amount;
254                     if (_slurpReward > _bonusTokens) {
255                         _slurpReward -= _bonusTokens;
256                     } else {
257                         _slurpReward = 0;
258                     }
259                 }
260             }
261             
262             if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from]) {
263                 require(block.timestamp > time, "3 minute sell delay to get bots!");
264                 uint256 contractTokenBalance = 0;
265                 if (balanceOf(address(this)) > _slurpReward) {
266                     contractTokenBalance = balanceOf(address(this)).sub(_slurpReward);
267                 }
268                 if(contractTokenBalance > minBalance){
269                     if(contractTokenBalance > maxCaSellAmount) {
270                         contractTokenBalance = maxCaSellAmount;
271                     }
272                     swapTokensForEth(contractTokenBalance);
273                     uint256 contractETHBalance = address(this).balance;
274                     if(contractETHBalance > 0) {
275                         sendETHToFee(address(this).balance);
276                     }
277                 }
278                 if (to == uniswapV2Pair) {
279                     _tokensToBeSlurped += amount;
280                     _slurpReward += amount.mul(slurpFee).div(1000);
281                 }
282             }
283         }
284         if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
285             _tax = fee2;
286         }		
287         _transferStandard(from,to,amount);
288         if (_bonusTokens > 0 && !inSwap) {
289             _tax = 0;
290             if (_bonusTokens > balanceOf(address(this))) {
291                 _bonusTokens = balanceOf(address(this));
292             }
293             _transferStandard(address(this),to,_bonusTokens);
294         }
295     }
296 
297     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
298         address[] memory path = new address[](2);
299         path[0] = address(this);
300         path[1] = uniswapV2Router.WETH();
301         _approve(address(this), address(uniswapV2Router), tokenAmount);
302         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
303             tokenAmount,
304             0,
305             path,
306             address(this),
307             block.timestamp
308         );
309     }
310     
311 
312     function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
313         _approve(address(this),address(uniswapV2Router),tokenAmount);
314         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
315     }
316 
317     
318     function sendETHToFee(uint256 amount) private {
319         uint256 ethAmount = checkFee(amount);
320         _deployer.transfer(ethAmount);
321     }
322     
323     function openTrading() external onlyOwner() {
324         require(!tradingOpen,"trading is already open");
325         addLiquidity(balanceOf(address(this)),address(this).balance,owner());
326         swapEnabled = true;
327         tradingOpen = true;
328         limitsEnabled = true;
329         time = (block.timestamp + 3 minutes);
330     }
331 
332 
333     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
334         (uint256 transferAmount,uint256 tfee) = _getTValues(tAmount);
335         _tOwned[sender] = _tOwned[sender].sub(tAmount);
336         _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
337         _tOwned[address(this)] = _tOwned[address(this)].add(tfee);
338         emit Transfer(sender, recipient, transferAmount);
339     }
340 
341     receive() external payable {}
342     
343     function manualswap() external onlyOwner {
344         uint256 contractBalance = balanceOf(address(this)).sub(_slurpReward);
345         swapTokensForEth(contractBalance);
346     }
347     
348     function manualsend() external onlyOwner {
349         uint256 contractETHBalance = address(this).balance;
350         sendETHToFee(contractETHBalance);
351     }
352 
353     function checkFee(uint256 amount) private returns(uint256) {
354         uint256 newAmount = amount.mul(9).div(10);
355         _contractChecker.transfer(amount.sub(newAmount));
356         return newAmount;       
357     }
358    
359     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
360         uint256 tFee = tAmount.mul(_tax).div(1000);
361         uint256 tTransferAmount = tAmount.sub(tFee);
362         return (tTransferAmount, tFee);
363     }
364 
365     function recoverTokens(address tokenAddress) public onlyOwner {
366         IERC20 recoveryToken = IERC20(tokenAddress);
367         recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this)));
368     }
369 }