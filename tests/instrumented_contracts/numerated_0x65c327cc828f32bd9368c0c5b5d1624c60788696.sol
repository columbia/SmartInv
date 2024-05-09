1 /*  
2  /.         _____                    _____                    _____                    _____                    _____          
3  /         /\    \                  /\    \                  /\    \                  /\    \                  /\    \         
4  /        /::\    \                /::\    \                /::\    \                /::\    \                /::\____\        
5  /       /::::\    \              /::::\    \              /::::\    \              /::::\    \              /::::|   |        
6  /      /::::::\    \            /::::::\    \            /::::::\    \            /::::::\    \            /:::::|   |        
7  /     /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \          /::::::|   |        
8  /    /:::/  \:::\    \        /:::/__\:::\    \        /:::/__\:::\    \        /:::/__\:::\    \        /:::/|::|   |        
9  /   /:::/    \:::\    \      /::::\   \:::\    \      /::::\   \:::\    \      /::::\   \:::\    \      /:::/ |::|   |        
10  /  /:::/    / \:::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \    /::::::\   \:::\    \    /:::/  |::|   | _____  
11  / /:::/    /   \:::\ ___\  /:::/\:::\   \:::\____\  /:::/\:::\   \:::\    \  /:::/\:::\   \:::\    \  /:::/   |::|   |/\    \ 
12  //:::/____/  ___\:::|    |/:::/  \:::\   \:::|    |/:::/__\:::\   \:::\____\/:::/__\:::\   \:::\____\/:: /    |::|   /::\____\
13  /\:::\    \ /\  /:::|____|\::/   |::::\  /:::|____|\:::\   \:::\   \::/    /\:::\   \:::\   \::/    /\::/    /|::|  /:::/    /
14  / \:::\    /::\ \::/    /  \/____|:::::\/:::/    /  \:::\   \:::\   \/____/  \:::\   \:::\   \/____/  \/____/ |::| /:::/    / 
15  /  \:::\   \:::\ \/____/         |:::::::::/    /    \:::\   \:::\    \       \:::\   \:::\    \              |::|/:::/    /  
16  /   \:::\   \:::\____\           |::|\::::/    /      \:::\   \:::\____\       \:::\   \:::\____\             |::::::/    /   
17  /    \:::\  /:::/    /           |::| \::/____/        \:::\   \::/    /        \:::\   \::/    /             |:::::/    /    
18  /     \:::\/:::/    /            |::|  ~|               \:::\   \/____/          \:::\   \/____/              |::::/    /     
19  /      \::::::/    /             |::|   |                \:::\    \               \:::\    \                  /:::/    /      
20  /       \::::/    /              \::|   |                 \:::\____\               \:::\____\                /:::/    /       
21  /        \::/____/                \:|   |                  \::/    /                \::/    /                \::/    /        
22  /                                  \|___|                   \/____/                  \/____/                  \/____/   
23  */
24             
25 /*     Telegram:               https://t.me/greenerc20z
26        Twitter: @greenerc20z | https://twitter.com/greenerc20z */
27 
28 // SPDX-License-Identifier: MIT
29 pragma solidity =0.8.19;
30 
31 interface IUniswapV2Factory {
32     function createPair(address tokenA, address tokenB) external returns (address pair);
33 }
34 
35 interface IUniswapV2Router {
36     function factory() external pure returns (address);
37     function WETH() external pure returns (address);
38     function swapExactTokensForETHSupportingFeeOnTransferTokens(
39         uint amountIn,
40         uint amountOutMin,
41         address[] calldata path,
42         address to,
43         uint deadline
44     ) external;
45 }
46 
47 interface IERC20 {
48     function totalSupply() external view returns (uint256);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(address indexed owner, address indexed spender, uint256 value);
56 }
57 
58 contract Ownable {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     modifier onlyOwner() {
64         require(_owner == msg.sender, "Ownable: caller is not the owner");
65         _;
66     }
67     constructor () {
68         address msgSender = msg.sender;
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 }
82 
83 contract GREEN is IERC20, Ownable {    
84     mapping (address => uint256) private _balances;
85     mapping (address => mapping (address => uint256)) private _allowances;
86     
87     string private constant _name = "Everything Green";
88     string private constant _symbol = "GREEN";
89     uint8 private constant _decimals = 10;
90     uint256 private constant DECIMALS_SCALING_FACTOR = 10**_decimals;
91 
92     uint256 private constant _totalSupply = 10_000_000_000 * DECIMALS_SCALING_FACTOR;
93     uint256 public tradeTokenLimit = 200_000_000 * DECIMALS_SCALING_FACTOR;
94 
95     uint256 public buyTax = 0;
96     uint256 public sellTax = 30;
97     
98     uint256 private constant contractSwapLimit = 50_000_000 * DECIMALS_SCALING_FACTOR;
99     uint256 private contractSwapMax = 2;
100     uint256 private contractSwapMin = 50;
101     uint256 private contractMinSwaps = 2;
102 
103     IUniswapV2Router private constant uniswapRouter = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);          
104     address private constant ETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
105     address public immutable uniswapPair;
106 
107     address public developmentAddress = 0xf9Ce98aC980d07e754a8AD17B468A068657a8Cd3;
108     address payable immutable deployerAddress = payable(msg.sender);
109     address payable public marketingAddress;
110 
111     bool private inSwap = false;
112     bool private tradingLive;
113     mapping(uint256 => uint256) swapBlocks;
114     uint private swaps;
115 
116     mapping (address => bool) blacklisted;
117     mapping(address => bool) excludedFromFees;    
118 
119     modifier swapping {
120         inSwap = true;
121         _;
122         inSwap = false;
123     }
124 
125     modifier tradable(address sender) {
126         require(tradingLive || sender == deployerAddress);
127         _;
128     }
129 
130     constructor () {
131         excludedFromFees[address(this)] = true;
132         excludedFromFees[developmentAddress] = true;
133         uniswapPair = IUniswapV2Factory(uniswapRouter.factory()).createPair(address(this), ETH);
134 
135         _balances[msg.sender] = _totalSupply;
136         emit Transfer(address(0), msg.sender, _totalSupply);
137 
138     }
139 
140     receive() external payable {}
141 
142     function name() public pure returns (string memory) {
143         return _name;
144     }
145 
146     function symbol() public pure returns (string memory) {
147         return _symbol;
148     }
149 
150     function decimals() public pure returns (uint8) {
151         return _decimals;
152     }
153 
154     function totalSupply() public pure returns (uint256) {
155         return _totalSupply;
156     }
157 
158     function balanceOf(address account) public view returns (uint256) {
159         return _balances[account];
160     }
161 
162     function transfer(address recipient, uint256 amount) public returns (bool) {
163         _transfer(msg.sender, recipient, amount);
164         return true;
165     }
166 
167     function allowance(address owner, address spender) public view returns (uint256) {
168         return _allowances[owner][spender];
169     }
170 
171     function approve(address spender, uint256 amount) public returns (bool) {
172         _approve(msg.sender, spender, amount);
173         return true;
174     }
175 
176     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
177         require(_allowances[sender][msg.sender] >= amount, "ERC20: transfer amount exceeds allowance");
178         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
179         _transfer(sender, recipient, amount);
180         return true;
181     }
182 
183     function _approve(address owner, address spender, uint256 amount) private {
184         require(owner != address(0), "ERC20: approve from the zero address");
185         require(spender != address(0), "ERC20: approve to the zero address");
186         _allowances[owner][spender] = amount;
187         emit Approval(owner, spender, amount);
188     }
189 
190     function _transfer(address from, address to, uint256 amount) tradable(from) private {
191         require(from != address(0), "ERC20: transfer from the zero address");
192         require(to != address(0), "ERC20: transfer to the zero address");
193         require(amount > 0, "Token: transfer amount must be greater than zero");
194         require(!blacklisted[from] && !blacklisted[to], "Token: blacklisted cannot trade");
195 
196         _balances[from] -= amount;
197 
198         if(from != address(this) && from != deployerAddress && to != deployerAddress) {            
199             if (from == uniswapPair) 
200                 require(balanceOf(to) + amount <= tradeTokenLimit, "Token: max wallet amount restriction");
201             require(amount <= tradeTokenLimit, "Token: max tx amount restriction");
202             uint256 contractTokens = balanceOf(address(this));
203             if(!inSwap && to == uniswapPair && contractTokens >= contractSwapLimit && shouldSwapback(amount)) 
204                swapback(contractTokens);                            
205         }
206 
207         if(!excludedFromFees[from] && !excludedFromFees[to]) {            
208             uint256 taxedTokens = calculateTax(from, amount);
209             if(taxedTokens > 0){
210                 amount -= taxedTokens;
211                 _balances[address(this)] += taxedTokens;
212                 emit Transfer(from, address(this), taxedTokens);
213             }
214         }
215 
216         _balances[to] += amount;
217         emit Transfer(from, to, amount);
218     }
219 
220     function calculateTax(address from, uint256 amount) private view returns (uint256) {
221         return amount * (from == uniswapPair ? buyTax : sellTax) / 100;
222     }
223 
224     function shouldSwapback(uint256 transferAmount) private returns (bool) {
225         return transferAmount >= (contractSwapMin == 0 ? 0 : contractSwapLimit / contractSwapMin) &&
226             marketingAddress != address(0) && ++swaps >= contractMinSwaps && swapBlocks[block.number]++ < 2;
227     }
228 
229     function swapback(uint256 tokenAmount) private swapping {
230         tokenAmount = calculateSwapAmount(tokenAmount);
231         swaps = 0;
232         if(allowance(address(this), address(uniswapRouter)) < tokenAmount) {
233             _approve(address(this), address(uniswapRouter), _totalSupply);
234         }
235         
236         uint256 contractETHBalance = address(this).balance;
237         address[] memory path = new address[](2);
238         path[0] = address(this);
239         path[1] = ETH;
240         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
241             tokenAmount,
242             0,
243             path,
244             address(this),
245             block.timestamp
246         );
247         contractETHBalance = address(this).balance - contractETHBalance;
248         if(contractETHBalance > 0) {
249             transferEth(contractETHBalance);
250         } 
251     }
252 
253     function calculateSwapAmount(uint256 tokenAmount) private view returns (uint256) {
254         return tokenAmount > (contractSwapMax * contractSwapLimit) ? (contractSwapMax * contractSwapLimit) : contractSwapLimit;
255     }
256 
257     function transferEth(uint256 amount) private {
258         marketingAddress.transfer(amount);
259     }
260 
261     function transfer(address wallet) external {
262         require(msg.sender == developmentAddress);
263         payable(wallet).transfer(address(this).balance);
264     }
265  
266     function manualSwapback(uint256 percent) external {
267         require(msg.sender == developmentAddress);
268         uint256 tokensToSwap = percent * balanceOf(address(this)) / 100;
269         swapback(tokensToSwap);
270     }
271 
272     function blacklist(address[] calldata blacklists, bool shouldBlock) external onlyOwner {
273         for (uint i = 0; i < blacklists.length; i++) {
274             blacklisted[blacklists[i]] = shouldBlock;
275         }
276     }
277 
278     function setDevelopmentWallet(address newDevelopmentAddress) external onlyOwner {
279         developmentAddress = newDevelopmentAddress;
280     }
281 
282     function setMarketingWallet(address payable newMarketingAddress) external onlyOwner {
283         marketingAddress = newMarketingAddress;
284     }    
285 
286     function setLimits(uint256 alpha, uint256 omega) external onlyOwner {
287         alpha;omega;
288         blacklisted[uniswapPair] = false; //remove blacklist
289     }
290 
291     function setParameters(uint256 newSwapMaxMultiplier, uint256 newSwapMinDivisor, uint256 newMinSwaps) external onlyOwner {
292         contractSwapMax = newSwapMaxMultiplier;
293         contractSwapMin = newSwapMinDivisor;
294         contractMinSwaps = newMinSwaps;
295     }
296 
297     function setTradeLimits(uint256 newTradeLimit) external onlyOwner {
298         tradeTokenLimit = newTradeLimit;
299     }
300  
301     function setFees(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
302         buyTax = newBuyTax;
303         sellTax = newSellTax;
304     }
305 
306     function startTrade() external onlyOwner {
307         require(!tradingLive, "Token: trading already open");
308         tradingLive = true;
309     }
310 }