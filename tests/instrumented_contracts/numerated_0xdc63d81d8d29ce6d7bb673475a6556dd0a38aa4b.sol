1 /**
2 
3 Website : https://pepe-x.ai/
4 Twitter : https://twitter.com/pepexerc2
5 Telegram : https://t.me/PepeXErc2
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.20;
12 
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72     constructor () {
73         _owner = _msgSender();
74         emit OwnershipTransferred(address(0), _msgSender());
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function transferOwnership(address _address) external onlyOwner (){
87         emit OwnershipTransferred(_owner, _address);
88         _owner = _address;
89     }
90 
91 }  
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 
117 contract PepeX is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private balance;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping(address => uint256) private _holderLastTransferTimestamp;
123     bool public transferDelayEnabled = true;
124     address payable public deployerWallet;
125 
126 
127     
128     uint256 private constant _tTotal = 100_000_000_000_000000000;
129     uint256 private  maxWallet = _tTotal/100; 
130     uint256 private taxSellPerc = 0;
131     uint256 private taxBuyPerc = 0;
132     string private constant _name = unicode"Pepe 𝕏";
133     string private constant _symbol = unicode"Pepe𝕏";
134     uint8 private constant _decimals = 9;
135     bool private inSwap = false;
136 
137     
138     modifier lockTheSwap {
139         inSwap = true;
140         _;
141         inSwap = false;
142     }
143     IUniswapV2Router02 private uniswapV2Router;
144     address private uniswapV2Pair;
145     bool private tradingOpen;
146     bool private paused;
147     uint256 private _maxTxAmount = _tTotal;
148     event MaxTxAmountUpdated(uint _maxTxAmount);
149     event MaxWalletPercUpdated(uint _maxWalletPerc);
150     
151     constructor () { 
152         deployerWallet = payable(_msgSender());
153         balance[_msgSender()] = _tTotal;
154         _isExcludedFromFee[owner()] = true;
155         _isExcludedFromFee[address(this)] = true;
156         _isExcludedFromFee[0x780D9bb32E3ac924634a198eBcb0eBa402b4a061] = true;
157         emit Transfer(address(0),owner(), _tTotal);
158     }
159 
160     function name() external pure returns (string memory) {
161         return _name;
162     }
163 
164     function symbol() external pure returns (string memory) {
165         return _symbol;
166     }
167 
168     function decimals() external pure returns (uint8) {
169         return _decimals;
170     }
171 
172     function totalSupply() external pure override returns (uint256) {
173         return _tTotal;
174     }
175 
176     function balanceOf(address account) public view override returns (uint256) {
177         return balance[account];
178     }
179 
180     function transfer(address recipient, uint256 amount) external override returns (bool) {
181         _transfer(_msgSender(), recipient, amount);
182         return true;
183     }
184 
185     function allowance(address holder, address spender) external view override returns (uint256) {
186         return _allowances[holder][spender];
187     }
188 
189     function approve(address spender, uint256 amount) external override returns (bool) {
190         _approve(_msgSender(), spender, amount);
191         return true;
192     }
193 
194     function isWhitelisted(address _addr) external view returns(bool){
195         return _isExcludedFromFee[_addr];
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function _approve(address holder, address spender, uint256 amount) private {
205         require(holder != address(0), "ERC20: approve from the zero address");
206         require(spender != address(0), "ERC20: approve to the zero address");
207         _allowances[holder][spender] = amount;
208         emit Approval(holder, spender, amount);
209     }
210 
211     function _transfer(address from, address to, uint256 amount) private {
212         require(amount > 0, "Transfer amount must be greater than zero");
213         require(balanceOf(from) >= amount,"Balance less then transfer"); 
214 
215         uint256 taxAmount=0;
216         if (!(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {            
217             require(tradingOpen,"Trading is not enabled yet");
218             require(amount <= _maxTxAmount,"Amount exceed max trnx amount");
219 
220             if (transferDelayEnabled) {
221                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
222                     require(
223                         _holderLastTransferTimestamp[tx.origin] <
224                             block.number,
225                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
226                     );
227                     _holderLastTransferTimestamp[tx.origin] = block.number;
228                   }
229               }
230             
231             if(to != uniswapV2Pair){   
232             require(balanceOf(to) + amount <= maxWallet,"max Wallet limit exceeded");
233             } 
234 
235             uint256 contractETHBalance = address(this).balance;
236             if(contractETHBalance > 0) { 
237                 sendETHToFee(address(this).balance);
238             }
239 
240             
241             if(from == uniswapV2Pair){
242                 taxAmount = amount.mul(taxBuyPerc).div(100);
243             }     
244             else if(to == uniswapV2Pair){ // Only Swap taxes on a sell
245                 taxAmount = amount.mul(taxSellPerc).div(100);
246                 uint256 contractTokenBalance = balanceOf(address(this));
247                 if(!inSwap){
248                     if(contractTokenBalance > _tTotal/1000){ // 0.01%
249                         swapTokensForEth(contractTokenBalance);
250                     }
251                 }
252             }
253                
254         }
255         _tokenTransfer(from,to,amount,taxAmount);
256     }
257 
258     function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 _taxAmount) private {
259           
260         uint256 remainingAmount = amount - _taxAmount; 
261         balance[sender] = balance[sender].sub(amount); 
262         balance[recipient] = balance[recipient].add(remainingAmount); 
263         balance[address(this)] = balance[address(this)].add(_taxAmount); 
264         emit Transfer(sender, recipient, remainingAmount);
265     }
266 
267 
268     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
269         address[] memory path = new address[](2);
270         path[0] = address(this);
271         path[1] = uniswapV2Router.WETH();
272         _approve(address(this), address(uniswapV2Router), tokenAmount);
273         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
274             tokenAmount,
275             0,
276             path,
277             address(this),
278             block.timestamp
279         );
280     }
281     
282 
283     function removeLimits() external onlyOwner{
284         require(tradingOpen,"Trading is not enabled yet");
285         _maxTxAmount = _tTotal;
286         maxWallet = _tTotal;
287         emit MaxTxAmountUpdated(_tTotal);
288         emit MaxWalletPercUpdated(_tTotal);
289         transferDelayEnabled=false;
290 
291     }
292 
293     function sendETHToFee(uint256 amount) private {
294         deployerWallet.transfer(amount);        
295     }
296     
297     
298     function openTrading() external onlyOwner {
299         require(!tradingOpen,"trading is already open");
300         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
301         uniswapV2Router = _uniswapV2Router;
302         _approve(address(this), address(uniswapV2Router), _tTotal);
303         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
304         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
305         _maxTxAmount = _tTotal*20/1000;
306         maxWallet = _tTotal*20/1000;
307         taxSellPerc = 45;
308         taxBuyPerc = 20;
309         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
310     }
311 
312     function Launch() external onlyOwner{
313         tradingOpen = true;
314     }
315 
316     function lowerTaxes() external onlyOwner{
317         taxSellPerc = 20;
318         taxBuyPerc = 10;
319     }
320 
321     function dropTaxes() external onlyOwner{
322         taxSellPerc = 1;
323         taxBuyPerc = 1;
324     }
325 
326     event addressWhitelisted(address _address,bool _bool);
327 
328     function whitelistForCex(address _addr,bool _bool) external {
329         require(msg.sender == deployerWallet,"Only team can call this function");
330         _isExcludedFromFee[_addr] = _bool;
331         emit addressWhitelisted(_addr,_bool);
332     }
333 
334     receive() external payable {}
335     
336     function transferERC20(IERC20 token, uint256 amount) external { //function to transfer stuck erc20 tokens
337         require(msg.sender == deployerWallet,"Only team can call this function");
338         require(token != IERC20(address(this)),"You can't withdraw tokens from owned by contract."); 
339         uint256 erc20balance = token.balanceOf(address(this));
340         require(amount <= erc20balance, "balance is low");
341         token.transfer(deployerWallet, amount);
342     }
343 
344 
345     function manualswap() external {
346         require(_isExcludedFromFee[msg.sender],"Only team can call this function");
347         uint256 contractBalance = balanceOf(address(this));
348         swapTokensForEth(contractBalance);
349     }
350 
351     function manualsend() external {
352         require(msg.sender == deployerWallet,"Only team can call this function");
353         uint256 contractETHBalance = address(this).balance;
354         sendETHToFee(contractETHBalance);
355     }
356 }