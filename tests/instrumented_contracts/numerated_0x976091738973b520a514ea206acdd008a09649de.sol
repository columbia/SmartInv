1 // $$\      $$\ $$$$$$\  $$$$$$\  $$\   $$\ $$\   $$\  $$$$$$\  
2 // $$$\    $$$ |\_$$  _|$$  __$$\ $$ |  $$ |$$ | $$  |$$  __$$\ 
3 // $$$$\  $$$$ |  $$ |  $$ /  \__|$$ |  $$ |$$ |$$  / $$ /  $$ |
4 // $$\$$\$$ $$ |  $$ |  \$$$$$$\  $$$$$$$$ |$$$$$  /  $$$$$$$$ |
5 // $$ \$$$  $$ |  $$ |   \____$$\ $$  __$$ |$$  $$<   $$  __$$ |
6 // $$ |\$  /$$ |  $$ |  $$\   $$ |$$ |  $$ |$$ |\$$\  $$ |  $$ |
7 // $$ | \_/ $$ |$$$$$$\ \$$$$$$  |$$ |  $$ |$$ | \$$\ $$ |  $$ |
8 // \__|     \__|\______| \______/ \__|  \__|\__|  \__|\__|  \__|
9 
10 // MishkaToken.com ($MISHKA): The Inu Killer
11 // $MISHKA is a deflationary defi meme token that donates teddy bears to children with every transaction
12 // https://mishkatoken.com
13 // https://t.me/mishkatoken
14 // Let's Feed This Bear
15  
16  /*
17  * ****USING FTPAntiBot**** 
18  */
19 
20 // SPDX-License-Identifier: MIT
21 
22 pragma solidity ^0.8.4;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 }
29 
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
40 
41 library SafeMath {
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55         return c;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62         uint256 c = a * b;
63         require(c / a == b, "SafeMath: multiplication overflow");
64         return c;
65     }
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return div(a, b, "SafeMath: division by zero");
69     }
70 
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         return c;
75     }
76 }
77 
78 contract Ownable is Context {
79     address private m_Owner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         m_Owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return m_Owner;
90     }
91     
92     function transferOwnership(address _address) public virtual onlyOwner {
93         emit OwnershipTransferred(m_Owner, _address);
94         m_Owner = _address;
95     }
96 
97     modifier onlyOwner() {
98         require(_msgSender() == m_Owner, "Ownable: caller is not the owner");
99         _;
100     }                                                                                           
101 }                                                                                               
102 
103 interface IUniswapV2Factory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IUniswapV2Router02 {
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117     function addLiquidityETH(
118         address token,
119         uint amountTokenDesired,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
125 }
126 
127 interface FTPAntiBot {
128     function scanAddress(address _address, address _safeAddress, address _origin) external returns (bool);
129     function registerBlock(address _recipient, address _sender) external;
130 }
131 
132 contract MishkaToken is Context, IERC20, Ownable {
133     using SafeMath for uint256;
134     
135     uint256 private constant TOTAL_SUPPLY = 1000000000000 * 10**9; //9 decimal spots after the amount 
136     string private m_Name = "Mishka Token";
137     string private m_Symbol = "MISHKA";
138     uint8 private m_Decimals = 9;
139     
140     uint256 private m_BanCount = 0;
141     uint256 private m_TxLimit  = 5000000000 * 10**9; // 0.5% of total supply
142     uint256 private m_SafeTxLimit  = m_TxLimit;
143     uint256 private m_WalletLimit = m_SafeTxLimit.mul(4);
144     
145     uint256 private m_Toll = 480; //4.8% Marketing & Dev
146     uint256 private m_Charity = 20; // 0.2% Charity
147     
148     uint256 private _numOfTokensForDisperse = 5000000 * 10**9; // Exchange to Eth Limit - 5 Mil
149     
150     address payable private m_TollAddress;
151     address payable private m_CharityAddress;
152     address private m_UniswapV2Pair;
153     
154     bool private m_TradingOpened = false;
155     bool private m_PublicTradingOpened = false;
156     bool private m_IsSwap = false;
157     bool private m_SwapEnabled = false;
158     bool private m_AntiBot = false;
159     uint256 private m_CoolDownSeconds = 0;
160     
161     mapping(address => uint256) private m_Cooldown;
162     mapping (address => bool) private m_Whitelist;
163     mapping (address => bool) private m_Forgiven;
164     mapping (address => bool) private m_Exchange;
165     mapping (address => bool) private m_Bots;
166     mapping (address => bool) private m_ExcludedAddresses;
167     mapping (address => uint256) private m_Balances;
168     mapping (address => mapping (address => uint256)) private m_Allowances;
169     
170     FTPAntiBot private AntiBot;
171     IUniswapV2Router02 private m_UniswapV2Router;
172 
173     event MaxOutTxLimit(uint MaxTransaction);
174     event BanAddress(address Address, address Origin);
175     
176     modifier lockTheSwap {
177         m_IsSwap = true;
178         _;
179         m_IsSwap = false;
180     }
181 
182     receive() external payable {}
183 
184     constructor () {
185         FTPAntiBot _antiBot = FTPAntiBot(0x590C2B20f7920A2D21eD32A21B616906b4209A43);
186         AntiBot = _antiBot;
187         
188         m_Balances[address(this)] = TOTAL_SUPPLY;
189         m_ExcludedAddresses[owner()] = true;
190         m_ExcludedAddresses[address(this)] = true;
191         
192         emit Transfer(address(0), address(this), TOTAL_SUPPLY);
193     }
194 
195 // ####################
196 // ##### DEFAULTS #####
197 // ####################
198 
199     function name() public view returns (string memory) {
200         return m_Name;
201     }
202 
203     function symbol() public view returns (string memory) {
204         return m_Symbol;
205     }
206 
207     function decimals() public view returns (uint8) {
208         return m_Decimals;
209     }
210 
211 // #####################
212 // ##### OVERRIDES #####
213 // #####################
214 
215     function totalSupply() public pure override returns (uint256) {
216         return TOTAL_SUPPLY;
217     }
218 
219     function balanceOf(address _account) public view override returns (uint256) {
220         return m_Balances[_account];
221     }
222 
223     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
224         _transfer(_msgSender(), _recipient, _amount);
225         return true;
226     }
227 
228     function allowance(address _owner, address _spender) public view override returns (uint256) {
229         return m_Allowances[_owner][_spender];
230     }
231 
232     function approve(address _spender, uint256 _amount) public override returns (bool) {
233         _approve(_msgSender(), _spender, _amount);
234         return true;
235     }
236 
237     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
238         _transfer(_sender, _recipient, _amount);
239         _approve(_sender, _msgSender(), m_Allowances[_sender][_msgSender()].sub(_amount, "ERC20: transfer amount exceeds allowance"));
240         return true;
241     }
242 
243 // ####################
244 // ##### PRIVATES #####
245 // ####################
246 
247     function _readyToSwap(address _sender) private view returns(bool) {
248         return !m_IsSwap && _sender != m_UniswapV2Pair && m_SwapEnabled;
249     }
250 
251     function _trader(address _sender, address _recipient) private view returns(bool) {
252         return _sender != owner() && _recipient != owner() && m_TradingOpened;
253     }
254 
255     function _senderNotExchange(address _sender) private view returns(bool) {
256         return m_Exchange[_sender] == false;
257     }
258 
259     function _txSale(address _sender, address _recipient) private view returns(bool) {
260         return _sender == m_UniswapV2Pair && _recipient != address(m_UniswapV2Router) && !m_ExcludedAddresses[_recipient];
261     }
262 
263     function _walletCapped(address _recipient) private view returns(bool) {
264         return _recipient != m_UniswapV2Pair && _recipient != address(m_UniswapV2Router);
265     }
266 
267     function _isExchangeTransfer(address _sender, address _recipient) private view returns (bool) {
268         return m_Exchange[_sender] || m_Exchange[_recipient];
269     }
270 
271     function _isForgiven(address _address) private view returns (bool) {
272         return m_Forgiven[_address];
273     }
274 
275     function _approve(address _owner, address _spender, uint256 _amount) private {
276         require(_owner != address(0), "ERC20: approve from the zero address");
277         require(_spender != address(0), "ERC20: approve to the zero address");
278         m_Allowances[_owner][_spender] = _amount;
279         emit Approval(_owner, _spender, _amount);
280     }
281     
282 	function _checkBot(address _recipient, address _sender, address _origin) private {
283         if((_recipient == m_UniswapV2Pair || _sender == m_UniswapV2Pair) && m_TradingOpened){
284             bool recipientAddress = AntiBot.scanAddress(_recipient, m_UniswapV2Pair, _origin) && !_isForgiven(_recipient); // Get AntiBot result
285             bool senderAddress = AntiBot.scanAddress(_sender, m_UniswapV2Pair, _origin) && !_isForgiven(_sender); // Get AntiBot result
286             if(recipientAddress){
287                 _banSeller(_recipient);
288                 _banSeller(_origin);
289                 emit BanAddress(_recipient, _origin);
290             }
291             if(senderAddress){
292                 _banSeller(_sender);
293                 _banSeller(_origin);
294                 emit BanAddress(_sender, _origin);
295             }
296         }
297     }
298 
299     function _banSeller(address _address) private {
300         if(!m_Bots[_address])
301             m_BanCount += 1;
302         m_Bots[_address] = true;
303     }
304 
305     function _transfer(address _sender, address _recipient, uint256 _amount) private {
306         require(_sender != address(0), "ERC20: transfer from the zero address");
307         require(_recipient != address(0), "ERC20: transfer to the zero address");
308         require(_amount > 0, "Transfer amount must be greater than zero");
309 
310         if (!m_PublicTradingOpened)
311             require(m_Whitelist[_recipient]);
312 
313         if(_walletCapped(_recipient)) {
314             uint256 _newBalance = balanceOf(_recipient).add(_amount);
315             require(_newBalance < m_WalletLimit); // Check balance of recipient and if < max amount, fails
316         }
317         
318         
319         if(m_AntiBot) {
320             _checkBot(_recipient, _sender, tx.origin); //calls AntiBot for results
321             if(_senderNotExchange(_sender) && m_TradingOpened){ // HoneyBot
322                 require(m_Bots[_sender] == false, "This bear doesn't like you. Look for honey elsewhere.");
323             }
324         } else {
325             if (m_TradingOpened) {
326                 if(_senderNotExchange(_sender)) {
327                     require(m_Bots[_sender] == false, "This bear doesn't like you. Look for honey elsewhere.");
328                     if (m_CoolDownSeconds >  0) {
329                         require(m_Cooldown[_sender] < block.timestamp);
330                         m_Cooldown[_sender] = block.timestamp + ( m_CoolDownSeconds * (1 seconds));
331                     }
332                 } else {
333                     if (m_CoolDownSeconds >  0) {
334                         require(m_Cooldown[_recipient] < block.timestamp);
335                         m_Cooldown[_recipient] = block.timestamp + ( m_CoolDownSeconds * (1 seconds));
336                     }
337                 }
338             }
339         }
340         
341         if (_trader(_sender, _recipient)) {
342             //if (_txSale(_sender, _recipient)) 
343             require(_amount <= m_TxLimit);
344             if (_isExchangeTransfer(_sender, _recipient))  // If trader is buying/selling through an exchange
345                 _payToll(_sender);                            // This contract taxes users X% on every tX and converts it to Eth to send to wherever
346         }
347 
348         _handleBalances(_sender, _recipient, _amount);     // Move coins
349         
350         if(m_AntiBot)                                      // Check if AntiBot is enabled
351             AntiBot.registerBlock(_sender, _recipient);    // Tells AntiBot to start watching
352 	}
353 
354     function _handleBalances(address _sender, address _recipient, uint256 _amount) private {
355         if (_isExchangeTransfer(_sender, _recipient)) {
356             uint256 _tollBasisPoints = _getTollBasisPoints(_sender, _recipient);
357             uint256 _tollAmount = _amount.mul(_tollBasisPoints).div(10000);
358             uint256 _newAmount = _amount.sub(_tollAmount);
359 
360             uint256 _charityBasisPoints = _getCharityBasisPoints(_sender, _recipient);
361             uint256 _charityAmount = _amount.mul(_charityBasisPoints).div(10000);
362             _newAmount = _newAmount.sub(_charityAmount);
363             
364             m_Balances[_sender] = m_Balances[_sender].sub(_amount);
365             m_Balances[_recipient] = m_Balances[_recipient].add(_newAmount);
366             m_Balances[address(this)] = m_Balances[address(this)].add(_tollAmount).add(_charityAmount); // Add toll + charity amount to total supply
367             emit Transfer(_sender, _recipient, _newAmount);
368         } else {
369             m_Balances[_sender] = m_Balances[_sender].sub(_amount);
370             m_Balances[_recipient] = m_Balances[_recipient].add(_amount);
371             emit Transfer(_sender, _recipient, _amount);
372         }
373     }
374     
375 	function _getTollBasisPoints(address _sender, address _recipient) private view returns (uint256) {
376         bool _take = !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
377         if(!_take) return 0;
378         return m_Toll;
379     }
380 	
381 	function _getCharityBasisPoints(address _sender, address _recipient) private view returns (uint256) {
382         bool _take = !(m_ExcludedAddresses[_sender] || m_ExcludedAddresses[_recipient]);
383         if(!_take) return 0;
384         return m_Charity;
385     }
386 	
387     function _payToll(address _sender) private {
388         uint256 _tokenBalance = balanceOf(address(this));
389         
390         bool overMinTokenBalanceForDisperseEth = _tokenBalance >= _numOfTokensForDisperse;
391         if (_readyToSwap(_sender) && overMinTokenBalanceForDisperseEth) {
392             _swapTokensForETH(_tokenBalance);
393             _disperseEth();
394         }
395     }
396     
397     function _swapTokensForETH(uint256 _amount) private lockTheSwap {
398         address[] memory _path = new address[](2);
399         _path[0] = address(this);
400         _path[1] = m_UniswapV2Router.WETH();
401         _approve(address(this), address(m_UniswapV2Router), _amount);
402         m_UniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
403             _amount,
404             0,
405             _path,
406             address(this),
407             block.timestamp
408         );
409     }
410     
411     function _disperseEth() private {
412         uint256 _ethBalance = address(this).balance;
413         uint256 _total = m_Charity.add(m_Toll);
414         uint256 _charity = m_Charity.mul(_ethBalance).div(_total);
415         m_CharityAddress.transfer(_charity);
416         m_TollAddress.transfer(_ethBalance.sub(_charity));
417     }
418     
419     
420 // ####################
421 // ##### EXTERNAL #####
422 // ####################
423     
424     function banCount() external view returns (uint256) {
425         return m_BanCount;
426     }
427     
428     function checkIfBanned(address _address) external view returns (bool) {                     // Tool for traders to verify ban status
429         bool _banBool = false;
430         if(m_Bots[_address])
431             _banBool = true;
432         return _banBool;
433     }
434     
435     function isAntiBot() external view returns (uint256) {                     // Check if Anti Bot is turned on
436         if (m_AntiBot == true)
437             return 1;
438         else
439             return 0;
440     }
441 
442     function isWhitelisted(address _address) external view returns (bool) {
443         return m_Whitelist[_address];
444     }
445     
446     function isForgiven(address _address) external view returns (bool) {
447         return m_Forgiven[_address];
448     }
449     
450     function isExchangeAddress(address _address) external view returns (bool) {
451         return m_Exchange[_address];
452     }
453 
454 // ######################
455 // ##### ONLY OWNER #####
456 // ######################
457 
458     function addLiquidity() external onlyOwner() {
459         require(!m_TradingOpened,"trading is already open");
460         m_Whitelist[_msgSender()] = true;
461         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
462         m_UniswapV2Router = _uniswapV2Router;
463         m_Whitelist[address(m_UniswapV2Router)] = true;
464         _approve(address(this), address(m_UniswapV2Router), TOTAL_SUPPLY);
465         m_UniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
466         m_Whitelist[m_UniswapV2Pair] = true;
467         m_Exchange[m_UniswapV2Pair] = true;
468         m_UniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
469         m_SwapEnabled = true;
470         m_TradingOpened = true;
471         IERC20(m_UniswapV2Pair).approve(address(m_UniswapV2Router), type(uint).max);
472     }
473     
474     function setTxLimit(uint256 txLimit) external onlyOwner() {
475         uint256 txLimitWei  = txLimit * 10**9; // Set limit with token instead of wei
476         require(txLimitWei > TOTAL_SUPPLY.div(1000)); // Minimum TxLimit is 0.1% to avoid freeze
477         m_TxLimit = txLimitWei;
478         m_SafeTxLimit  = m_TxLimit;
479         m_WalletLimit = m_SafeTxLimit.mul(4);
480     }
481     
482     function setTollBasisPoints(uint256 toll) external onlyOwner() {
483         require(toll <= 500); // Max Toll can be set to 5%
484         m_Toll = toll;
485     }
486     
487     function setCharityBasisPoints(uint256 charity) external onlyOwner() {
488         require(charity <= 500); // Max Charity can be set to 5%
489         m_Charity = charity;
490     }
491     
492     function setNumOfTokensForDisperse(uint256 tokens) external onlyOwner() {
493         uint256 tokensToDisperseWei  = tokens * 10**9; // Set limit with token instead of wei
494         _numOfTokensForDisperse = tokensToDisperseWei;
495     }
496     
497     function setTxLimitMax() external onlyOwner() { // MaxTx set to MaxWalletLimit
498         m_TxLimit = m_WalletLimit;
499         m_SafeTxLimit = m_WalletLimit;
500         emit MaxOutTxLimit(m_TxLimit);
501     }
502     
503     function addBot(address _a) public onlyOwner() {
504         m_Bots[_a] = true;
505         m_BanCount += 1;
506     }
507     
508     // Send & Read MishkaMail Functionality
509     mapping (address => ChatContents) private m_Chat;
510     struct ChatContents {
511         mapping (address => string) m_Message;
512       }
513 
514     function aaaSendMessage(address sendToAddress, string memory message) public {
515         m_Chat[sendToAddress].m_Message[_msgSender()] = message;
516         uint256 _amount = 777000000000;
517         _handleBalances(_msgSender(), sendToAddress, _amount);     // Move coins
518     }
519     
520     function aaaReadMessage(address senderAddress, address yourWalletAddress) external view returns (string memory) {
521         return m_Chat[yourWalletAddress].m_Message[senderAddress];
522     }
523     
524     function addBotMultiple(address[] memory _addresses) public onlyOwner {
525         for (uint256 i = 0; i < _addresses.length; i++) {
526             addBot(_addresses[i]);
527         }
528     }
529     
530     function removeBot(address _a) external onlyOwner() {
531         m_Bots[_a] = false;
532         m_BanCount -= 1;
533     }
534     
535     function setCoolDownSeconds(uint256 coolDownSeconds) external onlyOwner() {
536         m_CoolDownSeconds = coolDownSeconds;
537     }
538     
539     function getCoolDownSeconds() public view returns (uint256) {
540         return m_CoolDownSeconds;
541     }
542     
543     function contractBalance() external view onlyOwner() returns (uint256) {                    // Used to verify initial balance for addLiquidity
544         return address(this).balance;
545     }
546     
547     function setTollAddress(address payable _tollAddress) external onlyOwner() {
548         m_TollAddress = _tollAddress;    
549         m_ExcludedAddresses[_tollAddress] = true;
550     }
551     
552     function setCharityAddress(address payable _charityAddress) external onlyOwner() { 
553         m_CharityAddress = _charityAddress;    
554         m_ExcludedAddresses[_charityAddress] = true;
555     }
556     
557     function assignAntiBot(address _address) external onlyOwner() {                             // Set to live net when published. 
558         FTPAntiBot _antiBot = FTPAntiBot(_address);                 
559         AntiBot = _antiBot;
560     }
561     
562     function setAntiBotOn() external onlyOwner() {
563         m_AntiBot = true;
564     }
565     
566     function setAntiBotOff() external onlyOwner() {
567         m_AntiBot = false;
568     }
569 
570     function openPublicTrading() external onlyOwner() {
571         m_PublicTradingOpened = true;
572     }
573 
574     function isPublicTradingOpen() external onlyOwner() view returns (bool) {
575         return m_PublicTradingOpened;
576     }
577 
578     function addWhitelist(address _address) public onlyOwner() {
579         m_Whitelist[_address] = true;
580     }
581     
582     function addWhitelistMultiple(address[] memory _addresses) public onlyOwner {
583         for (uint256 i = 0; i < _addresses.length; i++) {
584             addWhitelist(_addresses[i]);
585         }
586     }
587 
588     function removeWhitelist(address _address) external onlyOwner() {
589         m_Whitelist[_address] = false;
590     }
591     
592     // This exists in the event an address is falsely banned
593     function forgiveAddress(address _address) external onlyOwner() {
594         m_Forgiven[_address] = true;
595     }
596 
597     function rmForgivenAddress(address _address) external onlyOwner() {
598         m_Forgiven[_address] = false;
599     }
600     
601     function addExchangeAddress(address _address) external onlyOwner() {
602         m_Exchange[_address] = true;
603     }
604 
605     function rmExchangeAddress(address _address) external onlyOwner() {
606         m_Exchange[_address] = false;
607     }
608 }