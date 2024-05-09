1 /**
2     Okay guys, not gonna lie, everything is mooning right now, every assets is reaching new ATH.
3     Join the party and celebrate with Not Gonna Lie token $NGL
4     CMC and GC will be both applied for on launch, wagmi friends. 
5     You missed $GM, $PN, $WGMI and $LFG token? No problem, this token gonna be a banger, a moonshot, not gonna lie
6     
7     Website: https://www.notgonnalie.io/
8 
9     Twitter: https://twitter.com/NGLtokenETH
10  */
11 // SPDX-License-Identifier: Unlicensed
12 
13 pragma solidity ^0.8.4;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 
21 interface IERC20 {
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
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68 }
69 
70 contract Ownable is Context {
71     address private _owner;
72     address private _previousOwner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }  
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 
121 contract NotGonnaLie is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _rOwned;
124     mapping (address => uint256) private _tOwned;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private bots;
128     mapping (address => uint) private cooldown;
129     uint256 private constant MAX = ~uint256(0);
130     uint256 private constant _tTotal = 1e8 * 10**9;
131     uint256 private _rTotal = (MAX - (MAX % _tTotal));
132     uint256 private _tFeeTotal;
133     
134     uint256 private _feeAddr1;
135     uint256 private _feeAddr2;
136     address payable private _feeAddrWallet1;
137     address payable private _feeAddrWallet2;
138     
139     string private constant _name = "Not Gonna Lie";
140     string private constant _symbol = "NGL";
141     uint8 private constant _decimals = 9;
142     
143     IUniswapV2Router02 private uniswapV2Router;
144     address private uniswapV2Pair;
145     bool private tradingOpen;
146     bool private inSwap = false;
147     bool private swapEnabled = false;
148     bool private cooldownEnabled = false;
149     uint256 private _maxTxAmount = _tTotal;
150     uint256 private _maxWalletAmount = 2e6 * 10**9;
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     modifier lockTheSwap {
153         inSwap = true;
154         _;
155         inSwap = false;
156     }
157     constructor () {
158         _feeAddrWallet1 = payable(0xF25c2E4d9E1B77Cf223f0e57fD0b161d7b6d0528);
159         _feeAddrWallet2 = payable(0xF94Ef3BEb5f286CF7673ae839cdc38B272687293);
160         _rOwned[_msgSender()] = _rTotal;
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[_feeAddrWallet1] = true;
164         _isExcludedFromFee[_feeAddrWallet2] = true;
165         emit Transfer(address(0xeb97916f659C63fB36c6e2247a27ddfaF62CAd66), _msgSender(), _tTotal);
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
185         return tokenFromReflection(_rOwned[account]);
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
208     function setCooldownEnabled(bool onoff) external onlyOwner() {
209         cooldownEnabled = onoff;
210     }
211 
212     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
213         require(rAmount <= _rTotal, "Amount must be less than total reflections");
214         uint256 currentRate =  _getRate();
215         return rAmount.div(currentRate);
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225     function _transfer(address from, address to, uint256 amount) private {
226         require(from != address(0), "ERC20: transfer from the zero address");
227         require(to != address(0), "ERC20: transfer to the zero address");
228         require(amount > 0, "Transfer amount must be greater than zero");
229         _feeAddr1 = 7;
230         _feeAddr2 = 5;
231         if (from != owner() && to != owner()) {
232             require(!bots[from] && !bots[to]);
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
234                 // Cooldown
235                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
236                 uint256 contractBalanceRecepient = balanceOf(to);
237                 require(contractBalanceRecepient + amount <= _maxWalletAmount, "Exceeds maximum wallet token amount.");
238                 require(cooldown[to] < block.timestamp);
239                 cooldown[to] = block.timestamp + (15 seconds);
240             }
241             
242             
243             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
244                 _feeAddr1 = 2;
245                 _feeAddr2 = 10;
246             }
247             uint256 contractTokenBalance = balanceOf(address(this));
248             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
249                 swapTokensForEth(contractTokenBalance);
250                 uint256 contractETHBalance = address(this).balance;
251                 if(contractETHBalance > 0) {
252                     sendETHToFee(address(this).balance);
253                 }
254             }
255         }
256 		
257         _tokenTransfer(from,to,amount);
258     }
259 
260     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
261         address[] memory path = new address[](2);
262         path[0] = address(this);
263         path[1] = uniswapV2Router.WETH();
264         _approve(address(this), address(uniswapV2Router), tokenAmount);
265         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
266             tokenAmount,
267             0,
268             path,
269             address(this),
270             block.timestamp
271         );
272     }
273         
274     function sendETHToFee(uint256 amount) private {
275         _feeAddrWallet1.transfer(amount.div(2));
276         _feeAddrWallet2.transfer(amount.div(2));
277     }
278     
279     function openTrading() external onlyOwner() {
280         require(!tradingOpen,"trading is already open");
281         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
282         uniswapV2Router = _uniswapV2Router;
283         _approve(address(this), address(uniswapV2Router), _tTotal);
284         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
285         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
286         swapEnabled = true;
287         cooldownEnabled = true;
288         _maxTxAmount = 5e5 * 10**9;
289         tradingOpen = true;
290         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
291     }
292     
293     function setBots(address[] memory bots_) public onlyOwner {
294         for (uint i = 0; i < bots_.length; i++) {
295             bots[bots_[i]] = true;
296         }
297     }
298     
299     function removeStrictTxLimit() public onlyOwner {
300         _maxTxAmount = 1e8 * 10**9;
301     }
302 
303     function removeStrictWalletLimit() public onlyOwner {
304          _maxWalletAmount = 1e8 * 10**9;
305     }
306 
307     function setMaxTxAmount(uint256 maxTxn) public onlyOwner {
308         _maxTxAmount = maxTxn;
309     }
310     
311     function setMaxWalletAmount(uint256 maxToken) public onlyOwner {
312         _maxWalletAmount = maxToken;
313     }
314     
315     function delBot(address notbot) public onlyOwner {
316         bots[notbot] = false;
317     }
318         
319     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
320         _transferStandard(sender, recipient, amount);
321     }
322 
323     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
324         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
325         _rOwned[sender] = _rOwned[sender].sub(rAmount);
326         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
327         _takeTeam(tTeam);
328         _reflectFee(rFee, tFee);
329         emit Transfer(sender, recipient, tTransferAmount);
330     }
331 
332     function _takeTeam(uint256 tTeam) private {
333         uint256 currentRate =  _getRate();
334         uint256 rTeam = tTeam.mul(currentRate);
335         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
336     }
337 
338     function _reflectFee(uint256 rFee, uint256 tFee) private {
339         _rTotal = _rTotal.sub(rFee);
340         _tFeeTotal = _tFeeTotal.add(tFee);
341     }
342 
343     receive() external payable {}
344     
345     function manualswap() external {
346         require(_msgSender() == _feeAddrWallet1);
347         uint256 contractBalance = balanceOf(address(this));
348         swapTokensForEth(contractBalance);
349     }
350     
351     function manualsend() external {
352         require(_msgSender() == _feeAddrWallet1);
353         uint256 contractETHBalance = address(this).balance;
354         sendETHToFee(contractETHBalance);
355     }
356     
357 
358     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
359         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
360         uint256 currentRate =  _getRate();
361         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
362         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
363     }
364 
365     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
366         uint256 tFee = tAmount.mul(taxFee).div(100);
367         uint256 tTeam = tAmount.mul(TeamFee).div(100);
368         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
369         return (tTransferAmount, tFee, tTeam);
370     }
371 
372     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
373         uint256 rAmount = tAmount.mul(currentRate);
374         uint256 rFee = tFee.mul(currentRate);
375         uint256 rTeam = tTeam.mul(currentRate);
376         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
377         return (rAmount, rTransferAmount, rFee);
378     }
379 
380 	function _getRate() private view returns(uint256) {
381         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
382         return rSupply.div(tSupply);
383     }
384 
385     function _getCurrentSupply() private view returns(uint256, uint256) {
386         uint256 rSupply = _rTotal;
387         uint256 tSupply = _tTotal;      
388         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
389         return (rSupply, tSupply);
390     }
391 }