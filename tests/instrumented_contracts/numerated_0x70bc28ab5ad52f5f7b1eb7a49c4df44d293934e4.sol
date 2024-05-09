1 /*
2 https://hphrddvmh666tg.com/
3 
4 https://play.hphrddvmh666tg.com/
5 
6 https://t.me/hphrddvmh666tg
7 
8 https://twitter.com/HPHRDDVMH666TG/
9 
10 Welcome to Hogwarts!
11 */
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity 0.8.20;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         return c;
67     }
68 
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 
121 contract HP is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private bots;
127     mapping(address => uint256) private _holderLastTransferTimestamp;
128     bool public transferDelayEnabled = true;
129     address payable private _taxWallet;
130     address payable private _rewardWallet = payable(0xE4A15B61d921f781A56c0a6c472256B768dBD9d5);
131 
132     uint256 private _buyTax=21;
133     uint256 private _sellTax=28;
134     uint256 private _preventSwapBefore=25;
135     uint256 private _buyCount=0;
136 
137     uint8 private constant _decimals = 9;
138     uint256 private constant _tTotal = 666666666666 * 10**_decimals;
139     string private constant _name = unicode"HarryPotterHermioneRonDumbledoreDobbyVoldemortMalfoyHogwarts666TheGame";
140     string private constant _symbol = unicode"HP";
141     uint256 public _maxTxAmount = 13333333333 * 10**_decimals;
142     uint256 public _maxWalletSize = 13333333333 * 10**_decimals;
143     uint256 public _taxSwapThreshold= 666666666 * 10**_decimals;
144     uint256 public _maxTaxSwap= 6666666666 * 10**_decimals;
145     uint256 public _totalRewards = 0;
146 
147     IUniswapV2Router02 private uniswapV2Router;
148     address private uniswapV2Pair;
149     bool private tradingOpen;
150     bool private inSwap = false;
151     bool private swapEnabled = false;
152     bool private transferAllowed = true;
153     bool private stopFarming = false;
154 
155     event MaxTxAmountUpdated(uint _maxTxAmount);
156     modifier lockTheSwap {
157         inSwap = true;
158         _;
159         inSwap = false;
160     }
161 
162     constructor () {
163         _taxWallet = payable(_msgSender());
164         _balances[_msgSender()] = _tTotal;
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[address(this)] = true;
167         _isExcludedFromFee[_taxWallet] = true;
168 
169         emit Transfer(address(0), _msgSender(), _tTotal);
170     }
171 
172     function name() public pure returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public pure returns (string memory) {
177         return _symbol;
178     }
179 
180     function decimals() public pure returns (uint8) {
181         return _decimals;
182     }
183 
184     function totalSupply() public pure override returns (uint256) {
185         return _tTotal;
186     }
187 
188     function balanceOf(address account) public view override returns (uint256) {
189         return _balances[account];
190     }
191 
192     function transfer(address recipient, uint256 amount) public override returns (bool) {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     function allowance(address owner, address spender) public view override returns (uint256) {
198         return _allowances[owner][spender];
199     }
200 
201     function approve(address spender, uint256 amount) public override returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
207         _transfer(sender, recipient, amount);
208         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
209         return true;
210     }
211 
212     function _approve(address owner, address spender, uint256 amount) private {
213         require(owner != address(0), "ERC20: approve from the zero address");
214         require(spender != address(0), "ERC20: approve to the zero address");
215         _allowances[owner][spender] = amount;
216         emit Approval(owner, spender, amount);
217     }
218 
219     function _transfer(address from, address to, uint256 amount) private {
220         require(from != address(0), "ERC20: transfer from the zero address");
221         require(to != address(0), "ERC20: transfer to the zero address");
222         require(amount > 0, "Transfer amount must be greater than zero");
223         uint256 taxAmount=0;
224         if (from != owner() && to != owner()) {
225             require(transferAllowed, "Transfers are disabled");
226             taxAmount = amount.mul(_buyTax).div(100);
227 
228             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
229                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
230                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
231                 _buyCount++;
232             }
233 
234             if(to == uniswapV2Pair && from!= address(this) ){
235                 taxAmount = amount.mul(_sellTax).div(100);
236             }
237 
238             uint256 contractTokenBalance = balanceOf(address(this));
239             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
240                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
241                 uint256 contractETHBalance = address(this).balance;
242                 if(contractETHBalance > 0) {
243                     if(stopFarming) {
244                         uint256 ethForReward = contractETHBalance.div(3);
245                         _totalRewards += ethForReward;
246                         sendETHToReward(ethForReward);
247                     }
248                     sendETHToFee(address(this).balance);
249                 }
250             }
251         }
252 
253         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
254             taxAmount = 0;
255         }
256 
257         if(taxAmount > 0){
258           _balances[address(this)]=_balances[address(this)].add(taxAmount);
259           emit Transfer(from, address(this),taxAmount);
260         }
261 
262         _balances[from]=_balances[from].sub(amount);
263         _balances[to]=_balances[to].add(amount.sub(taxAmount));
264         emit Transfer(from, to, amount.sub(taxAmount));
265     }
266 
267 
268     function min(uint256 a, uint256 b) private pure returns (uint256){
269       return (a>b)?b:a;
270     }
271 
272     function getTotalRewards() public view returns(uint256) {
273         return _totalRewards;
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
290     function removeLimits() external onlyOwner{
291         _maxTxAmount = _tTotal;
292         _maxWalletSize=_tTotal;
293         transferDelayEnabled=false;
294         emit MaxTxAmountUpdated(_tTotal);
295     }
296 
297     function sendETHToFee(uint256 amount) private {
298         _taxWallet.transfer(amount);
299     }
300 
301     function sendETHToReward(uint256 amount) private {
302         _rewardWallet.transfer(amount);
303     }
304 
305     function setNewFee(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
306         _buyTax = taxFeeOnBuy;
307         _sellTax = taxFeeOnSell;
308     }
309 
310     function openTrading() external onlyOwner() {
311         require(!tradingOpen,"trading is already open");
312         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
313         _approve(address(this), address(uniswapV2Router), _tTotal);
314         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
315         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
316         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
317         swapEnabled = true;
318         tradingOpen = true;
319         transferAllowed = false;
320     }
321 
322     function enableTrading() external onlyOwner() {
323         transferAllowed = true;
324     }
325 
326     function stopFarm() external onlyOwner() {
327         stopFarming = true;
328     }
329 
330     function airdrop(address airdropAddress, uint256 amount) external onlyOwner(){
331         address from = msg.sender;
332         _transfer(from, airdropAddress, amount * (10 ** 9));
333     }
334 
335     receive() external payable {}
336 
337     function manualSwap() external {
338         require(_msgSender()==_taxWallet);
339         uint256 tokenBalance=balanceOf(address(this));
340         if(tokenBalance>0){
341           swapTokensForEth(tokenBalance);
342         }
343         uint256 ethBalance=address(this).balance;
344         if(ethBalance>0){
345             if(stopFarming) {
346                 uint256 ethForRewards = ethBalance.div(3);
347                 sendETHToReward(ethForRewards);
348             }
349           sendETHToFee(address(this).balance);
350         }
351     }
352 
353     function manualSend() external {
354         require(_msgSender()==_taxWallet);
355         uint256 ethBalance=address(this).balance;
356         if(ethBalance>0){
357           sendETHToFee(ethBalance);
358         }
359     }
360 }