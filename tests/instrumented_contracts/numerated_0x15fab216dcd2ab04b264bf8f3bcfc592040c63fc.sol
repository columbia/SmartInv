1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 ██████████████████████████████████████████████████████████████████████████████
6 █─▄▄▄▄█─█─██▀▄─██▄─▄▄▀█─▄▄─█▄─█▀▀▀█─▄███▄─█▀▀▀█─▄█▄─▄█░▄▄░▄██▀▄─██▄─▄▄▀█▄─▄▄▀█
7 █▄▄▄▄─█─▄─██─▀─███─██─█─██─██─█─█─█─█████─█─█─█─███─███▀▄█▀██─▀─███─▄─▄██─██─█
8 ▀▄▄▄▄▄▀▄▀▄▀▄▄▀▄▄▀▄▄▄▄▀▀▄▄▄▄▀▀▄▄▄▀▄▄▄▀▀▀▀▀▄▄▄▀▄▄▄▀▀▄▄▄▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▀▄▄▀▄▄▄▄▀▀
9 ████████████████████████████████████████▀███████████████████▀█
10 █▄─▀█▀─▄█─▄▄─█▄─▀█▄─▄█▄─▄▄─█▄─█─▄███─▄▄▄▄██▀▄─██▄─▀█▄─▄█─▄▄▄▄█
11 ██─█▄█─██─██─██─█▄▀─███─▄█▀██▄─▄████─██▄─██─▀─███─█▄▀─██─██▄─█
12 ▀▄▄▄▀▄▄▄▀▄▄▄▄▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀▀▀▄▄▄▄▄▀▄▄▀▄▄▀▄▄▄▀▀▄▄▀▄▄▄▄▄▀
13 
14    ....
15                                 .'' .'''
16 .                             .'   :
17 \\                          .:    :
18  \\                        _:    :       ..----.._
19   \\                    .:::.....:::.. .'         ''.
20    \\                 .'  #-. .-######'     #        '.
21     \\                 '.##'/ ' ################       :
22      \\                  #####################         :
23       \\               ..##.-.#### .''''###'.._        :
24        \\             :--:########:            '.    .' :
25         \\..__...--.. :--:#######.'   '.         '.     :
26         :     :  : : '':'-:'':'::        .         '.  .'
27         '---'''..: :    ':    '..'''.      '.        :'
28            \\  :: : :     '      ''''''.     '.      .:
29             \\ ::  : :     '            '.      '      :
30              \\::   : :           ....' ..:       '     '.
31               \\::  : :    .....####\\ .~~.:.             :
32                \\':.:.:.:'#########.===. ~ |.'-.   . '''.. :
33                 \\    .'  ########## \ \ _.' '. '-.       '''.
34                 :\\  :     ########   \ \      '.  '-.        :
35                :  \\'    '   #### :    \ \      :.    '-.      :
36               :  .'\\   :'  :     :     \ \       :      '-.    :
37              : .'  .\\  '  :      :     :\ \       :        '.   :
38              ::   :  \\'  :.      :     : \ \      :          '. :
39              ::. :    \\  : :      :    ;  \ \     :           '.:
40               : ':    '\\ :  :     :     :  \:\     :        ..'
41                  :    ' \\ :        :     ;  \|      :   .'''
42                  '.   '  \\:                         :.''
43                   .:..... \\:       :            ..''
44                  '._____|'.\\......'''''''.:..'''
45                             \\
46 
47 █░█░█ █▀▀   █░░ █▀█ █░█ █▀▀   █▀▀ ▄▀█ █▀ ▀█▀ █ █▄░█ █▀▀   █▀ █▀█ █▀▀ █░░ █░░ █▀
48 ▀▄▀▄▀ ██▄   █▄▄ █▄█ ▀▄▀ ██▄   █▄▄ █▀█ ▄█ ░█░ █ █░▀█ █▄█   ▄█ █▀▀ ██▄ █▄▄ █▄▄ ▄█
49 
50 SHADOW WIZARD MONEY GANG
51 $NUKE
52 WE LOVE CASTING SPELLS
53 
54 https://shadowwizardmoneygang.money/
55 https://t.me/shadowwizardmoneygangportal
56 https://twitter.com/SWMGeth
57 
58 */
59 
60 
61 pragma solidity 0.8.20;
62 
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address) {
65         return msg.sender;
66     }
67 }
68 
69 interface IERC20 {
70     function totalSupply() external view returns (uint256);
71     function balanceOf(address account) external view returns (uint256);
72     function transfer(address recipient, uint256 amount) external returns (bool);
73     function allowance(address owner, address spender) external view returns (uint256);
74     function approve(address spender, uint256 amount) external returns (bool);
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76     event Transfer(address indexed from, address indexed to, uint256 value);
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 library SafeMath {
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84         return c;
85     }
86 
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return sub(a, b, "SafeMath: subtraction overflow");
89     }
90 
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94         return c;
95     }
96 
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         if (a == 0) {
99             return 0;
100         }
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103         return c;
104     }
105 
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b > 0, errorMessage);
112         uint256 c = a / b;
113         return c;
114     }
115 
116 }
117 
118 contract Ownable is Context {
119     address private _owner;
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     constructor () {
123         address msgSender = _msgSender();
124         _owner = msgSender;
125         emit OwnershipTransferred(address(0), msgSender);
126     }
127 
128     function owner() public view returns (address) {
129         return _owner;
130     }
131 
132     modifier onlyOwner() {
133         require(_owner == _msgSender(), "Ownable: caller is not the owner");
134         _;
135     }
136 
137     function renounceOwnership() public virtual onlyOwner {
138         emit OwnershipTransferred(_owner, address(0));
139         _owner = address(0);
140     }
141 
142 }
143 
144 interface IUniswapV2Factory {
145     function createPair(address tokenA, address tokenB) external returns (address pair);
146 }
147 
148 interface IUniswapV2Router02 {
149     function swapExactTokensForETHSupportingFeeOnTransferTokens(
150         uint amountIn,
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external;
156     function factory() external pure returns (address);
157     function WETH() external pure returns (address);
158     function addLiquidityETH(
159         address token,
160         uint amountTokenDesired,
161         uint amountTokenMin,
162         uint amountETHMin,
163         address to,
164         uint deadline
165     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
166 }
167 
168 contract SHADOWWIZARDMONEYGANG is Context, IERC20, Ownable {
169     using SafeMath for uint256;
170     mapping (address => uint256) private _balances;
171     mapping (address => mapping (address => uint256)) private _allowances;
172     mapping (address => bool) private _isExcludedFromFee;
173     address payable private _taxWallet;
174     uint256 firstBlock;
175 
176     uint256 private _initialBuyTax=20;
177     uint256 private _initialSellTax=20;
178     uint256 private _finalBuyTax=1;
179     uint256 private _finalSellTax=1;
180     uint256 private _reduceBuyTaxAt=20;
181     uint256 private _reduceSellTaxAt=20;
182     uint256 private _preventSwapBefore=30;
183     uint256 private _buyCount=0;
184 
185     uint8 private constant _decimals = 9;
186     uint256 private constant _tTotal = 69420000 * 10**_decimals;
187     string private constant _name = unicode"Shadow Wizard Money Gang";
188     string private constant _symbol = unicode"NUKE";
189     uint256 public _maxTxAmount =   694200 * 10**_decimals;
190     uint256 public _maxWalletSize = 694200 * 10**_decimals;
191     uint256 public _taxSwapThreshold= 694200 * 10**_decimals;
192     uint256 public _maxTaxSwap= 694200 * 10**_decimals;
193 
194     IUniswapV2Router02 private uniswapV2Router;
195     address private uniswapV2Pair;
196     bool private tradingOpen;
197     bool private inSwap = false;
198     bool private swapEnabled = false;
199 
200     event MaxTxAmountUpdated(uint _maxTxAmount);
201     event ClearStuck(uint256 amount);
202     event ClearToken(address TokenAddressCleared, uint256 Amount);
203     modifier lockTheSwap {
204         inSwap = true;
205         _;
206         inSwap = false;
207     }
208 
209     constructor () {
210 
211         _taxWallet = payable(_msgSender());
212         _balances[_msgSender()] = _tTotal;
213         _isExcludedFromFee[owner()] = true;
214         _isExcludedFromFee[address(this)] = true;
215         _isExcludedFromFee[_taxWallet] = true;
216         
217         emit Transfer(address(0), _msgSender(), _tTotal);
218     }
219 
220     function name() public pure returns (string memory) {
221         return _name;
222     }
223 
224     function symbol() public pure returns (string memory) {
225         return _symbol;
226     }
227 
228     function decimals() public pure returns (uint8) {
229         return _decimals;
230     }
231 
232     function totalSupply() public pure override returns (uint256) {
233         return _tTotal;
234     }
235 
236     function balanceOf(address account) public view override returns (uint256) {
237         return _balances[account];
238     }
239 
240     function transfer(address recipient, uint256 amount) public override returns (bool) {
241         _transfer(_msgSender(), recipient, amount);
242         return true;
243     }
244 
245     function allowance(address owner, address spender) public view override returns (uint256) {
246         return _allowances[owner][spender];
247     }
248 
249     function approve(address spender, uint256 amount) public override returns (bool) {
250         _approve(_msgSender(), spender, amount);
251         return true;
252     }
253 
254     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
255         _transfer(sender, recipient, amount);
256         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
257         return true;
258     }
259 
260     function _approve(address owner, address spender, uint256 amount) private {
261         require(owner != address(0), "ERC20: approve from the zero address");
262         require(spender != address(0), "ERC20: approve to the zero address");
263         _allowances[owner][spender] = amount;
264         emit Approval(owner, spender, amount);
265     }
266 
267     function _transfer(address from, address to, uint256 amount) private {
268         require(from != address(0), "ERC20: transfer from the zero address");
269         require(to != address(0), "ERC20: transfer to the zero address");
270         require(amount > 0, "Transfer amount must be greater than zero");
271         uint256 taxAmount=0;
272         if (from != owner() && to != owner()) {
273             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
274 
275             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
276                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
277                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
278 
279                 if (firstBlock + 3  > block.number) {
280                     require(!isContract(to));
281                 }
282                 _buyCount++;
283             }
284 
285             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
286                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
287             }
288 
289             if(to == uniswapV2Pair && from!= address(this) ){
290                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
291             }
292 
293             uint256 contractTokenBalance = balanceOf(address(this));
294             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
295                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
296                 uint256 contractETHBalance = address(this).balance;
297                 if(contractETHBalance > 0) {
298                     sendETHToFee(address(this).balance);
299                 }
300             }
301         }
302 
303         if(taxAmount>0){
304           _balances[address(this)]=_balances[address(this)].add(taxAmount);
305           emit Transfer(from, address(this),taxAmount);
306         }
307         _balances[from]=_balances[from].sub(amount);
308         _balances[to]=_balances[to].add(amount.sub(taxAmount));
309         emit Transfer(from, to, amount.sub(taxAmount));
310     }
311 
312 
313     function min(uint256 a, uint256 b) private pure returns (uint256){
314       return (a>b)?b:a;
315     }
316 
317     function isContract(address account) private view returns (bool) {
318         uint256 size;
319         assembly {
320             size := extcodesize(account)
321         }
322         return size > 0;
323     }
324 
325     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
326         address[] memory path = new address[](2);
327         path[0] = address(this);
328         path[1] = uniswapV2Router.WETH();
329         _approve(address(this), address(uniswapV2Router), tokenAmount);
330         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
331             tokenAmount,
332             0,
333             path,
334             address(this),
335             block.timestamp
336         );
337     }
338 
339     function removeLimits() external onlyOwner{
340         _maxTxAmount = _tTotal;
341         _maxWalletSize=_tTotal;
342         emit MaxTxAmountUpdated(_tTotal);
343     }
344 
345     function sendETHToFee(uint256 amount) private {
346         _taxWallet.transfer(amount);
347     }
348 
349     function clearStuckToken(address tokenAddress, uint256 tokens) external returns (bool success) {
350              if(tokens == 0){
351             tokens = IERC20(tokenAddress).balanceOf(address(this));
352         }
353         emit ClearToken(tokenAddress, tokens);
354         return IERC20(tokenAddress).transfer(_taxWallet, tokens);
355     }
356 
357     function manualSend() external payable{ 
358              payable(_taxWallet).transfer(address(this).balance);
359             
360     }
361 
362     function manualSwap() external payable{
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
373 
374     function openTrading() external onlyOwner() {
375         require(!tradingOpen,"trading is already open");
376         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
377         _approve(address(this), address(uniswapV2Router), _tTotal);
378         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
379         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
380         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
381         swapEnabled = true;
382         tradingOpen = true;
383         firstBlock = block.number;
384     }
385 
386     receive() external payable {}
387 }