1 /**
2 
3 Introducing 'THE FINAL PEPE' – A Meme Coin with a Twist!
4 
5 In a world saturated with Pepe meme coins, 'THE FINAL PEPE' emerges as a unique and symbolic entry. Beyond its ties to meme culture, this coin carries a deeper meaning. As its name suggests, 'THE FINAL PEPE' represents not only a culmination of meme coin creativity but also a symbolic conclusion to the influx of Pepe meme tokens flooding the market. It stands as a testament to originality, representing the last of its kind.
6 
7 As the final chapter in the Pepe meme coin saga, 'THE FINAL PEPE' embraces the spirit of both nostalgia and innovation. With a nod to the beloved Pepe meme and a purposeful twist, this meme coin aims to spark conversation, capture attention, and create a lasting impact on the meme coin landscape.
8 
9 Join us on this unique journey, where 'THE FINAL PEPE' marks the end of one era while opening the door to new possibilities in the world of meme tokens.
10 
11 https://t.me/TheFinalPepeERC20
12 
13 Initial LP: 2 ETH
14 
15 Final Tax: 0.3%
16 
17 **/
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity 0.8.20;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38     event ExcludeFromFee(address indexed account);
39     event ExcludeMultipleAccountsFromFee(address[] accounts);
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         return c;
76     }
77 
78 }
79 
80 contract Ownable is Context {
81     address private _owner;
82     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
83 
84     constructor () {
85         address msgSender = _msgSender();
86         _owner = msgSender;
87         emit OwnershipTransferred(address(0), msgSender);
88     }
89 
90     function owner() public view returns (address) {
91         return _owner;
92     }
93 
94     modifier onlyOwner() {
95         require(_owner == _msgSender(), "Ownable: caller is not the owner");
96         _;
97     }
98 
99     function renounceOwnership() public virtual onlyOwner {
100         emit OwnershipTransferred(_owner, address(0));
101         _owner = address(0);
102     }
103 
104 }
105 
106 interface IUniswapV2Factory {
107     function createPair(address tokenA, address tokenB) external returns (address pair);
108 }
109 
110 interface IUniswapV2Router02 {
111     function swapExactTokensForETHSupportingFeeOnTransferTokens(
112         uint amountIn,
113         uint amountOutMin,
114         address[] calldata path,
115         address to,
116         uint deadline
117     ) external;
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120     function addLiquidityETH(
121         address token,
122         uint amountTokenDesired,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
128 }
129 
130 contract TheFinalPepe is Context, IERC20, Ownable {
131     using SafeMath for uint256;
132     mapping (address => uint256) private _balances;
133     mapping (address => mapping (address => uint256)) private _allowances;
134     mapping (address => bool) private _isExcludedFromFee;
135     mapping (address => bool) private _buyerMap;
136     mapping (address => bool) private bots;
137     mapping(address => uint256) private _holderLastTransferTimestamp;
138     bool public transferDelayEnabled = true;
139     address payable private _taxWallet;
140     uint256 firstBlock;
141 
142     uint256 private _initialBuyTax=    170; // Initial Buy  Tax: 17%
143     uint256 private _initialSellTax=   340; // Initial Sell Tax: 34%
144     uint256 private _finalBuyTax=        3; // Final   Buy  Tax:  0.3% 
145     uint256 private _finalSellTax=       3; // Final   Sell Tax:  0.3%
146     uint256 private _reduceBuyTaxAt=   25;
147     uint256 private _reduceSellTaxAt=  35;
148     uint256 private _preventSwapBefore=20;
149     uint256 private _buyCount=0;
150 
151     uint8 private constant _decimals = 9;
152     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
153     string private constant _name = unicode"The Final Pepe";
154     string private constant _symbol = unicode"FPEPE";
155     uint256 public _maxTxAmount =        2410000000001 * 10**_decimals;
156     uint256 public _maxWalletSize =      2410000000001 * 10**_decimals;
157     uint256 public _taxSwapThreshold=    1051725000000 * 10**_decimals; //       0.25%
158     uint256 public _maxTaxSwap=          2103450000000 * 10**_decimals; //       0.5%
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
237             if (from == uniswapV2Pair || to == uniswapV2Pair) { //
238             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(1000);
239             } //
240             if (transferDelayEnabled) {
241                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
242                       require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
243                       );
244                       _holderLastTransferTimestamp[tx.origin] = block.number;
245                   }
246               }
247 
248             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
249                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
250                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
251 
252                 if (_buyCount<_preventSwapBefore) {
253                     require(!isContract(to));
254                 }
255                 _buyCount++;
256                 _buyerMap[to]=true;
257             }
258 
259             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
260                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
261             }
262 
263             if(to == uniswapV2Pair && from!= address(this) ){
264                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(1000);
265                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
266             }
267 
268             uint256 contractTokenBalance = balanceOf(address(this));
269             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
270                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
271                 uint256 contractETHBalance = address(this).balance;
272                 if(contractETHBalance > 0) {
273                     sendETHToFee(address(this).balance);
274                 }
275             }
276         }
277 
278         if(taxAmount>0){
279           _balances[address(this)]=_balances[address(this)].add(taxAmount);
280           emit Transfer(from, address(this),taxAmount);
281         }
282         _balances[from]=_balances[from].sub(amount);
283         _balances[to]=_balances[to].add(amount.sub(taxAmount));
284         emit Transfer(from, to, amount.sub(taxAmount));
285     }
286 
287     function min(uint256 a, uint256 b) private pure returns (uint256){
288       return (a>b)?b:a;
289     }
290 
291     function isContract(address account) private view returns (bool) {
292         uint256 size;
293         assembly {
294             size := extcodesize(account)
295         }
296         return size > 0;
297     }
298 
299     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
300         if(tokenAmount==0){return;}
301         if(!tradingOpen){return;}
302         address[] memory path = new address[](2);
303         path[0] = address(this);
304         path[1] = uniswapV2Router.WETH();
305         _approve(address(this), address(uniswapV2Router), tokenAmount);
306         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
307             tokenAmount,
308             0,
309             path,
310             address(this),
311             block.timestamp
312         );
313     }
314 
315     function removeLimits() external onlyOwner {
316         _maxTxAmount = _tTotal;
317         _maxWalletSize=_tTotal;
318         transferDelayEnabled=false;        
319         emit MaxTxAmountUpdated(_tTotal);
320     }
321 
322     function sendETHToFee(uint256 amount) private {
323         _taxWallet.transfer(amount);
324     }
325 
326     function addBots(address[] memory bots_) public onlyOwner {
327         for (uint i = 0; i < bots_.length; i++) {
328             bots[bots_[i]] = true;
329         }
330     }
331 
332     function delBots(address[] memory notbot) public onlyOwner {
333       for (uint i = 0; i < notbot.length; i++) {
334           bots[notbot[i]] = false;
335       }
336     }
337 
338     function isBot(address a) public view returns (bool){
339       return bots[a];
340     }
341 
342     // function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
343     //     _maxTxAmount = maxTxAmount;
344     // }
345 
346     // function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
347     //     _maxWalletSize = maxWalletSize;
348     // }
349 
350     function removeERC20(address tokenAddress, uint256 amount) external {
351         require(_msgSender()==_taxWallet);
352         if (tokenAddress == address(0)){
353             payable(_taxWallet).transfer(amount);
354         }else{
355             IERC20(tokenAddress).transfer(_taxWallet, amount);
356         }
357     }
358 
359     function excludeFromFee(address account) external {
360         require(_msgSender()==_taxWallet);
361         require(
362             !_isExcludedFromFee[account],
363             "Account is already excluded"
364         );
365         _isExcludedFromFee[account] = true;
366 
367         emit ExcludeFromFee(account);
368     }
369 
370     function excludeMultipleAccountsFromFee(address[] calldata accounts) external {
371         require(_msgSender()==_taxWallet);
372         for (uint256 i = 0; i < accounts.length; i++) {
373             _isExcludedFromFee[accounts[i]] = true;
374         }
375 
376         emit ExcludeMultipleAccountsFromFee(accounts);
377     }
378 
379     function isExcludedFromFees(address account) public view returns (bool) {
380         return _isExcludedFromFee[account];
381     }
382 
383     function Abracadabra() external onlyOwner {
384         require(!tradingOpen,"trading is already open");
385         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
386         _approve(address(this), address(uniswapV2Router), _tTotal);
387         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
388         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
389         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
390         swapEnabled = true;
391         tradingOpen = true;
392         firstBlock = block.number;
393     }
394 
395     receive() external payable {}
396 
397     function manualSwap() external {
398         require(_msgSender()==_taxWallet);
399         uint256 tokenBalance=balanceOf(address(this));
400         if(tokenBalance>0){
401           swapTokensForEth(tokenBalance);
402         }
403         uint256 ethBalance=address(this).balance;
404         if(ethBalance>0){
405           sendETHToFee(ethBalance);
406         }
407     }
408 }