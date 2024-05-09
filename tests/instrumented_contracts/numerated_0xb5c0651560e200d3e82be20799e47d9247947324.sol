1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) pure internal  returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) pure internal  returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) pure internal  returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) pure internal  returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Disbursement {
31 
32     /*
33      *  Storage
34      */
35     address public owner;
36     address public receiver;
37     uint public disbursementPeriod;
38     uint public startDate;
39     uint public withdrawnTokens;
40     Token public token;
41 
42     /*
43      *  Modifiers
44      */
45     modifier isOwner() {
46         if (msg.sender != owner)
47             // Only owner is allowed to proceed
48             revert();
49         _;
50     }
51 
52     modifier isReceiver() {
53         if (msg.sender != receiver)
54             // Only receiver is allowed to proceed
55             revert();
56         _;
57     }
58 
59     modifier isSetUp() {
60         if (address(token) == 0)
61             // Contract is not set up
62             revert();
63         _;
64     }
65 
66     /*
67      *  Public functions
68      */
69     /// @dev Constructor function sets contract owner
70     /// @param _receiver Receiver of vested tokens
71     /// @param _disbursementPeriod Vesting period in seconds
72     /// @param _startDate Start date of disbursement period (cliff)
73     function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)
74         public
75     {
76         if (_receiver == 0 || _disbursementPeriod == 0)
77             // Arguments are null
78             revert();
79         owner = msg.sender;
80         receiver = _receiver;
81         disbursementPeriod = _disbursementPeriod;
82         startDate = _startDate;
83         if (startDate == 0)
84             startDate = now;
85     }
86 
87     /// @dev Setup function sets external contracts' addresses
88     /// @param _token Token address
89     function setup(Token _token)
90         public
91         isOwner
92     {
93         if (address(token) != 0 || address(_token) == 0)
94             // Setup was executed already or address is null
95             revert();
96         token = _token;
97     }
98 
99     /// @dev Transfers tokens to a given address
100     /// @param _to Address of token receiver
101     /// @param _value Number of tokens to transfer
102     function withdraw(address _to, uint256 _value)
103         public
104         isReceiver
105         isSetUp
106     {
107         uint maxTokens = calcMaxWithdraw();
108         if (_value > maxTokens)
109             revert();
110         withdrawnTokens += _value;
111         token.transfer(_to, _value);
112     }
113 
114     /// @dev Calculates the maximum amount of vested tokens
115     /// @return Number of vested tokens to withdraw
116     function calcMaxWithdraw()
117         public
118         constant
119         returns (uint)
120     {
121         uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;
122         if (withdrawnTokens >= maxTokens || startDate > now)
123             return 0;
124         if (maxTokens - withdrawnTokens > token.totalSupply())
125             return token.totalSupply();
126         return maxTokens - withdrawnTokens;
127     }
128 }
129 
130 contract Token {
131     /* This is a slight change to the ERC20 base standard.
132     function totalSupply() constant returns (uint256 supply);
133     is replaced with:
134     uint256 public totalSupply;
135     This automatically creates a getter function for the totalSupply.
136     This is moved to the base contract since public getter functions are not
137     currently recognised as an implementation of the matching abstract
138     function by the compiler.
139     */
140     /// total amount of tokens
141     uint256 public totalSupply;
142     address public sale;
143     bool public transfersAllowed;
144     
145     /// @param _owner The address from which the balance will be retrieved
146     /// @return The balance
147     function balanceOf(address _owner) constant public returns (uint256 balance);
148 
149     /// @notice send `_value` token to `_to` from `msg.sender`
150     /// @param _to The address of the recipient
151     /// @param _value The amount of token to be transferred
152     /// @return Whether the transfer was successful or not
153     function transfer(address _to, uint256 _value) public returns (bool success);
154 
155     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
156     /// @param _from The address of the sender
157     /// @param _to The address of the recipient
158     /// @param _value The amount of token to be transferred
159     /// @return Whether the transfer was successful or not
160     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
161 
162     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
163     /// @param _spender The address of the account able to transfer the tokens
164     /// @param _value The amount of tokens to be approved for transfer
165     /// @return Whether the approval was successful or not
166     function approve(address _spender, uint256 _value) public returns (bool success);
167 
168     /// @param _owner The address of the account owning tokens
169     /// @param _spender The address of the account able to transfer the tokens
170     /// @return Amount of remaining tokens allowed to spent
171     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
172 
173     event Transfer(address indexed _from, address indexed _to, uint256 _value);
174     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
175 }
176 
177 contract StandardToken is Token {
178 
179     function transfer(address _to, uint256 _value)
180         public
181         validTransfer
182        	returns (bool success) 
183     {
184         //Default assumes totalSupply can't be over max (2^256 - 1).
185         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
186         //Replace the if with this one instead.
187         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
188     	require(balances[msg.sender] >= _value);
189         balances[msg.sender] -= _value;
190         balances[_to] += _value;
191         Transfer(msg.sender, _to, _value);
192         return true;
193     }
194 
195     function transferFrom(address _from, address _to, uint256 _value)
196         public
197         validTransfer
198       	returns (bool success)
199       {
200         //same as above. Replace this line with the following if you want to protect against wrapping uints.
201         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
202 	    require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
203         balances[_to] += _value;
204         balances[_from] -= _value;
205         allowed[_from][msg.sender] -= _value;
206         Transfer(_from, _to, _value);
207         return true;
208     }
209 
210     function balanceOf(address _owner) public constant returns (uint256 balance) {
211         return balances[_owner];
212     }
213 
214     function approve(address _spender, uint256 _value) public returns (bool success) {
215         require(balances[msg.sender] >= _value);
216         allowed[msg.sender][_spender] = _value;
217         Approval(msg.sender, _spender, _value);
218         return true;
219     }
220 
221     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
222       return allowed[_owner][_spender];
223     }
224 
225     mapping (address => uint256) balances;
226     mapping (address => mapping (address => uint256)) allowed;
227 
228     modifier validTransfer()
229     {
230         require(msg.sender == sale || transfersAllowed);
231         _;
232     }
233 }
234 
235 contract HumanStandardToken is StandardToken {
236 
237     /* Public variables of the token */
238 
239     /*
240     NOTE:
241     The following variables are OPTIONAL vanities. One does not have to include them.
242     They allow one to customise the token contract & in no way influences the core functionality.
243     Some wallets/interfaces might not even bother to look at this information.
244     */
245     string public name;                   //fancy name: eg Simon Bucks
246     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
247     string public symbol;                 //An identifier: eg SBX
248     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
249 
250     function HumanStandardToken(
251         uint256 _initialAmount,
252         string _tokenName,
253         uint8 _decimalUnits,
254         string _tokenSymbol,
255         address _sale)
256         public
257     {
258         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
259         totalSupply = _initialAmount;                        // Update total supply
260         name = _tokenName;                                   // Set the name for display purposes
261         decimals = _decimalUnits;                            // Amount of decimals for display purposes
262         symbol = _tokenSymbol;                               // Set the symbol for display purposes
263         sale = _sale;
264         transfersAllowed = false;
265     }
266 
267     /* Approves and then calls the receiving contract */
268     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
269         allowed[msg.sender][_spender] = _value;
270         Approval(msg.sender, _spender, _value);
271 
272         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
273         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
274         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
275         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
276         return true;
277     }
278 
279     function reversePurchase(address _tokenHolder)
280         public
281         onlySale
282     {
283         require(!transfersAllowed);
284         uint value = balances[_tokenHolder];
285         balances[_tokenHolder] -= value;
286         balances[sale] += value;
287         Transfer(_tokenHolder, sale, value);
288     }
289 
290     function removeTransferLock()
291         public
292         onlySale
293     {
294         transfersAllowed = true;
295     }
296 
297     modifier onlySale()
298     {
299         require(msg.sender == sale);
300         _;
301     }
302 }
303 
304 
305 
306 
307 contract Sale {
308 
309     // EVENTS
310 
311     event TransferredTimelockedTokens(address beneficiary, address disbursement,uint beneficiaryTokens);
312     event PurchasedTokens(address indexed purchaser, uint amount);
313     event LockedUnsoldTokens(uint numTokensLocked, address disburser);
314 
315     // STORAGE
316 
317     uint public constant TOTAL_SUPPLY = 1000000000000000000;
318     uint public constant MAX_PRIVATE = 750000000000000000;
319     uint8 public constant DECIMALS = 9;
320     string public constant NAME = "Leverj";
321     string public constant SYMBOL = "LEV";
322 
323     address public owner;
324     address public wallet;
325     HumanStandardToken public token;
326     uint public freezeBlock;
327     uint public startBlock;
328     uint public endBlock;
329     uint public presale_price_in_wei = 216685; //wei per 10**-9 of LEV!
330     uint public price_in_wei = 333333; //wei per 10**-9 of a LEV!
331 
332     //address[] public filters;
333 
334     uint public privateAllocated = 0;
335     bool public setupCompleteFlag = false;
336     bool public emergencyFlag = false;
337 
338     address[] public disbursements;
339     mapping(address => uint) public whitelistRegistrants;
340 
341     // PUBLIC FUNCTIONS
342 
343     function Sale(
344         address _owner,
345         uint _freezeBlock,
346         uint _startBlock,
347         uint _endBlock)
348         public 
349         checkBlockNumberInputs(_freezeBlock, _startBlock, _endBlock)
350     {
351         owner = _owner;
352         token = new HumanStandardToken(TOTAL_SUPPLY, NAME, DECIMALS, SYMBOL, address(this));
353         freezeBlock = _freezeBlock;
354         startBlock = _startBlock;
355         endBlock = _endBlock;
356         assert(token.transfer(this, token.totalSupply()));
357         assert(token.balanceOf(this) == token.totalSupply());
358         assert(token.balanceOf(this) == TOTAL_SUPPLY);
359     }
360 
361     function purchaseTokens()
362         public
363         payable
364         setupComplete
365         notInEmergency
366         saleInProgress
367     {
368         require(whitelistRegistrants[msg.sender] > 0 );
369         uint tempWhitelistAmount = whitelistRegistrants[msg.sender];
370 
371         /* Calculate whether any of the msg.value needs to be returned to
372            the sender. The purchaseAmount is the actual number of tokens which
373            will be purchased. */
374         uint purchaseAmount = msg.value / price_in_wei; 
375         uint excessAmount = msg.value % price_in_wei;
376 
377         if(purchaseAmount > whitelistRegistrants[msg.sender]){
378             uint extra = purchaseAmount - whitelistRegistrants[msg.sender];
379             purchaseAmount = whitelistRegistrants[msg.sender];
380             excessAmount += extra*price_in_wei;
381         }
382 
383         whitelistRegistrants[msg.sender] -= purchaseAmount;
384         assert(whitelistRegistrants[msg.sender] < tempWhitelistAmount);
385 
386         // Cannot purchase more tokens than this contract has available to sell
387         require(purchaseAmount <= token.balanceOf(this));
388 
389         // Return any excess msg.value
390         if (excessAmount > 0) {
391             msg.sender.transfer(excessAmount);
392         }
393 
394         // Forward received ether minus any excessAmount to the wallet
395         wallet.transfer(this.balance);
396 
397         // Transfer the sum of tokens tokenPurchase to the msg.sender
398         assert(token.transfer(msg.sender, purchaseAmount));
399         PurchasedTokens(msg.sender, purchaseAmount);
400     }
401 
402     function lockUnsoldTokens(address _unsoldTokensWallet)
403         public
404         saleEnded
405         setupComplete
406         onlyOwner
407     {
408         Disbursement disbursement = new Disbursement(
409             _unsoldTokensWallet,
410             1*365*24*60*60,
411             block.timestamp
412         );
413 
414         disbursement.setup(token);
415         uint amountToLock = token.balanceOf(this);
416         disbursements.push(disbursement);
417         token.transfer(disbursement, amountToLock);
418         LockedUnsoldTokens(amountToLock, disbursement);
419     }
420 
421     // OWNER-ONLY FUNCTIONS
422 
423     function distributeTimelockedTokens(
424         address[] _beneficiaries,
425         uint[] _beneficiariesTokens,
426         uint[] _timelockStarts,
427         uint[] _periods
428     ) 
429         public
430         onlyOwner
431         saleNotEnded
432     { 
433         assert(!setupCompleteFlag);
434         assert(_beneficiariesTokens.length < 11);
435         assert(_beneficiaries.length == _beneficiariesTokens.length);
436         assert(_beneficiariesTokens.length == _timelockStarts.length);
437         assert(_timelockStarts.length == _periods.length);
438 
439         for(uint i = 0; i < _beneficiaries.length; i++) {
440             require(privateAllocated + _beneficiariesTokens[i] <= MAX_PRIVATE);
441             privateAllocated += _beneficiariesTokens[i];
442             address beneficiary = _beneficiaries[i];
443             uint beneficiaryTokens = _beneficiariesTokens[i];
444 
445             Disbursement disbursement = new Disbursement(
446                 beneficiary,
447                 _periods[i],
448                 _timelockStarts[i]
449             );
450 
451             disbursement.setup(token);
452             token.transfer(disbursement, beneficiaryTokens);
453             disbursements.push(disbursement);
454             TransferredTimelockedTokens(beneficiary, disbursement, beneficiaryTokens);
455         }
456 
457         assert(token.balanceOf(this) >= (TOTAL_SUPPLY - MAX_PRIVATE));
458     }
459 
460     function distributePresaleTokens(address[] _buyers, uint[] _amounts)
461         public
462         onlyOwner
463         saleNotEnded
464     {
465         assert(!setupCompleteFlag);
466         require(_buyers.length < 11);
467         require(_buyers.length == _amounts.length);
468 
469         for(uint i=0; i < _buyers.length; i++){
470             require(privateAllocated + _amounts[i] <= MAX_PRIVATE);
471             assert(token.transfer(_buyers[i], _amounts[i]));
472             privateAllocated += _amounts[i];
473             PurchasedTokens(_buyers[i], _amounts[i]);
474         }
475 
476         assert(token.balanceOf(this) >= (TOTAL_SUPPLY - MAX_PRIVATE));
477     }
478 
479     function removeTransferLock()
480         public
481         onlyOwner
482     {
483         token.removeTransferLock();
484     }
485 
486     function reversePurchase(address _tokenHolder)
487         payable
488         public
489         onlyOwner
490     {
491         uint refund = token.balanceOf(_tokenHolder)*price_in_wei;
492         require(msg.value >= refund);
493         uint excessAmount = msg.value - refund;
494 
495         if (excessAmount > 0) {
496             msg.sender.transfer(excessAmount);
497         }
498 
499         _tokenHolder.transfer(refund);
500         token.reversePurchase(_tokenHolder);
501     }
502 
503     function setSetupComplete()
504         public
505         onlyOwner
506     {
507         require(wallet!=0);
508         require(privateAllocated!=0);  
509         setupCompleteFlag = true;
510     }
511 
512     function configureWallet(address _wallet)
513         public
514         onlyOwner
515     {
516         wallet = _wallet;
517     }
518 
519     function changeOwner(address _newOwner)
520         public
521         onlyOwner
522     {
523         require(_newOwner != 0);
524         owner = _newOwner;
525     }
526 
527     function changePrice(uint _newPrice)
528         public
529         onlyOwner
530         notFrozen
531         validPrice(_newPrice)
532     {
533         price_in_wei = _newPrice;
534     }
535 
536     function changeStartBlock(uint _newBlock)
537         public
538         onlyOwner
539         notFrozen
540     {
541         require(block.number <= _newBlock && _newBlock < startBlock);
542         freezeBlock = _newBlock - (startBlock - freezeBlock);
543         startBlock = _newBlock;
544     }
545 
546     function emergencyToggle()
547         public
548         onlyOwner
549     {
550         emergencyFlag = !emergencyFlag;
551     }
552     
553     function addWhitelist(address[] _purchaser, uint[] _amount)
554         public
555         onlyOwner
556         saleNotEnded
557     {
558         assert(_purchaser.length < 11 );
559         assert(_purchaser.length == _amount.length);
560         for(uint i = 0; i < _purchaser.length; i++) {
561             whitelistRegistrants[_purchaser[i]] = _amount[i];
562         }
563     }
564 
565     // MODIFIERS
566 
567     modifier saleEnded {
568         require(block.number >= endBlock);
569         _;
570     }
571 
572     modifier saleNotEnded {
573         require(block.number < endBlock);
574         _;
575     }
576 
577     modifier onlyOwner {
578         require(msg.sender == owner);
579         _;
580     }
581 
582     modifier notFrozen {
583         require(block.number < freezeBlock);
584         _;
585     }
586 
587     modifier saleInProgress {
588         require(block.number >= startBlock && block.number < endBlock);
589         _;
590     }
591 
592     modifier setupComplete {
593         assert(setupCompleteFlag);
594         _;
595     }
596 
597     modifier notInEmergency {
598         assert(emergencyFlag == false);
599         _;
600     }
601 
602     modifier checkBlockNumberInputs(uint _freeze, uint _start, uint _end) {
603         require(_freeze >= block.number
604         && _start >= _freeze
605         && _end >= _start);
606         _;
607     }
608 
609     modifier validPrice(uint _price){
610         require(_price > 0);
611         _;
612     }
613 
614 }