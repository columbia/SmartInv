1 // $XFINITE ultimate bot is coming‼️
2 // Are you guys ready for the ultimate game changer?
3 //https://t.me/Xfinite_Bot
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.17;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor () {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87 }
88 
89 interface IUniswapV2Factory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IUniswapV2Router02 {
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103     function addLiquidityETH(
104         address token,
105         uint amountTokenDesired,
106         uint amountTokenMin,
107         uint amountETHMin,
108         address to,
109         uint deadline
110     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
111 }
112 contract XfiniteBot is Context , IERC20, Ownable {
113     using SafeMath for uint256;
114     mapping (address => uint256) private _balances;
115     mapping (address => mapping (address => uint256)) private _allowances;
116     mapping (address => bool) private _isExcludedFromFee;
117     mapping (address => bool) private bots;
118     mapping(address => uint256) private _holderLastTransferTimestamp;
119     bool public transferDelayEnabled = true;
120     address payable private _taxWallet;
121     uint256 private _initialBuyTax=25;
122     uint256 private _initialSellTax=25;
123     uint256 private _finalBuyTax=2;
124     uint256 private _finalSellTax=2;
125     uint256 private _reduceBuyTaxAt=25;
126     uint256 private _reduceSellTaxAt=25; 
127     uint256 private _preventSwapBefore=30;
128     uint256 private _buyCount=0;
129 
130     uint8 private constant _decimals = 9;
131     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
132     string private constant _name = "XfiniteBot";
133     string private constant _symbol = "Xfinite";
134     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
135     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
136     uint256 public _taxSwapThreshold= 10000000 * 10**_decimals;
137     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
138 
139     IUniswapV2Router02 private uniswapV2Router;
140     address private uniswapV2Pair;
141     bool private tradingOpen;
142     bool private inSwap = false;
143     bool private swapEnabled = false;
144 
145     event MaxTxAmountUpdated(uint _maxTxAmount);
146     modifier lockTheSwap {
147         inSwap = true;
148         _;
149         inSwap = false;
150     }
151 
152     constructor () {
153         _taxWallet = payable(_msgSender());
154         _balances[_msgSender()] = _tTotal;
155         _isExcludedFromFee[owner()] = true;
156         _isExcludedFromFee[address(this)] = true;
157         _isExcludedFromFee[_taxWallet] = true;
158 
159         emit Transfer(address(0), _msgSender(), _tTotal);
160     }
161 
162     function name() public pure returns (string memory) {
163         return _name;
164     }
165 
166     function symbol() public pure returns (string memory) {
167         return _symbol;
168     }
169 
170     function decimals() public pure returns (uint8) {
171         return _decimals;
172     }
173 
174     function totalSupply() public pure override returns (uint256) {
175         return _tTotal;
176     }
177 
178     function balanceOf(address account) public view override returns (uint256) {
179         return _balances[account];
180     }
181 
182     function transfer(address recipient, uint256 amount) public override returns (bool) {
183         _transfer(_msgSender(), recipient, amount);
184         return true;
185     }
186 
187     function allowance(address owner, address spender) public view override returns (uint256) {
188         return _allowances[owner][spender];
189     }
190 
191     function approve(address spender, uint256 amount) public override returns (bool) {
192         _approve(_msgSender(), spender, amount);
193         return true;
194     }
195 
196     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
197         _transfer(sender, recipient, amount);
198         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
199         return true;
200     }
201 
202     function _approve(address owner, address spender, uint256 amount) private {
203         require(owner != address(0), "ERC20: approve from the zero address");
204         require(spender != address(0), "ERC20: approve to the zero address");
205         _allowances[owner][spender] = amount;
206         emit Approval(owner, spender, amount);
207     }
208 
209     function _transfer(address from, address to, uint256 amount) private {
210         require(from != address(0), "ERC20: transfer from the zero address");
211         require(to != address(0), "ERC20: transfer to the zero address");
212         require(amount > 0, "Transfer amount must be greater than zero");
213         uint256 taxAmount=0;
214         if (from != owner() && to != owner()) {
215             require(!bots[from] && !bots[to]);
216             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
217 
218             if (transferDelayEnabled) {
219                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
220                       require(
221                           _holderLastTransferTimestamp[tx.origin] <
222                               block.number,
223                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
224                       );
225                       _holderLastTransferTimestamp[tx.origin] = block.number;
226                   }
227               }
228               if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
229                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
230                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
231                 _buyCount++;
232             }
233 
234             if(to == uniswapV2Pair && from!= address(this) ){
235                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
236             }
237 
238             uint256 contractTokenBalance = balanceOf(address(this));
239             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
240                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
241                 uint256 contractETHBalance = address(this).balance;
242                 if(contractETHBalance > 0) {
243                     sendETHToFee(address(this).balance);
244                 }
245             }
246         }
247 
248         if(taxAmount>0){
249           _balances[address(this)]=_balances[address(this)].add(taxAmount);
250           emit Transfer(from, address(this),taxAmount);
251         }
252         _balances[from]=_balances[from].sub(amount);
253         _balances[to]=_balances[to].add(amount.sub(taxAmount));
254         emit Transfer(from, to, amount.sub(taxAmount));
255     }
256 
257 
258     function min(uint256 a, uint256 b) private pure returns (uint256){
259       return (a>b)?b:a;
260     }
261 
262     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
263         address[] memory path = new address[](2);
264         path[0] = address(this);
265         path[1] = uniswapV2Router.WETH();
266         _approve(address(this), address(uniswapV2Router), tokenAmount);
267         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
268             tokenAmount,
269             0,
270             path,
271             address(this),
272             block.timestamp
273         );
274     }
275 
276     function removeLimits() external onlyOwner{
277         _maxTxAmount = _tTotal;
278         _maxWalletSize=_tTotal;
279         transferDelayEnabled=false;
280         emit MaxTxAmountUpdated(_tTotal);
281     }
282 
283     function sendETHToFee(uint256 amount) private {
284         _taxWallet.transfer(amount);
285     }
286 
287     function addBots(address[] memory bots_) public onlyOwner {
288         for (uint i = 0; i < bots_.length; i++) {
289             bots[bots_[i]] = true;
290         }
291     }
292 
293     function delBots(address[] memory notbot) public onlyOwner {
294       for (uint i = 0; i < notbot.length; i++) {
295           bots[notbot[i]] = false;
296       }
297     }
298 
299     function isBot(address a) public view returns (bool){
300       return bots[a];
301     }
302 
303     function openTrading() external onlyOwner() {
304         require(!tradingOpen,"trading is already open");
305         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
306         _approve(address(this), address(uniswapV2Router), _tTotal);
307         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
308         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
309         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
310         swapEnabled = true;
311         tradingOpen = true;
312     }
313 
314     
315     function reduceFee(uint256 _newFee) external{
316       require(_msgSender()==_taxWallet);
317       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
318       _finalBuyTax=_newFee;
319       _finalSellTax=_newFee;
320     }
321 
322     receive() external payable {}
323 
324     function manualSwap() external {
325         require(_msgSender()==_taxWallet);
326         uint256 tokenBalance=balanceOf(address(this));
327         if(tokenBalance>0){
328           swapTokensForEth(tokenBalance);
329         }
330         uint256 ethBalance=address(this).balance;
331         if(ethBalance>0){
332           sendETHToFee(ethBalance);
333         }
334     }
335 }