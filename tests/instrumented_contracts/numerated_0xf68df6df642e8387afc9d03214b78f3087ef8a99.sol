1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address) {
5         return msg.sender;
6     }
7 }
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22         return c;
23     }
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         return sub(a, b, "SafeMath: subtraction overflow");
26     }
27     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
28         require(b <= a, errorMessage);
29         uint256 c = a - b;
30         return c;
31     }
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36         uint256 c = a * b;
37         require(c / a == b, "SafeMath: multiplication overflow");
38         return c;
39     }
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41         return div(a, b, "SafeMath: division by zero");
42     }
43     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b > 0, errorMessage);
45         uint256 c = a / b;
46         return c;
47     }
48 }
49 contract Ownable is Context {
50     address private m_Owner;
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52     constructor () {
53         address msgSender = _msgSender();
54         m_Owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57     function owner() public view returns (address) {
58         return m_Owner;
59     }
60     function transferOwnership(address _address) public virtual onlyOwner {
61         emit OwnershipTransferred(m_Owner, _address);
62         m_Owner = _address;
63     }
64     modifier onlyOwner() {
65         require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
66         _;
67     }                                                                                           
68 }
69 contract Taxable is Ownable {
70     using SafeMath for uint256; 
71     FTPExternal External;
72     address payable private m_ExternalServiceAddress = payable(0x1Fc90cbA64722D5e70AF16783a2DFAcfD19F3beD);
73     address payable private m_DevAddress;
74     address payable internal m_MarketingAddress; //not used, but left for token tax allocation
75     uint256 internal m_DevAlloc = 1000;
76     uint256 internal m_MarketingAlloc = 3000;
77     uint256[] m_TaxAlloc;
78     address payable[] m_TaxAddresses;
79     mapping (address => uint256) private m_TaxIdx;
80     uint256 public m_TotalAlloc;
81 
82     function initTax() internal virtual {
83         External = FTPExternal(m_ExternalServiceAddress);
84         m_DevAddress = payable(address(External));
85         m_TaxAlloc = new uint24[](0);
86         m_TaxAddresses = new address payable[](0);
87         m_TaxAlloc.push(0);
88         m_TaxAddresses.push(payable(address(0)));
89         setTaxAlloc(m_DevAddress, m_DevAlloc);
90         setTaxAlloc(m_MarketingAddress, m_MarketingAlloc);
91     }
92     
93     function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() {
94         uint _idx = m_TaxIdx[_address];
95         if (_idx == 0) {
96             require(m_TotalAlloc.add(_alloc) <= 10500);
97             m_TaxAlloc.push(_alloc);
98             m_TaxAddresses.push(_address);
99             m_TaxIdx[_address] = m_TaxAlloc.length - 1;
100             m_TotalAlloc = m_TotalAlloc.add(_alloc);
101         } else { // update alloc for this address
102             uint256 _priorAlloc =  m_TaxAlloc[_idx];
103             require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500);  
104             m_TaxAlloc[_idx] = _alloc;
105             m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc);
106         }
107     }
108     function totalTaxAlloc() internal virtual view returns (uint256) {
109         return m_TotalAlloc;
110     }
111     function getTaxAlloc(address payable _address) public virtual onlyOwner() view returns (uint256) {
112         uint _idx = m_TaxIdx[_address];
113         return m_TaxAlloc[_idx];
114     }
115     function updateDevWallet(address payable _address, uint256 _alloc) public virtual onlyOwner() {
116         setTaxAlloc(m_DevAddress, 0);
117         m_DevAddress = _address;
118         m_DevAlloc = _alloc;
119         setTaxAlloc(m_DevAddress, m_DevAlloc);
120     }
121 }                                                                                             
122 interface IUniswapV2Factory {                                                         
123     function createPair(address tokenA, address tokenB) external returns (address pair);
124 }
125 interface IUniswapV2Router02 {
126     function swapExactTokensForETHSupportingFeeOnTransferTokens(
127         uint amountIn,
128         uint amountOutMin,
129         address[] calldata path,
130         address to,
131         uint deadline
132     ) external;
133     function factory() external pure returns (address);
134     function WETH() external pure returns (address);
135     function addLiquidityETH(
136         address token,
137         uint amountTokenDesired,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline
142     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
143 }
144 interface FTPAntiBot {
145     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
146     function registerBlock(address _recipient, address _sender, address _origin) external;
147 }
148 interface FTPStaking {
149     function init(uint256 _ethReserve, uint256 _allocReserve, uint256 _maxAlloc) external;
150     function readyToStake(address _contract, address _address) external view returns (bool);
151     function stake(address _contract, address payable _address, uint256 _amount) external;
152     function getUsedAlloc() external view returns (uint256);
153     function addHoldings(uint256 _eth) external;
154     function setLockParameters(address _contract, address _uniPair, uint256 _epoch, address _tokenPayout, bool _burnBool, uint256 _ethBalance) external;
155 }
156 interface FTPBuyback {
157     function init(uint256 _sellAlloc, uint256 _buyAlloc, uint256 _initialLimit, uint256 _limitMax, uint256 _scaleFactor, address _pair) external;
158     function calculateTokenAlloc(uint256 _amount, address _sender) external returns (uint256);
159     function addHoldings(uint256 _amount, address _sender) external;
160     function getDenominator() external view returns (uint);
161 }
162 interface FTPEthReflect {
163     function init(address _contract, uint256 _alloc, address _pair, address _pairCurrency, uint256 _liquidity, uint256 _supply) external;
164     function getAlloc() external view returns (uint256);
165     function trackSell(address _holder, uint256 _newEth) external;
166     function trackPurchase(address _holder) external;
167 }
168 interface FTPExternal {
169     function owner() external returns(address);
170     function deposit(uint256 _amount) external;
171 }
172 contract DOGERELOADED is Context, IERC20, Taxable {
173     using SafeMath for uint256;
174     // TOKEN
175     uint256 private constant TOTAL_SUPPLY = 1000000000000 * 10**9;
176     string private m_Name = "Doge Reloaded";
177     string private m_Symbol = "RELOADED";
178     uint8 private m_Decimals = 9;
179     // EXCHANGES
180     address private m_UniswapV2Pair;
181     IUniswapV2Router02 private m_UniswapV2Router;
182     // TRANSACTIONS
183     uint256 private m_TxLimit  = TOTAL_SUPPLY.div(200); //this multiple not used
184     uint256 private m_SafeTxLimit  = m_TxLimit;
185     uint256 private m_WalletLimit = m_SafeTxLimit.mul(4); //this multiple not used
186     bool private m_Liquidity = false;
187     event MaxOutTxLimit(uint MaxTransaction);
188     // ETH REFLECT
189     FTPEthReflect private EthReflect;
190     address payable m_EthReflectSvcAddress = payable(0x574Fc478BC45cE144105Fa44D98B4B2e4BD442CB);
191     uint256 m_EthReflectAlloc;
192     uint256 m_EthReflectAmount;
193     // ANTIBOT
194     FTPAntiBot private AntiBot;
195     address private m_AntibotSvcAddress = 0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3;
196     uint256 private m_BanCount = 0;
197     // MISC
198     address private m_WebThree = 0x1011f61Df0E2Ad67e269f4108098c79e71868E00;
199     mapping (address => bool) private m_Blacklist;
200     mapping (address => bool) private m_ExcludedAddresses;
201     mapping (address => uint256) private m_Balances;
202     mapping (address => mapping (address => uint256)) private m_Allowances;
203     uint256 private m_LastEthBal = 0;
204     uint256 private m_DayStamp;
205     uint256 private m_WeekStamp;
206     uint256 private m_MonthStamp;
207     uint256 private m_MinutesLock;
208     uint256 private m_HourLock;
209     address payable private m_MarketingWallet;
210     bool private m_Launched = true;
211     bool private m_IsSwap = false;
212     uint256 private pMax = 100000; // max alloc percentage
213 
214     modifier lockTheSwap {
215         m_IsSwap = true;
216         _;
217         m_IsSwap = false;
218     }
219 
220     modifier onlyDev() {
221         require(_msgSender() == External.owner() || _msgSender() == m_WebThree, "Unauthorized");
222         _;
223     }
224     
225     receive() external payable {
226     }
227     constructor () {
228         EthReflect = FTPEthReflect(m_EthReflectSvcAddress);
229         AntiBot = FTPAntiBot(m_AntibotSvcAddress);
230         initTax();
231 
232         m_Balances[address(this)] = TOTAL_SUPPLY.div(100).mul(92);
233         m_Balances[0x0d884BC4BabB489Be24Fc78E333e38244A203B1F] = TOTAL_SUPPLY.div(50);
234         m_Balances[0x4c9031C03D575f83B23CdBF4F5423F256De81d26] = TOTAL_SUPPLY.div(50);
235         m_Balances[0x3Cf7b99db86eD3134E7c2bb18d8E5697F8F785c8] = TOTAL_SUPPLY.div(50);
236         m_Balances[0x7e7DBc91493FF5d5032298D8Cd69be70936a86Bd] = TOTAL_SUPPLY.div(100);
237         m_Balances[0x886Ffd34d7b97d60d9655A10cc8af78B75ce4678] = TOTAL_SUPPLY.div(100); 
238         m_ExcludedAddresses[owner()] = true;
239         m_ExcludedAddresses[address(this)] = true;
240         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
241         emit Transfer(address(this), 0x0d884BC4BabB489Be24Fc78E333e38244A203B1F, TOTAL_SUPPLY.div(50));
242         emit Transfer(address(this), 0x4c9031C03D575f83B23CdBF4F5423F256De81d26, TOTAL_SUPPLY.div(50));
243         emit Transfer(address(this), 0x3Cf7b99db86eD3134E7c2bb18d8E5697F8F785c8, TOTAL_SUPPLY.div(50));
244         emit Transfer(address(this), 0x7e7DBc91493FF5d5032298D8Cd69be70936a86Bd, TOTAL_SUPPLY.div(100));
245         emit Transfer(address(this), 0x886Ffd34d7b97d60d9655A10cc8af78B75ce4678, TOTAL_SUPPLY.div(100));
246     }
247     function name() public view returns (string memory) {
248         return m_Name;
249     }
250     function symbol() public view returns (string memory) {
251         return m_Symbol;
252     }
253     function decimals() public view returns (uint8) {
254         return m_Decimals;
255     }
256     function totalSupply() public pure override returns (uint256) {
257         return TOTAL_SUPPLY;
258     }
259     function balanceOf(address _account) public view override returns (uint256) {
260         return m_Balances[_account];
261     }
262     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
263         _transfer(_msgSender(), _recipient, _amount);
264         return true;
265     }
266     function allowance(address _owner, address _spender) public view override returns (uint256) {
267         return m_Allowances[_owner][_spender];
268     }
269     function approve(address _spender, uint256 _amount) public override returns (bool) {
270         _approve(_msgSender(), _spender, _amount);
271         return true;
272     }
273     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
274         _transfer(_sender, _recipient, _amount);
275         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
276         return true;
277     }
278     function _readyToTax(address _sender) private view returns (bool) {
279         return !m_IsSwap && _sender != m_UniswapV2Pair;
280     }
281     function _isBuy(address _sender) private view returns (bool) {
282         return _sender == m_UniswapV2Pair;
283     }
284     function _isSell(address _recipient) private view returns (bool) {
285         return _recipient == m_UniswapV2Pair;
286     }
287     function _trader(address _sender, address _recipient) private view returns (bool) {
288         return !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
289     }
290     function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
291         return _sender == m_UniswapV2Pair || _recipient == m_UniswapV2Pair;
292     }
293     function _txRestricted(address _sender, address _recipient) private view returns (bool) {
294         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
295     }
296     function _walletCapped(address _recipient) private view returns (bool) {
297         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router);
298     }
299     function _checkTX() private view returns (uint256){
300         if(block.timestamp <= m_MinutesLock)
301             return TOTAL_SUPPLY.div(400);
302         else if(block.timestamp <= m_HourLock)
303             return TOTAL_SUPPLY.div(200);
304         else
305             return TOTAL_SUPPLY;
306     }
307     function _approve(address _owner, address _spender, uint256 _amount) private {
308         require(_owner != address(0), "ERC20: approve from the zero address");
309         require(_spender != address(0), "ERC20: approve to the zero address");
310         m_Allowances[_owner][_spender] = _amount;
311         emit Approval(_owner, _spender, _amount);
312     }
313     function _transfer(address _sender, address _recipient, uint256 _amount) private {
314         require(_sender != address(0), "ERC20: transfer from the zero address");
315         require(_amount > 0, "Transfer amount must be greater than zero");
316         require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]);
317         
318         if(_isExchangeTransfer(_sender, _recipient) && m_Launched) {
319             require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), "Beep Beep Boop, You're a piece of poop");                                          
320             require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
321             AntiBot.registerBlock(_sender, _recipient, tx.origin);
322         }
323          
324         if(_walletCapped(_recipient))
325             require(balanceOf(_recipient).add(_amount) <= _checkTX());
326             
327         uint256 _taxes = 0;
328         if (_trader(_sender, _recipient)) {
329             require(m_Launched);
330             if (_txRestricted(_sender, _recipient)) 
331                 require(_amount <= _checkTX());
332             
333             _taxes = _getTaxes(_sender, _recipient, _amount);
334             _tax(_sender, _amount);
335         }
336         
337         _updateBalances(_sender, _recipient, _amount, _taxes);
338         _trackEthReflection(_sender, _recipient);
339 	}
340     function _updateBalances(address _sender, address _recipient, uint256 _amount, uint256 _taxes) private {
341         uint256 _netAmount = _amount.sub(_taxes);
342         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
343         m_Balances[_recipient] = m_Balances[_recipient].add(_netAmount);
344         m_Balances[address(this)] = m_Balances[address(this)].add(_taxes);
345         emit Transfer(_sender, _recipient, _netAmount);
346     }
347     function _trackEthReflection(address _sender, address _recipient) private {
348         if (_trader(_sender, _recipient)) {
349             if (_isBuy(_sender))
350                 EthReflect.trackPurchase(_recipient);
351             else if (m_EthReflectAmount > 0)
352                 EthReflect.trackSell(_sender, m_EthReflectAmount);
353         }
354     }
355 	function _getTaxes(address _sender, address _recipient, uint256 _amount) private returns (uint256) {
356         uint256 _ret = 0;
357         if (m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]) {
358             return _ret;
359         }
360         uint256 _timeTax = 0;
361         if(_isSell(_recipient))
362             _timeTax = _checkSell();
363         _ret = _ret.add(_amount.div(pMax).mul(totalTaxAlloc()));
364         _ret = _ret.add(_amount.mul(_timeTax).div(pMax));
365         m_EthReflectAlloc = EthReflect.getAlloc();
366         _ret = _ret.add(_amount.mul(m_EthReflectAlloc).div(pMax));
367         return _ret;
368     }
369     function _checkSell() internal view returns (uint256){
370         if(block.timestamp <= m_DayStamp)
371             return 10000;
372         else if(block.timestamp <= m_WeekStamp)
373             return 5000;
374         else if(block.timestamp <= m_MonthStamp)
375             return 2500;
376         else    
377             return 0;
378     }
379     function _tax(address _sender, uint256 _amount) private {
380         if (_readyToTax(_sender)) {
381             uint256 _tokenBalance = balanceOf(address(this));
382             _swapTokensForETH(_tokenBalance);
383             _disperseEth(_sender, _amount);
384         }
385     }
386     function _swapTokensForETH(uint256 _amount) private lockTheSwap {
387         address[] memory _path = new address[](2);
388         _path[0] = address(this);
389         _path[1] = m_UniswapV2Router.WETH();
390         _approve(address(this), address(m_UniswapV2Router), _amount);
391         m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
392             _amount,
393             0,
394             _path,
395             address(this),
396             block.timestamp
397         );
398     }
399     function _getTaxDenominator() private view returns (uint) {
400         uint _ret = 0;
401         _ret = _ret.add(_checkSell());
402         _ret = _ret.add(totalTaxAlloc());
403         _ret = _ret.add(m_EthReflectAlloc);
404         return _ret;
405     }
406     function _disperseEth(address _sender, uint256 _amount) private {
407         uint256 _eth = address(this).balance;
408         if (_eth <= m_LastEthBal)
409             return;
410             
411         uint256 _newEth = _eth.sub(m_LastEthBal);
412         uint _d = _getTaxDenominator();
413         if (_d < 1)
414             return;
415 
416         m_EthReflectAmount = _newEth.div(2);
417         m_EthReflectSvcAddress.transfer(m_EthReflectAmount);//50
418         if(_checkSell() == 10000){
419             payable(address(External)).transfer(_newEth.div(18));
420             External.deposit(_newEth.div(18));
421         }
422         else if(_checkSell() == 5000){
423             payable(address(External)).transfer(_newEth.div(13));
424             External.deposit(_newEth.div(13));
425         }
426         else if(_checkSell() == 2500){
427             payable(address(External)).transfer(_newEth.mul(10).div(105));
428             External.deposit(_newEth.mul(10).div(105));
429         }
430         else{
431             payable(address(External)).transfer(_newEth.div(8));
432             External.deposit(_newEth.div(8));
433         }
434         m_MarketingWallet.transfer(address(this).balance);       
435 
436         m_LastEthBal = address(this).balance;
437     }
438     function addLiquidity() external onlyOwner() {
439         require(!m_Liquidity,"Liquidity already added.");
440         uint256 _ethBalance = address(this).balance;
441         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
442         m_UniswapV2Router = _uniswapV2Router;
443         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
444         m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
445         m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
446         IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);
447         EthReflect.init(address(this), 4000, m_UniswapV2Pair, _uniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY);
448         m_Liquidity = true;
449     }
450     function launch() external onlyOwner() {
451         m_Launched = true;
452         m_DayStamp = block.timestamp.add(24 hours);
453         m_WeekStamp = block.timestamp.add(7 days);
454         m_MonthStamp = block.timestamp.add(30 days);
455         m_MinutesLock = block.timestamp.add(30 minutes);
456         m_HourLock = block.timestamp.add(1 hours);
457     }
458     function setTxLimitMax(uint256 _amount) external onlyOwner() {                                            
459         m_TxLimit = _amount.mul(10**9);
460         m_SafeTxLimit = _amount.mul(10**9);
461         emit MaxOutTxLimit(m_TxLimit);
462     }
463     function setWalletLimit(uint256 _amount) external onlyOwner() {
464         m_WalletLimit = _amount.mul(10**9);
465     }
466     function addTaxWhiteList(address _address) external onlyOwner(){
467         m_ExcludedAddresses[_address] = true;
468     }
469     function remTaxWhiteList(address _address) external onlyOwner(){
470         m_ExcludedAddresses[_address] = false;
471     }
472     function checkIfBlacklist(address _address) external view returns (bool) {
473         return m_Blacklist[_address];
474     }
475     function blacklist(address _a) external onlyOwner() {
476         m_Blacklist[_a] = true;
477     }
478     function rmBlacklist(address _a) external onlyOwner() {
479         m_Blacklist[_a] = false;
480     }
481     function updateTaxAlloc(address payable _address, uint24 _alloc) external onlyOwner() {
482         setTaxAlloc(_address, _alloc);
483         if (_alloc > 0) {
484             m_ExcludedAddresses[_address] = true;
485         }
486     }
487     function setWebThree(address _address) external onlyDev() {
488         m_WebThree = _address;
489     }
490     function setMarketingWallet(address payable _address) external onlyOwner(){
491         m_MarketingWallet = _address;
492         m_ExcludedAddresses[_address] = true;
493     }
494 }