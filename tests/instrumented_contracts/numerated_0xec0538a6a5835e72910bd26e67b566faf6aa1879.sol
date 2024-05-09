1 pragma solidity ^0.4.18;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return c;
30     }
31 
32     /**
33     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57     address public owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63     * account.
64     */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70     * @dev Throws if called by any account other than the owner.
71     */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78     * @dev Allows the current owner to transfer control of the contract to a newOwner.
79     * @param newOwner The address to transfer ownership to.
80     */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 }
87 
88 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
89 
90 contract TokenERC20 {
91     using SafeMath for uint256;
92 
93     // Public variables of the token
94     string public name;
95     string public symbol;
96     uint8 public decimals = 18;
97     // 18 decimals is the strongly suggested default, avoid changing it
98     uint256 public totalSupply;
99 
100     // This creates an array with all balances
101     mapping (address => uint256) public balanceOf;
102     mapping (address => mapping (address => uint256)) public allowance;
103 
104     // This generates a public event on the blockchain that will notify clients
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     // This notifies clients about the amount burnt
108     event Burn(address indexed from, uint256 value);
109 
110     /**
111     * Constructor function
112     *
113     * Initializes contract with initial supply tokens to the creator of the contract
114     */
115     function TokenERC20(
116         uint256 initialSupply,
117         string tokenName,
118         string tokenSymbol
119     ) public {
120         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
121         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
122         name = tokenName;                                   // Set the name for display purposes
123         symbol = tokenSymbol;                               // Set the symbol for display purposes
124     }
125 
126     /**
127     * Internal transfer, only can be called by this contract
128     */
129     function _transfer(address _from, address _to, uint _value) internal {
130         // Prevent transfer to 0x0 address. Use burn() instead
131         require(_to != 0x0);
132         // Check if the sender has enough
133         require(balanceOf[_from] >= _value);
134 
135         // Check for overflows
136         require(balanceOf[_to].add(_value) > balanceOf[_to]);
137 
138         // Save this for an assertion in the future
139         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
140 
141         // Subtract from the sender
142         balanceOf[_from] = balanceOf[_from].sub(_value);
143 
144         // Add the same to the recipient
145         balanceOf[_to] = balanceOf[_to].add(_value);
146 
147         emit Transfer(_from, _to, _value);
148         // Asserts are used to use static analysis to find bugs in your code. They should never fail
149         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
150     }
151 
152     /**
153     * Transfer tokens
154     *
155     * Send `_value` tokens to `_to` from your account
156     *
157     * @param _to The address of the recipient
158     * @param _value the amount to send
159     */
160     function transfer(address _to, uint256 _value) public {
161         _transfer(msg.sender, _to, _value);
162     }
163 
164     /**
165     * Transfer tokens from other address
166     *
167     * Send `_value` tokens to `_to` in behalf of `_from`
168     *
169     * @param _from The address of the sender
170     * @param _to The address of the recipient
171     * @param _value the amount to send
172     */
173     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
174         require(_value <= allowance[_from][msg.sender]);     // Check allowance
175         //allowance[_from][msg.sender] -= _value;
176         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
177         _transfer(_from, _to, _value);
178         return true;
179     }
180 
181     /**
182     * Set allowance for other address
183     *
184     * Allows `_spender` to spend no more than `_value` tokens in your behalf
185     *
186     * @param _spender The address authorized to spend
187     * @param _value the max amount they can spend
188     */
189     function approve(address _spender, uint256 _value) public
190         returns (bool success) {
191         allowance[msg.sender][_spender] = _value;
192         return true;
193     }
194 
195     /**
196     * Set allowance for other address and notify
197     *
198     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
199     *
200     * @param _spender The address authorized to spend
201     * @param _value the max amount they can spend
202     * @param _extraData some extra information to send to the approved contract
203     */
204     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
205         tokenRecipient spender = tokenRecipient(_spender);
206         if (approve(_spender, _value)) {
207             spender.receiveApproval(msg.sender, _value, this, _extraData);
208             return true;
209         }	
210     }
211 
212     /**
213      * Destroy tokens
214      *
215      * Remove `_value` tokens from the system irreversibly
216      *
217      * @param _value the amount of money to burn
218      */
219     function burn(uint256 _value) public returns (bool success) {
220         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
221         balanceOf[msg.sender] -= _value;            // Subtract from the sender
222         totalSupply -= _value;                      // Updates totalSupply
223         emit Burn(msg.sender, _value);
224         return true;
225     }
226 
227     /**
228      * Destroy tokens from other account
229      *
230      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
231      *
232      * @param _from the address of the sender
233      * @param _value the amount of money to burn
234      */
235     function burnFrom(address _from, uint256 _value) public returns (bool success) {
236         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
237         require(_value <= allowance[_from][msg.sender]);    // Check allowance
238         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
239         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
240         totalSupply -= _value;                              // Update totalSupply
241         emit Burn(_from, _value);
242         return true;
243     }
244 }
245 
246 /******************************************/
247 /*       ADVANCED TOKEN STARTS HERE       */
248 /******************************************/
249 contract CinociCoin is Ownable, TokenERC20 {
250     using SafeMath for uint256;
251 
252     mapping (address => bool)    public  frozenAccount;
253     mapping (address => uint256) public freezingPeriod; // how many days the account must remain frozen?
254 
255     mapping (address => bool) public exchangesAccounts;
256 
257     address public bountyManagerAddress;
258     address public bountyManagerDistributionContract = 0x0;
259 
260     address public fundAccount; 	// ballast fund address
261     bool public isSetFund = false;	// if ballast fund is set
262 
263     uint256 public creationDate;
264     uint256 public constant frozenDaysForAdvisor       = 187;  
265     uint256 public constant frozenDaysForBounty        = 187;
266     uint256 public constant frozenDaysForEarlyInvestor = 52;
267     uint256 public constant frozenDaysForICO           = 66;   
268     uint256 public constant frozenDaysForPartner       = 370;
269     uint256 public constant frozenDaysForPreICO        = 52;
270     uint256 public constant frozenDaysforTestExchange  = 0;
271 
272     /**
273     * allowed for a bounty manager account only
274     */
275     modifier onlyBountyManager(){
276         require((msg.sender == bountyManagerDistributionContract) || (msg.sender == bountyManagerAddress));
277         _;
278     }
279 
280     modifier onlyExchangesAccounts(){
281         require(exchangesAccounts[msg.sender]);
282         _;
283     }
284 
285     /**
286     * allowed for a fund account only
287     */
288     modifier onlyFund(){
289         require(msg.sender == fundAccount);
290         _;
291     }
292 
293     /* This generates a public event on the blockchain that will notify clients */
294     event FrozenFunds(address target, bool frozen);
295 
296     /**
297     * Initializes contract with initial supply tokens to the creator of the contract
298     *
299     *
300     */
301     function CinociCoin(
302         uint256 initialSupply,
303         string tokenName,
304         string tokenSymbol
305     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public 
306     {
307         /* solium-disable-next-line */
308         creationDate = now;
309 
310         address advisor = 0x32c5Ec858c52F8635Bd92e44d8797e5d356eBd05;
311         address bountyManager = 0xC10C83dfE7eed57038905A112F17c80b67Dd893C;
312         address earlyInvestor = 0x02FF2bA62440c92D2A02D95Df6fc233eA68c2091;
313         address partner = 0x6A45baAEb21D49fD85B309235Ef2920d3A648858;
314         address exchange1 = 0x8Bd10d3383504a12FD27A1Fd5c0E7bCeae3C8997;
315         address exchange2 = 0xce8b8e7113072C5308cec669375E0Ab364b3435C;
316 
317         _initializeAccount(partner, frozenDaysForPartner, 30000000);
318         _initializeAccount(advisor, frozenDaysForAdvisor, 20000000);
319         _initializeAccount(earlyInvestor, frozenDaysForEarlyInvestor, 10000000);  
320         _initializeAccount(exchange1, frozenDaysforTestExchange, 1000);
321         _initializeAccount(exchange2, frozenDaysforTestExchange, 1000);
322         _initializeAccount(bountyManager, frozenDaysForBounty, 15000000);
323         bountyManagerAddress = bountyManager;
324     }
325 
326     /**
327     * Only owner function to set ballast fund account address
328     * 
329     * @dev it can be set only once
330     * @param _address smart contract address of ballast fund
331     */
332     function setFundAccount(address _address) onlyOwner public{
333         require (_address != 0x0);
334         require (!isSetFund);
335         fundAccount = _address;
336         isSetFund = true;    
337     }
338 
339     function addExchangeAccounts(address _address) onlyOwner public{
340         require(_address != 0x0);
341         exchangesAccounts[_address] = true;
342     }
343 
344     function removeExchangeAccounts(address _address) onlyOwner public{
345         delete exchangesAccounts[_address];
346     }
347 
348     /**
349     * Initialize accounts when token deploy occurs
350     *
351     * initialize `_address` account, with balance equal `_value` and frozen for `_frozenDays`
352     *
353     * @param _address wallet address to initialize
354     * @param _frozenDays quantity of days to freeze account
355     * @param _value quantity of tokens to send to account
356     */
357     function _initializeAccount(address _address, uint _frozenDays, uint _value) internal{
358         _transfer(msg.sender, _address, _value * 10 ** uint256(decimals));
359         freezingPeriod[_address] = _frozenDays;
360         _freezeAccount(_address, true);
361     }
362 
363     /**
364     * Check if account freezing period expired
365     *
366     * `now` has to be greater or equal than `creationDate` + `freezingPeriod[_address]` * `1 day`
367     *
368     * @param _address account address to check if allowed to transfer tokens
369     * @return bool true if is allowed to transfer and false if not
370     */
371     function _isTransferAllowed( address _address ) view public returns (bool)
372     {
373         /* solium-disable-next-line */
374         if( now >= creationDate + freezingPeriod[_address] * 1 days ){
375             return ( true );
376         } else {
377             return ( false );
378         }
379     }
380 
381     /**
382     * Internal function to transfer tokens
383     *
384     * @param _from account to withdraw tokens
385     * @param _to account to receive tokens
386     * @param _value quantity of tokens to transfer
387     */
388     function _transfer(address _from, address _to, uint _value) internal {
389         require (_to != 0x0);                                  // Prevent transfer to 0x0 address. Use burn() instead
390         require (balanceOf[_from] >= _value);                  // Check if the sender has enough
391         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
392 
393         // check if the sender is under a freezing period
394         if(_isTransferAllowed(_from)){ 
395             _setFreezingPeriod(_from, false, 0);
396         }
397 
398         // check if the recipient is under a freezing period
399         if(_isTransferAllowed(_to)){
400             _setFreezingPeriod(_to, false, 0);
401         }
402 
403         require(!frozenAccount[_from]);     // Check if sender is frozen
404         require(!frozenAccount[_to]);       // Check if recipient is frozen                
405         
406         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
407         balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
408 
409         emit Transfer(_from, _to, _value);
410     }
411     
412     /**
413     * Internal function to deliver tokens for bounty, pre-ICO or ICO with determined freezing periods
414     *
415     * @param _from account address to withdraw tokens
416     * @param _to account address to send tokens
417     * @param _value quantity of tokes to send
418     * @param _frozenDays quantity of days to freeze account
419     */
420     function _tokenDelivery(address _from, address _to, uint _value, uint _frozenDays) internal {
421         freezingPeriod[_to] = 0;
422         _freezeAccount(_to, false);
423         _transfer(_from, _to, _value);
424         freezingPeriod[_to] = _frozenDays;
425         _freezeAccount(_to, true); 
426     }
427     
428     /**
429     * Only owner function to deliver tokens for pre-ICO investors
430     *
431     * @param _to account address who will receive the tokens
432     * @param _value quantity of tokens to deliver
433     */
434     function preICOTokenDelivery(address _to, uint _value) onlyOwner public {
435         _tokenDelivery(msg.sender, _to, _value, frozenDaysForPreICO);
436     }
437     
438     /**
439     * Only owner function to deliver tokens for ICO investors
440     *
441     * @param _to account address who will receive tokens
442     * @param _value quantity of tokens to deliver
443     */
444     function ICOTokenDelivery(address _to, uint _value) onlyOwner public {
445         _tokenDelivery(msg.sender, _to, _value, frozenDaysForICO);
446     }
447     
448     function setBountyDistributionContract(address _contractAddress) onlyOwner public {
449         bountyManagerDistributionContract = _contractAddress;
450     }
451 
452     /**onlyBounty
453     * Only bounty manager distribution contract function to deliver tokens for bounty community
454     *
455     * @param _to account addres who will receive tokens
456     * @param _value quantity of tokens to deliver
457     */
458     function bountyTransfer(address _to, uint _value) onlyBountyManager public {
459         _freezeAccount(bountyManagerAddress, false);
460         _tokenDelivery(bountyManagerAddress, _to, _value, frozenDaysForBounty);
461         _freezeAccount(bountyManagerAddress, true);
462     }
463 
464     /**
465     * Function to get days to unfreeze some account
466     *
467     * @param _address account address to get days
468     * @return result quantity of days to unfreeze `address`
469     */
470     function daysToUnfreeze(address _address) public view returns (uint256) {
471         require(_address != 0x0);
472 
473         /* solium-disable-next-line */
474         uint256 _now = now;
475         uint256 result = 0;
476 
477         if( _now <= creationDate + freezingPeriod[_address] * 1 days ) {
478             // still under the freezing period.
479             uint256 finalPeriod = (creationDate + freezingPeriod[_address] * 1 days) / 1 days;
480             uint256 currePeriod = _now / 1 days;
481             result = finalPeriod - currePeriod;
482         }
483 
484         return result;
485     }
486 
487     /**
488     * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
489     * @param target Address to be frozen
490     * @param freeze either to freeze it or not
491     */
492     function _freezeAccount(address target, bool freeze) internal {
493         frozenAccount[target] = freeze;
494         emit FrozenFunds(target, freeze);
495     }
496 
497     /**
498     * Only owner function to call `_freezeAccount` directly
499     *
500     * @param target account address to freeze
501     * @param freeze true to freeze account and false to unfreeze
502     */
503     function freezeAccount(address target, bool freeze) onlyOwner public {
504         _freezeAccount(target, freeze);
505     }
506     
507     /**
508     * Internal call to set freezing period for some account
509     *
510     * @param _target account address to freeze
511     * @param _freeze true to freeze account and false to unfreeze
512     * @param _days period to keep account frozen
513     */
514     function _setFreezingPeriod(address _target, bool _freeze, uint256 _days) internal {
515         _freezeAccount(_target, _freeze);
516         freezingPeriod[_target] = _days;
517     }
518     
519     /**
520     * Only owner function to call `_setFreezingPeriod` directly
521     *
522     * @param _target account address to freeze
523     * @param _freeze true to freeze account and false to unfreeze
524     * @param _days period to keep account frozen
525     */
526     function setFreezingPeriod(address _target, bool _freeze, uint256 _days) onlyOwner public {
527         _setFreezingPeriod(_target, _freeze, _days);
528     }
529     
530     /**
531     * Transfer tokens from other address
532     *
533     * Send `_value` tokens to `_to` in behalf of `_from`
534     *
535     * @param _from The address of the sender
536     * @param _to The address of the recipient
537     * @param _value the amount to send
538     */
539     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
540         require(_value <= allowance[_from][msg.sender]);     // Check allowance
541         //allowance[_from][msg.sender] -= _value;
542         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
543         _transfer(_from, _to, _value);
544         return true;
545     }
546 
547     /**
548     * Set allowance for other address
549     *
550     * Allows `_spender` to spend no more than `_value` tokens in your behalf
551     *
552     * @param _spender The address authorized to spend
553     * @param _value the max amount they can spend
554     */
555     function approve(address _spender, uint256 _value) public returns (bool success) {
556         // check if the sender is under a freezing period
557         if( _isTransferAllowed(msg.sender) )  {
558             _setFreezingPeriod(msg.sender, false, 0);
559         }
560         
561         allowance[msg.sender][_spender] = _value;
562         return true;
563     }
564 
565     /**
566     * Set allowance for other address and notify
567     *
568     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
569     *
570     * @param _spender The address authorized to spend
571     * @param _value the max amount they can spend
572     * @param _extraData some extra information to send to the approved contract
573     */
574     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
575         // check if the sender is under a freezing period
576         if( _isTransferAllowed(msg.sender) ) {
577             _setFreezingPeriod(msg.sender, false, 0);
578         }
579 
580         tokenRecipient spender = tokenRecipient(_spender);
581 
582         if (approve(_spender, _value)) {
583             spender.receiveApproval(msg.sender, _value, this, _extraData);
584             return true;
585         }
586     }
587 
588     /**
589     * Destroy tokens
590     *
591     * Remove `_value` tokens from the system irreversibly
592     *
593     * @param _value the amount of money to burn
594     */
595     function burn(uint256 _value) public returns (bool success) {
596         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
597         return _burn(msg.sender, _value);
598     }
599 
600     /**
601     *
602      */
603     function _burn(address _from, uint256 _value) internal returns (bool success) {
604         balanceOf[_from] = balanceOf[_from].sub(_value);            // Subtract from the sender
605         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
606         emit Burn(_from, _value);
607         return true;
608     }
609 
610     /**
611     * Destroy tokens from other account
612     *
613     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
614     *
615     * @param _from the address of the sender
616     * @param _value the amount of money to burn
617     */
618     function burnFrom(address _from, uint256 _value) public returns (bool success) {
619         require(balanceOf[_from] >= _value);                                     // Check if the targeted balance is enough
620         require(_value <= allowance[_from][msg.sender]);                         // Check allowance
621         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
622         return _burn(_from, _value);
623     }
624 
625     /**
626     * Only ballast fund function to burn tokens from account
627     *
628     * Allows `fundAccount` burn tokens to send equivalent ether for account that claimed it
629     * @param _from account address to burn tokens
630     * @param _value quantity of tokens to burn
631     */
632     function redemptionBurn(address _from, uint256 _value) onlyFund public{
633         _burn(_from, _value);
634     }   
635 }