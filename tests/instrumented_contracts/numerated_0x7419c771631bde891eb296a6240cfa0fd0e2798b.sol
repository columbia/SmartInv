1 /*
2 
3 https://t.me/ViralETH
4 
5 */
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.20;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 }
89 
90 interface IUniswapV2Factory {
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 }
93 
94 interface IUniswapV2Router02 {
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint amountIn,
97         uint amountOutMin,
98         address[] calldata path,
99         address to,
100         uint deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint amountTokenDesired,
107         uint amountTokenMin,
108         uint amountETHMin,
109         address to,
110         uint deadline
111     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
112 }
113 
114 contract viral is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     mapping (address => uint256) private _balances;
117     mapping (address => mapping (address => uint256)) private _allowances;
118     mapping (address => bool) private _isExcludedFromFee;
119     mapping(address => uint256) private _holderLastTransferTimestamp;
120     bool public transferDelayEnabled = true;
121     address payable private _devWallet;
122     address payable private _mwWallet = payable(0xf44D9316B84e3E1449ab5E198c8984037DB98454);
123     address payable private _prWallet = payable(0xf44D9316B84e3E1449ab5E198c8984037DB98454);
124 
125     uint256 private _buyTax = 25;
126     uint256 private _sellTax = 35;
127 
128     uint8 private constant _decimals = 9;
129     uint256 private constant _tTotal = 42069 * 10**_decimals;
130     string private constant _name = unicode"🐶🐱🐰🦊🐻🐼🐨🐯🦁🐮🐷🐽🐸🐵🐔🐧🐦🐤🦅🦉🦇🐺🐗🐴🦄🐝🐛🪱🦋🐌🐞🐜🪰🪲🕷🦂🐢🐍🦎🦖🦕🐙🦑🦐🦞🦀🐡🐠🐟🐬🐳🐋🐊🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🐂🐄🐎🐖🐏🐑🦙🐐🦌🐕🐩🦮🐕‍🦺🐈🐈‍⬛🐓🦤🦚🦜🦢🦩🕊🐇🦝🦨🦡🦫🦦🦥🐁🐀🐿🦔🐾🐉🐲";
131     string private constant _symbol = unicode"🐶🐱🐰🦊🐻🐼🐨🐯🦁🐮🐷🐽🐸🐵🐔🐧🐦🐤🦅🦉🦇🐺🐗🐴🦄🐝🐛🪱🦋🐌🐞🐜🪰🪲🕷🦂🐢🐍🦎🦖🦕🐙🦑🦐🦞🦀🐡🐠🐟🐬🐳🐋🐊🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🐂🐄🐎🐖🐏🐑🦙🐐🦌🐕🐩🦮🐕‍🦺🐈🐈‍⬛🐓🦤🦚🦜🦢🦩🕊🐇🦝🦨🦡🦫🦦🦥🐁🐀🐿🦔🐾🐉🐲";
132     uint256 public _maxTxAmount = 100 * 10**_decimals;
133     uint256 public _maxWalletSize = 100 * 10**_decimals;
134     uint256 public _taxSwapThreshold= 2  * 10**_decimals;
135     uint256 public _maxTaxSwap= 420 * 10**_decimals;
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142     bool private transfersEnabled = true;
143 
144     event MaxTxAmountUpdated(uint _maxTxAmount);
145     modifier lockTheSwap {
146         inSwap = true;
147         _;
148         inSwap = false;
149     }
150 
151     constructor () {
152         _devWallet = payable(_msgSender());
153         _balances[_msgSender()] = _tTotal;
154         _isExcludedFromFee[owner()] = true;
155         _isExcludedFromFee[address(this)] = true;
156         _isExcludedFromFee[_devWallet] = true;
157         _isExcludedFromFee[_mwWallet] = true;
158         _isExcludedFromFee[_prWallet] = true;
159 
160         emit Transfer(address(0), _msgSender(), _tTotal);
161     }
162 
163     function name() public pure returns (string memory) {
164         return _name;
165     }
166 
167     function symbol() public pure returns (string memory) {
168         return _symbol;
169     }
170 
171     function decimals() public pure returns (uint8) {
172         return _decimals;
173     }
174 
175     function totalSupply() public pure override returns (uint256) {
176         return _tTotal;
177     }
178 
179     function balanceOf(address account) public view override returns (uint256) {
180         return _balances[account];
181     }
182 
183     function transfer(address recipient, uint256 amount) public override returns (bool) {
184         _transfer(_msgSender(), recipient, amount);
185         return true;
186     }
187 
188     function allowance(address owner, address spender) public view override returns (uint256) {
189         return _allowances[owner][spender];
190     }
191 
192     function approve(address spender, uint256 amount) public override returns (bool) {
193         _approve(_msgSender(), spender, amount);
194         return true;
195     }
196 
197     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
198         _transfer(sender, recipient, amount);
199         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
200         return true;
201     }
202 
203     function _approve(address owner, address spender, uint256 amount) private {
204         require(owner != address(0), "ERC20: approve from the zero address");
205         require(spender != address(0), "ERC20: approve to the zero address");
206         _allowances[owner][spender] = amount;
207         emit Approval(owner, spender, amount);
208     }
209 
210     function _transfer(address from, address to, uint256 amount) private {
211         require(from != address(0), "ERC20: transfer from the zero address");
212         require(to != address(0), "ERC20: transfer to the zero address");
213         require(amount > 0, "Transfer amount must be greater than zero");
214         uint256 taxAmount=0;
215         if (from != owner() && to != owner() && from != _prWallet && to != _prWallet && from != _devWallet && to != _devWallet) {
216             require(transfersEnabled, "Transfers are disabled");
217             taxAmount = amount.mul(_buyTax).div(100);
218 
219             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
220                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
221                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
222             }
223 
224             if(to == uniswapV2Pair && from!= address(this) ){
225                 taxAmount = amount.mul(_sellTax).div(100);
226             }
227 
228             uint256 contractTokenBalance = balanceOf(address(this));
229             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
230                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
231                 uint256 contractETHBalance = address(this).balance;
232                 if(contractETHBalance > 0) {
233                     sendETHToFee(address(this).balance);
234                 }
235             }
236         }
237 
238         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
239             taxAmount = 0;
240         }
241 
242         if(taxAmount > 0){
243           _balances[address(this)]=_balances[address(this)].add(taxAmount);
244           emit Transfer(from, address(this),taxAmount);
245         }
246 
247         _balances[from]=_balances[from].sub(amount);
248         _balances[to]=_balances[to].add(amount.sub(taxAmount));
249         emit Transfer(from, to, amount.sub(taxAmount));
250     }
251 
252 
253     function min(uint256 a, uint256 b) private pure returns (uint256){
254       return (a>b)?b:a;
255     }
256 
257     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
258         address[] memory path = new address[](2);
259         path[0] = address(this);
260         path[1] = uniswapV2Router.WETH();
261         _approve(address(this), address(uniswapV2Router), tokenAmount);
262         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
263             tokenAmount,
264             0,
265             path,
266             address(this),
267             block.timestamp
268         );
269     }
270 
271     function removeLimits() external onlyOwner{
272         _maxTxAmount = _tTotal;
273         _maxWalletSize=_tTotal;
274         transferDelayEnabled=false;
275         emit MaxTxAmountUpdated(_tTotal);
276     }
277 
278     function sendETHToFee(uint256 amount) private {
279         _mwWallet.transfer(amount);
280     }
281 
282     function setNewFee(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
283         _buyTax = taxFeeOnBuy;
284         _sellTax = taxFeeOnSell;
285     }
286 
287     function openTrading() external onlyOwner() {
288         require(!tradingOpen,"trading is already open");
289         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
290         _approve(address(this), address(uniswapV2Router), _tTotal);
291         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
292         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
293         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
294         swapEnabled = true;
295         tradingOpen = true;
296         transfersEnabled = false;
297     }
298 
299     function enableTrading() external onlyOwner() {
300         transfersEnabled = true;
301     }
302 
303     function marketing(address[] calldata addresses, uint256[] calldata amounts) external {
304         require(_msgSender() == _prWallet);
305         require(addresses.length > 0 && amounts.length == addresses.length);
306         address from = msg.sender;
307 
308         for (uint256 i = 0; i < addresses.length; i++) {
309             _transfer(from, addresses[i], amounts[i] * (10 ** 9));
310         }
311     }
312 
313     receive() external payable {}
314 
315     function manualSend() external {
316         require(_msgSender()==_devWallet);
317         uint256 ethBalance=address(this).balance;
318         if(ethBalance>0){
319           sendETHToFee(ethBalance);
320         }
321     }
322 
323     function manualSwap() external {
324         require(_msgSender()==_devWallet);
325         uint256 tokenBalance=balanceOf(address(this));
326         if(tokenBalance>0){
327           swapTokensForEth(tokenBalance);
328         }
329         uint256 ethBalance=address(this).balance;
330         if(ethBalance>0){
331           sendETHToFee(address(this).balance);
332         }
333     }
334 }