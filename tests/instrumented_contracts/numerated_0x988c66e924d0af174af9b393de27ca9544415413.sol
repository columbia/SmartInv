1 /*
2                                      o
3                                    $""$o
4                                   $"  $$
5                                    $$$$
6                                    o "$o
7                                   o"  "$
8              oo"$$$"  oo$"$ooo   o$    "$    ooo"$oo  $$$"o
9 o o o o    oo"  o"      "o    $$o$"     o o$""  o$      "$  "oo   o o o o
10 "$o   ""$$$"   $$         $      "   o   ""    o"         $   "o$$"    o$$
11   ""o       o  $          $"       $$$$$       o          $  ooo     o""
12      "o   $$$$o $o       o$        $$$$$"       $o        " $$$$   o"
13       ""o $$$$o  oo o  o$"         $$$$$"        "o o o o"  "$$$  $
14         "" "$"     """""            ""$"            """      """ "
15          "oooooooooooooo  Ethereum King | $EKING  oooooooooooooo$
16           "$$$$"$$$$" $$$$$$$"$$$$$$ " "$$$$$"$$$$$$"  $$$""$$$$
17            $$$oo$$$$   $$$$$$o$$$$$$o" $$$$$$$$$$$$$$ o$$$$o$$$"
18            $"""""""""""""""""""""""""""""""""""""""""""""""""""$
19            $"                                                 "$
20            $"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$"$
21  
22  
23              Ethereum King | $EKING 👑 .... The one true king
24              
25              Join our telegram
26              
27              https://t.me/ethereumking1
28            
29           
30            
31 
32 SPDX-License-Identifier:
33 */
34 pragma solidity ^0.8.4;
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 }
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44     function balanceOf(address account) external view returns (uint256);
45     function transfer(address recipient, uint256 amount) external returns (bool);
46     function allowance(address owner, address spender) external view returns (uint256);
47     function approve(address spender, uint256 amount) external returns (bool);
48     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 library SafeMath {
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57         return c;
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67         return c;
68     }
69 
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         if (a == 0) {
72             return 0;
73         }
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76         return c;
77     }
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b > 0, errorMessage);
85         uint256 c = a / b;
86         return c;
87     }
88 
89 }
90 
91 contract Ownable is Context {
92     address private _owner;
93     address private _previousOwner;
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96     constructor () {
97         address msgSender = _msgSender();
98         _owner = msgSender;
99         emit OwnershipTransferred(address(0), msgSender);
100     }
101 
102     function owner() public view returns (address) {
103         return _owner;
104     }
105 
106     modifier onlyOwner() {
107         require(_owner == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110 
111     function renounceOwnership() public virtual onlyOwner {
112         emit OwnershipTransferred(_owner, address(0));
113         _owner = address(0);
114     }
115 
116 }  
117 
118 interface IUniswapV2Factory {
119     function createPair(address tokenA, address tokenB) external returns (address pair);
120 }
121 
122 interface IUniswapV2Router02 {
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130     function factory() external pure returns (address);
131     function WETH() external pure returns (address);
132     function addLiquidityETH(
133         address token,
134         uint amountTokenDesired,
135         uint amountTokenMin,
136         uint amountETHMin,
137         address to,
138         uint deadline
139     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
140 }
141 
142 contract EKING is Context, IERC20, Ownable {
143     using SafeMath for uint256;
144     mapping (address => uint256) private _rOwned;
145     mapping (address => uint256) private _tOwned;
146     mapping (address => mapping (address => uint256)) private _allowances;
147     mapping (address => bool) private _isExcludedFromFee;
148     mapping (address => bool) private bots;
149     mapping (address => uint) private cooldown;
150     uint256 private constant MAX = ~uint256(0);
151     uint256 private constant _tTotal = 1e12 * 10**9;
152     uint256 private _rTotal = (MAX - (MAX % _tTotal));
153     uint256 private _tFeeTotal;
154     string private constant _name = unicode"Ethereum King";
155     string private constant _symbol = 'EKING';
156     uint8 private constant _decimals = 9;
157     uint256 private _taxFee;
158     uint256 private _teamFee;
159     uint256 private _previousTaxFee = _taxFee;
160     uint256 private _previousteamFee = _teamFee;
161     address payable private _FeeAddress;
162     address payable private _marketingWalletAddress;
163     IUniswapV2Router02 private uniswapV2Router;
164     address private uniswapV2Pair;
165     bool private tradingOpen;
166     bool private inSwap = false;
167     bool private swapEnabled = false;
168     bool private cooldownEnabled = false;
169     uint256 private _maxTxAmount = _tTotal;
170     event MaxTxAmountUpdated(uint _maxTxAmount);
171     modifier lockTheSwap {
172         inSwap = true;
173         _;
174         inSwap = false;
175     }
176     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
177         _FeeAddress = FeeAddress;
178         _marketingWalletAddress = marketingWalletAddress;
179         _rOwned[_msgSender()] = _rTotal;
180         _isExcludedFromFee[owner()] = true;
181         _isExcludedFromFee[address(this)] = true;
182         _isExcludedFromFee[FeeAddress] = true;
183         _isExcludedFromFee[marketingWalletAddress] = true;
184         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
185     }
186 
187     function name() public pure returns (string memory) {
188         return _name;
189     }
190 
191     function symbol() public pure returns (string memory) {
192         return _symbol;
193     }
194 
195     function decimals() public pure returns (uint8) {
196         return _decimals;
197     }
198 
199     function totalSupply() public pure override returns (uint256) {
200         return _tTotal;
201     }
202 
203     function balanceOf(address account) public view override returns (uint256) {
204         return tokenFromReflection(_rOwned[account]);
205     }
206 
207     function transfer(address recipient, uint256 amount) public override returns (bool) {
208         _transfer(_msgSender(), recipient, amount);
209         return true;
210     }
211 
212     function allowance(address owner, address spender) public view override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     function approve(address spender, uint256 amount) public override returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
222         _transfer(sender, recipient, amount);
223         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
224         return true;
225     }
226 
227     function setCooldownEnabled(bool onoff) external onlyOwner() {
228         cooldownEnabled = onoff;
229     }
230 
231     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
232         require(rAmount <= _rTotal, "Amount must be less than total reflections");
233         uint256 currentRate =  _getRate();
234         return rAmount.div(currentRate);
235     }
236 
237     function removeAllFee() private {
238         if(_taxFee == 0 && _teamFee == 0) return;
239         _previousTaxFee = _taxFee;
240         _previousteamFee = _teamFee;
241         _taxFee = 0;
242         _teamFee = 0;
243     }
244     
245     function restoreAllFee() private {
246         _taxFee = _previousTaxFee;
247         _teamFee = _previousteamFee;
248     }
249 
250     function _approve(address owner, address spender, uint256 amount) private {
251         require(owner != address(0), "ERC20: approve from the zero address");
252         require(spender != address(0), "ERC20: approve to the zero address");
253         _allowances[owner][spender] = amount;
254         emit Approval(owner, spender, amount);
255     }
256 
257     function _transfer(address from, address to, uint256 amount) private {
258         require(from != address(0), "ERC20: transfer from the zero address");
259         require(to != address(0), "ERC20: transfer to the zero address");
260         require(amount > 0, "Transfer amount must be greater than zero");
261         _taxFee = 7;
262         _teamFee = 8;
263         if (from != owner() && to != owner()) {
264             require(!bots[from] && !bots[to]);
265             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
266                 require(amount <= _maxTxAmount);
267                 require(cooldown[to] < block.timestamp);
268                 cooldown[to] = block.timestamp + (30 seconds);
269             }
270             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
271                 _taxFee = 15;
272                 _teamFee = 15;
273             }
274             uint256 contractTokenBalance = balanceOf(address(this));
275             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
276                 swapTokensForEth(contractTokenBalance);
277                 uint256 contractETHBalance = address(this).balance;
278                 if(contractETHBalance > 0) {
279                     sendETHToFee(address(this).balance);
280                 }
281             }
282         }
283         bool takeFee = true;
284 
285         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
286             takeFee = false;
287         }
288 		
289         _tokenTransfer(from,to,amount,takeFee);
290     }
291 
292     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
293         address[] memory path = new address[](2);
294         path[0] = address(this);
295         path[1] = uniswapV2Router.WETH();
296         _approve(address(this), address(uniswapV2Router), tokenAmount);
297         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
298             tokenAmount,
299             0,
300             path,
301             address(this),
302             block.timestamp
303         );
304     }
305         
306     function sendETHToFee(uint256 amount) private {
307         _FeeAddress.transfer(amount.div(2));
308         _marketingWalletAddress.transfer(amount.div(2));
309     }
310     
311     function openTrading() external onlyOwner() {
312         require(!tradingOpen,"trading is already open");
313         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
314         uniswapV2Router = _uniswapV2Router;
315         _approve(address(this), address(uniswapV2Router), _tTotal);
316         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
317         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
318         swapEnabled = true;
319         cooldownEnabled = true;
320         _maxTxAmount = 4.25e9 * 10**9;
321         tradingOpen = true;
322         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
323     }
324     
325     function setBots(address[] memory bots_) public onlyOwner {
326         for (uint i = 0; i < bots_.length; i++) {
327             bots[bots_[i]] = true;
328         }
329     }
330     
331     function delBot(address notbot) public onlyOwner {
332         bots[notbot] = false;
333     }
334         
335     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
336         if(!takeFee)
337             removeAllFee();
338         _transferStandard(sender, recipient, amount);
339         if(!takeFee)
340             restoreAllFee();
341     }
342 
343     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
344         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
345         _rOwned[sender] = _rOwned[sender].sub(rAmount);
346         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
347         _takeTeam(tTeam);
348         _reflectFee(rFee, tFee);
349         emit Transfer(sender, recipient, tTransferAmount);
350     }
351 
352     function _takeTeam(uint256 tTeam) private {
353         uint256 currentRate =  _getRate();
354         uint256 rTeam = tTeam.mul(currentRate);
355         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
356     }
357 
358     function _reflectFee(uint256 rFee, uint256 tFee) private {
359         _rTotal = _rTotal.sub(rFee);
360         _tFeeTotal = _tFeeTotal.add(tFee);
361     }
362 
363     receive() external payable {}
364     
365     function manualswap() external {
366         require(_msgSender() == _FeeAddress);
367         uint256 contractBalance = balanceOf(address(this));
368         swapTokensForEth(contractBalance);
369     }
370     
371     function manualsend() external {
372         require(_msgSender() == _FeeAddress);
373         uint256 contractETHBalance = address(this).balance;
374         sendETHToFee(contractETHBalance);
375     }
376     
377 
378     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
379         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
380         uint256 currentRate =  _getRate();
381         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
382         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
383     }
384 
385     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
386         uint256 tFee = tAmount.mul(taxFee).div(100);
387         uint256 tTeam = tAmount.mul(TeamFee).div(100);
388         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
389         return (tTransferAmount, tFee, tTeam);
390     }
391 
392     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
393         uint256 rAmount = tAmount.mul(currentRate);
394         uint256 rFee = tFee.mul(currentRate);
395         uint256 rTeam = tTeam.mul(currentRate);
396         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
397         return (rAmount, rTransferAmount, rFee);
398     }
399 
400 	function _getRate() private view returns(uint256) {
401         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
402         return rSupply.div(tSupply);
403     }
404 
405     function _getCurrentSupply() private view returns(uint256, uint256) {
406         uint256 rSupply = _rTotal;
407         uint256 tSupply = _tTotal;      
408         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
409         return (rSupply, tSupply);
410     }
411 
412     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
413         require(maxTxPercent > 0, "Amount must be greater than 0");
414         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
415         emit MaxTxAmountUpdated(_maxTxAmount);
416     }
417 }