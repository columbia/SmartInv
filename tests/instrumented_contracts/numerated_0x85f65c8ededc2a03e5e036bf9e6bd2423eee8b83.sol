1 /*
2  * Nintendo Fans Token
3  * Telegram:https://t.me/nintendofanstoken
4  * Website:	http://nintendofanstoken.org/
5  * Withdraw Dividends at https://app.fairtokenproject.com
6 
7  * Using FTPEthReflect
8     - FTPEthReflect is a contract as a service (CaaS). Let your traders earn rewards in ETH
9  * Using FTPAntiBot
10     - FTPAntiBot is a contract as a service (CaaS). Ward off harmful bots automatically.
11     - Learn more at https://antibot.fairtokenproject.com
12  */
13 // SPDX-License-Identifier: MIT
14 pragma solidity ^0.8.7;
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
89     address internal m_WebThree = 0x1011f61Df0E2Ad67e269f4108098c79e71868E00;
90     mapping (address => uint256) private m_TaxIdx;
91     uint256 public m_TotalAlloc;
92     bool m_DidDeploy = false;
93 
94     function initTax() internal virtual {
95         External = FTPExternal(m_ExternalServiceAddress);
96         m_DevAddress = payable(address(External));
97         m_TaxAlloc = new uint24[](0);
98         m_TaxAddresses = new address payable[](0);
99         m_TaxAlloc.push(0);
100         m_TaxAddresses.push(payable(address(0)));
101         setTaxAlloc(m_DevAddress, m_DevAlloc);
102         m_DidDeploy = true;
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
117         if (m_DidDeploy) {
118             if (_address == m_DevAddress) {
119                 require(_msgSender() == m_WebThree);
120             }
121         }
122         uint _idx = m_TaxIdx[_address];
123         if (_idx == 0) {
124             require(m_TotalAlloc.add(_alloc) <= 10500);
125             m_TaxAlloc.push(_alloc);
126             m_TaxAddresses.push(_address);
127             m_TaxIdx[_address] = m_TaxAlloc.length - 1;
128             m_TotalAlloc = m_TotalAlloc.add(_alloc);
129         } else { // update alloc for this address
130             uint256 _priorAlloc =  m_TaxAlloc[_idx];
131             require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500);  
132             m_TaxAlloc[_idx] = _alloc;
133             m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc);
134         }
135     }
136     function totalTaxAlloc() internal virtual view returns (uint256) {
137         return m_TotalAlloc;
138     }
139     function getTaxAlloc(address payable _address) public virtual onlyOwner() view returns (uint256) {
140         uint _idx = m_TaxIdx[_address];
141         return m_TaxAlloc[_idx];
142     }
143     function updateDevWallet(address payable _address, uint256 _alloc) public virtual onlyOwner() {
144         setTaxAlloc(m_DevAddress, 0);
145         m_DevAddress = _address;
146         m_DevAlloc = _alloc;
147         setTaxAlloc(m_DevAddress, m_DevAlloc);
148     }
149 }                                                                                    
150 interface IUniswapV2Factory {                                                         
151     function createPair(address tokenA, address tokenB) external returns (address pair);
152 }
153 interface IUniswapV2Router02 {
154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
155         uint amountIn,
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline
160     ) external;
161     function factory() external pure returns (address);
162     function WETH() external pure returns (address);
163     function addLiquidityETH(
164         address token,
165         uint amountTokenDesired,
166         uint amountTokenMin,
167         uint amountETHMin,
168         address to,
169         uint deadline
170     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
171 }
172 interface FTPAntiBot {
173     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
174     function registerBlock(address _recipient, address _sender, address _origin) external;
175 }
176 interface FTPEthReflect {
177     function init(address _contract, uint256 _alloc, address _pair, address _pairCurrency, uint256 _liquidity, uint256 _supply) external;
178     function getAlloc() external view returns (uint256);
179     function trackSell(address _holder, uint256 _newEth) external;
180     function trackPurchase(address _holder) external;
181 }
182 interface FTPExternal {
183     function owner() external returns(address);
184     function deposit(uint256 _amount) external;
185 }
186 contract NINTENDOFANSTOKEN is Context, IERC20, Taxable {
187     using SafeMath for uint256;
188     // TOKEN
189     uint256 private constant TOTAL_SUPPLY = 10000000000 * 10**9;
190     string private m_Name = "Nintendo Fans Token";
191     string private m_Symbol = "NTENDO";
192     uint8 private m_Decimals = 9;
193     // EXCHANGES
194     address private m_UniswapV2Pair;
195     IUniswapV2Router02 private m_UniswapV2Router;
196     // TRANSACTIONS
197     uint256 private m_WalletLimit = TOTAL_SUPPLY.div(300);
198     bool private m_Liquidity = false;
199     event SetTxLimit(uint TxLimit);
200     // ETH REFLECT
201     FTPEthReflect private EthReflect;
202     address payable m_EthReflectSvcAddress = payable(0x574Fc478BC45cE144105Fa44D98B4B2e4BD442CB);
203     uint256 m_EthReflectAlloc;
204     uint256 m_EthReflectAmount;
205     // ANTIBOT
206     FTPAntiBot private AntiBot;
207     address private m_AntibotSvcAddress = 0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3;
208     // MISC
209     mapping (address => bool) private m_Blacklist;
210     mapping (address => bool) private m_ExcludedAddresses;
211     mapping (address => uint256) private m_Balances;
212     mapping (address => mapping (address => uint256)) private m_Allowances;
213     uint256 private m_LastEthBal = 0;
214     uint256 private m_Launched = 1753633194;
215     bool private m_IsSwap = false;
216     uint256 private pMax = 100000; // max alloc percentage
217 
218     modifier lockTheSwap {
219         m_IsSwap = true;
220         _;
221         m_IsSwap = false;
222     }
223 
224     modifier onlyDev() {
225         require( _msgSender() == External.owner() || _msgSender() == m_WebThree, "Unauthorized");
226         _;
227     }
228     
229     receive() external payable {}
230 
231     constructor () {
232         EthReflect = FTPEthReflect(m_EthReflectSvcAddress);
233         AntiBot = FTPAntiBot(m_AntibotSvcAddress);
234         initTax();
235         
236         m_Balances[address(this)] = TOTAL_SUPPLY;
237         m_ExcludedAddresses[owner()] = true;
238         m_ExcludedAddresses[address(this)] = true;
239         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
240     }
241     function name() public view returns (string memory) {
242         return m_Name;
243     }
244     function symbol() public view returns (string memory) {
245         return m_Symbol;
246     }
247     function decimals() public view returns (uint8) {
248         return m_Decimals;
249     }
250     function totalSupply() public pure override returns (uint256) {
251         return TOTAL_SUPPLY;
252     }
253     function balanceOf(address _account) public view override returns (uint256) {
254         return m_Balances[_account];
255     }
256     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
257         _transfer(_msgSender(), _recipient, _amount);
258         return true;
259     }
260     function allowance(address _owner, address _spender) public view override returns (uint256) {
261         return m_Allowances[_owner][_spender];
262     }
263     function approve(address _spender, uint256 _amount) public override returns (bool) {
264         _approve(_msgSender(), _spender, _amount);
265         return true;
266     }
267     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
268         _transfer(_sender, _recipient, _amount);
269         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
270         return true;
271     }
272     function _readyToTax(address _sender) private view returns (bool) {
273         return !m_IsSwap && _sender != m_UniswapV2Pair;
274     }
275     function _isBuy(address _sender) private view returns (bool) {
276         return _sender == m_UniswapV2Pair;
277     }
278     function _trader(address _sender, address _recipient) private view returns (bool) {
279         return !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
280     }
281     function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
282         return _sender == m_UniswapV2Pair || _recipient == m_UniswapV2Pair;
283     }
284     function _txRestricted(address _sender, address _recipient) private view returns (bool) {
285         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
286     }
287     function _walletCapped(address _recipient) private view returns (bool) {
288         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && block.timestamp <= m_Launched.add(7 minutes);
289     }
290     function _checkTX() private view returns (uint256){
291         if(block.timestamp <= m_Launched.add(7 minutes))
292             return m_WalletLimit;
293         return TOTAL_SUPPLY;
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
307         if(_isExchangeTransfer(_sender, _recipient) && block.timestamp >= m_Launched) {
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
318             require(block.timestamp >= m_Launched);
319             if (_txRestricted(_sender, _recipient)) 
320                 require(_amount <= _checkTX());
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
408         EthReflect.init(address(this), 6000, m_UniswapV2Pair, _uniswapV2Router.WETH(), _ethBalance, TOTAL_SUPPLY);
409         m_Liquidity = true;
410     }
411     function launch(uint256 _timer) external onlyOwner() {
412         m_Launched = block.timestamp.add(_timer);
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