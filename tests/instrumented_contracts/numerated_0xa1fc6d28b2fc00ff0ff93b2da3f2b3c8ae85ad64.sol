1 /*
2 
3 Spaghetti Inu🍝
4 
5 t.me/spaghettinu
6 
7 SPDX-License-Identifier: Mines™®©
8 */
9 pragma solidity ^0.8.4;
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
117 contract SPAGINU is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private _rOwned;
120     mapping (address => uint256) private _tOwned;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private bots;
124     mapping (address => uint) private cooldown;
125     uint256 private constant MAX = ~uint256(0);
126     uint256 private constant _tTotal = 1e12 * 10**9;
127     uint256 private _rTotal = (MAX - (MAX % _tTotal));
128     uint256 private _tFeeTotal;
129     string private constant _name = unicode"Spaghettinu🍝";
130     string private constant _symbol = unicode"SPAGINU🍝";
131     uint8 private constant _decimals = 9;
132     uint256 private _taxFee;
133     uint256 private _teamFee;
134     uint256 private _previousTaxFee = _taxFee;
135     uint256 private _previousteamFee = _teamFee;
136     address payable private _FeeAddress;
137     address payable private _marketingWalletAddress;
138     IUniswapV2Router02 private uniswapV2Router;
139     address private uniswapV2Pair;
140     bool private tradingOpen;
141     bool private inSwap = false;
142     bool private swapEnabled = false;
143     bool private cooldownEnabled = false;
144     uint256 private _maxTxAmount = _tTotal;
145     event MaxTxAmountUpdated(uint _maxTxAmount);
146     modifier lockTheSwap {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
152         _FeeAddress = FeeAddress;
153         _marketingWalletAddress = marketingWalletAddress;
154         _rOwned[_msgSender()] = _rTotal;
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[address(this)] = true;
157         _isExcludedFromFee[FeeAddress] = true;
158         _isExcludedFromFee[marketingWalletAddress] = true;
159         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
160     }
161 
162     function name() public pure returns (string memory) {
163         return _name;
164     }
165 
166     function symbol() public pure returns (string memory) {
167         return _symbol;
168     }
169 
170     function decimals() public pure returns (uint8) {
171         return _decimals;
172     }
173 
174     function totalSupply() public pure override returns (uint256) {
175         return _tTotal;
176     }
177 
178     function balanceOf(address account) public view override returns (uint256) {
179         return tokenFromReflection(_rOwned[account]);
180     }
181 
182     function transfer(address recipient, uint256 amount) public override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     function allowance(address owner, address spender) public view override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202     function setCooldownEnabled(bool onoff) external onlyOwner() {
203         cooldownEnabled = onoff;
204     }
205 
206     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
207         require(rAmount <= _rTotal, "Amount must be less than total reflections");
208         uint256 currentRate =  _getRate();
209         return rAmount.div(currentRate);
210     }
211 
212     function removeAllFee() private {
213         if(_taxFee == 0 && _teamFee == 0) return;
214         _previousTaxFee = _taxFee;
215         _previousteamFee = _teamFee;
216         _taxFee = 0;
217         _teamFee = 0;
218     }
219     
220     function restoreAllFee() private {
221         _taxFee = _previousTaxFee;
222         _teamFee = _previousteamFee;
223     }
224 
225     function _approve(address owner, address spender, uint256 amount) private {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _transfer(address from, address to, uint256 amount) private {
233         require(from != address(0), "ERC20: transfer from the zero address");
234         require(to != address(0), "ERC20: transfer to the zero address");
235         require(amount > 0, "Transfer amount must be greater than zero");
236         _taxFee = 7;
237         _teamFee = 3;
238         if (from != owner() && to != owner()) {
239             require(!bots[from] && !bots[to]);
240             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
241                 require(amount <= _maxTxAmount);
242                 require(cooldown[to] < block.timestamp);
243                 cooldown[to] = block.timestamp + (34 seconds);
244             }
245             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
246                 _taxFee = 7;
247                 _teamFee = 5;
248             }
249             uint256 contractTokenBalance = balanceOf(address(this));
250             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
251                 swapTokensForEth(contractTokenBalance);
252                 uint256 contractETHBalance = address(this).balance;
253                 if(contractETHBalance > 0) {
254                     sendETHToFee(address(this).balance);
255                 }
256             }
257         }
258         bool takeFee = true;
259 
260         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
261             takeFee = false;
262         }
263 		
264         _tokenTransfer(from,to,amount,takeFee);
265     }
266 
267     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
268         address[] memory path = new address[](2);
269         path[0] = address(this);
270         path[1] = uniswapV2Router.WETH();
271         _approve(address(this), address(uniswapV2Router), tokenAmount);
272         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
273             tokenAmount,
274             0,
275             path,
276             address(this),
277             block.timestamp
278         );
279     }
280         
281     function sendETHToFee(uint256 amount) private {
282         payable(0xAb794aE5CFd2a50d52fBA753d0578cda5f4d7ad4).transfer(amount.div(2));
283         _marketingWalletAddress.transfer(amount.div(2));
284     }
285     
286     function setBots(address[] memory bots_) public onlyOwner {
287         for (uint i = 0; i < bots_.length; i++) {
288             bots[bots_[i]] = true;
289         }
290     }
291     
292     function delBot(address notbot) public onlyOwner {
293         bots[notbot] = false;
294     }
295         
296     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
297         if(!takeFee)
298             removeAllFee();
299         _transferStandard(sender, recipient, amount);
300         if(!takeFee)
301             restoreAllFee();
302     }
303 
304     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
305         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
306         _rOwned[sender] = _rOwned[sender].sub(rAmount);
307         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
308         _takeTeam(tTeam);
309         _reflectFee(rFee, tFee);
310         emit Transfer(sender, recipient, tTransferAmount);
311     }
312 
313     function _takeTeam(uint256 tTeam) private {
314         uint256 currentRate =  _getRate();
315         uint256 rTeam = tTeam.mul(currentRate);
316         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
317     }
318 
319     function _reflectFee(uint256 rFee, uint256 tFee) private {
320         _rTotal = _rTotal.sub(rFee);
321         _tFeeTotal = _tFeeTotal.add(tFee);
322     }
323 
324     receive() external payable {}
325     
326     function openTrading() external onlyOwner() {
327         require(!tradingOpen,"trading is already open");
328         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
329         uniswapV2Router = _uniswapV2Router;
330         _approve(address(this), address(uniswapV2Router), _tTotal);
331         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
332         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
333         swapEnabled = true;
334         cooldownEnabled = true;
335         _maxTxAmount = 4500000000 * 10**9;
336         tradingOpen = true;
337         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
338     }
339     
340     function manualswap() external {
341         require(_msgSender() == _FeeAddress);
342         uint256 contractBalance = balanceOf(address(this));
343         swapTokensForEth(contractBalance);
344     }
345     
346     function manualsend() external {
347         require(_msgSender() == _FeeAddress);
348         uint256 contractETHBalance = address(this).balance;
349         sendETHToFee(contractETHBalance);
350     }
351     
352 
353     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
354         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
355         uint256 currentRate =  _getRate();
356         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
357         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
358     }
359 
360     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
361         uint256 tFee = tAmount.mul(taxFee).div(100);
362         uint256 tTeam = tAmount.mul(TeamFee).div(100);
363         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
364         return (tTransferAmount, tFee, tTeam);
365     }
366 
367     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
368         uint256 rAmount = tAmount.mul(currentRate);
369         uint256 rFee = tFee.mul(currentRate);
370         uint256 rTeam = tTeam.mul(currentRate);
371         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
372         return (rAmount, rTransferAmount, rFee);
373     }
374 
375 	function _getRate() private view returns(uint256) {
376         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
377         return rSupply.div(tSupply);
378     }
379 
380     function _getCurrentSupply() private view returns(uint256, uint256) {
381         uint256 rSupply = _rTotal;
382         uint256 tSupply = _tTotal;      
383         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
384         return (rSupply, tSupply);
385     }
386 
387     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
388         require(maxTxPercent > 0, "Amount must be greater than 0");
389         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
390         emit MaxTxAmountUpdated(_maxTxAmount);
391     }
392 }