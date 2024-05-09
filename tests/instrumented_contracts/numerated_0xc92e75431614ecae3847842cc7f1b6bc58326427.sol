1 /**
2   
3 KNUCKLES $KNUCKLES
4  Join Our Telegram: https://t.me/KNUCKLESToken
5  Website: https://knucklestoken.co/
6  
7  88                                           88        88                       
8 88                                           88        88                       
9 88                                           88        88                       
10 88   ,d8  8b,dPPYba,  88       88  ,adPPYba, 88   ,d8  88  ,adPPYba, ,adPPYba,  
11 88 ,a8"   88P'   `"8a 88       88 a8"     "" 88 ,a8"   88 a8P_____88 I8[    ""  
12 8888[     88       88 88       88 8b         8888[     88 8PP"""""""  `"Y8ba,   
13 88`"Yba,  88       88 "8a,   ,a88 "8a,   ,aa 88`"Yba,  88 "8b,   ,aa aa    ]8I  
14 88   `Y8a 88       88  `"YbbdP'Y8  `"Ybbd8"' 88   `Y8a 88  `"Ybbd8"' `"YbbdP"'  
15 
16                           .,,,,,,,,,,,,,,,,,,,,,                               
17                       ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                       
18                     ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                   
19                   ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                
20                 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,             
21               ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,          
22              ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,        
23             ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,    ,,,,,,,,,      
24           ,,,,,,,    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,        ,,,,,    
25           ,,,,,.      ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,          .,,,  
26          ,,,,,        ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,            ,, 
27           ,,,         ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,              
28           ,,,,,      ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,              
29          ,,,, ,,,  ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, ,,,,,,,,,,,,,,              
30           ,,,  ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,  ,,,,,,,,,,,,,             
31          ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,   ,,,,,,,,,,,,             
32      ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, ,,,,,,,,,,,,,,     ,,,,,,,,,,             
33               ,,,,,,,,,,  ,,,,,,,,,,  ,,,,,,,,,,,,,       ,,,,,,,,              
34                          ,,,,,,,,,.   .,,,,,,,,,,,,        ,,,,,,,              
35                          ,,,,,,,,      ,,,,,,,,,,,         ,,,,,,,              
36                         ,,,,,,,       ,,,,,,,,,,            ,,,,,               
37                        ,,,,,          ,,,,,,,,              ,,,,.               
38                        ,             ,,,,,,,                 ,,.                
39                                      ,,,,                    ,                  
40                                     ,,                               
41 
42 
43 
44 */
45 
46 pragma solidity ^0.8.4;
47 // SPDX-License-Identifier: UNLICENSED
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
154 contract KNUCKLES is Context, IERC20, Ownable {
155     using SafeMath for uint256;
156     mapping (address => uint256) private _rOwned;
157     mapping (address => uint256) private _tOwned;
158     mapping (address => mapping (address => uint256)) private _allowances;
159     mapping (address => bool) private _isExcludedFromFee;
160     mapping (address => bool) private bots;
161     mapping (address => uint) private cooldown;
162     uint256 private constant MAX = ~uint256(0);
163     uint256 private constant _tTotal = 1000000 * 10**9;
164     uint256 private _rTotal = (MAX - (MAX % _tTotal));
165     uint256 private _tFeeTotal;
166     
167     uint256 private _feeAddr1;
168     uint256 private _feeAddr2;
169     address payable private _feeAddrWallet1;
170     address payable private _feeAddrWallet2;
171     
172     string private constant _name = "KNUCKLES";
173     string private constant _symbol = "KNUCKLES";
174     uint8 private constant _decimals = 9;
175     
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
189     constructor () {
190         _feeAddrWallet1 = payable(0x4779A34CeeA3a89d783c8c662bF80BD6c1261A83);
191         _feeAddrWallet2 = payable(0x4779A34CeeA3a89d783c8c662bF80BD6c1261A83);
192         _rOwned[_msgSender()] = _rTotal;
193         _isExcludedFromFee[owner()] = true;
194         _isExcludedFromFee[address(this)] = true;
195         _isExcludedFromFee[_feeAddrWallet1] = true;
196         _isExcludedFromFee[_feeAddrWallet2] = true;
197         emit Transfer(address(0x85Ce0c0CDCe7Cd659a5F846261780Ec94d9A757B), _msgSender(), _tTotal);
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
261         _feeAddr1 = 0;
262         _feeAddr2 = 10;
263         if (from != owner() && to != owner()) {
264             require(!bots[from] && !bots[to]);
265             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
266                 // Cooldown
267                 require(amount <= _maxTxAmount);
268                 require(cooldown[to] < block.timestamp);
269                 cooldown[to] = block.timestamp + (30 seconds);
270             }
271             
272             
273             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
274                 _feeAddr1 = 0;
275                 _feeAddr2 = 10;
276             }
277             uint256 contractTokenBalance = balanceOf(address(this));
278             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
279                 swapTokensForEth(contractTokenBalance);
280                 uint256 contractETHBalance = address(this).balance;
281                 if(contractETHBalance > 0) {
282                     sendETHToFee(address(this).balance);
283                 }
284             }
285         }
286 		
287         _tokenTransfer(from,to,amount);
288     }
289 
290     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
291         address[] memory path = new address[](2);
292         path[0] = address(this);
293         path[1] = uniswapV2Router.WETH();
294         _approve(address(this), address(uniswapV2Router), tokenAmount);
295         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
296             tokenAmount,
297             0,
298             path,
299             address(this),
300             block.timestamp
301         );
302     }
303         
304     function sendETHToFee(uint256 amount) private {
305         _feeAddrWallet2.transfer(amount);
306     }
307     
308     function openTrading() external onlyOwner() {
309         require(!tradingOpen,"trading is already open");
310         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
311         uniswapV2Router = _uniswapV2Router;
312         _approve(address(this), address(uniswapV2Router), _tTotal);
313         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
314         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
315         swapEnabled = true;
316         cooldownEnabled = true;
317         _maxTxAmount = 50000 * 10**9;
318         tradingOpen = true;
319         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
320     }
321     
322     function nonosquare(address[] memory bots_) public onlyOwner {
323         for (uint i = 0; i < bots_.length; i++) {
324             bots[bots_[i]] = true;
325         }
326     }
327     
328     function delBot(address notbot) public onlyOwner {
329         bots[notbot] = false;
330     }
331         
332     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
333         _transferStandard(sender, recipient, amount);
334     }
335 
336     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
337         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
338         _rOwned[sender] = _rOwned[sender].sub(rAmount);
339         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
340         _takeTeam(tTeam);
341         _reflectFee(rFee, tFee);
342         emit Transfer(sender, recipient, tTransferAmount);
343     }
344 
345     function _takeTeam(uint256 tTeam) private {
346         uint256 currentRate =  _getRate();
347         uint256 rTeam = tTeam.mul(currentRate);
348         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
349     }
350 
351     function _reflectFee(uint256 rFee, uint256 tFee) private {
352         _rTotal = _rTotal.sub(rFee);
353         _tFeeTotal = _tFeeTotal.add(tFee);
354     }
355 
356     receive() external payable {}
357     
358     function manualswap() external {
359         require(_msgSender() == _feeAddrWallet1);
360         uint256 contractBalance = balanceOf(address(this));
361         swapTokensForEth(contractBalance);
362     }
363     
364     function manualsend() external {
365         require(_msgSender() == _feeAddrWallet1);
366         uint256 contractETHBalance = address(this).balance;
367         sendETHToFee(contractETHBalance);
368     }
369     
370 
371     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
372         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
373         uint256 currentRate =  _getRate();
374         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
375         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
376     }
377 
378     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
379         uint256 tFee = tAmount.mul(taxFee).div(100);
380         uint256 tTeam = tAmount.mul(TeamFee).div(100);
381         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
382         return (tTransferAmount, tFee, tTeam);
383     }
384 
385     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
386         uint256 rAmount = tAmount.mul(currentRate);
387         uint256 rFee = tFee.mul(currentRate);
388         uint256 rTeam = tTeam.mul(currentRate);
389         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
390         return (rAmount, rTransferAmount, rFee);
391     }
392 
393 	function _getRate() private view returns(uint256) {
394         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
395         return rSupply.div(tSupply);
396     }
397 
398     function _getCurrentSupply() private view returns(uint256, uint256) {
399         uint256 rSupply = _rTotal;
400         uint256 tSupply = _tTotal;      
401         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
402         return (rSupply, tSupply);
403     }
404 }