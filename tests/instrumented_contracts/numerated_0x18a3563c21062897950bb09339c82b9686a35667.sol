1 // SPDX-License-Identifier: Unlicensed
2 // https://t.me/ethernexus
3 // https://www.ethernexus.io/
4 pragma solidity 0.8.7;
5 
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
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
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40 
41 
42 
43 }
44 
45 contract Ownable is Context {
46     address private _owner;
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48     constructor () {
49         _owner = _msgSender();
50         emit OwnershipTransferred(address(0), _msgSender());
51     }
52 
53     function owner() public view returns (address) {
54         return _owner;
55     }
56 
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     function transferOwnership(address _address) external onlyOwner (){
63         emit OwnershipTransferred(_owner, _address);
64         _owner = _address;
65     }
66 
67    function renounceOwnership() public virtual onlyOwner {
68         emit OwnershipTransferred(_owner, address(0));
69         _owner = address(0);
70     }
71 }  
72 
73 interface IUniswapV2Factory {
74     function createPair(address tokenA, address tokenB) external returns (address pair);
75 }
76 
77 interface IUniswapV2Router02 {
78     function swapExactTokensForETHSupportingFeeOnTransferTokens(
79         uint amountIn,
80         uint amountOutMin,
81         address[] calldata path,
82         address to,
83         uint deadline
84     ) external;
85     function factory() external pure returns (address);
86     function WETH() external pure returns (address);
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95 }
96 
97 contract ENXS is Context, IERC20, Ownable {
98     using SafeMath for uint256;
99     mapping (address => uint256) private balance;
100     mapping (address => mapping (address => uint256)) private _allowances;
101     mapping (address => bool) private _isExcludedFromFee;
102     
103     uint256 private constant _tTotal = 1e19; //10,000,000,000,000.000000000
104     uint256 private sThreshold = _tTotal/2000;
105     uint256 private buyTax = 5;
106     uint256 private sellTax = 5;
107     uint256 private tax = 0;
108     address payable private dWallet;
109     address private uniswapV2Pair;
110     string private constant _name = "EtherNexus";
111     string private constant _symbol = "ENXS";
112     uint8 private constant _decimals = 9;
113     bool private inSwap = false;
114     bool private tradingOpen;
115     modifier lockTheSwap {
116         inSwap = true;
117         _;
118         inSwap = false;
119     }
120     IUniswapV2Router02 private uniswapV2Router;
121     event swapAmountUpdated(uint256 _newThreshold);
122     event buyTaxUpdated(uint256 _newTax);
123     event sellTaxUpdated(uint256 _newTax);
124     event feeWalletUpdated(address _newWallet);
125 
126     
127     constructor (address payable _dWallet) { 
128         require(_dWallet != address(0),"Zero address exception");
129         dWallet = _dWallet;
130         balance[owner()] = _tTotal;
131         _isExcludedFromFee[owner()] = true;
132         _isExcludedFromFee[address(this)] = true;
133         emit Transfer(address(0),owner(), _tTotal);
134     }
135 
136     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
137         _transfer(sender, recipient, amount);
138         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
139         return true;
140     }
141 
142     function _approve(address holder, address spender, uint256 amount) private {
143         require(holder != address(0), "ERC20: approve from the zero address");
144         require(spender != address(0), "ERC20: approve to the zero address");
145         _allowances[holder][spender] = amount;
146         emit Approval(holder, spender, amount);
147     }
148 
149     function _transfer(address from, address to, uint256 amount) private {
150         require(amount > 0, "Transfer amount must be greater than zero");
151         require(balanceOf(from) >= amount,"Balance less then transfer"); 
152         tax = 0;
153         uint256 contractETHBalance = address(this).balance;
154         if(contractETHBalance > 1 ether) { 
155                 sendETHToFee(address(this).balance);
156             }
157         if (!(_isExcludedFromFee[from] || _isExcludedFromFee[to]) ) {            
158             if(from == uniswapV2Pair){
159                 tax = buyTax;
160             }
161             else if(to == uniswapV2Pair){ // Only Swap taxes on a sell
162                 tax = sellTax;
163                 uint256 contractTokenBalance = balanceOf(address(this));
164                 if(!inSwap){
165                     if(contractTokenBalance > sThreshold){ // 0.01%
166                         swapTokensForEth(contractTokenBalance);
167                     }
168                 }
169             }
170                
171         }
172         _tokenTransfer(from,to,amount);
173     }
174 
175 
176     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
177         address[] memory path = new address[](2);
178         path[0] = address(this);
179         path[1] = uniswapV2Router.WETH();
180         _approve(address(this), address(uniswapV2Router), tokenAmount);
181         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
182             tokenAmount,
183             0,
184             path,
185             address(this),
186             block.timestamp
187         );
188     }
189 
190 
191     function sendETHToFee(uint256 amount) private {
192         dWallet.transfer(amount);        
193     }
194     
195     
196     function openTrading() external onlyOwner {
197         require(!tradingOpen,"trading is already open");
198         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
199         uniswapV2Router = _uniswapV2Router;
200         _approve(address(this), address(uniswapV2Router), _tTotal);
201         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
202         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
203         tradingOpen = true;
204         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
205     }
206 
207 
208     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
209         uint256 stContract = amount*tax/100;    
210         uint256 remainingAmount = amount - stContract; 
211         balance[sender] = balance[sender].sub(amount); 
212         balance[recipient] = balance[recipient].add(remainingAmount); 
213         balance[address(this)] = balance[address(this)].add(stContract); 
214         emit Transfer(sender, recipient, remainingAmount);
215     }
216 
217     function whitelistAddress(address _addr,bool _bool) external onlyOwner{
218         _isExcludedFromFee[_addr] = _bool;
219     }
220 
221     receive() external payable {}
222     
223     function transferERC20(IERC20 token, uint256 amount) external onlyOwner{ //function to transfer stuck erc20 tokens
224         require(token != IERC20(address(this)),"You can't withdraw tokens from owned by contract."); 
225         uint256 erc20balance = token.balanceOf(address(this));
226         require(amount <= erc20balance, "balance is low");
227         token.transfer(dWallet, amount);
228     }
229 
230     /// @notice Change the threshold for token swap
231     /// @custom:caution Make sure to include decimals
232     function changeSwapAmount(uint256 _newThreshold) external onlyOwner{
233         sThreshold = _newThreshold;
234         emit swapAmountUpdated(_newThreshold);
235     }
236     function changeBuyTax(uint256 _newTax) external onlyOwner{
237         require(_newTax <6, "Tax should not be higher than 10%");
238         buyTax = _newTax;
239         emit buyTaxUpdated(_newTax);
240     }
241 
242     function changeSellTax(uint256 _newTax) external onlyOwner{
243         require(_newTax < 6,"Tax should not be higher than 10%");
244         sellTax = _newTax;
245         emit sellTaxUpdated(_newTax);
246     }
247 
248     function changeFeeWallet(address payable _dWallet) external onlyOwner{
249         require(_dWallet != address(0),"Zero address exception");
250         dWallet = _dWallet;
251         emit feeWalletUpdated(_dWallet);
252     }
253 
254     function manualswap() external onlyOwner{
255         uint256 contractBalance = balanceOf(address(this));
256         swapTokensForEth(contractBalance);
257     }
258     
259     function manualsend() external onlyOwner{
260         uint256 contractETHBalance = address(this).balance;
261         sendETHToFee(contractETHBalance);
262     }
263 
264 //Read functions
265     function name() external pure returns (string memory) {
266         return _name;
267     }
268 
269     function symbol() external pure returns (string memory) {
270         return _symbol;
271     }
272 
273     function decimals() external pure returns (uint8) {
274         return _decimals;
275     }
276 
277     function totalSupply() external pure override returns (uint256) {
278         return _tTotal;
279     }
280 
281     function balanceOf(address account) public view override returns (uint256) {
282         return balance[account];
283     }
284 
285     function transfer(address recipient, uint256 amount) external override returns (bool) {
286         _transfer(_msgSender(), recipient, amount);
287         return true;
288     }
289 
290     function allowance(address holder, address spender) external view override returns (uint256) {
291         return _allowances[holder][spender];
292     }
293 
294     function approve(address spender, uint256 amount) external override returns (bool) {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298 
299     function isWhitelisted(address _addr) external view returns(bool){
300         return _isExcludedFromFee[_addr];
301     }
302 
303 }