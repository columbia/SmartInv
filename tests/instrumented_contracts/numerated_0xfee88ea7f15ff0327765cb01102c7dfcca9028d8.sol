1 // SPDX-License-Identifier: Unlicense
2 
3 /*
4 Twitter:  https://twitter.com/slapcoineth
5 Website:  https://slapcoin.xyz
6 Telegram: https://t.me/slapcoineth
7 */
8 
9 //   _________.____       _____ __________ 
10 //  /   _____/|    |     /  _  \\______   \
11 //  \_____  \ |    |    /  /_\  \|     ___/
12 //  /        \|    |___/    |    \    |    
13 // /_______  /|_______ \____|__  /____|    
14 //         \/         \/       \/      
15 
16 /**                                                                                            
17                                              @..........@                                           
18                                          @,................(@                                       
19                                       @,...................@..*@                                   @
20                                      ,,.....................,...,                            &@*@,*#
21                                     @,,.........................,@                      @***,,*,,,,,
22                                     @,,,..@...........*,,@@....,,@                @@*,,,,,,,,,,,,,,,
23                                    **,,,..............*@***,*,,,,,,,,,,,,@@@@,,,,,,,,,,,,,,,,,,,,,,,
24                                    @*,,,..................,**(@*@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*,,,*
25                                    @*,,,,,.................@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,,********@@
26                                  @,@*,,,,,,,,,,,,,,,@@,,,,,,,,,*,,,,,,,,,,,,,,,,******@@@           
27                                  #*@@*,,,,,,,,,@@,,,*****@@//@*,,,,,,,,,,,,,,*@@                    
28                                   &**@*,,,,,,/@@@/*,,,,,@*,,,,,,*,,,,,,,,,*@                        
29                                    @**@**,,@,,,,,,,@,,,*,*@@@*,,,,*,,,,**                           
30                                        ,**,**,,@@,*,*@@,,,,,,**@&@,@**@                             
31                                         %**,,***@/,,,,**@@/*@,,,**%                                 
32                                         ****,,,,,,,,,,,,@,&,*@                                      
33                                  @@@%%@ ****,,,,,,,,,,,,,,,**@@@@@@*                               
34                                @%%@%%@%%@@/&**,,,,,,,,,,,,@,*&@%%%@@@#%%                            
35                              @%%%%%%@%%@%%%%%%%@/*,**&@@%%&%%%@#%%%@%%@@                          
36                            ,%%%%#%%%%@%%@%%%%%%%%%@%%%%%%@%@@%&%#%@%%%%@#%(                         
37                            @%%%%%%#@%@%%%%%%%%%%%%%%%%@@@%#%%%@%%%%%@%%%%%@                         
38                        @@%%%%%%%#%%@@%%%@%%%%%%@@@&%%%%%%%@%%%%%#%#%%#%%%%%%%@@                     
39                 @@%%%%%%%%%%%%%%%%%&%@%%%%%%%%%#%#&@&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@              
40             @@%%#%#%#%#%#%%%%%@%#%#@%%%%@%%%%%@%#%#%#%#%#%#%#%#%#%#%#%#%%@%%#%#%#%#%#%%#@@          
41            @%@%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%#%%%%%%%@%%%%%%%%%%%%%%%@%@         
42          #%%%@%%%%%%%%%%%%%%%%%%%@%%%%%@%%#%%%%%%%%%%%%%%%%%%%%%#%%%%%%@%#%%%%%%%%%%%%%%@%%%/       
43         @%%%%@%%%%%%%%%%%%%%%%%%%%%@%%%%@%%%%%%%%%%%%%%%%%%%%%%%#%%%%%@%%%%%%%%%%%%%%%%%@%%%%@      
44        @%%%%%@%%#%%%%%%%%%%%%%%%#%%%%@%%%@%%%%%%#%%%%&%%%%%%%%%%#%%%%%%#%%%%%%%%#%%%%%%%@%%%%%@     
45       @%%%%%%@&%%%%%%%%%%%%%%%%%%%%%%%%%@%@%%%%%%%%%%%@%%%%%%%%%#%%@%%%%%%%%%%%%%%%%%%%@@%%%%%%@    
46      @%%%%%%%%%%%%%%%%%%%%%%%%%%#%%%%%%%%%@@%%%%%%%%%%%%%%%%%%%%%&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@   
47      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%&@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
48 **/
49 
50 pragma solidity 0.8.20;
51 
52 abstract contract Context {
53     function _msgSender() internal view virtual returns (address) {
54         return msg.sender;
55     }
56 }
57 
58 interface IERC20 {
59     function totalSupply() external view returns (uint256);
60     function balanceOf(address account) external view returns (uint256);
61     function transfer(address recipient, uint256 amount) external returns (bool);
62     function allowance(address owner, address spender) external view returns (uint256);
63     function approve(address spender, uint256 amount) external returns (bool);
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65     event Transfer(address indexed from, address indexed to, uint256 value);
66     event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 library SafeMath {
70     function add(uint256 a, uint256 b) internal pure returns (uint256) {
71         uint256 c = a + b;
72         require(c >= a, "SafeMath: addition overflow");
73         return c;
74     }
75 
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83         return c;
84     }
85 
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         if (a == 0) {
88             return 0;
89         }
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92         return c;
93     }
94 
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return div(a, b, "SafeMath: division by zero");
97     }
98 
99     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         require(b > 0, errorMessage);
101         uint256 c = a / b;
102         return c;
103     }
104 
105 }
106 
107 contract Ownable is Context {
108     address private _owner;
109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111     constructor () {
112         address msgSender = _msgSender();
113         _owner = msgSender;
114         emit OwnershipTransferred(address(0), msgSender);
115     }
116 
117     function owner() public view returns (address) {
118         return _owner;
119     }
120 
121     modifier onlyOwner() {
122         require(_owner == _msgSender(), "Ownable: caller is not the owner");
123         _;
124     }
125 
126     function renounceOwnership() public virtual onlyOwner {
127         emit OwnershipTransferred(_owner, address(0));
128         _owner = address(0);
129     }
130 
131 }
132 
133 interface IUniswapV2Factory {
134     function createPair(address tokenA, address tokenB) external returns (address pair);
135 }
136 
137 interface IUniswapV2Router02 {
138     function swapExactTokensForETHSupportingFeeOnTransferTokens(
139         uint amountIn,
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external;
145     function factory() external pure returns (address);
146     function WETH() external pure returns (address);
147     function addLiquidityETH(
148         address token,
149         uint amountTokenDesired,
150         uint amountTokenMin,
151         uint amountETHMin,
152         address to,
153         uint deadline
154     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
155 }
156 
157 contract SLAP is Context, IERC20, Ownable {
158     using SafeMath for uint256;
159     mapping (address => uint256) private _balances;
160     mapping (address => mapping (address => uint256)) private _allowances;
161     mapping (address => bool) private _isExcludedFromFee;
162     mapping (address => bool) private _buyerMap;
163     mapping (address => bool) private bots;
164     mapping(address => uint256) private _holderLastTransferTimestamp;
165     bool public transferDelayEnabled = false;
166     address payable private _taxWallet;
167 
168     uint8 private constant _decimals = 8;
169     uint256 private constant _tTotal = 100000000 * 10**_decimals;
170     string private constant _name = unicode"SLAP";
171     string private constant _symbol = unicode"SLAP";
172     uint256 public _maxTxAmount =   2000000 * 10**_decimals;
173     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
174     uint256 public _taxSwapThreshold=100000 * 10**_decimals;
175     uint256 public _maxTaxSwap=500000 * 10**_decimals;
176 
177     uint256 private _initialBuyTax=20;
178     uint256 private _initialSellTax=20;
179     uint256 private _finalBuyTax=2;
180     uint256 private _finalSellTax=2;
181     uint256 private _reduceBuyTaxAt=15;
182     uint256 private _reduceSellTaxAt=15;
183     uint256 private _preventSwapBefore=16;
184     uint256 private _buyCount=0;
185 
186     IUniswapV2Router02 private uniswapV2Router;
187     address private uniswapV2Pair;
188     bool private tradingOpen;
189     bool private inSwap = false;
190     bool private swapEnabled = false;
191 
192     event MaxTxAmountUpdated(uint _maxTxAmount);
193     modifier lockTheSwap {
194         inSwap = true;
195         _;
196         inSwap = false;
197     }
198 
199     constructor () {
200         _taxWallet = payable(_msgSender());
201         _balances[_msgSender()] = _tTotal;
202         _isExcludedFromFee[owner()] = true;
203         _isExcludedFromFee[address(this)] = true;
204         _isExcludedFromFee[_taxWallet] = true;
205 
206         emit Transfer(address(0), _msgSender(), _tTotal);
207     }
208 
209     function name() public pure returns (string memory) {
210         return _name;
211     }
212 
213     function symbol() public pure returns (string memory) {
214         return _symbol;
215     }
216 
217     function decimals() public pure returns (uint8) {
218         return _decimals;
219     }
220 
221     function totalSupply() public pure override returns (uint256) {
222         return _tTotal;
223     }
224 
225     function balanceOf(address account) public view override returns (uint256) {
226         return _balances[account];
227     }
228 
229     function transfer(address recipient, uint256 amount) public override returns (bool) {
230         _transfer(_msgSender(), recipient, amount);
231         return true;
232     }
233 
234     function allowance(address owner, address spender) public view override returns (uint256) {
235         return _allowances[owner][spender];
236     }
237 
238     function approve(address spender, uint256 amount) public override returns (bool) {
239         _approve(_msgSender(), spender, amount);
240         return true;
241     }
242 
243     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
244         _transfer(sender, recipient, amount);
245         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
246         return true;
247     }
248 
249     function _approve(address owner, address spender, uint256 amount) private {
250         require(owner != address(0), "ERC20: approve from the zero address");
251         require(spender != address(0), "ERC20: approve to the zero address");
252         _allowances[owner][spender] = amount;
253         emit Approval(owner, spender, amount);
254     }
255 
256     function _transfer(address from, address to, uint256 amount) private {
257         require(from != address(0), "ERC20: transfer from the zero address");
258         require(to != address(0), "ERC20: transfer to the zero address");
259         require(amount > 0, "Transfer amount must be greater than zero");
260         uint256 taxAmount=0;
261         if (from != owner() && to != owner()) {
262             require(!bots[from] && !bots[to]);
263 
264             if (transferDelayEnabled) {
265                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
266                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
267                   _holderLastTransferTimestamp[tx.origin] = block.number;
268                 }
269             }
270 
271             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
272                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
273                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
274                 if(_buyCount<_preventSwapBefore){
275                   require(!isContract(to));
276                 }
277                 _buyCount++;
278                 _buyerMap[to]=true;
279             }
280 
281 
282             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
283             if(to == uniswapV2Pair && from!= address(this) ){
284                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
285                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
286                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
287             }
288 
289             uint256 contractTokenBalance = balanceOf(address(this));
290             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
291                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
292                 uint256 contractETHBalance = address(this).balance;
293                 if(contractETHBalance > 0) {
294                     sendETHToFee(address(this).balance);
295                 }
296             }
297         }
298 
299         if(taxAmount>0){
300           _balances[address(this)]=_balances[address(this)].add(taxAmount);
301           emit Transfer(from, address(this),taxAmount);
302         }
303         _balances[from]=_balances[from].sub(amount);
304         _balances[to]=_balances[to].add(amount.sub(taxAmount));
305         emit Transfer(from, to, amount.sub(taxAmount));
306     }
307 
308     function min(uint256 a, uint256 b) private pure returns (uint256){
309       return (a>b)?b:a;
310     }
311 
312     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
313         if(tokenAmount==0){return;}
314         if(!tradingOpen){return;}
315         address[] memory path = new address[](2);
316         path[0] = address(this);
317         path[1] = uniswapV2Router.WETH();
318         _approve(address(this), address(uniswapV2Router), tokenAmount);
319         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
320             tokenAmount,
321             0,
322             path,
323             address(this),
324             block.timestamp
325         );
326     }
327 
328     function sendETHToFee(uint256 amount) private {
329         _taxWallet.transfer(amount);
330     }
331 
332     function isBot(address a) public view returns (bool){
333       return bots[a];
334     }
335 
336     function openTrading() external onlyOwner() {
337         require(!tradingOpen,"trading is already open");
338         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
339         _approve(address(this), address(uniswapV2Router), _tTotal);
340         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
341         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
342         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
343         swapEnabled = true;
344         tradingOpen = true;
345     }
346 
347     function removeLimits() external onlyOwner{
348         _maxTxAmount = _tTotal;
349         _maxWalletSize=_tTotal;
350         transferDelayEnabled=false;
351         emit MaxTxAmountUpdated(_tTotal);
352     }
353 
354     receive() external payable {}
355 
356     function manualSwap() external {
357         require(_msgSender()==_taxWallet);
358         uint256 tokenBalance=balanceOf(address(this));
359         if(tokenBalance>0){
360           swapTokensForEth(tokenBalance);
361         }
362         uint256 ethBalance=address(this).balance;
363         if(ethBalance>0){
364           sendETHToFee(ethBalance);
365         }
366     }
367 
368     function isContract(address account) private view returns (bool) {
369         uint256 size;
370         assembly {
371             size := extcodesize(account)
372         }
373         return size > 0;
374     }
375 
376     function withdrawStuckEth(address toAddr) external onlyOwner {
377         (bool success, ) = toAddr.call{value: address(this).balance}("");
378         require(success);
379     }
380 }