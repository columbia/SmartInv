1 /*
2             
3                                                                   
4         .-".'                      .--.            _..._    
5       .' .'                     .'    \       .-""  __ ""-. 
6      /  /                     .'       : --..:__.-""  ""-. \
7     :  :                     /         ;.d$$    sbp_.-""-:_:
8     ;  :                    : ._       :P .-.   ,"TP        
9     :   \                    \  T--...-; : d$b  :d$b        
10      \   `.                   \  `..'    ; $ $  ;$ $        
11       `.   "-.                 ).        : T$P  :T$P        
12         \..---^..             /           `-'    `._`._     
13        .'        "-.       .-"                     T$$$b    
14       /             "-._.-"               ._        '^' ;   
15      :                                    \.`.         /    
16      ;                                -.   \`."-._.-'-'     
17     :                                 .'\   \ \ \ \         
18     ;  ;                             /:  \   \ \ . ;        
19    :   :                            ,  ;  `.  `.;  :        
20    ;    \        ;                     ;    "-._:  ;        
21   :      `.      :                     :         \/         
22   ;       /"-.    ;                    :                    
23  :       /    "-. :                  : ;                    
24  :     .'        T-;                 ; ;        
25  ;    :          ; ;                /  :        
26  ;    ;          : :              .'    ;       
27 :    :            ;:         _..-"\     :       
28 :     \           : ;       /      \     ;      
29 ;    . '.         '-;      /        ;    :      
30 ;  \  ; :           :     :         :    '-.      
31 '.._L.:-'           :     ;          ;    . `. 
32                      ;    :          :  \  ; :  
33                      :    '-..       '.._L.:-'  
34                       ;     , `.                
35                       :   \  ; :                
36                       '..__L.:-'  
37           
38           Welcome to Kishu Inus little brother eKISHU!
39           
40           Big anti bot measures taken prelaunch fuck them guys
41           
42           100% Fair Launch NO dev wallets or "Presale wallets"
43           
44           Buy limit at start will be 4,250,000,000 tokens then raised to 1% of supply then 100% this is done to prevent sniping of the entire pool at launch
45           
46           There will be a cooldown of 30 seconds at launch between buying/selling on each unique addy this is an antibot measure also don't mass buy it wont work
47           
48           The cooldown will be removed some time after launch
49           
50           DON'T panic not a honeypot :p you'll be able to sell after 30 seconds 
51           
52           Join the telegram for more info 
53           
54           https://t.me/eKISHU1
55           
56           
57           
58           1,000,000,000,000 total supply
59           
60           15% burned (sent to dead address)
61           
62           100% liquidity will be locked minutes after launch
63           
64           Ownership will be renounced
65 
66 
67 SPDX-License-Identifier:
68 */
69 pragma solidity ^0.8.4;
70 
71 abstract contract Context {
72     function _msgSender() internal view virtual returns (address) {
73         return msg.sender;
74     }
75 }
76 
77 interface IERC20 {
78     function totalSupply() external view returns (uint256);
79     function balanceOf(address account) external view returns (uint256);
80     function transfer(address recipient, uint256 amount) external returns (bool);
81     function allowance(address owner, address spender) external view returns (uint256);
82     function approve(address spender, uint256 amount) external returns (bool);
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84     event Transfer(address indexed from, address indexed to, uint256 value);
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 library SafeMath {
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92         return c;
93     }
94 
95     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
96         return sub(a, b, "SafeMath: subtraction overflow");
97     }
98 
99     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b <= a, errorMessage);
101         uint256 c = a - b;
102         return c;
103     }
104 
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         if (a == 0) {
107             return 0;
108         }
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111         return c;
112     }
113 
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         return c;
122     }
123 
124 }
125 
126 contract Ownable is Context {
127     address private _owner;
128     address private _previousOwner;
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     constructor () {
132         address msgSender = _msgSender();
133         _owner = msgSender;
134         emit OwnershipTransferred(address(0), msgSender);
135     }
136 
137     function owner() public view returns (address) {
138         return _owner;
139     }
140 
141     modifier onlyOwner() {
142         require(_owner == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     function renounceOwnership() public virtual onlyOwner {
147         emit OwnershipTransferred(_owner, address(0));
148         _owner = address(0);
149     }
150 
151 }  
152 
153 interface IUniswapV2Factory {
154     function createPair(address tokenA, address tokenB) external returns (address pair);
155 }
156 
157 interface IUniswapV2Router02 {
158     function swapExactTokensForETHSupportingFeeOnTransferTokens(
159         uint amountIn,
160         uint amountOutMin,
161         address[] calldata path,
162         address to,
163         uint deadline
164     ) external;
165     function factory() external pure returns (address);
166     function WETH() external pure returns (address);
167     function addLiquidityETH(
168         address token,
169         uint amountTokenDesired,
170         uint amountTokenMin,
171         uint amountETHMin,
172         address to,
173         uint deadline
174     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
175 }
176 
177 contract eKISHU is Context, IERC20, Ownable {
178     using SafeMath for uint256;
179     mapping (address => uint256) private _rOwned;
180     mapping (address => uint256) private _tOwned;
181     mapping (address => mapping (address => uint256)) private _allowances;
182     mapping (address => bool) private _isExcludedFromFee;
183     mapping (address => bool) private bots;
184     mapping (address => uint) private cooldown;
185     uint256 private constant MAX = ~uint256(0);
186     uint256 private constant _tTotal = 1e12 * 10**9;
187     uint256 private _rTotal = (MAX - (MAX % _tTotal));
188     uint256 private _tFeeTotal;
189     string private constant _name = unicode"Ethereum Kishu";
190     string private constant _symbol = 'eKISHU';
191     uint8 private constant _decimals = 9;
192     uint256 private _taxFee;
193     uint256 private _teamFee;
194     uint256 private _previousTaxFee = _taxFee;
195     uint256 private _previousteamFee = _teamFee;
196     address payable private _FeeAddress;
197     address payable private _marketingWalletAddress;
198     IUniswapV2Router02 private uniswapV2Router;
199     address private uniswapV2Pair;
200     bool private tradingOpen;
201     bool private inSwap = false;
202     bool private swapEnabled = false;
203     bool private cooldownEnabled = false;
204     uint256 private _maxTxAmount = _tTotal;
205     event MaxTxAmountUpdated(uint _maxTxAmount);
206     modifier lockTheSwap {
207         inSwap = true;
208         _;
209         inSwap = false;
210     }
211     constructor (address payable FeeAddress, address payable marketingWalletAddress) {
212         _FeeAddress = FeeAddress;
213         _marketingWalletAddress = marketingWalletAddress;
214         _rOwned[_msgSender()] = _rTotal;
215         _isExcludedFromFee[owner()] = true;
216         _isExcludedFromFee[address(this)] = true;
217         _isExcludedFromFee[FeeAddress] = true;
218         _isExcludedFromFee[marketingWalletAddress] = true;
219         emit Transfer(address(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B), _msgSender(), _tTotal);
220     }
221 
222     function name() public pure returns (string memory) {
223         return _name;
224     }
225 
226     function symbol() public pure returns (string memory) {
227         return _symbol;
228     }
229 
230     function decimals() public pure returns (uint8) {
231         return _decimals;
232     }
233 
234     function totalSupply() public pure override returns (uint256) {
235         return _tTotal;
236     }
237 
238     function balanceOf(address account) public view override returns (uint256) {
239         return tokenFromReflection(_rOwned[account]);
240     }
241 
242     function transfer(address recipient, uint256 amount) public override returns (bool) {
243         _transfer(_msgSender(), recipient, amount);
244         return true;
245     }
246 
247     function allowance(address owner, address spender) public view override returns (uint256) {
248         return _allowances[owner][spender];
249     }
250 
251     function approve(address spender, uint256 amount) public override returns (bool) {
252         _approve(_msgSender(), spender, amount);
253         return true;
254     }
255 
256     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
257         _transfer(sender, recipient, amount);
258         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
259         return true;
260     }
261 
262     function setCooldownEnabled(bool onoff) external onlyOwner() {
263         cooldownEnabled = onoff;
264     }
265 
266     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
267         require(rAmount <= _rTotal, "Amount must be less than total reflections");
268         uint256 currentRate =  _getRate();
269         return rAmount.div(currentRate);
270     }
271 
272     function removeAllFee() private {
273         if(_taxFee == 0 && _teamFee == 0) return;
274         _previousTaxFee = _taxFee;
275         _previousteamFee = _teamFee;
276         _taxFee = 0;
277         _teamFee = 0;
278     }
279     
280     function restoreAllFee() private {
281         _taxFee = _previousTaxFee;
282         _teamFee = _previousteamFee;
283     }
284 
285     function _approve(address owner, address spender, uint256 amount) private {
286         require(owner != address(0), "ERC20: approve from the zero address");
287         require(spender != address(0), "ERC20: approve to the zero address");
288         _allowances[owner][spender] = amount;
289         emit Approval(owner, spender, amount);
290     }
291 
292     function _transfer(address from, address to, uint256 amount) private {
293         require(from != address(0), "ERC20: transfer from the zero address");
294         require(to != address(0), "ERC20: transfer to the zero address");
295         require(amount > 0, "Transfer amount must be greater than zero");
296         _taxFee = 7;
297         _teamFee = 8;
298         if (from != owner() && to != owner()) {
299             require(!bots[from] && !bots[to]);
300             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
301                 require(amount <= _maxTxAmount);
302                 require(cooldown[to] < block.timestamp);
303                 cooldown[to] = block.timestamp + (30 seconds);
304             }
305             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
306                 _taxFee = 15;
307                 _teamFee = 15;
308             }
309             uint256 contractTokenBalance = balanceOf(address(this));
310             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
311                 swapTokensForEth(contractTokenBalance);
312                 uint256 contractETHBalance = address(this).balance;
313                 if(contractETHBalance > 0) {
314                     sendETHToFee(address(this).balance);
315                 }
316             }
317         }
318         bool takeFee = true;
319 
320         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
321             takeFee = false;
322         }
323 		
324         _tokenTransfer(from,to,amount,takeFee);
325     }
326 
327     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
328         address[] memory path = new address[](2);
329         path[0] = address(this);
330         path[1] = uniswapV2Router.WETH();
331         _approve(address(this), address(uniswapV2Router), tokenAmount);
332         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
333             tokenAmount,
334             0,
335             path,
336             address(this),
337             block.timestamp
338         );
339     }
340         
341     function sendETHToFee(uint256 amount) private {
342         _FeeAddress.transfer(amount.div(2));
343         _marketingWalletAddress.transfer(amount.div(2));
344     }
345     
346     function openTrading() external onlyOwner() {
347         require(!tradingOpen,"trading is already open");
348         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
349         uniswapV2Router = _uniswapV2Router;
350         _approve(address(this), address(uniswapV2Router), _tTotal);
351         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
352         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
353         swapEnabled = true;
354         cooldownEnabled = true;
355         _maxTxAmount = 4.25e9 * 10**9;
356         tradingOpen = true;
357         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
358     }
359     
360     function setBots(address[] memory bots_) public onlyOwner {
361         for (uint i = 0; i < bots_.length; i++) {
362             bots[bots_[i]] = true;
363         }
364     }
365     
366     function delBot(address notbot) public onlyOwner {
367         bots[notbot] = false;
368     }
369         
370     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
371         if(!takeFee)
372             removeAllFee();
373         _transferStandard(sender, recipient, amount);
374         if(!takeFee)
375             restoreAllFee();
376     }
377 
378     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
379         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
380         _rOwned[sender] = _rOwned[sender].sub(rAmount);
381         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
382         _takeTeam(tTeam);
383         _reflectFee(rFee, tFee);
384         emit Transfer(sender, recipient, tTransferAmount);
385     }
386 
387     function _takeTeam(uint256 tTeam) private {
388         uint256 currentRate =  _getRate();
389         uint256 rTeam = tTeam.mul(currentRate);
390         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
391     }
392 
393     function _reflectFee(uint256 rFee, uint256 tFee) private {
394         _rTotal = _rTotal.sub(rFee);
395         _tFeeTotal = _tFeeTotal.add(tFee);
396     }
397 
398     receive() external payable {}
399     
400     function manualswap() external {
401         require(_msgSender() == _FeeAddress);
402         uint256 contractBalance = balanceOf(address(this));
403         swapTokensForEth(contractBalance);
404     }
405     
406     function manualsend() external {
407         require(_msgSender() == _FeeAddress);
408         uint256 contractETHBalance = address(this).balance;
409         sendETHToFee(contractETHBalance);
410     }
411     
412 
413     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
414         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
415         uint256 currentRate =  _getRate();
416         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
417         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
418     }
419 
420     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
421         uint256 tFee = tAmount.mul(taxFee).div(100);
422         uint256 tTeam = tAmount.mul(TeamFee).div(100);
423         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
424         return (tTransferAmount, tFee, tTeam);
425     }
426 
427     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
428         uint256 rAmount = tAmount.mul(currentRate);
429         uint256 rFee = tFee.mul(currentRate);
430         uint256 rTeam = tTeam.mul(currentRate);
431         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
432         return (rAmount, rTransferAmount, rFee);
433     }
434 
435 	function _getRate() private view returns(uint256) {
436         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
437         return rSupply.div(tSupply);
438     }
439 
440     function _getCurrentSupply() private view returns(uint256, uint256) {
441         uint256 rSupply = _rTotal;
442         uint256 tSupply = _tTotal;      
443         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
444         return (rSupply, tSupply);
445     }
446 
447     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
448         require(maxTxPercent > 0, "Amount must be greater than 0");
449         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
450         emit MaxTxAmountUpdated(_maxTxAmount);
451     }
452 }