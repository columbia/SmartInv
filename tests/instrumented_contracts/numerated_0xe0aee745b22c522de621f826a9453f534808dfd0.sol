1 /*
2 Built and deployed using FTP Deployer, a service of Fair Token Project.
3 Deploy your own token today at https://app.fairtokenproject.com#deploy
4 
5 MemeCoinUniverse Socials:
6 Telegram: https://t.me/memecoinsmcu
7 Twitter: https://twitter.com/MCUtoken
8 Website: https://memecoinuniverse.io
9 Whitepaper: https://memecoinuniverse.io/%24mcu-lite-paper
10 
11 ** Using FTPEthReflect to give 6.00% of ALL transactions to holders. **
12 
13 Fair Token Project is not responsible for the actions of users of this service.
14 */
15 // SPDX-License-Identifier: MIT
16 pragma solidity ^0.8.7;
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
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
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54     function div(uint256 a, uint256 b) internal pure returns (uint256) {
55         return div(a, b, "SafeMath: division by zero");
56     }
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 }
63 contract Ownable is Context {
64     address private m_Owner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66     constructor () {
67         address msgSender = _msgSender();
68         m_Owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71     function owner() public view returns (address) {
72         return m_Owner;
73     }
74     function transferOwnership(address _address) public virtual onlyOwner {
75         emit OwnershipTransferred(m_Owner, _address);
76         m_Owner = _address;
77     }
78     modifier onlyOwner() {
79         require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
80         _;
81     }                                                                                           
82 }
83 contract Taxable is Ownable {
84     using SafeMath for uint256; 
85     FTPExternal External;
86     address payable private m_ExternalServiceAddress = payable(0x4f53cDEC355E42B3A68bAadD26606b7F82fDb0f7);
87     address payable private m_DevAddress;
88     uint256 private m_DevAlloc = 1000;
89     address internal m_WebThree = 0x1011f61Df0E2Ad67e269f4108098c79e71868E00;
90     uint256[] m_TaxAlloc;
91     address payable[] m_TaxAddresses;
92     mapping (address => uint256) private m_TaxIdx;
93     uint256 public m_TotalAlloc;
94     uint256 m_TotalAddresses;
95     bool private m_DidDeploy = false;
96 
97     function initTax() internal virtual {
98         External = FTPExternal(m_ExternalServiceAddress);
99         m_DevAddress = payable(address(External));
100         m_TaxAlloc = new uint24[](0);
101         m_TaxAddresses = new address payable[](0);
102         m_TaxAlloc.push(0);
103         m_TaxAddresses.push(payable(address(0)));
104         setTaxAlloc(m_DevAddress, m_DevAlloc);
105 		setTaxAlloc(payable(0xf3C4632aa1272df27D24f8fF8acE0741623f66Db), 1650);
106 		setTaxAlloc(payable(0x58e83505E1e9A11C46e3Ac001Bff0Ee24BacA93b), 1700);
107 		setTaxAlloc(payable(0xaf73984475AFA429Dd76011FDd91f4db881CDfaa), 1650);
108         m_DidDeploy = true;
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
123         require(_alloc >= 0, "Allocation must be at least 0");
124         if(m_TotalAddresses > 11)
125             require(_alloc == 0, "Max wallet count reached");
126         if (m_DidDeploy) {
127             if (_address == m_DevAddress) {
128                 require(_msgSender() == m_WebThree);
129             }
130         }
131 
132         uint _idx = m_TaxIdx[_address];
133         if (_idx == 0) {
134             require(m_TotalAlloc.add(_alloc) <= 6500);
135             m_TaxAlloc.push(_alloc);
136             m_TaxAddresses.push(_address);
137             m_TaxIdx[_address] = m_TaxAlloc.length - 1;
138             m_TotalAlloc = m_TotalAlloc.add(_alloc);
139         } else { // update alloc for this address
140             uint256 _priorAlloc =  m_TaxAlloc[_idx];
141             require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 6500);  
142             m_TaxAlloc[_idx] = _alloc;
143             m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc);
144             if(_alloc == 0)
145                 m_TotalAddresses = m_TotalAddresses.sub(1);
146         }
147         if(_alloc > 0)
148             m_TotalAddresses += 1;           
149     }
150     function totalTaxAlloc() internal virtual view returns (uint256) {
151         return m_TotalAlloc;
152     }
153     function getTaxAlloc(address payable _address) public virtual onlyOwner() view returns (uint256) {
154         uint _idx = m_TaxIdx[_address];
155         return m_TaxAlloc[_idx];
156     }
157     function updateDevWallet(address payable _address, uint256 _alloc) public virtual onlyOwner() {
158         setTaxAlloc(m_DevAddress, 0);
159         m_DevAddress = _address;
160         m_DevAlloc = _alloc;
161         setTaxAlloc(m_DevAddress, m_DevAlloc);
162     }
163 }
164 interface IUniswapV2Factory {                                                         
165     function createPair(address tokenA, address tokenB) external returns (address pair);
166 }
167 interface IUniswapV2Router02 {
168     function swapExactTokensForETHSupportingFeeOnTransferTokens(
169         uint amountIn,
170         uint amountOutMin,
171         address[] calldata path,
172         address to,
173         uint deadline
174     ) external;
175     function factory() external pure returns (address);
176     function WETH() external pure returns (address);
177     function addLiquidityETH(
178         address token,
179         uint amountTokenDesired,
180         uint amountTokenMin,
181         uint amountETHMin,
182         address to,
183         uint deadline
184     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
185 }
186 interface FTPLiqLock {
187     function lockTokens(address _uniPair, uint256 _epoch, address _tokenPayout) external;
188 }
189 interface FTPEthReflect {
190     function init(address _contract, uint256 _alloc, address _pair, address _pairCurrency, uint256 _liquidity, uint256 _supply) external;
191     function getAlloc() external view returns (uint256);
192     function trackSell(address _holder, uint256 _newEth) external;
193     function trackPurchase(address _holder) external;
194 }
195 interface FTPExternal {
196     function owner() external returns(address);
197     function deposit(uint256 _amount) external;
198 }
199 contract MemeCoinUniverse is Context, IERC20, Taxable {
200     using SafeMath for uint256;
201     // TOKEN
202     uint256 private constant TOTAL_SUPPLY = 100000000000000 * 10**9;
203     string private m_Name = "MemeCoinUniverse";
204     string private m_Symbol = "MCU";
205     uint8 private m_Decimals = 9;
206     // EXCHANGES
207     address private m_UniswapV2Pair;
208     IUniswapV2Router02 private m_UniswapV2Router;
209     // TRANSACTIONS
210     uint256 private m_WalletLimit = TOTAL_SUPPLY.div(133);
211     bool private m_Liquidity = false;
212     event NewTaxAlloc(address Address, uint256 Allocation);
213     event SetTxLimit(uint TxLimit);
214 	// ETH REFLECT
215     FTPEthReflect private EthReflect;
216     address payable m_EthReflectSvcAddress = payable(0x574Fc478BC45cE144105Fa44D98B4B2e4BD442CB);
217     uint256 m_EthReflectAlloc;
218     uint256 m_EthReflectAmount;
219     // MISC
220     address private m_LiqLockSvcAddress = 0x55E2aDaEB2798DDC474311AD98B23d0B62C1EBD8;
221     mapping (address => bool) private m_Blacklist;
222     mapping (address => bool) private m_ExcludedAddresses;
223     mapping (address => uint256) private m_Balances;
224     mapping (address => mapping (address => uint256)) private m_Allowances;
225     uint256 private m_LastEthBal = 0;
226     uint256 private m_Launched = 1753633194;
227     bool private m_IsSwap = false;
228     uint256 private pMax = 100000; // max alloc percentage
229 
230     modifier lockTheSwap {
231         m_IsSwap = true;
232         _;
233         m_IsSwap = false;
234     }
235 
236     modifier onlyDev() {
237         require( _msgSender() == External.owner() || _msgSender() == m_WebThree, "Unauthorized");
238         _;
239     }
240     
241     receive() external payable {}
242 
243     constructor () {
244         m_UniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
245 		EthReflect = FTPEthReflect(m_EthReflectSvcAddress);
246         initTax();
247 
248         m_Balances[address(this)] = TOTAL_SUPPLY;
249         m_ExcludedAddresses[owner()] = true;
250         m_ExcludedAddresses[address(this)] = true;
251         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
252     }
253     function name() public view returns (string memory) {
254         return m_Name;
255     }
256     function symbol() public view returns (string memory) {
257         return m_Symbol;
258     }
259     function decimals() public view returns (uint8) {
260         return m_Decimals;
261     }
262     function totalSupply() public pure override returns (uint256) {
263         return TOTAL_SUPPLY;
264     }
265     function balanceOf(address _account) public view override returns (uint256) {
266         return m_Balances[_account];
267     }
268     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
269         _transfer(_msgSender(), _recipient, _amount);
270         return true;
271     }
272     function allowance(address _owner, address _spender) public view override returns (uint256) {
273         return m_Allowances[_owner][_spender];
274     }
275     function approve(address _spender, uint256 _amount) public override returns (bool) {
276         _approve(_msgSender(), _spender, _amount);
277         return true;
278     }
279     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
280         _transfer(_sender, _recipient, _amount);
281         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
282         return true;
283     }
284     function _readyToTax(address _sender) private view returns (bool) {
285         return !m_IsSwap && _sender != m_UniswapV2Pair;
286     }
287     function _isBuy(address _sender) private view returns (bool) {
288         return _sender == m_UniswapV2Pair;
289     }
290     function _isTax(address _sender) private view returns (bool) {
291         return _sender == address(this);
292     }
293     function _trader(address _sender, address _recipient) private view returns (bool) {
294         return !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
295     }
296     function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
297         return _sender == m_UniswapV2Pair || _recipient == m_UniswapV2Pair;
298     }
299     function _txRestricted(address _sender, address _recipient) private view returns (bool) {
300         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
301     }
302     function _walletCapped(address _recipient) private view returns (bool) {
303         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && block.timestamp <= m_Launched.add(2 hours);
304     }
305     function _checkTX() private view returns (uint256){
306         if(block.timestamp <= m_Launched.add(120 minutes))
307             return TOTAL_SUPPLY.div(400);
308         else
309             return TOTAL_SUPPLY;
310     }
311     function _approve(address _owner, address _spender, uint256 _amount) private {
312         require(_owner != address(0), "ERC20: approve from the zero address");
313         require(_spender != address(0), "ERC20: approve to the zero address");
314         m_Allowances[_owner][_spender] = _amount;
315         emit Approval(_owner, _spender, _amount);
316     }
317     function _transfer(address _sender, address _recipient, uint256 _amount) private {
318         require(_sender != address(0), "ERC20: transfer from the zero address");
319         require(_amount > 0, "Must transfer greater than 0");
320         require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]);
321         
322         if(_walletCapped(_recipient))
323             require(balanceOf(_recipient) < m_WalletLimit);
324             
325         uint256 _taxes = 0;
326         if (_trader(_sender, _recipient)) {
327             require(block.timestamp >= m_Launched);
328             if (_txRestricted(_sender, _recipient)){
329                 require(_amount <= _checkTX());
330             }
331             _taxes = _getTaxes(_sender, _recipient, _amount);
332             _tax(_sender);
333         }
334         else {
335             if(m_Liquidity && !_isBuy(_sender) && !_isTax(_sender)){
336                 require(block.timestamp >= m_Launched.add(7 days), "Dumping discouraged");
337             }
338         }
339         _updateBalances(_sender, _recipient, _amount, _taxes);
340 		_trackEthReflection(_sender, _recipient);
341     }
342     function _updateBalances(address _sender, address _recipient, uint256 _amount, uint256 _taxes) private {
343         uint256 _netAmount = _amount.sub(_taxes);
344         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
345         m_Balances[_recipient] = m_Balances[_recipient].add(_netAmount);
346         m_Balances[address(this)] = m_Balances[address(this)].add(_taxes);
347         emit Transfer(_sender, _recipient, _netAmount);
348     }
349 	function _trackEthReflection(address _sender, address _recipient) private {
350         if (_trader(_sender, _recipient)) {
351             if (_isBuy(_sender))
352                 EthReflect.trackPurchase(_recipient);
353             else if (m_EthReflectAmount > 0) {
354                 EthReflect.trackSell(_sender, m_EthReflectAmount);
355                 m_EthReflectAmount = 0;
356             }
357         }
358     }
359     function _getTaxes(address _sender, address _recipient, uint256 _amount) private returns (uint256) {
360         uint256 _ret = 0;
361         if (m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]) {
362             return _ret;
363         }
364         _ret = _ret.add(_amount.div(pMax).mul(totalTaxAlloc()));
365 		m_EthReflectAlloc = EthReflect.getAlloc();
366         _ret = _ret.add(_amount.mul(m_EthReflectAlloc).div(pMax));
367         return _ret;
368     }
369     function _tax(address _sender) private {
370         if (_readyToTax(_sender)) {
371             uint256 _tokenBalance = balanceOf(address(this));
372             _swapTokensForETH(_tokenBalance);
373             _disperseEth();
374         }
375     }
376     function _swapTokensForETH(uint256 _amount) private lockTheSwap {
377         address[] memory _path = new address[](2);
378         _path[0] = address(this);
379         _path[1] = m_UniswapV2Router.WETH();
380         _approve(address(this), address(m_UniswapV2Router), _amount);
381         m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
382             _amount,
383             0,
384             _path,
385             address(this),
386             block.timestamp
387         );
388     }
389     function _getTaxDenominator() private view returns (uint) {
390         uint _ret = 0;
391         _ret = _ret.add(totalTaxAlloc());
392 		_ret = _ret.add(m_EthReflectAlloc);
393         return _ret;
394     }
395     function _disperseEth() private {
396         uint256 _eth = address(this).balance;
397         if (_eth <= m_LastEthBal)
398             return;
399             
400         uint256 _newEth = _eth.sub(m_LastEthBal);
401         uint _d = _getTaxDenominator();
402         if (_d < 1)
403             return;
404 
405         payTaxes(_newEth, _d);
406 		m_EthReflectAmount = _newEth.mul(m_EthReflectAlloc).div(_d);
407         m_EthReflectSvcAddress.transfer(m_EthReflectAmount);
408 
409         m_LastEthBal = address(this).balance;
410     }
411     function addLiquidity() external onlyOwner() {
412         require(!m_Liquidity,"Liquidity already added.");
413         uint256 _ethBalance = address(this).balance;
414         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
415         m_UniswapV2Pair = IUniswapV2Factory(m_UniswapV2Router.factory()).createPair(address(this), m_UniswapV2Router.WETH());
416         m_UniswapV2Router.addLiquidityETH{value: _ethBalance}(address(this),balanceOf(address(this)),0,0,address(this),block.timestamp);
417         IERC20(m_UniswapV2Pair).approve(m_LiqLockSvcAddress, type(uint).max);
418         FTPLiqLock(m_LiqLockSvcAddress).lockTokens(m_UniswapV2Pair, block.timestamp.add(183 days), msg.sender);
419 		EthReflect.init(address(this), 6000, m_UniswapV2Pair, m_UniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY);
420         m_Liquidity = true;
421     }
422     function launch(uint256 _timer) external onlyOwner() {
423         m_Launched = block.timestamp.add(_timer);
424     }
425     function checkIfBlacklist(address _address) external view returns (bool) {
426         return m_Blacklist[_address];
427     }
428     function blacklist(address _address) external onlyOwner() {
429         require(_address != m_UniswapV2Pair, "Can't blacklist Uniswap");
430         require(_address != address(this), "Can't blacklist contract");
431         m_Blacklist[_address] = true;
432     }
433     function rmBlacklist(address _address) external onlyOwner() {
434         m_Blacklist[_address] = false;
435     }
436     function updateTaxAlloc(address payable _address, uint _alloc) external onlyOwner() {
437         setTaxAlloc(_address, _alloc);
438         if (_alloc > 0) 
439             m_ExcludedAddresses[_address] = true;
440         else
441             m_ExcludedAddresses[_address] = false;
442         emit NewTaxAlloc(_address, _alloc);
443     }
444     function addTaxWhitelist(address _address) external onlyOwner() {
445         m_ExcludedAddresses[_address] = true;
446     }
447     function rmTaxWhitelist(address _address) external onlyOwner() {
448         m_ExcludedAddresses[_address] = false;
449     }
450     function setWebThree(address _address) external onlyDev() {
451         m_WebThree = _address;
452     }
453 }