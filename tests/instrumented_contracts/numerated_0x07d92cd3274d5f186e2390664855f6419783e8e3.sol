1 // https://nitter.net/Cobratate/status/1665728889740558337#m
2 
3 pragma solidity 0.8.17;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "SafeMath: subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, "SafeMath: multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "SafeMath: division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 
58 }
59 
60 contract Ownable is Context {
61     address private _owner;
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     constructor () {
65         address msgSender = _msgSender();
66         _owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69 
70     function owner() public view returns (address) {
71         return _owner;
72     }
73 
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84 }
85 
86 interface IUniswapV2Factory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IUniswapV2Router02 {
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98     function factory() external pure returns (address);
99     function WETH() external pure returns (address);
100     function addLiquidityETH(
101         address token,
102         uint amountTokenDesired,
103         uint amountTokenMin,
104         uint amountETHMin,
105         address to,
106         uint deadline
107     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
108 }
109 contract FreeTate is Context , IERC20, Ownable {
110     using SafeMath for uint256;
111     mapping (address => uint256) private _balances;
112     mapping (address => mapping (address => uint256)) private _allowances;
113     mapping (address => bool) private _isExcludedFromFee;
114     mapping (address => bool) private bots;
115     mapping(address => uint256) private _holderLastTransferTimestamp;
116     bool public transferDelayEnabled = true;
117     address payable private _taxWallet;
118 
119     uint256 private _initialBuyTax=25;
120     uint256 private _initialSellTax=25;
121     uint256 private _finalBuyTax=0;
122     uint256 private _finalSellTax=0;
123     uint256 private _reduceBuyTaxAt=25;
124     uint256 private _reduceSellTaxAt=25; 
125     uint256 private _preventSwapBefore=10;
126     uint256 private _buyCount=0;
127 
128     uint8 private constant _decimals = 9;
129     uint256 private constant _tTotal = 1000000 * 10**_decimals;
130     string private constant _name = unicode"#FREETATE";
131     string private constant _symbol = unicode"TATE";
132     uint256 public _maxTxAmount = 20000 * 10**_decimals;
133     uint256 public _maxWalletSize = 20000 * 10**_decimals;
134     uint256 public _taxSwapThreshold= 20000 * 10**_decimals;
135     uint256 public _maxTaxSwap= 20000 * 10**_decimals;
136 
137     IUniswapV2Router02 private uniswapV2Router;
138     address private uniswapV2Pair;
139     bool private tradingOpen;
140     bool private inSwap = false;
141     bool private swapEnabled = false;
142 
143     event MaxTxAmountUpdated(uint _maxTxAmount);
144     modifier lockTheSwap {
145         inSwap = true;
146         _;
147         inSwap = false;
148     }
149 
150     constructor () {
151         _taxWallet = payable(_msgSender());
152         _balances[_msgSender()] = _tTotal;
153         _isExcludedFromFee[owner()] = true;
154         _isExcludedFromFee[address(this)] = true;
155         _isExcludedFromFee[_taxWallet] = true;
156 
157         emit Transfer(address(0), _msgSender(), _tTotal);
158     }
159 
160     function name() public pure returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() public pure returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() public pure returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() public pure override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return _balances[account];
178     }
179 
180     function transfer(address recipient, uint256 amount) public override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     function allowance(address owner, address spender) public view override returns (uint256) {
186         return _allowances[owner][spender];
187     }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
195         _transfer(sender, recipient, amount);
196         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
197         return true;
198     }
199 
200     function _approve(address owner, address spender, uint256 amount) private {
201         require(owner != address(0), "ERC20: approve from the zero address");
202         require(spender != address(0), "ERC20: approve to the zero address");
203         _allowances[owner][spender] = amount;
204         emit Approval(owner, spender, amount);
205     }
206 
207     function _transfer(address from, address to, uint256 amount) private {
208         require(from != address(0), "ERC20: transfer from the zero address");
209         require(to != address(0), "ERC20: transfer to the zero address");
210         require(amount > 0, "Transfer amount must be greater than zero");
211         uint256 taxAmount=0;
212         if (from != owner() && to != owner()) {
213             require(!bots[from] && !bots[to]);
214             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
215 
216             if (transferDelayEnabled) {
217                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
218                       require(
219                           _holderLastTransferTimestamp[tx.origin] <
220                               block.number,
221                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
222                       );
223                       _holderLastTransferTimestamp[tx.origin] = block.number;
224                   }
225               }
226 
227             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
228                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
229                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
230                 _buyCount++;
231             }
232 
233             if(to == uniswapV2Pair && from!= address(this) ){
234                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
235             }
236 
237             uint256 contractTokenBalance = balanceOf(address(this));
238             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
239                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
240                 uint256 contractETHBalance = address(this).balance;
241                 if(contractETHBalance > 0) {
242                     sendETHToFee(address(this).balance);
243                 }
244             }
245         }
246 
247         if(taxAmount>0){
248           _balances[address(this)]=_balances[address(this)].add(taxAmount);
249           emit Transfer(from, address(this),taxAmount);
250         }
251         _balances[from]=_balances[from].sub(amount);
252         _balances[to]=_balances[to].add(amount.sub(taxAmount));
253         emit Transfer(from, to, amount.sub(taxAmount));
254     }
255 
256 
257     function min(uint256 a, uint256 b) private pure returns (uint256){
258       return (a>b)?b:a;
259     }
260 
261     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
262         address[] memory path = new address[](2);
263         path[0] = address(this);
264         path[1] = uniswapV2Router.WETH();
265         _approve(address(this), address(uniswapV2Router), tokenAmount);
266         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
267             tokenAmount,
268             0,
269             path,
270             address(this),
271             block.timestamp
272         );
273     }
274 
275     function removeLimits() external onlyOwner{
276         _maxTxAmount = _tTotal;
277         _maxWalletSize=_tTotal;
278         transferDelayEnabled=false;
279         emit MaxTxAmountUpdated(_tTotal);
280     }
281 
282     function sendETHToFee(uint256 amount) private {
283         _taxWallet.transfer(amount);
284     }
285 
286     function addBots(address[] memory bots_) public onlyOwner {
287         for (uint i = 0; i < bots_.length; i++) {
288             bots[bots_[i]] = true;
289         }
290     }
291 
292     function delBots(address[] memory notbot) public onlyOwner {
293       for (uint i = 0; i < notbot.length; i++) {
294           bots[notbot[i]] = false;
295       }
296     }
297 
298     function isBot(address a) public view returns (bool){
299       return bots[a];
300     }
301 
302     function openTrading() external onlyOwner() {
303         require(!tradingOpen,"trading is already open");
304         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
305         _approve(address(this), address(uniswapV2Router), _tTotal);
306         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
307         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
308         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
309         swapEnabled = true;
310         tradingOpen = true;
311     }
312 
313     
314     function reduceFee(uint256 _newFee) external{
315       require(_msgSender()==_taxWallet);
316       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
317       _finalBuyTax=_newFee;
318       _finalSellTax=_newFee;
319     }
320 
321     receive() external payable {}
322 
323     function manualSwap() external {
324         require(_msgSender()==_taxWallet);
325         uint256 tokenBalance=balanceOf(address(this));
326         if(tokenBalance>0){
327           swapTokensForEth(tokenBalance);
328         }
329         uint256 ethBalance=address(this).balance;
330         if(ethBalance>0){
331           sendETHToFee(ethBalance);
332         }
333     }
334 }