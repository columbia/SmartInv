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
107 
108 contract GRO is StandardToken {
109     // FIELDS
110     string public name = "Gron Digital";
111     string public symbol = "GRO";
112     uint256 public decimals = 18;
113     string public version = "10.0";
114 
115     // Nine Hundred and Fifty million with support for 18 decimals
116     uint256 public tokenCap = 950000000 * 10**18;
117 
118     // crowdsale parameters
119     uint256 public fundingStartBlock;
120     uint256 public fundingEndBlock;
121 
122     // vesting fields
123     address public vestingContract;
124     bool private vestingSet = false;
125 
126     // root control
127     address public fundWallet;
128     // control of liquidity and limited control of updatePrice
129     address public controlWallet;
130     // time to wait between controlWallet price updates
131     uint256 public waitTime = 5 hours;
132 
133     // fundWallet controlled state variables
134     // halted: halt buying due to emergency, tradeable: signal that GRON platform is up and running
135     bool public halted = false;
136     bool public tradeable = false;
137 
138     // -- totalSupply defined in StandardToken
139     // -- mapping to token balances done in StandardToken
140 
141     uint256 public previousUpdateTime = 0;
142     Price public currentPrice;
143     uint256 public minAmount = 0.05 ether; // 500 GRO
144 
145     // map participant address to a withdrawal request
146     mapping (address => Withdrawal) public withdrawals;
147     // maps previousUpdateTime to the next price
148     mapping (uint256 => Price) public prices;
149     // maps addresses
150     mapping (address => bool) public whitelist;
151 
152     // TYPES
153 
154     struct Price { // tokensPerEth
155         uint256 numerator;
156     }
157 
158     struct Withdrawal {
159         uint256 tokens;
160         uint256 time; // time for each withdrawal is set to the previousUpdateTime
161     }
162 
163     // EVENTS
164 
165     event Buy(address indexed participant, address indexed beneficiary, uint256 weiValue, uint256 amountTokens);
166     event AllocatePresale(address indexed participant, uint256 amountTokens);
167     event BonusAllocation(address indexed participant, string participant_addr, string txnHash, uint256 bonusTokens);
168     event Mint(address indexed to, uint256 amount);
169     event Whitelist(address indexed participant);
170     event PriceUpdate(uint256 numerator);
171     event AddLiquidity(uint256 ethAmount);
172     event RemoveLiquidity(uint256 ethAmount);
173     event WithdrawRequest(address indexed participant, uint256 amountTokens);
174     event Withdraw(address indexed participant, uint256 amountTokens, uint256 etherAmount);
175 
176     // MODIFIERS
177 
178     modifier isTradeable { // exempt vestingContract and fundWallet to allow dev allocations
179         require(tradeable || msg.sender == fundWallet || msg.sender == vestingContract);
180         _;
181     }
182 
183     modifier onlyWhitelist {
184         require(whitelist[msg.sender]);
185         _;
186     }
187 
188     modifier onlyFundWallet {
189         require(msg.sender == fundWallet);
190         _;
191     }
192 
193     modifier onlyManagingWallets {
194         require(msg.sender == controlWallet || msg.sender == fundWallet);
195         _;
196     }
197 
198     modifier only_if_controlWallet {
199         if (msg.sender == controlWallet) _;
200     }
201     modifier require_waited {
202       require(safeSub(currentTime(), waitTime) >= previousUpdateTime);
203         _;
204     }
205     modifier only_if_decrease (uint256 newNumerator) {
206         if (newNumerator < currentPrice.numerator) _;
207     }
208 
209     // CONSTRUCTOR
210     function GRO() public {
211         fundWallet = msg.sender;
212         whitelist[fundWallet] = true;
213         previousUpdateTime = currentTime();
214     }
215 
216     // Called after deployment
217     // Not all deployment clients support constructor arguments.
218     // This function is provided for maximum compatibility. 
219     function initialiseContract(address controlWalletInput, uint256 priceNumeratorInput, uint256 startBlockInput, uint256 endBlockInput) external onlyFundWallet {
220       require(controlWalletInput != address(0));
221       require(priceNumeratorInput > 0);
222       require(endBlockInput > startBlockInput);
223       controlWallet = controlWalletInput;
224       whitelist[controlWallet] = true;
225       currentPrice = Price(priceNumeratorInput);
226       fundingStartBlock = startBlockInput;
227       fundingEndBlock = endBlockInput;
228       previousUpdateTime = currentTime();
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
290     // amountTokens is not supplied in subunits. (without 18 0's)
291     function allocatePresaleTokens(
292 			       address participant_address,
293 			       string participant_str,
294 			       uint256 amountTokens,
295 			       string txnHash
296 			       )
297       external onlyFundWallet {
298 
299       require(currentBlock() < fundingEndBlock);
300       require(participant_address != address(0));
301      
302       uint256 bonusTokens = 0;
303       uint256 totalTokens = safeMul(amountTokens, 10**18); // scale to subunit
304 
305       if (firstDigit(txnHash) == firstDigit(participant_str)) {
306 	  // Calculate 10% bonus
307 	  bonusTokens = safeMul(totalTokens, 10) / 100;
308 	  totalTokens = safeAdd(totalTokens, bonusTokens);
309       }
310 
311         whitelist[participant_address] = true;
312         mint(participant_address, totalTokens);
313 	// Events
314         Whitelist(participant_address);
315         AllocatePresale(participant_address, totalTokens);
316 	BonusAllocation(participant_address, participant_str, txnHash, bonusTokens);
317     }
318 
319     // returns the first character as a byte in a given hex string
320     // address Given 0x1abcd... returns 1
321     function firstDigit(string s) pure public returns(byte){
322 	bytes memory strBytes = bytes(s);
323 	return strBytes[2];
324       }
325 
326     function verifyParticipant(address participant) external onlyManagingWallets {
327         whitelist[participant] = true;
328         Whitelist(participant);
329     }
330 
331     function buy() external payable {
332         buyTo(msg.sender);
333     }
334 
335     function buyTo(address participant) public payable onlyWhitelist {
336       require(!halted);
337       require(participant != address(0));
338       require(msg.value >= minAmount);
339       require(currentBlock() >= fundingStartBlock && currentBlock() < fundingEndBlock);
340       // msg.value in wei - scale to GRO
341       uint256 baseAmountTokens = safeMul(msg.value, currentPrice.numerator);
342       // calc lottery amount excluding potential ico bonus
343       uint256 lotteryAmount = blockLottery(baseAmountTokens);
344       uint256 icoAmount = safeMul(msg.value, icoNumeratorPrice());
345 
346       uint256 tokensToBuy = safeAdd(icoAmount, lotteryAmount);
347       mint(participant, tokensToBuy);
348       // send ether to fundWallet
349       fundWallet.transfer(msg.value);
350       // Events
351       Buy(msg.sender, participant, msg.value, tokensToBuy);
352     }
353 
354     // time based on blocknumbers, assuming a blocktime of 15s
355     function icoNumeratorPrice() public constant returns (uint256) {
356         uint256 icoDuration = safeSub(currentBlock(), fundingStartBlock);
357         uint256 numerator;
358 
359         uint256 firstBlockPhase = 80640; // #blocks = 2*7*24*60*60/15 = 80640
360         uint256 secondBlockPhase = 161280; // // #blocks = 4*7*24*60*60/15 = 161280
361         uint256 thirdBlockPhase = 241920; // // #blocks = 6*7*24*60*60/15 = 241920
362         //uint256 fourthBlock = 322560; // #blocks = Greater Than thirdBlock
363 
364         if (icoDuration < firstBlockPhase ) {
365             numerator = 13000;
366 	    return numerator;
367         } else if (icoDuration < secondBlockPhase ) { 
368             numerator = 12000;
369 	    return numerator;
370         } else if (icoDuration < thirdBlockPhase ) { 
371             numerator = 11000;
372 	    return numerator;
373         } else {
374             numerator = 10000;
375 	    return numerator;
376         }
377     }
378 
379     function currentBlock() private constant returns(uint256 _currentBlock) {
380       return block.number;
381     }
382 
383     function currentTime() private constant returns(uint256 _currentTime) {
384       return now;
385     }
386 
387     function blockLottery(uint256 _amountTokens) private constant returns(uint256) {
388       uint256 divisor = 10;
389       uint256 winning_digit = 0;
390       uint256 tokenWinnings = 0;
391 
392       if (currentBlock() % divisor == winning_digit) {
393 	tokenWinnings = safeMul(_amountTokens, 10) / 100;
394       }
395       
396       return tokenWinnings;	
397     }
398 
399     function requestWithdrawal(uint256 amountTokensToWithdraw) external isTradeable onlyWhitelist {
400       require(currentBlock() > fundingEndBlock);
401         require(amountTokensToWithdraw > 0);
402         address participant = msg.sender;
403         require(balanceOf(participant) >= amountTokensToWithdraw);
404         require(withdrawals[participant].tokens == 0); // participant cannot have outstanding withdrawals
405         balances[participant] = safeSub(balances[participant], amountTokensToWithdraw);
406         withdrawals[participant] = Withdrawal({tokens: amountTokensToWithdraw, time: previousUpdateTime});
407         WithdrawRequest(participant, amountTokensToWithdraw);
408     }
409 
410     function withdraw() external {
411         address participant = msg.sender;
412         uint256 tokens = withdrawals[participant].tokens;
413         require(tokens > 0); // participant must have requested a withdrawal
414         uint256 requestTime = withdrawals[participant].time;
415         // obtain the next price that was set after the request
416         Price price = prices[requestTime];
417         require(price.numerator > 0); // price must have been set
418         uint256 withdrawValue = tokens / price.numerator;
419         // if contract ethbal > then send + transfer tokens to fundWallet, otherwise give tokens back
420         withdrawals[participant].tokens = 0;
421         if (this.balance >= withdrawValue) {
422             enact_withdrawal_greater_equal(participant, withdrawValue, tokens);
423 	}
424         else {
425             enact_withdrawal_less(participant, withdrawValue, tokens);
426 	}
427     }
428 
429     function enact_withdrawal_greater_equal(address participant, uint256 withdrawValue, uint256 tokens)
430         private
431     {
432         assert(this.balance >= withdrawValue);
433         balances[fundWallet] = safeAdd(balances[fundWallet], tokens);
434         participant.transfer(withdrawValue);
435         Withdraw(participant, tokens, withdrawValue);
436     }
437     function enact_withdrawal_less(address participant, uint256 withdrawValue, uint256 tokens)
438         private
439     {
440         assert(this.balance < withdrawValue);
441         balances[participant] = safeAdd(balances[participant], tokens);
442         Withdraw(participant, tokens, 0); // indicate a failed withdrawal
443     }
444 
445 
446     function checkWithdrawValue(uint256 amountTokensToWithdraw) public constant returns (uint256 etherValue) {
447         require(amountTokensToWithdraw > 0);
448         require(balanceOf(msg.sender) >= amountTokensToWithdraw);
449         uint256 withdrawValue = safeMul(amountTokensToWithdraw, currentPrice.numerator);
450         require(this.balance >= withdrawValue);
451         return withdrawValue;
452     }
453 
454     // allow fundWallet or controlWallet to add ether to contract
455     function addLiquidity() external onlyManagingWallets payable {
456         require(msg.value > 0);
457         AddLiquidity(msg.value);
458     }
459 
460     // allow fundWallet to remove ether from contract
461     function removeLiquidity(uint256 amount) external onlyManagingWallets {
462         require(amount <= this.balance);
463         fundWallet.transfer(amount);
464         RemoveLiquidity(amount);
465     }
466 
467     function changeFundWallet(address newFundWallet) external onlyFundWallet {
468         require(newFundWallet != address(0));
469         fundWallet = newFundWallet;
470     }
471 
472     function changeControlWallet(address newControlWallet) external onlyFundWallet {
473         require(newControlWallet != address(0));
474         controlWallet = newControlWallet;
475     }
476 
477     function changeWaitTime(uint256 newWaitTime) external onlyFundWallet {
478         waitTime = newWaitTime;
479     }
480 
481     function updateFundingStartBlock(uint256 newFundingStartBlock) external onlyFundWallet {
482       require(currentBlock() < fundingStartBlock);
483         require(currentBlock() < newFundingStartBlock);
484         fundingStartBlock = newFundingStartBlock;
485     }
486 
487     function updateFundingEndBlock(uint256 newFundingEndBlock) external onlyFundWallet {
488         require(currentBlock() < fundingEndBlock);
489         require(currentBlock() < newFundingEndBlock);
490         fundingEndBlock = newFundingEndBlock;
491     }
492 
493     function halt() external onlyFundWallet {
494         halted = true;
495     }
496     function unhalt() external onlyFundWallet {
497         halted = false;
498     }
499 
500     function enableTrading() external onlyFundWallet {
501         require(currentBlock() > fundingEndBlock);
502         tradeable = true;
503     }
504 
505     function claimTokens(address _token) external onlyFundWallet {
506         require(_token != address(0));
507         Token token = Token(_token);
508         uint256 balance = token.balanceOf(this);
509         token.transfer(fundWallet, balance);
510      }
511 
512     // prevent transfers until trading allowed
513     function transfer(address _to, uint256 _value) public isTradeable returns (bool success) {
514         return super.transfer(_to, _value);
515     }
516     function transferFrom(address _from, address _to, uint256 _value) public isTradeable returns (bool success) {
517         return super.transferFrom(_from, _to, _value);
518     }
519 }