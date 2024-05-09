1 pragma solidity ^0.4.13;
2 
3 /**
4  * Overflow aware uint math functions.
5  *
6  * Inspired by https://github.com/MakerDAO/maker-otc/blob/master/contracts/simple_market.sol
7  */
8 contract SafeMath {
9     //internals
10 
11     function safeMul(uint a, uint b) internal returns (uint) {
12         uint c = a * b;
13         require(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function safeSub(uint a, uint b) internal returns (uint) {
18         require(b <= a);
19         return a - b;
20     }
21 
22     function safeAdd(uint a, uint b) internal returns (uint) {
23         uint c = a + b;
24         require(c>=a && c>=b);
25         return c;
26     }
27 
28     function safeDiv(uint a, uint b) internal returns (uint) {
29         require(b > 0);
30         uint c = a / b;
31         require(a == b * c + a % b);
32         return c;
33     }
34 }
35 
36 
37 /**
38  * ERC 20 token
39  *
40  * https://github.com/ethereum/EIPs/issues/20
41  */
42 interface Token {
43 
44     /// @param _owner The address from which the balance will be retrieved
45     /// @return The balance
46     function balanceOf(address _owner) constant returns (uint256 balance);
47 
48     /// @notice send `_value` token to `_to` from `msg.sender`
49     /// @param _to The address of the recipient
50     /// @param _value The amount of token to be transferred
51     /// @return Whether the transfer was successful or not
52     function transfer(address _to, uint256 _value) returns (bool success);
53 
54     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
55     /// @param _from The address of the sender
56     /// @param _to The address of the recipient
57     /// @param _value The amount of token to be transferred
58     /// @return Whether the transfer was successful or not
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
60 
61     /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
62     /// @param _spender The address of the account able to transfer the tokens
63     /// @param _value The amount of wei to be approved for transfer
64     /// @return Whether the approval was successful or not
65     function approve(address _spender, uint256 _value) returns (bool success);
66 
67     /// @param _owner The address of the account owning tokens
68     /// @param _spender The address of the account able to transfer the tokens
69     /// @return Amount of remaining tokens allowed to spent
70     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
71 
72     event Transfer(address indexed _from, address indexed _to, uint256 _value);
73     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
74 
75 }
76 
77 /**
78  * ERC 20 token
79  *
80  * https://github.com/ethereum/EIPs/issues/20
81  */
82 contract StandardToken is Token {
83 
84     /**
85      * Reviewed:
86      * - Integer overflow = OK, checked
87      */
88     function transfer(address _to, uint256 _value) returns (bool success) {
89         //Default assumes totalSupply can't be over max (2^256 - 1).
90         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
91         //Replace the if with this one instead.
92         if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
93             //if (balances[msg.sender] >= _value && _value > 0) {
94             balances[msg.sender] -= _value;
95             balances[_to] += _value;
96             Transfer(msg.sender, _to, _value);
97             return true;
98         } else { return false; }
99     }
100 
101     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
102         //same as above. Replace this line with the following if you want to protect against wrapping uints.
103         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
104             //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
105             balances[_to] += _value;
106             balances[_from] -= _value;
107             allowed[_from][msg.sender] -= _value;
108             Transfer(_from, _to, _value);
109             return true;
110         } else { return false; }
111     }
112 
113     function balanceOf(address _owner) constant returns (uint256 balance) {
114         return balances[_owner];
115     }
116 
117     function approve(address _spender, uint256 _value) returns (bool success) {
118         allowed[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120         return true;
121     }
122 
123     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124         return allowed[_owner][_spender];
125     }
126 
127     mapping(address => uint256) balances;
128 
129     mapping (address => mapping (address => uint256)) allowed;
130 
131     uint256 public totalSupply;
132 }
133 
134 
135 /**
136  * PIX crowdsale ICO contract.
137  *
138  * Security criteria evaluated against http://ethereum.stackexchange.com/questions/8551/methodological-security-review-of-a-smart-contract
139  *
140  *
141  */
142 contract PIXToken is StandardToken, SafeMath {
143 
144     string public name = "PIX Token";
145     string public symbol = "PIX";
146 
147     // Initial founder address (set in constructor)
148     // This address is used as a controller address, in order to properly handle administration of the token.
149     address public founder = 0x0;
150 
151     // Deposit Address - The funds will be sent here immediately after payments are made to the contract
152     address public deposit = 0x0;
153 
154     /*
155     Multi-stage sale contract.
156 
157     Notes:
158     All token sales are tied to USD.  No token sales are for a fixed amount of Wei, this can shift and change over time.
159     Due to this, the following needs to be paid attention to:
160     1. The value of the token fluctuates in reference to the centsPerEth set on the contract.
161     2. The tokens are priced in cents.  So all token purchases will be calculated out live at that time.
162 
163     Funding Stages:
164     1. Pre-Sale, there will be 15M USD ( 125M tokens ) for sale. Bonus of 20%
165     2. Day 1 sale, there will be 20M USD - the pre-sale amount of tokens for sale. (~166.6m tokens - Pre-Sale tokens) Bonus of 15%
166     3. Day 2 sale, there will be 20M USD (~166.6m tokens) tokens for sale.  Bonus of 10%
167     4. Days 3-10 sale, there will be 20M USD (~166.6m tokens) tokens for sale.  Bonus of 5%
168 
169     Post-Sale:
170     1. 30% of the total token count is reserved for release every year, at 1/4th of the originally reserved value per year.
171     2. 20% of the total token count [Minus the number of excess bonus tokens from the pre-sale] is issued out to the team when the sale has completed.
172     3. Purchased tokens come available to be withdrawn 31 days after the sale has completed.
173     */
174 
175     enum State { PreSale, Day1, Day2, Day3, Running, Halted } // the states through which this contract goes
176     State state;
177 
178     // Pricing for the pre-sale in US Cents.
179     uint public capPreSale = 15 * 10**8;  // 15M USD cap for pre-sale, this subtracts from day1 cap
180     uint public capDay1 = 20 * 10**8;  // 20M USD cap for day 1
181     uint public capDay2 = 20 * 10**8;  // 20M USD cap for day 2
182     uint public capDay3 = 20 * 10**8;  // 20M USD cap for day 3 - 10
183 
184     // Token pricing information
185     uint public weiPerEther = 10**18;
186     uint public centsPerEth = 23000;
187     uint public centsPerToken = 12;
188 
189     // Amount of funds raised in stages of pre-sale
190     uint public raisePreSale = 0;  // USD raise during the pre-sale period
191     uint public raiseDay1 = 0;  // USD raised on Day 1
192     uint public raiseDay2 = 0;  // USD raised on Day 2
193     uint public raiseDay3 = 0;  // USD raised during days 3-10
194 
195     // Block timing/contract unlocking information
196     uint public publicSaleStart = 1502280000; // Aug 9, 2017 Noon UTC
197     uint public day2Start = 1502366400; // Aug 10, 2017 Noon UTC
198     uint public day3Start = 1502452800; // Aug 11, 2017 Noon UTC
199     uint public saleEnd = 1503144000; // Aug 19, 2017 Noon UTC
200     uint public coinTradeStart = 1505822400; // Sep 19, 2017 Noon UTC
201     uint public year1Unlock = 1534680000; // Aug 19, 2018 Noon UTC
202     uint public year2Unlock = 1566216000; // Aug 19, 2019 Noon UTC
203     uint public year3Unlock = 1597838400; // Aug 19, 2020 Noon UTC
204     uint public year4Unlock = 1629374400; // Aug 19, 2021 Noon UTC
205 
206     // Have the post-reward allocations been completed
207     bool public allocatedFounders = false;
208     bool public allocated1Year = false;
209     bool public allocated2Year = false;
210     bool public allocated3Year = false;
211     bool public allocated4Year = false;
212 
213     // Token count information
214     uint public totalTokensSale = 500000000; //total number of tokens being sold in the ICO, excluding bonuses, reserve, and team distributions
215     uint public totalTokensReserve = 330000000;
216     uint public totalTokensCompany = 220000000;
217 
218     bool public halted = false; //the founder address can set this to true to halt the crowdsale due to emergency.
219 
220     mapping(address => uint256) presaleWhitelist; // Pre-sale Whitelist
221 
222     event Buy(address indexed sender, uint eth, uint fbt);
223     event Withdraw(address indexed sender, address to, uint eth);
224     event AllocateTokens(address indexed sender);
225 
226     function PIXToken(address depositAddress) {
227         /*
228             Initialize the contract with a sane set of owners
229         */
230         founder = msg.sender;  // Allocate the founder address as a usable address separate from deposit.
231         deposit = depositAddress;  // Store the deposit address.
232     }
233 
234     function setETHUSDRate(uint centsPerEthInput) public {
235         /*
236             Sets the current ETH/USD Exchange rate in cents.  This modifies the token price in Wei.
237         */
238         require(msg.sender == founder);
239         centsPerEth = centsPerEthInput;
240     }
241 
242     /*
243         Gets the current state of the contract based on the block number involved in the current transaction.
244     */
245     function getCurrentState() constant public returns (State) {
246 
247         if(halted) return State.Halted;
248         else if(block.timestamp < publicSaleStart) return State.PreSale;
249         else if(block.timestamp > publicSaleStart && block.timestamp <= day2Start) return State.Day1;
250         else if(block.timestamp > day2Start && block.timestamp <= day3Start) return State.Day2;
251         else if(block.timestamp > day3Start && block.timestamp <= saleEnd) return State.Day3;
252         else return State.Running;
253     }
254 
255     /*
256         Gets the current amount of bonus per purchase in percent.
257     */
258     function getCurrentBonusInPercent() constant public returns (uint) {
259         State s = getCurrentState();
260         if (s == State.Halted) revert();
261         else if(s == State.PreSale) return 20;
262         else if(s == State.Day1) return 15;
263         else if(s == State.Day2) return 10;
264         else if(s == State.Day3) return 5;
265         else return 0;
266     }
267 
268     /*
269         Get the current price of the token in WEI.  This should be the weiPerEther/centsPerEth * centsPerToken
270     */
271     function getTokenPriceInWEI() constant public returns (uint){
272         uint weiPerCent = safeDiv(weiPerEther, centsPerEth);
273         return safeMul(weiPerCent, centsPerToken);
274     }
275 
276     /*
277         Entry point for purchasing for one's self.
278     */
279     function buy() payable public {
280         buyRecipient(msg.sender);
281     }
282 
283     /*
284         Main purchasing function for the contract
285         1. Should validate the current state, from the getCurrentState() function
286         2. Should only allow the founder to order during the pre-sale
287         3. Should correctly calculate the values to be paid out during different stages of the contract.
288     */
289     function buyRecipient(address recipient) payable public {
290         State current_state = getCurrentState(); // Get the current state of the contract.
291         uint usdCentsRaise = safeDiv(safeMul(msg.value, centsPerEth), weiPerEther); // Get the current number of cents raised by the payment.
292 
293         if(current_state == State.PreSale)
294         {
295             require (presaleWhitelist[msg.sender] > 0);
296             raisePreSale = safeAdd(raisePreSale, usdCentsRaise); //add current raise to pre-sell amount
297             require(raisePreSale < capPreSale && usdCentsRaise < presaleWhitelist[msg.sender]); //ensure pre-sale cap, 15m usd * 100 so we have cents
298             presaleWhitelist[msg.sender] = presaleWhitelist[msg.sender] - usdCentsRaise; // Remove the amount purchased from the pre-sale permitted for that user
299         }
300         else if (current_state == State.Day1)
301         {
302             raiseDay1 = safeAdd(raiseDay1, usdCentsRaise); //add current raise to pre-sell amount
303             require(raiseDay1 < (capDay1 - raisePreSale)); //ensure day 1 cap, which is lower by the amount we pre-sold
304         }
305         else if (current_state == State.Day2)
306         {
307             raiseDay2 = safeAdd(raiseDay2, usdCentsRaise); //add current raise to pre-sell amount
308             require(raiseDay2 < capDay2); //ensure day 2 cap
309         }
310         else if (current_state == State.Day3)
311         {
312             raiseDay3 = safeAdd(raiseDay3, usdCentsRaise); //add current raise to pre-sell amount
313             require(raiseDay3 < capDay3); //ensure day 3 cap
314         }
315         else revert();
316 
317         uint tokens = safeDiv(msg.value, getTokenPriceInWEI()); // Calculate number of tokens to be paid out
318         uint bonus = safeDiv(safeMul(tokens, getCurrentBonusInPercent()), 100); // Calculate number of bonus tokens
319 
320         if (current_state == State.PreSale) {
321             // Remove the extra 5% from the totalTokensCompany, in order to keep the 550m on track.
322             totalTokensCompany = safeSub(totalTokensCompany, safeDiv(bonus, 4));
323         }
324 
325         uint totalTokens = safeAdd(tokens, bonus);
326 
327         balances[recipient] = safeAdd(balances[recipient], totalTokens);
328         totalSupply = safeAdd(totalSupply, totalTokens);
329 
330         deposit.transfer(msg.value); // Send deposited Ether to the deposit address on file.
331 
332         Buy(recipient, msg.value, totalTokens);
333     }
334 
335     /*
336         Allocate reserved and founders tokens based on the running time and state of the contract.
337      */
338     function allocateReserveAndFounderTokens() {
339         require(msg.sender==founder);
340         require(getCurrentState() == State.Running);
341         uint tokens = 0;
342 
343         if(block.timestamp > saleEnd && !allocatedFounders)
344         {
345             allocatedFounders = true;
346             tokens = totalTokensCompany;
347             balances[founder] = safeAdd(balances[founder], tokens);
348             totalSupply = safeAdd(totalSupply, tokens);
349         }
350         else if(block.timestamp > year1Unlock && !allocated1Year)
351         {
352             allocated1Year = true;
353             tokens = safeDiv(totalTokensReserve, 4);
354             balances[founder] = safeAdd(balances[founder], tokens);
355             totalSupply = safeAdd(totalSupply, tokens);
356         }
357         else if(block.timestamp > year2Unlock && !allocated2Year)
358         {
359             allocated2Year = true;
360             tokens = safeDiv(totalTokensReserve, 4);
361             balances[founder] = safeAdd(balances[founder], tokens);
362             totalSupply = safeAdd(totalSupply, tokens);
363         }
364         else if(block.timestamp > year3Unlock && !allocated3Year)
365         {
366             allocated3Year = true;
367             tokens = safeDiv(totalTokensReserve, 4);
368             balances[founder] = safeAdd(balances[founder], tokens);
369             totalSupply = safeAdd(totalSupply, tokens);
370         }
371         else if(block.timestamp > year4Unlock && !allocated4Year)
372         {
373             allocated4Year = true;
374             tokens = safeDiv(totalTokensReserve, 4);
375             balances[founder] = safeAdd(balances[founder], tokens);
376             totalSupply = safeAdd(totalSupply, tokens);
377         }
378         else revert();
379 
380         AllocateTokens(msg.sender);
381     }
382 
383     /**
384      * Emergency Stop ICO.
385      *
386      *  Applicable tests:
387      *
388      * - Test unhalting, buying, and succeeding
389      */
390     function halt() {
391         require(msg.sender==founder);
392         halted = true;
393     }
394 
395     function unhalt() {
396         require(msg.sender==founder);
397         halted = false;
398     }
399 
400     /*
401         Change founder address (Controlling address for contract)
402     */
403     function changeFounder(address newFounder) {
404         require(msg.sender==founder);
405         founder = newFounder;
406     }
407 
408     /*
409         Change deposit address (Address to which funds are deposited)
410     */
411     function changeDeposit(address newDeposit) {
412         require(msg.sender==founder);
413         deposit = newDeposit;
414     }
415 
416     /*
417         Add people to the pre-sale whitelist
418         Amount should be the value in USD that the purchaser is allowed to buy
419         IE: 100 is $100 is 10000 cents.  The correct value to enter is 100
420     */
421     function addPresaleWhitelist(address toWhitelist, uint256 amount){
422         require(msg.sender==founder && amount > 0);
423         presaleWhitelist[toWhitelist] = amount * 100;
424     }
425 
426     /**
427      * ERC 20 Standard Token interface transfer function
428      *
429      * Prevent transfers until freeze period is over.
430      *
431      * Applicable tests:
432      *
433      * - Test restricted early transfer
434      * - Test transfer after restricted period
435      */
436     function transfer(address _to, uint256 _value) returns (bool success) {
437         require(block.timestamp > coinTradeStart);
438         return super.transfer(_to, _value);
439     }
440     /**
441      * ERC 20 Standard Token interface transfer function
442      *
443      * Prevent transfers until freeze period is over.
444      */
445     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
446         require(block.timestamp > coinTradeStart);
447         return super.transferFrom(_from, _to, _value);
448     }
449 
450     function() payable {
451         buyRecipient(msg.sender);
452     }
453 
454 }