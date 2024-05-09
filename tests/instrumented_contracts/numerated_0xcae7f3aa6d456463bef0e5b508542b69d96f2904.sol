1 /**
2  *  .----------------.  .-----------------. .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
3  * | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
4  * | |     _____    | || | ____  _____  | || | ____   ____  | || |  _________   | || |     ______   | || |  _________   | || |      __      | || |     _____    | |
5  * | |    |_   _|   | || ||_   \|_   _| | || ||_  _| |_  _| | || | |_   ___  |  | || |   .' ___  |  | || | |  _   _  |  | || |     /  \     | || |    |_   _|   | |
6  * | |      | |     | || |  |   \ | |   | || |  \ \   / /   | || |   | |_  \_|  | || |  / .'   \_|  | || | |_/ | | \_|  | || |    / /\ \    | || |      | |     | |
7  * | |      | |     | || |  | |\ \| |   | || |   \ \ / /    | || |   |  _|  _   | || |  | |         | || |     | |      | || |   / ____ \   | || |      | |     | |
8  * | |     _| |_    | || | _| |_\   |_  | || |    \ ' /     | || |  _| |___/ |  | || |  \ `.___.'\  | || |    _| |_     | || | _/ /    \ \_ | || |     _| |_    | |
9  * | |    |_____|   | || ||_____|\____| | || |     \_/      | || | |_________|  | || |   `._____.'  | || |   |_____|    | || ||____|  |____|| || |    |_____|   | |
10  * | |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |
11  * | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
12  * '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
13  * InvectAI: Exploring the Synergy of AI and Blockchain
14  * Stealth launch
15  *
16  * Web: https://invect.ai
17  * Telegram: https://t.me/invectai
18  * Twitter: https://twitter.com/InvectAi
19  * Discord: https://discord.gg/5vHTvaCuCx
20  * 
21  * InvectAI is a revolutionary platform that combines the power of AI and blockchain to create a new realm of creative potential. 
22  * With InvectAI, users can generate multimedia content with ease, unleashing their imagination and exploring endless possibilities for content creation.
23  * 
24  * The platform offers a range of AI-powered solutions for generating multimedia content, including image, animation, voice, lyrics, character, video, and speaking portrait generation. 
25  * Users can customize parameters to create stunning visual art and complex animations, compose song lyrics, and generate realistic or fantastical characters in games and social media. 
26  * InvectAI's AI solutions also allow for natural-sounding speech and can animate any portrait with expressions and speech.
27  * 
28  * To make it even easier for users to access the platform's AI solutions, InvectAI offers Discord, Telegram, and Twitter bots, allowing users to generate multimedia content quickly and easily without technical expertise.
29  * 
30  * AI Image Generation
31  * AI Animation Generation
32  * AI Voice Generation
33  * AI Lyrics Generation
34  * AI Character Generation
35  * AI Video Generation
36  * AI Chat InvectGPT-3
37  * AI Speaking Portrait Generation
38  * AI Telegram Bots
39  * AI Discord Bots
40  * AI Twitter Bots
41  * AI Developer Solutions API
42  * 
43  * 1 Billion InvectAI Tokens
44  * Tax: 6%
45  * A portion of the transaction fees from the InvectAI token will be collected as tax and will be used to pay for the costs associated with developing, maintaining, and improving the AI models, as well as for marketing efforts to promote the adoption of the platform. 
46  * This tax mechanism ensures that the InvectAI ecosystem remains financially self-sufficient, while also incentivizing users to hold and use the token.
47  *
48  * READ MORE:
49  * https://invect.ai
50 */
51 
52 pragma solidity 0.8.17;
53 
54 abstract contract Context {
55     function _msgSender() internal view virtual returns (address) {
56         return msg.sender;
57     }
58 }
59 
60 interface IERC20 {
61     function totalSupply() external view returns (uint256);
62     function balanceOf(address account) external view returns (uint256);
63     function transfer(address recipient, uint256 amount) external returns (bool);
64     function allowance(address owner, address spender) external view returns (uint256);
65     function approve(address spender, uint256 amount) external returns (bool);
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67     event Transfer(address indexed from, address indexed to, uint256 value);
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75         return c;
76     }
77 
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return sub(a, b, "SafeMath: subtraction overflow");
80     }
81 
82     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
83         require(b <= a, errorMessage);
84         uint256 c = a - b;
85         return c;
86     }
87 
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         if (a == 0) {
90             return 0;
91         }
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94         return c;
95     }
96 
97     function div(uint256 a, uint256 b) internal pure returns (uint256) {
98         return div(a, b, "SafeMath: division by zero");
99     }
100 
101     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
102         require(b > 0, errorMessage);
103         uint256 c = a / b;
104         return c;
105     }
106 
107 }
108 
109 contract Ownable is Context {
110     address private _owner;
111     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
112 
113     constructor () {
114         address msgSender = _msgSender();
115         _owner = msgSender;
116         emit OwnershipTransferred(address(0), msgSender);
117     }
118 
119     function owner() public view returns (address) {
120         return _owner;
121     }
122 
123     modifier onlyOwner() {
124         require(_owner == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     function renounceOwnership() public virtual onlyOwner {
129         emit OwnershipTransferred(_owner, address(0));
130         _owner = address(0);
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
159 contract InvectAI is Context, IERC20, Ownable {
160     // INVECT.AI
161     using SafeMath for uint256;
162     mapping (address => uint256) private _balances;
163     mapping (address => mapping (address => uint256)) private _allowances;
164     mapping (address => bool) private _isExcludedFromFee;
165     mapping (address => bool) private bots;
166     mapping(address => uint256) private _holderLastTransferTimestamp;
167     bool public transferDelayEnabled = false;
168     address payable private _taxWallet;
169 
170     uint256 private _initialBuyTax=8;
171     uint256 private _initialSellTax=14;
172     uint256 private _finalBuyTax=6;
173     uint256 private _finalSellTax=6;
174     uint256 private _reduceBuyTaxAt=1;
175     uint256 private _reduceSellTaxAt=10;
176     uint256 private _preventSwapBefore=30;
177     uint256 private _buyCount=0;
178 
179     uint8 private constant _decimals = 8;
180     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
181     string private constant _name = unicode"InvectAI";
182     string private constant _symbol = unicode"InvectAI";
183     uint256 public _maxTxAmount =   40000000 * 10**_decimals;
184     uint256 public _maxWalletSize = 40000000 * 10**_decimals;
185     uint256 public _taxSwapThreshold=4000000 * 10**_decimals;
186     uint256 public _maxTaxSwap=4000000 * 10**_decimals;
187 	
188 	// At InvectAI, we're exploring the potential of connecting two revolutionary technologies: AI and blockchain. 
189 	// By leveraging the strengths of both, we believe we can create a powerful platform that empowers users to generate and access AI-generated content in a decentralized and transparent manner.
190 
191     // Our vision is to create smart contracts on the Ethereum network that will allow anyone to access AI-generated content simply by interacting with the contract. 
192 	// This approach will provide a secure and transparent way for users to access and utilize AI content without the need for intermediaries. 
193 
194     IUniswapV2Router02 private uniswapV2Router;
195     address private uniswapV2Pair;
196     bool private tradingOpen;
197     bool private inSwap = false;
198     bool private swapEnabled = false;
199 
200     event MaxTxAmountUpdated(uint _maxTxAmount);
201     modifier lockTheSwap {
202         inSwap = true;
203         _;
204         inSwap = false;
205     }
206 
207     constructor () {
208         _taxWallet = payable(_msgSender());
209         _balances[_msgSender()] = _tTotal;
210         _isExcludedFromFee[owner()] = true;
211         _isExcludedFromFee[address(this)] = true;
212         _isExcludedFromFee[_taxWallet] = true;
213 
214         emit Transfer(address(0), _msgSender(), _tTotal);
215     }
216 
217     function name() public pure returns (string memory) {
218         return _name;
219     }
220 
221     function symbol() public pure returns (string memory) {
222         return _symbol;
223     }
224 
225     function decimals() public pure returns (uint8) {
226         return _decimals;
227     }
228 
229     function totalSupply() public pure override returns (uint256) {
230         return _tTotal;
231     }
232 
233     function balanceOf(address account) public view override returns (uint256) {
234         return _balances[account];
235     }
236 
237     function transfer(address recipient, uint256 amount) public override returns (bool) {
238         _transfer(_msgSender(), recipient, amount);
239         return true;
240     }
241 
242     function allowance(address owner, address spender) public view override returns (uint256) {
243         return _allowances[owner][spender];
244     }
245 
246     function approve(address spender, uint256 amount) public override returns (bool) {
247         _approve(_msgSender(), spender, amount);
248         return true;
249     }
250 
251     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
252         _transfer(sender, recipient, amount);
253         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
254         return true;
255     }
256 
257     function _approve(address owner, address spender, uint256 amount) private {
258         require(owner != address(0), "ERC20: approve from the zero address");
259         require(spender != address(0), "ERC20: approve to the zero address");
260         _allowances[owner][spender] = amount;
261         emit Approval(owner, spender, amount);
262     }
263 
264     function _transfer(address from, address to, uint256 amount) private {
265         require(from != address(0), "ERC20: transfer from the zero address");
266         require(to != address(0), "ERC20: transfer to the zero address");
267         require(amount > 0, "Transfer amount must be greater than zero");
268         uint256 taxAmount=0;
269         if (from != owner() && to != owner()) {
270             require(!bots[from] && !bots[to]);
271             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
272 
273             if (transferDelayEnabled) {
274                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
275                       require(
276                           _holderLastTransferTimestamp[tx.origin] <
277                               block.number,
278                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
279                       );
280                       _holderLastTransferTimestamp[tx.origin] = block.number;
281                   }
282               }
283 
284             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
285                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
286                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
287                 _buyCount++;
288             }
289 
290             if(to == uniswapV2Pair && from!= address(this) ){
291                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
292             }
293 
294             uint256 contractTokenBalance = balanceOf(address(this));
295             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
296                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
297                 uint256 contractETHBalance = address(this).balance;
298                 if(contractETHBalance > 0) {
299                     sendETHToFee(address(this).balance);
300                 }
301             }
302         }
303 
304         if(taxAmount>0){
305           _balances[address(this)]=_balances[address(this)].add(taxAmount);
306           emit Transfer(from, address(this),taxAmount);
307         }
308         _balances[from]=_balances[from].sub(amount);
309         _balances[to]=_balances[to].add(amount.sub(taxAmount));
310         emit Transfer(from, to, amount.sub(taxAmount));
311     }
312 
313 
314     function min(uint256 a, uint256 b) private pure returns (uint256){
315       return (a>b)?b:a;
316     }
317 
318     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
319         address[] memory path = new address[](2);
320         path[0] = address(this);
321         path[1] = uniswapV2Router.WETH();
322         _approve(address(this), address(uniswapV2Router), tokenAmount);
323         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
324             tokenAmount,
325             0,
326             path,
327             address(this),
328             block.timestamp
329         );
330     }
331 
332     function removeLimits() external onlyOwner{
333         _maxTxAmount = _tTotal;
334         _maxWalletSize=_tTotal;
335         transferDelayEnabled=false;
336         emit MaxTxAmountUpdated(_tTotal);
337     }
338 
339     function sendETHToFee(uint256 amount) private {
340         _taxWallet.transfer(amount);
341     }
342 
343     function isBot(address a) public view returns (bool){
344       return bots[a];
345     }
346 
347     function openTrading() external onlyOwner() {
348         require(!tradingOpen,"trading is already open");
349         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
350         _approve(address(this), address(uniswapV2Router), _tTotal);
351         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
352         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
353         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
354         swapEnabled = true;
355         tradingOpen = true;
356     }
357 
358     
359 
360     receive() external payable {}
361 
362     function manualSwap() external {
363         require(_msgSender()==_taxWallet);
364         uint256 tokenBalance=balanceOf(address(this));
365         if(tokenBalance>0){
366           swapTokensForEth(tokenBalance);
367         }
368         uint256 ethBalance=address(this).balance;
369         if(ethBalance>0){
370           sendETHToFee(ethBalance);
371         }
372     }
373 }