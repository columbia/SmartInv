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
52         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53         if (balances[msg.sender] >= _value && _value > 0) {
54             balances[msg.sender] -= _value;
55             balances[_to] += _value;
56             Transfer(msg.sender, _to, _value);
57             return true;
58         } else { return false; }
59     }
60 
61     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
62         //same as above. Replace this line with the following if you want to protect against wrapping uints.
63         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
64         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
65             balances[_to] += _value;
66             balances[_from] -= _value;
67             allowed[_from][msg.sender] -= _value;
68             Transfer(_from, _to, _value);
69             return true;
70         } else { return false; }
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
93     function () {
94         //if ether is sent to this address, send it back.
95         throw;
96     }
97 
98     /* Public variables of the token */
99 
100     /*
101     NOTE:
102     The following variables are OPTIONAL vanities. One does not have to include them.
103     They allow one to customise the token contract & in no way influences the core functionality.
104     Some wallets/interfaces might not even bother to look at this information.
105     */
106     string public name;                   //fancy name: eg Simon Bucks
107     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
108     string public symbol;                 //An identifier: eg SBX
109     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
110 
111     function HumanStandardToken(
112         uint256 _initialAmount,
113         string _tokenName,
114         uint8 _decimalUnits,
115         string _tokenSymbol
116         ) {
117         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
118         totalSupply = _initialAmount;                        // Update total supply
119         name = _tokenName;                                   // Set the name for display purposes
120         decimals = _decimalUnits;                            // Amount of decimals for display purposes
121         symbol = _tokenSymbol;                               // Set the symbol for display purposes
122     }
123 
124     /* Approves and then calls the receiving contract */
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
126         allowed[msg.sender][_spender] = _value;
127         Approval(msg.sender, _spender, _value);
128 
129         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
130         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
131         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
132         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
133         return true;
134     }
135 }
136 
137 contract Disbursement {
138 
139     /*
140      *  Storage
141      */
142     address public owner;
143     address public receiver;
144     uint public disbursementPeriod;
145     uint public startDate;
146     uint public withdrawnTokens;
147     Token public token;
148 
149     /*
150      *  Modifiers
151      */
152     modifier isOwner() {
153         if (msg.sender != owner)
154             // Only owner is allowed to proceed
155             revert();
156         _;
157     }
158 
159     modifier isReceiver() {
160         if (msg.sender != receiver)
161             // Only receiver is allowed to proceed
162             revert();
163         _;
164     }
165 
166     modifier isSetUp() {
167         if (address(token) == 0)
168             // Contract is not set up
169             revert();
170         _;
171     }
172 
173     /*
174      *  Public functions
175      */
176     /// @dev Constructor function sets contract owner
177     /// @param _receiver Receiver of vested tokens
178     /// @param _disbursementPeriod Vesting period in seconds
179     /// @param _startDate Start date of disbursement period (cliff)
180     function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)
181         public
182     {
183         if (_receiver == 0 || _disbursementPeriod == 0)
184             // Arguments are null
185             revert();
186         owner = msg.sender;
187         receiver = _receiver;
188         disbursementPeriod = _disbursementPeriod;
189         startDate = _startDate;
190         if (startDate == 0)
191             startDate = now;
192     }
193 
194     /// @dev Setup function sets external contracts' addresses
195     /// @param _token Token address
196     function setup(Token _token)
197         public
198         isOwner
199     {
200         if (address(token) != 0 || address(_token) == 0)
201             // Setup was executed already or address is null
202             revert();
203         token = _token;
204     }
205 
206     /// @dev Transfers tokens to a given address
207     /// @param _to Address of token receiver
208     /// @param _value Number of tokens to transfer
209     function withdraw(address _to, uint256 _value)
210         public
211         isReceiver
212         isSetUp
213     {
214         uint maxTokens = calcMaxWithdraw();
215         if (_value > maxTokens)
216             revert();
217         withdrawnTokens += _value;
218         token.transfer(_to, _value);
219     }
220 
221     /// @dev Calculates the maximum amount of vested tokens
222     /// @return Number of vested tokens to withdraw
223     function calcMaxWithdraw()
224         public
225         constant
226         returns (uint)
227     {
228         uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;
229         if (withdrawnTokens >= maxTokens || startDate > now)
230             return 0;
231         return maxTokens - withdrawnTokens;
232     }
233 }
234 
235 contract Filter {
236 
237     event SetupAllowance(address indexed beneficiary, uint amount);
238 
239     Disbursement public disburser;
240     address public owner;
241     mapping(address => Beneficiary) public beneficiaries;
242 
243     struct Beneficiary {
244         uint claimAmount;
245         bool claimed;
246     }
247 
248     modifier onlyOwner {
249         require(msg.sender == owner);
250         _;
251     }
252 
253     function Filter(
254         address[] _beneficiaries,
255         uint[] _beneficiaryTokens
256     ) {
257         owner = msg.sender;
258         for(uint i = 0; i < _beneficiaries.length; i++) {
259             beneficiaries[_beneficiaries[i]] = Beneficiary({
260                 claimAmount: _beneficiaryTokens[i],
261                 claimed: false
262             });
263             SetupAllowance(_beneficiaries[i],
264                            beneficiaries[_beneficiaries[i]].claimAmount);
265         }
266     }
267 
268     function setup(Disbursement _disburser)
269         public
270         onlyOwner
271     {
272         require(address(disburser) == 0 && address(_disburser) != 0);
273         disburser = _disburser; 
274     }
275 
276     function claim()
277         public
278     {
279         require(beneficiaries[msg.sender].claimed == false);
280         beneficiaries[msg.sender].claimed = true;
281         disburser.withdraw(msg.sender, beneficiaries[msg.sender].claimAmount);
282     }
283 }
284 
285 contract Sale {
286 
287     /*
288      * Events
289      */
290 
291     event PurchasedTokens(address indexed purchaser, uint amount);
292     event TransferredPreBuyersReward(address indexed preBuyer, uint amount);
293     event TransferredFoundersTokens(address vault, uint amount);
294 
295     /*
296      * Storage
297      */
298 
299     address public owner;
300     address public wallet;
301     HumanStandardToken public token;
302     uint public price;
303     uint public startBlock;
304     uint public freezeBlock;
305     bool public emergencyFlag = false;
306     bool public preSaleTokensDisbursed = false;
307     bool public foundersTokensDisbursed = false;
308     address[] public filters;
309 
310     /*
311      * Modifiers
312      */
313 
314     modifier saleStarted {
315         require(block.number >= startBlock);
316         _;
317     }
318 
319     modifier onlyOwner {
320         require(msg.sender == owner);
321         _;
322     }
323 
324     modifier notFrozen {
325         require(block.number < freezeBlock);
326         _;
327     }
328 
329     modifier setupComplete {
330         assert(preSaleTokensDisbursed && foundersTokensDisbursed);
331         _;
332     }
333 
334     modifier notInEmergency {
335         assert(emergencyFlag == false);
336         _;
337     }
338 
339     /*
340      * Public functions
341      */
342 
343     /// @dev Sale(): constructor for Sale contract
344     /// @param _owner the address which owns the sale, can access owner-only functions
345     /// @param _wallet the sale's beneficiary address 
346     /// @param _tokenSupply the total number of AdToken to mint
347     /// @param _tokenName AdToken's human-readable name
348     /// @param _tokenDecimals the number of display decimals in AdToken balances
349     /// @param _tokenSymbol AdToken's human-readable asset symbol
350     /// @param _price price of the token in Wei (ADT/Wei pair price)
351     /// @param _startBlock the block at which this contract will begin selling its ADT balance
352     function Sale(
353         address _owner,
354         address _wallet,
355         uint256 _tokenSupply,
356         string _tokenName,
357         uint8 _tokenDecimals,
358         string _tokenSymbol,
359         uint _price,
360         uint _startBlock,
361         uint _freezeBlock
362     ) {
363         owner = _owner;
364         wallet = _wallet;
365         token = new HumanStandardToken(_tokenSupply, _tokenName, _tokenDecimals, _tokenSymbol);
366         price = _price;
367         startBlock = _startBlock;
368         freezeBlock = _freezeBlock;
369 
370         assert(token.transfer(this, token.totalSupply()));
371         assert(token.balanceOf(this) == token.totalSupply());
372         assert(token.balanceOf(this) == 10**18);
373     }
374 
375     /// @dev distributeFoundersRewards(): private utility function called by constructor
376     /// @param _preBuyers an array of addresses to which awards will be distributed
377     /// @param _preBuyersTokens an array of integers specifying preBuyers rewards
378     function distributePreBuyersRewards(
379         address[] _preBuyers,
380         uint[] _preBuyersTokens
381     ) 
382         public
383         onlyOwner
384     { 
385         assert(!preSaleTokensDisbursed);
386 
387         for(uint i = 0; i < _preBuyers.length; i++) {
388             require(token.transfer(_preBuyers[i], _preBuyersTokens[i]));
389             TransferredPreBuyersReward(_preBuyers[i], _preBuyersTokens[i]);
390         }
391 
392         preSaleTokensDisbursed = true;
393     }
394 
395     /// @dev distributeTimelockedRewards(): private utility function called by constructor
396     /// @param _founders an array of addresses specifying disbursement beneficiaries
397     /// @param _foundersTokens an array of integers specifying disbursement amounts
398     /// @param _founderTimelocks an array of UNIX timestamps specifying vesting dates
399     function distributeFoundersRewards(
400         address[] _founders,
401         uint[] _foundersTokens,
402         uint[] _founderTimelocks
403     ) 
404         public
405         onlyOwner
406     { 
407         assert(preSaleTokensDisbursed);
408         assert(!foundersTokensDisbursed);
409 
410         /* Total number of tokens to be disbursed for a given tranch. Used when
411            tokens are transferred to disbursement contracts. */
412         uint tokensPerTranch = 0;
413         // Alias of founderTimelocks.length for legibility
414         uint tranches = _founderTimelocks.length;
415         // The number of tokens which may be withdrawn per founder for each tranch
416         uint[] memory foundersTokensPerTranch = new uint[](_foundersTokens.length);
417 
418         // Compute foundersTokensPerTranch and tokensPerTranch
419         for(uint i = 0; i < _foundersTokens.length; i++) {
420             foundersTokensPerTranch[i] = _foundersTokens[i]/tranches;
421             tokensPerTranch = tokensPerTranch + foundersTokensPerTranch[i];
422         }
423 
424         /* Deploy disbursement and filter contract pairs, initialize both and store
425            filter addresses in filters array. Finally, transfer tokensPerTranch to
426            disbursement contracts. */
427         for(uint j = 0; j < tranches; j++) {
428             Filter filter = new Filter(_founders, foundersTokensPerTranch);
429             filters.push(filter);
430             Disbursement vault = new Disbursement(filter, 1, _founderTimelocks[j]);
431             // Give the disbursement contract the address of the token it disburses.
432             vault.setup(token);             
433             /* Give the filter contract the address of the disbursement contract
434                it access controls */
435             filter.setup(vault);             
436             // Transfer to the vault the tokens it is to disburse
437             assert(token.transfer(vault, tokensPerTranch));
438             TransferredFoundersTokens(vault, tokensPerTranch);
439         }
440 
441         assert(token.balanceOf(this) == 5 * 10**17);
442         foundersTokensDisbursed = true;
443     }
444 
445     /// @dev purchaseToken(): function that exchanges ETH for ADT (main sale function)
446     /// @notice You're about to purchase the equivalent of `msg.value` Wei in ADT tokens
447     function purchaseTokens()
448         saleStarted
449         payable
450         setupComplete
451         notInEmergency
452     {
453         /* Calculate whether any of the msg.value needs to be returned to
454            the sender. The tokenPurchase is the actual number of tokens which
455            will be purchased once any excessAmount included in the msg.value
456            is removed from the purchaseAmount. */
457         uint excessAmount = msg.value % price;
458         uint purchaseAmount = msg.value - excessAmount;
459         uint tokenPurchase = purchaseAmount / price;
460 
461         // Cannot purchase more tokens than this contract has available to sell
462         require(tokenPurchase <= token.balanceOf(this));
463 
464         // Return any excess msg.value
465         if (excessAmount > 0) {
466             msg.sender.transfer(excessAmount);
467         }
468 
469         // Forward received ether minus any excessAmount to the wallet
470         wallet.transfer(purchaseAmount);
471 
472         // Transfer the sum of tokens tokenPurchase to the msg.sender
473         assert(token.transfer(msg.sender, tokenPurchase));
474 
475         PurchasedTokens(msg.sender, tokenPurchase);
476     }
477 
478     /*
479      * Owner-only functions
480      */
481 
482     function changeOwner(address _newOwner)
483         onlyOwner
484     {
485         require(_newOwner != 0);
486         owner = _newOwner;
487     }
488 
489     function changePrice(uint _newPrice)
490         onlyOwner
491         notFrozen
492     {
493         require(_newPrice != 0);
494         price = _newPrice;
495     }
496 
497     function changeWallet(address _wallet)
498         onlyOwner
499         notFrozen
500     {
501         require(_wallet != 0);
502         wallet = _wallet;
503     }
504 
505     function changeStartBlock(uint _newBlock)
506         onlyOwner
507         notFrozen
508     {
509         require(_newBlock != 0);
510 
511         freezeBlock = _newBlock - (startBlock - freezeBlock);
512         startBlock = _newBlock;
513     }
514 
515     function emergencyToggle()
516         onlyOwner
517     {
518         emergencyFlag = !emergencyFlag;
519     }
520 
521 }