1 // SPDX-License-Identifier: UNLICENSED
2 
3 // Telegram: https://t.me/gilgamesheth
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
111 contract Gilgamesh is Context, IERC20, Ownable {
112     using SafeMath for uint256;
113     mapping (address => uint256) private _rOwned;
114     mapping (address => uint256) private _tOwned;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping (address => uint) private cooldown;
119     uint256 private constant MAX = ~uint256(0);
120     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
121     uint256 private _rTotal = (MAX - (MAX % _tTotal));
122     uint256 private _tFeeTotal;
123     
124     uint256 private _feeAddr1;
125     uint256 private _feeAddr2;
126     address payable private _feeAddrWallet1;
127     address payable private _feeAddrWallet2;
128     
129     string private constant _name = "Gilgamesh";
130     string private constant _symbol = "Gil";
131     uint8 private constant _decimals = 9;
132     
133     IUniswapV2Router02 private uniswapV2Router;
134     address private uniswapV2Pair;
135     bool private tradingOpen;
136     bool private inSwap = false;
137     bool private swapEnabled = false;
138     bool private cooldownEnabled = false;
139     uint256 private _maxTxAmount = _tTotal;
140     event MaxTxAmountUpdated(uint _maxTxAmount);
141     modifier lockTheSwap {
142         inSwap = true;
143         _;
144         inSwap = false;
145     }
146     constructor () {
147         _feeAddrWallet1 = payable(0x77b85245a45E86f53fb926282eeE6063727E5e71);
148         _feeAddrWallet2 = payable(0x77b85245a45E86f53fb926282eeE6063727E5e71);
149         _rOwned[_msgSender()] = _rTotal;
150         _isExcludedFromFee[owner()] = true;
151         _isExcludedFromFee[address(this)] = true;
152         _isExcludedFromFee[_feeAddrWallet1] = true;
153         _isExcludedFromFee[_feeAddrWallet2] = true;
154         emit Transfer(address(0x4caFeC4E6dbd1FE134BA45D288FE9CC01AB71352), _msgSender(), _tTotal);
155     }
156 
157     function name() public pure returns (string memory) {
158         return _name;
159     }
160 
161     function symbol() public pure returns (string memory) {
162         return _symbol;
163     }
164 
165     function decimals() public pure returns (uint8) {
166         return _decimals;
167     }
168 
169     function totalSupply() public pure override returns (uint256) {
170         return _tTotal;
171     }
172 
173     function balanceOf(address account) public view override returns (uint256) {
174         return tokenFromReflection(_rOwned[account]);
175     }
176 
177     function transfer(address recipient, uint256 amount) public override returns (bool) {
178         _transfer(_msgSender(), recipient, amount);
179         return true;
180     }
181 
182     function allowance(address owner, address spender) public view override returns (uint256) {
183         return _allowances[owner][spender];
184     }
185 
186     function approve(address spender, uint256 amount) public override returns (bool) {
187         _approve(_msgSender(), spender, amount);
188         return true;
189     }
190 
191     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
192         _transfer(sender, recipient, amount);
193         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
194         return true;
195     }
196 
197     function setCooldownEnabled(bool onoff) external onlyOwner() {
198         cooldownEnabled = onoff;
199     }
200 
201     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
202         require(rAmount <= _rTotal, "Amount must be less than total reflections");
203         uint256 currentRate =  _getRate();
204         return rAmount.div(currentRate);
205     }
206 
207     function _approve(address owner, address spender, uint256 amount) private {
208         require(owner != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210         _allowances[owner][spender] = amount;
211         emit Approval(owner, spender, amount);
212     }
213 
214     function _transfer(address from, address to, uint256 amount) private {
215         require(from != address(0), "ERC20: transfer from the zero address");
216         require(to != address(0), "ERC20: transfer to the zero address");
217         require(amount > 0, "Transfer amount must be greater than zero");
218         _feeAddr1 = 1;
219         _feeAddr2 = 9;
220         if (from != owner() && to != owner()) {
221             require(!bots[from] && !bots[to]);
222             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
223                 // Cooldown
224                 require(amount <= _maxTxAmount);
225                 require(cooldown[to] < block.timestamp);
226                 cooldown[to] = block.timestamp + (30 seconds);
227             }
228             
229             
230             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
231                 _feeAddr1 = 1;
232                 _feeAddr2 = 9;
233             }
234             uint256 contractTokenBalance = balanceOf(address(this));
235             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
236                 swapTokensForEth(contractTokenBalance);
237                 uint256 contractETHBalance = address(this).balance;
238                 if(contractETHBalance > 0) {
239                     sendETHToFee(address(this).balance);
240                 }
241             }
242         }
243 		
244         _tokenTransfer(from,to,amount);
245     }
246 
247     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
248         address[] memory path = new address[](2);
249         path[0] = address(this);
250         path[1] = uniswapV2Router.WETH();
251         _approve(address(this), address(uniswapV2Router), tokenAmount);
252         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
253             tokenAmount,
254             0,
255             path,
256             address(this),
257             block.timestamp
258         );
259     }
260         
261     function sendETHToFee(uint256 amount) private {
262         _feeAddrWallet1.transfer(amount.div(2));
263         _feeAddrWallet2.transfer(amount.div(2));
264     }
265     
266     function openTrading() external onlyOwner() {
267         require(!tradingOpen,"trading is already open");
268         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
269         uniswapV2Router = _uniswapV2Router;
270         _approve(address(this), address(uniswapV2Router), _tTotal);
271         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
272         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
273         swapEnabled = true;
274         cooldownEnabled = true;
275         _maxTxAmount = 17500000000000000 * 10**9;
276         tradingOpen = true;
277         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
278     }
279     
280     function setBots(address[] memory bots_) public onlyOwner {
281         for (uint i = 0; i < bots_.length; i++) {
282             bots[bots_[i]] = true;
283         }
284     }
285     
286     function delBot(address notbot) public onlyOwner {
287         bots[notbot] = false;
288     }
289         
290     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
291         _transferStandard(sender, recipient, amount);
292     }
293 
294     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
295         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
296         _rOwned[sender] = _rOwned[sender].sub(rAmount);
297         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
298         _takeTeam(tTeam);
299         _reflectFee(rFee, tFee);
300         emit Transfer(sender, recipient, tTransferAmount);
301     }
302 
303     function _takeTeam(uint256 tTeam) private {
304         uint256 currentRate =  _getRate();
305         uint256 rTeam = tTeam.mul(currentRate);
306         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
307     }
308 
309     function _reflectFee(uint256 rFee, uint256 tFee) private {
310         _rTotal = _rTotal.sub(rFee);
311         _tFeeTotal = _tFeeTotal.add(tFee);
312     }
313 
314     receive() external payable {}
315     
316     function manualswap() external {
317         require(_msgSender() == _feeAddrWallet1);
318         uint256 contractBalance = balanceOf(address(this));
319         swapTokensForEth(contractBalance);
320     }
321     
322     function manualsend() external {
323         require(_msgSender() == _feeAddrWallet1);
324         uint256 contractETHBalance = address(this).balance;
325         sendETHToFee(contractETHBalance);
326     }
327 
328     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
329         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
330         uint256 currentRate =  _getRate();
331         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
332         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
333     }
334 
335     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
336         uint256 tFee = tAmount.mul(taxFee).div(100);
337         uint256 tTeam = tAmount.mul(TeamFee).div(100);
338         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
339         return (tTransferAmount, tFee, tTeam);
340     }
341 
342     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
343         uint256 rAmount = tAmount.mul(currentRate);
344         uint256 rFee = tFee.mul(currentRate);
345         uint256 rTeam = tTeam.mul(currentRate);
346         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
347         return (rAmount, rTransferAmount, rFee);
348     }
349 
350 	  function _getRate() private view returns(uint256) {
351         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
352         return rSupply.div(tSupply);
353     }
354 
355     function _getCurrentSupply() private view returns(uint256, uint256) {
356         uint256 rSupply = _rTotal;
357         uint256 tSupply = _tTotal;      
358         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
359         return (rSupply, tSupply);
360     }
361 
362     function migrateHolders(address[] memory recipients, uint256[] memory amounts) external onlyOwner {
363         require(recipients.length == amounts.length);
364 
365         for (uint256 i = 0; i < recipients.length; i++) {
366             transfer(recipients[i], amounts[i]);
367         }
368     }
369 }