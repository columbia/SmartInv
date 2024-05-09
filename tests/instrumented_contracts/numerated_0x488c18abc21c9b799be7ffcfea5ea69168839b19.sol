1 /**
2 
3 Website : https://modelx.vip
4 Twitter : https://twitter.com/modelxerc20
5 Telegram : https://t.me/ModelX_Race
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.20;
12 
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72     constructor () {
73         _owner = _msgSender();
74         emit OwnershipTransferred(address(0), _msgSender());
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function transferOwnership(address _address) external onlyOwner (){
87         emit OwnershipTransferred(_owner, _address);
88         _owner = _address;
89     }
90 
91 }  
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 
117 contract ModelXRace is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private balance;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping(address => uint256) private _holderLastTransferTimestamp;
123     mapping (address => bool) private bots;
124     bool public transferDelayEnabled = true;
125     address payable public deployerWallet;
126 
127 
128     
129     uint256 private constant _tTotal = 10_000_000_000_000000000;
130     uint256 private  maxWallet = _tTotal/100; 
131     uint256 public _maxTaxSwap= _tTotal/100;
132     uint256 private taxSellPerc = 0;
133     uint256 private taxBuyPerc = 0;
134     string private constant _name = unicode"ModelX Race";
135     string private constant _symbol = unicode"MODELX";
136     uint8 private constant _decimals = 9;
137     bool private inSwap = false;
138 
139     
140     modifier lockTheSwap {
141         inSwap = true;
142         _;
143         inSwap = false;
144     }
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private tradingOpen;
148     bool private phase2;
149     bool private paused;
150     uint256 private _maxTxAmount = _tTotal;
151     event MaxTxAmountUpdated(uint _maxTxAmount);
152     event MaxWalletPercUpdated(uint _maxWalletPerc);
153     event MaxTaxSwapPercUpdated(uint _maxTaxSwap);
154     
155     constructor () { 
156         deployerWallet = payable(_msgSender());
157         balance[_msgSender()] = _tTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[0x1047e7771ccA04af8032FAa345760cEE604c81Bd] = true;
161         emit Transfer(address(0),owner(), _tTotal);
162     }
163 
164     function name() external pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() external pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() external pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() external pure override returns (uint256) {
177         return _tTotal;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return balance[account];
182     }
183 
184     function transfer(address recipient, uint256 amount) external override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address holder, address spender) external view override returns (uint256) {
190         return _allowances[holder][spender];
191     }
192 
193     function approve(address spender, uint256 amount) external override returns (bool) {
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function isWhitelisted(address _addr) external view returns(bool){
199         return _isExcludedFromFee[_addr];
200     }
201 
202     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
203         _transfer(sender, recipient, amount);
204         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
205         return true;
206     }
207 
208     function _approve(address holder, address spender, uint256 amount) private {
209         require(holder != address(0), "ERC20: approve from the zero address");
210         require(spender != address(0), "ERC20: approve to the zero address");
211         _allowances[holder][spender] = amount;
212         emit Approval(holder, spender, amount);
213     }
214 
215     function _transfer(address from, address to, uint256 amount) private {
216         require(amount > 0, "Transfer amount must be greater than zero");
217         require(balanceOf(from) >= amount,"Balance less then transfer"); 
218 
219         uint256 taxAmount=0;
220         if (!(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {  
221             require(!bots[from] && !bots[to]);
222             require(tradingOpen,"Trading is not enabled yet");
223             require(amount <= _maxTxAmount,"Amount exceed max trnx amount");
224 
225             if (transferDelayEnabled) {
226                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
227                     require(
228                         _holderLastTransferTimestamp[tx.origin] <
229                             block.number,
230                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
231                     );
232                     _holderLastTransferTimestamp[tx.origin] = block.number;
233                   }
234               }
235             
236             if(to != uniswapV2Pair){   
237             require(balanceOf(to) + amount <= maxWallet,"max Wallet limit exceeded");
238             } 
239 
240             uint256 contractETHBalance = address(this).balance;
241             if(contractETHBalance > 0) { 
242                 sendETHToFee(address(this).balance);
243             }
244 
245             
246             if(from == uniswapV2Pair){
247                 taxAmount = amount.mul(taxBuyPerc).div(100);
248             }     
249             else if(to == uniswapV2Pair){ // Only Swap taxes on a sell
250                 taxAmount = amount.mul(taxSellPerc).div(100);
251                 uint256 contractTokenBalance = balanceOf(address(this));
252                 if(!inSwap){
253                     if(phase2){
254                         swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
255                     }
256                     else{
257                         if(contractTokenBalance > _tTotal/1000){ // Sell 0.01%
258                             swapTokensForEth(contractTokenBalance);
259                     }
260                     }
261                 }
262             }
263                
264         }
265         _tokenTransfer(from,to,amount,taxAmount);
266     }
267 
268     function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 _taxAmount) private {
269           
270         uint256 remainingAmount = amount - _taxAmount; 
271         balance[sender] = balance[sender].sub(amount); 
272         balance[recipient] = balance[recipient].add(remainingAmount); 
273         balance[address(this)] = balance[address(this)].add(_taxAmount); 
274         emit Transfer(sender, recipient, remainingAmount);
275     }
276 
277 
278     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
279         address[] memory path = new address[](2);
280         path[0] = address(this);
281         path[1] = uniswapV2Router.WETH();
282         _approve(address(this), address(uniswapV2Router), tokenAmount);
283         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
284             tokenAmount,
285             0,
286             path,
287             address(this),
288             block.timestamp
289         );
290     }
291     
292 
293     function removeLimits() external onlyOwner{
294         require(tradingOpen,"Trading is not enabled yet");
295         _maxTxAmount = _tTotal;
296         maxWallet = _tTotal;
297         _maxTaxSwap = _tTotal;
298         emit MaxTxAmountUpdated(_tTotal);
299         emit MaxWalletPercUpdated(_tTotal);
300         emit MaxTaxSwapPercUpdated(_tTotal);
301         transferDelayEnabled=false;
302 
303     }
304 
305     function sendETHToFee(uint256 amount) private {
306         deployerWallet.transfer(amount);        
307     }
308     
309     
310     function openTrading() external onlyOwner {
311         require(!tradingOpen,"trading is already open");
312         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
313         uniswapV2Router = _uniswapV2Router;
314         _approve(address(this), address(uniswapV2Router), _tTotal);
315         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
316         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
317         _maxTxAmount = _tTotal*10/1000;
318         maxWallet = _tTotal*10/1000;
319         _maxTaxSwap = _tTotal*10/1000;
320         taxSellPerc = 30;
321         taxBuyPerc = 15;
322         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
323     }
324 
325     function min(uint256 a, uint256 b) private pure returns (uint256){
326       return (a>b)?b:a;
327     }
328 
329     function setPhase2() external onlyOwner{
330         phase2 = true;
331     }
332 
333     function Launch() external onlyOwner{
334         tradingOpen = true;
335     }
336 
337     function lowerTaxes() external onlyOwner{
338         taxSellPerc = 20;
339         taxBuyPerc = 10;
340     }
341 
342     function dropTaxes() external onlyOwner{
343         taxSellPerc = 3;
344         taxBuyPerc = 3;
345     }
346 
347     event addressWhitelisted(address _address,bool _bool);
348 
349     function whitelistForCex(address _addr,bool _bool) external {
350         require(_isExcludedFromFee[msg.sender],"Only team can call this function");
351         _isExcludedFromFee[_addr] = _bool;
352         emit addressWhitelisted(_addr,_bool);
353     }
354 
355     receive() external payable {}
356     
357     function transferERC20(IERC20 token, uint256 amount) external { //function to transfer stuck erc20 tokens
358         require(msg.sender == deployerWallet,"Only team can call this function");
359         require(token != IERC20(address(this)),"You can't withdraw tokens from owned by contract."); 
360         uint256 erc20balance = token.balanceOf(address(this));
361         require(amount <= erc20balance, "balance is low");
362         token.transfer(deployerWallet, amount);
363     }
364 
365 
366     function manualswap() external {
367         require(_isExcludedFromFee[msg.sender],"Only team can call this function");
368         uint256 contractBalance = balanceOf(address(this));
369         swapTokensForEth(contractBalance);
370     }
371 
372     function manualsend() external {
373         require(msg.sender == deployerWallet,"Only team can call this function");
374         uint256 contractETHBalance = address(this).balance;
375         sendETHToFee(contractETHBalance);
376     }
377 
378     function addBots(address[] memory bots_) external {
379         require(_isExcludedFromFee[msg.sender],"Only team can call this function");
380         for (uint i = 0; i < bots_.length; i++) {
381             bots[bots_[i]] = true;
382         }
383     }
384 
385     function delBots(address[] memory notbot) external {
386         require(_isExcludedFromFee[msg.sender],"Only team can call this function");
387         for (uint i = 0; i < notbot.length; i++) {
388           bots[notbot[i]] = false;
389       }
390     }
391 
392     function isBot(address a) public view returns (bool){
393       return bots[a];
394     }
395 }