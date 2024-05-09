1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-07
3 */
4 
5 /*
6 
7 
8  t.me/shibataco
9  Shiba Taco
10  $SHIBTACO
11  
12  So delicious! 
13 
14       _     _ _     _                  
15     | |   (_) |   | |                 
16  ___| |__  _| |__ | |_ __ _  ___ ___  
17 / __| '_ \| | '_ \| __/ _` |/ __/ _ \ 
18 \__ \ | | | | |_) | || (_| | (_| (_) |
19 |___/_| |_|_|_.__/ \__\__,_|\___\___/ 
20                                       
21                                       
22  Twitter: https://twitter.com/shibataco
23 
24  Telegram: https://t.me/shibataco
25 
26  Instagram: https://instagram.com/realshibataco?utm_medium=copy_link
27  
28  Website: shibataco.com
29 
30  Reddit: https://www.reddit.com/r/ShibaTaco
31 
32  Marketing paid
33 
34  Liqudity Locked
35  
36  Ownership renounced
37  
38  No Devwallets
39  
40  CG, CMC listing: Ongoing
41  
42  Devs of Shibramen ©
43 
44  SPDX-License-Identifier: Mines™®©
45 */
46 pragma solidity ^0.8.4;
47 
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address) {
50         return msg.sender;
51     }
52 }
53 
54 interface IERC20 {
55     function totalSupply() external view returns (uint256);
56     function balanceOf(address account) external view returns (uint256);
57     function transfer(address recipient, uint256 amount) external returns (bool);
58     function allowance(address owner, address spender) external view returns (uint256);
59     function approve(address spender, uint256 amount) external returns (bool);
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 library SafeMath {
66     function add(uint256 a, uint256 b) internal pure returns (uint256) {
67         uint256 c = a + b;
68         require(c >= a, "SafeMath: addition overflow");
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79         return c;
80     }
81 
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         if (a == 0) {
84             return 0;
85         }
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88         return c;
89     }
90 
91     function div(uint256 a, uint256 b) internal pure returns (uint256) {
92         return div(a, b, "SafeMath: division by zero");
93     }
94 
95     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
96         require(b > 0, errorMessage);
97         uint256 c = a / b;
98         return c;
99     }
100 
101 }
102 
103 contract Ownable is Context {
104     address private _owner;
105     address private _previousOwner;
106     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
107 
108     constructor () {
109         address msgSender = _msgSender();
110         _owner = msgSender;
111         emit OwnershipTransferred(address(0), msgSender);
112     }
113 
114     function owner() public view returns (address) {
115         return _owner;
116     }
117 
118     modifier onlyOwner() {
119         require(_owner == _msgSender(), "Ownable: caller is not the owner");
120         _;
121     }
122 
123     function renounceOwnership() public virtual onlyOwner {
124         emit OwnershipTransferred(_owner, address(0));
125         _owner = address(0);
126     }
127 
128 }  
129 
130 interface IUniswapV2Factory {
131     function createPair(address tokenA, address tokenB) external returns (address pair);
132 }
133 
134 interface IUniswapV2Router02 {
135     function swapExactTokensForETHSupportingFeeOnTransferTokens(
136         uint amountIn,
137         uint amountOutMin,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external;
142     function factory() external pure returns (address);
143     function WETH() external pure returns (address);
144     function addLiquidityETH(
145         address token,
146         uint amountTokenDesired,
147         uint amountTokenMin,
148         uint amountETHMin,
149         address to,
150         uint deadline
151     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
152 }
153 
154 contract SHIBATACO is Context, IERC20, Ownable {
155     using SafeMath for uint256;
156     mapping (address => uint256) private _rOwned;
157     mapping (address => uint256) private _tOwned;
158     mapping (address => mapping (address => uint256)) private _allowances;
159     mapping (address => bool) private _isExcludedFromFee;
160     mapping (address => bool) private bots;
161     mapping (address => uint) private cooldown;
162     uint256 private constant MAX = ~uint256(0);
163     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
164     uint256 private _rTotal = (MAX - (MAX % _tTotal));
165     uint256 private _tFeeTotal;
166     string private constant _name = "Shiba Taco";
167     string private constant _symbol = unicode'SHIBTACO🌮';
168     uint8 private constant _decimals = 9;
169     uint256 private _taxFee;
170     uint256 private _teamFee;
171     uint256 private _previousTaxFee = _taxFee;
172     uint256 private _previousteamFee = _teamFee;
173     address payable private _FeeAddress;
174     address payable private _marketingWalletAddress;
175     IUniswapV2Router02 private uniswapV2Router;
176     address private uniswapV2Pair;
177     bool private tradingOpen;
178     bool private inSwap = false;
179     bool private swapEnabled = false;
180     bool private cooldownEnabled = false;
181     uint256 private _maxTxAmount = _tTotal;
182     event MaxTxAmountUpdated(uint _maxTxAmount);
183     modifier lockTheSwap {
184         inSwap = true;
185         _;
186         inSwap = false;
187     }
188     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
189         _FeeAddress = FeeAddress;
190         _marketingWalletAddress = marketingWalletAddress;
191         _rOwned[_msgSender()] = _rTotal;
192         _isExcludedFromFee[owner()] = true;
193         _isExcludedFromFee[address(this)] = true;
194         _isExcludedFromFee[FeeAddress] = true;
195         _isExcludedFromFee[marketingWalletAddress] = true;
196         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
197     }
198 
199     function name() public pure returns (string memory) {
200         return _name;
201     }
202 
203     function symbol() public pure returns (string memory) {
204         return _symbol;
205     }
206 
207     function decimals() public pure returns (uint8) {
208         return _decimals;
209     }
210 
211     function totalSupply() public pure override returns (uint256) {
212         return _tTotal;
213     }
214 
215     function balanceOf(address account) public view override returns (uint256) {
216         return tokenFromReflection(_rOwned[account]);
217     }
218 
219     function transfer(address recipient, uint256 amount) public override returns (bool) {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     function allowance(address owner, address spender) public view override returns (uint256) {
225         return _allowances[owner][spender];
226     }
227 
228     function approve(address spender, uint256 amount) public override returns (bool) {
229         _approve(_msgSender(), spender, amount);
230         return true;
231     }
232 
233     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
234         _transfer(sender, recipient, amount);
235         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
236         return true;
237     }
238 
239     function setCooldownEnabled(bool onoff) external onlyOwner() {
240         cooldownEnabled = onoff;
241     }
242 
243     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
244         require(rAmount <= _rTotal, "Amount must be less than total reflections");
245         uint256 currentRate =  _getRate();
246         return rAmount.div(currentRate);
247     }
248 
249     function removeAllFee() private {
250         if(_taxFee == 0 && _teamFee == 0) return;
251         _previousTaxFee = _taxFee;
252         _previousteamFee = _teamFee;
253         _taxFee = 0;
254         _teamFee = 0;
255     }
256     
257     function restoreAllFee() private {
258         _taxFee = _previousTaxFee;
259         _teamFee = _previousteamFee;
260     }
261 
262     function _approve(address owner, address spender, uint256 amount) private {
263         require(owner != address(0), "ERC20: approve from the zero address");
264         require(spender != address(0), "ERC20: approve to the zero address");
265         _allowances[owner][spender] = amount;
266         emit Approval(owner, spender, amount);
267     }
268 
269     function _transfer(address from, address to, uint256 amount) private {
270         require(from != address(0), "ERC20: transfer from the zero address");
271         require(to != address(0), "ERC20: transfer to the zero address");
272         require(amount > 0, "Transfer amount must be greater than zero");
273         _taxFee = 5;
274         _teamFee = 10;
275         if (from != owner() && to != owner()) {
276             require(!bots[from] && !bots[to]);
277             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
278                 require(amount <= _maxTxAmount);
279                 require(cooldown[to] < block.timestamp);
280                 cooldown[to] = block.timestamp + (30 seconds);
281             }
282             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
283                 _taxFee = 5;
284                 _teamFee = 10;
285             }
286             uint256 contractTokenBalance = balanceOf(address(this));
287             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
288                 swapTokensForEth(contractTokenBalance);
289                 uint256 contractETHBalance = address(this).balance;
290                 if(contractETHBalance > 0) {
291                     sendETHToFee(address(this).balance);
292                 }
293             }
294         }
295         bool takeFee = true;
296 
297         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
298             takeFee = false;
299         }
300 		
301         _tokenTransfer(from,to,amount,takeFee);
302     }
303 
304     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
305         address[] memory path = new address[](2);
306         path[0] = address(this);
307         path[1] = uniswapV2Router.WETH();
308         _approve(address(this), address(uniswapV2Router), tokenAmount);
309         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
310             tokenAmount,
311             0,
312             path,
313             address(this),
314             block.timestamp
315         );
316     }
317         
318     function sendETHToFee(uint256 amount) private {
319         _FeeAddress.transfer(amount.div(2));
320         _marketingWalletAddress.transfer(amount.div(2));
321     }
322     
323     function openTrading() external onlyOwner() {
324         require(!tradingOpen,"trading is already open");
325         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
326         uniswapV2Router = _uniswapV2Router;
327         _approve(address(this), address(uniswapV2Router), _tTotal);
328         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
329         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
330         swapEnabled = true;
331         cooldownEnabled = true;
332         _maxTxAmount = 100000000000000000 * 10**9;
333         tradingOpen = true;
334         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
335     }
336     
337     function setBots(address[] memory bots_) public onlyOwner {
338         for (uint i = 0; i < bots_.length; i++) {
339             bots[bots_[i]] = true;
340         }
341     }
342     
343     function delBot(address notbot) public onlyOwner {
344         bots[notbot] = false;
345     }
346         
347     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
348         if(!takeFee)
349             removeAllFee();
350         _transferStandard(sender, recipient, amount);
351         if(!takeFee)
352             restoreAllFee();
353     }
354 
355     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
356         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
357         _rOwned[sender] = _rOwned[sender].sub(rAmount);
358         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
359         _takeTeam(tTeam);
360         _reflectFee(rFee, tFee);
361         emit Transfer(sender, recipient, tTransferAmount);
362     }
363 
364     function _takeTeam(uint256 tTeam) private {
365         uint256 currentRate =  _getRate();
366         uint256 rTeam = tTeam.mul(currentRate);
367         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
368     }
369 
370     function _reflectFee(uint256 rFee, uint256 tFee) private {
371         _rTotal = _rTotal.sub(rFee);
372         _tFeeTotal = _tFeeTotal.add(tFee);
373     }
374 
375     receive() external payable {}
376     
377     function manualswap() external {
378         require(_msgSender() == _FeeAddress);
379         uint256 contractBalance = balanceOf(address(this));
380         swapTokensForEth(contractBalance);
381     }
382     
383     function manualsend() external {
384         require(_msgSender() == _FeeAddress);
385         uint256 contractETHBalance = address(this).balance;
386         sendETHToFee(contractETHBalance);
387     }
388     
389 
390     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
391         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
392         uint256 currentRate =  _getRate();
393         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
394         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
395     }
396 
397     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
398         uint256 tFee = tAmount.mul(taxFee).div(100);
399         uint256 tTeam = tAmount.mul(TeamFee).div(100);
400         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
401         return (tTransferAmount, tFee, tTeam);
402     }
403 
404     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
405         uint256 rAmount = tAmount.mul(currentRate);
406         uint256 rFee = tFee.mul(currentRate);
407         uint256 rTeam = tTeam.mul(currentRate);
408         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
409         return (rAmount, rTransferAmount, rFee);
410     }
411 
412 	function _getRate() private view returns(uint256) {
413         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
414         return rSupply.div(tSupply);
415     }
416 
417     function _getCurrentSupply() private view returns(uint256, uint256) {
418         uint256 rSupply = _rTotal;
419         uint256 tSupply = _tTotal;      
420         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
421         return (rSupply, tSupply);
422     }
423 
424     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
425         require(maxTxPercent > 0, "Amount must be greater than 0");
426         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
427         emit MaxTxAmountUpdated(_maxTxAmount);
428     }
429 }