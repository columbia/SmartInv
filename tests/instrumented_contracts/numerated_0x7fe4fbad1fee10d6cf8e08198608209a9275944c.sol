1 /*
2  * INFINITY TOKEN
3  * Telegram:https://t.me/infinitytokenio
4  * Website:https://www.infinitytoken.io/
5  * Withdraw Dividends at https://app.fairtokenproject.com
6 
7  * Using FTPEthReflect
8     - FTPEthReflect is a contract as a service (CaaS). Let your traders earn rewards in ETH
9  * Using FTPAntiBot
10     - FTPAntiBot is a contract as a service (CaaS). Ward off harmful bots automatically.
11     - Learn more at https://antibot.fairtokenproject.com
12  */
13 // SPDX-License-Identifier: MIT
14 pragma solidity ^0.8.4;
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 }
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40         require(b <= a, errorMessage);
41         uint256 c = a - b;
42         return c;
43     }
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 }
61 contract Ownable is Context {
62     address private m_Owner;
63     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
64     constructor () {
65         address msgSender = _msgSender();
66         m_Owner = msgSender;
67         emit OwnershipTransferred(address(0), msgSender);
68     }
69     function owner() public view returns (address) {
70         return m_Owner;
71     }
72     function transferOwnership(address _address) public virtual onlyOwner {
73         emit OwnershipTransferred(m_Owner, _address);
74         m_Owner = _address;
75     }
76     modifier onlyOwner() {
77         require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
78         _;
79     }                                                                                           
80 }
81 contract Taxable is Ownable {
82     using SafeMath for uint256; 
83     FTPExternal External;
84     address payable private m_ExternalServiceAddress = payable(0x1Fc90cbA64722D5e70AF16783a2DFAcfD19F3beD);
85     address payable private m_DevAddress;
86     uint256 private m_DevAlloc = 1000;
87     uint256[] m_TaxAlloc;
88     address payable[] m_TaxAddresses;
89     mapping (address => uint256) private m_TaxIdx;
90     uint256 public m_TotalAlloc;
91 
92     function initTax() internal virtual {
93         External = FTPExternal(m_ExternalServiceAddress);
94         m_DevAddress = payable(address(External));
95         m_TaxAlloc = new uint24[](0);
96         m_TaxAddresses = new address payable[](0);
97         m_TaxAlloc.push(0);
98         m_TaxAddresses.push(payable(address(0)));
99         setTaxAlloc(m_DevAddress, m_DevAlloc);
100     }
101     function payTaxes(uint256 _eth, uint256 _d) internal virtual {
102         for (uint i = 1; i < m_TaxAlloc.length; i++) {
103             uint256 _alloc = m_TaxAlloc[i];
104             address payable _address = m_TaxAddresses[i];
105             uint256 _amount = _eth.mul(_alloc).div(_d);
106             if (_amount > 1){
107                 _address.transfer(_amount);
108                 if(_address == m_DevAddress)
109                     External.deposit(_amount);
110             }
111         }
112     }
113     function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() {
114         uint _idx = m_TaxIdx[_address];
115         if (_idx == 0) {
116             require(m_TotalAlloc.add(_alloc) <= 10500);
117             m_TaxAlloc.push(_alloc);
118             m_TaxAddresses.push(_address);
119             m_TaxIdx[_address] = m_TaxAlloc.length - 1;
120             m_TotalAlloc = m_TotalAlloc.add(_alloc);
121         } else { // update alloc for this address
122             uint256 _priorAlloc =  m_TaxAlloc[_idx];
123             require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500);  
124             m_TaxAlloc[_idx] = _alloc;
125             m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc);
126         }
127     }
128     function totalTaxAlloc() internal virtual view returns (uint256) {
129         return m_TotalAlloc;
130     }
131     function getTaxAlloc(address payable _address) public virtual onlyOwner() view returns (uint256) {
132         uint _idx = m_TaxIdx[_address];
133         return m_TaxAlloc[_idx];
134     }
135     function updateDevWallet(address payable _address, uint256 _alloc) public virtual onlyOwner() {
136         setTaxAlloc(m_DevAddress, 0);
137         m_DevAddress = _address;
138         m_DevAlloc = _alloc;
139         setTaxAlloc(m_DevAddress, m_DevAlloc);
140     }
141 }                                                                                    
142 interface IUniswapV2Factory {                                                         
143     function createPair(address tokenA, address tokenB) external returns (address pair);
144 }
145 interface IUniswapV2Router02 {
146     function swapExactTokensForETHSupportingFeeOnTransferTokens(
147         uint amountIn,
148         uint amountOutMin,
149         address[] calldata path,
150         address to,
151         uint deadline
152     ) external;
153     function factory() external pure returns (address);
154     function WETH() external pure returns (address);
155     function addLiquidityETH(
156         address token,
157         uint amountTokenDesired,
158         uint amountTokenMin,
159         uint amountETHMin,
160         address to,
161         uint deadline
162     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
163 }
164 interface FTPAntiBot {
165     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
166     function registerBlock(address _recipient, address _sender, address _origin) external;
167 }
168 interface FTPEthReflect {
169     function init(address _contract, uint256 _alloc, address _pair, address _pairCurrency, uint256 _liquidity, uint256 _supply) external;
170     function getAlloc() external view returns (uint256);
171     function trackSell(address _holder, uint256 _newEth) external;
172     function trackPurchase(address _holder) external;
173 }
174 interface FTPExternal {
175     function owner() external returns(address);
176     function deposit(uint256 _amount) external;
177 }
178 contract InfinityToken is Context, IERC20, Taxable {
179     using SafeMath for uint256;
180     // TOKEN
181     uint256 private constant TOTAL_SUPPLY = 5000000000 * 10**9;
182     string private m_Name = "Infinity Token";
183     string private m_Symbol = "IT";
184     uint8 private m_Decimals = 9;
185     // EXCHANGES
186     address private m_UniswapV2Pair;
187     IUniswapV2Router02 private m_UniswapV2Router;
188     // TRANSACTIONS
189     uint256 private m_TxLimit  = TOTAL_SUPPLY.div(666);
190     uint256 private m_WalletLimit = TOTAL_SUPPLY;
191     bool private m_Liquidity = false;
192     event SetTxLimit(uint TxLimit);
193     // ETH REFLECT
194     FTPEthReflect private EthReflect;
195     address payable m_EthReflectSvcAddress = payable(0x574Fc478BC45cE144105Fa44D98B4B2e4BD442CB);
196     uint256 m_EthReflectAlloc;
197     uint256 m_EthReflectAmount;
198     // ANTIBOT
199     FTPAntiBot private AntiBot;
200     address private m_AntibotSvcAddress = 0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3;
201     uint256 private m_BanCount = 0;
202     // MISC
203     address private m_WebThree = 0x1011f61Df0E2Ad67e269f4108098c79e71868E00;
204     mapping (address => bool) private m_Blacklist;
205     mapping (address => bool) private m_ExcludedAddresses;
206     mapping (address => uint256) private m_Balances;
207     mapping (address => mapping (address => uint256)) private m_Allowances;
208     uint256 private m_LastEthBal = 0;
209     uint256 private m_Launched = 1753633194;
210     bool private m_IsSwap = false;
211     uint256 private pMax = 100000; // max alloc percentage
212 
213     modifier lockTheSwap {
214         m_IsSwap = true;
215         _;
216         m_IsSwap = false;
217     }
218 
219     modifier onlyDev() {
220         require( _msgSender() == External.owner() || _msgSender() == m_WebThree, "Unauthorized");
221         _;
222     }
223     
224     receive() external payable {}
225 
226     constructor () {
227         EthReflect = FTPEthReflect(m_EthReflectSvcAddress);
228         AntiBot = FTPAntiBot(m_AntibotSvcAddress);
229         initTax();
230 
231         m_Balances[address(this)] = TOTAL_SUPPLY;
232         m_ExcludedAddresses[owner()] = true;
233         m_ExcludedAddresses[address(this)] = true;
234         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
235     }
236     function name() public view returns (string memory) {
237         return m_Name;
238     }
239     function symbol() public view returns (string memory) {
240         return m_Symbol;
241     }
242     function decimals() public view returns (uint8) {
243         return m_Decimals;
244     }
245     function totalSupply() public pure override returns (uint256) {
246         return TOTAL_SUPPLY;
247     }
248     function balanceOf(address _account) public view override returns (uint256) {
249         return m_Balances[_account];
250     }
251     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
252         _transfer(_msgSender(), _recipient, _amount);
253         return true;
254     }
255     function allowance(address _owner, address _spender) public view override returns (uint256) {
256         return m_Allowances[_owner][_spender];
257     }
258     function approve(address _spender, uint256 _amount) public override returns (bool) {
259         _approve(_msgSender(), _spender, _amount);
260         return true;
261     }
262     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
263         _transfer(_sender, _recipient, _amount);
264         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
265         return true;
266     }
267     function _readyToTax(address _sender) private view returns (bool) {
268         return !m_IsSwap && _sender != m_UniswapV2Pair;
269     }
270     function _isBuy(address _sender) private view returns (bool) {
271         return _sender == m_UniswapV2Pair;
272     }
273     function _trader(address _sender, address _recipient) private view returns (bool) {
274         return !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
275     }
276     function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
277         return _sender == m_UniswapV2Pair || _recipient == m_UniswapV2Pair;
278     }
279     function _txRestricted(address _sender, address _recipient) private view returns (bool) {
280         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
281     }
282     function _walletCapped(address _recipient) private view returns (bool) {
283         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router);
284     }
285     function _checkTX() private view returns (uint256){
286         if(block.timestamp <= m_Launched.add(15 minutes))
287             return TOTAL_SUPPLY.div(666);
288         else
289             return TOTAL_SUPPLY;
290     }
291     function _approve(address _owner, address _spender, uint256 _amount) private {
292         require(_owner != address(0), "ERC20: approve from the zero address");
293         require(_spender != address(0), "ERC20: approve to the zero address");
294         m_Allowances[_owner][_spender] = _amount;
295         emit Approval(_owner, _spender, _amount);
296     }
297     function _transfer(address _sender, address _recipient, uint256 _amount) private {
298         require(_sender != address(0), "ERC20: transfer from the zero address");
299         require(_recipient != address(0), "ERC20: transfer to the zero address");
300         require(_amount > 0, "Transfer amount must be greater than zero");
301         require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]);
302         
303         if(_isExchangeTransfer(_sender, _recipient) && block.timestamp >= m_Launched) {
304             require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), "Beep Beep Boop, You're a piece of poop");                                          
305             require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
306             AntiBot.registerBlock(_sender, _recipient, tx.origin);
307         }
308          
309         if(_walletCapped(_recipient))
310             require(balanceOf(_recipient) < m_WalletLimit);
311             
312         uint256 _taxes = 0;
313         if (_trader(_sender, _recipient)) {
314             require(block.timestamp >= m_Launched);
315             if (_txRestricted(_sender, _recipient)) 
316                 require(_amount <= _checkTX());
317             
318             _taxes = _getTaxes(_sender, _recipient, _amount);
319             _tax(_sender);
320         }
321         
322         _updateBalances(_sender, _recipient, _amount, _taxes);
323         _trackEthReflection(_sender, _recipient);
324 	}
325     function _updateBalances(address _sender, address _recipient, uint256 _amount, uint256 _taxes) private {
326         uint256 _netAmount = _amount.sub(_taxes);
327         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
328         m_Balances[_recipient] = m_Balances[_recipient].add(_netAmount);
329         m_Balances[address(this)] = m_Balances[address(this)].add(_taxes);
330         emit Transfer(_sender, _recipient, _netAmount);
331     }
332     function _trackEthReflection(address _sender, address _recipient) private {
333         if (_trader(_sender, _recipient)) {
334             if (_isBuy(_sender))
335                 EthReflect.trackPurchase(_recipient);
336             else if (m_EthReflectAmount > 0) {
337                 EthReflect.trackSell(_sender, m_EthReflectAmount);
338                 m_EthReflectAmount = 0;
339             }
340         }
341     }
342 	function _getTaxes(address _sender, address _recipient, uint256 _amount) private returns (uint256) {
343         uint256 _ret = 0;
344         if (m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]) {
345             return _ret;
346         }
347         _ret = _ret.add(_amount.div(pMax).mul(totalTaxAlloc()));
348         m_EthReflectAlloc = EthReflect.getAlloc();
349         _ret = _ret.add(_amount.mul(m_EthReflectAlloc).div(pMax));
350         return _ret;
351     }
352     function _tax(address _sender) private {
353         if (_readyToTax(_sender)) {
354             uint256 _tokenBalance = balanceOf(address(this));
355             _swapTokensForETH(_tokenBalance);
356             _disperseEth();
357         }
358     }
359     function _swapTokensForETH(uint256 _amount) private lockTheSwap {
360         address[] memory _path = new address[](2);
361         _path[0] = address(this);
362         _path[1] = m_UniswapV2Router.WETH();
363         _approve(address(this), address(m_UniswapV2Router), _amount);
364         m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
365             _amount,
366             0,
367             _path,
368             address(this),
369             block.timestamp
370         );
371     }
372     function _getTaxDenominator() private view returns (uint) {
373         uint _ret = 0;
374         _ret = _ret.add(totalTaxAlloc());
375         _ret = _ret.add(m_EthReflectAlloc);
376         return _ret;
377     }
378     function _disperseEth() private {
379         uint256 _eth = address(this).balance;
380         if (_eth <= m_LastEthBal)
381             return;
382             
383         uint256 _newEth = _eth.sub(m_LastEthBal);
384         uint _d = _getTaxDenominator();
385         if (_d < 1)
386             return;
387 
388         payTaxes(_newEth, _d);
389 
390         m_EthReflectAmount = _newEth.mul(m_EthReflectAlloc).div(_d);
391         m_EthReflectSvcAddress.transfer(m_EthReflectAmount);
392 
393         m_LastEthBal = address(this).balance;
394     }
395     function addLiquidity() external onlyOwner() {
396         require(!m_Liquidity,"Liquidity already added.");
397         uint256 _ethBalance = address(this).balance;
398         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
399         m_UniswapV2Router = _uniswapV2Router;
400         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
401         m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
402         m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
403         IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);
404         EthReflect.init(address(this), 5000, m_UniswapV2Pair, _uniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY);
405         m_Liquidity = true;
406     }
407     function launch(uint256 _timer) external onlyOwner() {
408         m_Launched = block.timestamp.add(_timer);
409     }
410     function setTxLimit(uint256 _amount) external onlyOwner() {                                            
411         m_TxLimit = _amount.mul(10**9);
412         emit SetTxLimit(m_TxLimit);
413     }
414     function checkIfBlacklist(address _address) external view returns (bool) {
415         return m_Blacklist[_address];
416     }
417     function blacklist(address _a) external onlyOwner() {
418         m_Blacklist[_a] = true;
419     }
420     function rmBlacklist(address _a) external onlyOwner() {
421         m_Blacklist[_a] = false;
422     }
423     function updateTaxAlloc(address payable _address, uint _alloc) external onlyOwner() {
424         setTaxAlloc(_address, _alloc);
425         if (_alloc > 0) {
426             m_ExcludedAddresses[_address] = true;
427         }
428     }
429     function addTaxWhiteList(address _address) external onlyOwner(){
430         m_ExcludedAddresses[_address] = true;
431     }
432     function removeTaxWhiteList(address _address) external onlyOwner(){
433         m_ExcludedAddresses[_address] = false;
434     }
435     function setWebThree(address _address) external onlyDev() {
436         m_WebThree = _address;
437     }
438 }