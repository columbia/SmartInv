1 pragma solidity 0.4.11;
2 
3 contract SafeMath {
4 
5   function safeMul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10   function safeSub(uint a, uint b) internal returns (uint) {
11     assert(b <= a);
12     return a - b;
13   }
14   function safeAdd(uint a, uint b) internal returns (uint) {
15     uint c = a + b;
16     assert(c>=a && c>=b);
17     return c;
18   }
19 
20   // mitigate short address attack
21   // thanks to https://github.com/numerai/contract/blob/c182465f82e50ced8dacb3977ec374a892f5fa8c/contracts/Safe.sol#L30-L34.
22   // TODO: doublecheck implication of >= compared to ==
23   modifier onlyPayloadSize(uint numWords) {
24      assert(msg.data.length >= numWords * 32 + 4);
25      _;
26   }
27 
28 }
29 
30 
31 contract Token { // ERC20 standard
32 
33     function balanceOf(address _owner) constant returns (uint256 balance);
34     function transfer(address _to, uint256 _value) returns (bool success);
35     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
36     function approve(address _spender, uint256 _value) returns (bool success);
37     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41 }
42 
43 
44 contract StandardToken is Token, SafeMath {
45 
46     uint256 public totalSupply;
47 
48     // TODO: update tests to expect throw
49     function transfer(address _to, uint256 _value) onlyPayloadSize(2) returns (bool success) {
50         require(_to != address(0));
51         require(balances[msg.sender] >= _value && _value > 0);
52         balances[msg.sender] = safeSub(balances[msg.sender], _value);
53         balances[_to] = safeAdd(balances[_to], _value);
54         Transfer(msg.sender, _to, _value);
55 
56         return true;
57     }
58 
59     // TODO: update tests to expect throw
60     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) returns (bool success) {
61         require(_to != address(0));
62         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
63         balances[_from] = safeSub(balances[_from], _value);
64         balances[_to] = safeAdd(balances[_to], _value);
65         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
66         Transfer(_from, _to, _value);
67 
68         return true;
69     }
70 
71     function balanceOf(address _owner) constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     // To change the approve amount you first have to reduce the addresses'
76     //  allowance to zero by calling 'approve(_spender, 0)' if it is not
77     //  already 0 to mitigate the race condition described here:
78     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79     function approve(address _spender, uint256 _value) onlyPayloadSize(2) returns (bool success) {
80         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83 
84         return true;
85     }
86 
87     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) onlyPayloadSize(3) returns (bool success) {
88         require(allowed[msg.sender][_spender] == _oldValue);
89         allowed[msg.sender][_spender] = _newValue;
90         Approval(msg.sender, _spender, _newValue);
91 
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
96       return allowed[_owner][_spender];
97     }
98 
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101 
102 }
103 
104 
105 contract C20 is StandardToken {
106 
107     // FIELDS
108 
109     string public name = "Crypto20";
110     string public symbol = "C20";
111     uint256 public decimals = 18;
112     string public version = "9.0";
113 
114     uint256 public tokenCap = 86206896 * 10**18;
115 
116     // crowdsale parameters
117     uint256 public fundingStartBlock;
118     uint256 public fundingEndBlock;
119 
120     // vesting fields
121     address public vestingContract;
122     bool private vestingSet = false;
123 
124     // root control
125     address public fundWallet;
126     // control of liquidity and limited control of updatePrice
127     address public controlWallet;
128     // time to wait between controlWallet price updates
129     uint256 public waitTime = 5 hours;
130 
131     // fundWallet controlled state variables
132     // halted: halt buying due to emergency, tradeable: signal that assets have been acquired
133     bool public halted = false;
134     bool public tradeable = false;
135 
136     // -- totalSupply defined in StandardToken
137     // -- mapping to token balances done in StandardToken
138 
139     uint256 public previousUpdateTime = 0;
140     Price public currentPrice;
141     uint256 public minAmount = 0.04 ether;
142 
143     // map participant address to a withdrawal request
144     mapping (address => Withdrawal) public withdrawals;
145     // maps previousUpdateTime to the next price
146     mapping (uint256 => Price) public prices;
147     // maps addresses
148     mapping (address => bool) public whitelist;
149 
150     // TYPES
151 
152     struct Price { // tokensPerEth
153         uint256 numerator;
154         uint256 denominator;
155     }
156 
157     struct Withdrawal {
158         uint256 tokens;
159         uint256 time; // time for each withdrawal is set to the previousUpdateTime
160     }
161 
162     // EVENTS
163 
164     event Buy(address indexed participant, address indexed beneficiary, uint256 ethValue, uint256 amountTokens);
165     event AllocatePresale(address indexed participant, uint256 amountTokens);
166     event Whitelist(address indexed participant);
167     event PriceUpdate(uint256 numerator, uint256 denominator);
168     event AddLiquidity(uint256 ethAmount);
169     event RemoveLiquidity(uint256 ethAmount);
170     event WithdrawRequest(address indexed participant, uint256 amountTokens);
171     event Withdraw(address indexed participant, uint256 amountTokens, uint256 etherAmount);
172 
173     // MODIFIERS
174 
175     modifier isTradeable { // exempt vestingContract and fundWallet to allow dev allocations
176         require(tradeable || msg.sender == fundWallet || msg.sender == vestingContract);
177         _;
178     }
179 
180     modifier onlyWhitelist {
181         require(whitelist[msg.sender]);
182         _;
183     }
184 
185     modifier onlyFundWallet {
186         require(msg.sender == fundWallet);
187         _;
188     }
189 
190     modifier onlyManagingWallets {
191         require(msg.sender == controlWallet || msg.sender == fundWallet);
192         _;
193     }
194 
195     modifier only_if_controlWallet {
196         if (msg.sender == controlWallet) _;
197     }
198     modifier require_waited {
199         require(safeSub(now, waitTime) >= previousUpdateTime);
200         _;
201     }
202     modifier only_if_increase (uint256 newNumerator) {
203         if (newNumerator > currentPrice.numerator) _;
204     }
205 
206     // CONSTRUCTOR
207 
208     function C20(address controlWalletInput, uint256 priceNumeratorInput, uint256 startBlockInput, uint256 endBlockInput) {
209         require(controlWalletInput != address(0));
210         require(priceNumeratorInput > 0);
211         require(endBlockInput > startBlockInput);
212         fundWallet = msg.sender;
213         controlWallet = controlWalletInput;
214         whitelist[fundWallet] = true;
215         whitelist[controlWallet] = true;
216         currentPrice = Price(priceNumeratorInput, 1000); // 1 token = 1 usd at ICO start
217         fundingStartBlock = startBlockInput;
218         fundingEndBlock = endBlockInput;
219         previousUpdateTime = now;
220     }
221 
222     // METHODS
223 
224     function setVestingContract(address vestingContractInput) external onlyFundWallet {
225         require(vestingContractInput != address(0));
226         vestingContract = vestingContractInput;
227         whitelist[vestingContract] = true;
228         vestingSet = true;
229     }
230 
231     // allows controlWallet to update the price within a time contstraint, allows fundWallet complete control
232     function updatePrice(uint256 newNumerator) external onlyManagingWallets {
233         require(newNumerator > 0);
234         require_limited_change(newNumerator);
235         // either controlWallet command is compliant or transaction came from fundWallet
236         currentPrice.numerator = newNumerator;
237         // maps time to new Price (if not during ICO)
238         prices[previousUpdateTime] = currentPrice;
239         previousUpdateTime = now;
240         PriceUpdate(newNumerator, currentPrice.denominator);
241     }
242 
243     function require_limited_change (uint256 newNumerator)
244         private
245         only_if_controlWallet
246         require_waited
247         only_if_increase(newNumerator)
248     {
249         uint256 percentage_diff = 0;
250         percentage_diff = safeMul(newNumerator, 100) / currentPrice.numerator;
251         percentage_diff = safeSub(percentage_diff, 100);
252         // controlWallet can only increase price by max 20% and only every waitTime
253         require(percentage_diff <= 20);
254     }
255 
256     function updatePriceDenominator(uint256 newDenominator) external onlyFundWallet {
257         require(block.number > fundingEndBlock);
258         require(newDenominator > 0);
259         currentPrice.denominator = newDenominator;
260         // maps time to new Price
261         prices[previousUpdateTime] = currentPrice;
262         previousUpdateTime = now;
263         PriceUpdate(currentPrice.numerator, newDenominator);
264     }
265 
266     function allocateTokens(address participant, uint256 amountTokens) private {
267         require(vestingSet);
268         // 13% of total allocated for PR, Marketing, Team, Advisors
269         uint256 developmentAllocation = safeMul(amountTokens, 14942528735632185) / 100000000000000000;
270         // check that token cap is not exceeded
271         uint256 newTokens = safeAdd(amountTokens, developmentAllocation);
272         require(safeAdd(totalSupply, newTokens) <= tokenCap);
273         // increase token supply, assign tokens to participant
274         totalSupply = safeAdd(totalSupply, newTokens);
275         balances[participant] = safeAdd(balances[participant], amountTokens);
276         balances[vestingContract] = safeAdd(balances[vestingContract], developmentAllocation);
277     }
278 
279     function allocatePresaleTokens(address participant, uint amountTokens) external onlyFundWallet {
280         require(block.number < fundingEndBlock);
281         require(participant != address(0));
282         whitelist[participant] = true; // automatically whitelist accepted presale
283         allocateTokens(participant, amountTokens);
284         Whitelist(participant);
285         AllocatePresale(participant, amountTokens);
286     }
287 
288     function verifyParticipant(address participant) external onlyManagingWallets {
289         whitelist[participant] = true;
290         Whitelist(participant);
291     }
292 
293     function buy() external payable {
294         buyTo(msg.sender);
295     }
296 
297     function buyTo(address participant) public payable onlyWhitelist {
298         require(!halted);
299         require(participant != address(0));
300         require(msg.value >= minAmount);
301         require(block.number >= fundingStartBlock && block.number < fundingEndBlock);
302         uint256 icoDenominator = icoDenominatorPrice();
303         uint256 tokensToBuy = safeMul(msg.value, currentPrice.numerator) / icoDenominator;
304         allocateTokens(participant, tokensToBuy);
305         // send ether to fundWallet
306         fundWallet.transfer(msg.value);
307         Buy(msg.sender, participant, msg.value, tokensToBuy);
308     }
309 
310     // time based on blocknumbers, assuming a blocktime of 30s
311     function icoDenominatorPrice() public constant returns (uint256) {
312         uint256 icoDuration = safeSub(block.number, fundingStartBlock);
313         uint256 denominator;
314         if (icoDuration < 2880) { // #blocks = 24*60*60/30 = 2880
315             return currentPrice.denominator;
316         } else if (icoDuration < 80640 ) { // #blocks = 4*7*24*60*60/30 = 80640
317             denominator = safeMul(currentPrice.denominator, 105) / 100;
318             return denominator;
319         } else {
320             denominator = safeMul(currentPrice.denominator, 110) / 100;
321             return denominator;
322         }
323     }
324 
325     function requestWithdrawal(uint256 amountTokensToWithdraw) external isTradeable onlyWhitelist {
326         require(block.number > fundingEndBlock);
327         require(amountTokensToWithdraw > 0);
328         address participant = msg.sender;
329         require(balanceOf(participant) >= amountTokensToWithdraw);
330         require(withdrawals[participant].tokens == 0); // participant cannot have outstanding withdrawals
331         balances[participant] = safeSub(balances[participant], amountTokensToWithdraw);
332         withdrawals[participant] = Withdrawal({tokens: amountTokensToWithdraw, time: previousUpdateTime});
333         WithdrawRequest(participant, amountTokensToWithdraw);
334     }
335 
336     function withdraw() external {
337         address participant = msg.sender;
338         uint256 tokens = withdrawals[participant].tokens;
339         require(tokens > 0); // participant must have requested a withdrawal
340         uint256 requestTime = withdrawals[participant].time;
341         // obtain the next price that was set after the request
342         Price price = prices[requestTime];
343         require(price.numerator > 0); // price must have been set
344         uint256 withdrawValue = safeMul(tokens, price.denominator) / price.numerator;
345         // if contract ethbal > then send + transfer tokens to fundWallet, otherwise give tokens back
346         withdrawals[participant].tokens = 0;
347         if (this.balance >= withdrawValue)
348             enact_withdrawal_greater_equal(participant, withdrawValue, tokens);
349         else
350             enact_withdrawal_less(participant, withdrawValue, tokens);
351     }
352 
353     function enact_withdrawal_greater_equal(address participant, uint256 withdrawValue, uint256 tokens)
354         private
355     {
356         assert(this.balance >= withdrawValue);
357         balances[fundWallet] = safeAdd(balances[fundWallet], tokens);
358         participant.transfer(withdrawValue);
359         Withdraw(participant, tokens, withdrawValue);
360     }
361     function enact_withdrawal_less(address participant, uint256 withdrawValue, uint256 tokens)
362         private
363     {
364         assert(this.balance < withdrawValue);
365         balances[participant] = safeAdd(balances[participant], tokens);
366         Withdraw(participant, tokens, 0); // indicate a failed withdrawal
367     }
368 
369 
370     function checkWithdrawValue(uint256 amountTokensToWithdraw) constant returns (uint256 etherValue) {
371         require(amountTokensToWithdraw > 0);
372         require(balanceOf(msg.sender) >= amountTokensToWithdraw);
373         uint256 withdrawValue = safeMul(amountTokensToWithdraw, currentPrice.denominator) / currentPrice.numerator;
374         require(this.balance >= withdrawValue);
375         return withdrawValue;
376     }
377 
378     // allow fundWallet or controlWallet to add ether to contract
379     function addLiquidity() external onlyManagingWallets payable {
380         require(msg.value > 0);
381         AddLiquidity(msg.value);
382     }
383 
384     // allow fundWallet to remove ether from contract
385     function removeLiquidity(uint256 amount) external onlyManagingWallets {
386         require(amount <= this.balance);
387         fundWallet.transfer(amount);
388         RemoveLiquidity(amount);
389     }
390 
391     function changeFundWallet(address newFundWallet) external onlyFundWallet {
392         require(newFundWallet != address(0));
393         fundWallet = newFundWallet;
394     }
395 
396     function changeControlWallet(address newControlWallet) external onlyFundWallet {
397         require(newControlWallet != address(0));
398         controlWallet = newControlWallet;
399     }
400 
401     function changeWaitTime(uint256 newWaitTime) external onlyFundWallet {
402         waitTime = newWaitTime;
403     }
404 
405     function updateFundingStartBlock(uint256 newFundingStartBlock) external onlyFundWallet {
406         require(block.number < fundingStartBlock);
407         require(block.number < newFundingStartBlock);
408         fundingStartBlock = newFundingStartBlock;
409     }
410 
411     function updateFundingEndBlock(uint256 newFundingEndBlock) external onlyFundWallet {
412         require(block.number < fundingEndBlock);
413         require(block.number < newFundingEndBlock);
414         fundingEndBlock = newFundingEndBlock;
415     }
416 
417     function halt() external onlyFundWallet {
418         halted = true;
419     }
420     function unhalt() external onlyFundWallet {
421         halted = false;
422     }
423 
424     function enableTrading() external onlyFundWallet {
425         require(block.number > fundingEndBlock);
426         tradeable = true;
427     }
428 
429     // fallback function
430     function() payable {
431         require(tx.origin == msg.sender);
432         buyTo(msg.sender);
433     }
434 
435     function claimTokens(address _token) external onlyFundWallet {
436         require(_token != address(0));
437         Token token = Token(_token);
438         uint256 balance = token.balanceOf(this);
439         token.transfer(fundWallet, balance);
440      }
441 
442     // prevent transfers until trading allowed
443     function transfer(address _to, uint256 _value) isTradeable returns (bool success) {
444         return super.transfer(_to, _value);
445     }
446     function transferFrom(address _from, address _to, uint256 _value) isTradeable returns (bool success) {
447         return super.transferFrom(_from, _to, _value);
448     }
449 
450 }