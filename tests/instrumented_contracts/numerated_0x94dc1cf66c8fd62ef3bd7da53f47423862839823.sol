1 contract Token {
2     /* This is a slight change to the ERC20 base standard.
3     function totalSupply() constant returns (uint256 supply);
4     is replaced with:
5     uint256 public totalSupply;
6     This automatically creates a getter function for the totalSupply.
7     This is moved to the base contract since public getter functions are not
8     currently recognised as an implementation of the matching abstract
9     function by the compiler.
10     */
11     /// total amount of tokens
12     uint256 public totalSupply;
13 
14     /// @param _owner The address from which the balance will be retrieved
15     /// @return The balance
16     function balanceOf(address _owner) constant returns (uint256 balance);
17 
18     /// @notice send `_value` token to `_to` from `msg.sender`
19     /// @param _to The address of the recipient
20     /// @param _value The amount of token to be transferred
21     /// @return Whether the transfer was successful or not
22     function transfer(address _to, uint256 _value) returns (bool success);
23 
24     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
25     /// @param _from The address of the sender
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
30 
31     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
32     /// @param _spender The address of the account able to transfer the tokens
33     /// @param _value The amount of tokens to be approved for transfer
34     /// @return Whether the approval was successful or not
35     function approve(address _spender, uint256 _value) returns (bool success);
36 
37     /// @param _owner The address of the account owning tokens
38     /// @param _spender The address of the account able to transfer the tokens
39     /// @return Amount of remaining tokens allowed to spent
40     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
41 
42     event Transfer(address indexed _from, address indexed _to, uint256 _value);
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 }
45 
46 contract StandardToken is Token {
47 
48     function transfer(address _to, uint256 _value) returns (bool success) {
49         //Default assumes totalSupply can't be over max (2^256 - 1).
50         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
51         //Replace the if with this one instead.
52         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
53         require(balances[msg.sender] >= _value);
54         balances[msg.sender] -= _value;
55         balances[_to] += _value;
56         Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
61         //same as above. Replace this line with the following if you want to protect against wrapping uints.
62         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
63         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
64         balances[_to] += _value;
65         balances[_from] -= _value;
66         allowed[_from][msg.sender] -= _value;
67         Transfer(_from, _to, _value);
68         return true;
69     }
70 
71     function balanceOf(address _owner) constant returns (uint256 balance) {
72         return balances[_owner];
73     }
74 
75     function approve(address _spender, uint256 _value) returns (bool success) {
76         allowed[msg.sender][_spender] = _value;
77         Approval(msg.sender, _spender, _value);
78         return true;
79     }
80 
81     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
82       return allowed[_owner][_spender];
83     }
84 
85     mapping (address => uint256) balances;
86     mapping (address => mapping (address => uint256)) allowed;
87 }
88 
89 contract HumanStandardToken is StandardToken {
90 
91     /* Public variables of the token */
92 
93     /*
94     NOTE:
95     The following variables are OPTIONAL vanities. One does not have to include them.
96     They allow one to customise the token contract & in no way influences the core functionality.
97     Some wallets/interfaces might not even bother to look at this information.
98     */
99     string public name;                   //fancy name: eg Simon Bucks
100     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
101     string public symbol;                 //An identifier: eg SBX
102     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
103 
104     function HumanStandardToken(
105         uint256 _initialAmount,
106         string _tokenName,
107         uint8 _decimalUnits,
108         string _tokenSymbol
109         ) {
110         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
111         totalSupply = _initialAmount;                        // Update total supply
112         name = _tokenName;                                   // Set the name for display purposes
113         decimals = _decimalUnits;                            // Amount of decimals for display purposes
114         symbol = _tokenSymbol;                               // Set the symbol for display purposes
115     }
116 
117     /* Approves and then calls the receiving contract */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
119         allowed[msg.sender][_spender] = _value;
120         Approval(msg.sender, _spender, _value);
121 
122         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
123         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
124         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
125         require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
126         return true;
127     }
128 }
129 
130 contract Disbursement {
131 
132     /*
133      *  Storage
134      */
135     address public owner;
136     address public receiver;
137     uint public disbursementPeriod;
138     uint public startDate;
139     uint public withdrawnTokens;
140     Token public token;
141 
142     /*
143      *  Modifiers
144      */
145     modifier isOwner() {
146         if (msg.sender != owner)
147             // Only owner is allowed to proceed
148             revert();
149         _;
150     }
151 
152     modifier isReceiver() {
153         if (msg.sender != receiver)
154             // Only receiver is allowed to proceed
155             revert();
156         _;
157     }
158 
159     modifier isSetUp() {
160         if (address(token) == 0)
161             // Contract is not set up
162             revert();
163         _;
164     }
165 
166     /*
167      *  Public functions
168      */
169     /// @dev Constructor function sets contract owner
170     /// @param _receiver Receiver of vested tokens
171     /// @param _disbursementPeriod Vesting period in seconds
172     /// @param _startDate Start date of disbursement period (cliff)
173     function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)
174         public
175     {
176         if (_receiver == 0 || _disbursementPeriod == 0)
177             // Arguments are null
178             revert();
179         owner = msg.sender;
180         receiver = _receiver;
181         disbursementPeriod = _disbursementPeriod;
182         startDate = _startDate;
183         if (startDate == 0)
184             startDate = now;
185     }
186 
187     /// @dev Setup function sets external contracts' addresses
188     /// @param _token Token address
189     function setup(Token _token)
190         public
191         isOwner
192     {
193         if (address(token) != 0 || address(_token) == 0)
194             // Setup was executed already or address is null
195             revert();
196         token = _token;
197     }
198 
199     /// @dev Transfers tokens to a given address
200     /// @param _to Address of token receiver
201     /// @param _value Number of tokens to transfer
202     function withdraw(address _to, uint256 _value)
203         public
204         isReceiver
205         isSetUp
206     {
207         uint maxTokens = calcMaxWithdraw();
208         if (_value > maxTokens)
209             revert();
210         withdrawnTokens += _value;
211         token.transfer(_to, _value);
212     }
213 
214     /// @dev Calculates the maximum amount of vested tokens
215     /// @return Number of vested tokens to withdraw
216     function calcMaxWithdraw()
217         public
218         constant
219         returns (uint)
220     {
221         uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;
222         if (withdrawnTokens >= maxTokens || startDate > now)
223             return 0;
224         return maxTokens - withdrawnTokens;
225     }
226 }
227 
228 contract Sale {
229 
230     /*
231      * Events
232      */
233 
234     event PurchasedTokens(address indexed purchaser, uint amount);
235     event TransferredPreBuyersReward(address indexed preBuyer, uint amount);
236     event TransferredTimelockedTokens(address beneficiary, address disburser, uint amount);
237 
238     /*
239      * Storage
240      */
241 
242     address public owner;
243     address public wallet;
244     HumanStandardToken public token;
245     uint public price;
246     uint public startBlock;
247     uint public freezeBlock;
248     uint public endBlock;
249 
250     uint public totalPreBuyers;
251     uint public preBuyersDispensedTo = 0;
252     uint public totalTimelockedBeneficiaries;
253     uint public timeLockedBeneficiariesDisbursedTo = 0;
254 
255     bool public emergencyFlag = false;
256     bool public preSaleTokensDisbursed = false;
257     bool public timelockedTokensDisbursed = false;
258 
259     /*
260      * Modifiers
261      */
262 
263     modifier saleStarted {
264         require(block.number >= startBlock);
265         _;
266     }
267 
268     modifier saleEnded {
269          require(block.number > endBlock);
270          _;
271     }
272 
273     modifier saleNotEnded {
274         require(block.number <= endBlock);
275         _;
276     }
277 
278     modifier onlyOwner {
279         require(msg.sender == owner);
280         _;
281     }
282 
283     modifier notFrozen {
284         require(block.number < freezeBlock);
285         _;
286     }
287 
288     modifier setupComplete {
289         assert(preSaleTokensDisbursed && timelockedTokensDisbursed);
290         _;
291     }
292 
293     modifier notInEmergency {
294         assert(emergencyFlag == false);
295         _;
296     }
297 
298     /*
299      * Public functions
300      */
301 
302     /// @dev Sale(): constructor for Sale contract
303     /// @param _owner the address which owns the sale, can access owner-only functions
304     /// @param _wallet the sale's beneficiary address
305     /// @param _tokenSupply the total number of tokens to mint
306     /// @param _tokenName the token's human-readable name
307     /// @param _tokenDecimals the number of display decimals in token balances
308     /// @param _tokenSymbol the token's human-readable asset symbol
309     /// @param _price price of the token in Wei
310     /// @param _startBlock the block at which this contract will begin selling its token balance
311     function Sale(
312         address _owner,
313         address _wallet,
314         uint256 _tokenSupply,
315         string _tokenName,
316         uint8 _tokenDecimals,
317         string _tokenSymbol,
318         uint _price,
319         uint _startBlock,
320         uint _freezeBlock,
321         uint _totalPreBuyers,
322         uint _totalTimelockedBeneficiaries,
323         uint _endBlock
324     ) {
325         owner = _owner;
326         wallet = _wallet;
327         token = new HumanStandardToken(_tokenSupply, _tokenName, _tokenDecimals, _tokenSymbol);
328         price = _price;
329         startBlock = _startBlock;
330         freezeBlock = _freezeBlock;
331         totalPreBuyers = _totalPreBuyers;
332         totalTimelockedBeneficiaries = _totalTimelockedBeneficiaries;
333         endBlock = _endBlock;
334 
335         token.transfer(this, token.totalSupply());
336         assert(token.balanceOf(this) == token.totalSupply());
337         assert(token.balanceOf(this) == _tokenSupply);
338     }
339 
340     /// @dev distributePreBuyersRewards(): private utility function called by constructor
341     /// @param _preBuyers an array of addresses to which awards will be distributed
342     /// @param _preBuyersTokens an array of integers specifying preBuyers rewards
343     function distributePreBuyersRewards(
344         address[] _preBuyers,
345         uint[] _preBuyersTokens
346     )
347         public
348         onlyOwner
349     {
350         assert(!preSaleTokensDisbursed);
351 
352         for(uint i = 0; i < _preBuyers.length; i++) {
353             token.transfer(_preBuyers[i], _preBuyersTokens[i]);
354             preBuyersDispensedTo += 1;
355             TransferredPreBuyersReward(_preBuyers[i], _preBuyersTokens[i]);
356         }
357 
358         if(preBuyersDispensedTo == totalPreBuyers) {
359           preSaleTokensDisbursed = true;
360         }
361     }
362 
363     /// @dev distributeTimelockedTokens(): private utility function called by constructor
364     /// @param _beneficiaries an array of addresses specifying disbursement beneficiaries
365     /// @param _beneficiariesTokens an array of integers specifying disbursement amounts
366     /// @param _timelocks an array of UNIX timestamps specifying vesting dates
367     /// @param _periods an array of durations in seconds specifying vesting periods
368     function distributeTimelockedTokens(
369         address[] _beneficiaries,
370         uint[] _beneficiariesTokens,
371         uint[] _timelocks,
372         uint[] _periods
373     )
374         public
375         onlyOwner
376     {
377         assert(preSaleTokensDisbursed);
378         assert(!timelockedTokensDisbursed);
379 
380         for(uint i = 0; i < _beneficiaries.length; i++) {
381           address beneficiary = _beneficiaries[i];
382           uint beneficiaryTokens = _beneficiariesTokens[i];
383 
384           Disbursement disbursement = new Disbursement(
385             beneficiary,
386             _periods[i],
387             _timelocks[i]
388           );
389 
390           disbursement.setup(token);
391           token.transfer(disbursement, beneficiaryTokens);
392           timeLockedBeneficiariesDisbursedTo += 1;
393 
394           TransferredTimelockedTokens(beneficiary, disbursement, beneficiaryTokens);
395         }
396 
397         if(timeLockedBeneficiariesDisbursedTo == totalTimelockedBeneficiaries) {
398           timelockedTokensDisbursed = true;
399         }
400     }
401 
402     /// @dev purchaseToken(): function that exchanges ETH for tokens (main sale function)
403     /// @notice You're about to purchase the equivalent of `msg.value` Wei in tokens
404     function purchaseTokens()
405         saleStarted
406         saleNotEnded
407         payable
408         setupComplete
409         notInEmergency
410     {
411         /* Calculate whether any of the msg.value needs to be returned to
412            the sender. The tokenPurchase is the actual number of tokens which
413            will be purchased once any excessAmount included in the msg.value
414            is removed from the purchaseAmount. */
415         uint excessAmount = msg.value % price;
416         uint purchaseAmount = msg.value - excessAmount;
417         uint tokenPurchase = purchaseAmount / price;
418 
419         // Cannot purchase more tokens than this contract has available to sell
420         require(tokenPurchase <= token.balanceOf(this));
421 
422         // Return any excess msg.value
423         if (excessAmount > 0) {
424             msg.sender.transfer(excessAmount);
425         }
426 
427         // Forward received ether minus any excessAmount to the wallet
428         wallet.transfer(purchaseAmount);
429 
430         // Transfer the sum of tokens tokenPurchase to the msg.sender
431         token.transfer(msg.sender, tokenPurchase);
432 
433         PurchasedTokens(msg.sender, tokenPurchase);
434     }
435 
436     /*
437      * Owner-only functions
438      */
439 
440     function changeOwner(address _newOwner)
441         onlyOwner
442     {
443         require(_newOwner != 0);
444         owner = _newOwner;
445     }
446 
447     function withdrawRemainder()
448          onlyOwner
449          saleEnded
450      {
451          uint remainder = token.balanceOf(this);
452          token.transfer(wallet, remainder);
453      }
454 
455     function changePrice(uint _newPrice)
456         onlyOwner
457         notFrozen
458     {
459         require(_newPrice != 0);
460         price = _newPrice;
461     }
462 
463     function changeWallet(address _wallet)
464         onlyOwner
465         notFrozen
466     {
467         require(_wallet != 0);
468         wallet = _wallet;
469     }
470 
471     function changeStartBlock(uint _newBlock)
472         onlyOwner
473         notFrozen
474     {
475         require(_newBlock != 0);
476 
477         freezeBlock = _newBlock - (startBlock - freezeBlock);
478         startBlock = _newBlock;
479     }
480 
481     function changeEndBlock(uint _newBlock)
482         onlyOwner
483         notFrozen
484     {
485         require(_newBlock > startBlock);
486         endBlock = _newBlock;
487     }
488 
489     function emergencyToggle()
490         onlyOwner
491     {
492         emergencyFlag = !emergencyFlag;
493     }
494 
495 }