1 pragma solidity 0.4.18;
2 
3 contract Token { // ERC20 standard
4 
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract SafeMath {
15 
16   function safeMul(uint a, uint b) pure internal returns (uint) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21   function safeSub(uint a, uint b) pure internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25   function safeAdd(uint a, uint b) pure internal returns (uint) {
26     uint c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30   function safeNumDigits(uint number) pure internal returns (uint8) {
31     uint8 digits = 0;
32     while (number != 0) {
33         number /= 10;
34         digits++;
35     }
36     return digits;
37 }
38 
39   // mitigate short address attack
40   // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
41   // TODO: doublecheck implication of >= compared to ==
42   modifier onlyPayloadSize(uint numWords) {
43      assert(msg.data.length >= numWords * 32 + 4);
44      _;
45   }
46 
47 }
48 
49 contract StandardToken is Token, SafeMath {
50 
51     uint256 public totalSupply;
52 
53     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool success) {
54         require(_to != address(0));
55         require(balances[msg.sender] >= _value && _value > 0);
56         balances[msg.sender] = safeSub(balances[msg.sender], _value);
57         balances[_to] = safeAdd(balances[_to], _value);
58         Transfer(msg.sender, _to, _value);
59 
60         return true;
61     }
62 
63     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool success) {
64         require(_to != address(0));
65         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
66         balances[_from] = safeSub(balances[_from], _value);
67         balances[_to] = safeAdd(balances[_to], _value);
68         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
69         Transfer(_from, _to, _value);
70 
71         return true;
72     }
73 
74     function balanceOf(address _owner) public constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77 
78     // To change the approve amount you first have to reduce the addresses'
79     //  allowance to zero by calling 'approve(_spender, 0)' if it is not
80     //  already 0 to mitigate the race condition described here:
81     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82     function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool success) {
83         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
84         allowed[msg.sender][_spender] = _value;
85         Approval(msg.sender, _spender, _value);
86 
87         return true;
88     }
89 
90     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) public onlyPayloadSize(3) returns (bool success) {
91         require(allowed[msg.sender][_spender] == _oldValue);
92         allowed[msg.sender][_spender] = _newValue;
93         Approval(msg.sender, _spender, _newValue);
94 
95         return true;
96     }
97 
98     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
99       return allowed[_owner][_spender];
100     }
101 
102     mapping (address => uint256) balances;
103     mapping (address => mapping (address => uint256)) allowed;
104 
105 }
106 
107 contract GRO is StandardToken {
108     // FIELDS
109     string public name = "Gron Digital";
110     string public symbol = "GRO";
111     uint256 public decimals = 18;
112     string public version = "11.0";
113 
114     // Nine Hundred and Fifty million with support for 18 decimals
115     uint256 public tokenCap = 950000000 * 10**18;
116 
117     // crowdsale parameters
118     uint256 public fundingStartBlock;
119     uint256 public fundingEndBlock;
120 
121     // vesting fields
122     address public vestingContract;
123     bool private vestingSet = false;
124 
125     // root control
126     address public fundWallet;
127     // control of liquidity and limited control of updatePrice
128     address public controlWallet;
129     // time to wait between controlWallet price updates
130     uint256 public waitTime = 5 hours;
131 
132     // fundWallet controlled state variables
133     // halted: halt buying due to emergency, tradeable: signal that GRON platform is up and running
134     bool public halted = false;
135     bool public tradeable = false;
136 
137     // -- totalSupply defined in StandardToken
138     // -- mapping to token balances done in StandardToken
139 
140     uint256 public previousUpdateTime = 0;
141     Price public currentPrice;
142     uint256 public minAmount; // Minimum amount of ether to accept for GRO purchases
143 
144     // map participant address to a withdrawal request
145     mapping (address => Withdrawal) public withdrawals;
146     // maps previousUpdateTime to the next price
147     mapping (uint256 => Price) public prices;
148     // maps addresses
149     mapping (address => bool) public whitelist;
150 
151     // TYPES
152 
153     struct Price { // tokensPerEth
154         uint256 numerator;
155     }
156 
157     struct Withdrawal {
158         uint256 tokens;
159         uint256 time; // time for each withdrawal is set to the previousUpdateTime
160     }
161 
162     // EVENTS
163 
164     event Buy(address indexed participant, address indexed beneficiary, uint256 weiValue, uint256 amountTokens);
165     event AllocatePresale(address indexed participant, uint256 amountTokens);
166     event BonusAllocation(address indexed participant, string participant_addr, string txnHash, uint256 bonusTokens);
167     event Mint(address indexed to, uint256 amount);
168     event Whitelist(address indexed participant);
169     event PriceUpdate(uint256 numerator);
170     event AddLiquidity(uint256 ethAmount);
171     event RemoveLiquidity(uint256 ethAmount);
172     event WithdrawRequest(address indexed participant, uint256 amountTokens);
173     event Withdraw(address indexed participant, uint256 amountTokens, uint256 etherAmount);
174 
175     // MODIFIERS
176 
177     modifier isTradeable { // exempt vestingContract and fundWallet to allow dev allocations
178         require(tradeable || msg.sender == fundWallet || msg.sender == vestingContract);
179         _;
180     }
181 
182     modifier onlyWhitelist {
183         require(whitelist[msg.sender]);
184         _;
185     }
186 
187     modifier onlyFundWallet {
188         require(msg.sender == fundWallet);
189         _;
190     }
191 
192     modifier onlyManagingWallets {
193         require(msg.sender == controlWallet || msg.sender == fundWallet);
194         _;
195     }
196 
197     modifier only_if_controlWallet {
198         if (msg.sender == controlWallet) _;
199     }
200     modifier require_waited {
201       require(safeSub(currentTime(), waitTime) >= previousUpdateTime);
202         _;
203     }
204     modifier only_if_decrease (uint256 newNumerator) {
205         if (newNumerator < currentPrice.numerator) _;
206     }
207 
208     // CONSTRUCTOR
209     function GRO() public {
210         fundWallet = msg.sender;
211         whitelist[fundWallet] = true;
212         previousUpdateTime = currentTime();
213     }
214 
215     // Called after deployment
216     // Not all deployment clients support constructor arguments.
217     // This function is provided for maximum compatibility. 
218     function initialiseContract(address controlWalletInput, uint256 priceNumeratorInput, uint256 startBlockInput, uint256 endBlockInput) external onlyFundWallet {
219       require(controlWalletInput != address(0));
220       require(priceNumeratorInput > 0);
221       require(endBlockInput > startBlockInput);
222       controlWallet = controlWalletInput;
223       whitelist[controlWallet] = true;
224       currentPrice = Price(priceNumeratorInput);
225       fundingStartBlock = startBlockInput;
226       fundingEndBlock = endBlockInput;
227       previousUpdateTime = currentTime();
228       minAmount = 0.05 ether; // 500 GRO
229     }
230 
231     // METHODS
232 
233     function setVestingContract(address vestingContractInput) external onlyFundWallet {
234         require(vestingContractInput != address(0));
235         vestingContract = vestingContractInput;
236         whitelist[vestingContract] = true;
237         vestingSet = true;
238     }
239 
240     // allows controlWallet to update the price within a time contstraint, allows fundWallet complete control
241     function updatePrice(uint256 newNumerator) external onlyManagingWallets {
242         require(newNumerator > 0);
243         require_limited_change(newNumerator);
244         // either controlWallet command is compliant or transaction came from fundWallet
245         currentPrice.numerator = newNumerator;
246         // maps time to new Price (if not during ICO)
247         prices[previousUpdateTime] = currentPrice;
248         previousUpdateTime = currentTime();
249         PriceUpdate(newNumerator);
250     }
251 
252     function require_limited_change (uint256 newNumerator)
253       private
254       view
255       only_if_controlWallet
256       require_waited
257       only_if_decrease(newNumerator)
258     {
259         uint256 percentage_diff = 0;
260         percentage_diff = safeMul(newNumerator, 100) / currentPrice.numerator;
261         percentage_diff = safeSub(100, percentage_diff);
262         // controlWallet can only increase price by max 20% and only every waitTime
263         require(percentage_diff <= 20);
264     }
265 
266     function mint(address participant, uint256 amountTokens) private {
267         require(vestingSet);
268         // 40% of total allocated for Founders, Team incentives & Bonuses.
269 
270 	// Solidity v0.4.18 - floating point is not fully supported,
271 	// integer division results in truncated values
272 	// Therefore we are multiplying out by 1000000... for
273 	// precision. This allows ratios values up to 0.0000x or 0.00x percent
274 	uint256 precision = 10**18;
275 	uint256 allocationRatio = safeMul(amountTokens, precision) / safeMul(570000000, precision);
276         uint256 developmentAllocation = safeMul(allocationRatio, safeMul(380000000, precision)) / precision;
277         // check that token cap is not exceeded
278         uint256 newTokens = safeAdd(amountTokens, developmentAllocation);
279         require(safeAdd(totalSupply, newTokens) <= tokenCap);
280         // increase token supply, assign tokens to participant
281         totalSupply = safeAdd(totalSupply, newTokens);
282         balances[participant] = safeAdd(balances[participant], amountTokens);
283         balances[vestingContract] = safeAdd(balances[vestingContract], developmentAllocation);
284 
285 	Mint(fundWallet, newTokens);
286 	Transfer(fundWallet, participant, amountTokens);
287 	Transfer(fundWallet, vestingContract, developmentAllocation);
288     }
289 
290     // amountTokens is supplied in major units, not subunits / decimal
291     // units.
292     function allocatePresaleTokens(
293 			       address participant_address,
294 			       string participant_str,
295 			       uint256 amountTokens,
296 			       string txnHash
297 			       )
298       external onlyFundWallet {
299 
300       require(currentBlock() < fundingEndBlock);
301       require(participant_address != address(0));
302      
303       uint256 bonusTokens = 0;
304       uint256 totalTokens = safeMul(amountTokens, 10**18); // scale to subunit
305 
306       if (firstDigit(txnHash) == firstDigit(participant_str)) {
307 	  // Calculate 10% bonus
308 	  bonusTokens = safeMul(totalTokens, 10) / 100;
309 	  totalTokens = safeAdd(totalTokens, bonusTokens);
310       }
311         
312         mint(participant_address, totalTokens);
313 	// Events        
314         AllocatePresale(participant_address, totalTokens);
315 	BonusAllocation(participant_address, participant_str, txnHash, bonusTokens);
316     }
317 
318     // returns the first character as a byte in a given hex string
319     // address Given 0x1abcd... returns 1
320     function firstDigit(string s) pure public returns(byte){
321 	bytes memory strBytes = bytes(s);
322 	return strBytes[2];
323       }
324 
325     function verifyParticipant(address participant) external onlyManagingWallets {
326         whitelist[participant] = true;
327         Whitelist(participant);
328     }
329 
330     // fallback function
331     function() payable public {
332       require(tx.origin == msg.sender);
333       buyTo(msg.sender);
334     }
335 
336     function buy() external payable {
337         buyTo(msg.sender);
338     }
339 
340     function buyTo(address participant) public payable {
341       require(!halted);
342       require(participant != address(0));
343       require(msg.value >= minAmount);
344       require(currentBlock() < fundingEndBlock);
345       // msg.value in wei - scale to GRO
346       uint256 baseAmountTokens = safeMul(msg.value, currentPrice.numerator);
347       // calc lottery amount excluding potential ico bonus
348       uint256 lotteryAmount = blockLottery(baseAmountTokens);
349       uint256 icoAmount = safeMul(msg.value, icoNumeratorPrice());
350 
351       uint256 tokensToBuy = safeAdd(icoAmount, lotteryAmount);
352       mint(participant, tokensToBuy);
353       // send ether to fundWallet
354       fundWallet.transfer(msg.value);
355       // Events
356       Buy(msg.sender, participant, msg.value, tokensToBuy);
357     }
358 
359     // time based on blocknumbers, assuming a blocktime of 15s
360     function icoNumeratorPrice() public constant returns (uint256) {
361 
362       if (currentBlock() < fundingStartBlock){
363 	return 14000;
364       }
365       
366       uint256 icoDuration = safeSub(currentBlock(), fundingStartBlock);
367 
368       uint256 firstBlockPhase = 80640; // #blocks = 2*7*24*60*60/15 = 80640
369       uint256 secondBlockPhase = 161280; // // #blocks = 4*7*24*60*60/15 = 161280
370       uint256 thirdBlockPhase = 241920; // // #blocks = 6*7*24*60*60/15 = 241920
371 
372       if (icoDuration < firstBlockPhase ) {
373 	return  13000;	  
374       } else if (icoDuration < secondBlockPhase ) { 
375 	return  12000;	    
376       } else if (icoDuration < thirdBlockPhase ) { 
377 	return 11000;	    
378       } else {
379 	return 10000;
380       }
381     }
382 
383     function currentBlock() private constant returns(uint256 _currentBlock) {
384       return block.number;
385     }
386 
387     function currentTime() private constant returns(uint256 _currentTime) {
388       return now;
389     }
390 
391     function blockLottery(uint256 _amountTokens) private constant returns(uint256) {
392       uint256 divisor = 10;
393       uint256 winning_digit = 0;
394       uint256 tokenWinnings = 0;
395 
396       if (currentBlock() % divisor == winning_digit) {
397 	tokenWinnings = safeMul(_amountTokens, 10) / 100;
398       }
399       
400       return tokenWinnings;	
401     }
402 
403     function requestWithdrawal(uint256 amountTokensToWithdraw) external isTradeable onlyWhitelist {
404       require(currentBlock() > fundingEndBlock);
405         require(amountTokensToWithdraw > 0);
406         address participant = msg.sender;
407         require(balanceOf(participant) >= amountTokensToWithdraw);
408         require(withdrawals[participant].tokens == 0); // participant cannot have outstanding withdrawals
409         balances[participant] = safeSub(balances[participant], amountTokensToWithdraw);
410         withdrawals[participant] = Withdrawal({tokens: amountTokensToWithdraw, time: previousUpdateTime});
411         WithdrawRequest(participant, amountTokensToWithdraw);
412     }
413 
414     function withdraw() external {
415         address participant = msg.sender;
416         uint256 tokens = withdrawals[participant].tokens;
417         require(tokens > 0); // participant must have requested a withdrawal
418         uint256 requestTime = withdrawals[participant].time;
419         // obtain the next price that was set after the request
420         Price price = prices[requestTime];
421         require(price.numerator > 0); // price must have been set
422         uint256 withdrawValue = tokens / price.numerator;
423         // if contract ethbal > then send + transfer tokens to fundWallet, otherwise give tokens back
424         withdrawals[participant].tokens = 0;
425         if (this.balance >= withdrawValue) {
426             enact_withdrawal_greater_equal(participant, withdrawValue, tokens);
427 	}
428         else {
429             enact_withdrawal_less(participant, withdrawValue, tokens);
430 	}
431     }
432 
433     function enact_withdrawal_greater_equal(address participant, uint256 withdrawValue, uint256 tokens)
434         private
435     {
436         assert(this.balance >= withdrawValue);
437         balances[fundWallet] = safeAdd(balances[fundWallet], tokens);
438         participant.transfer(withdrawValue);
439         Withdraw(participant, tokens, withdrawValue);
440     }
441     function enact_withdrawal_less(address participant, uint256 withdrawValue, uint256 tokens)
442         private
443     {
444         assert(this.balance < withdrawValue);
445         balances[participant] = safeAdd(balances[participant], tokens);
446         Withdraw(participant, tokens, 0); // indicate a failed withdrawal
447     }
448 
449     // Returns the ether value (in wei units) for the amount of tokens
450     // in subunits for decimal support, at the current GRO exchange
451     // rate
452     function checkWithdrawValue(uint256 amountTokensInSubunit) public constant returns (uint256 weiValue) {
453         require(amountTokensInSubunit > 0);
454         require(balanceOf(msg.sender) >= amountTokensInSubunit);
455         uint256 withdrawValue = amountTokensInSubunit / currentPrice.numerator;
456         require(this.balance >= withdrawValue);
457         return withdrawValue;
458     }
459 
460     // allow fundWallet or controlWallet to add ether to contract
461     function addLiquidity() external onlyManagingWallets payable {
462         require(msg.value > 0);
463         AddLiquidity(msg.value);
464     }
465 
466     // allow fundWallet to remove ether from contract
467     function removeLiquidity(uint256 amount) external onlyManagingWallets {
468         require(amount <= this.balance);
469         fundWallet.transfer(amount);
470         RemoveLiquidity(amount);
471     }
472 
473     function changeFundWallet(address newFundWallet) external onlyFundWallet {
474         require(newFundWallet != address(0));
475         fundWallet = newFundWallet;
476     }
477 
478     function changeControlWallet(address newControlWallet) external onlyFundWallet {
479         require(newControlWallet != address(0));
480         controlWallet = newControlWallet;
481     }
482 
483     function changeWaitTime(uint256 newWaitTime) external onlyFundWallet {
484         waitTime = newWaitTime;
485     }
486 
487     // specified in wei
488     function changeMinAmount(uint256 newMinAmount) external onlyFundWallet {
489       minAmount = newMinAmount;
490     }
491 
492     function updateFundingStartBlock(uint256 newFundingStartBlock) external onlyFundWallet {
493       require(currentBlock() < fundingStartBlock);
494         require(currentBlock() < newFundingStartBlock);
495         fundingStartBlock = newFundingStartBlock;
496     }
497 
498     function updateFundingEndBlock(uint256 newFundingEndBlock) external onlyFundWallet {
499         require(currentBlock() < fundingEndBlock);
500         require(currentBlock() < newFundingEndBlock);
501         fundingEndBlock = newFundingEndBlock;
502     }
503 
504     function halt() external onlyFundWallet {
505         halted = true;
506     }
507     function unhalt() external onlyFundWallet {
508         halted = false;
509     }
510 
511     function enableTrading() external onlyFundWallet {
512         require(currentBlock() > fundingEndBlock);
513         tradeable = true;
514     }
515 
516     function claimTokens(address _token) external onlyFundWallet {
517         require(_token != address(0));
518         Token token = Token(_token);
519         uint256 balance = token.balanceOf(this);
520         token.transfer(fundWallet, balance);
521      }
522 
523     // prevent transfers until trading allowed
524     function transfer(address _to, uint256 _value) public isTradeable returns (bool success) {
525         return super.transfer(_to, _value);
526     }
527     function transferFrom(address _from, address _to, uint256 _value) public isTradeable returns (bool success) {
528         return super.transferFrom(_from, _to, _value);
529     }
530 }