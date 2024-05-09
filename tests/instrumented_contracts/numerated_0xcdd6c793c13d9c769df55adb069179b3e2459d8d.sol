1 /*
2  /$$                                           /$$$$$$                    
3 | $$                                          |_  $$_/                    
4 | $$       /$$   /$$  /$$$$$$$ /$$   /$$        | $$   /$$$$$$$  /$$   /$$
5 | $$      | $$  | $$ /$$_____/| $$  | $$        | $$  | $$__  $$| $$  | $$
6 | $$      | $$  | $$| $$      | $$  | $$        | $$  | $$  \ $$| $$  | $$
7 | $$      | $$  | $$| $$      | $$  | $$        | $$  | $$  | $$| $$  | $$
8 | $$$$$$$$|  $$$$$$/|  $$$$$$$|  $$$$$$$       /$$$$$$| $$  | $$|  $$$$$$/
9 |________/ \______/  \_______/ \____  $$      |______/|__/  |__/ \______/ 
10                                /$$  | $$                                  
11                               |  $$$$$$/                                  
12                                \______/                                   
13 
14 Telegram: t.me/LucyInuETH
15 Website: https://lucyinu.me
16 */
17 
18 pragma solidity ^0.8.3;
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
126 contract LucyInu is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _rOwned;
129     mapping (address => uint256) private _tOwned;
130     mapping (address => mapping (address => uint256)) private _allowances;
131     mapping (address => bool) private _isExcludedFromFee;
132     mapping (address => bool) private bots;
133     mapping (address => uint) private cooldown;
134     uint256 private constant MAX = ~uint256(0);
135     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
136     uint256 private _rTotal = (MAX - (MAX % _tTotal));
137     uint256 private _tFeeTotal;
138     string private constant _name = "LucyInu";
139     string private constant _symbol = "Lucy";
140     uint8 private constant _decimals = 18;
141     uint256 private _taxFee;
142     uint256 private _teamFee;
143     uint256 private _previousTaxFee = _taxFee;
144     uint256 private _previousteamFee = _teamFee;
145     address payable private _FeeAddress;
146     address payable private _marketingWalletAddress;
147     IUniswapV2Router02 private uniswapV2Router;
148     address private uniswapV2Pair;
149     bool private tradingOpen;
150     bool private inSwap = false;
151     bool private swapEnabled = false;
152     bool private cooldownEnabled = false;
153     uint256 private _maxTxAmount = _tTotal;
154     event MaxTxAmountUpdated(uint _maxTxAmount);
155     modifier lockTheSwap {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160     constructor (address payable addr1, address payable addr2) {
161         _FeeAddress = addr1;
162         _marketingWalletAddress = addr2;
163         _rOwned[_msgSender()] = _rTotal;
164         _isExcludedFromFee[owner()] = true;
165         _isExcludedFromFee[address(this)] = true;
166         _isExcludedFromFee[_FeeAddress] = true;
167         _isExcludedFromFee[_marketingWalletAddress] = true;
168         emit Transfer(address(0x929242B1Eb71b05Ce9319fa902983Dce3c0383E1), _msgSender(), _tTotal);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _tTotal;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return tokenFromReflection(_rOwned[account]);
189     }
190 
191     function transfer(address recipient, uint256 amount) public override returns (bool) {
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256) {
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210 
211     function setCooldownEnabled(bool onoff) external onlyOwner() {
212         cooldownEnabled = onoff;
213     }
214 
215     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
216         require(rAmount <= _rTotal, "Amount must be less than total reflections");
217         uint256 currentRate =  _getRate();
218         return rAmount.div(currentRate);
219     }
220 
221     function removeAllFee() private {
222         if(_taxFee == 0 && _teamFee == 0) return;
223         _previousTaxFee = _taxFee;
224         _previousteamFee = _teamFee;
225         _taxFee = 0;
226         _teamFee = 0;
227     }
228     
229     function restoreAllFee() private {
230         _taxFee = _previousTaxFee;
231         _teamFee = _previousteamFee;
232     }
233 
234     function _approve(address owner, address spender, uint256 amount) private {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237         _allowances[owner][spender] = amount;
238         emit Approval(owner, spender, amount);
239     }
240 
241     function _transfer(address from, address to, uint256 amount) private {
242         require(from != address(0), "ERC20: transfer from the zero address");
243         require(to != address(0), "ERC20: transfer to the zero address");
244         require(amount > 0, "Transfer amount must be greater than zero");
245         _taxFee = 1;
246         _teamFee = 9;
247         if (from != owner() && to != owner()) {
248             require(!bots[from] && !bots[to]);
249             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
250                 require(amount <= _maxTxAmount);
251                 require(cooldown[to] < block.timestamp);
252                 cooldown[to] = block.timestamp + (30 seconds);
253             }
254             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
255                 _taxFee = 1;
256                 _teamFee = 9;
257             }
258             uint256 contractTokenBalance = balanceOf(address(this));
259             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
260                 swapTokensForEth(contractTokenBalance);
261                 uint256 contractETHBalance = address(this).balance;
262                 if(contractETHBalance > 0) {
263                     sendETHToFee(address(this).balance);
264                 }
265             }
266         }
267         bool takeFee = true;
268 
269         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
270             takeFee = false;
271         }
272 		
273         _tokenTransfer(from,to,amount,takeFee);
274     }
275 
276     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
277         address[] memory path = new address[](2);
278         path[0] = address(this);
279         path[1] = uniswapV2Router.WETH();
280         _approve(address(this), address(uniswapV2Router), tokenAmount);
281         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
282             tokenAmount,
283             0,
284             path,
285             address(this),
286             block.timestamp
287         );
288     }
289         
290     function sendETHToFee(uint256 amount) private {
291         _FeeAddress.transfer(amount.div(2));
292         _marketingWalletAddress.transfer(amount.div(2));
293     }
294     
295     function openTrading() external onlyOwner() {
296         require(!tradingOpen,"trading is already open");
297         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
298         uniswapV2Router = _uniswapV2Router;
299         _approve(address(this), address(uniswapV2Router), _tTotal);
300         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
301         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
302         swapEnabled = true;
303         cooldownEnabled = true;
304         _maxTxAmount = 100000000000000000 * 10**9;
305         tradingOpen = true;
306         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
307     }
308     
309     function setBots(address[] memory bots_) public onlyOwner {
310         for (uint i = 0; i < bots_.length; i++) {
311             bots[bots_[i]] = true;
312         }
313     }
314     
315     function delBot(address notbot) public onlyOwner {
316         bots[notbot] = false;
317     }
318         
319     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
320         if(!takeFee)
321             removeAllFee();
322         _transferStandard(sender, recipient, amount);
323         if(!takeFee)
324             restoreAllFee();
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
350         require(_msgSender() == _FeeAddress);
351         uint256 contractBalance = balanceOf(address(this));
352         swapTokensForEth(contractBalance);
353     }
354     
355     function manualsend() external {
356         require(_msgSender() == _FeeAddress);
357         uint256 contractETHBalance = address(this).balance;
358         sendETHToFee(contractETHBalance);
359     }
360     
361 
362     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
363         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
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
395 
396     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
397         require(maxTxPercent > 0, "Amount must be greater than 0");
398         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
399         emit MaxTxAmountUpdated(_maxTxAmount);
400     }
401 }