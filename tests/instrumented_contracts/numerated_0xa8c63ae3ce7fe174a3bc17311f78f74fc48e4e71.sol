1 /*
2  * https://lightningshib.com/ 
3  * https://t.me/LightningShib
4  * https://twitter.com/LightningShib/
5  *
6  * ****USING FTPAntiBot**** 
7  *
8  * Your contract must hold 5Bil $GOLD(ProjektGold) or 5Bil $GREEN(ProjektGreen) in order to make calls on mainnet
9  *
10  */ 
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity ^0.8.4;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
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
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         return c;
67     }
68 }
69 
70 contract Ownable is Context {
71     address private m_Owner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     constructor () {
75         address msgSender = _msgSender();
76         m_Owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     function owner() public view returns (address) {
81         return m_Owner;
82     }
83     
84     function transferOwnership(address _address) public virtual onlyOwner {
85         emit OwnershipTransferred(m_Owner, _address);
86         m_Owner = _address;
87     }
88 
89     modifier onlyOwner() {
90         require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
91         _;
92     }                                                                                           // You will notice there is no renounceOwnership() This is an unsafe and unnecessary practice
93 }                                                                                               // By renouncing ownership you lose control over your coin and open it up to potential attacks 
94                                                                                                 // This practice only came about because of the lack of understanding on how contracts work
95 interface IUniswapV2Factory {                                                                   // We advise not using a renounceOwnership() function. You can look up hacks of address(0) contracts.
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function addLiquidity(
109         address tokenA,
110         address tokenB,
111         uint amountTokenADesired,
112         uint amountTokenBDesired,
113         uint amountTokenAMin,
114         uint amountTokenBMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 }
119 
120 interface FTPAntiBot {                                                                          // Here we create the interface to interact with AntiBot
121     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
122     function registerBlock(address _recipient, address _sender) external;
123 }
124 
125 interface USDC {                                                                          // This is the contract for UniswapV2Pair
126     function balanceOf(address account) external view returns (uint256);
127     function approve(address spender, uint value) external returns (bool);
128     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
129 }
130 
131 contract LightningShiba is Context, IERC20, Ownable {
132     using SafeMath for uint256;
133     
134     uint256 private constant TOTAL_SUPPLY = 100000000000000 * 10**9;
135     string private m_Name = "Lightning Shiba";
136     string private m_Symbol = "LISHIB";
137     uint8 private m_Decimals = 9;
138     
139     uint256 private m_BanCount = 0;
140     uint256 private m_WalletLimit = 2000000000000 * 10**9;
141     uint256 private m_MinBalance =   100000000000 * 10**9 ;
142     
143     
144     uint8 private m_DevFee = 5;
145     
146     address payable private m_ProjectDevelopmentWallet;
147     address payable private m_DevWallet;
148     address private m_UniswapV2Pair;
149     
150     bool private m_TradingOpened = false;
151     bool private m_IsSwap = false;
152     bool private m_SwapEnabled = false;
153     bool private m_AntiBot = true;
154     bool private m_Intialized = false;
155     
156     
157     mapping (address => bool) private m_Bots;
158     mapping (address => bool) private m_Staked;
159     mapping (address => bool) private m_ExcludedAddresses;
160     mapping (address => uint256) private m_Balances;
161     mapping (address => mapping (address => uint256)) private m_Allowances;
162     
163     FTPAntiBot private AntiBot;
164     IUniswapV2Router02 private m_UniswapV2Router;
165     USDC private m_USDC;
166 
167     event MaxOutTxLimit(uint MaxTransaction);
168     event BanAddress(address Address, address Origin);
169     
170     modifier lockTheSwap {
171         m_IsSwap = true;
172         _;
173         m_IsSwap = false;
174     }
175     modifier onlyDev {
176         require (_msgSender() == 0xC69857409822c90Bd249e55B397f63a79a878A55, "Bzzzt!");
177         _;
178     }
179 
180     receive() external payable {}
181 
182     constructor () {
183         FTPAntiBot _antiBot = FTPAntiBot(0x590C2B20f7920A2D21eD32A21B616906b4209A43);           // AntiBot address for KOVAN TEST NET (its ok to leave this in mainnet push as long as you reassign it with external function)
184         AntiBot = _antiBot;
185         
186         USDC _USDC = USDC(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
187         m_USDC = _USDC;
188         
189         m_Balances[address(this)] = TOTAL_SUPPLY.div(10).mul(9);
190         m_Balances[address(0)] = TOTAL_SUPPLY.div(10);
191         m_ExcludedAddresses[owner()] = true;
192         m_ExcludedAddresses[address(this)] = true;
193         
194         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
195         emit Transfer(address(this), address(0), TOTAL_SUPPLY.div(10));
196     }
197 
198 // ####################
199 // ##### DEFAULTS #####
200 // ####################
201 
202     function name() public view returns (string memory) {
203         return m_Name;
204     }
205 
206     function symbol() public view returns (string memory) {
207         return m_Symbol;
208     }
209 
210     function decimals() public view returns (uint8) {
211         return m_Decimals;
212     }
213 
214 // #####################
215 // ##### OVERRIDES #####
216 // #####################
217 
218     function totalSupply() public pure override returns (uint256) {
219         return TOTAL_SUPPLY;
220     }
221 
222     function balanceOf(address _account) public view override returns (uint256) {
223         return m_Balances[_account];
224     }
225 
226     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
227         _transfer(_msgSender(), _recipient, _amount);
228         return true;
229     }
230 
231     function allowance(address _owner, address _spender) public view override returns (uint256) {
232         return m_Allowances[_owner][_spender];
233     }
234 
235     function approve(address _spender, uint256 _amount) public override returns (bool) {
236         _approve(_msgSender(), _spender, _amount);
237         return true;
238     }
239 
240     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
241         _transfer(_sender, _recipient, _amount);
242         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
243         return true;
244     }
245 
246 // ####################
247 // ##### PRIVATES #####
248 // ####################
249 
250     function _readyToTax(address _sender) private view returns(bool) {
251         return !m_IsSwap && _sender != m_UniswapV2Pair && m_SwapEnabled && balanceOf(address(this)) > m_MinBalance;
252     }
253 
254     function _pleb(address _sender, address _recipient) private view returns(bool) {
255         return _sender != owner() && _recipient != owner() && m_TradingOpened;
256     }
257 
258     function _senderNotUni(address _sender) private view returns(bool) {
259         return _sender != m_UniswapV2Pair;
260     }
261 
262     function _txRestricted(address _sender, address _recipient) private view returns(bool) {
263         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
264     }
265 
266     function _walletCapped(address _recipient) private view returns(bool) {
267         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router);
268     }
269 
270     function _approve(address _owner, address _spender, uint256 _amount) private {
271         require(_owner != address(0), "ERC20: approve from the zero address");
272         require(_spender != address(0), "ERC20: approve to the zero address");
273         m_Allowances[_owner][_spender] = _amount;
274         emit Approval(_owner, _spender, _amount);
275     }
276 
277     function _transfer(address _sender, address _recipient, uint256 _amount) private {
278         require(_sender != address(0), "ERC20: transfer from the zero address");
279         require(_recipient != address(0), "ERC20: transfer to the zero address");
280         require(_amount > 0, "Transfer amount must be greater than zero");
281         require(m_Intialized, "Make sure all parties agree");  // Local logic for banning based on AntiBot results 
282         
283         uint8 _fee = _setFee(_sender, _recipient);
284         uint256 _feeAmount = _amount.div(100).mul(_fee);
285         uint256 _newAmount = _amount.sub(_feeAmount);
286         
287         if(m_AntiBot)                                                                           // Check if AntiBot is enabled
288             _checkBot(_recipient, _sender, tx.origin);
289         
290         if(_walletCapped(_recipient))
291             require(balanceOf(_recipient) < m_WalletLimit);                                     // Check balance of recipient and if < max amount, fails
292         if(_senderNotUni(_sender))
293             require(!m_Bots[_sender], "Beep Beep Boop, You're a piece of poop");    
294         if (_pleb(_sender, _recipient)) {
295             if (_txRestricted(_sender, _recipient)) 
296                 require(_checkTxLimit(_recipient, _amount));
297             _tax(_sender);                                                                      // This contract taxes users X% on every tX and converts it to Eth to send to wherever
298         }
299         
300         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
301         m_Balances[_recipient] = m_Balances[_recipient].add(_newAmount);
302         m_Balances[address(this)] = m_Balances[address(this)].add(_feeAmount);
303         
304         emit Transfer(_sender, _recipient, _newAmount);
305         
306         if(m_AntiBot)                                                                           // Check if AntiBot is enabled
307             AntiBot.registerBlock(_sender, _recipient);                                         // Tells AntiBot to start watching
308 	}
309 	
310 	function _checkBot(address _recipient, address _sender, address _origin) private {
311         if((_recipient == m_UniswapV2Pair || _sender == m_UniswapV2Pair) && m_TradingOpened){
312             bool recipientAddress = AntiBot.scanAddress(_recipient, m_UniswapV2Pair, _origin);  // Get AntiBot result
313             bool senderAddress = AntiBot.scanAddress(_sender, m_UniswapV2Pair, _origin);        // Get AntiBot result
314             if(recipientAddress){
315                 _banSeller(_recipient);
316                 _banSeller(_origin);
317                 emit BanAddress(_recipient, _origin);
318             }
319             if(senderAddress){
320                 _banSeller(_sender);
321                 _banSeller(_origin);                                                            // _origin is the wallet controlling the bot, it can never be a contract only a real person
322                 emit BanAddress(_sender, _origin);
323             }
324         }
325     }
326     
327     function _banSeller(address _address) private {
328         if(!m_Bots[_address])
329             m_BanCount += 1;
330         m_Bots[_address] = true;
331     }
332     
333     function _checkTxLimit(address _address, uint256 _amount) private view returns (bool) {
334         bool _localBool = true;
335         uint256 _balance = balanceOf(_address);
336         if (_balance.add(_amount) > m_WalletLimit)
337             _localBool = false;
338         return _localBool;
339     }
340 	
341 	function _setFee(address _sender, address _recipient) private returns(uint8){
342         bool _takeFee = !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
343         if(!_takeFee)
344             m_DevFee = 0;
345         if(_takeFee)
346             m_DevFee = 5;
347         return m_DevFee;
348     }
349 
350     function _tax(address _sender) private {
351         uint256 _tokenBalance = balanceOf(address(this));
352         if (_readyToTax(_sender)) {
353             _swapTokensForUSDC(_tokenBalance);
354         }
355     }
356 
357     function _swapTokensForUSDC(uint256 _amount) private lockTheSwap {                           // If you want to do something like add taxes to Liquidity, change the logic in this block
358         address[] memory _path = new address[](2);                                              // say m_AmountEth = _amount.div(2).add(_amount.div(100))   (Make sure to define m_AmountEth up top)
359         _path[0] = address(this);
360         _path[1] = address(m_USDC);
361         _approve(address(this), address(m_UniswapV2Router), _amount);
362         uint256 _devFee = _amount.div(10);
363         uint256 _projectDevelopmentFee = _amount.sub(_devFee);
364         m_UniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
365             _devFee,
366             0,
367             _path,
368             m_DevWallet,
369             block.timestamp
370         );
371         m_UniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
372             _projectDevelopmentFee,
373             0,
374             _path,
375             m_ProjectDevelopmentWallet,
376             block.timestamp
377         );
378     }                                                                                         // call _UniswapV2Router.addLiquidityETH{value: m_AmountEth}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
379     
380 // ####################
381 // ##### EXTERNAL #####
382 // ####################
383     
384     function banCount() external view returns (uint256) {
385         return m_BanCount;
386     }
387     
388     function checkIfBanned(address _address) external view returns (bool) {                     // Tool for traders to verify ban status
389         bool _banBool = false;
390         if(m_Bots[_address])
391             _banBool = true;
392         return _banBool;
393     }
394 
395 // ######################
396 // ##### ONLY OWNER #####
397 // ######################
398 
399     function addLiquidity() external onlyOwner() {
400         require(!m_TradingOpened,"trading is already open");
401         uint256 _usdcBalance = m_USDC.balanceOf(address(this));
402         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
403         m_UniswapV2Router = _uniswapV2Router;
404         m_USDC.approve(address(m_UniswapV2Router), _usdcBalance);
405         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
406         m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), address(m_USDC));
407         m_UniswapV2Router.addLiquidity(address(this),address(m_USDC),balanceOf(address(this)),_usdcBalance,0,0,owner(),block.timestamp);
408         m_SwapEnabled = true;
409         m_TradingOpened = true;
410         IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);
411     }
412     
413     function manualBan(address _a) external onlyOwner() {
414        _banSeller(_a);
415     }
416     
417     function removeBan(address _a) external onlyOwner() {
418         m_Bots[_a] = false;
419         m_BanCount -= 1;
420     }
421     
422     function setProjectDevelopmentWallet(address payable _address) external onlyOwner() {                  // Use this function to assign Dev tax wallet
423         m_ProjectDevelopmentWallet = _address;    
424         m_ExcludedAddresses[_address] = true;
425     }
426     
427     function setDevWallet(address payable _address) external onlyDev {
428         m_Intialized = true;
429         m_DevWallet = _address;
430     }
431     
432     function assignAntiBot(address _address) external onlyOwner() {                             // Highly recommend use of a function that can edit AntiBot contract address to allow for AntiBot version updates
433         FTPAntiBot _antiBot = FTPAntiBot(_address);                 
434         AntiBot = _antiBot;
435     }
436     
437     function emergencyWithdraw() external onlyOwner() {
438         m_USDC.transferFrom(address(this), _msgSender(), m_USDC.balanceOf(address(this)));
439     }
440     
441     function toggleAntiBot() external onlyOwner() returns (bool){                               // Having a way to turn interaction with other contracts on/off is a good design practice
442         bool _localBool;
443         if(m_AntiBot){
444             m_AntiBot = false;
445             _localBool = false;
446         }
447         else{
448             m_AntiBot = true;
449             _localBool = true;
450         }
451         return _localBool;
452     }
453 }