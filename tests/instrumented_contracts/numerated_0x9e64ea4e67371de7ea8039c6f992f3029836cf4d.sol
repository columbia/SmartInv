1 /**
2   /$$$$$$  /$$   /$$ /$$   /$$ /$$$$$$$  /$$$$$$$$ /$$$$$$$$
3  /$$__  $$| $$  | $$| $$$ | $$| $$__  $$| $$_____/|__  $$__/
4 | $$  \__/| $$  | $$| $$$$| $$| $$  \ $$| $$         | $$   
5 | $$ /$$$$| $$  | $$| $$ $$ $$| $$$$$$$ | $$$$$      | $$   
6 | $$|_  $$| $$  | $$| $$  $$$$| $$__  $$| $$__/      | $$   
7 | $$  \ $$| $$  | $$| $$\  $$$| $$  \ $$| $$         | $$   
8 |  $$$$$$/|  $$$$$$/| $$ \  $$| $$$$$$$/| $$$$$$$$   | $$   
9  \______/  \______/ |__/  \__/|_______/ |________/   |__/   
10                                                             
11 Are you ready to embark on a groundbreaking journey into the world of gambling with limitless possibilities? 
12 Look no further, as we introduce you to our extraordinary crypto casino – a game-changer in the industry - GUNBET.
13 
14 Revolutionary crypto casino and sports betting with revenue share and over 50 fun games. Unleash the Future of Gaming.
15 Own a part of the casino with GunBet token!
16 
17 As a token holder, you become an integral part of the casino's success.
18 You will receive an impressive 50% share of the casino's profits and an additional 20% from token tax fees.
19  
20 Revenue share address: gunbet-revshare.eth (read more in Docs).
21 
22 Step into our gaming realm, where an exhilarating array of over 50+ games awaits you.
23 
24 From the classic charm of Slots and Roulette to the adrenaline-pumping excitement of Sports Betting and Towers, we have carefully curated an extensive selection of games to cater to all preferences.
25 
26 In our quest to embrace the revolutionary world of cryptocurrencies, we proudly offer 8 seamless and secure crypto deposit methods.
27 Say goodbye to cumbersome traditional payment systems and embrace the efficiency of blockchain transactions.
28  
29 For our esteemed players who exhibit significant volume and loyalty, we have tailored a VIP program that showers you with exclusive perks and privileges.
30 As a VIP, you'll enjoy personalized rewards, priority support, and access to top-tier events.
31  
32 Experience the thrill of competition as we host daily wagering competitions, where players with the highest amounts wagered have the chance to win enticing rewards in real dollars.
33 It's not just about winning big in the games; it's about being rewarded for your dedication and passion.
34  
35 And that's not all – we believe in showering our players with generous bonuses. Upon making your deposits, you'll receive an incredible 50% deposit bonus, giving you more bang for your buck and extending your gaming experience.
36 Our mission is to revolutionize the casino industry and provide an unparalleled gaming environment that merges the excitement of gambling with the innovation of blockchain technology. We invite you to join us on this remarkable journey as we redefine the future of gaming.
37 
38 Take the leap into the world of limitless possibilities – join GunBet at the forefront of the gaming revolution today!
39 Rev. Share Address - gunbet-revshare.eth
40 
41 Docs - https://gunbet.gitbook.io/start/
42 Website - https://gunbet.gg
43 Twitter - https://twitter.com/gunbetgg
44 Medium - https://medium.com/@gunbet
45 Discord - https://discord.gg/AXH2WZRrMg
46 Telegram - https://t.me/gunbetgg
47 
48 **/
49 // SPDX-License-Identifier: MIT
50 
51 pragma solidity 0.8.20;
52 
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 }
58 
59 interface IERC20 {
60     function totalSupply() external view returns (uint256);
61     function balanceOf(address account) external view returns (uint256);
62     function transfer(address recipient, uint256 amount) external returns (bool);
63     function allowance(address owner, address spender) external view returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 }
69 
70 library SafeMath {
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74         return c;
75     }
76 
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80 
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84         return c;
85     }
86 
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         if (a == 0) {
89             return 0;
90         }
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93         return c;
94     }
95 
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         require(b > 0, errorMessage);
102         uint256 c = a / b;
103         return c;
104     }
105 
106 }
107 
108 contract Ownable is Context {
109     address private _owner;
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112     constructor () {
113         address msgSender = _msgSender();
114         _owner = msgSender;
115         emit OwnershipTransferred(address(0), msgSender);
116     }
117 
118     function owner() public view returns (address) {
119         return _owner;
120     }
121 
122     modifier onlyOwner() {
123         require(_owner == _msgSender(), "Ownable: caller is not the owner");
124         _;
125     }
126 
127     function renounceOwnership() public virtual onlyOwner {
128         emit OwnershipTransferred(_owner, address(0));
129         _owner = address(0);
130     }
131 
132 }
133 
134 interface IUniswapV2Factory {
135     function createPair(address tokenA, address tokenB) external returns (address pair);
136 }
137 
138 interface IUniswapV2Router02 {
139     function swapExactTokensForETHSupportingFeeOnTransferTokens(
140         uint amountIn,
141         uint amountOutMin,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external;
146     function factory() external pure returns (address);
147     function WETH() external pure returns (address);
148     function addLiquidityETH(
149         address token,
150         uint amountTokenDesired,
151         uint amountTokenMin,
152         uint amountETHMin,
153         address to,
154         uint deadline
155     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
156 }
157 
158 contract GunBet is Context, IERC20, Ownable {
159     using SafeMath for uint256;
160     mapping (address => uint256) private _balances;
161     mapping (address => mapping (address => uint256)) private _allowances;
162     mapping (address => bool) private _isExcludedFromFee;
163     address payable private _taxWallet;
164 	address payable private _revshareWallet;
165     uint256 firstBlock;
166 
167     uint256 private _initialBuyTax=18;
168     uint256 private _initialSellTax=18;
169     uint256 private _finalBuyTax=5;
170     uint256 private _finalSellTax=5;
171     uint256 private _reduceBuyTaxAt=30;
172     uint256 private _reduceSellTaxAt=30;
173     uint256 private _preventSwapBefore=30;
174     uint256 private _buyCount=0;
175 
176     uint8 private constant _decimals = 9;
177     uint256 private constant _tTotal = 10000000 * 10**_decimals;
178     string private constant _name = unicode"GUNBET";
179     string private constant _symbol = unicode"GUNBET";
180     uint256 public _maxTxAmount =   100000 * 10**_decimals;
181     uint256 public _maxWalletSize = 100000 * 10**_decimals;
182     uint256 public _taxSwapThreshold= 100000 * 10**_decimals;
183     uint256 public _maxTaxSwap= 100000 * 10**_decimals;
184 
185     IUniswapV2Router02 private uniswapV2Router;
186     address private uniswapV2Pair;
187     bool private tradingOpen;
188     bool private inSwap = false;
189     bool private swapEnabled = false;
190 
191     event MaxTxAmountUpdated(uint _maxTxAmount);
192     modifier lockTheSwap {
193         inSwap = true;
194         _;
195         inSwap = false;
196     }
197 
198     constructor () {
199 
200         _taxWallet = payable(_msgSender());
201 		_revshareWallet = payable(address(0x62A6f3686Da6689033375d061b307b98849b5aA0));
202         _balances[_msgSender()] = _tTotal;
203         _isExcludedFromFee[owner()] = true;
204         _isExcludedFromFee[address(this)] = true;
205         _isExcludedFromFee[_taxWallet] = true;
206 		_isExcludedFromFee[_revshareWallet] = true;
207         
208         emit Transfer(address(0), _msgSender(), _tTotal);
209     }
210 	
211 
212     function name() public pure returns (string memory) {
213         return _name;
214     }
215 	
216 
217     function symbol() public pure returns (string memory) {
218         return _symbol;
219     }
220 	
221 
222     function decimals() public pure returns (uint8) {
223         return _decimals;
224     }
225 	
226 
227     function totalSupply() public pure override returns (uint256) {
228         return _tTotal;
229     }
230 	
231 
232     function balanceOf(address account) public view override returns (uint256) {
233         return _balances[account];
234     }
235 	
236 
237     function transfer(address recipient, uint256 amount) public override returns (bool) {
238         _transfer(_msgSender(), recipient, amount);
239         return true;
240     }
241 	
242 
243     function allowance(address owner, address spender) public view override returns (uint256) {
244         return _allowances[owner][spender];
245     }
246 	
247 
248     function approve(address spender, uint256 amount) public override returns (bool) {
249         _approve(_msgSender(), spender, amount);
250         return true;
251     }
252 	
253 
254     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
255         _transfer(sender, recipient, amount);
256         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
257         return true;
258     }
259 	
260 
261     function _approve(address owner, address spender, uint256 amount) private {
262         require(owner != address(0), "ERC20: approve from the zero address");
263         require(spender != address(0), "ERC20: approve to the zero address");
264         _allowances[owner][spender] = amount;
265         emit Approval(owner, spender, amount);
266     }
267 
268 
269     function _transfer(address from, address to, uint256 amount) private {
270         require(from != address(0), "ERC20: transfer from the zero address");
271         require(to != address(0), "ERC20: transfer to the zero address");
272         require(amount > 0, "Transfer amount must be greater than zero");
273         uint256 taxAmount=0;
274         if (from != owner() && to != owner()) {
275             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
276 
277             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
278                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
279                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
280 
281                 if (firstBlock + 3  > block.number) {
282                     require(!isContract(to));
283                 }
284                 _buyCount++;
285             }
286 
287             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
288                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
289             }
290 
291             if(to == uniswapV2Pair && from!= address(this) ){
292                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
293             }
294 
295             uint256 contractTokenBalance = balanceOf(address(this));
296             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
297                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
298                 uint256 contractETHBalance = address(this).balance;
299                 if(contractETHBalance > 0) {
300 					sendETHToRevShare(address(this).balance.div(5));
301                     sendETHToFee(address(this).balance);
302                 }
303             }
304         }
305 
306         if(taxAmount>0){
307           _balances[address(this)]=_balances[address(this)].add(taxAmount);
308           emit Transfer(from, address(this),taxAmount);
309         }
310         _balances[from]=_balances[from].sub(amount);
311         _balances[to]=_balances[to].add(amount.sub(taxAmount));
312         emit Transfer(from, to, amount.sub(taxAmount));
313     }
314 
315 
316     function min(uint256 a, uint256 b) private pure returns (uint256){
317       return (a>b)?b:a;
318     }
319 
320     function isContract(address account) private view returns (bool) {
321         uint256 size;
322         assembly {
323             size := extcodesize(account)
324         }
325         return size > 0;
326     }
327 
328     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
329         address[] memory path = new address[](2);
330         path[0] = address(this);
331         path[1] = uniswapV2Router.WETH();
332         _approve(address(this), address(uniswapV2Router), tokenAmount);
333         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
334             tokenAmount,
335             0,
336             path,
337             address(this),
338             block.timestamp
339         );
340     }
341 
342     function removeLimits() external onlyOwner{
343         _maxTxAmount = _tTotal;
344         _maxWalletSize=_tTotal;
345         emit MaxTxAmountUpdated(_tTotal);
346     }
347 
348     function sendETHToFee(uint256 amount) private {
349         _taxWallet.transfer(amount);
350     }
351 	
352 	function sendETHToRevShare(uint256 amount) private {
353         _revshareWallet.transfer(amount);
354     }
355 
356     function openTrading() external onlyOwner() {
357         require(!tradingOpen,"trading is already open");
358         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
359         _approve(address(this), address(uniswapV2Router), _tTotal);
360         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
361         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
362         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
363         swapEnabled = true;
364         tradingOpen = true;
365         firstBlock = block.number;
366     }
367 
368     receive() external payable {}
369 }