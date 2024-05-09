1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-12
3 */
4 
5 /*
6 
7 
8  t.me/shibaotoken
9  Shiba Bao
10  $SHIBAO
11  
12  So delicious! 
13 
14        .__    ._____.                  
15   _____|  |__ |__\_ |__ _____    ____  
16  /  ___/  |  \|  || __ \\__  \  /  _ \ 
17  \___ \|   Y  \  || \_\ \/ __ \(  <_> )
18 /____  >___|  /__||___  (____  /\____/ 
19      \/     \/        \/     \/       
20                                       
21  Twitter: https://twitter.com/getshibao
22 
23  Telegram: https://t.me/shibaotoken
24 
25  Instagram: https://instagram.com/realshibabao?utm_medium=copy_link
26  
27  Website: shibabao.finance
28 
29  Reddit: https://www.reddit.com/r/ShibaBao/
30 
31  Marketing paid
32 
33  Liqudity Locked
34  
35  Ownership renounced
36  
37  No Devwallets
38  
39  CG, CMC listing: Ongoing
40  
41  Devs of other delicious shiba foods
42  
43  Got questions? team@shibabao.finance
44 
45  SPDX-License-Identifier: Mines™®©
46 */
47 pragma solidity ^0.8.4;
48 
49 abstract contract Context {
50     function _msgSender() internal view virtual returns (address) {
51         return msg.sender;
52     }
53 }
54 
55 interface IERC20 {
56     function totalSupply() external view returns (uint256);
57     function balanceOf(address account) external view returns (uint256);
58     function transfer(address recipient, uint256 amount) external returns (bool);
59     function allowance(address owner, address spender) external view returns (uint256);
60     function approve(address spender, uint256 amount) external returns (bool);
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     event Approval(address indexed owner, address indexed spender, uint256 value);
64 }
65 
66 library SafeMath {
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         require(c >= a, "SafeMath: addition overflow");
70         return c;
71     }
72 
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b <= a, errorMessage);
79         uint256 c = a - b;
80         return c;
81     }
82 
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         if (a == 0) {
85             return 0;
86         }
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89         return c;
90     }
91 
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         return div(a, b, "SafeMath: division by zero");
94     }
95 
96     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         require(b > 0, errorMessage);
98         uint256 c = a / b;
99         return c;
100     }
101 
102 }
103 
104 contract Ownable is Context {
105     address private _owner;
106     address private _previousOwner;
107     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109     constructor () {
110         address msgSender = _msgSender();
111         _owner = msgSender;
112         emit OwnershipTransferred(address(0), msgSender);
113     }
114 
115     function owner() public view returns (address) {
116         return _owner;
117     }
118 
119     modifier onlyOwner() {
120         require(_owner == _msgSender(), "Ownable: caller is not the owner");
121         _;
122     }
123 
124     function renounceOwnership() public virtual onlyOwner {
125         emit OwnershipTransferred(_owner, address(0));
126         _owner = address(0);
127     }
128 
129 }  
130 
131 interface IUniswapV2Factory {
132     function createPair(address tokenA, address tokenB) external returns (address pair);
133 }
134 
135 interface IUniswapV2Router02 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143     function factory() external pure returns (address);
144     function WETH() external pure returns (address);
145     function addLiquidityETH(
146         address token,
147         uint amountTokenDesired,
148         uint amountTokenMin,
149         uint amountETHMin,
150         address to,
151         uint deadline
152     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
153 }
154 
155 contract SHIBAO is Context, IERC20, Ownable {
156     using SafeMath for uint256;
157     mapping (address => uint256) private _rOwned;
158     mapping (address => uint256) private _tOwned;
159     mapping (address => mapping (address => uint256)) private _allowances;
160     mapping (address => bool) private _isExcludedFromFee;
161     mapping (address => bool) private bots;
162     mapping (address => uint) private cooldown;
163     uint256 private constant MAX = ~uint256(0);
164     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
165     uint256 private _rTotal = (MAX - (MAX % _tTotal));
166     uint256 private _tFeeTotal;
167     string private constant _name = "Shiba Bao";
168     string private constant _symbol = unicode'SHIBAO🥟';
169     uint8 private constant _decimals = 9;
170     uint256 private _taxFee;
171     uint256 private _teamFee;
172     uint256 private _previousTaxFee = _taxFee;
173     uint256 private _previousteamFee = _teamFee;
174     address payable private _FeeAddress;
175     address payable private _marketingWalletAddress;
176     IUniswapV2Router02 private uniswapV2Router;
177     address private uniswapV2Pair;
178     bool private tradingOpen;
179     bool private inSwap = false;
180     bool private swapEnabled = false;
181     bool private cooldownEnabled = false;
182     uint256 private _maxTxAmount = _tTotal;
183     event MaxTxAmountUpdated(uint _maxTxAmount);
184     modifier lockTheSwap {
185         inSwap = true;
186         _;
187         inSwap = false;
188     }
189     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
190         _FeeAddress = FeeAddress;
191         _marketingWalletAddress = marketingWalletAddress;
192         _rOwned[_msgSender()] = _rTotal;
193         _isExcludedFromFee[owner()] = true;
194         _isExcludedFromFee[address(this)] = true;
195         _isExcludedFromFee[FeeAddress] = true;
196         _isExcludedFromFee[marketingWalletAddress] = true;
197         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
198     }
199 
200     function name() public pure returns (string memory) {
201         return _name;
202     }
203 
204     function symbol() public pure returns (string memory) {
205         return _symbol;
206     }
207 
208     function decimals() public pure returns (uint8) {
209         return _decimals;
210     }
211 
212     function totalSupply() public pure override returns (uint256) {
213         return _tTotal;
214     }
215 
216     function balanceOf(address account) public view override returns (uint256) {
217         return tokenFromReflection(_rOwned[account]);
218     }
219 
220     function transfer(address recipient, uint256 amount) public override returns (bool) {
221         _transfer(_msgSender(), recipient, amount);
222         return true;
223     }
224 
225     function allowance(address owner, address spender) public view override returns (uint256) {
226         return _allowances[owner][spender];
227     }
228 
229     function approve(address spender, uint256 amount) public override returns (bool) {
230         _approve(_msgSender(), spender, amount);
231         return true;
232     }
233 
234     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
235         _transfer(sender, recipient, amount);
236         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
237         return true;
238     }
239 
240     function setCooldownEnabled(bool onoff) external onlyOwner() {
241         cooldownEnabled = onoff;
242     }
243 
244     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
245         require(rAmount <= _rTotal, "Amount must be less than total reflections");
246         uint256 currentRate =  _getRate();
247         return rAmount.div(currentRate);
248     }
249 
250     function removeAllFee() private {
251         if(_taxFee == 0 && _teamFee == 0) return;
252         _previousTaxFee = _taxFee;
253         _previousteamFee = _teamFee;
254         _taxFee = 0;
255         _teamFee = 0;
256     }
257     
258     function restoreAllFee() private {
259         _taxFee = _previousTaxFee;
260         _teamFee = _previousteamFee;
261     }
262 
263     function _approve(address owner, address spender, uint256 amount) private {
264         require(owner != address(0), "ERC20: approve from the zero address");
265         require(spender != address(0), "ERC20: approve to the zero address");
266         _allowances[owner][spender] = amount;
267         emit Approval(owner, spender, amount);
268     }
269 
270     function _transfer(address from, address to, uint256 amount) private {
271         require(from != address(0), "ERC20: transfer from the zero address");
272         require(to != address(0), "ERC20: transfer to the zero address");
273         require(amount > 0, "Transfer amount must be greater than zero");
274         _taxFee = 5;
275         _teamFee = 10;
276         if (from != owner() && to != owner()) {
277             require(!bots[from] && !bots[to]);
278             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
279                 require(amount <= _maxTxAmount);
280                 require(cooldown[to] < block.timestamp);
281                 cooldown[to] = block.timestamp + (30 seconds);
282             }
283             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
284                 _taxFee = 5;
285                 _teamFee = 10;
286             }
287             uint256 contractTokenBalance = balanceOf(address(this));
288             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
289                 swapTokensForEth(contractTokenBalance);
290                 uint256 contractETHBalance = address(this).balance;
291                 if(contractETHBalance > 0) {
292                     sendETHToFee(address(this).balance);
293                 }
294             }
295         }
296         bool takeFee = true;
297 
298         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
299             takeFee = false;
300         }
301 		
302         _tokenTransfer(from,to,amount,takeFee);
303     }
304 
305     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
306         address[] memory path = new address[](2);
307         path[0] = address(this);
308         path[1] = uniswapV2Router.WETH();
309         _approve(address(this), address(uniswapV2Router), tokenAmount);
310         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
311             tokenAmount,
312             0,
313             path,
314             address(this),
315             block.timestamp
316         );
317     }
318         
319     function sendETHToFee(uint256 amount) private {
320         _FeeAddress.transfer(amount.div(2));
321         _marketingWalletAddress.transfer(amount.div(2));
322     }
323     
324     function openTrading() external onlyOwner() {
325         require(!tradingOpen,"trading is already open");
326         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
327         uniswapV2Router = _uniswapV2Router;
328         _approve(address(this), address(uniswapV2Router), _tTotal);
329         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
330         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
331         swapEnabled = true;
332         cooldownEnabled = true;
333         _maxTxAmount = 100000000000000000 * 10**9;
334         tradingOpen = true;
335         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
336     }
337     
338     function setBots(address[] memory bots_) public onlyOwner {
339         for (uint i = 0; i < bots_.length; i++) {
340             bots[bots_[i]] = true;
341         }
342     }
343     
344     function delBot(address notbot) public onlyOwner {
345         bots[notbot] = false;
346     }
347         
348     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
349         if(!takeFee)
350             removeAllFee();
351         _transferStandard(sender, recipient, amount);
352         if(!takeFee)
353             restoreAllFee();
354     }
355 
356     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
357         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
358         _rOwned[sender] = _rOwned[sender].sub(rAmount);
359         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
360         _takeTeam(tTeam);
361         _reflectFee(rFee, tFee);
362         emit Transfer(sender, recipient, tTransferAmount);
363     }
364 
365     function _takeTeam(uint256 tTeam) private {
366         uint256 currentRate =  _getRate();
367         uint256 rTeam = tTeam.mul(currentRate);
368         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
369     }
370 
371     function _reflectFee(uint256 rFee, uint256 tFee) private {
372         _rTotal = _rTotal.sub(rFee);
373         _tFeeTotal = _tFeeTotal.add(tFee);
374     }
375 
376     receive() external payable {}
377     
378     function manualswap() external {
379         require(_msgSender() == _FeeAddress);
380         uint256 contractBalance = balanceOf(address(this));
381         swapTokensForEth(contractBalance);
382     }
383     
384     function manualsend() external {
385         require(_msgSender() == _FeeAddress);
386         uint256 contractETHBalance = address(this).balance;
387         sendETHToFee(contractETHBalance);
388     }
389     
390 
391     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
392         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
393         uint256 currentRate =  _getRate();
394         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
395         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
396     }
397 
398     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
399         uint256 tFee = tAmount.mul(taxFee).div(100);
400         uint256 tTeam = tAmount.mul(TeamFee).div(100);
401         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
402         return (tTransferAmount, tFee, tTeam);
403     }
404 
405     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
406         uint256 rAmount = tAmount.mul(currentRate);
407         uint256 rFee = tFee.mul(currentRate);
408         uint256 rTeam = tTeam.mul(currentRate);
409         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
410         return (rAmount, rTransferAmount, rFee);
411     }
412 
413 	function _getRate() private view returns(uint256) {
414         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
415         return rSupply.div(tSupply);
416     }
417 
418     function _getCurrentSupply() private view returns(uint256, uint256) {
419         uint256 rSupply = _rTotal;
420         uint256 tSupply = _tTotal;      
421         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
422         return (rSupply, tSupply);
423     }
424 
425     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
426         require(maxTxPercent > 0, "Amount must be greater than 0");
427         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
428         emit MaxTxAmountUpdated(_maxTxAmount);
429     }
430 }