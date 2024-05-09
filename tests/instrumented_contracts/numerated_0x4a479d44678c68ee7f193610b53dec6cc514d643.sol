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
14 
15 /**
16  * Overflow aware uint math functions.
17  *
18  * Inspired by https://github.com/makerdao/maker-otc/blob/master/src/simple_market.sol
19  */
20 
21 contract SafeMath {
22 
23   function safeMul(uint a, uint b) pure internal returns (uint) {
24     uint c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28   function safeSub(uint a, uint b) pure internal returns (uint) {
29     assert(b <= a);
30     return a - b;
31   }
32   function safeAdd(uint a, uint b) pure internal returns (uint) {
33     uint c = a + b;
34     assert(c>=a && c>=b);
35     return c;
36   }
37   function safeNumDigits(uint number) pure internal returns (uint8) {
38     uint8 digits = 0;
39     while (number != 0) {
40         number /= 10;
41         digits++;
42     }
43     return digits;
44 }
45 
46   // mitigate short address attack
47   // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
48   // TODO: doublecheck implication of >= compared to ==
49   modifier onlyPayloadSize(uint numWords) {
50      assert(msg.data.length >= numWords * 32 + 4);
51      _;
52   }
53 
54 }
55 
56 contract StandardToken is Token, SafeMath {
57 
58     uint256 public totalSupply;
59 
60     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool success) {
61         require(_to != address(0));
62         require(balances[msg.sender] >= _value && _value > 0);
63         balances[msg.sender] = safeSub(balances[msg.sender], _value);
64         balances[_to] = safeAdd(balances[_to], _value);
65         Transfer(msg.sender, _to, _value);
66 
67         return true;
68     }
69 
70     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool success) {
71         require(_to != address(0));
72         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
73         balances[_from] = safeSub(balances[_from], _value);
74         balances[_to] = safeAdd(balances[_to], _value);
75         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
76         Transfer(_from, _to, _value);
77 
78         return true;
79     }
80 
81     function balanceOf(address _owner) public constant returns (uint256 balance) {
82         return balances[_owner];
83     }
84 
85     // To change the approve amount you first have to reduce the addresses'
86     //  allowance to zero by calling 'approve(_spender, 0)' if it is not
87     //  already 0 to mitigate the race condition described here:
88     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89     function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool success) {
90         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
91         allowed[msg.sender][_spender] = _value;
92         Approval(msg.sender, _spender, _value);
93 
94         return true;
95     }
96 
97     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) public onlyPayloadSize(3) returns (bool success) {
98         require(allowed[msg.sender][_spender] == _oldValue);
99         allowed[msg.sender][_spender] = _newValue;
100         Approval(msg.sender, _spender, _newValue);
101 
102         return true;
103     }
104 
105     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
106       return allowed[_owner][_spender];
107     }
108 
109     mapping (address => uint256) balances;
110     mapping (address => mapping (address => uint256)) allowed;
111 
112 }
113 
114 contract GRO is StandardToken {
115     // FIELDS
116     string public name = "Gron Digital";
117     string public symbol = "GRO";
118     uint256 public decimals = 18;
119     string public version = "9.0";
120 
121     uint256 public tokenCap = 950000000 * 10**18;
122 
123     // crowdsale parameters
124     uint256 public fundingStartBlock;
125     uint256 public fundingEndBlock;
126 
127     // vesting fields
128     address public vestingContract;
129     bool private vestingSet = false;
130 
131     // root control
132     address public fundWallet;
133     // control of liquidity and limited control of updatePrice
134     address public controlWallet;
135     // time to wait between controlWallet price updates
136     uint256 public waitTime = 5 hours;
137 
138     // fundWallet controlled state variables
139     // halted: halt buying due to emergency, tradeable: signal that GRON platform is up and running
140     bool public halted = false;
141     bool public tradeable = false;
142 
143     // -- totalSupply defined in StandardToken
144     // -- mapping to token balances done in StandardToken
145 
146     uint256 public previousUpdateTime = 0;
147     Price public currentPrice;
148     uint256 public minAmount = 0.05 ether; // 500 GRO
149 
150     // map participant address to a withdrawal request
151     mapping (address => Withdrawal) public withdrawals;
152     // maps previousUpdateTime to the next price
153     mapping (uint256 => Price) public prices;
154     // maps addresses
155     mapping (address => bool) public whitelist;
156 
157     // TYPES
158 
159     struct Price { // tokensPerEth
160         uint256 numerator;
161     }
162 
163     struct Withdrawal {
164         uint256 tokens;
165         uint256 time; // time for each withdrawal is set to the previousUpdateTime
166     }
167 
168     // EVENTS
169 
170     event Buy(address indexed participant, address indexed beneficiary, uint256 weiValue, uint256 amountTokens);
171     event AllocatePresale(address indexed participant, uint256 amountTokens);
172     event BonusAllocation(address indexed participant, string participant_addr, uint256 bonusTokens);    
173     event Whitelist(address indexed participant);
174     event PriceUpdate(uint256 numerator);
175     event AddLiquidity(uint256 ethAmount);
176     event RemoveLiquidity(uint256 ethAmount);
177     event WithdrawRequest(address indexed participant, uint256 amountTokens);
178     event Withdraw(address indexed participant, uint256 amountTokens, uint256 etherAmount);
179 
180     // MODIFIERS
181 
182     modifier isTradeable { // exempt vestingContract and fundWallet to allow dev allocations
183         require(tradeable || msg.sender == fundWallet || msg.sender == vestingContract);
184         _;
185     }
186 
187     modifier onlyWhitelist {
188         require(whitelist[msg.sender]);
189         _;
190     }
191 
192     modifier onlyFundWallet {
193         require(msg.sender == fundWallet);
194         _;
195     }
196 
197     modifier onlyManagingWallets {
198         require(msg.sender == controlWallet || msg.sender == fundWallet);
199         _;
200     }
201 
202     modifier only_if_controlWallet {
203         if (msg.sender == controlWallet) _;
204     }
205     modifier require_waited {
206       require(safeSub(currentTime(), waitTime) >= previousUpdateTime);
207         _;
208     }
209     modifier only_if_decrease (uint256 newNumerator) {
210         if (newNumerator < currentPrice.numerator) _;
211     }
212 
213     // CONSTRUCTOR
214     function GRO() public {
215         fundWallet = msg.sender;
216         whitelist[fundWallet] = true;
217         previousUpdateTime = currentTime();
218     }
219 
220     // Called after deployment
221     // Not all deployment clients support constructor arguments.
222     // This function is provided for maximum compatibility. 
223     function initialiseContract(address controlWalletInput, uint256 priceNumeratorInput, uint256 startBlockInput, uint256 endBlockInput) external onlyFundWallet {
224       require(controlWalletInput != address(0));
225       require(priceNumeratorInput > 0);
226       require(endBlockInput > startBlockInput);
227       controlWallet = controlWalletInput;
228       whitelist[controlWallet] = true;
229       currentPrice = Price(priceNumeratorInput);
230       fundingStartBlock = startBlockInput;
231       fundingEndBlock = endBlockInput;
232       previousUpdateTime = currentTime();
233     }
234 
235     // METHODS
236 
237     function setVestingContract(address vestingContractInput) external onlyFundWallet {
238         require(vestingContractInput != address(0));
239         vestingContract = vestingContractInput;
240         whitelist[vestingContract] = true;
241         vestingSet = true;
242     }
243 
244     // allows controlWallet to update the price within a time contstraint, allows fundWallet complete control
245     function updatePrice(uint256 newNumerator) external onlyManagingWallets {
246         require(newNumerator > 0);
247         require_limited_change(newNumerator);
248         // either controlWallet command is compliant or transaction came from fundWallet
249         currentPrice.numerator = newNumerator;
250         // maps time to new Price (if not during ICO)
251         prices[previousUpdateTime] = currentPrice;
252         previousUpdateTime = currentTime();
253         PriceUpdate(newNumerator);
254     }
255 
256     function require_limited_change (uint256 newNumerator)
257       private
258       view
259       only_if_controlWallet
260       require_waited
261       only_if_decrease(newNumerator)
262     {
263         uint256 percentage_diff = 0;
264         percentage_diff = safeMul(newNumerator, 100) / currentPrice.numerator;
265         percentage_diff = safeSub(100, percentage_diff);
266         // controlWallet can only increase price by max 20% and only every waitTime
267         require(percentage_diff <= 20);
268     }
269 
270     function allocateTokens(address participant, uint256 amountTokens) private {
271         require(vestingSet);
272         // 40% of total allocated for Founders, Team incentives & Bonuses.
273 
274 	// Solidity v0.4.18 - floating point is not fully supported,
275 	// so often integer division results in truncated values.
276 	// Therefore we are multiplying out by 1000000 for
277 	// precision. This allows ratios values up to 0.0000x or 0.00x percent
278 	uint256 precision = 10**18;
279 	uint256 allocationRatio = safeMul(amountTokens, precision) / 570000000;
280         uint256 developmentAllocation = safeMul(allocationRatio, 380000000) / precision;
281         // check that token cap is not exceeded
282         uint256 newTokens = safeAdd(amountTokens, developmentAllocation);
283         require(safeAdd(totalSupply, newTokens) <= tokenCap);
284         // increase token supply, assign tokens to participant
285         totalSupply = safeAdd(totalSupply, newTokens);
286         balances[participant] = safeAdd(balances[participant], amountTokens);
287         balances[vestingContract] = safeAdd(balances[vestingContract], developmentAllocation);
288     }
289     
290     function allocatePresaleTokens(
291 			       address participant_address,
292 			       string participant_str,
293 			       uint256 amountTokens,
294 			       string txnHash
295 			       )
296       external onlyFundWallet {
297 
298       require(currentBlock() < fundingEndBlock);
299       require(participant_address != address(0));
300      
301       uint256 bonusTokens = 0;
302       uint256 totalTokens = amountTokens;
303 
304       if (firstDigit(txnHash) == firstDigit(participant_str)) {
305 	  // Calculate 10% bonus
306 	  bonusTokens = safeMul(totalTokens, 10) / 100;
307 	  totalTokens = safeAdd(totalTokens, bonusTokens);
308       }
309 
310         whitelist[participant_address] = true;
311         allocateTokens(participant_address, totalTokens);
312         Whitelist(participant_address);
313         AllocatePresale(participant_address, totalTokens);
314 	BonusAllocation(participant_address, participant_str, bonusTokens);
315     }
316 
317     // returns the first character as a byte in a given string address
318     // Given 0x1abcd... returns 1 
319     function firstDigit(string s) pure public returns(byte){
320 	bytes memory strBytes = bytes(s);
321 	return strBytes[2];
322       }
323 
324     function verifyParticipant(address participant) external onlyManagingWallets {
325         whitelist[participant] = true;
326         Whitelist(participant);
327     }
328 
329     function buy() external payable {
330         buyTo(msg.sender);
331     }
332 
333     function buyTo(address participant) public payable onlyWhitelist {
334         require(!halted);
335         require(participant != address(0));
336         require(msg.value >= minAmount);
337         require(currentBlock() >= fundingStartBlock && currentBlock() < fundingEndBlock);
338 	// msg.value in wei - scale to ether after applying price numerator
339         uint256 tokensToBuy = safeMul(msg.value, currentPrice.numerator) / (1 ether);
340         allocateTokens(participant, tokensToBuy);
341         // send ether to fundWallet
342         fundWallet.transfer(msg.value);
343         Buy(msg.sender, participant, msg.value, tokensToBuy);
344     }
345 
346     // time based on blocknumbers, assuming a blocktime of 15s
347     function icoNumeratorPrice() public constant returns (uint256) {
348         uint256 icoDuration = safeSub(currentBlock(), fundingStartBlock);
349         uint256 numerator;
350 
351         uint256 firstBlockPhase = 80640; // #blocks = 2*7*24*60*60/15 = 80640
352         uint256 secondBlockPhase = 161280; // // #blocks = 4*7*24*60*60/15 = 161280
353         uint256 thirdBlockPhase = 241920; // // #blocks = 6*7*24*60*60/15 = 241920
354         //uint256 fourthBlock = 322560; // #blocks = Greater Than thirdBlock
355 
356         if (icoDuration < firstBlockPhase ) {
357             numerator = 13000;
358 	    return numerator;
359         } else if (icoDuration < secondBlockPhase ) { 
360             numerator = 12000;
361 	    return numerator;
362         } else if (icoDuration < thirdBlockPhase ) { 
363             numerator = 11000;
364 	    return numerator;
365         } else {
366             numerator = 10000;
367 	    return numerator;
368         }
369     }
370 
371     function currentBlock() private constant returns(uint256 _currentBlock) {
372       return block.number;
373     }
374 
375     function currentTime() private constant returns(uint256 _currentTime) {
376       return now;
377     }      
378 
379     function requestWithdrawal(uint256 amountTokensToWithdraw) external isTradeable onlyWhitelist {
380       require(currentBlock() > fundingEndBlock);
381         require(amountTokensToWithdraw > 0);
382         address participant = msg.sender;
383         require(balanceOf(participant) >= amountTokensToWithdraw);
384         require(withdrawals[participant].tokens == 0); // participant cannot have outstanding withdrawals
385         balances[participant] = safeSub(balances[participant], amountTokensToWithdraw);
386         withdrawals[participant] = Withdrawal({tokens: amountTokensToWithdraw, time: previousUpdateTime});
387         WithdrawRequest(participant, amountTokensToWithdraw);
388     }
389 
390     function withdraw() external {
391         address participant = msg.sender;
392         uint256 tokens = withdrawals[participant].tokens;
393         require(tokens > 0); // participant must have requested a withdrawal
394         uint256 requestTime = withdrawals[participant].time;
395         // obtain the next price that was set after the request
396         Price price = prices[requestTime];
397         require(price.numerator > 0); // price must have been set
398         uint256 withdrawValue = safeMul(tokens, price.numerator);
399         // if contract ethbal > then send + transfer tokens to fundWallet, otherwise give tokens back
400         withdrawals[participant].tokens = 0;
401         if (this.balance >= withdrawValue)
402             enact_withdrawal_greater_equal(participant, withdrawValue, tokens);
403         else
404             enact_withdrawal_less(participant, withdrawValue, tokens);
405     }
406 
407     function enact_withdrawal_greater_equal(address participant, uint256 withdrawValue, uint256 tokens)
408         private
409     {
410         assert(this.balance >= withdrawValue);
411         balances[fundWallet] = safeAdd(balances[fundWallet], tokens);
412         participant.transfer(withdrawValue);
413         Withdraw(participant, tokens, withdrawValue);
414     }
415     function enact_withdrawal_less(address participant, uint256 withdrawValue, uint256 tokens)
416         private
417     {
418         assert(this.balance < withdrawValue);
419         balances[participant] = safeAdd(balances[participant], tokens);
420         Withdraw(participant, tokens, 0); // indicate a failed withdrawal
421     }
422 
423 
424     function checkWithdrawValue(uint256 amountTokensToWithdraw) public constant returns (uint256 etherValue) {
425         require(amountTokensToWithdraw > 0);
426         require(balanceOf(msg.sender) >= amountTokensToWithdraw);
427         uint256 withdrawValue = safeMul(amountTokensToWithdraw, currentPrice.numerator);
428         require(this.balance >= withdrawValue);
429         return withdrawValue;
430     }
431 
432     // allow fundWallet or controlWallet to add ether to contract
433     function addLiquidity() external onlyManagingWallets payable {
434         require(msg.value > 0);
435         AddLiquidity(msg.value);
436     }
437 
438     // allow fundWallet to remove ether from contract
439     function removeLiquidity(uint256 amount) external onlyManagingWallets {
440         require(amount <= this.balance);
441         fundWallet.transfer(amount);
442         RemoveLiquidity(amount);
443     }
444 
445     function changeFundWallet(address newFundWallet) external onlyFundWallet {
446         require(newFundWallet != address(0));
447         fundWallet = newFundWallet;
448     }
449 
450     function changeControlWallet(address newControlWallet) external onlyFundWallet {
451         require(newControlWallet != address(0));
452         controlWallet = newControlWallet;
453     }
454 
455     function changeWaitTime(uint256 newWaitTime) external onlyFundWallet {
456         waitTime = newWaitTime;
457     }
458 
459     function updateFundingStartBlock(uint256 newFundingStartBlock) external onlyFundWallet {
460       require(currentBlock() < fundingStartBlock);
461         require(currentBlock() < newFundingStartBlock);
462         fundingStartBlock = newFundingStartBlock;
463     }
464 
465     function updateFundingEndBlock(uint256 newFundingEndBlock) external onlyFundWallet {
466         require(currentBlock() < fundingEndBlock);
467         require(currentBlock() < newFundingEndBlock);
468         fundingEndBlock = newFundingEndBlock;
469     }
470 
471     function halt() external onlyFundWallet {
472         halted = true;
473     }
474     function unhalt() external onlyFundWallet {
475         halted = false;
476     }
477 
478     function enableTrading() external onlyFundWallet {
479         require(currentBlock() > fundingEndBlock);
480         tradeable = true;
481     }
482 
483     // fallback function
484     function() payable public {
485         require(tx.origin == msg.sender);
486         buyTo(msg.sender);
487     }
488 
489     function claimTokens(address _token) external onlyFundWallet {
490         require(_token != address(0));
491         Token token = Token(_token);
492         uint256 balance = token.balanceOf(this);
493         token.transfer(fundWallet, balance);
494      }
495 
496     // prevent transfers until trading allowed
497     function transfer(address _to, uint256 _value) public isTradeable returns (bool success) {
498         return super.transfer(_to, _value);
499     }
500     function transferFrom(address _from, address _to, uint256 _value) public isTradeable returns (bool success) {
501         return super.transferFrom(_from, _to, _value);
502     }
503 }