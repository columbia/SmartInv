1 pragma solidity 0.4.11;
2 
3 contract Token {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
47 
48 contract StandardToken is Token {
49 
50     function transfer(address _to, uint256 _value) returns (bool success) {
51         //Default assumes totalSupply can't be over max (2^256 - 1).
52         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
53         //Replace the if with this one instead.
54         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
55         require(balances[msg.sender] >= _value);
56         balances[msg.sender] -= _value;
57         balances[_to] += _value;
58         Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
63         //same as above. Replace this line with the following if you want to protect against wrapping uints.
64         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
65         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
66         balances[_to] += _value;
67         balances[_from] -= _value;
68         allowed[_from][msg.sender] -= _value;
69         Transfer(_from, _to, _value);
70         return true;
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value) returns (bool success) {
78         allowed[msg.sender][_spender] = _value;
79         Approval(msg.sender, _spender, _value);
80         return true;
81     }
82 
83     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
84       return allowed[_owner][_spender];
85     }
86 
87     mapping (address => uint256) balances;
88     mapping (address => mapping (address => uint256)) allowed;
89 }
90 
91 contract HumanStandardToken is StandardToken {
92 
93     /* Public variables of the token */
94 
95     /*
96     NOTE:
97     The following variables are OPTIONAL vanities. One does not have to include them.
98     They allow one to customise the token contract & in no way influences the core functionality.
99     Some wallets/interfaces might not even bother to look at this information.
100     */
101     string public name;                   //fancy name: eg Simon Bucks
102     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
103     string public symbol;                 //An identifier: eg SBX
104     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
105 
106     function HumanStandardToken(
107         uint256 _initialAmount,
108         string _tokenName,
109         uint8 _decimalUnits,
110         string _tokenSymbol
111         ) {
112         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
113         totalSupply = _initialAmount;                        // Update total supply
114         name = _tokenName;                                   // Set the name for display purposes
115         decimals = _decimalUnits;                            // Amount of decimals for display purposes
116         symbol = _tokenSymbol;                               // Set the symbol for display purposes
117     }
118 
119     /* Approves and then calls the receiving contract */
120     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
121         allowed[msg.sender][_spender] = _value;
122         Approval(msg.sender, _spender, _value);
123 
124         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
125         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
126         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
127         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
128         return true;
129     }
130 }
131 
132 contract Disbursement {
133 
134     /*
135      *  Storage
136      */
137     address public owner;
138     address public receiver;
139     uint public disbursementPeriod;
140     uint public startDate;
141     uint public withdrawnTokens;
142     Token public token;
143 
144     /*
145      *  Modifiers
146      */
147     modifier isOwner() {
148         if (msg.sender != owner)
149             // Only owner is allowed to proceed
150             revert();
151         _;
152     }
153 
154     modifier isReceiver() {
155         if (msg.sender != receiver)
156             // Only receiver is allowed to proceed
157             revert();
158         _;
159     }
160 
161     modifier isSetUp() {
162         if (address(token) == 0)
163             // Contract is not set up
164             revert();
165         _;
166     }
167 
168     /*
169      *  Public functions
170      */
171     /// @dev Constructor function sets contract owner
172     /// @param _receiver Receiver of vested tokens
173     /// @param _disbursementPeriod Vesting period in seconds
174     /// @param _startDate Start date of disbursement period (cliff)
175     function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)
176         public
177     {
178         if (_receiver == 0 || _disbursementPeriod == 0)
179             // Arguments are null
180             revert();
181         owner = msg.sender;
182         receiver = _receiver;
183         disbursementPeriod = _disbursementPeriod;
184         startDate = _startDate;
185         if (startDate == 0)
186             startDate = now;
187     }
188 
189     /// @dev Setup function sets external contracts' addresses
190     /// @param _token Token address
191     function setup(Token _token)
192         public
193         isOwner
194     {
195         if (address(token) != 0 || address(_token) == 0)
196             // Setup was executed already or address is null
197             revert();
198         token = _token;
199     }
200 
201     /// @dev Transfers tokens to a given address
202     /// @param _to Address of token receiver
203     /// @param _value Number of tokens to transfer
204     function withdraw(address _to, uint256 _value)
205         public
206         isReceiver
207         isSetUp
208     {
209         uint maxTokens = calcMaxWithdraw();
210         if (_value > maxTokens)
211             revert();
212         withdrawnTokens += _value;
213         token.transfer(_to, _value);
214     }
215 
216     /// @dev Calculates the maximum amount of vested tokens
217     /// @return Number of vested tokens to withdraw
218     function calcMaxWithdraw()
219         public
220         constant
221         returns (uint)
222     {
223         uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;
224         if (withdrawnTokens >= maxTokens || startDate > now)
225             return 0;
226         return maxTokens - withdrawnTokens;
227     }
228 }
229 
230 contract Sale {
231 
232     /*
233      * Events
234      */
235 
236     event PurchasedTokens(address indexed purchaser, uint amount);
237     event TransferredPreBuyersReward(address indexed preBuyer, uint amount);
238     event TransferredTimelockedTokens(address beneficiary, address disburser, uint amount);
239 
240     /*
241      * Storage
242      */
243 
244     address public owner;
245     address public wallet;
246     HumanStandardToken public token;
247     uint public price;
248     uint public startBlock;
249     uint public freezeBlock;
250     uint public endBlock;
251 
252     uint public totalPreBuyers;
253     uint public preBuyersDispensedTo = 0;
254     uint public totalTimelockedBeneficiaries;
255     uint public timeLockedBeneficiariesDisbursedTo = 0;
256 
257     bool public emergencyFlag = false;
258     bool public preSaleTokensDisbursed = false;
259     bool public timelockedTokensDisbursed = false;
260 
261     /*
262      * Modifiers
263      */
264 
265     modifier saleStarted {
266         require(block.number >= startBlock);
267         _;
268     }
269 
270     modifier saleEnded {
271          require(block.number > endBlock);
272          _;
273     }
274 
275     modifier saleNotEnded {
276         require(block.number <= endBlock);
277         _;
278     }
279 
280     modifier onlyOwner {
281         require(msg.sender == owner);
282         _;
283     }
284 
285     modifier notFrozen {
286         require(block.number < freezeBlock);
287         _;
288     }
289 
290     modifier setupComplete {
291         assert(preSaleTokensDisbursed && timelockedTokensDisbursed);
292         _;
293     }
294 
295     modifier notInEmergency {
296         assert(emergencyFlag == false);
297         _;
298     }
299 
300     /*
301      * Public functions
302      */
303 
304     /// @dev Sale(): constructor for Sale contract
305     /// @param _owner the address which owns the sale, can access owner-only functions
306     /// @param _wallet the sale's beneficiary address
307     /// @param _tokenSupply the total number of tokens to mint
308     /// @param _tokenName the token's human-readable name
309     /// @param _tokenDecimals the number of display decimals in token balances
310     /// @param _tokenSymbol the token's human-readable asset symbol
311     /// @param _price price of the token in Wei
312     /// @param _startBlock the block at which this contract will begin selling its token balance
313     function Sale(
314         address _owner,
315         address _wallet,
316         uint256 _tokenSupply,
317         string _tokenName,
318         uint8 _tokenDecimals,
319         string _tokenSymbol,
320         uint _price,
321         uint _startBlock,
322         uint _freezeBlock,
323         uint _totalPreBuyers,
324         uint _totalTimelockedBeneficiaries,
325         uint _endBlock
326     ) {
327         owner = _owner;
328         wallet = _wallet;
329         token = new HumanStandardToken(_tokenSupply, _tokenName, _tokenDecimals, _tokenSymbol);
330         price = _price;
331         startBlock = _startBlock;
332         freezeBlock = _freezeBlock;
333         totalPreBuyers = _totalPreBuyers;
334         totalTimelockedBeneficiaries = _totalTimelockedBeneficiaries;
335         endBlock = _endBlock;
336 
337         token.transfer(this, token.totalSupply());
338         assert(token.balanceOf(this) == token.totalSupply());
339         assert(token.balanceOf(this) == _tokenSupply);
340     }
341 
342     /// @dev distributePreBuyersRewards(): private utility function called by constructor
343     /// @param _preBuyers an array of addresses to which awards will be distributed
344     /// @param _preBuyersTokens an array of integers specifying preBuyers rewards
345     function distributePreBuyersRewards(
346         address[] _preBuyers,
347         uint[] _preBuyersTokens
348     )
349         public
350         onlyOwner
351     {
352         assert(!preSaleTokensDisbursed);
353 
354         for(uint i = 0; i < _preBuyers.length; i++) {
355             token.transfer(_preBuyers[i], _preBuyersTokens[i]);
356             preBuyersDispensedTo += 1;
357             TransferredPreBuyersReward(_preBuyers[i], _preBuyersTokens[i]);
358         }
359 
360         if(preBuyersDispensedTo == totalPreBuyers) {
361           preSaleTokensDisbursed = true;
362         }
363     }
364 
365     /// @dev distributeTimelockedTokens(): private utility function called by constructor
366     /// @param _beneficiaries an array of addresses specifying disbursement beneficiaries
367     /// @param _beneficiariesTokens an array of integers specifying disbursement amounts
368     /// @param _timelocks an array of UNIX timestamps specifying vesting dates
369     /// @param _periods an array of durations in seconds specifying vesting periods
370     function distributeTimelockedTokens(
371         address[] _beneficiaries,
372         uint[] _beneficiariesTokens,
373         uint[] _timelocks,
374         uint[] _periods
375     )
376         public
377         onlyOwner
378     {
379         assert(preSaleTokensDisbursed);
380         assert(!timelockedTokensDisbursed);
381 
382         for(uint i = 0; i < _beneficiaries.length; i++) {
383           address beneficiary = _beneficiaries[i];
384           uint beneficiaryTokens = _beneficiariesTokens[i];
385 
386           Disbursement disbursement = new Disbursement(
387             beneficiary,
388             _periods[i],
389             _timelocks[i]
390           );
391 
392           disbursement.setup(token);
393           token.transfer(disbursement, beneficiaryTokens);
394           timeLockedBeneficiariesDisbursedTo += 1;
395 
396           TransferredTimelockedTokens(beneficiary, disbursement, beneficiaryTokens);
397         }
398 
399         if(timeLockedBeneficiariesDisbursedTo == totalTimelockedBeneficiaries) {
400           timelockedTokensDisbursed = true;
401         }
402     }
403 
404     /// @dev purchaseToken(): function that exchanges ETH for tokens (main sale function)
405     /// @notice You're about to purchase the equivalent of `msg.value` Wei in tokens
406     function purchaseTokens()
407         saleStarted
408         saleNotEnded
409         payable
410         setupComplete
411         notInEmergency
412     {
413         /* Calculate whether any of the msg.value needs to be returned to
414            the sender. The tokenPurchase is the actual number of tokens which
415            will be purchased once any excessAmount included in the msg.value
416            is removed from the purchaseAmount. */
417         uint excessAmount = msg.value % price;
418         uint purchaseAmount = msg.value - excessAmount;
419         uint tokenPurchase = purchaseAmount / price;
420 
421         // Cannot purchase more tokens than this contract has available to sell
422         require(tokenPurchase <= token.balanceOf(this));
423 
424         // Return any excess msg.value
425         if (excessAmount > 0) {
426             msg.sender.transfer(excessAmount);
427         }
428 
429         // Forward received ether minus any excessAmount to the wallet
430         wallet.transfer(purchaseAmount);
431 
432         // Transfer the sum of tokens tokenPurchase to the msg.sender
433         token.transfer(msg.sender, tokenPurchase);
434 
435         PurchasedTokens(msg.sender, tokenPurchase);
436     }
437 
438     /*
439      * Owner-only functions
440      */
441 
442     function changeOwner(address _newOwner)
443         onlyOwner
444     {
445         require(_newOwner != 0);
446         owner = _newOwner;
447     }
448 
449     function withdrawRemainder()
450          onlyOwner
451          saleEnded
452      {
453          uint remainder = token.balanceOf(this);
454          token.transfer(wallet, remainder);
455      }
456 
457     function changePrice(uint _newPrice)
458         onlyOwner
459         notFrozen
460     {
461         require(_newPrice != 0);
462         price = _newPrice;
463     }
464 
465     function changeWallet(address _wallet)
466         onlyOwner
467         notFrozen
468     {
469         require(_wallet != 0);
470         wallet = _wallet;
471     }
472 
473     function changeStartBlock(uint _newBlock)
474         onlyOwner
475         notFrozen
476     {
477         require(_newBlock != 0);
478 
479         freezeBlock = _newBlock - (startBlock - freezeBlock);
480         startBlock = _newBlock;
481     }
482 
483     function changeEndBlock(uint _newBlock)
484         onlyOwner
485         notFrozen
486     {
487         require(_newBlock > startBlock);
488         endBlock = _newBlock;
489     }
490 
491     function emergencyToggle()
492         onlyOwner
493     {
494         emergencyFlag = !emergencyFlag;
495     }
496 
497 }