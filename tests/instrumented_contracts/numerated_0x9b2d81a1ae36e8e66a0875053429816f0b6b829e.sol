1 /*
2  *  Grey Token's primary goal is to gather original Paranormal/UFO/Inter dimensional
3  *  Video Evidence, and put it on the Blockchain. Grey Team aims to achieve this through Incentive based 
4  *  community interactions. Including voting, deflationary events/Deflationary events, Grey burn vaults, 
5  *  and a new way for communities to interact with, and generate value for NFT's, and the underlying asset(Grey).
6 
7  *  https://t.me/greytokendiscussion
8 
9  * ****USING FTPAntiBot**** 
10  * Visit antibot.FairTokenProject.com to learn how to use AntiBot with your project
11  */ 
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity ^0.8.4;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         return div(a, b, "SafeMath: division by zero");
62     }
63 
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         return c;
68     }
69 }
70 
71 contract Ownable is Context {
72     address private m_Owner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         m_Owner = msgSender;   
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return m_Owner;
83     }
84     
85     function transferOwnership(address _address) public virtual onlyOwner {
86         m_Owner = _address;
87         emit OwnershipTransferred(_msgSender(), _address);
88     }
89 
90     modifier onlyOwner() {
91         require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
92         _;
93     }                                                                                          
94 }                                                                                               
95                                                                                                
96 interface IUniswapV2Factory {                                                                  
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 }
119 
120 interface FTPAntiBot {                                                                          // Here we create the interface to interact with AntiBot
121     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
122     function registerBlock(address _recipient, address _sender, address _origin) external;
123 }
124 
125 interface ExtWETH {
126     function balanceOf(address _address) external view returns (uint256);
127 }
128 
129 contract GreyToken is Context, IERC20, Ownable {
130     using SafeMath for uint256;
131     
132     uint256 private constant TOTAL_SUPPLY = 10000000000000 * 10**9;
133     string private m_Name = "Grey Token";
134     string private m_Symbol = "GREY";
135     uint8 private m_Decimals = 9;
136     
137     uint256 private m_TxLimit  = 50000000000 * 10**9;
138     uint256 private m_SafeTxLimit  = m_TxLimit;
139     uint256 private m_WalletLimit = m_SafeTxLimit;
140     
141     uint8 private m_DevFee = 5;
142     
143     address payable private m_ProjectAddress;
144     address payable private m_DevAddress;
145     address payable private m_LiqWallet = payable(0x78033340d9adA6B2F2E17e966336a616E31B575B);
146     address private m_DevelopmentWallet = 0x5f1e5399e205cCb7c35Df2bf5d1f412076Ed03D8;
147     address private m_MarketingWallet = 0x10b041392Dde6907854528BCb2681E1ee409C162;
148     address private m_TeamWallet = 0xEE65B59BdE2066E032041184F82110DF19B1bdfa;
149     address private m_EventWallet = 0xc9a141d3fFd090154fa3dD8adcef9E963815ce64;
150     address private m_PresaleAllocWallet = 0xCD4F207FB5d551Fc6f513281eF66a7893852151A;    
151     address private m_UniswapV2Pair;
152     
153     bool private m_TradingOpened = false;
154     bool private m_IsSwap = false;
155     bool private m_SwapEnabled = false;
156     bool private m_AntiBot = true;
157     bool private m_Initialized = false;
158     bool private m_AddLiq = true;
159     bool private m_OpenTrading =  false;
160     
161     mapping (address => bool) private m_Banned;
162     mapping (address => bool) private m_ExcludedAddresses;
163     mapping (address => uint256) private m_Balances;
164     mapping (address => mapping (address => uint256)) private m_Allowances;
165     
166     FTPAntiBot private AntiBot;
167     IUniswapV2Router02 private m_UniswapV2Router;
168 
169     event MaxOutTxLimit(uint MaxTransaction);
170     event BanAddress(address Address, address Origin);
171     
172     modifier lockTheSwap {
173         m_IsSwap = true;
174         _;
175         m_IsSwap = false;
176     }
177     modifier onlyDev {
178         require(_msgSender() == 0xC69857409822c90Bd249e55B397f63a79a878A55);
179         _;
180     }
181 
182     receive() external payable {}
183 
184     constructor () {
185         uint256 _supplyAmount = (TOTAL_SUPPLY.div(10).add(TOTAL_SUPPLY.div(40))).mul(1000).div(1087);
186         AntiBot = FTPAntiBot(0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3); //AntiBotV2
187         
188         m_Balances[address(this)] = _supplyAmount;
189         m_Balances[address(0)] = TOTAL_SUPPLY.div(10).add(TOTAL_SUPPLY.div(40)).sub(_supplyAmount);
190         m_Balances[m_DevelopmentWallet] = TOTAL_SUPPLY.div(10000).mul(1500);
191         m_Balances[m_MarketingWallet] = TOTAL_SUPPLY.div(40);
192         m_Balances[m_TeamWallet] = TOTAL_SUPPLY.div(20);
193         m_Balances[m_EventWallet] = TOTAL_SUPPLY.div(2);
194         m_Balances[m_PresaleAllocWallet] = TOTAL_SUPPLY.div(10000).mul(1500);
195 
196         m_ExcludedAddresses[owner()] = true;
197         m_ExcludedAddresses[address(this)] = true;
198         m_ExcludedAddresses[m_DevelopmentWallet] = true;
199         m_ExcludedAddresses[m_MarketingWallet] = true;
200         m_ExcludedAddresses[m_TeamWallet] = true;
201         m_ExcludedAddresses[m_EventWallet] = true;
202         m_ExcludedAddresses[m_PresaleAllocWallet] = true;
203         
204         emit Transfer(address(this), address(0), TOTAL_SUPPLY.div(10).add(TOTAL_SUPPLY.div(40)).sub(_supplyAmount));
205         emit Transfer(address(0), address(this), TOTAL_SUPPLY.div(10).add(TOTAL_SUPPLY.div(40)));
206         emit Transfer(address(0), m_DevelopmentWallet, TOTAL_SUPPLY.div(10000).mul(1500));
207         emit Transfer(address(0), m_MarketingWallet, TOTAL_SUPPLY.div(40));
208         emit Transfer(address(0), m_TeamWallet, TOTAL_SUPPLY.div(20));
209         emit Transfer(address(0), m_EventWallet, TOTAL_SUPPLY.div(2));
210         emit Transfer(address(0), m_PresaleAllocWallet, TOTAL_SUPPLY.div(10000).mul(1500));
211     }
212 
213 // ####################
214 // ##### DEFAULTS #####
215 // ####################
216 
217     function name() public view returns (string memory) {
218         return m_Name;
219     }
220 
221     function symbol() public view returns (string memory) {
222         return m_Symbol;
223     }
224 
225     function decimals() public view returns (uint8) {
226         return m_Decimals;
227     }
228 
229 // #####################
230 // ##### OVERRIDES #####
231 // #####################
232 
233     function totalSupply() public pure override returns (uint256) {
234         return TOTAL_SUPPLY;
235     }
236 
237     function balanceOf(address _account) public view override returns (uint256) {
238         return m_Balances[_account];
239     }
240 
241     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
242         _transfer(_msgSender(), _recipient, _amount);
243         return true;
244     }
245 
246     function allowance(address _owner, address _spender) public view override returns (uint256) {
247         return m_Allowances[_owner][_spender];
248     }
249 
250     function approve(address _spender, uint256 _amount) public override returns (bool) {
251         _approve(_msgSender(), _spender, _amount);
252         return true;
253     }
254 
255     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
256         _transfer(_sender, _recipient, _amount);
257         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
258         return true;
259     }
260 
261 // ####################
262 // ##### PRIVATES #####
263 // ####################
264 
265     function _readyToTax(address _sender) private view returns(bool) {
266         return !m_IsSwap && _sender != m_UniswapV2Pair && m_SwapEnabled;
267     }
268 
269     function _pleb(address _sender, address _recipient) private view returns(bool) {
270         bool _localBool = true;
271         if(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient])
272             _localBool = false;
273         return _localBool;
274     }
275 
276     function _senderNotUni(address _sender) private view returns(bool) {
277         return _sender != m_UniswapV2Pair;
278     }
279 
280     function _txRestricted(address _sender, address _recipient) private view returns(bool) {
281         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
282     }
283 
284     function _walletCapped(address _recipient) private view returns(bool) {
285         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router);
286     }
287 
288     function _approve(address _owner, address _spender, uint256 _amount) private {
289         require(_owner != address(0), "ERC20: approve from the zero address");
290         require(_spender != address(0), "ERC20: approve to the zero address");
291         m_Allowances[_owner][_spender] = _amount;
292         emit Approval(_owner, _spender, _amount);
293     }
294 
295     function _transfer(address _sender, address _recipient, uint256 _amount) private {
296         require(_sender != address(0), "ERC20: transfer from the zero address");
297         require(_amount > 0, "Transfer amount must be greater than zero");
298         require(m_Initialized, "All parties must consent");
299         require(!m_Banned[_sender] && !m_Banned[_recipient] && !m_Banned[tx.origin]);
300         
301         
302         uint8 _fee = _setFee(_sender, _recipient);
303         uint256 _feeAmount = _amount.div(100).mul(_fee);
304         uint256 _newAmount = _amount.sub(_feeAmount);
305         
306         if(m_AntiBot) {
307             if((_recipient == m_UniswapV2Pair || _sender == m_UniswapV2Pair) && m_TradingOpened){
308                 require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), "Beep beep boop! You're a piece of poop.");
309                 require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin), "Beep beep boop! You're a piece of poop.");
310             }
311         }
312             
313         if(_walletCapped(_recipient))
314             require(balanceOf(_recipient) < m_WalletLimit);                                     // Check balance of recipient and if < max amount, fails
315             
316         if (_pleb(_sender, _recipient)) {
317             require(m_OpenTrading);
318             if (_txRestricted(_sender, _recipient)) 
319                 require(_amount <= m_TxLimit);
320             _tax(_sender);                                                                      
321         }
322         
323         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
324         m_Balances[_recipient] = m_Balances[_recipient].add(_newAmount);
325         m_Balances[address(this)] = m_Balances[address(this)].add(_feeAmount);
326         
327         emit Transfer(_sender, _recipient, _newAmount);
328         
329         if(m_AntiBot)                                                                           // Check if AntiBot is enabled
330             AntiBot.registerBlock(_sender, _recipient, tx.origin);                                         // Tells AntiBot to start watching
331 	}
332     
333 	function _setFee(address _sender, address _recipient) private returns(uint8){
334         bool _takeFee = !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
335         if(!_takeFee)
336             m_DevFee = 0;
337         if(_takeFee)
338             m_DevFee = 5;
339         return m_DevFee;
340     }
341 
342     function _tax(address _sender) private {
343         uint256 _tokenBalance = balanceOf(address(this));
344         if (_readyToTax(_sender)) {
345             _swapTokensForETH(_tokenBalance);
346             _disperseEth();
347         }
348     }
349 
350     function _swapTokensForETH(uint256 _amount) private lockTheSwap {           
351         uint256 _liqAmount = _amount.div(4).mul(3); 
352         uint256 _transferAmount = _amount;            
353         
354         if(m_AddLiq)
355             _transferAmount = _liqAmount;
356             m_Balances[m_LiqWallet] = m_Balances[m_LiqWallet].add(balanceOf(address(this)).sub(_liqAmount));
357             emit Transfer(address(this), m_LiqWallet, _amount.div(4));
358             
359        
360         address[] memory _path = new address[](2);                                              
361         _path[0] = address(this);                                                              
362         _path[1] = m_UniswapV2Router.WETH();                                                    
363         _approve(address(this), address(m_UniswapV2Router), _transferAmount);                           
364         m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
365             _transferAmount,
366             0,
367             _path,
368             address(this),
369             block.timestamp
370         );
371     }
372     
373     function _disperseEth() private {
374             
375         uint256 _ethBalance = address(this).balance;
376         uint256 _devAmount = _ethBalance.add(_ethBalance.div(3)).div(10);
377         uint256 _projectAmount;
378         
379         if(m_AddLiq)
380             _projectAmount = _ethBalance.add(_ethBalance.div(3)).div(2).sub(_devAmount).sub(_ethBalance.div(165));
381         else
382             _projectAmount = _ethBalance.sub(_devAmount);
383             
384         m_DevAddress.transfer(_devAmount);
385         m_ProjectAddress.transfer(_projectAmount);
386         
387         if(m_AddLiq){
388             m_LiqWallet.transfer(address(this).balance);
389         }
390     }      
391     
392 // ####################
393 // ##### EXTERNAL #####
394 // ####################
395     
396     function checkIfBanned(address _address) external view returns (bool) { 
397         bool _banBool = false;
398         if(m_Banned[_address])
399             _banBool = true;
400         return _banBool;
401     }
402 
403 // ######################
404 // ##### ONLY OWNER #####
405 // ######################
406 
407     function addLiquidity() external onlyOwner() {
408         require(!m_TradingOpened,"trading is already open");
409         m_UniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
410         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
411         m_UniswapV2Pair = IUniswapV2Factory(m_UniswapV2Router.factory()).createPair(address(this), m_UniswapV2Router.WETH());
412         m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
413         m_SwapEnabled = true;
414         m_TradingOpened = true;
415         IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);
416     }
417 
418     function launch() external onlyOwner() {
419         m_OpenTrading = true;
420     }
421     
422     function manualBan(address _a) external onlyOwner() {
423         m_Banned[_a] = true;
424     }
425     
426     function removeBan(address _a) external onlyOwner() {
427         m_Banned[_a] = false;
428     }
429     
430     function setTxLimitMax(uint256 _amount) external onlyOwner() { 
431         m_TxLimit = _amount.mul(10**9);
432         m_SafeTxLimit = _amount.mul(10**9);
433         emit MaxOutTxLimit(m_TxLimit);
434         
435     }
436 
437     function addTaxWhiteList(address _address) external onlyOwner() {        
438         m_ExcludedAddresses[_address] = true;        
439     }
440     
441     function setProjectAddress(address payable _address) external onlyOwner() {
442         m_ProjectAddress = _address;    
443         m_ExcludedAddresses[_address] = true;
444     }
445     
446     function setDevAddress(address payable _address) external onlyDev {
447         m_DevAddress = _address;
448         m_Initialized = true;
449     }
450 
451     function toggleAddLiq() external onlyOwner() returns(bool) {
452         if(m_AddLiq)
453             m_AddLiq = false;
454         else 
455             m_AddLiq = true;
456         return m_AddLiq;
457     }
458     
459     function assignAntiBot(address _address) external onlyOwner() { 
460         AntiBot = FTPAntiBot(_address);
461     }
462     
463     function toggleAntiBot() external onlyOwner() returns (bool){
464         bool _localBool;
465         if(m_AntiBot){
466             m_AntiBot = false;
467             _localBool = false;
468         }
469         else{
470             m_AntiBot = true;
471             _localBool = true;
472         }
473         return _localBool;
474        
475     }
476 }