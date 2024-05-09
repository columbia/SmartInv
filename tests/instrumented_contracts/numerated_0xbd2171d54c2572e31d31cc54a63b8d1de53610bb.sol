1 /**
2 
3 */
4 
5 /**
6                  8888  8888888
7 //                    888888888888888888888888
8 //                 8888:::8888888888888888888888888
9 //               8888::::::8888888888888888888888888888
10 //              88::::::::888:::8888888888888888888888888
11 //            88888888::::8:::::::::::88888888888888888888
12 //          888 8::888888::::::::::::::::::88888888888   888
13 //             88::::88888888::::m::::::::::88888888888    8
14 //           888888888888888888:M:::::::::::8888888888888
15 //          88888888888888888888::::::::::::M88888888888888
16 //            8888888888888888888888:::::::::M8888888888888888
17 //           8888888888888888888888:::::::M888888888888888888
18 //          8888888888888888::88888::::::M88888888888888888888
19 //        88888888888888888:::88888:::::M888888888888888   8888
20 //       88888888888888888:::88888::::M::;o*M*o;888888888    88
21 //      88888888888888888:::8888:::::M:::::::::::88888888    8
22 //     88888888888888888::::88::::::M:;:::::::::::888888888
23 //    8888888888888888888:::8::::::M::aAa::::::::M8888888888       8
24 //    88   8888888888::88::::8::::M:::::::::::::888888888888888 8888
25 //   88  88888888888:::8:::::::::M::::::::::;::88:88888888888888888
26 //   8  8888888888888:::::::::::M::"@@@@@@"::::8w8888888888888888
27 //    88888888888:888::::::::::M:::::"@a@":::::M8i8888888888888888
28 //   8888888888::::88:::::::::M88:::::::::::::M88z88888888888888888
29 //  8888888888:::::8:::::::::M88888:::::::::MM888!888888888888888888
30 //  888888888:::::8:::::::::M8888888MAmmmAMVMM888*88888888   88888888
31 //  888888 M:::::::::::::::M888888888:::::::MM88888888888888   8888888
32 //  8888   M::::::::::::::M88888888888::::::MM888888888888888    88888
33 //   888   M:::::::::::::M8888888888888M:::::mM888888888888888    8888
34 //    888  M::::::::::::M8888:888888888888::::m::Mm88888 888888   8888
35 //     88  M::::::::::::8888:88888888888888888::::::Mm8   88888   888
36 //     88  M::::::::::8888M::88888::888888888888:::::::Mm88888    88
37 //     8   MM::::::::8888M:::8888:::::888888888888::::::::Mm8     4
38 //         8M:::::::8888M:::::888:::::::88:::8888888::::::::Mm    2
39 //        88MM:::::8888M:::::::88::::::::8:::::888888:::M:::::M
40 //       8888M:::::888MM::::::::8:::::::::::M::::8888::::M::::M
41 //      88888M:::::88:M::::::::::8:::::::::::M:::8888::::::M::M
42 //     88 888MM:::888:M:::::::::::::::::::::::M:8888:::::::::M:
43 //     8 88888M:::88::M:::::::::::::::::::::::MM:88::::::::::::M
44 //       88888M:::88::M::::::::::*88*::::::::::M:88::::::::::::::M
45 //      888888M:::88::M:::::::::88@@88:::::::::M::88::::::::::::::M
46 //      888888MM::88::MM::::::::88@@88:::::::::M:::8::::::::::::::*8
47 //      88888  M:::8::MM:::::::::*88*::::::::::M:::::::::::::::::88@@
48 //      8888   MM::::::MM:::::::::::::::::::::MM:::::::::::::::::88@@
49 //       888    M:::::::MM:::::::::::::::::::MM::M::::::::::::::::*8
50 //       888    MM:::::::MMM::::::::::::::::MM:::MM:::::::::::::::M
51 //        88     M::::::::MMMM:::::::::::MMMM:::::MM::::::::::::MM
52 //         88    MM:::::::::MMMMMMMMMMMMMMM::::::::MMM::::::::MMM
53 //          88    MM::::::::::::MMMMMMM::::::::::::::MMMMMMMMMM
54 //           88   8MM::::::::::::::::::::::::::::::::::MMMMMM
55 //            8   88MM::::::::::::::::::::::M:::M::::::::MM
56 //                888MM::::::::::::::::::MM::::::MM::::::MM
57 //               88888MM:::::::::::::::MMM:::::::mM:::::MM
58 //               888888MM:::::::::::::MMM:::::::::MMM:::M
59 //              88888888MM:::::::::::MMM:::::::::::MM:::M
60 //             88 8888888M:::::::::MMM::::::::::::::M:::M
61 //             8  888888 M:::::::MM:::::::::::::::::M:::M:
62 //                888888 M::::::M:::::::::::::::::::M:::MM
63 //               888888  M:::::M::::::::::::::::::::::::M:M
64 //               888888  M:::::M:::::::::@::::::::::::::M::M
65 //               88888   M::::::::::::::@@:::::::::::::::M::M
66 //              88888   M::::::::::::::@@@::::::::::::::::M::M
67 //             88888   M:::::::::::::::@@::::::::::::::::::M::M
68 //            88888   M:::::m::::::::::@::::::::::Mm:::::::M:::M
69 //            8888   M:::::M:::::::::::::::::::::::MM:::::::M:::M
70 //           8888   M:::::M:::::::::::::::::::::::MMM::::::::M:::M
71 //          888    M:::::Mm::::::::::::::::::::::MMM:::::::::M::::M
72 //        8888    MM::::Mm:::::::::::::::::::::MMMM:::::::::m::m:::M
73 //       888      M:::::M::::::::::::::::::::MMM::::::::::::M::mm:::M
74 //    8888       MM:::::::::::::::::::::::::MM:::::::::::::mM::MM:::M:
75 //               M:::::::::::::::::::::::::M:::::::::::::::mM::MM:::Mm
76 //              MM::::::m::::::::::::::::::M::::::::::::::::M::MM:::MM
77 //              M::::::::M::::::::::::::::::M:::::::::::::::::M::M:::MM
78 //  '88::::::::::M888::::'88888888::'88:::'88:'88888888::'88888888:::M8888888:::'888888::
79 //  :88:::::::::'88:88::::88....:88:.:88:'88:::88....:88::88....:88:'88....:88:'88...:88:
80 //  :88::::::::'88:.:88:::88:::::88::.:8888::::88:::::88::88:::::88::88:::::88::88:::..::
81 //  :88:::::::'88:::.:88::88:::::88:::.:88:::::88888888:::88888888:::88:::::88:.:888888::
82 //  :88::::::::888888888::88:::::88:::::88:::::88....:88::88..:88::::88:::::88::.....:88:
83 //  :88::::::::88....:88::88:::::88:::::88:::::88:::::88::88::.:88:::88:::::88:'88::::88:
84 //  :88888888::88:::::88::88888888::::::88:::::88888888:::88:::.:88:.:8888888::.:888888::
85 //                                      88
86 
87 
88 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
89 CryptoBroChics presents: LadyBrosPepeBoboTurboGooch666Inu [LITECOIN]   
90 Telegram: ThisMetaIsSoRedactedBro [there is no telegram]
91 Website:  https://ladybros.me
92 Twitter:  https://twitter.com/LBPBTG666I
93 Somewhere in between the $LADYS and $BROS is a long, thicc fork of HarryPotterObamaSonic10Inu ($BITCOIN): $LITECOIN
94 **/
95 
96 // SPDX-License-Identifier: NONE
97 
98 pragma solidity 0.8.19;
99 
100 abstract contract Context {
101     function _msgSender() internal view virtual returns (address) {
102         return msg.sender;
103     }
104 }
105 
106 interface IERC20 {
107     function totalSupply() external view returns (uint256);
108     function balanceOf(address account) external view returns (uint256);
109     function transfer(address recipient, uint256 amount) external returns (bool);
110     function allowance(address owner, address spender) external view returns (uint256);
111     function approve(address spender, uint256 amount) external returns (bool);
112     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
113     event Transfer(address indexed from, address indexed to, uint256 value);
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 library SafeMath {
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121         return c;
122     }
123 
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b <= a, errorMessage);
130         uint256 c = a - b;
131         return c;
132     }
133 
134     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
135         if (a == 0) {
136             return 0;
137         }
138         uint256 c = a * b;
139         require(c / a == b, "SafeMath: multiplication overflow");
140         return c;
141     }
142 
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return div(a, b, "SafeMath: division by zero");
145     }
146 
147     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b > 0, errorMessage);
149         uint256 c = a / b;
150         return c;
151     }
152 
153 }
154 
155 contract Ownable is Context {
156     address private _owner;
157     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159     constructor () {
160         address msgSender = _msgSender();
161         _owner = msgSender;
162         emit OwnershipTransferred(address(0), msgSender);
163     }
164 
165     function owner() public view returns (address) {
166         return _owner;
167     }
168 
169     modifier onlyOwner() {
170         require(_owner == _msgSender(), "Ownable: caller is not the owner");
171         _;
172     }
173 
174     function renounceOwnership() public virtual onlyOwner {
175         emit OwnershipTransferred(_owner, address(0));
176         _owner = address(0);
177     }
178 
179 }
180 
181 interface IUniswapV2Factory {
182     function createPair(address tokenA, address tokenB) external returns (address pair);
183 }
184 
185 interface IUniswapV2Router02 {
186     function swapExactTokensForETHSupportingFeeOnTransferTokens(
187         uint amountIn,
188         uint amountOutMin,
189         address[] calldata path,
190         address to,
191         uint deadline
192     ) external;
193     function factory() external pure returns (address);
194     function WETH() external pure returns (address);
195     function addLiquidityETH(
196         address token,
197         uint amountTokenDesired,
198         uint amountTokenMin,
199         uint amountETHMin,
200         address to,
201         uint deadline
202     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
203 }
204 
205 contract Litecoin is Context, IERC20, Ownable {
206     using SafeMath for uint256;
207     mapping (address => uint256) private _balances;
208     mapping (address => mapping (address => uint256)) private _allowances;
209     mapping (address => bool) private _isExcludedFromFee;
210     mapping (address => bool) private bots;
211     mapping(address => uint256) private _holderLastTransferTimestamp;
212     bool public transferDelayEnabled = false;
213     address payable private _taxWallet;
214 
215     uint256 private _initialBuyTax=15;
216     uint256 private _initialSellTax=69;
217     uint256 private _finalBuyTax=0;
218     uint256 private _finalSellTax=0;
219     uint256 public _reduceBuyTaxAt=16;
220     uint256 public _reduceSellTaxAt=19;
221     uint256 private _preventSwapBefore=30;
222     uint256 private _buyCount=0;
223 
224     uint8 private constant _decimals = 8;
225     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
226     string private constant _name = unicode"LadyBrosPepeBoboTurboGooch666Inu";
227     string private constant _symbol = unicode"LITECOIN";
228     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
229     uint256 public _maxWalletSize = 30000000 * 10**_decimals;
230     uint256 public _taxSwapThreshold=6000000 * 10**_decimals;
231     uint256 public _maxTaxSwap=6000000 * 10**_decimals;
232 
233     IUniswapV2Router02 private uniswapV2Router;
234     address private uniswapV2Pair;
235     bool private tradingOpen;
236     bool private inSwap = false;
237     bool private swapEnabled = false;
238 
239     event MaxTxAmountUpdated(uint _maxTxAmount);
240     modifier lockTheSwap {
241         inSwap = true;
242         _;
243         inSwap = false;
244     }
245 
246     constructor () {
247         _taxWallet = payable(_msgSender());
248         _balances[_msgSender()] = _tTotal;
249         _isExcludedFromFee[owner()] = true;
250         _isExcludedFromFee[address(this)] = true;
251         _isExcludedFromFee[_taxWallet] = true;
252 
253         emit Transfer(address(0), _msgSender(), _tTotal);
254     }
255 
256     function name() public pure returns (string memory) {
257         return _name;
258     }
259 
260     function symbol() public pure returns (string memory) {
261         return _symbol;
262     }
263 
264     function decimals() public pure returns (uint8) {
265         return _decimals;
266     }
267 
268     function totalSupply() public pure override returns (uint256) {
269         return _tTotal;
270     }
271 
272     function balanceOf(address account) public view override returns (uint256) {
273         return _balances[account];
274     }
275 
276     function transfer(address recipient, uint256 amount) public override returns (bool) {
277         _transfer(_msgSender(), recipient, amount);
278         return true;
279     }
280 
281     function allowance(address owner, address spender) public view override returns (uint256) {
282         return _allowances[owner][spender];
283     }
284 
285     function approve(address spender, uint256 amount) public override returns (bool) {
286         _approve(_msgSender(), spender, amount);
287         return true;
288     }
289 
290     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
291         _transfer(sender, recipient, amount);
292         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
293         return true;
294     }
295 
296     function _approve(address owner, address spender, uint256 amount) private {
297         require(owner != address(0), "ERC20: approve from the zero address");
298         require(spender != address(0), "ERC20: approve to the zero address");
299         _allowances[owner][spender] = amount;
300         emit Approval(owner, spender, amount);
301     }
302 
303     function _transfer(address from, address to, uint256 amount) private {
304         require(from != address(0), "ERC20: transfer from the zero address");
305         require(to != address(0), "ERC20: transfer to the zero address");
306         require(amount > 0, "Transfer amount must be greater than zero");
307         uint256 taxAmount=0;
308         if (from != owner() && to != owner()) {
309             require(!bots[from] && !bots[to]);
310 
311             if (transferDelayEnabled) {
312                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
313                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
314                   _holderLastTransferTimestamp[tx.origin] = block.number;
315                 }
316             }
317 
318             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
319                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
320                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
321                 _buyCount++;
322             }
323 
324 
325             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
326             if(to == uniswapV2Pair && from!= address(this) ){
327                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
328             }
329 
330             uint256 contractTokenBalance = balanceOf(address(this));
331             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
332                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
333                 uint256 contractETHBalance = address(this).balance;
334                 if(contractETHBalance > 0) {
335                     sendETHToFee(address(this).balance);
336                 }
337             }
338         }
339 
340         if(taxAmount>0){
341           _balances[address(this)]=_balances[address(this)].add(taxAmount);
342           emit Transfer(from, address(this),taxAmount);
343         }
344         _balances[from]=_balances[from].sub(amount);
345         _balances[to]=_balances[to].add(amount.sub(taxAmount));
346         emit Transfer(from, to, amount.sub(taxAmount));
347     }
348 
349 
350     function min(uint256 a, uint256 b) private pure returns (uint256){
351       return (a>b)?b:a;
352     }
353 
354     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
355         if(tokenAmount==0){return;}
356         if(!tradingOpen){return;}
357         address[] memory path = new address[](2);
358         path[0] = address(this);
359         path[1] = uniswapV2Router.WETH();
360         _approve(address(this), address(uniswapV2Router), tokenAmount);
361         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
362             tokenAmount,
363             0,
364             path,
365             address(this),
366             block.timestamp
367         );
368     }
369 
370     function removeLimits() external onlyOwner{
371         _maxTxAmount = _tTotal;
372         _maxWalletSize=_tTotal;
373         transferDelayEnabled=false;
374         _reduceSellTaxAt=20;
375         _reduceBuyTaxAt=20;
376         emit MaxTxAmountUpdated(_tTotal);
377     }
378 
379     function sendETHToFee(uint256 amount) private {
380         _taxWallet.transfer(amount);
381     }
382 
383     function isBot(address a) public view returns (bool){
384       return bots[a];
385     }
386 
387     function fluffing() external onlyOwner() {
388         require(!tradingOpen,"trading is already open");
389         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
390         _approve(address(this), address(uniswapV2Router), _tTotal);
391         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
392         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
393         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
394         swapEnabled = true;
395         tradingOpen = true;
396     }
397 
398     receive() external payable {}
399 
400     function manualSwap() external {
401         require(_msgSender()==_taxWallet);
402         uint256 tokenBalance=balanceOf(address(this));
403         if(tokenBalance>0){
404           swapTokensForEth(tokenBalance);
405         }
406         uint256 ethBalance=address(this).balance;
407         if(ethBalance>0){
408           sendETHToFee(ethBalance);
409         }
410     }
411     
412     function addBots(address[] memory bots_) public onlyOwner {
413         for (uint i = 0; i < bots_.length; i++) {
414             bots[bots_[i]] = true;
415         }
416     }
417 
418     function delBots(address[] memory notbot) public onlyOwner {
419       for (uint i = 0; i < notbot.length; i++) {
420           bots[notbot[i]] = false;
421       }
422     }
423     
424 }