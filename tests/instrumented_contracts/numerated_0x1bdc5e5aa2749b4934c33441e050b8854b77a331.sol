1 /**
2  
3  First Inu — $FINU
4  Join Our Telegram: https://t.me/FirstInuToken
5  Website: https://finu.co
6  WhitePaper: https://finu.co/whitepaper
7  "Be The First!"
8  
9 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCi..:fCCC
10 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC1,LCCCf,CC
11 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCL,tCCCCCL,CC
12 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC1:CCCCCCt,CCC
13 CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCL,tCCCCCC:1CCCC
14 CCCCCCCCCCCC1.,.iLCftLCCCCCCCCCCCCi:CCCCCCf.LCCCCC
15 CCCCCCCCCCt.fCCCC,1CCL:i;,:1CCCCL,fCCCCCCi:CCGGGGG
16 GGGGGGCCL,,tCCCC:fCCCC1;CCCCi;Ci;CCCCCCL,tCCCCCCCC
17 CCCCCCCf,t:CCCCi1CCCf;.tCCCCC..fCCCCCCf,LCCCCCCCCC
18 CCCCCCf,L:fCCCL,CCCt;CCC1,tCi;CCCCCCC;iCCCCCCCCCCC
19 CCCGCL.LC:fCCCi1CCC1iCCCCCLi.tCCCCCL,fCCCCCCCCCCCC
20 CCCCC:tCCLi,;,.fCCCC.;CCCCCCCC1,fC1:CCCCCCCCCCCCCC
21 CCCCt:CCCCCCCCC1.::.iL:;LCCCCCCC.:1CCCCCCCCCCCCCCC
22 CCCC;1CCCCCCCCCCCCCC1.1f:;CCCCCC,LCCCCCCCCCCCCCCCC
23 CCCC.LCCCCCi ::  1CCCCCC,LCCCCCC.CCCCCCCCCCCCCCCCC
24 CCCC.CCCi .     ;: .fCCCfCCCCCCt:CCCCCCCCCCCCCCCCC
25 CCCi:Cf.  .  ,    .Lf:tCCCCCCCC:tCCCCCCCCCCCCCCCCC
26 CC,tCCCCCf.     fCCL:   ,LCCCL:1CCCCCCCCCCCCCCCCCC
27 CCt,tCCCCCCCCCCCCCi   :LCCCL;:LCCCCCCCCCCCCCCCCCCC
28 CCCCL;,fCCCCCCCL:   iCCCCf,iCCCCCCCCCCCCCCCCCCCCCC
29 CCCCCCCL::LCCCCCC1tCCCt,:LCCCCCCCCCCCCCCCCCCCCCCCC
30 CCCCCCCCCCf,iLCCCCL:,tCCCCCCCCCCCCCCCCCCCCCCCCCCCC
31 CCCCCCCCCCCCC1,tC1:CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
32 CCCCCCCCCCCCCCCCfLCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
33    
34 */
35 
36 pragma solidity ^0.8.4;
37 // SPDX-License-Identifier: UNLICENSED
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address) {
40         return msg.sender;
41     }
42 }
43 
44 interface IERC20 {
45     function totalSupply() external view returns (uint256);
46     function balanceOf(address account) external view returns (uint256);
47     function transfer(address recipient, uint256 amount) external returns (bool);
48     function allowance(address owner, address spender) external view returns (uint256);
49     function approve(address spender, uint256 amount) external returns (bool);
50     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
51     event Transfer(address indexed from, address indexed to, uint256 value);
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 }
54 
55 library SafeMath {
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b <= a, errorMessage);
68         uint256 c = a - b;
69         return c;
70     }
71 
72     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
73         if (a == 0) {
74             return 0;
75         }
76         uint256 c = a * b;
77         require(c / a == b, "SafeMath: multiplication overflow");
78         return c;
79     }
80 
81     function div(uint256 a, uint256 b) internal pure returns (uint256) {
82         return div(a, b, "SafeMath: division by zero");
83     }
84 
85     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
86         require(b > 0, errorMessage);
87         uint256 c = a / b;
88         return c;
89     }
90 
91 }
92 
93 contract Ownable is Context {
94     address private _owner;
95     address private _previousOwner;
96     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97 
98     constructor () {
99         address msgSender = _msgSender();
100         _owner = msgSender;
101         emit OwnershipTransferred(address(0), msgSender);
102     }
103 
104     function owner() public view returns (address) {
105         return _owner;
106     }
107 
108     modifier onlyOwner() {
109         require(_owner == _msgSender(), "Ownable: caller is not the owner");
110         _;
111     }
112 
113     function renounceOwnership() public virtual onlyOwner {
114         emit OwnershipTransferred(_owner, address(0));
115         _owner = address(0);
116     }
117 
118 }  
119 
120 interface IUniswapV2Factory {
121     function createPair(address tokenA, address tokenB) external returns (address pair);
122 }
123 
124 interface IUniswapV2Router02 {
125     function swapExactTokensForETHSupportingFeeOnTransferTokens(
126         uint amountIn,
127         uint amountOutMin,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external;
132     function factory() external pure returns (address);
133     function WETH() external pure returns (address);
134     function addLiquidityETH(
135         address token,
136         uint amountTokenDesired,
137         uint amountTokenMin,
138         uint amountETHMin,
139         address to,
140         uint deadline
141     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
142 }
143 
144 contract FINU is Context, IERC20, Ownable {
145     using SafeMath for uint256;
146     mapping (address => uint256) private _rOwned;
147     mapping (address => uint256) private _tOwned;
148     mapping (address => mapping (address => uint256)) private _allowances;
149     mapping (address => bool) private _isExcludedFromFee;
150     mapping (address => bool) private bots;
151     mapping (address => uint) private cooldown;
152     uint256 private constant MAX = ~uint256(0);
153     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
154     uint256 private _rTotal = (MAX - (MAX % _tTotal));
155     uint256 private _tFeeTotal;
156     
157     uint256 private _feeAddr1;
158     uint256 private _feeAddr2;
159     address payable private _feeAddrWallet1;
160     address payable private _feeAddrWallet2;
161     
162     string private constant _name = "First Inu";
163     string private constant _symbol = "FINU";
164     uint8 private constant _decimals = 9;
165     
166     IUniswapV2Router02 private uniswapV2Router;
167     address private uniswapV2Pair;
168     bool private tradingOpen;
169     bool private inSwap = false;
170     bool private swapEnabled = false;
171     bool private cooldownEnabled = false;
172     uint256 private _maxTxAmount = _tTotal;
173     event MaxTxAmountUpdated(uint _maxTxAmount);
174     modifier lockTheSwap {
175         inSwap = true;
176         _;
177         inSwap = false;
178     }
179     constructor () {
180         _feeAddrWallet1 = payable(0xEc97E47710081e7b63EF37083C2AE05Cc821F829);
181         _feeAddrWallet2 = payable(0xEc97E47710081e7b63EF37083C2AE05Cc821F829);
182         _rOwned[_msgSender()] = _rTotal;
183         _isExcludedFromFee[owner()] = true;
184         _isExcludedFromFee[address(this)] = true;
185         _isExcludedFromFee[_feeAddrWallet1] = true;
186         _isExcludedFromFee[_feeAddrWallet2] = true;
187         emit Transfer(address(0x71930Bf7D5B559BFC0105a4d801B2B4b07131Cd6), _msgSender(), _tTotal);
188     }
189 
190     function name() public pure returns (string memory) {
191         return _name;
192     }
193 
194     function symbol() public pure returns (string memory) {
195         return _symbol;
196     }
197 
198     function decimals() public pure returns (uint8) {
199         return _decimals;
200     }
201 
202     function totalSupply() public pure override returns (uint256) {
203         return _tTotal;
204     }
205 
206     function balanceOf(address account) public view override returns (uint256) {
207         return tokenFromReflection(_rOwned[account]);
208     }
209 
210     function transfer(address recipient, uint256 amount) public override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     function allowance(address owner, address spender) public view override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 
219     function approve(address spender, uint256 amount) public override returns (bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 
224     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
225         _transfer(sender, recipient, amount);
226         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
227         return true;
228     }
229 
230     function setCooldownEnabled(bool onoff) external onlyOwner() {
231         cooldownEnabled = onoff;
232     }
233 
234     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
235         require(rAmount <= _rTotal, "Amount must be less than total reflections");
236         uint256 currentRate =  _getRate();
237         return rAmount.div(currentRate);
238     }
239 
240     function _approve(address owner, address spender, uint256 amount) private {
241         require(owner != address(0), "ERC20: approve from the zero address");
242         require(spender != address(0), "ERC20: approve to the zero address");
243         _allowances[owner][spender] = amount;
244         emit Approval(owner, spender, amount);
245     }
246 
247     function _transfer(address from, address to, uint256 amount) private {
248         require(from != address(0), "ERC20: transfer from the zero address");
249         require(to != address(0), "ERC20: transfer to the zero address");
250         require(amount > 0, "Transfer amount must be greater than zero");
251         _feeAddr1 = 2;
252         _feeAddr2 = 12;
253         if (from != owner() && to != owner()) {
254             require(!bots[from] && !bots[to]);
255             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
256                 // Cooldown
257                 require(amount <= _maxTxAmount);
258                 require(cooldown[to] < block.timestamp);
259                 cooldown[to] = block.timestamp + (30 seconds);
260             }
261             
262             
263             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
264                 _feeAddr1 = 2;
265                 _feeAddr2 = 14;
266             }
267             uint256 contractTokenBalance = balanceOf(address(this));
268             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
269                 swapTokensForEth(contractTokenBalance);
270                 uint256 contractETHBalance = address(this).balance;
271                 if(contractETHBalance > 0) {
272                     sendETHToFee(address(this).balance);
273                 }
274             }
275         }
276 		
277         _tokenTransfer(from,to,amount);
278     }
279 
280     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
281         address[] memory path = new address[](2);
282         path[0] = address(this);
283         path[1] = uniswapV2Router.WETH();
284         _approve(address(this), address(uniswapV2Router), tokenAmount);
285         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
286             tokenAmount,
287             0,
288             path,
289             address(this),
290             block.timestamp
291         );
292     }
293         
294     function sendETHToFee(uint256 amount) private {
295         _feeAddrWallet1.transfer(amount.div(2));
296         _feeAddrWallet2.transfer(amount.div(2));
297     }
298     
299     function openTrading() external onlyOwner() {
300         require(!tradingOpen,"trading is already open");
301         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
302         uniswapV2Router = _uniswapV2Router;
303         _approve(address(this), address(uniswapV2Router), _tTotal);
304         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
305         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
306         swapEnabled = true;
307         cooldownEnabled = true;
308         _maxTxAmount = 25000000000000000 * 10**9;
309         tradingOpen = true;
310         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
311     }
312     
313     function setBots(address[] memory bots_) public onlyOwner {
314         for (uint i = 0; i < bots_.length; i++) {
315             bots[bots_[i]] = true;
316         }
317     }
318     
319     function delBot(address notbot) public onlyOwner {
320         bots[notbot] = false;
321     }
322         
323     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
324         _transferStandard(sender, recipient, amount);
325     }
326 
327     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
328         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
329         _rOwned[sender] = _rOwned[sender].sub(rAmount);
330         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
331         _takeTeam(tTeam);
332         _reflectFee(rFee, tFee);
333         emit Transfer(sender, recipient, tTransferAmount);
334     }
335 
336     function _takeTeam(uint256 tTeam) private {
337         uint256 currentRate =  _getRate();
338         uint256 rTeam = tTeam.mul(currentRate);
339         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
340     }
341 
342     function _reflectFee(uint256 rFee, uint256 tFee) private {
343         _rTotal = _rTotal.sub(rFee);
344         _tFeeTotal = _tFeeTotal.add(tFee);
345     }
346 
347     receive() external payable {}
348     
349     function manualswap() external {
350         require(_msgSender() == _feeAddrWallet1);
351         uint256 contractBalance = balanceOf(address(this));
352         swapTokensForEth(contractBalance);
353     }
354     
355     function manualsend() external {
356         require(_msgSender() == _feeAddrWallet1);
357         uint256 contractETHBalance = address(this).balance;
358         sendETHToFee(contractETHBalance);
359     }
360     
361 
362     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
363         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
364         uint256 currentRate =  _getRate();
365         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
366         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
367     }
368 
369     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
370         uint256 tFee = tAmount.mul(taxFee).div(100);
371         uint256 tTeam = tAmount.mul(TeamFee).div(100);
372         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
373         return (tTransferAmount, tFee, tTeam);
374     }
375 
376     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
377         uint256 rAmount = tAmount.mul(currentRate);
378         uint256 rFee = tFee.mul(currentRate);
379         uint256 rTeam = tTeam.mul(currentRate);
380         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
381         return (rAmount, rTransferAmount, rFee);
382     }
383 
384 	function _getRate() private view returns(uint256) {
385         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
386         return rSupply.div(tSupply);
387     }
388 
389     function _getCurrentSupply() private view returns(uint256, uint256) {
390         uint256 rSupply = _rTotal;
391         uint256 tSupply = _tTotal;      
392         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
393         return (rSupply, tSupply);
394     }
395 }