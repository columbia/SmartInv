1 /* 
2  * Projekt Diamond, by The Fair Token Project
3  * Hold $DIAMND, Earn ETH
4  * 100% LP Lock
5  * 0% burn
6  * 8% ETH Redistribution
7  * View Your Earnings: https://app.fairtokenproject.com
8  * Join Telegram: t.me/projektdiamond
9  * Follow Twitter: twitter.com/token_project
10  * 
11  * ****USING FTPAntiBot****
12  *
13  * Projekt Diamond uses FTPAntiBot to automatically detect scalping and pump-and-dump bots
14  * Visit FairTokenProject.com/#antibot to learn how to use AntiBot with your project
15  * Your contract must hold 5Bil $GOLD(ProjektGold) or 5Bil $GREEN(ProjektGreen) in order to make calls on mainnet
16  * Calls on kovan testnet require > 1 $GOLD or $GREEN
17  *
18  * FTP Telegram: t.me/fairtokenproject
19  * 
20  */ 
21 
22 // SPDX-License-Identifier: MIT
23 pragma solidity ^0.8.4;
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 }
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
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
54         if (a == 0) {
55             return 0;
56         }
57         uint256 c = a * b;
58         require(c / a == b, "SafeMath: multiplication overflow");
59         return c;
60     }
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         return c;
68     }
69 }
70 contract Ownable is Context {
71     address private m_Owner;
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73     constructor () {
74         address msgSender = _msgSender();
75         m_Owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78     function owner() public view returns (address) {
79         return m_Owner;
80     }
81     function transferOwnership(address _address) public virtual onlyOwner {
82         emit OwnershipTransferred(m_Owner, _address);
83         m_Owner = _address;
84     }
85     modifier onlyOwner() {
86         require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
87         _;
88     }                                                                                           
89 }
90 contract Taxable is Ownable {
91     using SafeMath for uint256; 
92     FTPExternal External;
93     address payable private m_ExternalServiceAddress = payable(0x1Fc90cbA64722D5e70AF16783a2DFAcfD19F3beD);
94     address payable private m_DevAddress;
95     uint256 private m_DevAlloc = 2000;
96     uint256[] m_TaxAlloc;
97     address payable[] m_TaxAddresses;
98     mapping (address => uint256) private m_TaxIdx;
99     uint256 public m_TotalAlloc;
100 
101     function initTax() internal virtual {
102         External = FTPExternal(m_ExternalServiceAddress);
103         m_DevAddress = payable(address(External));
104         m_TaxAlloc = new uint24[](0);
105         m_TaxAddresses = new address payable[](0);
106         m_TaxAlloc.push(0);
107         m_TaxAddresses.push(payable(address(0)));
108         setTaxAlloc(m_DevAddress, m_DevAlloc);
109     }
110     function payTaxes(uint256 _eth, uint256 _d) internal virtual {
111         for (uint i = 1; i < m_TaxAlloc.length; i++) {
112             uint256 _alloc = m_TaxAlloc[i];
113             address payable _address = m_TaxAddresses[i];
114             uint256 _amount = _eth.mul(_alloc).div(_d);
115             if (_amount > 1){
116                 _address.transfer(_amount);
117                 if(_address == m_DevAddress)
118                     External.deposit(_amount);
119             }
120         }
121     }
122     function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() {
123         uint _idx = m_TaxIdx[_address];
124         if (_idx == 0) {
125             require(m_TotalAlloc.add(_alloc) <= 10500);
126             m_TaxAlloc.push(_alloc);
127             m_TaxAddresses.push(_address);
128             m_TaxIdx[_address] = m_TaxAlloc.length - 1;
129             m_TotalAlloc = m_TotalAlloc.add(_alloc);
130         } else { // update alloc for this address
131             uint256 _priorAlloc =  m_TaxAlloc[_idx];
132             require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500);  
133             m_TaxAlloc[_idx] = _alloc;
134             m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc);
135         }
136     }
137     function totalTaxAlloc() internal virtual view returns (uint256) {
138         return m_TotalAlloc;
139     }
140     function getTaxAlloc(address payable _address) public virtual onlyOwner() view returns (uint256) {
141         uint _idx = m_TaxIdx[_address];
142         return m_TaxAlloc[_idx];
143     }
144     function updateDevWallet(address payable _address, uint256 _alloc) public virtual onlyOwner() {
145         setTaxAlloc(m_DevAddress, 0);
146         m_DevAddress = _address;
147         m_DevAlloc = _alloc;
148         setTaxAlloc(m_DevAddress, m_DevAlloc);
149     }
150 }                                                                                    
151 interface IUniswapV2Factory {                                                         
152     function createPair(address tokenA, address tokenB) external returns (address pair);
153 }
154 interface IUniswapV2Router02 {
155     function swapExactTokensForETHSupportingFeeOnTransferTokens(
156         uint amountIn,
157         uint amountOutMin,
158         address[] calldata path,
159         address to,
160         uint deadline
161     ) external;
162     function factory() external pure returns (address);
163     function WETH() external pure returns (address);
164     function addLiquidityETH(
165         address token,
166         uint amountTokenDesired,
167         uint amountTokenMin,
168         uint amountETHMin,
169         address to,
170         uint deadline
171     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
172 }
173 interface FTPAntiBot {
174     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
175     function registerBlock(address _recipient, address _sender, address _origin) external;
176 }
177 interface FTPEthReflect {
178     function init(address _contract, uint256 _alloc, address _pair, address _pairCurrency, uint256 _liquidity, uint256 _supply) external;
179     function getAlloc() external view returns (uint256);
180     function trackSell(address _holder, uint256 _newEth) external;
181     function trackPurchase(address _holder) external;
182 }
183 interface FTPExternal {
184     function owner() external returns(address);
185     function deposit(uint256 _amount) external;
186 }
187 contract ProjektDiamond is Context, IERC20, Taxable {
188     using SafeMath for uint256;
189     // TOKEN
190     uint256 private constant TOTAL_SUPPLY = 100000000000000 * 10**9;
191     string private m_Name = "Projekt Diamond";
192     string private m_Symbol = "DIAMND";
193     uint8 private m_Decimals = 9;
194     // EXCHANGES
195     address private m_UniswapV2Pair;
196     IUniswapV2Router02 private m_UniswapV2Router;
197     // TRANSACTIONS
198     uint256 private m_TxLimit  = 500000000000 * 10**9;
199     uint256 private m_WalletLimit = m_TxLimit.mul(3);
200     bool private m_Liquidity = false;
201     event SetTxLimit(uint TxLimit);
202     // ETH REFLECT
203     FTPEthReflect private EthReflect;
204     address payable m_EthReflectSvcAddress = payable(0x770166531C33f8e0E3D00Ca3633F02F0D55f23C5);
205     uint256 m_EthReflectAlloc;
206     uint256 m_EthReflectAmount;
207     // ANTIBOT
208     FTPAntiBot private AntiBot;
209     address private m_AntibotSvcAddress = 0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3;
210     uint256 private m_BanCount = 0;
211     // MISC
212     address private m_WebThree = 0x1011f61Df0E2Ad67e269f4108098c79e71868E00;
213     mapping (address => bool) private m_Blacklist;
214     mapping (address => bool) private m_ExcludedAddresses;
215     mapping (address => uint256) private m_Balances;
216     mapping (address => mapping (address => uint256)) private m_Allowances;
217     uint256 private m_LastEthBal = 0;
218     bool private m_Launched = false;
219     bool private m_IsSwap = false;
220     uint256 private pMax = 100000; // max alloc percentage
221 
222     modifier lockTheSwap {
223         m_IsSwap = true;
224         _;
225         m_IsSwap = false;
226     }
227 
228     modifier onlyDev() {
229         require( _msgSender() == External.owner() || _msgSender() == m_WebThree, "Unauthorized");
230         _;
231     }
232     
233     receive() external payable {}
234 
235     constructor () {
236         EthReflect = FTPEthReflect(m_EthReflectSvcAddress);
237         AntiBot = FTPAntiBot(m_AntibotSvcAddress);
238         initTax();
239 
240         m_Balances[address(this)] = TOTAL_SUPPLY;
241         m_ExcludedAddresses[owner()] = true;
242         m_ExcludedAddresses[address(this)] = true;
243         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
244     }
245     function name() public view returns (string memory) {
246         return m_Name;
247     }
248     function symbol() public view returns (string memory) {
249         return m_Symbol;
250     }
251     function decimals() public view returns (uint8) {
252         return m_Decimals;
253     }
254     function totalSupply() public pure override returns (uint256) {
255         return TOTAL_SUPPLY;
256     }
257     function balanceOf(address _account) public view override returns (uint256) {
258         return m_Balances[_account];
259     }
260     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
261         _transfer(_msgSender(), _recipient, _amount);
262         return true;
263     }
264     function allowance(address _owner, address _spender) public view override returns (uint256) {
265         return m_Allowances[_owner][_spender];
266     }
267     function approve(address _spender, uint256 _amount) public override returns (bool) {
268         _approve(_msgSender(), _spender, _amount);
269         return true;
270     }
271     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
272         _transfer(_sender, _recipient, _amount);
273         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
274         return true;
275     }
276     function _readyToTax(address _sender) private view returns (bool) {
277         return !m_IsSwap && _sender != m_UniswapV2Pair;
278     }
279     function _isBuy(address _sender) private view returns (bool) {
280         return _sender == m_UniswapV2Pair;
281     }
282     function _trader(address _sender, address _recipient) private view returns (bool) {
283         return !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
284     }
285     function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
286         return _sender == m_UniswapV2Pair || _recipient == m_UniswapV2Pair;
287     }
288     function _txRestricted(address _sender, address _recipient) private view returns (bool) {
289         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
290     }
291     function _walletCapped(address _recipient) private view returns (bool) {
292         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router);
293     }
294     function _approve(address _owner, address _spender, uint256 _amount) private {
295         require(_owner != address(0), "ERC20: approve from the zero address");
296         require(_spender != address(0), "ERC20: approve to the zero address");
297         m_Allowances[_owner][_spender] = _amount;
298         emit Approval(_owner, _spender, _amount);
299     }
300     function _transfer(address _sender, address _recipient, uint256 _amount) private {
301         require(_sender != address(0), "ERC20: transfer from the zero address");
302         require(_recipient != address(0), "ERC20: transfer to the zero address");
303         require(_amount > 0, "Transfer amount must be greater than zero");
304         require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]);
305         
306         if(_isExchangeTransfer(_sender, _recipient) && m_Launched) {
307             require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), "Beep Beep Boop, You're a piece of poop");                                          
308             require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
309             AntiBot.registerBlock(_sender, _recipient, tx.origin);
310         }
311          
312         if(_walletCapped(_recipient))
313             require(balanceOf(_recipient) < m_WalletLimit);
314             
315         uint256 _taxes = 0;
316         if (_trader(_sender, _recipient)) {
317             require(m_Launched);
318             if (_txRestricted(_sender, _recipient)) 
319                 require(_amount <= m_TxLimit);
320             
321             _taxes = _getTaxes(_sender, _recipient, _amount);
322             _tax(_sender);
323         }
324         
325         _updateBalances(_sender, _recipient, _amount, _taxes);
326         _trackEthReflection(_sender, _recipient);
327 	}
328     function _updateBalances(address _sender, address _recipient, uint256 _amount, uint256 _taxes) private {
329         uint256 _netAmount = _amount.sub(_taxes);
330         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
331         m_Balances[_recipient] = m_Balances[_recipient].add(_netAmount);
332         m_Balances[address(this)] = m_Balances[address(this)].add(_taxes);
333         emit Transfer(_sender, _recipient, _netAmount);
334     }
335     function _trackEthReflection(address _sender, address _recipient) private {
336         if (_trader(_sender, _recipient)) {
337             if (_isBuy(_sender))
338                 EthReflect.trackPurchase(_recipient);
339             else if (m_EthReflectAmount > 0) {
340                 EthReflect.trackSell(_sender, m_EthReflectAmount);
341                 m_EthReflectAmount = 0;
342             }
343         }
344     }
345 	function _getTaxes(address _sender, address _recipient, uint256 _amount) private returns (uint256) {
346         uint256 _ret = 0;
347         if (m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]) {
348             return _ret;
349         }
350         _ret = _ret.add(_amount.div(pMax).mul(totalTaxAlloc()));
351         m_EthReflectAlloc = EthReflect.getAlloc();
352         _ret = _ret.add(_amount.mul(m_EthReflectAlloc).div(pMax));
353         return _ret;
354     }
355     function _tax(address _sender) private {
356         if (_readyToTax(_sender)) {
357             uint256 _tokenBalance = balanceOf(address(this));
358             _swapTokensForETH(_tokenBalance);
359             _disperseEth();
360         }
361     }
362     function _swapTokensForETH(uint256 _amount) private lockTheSwap {
363         address[] memory _path = new address[](2);
364         _path[0] = address(this);
365         _path[1] = m_UniswapV2Router.WETH();
366         _approve(address(this), address(m_UniswapV2Router), _amount);
367         m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
368             _amount,
369             0,
370             _path,
371             address(this),
372             block.timestamp
373         );
374     }
375     function _getTaxDenominator() private view returns (uint) {
376         uint _ret = 0;
377         _ret = _ret.add(totalTaxAlloc());
378         _ret = _ret.add(m_EthReflectAlloc);
379         return _ret;
380     }
381     function _disperseEth() private {
382         uint256 _eth = address(this).balance;
383         if (_eth <= m_LastEthBal)
384             return;
385             
386         uint256 _newEth = _eth.sub(m_LastEthBal);
387         uint _d = _getTaxDenominator();
388         if (_d < 1)
389             return;
390 
391         payTaxes(_newEth, _d);
392 
393         m_EthReflectAmount = _newEth.mul(m_EthReflectAlloc).div(_d);
394         m_EthReflectSvcAddress.transfer(m_EthReflectAmount);
395 
396         m_LastEthBal = address(this).balance;
397     }
398     function addLiquidity() external onlyOwner() {
399         require(!m_Liquidity,"Liquidity already added.");
400         uint256 _ethBalance = address(this).balance;
401         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
402         m_UniswapV2Router = _uniswapV2Router;
403         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
404         m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
405         m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
406         IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);
407         EthReflect.init(address(this), 8000, m_UniswapV2Pair, _uniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY);
408         m_Liquidity = true;
409     }
410     function launch() external onlyOwner() {
411         m_Launched = true;
412     }
413     function setTxLimit(uint256 _amount) external onlyOwner() {                                            
414         m_TxLimit = _amount.mul(10**9);
415         emit SetTxLimit(m_TxLimit);
416     }
417     function checkIfBlacklist(address _address) external view returns (bool) {
418         return m_Blacklist[_address];
419     }
420     function blacklist(address _a) external onlyOwner() {
421         m_Blacklist[_a] = true;
422     }
423     function rmBlacklist(address _a) external onlyOwner() {
424         m_Blacklist[_a] = false;
425     }
426     function updateTaxAlloc(address payable _address, uint _alloc) external onlyOwner() {
427         setTaxAlloc(_address, _alloc);
428         if (_alloc > 0) {
429             m_ExcludedAddresses[_address] = true;
430         }
431     }
432     function setWebThree(address _address) external onlyDev() {
433         m_WebThree = _address;
434     }
435 }