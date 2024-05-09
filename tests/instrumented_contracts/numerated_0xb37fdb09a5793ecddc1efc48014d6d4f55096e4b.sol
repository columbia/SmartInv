1 pragma solidity ^0.4.17;
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
15     address public sale;
16     bool public transfersAllowed;
17     
18     /// @param _owner The address from which the balance will be retrieved
19     /// @return The balance
20     function balanceOf(address _owner) constant public returns (uint256 balance);
21 
22     /// @notice send `_value` token to `_to` from `msg.sender`
23     /// @param _to The address of the recipient
24     /// @param _value The amount of token to be transferred
25     /// @return Whether the transfer was successful or not
26     function transfer(address _to, uint256 _value) public returns (bool success);
27 
28     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29     /// @param _from The address of the sender
30     /// @param _to The address of the recipient
31     /// @param _value The amount of token to be transferred
32     /// @return Whether the transfer was successful or not
33     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
34 
35     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36     /// @param _spender The address of the account able to transfer the tokens
37     /// @param _value The amount of tokens to be approved for transfer
38     /// @return Whether the approval was successful or not
39     function approve(address _spender, uint256 _value) public returns (bool success);
40 
41     /// @param _owner The address of the account owning tokens
42     /// @param _spender The address of the account able to transfer the tokens
43     /// @return Amount of remaining tokens allowed to spent
44     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
45 
46     event Transfer(address indexed _from, address indexed _to, uint256 _value);
47     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 
51 contract StandardToken is Token {
52 
53     function transfer(address _to, uint256 _value)
54         public
55         validTransfer
56         returns (bool success) 
57     {
58         //Default assumes totalSupply can't be over max (2^256 - 1).
59         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
60         //Replace the if with this one instead.
61         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
62         require(balances[msg.sender] >= _value);
63         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
64         balances[_to] = SafeMath.add(balances[_to],_value);
65         Transfer(msg.sender, _to, _value);
66         return true;
67     }
68 
69     function transferFrom(address _from, address _to, uint256 _value)
70         public
71         validTransfer
72         returns (bool success)
73       {
74         //same as above. Replace this line with the following if you want to protect against wrapping uints.
75         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
76         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
77         balances[_to] = SafeMath.add(balances[_to], _value);
78         balances[_from] = SafeMath.sub(balances[_from], _value);
79         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
80         Transfer(_from, _to, _value);
81         return true;
82     }
83 
84     function balanceOf(address _owner) public constant returns (uint256 balance) {
85         return balances[_owner];
86     }
87 
88     function approve(address _spender, uint256 _value) public returns (bool success) {
89         require(balances[msg.sender] >= _value);
90         allowed[msg.sender][_spender] = _value;
91         Approval(msg.sender, _spender, _value);
92         return true;
93     }
94 
95     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
96       return allowed[_owner][_spender];
97     }
98 
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowed;
101 
102     modifier validTransfer()
103     {
104         require(msg.sender == sale || transfersAllowed);
105         _;
106     }   
107 }
108 
109 
110 contract HumanStandardToken is StandardToken {
111 
112     /* Public variables of the token */
113 
114     /*
115     NOTE:
116     The following variables are OPTIONAL vanities. One does not have to include them.
117     They allow one to customise the token contract & in no way influences the core functionality.
118     Some wallets/interfaces might not even bother to look at this information.
119     */
120     string public name;                   //fancy name: eg Simon Bucks
121     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
122     string public symbol;                 //An identifier: eg SBX
123     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
124 
125     function HumanStandardToken(
126         uint256 _initialAmount,
127         string _tokenName,
128         uint8 _decimalUnits,
129         string _tokenSymbol,
130         address _sale)
131         public
132     {
133         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
134         totalSupply = _initialAmount;                        // Update total supply
135         name = _tokenName;                                   // Set the name for display purposes
136         decimals = _decimalUnits;                            // Amount of decimals for display purposes
137         symbol = _tokenSymbol;                               // Set the symbol for display purposes
138         sale = _sale;
139         transfersAllowed = false;
140     }
141 
142     /* Approves and then calls the receiving contract */
143     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
144         allowed[msg.sender][_spender] = _value;
145         Approval(msg.sender, _spender, _value);
146 
147         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
148         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
149         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
150         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
151         return true;
152     }
153 
154     function reversePurchase(address _tokenHolder)
155         public
156         onlySale
157     {
158         require(!transfersAllowed);
159         uint value = balances[_tokenHolder];
160         balances[_tokenHolder] = SafeMath.sub(balances[_tokenHolder], value);
161         balances[sale] = SafeMath.add(balances[sale], value);
162         Transfer(_tokenHolder, sale, value);
163     }
164 
165     function removeTransferLock()
166         public
167         onlySale
168     {
169         transfersAllowed = true;
170     }
171 
172     modifier onlySale()
173     {
174         require(msg.sender == sale);
175         _;
176     }
177 }
178 
179 
180 contract Disbursement {
181 
182     /*
183      *  Storage
184      */
185     address public owner;
186     address public receiver;
187     uint public disbursementPeriod;
188     uint public startDate;
189     uint public withdrawnTokens;
190     Token public token;
191 
192     /*
193      *  Modifiers
194      */
195     modifier isOwner() {
196         if (msg.sender != owner)
197             // Only owner is allowed to proceed
198             revert();
199         _;
200     }
201 
202     modifier isReceiver() {
203         if (msg.sender != receiver)
204             // Only receiver is allowed to proceed
205             revert();
206         _;
207     }
208 
209     modifier isSetUp() {
210         if (address(token) == 0)
211             // Contract is not set up
212             revert();
213         _;
214     }
215 
216     /*
217      *  Public functions
218      */
219     /// @dev Constructor function sets contract owner
220     /// @param _receiver Receiver of vested tokens
221     /// @param _disbursementPeriod Vesting period in seconds
222     /// @param _startDate Start date of disbursement period (cliff)
223     function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)
224         public
225     {
226         if (_receiver == 0 || _disbursementPeriod == 0)
227             // Arguments are null
228             revert();
229         owner = msg.sender;
230         receiver = _receiver;
231         disbursementPeriod = _disbursementPeriod;
232         startDate = _startDate;
233         if (startDate == 0)
234             startDate = now;
235     }
236 
237     /// @dev Setup function sets external contracts' addresses
238     /// @param _token Token address
239     function setup(Token _token)
240         public
241         isOwner
242     {
243         if (address(token) != 0 || address(_token) == 0)
244             // Setup was executed already or address is null
245             revert();
246         token = _token;
247     }
248 
249     /// @dev Transfers tokens to a given address
250     /// @param _to Address of token receiver
251     /// @param _value Number of tokens to transfer
252     function withdraw(address _to, uint256 _value)
253         public
254         isReceiver
255         isSetUp
256     {
257         uint maxTokens = calcMaxWithdraw();
258         if (_value > maxTokens)
259             revert();
260         withdrawnTokens = SafeMath.add(withdrawnTokens, _value);
261         token.transfer(_to, _value);
262     }
263 
264     /// @dev Calculates the maximum amount of vested tokens
265     /// @return Number of vested tokens to withdraw
266     function calcMaxWithdraw()
267         public
268         constant
269         returns (uint)
270     {
271         uint maxTokens = SafeMath.mul(SafeMath.add(token.balanceOf(this), withdrawnTokens), SafeMath.sub(now,startDate)) / disbursementPeriod;
272         //uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;
273         if (withdrawnTokens >= maxTokens || startDate > now)
274             return 0;
275         if (SafeMath.sub(maxTokens, withdrawnTokens) > token.totalSupply())
276             return token.totalSupply();
277         return SafeMath.sub(maxTokens, withdrawnTokens);
278     }
279 }
280 
281 
282 library SafeMath {
283   function mul(uint256 a, uint256 b) pure internal  returns (uint256) {
284     uint256 c = a * b;
285     assert(a == 0 || c / a == b);
286     return c;
287   }
288 
289   function div(uint256 a, uint256 b) pure internal  returns (uint256) {
290     // assert(b > 0); // Solidity automatically throws when dividing by 0
291     uint256 c = a / b;
292     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
293     return c;
294   }
295 
296   function sub(uint256 a, uint256 b) pure internal  returns (uint256) {
297     assert(b <= a);
298     return a - b;
299   }
300 
301   function add(uint256 a, uint256 b) pure internal  returns (uint256) {
302     uint256 c = a + b;
303     assert(c >= a);
304     return c;
305   }
306 }
307 
308 
309 contract Sale {
310 
311     // EVENTS
312     event TransferredTimelockedTokens(address beneficiary, address disbursement,uint beneficiaryTokens);
313     event PurchasedTokens(address indexed purchaser, uint amount);
314     event LockedUnsoldTokens(uint numTokensLocked, address disburser);
315 
316     // STORAGE
317     uint public constant TOTAL_SUPPLY = 1000000000000000000;
318     uint public constant MAX_PRIVATE = 750000000000000000;
319     uint8 public constant DECIMALS = 9;
320     string public constant NAME = "Leverj";
321     string public constant SYMBOL = "LEV";
322     address public owner;
323     address public whitelistAdmin;
324     address public wallet;
325     HumanStandardToken public token;
326     uint public freezeBlock;
327     uint public startBlock;
328     uint public endBlock;
329     uint public price_in_wei = 333333; //wei per 10**-9 of a LEV!
330     uint public privateAllocated = 0;
331     bool public setupCompleteFlag = false;
332     bool public emergencyFlag = false;
333     address[] public disbursements;
334     mapping(address => uint) public whitelistRegistrants;
335     mapping(address => bool) public whitelistRegistrantsFlag;
336     bool public publicSale = false;
337 
338     // PUBLIC FUNCTIONS
339     function Sale(
340         address _owner,
341         uint _freezeBlock,
342         uint _startBlock,
343         uint _endBlock,
344         address _whitelistAdmin)
345         public 
346         checkBlockNumberInputs(_freezeBlock, _startBlock, _endBlock)
347     {
348         owner = _owner;
349         whitelistAdmin = _whitelistAdmin;
350         token = new HumanStandardToken(TOTAL_SUPPLY, NAME, DECIMALS, SYMBOL, address(this));
351         freezeBlock = _freezeBlock;
352         startBlock = _startBlock;
353         endBlock = _endBlock;
354         assert(token.transfer(this, token.totalSupply()));
355         assert(token.balanceOf(this) == token.totalSupply());
356         assert(token.balanceOf(this) == TOTAL_SUPPLY);
357     }
358 
359     function purchaseTokens()
360         public
361         payable
362         setupComplete
363         notInEmergency
364         saleInProgress
365     {
366         require(whitelistRegistrantsFlag[msg.sender] == true);
367         /* Calculate whether any of the msg.value needs to be returned to
368            the sender. The purchaseAmount is the actual number of tokens which
369            will be purchased. */
370         uint purchaseAmount = msg.value / price_in_wei; 
371         uint excessAmount = msg.value % price_in_wei;
372 
373         if (!publicSale){
374             require(whitelistRegistrants[msg.sender] > 0 );
375             uint tempWhitelistAmount = whitelistRegistrants[msg.sender];
376             if (purchaseAmount > whitelistRegistrants[msg.sender]){
377                 uint extra = SafeMath.sub(purchaseAmount,whitelistRegistrants[msg.sender]);
378                 purchaseAmount = whitelistRegistrants[msg.sender];
379                 excessAmount = SafeMath.add(excessAmount,extra*price_in_wei);
380             }
381             whitelistRegistrants[msg.sender] = SafeMath.sub(whitelistRegistrants[msg.sender], purchaseAmount);
382             assert(whitelistRegistrants[msg.sender] < tempWhitelistAmount);
383         }  
384 
385         // Cannot purchase more tokens than this contract has available to sell
386         require(purchaseAmount <= token.balanceOf(this));
387         // Return any excess msg.value
388         if (excessAmount > 0){
389             msg.sender.transfer(excessAmount);
390         }
391         // Forward received ether minus any excessAmount to the wallet
392         wallet.transfer(this.balance);
393         // Transfer the sum of tokens tokenPurchase to the msg.sender
394         assert(token.transfer(msg.sender, purchaseAmount));
395         PurchasedTokens(msg.sender, purchaseAmount);
396     }
397 
398     function lockUnsoldTokens(address _unsoldTokensWallet)
399         public
400         saleEnded
401         setupComplete
402         onlyOwner
403     {
404         Disbursement disbursement = new Disbursement(
405             _unsoldTokensWallet,
406             1*365*24*60*60,
407             block.timestamp
408         );
409         disbursement.setup(token);
410         uint amountToLock = token.balanceOf(this);
411         disbursements.push(disbursement);
412         token.transfer(disbursement, amountToLock);
413         LockedUnsoldTokens(amountToLock, disbursement);
414     }
415 
416     // OWNER-ONLY FUNCTIONS
417     function distributeTimelockedTokens(
418         address[] _beneficiaries,
419         uint[] _beneficiariesTokens,
420         uint[] _timelockStarts,
421         uint[] _periods
422     ) 
423         public
424         onlyOwner
425         saleNotEnded
426     { 
427         assert(!setupCompleteFlag);
428         assert(_beneficiariesTokens.length < 11);
429         assert(_beneficiaries.length == _beneficiariesTokens.length);
430         assert(_beneficiariesTokens.length == _timelockStarts.length);
431         assert(_timelockStarts.length == _periods.length);
432         for(uint i = 0; i < _beneficiaries.length; i++) {
433             require(privateAllocated + _beneficiariesTokens[i] <= MAX_PRIVATE);
434             privateAllocated = SafeMath.add(privateAllocated, _beneficiariesTokens[i]);
435             address beneficiary = _beneficiaries[i];
436             uint beneficiaryTokens = _beneficiariesTokens[i];
437             Disbursement disbursement = new Disbursement(
438                 beneficiary,
439                 _periods[i],
440                 _timelockStarts[i]
441             );
442             disbursement.setup(token);
443             token.transfer(disbursement, beneficiaryTokens);
444             disbursements.push(disbursement);
445             TransferredTimelockedTokens(beneficiary, disbursement, beneficiaryTokens);
446         }
447         assert(token.balanceOf(this) >= (SafeMath.sub(TOTAL_SUPPLY, MAX_PRIVATE)));
448     }
449 
450     function distributePresaleTokens(address[] _buyers, uint[] _amounts)
451         public
452         onlyOwner
453         saleNotEnded
454     {
455         assert(!setupCompleteFlag);
456         require(_buyers.length < 11);
457         require(_buyers.length == _amounts.length);
458         for(uint i=0; i < _buyers.length; i++){
459             require(SafeMath.add(privateAllocated, _amounts[i]) <= MAX_PRIVATE);
460             assert(token.transfer(_buyers[i], _amounts[i]));
461             privateAllocated = SafeMath.add(privateAllocated, _amounts[i]);
462             PurchasedTokens(_buyers[i], _amounts[i]);
463         }
464         assert(token.balanceOf(this) >= (SafeMath.sub(TOTAL_SUPPLY, MAX_PRIVATE)));
465     }
466 
467     function removeTransferLock()
468         public
469         onlyOwner
470     {
471         token.removeTransferLock();
472     }
473 
474     function reversePurchase(address _tokenHolder)
475         payable
476         public
477         onlyOwner
478     {
479         uint refund = SafeMath.mul(token.balanceOf(_tokenHolder),price_in_wei);
480         require(msg.value >= refund);
481         uint excessAmount = SafeMath.sub(msg.value, refund);
482         if (excessAmount > 0) {
483             msg.sender.transfer(excessAmount);
484         }
485 
486         _tokenHolder.transfer(refund);
487         token.reversePurchase(_tokenHolder);
488     }
489 
490     function setSetupComplete()
491         public
492         onlyOwner
493     {
494         require(wallet!=0);
495         require(privateAllocated!=0);  
496         setupCompleteFlag = true;
497     }
498 
499     function configureWallet(address _wallet)
500         public
501         onlyOwner
502     {
503         wallet = _wallet;
504     }
505 
506     function changeOwner(address _newOwner)
507         public
508         onlyOwner
509     {
510         require(_newOwner != 0);
511         owner = _newOwner;
512     }
513 
514     function changeWhitelistAdmin(address _newAdmin)
515         public
516         onlyOwner
517     {
518         require(_newAdmin != 0);
519         whitelistAdmin = _newAdmin;
520     }
521 
522     function changePrice(uint _newPrice)
523         public
524         onlyOwner
525         notFrozen
526         validPrice(_newPrice)
527     {
528         price_in_wei = _newPrice;
529     }
530 
531     function changeStartBlock(uint _newBlock)
532         public
533         onlyOwner
534         notFrozen
535     {
536         require(block.number <= _newBlock && _newBlock < startBlock);
537         freezeBlock = SafeMath.sub(_newBlock , SafeMath.sub(startBlock, freezeBlock));
538         startBlock = _newBlock;
539     }
540 
541     function emergencyToggle()
542         public
543         onlyOwner
544     {
545         emergencyFlag = !emergencyFlag;
546     }
547     
548     function addWhitelist(address[] _purchaser, uint[] _amount)
549         public
550         onlyWhitelistAdmin
551         saleNotEnded
552     {
553         assert(_purchaser.length < 11 );
554         assert(_purchaser.length == _amount.length);
555         for(uint i = 0; i < _purchaser.length; i++) {
556             whitelistRegistrants[_purchaser[i]] = _amount[i];
557             whitelistRegistrantsFlag[_purchaser[i]] = true;
558         }
559     }
560 
561     function startPublicSale()
562         public
563         onlyOwner
564     {
565         if (!publicSale){
566             publicSale = true;
567         }
568     }
569 
570     // MODIFIERS
571     modifier saleEnded {
572         require(block.number >= endBlock);
573         _;
574     }
575     modifier saleNotEnded {
576         require(block.number < endBlock);
577         _;
578     }
579     modifier onlyOwner {
580         require(msg.sender == owner);
581         _;
582     }
583     modifier onlyWhitelistAdmin {
584         require(msg.sender == owner || msg.sender == whitelistAdmin);
585         _;
586     }
587     modifier notFrozen {
588         require(block.number < freezeBlock);
589         _;
590     }
591     modifier saleInProgress {
592         require(block.number >= startBlock && block.number < endBlock);
593         _;
594     }
595     modifier setupComplete {
596         assert(setupCompleteFlag);
597         _;
598     }
599     modifier notInEmergency {
600         assert(emergencyFlag == false);
601         _;
602     }
603     modifier checkBlockNumberInputs(uint _freeze, uint _start, uint _end) {
604         require(_freeze >= block.number
605         && _start >= _freeze
606         && _end >= _start);
607         _;
608     }
609     modifier validPrice(uint _price){
610         require(_price > 0);
611         _;
612     }
613 }