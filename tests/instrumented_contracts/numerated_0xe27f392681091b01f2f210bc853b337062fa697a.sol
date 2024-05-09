1 /**
2  * GAMBLX - The world first positive RTP (Return-To-Player) decentralized casino!
3  *
4  * Unlike traditional casinos with a house edge, at GAMBLX, our unique game mechanics system eliminates the house edge. This means (f.e.) you can enjoy up to an 80% chance to win X2 bets, depending on the round. Imagine the possibilities - with a total pool of $2800, a mere $40 bet can grant you a 50% chance to win, particularly during rounds with high bonus pools and smaller bets. Say goodbye to always losing – at GAMBLX, you have the advantage!
5  * 50% of token volume tax funds are automatically added to jackpot rounds as bonus pools.
6  * Additionally, 30% of total casino revenue is shared randomly into game pools, and 10% of casino revenue is used for token buyback at random interval.
7  * The token is deflationary, with 5% of tokens from tax volume being burned automatically.
8  * Holders of the token become part owners of the casino, receiving 30% of casino revenue and 20% of token tax fees through the Revenue Share Program.
9  * Return to Player (RTP) can reach up to +1000%, depending on the round and bonus pool. Players can even apply their skills to calculate the best timing to join game.
10  * Fully decentralized, winners for each round are automatically chosen using our smart contract provable fair system.
11  * 10% of each game pool contributes to casino revenue, and 30% of this revenue is shared with token holders through the Revenue Share system.
12  *
13  *
14  * At GamblX, we believe in provably fair gaming. Every game, bet, and winner can be verified, as our smart contract automatically selects winners at the end of each game, leaving no room for human intervention.
15  * As we expand our offerings, players can expect a diverse range of games designed to cater to all interests and preferences. From classic casino games with a blockchain twist to groundbreaking and unique creations, each game promises a seamless and transparent gaming experience.
16  * Our new games will feature provably fair mechanics, ensuring that players can verify the fairness of every outcome independently. The blockchain's decentralized nature provides added security and trust, ensuring that the integrity of the games remains uncompromised.
17  * Whether you are a seasoned gambler or a newcomer to the world of blockchain gaming, our upcoming releases will captivate and entertain you. Prepare to embark on an unforgettable journey, where thrilling gameplay and blockchain technology converge to create an unparalleled gaming adventure.
18  * GamblX invites players to join our revolution in the gambling world, where trust, fairness, and exhilarating gaming experiences converge. Embrace the advantage and explore the endless possibilities of winning with GamblX.
19  *
20  *
21  * Website: https://gamblx.com
22  * Twitter: https://twitter.com/gamblx_com
23  * Telegram: https://t.me/gamblx_com
24  * Medium: https://medium.com/@gamblx/
25  * Discord: https://discord.com/invite/bFfwwTYE
26  * Docs: https://gamblx.gitbook.io/info
27  * 
28  * 
29 */
30 
31 // SPDX-License-Identifier: MIT
32 
33 pragma solidity 0.8.20;
34 
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address) {
37         return msg.sender;
38     }
39 }
40 
41 interface IERC20 {
42     function totalSupply() external view returns (uint256);
43     function balanceOf(address account) external view returns (uint256);
44     function transfer(address recipient, uint256 amount) external returns (bool);
45     function allowance(address owner, address spender) external view returns (uint256);
46     function approve(address spender, uint256 amount) external returns (bool);
47     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
48     event Transfer(address indexed from, address indexed to, uint256 value);
49     event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 interface Jackpot {
53     function addBonus() external payable;  
54 }
55 
56 library SafeMath {
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60         return c;
61     }
62 
63     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64         return sub(a, b, "SafeMath: subtraction overflow");
65     }
66 
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70         return c;
71     }
72 
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         if (a == 0) {
75             return 0;
76         }
77         uint256 c = a * b;
78         require(c / a == b, "SafeMath: multiplication overflow");
79         return c;
80     }
81 
82     function div(uint256 a, uint256 b) internal pure returns (uint256) {
83         return div(a, b, "SafeMath: division by zero");
84     }
85 
86     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b > 0, errorMessage);
88         uint256 c = a / b;
89         return c;
90     }
91 
92 }
93 
94 contract Ownable is Context {
95     address private _owner;
96 	address private _jackpotmanager;
97     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
98 
99     constructor () {
100         address msgSender = _msgSender();
101         _owner = msgSender;
102 		_jackpotmanager = msgSender;
103         emit OwnershipTransferred(address(0), msgSender);
104     }
105 
106     function owner() public view returns (address) {
107         return _owner;
108     }
109 
110     function jackpotmanager() public view returns (address) {
111         return _jackpotmanager;
112     }
113 	
114     modifier onlyOwner() {
115         require(_owner == _msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 	
119 	modifier onlyJackpotManager() {
120         require(_jackpotmanager == _msgSender(), "Ownable: caller is not the jackpot manager");
121         _;
122     }
123 
124     function renounceOwnership() public virtual onlyOwner {
125         emit OwnershipTransferred(_owner, address(0));
126         _owner = address(0);
127     }
128 	
129 	function renounceJackpotManager() public virtual onlyJackpotManager {
130         _jackpotmanager = address(0);
131     }
132 
133 }
134 
135 interface IUniswapV2Factory {
136     function createPair(address tokenA, address tokenB) external returns (address pair);
137 }
138 
139 interface IUniswapV2Router02 {
140     function swapExactTokensForETHSupportingFeeOnTransferTokens(
141         uint amountIn,
142         uint amountOutMin,
143         address[] calldata path,
144         address to,
145         uint deadline
146     ) external;
147     function factory() external pure returns (address);
148     function WETH() external pure returns (address);
149     function addLiquidityETH(
150         address token,
151         uint amountTokenDesired,
152         uint amountTokenMin,
153         uint amountETHMin,
154         address to,
155         uint deadline
156     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
157 }
158 
159 contract GAMBLX is Context, IERC20, Ownable {
160     using SafeMath for uint256;
161 	
162     mapping (address => uint256) private _balances;
163     mapping (address => mapping (address => uint256)) private _allowances;
164     mapping (address => bool) private _isExcludedFromFee;
165     address payable private _taxWallet;
166     uint256 firstBlock;
167 
168     uint256 private _initialBuyTax=17;
169     uint256 private _initialSellTax=17;
170     uint256 private _finalBuyTax=5;
171     uint256 private _finalSellTax=5;
172     uint256 private _reduceBuyTaxAt=23;
173     uint256 private _reduceSellTaxAt=23;
174     uint256 private _preventSwapBefore=23;
175     uint256 private _buyCount=0;
176 
177     uint8 private constant _decimals = 9;
178     uint256 private constant _tTotal = 100000000 * 10**_decimals;
179     string private constant _name = unicode"GAMBLX";
180     string private constant _symbol = unicode"GAMBLX";
181     uint256 public _maxTxAmount =   1000000 * 10**_decimals;
182     uint256 public _maxWalletSize = 1000000 * 10**_decimals;
183     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
184     uint256 public _maxTaxSwap= 1000000 * 10**_decimals;
185 
186     IUniswapV2Router02 private uniswapV2Router;
187     address private uniswapV2Pair;
188     bool private tradingOpen;
189     bool private inSwap = false;
190     bool private swapEnabled = false;
191 	
192 	address jackpotAddress;
193 	
194 	uint256 public totalTokensBurned = 0;
195 
196     event MaxTxAmountUpdated(uint _maxTxAmount);
197     modifier lockTheSwap {
198         inSwap = true;
199         _;
200         inSwap = false;
201     }
202 
203     constructor () {
204 
205         _taxWallet = payable(_msgSender());
206         _balances[_msgSender()] = _tTotal;
207         _isExcludedFromFee[owner()] = true;
208         _isExcludedFromFee[address(this)] = true;
209         _isExcludedFromFee[_taxWallet] = true;
210         
211         emit Transfer(address(0), _msgSender(), _tTotal);
212     }
213 
214     function name() public pure returns (string memory) {
215         return _name;
216     }
217 
218     function symbol() public pure returns (string memory) {
219         return _symbol;
220     }
221 
222     function decimals() public pure returns (uint8) {
223         return _decimals;
224     }
225 
226     function totalSupply() public pure override returns (uint256) {
227         return _tTotal;
228     }
229 
230     function balanceOf(address account) public view override returns (uint256) {
231         return _balances[account];
232     }
233 
234     function transfer(address recipient, uint256 amount) public override returns (bool) {
235         _transfer(_msgSender(), recipient, amount);
236         return true;
237     }
238 
239     function allowance(address owner, address spender) public view override returns (uint256) {
240         return _allowances[owner][spender];
241     }
242 
243     function approve(address spender, uint256 amount) public override returns (bool) {
244         _approve(_msgSender(), spender, amount);
245         return true;
246     }
247 
248     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
249         _transfer(sender, recipient, amount);
250         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
251         return true;
252     }
253 
254     function _approve(address owner, address spender, uint256 amount) private {
255         require(owner != address(0), "ERC20: approve from the zero address");
256         require(spender != address(0), "ERC20: approve to the zero address");
257         _allowances[owner][spender] = amount;
258         emit Approval(owner, spender, amount);
259     }
260 
261     function _transfer(address from, address to, uint256 amount) private {
262         require(from != address(0), "ERC20: transfer from the zero address");
263         require(to != address(0), "ERC20: transfer to the zero address");
264         require(amount > 0, "Transfer amount must be greater than zero");
265         uint256 taxAmount=0;
266         if (from != owner() && to != owner()) {
267             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
268 
269             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
270                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
271                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
272 
273                 if (firstBlock + 3  > block.number) {
274                     require(!isContract(to));
275                 }
276                 _buyCount++;
277             }
278 
279             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
280                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
281             }
282 
283             if(to == uniswapV2Pair && from!= address(this) ){
284                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
285             }
286 
287             uint256 contractTokenBalance = balanceOf(address(this));
288             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
289 			    uint taxtokensburned;
290 				taxtokensburned = contractTokenBalance.div(20); //5% of tax burned
291 				totalTokensBurned += taxtokensburned;
292                 _balances[address(this)]=_balances[address(this)].sub(taxtokensburned);
293                 _balances[address(0xdead)]=_balances[address(0xdead)].add(taxtokensburned);
294                 emit Transfer(address(this), address(0xdead), taxtokensburned);
295 				//burn tokens from tax
296 				uint256 contractTokenBalance2 = balanceOf(address(this));
297                 swapTokensForEth(min(amount,min(contractTokenBalance2,_maxTaxSwap)));
298                 uint256 contractETHBalance = address(this).balance;
299                 if(contractETHBalance > 0) {
300 					Jackpot(jackpotAddress).addBonus{value: address(this).balance.div(2)}(); //send 50% to bonus pool jackpot
301                     sendETHToFee(address(this).balance); //send 50% to tax wallet
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
342     function setJackpotAddress(address _jackpotAddress) external onlyJackpotManager {
343        jackpotAddress = _jackpotAddress;
344     }
345 	
346     function removeLimits() external onlyOwner{
347         _maxTxAmount = _tTotal;
348         _maxWalletSize=_tTotal;
349         emit MaxTxAmountUpdated(_tTotal);
350     }
351 
352     function sendETHToFee(uint256 amount) private {
353         _taxWallet.transfer(amount);
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