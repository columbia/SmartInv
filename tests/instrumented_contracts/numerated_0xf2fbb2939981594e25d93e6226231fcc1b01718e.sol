1 library SafeMath {
2   function mul(uint256 a, uint256 b) pure internal  returns (uint256) {
3     uint256 c = a * b;
4     assert(a == 0 || c / a == b);
5     return c;
6   }
7 
8   function div(uint256 a, uint256 b) pure internal  returns (uint256) {
9     // assert(b > 0); // Solidity automatically throws when dividing by 0
10     uint256 c = a / b;
11     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) pure internal  returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) pure internal  returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract Token {
28     /* This is a slight change to the ERC20 base standard.
29     function totalSupply() constant returns (uint256 supply);
30     is replaced with:
31     uint256 public totalSupply;
32     This automatically creates a getter function for the totalSupply.
33     This is moved to the base contract since public getter functions are not
34     currently recognised as an implementation of the matching abstract
35     function by the compiler.
36     */
37     /// total amount of tokens
38     uint256 public totalSupply;
39     address public sale;
40     bool public transfersAllowed;
41     
42     /// @param _owner The address from which the balance will be retrieved
43     /// @return The balance
44     function balanceOf(address _owner) constant public returns (uint256 balance);
45 
46     /// @notice send `_value` token to `_to` from `msg.sender`
47     /// @param _to The address of the recipient
48     /// @param _value The amount of token to be transferred
49     /// @return Whether the transfer was successful or not
50     function transfer(address _to, uint256 _value) public returns (bool success);
51 
52     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
53     /// @param _from The address of the sender
54     /// @param _to The address of the recipient
55     /// @param _value The amount of token to be transferred
56     /// @return Whether the transfer was successful or not
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
58 
59     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
60     /// @param _spender The address of the account able to transfer the tokens
61     /// @param _value The amount of tokens to be approved for transfer
62     /// @return Whether the approval was successful or not
63     function approve(address _spender, uint256 _value) public returns (bool success);
64 
65     /// @param _owner The address of the account owning tokens
66     /// @param _spender The address of the account able to transfer the tokens
67     /// @return Amount of remaining tokens allowed to spent
68     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72 }
73 
74 contract StandardToken is Token {
75 
76     function transfer(address _to, uint256 _value)
77         public
78         validTransfer
79        	returns (bool success) 
80     {
81         //Default assumes totalSupply can't be over max (2^256 - 1).
82         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
83         //Replace the if with this one instead.
84         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
85     	require(balances[msg.sender] >= _value);
86         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
87         balances[_to] = SafeMath.add(balances[_to],_value);
88         Transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value)
93         public
94         validTransfer
95       	returns (bool success)
96       {
97         //same as above. Replace this line with the following if you want to protect against wrapping uints.
98         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
99 	    require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
100         balances[_to] = SafeMath.add(balances[_to], _value);
101         balances[_from] = SafeMath.sub(balances[_from], _value);
102         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
103         Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function balanceOf(address _owner) public constant returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     function approve(address _spender, uint256 _value) public returns (bool success) {
112         require(balances[msg.sender] >= _value);
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
119       return allowed[_owner][_spender];
120     }
121 
122     mapping (address => uint256) balances;
123     mapping (address => mapping (address => uint256)) allowed;
124 
125     modifier validTransfer()
126     {
127         require(msg.sender == sale || transfersAllowed);
128         _;
129     }   
130 }
131 
132 contract HumanStandardToken is StandardToken {
133 
134     /* Public variables of the token */
135 
136     /*
137     NOTE:
138     The following variables are OPTIONAL vanities. One does not have to include them.
139     They allow one to customise the token contract & in no way influences the core functionality.
140     Some wallets/interfaces might not even bother to look at this information.
141     */
142     string public name;                   //fancy name: eg Simon Bucks
143     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
144     string public symbol;                 //An identifier: eg SBX
145     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
146 
147     function HumanStandardToken(
148         uint256 _initialAmount,
149         string _tokenName,
150         uint8 _decimalUnits,
151         string _tokenSymbol,
152         address _sale)
153         public
154     {
155         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
156         totalSupply = _initialAmount;                        // Update total supply
157         name = _tokenName;                                   // Set the name for display purposes
158         decimals = _decimalUnits;                            // Amount of decimals for display purposes
159         symbol = _tokenSymbol;                               // Set the symbol for display purposes
160         sale = _sale;
161         transfersAllowed = false;
162     }
163 
164     /* Approves and then calls the receiving contract */
165     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
166         allowed[msg.sender][_spender] = _value;
167         Approval(msg.sender, _spender, _value);
168 
169         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
170         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
171         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
172         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
173         return true;
174     }
175 
176     function reversePurchase(address _tokenHolder)
177         public
178         onlySale
179     {
180         require(!transfersAllowed);
181         uint value = balances[_tokenHolder];
182         balances[_tokenHolder] = SafeMath.sub(balances[_tokenHolder], value);
183         balances[sale] = SafeMath.add(balances[sale], value);
184         Transfer(_tokenHolder, sale, value);
185     }
186 
187     function removeTransferLock()
188         public
189         onlySale
190     {
191         transfersAllowed = true;
192     }
193 
194     modifier onlySale()
195     {
196         require(msg.sender == sale);
197         _;
198     }
199 }
200 
201 contract Disbursement {
202 
203     /*
204      *  Storage
205      */
206     address public owner;
207     address public receiver;
208     uint public disbursementPeriod;
209     uint public startDate;
210     uint public withdrawnTokens;
211     Token public token;
212 
213     /*
214      *  Modifiers
215      */
216     modifier isOwner() {
217         if (msg.sender != owner)
218             // Only owner is allowed to proceed
219             revert();
220         _;
221     }
222 
223     modifier isReceiver() {
224         if (msg.sender != receiver)
225             // Only receiver is allowed to proceed
226             revert();
227         _;
228     }
229 
230     modifier isSetUp() {
231         if (address(token) == 0)
232             // Contract is not set up
233             revert();
234         _;
235     }
236 
237     /*
238      *  Public functions
239      */
240     /// @dev Constructor function sets contract owner
241     /// @param _receiver Receiver of vested tokens
242     /// @param _disbursementPeriod Vesting period in seconds
243     /// @param _startDate Start date of disbursement period (cliff)
244     function Disbursement(address _receiver, uint _disbursementPeriod, uint _startDate)
245         public
246     {
247         if (_receiver == 0 || _disbursementPeriod == 0)
248             // Arguments are null
249             revert();
250         owner = msg.sender;
251         receiver = _receiver;
252         disbursementPeriod = _disbursementPeriod;
253         startDate = _startDate;
254         if (startDate == 0)
255             startDate = now;
256     }
257 
258     /// @dev Setup function sets external contracts' addresses
259     /// @param _token Token address
260     function setup(Token _token)
261         public
262         isOwner
263     {
264         if (address(token) != 0 || address(_token) == 0)
265             // Setup was executed already or address is null
266             revert();
267         token = _token;
268     }
269 
270     /// @dev Transfers tokens to a given address
271     /// @param _to Address of token receiver
272     /// @param _value Number of tokens to transfer
273     function withdraw(address _to, uint256 _value)
274         public
275         isReceiver
276         isSetUp
277     {
278         uint maxTokens = calcMaxWithdraw();
279         if (_value > maxTokens)
280             revert();
281         withdrawnTokens = SafeMath.add(withdrawnTokens, _value);
282         token.transfer(_to, _value);
283     }
284 
285     /// @dev Calculates the maximum amount of vested tokens
286     /// @return Number of vested tokens to withdraw
287     function calcMaxWithdraw()
288         public
289         constant
290         returns (uint)
291     {
292         uint maxTokens = SafeMath.mul(SafeMath.add(token.balanceOf(this), withdrawnTokens), SafeMath.sub(now,startDate)) / disbursementPeriod;
293         //uint maxTokens = (token.balanceOf(this) + withdrawnTokens) * (now - startDate) / disbursementPeriod;
294         if (withdrawnTokens >= maxTokens || startDate > now)
295             return 0;
296         if (SafeMath.sub(maxTokens, withdrawnTokens) > token.totalSupply())
297             return token.totalSupply();
298         return SafeMath.sub(maxTokens, withdrawnTokens);
299     }
300 }
301 
302 contract Sale {
303 
304     // EVENTS
305     event TransferredTimelockedTokens(address beneficiary, address disbursement,uint beneficiaryTokens);
306     event PurchasedTokens(address indexed purchaser, uint amount);
307     event LockedUnsoldTokens(uint numTokensLocked, address disburser);
308 
309     // STORAGE
310     uint public constant TOTAL_SUPPLY = 1000000000000000000;
311     uint public constant MAX_PRIVATE = 750200000000000000;
312 
313     uint8 public constant DECIMALS = 9;
314     string public constant NAME = "Leverj";
315     string public constant SYMBOL = "LEV";
316     address public owner;
317     address public whitelistAdmin;
318     address public wallet;
319     HumanStandardToken public token;
320     uint public freezeBlock;
321     uint public startBlock;
322     uint public endBlock;
323     uint public price_in_wei = 333333; //wei per 10**-9 of a LEV!
324     uint public privateAllocated = 0;
325     bool public setupCompleteFlag = false;
326     bool public emergencyFlag = false;
327     address[] public disbursements;
328     mapping(address => uint) public whitelistRegistrants;
329     mapping(address => bool) public whitelistRegistrantsFlag;
330     bool public publicSale = false;
331 
332     // PUBLIC FUNCTIONS
333     function Sale(
334         address _owner,
335         uint _freezeBlock,
336         uint _startBlock,
337         uint _endBlock,
338         address _whitelistAdmin)
339         public 
340         checkBlockNumberInputs(_freezeBlock, _startBlock, _endBlock)
341     {
342         owner = _owner;
343         whitelistAdmin = _whitelistAdmin;
344         token = new HumanStandardToken(TOTAL_SUPPLY, NAME, DECIMALS, SYMBOL, address(this));
345         freezeBlock = _freezeBlock;
346         startBlock = _startBlock;
347         endBlock = _endBlock;
348         assert(token.transfer(this, token.totalSupply()));
349         assert(token.balanceOf(this) == token.totalSupply());
350         assert(token.balanceOf(this) == TOTAL_SUPPLY);
351     }
352 
353     function purchaseTokens()
354         public
355         payable
356         setupComplete
357         notInEmergency
358         saleInProgress
359     {
360         require(whitelistRegistrantsFlag[msg.sender] == true);
361         /* Calculate whether any of the msg.value needs to be returned to
362            the sender. The purchaseAmount is the actual number of tokens which
363            will be purchased. */
364         uint purchaseAmount = msg.value / price_in_wei; 
365         uint excessAmount = msg.value % price_in_wei;
366 
367         if (!publicSale){
368             require(whitelistRegistrants[msg.sender] > 0 );
369             uint tempWhitelistAmount = whitelistRegistrants[msg.sender];
370             if (purchaseAmount > whitelistRegistrants[msg.sender]){
371                 uint extra = SafeMath.sub(purchaseAmount,whitelistRegistrants[msg.sender]);
372                 purchaseAmount = whitelistRegistrants[msg.sender];
373                 excessAmount = SafeMath.add(excessAmount,extra*price_in_wei);
374             }
375             whitelistRegistrants[msg.sender] = SafeMath.sub(whitelistRegistrants[msg.sender], purchaseAmount);
376             assert(whitelistRegistrants[msg.sender] < tempWhitelistAmount);
377         }  
378 
379         // Cannot purchase more tokens than this contract has available to sell
380         require(purchaseAmount <= token.balanceOf(this));
381         // Return any excess msg.value
382         if (excessAmount > 0){
383             msg.sender.transfer(excessAmount);
384         }
385         // Forward received ether minus any excessAmount to the wallet
386         wallet.transfer(this.balance);
387         // Transfer the sum of tokens tokenPurchase to the msg.sender
388         assert(token.transfer(msg.sender, purchaseAmount));
389         PurchasedTokens(msg.sender, purchaseAmount);
390     }
391 
392     function lockUnsoldTokens(address _unsoldTokensWallet)
393         public
394         saleEnded
395         setupComplete
396         onlyOwner
397     {
398         Disbursement disbursement = new Disbursement(
399             _unsoldTokensWallet,
400             1*365*24*60*60,
401             block.timestamp
402         );
403         disbursement.setup(token);
404         uint amountToLock = token.balanceOf(this);
405         disbursements.push(disbursement);
406         token.transfer(disbursement, amountToLock);
407         LockedUnsoldTokens(amountToLock, disbursement);
408     }
409 
410     // OWNER-ONLY FUNCTIONS
411     function distributeTimelockedTokens(
412         address[] _beneficiaries,
413         uint[] _beneficiariesTokens,
414         uint[] _timelockStarts,
415         uint[] _periods
416     ) 
417         public
418         onlyOwner
419         saleNotEnded
420     { 
421         assert(!setupCompleteFlag);
422         assert(_beneficiariesTokens.length < 11);
423         assert(_beneficiaries.length == _beneficiariesTokens.length);
424         assert(_beneficiariesTokens.length == _timelockStarts.length);
425         assert(_timelockStarts.length == _periods.length);
426         for(uint i = 0; i < _beneficiaries.length; i++) {
427             require(privateAllocated + _beneficiariesTokens[i] <= MAX_PRIVATE);
428             privateAllocated = SafeMath.add(privateAllocated, _beneficiariesTokens[i]);
429             address beneficiary = _beneficiaries[i];
430             uint beneficiaryTokens = _beneficiariesTokens[i];
431             Disbursement disbursement = new Disbursement(
432                 beneficiary,
433                 _periods[i],
434                 _timelockStarts[i]
435             );
436             disbursement.setup(token);
437             token.transfer(disbursement, beneficiaryTokens);
438             disbursements.push(disbursement);
439             TransferredTimelockedTokens(beneficiary, disbursement, beneficiaryTokens);
440         }
441         assert(token.balanceOf(this) >= (SafeMath.sub(TOTAL_SUPPLY, MAX_PRIVATE)));
442     }
443 
444     function distributePresaleTokens(address[] _buyers, uint[] _amounts)
445         public
446         onlyOwner
447         saleNotEnded
448     {
449         assert(!setupCompleteFlag);
450         require(_buyers.length < 11);
451         require(_buyers.length == _amounts.length);
452         for(uint i=0; i < _buyers.length; i++){
453             require(SafeMath.add(privateAllocated, _amounts[i]) <= MAX_PRIVATE);
454             assert(token.transfer(_buyers[i], _amounts[i]));
455             privateAllocated = SafeMath.add(privateAllocated, _amounts[i]);
456             PurchasedTokens(_buyers[i], _amounts[i]);
457         }
458         assert(token.balanceOf(this) >= (SafeMath.sub(TOTAL_SUPPLY, MAX_PRIVATE)));
459     }
460 
461     function removeTransferLock()
462         public
463         onlyOwner
464     {
465         token.removeTransferLock();
466     }
467 
468     function reversePurchase(address _tokenHolder)
469         payable
470         public
471         onlyOwner
472     {
473         uint refund = SafeMath.mul(token.balanceOf(_tokenHolder),price_in_wei);
474         require(msg.value >= refund);
475         uint excessAmount = SafeMath.sub(msg.value, refund);
476         if (excessAmount > 0) {
477             msg.sender.transfer(excessAmount);
478         }
479 
480         _tokenHolder.transfer(refund);
481         token.reversePurchase(_tokenHolder);
482     }
483 
484     function setSetupComplete()
485         public
486         onlyOwner
487     {
488         require(wallet!=0);
489         require(privateAllocated!=0);  
490         setupCompleteFlag = true;
491     }
492 
493     function configureWallet(address _wallet)
494         public
495         onlyOwner
496     {
497         wallet = _wallet;
498     }
499 
500     function changeOwner(address _newOwner)
501         public
502         onlyOwner
503     {
504         require(_newOwner != 0);
505         owner = _newOwner;
506     }
507 
508     function changeWhitelistAdmin(address _newAdmin)
509         public
510         onlyOwner
511     {
512         require(_newAdmin != 0);
513         whitelistAdmin = _newAdmin;
514     }
515 
516     function changePrice(uint _newPrice)
517         public
518         onlyOwner
519         notFrozen
520         validPrice(_newPrice)
521     {
522         price_in_wei = _newPrice;
523     }
524 
525     function changeStartBlock(uint _newBlock)
526         public
527         onlyOwner
528         notFrozen
529     {
530         require(block.number <= _newBlock && _newBlock < startBlock);
531         freezeBlock = SafeMath.sub(_newBlock , SafeMath.sub(startBlock, freezeBlock));
532         startBlock = _newBlock;
533     }
534 
535     function emergencyToggle()
536         public
537         onlyOwner
538     {
539         emergencyFlag = !emergencyFlag;
540     }
541     
542     function addWhitelist(address[] _purchaser, uint[] _amount)
543         public
544         onlyWhitelistAdmin
545         saleNotEnded
546     {
547         assert(_purchaser.length < 11 );
548         assert(_purchaser.length == _amount.length);
549         for(uint i = 0; i < _purchaser.length; i++) {
550             whitelistRegistrants[_purchaser[i]] = _amount[i];
551             whitelistRegistrantsFlag[_purchaser[i]] = true;
552             
553         }
554     }
555 
556     function startPublicSale()
557         public
558         onlyOwner
559     {
560         if (!publicSale){
561             publicSale = true;
562         }
563     }
564 
565     // MODIFIERS
566     modifier saleEnded {
567         require(block.number >= endBlock);
568         _;
569     }
570     modifier saleNotEnded {
571         require(block.number < endBlock);
572         _;
573     }
574     modifier onlyOwner {
575         require(msg.sender == owner);
576         _;
577     }
578     modifier onlyWhitelistAdmin {
579         require(msg.sender == owner || msg.sender == whitelistAdmin);
580         _;
581     }
582     modifier notFrozen {
583         require(block.number < freezeBlock);
584         _;
585     }
586     modifier saleInProgress {
587         require(block.number >= startBlock && block.number < endBlock);
588         _;
589     }
590     modifier setupComplete {
591         assert(setupCompleteFlag);
592         _;
593     }
594     modifier notInEmergency {
595         assert(emergencyFlag == false);
596         _;
597     }
598     modifier checkBlockNumberInputs(uint _freeze, uint _start, uint _end) {
599         require(_freeze >= block.number
600         && _start >= _freeze
601         && _end >= _start);
602         _;
603     }
604     modifier validPrice(uint _price){
605         require(_price > 0);
606         _;
607     }
608 }