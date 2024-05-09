1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-15
3 */
4 
5 /*
6 
7 
8  t.me/shibasta
9  Shiba Pasta
10  $SHIBASTA
11  
12  
13  Buon Appetito!
14  So delicious! 
15  
16                            ▒▒▒▒▒▒▒▒░░░░                        
17                       ░░░░▒▒▒▒▒▒▒▒▒▒░░        ████            
18               ████████▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒    ██▒▒▒▒██          
19             ██▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒░░▒▒▒▒██▒▒▒▒██            
20           ████▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒██            
21           ██▒▒██░░░░▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░██              
22             ██░░▒▒▒▒▒▒░░░░▒▒▒▒░░▒▒▒▒░░▒▒░░▒▒░░░░░░            
23         ████░░▒▒░░▒▒▒▒░░▒▒▒▒░░░░░░░░▒▒░░▒▒░░▒▒▒▒▒▒░░████      
24     ████░░░░░░░░▒▒░░░░▒▒░░░░░░░░░░▒▒░░▒▒░░░░░░░░░░▒▒░░░░████  
25   ██░░░░░░░░░░░░░░▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒░░▒▒░░▒▒▒▒░░▒▒░░░░░░░░░░░░██
26   ██░░░░░░░░░░░░▒▒░░░░▒▒░░░░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░░░░██
27     ██░░░░░░░░░░▒▒░░▒▒░░░░░░▒▒░░░░░░░░░░░░▒▒░░▒▒░░░░░░░░░░██  
28       ████░░░░░░░░░░▒▒░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░████    
29           ██████████░░░░░░░░░░░░░░░░░░░░░░░░██████████        
30               ██░░░░████████████████████████░░░░██            
31                 ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░██              
32                   ████████████████████████████                
33 
34  Fair launch!
35  No presale/team/dev tokens!
36  Designed and developed by the Shiba Ramen core team (@shibaramen)
37  LP Lock immediately on launch.
38  Ownership will be renounced 10 minutes after launch.
39  Slippage Recommended: 18%+
40  
41  Twitter: https://twitter.com/shibapastaofficial
42 
43  Telegram: https://t.me/shibasta
44 
45  Instagram: https://instagram.com/shibapastaofficial?utm_medium=copy_link
46  
47  Website: https://www.shibapasta.finance
48 
49  Reddit: https://www.reddit.com/r/ShibaPasta/
50 
51  SPDX-License-Identifier: Mines™®©
52 */
53 pragma solidity ^0.8.4;
54 
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address) {
57         return msg.sender;
58     }
59 }
60 
61 interface IERC20 {
62     function totalSupply() external view returns (uint256);
63     function balanceOf(address account) external view returns (uint256);
64     function transfer(address recipient, uint256 amount) external returns (bool);
65     function allowance(address owner, address spender) external view returns (uint256);
66     function approve(address spender, uint256 amount) external returns (bool);
67     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 library SafeMath {
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         uint256 c = a + b;
75         require(c >= a, "SafeMath: addition overflow");
76         return c;
77     }
78 
79     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
80         return sub(a, b, "SafeMath: subtraction overflow");
81     }
82 
83     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86         return c;
87     }
88 
89     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90         if (a == 0) {
91             return 0;
92         }
93         uint256 c = a * b;
94         require(c / a == b, "SafeMath: multiplication overflow");
95         return c;
96     }
97 
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         require(b > 0, errorMessage);
104         uint256 c = a / b;
105         return c;
106     }
107 
108 }
109 
110 contract Ownable is Context {
111     address private _owner;
112     address private _previousOwner;
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115     constructor () {
116         address msgSender = _msgSender();
117         _owner = msgSender;
118         emit OwnershipTransferred(address(0), msgSender);
119     }
120 
121     function owner() public view returns (address) {
122         return _owner;
123     }
124 
125     modifier onlyOwner() {
126         require(_owner == _msgSender(), "Ownable: caller is not the owner");
127         _;
128     }
129 
130     function renounceOwnership() public virtual onlyOwner {
131         emit OwnershipTransferred(_owner, address(0));
132         _owner = address(0);
133     }
134 
135 }  
136 
137 interface IUniswapV2Factory {
138     function createPair(address tokenA, address tokenB) external returns (address pair);
139 }
140 
141 interface IUniswapV2Router02 {
142     function swapExactTokensForETHSupportingFeeOnTransferTokens(
143         uint amountIn,
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external;
149     function factory() external pure returns (address);
150     function WETH() external pure returns (address);
151     function addLiquidityETH(
152         address token,
153         uint amountTokenDesired,
154         uint amountTokenMin,
155         uint amountETHMin,
156         address to,
157         uint deadline
158     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
159 }
160 
161 contract SHIBASTA is Context, IERC20, Ownable {
162     using SafeMath for uint256;
163     mapping (address => uint256) private _rOwned;
164     mapping (address => uint256) private _tOwned;
165     mapping (address => mapping (address => uint256)) private _allowances;
166     mapping (address => bool) private _isExcludedFromFee;
167     mapping (address => bool) private bots;
168     mapping (address => uint) private cooldown;
169     uint256 private constant MAX = ~uint256(0);
170     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
171     uint256 private _rTotal = (MAX - (MAX % _tTotal));
172     uint256 private _tFeeTotal;
173     string private constant _name = "Shiba Pasta";
174     string private constant _symbol = unicode'SHIBASTA🍝';
175     uint8 private constant _decimals = 9;
176     uint256 private _taxFee;
177     uint256 private _teamFee;
178     uint256 private _previousTaxFee = _taxFee;
179     uint256 private _previousteamFee = _teamFee;
180     address payable private _FeeAddress;
181     address payable private _marketingWalletAddress;
182     IUniswapV2Router02 private uniswapV2Router;
183     address private uniswapV2Pair;
184     bool private tradingOpen;
185     bool private inSwap = false;
186     bool private swapEnabled = false;
187     bool private cooldownEnabled = false;
188     uint256 private _maxTxAmount = _tTotal;
189     event MaxTxAmountUpdated(uint _maxTxAmount);
190     modifier lockTheSwap {
191         inSwap = true;
192         _;
193         inSwap = false;
194     }
195     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
196         _FeeAddress = FeeAddress;
197         _marketingWalletAddress = marketingWalletAddress;
198         _rOwned[_msgSender()] = _rTotal;
199         _isExcludedFromFee[owner()] = true;
200         _isExcludedFromFee[address(this)] = true;
201         _isExcludedFromFee[FeeAddress] = true;
202         _isExcludedFromFee[marketingWalletAddress] = true;
203         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
204     }
205 
206     function name() public pure returns (string memory) {
207         return _name;
208     }
209 
210     function symbol() public pure returns (string memory) {
211         return _symbol;
212     }
213 
214     function decimals() public pure returns (uint8) {
215         return _decimals;
216     }
217 
218     function totalSupply() public pure override returns (uint256) {
219         return _tTotal;
220     }
221 
222     function balanceOf(address account) public view override returns (uint256) {
223         return tokenFromReflection(_rOwned[account]);
224     }
225 
226     function transfer(address recipient, uint256 amount) public override returns (bool) {
227         _transfer(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     function allowance(address owner, address spender) public view override returns (uint256) {
232         return _allowances[owner][spender];
233     }
234 
235     function approve(address spender, uint256 amount) public override returns (bool) {
236         _approve(_msgSender(), spender, amount);
237         return true;
238     }
239 
240     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
241         _transfer(sender, recipient, amount);
242         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
243         return true;
244     }
245 
246     function setCooldownEnabled(bool onoff) external onlyOwner() {
247         cooldownEnabled = onoff;
248     }
249 
250     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
251         require(rAmount <= _rTotal, "Amount must be less than total reflections");
252         uint256 currentRate =  _getRate();
253         return rAmount.div(currentRate);
254     }
255 
256     function removeAllFee() private {
257         if(_taxFee == 0 && _teamFee == 0) return;
258         _previousTaxFee = _taxFee;
259         _previousteamFee = _teamFee;
260         _taxFee = 0;
261         _teamFee = 0;
262     }
263     
264     function restoreAllFee() private {
265         _taxFee = _previousTaxFee;
266         _teamFee = _previousteamFee;
267     }
268 
269     function _approve(address owner, address spender, uint256 amount) private {
270         require(owner != address(0), "ERC20: approve from the zero address");
271         require(spender != address(0), "ERC20: approve to the zero address");
272         _allowances[owner][spender] = amount;
273         emit Approval(owner, spender, amount);
274     }
275 
276     function _transfer(address from, address to, uint256 amount) private {
277         require(from != address(0), "ERC20: transfer from the zero address");
278         require(to != address(0), "ERC20: transfer to the zero address");
279         require(amount > 0, "Transfer amount must be greater than zero");
280         _taxFee = 5;
281         _teamFee = 10;
282         if (from != owner() && to != owner()) {
283             require(!bots[from] && !bots[to]);
284             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
285                 require(amount <= _maxTxAmount);
286                 require(cooldown[to] < block.timestamp);
287                 cooldown[to] = block.timestamp + (30 seconds);
288             }
289             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
290                 _taxFee = 5;
291                 _teamFee = 10;
292             }
293             uint256 contractTokenBalance = balanceOf(address(this));
294             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
295                 swapTokensForEth(contractTokenBalance);
296                 uint256 contractETHBalance = address(this).balance;
297                 if(contractETHBalance > 0) {
298                     sendETHToFee(address(this).balance);
299                 }
300             }
301         }
302         bool takeFee = true;
303 
304         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
305             takeFee = false;
306         }
307 		
308         _tokenTransfer(from,to,amount,takeFee);
309     }
310 
311     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
312         address[] memory path = new address[](2);
313         path[0] = address(this);
314         path[1] = uniswapV2Router.WETH();
315         _approve(address(this), address(uniswapV2Router), tokenAmount);
316         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
317             tokenAmount,
318             0,
319             path,
320             address(this),
321             block.timestamp
322         );
323     }
324         
325     function sendETHToFee(uint256 amount) private {
326         _FeeAddress.transfer(amount.div(2));
327         _marketingWalletAddress.transfer(amount.div(2));
328     }
329     
330     function openTrading() external onlyOwner() {
331         require(!tradingOpen,"trading is already open");
332         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
333         uniswapV2Router = _uniswapV2Router;
334         _approve(address(this), address(uniswapV2Router), _tTotal);
335         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
336         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
337         swapEnabled = true;
338         cooldownEnabled = true;
339         _maxTxAmount = 100000000000000000 * 10**9;
340         tradingOpen = true;
341         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
342     }
343     
344     function setBots(address[] memory bots_) public onlyOwner {
345         for (uint i = 0; i < bots_.length; i++) {
346             bots[bots_[i]] = true;
347         }
348     }
349     
350     function delBot(address notbot) public onlyOwner {
351         bots[notbot] = false;
352     }
353         
354     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
355         if(!takeFee)
356             removeAllFee();
357         _transferStandard(sender, recipient, amount);
358         if(!takeFee)
359             restoreAllFee();
360     }
361 
362     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
363         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
364         _rOwned[sender] = _rOwned[sender].sub(rAmount);
365         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
366         _takeTeam(tTeam);
367         _reflectFee(rFee, tFee);
368         emit Transfer(sender, recipient, tTransferAmount);
369     }
370 
371     function _takeTeam(uint256 tTeam) private {
372         uint256 currentRate =  _getRate();
373         uint256 rTeam = tTeam.mul(currentRate);
374         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
375     }
376 
377     function _reflectFee(uint256 rFee, uint256 tFee) private {
378         _rTotal = _rTotal.sub(rFee);
379         _tFeeTotal = _tFeeTotal.add(tFee);
380     }
381 
382     receive() external payable {}
383     
384     function manualswap() external {
385         require(_msgSender() == _FeeAddress);
386         uint256 contractBalance = balanceOf(address(this));
387         swapTokensForEth(contractBalance);
388     }
389     
390     function manualsend() external {
391         require(_msgSender() == _FeeAddress);
392         uint256 contractETHBalance = address(this).balance;
393         sendETHToFee(contractETHBalance);
394     }
395     
396 
397     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
398         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
399         uint256 currentRate =  _getRate();
400         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
401         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
402     }
403 
404     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
405         uint256 tFee = tAmount.mul(taxFee).div(100);
406         uint256 tTeam = tAmount.mul(TeamFee).div(100);
407         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
408         return (tTransferAmount, tFee, tTeam);
409     }
410 
411     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
412         uint256 rAmount = tAmount.mul(currentRate);
413         uint256 rFee = tFee.mul(currentRate);
414         uint256 rTeam = tTeam.mul(currentRate);
415         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
416         return (rAmount, rTransferAmount, rFee);
417     }
418 
419 	function _getRate() private view returns(uint256) {
420         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
421         return rSupply.div(tSupply);
422     }
423 
424     function _getCurrentSupply() private view returns(uint256, uint256) {
425         uint256 rSupply = _rTotal;
426         uint256 tSupply = _tTotal;      
427         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
428         return (rSupply, tSupply);
429     }
430 
431     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
432         require(maxTxPercent > 0, "Amount must be greater than 0");
433         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
434         emit MaxTxAmountUpdated(_maxTxAmount);
435     }
436 }