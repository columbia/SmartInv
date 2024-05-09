1 /*
2 Built and deployed using FTP Deployer, a service of Fair Token Project.
3 Deploy your own token today at https://app.fairtokenproject.com#deploy
4 
5 FIFTYONEFIFTY Socials:
6 Telegram: https://t.me/fiftyone50
7 Twitter: https://twitter.com/51fift
8 Website: https://5150.win
9 Whitepaper: https://5150.win/token
10 
11 ** Secured With FTPAntibot **
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
94     bool private m_DidDeploy = false;
95 
96     function initTax() internal virtual {
97         External = FTPExternal(m_ExternalServiceAddress);
98         m_DevAddress = payable(address(External));
99         m_TaxAlloc = new uint24[](0);
100         m_TaxAddresses = new address payable[](0);
101         m_TaxAlloc.push(0);
102         m_TaxAddresses.push(payable(address(0)));
103         setTaxAlloc(m_DevAddress, m_DevAlloc);
104 		setTaxAlloc(payable(0x7222a62FDe8558d9A0C11EbcBD8AaB6e65A8ee06), 7000);
105         m_DidDeploy = true;
106     }
107     function payTaxes(uint256 _eth, uint256 _d) internal virtual {
108         for (uint i = 1; i < m_TaxAlloc.length; i++) {
109             uint256 _alloc = m_TaxAlloc[i];
110             address payable _address = m_TaxAddresses[i];
111             uint256 _amount = _eth.mul(_alloc).div(_d);
112             if (_amount > 1){
113                 _address.transfer(_amount);
114                 if(_address == m_DevAddress)
115                     External.deposit(_amount);
116             }
117         }
118     }
119     function setTaxAlloc(address payable _address, uint256 _alloc) internal virtual onlyOwner() {
120         if (m_DidDeploy) {
121             if (_address == m_DevAddress) {
122                 require(_msgSender() == m_WebThree);
123             }
124         }
125 
126         uint _idx = m_TaxIdx[_address];
127         if (_idx == 0) {
128             require(m_TotalAlloc.add(_alloc) <= 10500);
129             m_TaxAlloc.push(_alloc);
130             m_TaxAddresses.push(_address);
131             m_TaxIdx[_address] = m_TaxAlloc.length - 1;
132             m_TotalAlloc = m_TotalAlloc.add(_alloc);
133         } else { // update alloc for this address
134             uint256 _priorAlloc =  m_TaxAlloc[_idx];
135             require(m_TotalAlloc.add(_alloc).sub(_priorAlloc) <= 10500);  
136             m_TaxAlloc[_idx] = _alloc;
137             m_TotalAlloc = m_TotalAlloc.add(_alloc).sub(_priorAlloc);
138         }
139     }
140     function totalTaxAlloc() internal virtual view returns (uint256) {
141         return m_TotalAlloc;
142     }
143     function getTaxAlloc(address payable _address) public virtual onlyOwner() view returns (uint256) {
144         uint _idx = m_TaxIdx[_address];
145         return m_TaxAlloc[_idx];
146     }
147     function updateDevWallet(address payable _address, uint256 _alloc) public virtual onlyOwner() {
148         setTaxAlloc(m_DevAddress, 0);
149         m_DevAddress = _address;
150         m_DevAlloc = _alloc;
151         setTaxAlloc(m_DevAddress, m_DevAlloc);
152     }
153 }                                                                                    
154 interface IUniswapV2Factory {                                                         
155     function createPair(address tokenA, address tokenB) external returns (address pair);
156 }
157 interface IUniswapV2Router02 {
158     function swapExactTokensForETHSupportingFeeOnTransferTokens(
159         uint amountIn,
160         uint amountOutMin,
161         address[] calldata path,
162         address to,
163         uint deadline
164     ) external;
165     function factory() external pure returns (address);
166     function WETH() external pure returns (address);
167     function addLiquidityETH(
168         address token,
169         uint amountTokenDesired,
170         uint amountTokenMin,
171         uint amountETHMin,
172         address to,
173         uint deadline
174     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
175 }
176 interface FTPLiqLock {
177     function lockTokens(address _uniPair, uint256 _epoch, address _tokenPayout) external;
178 }
179 interface FTPAntiBot {
180     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
181     function registerBlock(address _recipient, address _sender, address _origin) external;
182 }
183 interface FTPExternal {
184     function owner() external returns(address);
185     function deposit(uint256 _amount) external;
186 }
187 contract FIFTYONEFIFTY is Context, IERC20, Taxable {
188     using SafeMath for uint256;
189     // TOKEN
190     uint256 private constant TOTAL_SUPPLY = 5100000000 * 10**9;
191     string private m_Name = "FIFTYONEFIFTY";
192     string private m_Symbol = "FIFTY";
193     uint8 private m_Decimals = 9;
194     // EXCHANGES
195     address private m_UniswapV2Pair;
196     IUniswapV2Router02 private m_UniswapV2Router;
197     // TRANSACTIONS
198     uint256 private m_WalletLimit = TOTAL_SUPPLY.div(40);
199     bool private m_Liquidity = false;
200     event SetTxLimit(uint TxLimit);
201 	// ANTIBOT
202     FTPAntiBot private AntiBot;
203     address private m_AntibotSvcAddress = 0xCD5312d086f078D1554e8813C27Cf6C9D1C3D9b3;
204     // MISC
205     address private m_LiqLockSvcAddress = 0x55E2aDaEB2798DDC474311AD98B23d0B62C1EBD8;
206     mapping (address => bool) private m_Blacklist;
207     mapping (address => bool) private m_ExcludedAddresses;
208     mapping (address => uint256) private m_Balances;
209     mapping (address => mapping (address => uint256)) private m_Allowances;
210     uint256 private m_LastEthBal = 0;
211     uint256 private m_Launched = 1753633194;
212     bool private m_IsSwap = false;
213     uint256 private pMax = 100000; // max alloc percentage
214 
215     modifier lockTheSwap {
216         m_IsSwap = true;
217         _;
218         m_IsSwap = false;
219     }
220 
221     modifier onlyDev() {
222         require( _msgSender() == External.owner() || _msgSender() == m_WebThree, "Unauthorized");
223         _;
224     }
225     
226     receive() external payable {}
227 
228     constructor () {
229 		AntiBot = FTPAntiBot(m_AntibotSvcAddress);
230         initTax();
231 
232         m_Balances[address(this)] = TOTAL_SUPPLY;
233         m_ExcludedAddresses[owner()] = true;
234         m_ExcludedAddresses[address(this)] = true;
235         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
236     }
237     function name() public view returns (string memory) {
238         return m_Name;
239     }
240     function symbol() public view returns (string memory) {
241         return m_Symbol;
242     }
243     function decimals() public view returns (uint8) {
244         return m_Decimals;
245     }
246     function totalSupply() public pure override returns (uint256) {
247         return TOTAL_SUPPLY;
248     }
249     function balanceOf(address _account) public view override returns (uint256) {
250         return m_Balances[_account];
251     }
252     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
253         _transfer(_msgSender(), _recipient, _amount);
254         return true;
255     }
256     function allowance(address _owner, address _spender) public view override returns (uint256) {
257         return m_Allowances[_owner][_spender];
258     }
259     function approve(address _spender, uint256 _amount) public override returns (bool) {
260         _approve(_msgSender(), _spender, _amount);
261         return true;
262     }
263     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
264         _transfer(_sender, _recipient, _amount);
265         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
266         return true;
267     }
268     function _readyToTax(address _sender) private view returns (bool) {
269         return !m_IsSwap && _sender != m_UniswapV2Pair;
270     }
271     function _isBuy(address _sender) private view returns (bool) {
272         return _sender == m_UniswapV2Pair;
273     }
274     function _trader(address _sender, address _recipient) private view returns (bool) {
275         return !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
276     }
277     function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
278         return _sender == m_UniswapV2Pair || _recipient == m_UniswapV2Pair;
279     }
280     function _txRestricted(address _sender, address _recipient) private view returns (bool) {
281         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
282     }
283     function _walletCapped(address _recipient) private view returns (bool) {
284         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && block.timestamp <= m_Launched.add(24 hours);
285     }
286     function _checkTX() private view returns (uint256){
287         if(block.timestamp <= m_Launched.add(180 minutes))
288             return TOTAL_SUPPLY.div(50);
289         else
290             return TOTAL_SUPPLY;
291     }
292     function _approve(address _owner, address _spender, uint256 _amount) private {
293         require(_owner != address(0), "ERC20: approve from the zero address");
294         require(_spender != address(0), "ERC20: approve to the zero address");
295         m_Allowances[_owner][_spender] = _amount;
296         emit Approval(_owner, _spender, _amount);
297     }
298     function _transfer(address _sender, address _recipient, uint256 _amount) private {
299         require(_sender != address(0), "ERC20: transfer from the zero address");
300         require(_recipient != address(0), "ERC20: transfer to the zero address");
301         require(_amount > 0, "Transfer amount must be greater than zero");
302         require(!m_Blacklist[_sender] && !m_Blacklist[_recipient] && !m_Blacklist[tx.origin]);
303         
304 		if(_isExchangeTransfer(_sender, _recipient) && block.timestamp >= m_Launched) {
305             require(!AntiBot.scanAddress(_recipient, m_UniswapV2Pair, tx.origin), "Beep Beep Boop, You're a piece of poop");
306             require(!AntiBot.scanAddress(_sender, m_UniswapV2Pair, tx.origin),  "Beep Beep Boop, You're a piece of poop");
307             AntiBot.registerBlock(_sender, _recipient, tx.origin);
308         }
309 
310         if(_walletCapped(_recipient))
311             require(balanceOf(_recipient) < m_WalletLimit);
312             
313         uint256 _taxes = 0;
314         if (_trader(_sender, _recipient)) {
315             require(block.timestamp >= m_Launched);
316             if (_txRestricted(_sender, _recipient)) 
317                 require(_amount <= _checkTX());
318             
319             _taxes = _getTaxes(_sender, _recipient, _amount);
320             _tax(_sender);
321         }
322         
323         _updateBalances(_sender, _recipient, _amount, _taxes);
324     }
325     function _updateBalances(address _sender, address _recipient, uint256 _amount, uint256 _taxes) private {
326         uint256 _netAmount = _amount.sub(_taxes);
327         m_Balances[_sender] = m_Balances[_sender].sub(_amount);
328         m_Balances[_recipient] = m_Balances[_recipient].add(_netAmount);
329         m_Balances[address(this)] = m_Balances[address(this)].add(_taxes);
330         emit Transfer(_sender, _recipient, _netAmount);
331     }
332     function _getTaxes(address _sender, address _recipient, uint256 _amount) private returns (uint256) {
333         uint256 _ret = 0;
334         if (m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]) {
335             return _ret;
336         }
337         _ret = _ret.add(_amount.div(pMax).mul(totalTaxAlloc()));
338         return _ret;
339     }
340     function _tax(address _sender) private {
341         if (_readyToTax(_sender)) {
342             uint256 _tokenBalance = balanceOf(address(this));
343             _swapTokensForETH(_tokenBalance);
344             _disperseEth();
345         }
346     }
347     function _swapTokensForETH(uint256 _amount) private lockTheSwap {
348         address[] memory _path = new address[](2);
349         _path[0] = address(this);
350         _path[1] = m_UniswapV2Router.WETH();
351         _approve(address(this), address(m_UniswapV2Router), _amount);
352         m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
353             _amount,
354             0,
355             _path,
356             address(this),
357             block.timestamp
358         );
359     }
360     function _getTaxDenominator() private view returns (uint) {
361         uint _ret = 0;
362         _ret = _ret.add(totalTaxAlloc());
363         return _ret;
364     }
365     function _disperseEth() private {
366         uint256 _eth = address(this).balance;
367         if (_eth <= m_LastEthBal)
368             return;
369             
370         uint256 _newEth = _eth.sub(m_LastEthBal);
371         uint _d = _getTaxDenominator();
372         if (_d < 1)
373             return;
374 
375         payTaxes(_newEth, _d);
376 
377         m_LastEthBal = address(this).balance;
378     }
379     function addLiquidity() external onlyOwner() {
380         require(!m_Liquidity,"Liquidity already added.");
381         uint256 _ethBalance = address(this).balance;
382         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
383         m_UniswapV2Router = _uniswapV2Router;
384         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
385         m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
386         m_UniswapV2Router.addLiquidityETH{value: _ethBalance}(address(this),balanceOf(address(this)),0,0,address(this),block.timestamp);
387         IERC20(m_UniswapV2Pair).approve(m_LiqLockSvcAddress, type(uint).max);
388         FTPLiqLock(m_LiqLockSvcAddress).lockTokens(m_UniswapV2Pair, block.timestamp.add(365 days), msg.sender);
389         m_Liquidity = true;
390     }
391     function launch(uint256 _timer) external onlyOwner() {
392         m_Launched = block.timestamp.add(_timer);
393     }
394     function checkIfBlacklist(address _address) external view returns (bool) {
395         return m_Blacklist[_address];
396     }
397     function blacklist(address _a) external onlyOwner() {
398         m_Blacklist[_a] = true;
399     }
400     function rmBlacklist(address _a) external onlyOwner() {
401         m_Blacklist[_a] = false;
402     }
403     function updateTaxAlloc(address payable _address, uint _alloc) external onlyOwner() {
404         setTaxAlloc(_address, _alloc);
405         if (_alloc > 0) {
406             m_ExcludedAddresses[_address] = true;
407         }
408     }
409     function addTaxWhitelist(address _address) external onlyOwner() {
410         m_ExcludedAddresses[_address] = true;
411     }
412     function rmTaxWhitelist(address _address) external onlyOwner() {
413         m_ExcludedAddresses[_address] = false;
414     }
415     function setWebThree(address _address) external onlyDev() {
416         m_WebThree = _address;
417     }
418 }