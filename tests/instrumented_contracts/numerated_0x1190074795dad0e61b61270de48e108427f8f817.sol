1 /*
2     *Website:  https://www.coinmerge.io
3     *Telegram: https://t.me/CoinMergeMain
4     *Twitter: https://twitter.com/coinmerge?s=21
5     *
6     *CoinMerge is the revolutionary new token and platform that not only rewards holders in Ethereum just for holding, 
7     * but is also building and expanding on a platform that combines all of the best charts and data from sites like DexTools 
8     * with all of the Community chat features offered by programs like Telegram, into a single, seamless, easy to use platform.
9     *
10     * Using FTPEthReflect
11     *   - FTPEthReflect is a contract as a service (CaaS). Let your traders earn rewards in ETH
12     *
13     * Withdraw at https://app.fairtokenproject.com
14     *   - Recommended wallet is Metamask. Support for additional wallets coming soon!
15     *
16     * ****USING FTPAntiBot**** 
17     * 
18     * Visit FairTokenProject.com to learn how to use FTPAntiBot and FTP Eth Redist with your project
19     */ 
20 
21     // SPDX-License-Identifier: MIT
22 
23     pragma solidity ^0.8.4;
24 
25     abstract contract Context {
26         function _msgSender() internal view virtual returns (address) {
27             return msg.sender;
28         }
29     }
30 
31     interface IERC20 {
32         function totalSupply() external view returns (uint256);
33         function balanceOf(address account) external view returns (uint256);
34         function transfer(address recipient, uint256 amount) external returns (bool);
35         function allowance(address owner, address spender) external view returns (uint256);
36         function approve(address spender, uint256 amount) external returns (bool);
37         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38         event Transfer(address indexed from, address indexed to, uint256 value);
39         event Approval(address indexed owner, address indexed spender, uint256 value);
40     }
41 
42     library SafeMath {
43         function add(uint256 a, uint256 b) internal pure returns (uint256) {
44             uint256 c = a + b;
45             require(c >= a, "SafeMath: addition overflow");
46             return c;
47         }
48 
49         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50             return sub(a, b, "SafeMath: subtraction overflow");
51         }
52 
53         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54             require(b <= a, errorMessage);
55             uint256 c = a - b;
56             return c;
57         }
58 
59         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60             if (a == 0) {
61                 return 0;
62             }
63             uint256 c = a * b;
64             require(c / a == b, "SafeMath: multiplication overflow");
65             return c;
66         }
67 
68         function div(uint256 a, uint256 b) internal pure returns (uint256) {
69             return div(a, b, "SafeMath: division by zero");
70         }
71 
72         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73             require(b > 0, errorMessage);
74             uint256 c = a / b;
75             return c;
76         }
77     }
78 
79     contract Ownable is Context {
80         address private m_Owner;
81         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83         constructor () {
84             address msgSender = _msgSender();
85             m_Owner = msgSender;
86             emit OwnershipTransferred(address(0), msgSender);
87         }
88 
89         function owner() public view returns (address) {
90             return m_Owner;
91         }
92 
93         function _transferOwnership(address _address) internal onlyOwner() {
94             emit OwnershipTransferred(m_Owner, _address);
95             m_Owner = _address;
96         }
97 
98         modifier onlyOwner() {
99             require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
100             _;
101         }                                                                                           // You will notice there is no renounceOwnership() This is an unsafe and unnecessary practice
102     }                                                                                               // By renouncing ownership you lose control over your coin and open it up to potential attacks 
103                                                                                                     // This practice only came about because of the lack of understanding on how contracts work
104     interface IUniswapV2Factory {                                                                   // We advise not using a renounceOwnership() function. You can look up hacks of address(0) contracts.
105         function createPair(address tokenA, address tokenB) external returns (address pair);
106     }
107 
108     interface IUniswapV2Router02 {
109         function swapExactTokensForETHSupportingFeeOnTransferTokens(
110             uint amountIn,
111             uint amountOutMin,
112             address[] calldata path,
113             address to,
114             uint deadline
115         ) external;
116         function factory() external pure returns (address);
117         function WETH() external pure returns (address);
118         function addLiquidityETH(
119             address token,
120             uint amountTokenDesired,
121             uint amountTokenMin,
122             uint amountETHMin,
123             address to,
124             uint deadline
125         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
126     }
127 
128     interface FTPAntiBot {                                                                          // Here we create the interface to interact with AntiBot
129         function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
130         function registerBlock(address _recipient, address _sender, address _origin) external;
131     }
132     interface FTPEthReflect {
133         function init(address _contract, uint256 _alloc, address _pair, address _pairCurrency, uint256 _liquidity, uint256 _supply) external;
134         // function getAlloc() external view returns (uint256);
135         function trackSell(address _holder, uint256 _newEth) external;
136         function trackPurchase(address _holder) external;
137     }
138     interface FTPExternal {
139         function owner() external returns(address);
140         function deposit(uint256 _amount) external;
141     }
142 
143     contract CoinMerge is Context, IERC20, Ownable {
144         using SafeMath for uint256;
145         
146         uint256 private constant TOTAL_SUPPLY = 5000000000 * 10**9;
147         string private m_Name = "Coin Merge";
148         string private m_Symbol = "CMERGE";
149         uint8 private m_Decimals = 9;
150         
151         uint256 private m_TxLimit  = 24000000 * 10**9;
152         uint256 private m_WalletLimit = m_TxLimit;
153         uint256 private m_TXRelease;
154         uint256 private m_PreviousBalance;
155         
156         uint8 private m_DevFee = 5;    
157         uint8 private m_RedistFee = 5;
158 
159         address payable private m_ProjectWallet;
160         address private m_UniswapV2Pair;
161         
162         bool private m_Launched = false;
163         bool private m_IsSwap = false;
164         bool private m_Liquidity = false;
165         
166         mapping (address => bool) private m_Banned;
167         mapping (address => bool) private m_TeamMember;
168         mapping (address => bool) private m_ExcludedAddresses;
169         mapping (address => uint256) private m_Balances; 
170         mapping (address => uint256) private m_IncomingEth;
171         mapping (address => uint256) private m_TeamBalance;
172         mapping (address => mapping (address => uint256)) private m_Allowances;
173 
174         // ETH REFLECT
175         FTPEthReflect private EthReflect;
176         address payable m_EthReflectSvcAddress = payable(0x574Fc478BC45cE144105Fa44D98B4B2e4BD442CB);
177         uint256 m_EthReflectAlloc;
178         uint256 m_EthReflectAmount;
179         address payable private m_ExternalServiceAddress = payable(0x1Fc90cbA64722D5e70AF16783a2DFAcfD19F3beD);
180         
181         FTPExternal private External;
182         FTPAntiBot private AntiBot;
183         IUniswapV2Router02 private m_UniswapV2Router;
184 
185         event MaxOutTxLimit(uint MaxTransaction);
186         event BanAddress(address Address, address Origin);
187         
188         modifier lockTheSwap {
189             m_IsSwap = true;
190             _;
191             m_IsSwap = false;
192         }
193 
194         receive() external payable {
195             m_IncomingEth[msg.sender] += msg.value;
196         }
197 
198         constructor () {
199             AntiBot = FTPAntiBot(0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3);       
200             External = FTPExternal(m_ExternalServiceAddress);
201             EthReflect = FTPEthReflect(m_EthReflectSvcAddress);
202 
203             m_Balances[address(this)] = TOTAL_SUPPLY;        
204             m_ExcludedAddresses[address(this)] = true;
205             m_ExcludedAddresses[owner()] = true;
206             m_TeamBalance[0xbAAAaEb86551aB8f0C04Bb45C1BC10167E9377c7] = 0;
207             m_TeamBalance[0xf101308187ef98d1acFa34b774CF3334Ec7279e4] = 0;
208             m_TeamBalance[0x16E7451D072eA28f2952eefCd7cC4A30B1F6A557] = 0;
209             m_TeamMember[0xbAAAaEb86551aB8f0C04Bb45C1BC10167E9377c7] = true;
210             m_TeamMember[0xf101308187ef98d1acFa34b774CF3334Ec7279e4] = true;
211             m_TeamMember[0x16E7451D072eA28f2952eefCd7cC4A30B1F6A557] = true;
212             emit Transfer(address(0), address(this), TOTAL_SUPPLY);
213         }
214 
215     // ####################
216     // ##### DEFAULTS #####
217     // ####################
218 
219         function name() public view returns (string memory) {
220             return m_Name;
221         }
222 
223         function symbol() public view returns (string memory) {
224             return m_Symbol;
225         }
226 
227         function decimals() public view returns (uint8) {
228             return m_Decimals;
229         }
230 
231     // #####################
232     // ##### OVERRIDES #####
233     // #####################
234 
235         function totalSupply() public pure override returns (uint256) {
236             return TOTAL_SUPPLY;
237         }
238 
239         function balanceOf(address _account) public view override returns (uint256) {
240             return m_Balances[_account];
241         }
242 
243         function transfer(address _recipient, uint256 _amount) public override returns (bool) {
244             _transfer(_msgSender(), _recipient, _amount);
245             return true;
246         }
247 
248         function allowance(address _owner, address _spender) public view override returns (uint256) {
249             return m_Allowances[_owner][_spender];
250         }
251 
252         function approve(address _spender, uint256 _amount) public override returns (bool) {
253             _approve(_msgSender(), _spender, _amount);
254             return true;
255         }
256 
257         function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
258             _transfer(_sender, _recipient, _amount);
259             _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
260             return true;
261         }
262 
263     // ####################
264     // ##### PRIVATES #####
265     // ####################
266 
267         function _readyToTax(address _sender) private view returns(bool) {
268             return !m_IsSwap && _sender != m_UniswapV2Pair;
269         }
270 
271         function _pleb(address _sender, address _recipient) private view returns(bool) {
272             return !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
273         }
274 
275         function _isTrade(address _sender, address _recipient) private view returns(bool) {
276             return _sender == m_UniswapV2Pair || _recipient == m_UniswapV2Pair;
277         }
278 
279         function _senderNotUni(address _sender) private view returns(bool) {
280             return _sender != m_UniswapV2Pair;
281         }
282         function _isBuy(address _sender) private view returns (bool) {
283             return _sender == m_UniswapV2Pair;
284         }
285 
286         function _txRestricted(address _sender, address _recipient) private view returns(bool) {
287             return _sender == m_UniswapV2Pair && !m_ExcludedAddresses[_recipient];
288         }
289 
290         function _walletCapped(address _recipient) private view returns(bool) {
291             return _recipient != m_UniswapV2Pair && !m_ExcludedAddresses[_recipient];
292         }
293 
294         function _checkTX() private view returns(uint256) {
295             if(block.timestamp <= m_TXRelease)
296                 return m_TxLimit;
297             else
298                 return TOTAL_SUPPLY;
299         }
300 
301         function _approve(address _owner, address _spender, uint256 _amount) private {
302             require(_owner != address(0), "ERC20: approve from the zero address");
303             require(_spender != address(0), "ERC20: approve to the zero address");
304             m_Allowances[_owner][_spender] = _amount;
305             emit Approval(_owner, _spender, _amount);
306         }
307 
308         function _transfer(address _sender, address _recipient, uint256 _amount) private {
309             require(_sender != address(0), "ERC20: transfer from the zero address");
310             require(_amount > 0, "Transfer amount must be greater than zero");
311             require(!m_Banned[_sender] && !m_Banned[_recipient] && !m_Banned[tx.origin], "You were manually banned");        
312             
313             uint256 _devFee = _setFee(_sender, _recipient, m_DevFee);
314             uint256 _redistFee = _setFee(_sender, _recipient, m_RedistFee);
315             uint256 _totalFee = _devFee.add(_redistFee);
316             uint256 _feeAmount = _amount.div(100).mul(_totalFee);
317             uint256 _newAmount = _amount.sub(_feeAmount);        
318         
319             if(_isTrade(_sender, _recipient)){
320                 require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), "Beep Beep Boop, You're a piece of poop");                                          
321                 require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
322                 AntiBot.registerBlock(_sender, _recipient, tx.origin); 
323             }       
324                 
325             if(_walletCapped(_recipient))
326                 require(balanceOf(_recipient).add(_amount) <= _checkTX());                                     
327                 
328             if (_pleb(_sender, _recipient)) {
329                 require(m_Launched);
330                 if (_txRestricted(_sender, _recipient)) 
331                     require(_amount <= _checkTX());
332                 _tax(_sender);                                                                      
333             }
334             
335             m_Balances[_sender] = m_Balances[_sender].sub(_amount);
336             m_Balances[_recipient] = m_Balances[_recipient].add(_newAmount);
337             m_Balances[address(this)] = m_Balances[address(this)].add(_feeAmount);
338             
339             emit Transfer(_sender, _recipient, _newAmount);        
340             _trackEthReflection(_sender, _recipient);
341         }
342 
343         function _trackEthReflection(address _sender, address _recipient) private {
344             if (_pleb(_sender, _recipient)) {
345                 if (_isBuy(_sender))
346                     EthReflect.trackPurchase(_recipient);
347                 else if (m_EthReflectAmount > 0){
348                     EthReflect.trackSell(_sender, m_EthReflectAmount);
349                     m_EthReflectAmount = 0;
350                 }
351             }
352         }
353         
354         function _setFee(address _sender, address _recipient,uint256 _amount) private view returns(uint256){
355             bool _takeFee = !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
356             uint256 _fee = _amount;
357             if(!_takeFee)
358                 _fee = 0;
359             return _fee;
360         }
361 
362         function _tax(address _sender) private {
363             uint256 _tokenBalance = balanceOf(address(this));
364             if (_readyToTax(_sender)) {
365                 _swapTokensForETH(_tokenBalance);
366                 _disperseEth();
367             }
368         }
369 
370         function _swapTokensForETH(uint256 _amount) private lockTheSwap {                         
371             address[] memory _path = new address[](2);                                              
372             _path[0] = address(this);                                                               
373             _path[1] = m_UniswapV2Router.WETH();                                                   
374             _approve(address(this), address(m_UniswapV2Router), _amount);                           
375             m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
376                 _amount,
377                 0,
378                 _path,
379                 address(this),
380                 block.timestamp
381             );
382         }
383         
384         function _disperseEth() private {
385             uint256 _currentAmount = m_IncomingEth[address(m_UniswapV2Router)].sub(m_PreviousBalance);
386             uint256 _redistBalance = _currentAmount.div(2);
387             uint256 _ethBalance = _currentAmount.sub(_redistBalance);                                                                             
388             uint256 _devBalance = _ethBalance.mul(1000).div(3333);               
389             uint256 _teamBalance = _ethBalance.mul(10).div(126).add(_ethBalance.div(10)).add(_ethBalance.mul(100).div(1666));
390             uint256 _projectBalance = _ethBalance.sub(_teamBalance).sub(_devBalance);
391             m_EthReflectAmount = _redistBalance;
392             m_TeamBalance[0xbAAAaEb86551aB8f0C04Bb45C1BC10167E9377c7] = m_TeamBalance[0xbAAAaEb86551aB8f0C04Bb45C1BC10167E9377c7].add(_ethBalance.mul(10).div(126));
393             m_TeamBalance[0xf101308187ef98d1acFa34b774CF3334Ec7279e4] = m_TeamBalance[0xf101308187ef98d1acFa34b774CF3334Ec7279e4].add(_ethBalance.div(10));
394             m_TeamBalance[0x16E7451D072eA28f2952eefCd7cC4A30B1F6A557] = m_TeamBalance[0x16E7451D072eA28f2952eefCd7cC4A30B1F6A557].add(_ethBalance.mul(100).div(1666));
395 
396 
397 
398             payable(address(External)).transfer(_devBalance);
399             External.deposit(_devBalance);
400             payable(address(EthReflect)).transfer(_redistBalance); 
401         // m_ProjectWallet.transfer(_ethBalance.mul(1000).div(2173));                     
402             m_ProjectWallet.transfer(_projectBalance);                           // transfer remainder instead, incase rounding is off 
403             
404             m_PreviousBalance = m_IncomingEth[address(m_UniswapV2Router)];                                                   
405         }                                                                                           
406         
407     // ####################
408     // ##### EXTERNAL #####
409     // ####################
410 
411     // ######################
412     // ##### ONLY OWNER #####
413     // ######################
414 
415         function addLiquidity() external onlyOwner() {
416             require(!m_Liquidity,"trading is already open");
417             uint256 _ethBalance = address(this).balance;
418             m_UniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
419             _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
420             m_UniswapV2Pair = IUniswapV2Factory(m_UniswapV2Router.factory()).createPair(address(this), m_UniswapV2Router.WETH());
421             m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
422             EthReflect.init(address(this), 5000, m_UniswapV2Pair, m_UniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY);
423             IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);
424             m_Liquidity = true;        
425         }
426 
427         function launch() external onlyOwner() {
428             m_Launched = true;
429             m_TXRelease = block.timestamp + (7 minutes);
430         }
431 
432         function transferOwnership(address _address) external onlyOwner() {
433             m_ExcludedAddresses[owner()] = false;
434             _transferOwnership(_address);        
435             m_ExcludedAddresses[_address] = true;
436         }
437 
438         function addTaxWhitelist(address _address) external onlyOwner() {
439             m_ExcludedAddresses[_address] = true;
440         }
441 
442         function removeTaxWhitelist(address _address) external onlyOwner() {
443             m_ExcludedAddresses[_address] = false;
444         }
445 
446         function setTxLimit(uint256 _amount) external onlyOwner() {                                            
447             m_TxLimit = _amount.mul(10**9);
448             emit MaxOutTxLimit(m_TxLimit);
449         }
450 
451         function setWalletLimit(uint256 _amount) external onlyOwner() {
452             m_WalletLimit = _amount.mul(10**9);
453         }
454         
455         function manualBan(address _a) external onlyOwner() {
456             m_Banned[_a] = true;
457         }
458         
459         function removeBan(address _a) external onlyOwner() {
460             m_Banned[_a] = false;
461         }
462 
463         function teamWithdraw() external {
464             require(m_TeamMember[_msgSender()]);
465             require(m_TeamBalance[_msgSender()] > 0);
466             payable(_msgSender()).transfer(m_TeamBalance[_msgSender()]);
467             m_TeamBalance[_msgSender()] = 0;
468         }
469         
470         function setProjectWallet(address payable _address) external onlyOwner() {                  
471             m_ProjectWallet = _address;    
472             m_ExcludedAddresses[_address] = true;
473         }
474     }