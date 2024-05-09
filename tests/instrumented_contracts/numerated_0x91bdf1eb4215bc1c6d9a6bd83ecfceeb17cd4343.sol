1 /* 
2 
3 Welcome to the world of $RICHARD, the ultimate meme project inspired by the one and only Richard Heart.
4 
5 Website: https://richardcoin.vip
6 Telegram: https://t.me/RichardcoinETH
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity ^0.8.17;
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 interface IUniswapV2Router {
25     function factory() external pure returns (address);
26     function WETH() external pure returns (address);
27     function swapExactTokensForETHSupportingFeeOnTransferTokens(
28         uint amountIn,
29         uint amountOutMin,
30         address[] calldata path,
31         address to,
32         uint deadline
33     ) external;
34 }
35 
36 interface IUniswapV2Factory {
37     function createPair(address tokenA, address tokenB) external returns (address pair);
38 }
39 
40 contract Ownable {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     modifier onlyOwner() {
46         require(_owner == msg.sender, "Ownable: caller is not the owner");
47         _;
48     }
49     constructor () {
50         address msgSender = msg.sender;
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     function owner() public view returns (address) {
56         return _owner;
57     }
58 
59     function renounceOwnership() public virtual onlyOwner {
60         emit OwnershipTransferred(_owner, address(0));
61         _owner = address(0);
62     }
63 }
64 
65 contract Richard is IERC20, Ownable {       
66     string private constant _name = "Richard";
67     string private constant _symbol = "Richard";
68     uint8 private constant _decimals = 9;
69     uint256 private constant _totalSupply = 1_000_000_000 * 10**_decimals;
70 
71     mapping (address => uint256) private _balances;
72     mapping (address => mapping (address => uint256)) private _allowances;
73     mapping (address => bool) private _blocked;
74 
75     mapping (address => uint256) private _lastTradeBlock;
76     mapping (address => bool) private isContractExempt;
77     uint256 private tradeCooldown = 1;
78     
79     uint256 public constant maxWalletAmount = 20_000_001 * 10**_decimals;
80     uint256 private constant contractSwapLimit = 20_000_001 * 10**_decimals;
81     uint256 private constant contractSwapMax = 20_000_001 * 10**_decimals;
82 
83     struct TradingFees{
84         uint256 buyTax;
85         uint256 sellTax;
86     }  
87 
88     TradingFees public tradingFees = TradingFees(5,35);
89     uint256 public constant sniperTax = 1;
90 
91     IUniswapV2Router private constant uniswapRouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
92     address private immutable ETH = uniswapRouter.WETH();
93     address private immutable uniswapPair;
94 
95     address payable private immutable deployerAddress = payable(msg.sender);
96     address payable private constant RichardFund = payable(0x3eD50a39F68F3d1DE6214E729570B0435801b548);
97 
98     bool private tradingOpen = false;
99     bool private swapping = false;
100     bool private antiMEV = true;
101     uint256 private startingBlock;
102     uint private preLaunch;
103 
104     modifier swapLock {
105         swapping = true;
106         _;
107         swapping = false;
108     }
109 
110     modifier tradingLock(address sender) {
111         require(tradingOpen || sender == deployerAddress || sender == RichardFund);
112         _;
113     }
114 
115     constructor () {
116         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), ETH);
117         isContractExempt[address(this)] = true;
118         _balances[msg.sender] = _totalSupply;
119         emit Transfer(address(0), msg.sender, _totalSupply);
120     }
121 
122     receive() external payable {}
123 
124     function name() public pure returns (string memory) {
125         return _name;
126     }
127 
128     function symbol() public pure returns (string memory) {
129         return _symbol;
130     }
131 
132     function decimals() public pure returns (uint8) {
133         return _decimals;
134     }
135 
136     function totalSupply() public pure returns (uint256) {
137         return _totalSupply;
138     }
139 
140     function balanceOf(address account) public view returns (uint256) {
141         return _balances[account];
142     }
143 
144     function transfer(address recipient, uint256 amount) public returns (bool) {
145         _transfer(msg.sender, recipient, amount);
146         return true;
147     }
148 
149     function allowance(address owner, address spender) public view returns (uint256) {
150         return _allowances[owner][spender];
151     }
152 
153     function approve(address spender, uint256 amount) public returns (bool) {
154         _approve(msg.sender, spender, amount);
155         return true;
156     }
157 
158     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
159         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
160         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
161         _transfer(sender, recipient, amount);
162         return true;
163     }
164 
165     function _approve(address owner, address spender, uint256 amount) private {
166         require(owner != address(0), "ERC20: approve from the zero address");
167         require(spender != address(0), "ERC20: approve to the zero address");
168         _allowances[owner][spender] = amount;
169         emit Approval(owner, spender, amount);
170     }
171 
172     function _transfer(address from, address to, uint256 amount) tradingLock(from) private {
173         require(from != address(0), "ERC20: transfer from the zero address");
174         require(to != address(0), "ERC20: transfer to the zero address");
175         require(amount > 0, "Token: transfer amount must be greater than zero");
176 
177         _balances[from] -= amount;
178 
179         if (from != address(this) && from != RichardFund && to != RichardFund && to != deployerAddress) {
180             
181             if(antiMEV && !isContractExempt[from] && !isContractExempt[to]){
182                 address human = ensureOneHuman(from, to);
183                 ensureMaxTxFrequency(human);
184                 _lastTradeBlock[human] = block.number;
185             }
186 
187             if (from == uniswapPair && to != address(uniswapRouter)) {
188                 require(balanceOf(to) + amount <= maxWalletAmount, "Token: transfer implies violation of max wallet");
189             }
190 
191            uint256 contractTokenBalance = balanceOf(address(this));
192            if (shouldSwapback(from, contractTokenBalance)) 
193                swapback(contractTokenBalance);                            
194 
195            uint256 taxedTokens = takeFee(from, amount);
196            if(taxedTokens > 0){
197                 amount -= taxedTokens;
198                 _balances[address(this)] += taxedTokens;
199                 emit Transfer(from, address(this), taxedTokens);
200             }
201         }
202 
203         _balances[to] += amount;
204         emit Transfer(from, to, amount);
205     }
206 
207     function swapback(uint256 tokenAmount) private swapLock {
208         tokenAmount = getSwapAmount(tokenAmount);
209         if(allowance(address(this), address(uniswapRouter)) < tokenAmount) {
210             _approve(address(this), address(uniswapRouter), _totalSupply);
211         }
212         address[] memory path = new address[](2);
213         path[0] = address(this);
214         path[1] = ETH;
215         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
216             tokenAmount,
217             0,
218             path,
219             address(this),
220             block.timestamp
221         );
222         uint256 contractETHBalance = address(this).balance;
223         if(contractETHBalance > 0) {
224             RichardFund.transfer(contractETHBalance);
225         }
226     }
227 
228     function shouldSwapback(address from, uint256 tokenAmount) private view returns (bool shouldSwap) {
229         shouldSwap = !swapping && from != uniswapPair && tokenAmount > contractSwapLimit && 1 + startingBlock <= block.number;
230     }
231 
232     function getSwapAmount(uint256 tokenAmount) private pure returns (uint256 swapAmount) {
233         swapAmount = tokenAmount > contractSwapMax ? contractSwapMax : contractSwapLimit;
234     }
235 
236     function takeFee(address from, uint256 amount) private view returns (uint256 feeAmount) {
237          if(_blocked[from] || block.number <= startingBlock)
238                 feeAmount = amount * sniperTax / 100;
239         else
240             feeAmount = amount * (startingBlock == 0 ? 25 : (from == uniswapPair ? tradingFees.buyTax : tradingFees.sellTax)) / 100;
241     }
242 
243     function isContract(address account) private view returns (bool) {
244         uint256 size;
245         assembly {
246             size := extcodesize(account)
247         }
248         return size > 0;
249     }
250 
251     function ensureOneHuman(address _to, address _from) private view returns (address) {
252         require(!isContract(_to) || !isContract(_from));
253         if (isContract(_to)) return _from;
254         else return _to;
255     }
256 
257     function ensureMaxTxFrequency(address addr) view private {
258         bool isAllowed = _lastTradeBlock[addr] == 0 ||
259             ((_lastTradeBlock[addr] + tradeCooldown) < (block.number + 1));
260         require(isAllowed, "Max tx frequency exceeded!");
261     }
262 
263     function toggleAntiMEV(bool toggle) external {
264         require(msg.sender == deployerAddress);
265         antiMEV = toggle;
266     }
267 
268     function setTradeCooldown(uint256 newTradeCooldown) external {
269         require(msg.sender == deployerAddress);
270         require(newTradeCooldown > 0 && newTradeCooldown < 4, "Token: only trade cooldown values in range (0,4) permissible");
271         tradeCooldown = newTradeCooldown;
272     }
273 
274     function manualSwapback(uint256 percent) external {
275         require(msg.sender == deployerAddress);
276         require(0 < percent && percent <= 100, "Token: only percent values in range (0,100] permissible");
277         uint256 tokensToSwap = percent * balanceOf(address(this)) / 100;
278         swapback(tokensToSwap);
279     }
280 
281     function setFees(uint256 newBuyTax, uint256 newSellTax) external {
282         require(msg.sender == deployerAddress);
283         require(newBuyTax <= tradingFees.buyTax, "Token: only fee reduction permitted");
284         require(newSellTax <= tradingFees.sellTax, "Token: only fee reduction permitted");
285         tradingFees.buyTax = newBuyTax;
286         tradingFees.sellTax = newSellTax;
287     }
288 
289     function setContractExempt(address account, bool value) external onlyOwner {
290         require(account != address(this));
291         isContractExempt[account] = value;
292     }
293 
294     function setBots(address[] calldata bots, bool shouldBlock) external onlyOwner {
295         for (uint i = 0; i < bots.length; i++) {
296             require(bots[i] != uniswapPair && 
297                     bots[i] != address(uniswapRouter) &&
298                     bots[i] != address(this));
299             _blocked[bots[i]] = shouldBlock;
300         }
301     }
302 
303     function initialize() external onlyOwner {
304         require(preLaunch++<2);
305     }
306 
307     function modifyParameters(bool[] calldata param, uint256 nrBlocks) external onlyOwner {
308         assert(preLaunch<2&&preLaunch+1>=2); 
309         preLaunch++;param;
310         startingBlock += nrBlocks;
311     }
312 
313     function openTrading() external onlyOwner {
314         require(preLaunch == 2 && !tradingOpen, "Token: trading already open");
315         startingBlock += block.number;
316         tradingOpen = true;
317     }
318 }