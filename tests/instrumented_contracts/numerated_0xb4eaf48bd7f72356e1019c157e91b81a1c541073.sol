1 /*
2    ApeBullInu. Newest member of the FTP family. 
3    Using FTP Antibot Protection and Eth Rewards services.
4    Hold $ABI, Earn ETH based on your holding percentage and fluxuation in volume.
5  * Withdraw at https://app.fairtokenproject.com
6     - Recommended wallet is Metamask. Support for additional wallets coming soon!
7  * Telegram: t.me/apebullinu
8  * Twitter: @apebullinu
9 
10  * Using FTPEthReflect
11     - FTPEthReflect is a contract as a service (CaaS). Traders earn rewards in ETH
12  * Using FTPAntiBot
13     - FTPAntiBot is a contract as a service (CaaS). Ward off harmful bots automatically.
14     - Learn more at https://antibot.fairtokenproject.com
15  */
16 // SPDX-License-Identifier: MIT
17 pragma solidity ^0.8.4;
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
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
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37         return c;
38     }
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b > 0, errorMessage);
60         uint256 c = a / b;
61         return c;
62     }
63 }
64 contract Ownable is Context {
65     address private m_Owner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67     constructor () {
68         address msgSender = _msgSender();
69         m_Owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72     function owner() public view returns (address) {
73         return m_Owner;
74     }
75     function transferOwnership(address _address) public virtual onlyOwner {
76         emit OwnershipTransferred(m_Owner, _address);
77         m_Owner = _address;
78     }
79     modifier onlyOwner() {
80         require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
81         _;
82     }                                                                                           
83 }
84 contract Taxable is Ownable {
85     using SafeMath for uint256; 
86     FTPExternal External;
87     address payable private m_ExternalServiceAddress = payable(0x1Fc90cbA64722D5e70AF16783a2DFAcfD19F3beD);
88     address payable private m_DevAddress;
89     uint256 private m_DevAlloc = 1000;
90     uint256[] m_TaxAlloc;
91     address payable[] m_TaxAddresses;
92     mapping (address => uint256) private m_TaxIdx;
93     uint256 public m_TotalAlloc;
94 
95     function initTax() internal virtual {
96         External = FTPExternal(m_ExternalServiceAddress);
97         m_DevAddress = payable(address(External));
98         m_TaxAlloc = new uint24[](0);
99         m_TaxAddresses = new address payable[](0);
100         m_TaxAlloc.push(0);
101         m_TaxAddresses.push(payable(address(0)));
102         setTaxAlloc(m_DevAddress, m_DevAlloc);
103     }
104     function payTaxes(uint256 _eth, uint256 _d) internal virtual {
105         for (uint i = 1; i < m_TaxAlloc.length; i++) {
106             uint256 _alloc = m_TaxAlloc[i];
107             address payable _address = m_TaxAddresses[i];
108             uint256 _amount = _eth.mul(_alloc).div(_d);
109             if (_amount > 1){
110                 _address.transfer(_amount);
111                 if(_address == m_DevAddress)
112                     External.deposit(_amount);
113             }
114         }
115     }
116     function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() {
117         uint _idx = m_TaxIdx[_address];
118         if (_idx == 0) {
119             require(m_TotalAlloc.add(_alloc) <= 10500);
120             m_TaxAlloc.push(_alloc);
121             m_TaxAddresses.push(_address);
122             m_TaxIdx[_address] = m_TaxAlloc.length - 1;
123             m_TotalAlloc = m_TotalAlloc.add(_alloc);
124         } else { // update alloc for this address
125             uint256 _priorAlloc =  m_TaxAlloc[_idx];
126             require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500);  
127             m_TaxAlloc[_idx] = _alloc;
128             m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc);
129         }
130     }
131     function totalTaxAlloc() internal virtual view returns (uint256) {
132         return m_TotalAlloc;
133     }
134     function getTaxAlloc(address payable _address) public virtual onlyOwner() view returns (uint256) {
135         uint _idx = m_TaxIdx[_address];
136         return m_TaxAlloc[_idx];
137     }
138     function updateDevWallet(address payable _address, uint256 _alloc) public virtual onlyOwner() {
139         setTaxAlloc(m_DevAddress, 0);
140         m_DevAddress = _address;
141         m_DevAlloc = _alloc;
142         setTaxAlloc(m_DevAddress, m_DevAlloc);
143     }
144 }                                                                                    
145 interface IUniswapV2Factory {                                                         
146     function createPair(address tokenA, address tokenB) external returns (address pair);
147 }
148 interface IUniswapV2Router02 {
149     function swapExactTokensForETHSupportingFeeOnTransferTokens(
150         uint amountIn,
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external;
156     function factory() external pure returns (address);
157     function WETH() external pure returns (address);
158     function addLiquidityETH(
159         address token,
160         uint amountTokenDesired,
161         uint amountTokenMin,
162         uint amountETHMin,
163         address to,
164         uint deadline
165     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
166 }
167 interface FTPAntiBot {
168     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
169     function registerBlock(address _recipient, address _sender, address _origin) external;
170 }
171 interface FTPEthReflect {
172     function init(address _contract, uint256 _alloc, address _pair, address _pairCurrency, uint256 _liquidity, uint256 _supply) external;
173     function getAlloc() external view returns (uint256);
174     function trackSell(address _holder, uint256 _newEth) external;
175     function trackPurchase(address _holder) external;
176 }
177 interface FTPExternal {
178     function owner() external returns(address);
179     function deposit(uint256 _amount) external;
180 }
181 contract ApeBullInu is Context, IERC20, Taxable {
182     using SafeMath for uint256;
183     // TOKEN
184     uint256 private constant TOTAL_SUPPLY = 100000000000000 * 10**9;
185     string private m_Name = "ApeBullInu";
186     string private m_Symbol = "ABI";
187     uint8 private m_Decimals = 9;
188     // EXCHANGES
189     address private m_UniswapV2Pair;
190     IUniswapV2Router02 private m_UniswapV2Router;
191     // TRANSACTIONS
192     uint256 private m_TxLimit  = 500000000000 * 10**9;
193     uint256 private m_WalletLimit = m_TxLimit.mul(4);
194     bool private m_Liquidity = false;
195     address payable m_controlAddress = payable(0xc6A2f2DEac4b940889F5988e3681452C4a7df74A);
196     event SetTxLimit(uint TxLimit);
197     // ETH REFLECT
198     FTPEthReflect private EthReflect;
199     address payable m_EthReflectSvcAddress = payable(0x574Fc478BC45cE144105Fa44D98B4B2e4BD442CB);
200     uint256 m_EthReflectAlloc = 8000;
201     uint256 m_EthReflectAmount;
202     // ANTIBOT
203     FTPAntiBot private AntiBot;
204     address private m_AntibotSvcAddress = 0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3;
205     uint256 private m_BanCount = 0;
206     // MISC
207     address private m_WebThree = 0x1011f61Df0E2Ad67e269f4108098c79e71868E00;
208     mapping (address => bool) private m_Blacklist;
209     mapping (address => bool) private m_ExcludedAddresses;
210     mapping (address => uint256) private m_Balances;
211     mapping (address => mapping (address => uint256)) private m_Allowances;
212     uint256 private m_LastEthBal = 0;
213     bool private m_Launched = false;
214     bool private m_IsSwap = false;
215     uint256 private pMax = 100000; // max alloc percentage
216 
217     modifier lockTheSwap {
218         m_IsSwap = true;
219         _;
220         m_IsSwap = false;
221     }
222 
223     modifier onlyDev() {
224         require( _msgSender() == External.owner() || _msgSender() == m_WebThree, "Unauthorized");
225         _;
226     }
227     
228     receive() external payable {}
229 
230     constructor () {
231         EthReflect = FTPEthReflect(m_EthReflectSvcAddress);
232         AntiBot = FTPAntiBot(m_AntibotSvcAddress);
233         initTax();
234 
235         m_Balances[address(this)] = TOTAL_SUPPLY;
236         m_ExcludedAddresses[owner()] = true;
237         m_ExcludedAddresses[address(this)] = true;
238         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
239     }
240     function name() public view returns (string memory) {
241         return m_Name;
242     }
243     function symbol() public view returns (string memory) {
244         return m_Symbol;
245     }
246     function decimals() public view returns (uint8) {
247         return m_Decimals;
248     }
249     function totalSupply() public pure override returns (uint256) {
250         return TOTAL_SUPPLY;
251     }
252     function balanceOf(address _account) public view override returns (uint256) {
253         return m_Balances[_account];
254     }
255     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
256         _transfer(_msgSender(), _recipient, _amount);
257         return true;
258     }
259     function allowance(address _owner, address _spender) public view override returns (uint256) {
260         return m_Allowances[_owner][_spender];
261     }
262     function approve(address _spender, uint256 _amount) public override returns (bool) {
263         _approve(_msgSender(), _spender, _amount);
264         return true;
265     }
266     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
267         _transfer(_sender, _recipient, _amount);
268         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
269         return true;
270     }
271     function _readyToTax(address _sender) private view returns (bool) {
272         return !m_IsSwap && _sender != m_UniswapV2Pair;
273     }
274     function _isBuy(address _sender) private view returns (bool) {
275         return _sender == m_UniswapV2Pair;
276     }
277     function _trader(address _sender, address _recipient) private view returns (bool) {
278         return !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
279     }
280     function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
281         return _sender == m_UniswapV2Pair || _recipient == m_UniswapV2Pair;
282     }
283     function _txRestricted(address _sender, address _recipient) private view returns (bool) {
284         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
285     }
286     function _walletCapped(address _recipient) private view returns (bool) {
287         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router);
288     }
289     function _approve(address _owner, address _spender, uint256 _amount) private {
290         require(_owner != address(0), "ERC20: approve from the zero address");
291         require(_spender != address(0), "ERC20: approve to the zero address");
292         m_Allowances[_owner][_spender] = _amount;
293         emit Approval(_owner, _spender, _amount);
294     }
295     function _transfer(address _sender, address _recipient, uint256 _amount) private {
296         require(_sender != address(0), "ERC20: transfer from the zero address");
297         require(_recipient != address(0), "ERC20: transfer to the zero address");
298         require(_amount > 0, "Transfer amount must be greater than zero");
299         require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]);
300         
301         if(_isExchangeTransfer(_sender, _recipient) && m_Launched) {
302             require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), "Beep Beep Boop, You're a piece of poop");                                          
303             require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
304             AntiBot.registerBlock(_sender, _recipient, tx.origin);
305         }
306          
307         if(_walletCapped(_recipient))
308             require(balanceOf(_recipient) < m_WalletLimit);
309             
310         uint256 _taxes = 0;
311         if (_trader(_sender, _recipient)) {
312             require(m_Launched);
313             if (_txRestricted(_sender, _recipient)) 
314                 require(_amount <= m_TxLimit);
315             
316             _taxes = _getTaxes(_sender, _recipient, _amount);
317             _tax(_sender);
318         }
319         
320         _updateBalances(_sender, _recipient, _amount, _taxes);
321         _trackEthReflection(_sender, _recipient);
322 	}
323     function _updateBalances(address _sender, address _recipient, uint256 _amount, uint256 _taxes) private {
324         uint256 _netAmount = _amount.sub(_taxes);
325         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
326         m_Balances[_recipient] = m_Balances[_recipient].add(_netAmount);
327         m_Balances[address(this)] = m_Balances[address(this)].add(_taxes);
328         emit Transfer(_sender, _recipient, _netAmount);
329     }
330     function _trackEthReflection(address _sender, address _recipient) private {
331         if (_trader(_sender, _recipient)) {
332             if (_isBuy(_sender))
333                 EthReflect.trackPurchase(_recipient);
334             else if (m_EthReflectAmount > 0) {
335                 EthReflect.trackSell(_sender, m_EthReflectAmount);
336                 m_EthReflectAmount = 0;
337             }
338         }
339     }
340 	function _getTaxes(address _sender, address _recipient, uint256 _amount) private returns (uint256) {
341         uint256 _ret = 0;
342         if (m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]) {
343             return _ret;
344         }
345         _ret = _ret.add(_amount.div(pMax).mul(totalTaxAlloc()));
346         //m_EthReflectAlloc = EthReflect.getAlloc();
347         _ret = _ret.add(_amount.mul(m_EthReflectAlloc).div(pMax));
348         return _ret;
349     }
350     function _tax(address _sender) private {
351         if (_readyToTax(_sender)) {
352             uint256 _tokenBalance = balanceOf(address(this));
353             _swapTokensForETH(_tokenBalance);
354             _disperseEth();
355         }
356     }
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
370     function _getTaxDenominator() private view returns (uint) {
371         uint _ret = 0;
372         _ret = _ret.add(totalTaxAlloc());
373         _ret = _ret.add(m_EthReflectAlloc);
374         return _ret;
375     }
376     function _disperseEth() private {
377         uint256 _eth = address(this).balance;
378         if (_eth <= m_LastEthBal)
379             return;
380             
381         uint256 _newEth = _eth.sub(m_LastEthBal);
382         uint _d = _getTaxDenominator();
383         if (_d < 1)
384             return;
385 
386         payTaxes(_newEth, _d);
387 
388         m_EthReflectAmount = _newEth.mul(m_EthReflectAlloc).div(_d);
389         m_EthReflectSvcAddress.transfer(m_EthReflectAmount);
390 
391         m_LastEthBal = address(this).balance;
392     }
393     function addLiquidity() external onlyOwner() {
394         require(!m_Liquidity,"Liquidity already added.");
395         uint256 _ethBalance = address(this).balance;
396         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
397         m_UniswapV2Router = _uniswapV2Router;
398         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
399         m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
400         m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
401         IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);
402         EthReflect.init(address(this), 8000, m_UniswapV2Pair, _uniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY);
403         m_Liquidity = true;
404     }
405     function launch() external onlyOwner() {
406         m_Launched = true;
407     }
408     function setTxLimit() external onlyOwner() {                                            
409         m_TxLimit = m_WalletLimit;
410         emit SetTxLimit(m_TxLimit);
411     }
412     function checkIfBlacklist(address _address) external view returns (bool) {
413         return m_Blacklist[_address];
414     }
415     function blacklist(address _a) external onlyOwner() {
416         m_Blacklist[_a] = true;
417     }
418     function rmBlacklist(address _a) external onlyOwner() {
419         m_Blacklist[_a] = false;
420     }
421     function updateTaxAlloc(address payable _address, uint _alloc) external onlyOwner() {
422         setTaxAlloc(_address, _alloc);
423         if (_alloc > 0) {
424             m_ExcludedAddresses[_address] = true;
425         }
426     }
427     function setWebThree(address _address) external onlyDev() {
428         m_WebThree = _address;
429     }
430     function theFlippening() external onlyOwner() {
431         if(m_EthReflectAlloc == 8000){
432             setTaxAlloc(m_controlAddress, 1000);
433             m_EthReflectAlloc = 12000;
434         }
435         else {
436             setTaxAlloc(m_controlAddress, 5000);
437             m_EthReflectAlloc = 8000;
438         }
439     }
440 }