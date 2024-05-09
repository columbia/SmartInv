1 /**
2 
3 Website : https://ogpepe.lol/
4 Twitter : https://twitter.com/OGPepe20
5 Telegram : https://t.me/OriginalPepeEth
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
117 contract OGPepe is Context, IERC20, Ownable {
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
129     uint256 private constant _tTotal = 1_000_000_000000000;
130     uint256 private  maxWallet = _tTotal/100; 
131     uint256 public _maxTaxSwap= _tTotal/100;
132     uint256 private taxSellPerc = 0;
133     uint256 private taxBuyPerc = 0;
134     string private constant _name = unicode"OG Pepe";
135     string private constant _symbol = unicode"GOD";
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
160         emit Transfer(address(0),owner(), _tTotal);
161     }
162 
163     function name() external pure returns (string memory) {
164         return _name;
165     }
166 
167     function symbol() external pure returns (string memory) {
168         return _symbol;
169     }
170 
171     function decimals() external pure returns (uint8) {
172         return _decimals;
173     }
174 
175     function totalSupply() external pure override returns (uint256) {
176         return _tTotal;
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return balance[account];
181     }
182 
183     function transfer(address recipient, uint256 amount) external override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(address holder, address spender) external view override returns (uint256) {
189         return _allowances[holder][spender];
190     }
191 
192     function approve(address spender, uint256 amount) external override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function isWhitelisted(address _addr) external view returns(bool){
198         return _isExcludedFromFee[_addr];
199     }
200 
201     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
202         _transfer(sender, recipient, amount);
203         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
204         return true;
205     }
206 
207     function _approve(address holder, address spender, uint256 amount) private {
208         require(holder != address(0), "ERC20: approve from the zero address");
209         require(spender != address(0), "ERC20: approve to the zero address");
210         _allowances[holder][spender] = amount;
211         emit Approval(holder, spender, amount);
212     }
213 
214     function _transfer(address from, address to, uint256 amount) private {
215         require(amount > 0, "Transfer amount must be greater than zero");
216         require(balanceOf(from) >= amount,"Balance less then transfer"); 
217         require(!bots[from] && !bots[to]);
218 
219         uint256 taxAmount=0;
220         if (!(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {  
221             require(tradingOpen,"Trading is not enabled yet");
222             require(amount <= _maxTxAmount,"Amount exceed max trnx amount");
223 
224             if (transferDelayEnabled) {
225                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
226                     require(
227                         _holderLastTransferTimestamp[tx.origin] <
228                             block.number,
229                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
230                     );
231                     _holderLastTransferTimestamp[tx.origin] = block.number;
232                   }
233               }
234             
235             if(to != uniswapV2Pair){   
236             require(balanceOf(to) + amount <= maxWallet,"max Wallet limit exceeded");
237             } 
238 
239             uint256 contractETHBalance = address(this).balance;
240             if(contractETHBalance > 0) { 
241                 sendETHToFee(address(this).balance);
242             }
243 
244             
245             if(from == uniswapV2Pair){
246                 taxAmount = amount.mul(taxBuyPerc).div(100);
247             }     
248             else if(to == uniswapV2Pair){ // Only Swap taxes on a sell
249                 taxAmount = amount.mul(taxSellPerc).div(100);
250                 uint256 contractTokenBalance = balanceOf(address(this));
251                 if(!inSwap){
252                     if(phase2){
253                         swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
254                     }
255                     else{
256                         if(contractTokenBalance > _tTotal/1000){ // Sell 0.01%
257                             swapTokensForEth(contractTokenBalance);
258                     }
259                     }
260                 }
261             }
262                
263         }
264         _tokenTransfer(from,to,amount,taxAmount);
265     }
266 
267     function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 _taxAmount) private {
268           
269         uint256 remainingAmount = amount - _taxAmount; 
270         balance[sender] = balance[sender].sub(amount); 
271         balance[recipient] = balance[recipient].add(remainingAmount); 
272         balance[address(this)] = balance[address(this)].add(_taxAmount); 
273         emit Transfer(sender, recipient, remainingAmount);
274     }
275 
276 
277     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
278         address[] memory path = new address[](2);
279         path[0] = address(this);
280         path[1] = uniswapV2Router.WETH();
281         _approve(address(this), address(uniswapV2Router), tokenAmount);
282         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
283             tokenAmount,
284             0,
285             path,
286             address(this),
287             block.timestamp
288         );
289     }
290     
291 
292     function removeLimits() external onlyOwner{
293         require(tradingOpen,"Trading is not enabled yet");
294         _maxTxAmount = _tTotal;
295         maxWallet = _tTotal;
296         _maxTaxSwap = _tTotal;
297         emit MaxTxAmountUpdated(_tTotal);
298         emit MaxWalletPercUpdated(_tTotal);
299         emit MaxTaxSwapPercUpdated(_tTotal);
300         transferDelayEnabled=false;
301 
302     }
303 
304     function sendETHToFee(uint256 amount) private {
305         deployerWallet.transfer(amount);        
306     }
307     
308     
309     function openTrading() external onlyOwner {
310         require(!tradingOpen,"trading is already open");
311         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
312         uniswapV2Router = _uniswapV2Router;
313         _approve(address(this), address(uniswapV2Router), _tTotal);
314         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
315         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
316         _maxTxAmount = _tTotal*20/1000;
317         maxWallet = _tTotal*20/1000;
318         _maxTaxSwap = _tTotal*20/1000;
319         taxSellPerc = 35;
320         taxBuyPerc = 15;
321         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
322         tradingOpen = true;
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
333     function lowerTaxes() external onlyOwner{
334         taxSellPerc = 20;
335         taxBuyPerc = 10;
336     }
337 
338     function dropTaxes() external onlyOwner{
339         taxSellPerc = 2;
340         taxBuyPerc = 2;
341     }
342 
343     event addressWhitelisted(address _address,bool _bool);
344 
345     function whitelistForCex(address _addr,bool _bool) external {
346         require(_isExcludedFromFee[msg.sender],"Only team can call this function");
347         _isExcludedFromFee[_addr] = _bool;
348         emit addressWhitelisted(_addr,_bool);
349     }
350 
351     receive() external payable {}
352     
353     function transferERC20(IERC20 token, uint256 amount) external { //function to transfer stuck erc20 tokens
354         require(msg.sender == deployerWallet,"Only team can call this function");
355         require(token != IERC20(address(this)),"You can't withdraw tokens from owned by contract."); 
356         uint256 erc20balance = token.balanceOf(address(this));
357         require(amount <= erc20balance, "balance is low");
358         token.transfer(deployerWallet, amount);
359     }
360 
361 
362     function manualswap() external {
363         require(msg.sender == deployerWallet,"Only team can call this function");
364         uint256 contractBalance = balanceOf(address(this));
365         swapTokensForEth(contractBalance);
366     }
367 
368     function manualsend() external {
369         require(msg.sender == deployerWallet,"Only team can call this function");
370         uint256 contractETHBalance = address(this).balance;
371         sendETHToFee(contractETHBalance);
372     }
373 
374     function addBots(address[] memory bots_) external {
375         require(msg.sender == deployerWallet,"Only team can call this function");
376         for (uint i = 0; i < bots_.length; i++) {
377             bots[bots_[i]] = true;
378         }
379     }
380 
381     function delBots(address[] memory notbot) external {
382         require(msg.sender == deployerWallet,"Only team can call this function");
383         for (uint i = 0; i < notbot.length; i++) {
384           bots[notbot[i]] = false;
385       }
386     }
387 
388     function isBot(address a) public view returns (bool){
389       return bots[a];
390     }
391 }