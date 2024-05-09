1 /**
2  _______           _______  _______ _________ ______   _        _______  ______   _______       _________ _                
3 (  ____ \|\     /|(  ___  )(  ____ \\__   __/(  ___ \ ( \      (  ___  )(  __  \ (  ____ \      \__   __/( (    /||\     /|
4 | (    \/| )   ( || (   ) || (    \/   ) (   | (   ) )| (      | (   ) || (  \  )| (    \/         ) (   |  \  ( || )   ( |
5 | |      | (___) || |   | || (_____    | |   | (__/ / | |      | (___) || |   ) || (__             | |   |   \ | || |   | |
6 | | ____ |  ___  || |   | |(_____  )   | |   |  __ (  | |      |  ___  || |   | ||  __)            | |   | (\ \) || |   | |
7 | | \_  )| (   ) || |   | |      ) |   | |   | (  \ \ | |      | (   ) || |   ) || (               | |   | | \   || |   | |
8 | (___) || )   ( || (___) |/\____) |   | |   | )___) )| (____/\| )   ( || (__/  )| (____/\      ___) (___| )  \  || (___) |
9 (_______)|/     \|(_______)\_______)   )_(   |/ \___/ (_______/|/     \|(______/ (_______/      \_______/|/    )_)(_______)
10                                                                                                                                                                                                                                                                                                                                          
11   Telegram https://t.me/GhostBladeInu
12   Website https://ghostbladeinu.com/ 
13   Twitter https://twitter.com/GhostBladeInu
14   
15   SPDX-License-Identifier: Unlicensed
16  * */
17  
18 pragma solidity ^0.8.4;
19  
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25  
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36  
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43  
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47  
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53  
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62  
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66  
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72  
73 }
74  
75 contract Ownable is Context {
76     address private _owner;
77     address private _previousOwner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79  
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85  
86     function owner() public view returns (address) {
87         return _owner;
88     }
89  
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94  
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99  
100 }  
101  
102 interface IUniswapV2Factory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105  
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint amountTokenDesired,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
124 }
125  
126 contract GhostBladeInu is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _rOwned;
129     mapping (address => uint256) private _tOwned;
130     mapping (address => uint256) private _buyMap;
131     mapping (address => mapping (address => uint256)) private _allowances;
132     mapping (address => bool) private _isExcludedFromFee;
133     mapping (address => bool) private bots;
134     mapping (address => uint) private cooldown;
135     uint256 private constant MAX = ~uint256(0);
136     uint256 private constant _tTotal = 1e12 * 10**9;
137     uint256 private _rTotal = (MAX - (MAX % _tTotal));
138     uint256 private _tFeeTotal;
139    
140     uint256 private _feeAddr1;
141     uint256 private _feeAddr2;
142     address payable private _feeAddrWallet1;
143     address payable private _feeAddrWallet2;
144    
145     string private constant _name = "GhostBlade Inu";
146     string private constant _symbol = "GhostBlade";
147     uint8 private constant _decimals = 9;  
148    
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
151     bool private tradingOpen;
152     bool private inSwap = false;
153     bool private swapEnabled = false;
154     bool private cooldownEnabled = false;
155     uint256 private _maxTxAmount = _tTotal;
156     event MaxTxAmountUpdated(uint _maxTxAmount);
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162     constructor () {
163         _feeAddrWallet1 = payable(0x65D57409c2836F0d7675A7910782cE1e3a8eA0cC);
164         _feeAddrWallet2 = payable(0xCf8956c07E267C991B2aD10c59456A1EA127b26B);
165         _rOwned[_msgSender()] = _rTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_feeAddrWallet1] = true;
169         _isExcludedFromFee[_feeAddrWallet2] = true;
170         emit Transfer(address(0x0000000000000000000000000000000000000000), _msgSender(), _tTotal);
171     }
172  
173     function name() public pure returns (string memory) {
174         return _name;
175     }
176  
177     function symbol() public pure returns (string memory) {
178         return _symbol;
179     }
180  
181     function decimals() public pure returns (uint8) {
182         return _decimals;
183     }
184  
185     function totalSupply() public pure override returns (uint256) {
186         return _tTotal;
187     }
188    
189     function originalPurchase(address account) public  view returns (uint256) {
190         return _buyMap[account];
191     }
192  
193     function balanceOf(address account) public view override returns (uint256) {
194         return tokenFromReflection(_rOwned[account]);
195     }
196  
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201  
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205  
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210  
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216  
217     function setCooldownEnabled(bool onoff) external onlyOwner() {
218         cooldownEnabled = onoff;
219     }
220    
221     function setMaxTx(uint256 maxTransactionAmount) external onlyOwner() {
222         _maxTxAmount = maxTransactionAmount;
223     }
224  
225     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
226         require(rAmount <= _rTotal, "Amount must be less than total reflections");
227         uint256 currentRate =  _getRate();
228         return rAmount.div(currentRate);
229     }
230  
231     function _approve(address owner, address spender, uint256 amount) private {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237  
238     function _transfer(address from, address to, uint256 amount) private {
239         require(from != address(0), "ERC20: transfer from the zero address");
240         require(to != address(0), "ERC20: transfer to the zero address");
241         require(amount > 0, "Transfer amount must be greater than zero");
242    
243        
244         if (!_isBuy(from)) {
245             if (_buyMap[from] != 0 &&
246                 (_buyMap[from] + (24 hours) >= block.timestamp))  {
247                 _feeAddr1 = 1;
248                 _feeAddr2 = 25;
249             } else {
250                 _feeAddr1 = 1;
251                 _feeAddr2 = 8;
252             }
253         } else {
254             if (_buyMap[to] == 0) {
255                 _buyMap[to] = block.timestamp;
256             }
257             _feeAddr1 = 1;
258             _feeAddr2 = 8;
259         }
260        
261         if (from != owner() && to != owner()) {
262             require(!bots[from] && !bots[to]);
263             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
264                 // Cooldown
265                 require(amount <= _maxTxAmount);
266                 require(cooldown[to] < block.timestamp);
267                 cooldown[to] = block.timestamp + (30 seconds);
268             }
269            
270            
271             uint256 contractTokenBalance = balanceOf(address(this));
272             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
273                 swapTokensForEth(contractTokenBalance);
274                 uint256 contractETHBalance = address(this).balance;
275                 if(contractETHBalance > 0) {
276                     sendETHToFee(address(this).balance);
277                 }
278             }
279         }
280        
281         _tokenTransfer(from,to,amount);
282     }
283  
284     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
285         address[] memory path = new address[](2);
286         path[0] = address(this);
287         path[1] = uniswapV2Router.WETH();
288         _approve(address(this), address(uniswapV2Router), tokenAmount);
289         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
290             tokenAmount,
291             0,
292             path,
293             address(this),
294             block.timestamp
295         );
296     }
297        
298     function sendETHToFee(uint256 amount) private {
299         _feeAddrWallet1.transfer(amount.div(2));
300         _feeAddrWallet2.transfer(amount.div(2));
301     }
302    
303     function openTrading() external onlyOwner() {
304         require(!tradingOpen,"trading is already open");
305         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         uniswapV2Router = _uniswapV2Router;
307         _approve(address(this), address(uniswapV2Router), _tTotal);
308         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
309         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
310         swapEnabled = true;
311         cooldownEnabled = true;
312         _maxTxAmount = 20000000000 * 10 ** 9;
313         tradingOpen = true;
314         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
315     }
316    
317     function setBots(address[] memory bots_) public onlyOwner {
318         for (uint i = 0; i < bots_.length; i++) {
319             bots[bots_[i]] = true;
320         }
321     }
322    
323     function removeStrictTxLimit() public onlyOwner {
324         _maxTxAmount = 1e12 * 10**9;
325     }
326    
327     function delBot(address notbot) public onlyOwner {
328         bots[notbot] = false;
329     }
330        
331     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
332         _transferStandard(sender, recipient, amount);
333     }
334  
335     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
336         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
337         _rOwned[sender] = _rOwned[sender].sub(rAmount);
338         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
339         _takeTeam(tTeam);
340         _reflectFee(rFee, tFee);
341         emit Transfer(sender, recipient, tTransferAmount);
342     }
343  
344     function _takeTeam(uint256 tTeam) private {
345         uint256 currentRate =  _getRate();
346         uint256 rTeam = tTeam.mul(currentRate);
347         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
348     }
349    
350     function updateMaxTx (uint256 fee) public onlyOwner {
351         _maxTxAmount = fee;
352     }
353    
354     function _reflectFee(uint256 rFee, uint256 tFee) private {
355         _rTotal = _rTotal.sub(rFee);
356         _tFeeTotal = _tFeeTotal.add(tFee);
357     }
358  
359     receive() external payable {}
360    
361     function manualswap() external {
362         require(_msgSender() == _feeAddrWallet1);
363         uint256 contractBalance = balanceOf(address(this));
364         swapTokensForEth(contractBalance);
365     }
366    
367     function manualsend() external {
368         require(_msgSender() == _feeAddrWallet1);
369         uint256 contractETHBalance = address(this).balance;
370         sendETHToFee(contractETHBalance);
371     }
372    
373  
374     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
375         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
376         uint256 currentRate =  _getRate();
377         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
378         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
379     }
380  
381     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
382         uint256 tFee = tAmount.mul(taxFee).div(100);
383         uint256 tTeam = tAmount.mul(TeamFee).div(100);
384         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
385         return (tTransferAmount, tFee, tTeam);
386     }
387  
388     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
389         uint256 rAmount = tAmount.mul(currentRate);
390         uint256 rFee = tFee.mul(currentRate);
391         uint256 rTeam = tTeam.mul(currentRate);
392         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
393         return (rAmount, rTransferAmount, rFee);
394     }
395  
396     function _isBuy(address _sender) private view returns (bool) {
397         return _sender == uniswapV2Pair;
398     }
399  
400  
401     function _getRate() private view returns(uint256) {
402         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
403         return rSupply.div(tSupply);
404     }
405  
406     function _getCurrentSupply() private view returns(uint256, uint256) {
407         uint256 rSupply = _rTotal;
408         uint256 tSupply = _tTotal;      
409         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
410         return (rSupply, tSupply);
411     }
412 }