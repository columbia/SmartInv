1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Token name: 0x556
5 Ticker: 0x556
6 Supply: 999
7 
8 Ethereum's co-founder, Vitalik Buterin, transferred 999 $ETH ($1.63M) from the better-known address 0xD04 to address 0x556 20 hours ago:
9 
10 txid: https://etherscan.io/tx/0xa1111970c149cbd1f5782f9dadd977439eba1ec2c25fe8ccfdc9bb6003d06664
11 
12 better-known address: https://platform.spotonchain.ai/profile?address=0xd04daa65144b97f147fbc9a9b45e741df0a28fd7
13 
14 other address: https://platform.spotonchain.ai/profile?address=0x5567A4bE2D5b77F5Fd870f99Ed9167Feab8831B1
15 
16 https://platform.spotonchain.ai/signal-details/vitalik-buterin-sold-mkr-and-may-deposit-eth-to-bitstamp-soon-531
17 
18 TG: https://t.me/Vitalik_0x556
19 TWITTER: https://twitter.com/Vitalik_0x556
20 WEBSITE: https://vitalik0x566.com
21 
22 
23 **/
24 pragma solidity 0.8.20;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34     function balanceOf(address account) external view returns (uint256);
35     function transfer(address recipient, uint256 amount) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37     function approve(address spender, uint256 amount) external returns (bool);
38     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 library SafeMath {
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57         return c;
58     }
59 
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         if (a == 0) {
62             return 0;
63         }
64         uint256 c = a * b;
65         require(c / a == b, "SafeMath: multiplication overflow");
66         return c;
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return div(a, b, "SafeMath: division by zero");
71     }
72 
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b > 0, errorMessage);
75         uint256 c = a / b;
76         return c;
77     }
78 
79 }
80 
81 contract Ownable is Context {
82     address private _owner;
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     constructor () {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90 
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     function renounceOwnership() public virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104 
105 }
106 
107 interface IUniswapV2Factory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IUniswapV2Router02 {
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129 }
130 
131 contract x556 is Context, IERC20, Ownable {
132     using SafeMath for uint256;
133     mapping (address => uint256) private _balances;
134     mapping (address => mapping (address => uint256)) private _allowances;
135     mapping (address => bool) private _isExcludedFromFee;
136     mapping (address => bool) private _buyerMap;
137     mapping (address => bool) private bots;
138     mapping(address => uint256) private _holderLastTransferTimestamp;
139     bool public transferDelayEnabled = false;
140     address payable private _taxWallet;
141 
142     uint256 private _initialBuyTax=10;
143     uint256 private _initialSellTax=40;
144     uint256 private _finalBuyTax=1;
145     uint256 private _finalSellTax=1;
146     uint256 private _reduceBuyTaxAt=10;
147     uint256 private _reduceSellTaxAt=20;
148     uint256 private _preventSwapBefore=40;
149     uint256 private _buyCount=0;
150 
151     uint8 private constant _decimals = 9;
152     uint256 private constant _tTotal = 999 * 10**_decimals;
153     string private constant _name = unicode"0x556";
154     string private constant _symbol = unicode"0x556";
155     uint256 public _maxTxAmount = 2 * 10**_decimals;
156     uint256 public _maxWalletSize = 2 * 10**_decimals;
157     uint256 public _taxSwapThreshold= 1 * 10**_decimals;
158     uint256 public _maxTaxSwap= 1 * 10**_decimals;
159 
160     IUniswapV2Router02 private uniswapV2Router;
161     address private uniswapV2Pair;
162     bool private tradingOpen;
163     bool private inSwap = false;
164     bool private swapEnabled = false;
165 
166     event MaxTxAmountUpdated(uint _maxTxAmount);
167     modifier lockTheSwap {
168         inSwap = true;
169         _;
170         inSwap = false;
171     }
172 
173     constructor () {
174         _taxWallet = payable(_msgSender());
175         _balances[_msgSender()] = _tTotal;
176         _isExcludedFromFee[owner()] = true;
177         _isExcludedFromFee[address(this)] = true;
178         _isExcludedFromFee[_taxWallet] = true;
179 
180         emit Transfer(address(0), _msgSender(), _tTotal);
181     }
182 
183     function name() public pure returns (string memory) {
184         return _name;
185     }
186 
187     function symbol() public pure returns (string memory) {
188         return _symbol;
189     }
190 
191     function decimals() public pure returns (uint8) {
192         return _decimals;
193     }
194 
195     function totalSupply() public pure override returns (uint256) {
196         return _tTotal;
197     }
198 
199     function balanceOf(address account) public view override returns (uint256) {
200         return _balances[account];
201     }
202 
203     function transfer(address recipient, uint256 amount) public override returns (bool) {
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     function allowance(address owner, address spender) public view override returns (uint256) {
209         return _allowances[owner][spender];
210     }
211 
212     function approve(address spender, uint256 amount) public override returns (bool) {
213         _approve(_msgSender(), spender, amount);
214         return true;
215     }
216 
217     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
218         _transfer(sender, recipient, amount);
219         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
220         return true;
221     }
222 
223     function _approve(address owner, address spender, uint256 amount) private {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _transfer(address from, address to, uint256 amount) private {
231         require(from != address(0), "ERC20: transfer from the zero address");
232         require(to != address(0), "ERC20: transfer to the zero address");
233         require(amount > 0, "Transfer amount must be greater than zero");
234         uint256 taxAmount=0;
235         if (from != owner() && to != owner()) {
236             require(!bots[from] && !bots[to]);
237 
238             if (transferDelayEnabled) {
239                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
240                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
241                   _holderLastTransferTimestamp[tx.origin] = block.number;
242                 }
243             }
244 
245             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
246                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
247                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
248                 if(_buyCount<_preventSwapBefore){
249                   require(!isContract(to));
250                 }
251                 _buyCount++;
252                 _buyerMap[to]=true;
253             }
254 
255 
256             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
257             if(to == uniswapV2Pair && from!= address(this) ){
258                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
259                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
260                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
261             }
262 
263             uint256 contractTokenBalance = balanceOf(address(this));
264             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
265                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
266                 uint256 contractETHBalance = address(this).balance;
267                 if(contractETHBalance > 0) {
268                     sendETHToFee(address(this).balance);
269                 }
270             }
271         }
272 
273         if(taxAmount>0){
274           _balances[address(this)]=_balances[address(this)].add(taxAmount);
275           emit Transfer(from, address(this),taxAmount);
276         }
277         _balances[from]=_balances[from].sub(amount);
278         _balances[to]=_balances[to].add(amount.sub(taxAmount));
279         emit Transfer(from, to, amount.sub(taxAmount));
280     }
281 
282 
283     function min(uint256 a, uint256 b) private pure returns (uint256){
284       return (a>b)?b:a;
285     }
286 
287     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
288         if(tokenAmount==0){return;}
289         if(!tradingOpen){return;}
290         address[] memory path = new address[](2);
291         path[0] = address(this);
292         path[1] = uniswapV2Router.WETH();
293         _approve(address(this), address(uniswapV2Router), tokenAmount);
294         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
295             tokenAmount,
296             0,
297             path,
298             address(this),
299             block.timestamp
300         );
301     }
302 
303     function removeLimits() external onlyOwner{
304         _maxTxAmount = _tTotal;
305         _maxWalletSize=_tTotal;
306         transferDelayEnabled=false;
307         emit MaxTxAmountUpdated(_tTotal);
308     }
309 
310     function sendETHToFee(uint256 amount) private {
311         _taxWallet.transfer(amount);
312     }
313 
314     function isBot(address a) public view returns (bool){
315       return bots[a];
316     }
317 
318     function openTrading() external onlyOwner() {
319         require(!tradingOpen,"trading is already open");
320         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
321         _approve(address(this), address(uniswapV2Router), _tTotal);
322         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
323         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
324         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
325         swapEnabled = true;
326         tradingOpen = true;
327     }
328 
329     receive() external payable {}
330 
331     function isContract(address account) private view returns (bool) {
332         uint256 size;
333         assembly {
334             size := extcodesize(account)
335         }
336         return size > 0;
337     }
338 
339     function manualSwap() external {
340         require(_msgSender()==_taxWallet);
341         uint256 tokenBalance=balanceOf(address(this));
342         if(tokenBalance>0){
343           swapTokensForEth(tokenBalance);
344         }
345         uint256 ethBalance=address(this).balance;
346         if(ethBalance>0){
347           sendETHToFee(ethBalance);
348         }
349     }
350 
351     
352     
353     function reduceFee(uint256 _newFee) external{
354       require(_msgSender()==_taxWallet);
355       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
356       _finalBuyTax=_newFee;
357       _finalSellTax=_newFee;
358     }
359     
360 }