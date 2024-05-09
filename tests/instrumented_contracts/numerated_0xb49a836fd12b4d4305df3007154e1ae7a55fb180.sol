1 /**
2 
3 $HEAVEN awaits for the diamond hands who want to join us.......
4 
5                 _                                  
6               (`  ).                   _           
7              (     ).              .:(`  )`.       
8 )           _(       '`.          :(   .    )      
9         .=(`(      .   )     .--  `.  (    ) )      
10        ((    (..__.:'-'   .+(   )   ` _`  ) )                 
11 `.     `(       ) )       (   .  )     (   )  ._   
12   )      ` __.:'   )     (   (   ))     `-'.-(`  ) 
13 )  )  ( )       --'       `- __.'         :(      )) 
14 .-'  (_.'          .')                    `(    )  ))
15                   (_  )                     ` __.:'          
16                                         
17 --..,___.--,--'`,---..-.--+--.,,-,,..._.--..-._.-a:f--.
18 
19 https://twitter.com/HEAVENERC20
20 https://t.me/HeavenEntry
21 
22 **/
23 
24 pragma solidity 0.8.17;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34     function balanceOf(address account) external view returns (uint256);
35     function transfer(address recipient, uint256 amount) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37     function approve(address spender, uint256 amount) external returns (bool);
38     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 library SafeMath {
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57         return c;
58     }
59 
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         if (a == 0) {
62             return 0;
63         }
64         uint256 c = a * b;
65         require(c / a == b, "SafeMath: multiplication overflow");
66         return c;
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return div(a, b, "SafeMath: division by zero");
71     }
72 
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b > 0, errorMessage);
75         uint256 c = a / b;
76         return c;
77     }
78 
79 }
80 
81 contract Ownable is Context {
82     address private _owner;
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     constructor () {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90 
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     function renounceOwnership() public virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104 
105 }
106 
107 interface IUniswapV2Factory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IUniswapV2Router02 {
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129 }
130 
131 contract HEAVEN is Context, IERC20, Ownable {
132     using SafeMath for uint256;
133     mapping (address => uint256) private _balances;
134     mapping (address => mapping (address => uint256)) private _allowances;
135     mapping (address => bool) private _isExcludedFromFee;
136     mapping (address => bool) private bots;
137     mapping(address => uint256) private _holderLastTransferTimestamp;
138     bool public transferDelayEnabled = true;
139     address payable private _taxWallet;
140 
141     uint256 private _initialBuyTax=20;
142     uint256 private _initialSellTax=20;
143     uint256 private _finalBuyTax=0;
144     uint256 private _finalSellTax=0;
145     uint256 private _reduceBuyTaxAt=15;
146     uint256 private _reduceSellTaxAt=25;
147     uint256 private _preventSwapBefore=20;
148     uint256 private _buyCount=0;
149 
150     uint8 private constant _decimals = 9;
151     uint256 private constant _tTotal = 777777777777 * 10**_decimals;
152     string private constant _name = unicode"HEAVEN"; 
153     string private constant _symbol = unicode"HEAVEN"; 
154     uint256 public _maxTxAmount =   15555555555 * 10**_decimals;
155     uint256 public _maxWalletSize = 15555555555 * 10**_decimals;
156     uint256 public _taxSwapThreshold= 7777777777 * 10**_decimals;
157     uint256 public _maxTaxSwap= 7777777777 * 10**_decimals;
158 
159     IUniswapV2Router02 private uniswapV2Router;
160     address private uniswapV2Pair;
161     bool private tradingOpen;
162     bool private inSwap = false;
163     bool private swapEnabled = false;
164 
165     event MaxTxAmountUpdated(uint _maxTxAmount);
166     modifier lockTheSwap {
167         inSwap = true;
168         _;
169         inSwap = false;
170     }
171 
172     constructor () {
173         _taxWallet = payable(_msgSender());
174         _balances[_msgSender()] = _tTotal;
175         _isExcludedFromFee[owner()] = true;
176         _isExcludedFromFee[address(this)] = true;
177         _isExcludedFromFee[_taxWallet] = true;
178 
179         emit Transfer(address(0), _msgSender(), _tTotal);
180     }
181 
182     function name() public pure returns (string memory) {
183         return _name;
184     }
185 
186     function symbol() public pure returns (string memory) {
187         return _symbol;
188     }
189 
190     function decimals() public pure returns (uint8) {
191         return _decimals;
192     }
193 
194     function totalSupply() public pure override returns (uint256) {
195         return _tTotal;
196     }
197 
198     function balanceOf(address account) public view override returns (uint256) {
199         return _balances[account];
200     }
201 
202     function transfer(address recipient, uint256 amount) public override returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     function allowance(address owner, address spender) public view override returns (uint256) {
208         return _allowances[owner][spender];
209     }
210 
211     function approve(address spender, uint256 amount) public override returns (bool) {
212         _approve(_msgSender(), spender, amount);
213         return true;
214     }
215 
216     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
217         _transfer(sender, recipient, amount);
218         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
219         return true;
220     }
221 
222     function _approve(address owner, address spender, uint256 amount) private {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228 
229     function _transfer(address from, address to, uint256 amount) private {
230         require(from != address(0), "ERC20: transfer from the zero address");
231         require(to != address(0), "ERC20: transfer to the zero address");
232         require(amount > 0, "Transfer amount must be greater than zero");
233         uint256 taxAmount=0;
234         if (from != owner() && to != owner()) {
235             require(!bots[from] && !bots[to]);
236             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
237 
238             if (transferDelayEnabled) {
239                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
240                       require(
241                           _holderLastTransferTimestamp[tx.origin] <
242                               block.number,
243                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
244                       );
245                       _holderLastTransferTimestamp[tx.origin] = block.number;
246                   }
247               }
248 
249             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
250                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
251                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
252                 _buyCount++;
253             }
254 
255             if(to == uniswapV2Pair && from!= address(this) ){
256                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
257             }
258 
259             uint256 contractTokenBalance = balanceOf(address(this));
260             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
261                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
262                 uint256 contractETHBalance = address(this).balance;
263                 if(contractETHBalance > 0) {
264                     sendETHToFee(address(this).balance);
265                 }
266             }
267         }
268 
269         if(taxAmount>0){
270           _balances[address(this)]=_balances[address(this)].add(taxAmount);
271           emit Transfer(from, address(this),taxAmount);
272         }
273         _balances[from]=_balances[from].sub(amount);
274         _balances[to]=_balances[to].add(amount.sub(taxAmount));
275         emit Transfer(from, to, amount.sub(taxAmount));
276     }
277 
278 
279     function min(uint256 a, uint256 b) private pure returns (uint256){
280       return (a>b)?b:a;
281     }
282 
283     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
284         address[] memory path = new address[](2);
285         path[0] = address(this);
286         path[1] = uniswapV2Router.WETH();
287         _approve(address(this), address(uniswapV2Router), tokenAmount);
288         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
289             tokenAmount,
290             0,
291             path,
292             address(this),
293             block.timestamp
294         );
295     }
296 
297     function removeLimits() external onlyOwner{
298         _maxTxAmount = _tTotal;
299         _maxWalletSize=_tTotal;
300         transferDelayEnabled=false;
301         emit MaxTxAmountUpdated(_tTotal);
302     }
303 
304     function sendETHToFee(uint256 amount) private {
305         _taxWallet.transfer(amount);
306     }
307 
308     function addBots(address[] memory bots_) public onlyOwner {
309         for (uint i = 0; i < bots_.length; i++) {
310             bots[bots_[i]] = true;
311         }
312     }
313 
314     function delBots(address[] memory notbot) public onlyOwner {
315       for (uint i = 0; i < notbot.length; i++) {
316           bots[notbot[i]] = false;
317       }
318     }
319 
320     function isBot(address a) public view returns (bool){
321       return bots[a];
322     }
323 
324     function openTrading() external onlyOwner() {
325         require(!tradingOpen,"trading is already open");
326         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
327         _approve(address(this), address(uniswapV2Router), _tTotal);
328         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
329         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
330         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
331         swapEnabled = true;
332         tradingOpen = true;
333     }
334 
335     
336     function reduceFee(uint256 _newFee) external{
337       require(_msgSender()==_taxWallet);
338       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
339       _finalBuyTax=_newFee;
340       _finalSellTax=_newFee;
341     }
342 
343     receive() external payable {}
344 
345     function manualSwap() external {
346         require(_msgSender()==_taxWallet);
347         uint256 tokenBalance=balanceOf(address(this));
348         if(tokenBalance>0){
349           swapTokensForEth(tokenBalance);
350         }
351         uint256 ethBalance=address(this).balance;
352         if(ethBalance>0){
353           sendETHToFee(ethBalance);
354         }
355     }
356 }