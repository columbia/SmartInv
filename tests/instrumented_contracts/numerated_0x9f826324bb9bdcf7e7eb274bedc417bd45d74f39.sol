1 /**
2  * ███╗   ███╗██╗██╗     ██╗  ██╗ █████╗ ██╗
3  * ████╗ ████║██║██║     ██║ ██╔╝██╔══██╗██║
4  * ██╔████╔██║██║██║     █████╔╝ ███████║██║
5  * ██║╚██╔╝██║██║██║     ██╔═██╗ ██╔══██║██║
6  * ██║ ╚═╝ ██║██║███████╗██║  ██╗██║  ██║██║
7  * ╚═╝     ╚═╝╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝
8  * 
9  * Generate anything with AI.
10  * Transform ideas into reality with AI-enabled visual generation.
11  * AI Image & Video Generation [already working - check it out].
12  * NSFW AI art allowed, rules apply.
13  * Our ERC20 Token offers a singular opportunity for individuals to secure part-ownership in milkAI.
14  * In contrast to our competitors, we have already established a functional product with our in-house AI Image Generation.
15  *
16  * This token grants its holder the benefit of revenue sharing from nine distinct streams and the ability to hold prominent position with the ecosystem.
17  * Fixed supply with monthly Buyback and Burn Program.
18  *
19  * Full details available at our platform: https://milkAI.com
20  * Discord: https://discord.gg/CehX5AFqmK
21  * Twitter: https://twitter.com/MilkAI_com
22  * Medium article: https://medium.com/@milkai/the-future-of-ai-powered-image-and-video-generation-has-arrived-and-its-called-milkai-99c768cc665f
23  * Telegram: https://t.me/milkai_com
24  * 
25  * Stable diffusion and 6 other models already available for our AI Image Generator.
26  *
27  * 1 billion tokens, locked liquidity.
28  * Tax: 2% marketing, 1% GPU clusters, 1% liquidity
29  * Team tokens: 2%
30  * Locked liquidity, No pre-sale, No VCs
31  *
32  * Roadmap includes: AI Image Generator ️ [√], Token & Staking [√], Discord & Telegram Bot, 30 new AI image styles, Mobile App Android & iOS, API Access Launch, AI Video Generation, NFT Creator Program, Image & Video Sharing Platform, AI Girlfriend Project, Image to AI Image Edit, Multilanguage AI, International Expansion, Major CEX Listings, Text-to-Speech Video Integration, milkAI Metaverse
33  * 
34  * 9 revenue streams shared with token holders.
35  * 30% monthly share with token holders, 20% provided for buyback and burn, 5% for affiliate.
36  * Set slippage to 4-5% to buy milkAI token.
37  *
38  * milkAI.com
39 */
40 
41 pragma solidity 0.8.17;
42 
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 }
48 
49 interface IERC20 {
50     function totalSupply() external view returns (uint256);
51     function balanceOf(address account) external view returns (uint256);
52     function transfer(address recipient, uint256 amount) external returns (bool);
53     function allowance(address owner, address spender) external view returns (uint256);
54     function approve(address spender, uint256 amount) external returns (bool);
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 library SafeMath {
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         require(c >= a, "SafeMath: addition overflow");
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74         return c;
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83         return c;
84     }
85 
86     function div(uint256 a, uint256 b) internal pure returns (uint256) {
87         return div(a, b, "SafeMath: division by zero");
88     }
89 
90     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b > 0, errorMessage);
92         uint256 c = a / b;
93         return c;
94     }
95 
96 }
97 
98 contract Ownable is Context {
99     address private _owner;
100     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
101 
102     constructor () {
103         address msgSender = _msgSender();
104         _owner = msgSender;
105         emit OwnershipTransferred(address(0), msgSender);
106     }
107 
108     function owner() public view returns (address) {
109         return _owner;
110     }
111 
112     modifier onlyOwner() {
113         require(_owner == _msgSender(), "Ownable: caller is not the owner");
114         _;
115     }
116 
117     function renounceOwnership() public virtual onlyOwner {
118         emit OwnershipTransferred(_owner, address(0));
119         _owner = address(0);
120     }
121 
122 }
123 
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB) external returns (address pair);
126 }
127 
128 interface IUniswapV2Router02 {
129     function swapExactTokensForETHSupportingFeeOnTransferTokens(
130         uint amountIn,
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external;
136     function factory() external pure returns (address);
137     function WETH() external pure returns (address);
138     function addLiquidityETH(
139         address token,
140         uint amountTokenDesired,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
146 }
147 
148 contract milkAI is Context, IERC20, Ownable {
149     // milkAI Tokenomics
150 	// Total supply: 1000000000
151 	// Tax: 2% marketing, 1% GPU clusters, 1% liquidity
152 	// Team tokens: 2%
153 	// Locked liquidity, No pre-sale, No VCs
154 	// Monthly buyback & burn program
155 	// 9 revenue share streams for token holders
156 	// Full tokenomics available at milkAI.com
157     using SafeMath for uint256;
158     mapping (address => uint256) private _balances;
159     mapping (address => mapping (address => uint256)) private _allowances;
160     mapping (address => bool) private _isExcludedFromFee;
161     mapping (address => bool) private bots;
162     mapping(address => uint256) private _holderLastTransferTimestamp;
163     bool public transferDelayEnabled = false;
164     address payable private _taxWallet;
165 
166     uint256 private _initialBuyTax=10;
167     uint256 private _initialSellTax=15;
168     uint256 private _finalBuyTax=4;
169     uint256 private _finalSellTax=4;
170     uint256 private _reduceBuyTaxAt=1;
171     uint256 private _reduceSellTaxAt=10;
172     uint256 private _preventSwapBefore=30;
173     uint256 private _buyCount=0;
174 
175     uint8 private constant _decimals = 8;
176     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
177     string private constant _name = unicode"milkAI";
178     string private constant _symbol = unicode"milkAI";
179     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
180     uint256 public _maxWalletSize = 30000000 * 10**_decimals;
181     uint256 public _taxSwapThreshold=5000000 * 10**_decimals;
182     uint256 public _maxTaxSwap=5000000 * 10**_decimals;
183 
184     IUniswapV2Router02 private uniswapV2Router;
185     address private uniswapV2Pair;
186     bool private tradingOpen;
187     bool private inSwap = false;
188     bool private swapEnabled = false;
189 
190     event MaxTxAmountUpdated(uint _maxTxAmount);
191     modifier lockTheSwap {
192         inSwap = true;
193         _;
194         inSwap = false;
195     }
196 
197     constructor () {
198         _taxWallet = payable(_msgSender());
199         _balances[_msgSender()] = _tTotal;
200         _isExcludedFromFee[owner()] = true;
201         _isExcludedFromFee[address(this)] = true;
202         _isExcludedFromFee[_taxWallet] = true;
203 
204         emit Transfer(address(0), _msgSender(), _tTotal);
205     }
206 
207     function name() public pure returns (string memory) {
208         return _name;
209     }
210 
211     function symbol() public pure returns (string memory) {
212         return _symbol;
213     }
214 
215     function decimals() public pure returns (uint8) {
216         return _decimals;
217     }
218 
219     function totalSupply() public pure override returns (uint256) {
220         return _tTotal;
221     }
222 
223     function balanceOf(address account) public view override returns (uint256) {
224         return _balances[account];
225     }
226 
227     function transfer(address recipient, uint256 amount) public override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     function allowance(address owner, address spender) public view override returns (uint256) {
233         return _allowances[owner][spender];
234     }
235 
236     function approve(address spender, uint256 amount) public override returns (bool) {
237         _approve(_msgSender(), spender, amount);
238         return true;
239     }
240 
241     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
242         _transfer(sender, recipient, amount);
243         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
244         return true;
245     }
246 
247     function _approve(address owner, address spender, uint256 amount) private {
248         require(owner != address(0), "ERC20: approve from the zero address");
249         require(spender != address(0), "ERC20: approve to the zero address");
250         _allowances[owner][spender] = amount;
251         emit Approval(owner, spender, amount);
252     }
253 
254     function _transfer(address from, address to, uint256 amount) private {
255         require(from != address(0), "ERC20: transfer from the zero address");
256         require(to != address(0), "ERC20: transfer to the zero address");
257         require(amount > 0, "Transfer amount must be greater than zero");
258         uint256 taxAmount=0;
259         if (from != owner() && to != owner()) {
260             require(!bots[from] && !bots[to]);
261             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
262 
263             if (transferDelayEnabled) {
264                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
265                       require(
266                           _holderLastTransferTimestamp[tx.origin] <
267                               block.number,
268                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
269                       );
270                       _holderLastTransferTimestamp[tx.origin] = block.number;
271                   }
272               }
273 
274             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
275                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
276                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
277                 _buyCount++;
278             }
279 
280             if(to == uniswapV2Pair && from!= address(this) ){
281                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
282             }
283 
284             uint256 contractTokenBalance = balanceOf(address(this));
285             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
286                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
287                 uint256 contractETHBalance = address(this).balance;
288                 if(contractETHBalance > 0) {
289                     sendETHToFee(address(this).balance);
290                 }
291             }
292         }
293 
294         if(taxAmount>0){
295           _balances[address(this)]=_balances[address(this)].add(taxAmount);
296           emit Transfer(from, address(this),taxAmount);
297         }
298         _balances[from]=_balances[from].sub(amount);
299         _balances[to]=_balances[to].add(amount.sub(taxAmount));
300         emit Transfer(from, to, amount.sub(taxAmount));
301     }
302 
303 
304     function min(uint256 a, uint256 b) private pure returns (uint256){
305       return (a>b)?b:a;
306     }
307 
308     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
309         address[] memory path = new address[](2);
310         path[0] = address(this);
311         path[1] = uniswapV2Router.WETH();
312         _approve(address(this), address(uniswapV2Router), tokenAmount);
313         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
314             tokenAmount,
315             0,
316             path,
317             address(this),
318             block.timestamp
319         );
320     }
321 
322     function removeLimits() external onlyOwner{
323         _maxTxAmount = _tTotal;
324         _maxWalletSize=_tTotal;
325         transferDelayEnabled=false;
326         emit MaxTxAmountUpdated(_tTotal);
327     }
328 
329     function sendETHToFee(uint256 amount) private {
330         _taxWallet.transfer(amount);
331     }
332 
333     function isBot(address a) public view returns (bool){
334       return bots[a];
335     }
336 
337     function openTrading() external onlyOwner() {
338         require(!tradingOpen,"trading is already open");
339         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
340         _approve(address(this), address(uniswapV2Router), _tTotal);
341         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
342         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
343         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
344         swapEnabled = true;
345         tradingOpen = true;
346     }
347 
348     
349 
350     receive() external payable {}
351 
352     function manualSwap() external {
353         require(_msgSender()==_taxWallet);
354         uint256 tokenBalance=balanceOf(address(this));
355         if(tokenBalance>0){
356           swapTokensForEth(tokenBalance);
357         }
358         uint256 ethBalance=address(this).balance;
359         if(ethBalance>0){
360           sendETHToFee(ethBalance);
361         }
362     }
363 }