1 pragma solidity 0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     if (a == 0) {
11       return 0;
12     }
13     uint256 c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal pure returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract AMBToken {
38     using SafeMath for uint256;
39 
40     string  public constant name     = "Ambit token";
41     string  public constant symbol   = "AMBT";
42     uint8   public constant decimals = 18;
43     uint256 public totalSupply;
44 
45     bool internal contractIsWorking = true;
46 
47     struct Investor {
48         uint256 tokenBalance;
49         uint256 icoInvest;
50         bool    activated;
51     }
52     mapping(address => Investor) internal investors;
53     mapping(address => mapping (address => uint256)) internal allowed;
54 
55     /*
56             Dividend's Structures
57     */
58     uint256   internal dividendCandidate = 0;
59     uint256[] internal dividends;
60 
61     enum ProfitStatus {Initial, StartFixed, EndFixed, Claimed}
62     struct InvestorProfitData {
63         uint256      start_balance;
64         uint256      end_balance;
65         ProfitStatus status;
66     }
67 
68     mapping(address => mapping(uint32 => InvestorProfitData)) internal profits;
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 
73     function balanceOf(address _owner) public view returns (uint256 balance) {
74         return investors[_owner].tokenBalance;
75     }
76 
77     function allowance(address _owner, address _spender) public view returns (uint256) {
78         return allowed[_owner][_spender];
79     }
80 
81     function _approve(address _spender, uint256 _value) internal returns (bool) {
82         allowed[msg.sender][_spender] = _value;
83         emit Approval(msg.sender, _spender, _value);
84         return true;
85     }
86 
87     function approve(address _spender, uint256 _value) public returns (bool) {
88         require(investors[msg.sender].activated && contractIsWorking);
89         return _approve(_spender, _value);
90     }
91 
92     function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
93         require(_to != address(0));
94         require(_value <= investors[_from].tokenBalance);
95 
96         fixDividendBalances(_to, false);
97 
98         investors[_from].tokenBalance = investors[_from].tokenBalance.sub(_value);
99         investors[_to].tokenBalance = investors[_to].tokenBalance.add(_value);
100         emit Transfer(_from, _to, _value);
101         return true;
102     }
103 
104     function transfer(address _to, uint256 _value) public returns (bool) {
105         require(investors[msg.sender].activated && contractIsWorking);
106         fixDividendBalances(msg.sender, false);
107         return _transfer( msg.sender, _to,  _value);
108     }
109 
110     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111         require(investors[msg.sender].activated && investors[_from].activated && contractIsWorking);
112         require(_to != address(0));
113         require(_value <= investors[_from].tokenBalance);
114         require(_value <= allowed[_from][msg.sender]);
115 
116         fixDividendBalances(_from, false);
117         fixDividendBalances(_to, false);
118 
119         investors[_from].tokenBalance = investors[_from].tokenBalance.sub(_value);
120         investors[_to].tokenBalance   = investors[_to].tokenBalance.add(_value);
121         allowed[_from][msg.sender]    = allowed[_from][msg.sender].sub(_value);
122 
123         emit Transfer(_from, _to, _value);
124         return true;
125     }
126 
127     /*
128         Eligible token and balance helper function
129      */
130     function fixDividendBalances(address investor, bool revertIfClaimed) internal
131         returns (InvestorProfitData storage current_profit, uint256 profit_per_token){
132 
133         uint32 next_id      = uint32(dividends.length);
134         uint32 current_id   = next_id - 1;
135         current_profit      = profits[investor][current_id];
136 
137         if (revertIfClaimed) require(current_profit.status != ProfitStatus.Claimed);
138         InvestorProfitData storage next_profit      = profits[investor][next_id];
139 
140         if (current_profit.status == ProfitStatus.Initial) {
141 
142             current_profit.start_balance = investors[investor].tokenBalance;
143             current_profit.end_balance   = investors[investor].tokenBalance;
144             current_profit.status        = ProfitStatus.EndFixed;
145             next_profit.start_balance = investors[investor].tokenBalance;
146             next_profit.status        = ProfitStatus.StartFixed;
147 
148         } else if (current_profit.status == ProfitStatus.StartFixed) {
149 
150             current_profit.end_balance = investors[investor].tokenBalance;
151             current_profit.status      = ProfitStatus.EndFixed;
152             next_profit.start_balance = investors[investor].tokenBalance;
153             next_profit.status        = ProfitStatus.StartFixed;
154         }
155         profit_per_token = dividends[current_id];
156     }
157 }
158 
159 contract AMBTICO is AMBToken {
160     uint256 internal constant ONE_TOKEN           = 10 ** uint256(decimals);//just for convenience
161     uint256 internal constant MILLION             = 1000000;                //just for convenience
162 
163     uint256 internal constant BOUNTY_QUANTITY     = 3120000;
164     uint256 internal constant RESERV_QUANTITY     = 12480000;
165 
166     uint256 internal constant TOKEN_MAX_SUPPLY    = 104 * MILLION   * ONE_TOKEN;
167     uint256 internal constant BOUNTY_TOKENS       = BOUNTY_QUANTITY * ONE_TOKEN;
168     uint256 internal constant RESERV_TOKENS       = RESERV_QUANTITY * ONE_TOKEN;
169     uint256 internal constant MIN_SOLD_TOKENS     = 200             * ONE_TOKEN;
170     uint256 internal constant SOFTCAP             = BOUNTY_TOKENS + RESERV_TOKENS + 6 * MILLION * ONE_TOKEN;
171 
172     uint256 internal constant REFUND_PERIOD       = 60 days;
173     uint256 internal constant KYC_REVIEW_PERIOD   = 60 days;
174 
175     address internal owner;
176     address internal bountyManager;
177     address internal dividendManager;
178     address internal dApp;
179 
180     enum ContractMode {Initial, TokenSale, UnderSoftCap, DividendDistribution, Destroyed}
181     ContractMode public mode = ContractMode.Initial;
182 
183     uint256 public icoFinishTime = 0;
184     uint256 public tokenSold = 0;
185     uint256 public etherCollected = 0;
186 
187     uint8   public currentSection = 0;
188     uint[4] public saleSectionDiscounts = [ uint8(20), 10, 5];
189     uint[4] public saleSectionPrice     = [ uint256(1000000000000000), 1125000000000000, 1187500000000000, 1250000000000000];//price: 0.40 0.45 0.475 0.50 cent | ETH/USD initial rate: 400
190     uint[4] public saleSectionCount     = [ uint256(17 * MILLION), 20 * MILLION, 20 * MILLION, 47 * MILLION - (BOUNTY_QUANTITY+RESERV_QUANTITY)];
191     uint[4] public saleSectionInvest    = [ uint256(saleSectionCount[0] * saleSectionPrice[0]),
192                                                     saleSectionCount[1] * saleSectionPrice[1],
193                                                     saleSectionCount[2] * saleSectionPrice[2],
194                                                     saleSectionCount[3] * saleSectionPrice[3]];
195     uint256 public buyBackPriceWei = 0 ether;
196 
197     event OwnershipTransferred          (address previousOwner, address newOwner);
198     event BountyManagerAssigned         (address previousBountyManager, address newBountyManager);
199     event DividendManagerAssigned       (address previousDividendManager, address newDividendManager);
200     event DAppAssigned                  (address previousDApp, address newDApp);
201     event ModeChanged                   (ContractMode  newMode, uint256 tokenBalance);
202     event DividendDeclared              (uint32 indexed dividendID, uint256 profitPerToken);
203     event DividendClaimed               (address indexed investor, uint256 amount);
204     event BuyBack                       (address indexed requestor);
205     event Refund                        (address indexed investor, uint256 amount);
206     event Handbrake                     (ContractMode current_mode, bool functioning);
207     event FundsAdded                    (address owner, uint256 amount);
208     event FundsWithdrawal               (address owner, uint256 amount);
209     event BountyTransfered              (address recipient, uint256 amount);
210     event PriceChanged                  (uint256 newPrice);
211     event BurnToken                     (uint256 amount);
212 
213     modifier grantOwner() {
214         require(msg.sender == owner);
215         _;
216     }
217 
218     modifier grantBountyManager() {
219         require(msg.sender == bountyManager);
220         _;
221     }
222 
223     modifier grantDividendManager() {
224         require(msg.sender == dividendManager);
225         _;
226     }
227 
228     modifier grantDApp() {
229         require(msg.sender == dApp);
230         _;
231     }
232     function AMBTICO() public {
233         owner = msg.sender;
234         dividends.push(0);
235     }
236 
237     function setTokenPrice(uint256 new_wei_price) public grantDApp {
238         require(new_wei_price > 0);
239         uint8 len = uint8(saleSectionPrice.length)-1;
240         for (uint8 i=0; i<=len; i++) {
241             uint256 prdsc = 100 - saleSectionDiscounts[i];
242             saleSectionPrice[i]  = prdsc.mul(new_wei_price ).div(100);
243             saleSectionInvest[i] = saleSectionPrice[i] * saleSectionCount[i];
244         }
245         emit PriceChanged(new_wei_price);
246     }
247 
248     function startICO() public grantOwner {
249         require(contractIsWorking);
250         require(mode == ContractMode.Initial);
251         require(bountyManager != 0x0);
252 
253         totalSupply = TOKEN_MAX_SUPPLY;
254 
255         investors[this].tokenBalance            = TOKEN_MAX_SUPPLY-(BOUNTY_TOKENS+RESERV_TOKENS);
256         investors[bountyManager].tokenBalance   = BOUNTY_TOKENS;
257         investors[owner].tokenBalance           = RESERV_TOKENS;
258 
259         tokenSold = investors[bountyManager].tokenBalance + investors[owner].tokenBalance;
260 
261         mode = ContractMode.TokenSale;
262         emit ModeChanged(mode, investors[this].tokenBalance);
263     }
264 
265     function getCurrentTokenPrice() public view returns(uint256) {
266         require(currentSection < saleSectionCount.length);
267         return saleSectionPrice[currentSection];
268     }
269 
270     function () public payable {
271         invest();
272     }
273     function invest() public payable {
274        _invest(msg.sender,msg.value);
275     }
276     /* Used by ĐApp to accept Bitcoin transfers.*/
277     function investWithBitcoin(address ethAddress, uint256 ethWEI) public grantDApp {
278         _invest(ethAddress,ethWEI);
279     }
280 
281 
282     function _invest(address msg_sender, uint256 msg_value) internal {
283         require(contractIsWorking);
284         require(currentSection < saleSectionCount.length);
285         require(mode == ContractMode.TokenSale);
286         require(msg_sender != bountyManager);
287 
288         uint wei_value = msg_value;
289         uint _tokens = 0;
290 
291         while (wei_value > 0 && (currentSection < saleSectionCount.length)) {
292             if (saleSectionInvest[currentSection] >= wei_value) {
293                 _tokens += ONE_TOKEN.mul(wei_value).div(saleSectionPrice[currentSection]);
294                 saleSectionInvest[currentSection] -= wei_value;
295                 wei_value =0;
296             } else {
297                 _tokens += ONE_TOKEN.mul(saleSectionInvest[currentSection]).div(saleSectionPrice[currentSection]);
298                 wei_value -= saleSectionInvest[currentSection];
299                 saleSectionInvest[currentSection] = 0;
300             }
301             if (saleSectionInvest[currentSection] <= 0) currentSection++;
302         }
303 
304         require(_tokens >= MIN_SOLD_TOKENS);
305 
306         require(_transfer(this, msg_sender, _tokens));
307 
308         profits[msg_sender][1] = InvestorProfitData({
309             start_balance:  investors[msg_sender].tokenBalance,
310             end_balance:    investors[msg_sender].tokenBalance,
311             status:         ProfitStatus.StartFixed
312             });
313 
314         investors[msg_sender].icoInvest += (msg_value - wei_value);
315 
316         tokenSold      += _tokens;
317         etherCollected += (msg_value - wei_value);
318 
319         if (saleSectionInvest[saleSectionInvest.length-1] == 0 ) {
320             _finishICO();
321         }
322 
323         if (wei_value > 0) {
324             msg_sender.transfer(wei_value);
325         }
326     }
327 
328     function _finishICO() internal {
329         require(contractIsWorking);
330         require(mode == ContractMode.TokenSale);
331 
332         if (tokenSold >= SOFTCAP) {
333             mode = ContractMode.DividendDistribution;
334         } else {
335             mode = ContractMode.UnderSoftCap;
336         }
337 
338         investors[this].tokenBalance = 0;
339         icoFinishTime                = now;
340         totalSupply                  = tokenSold;
341 
342         emit ModeChanged(mode, investors[this].tokenBalance);
343     }
344 
345     function finishICO() public grantOwner  {
346         _finishICO();
347     }
348 
349     function getInvestedAmount(address investor) public view returns(uint256) {
350         return investors[investor].icoInvest;
351     }
352 
353     function activateAddress(address investor, bool status) public grantDApp {
354         require(contractIsWorking);
355         require(mode == ContractMode.DividendDistribution);
356         require((now - icoFinishTime) < KYC_REVIEW_PERIOD);
357         investors[investor].activated = status;
358     }
359 
360     function isAddressActivated(address investor) public view returns (bool) {
361         return investors[investor].activated;
362     }
363 
364     /*******
365             Dividend Declaration Section
366     *********/
367     function declareDividend(uint256 profit_per_token) public grantDividendManager {
368         dividendCandidate = profit_per_token;
369     }
370 
371     function confirmDividend(uint256 profit_per_token) public grantOwner {
372         require(contractIsWorking);
373         require(dividendCandidate == profit_per_token);
374         require(mode == ContractMode.DividendDistribution);
375 
376         dividends.push(dividendCandidate);
377         emit DividendDeclared(uint32(dividends.length), dividendCandidate);
378         dividendCandidate = 0;
379     }
380 
381     function claimDividend() public {
382         require(contractIsWorking);
383         require(mode == ContractMode.DividendDistribution);
384         require(investors[msg.sender].activated);
385 
386         InvestorProfitData storage current_profit;
387         uint256 price_per_token;
388         (current_profit, price_per_token) = fixDividendBalances(msg.sender, true);
389 
390         uint256 investorProfitWei =
391                     (current_profit.start_balance < current_profit.end_balance ?
392                      current_profit.start_balance : current_profit.end_balance ).div(ONE_TOKEN).mul(price_per_token);
393 
394         current_profit.status = ProfitStatus.Claimed;
395         emit DividendClaimed(msg.sender, investorProfitWei);
396 
397         msg.sender.transfer(investorProfitWei);
398     }
399 
400     function getDividendInfo() public view returns(uint256) {
401         return dividends[dividends.length - 1];
402     }
403 
404     /*******
405                 emit BuyBack
406     ********/
407     function setBuyBackPrice(uint256 token_buyback_price) public grantOwner {
408         require(mode == ContractMode.DividendDistribution);
409         buyBackPriceWei = token_buyback_price;
410     }
411 
412     function buyback() public {
413         require(contractIsWorking);
414         require(mode == ContractMode.DividendDistribution);
415         require(buyBackPriceWei > 0);
416 
417         uint256 token_amount = investors[msg.sender].tokenBalance;
418         uint256 ether_amount = calcTokenToWei(token_amount);
419 
420         require(address(this).balance > ether_amount);
421 
422         if (transfer(this, token_amount)){
423             emit BuyBack(msg.sender);
424             msg.sender.transfer(ether_amount);
425         }
426     }
427 
428     /********
429                 Under SoftCap Section
430     *********/
431     function refund() public {
432         require(contractIsWorking);
433         require(mode == ContractMode.UnderSoftCap);
434         require(investors[msg.sender].tokenBalance >0);
435         require(investors[msg.sender].icoInvest>0);
436 
437         require (address(this).balance > investors[msg.sender].icoInvest);
438 
439         if (_transfer(msg.sender, this, investors[msg.sender].tokenBalance)){
440             emit Refund(msg.sender, investors[msg.sender].icoInvest);
441             msg.sender.transfer(investors[msg.sender].icoInvest);
442         }
443     }
444 
445     function destroyContract() public grantOwner {
446         require(mode == ContractMode.UnderSoftCap);
447         require((now - icoFinishTime) > REFUND_PERIOD);
448         selfdestruct(owner);
449     }
450     /********
451                 Permission related
452     ********/
453 
454     function transferOwnership(address new_owner) public grantOwner {
455         require(contractIsWorking);
456         require(new_owner != address(0));
457         emit OwnershipTransferred(owner, new_owner);
458         owner = new_owner;
459     }
460 
461     function setBountyManager(address new_bounty_manager) public grantOwner {
462         require(investors[new_bounty_manager].tokenBalance ==0);
463         if (mode == ContractMode.Initial) {
464             emit BountyManagerAssigned(bountyManager, new_bounty_manager);
465             bountyManager = new_bounty_manager;
466         } else if (mode == ContractMode.TokenSale) {
467             emit BountyManagerAssigned(bountyManager, new_bounty_manager);
468             address old_bounty_manager = bountyManager;
469             bountyManager              = new_bounty_manager;
470             require(_transfer(old_bounty_manager, new_bounty_manager, investors[old_bounty_manager].tokenBalance));
471         } else {
472             revert();
473         }
474     }
475 
476     function setDividendManager(address new_dividend_manager) public grantOwner {
477         emit DividendManagerAssigned(dividendManager, new_dividend_manager);
478         dividendManager = new_dividend_manager;
479     }
480 
481     function setDApp(address new_dapp) public grantOwner {
482         emit DAppAssigned(dApp, new_dapp);
483         dApp = new_dapp;
484     }
485 
486 
487 
488     /********
489                 Security and funds section
490     ********/
491 
492     function transferBounty(address _to, uint256 _amount) public grantBountyManager {
493         require(contractIsWorking);
494         require(mode == ContractMode.DividendDistribution);
495         if (_transfer(bountyManager, _to, _amount)) {
496             emit BountyTransfered(_to, _amount);
497         }
498     }
499 
500     function burnTokens(uint256 tokenAmount) public grantOwner {
501         require(contractIsWorking);
502         require(mode == ContractMode.DividendDistribution);
503         require(investors[msg.sender].tokenBalance > tokenAmount);
504 
505         investors[msg.sender].tokenBalance -= tokenAmount;
506         totalSupply = totalSupply.sub(tokenAmount);
507         emit BurnToken(tokenAmount);
508     }
509 
510     function withdrawFunds(uint wei_value) grantOwner external {
511         require(mode != ContractMode.UnderSoftCap);
512         require(address(this).balance >= wei_value);
513 
514         emit FundsWithdrawal(msg.sender, wei_value);
515         msg.sender.transfer(wei_value);
516     }
517 
518     function addFunds() public payable grantOwner {
519         require(contractIsWorking);
520         emit FundsAdded(msg.sender, msg.value);
521     }
522 
523     function pauseContract() public grantOwner {
524         require(contractIsWorking);
525         contractIsWorking = false;
526         emit Handbrake(mode, contractIsWorking);
527     }
528 
529     function restoreContract() public grantOwner {
530         require(!contractIsWorking);
531         contractIsWorking = true;
532         emit Handbrake(mode, contractIsWorking);
533     }
534 
535     /********
536                 Helper functions
537     ********/
538     function calcTokenToWei(uint256 token_amount) internal view returns (uint256) {
539         return buyBackPriceWei.mul(token_amount).div(ONE_TOKEN);
540     }
541 }