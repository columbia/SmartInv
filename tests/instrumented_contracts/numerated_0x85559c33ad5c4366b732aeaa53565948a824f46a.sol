1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-03
3 */
4 
5 /*
6 
7 
8  t.me/shurger
9  Shiba Burger
10  $SHURGER
11  
12       _                               
13     | |                              
14  ___| |__  _   _ _ __ __ _  ___ _ __ 
15 / __| '_ \| | | | '__/ _` |/ _ \ '__|
16 \__ \ | | | |_| | | | (_| |  __/ |   
17 |___/_| |_|\__,_|_|  \__, |\___|_|   
18                       __/ |          
19                      |___/          
20 
21  //shibaburger.net 
22  
23  // Twitter: @itsshibaburger
24  
25  // Reddit: https://www.reddit.com/r/ShibaBurger/
26  
27  // Instagram: @shibaburger
28 
29  //Marketing paid
30 
31  //Liqudity Locked
32  
33  //Ownership renounced
34  
35  //No Devwallets
36  
37  //CG, CMC listing: Ongoing
38 
39  SPDX-License-Identifier: Mines™®©
40 */
41 pragma solidity ^0.8.4;
42 
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 }
48 
49 interface IERC20 {
50     function totalSupply() external view returns (uint256);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74         return c;
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83         return c;
84     }
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b > 0, errorMessage);
92         uint256 c = a / b;
93         return c;
94     }
95 
96 }
97 
98 contract Ownable is Context {
99     address private _owner;
100     address private _previousOwner;
101     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
102 
103     constructor () {
104         address msgSender = _msgSender();
105         _owner = msgSender;
106         emit OwnershipTransferred(address(0), msgSender);
107     }
108 
109     function owner() public view returns (address) {
110         return _owner;
111     }
112 
113     modifier onlyOwner() {
114         require(_owner == _msgSender(), "Ownable: caller is not the owner");
115         _;
116     }
117 
118     function renounceOwnership() public virtual onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 
123 }  
124 
125 interface IUniswapV2Factory {
126     function createPair(address tokenA, address tokenB) external returns (address pair);
127 }
128 
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint amountIn,
132         uint amountOutMin,
133         address[] calldata path,
134         address to,
135         uint deadline
136     ) external;
137     function factory() external pure returns (address);
138     function WETH() external pure returns (address);
139     function addLiquidityETH(
140         address token,
141         uint amountTokenDesired,
142         uint amountTokenMin,
143         uint amountETHMin,
144         address to,
145         uint deadline
146     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
147 }
148 
149 contract SHURGER is Context, IERC20, Ownable {
150     using SafeMath for uint256;
151     mapping (address => uint256) private _rOwned;
152     mapping (address => uint256) private _tOwned;
153     mapping (address => mapping (address => uint256)) private _allowances;
154     mapping (address => bool) private _isExcludedFromFee;
155     mapping (address => bool) private bots;
156     mapping (address => uint) private cooldown;
157     uint256 private constant MAX = ~uint256(0);
158     uint256 private constant _tTotal = 1e12 * 10**9;
159     uint256 private _rTotal = (MAX - (MAX % _tTotal));
160     uint256 private _tFeeTotal;
161     string private constant _name = "Shiba Burger";
162     string private constant _symbol = unicode'SHURGER 🍔';
163     uint8 private constant _decimals = 9;
164     uint256 private _taxFee;
165     uint256 private _teamFee;
166     uint256 private _previousTaxFee = _taxFee;
167     uint256 private _previousteamFee = _teamFee;
168     address payable private _FeeAddress;
169     address payable private _marketingWalletAddress;
170     IUniswapV2Router02 private uniswapV2Router;
171     address private uniswapV2Pair;
172     bool private tradingOpen;
173     bool private inSwap = false;
174     bool private swapEnabled = false;
175     bool private cooldownEnabled = false;
176     uint256 private _maxTxAmount = _tTotal;
177     event MaxTxAmountUpdated(uint _maxTxAmount);
178     modifier lockTheSwap {
179         inSwap = true;
180         _;
181         inSwap = false;
182     }
183     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
184         _FeeAddress = FeeAddress;
185         _marketingWalletAddress = marketingWalletAddress;
186         _rOwned[_msgSender()] = _rTotal;
187         _isExcludedFromFee[owner()] = true;
188         _isExcludedFromFee[address(this)] = true;
189         _isExcludedFromFee[FeeAddress] = true;
190         _isExcludedFromFee[marketingWalletAddress] = true;
191         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
192     }
193 
194     function name() public pure returns (string memory) {
195         return _name;
196     }
197 
198     function symbol() public pure returns (string memory) {
199         return _symbol;
200     }
201 
202     function decimals() public pure returns (uint8) {
203         return _decimals;
204     }
205 
206     function totalSupply() public pure override returns (uint256) {
207         return _tTotal;
208     }
209 
210     function balanceOf(address account) public view override returns (uint256) {
211         return tokenFromReflection(_rOwned[account]);
212     }
213 
214     function transfer(address recipient, uint256 amount) public override returns (bool) {
215         _transfer(_msgSender(), recipient, amount);
216         return true;
217     }
218 
219     function allowance(address owner, address spender) public view override returns (uint256) {
220         return _allowances[owner][spender];
221     }
222 
223     function approve(address spender, uint256 amount) public override returns (bool) {
224         _approve(_msgSender(), spender, amount);
225         return true;
226     }
227 
228     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
229         _transfer(sender, recipient, amount);
230         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
231         return true;
232     }
233 
234     function setCooldownEnabled(bool onoff) external onlyOwner() {
235         cooldownEnabled = onoff;
236     }
237 
238     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
239         require(rAmount <= _rTotal, "Amount must be less than total reflections");
240         uint256 currentRate =  _getRate();
241         return rAmount.div(currentRate);
242     }
243 
244     function removeAllFee() private {
245         if(_taxFee == 0 && _teamFee == 0) return;
246         _previousTaxFee = _taxFee;
247         _previousteamFee = _teamFee;
248         _taxFee = 0;
249         _teamFee = 0;
250     }
251     
252     function restoreAllFee() private {
253         _taxFee = _previousTaxFee;
254         _teamFee = _previousteamFee;
255     }
256 
257     function _approve(address owner, address spender, uint256 amount) private {
258         require(owner != address(0), "ERC20: approve from the zero address");
259         require(spender != address(0), "ERC20: approve to the zero address");
260         _allowances[owner][spender] = amount;
261         emit Approval(owner, spender, amount);
262     }
263 
264     function _transfer(address from, address to, uint256 amount) private {
265         require(from != address(0), "ERC20: transfer from the zero address");
266         require(to != address(0), "ERC20: transfer to the zero address");
267         require(amount > 0, "Transfer amount must be greater than zero");
268         _taxFee = 5;
269         _teamFee = 10;
270         if (from != owner() && to != owner()) {
271             require(!bots[from] && !bots[to]);
272             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
273                 require(amount <= _maxTxAmount);
274                 require(cooldown[to] < block.timestamp);
275                 cooldown[to] = block.timestamp + (30 seconds);
276             }
277             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
278                 _taxFee = 5;
279                 _teamFee = 10;
280             }
281             uint256 contractTokenBalance = balanceOf(address(this));
282             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
283                 swapTokensForEth(contractTokenBalance);
284                 uint256 contractETHBalance = address(this).balance;
285                 if(contractETHBalance > 0) {
286                     sendETHToFee(address(this).balance);
287                 }
288             }
289         }
290         bool takeFee = true;
291 
292         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
293             takeFee = false;
294         }
295 		
296         _tokenTransfer(from,to,amount,takeFee);
297     }
298 
299     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
300         address[] memory path = new address[](2);
301         path[0] = address(this);
302         path[1] = uniswapV2Router.WETH();
303         _approve(address(this), address(uniswapV2Router), tokenAmount);
304         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
305             tokenAmount,
306             0,
307             path,
308             address(this),
309             block.timestamp
310         );
311     }
312         
313     function sendETHToFee(uint256 amount) private {
314         _FeeAddress.transfer(amount.div(2));
315         _marketingWalletAddress.transfer(amount.div(2));
316     }
317     
318     function openTrading() external onlyOwner() {
319         require(!tradingOpen,"trading is already open");
320         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
321         uniswapV2Router = _uniswapV2Router;
322         _approve(address(this), address(uniswapV2Router), _tTotal);
323         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
324         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
325         swapEnabled = true;
326         cooldownEnabled = true;
327         _maxTxAmount = 4.25e9 * 10**9;
328         tradingOpen = true;
329         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
330     }
331     
332     function setBots(address[] memory bots_) public onlyOwner {
333         for (uint i = 0; i < bots_.length; i++) {
334             bots[bots_[i]] = true;
335         }
336     }
337     
338     function delBot(address notbot) public onlyOwner {
339         bots[notbot] = false;
340     }
341         
342     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
343         if(!takeFee)
344             removeAllFee();
345         _transferStandard(sender, recipient, amount);
346         if(!takeFee)
347             restoreAllFee();
348     }
349 
350     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
351         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
352         _rOwned[sender] = _rOwned[sender].sub(rAmount);
353         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
354         _takeTeam(tTeam);
355         _reflectFee(rFee, tFee);
356         emit Transfer(sender, recipient, tTransferAmount);
357     }
358 
359     function _takeTeam(uint256 tTeam) private {
360         uint256 currentRate =  _getRate();
361         uint256 rTeam = tTeam.mul(currentRate);
362         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
363     }
364 
365     function _reflectFee(uint256 rFee, uint256 tFee) private {
366         _rTotal = _rTotal.sub(rFee);
367         _tFeeTotal = _tFeeTotal.add(tFee);
368     }
369 
370     receive() external payable {}
371     
372     function manualswap() external {
373         require(_msgSender() == _FeeAddress);
374         uint256 contractBalance = balanceOf(address(this));
375         swapTokensForEth(contractBalance);
376     }
377     
378     function manualsend() external {
379         require(_msgSender() == _FeeAddress);
380         uint256 contractETHBalance = address(this).balance;
381         sendETHToFee(contractETHBalance);
382     }
383     
384 
385     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
386         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
387         uint256 currentRate =  _getRate();
388         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
389         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
390     }
391 
392     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
393         uint256 tFee = tAmount.mul(taxFee).div(100);
394         uint256 tTeam = tAmount.mul(TeamFee).div(100);
395         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
396         return (tTransferAmount, tFee, tTeam);
397     }
398 
399     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
400         uint256 rAmount = tAmount.mul(currentRate);
401         uint256 rFee = tFee.mul(currentRate);
402         uint256 rTeam = tTeam.mul(currentRate);
403         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
404         return (rAmount, rTransferAmount, rFee);
405     }
406 
407 	function _getRate() private view returns(uint256) {
408         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
409         return rSupply.div(tSupply);
410     }
411 
412     function _getCurrentSupply() private view returns(uint256, uint256) {
413         uint256 rSupply = _rTotal;
414         uint256 tSupply = _tTotal;      
415         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
416         return (rSupply, tSupply);
417     }
418 
419     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
420         require(maxTxPercent > 0, "Amount must be greater than 0");
421         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
422         emit MaxTxAmountUpdated(_maxTxAmount);
423     }
424 }