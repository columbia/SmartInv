1 //   _    _ _   _                __ _                            
2 //  | |  (_) | | |              / _(_)                           
3 //  | | ___| |_| |_ ___ _ __   | |_ _ _ __   __ _ _ __   ___ ___ 
4 //  | |/ / | __| __/ _ \ '_ \  |  _| | '_ \ / _` | '_ \ / __/ _ \
5 //  |   <| | |_| ||  __/ | | |_| | | | | | | (_| | | | | (_|  __/
6 //  |_|\_\_|\__|\__\___|_| |_(_)_| |_|_| |_|\__,_|_| |_|\___\___|
7 //
8 //  LIQUID : a token with deep floor liquidity & ever-rising floor price
9 //
10 //  https://www.KittenSwap.org
11 //
12 //  https://www.Kitten.finance
13 //
14 pragma solidity ^0.5.17;
15 
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint) {
18         uint c = a + b;
19         require(c >= a, "SafeMath: addition overflow");
20 
21         return c;
22     }
23     function sub(uint a, uint b) internal pure returns (uint) {
24         return sub(a, b, "SafeMath: subtraction overflow");
25     }
26     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
27         require(b <= a, errorMessage);
28         uint c = a - b;
29 
30         return c;
31     }
32     function mul(uint a, uint b) internal pure returns (uint) {
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint c = a * b;
38         require(c / a == b, "SafeMath: multiplication overflow");
39 
40         return c;
41     }
42     function div(uint a, uint b) internal pure returns (uint) {
43         return div(a, b, "SafeMath: division by zero");
44     }
45     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
46         // Solidity only automatically asserts when dividing by 0
47         require(b > 0, errorMessage);
48         uint c = a / b;
49 
50         return c;
51     }
52 }
53 
54 contract ERC20Detailed {
55     string private _name;
56     string private _symbol;
57     uint8 private _decimals;
58 
59     constructor (string memory name, string memory symbol, uint8 decimals) public {
60         _name = name;
61         _symbol = symbol;
62         _decimals = decimals;
63     }
64     function name() public view returns (string memory) {
65         return _name;
66     }
67     function symbol() public view returns (string memory) {
68         return _symbol;
69     }
70     function decimals() public view returns (uint8) {
71         return _decimals;
72     }
73 }
74 
75 ////////////////////////////////////////////////////////////////////////////////
76 
77 interface IERC20 {
78     function balanceOf(address account) external view returns (uint);
79 }
80 
81 ////////////////////////////////////////////////////////////////////////////////
82 
83 contract LIQUID is ERC20Detailed 
84 {
85     address public DEPLOYER = 0xD8d71629950cE53d7E9F94619b09058D9D9f5866;
86     uint public constant INITIAL_EthReserve = 2100 * (10 ** 18);
87     uint public constant INITIAL_TokenReserve = 21000 * (10 ** 18);
88     
89     ////////////////////////////////////////////////////////////////////////////////
90     
91     using SafeMath for uint;
92     
93     uint public MARKET_OPEN_STAGE = 0; // 0: closed; 1: open;
94     
95     uint public MARKET_BUY_ETH_LIMIT = (10 ** 18) / 1000; // 0: ignore; x: limit purchase amt;
96     
97     address public MARKET_WHITELIST_TOKEN = address(0);
98     uint public MARKET_WHITELIST_TOKEN_BP = 10 * 10000; // 0: ignore; x: require y TOKEN to hold [x * y / 10000] LIQUID
99     
100     uint public MARKET_WHITELIST_BASE_AMT = 10 * (10 ** 18); // can always own some LIQUID
101 
102     ////////////////////////////////////////////////////////////////////////////////
103     
104     uint public gTransferBurnBP = 60;
105     uint public gSellBurnBP = 60;
106     uint public gSellTreasuryBP = 0;
107     
108     // special BurnBP for some addresses
109     mapping (address => uint) public gTransferFromBurnBP;
110     mapping (address => uint) public gTransferToBurnBP;
111     
112     ////////////////////////////////////////////////////////////////////////////////
113     
114     uint public gContractCheckBuyLevel = 3; // 0: no check; 1: methodA; 2: methodB; 3: both;
115     uint public gContractCheckSellLevel = 3; // 0: no check; 1: methodA; 2: methodB; 3: both;
116     
117     mapping (address => uint) public gContractWhitelist; // 0: disableALL; 1: disableBUY; 2: disableSELL; 3: allowALL;
118     
119     function isContract(address account) internal view returns (bool) {
120         // This method relies in extcodesize, which returns 0 for contracts in
121         // construction, since the code is only stored at the end of the
122         // constructor execution.
123 
124         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
125         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
126         // for accounts without code, i.e. `keccak256('')`
127         bytes32 codehash;
128         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
129         // solhint-disable-next-line no-inline-assembly
130         assembly { codehash := extcodehash(account) }
131         return (codehash != 0x0 && codehash != accountHash);
132     }
133 
134     ////////////////////////////////////////////////////////////////////////////////
135 
136     address constant tokenFactoryAddr = 0x1111111111111111111111111111111111111111;
137     
138     address public govAddr;
139     
140     address public treasuryAddr;
141     uint public treasuryAmtTotal = 0;
142 
143     constructor () public ERC20Detailed("LIQUID", "LIQUID", 18) {
144         if (msg.sender == DEPLOYER) {
145             govAddr = msg.sender;
146             treasuryAddr = msg.sender;
147             _mint(tokenFactoryAddr, INITIAL_TokenReserve);
148         }        
149     }
150 
151     ////////////////////////////////////////////////////////////////////////////////
152     
153     function _msgSender() internal view returns (address payable) {
154         return msg.sender;
155     }
156     
157     event Transfer(address indexed from, address indexed to, uint value);
158     event Approval(address indexed owner, address indexed spender, uint value);
159     
160     mapping (address => uint) private _balances;
161     mapping (address => mapping (address => uint)) private _allowances;
162 
163     uint private _totalSupply;
164     function totalSupply() public view returns (uint) {
165         return _totalSupply;
166     }
167     function balanceOf(address account) public view returns (uint) {
168         return _balances[account];
169     }
170     function transfer(address recipient, uint amount) public returns (bool) {
171         _transfer(_msgSender(), recipient, amount);
172         return true;
173     }
174     function allowance(address owner, address spender) public view returns (uint) {
175         return _allowances[owner][spender];
176     }
177     function approve(address spender, uint amount) public returns (bool) {
178         _approve(_msgSender(), spender, amount);
179         return true;
180     }
181     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
182         _transfer(sender, recipient, amount);
183         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
184         return true;
185     }
186     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
187         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
188         return true;
189     }
190     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
191         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
192         return true;
193     }
194     function _transfer(address sender, address recipient, uint amount) internal {
195         require(sender != address(0), "ERC20: transfer from the zero address");
196         require(recipient != address(0), "ERC20: transfer to the zero address");
197 
198         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
199         
200         _balances[recipient] = _balances[recipient].add(amount);
201         emit Transfer(sender, recipient, amount);
202 
203         //------------------------------------------------------------------------------
204 
205         // 0         ===> default BurnBP
206         // 1 ~ 10000 ===> customized BurnBP
207         // >10000    ===> zero BurnBP
208         
209         uint fromBurnBP = gTransferFromBurnBP[sender];
210         if (fromBurnBP == 0)
211             fromBurnBP = gTransferBurnBP;
212         else if (fromBurnBP > 10000)
213             fromBurnBP = 0;
214 
215         uint toBurnBP = gTransferToBurnBP[recipient];
216         if (toBurnBP == 0)
217             toBurnBP = gTransferBurnBP;
218         else if (toBurnBP > 10000)
219             toBurnBP = 0;
220 
221         uint BurnBP = fromBurnBP; // BurnBP = min(fromBurnBP, toBurnBP)
222         if (BurnBP > toBurnBP)
223             BurnBP = toBurnBP;
224         
225         if (BurnBP > 0) {
226             uint burnAmt = amount.mul(BurnBP).div(10000);
227             _burn(recipient, burnAmt);
228         }
229     }
230     function _transferRawNoBurn(address sender, address recipient, uint amount) internal {
231         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
232         
233         _balances[recipient] = _balances[recipient].add(amount);
234         emit Transfer(sender, recipient, amount);
235     }    
236     function _mint(address account, uint amount) internal {
237         require(account != address(0), "ERC20: mint to the zero address");
238 
239         _totalSupply = _totalSupply.add(amount);
240         _balances[account] = _balances[account].add(amount);
241         emit Transfer(address(0), account, amount);
242     }
243     function _burn(address account, uint amount) internal {
244         require(account != address(0), "ERC20: burn from the zero address");
245         
246         if (amount == 0) return;
247         if (_balances[account] == 0) return;
248 
249         if (account != tokenFactoryAddr) {
250 
251             _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
252             emit Transfer(account, address(0), amount);
253 
254             //------------------------------------------------------------------------------
255             // AutoBoost : because totalSupply is reduced, we can burn tokenReserve to boost price
256             // Check our Medium on https://www.Kitten.finance for details
257             //------------------------------------------------------------------------------
258             
259             uint TokenReserve = _balances[tokenFactoryAddr];
260             
261             if (_totalSupply > TokenReserve) { // shall always satisfy
262                 uint extraBurn = TokenReserve.mul(amount).div(_totalSupply.sub(TokenReserve));
263                 _balances[tokenFactoryAddr] = TokenReserve.sub(extraBurn);
264                 emit Transfer(tokenFactoryAddr, address(0), extraBurn);
265                 
266                 _totalSupply = _totalSupply.sub(amount).sub(extraBurn);
267             } else {
268                 _totalSupply = _totalSupply.sub(amount);
269             }
270         }
271     }
272     function _approve(address owner, address spender, uint amount) internal {
273         require(owner != address(0), "ERC20: approve from the zero address");
274         require(spender != address(0), "ERC20: approve to the zero address");
275 
276         _allowances[owner][spender] = amount;
277         emit Approval(owner, spender, amount);
278     }    
279     
280     ////////////////////////////////////////////////////////////////////////////////
281 
282     function getEthReserve() public view returns (uint) {
283         return INITIAL_EthReserve.add(address(this).balance).sub(treasuryAmtTotal);
284     }
285 
286     function getTokenReserve() public view returns (uint) {
287         return _balances[tokenFactoryAddr];
288     }
289     
290     event BuyToken(address indexed user, uint tokenAmt, uint ethAmt);
291     event SellToken(address indexed user, uint tokenAmt, uint ethAmt);
292 
293     function buyToken(uint minTokenAmt, uint expireTimestamp) external payable 
294     {
295         address user = msg.sender;
296 
297         if (gContractWhitelist[user] < 2) { // 0: disableALL; 1: disableBUY; 2: disableSELL; 3: allowALL;
298             if (gContractCheckBuyLevel % 2 == 1) require(!isContract(user), '!human'); // 0: no check; 1: methodA; 2: methodB; 3: both;
299             if (gContractCheckBuyLevel >= 2) require(user == tx.origin, '!human');     // 0: no check; 1: methodA; 2: methodB; 3: both;
300         }
301 
302         require ((MARKET_OPEN_STAGE > 0) || (user == govAddr), '!market'); // govAddr can test contract before market open
303         require (msg.value > 0, '!eth');
304         require (minTokenAmt > 0, '!minToken');
305         require ((expireTimestamp == 0) || (block.timestamp <= expireTimestamp), '!expire');
306         require ((MARKET_BUY_ETH_LIMIT == 0) || (msg.value <= MARKET_BUY_ETH_LIMIT), '!ethLimit');
307         
308         //------------------------------------------------------------------------------
309         
310         uint newEthReserve = INITIAL_EthReserve.add(address(this).balance).sub(treasuryAmtTotal);
311         uint oldEthReserve = newEthReserve.sub(msg.value);
312 
313         uint oldTokenReserve = _balances[tokenFactoryAddr];
314         uint newTokenReserve = (oldEthReserve.mul(oldTokenReserve).add(newEthReserve / 2)).div(newEthReserve);
315         
316         uint outTokenAmt = oldTokenReserve.sub(newTokenReserve);
317         require (outTokenAmt > 0, '!outToken');
318         require (outTokenAmt >= minTokenAmt, "KittenSwap: INSUFFICIENT_OUTPUT_AMOUNT");
319         
320         if ((MARKET_WHITELIST_TOKEN_BP > 0) && (MARKET_WHITELIST_TOKEN != address(0))) 
321         {
322             uint amtWhitelistToken = IERC20(MARKET_WHITELIST_TOKEN).balanceOf(user);
323             uint amtLimit = amtWhitelistToken.mul(MARKET_WHITELIST_TOKEN_BP).div(10000);
324             
325             if (amtLimit < MARKET_WHITELIST_BASE_AMT) {
326                 amtLimit = MARKET_WHITELIST_BASE_AMT;
327             }
328             
329             require (_balances[user].add(outTokenAmt) <= amtLimit, '!need-more-whitelist-token');
330         }
331 
332         _transferRawNoBurn(tokenFactoryAddr, user, outTokenAmt);
333 
334         //------------------------------------------------------------------------------
335         
336         emit BuyToken(user, outTokenAmt, msg.value);
337     }
338     
339     function sellToken(uint tokenAmt, uint minEthAmt, uint expireTimestamp) external 
340     {
341         address payable user = msg.sender;
342 
343         if (gContractWhitelist[user] % 2 == 0) { // 0: disableALL; 1: disableBUY; 2: disableSELL; 3: allowALL;
344             if (gContractCheckSellLevel % 2 == 1) require(!isContract(user), '!human'); // 0: no check; 1: methodA; 2: methodB; 3: both;
345             if (gContractCheckSellLevel >= 2) require(user == tx.origin, '!human');     // 0: no check; 1: methodA; 2: methodB; 3: both;
346         }
347 
348         require (tokenAmt > 0, '!token');
349         require (minEthAmt > 0, '!minEth');
350         require ((expireTimestamp == 0) || (block.timestamp <= expireTimestamp), '!expire');
351         
352         uint burnAmt = tokenAmt.mul(gSellBurnBP).div(10000);
353         _burn(user, burnAmt);
354         uint tokenAmtAfterBurn = tokenAmt.sub(burnAmt);
355 
356         //------------------------------------------------------------------------------
357 
358         uint oldEthReserve = INITIAL_EthReserve.add(address(this).balance).sub(treasuryAmtTotal);
359         uint oldTokenReserve = _balances[tokenFactoryAddr];
360 
361         uint newTokenReserve = oldTokenReserve.add(tokenAmtAfterBurn);
362         uint newEthReserve = (oldEthReserve.mul(oldTokenReserve).add(newTokenReserve / 2)).div(newTokenReserve);
363         
364         uint outEthAmt = oldEthReserve.sub(newEthReserve);
365         require (outEthAmt > 0, '!outEth');
366         require (outEthAmt >= minEthAmt, "KittenSwap: INSUFFICIENT_OUTPUT_AMOUNT");
367 
368         _transferRawNoBurn(user, tokenFactoryAddr, tokenAmtAfterBurn);
369 
370         //------------------------------------------------------------------------------
371 
372         if (gSellTreasuryBP > 0) 
373         {
374             uint treasuryAmt = outEthAmt.mul(gSellTreasuryBP).div(10000);
375             treasuryAmtTotal = treasuryAmtTotal.add(treasuryAmt);
376             user.transfer(outEthAmt.sub(treasuryAmt));
377         } 
378         else
379         {
380             user.transfer(outEthAmt);
381         }
382         
383         emit SellToken(user, tokenAmt, outEthAmt);
384     }
385     
386     ////////////////////////////////////////////////////////////////////////////////
387     
388     modifier govOnly() 
389     {
390     	require(msg.sender == govAddr, "!gov");
391     	_;
392     }
393     
394     function govTransferAddr(address newAddr) external govOnly 
395     {
396     	require(newAddr != address(0), "!addr");
397     	govAddr = newAddr;
398     }
399     
400     function govOpenMarket() external govOnly
401     {
402         MARKET_OPEN_STAGE = 1;
403     }
404 
405     function govSetTreasury(address newAddr) external govOnly
406     {
407     	require(newAddr != address(0), "!addr");
408     	treasuryAddr = newAddr;
409     }    
410     
411     function govSetBurn(uint transferBurnBP, uint sellBurnBP, uint sellTreasuryBP) external govOnly
412     {
413         require (transferBurnBP <= 60);
414         require (sellBurnBP <= 60);
415         require (sellTreasuryBP <= 30);
416         require (sellTreasuryBP <= sellBurnBP);
417         require (sellBurnBP.add(sellTreasuryBP) <= 60);
418         
419         gTransferBurnBP = transferBurnBP;
420         gSellBurnBP = sellBurnBP;
421         gSellTreasuryBP = sellTreasuryBP;
422     }
423     
424     function govSetBurnForAddress(address addr, uint transferFromBurnBP, uint transferToBurnBP) external govOnly
425     {
426         // 0         ===> default BurnBP
427         // 1 ~ 10000 ===> customized BurnBP
428         // 10001     ===> zero BurnBP
429         require (transferFromBurnBP <= 10001);
430         require (transferToBurnBP <= 10001);
431         
432         gTransferFromBurnBP[addr] = transferFromBurnBP;
433         gTransferToBurnBP[addr] = transferToBurnBP;
434     }
435 
436     function govSetContractCheckLevel(uint buyLevel, uint sellLevel) external govOnly
437     {
438         gContractCheckBuyLevel = buyLevel;
439         gContractCheckSellLevel = sellLevel;
440     }
441     function govSetContractWhiteList(address addr, uint state) external govOnly
442     {
443         gContractWhitelist[addr] = state;
444     }
445     
446     function govSetBuyLimit(uint new_MARKET_BUY_ETH_LIMIT) external govOnly 
447     {
448         MARKET_BUY_ETH_LIMIT = new_MARKET_BUY_ETH_LIMIT;
449     }
450 
451     function govSetWhitelistToken(address new_MARKET_WHITELIST_TOKEN, uint new_MARKET_WHITELIST_TOKEN_BP) external govOnly 
452     {
453         MARKET_WHITELIST_TOKEN = new_MARKET_WHITELIST_TOKEN;
454         MARKET_WHITELIST_TOKEN_BP = new_MARKET_WHITELIST_TOKEN_BP;
455     }
456     
457     function govSetWhitelistBaseAmt(uint new_MARKET_WHITELIST_BASE_AMT) external govOnly 
458     {
459         MARKET_WHITELIST_BASE_AMT = new_MARKET_WHITELIST_BASE_AMT;
460     }    
461     
462     ////////////////////////////////////////////////////////////////////////////////
463 
464     modifier treasuryOnly() 
465     {
466     	require(msg.sender == treasuryAddr, "!treasury");
467     	_;
468     }    
469     
470     function treasurySend(uint amt) external treasuryOnly
471     {
472         require(amt <= treasuryAmtTotal);
473 
474         treasuryAmtTotal = treasuryAmtTotal.sub(amt);
475         
476         address payable _treasuryAddr = address(uint160(treasuryAddr));
477         _treasuryAddr.transfer(amt);
478     }
479 }