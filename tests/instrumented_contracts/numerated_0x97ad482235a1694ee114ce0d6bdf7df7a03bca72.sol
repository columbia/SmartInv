1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.7;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 }
11 
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         require(c >= a, "SafeMath: addition overflow");
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
35         require(b <= a, errorMessage);
36         uint256 c = a - b;
37         return c;
38     }
39 
40 
41 
42 }
43 
44 contract Ownable is Context {
45     address private _owner;
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47     constructor () {
48         _owner = _msgSender();
49         emit OwnershipTransferred(address(0), _msgSender());
50     }
51 
52     function owner() public view returns (address) {
53         return _owner;
54     }
55 
56     modifier onlyOwner() {
57         require(_owner == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     function transferOwnership(address _address) external onlyOwner (){
62         emit OwnershipTransferred(_owner, _address);
63         _owner = _address;
64     }
65 
66 }  
67 
68 interface IUniswapV2Factory {
69     function createPair(address tokenA, address tokenB) external returns (address pair);
70 }
71 
72 interface IUniswapV2Router02 {
73     function swapExactTokensForETHSupportingFeeOnTransferTokens(
74         uint amountIn,
75         uint amountOutMin,
76         address[] calldata path,
77         address to,
78         uint deadline
79     ) external;
80     function factory() external pure returns (address);
81     function WETH() external pure returns (address);
82     function addLiquidityETH(
83         address token,
84         uint amountTokenDesired,
85         uint amountTokenMin,
86         uint amountETHMin,
87         address to,
88         uint deadline
89     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
90 }
91 
92 contract tumb is Context, IERC20, Ownable {
93     using SafeMath for uint256;
94     mapping (address => uint256) private balance;
95     mapping (address => mapping (address => uint256)) private _allowances;
96     mapping (address => bool) private _isExcludedFromFee;
97     
98     uint256 private constant _tTotal = 420_000_000_000_000000000;
99     uint256 private  maxWallet = _tTotal/100; 
100     uint256 private taxPerc = 0;
101     uint256 private tax = 0;
102     address payable private wallet1;
103     address payable private wallet2;
104     address payable private deployerWallet;
105     string private constant _name = "TUMB";
106     string private constant _symbol = "TUMB";
107     uint8 private constant _decimals = 9;
108     bool private inSwap = false;
109     
110     modifier lockTheSwap {
111         inSwap = true;
112         _;
113         inSwap = false;
114     }
115     IUniswapV2Router02 private uniswapV2Router;
116     address private uniswapV2Pair;
117     bool private tradingOpen;
118     bool private paused;
119     uint256 private _maxTxAmount = _tTotal;
120     event MaxTxAmountUpdated(uint _maxTxAmount);
121     event MaxWalletPercUpdated(uint _maxWalletPerc);
122     
123     constructor (address payable _wallet1, address payable _deployerWallet,address payable _wallet2) { 
124         require(_wallet1 != address(0),"Zero address exception");
125         require(_deployerWallet != address(0),"Zero address exception");
126         require(_wallet2 != address(0),"Zero address exception");
127         wallet1 = _wallet1;
128         deployerWallet = _deployerWallet;
129         wallet2 = _wallet2;
130         balance[msg.sender] = _tTotal;
131         _isExcludedFromFee[owner()] = true;
132         _isExcludedFromFee[address(this)] = true;
133         _isExcludedFromFee[wallet1] = true;
134         emit Transfer(address(0),owner(), _tTotal);
135     }
136 
137     function name() external pure returns (string memory) {
138         return _name;
139     }
140 
141     function symbol() external pure returns (string memory) {
142         return _symbol;
143     }
144 
145     function decimals() external pure returns (uint8) {
146         return _decimals;
147     }
148 
149     function totalSupply() external pure override returns (uint256) {
150         return _tTotal;
151     }
152 
153     function balanceOf(address account) public view override returns (uint256) {
154         return balance[account];
155     }
156 
157     function transfer(address recipient, uint256 amount) external override returns (bool) {
158         _transfer(_msgSender(), recipient, amount);
159         return true;
160     }
161 
162     function allowance(address holder, address spender) external view override returns (uint256) {
163         return _allowances[holder][spender];
164     }
165 
166     function approve(address spender, uint256 amount) external override returns (bool) {
167         _approve(_msgSender(), spender, amount);
168         return true;
169     }
170 
171     function isWhitelisted(address _addr) external view returns(bool){
172         return _isExcludedFromFee[_addr];
173     }
174 
175     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
176         _transfer(sender, recipient, amount);
177         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
178         return true;
179     }
180 
181     function _approve(address holder, address spender, uint256 amount) private {
182         require(holder != address(0), "ERC20: approve from the zero address");
183         require(spender != address(0), "ERC20: approve to the zero address");
184         _allowances[holder][spender] = amount;
185         emit Approval(holder, spender, amount);
186     }
187 
188     function _transfer(address from, address to, uint256 amount) private {
189         require(amount > 0, "Transfer amount must be greater than zero");
190         require(balanceOf(from) >= amount,"Balance less then transfer"); 
191 
192         tax = 0;
193         if (!(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {            
194             require(!paused,"Trading is paused");
195             require(amount <= _maxTxAmount,"Amount exceed max trnx amount");
196             
197             if(to != uniswapV2Pair){   
198             require(balanceOf(to) + amount <= maxWallet,"max Wallet limit exceeded");
199             }
200             uint256 contractETHBalance = address(this).balance;
201             if(contractETHBalance > 500000000000000000) { 
202                 sendETHToFee(address(this).balance);
203             }
204             if(from == uniswapV2Pair){
205                 tax = taxPerc;
206             }
207             else if(to == uniswapV2Pair){ // Only Swap taxes on a sell
208                 tax = taxPerc;
209                 uint256 contractTokenBalance = balanceOf(address(this));
210                 if(!inSwap){
211                     if(contractTokenBalance > _tTotal/1000){ // 0.01%
212                         swapTokensForEth(contractTokenBalance);
213                     }
214                 }
215             }
216                
217         }
218         _tokenTransfer(from,to,amount);
219     }
220 
221 
222     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
223         address[] memory path = new address[](2);
224         path[0] = address(this);
225         path[1] = uniswapV2Router.WETH();
226         _approve(address(this), address(uniswapV2Router), tokenAmount);
227         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
228             tokenAmount,
229             0,
230             path,
231             address(this),
232             block.timestamp
233         );
234     }
235     
236 
237     function removeLimits() external onlyOwner{
238         require(tradingOpen,"Trading is not enabled yet");
239         _maxTxAmount = _tTotal;
240         maxWallet = _tTotal;
241         emit MaxTxAmountUpdated(_tTotal);
242         emit MaxWalletPercUpdated(_tTotal);
243     }
244 
245     function sendETHToFee(uint256 amount) private {
246         wallet1.transfer(amount*3/5);
247         wallet2.transfer(amount/5);
248         deployerWallet.transfer(address(this).balance);        
249     }
250     
251     
252     function openTrading() external onlyOwner {
253         require(!tradingOpen,"trading is already open");
254         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
255         uniswapV2Router = _uniswapV2Router;
256         _approve(address(this), address(uniswapV2Router), _tTotal);
257         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
258         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
259         _maxTxAmount = _tTotal*75/1000;
260         maxWallet = _tTotal*75/1000;
261         taxPerc = 25;
262         tradingOpen = true;
263         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
264     }
265 
266 
267     function dropTaxes() external onlyOwner{
268         taxPerc = 2;
269     }
270 
271     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
272         
273         uint256 tTeam = amount*tax/100;    
274         uint256 remainingAmount = amount - tTeam; 
275         balance[sender] = balance[sender].sub(amount); 
276         balance[recipient] = balance[recipient].add(remainingAmount); 
277         balance[address(this)] = balance[address(this)].add(tTeam); 
278         emit Transfer(sender, recipient, remainingAmount);
279     }
280 
281     event addressWhitelisted(address _address,bool _bool);
282 
283     function whitelistForCex(address _addr,bool _bool) external {
284         require(msg.sender == deployerWallet,"Only team can call this function");
285         _isExcludedFromFee[_addr] = _bool;
286         emit addressWhitelisted(_addr,_bool);
287     }
288 
289     receive() external payable {}
290     
291     function transferERC20(IERC20 token, uint256 amount) external { //function to transfer stuck erc20 tokens
292         require(msg.sender == deployerWallet,"Only team can call this function");
293         require(token != IERC20(address(this)),"You can't withdraw tokens from owned by contract."); 
294         uint256 erc20balance = token.balanceOf(address(this));
295         require(amount <= erc20balance, "balance is low");
296         token.transfer(deployerWallet, amount);
297     }
298 
299 
300     function manualswap() external {
301         require(msg.sender == deployerWallet,"Only team can call this function");
302         uint256 contractBalance = balanceOf(address(this));
303         swapTokensForEth(contractBalance);
304     }
305 
306     function manualsend() external {
307         require(msg.sender == deployerWallet,"Only team can call this function");
308         uint256 contractETHBalance = address(this).balance;
309         sendETHToFee(contractETHBalance);
310     }
311 }