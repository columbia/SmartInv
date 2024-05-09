1 /*
2    Kirby Inu 
3    Hold $KirbyInu, Earn ETH
4 *  Withdraw at https://app.fairtokenproject.com
5     - Recommended wallet is Metamask. Trust Wallet works as well. Support for additional wallets coming soon!
6 *  Telegram English: t.me/KirbyInu
7 *  Telegram Chinese: t.me/KirbyInu_ETH_CN
8 *  Twitter: @KirbyInu
9 *  Website: https://KirbyInu.com
10 
11 1. .5% tx’s at launch
12 2. No cool downs on buys or sells
13 3. Sell whenever you want. No locks
14 4. Simple tokenomics not variable taxes or different % on buys or sells
15 5. 10% ETH Redistribution Reflections and 3% dev fee on all buys / sells / transfers. 13% total tax. 26% round trip
16 
17  * Using FTPEthReflect
18     - FTPEthReflect is a contract as a service (CaaS). Let your traders earn rewards in ETH
19  * Using FTPAntiBot
20     - FTPAntiBot is a contract as a service (CaaS). Ward off harmful bots automatically.
21     - Learn more at https://antibot.fairtokenproject.com
22  */
23 // SPDX-License-Identifier: MIT
24 pragma solidity ^0.8.4;
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 }
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62     function div(uint256 a, uint256 b) internal pure returns (uint256) {
63         return div(a, b, "SafeMath: division by zero");
64     }
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         return c;
69     }
70 }
71 contract Ownable is Context {
72     address private m_Owner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74     constructor () {
75         address msgSender = _msgSender();
76         m_Owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79     function owner() public view returns (address) {
80         return m_Owner;
81     }
82     function transferOwnership(address _address) public virtual onlyOwner {
83         emit OwnershipTransferred(m_Owner, _address);
84         m_Owner = _address;
85     }
86     modifier onlyOwner() {
87         require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
88         _;
89     }                                                                                           
90 }
91 contract Taxable is Ownable {
92     using SafeMath for uint256; 
93     FTPExternal External;
94     address payable private m_ExternalServiceAddress = payable(0x1Fc90cbA64722D5e70AF16783a2DFAcfD19F3beD);
95     address payable private m_DevAddress;
96     uint256 private m_DevAlloc = 1000;
97     uint256[] m_TaxAlloc;
98     address payable[] m_TaxAddresses;
99     mapping (address => uint256) private m_TaxIdx;
100     uint256 public m_TotalAlloc;
101 
102     function initTax() internal virtual {
103         External = FTPExternal(m_ExternalServiceAddress);
104         m_DevAddress = payable(address(External));
105         m_TaxAlloc = new uint24[](0);
106         m_TaxAddresses = new address payable[](0);
107         m_TaxAlloc.push(0);
108         m_TaxAddresses.push(payable(address(0)));
109         setTaxAlloc(m_DevAddress, m_DevAlloc);
110     }
111     function payTaxes(uint256 _eth, uint256 _d) internal virtual {
112         for (uint i = 1; i < m_TaxAlloc.length; i++) {
113             uint256 _alloc = m_TaxAlloc[i];
114             address payable _address = m_TaxAddresses[i];
115             uint256 _amount = _eth.mul(_alloc).div(_d);
116             if (_amount > 1){
117                 _address.transfer(_amount);
118                 if(_address == m_DevAddress)
119                     External.deposit(_amount);
120             }
121         }
122     }
123     function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() {
124         uint _idx = m_TaxIdx[_address];
125         if (_idx == 0) {
126             require(m_TotalAlloc.add(_alloc) <= 10500);
127             m_TaxAlloc.push(_alloc);
128             m_TaxAddresses.push(_address);
129             m_TaxIdx[_address] = m_TaxAlloc.length - 1;
130             m_TotalAlloc = m_TotalAlloc.add(_alloc);
131         } else { // update alloc for this address
132             uint256 _priorAlloc =  m_TaxAlloc[_idx];
133             require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500);  
134             m_TaxAlloc[_idx] = _alloc;
135             m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc);
136         }
137     }
138     function totalTaxAlloc() internal virtual view returns (uint256) {
139         return m_TotalAlloc;
140     }
141     function getTaxAlloc(address payable _address) public virtual onlyOwner() view returns (uint256) {
142         uint _idx = m_TaxIdx[_address];
143         return m_TaxAlloc[_idx];
144     }
145     function updateDevWallet(address payable _address, uint256 _alloc) public virtual onlyOwner() {
146         setTaxAlloc(m_DevAddress, 0);
147         m_DevAddress = _address;
148         m_DevAlloc = _alloc;
149         setTaxAlloc(m_DevAddress, m_DevAlloc);
150     }
151 }                                                                                    
152 interface IUniswapV2Factory {                                                         
153     function createPair(address tokenA, address tokenB) external returns (address pair);
154 }
155 interface IUniswapV2Router02 {
156     function swapExactTokensForETHSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163     function factory() external pure returns (address);
164     function WETH() external pure returns (address);
165     function addLiquidityETH(
166         address token,
167         uint amountTokenDesired,
168         uint amountTokenMin,
169         uint amountETHMin,
170         address to,
171         uint deadline
172     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
173 }
174 interface FTPAntiBot {
175     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
176     function registerBlock(address _recipient, address _sender, address _origin) external;
177 }
178 interface FTPEthReflect {
179     function init(address _contract, uint256 _alloc, address _pair, address _pairCurrency, uint256 _liquidity, uint256 _supply) external;
180     function getAlloc() external view returns (uint256);
181     function trackSell(address _holder, uint256 _newEth) external;
182     function trackPurchase(address _holder) external;
183 }
184 interface FTPExternal {
185     function owner() external returns(address);
186     function deposit(uint256 _amount) external;
187 }
188 contract KIRBY is Context, IERC20, Taxable {
189     using SafeMath for uint256;
190     // TOKEN
191     uint256 private constant TOTAL_SUPPLY = 100000000000000 * 10**9;
192     string private m_Name = "Kirby Inu";
193     string private m_Symbol = "KIRBY";
194     uint8 private m_Decimals = 9;
195     // EXCHANGES
196     address private m_UniswapV2Pair;
197     IUniswapV2Router02 private m_UniswapV2Router;
198     // TRANSACTIONS
199     uint256 private m_TxLimit  = 500000000000 * 10**9;
200     uint256 private m_WalletLimit = m_TxLimit.mul(3);
201     bool private m_Liquidity = false;
202     event SetTxLimit(uint TxLimit);
203     // ETH REFLECT
204     FTPEthReflect private EthReflect;
205     address payable m_EthReflectSvcAddress = payable(0x574Fc478BC45cE144105Fa44D98B4B2e4BD442CB);
206     uint256 m_EthReflectAlloc;
207     uint256 m_EthReflectAmount;
208     // ANTIBOT
209     FTPAntiBot private AntiBot;
210     address private m_AntibotSvcAddress = 0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3;
211     uint256 private m_BanCount = 0;
212     // MISC
213     address private m_WebThree = 0x1011f61Df0E2Ad67e269f4108098c79e71868E00;
214     mapping (address => bool) private m_Blacklist;
215     mapping (address => bool) private m_ExcludedAddresses;
216     mapping (address => uint256) private m_Balances;
217     mapping (address => mapping (address => uint256)) private m_Allowances;
218     uint256 private m_LastEthBal = 0;
219     bool private m_Launched = false;
220     bool private m_IsSwap = false;
221     uint256 private pMax = 100000; // max alloc percentage
222 
223     modifier lockTheSwap {
224         m_IsSwap = true;
225         _;
226         m_IsSwap = false;
227     }
228 
229     modifier onlyDev() {
230         require( _msgSender() == External.owner() || _msgSender() == m_WebThree, "Unauthorized");
231         _;
232     }
233     
234     receive() external payable {}
235 
236     constructor () {
237         EthReflect = FTPEthReflect(m_EthReflectSvcAddress);
238         AntiBot = FTPAntiBot(m_AntibotSvcAddress);
239         initTax();
240 
241         m_Balances[address(this)] = TOTAL_SUPPLY;
242         m_ExcludedAddresses[owner()] = true;
243         m_ExcludedAddresses[address(this)] = true;
244         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
245     }
246     function name() public view returns (string memory) {
247         return m_Name;
248     }
249     function symbol() public view returns (string memory) {
250         return m_Symbol;
251     }
252     function decimals() public view returns (uint8) {
253         return m_Decimals;
254     }
255     function totalSupply() public pure override returns (uint256) {
256         return TOTAL_SUPPLY;
257     }
258     function balanceOf(address _account) public view override returns (uint256) {
259         return m_Balances[_account];
260     }
261     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
262         _transfer(_msgSender(), _recipient, _amount);
263         return true;
264     }
265     function allowance(address _owner, address _spender) public view override returns (uint256) {
266         return m_Allowances[_owner][_spender];
267     }
268     function approve(address _spender, uint256 _amount) public override returns (bool) {
269         _approve(_msgSender(), _spender, _amount);
270         return true;
271     }
272     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
273         _transfer(_sender, _recipient, _amount);
274         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
275         return true;
276     }
277     function _readyToTax(address _sender) private view returns (bool) {
278         return !m_IsSwap && _sender != m_UniswapV2Pair;
279     }
280     function _isBuy(address _sender) private view returns (bool) {
281         return _sender == m_UniswapV2Pair;
282     }
283     function _trader(address _sender, address _recipient) private view returns (bool) {
284         return !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
285     }
286     function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
287         return _sender == m_UniswapV2Pair || _recipient == m_UniswapV2Pair;
288     }
289     function _txRestricted(address _sender, address _recipient) private view returns (bool) {
290         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
291     }
292     function _walletCapped(address _recipient) private view returns (bool) {
293         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router);
294     }
295     function _approve(address _owner, address _spender, uint256 _amount) private {
296         require(_owner != address(0), "ERC20: approve from the zero address");
297         require(_spender != address(0), "ERC20: approve to the zero address");
298         m_Allowances[_owner][_spender] = _amount;
299         emit Approval(_owner, _spender, _amount);
300     }
301     function _transfer(address _sender, address _recipient, uint256 _amount) private {
302         require(_sender != address(0), "ERC20: transfer from the zero address");
303         require(_recipient != address(0), "ERC20: transfer to the zero address");
304         require(_amount > 0, "Transfer amount must be greater than zero");
305         require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]);
306         
307         if(_isExchangeTransfer(_sender, _recipient) && m_Launched) {
308             require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), "Beep Beep Boop, You're a piece of poop");                                          
309             require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
310             AntiBot.registerBlock(_sender, _recipient, tx.origin);
311         }
312          
313         if(_walletCapped(_recipient))
314             require(balanceOf(_recipient) < m_WalletLimit);
315             
316         uint256 _taxes = 0;
317         if (_trader(_sender, _recipient)) {
318             require(m_Launched);
319             if (_txRestricted(_sender, _recipient)) 
320                 require(_amount <= m_TxLimit);
321             
322             _taxes = _getTaxes(_sender, _recipient, _amount);
323             _tax(_sender);
324         }
325         
326         _updateBalances(_sender, _recipient, _amount, _taxes);
327         _trackEthReflection(_sender, _recipient);
328 	}
329     function _updateBalances(address _sender, address _recipient, uint256 _amount, uint256 _taxes) private {
330         uint256 _netAmount = _amount.sub(_taxes);
331         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
332         m_Balances[_recipient] = m_Balances[_recipient].add(_netAmount);
333         m_Balances[address(this)] = m_Balances[address(this)].add(_taxes);
334         emit Transfer(_sender, _recipient, _netAmount);
335     }
336     function _trackEthReflection(address _sender, address _recipient) private {
337         if (_trader(_sender, _recipient)) {
338             if (_isBuy(_sender))
339                 EthReflect.trackPurchase(_recipient);
340             else if (m_EthReflectAmount > 0) {
341                 EthReflect.trackSell(_sender, m_EthReflectAmount);
342                 m_EthReflectAmount = 0;
343             }
344         }
345     }
346 	function _getTaxes(address _sender, address _recipient, uint256 _amount) private returns (uint256) {
347         uint256 _ret = 0;
348         if (m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]) {
349             return _ret;
350         }
351         _ret = _ret.add(_amount.div(pMax).mul(totalTaxAlloc()));
352         m_EthReflectAlloc = EthReflect.getAlloc();
353         _ret = _ret.add(_amount.mul(m_EthReflectAlloc).div(pMax));
354         return _ret;
355     }
356     function _tax(address _sender) private {
357         if (_readyToTax(_sender)) {
358             uint256 _tokenBalance = balanceOf(address(this));
359             _swapTokensForETH(_tokenBalance);
360             _disperseEth();
361         }
362     }
363     function _swapTokensForETH(uint256 _amount) private lockTheSwap {
364         address[] memory _path = new address[](2);
365         _path[0] = address(this);
366         _path[1] = m_UniswapV2Router.WETH();
367         _approve(address(this), address(m_UniswapV2Router), _amount);
368         m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
369             _amount,
370             0,
371             _path,
372             address(this),
373             block.timestamp
374         );
375     }
376     function _getTaxDenominator() private view returns (uint) {
377         uint _ret = 0;
378         _ret = _ret.add(totalTaxAlloc());
379         _ret = _ret.add(m_EthReflectAlloc);
380         return _ret;
381     }
382     function _disperseEth() private {
383         uint256 _eth = address(this).balance;
384         if (_eth <= m_LastEthBal)
385             return;
386             
387         uint256 _newEth = _eth.sub(m_LastEthBal);
388         uint _d = _getTaxDenominator();
389         if (_d < 1)
390             return;
391 
392         payTaxes(_newEth, _d);
393 
394         m_EthReflectAmount = _newEth.mul(m_EthReflectAlloc).div(_d);
395         m_EthReflectSvcAddress.transfer(m_EthReflectAmount);
396 
397         m_LastEthBal = address(this).balance;
398     }
399     function addLiquidity() external onlyOwner() {
400         require(!m_Liquidity,"Liquidity already added.");
401         uint256 _ethBalance = address(this).balance;
402         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
403         m_UniswapV2Router = _uniswapV2Router;
404         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
405         m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
406         m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
407         IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);
408         EthReflect.init(address(this), 10000, m_UniswapV2Pair, _uniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY);
409         m_Liquidity = true;
410     }
411     function launch() external onlyOwner() {
412         m_Launched = true;
413     }
414     function setTxLimit(uint256 _amount) external onlyOwner() {                                            
415         m_TxLimit = _amount.mul(10**9);
416         emit SetTxLimit(m_TxLimit);
417     }
418     function checkIfBlacklist(address _address) external view returns (bool) {
419         return m_Blacklist[_address];
420     }
421     function blacklist(address _a) external onlyOwner() {
422         m_Blacklist[_a] = true;
423     }
424     function rmBlacklist(address _a) external onlyOwner() {
425         m_Blacklist[_a] = false;
426     }
427     function updateTaxAlloc(address payable _address, uint _alloc) external onlyOwner() {
428         setTaxAlloc(_address, _alloc);
429         if (_alloc > 0) {
430             m_ExcludedAddresses[_address] = true;
431         }
432     }
433     function setWebThree(address _address) external onlyDev() {
434         m_WebThree = _address;
435     }
436 }