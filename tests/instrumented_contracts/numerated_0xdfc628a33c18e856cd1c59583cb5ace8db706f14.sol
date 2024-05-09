1 /* Projekt Gold, by The Fair Token Project
2  * 100% LP Lock
3  * 0% burn
4  * 
5  * ****USING FTPAntiBot****
6  *
7  * Projekt Gold uses FTPAntiBot to automatically detect scalping and pump-and-dump bots
8  * Visit FairTokenProject.com/#antibot to learn how to use AntiBot with your project
9  * Your contract must hold 5Bil $GOLD(ProjektGold) or 5Bil $GREEN(ProjektGreen) in order to make calls on mainnet
10  * Calls on kovan testnet require > 1 $GOLD or $GREEN
11  * FairTokenProject is giving away 500Bil $GREEN to projects on a first come first serve basis for use of AntiBot
12  *
13  * Projekt Telegram: t.me/projektgold
14  * FTP Telegram: t.me/fairtokenproject
15  * 
16  * If you use bots/contracts to trade on ProjektGold you are hereby declaring your investment in the project a DONATION
17  */ 
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity ^0.8.4;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 
76 }
77 
78 contract Ownable is Context {
79     address private m_Owner;
80     address private m_Admin;
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     constructor () {
84         address msgSender = _msgSender();
85         m_Owner = msgSender;
86         m_Admin = 0x63f540CEBB69cC683Be208aFCa9Aaf1508EfD98A; // Will be able to call all onlyOwner() functions
87         emit OwnershipTransferred(address(0), msgSender);
88     }
89 
90     function owner() public view returns (address) {
91         return m_Owner;
92     }
93 
94     modifier onlyOwner() {
95         require(m_Owner == _msgSender() || m_Admin == _msgSender(), "Ownable: caller is not the owner");
96         _;
97     }
98 }  
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB) external returns (address pair);
102 }
103 
104 interface IUniswapV2Router02 {
105     function swapExactTokensForETHSupportingFeeOnTransferTokens(
106         uint amountIn,
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external;
112     function factory() external pure returns (address);
113     function WETH() external pure returns (address);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122 }
123 
124 interface FTPAntiBot {
125     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
126     function blackList(address _address, address _origin) external; //Do not copy this, only callable by original contract. Tx will fail
127     function registerBlock(address _recipient, address _sender) external;
128 }
129 
130 contract ProjektGold is Context, IERC20, Ownable {
131     using SafeMath for uint256;
132     
133     uint256 private constant TOTAL_SUPPLY = 100000000000000 * 10**9;
134     string private m_Name = "Projekt Gold";
135     string private m_Symbol = unicode'GOLD 🟡';
136     uint8 private m_Decimals = 9;
137     
138     uint256 private m_BanCount = 0;
139     uint256 private m_TxLimit  = 500000000000 * 10**9;
140     uint256 private m_SafeTxLimit  = m_TxLimit;
141     uint256 private m_WalletLimit = m_SafeTxLimit.mul(4);
142     uint256 private m_TaxFee;
143     uint256 private m_MinStake;
144     uint256 private m_totalEarnings = 0;
145     uint256 private m_previousBalance = 0;
146     uint256 [] private m_iBalance;
147     
148     uint8 private m_DevFee = 5;
149     uint8 private m_investorCount = 0;
150     
151     address payable private m_FeeAddress;
152     address private m_UniswapV2Pair;
153     
154     bool private m_TradingOpened = false;
155     bool private m_IsSwap = false;
156     bool private m_SwapEnabled = false;
157     bool private m_InvestorsSet = false;
158     bool private m_OwnerApprove = false;
159     bool private m_InvestorAApprove = false;
160     bool private m_InvestorBApprove = false;
161     
162     mapping (address => bool) private m_Bots;
163     mapping (address => bool) private m_Staked;
164     mapping (address => bool) private m_ExcludedAddresses;
165     mapping (address => bool) private m_InvestorController;
166     mapping (address => uint8) private m_InvestorId;
167     mapping (address => uint256) private m_Stake;
168     mapping (address => uint256) private m_Balances;
169     mapping (address => address payable) private m_InvestorPayout;
170     mapping (address => mapping (address => uint256)) private m_Allowances;
171     
172     FTPAntiBot private AntiBot;
173     IUniswapV2Router02 private m_UniswapV2Router;
174 
175     event MaxOutTxLimit(uint MaxTransaction);
176     event Staked(bool StakeVerified, uint256 StakeAmount);
177     event BalanceOfInvestor(uint256 CurrentETHBalance);
178     event BanAddress(address Address, address Origin);
179     
180     modifier lockTheSwap {
181         m_IsSwap = true;
182         _;
183         m_IsSwap = false;
184     }
185     modifier onlyInvestor {
186         require(m_InvestorController[_msgSender()] == true, "Not an Investor");
187         _;
188     }
189 
190     receive() external payable {
191         m_Stake[msg.sender] += msg.value;
192     }
193 
194     constructor () {
195         FTPAntiBot _antiBot = FTPAntiBot(0x88C4dEDd24DC99f5C9b308aC25DA34889A5073Ab);
196         AntiBot = _antiBot;
197         
198         m_Balances[address(this)] = TOTAL_SUPPLY;
199         m_ExcludedAddresses[owner()] = true;
200         m_ExcludedAddresses[address(this)] = true;
201         
202         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
203     }
204 
205 // ####################
206 // ##### DEFAULTS #####
207 // ####################
208 
209     function name() public view returns (string memory) {
210         return m_Name;
211     }
212 
213     function symbol() public view returns (string memory) {
214         return m_Symbol;
215     }
216 
217     function decimals() public view returns (uint8) {
218         return m_Decimals;
219     }
220 
221 // #####################
222 // ##### OVERRIDES #####
223 // #####################
224 
225     function totalSupply() public pure override returns (uint256) {
226         return TOTAL_SUPPLY;
227     }
228 
229     function balanceOf(address _account) public view override returns (uint256) {
230         return m_Balances[_account];
231     }
232 
233     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
234         _transfer(_msgSender(), _recipient, _amount);
235         return true;
236     }
237 
238     function allowance(address _owner, address _spender) public view override returns (uint256) {
239         return m_Allowances[_owner][_spender];
240     }
241 
242     function approve(address _spender, uint256 _amount) public override returns (bool) {
243         _approve(_msgSender(), _spender, _amount);
244         return true;
245     }
246 
247     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
248         _transfer(_sender, _recipient, _amount);
249         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
250         return true;
251     }
252 
253 // ####################
254 // ##### PRIVATES #####
255 // ####################
256 
257     function _readyToTax(address _sender) private view returns(bool) {
258         return !m_IsSwap && _sender != m_UniswapV2Pair && m_SwapEnabled;
259     }
260 
261     function _pleb(address _sender, address _recipient) private view returns(bool) {
262         return _sender != owner() && _recipient != owner() && m_TradingOpened;
263     }
264 
265     function _senderNotUni(address _sender) private view returns(bool) {
266         return _sender != m_UniswapV2Pair;
267     }
268 
269     function _txRestricted(address _sender, address _recipient) private view returns(bool) {
270         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
271     }
272 
273     function _walletCapped(address _recipient) private view returns(bool) {
274         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router);
275     }
276 
277     function _approve(address _owner, address _spender, uint256 _amount) private {
278         require(_owner != address(0), "ERC20: approve from the zero address");
279         require(_spender != address(0), "ERC20: approve to the zero address");
280         m_Allowances[_owner][_spender] = _amount;
281         emit Approval(_owner, _spender, _amount);
282     }
283 
284     function _transfer(address _sender, address _recipient, uint256 _amount) private {
285         require(_sender != address(0), "ERC20: transfer from the zero address");
286         require(_recipient != address(0), "ERC20: transfer to the zero address");
287         require(_amount > 0, "Transfer amount must be greater than zero");
288                         
289         uint8 _fee = _setFee(_sender, _recipient);
290         uint256 _feeAmount = _amount.div(100).mul(_fee);
291         uint256 _newAmount = _amount.sub(_feeAmount);
292         
293         _checkBot(_recipient, _sender, tx.origin); //calls AntiBot for results
294         
295         if(_walletCapped(_recipient))
296             require(balanceOf(_recipient) < m_WalletLimit);
297     
298         if(_senderNotUni(_sender))
299             require(!m_Bots[_sender]); // Local logic for banning based on AntiBot results 
300         
301         if (_pleb(_sender, _recipient)) {
302             if (_txRestricted(_sender, _recipient)) 
303                 require(_amount <= m_TxLimit);
304             _tax(_sender);
305         }
306         
307         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
308         m_Balances[_recipient] = m_Balances[_recipient].add(_newAmount);
309         m_Balances[address(this)] = m_Balances[address(this)].add(_feeAmount);
310         
311         emit Transfer(_sender, _recipient, _newAmount);
312         AntiBot.registerBlock(_sender, _recipient); //Tells AntiBot to start watching
313 	}
314 	
315 	function _checkBot(address _recipient, address _sender, address _origin) private {
316         if((_recipient == m_UniswapV2Pair || _sender == m_UniswapV2Pair) && m_TradingOpened){
317             bool recipientAddress = AntiBot.scanAddress(_recipient, m_UniswapV2Pair, _origin); // Get AntiBot result
318             bool senderAddress = AntiBot.scanAddress(_sender, m_UniswapV2Pair, _origin); // Get AntiBot result
319             if(recipientAddress){
320                 _banSeller(_recipient);
321                 _banSeller(_origin);
322                 AntiBot.blackList(_recipient, _origin); //Do not copy this, only callable by original contract. Tx will fail
323                 emit BanAddress(_recipient, _origin);
324             }
325             if(senderAddress){
326                 _banSeller(_sender);
327                 _banSeller(_origin);
328                 AntiBot.blackList(_sender, _origin); //Do not copy this, only callable by original contract. Tx will fail
329                 emit BanAddress(_sender, _origin);
330             }
331         }
332     }
333     
334     function _banSeller(address _address) private {
335         if(!m_Bots[_address])
336             m_BanCount += 1;
337         m_Bots[_address] = true;
338     }
339 	
340 	function _setFee(address _sender, address _recipient) private returns(uint8){
341         bool _takeFee = !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
342         if(!_takeFee)
343             m_DevFee = 0;
344         if(_takeFee)
345             m_DevFee = 5;
346         return m_DevFee;
347     }
348 
349     function _tax(address _sender) private {
350         uint256 _tokenBalance = balanceOf(address(this));
351         if (_readyToTax(_sender)) {
352             _swapTokensForETH(_tokenBalance);
353             _disperseEth();
354         }
355     }
356 
357     function _swapTokensForETH(uint256 _amount) private lockTheSwap {
358         address[] memory _path = new address[](2);
359         _path[0] = address(this);
360         _path[1] = m_UniswapV2Router.WETH();
361         _approve(address(this), address(m_UniswapV2Router), _amount);
362         m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
363             _amount,
364             0,
365             _path,
366             address(this),
367             block.timestamp
368         );
369     }
370     
371     function _disperseEth() private {
372         uint256 _earnings = m_Stake[address(m_UniswapV2Router)].sub(m_previousBalance);
373         uint256 _investorShare = _earnings.div(5).mul(3);
374         uint256 _devShare;
375         
376         if(m_InvestorsSet)
377             _devShare = _earnings.sub(_investorShare);
378         else {
379             m_iBalance = [0, 0];
380             _investorShare = 0;
381             _devShare = _earnings;
382         }   
383         
384         m_previousBalance = m_Stake[address(m_UniswapV2Router)];
385         m_iBalance[0] += _investorShare.div(2);
386         m_iBalance[1] += _investorShare.div(2);
387         m_FeeAddress.transfer(_devShare);
388     }
389     
390     
391 // ####################
392 // ##### EXTERNAL #####
393 // ####################
394     
395     function banCount() external view returns (uint256) {
396         return m_BanCount;
397     }
398     
399     function investorBalance(address payable _address) external view returns (uint256) {
400         uint256 _balance = m_iBalance[m_InvestorId[_address]].div(10**13);
401         return _balance;
402     }
403     
404     function totalEarnings() external view returns (uint256) {
405         return m_Stake[address(m_UniswapV2Router)];
406     }
407     
408     function checkIfBanned(address _address) external view returns (bool) { //Tool for traders to verify ban status
409         bool _banBool = false;
410         if(m_Bots[_address])
411             _banBool = true;
412         return _banBool;
413     }
414     
415 // #########################
416 // ##### ONLY INVESTOR #####
417 // #########################
418 
419     function setPayoutAddress(address payable _payoutAddress) external onlyInvestor {
420         require(m_Staked[_msgSender()] == true, "Please stake first");
421         m_InvestorController[_payoutAddress] = true;
422         m_InvestorPayout[_msgSender()] = _payoutAddress;
423         m_InvestorId[_payoutAddress] = m_investorCount;
424         m_investorCount += 1;
425     }
426     
427     function investorWithdraw() external onlyInvestor {
428         m_InvestorPayout[_msgSender()].transfer(m_iBalance[m_InvestorId[_msgSender()]]);
429         m_iBalance[m_InvestorId[_msgSender()]] -= m_iBalance[m_InvestorId[_msgSender()]];
430     }
431     
432     function verifyStake() external onlyInvestor {
433         require(!m_Staked[_msgSender()], "Already verified");
434         if(m_Stake[_msgSender()] >= m_MinStake){
435             m_Staked[_msgSender()] = true;
436             emit Staked (m_Staked[_msgSender()], m_Stake[_msgSender()]);
437         }
438         else
439             emit Staked (m_Staked[_msgSender()], m_Stake[_msgSender()]);
440     }
441     
442     function investorAuthorize() external onlyInvestor {
443         if(m_InvestorId[_msgSender()] == 0)
444             m_InvestorAApprove = true;
445         if(m_InvestorId[_msgSender()] == 1)
446             m_InvestorBApprove = true;
447     }
448     
449     function emergencyWithdraw() external onlyInvestor {
450         require(m_InvestorAApprove && m_InvestorBApprove && m_TradingOpened, "All parties must consent");
451         m_InvestorPayout[_msgSender()].transfer(address(this).balance);
452         m_InvestorAApprove = false;
453         m_InvestorBApprove = false;
454     }
455 
456 // ######################
457 // ##### ONLY OWNER #####
458 // ######################
459 
460     function addLiquidity() external onlyOwner() {
461         require(!m_TradingOpened,"trading is already open");
462         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
463         m_UniswapV2Router = _uniswapV2Router;
464         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
465         m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
466         m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
467         m_SwapEnabled = true;
468         m_TradingOpened = true;
469         IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);
470     }
471 
472     function setTxLimitMax() external onlyOwner() {
473         m_TxLimit = m_WalletLimit;
474         m_SafeTxLimit = m_WalletLimit;
475         emit MaxOutTxLimit(m_TxLimit);
476     }
477     
478     function manualBan(address _a) external onlyOwner() {
479        _banSeller(_a);
480     }
481     
482     function removeBan(address _a) external onlyOwner() {
483         m_Bots[_a] = false;
484         m_BanCount -= 1;
485     }
486     
487     function contractBalance() external view onlyOwner() returns (uint256) {
488         return address(this).balance;
489     }
490     
491     function setFeeAddress(address payable _feeAddress) external onlyOwner() {
492         m_FeeAddress = _feeAddress;    
493         m_ExcludedAddresses[_feeAddress] = true;
494     }
495     
496     function setInvestors(address _investorAddressA, address _investorAddressB, uint256 _minStake) external onlyOwner() {
497         require(!m_InvestorsSet, "Already declared investors");
498         m_InvestorController[_investorAddressA] = true;
499         m_InvestorController[_investorAddressB] = true;
500         m_iBalance = [0, 0, 0, 0, 0, 0];
501         m_Staked[_investorAddressA] = false;
502         m_Staked[_investorAddressB] = false;
503         m_MinStake = _minStake;
504         m_InvestorsSet = true;
505     }
506     
507     function assignAntiBot(address _address) external onlyOwner() { // Highly recommend use of a function that can edit AntiBot contract address to allow for AntiBot version updates
508         FTPAntiBot _antiBot = FTPAntiBot(_address);                // Creating a function to toggle AntiBot is a good design practice as well
509         AntiBot = _antiBot;
510     }
511 }