1 pragma solidity ^0.4.16;
2 
3 contract SafeMath{
4 
5   // math operations with safety checks that throw on error
6   // small gas improvement
7 
8   function safeMul(uint256 a, uint256 b) internal returns (uint256){
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16   
17   function safeDiv(uint256 a, uint256 b) internal returns (uint256){
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     // uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return a / b;
22   }
23   
24   function safeSub(uint256 a, uint256 b) internal returns (uint256){
25     assert(b <= a);
26     return a - b;
27   }
28   
29   function safeAdd(uint256 a, uint256 b) internal returns (uint256){
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 
35   // mitigate short address attack
36   // https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34
37   modifier onlyPayloadSize(uint numWords){
38      assert(msg.data.length >= numWords * 32 + 4);
39      _;
40   }
41 
42 }
43 
44 
45 contract Token{ // ERC20 standard
46 
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
49     function balanceOf(address _owner) constant returns (uint256 balance);
50     function transfer(address _to, uint256 _value) returns (bool success);
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
52     function approve(address _spender, uint256 _value) returns (bool success);
53     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
54 
55 }
56 
57 
58 contract StandardToken is Token, SafeMath{
59 
60     uint256 public totalSupply;
61 
62     function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool success){
63         require(_to != address(0));
64         require(balances[msg.sender] >= _value && _value > 0);
65         balances[msg.sender] = safeSub(balances[msg.sender], _value);
66         balances[_to] = safeAdd(balances[_to], _value);
67         Transfer(msg.sender, _to, _value);
68         return true;
69     }
70 
71     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success){
72         require(_to != address(0));
73         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
74         balances[_from] = safeSub(balances[_from], _value);
75         balances[_to] = safeAdd(balances[_to], _value);
76         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
77         Transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function balanceOf(address _owner) constant returns (uint256 balance){
82         return balances[_owner];
83     }
84     
85     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86     function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success){
87         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
88         allowed[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 
93     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) returns (bool success){
94         require(allowed[msg.sender][_spender] == _oldValue);
95         allowed[msg.sender][_spender] = _newValue;
96         Approval(msg.sender, _spender, _newValue);
97         return true;
98     }
99 
100     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
101         return allowed[_owner][_spender];
102     }
103 
104     // this creates an array with all balances
105     mapping (address => uint256) balances;
106     mapping (address => mapping (address => uint256)) allowed;
107 
108 }
109 
110 
111 contract EDEX is StandardToken{
112 
113     // public variables of the token
114 
115     string public name = "Equadex";
116     string public symbol = "EDEX";
117     uint256 public decimals = 18;
118     
119     // reachable if max amount raised
120     uint256 public maxSupply = 100000000e18;
121     
122     // ICO starting and ending blocks, can be changed as needed
123     uint256 public icoStartBlock;
124     // icoEndBlock = icoStartBlock + 345,600 blocks for 2 months ICO
125     uint256 public icoEndBlock;
126 
127     // set the wallets with different levels of authority
128     address public mainWallet;
129     address public secondaryWallet;
130     
131     // time to wait between secondaryWallet price updates, mainWallet can update without restrictions
132     uint256 public priceUpdateWaitingTime = 1 hours;
133 
134     uint256 public previousUpdateTime = 0;
135     
136     // strucure of price
137     PriceEDEX public currentPrice;
138     uint256 public minInvestment = 0.01 ether;
139     
140     // for tokens allocated to the team
141     address public grantVestedEDEXContract;
142     bool private grantVestedEDEXSet = false;
143     
144     // halt the crowdsale should any suspicious behavior of a third-party be identified
145     // tokens will be locked for trading until they are listed on exchanges
146     bool public haltICO = false;
147     bool public setTrading = false;
148 
149     // maps investor address to a liquidation request
150     mapping (address => Liquidation) public liquidations;
151     // maps previousUpdateTime to the next price
152     mapping (uint256 => PriceEDEX) public prices;
153     // maps verified addresses
154     mapping (address => bool) public verified;
155 
156     event Verification(address indexed investor);
157     event LiquidationCall(address indexed investor, uint256 amountTokens);
158     event Liquidations(address indexed investor, uint256 amountTokens, uint256 etherAmount);
159     event Buy(address indexed investor, address indexed beneficiary, uint256 ethValue, uint256 amountTokens);
160     event PrivateSale(address indexed investor, uint256 amountTokens);
161     event PriceEDEXUpdate(uint256 topInteger, uint256 bottomInteger);
162     event AddLiquidity(uint256 etherAmount);
163     event RemoveLiquidity(uint256 etherAmount);
164     
165     // for price updates as a rational number
166     struct PriceEDEX{
167         uint256 topInteger;
168         uint256 bottomInteger;
169     }
170 
171     struct Liquidation{
172         uint256 tokens;
173         uint256 time;
174     }
175 
176     // grantVestedEDEXContract and mainWallet can transfer to allow team allocations
177     modifier isSetTrading{
178         require(setTrading || msg.sender == mainWallet || msg.sender == grantVestedEDEXContract);
179         _;
180     }
181 
182     modifier onlyVerified{
183         require(verified[msg.sender]);
184         _;
185     }
186 
187     modifier onlyMainWallet{
188         require(msg.sender == mainWallet);
189         _;
190     }
191 
192     modifier onlyControllingWallets{
193         require(msg.sender == secondaryWallet || msg.sender == mainWallet);
194         _;
195     }
196 
197     modifier only_if_secondaryWallet{
198         if (msg.sender == secondaryWallet) _;
199     }
200     modifier require_waited{
201         require(safeSub(now, priceUpdateWaitingTime) >= previousUpdateTime);
202         _;
203     }
204     modifier only_if_increase (uint256 newTopInteger){
205         if (newTopInteger > currentPrice.topInteger) _;
206     }
207 
208     function EDEX(address secondaryWalletInput, uint256 priceTopIntegerInput, uint256 startBlockInput, uint256 endBlockInput){
209         require(secondaryWalletInput != address(0));
210         require(endBlockInput > startBlockInput);
211         require(priceTopIntegerInput > 0);
212         mainWallet = msg.sender;
213         secondaryWallet = secondaryWalletInput;
214         verified[mainWallet] = true;
215         verified[secondaryWallet] = true;
216         // priceTopIntegerInput = 800,000 for 1 ETH = 800 EDEX
217         currentPrice = PriceEDEX(priceTopIntegerInput, 1000);
218         // icoStartBlock should be around block number 5,709,200 = June 1st 2018
219         icoStartBlock = startBlockInput;
220         // icoEndBlock = icoStartBlock + 345,600 blocks
221         icoEndBlock = endBlockInput;
222         previousUpdateTime = now;
223     }
224 
225     function setGrantVestedEDEXContract(address grantVestedEDEXContractInput) external onlyMainWallet{
226         require(grantVestedEDEXContractInput != address(0));
227         grantVestedEDEXContract = grantVestedEDEXContractInput;
228         verified[grantVestedEDEXContract] = true;
229         grantVestedEDEXSet = true;
230     }
231 
232     function updatePriceEDEX(uint256 newTopInteger) external onlyControllingWallets{
233         require(newTopInteger > 0);
234         require_limited_change(newTopInteger);
235         currentPrice.topInteger = newTopInteger;
236         // maps time to new PriceEDEX
237         prices[previousUpdateTime] = currentPrice;
238         previousUpdateTime = now;
239         PriceEDEXUpdate(newTopInteger, currentPrice.bottomInteger);
240     }
241 
242     function require_limited_change (uint256 newTopInteger) private only_if_secondaryWallet require_waited only_if_increase(newTopInteger){
243         uint256 percentage_diff = 0;
244         percentage_diff = safeMul(newTopInteger, 100) / currentPrice.topInteger;
245         percentage_diff = safeSub(percentage_diff, 100);
246         // secondaryWallet can increase price by 20% maximum once every priceUpdateWaitingTime
247         require(percentage_diff <= 20);
248     }
249 
250     function updatePriceBottomInteger(uint256 newBottomInteger) external onlyMainWallet{
251         require(block.number > icoEndBlock);
252         require(newBottomInteger > 0);
253         currentPrice.bottomInteger = newBottomInteger;
254         // maps time to new Price
255         prices[previousUpdateTime] = currentPrice;
256         previousUpdateTime = now;
257         PriceEDEXUpdate(currentPrice.topInteger, newBottomInteger);
258     }
259 
260     function tokenAllocation(address investor, uint256 amountTokens) private{
261         require(grantVestedEDEXSet);
262         // the 15% allocated to the team
263         uint256 teamAllocation = safeMul(amountTokens, 1764705882352941) / 1e16;
264         uint256 newTokens = safeAdd(amountTokens, teamAllocation);
265         require(safeAdd(totalSupply, newTokens) <= maxSupply);
266         totalSupply = safeAdd(totalSupply, newTokens);
267         balances[investor] = safeAdd(balances[investor], amountTokens);
268         balances[grantVestedEDEXContract] = safeAdd(balances[grantVestedEDEXContract], teamAllocation);
269     }
270 
271     function privateSaleTokens(address investor, uint amountTokens) external onlyMainWallet{
272         require(block.number < icoEndBlock);
273         require(investor != address(0));
274         verified[investor] = true;
275         tokenAllocation(investor, amountTokens);
276         Verification(investor);
277         PrivateSale(investor, amountTokens);
278     }
279 
280     function verifyInvestor(address investor) external onlyControllingWallets{
281         verified[investor] = true;
282         Verification(investor);
283     }
284     
285     // blacklists bot addresses using ICO whitelisted addresses
286     function removeVerifiedInvestor(address investor) external onlyControllingWallets{
287         verified[investor] = false;
288         Verification(investor);
289     }
290 
291     function buy() external payable{
292         buyTo(msg.sender);
293     }
294 
295     function buyTo(address investor) public payable onlyVerified{
296         require(!haltICO);
297         require(investor != address(0));
298         require(msg.value >= minInvestment);
299         require(block.number >= icoStartBlock && block.number < icoEndBlock);
300         uint256 icoBottomInteger = icoBottomIntegerPrice();
301         uint256 tokensToBuy = safeMul(msg.value, currentPrice.topInteger) / icoBottomInteger;
302         tokenAllocation(investor, tokensToBuy);
303         // send ether to mainWallet
304         mainWallet.transfer(msg.value);
305         Buy(msg.sender, investor, msg.value, tokensToBuy);
306     }
307 
308     // bonus scheme during ICO, 1 ETH = 800 EDEX for 1st 20 days, 1 ETH = 727 EDEX for 2nd 20 days, 1 ETH = 667 EDEX for 3rd 20 days
309     function icoBottomIntegerPrice() public constant returns (uint256){
310         uint256 icoDuration = safeSub(block.number, icoStartBlock);
311         uint256 bottomInteger;
312         // icoDuration < 115,200 blocks = 20 days
313         if (icoDuration < 115200){
314             return currentPrice.bottomInteger;
315         }
316         // icoDuration < 230,400 blocks = 40 days
317         else if (icoDuration < 230400 ){
318             bottomInteger = safeMul(currentPrice.bottomInteger, 110) / 100;
319             return bottomInteger;
320         }
321         else{
322             bottomInteger = safeMul(currentPrice.bottomInteger, 120) / 100;
323             return bottomInteger;
324         }
325     }
326 
327     // change ICO starting date if more time needed for preparation
328     function changeIcoStartBlock(uint256 newIcoStartBlock) external onlyMainWallet{
329         require(block.number < icoStartBlock);
330         require(block.number < newIcoStartBlock);
331         icoStartBlock = newIcoStartBlock;
332     }
333 
334     function changeIcoEndBlock(uint256 newIcoEndBlock) external onlyMainWallet{
335         require(block.number < icoEndBlock);
336         require(block.number < newIcoEndBlock);
337         icoEndBlock = newIcoEndBlock;
338     }
339 
340     function changePriceUpdateWaitingTime(uint256 newPriceUpdateWaitingTime) external onlyMainWallet{
341         priceUpdateWaitingTime = newPriceUpdateWaitingTime;
342     }
343 
344     function requestLiquidation(uint256 amountTokensToLiquidate) external isSetTrading onlyVerified{
345         require(block.number > icoEndBlock);
346         require(amountTokensToLiquidate > 0);
347         address investor = msg.sender;
348         require(balanceOf(investor) >= amountTokensToLiquidate);
349         require(liquidations[investor].tokens == 0);
350         balances[investor] = safeSub(balances[investor], amountTokensToLiquidate);
351         liquidations[investor] = Liquidation({tokens: amountTokensToLiquidate, time: previousUpdateTime});
352         LiquidationCall(investor, amountTokensToLiquidate);
353     }
354 
355     function liquidate() external{
356         address investor = msg.sender;
357         uint256 tokens = liquidations[investor].tokens;
358         require(tokens > 0);
359         uint256 requestTime = liquidations[investor].time;
360         // obtain the next price that was set after the request
361         PriceEDEX storage price = prices[requestTime];
362         require(price.topInteger > 0);
363         uint256 liquidationValue = safeMul(tokens, price.bottomInteger) / price.topInteger;
364         // if there is enough ether on the contract, proceed. Otherwise, send back tokens
365         liquidations[investor].tokens = 0;
366         if (this.balance >= liquidationValue)
367             enact_liquidation_greater_equal(investor, liquidationValue, tokens);
368         else
369             enact_liquidation_less(investor, liquidationValue, tokens);
370     }
371 
372     function enact_liquidation_greater_equal(address investor, uint256 liquidationValue, uint256 tokens) private{
373         assert(this.balance >= liquidationValue);
374         balances[mainWallet] = safeAdd(balances[mainWallet], tokens);
375         investor.transfer(liquidationValue);
376         Liquidations(investor, tokens, liquidationValue);
377     }
378     
379     function enact_liquidation_less(address investor, uint256 liquidationValue, uint256 tokens) private{
380         assert(this.balance < liquidationValue);
381         balances[investor] = safeAdd(balances[investor], tokens);
382         Liquidations(investor, tokens, 0);
383     }
384 
385     function checkLiquidationValue(uint256 amountTokensToLiquidate) constant returns (uint256 etherValue){
386         require(amountTokensToLiquidate > 0);
387         require(balanceOf(msg.sender) >= amountTokensToLiquidate);
388         uint256 liquidationValue = safeMul(amountTokensToLiquidate, currentPrice.bottomInteger) / currentPrice.topInteger;
389         require(this.balance >= liquidationValue);
390         return liquidationValue;
391     }
392 
393     // add liquidity to contract for investor liquidation
394     function addLiquidity() external onlyControllingWallets payable{
395         require(msg.value > 0);
396         AddLiquidity(msg.value);
397     }
398 
399     // remove liquidity from contract
400     function removeLiquidity(uint256 amount) external onlyControllingWallets{
401         require(amount <= this.balance);
402         mainWallet.transfer(amount);
403         RemoveLiquidity(amount);
404     }
405 
406     function changeMainWallet(address newMainWallet) external onlyMainWallet{
407         require(newMainWallet != address(0));
408         mainWallet = newMainWallet;
409     }
410 
411     function changeSecondaryWallet(address newSecondaryWallet) external onlyMainWallet{
412         require(newSecondaryWallet != address(0));
413         secondaryWallet = newSecondaryWallet;
414     }
415 
416     function enableTrading() external onlyMainWallet{
417         require(block.number > icoEndBlock);
418         setTrading = true;
419     }
420 
421     function claimEDEX(address _token) external onlyMainWallet{
422         require(_token != address(0));
423         Token token = Token(_token);
424         uint256 balance = token.balanceOf(this);
425         token.transfer(mainWallet, balance);
426      }
427 
428     // disable transfers and allow them once token is tradeable
429     function transfer(address _to, uint256 _value) isSetTrading returns (bool success){
430         return super.transfer(_to, _value);
431     }
432     function transferFrom(address _from, address _to, uint256 _value) isSetTrading returns (bool success){
433         return super.transferFrom(_from, _to, _value);
434     }
435 
436     function haltICO() external onlyMainWallet{
437         haltICO = true;
438     }
439     
440     function unhaltICO() external onlyMainWallet{
441         haltICO = false;
442     }
443     
444     // fallback function
445     function() payable{
446         require(tx.origin == msg.sender);
447         buyTo(msg.sender);
448     }
449 }