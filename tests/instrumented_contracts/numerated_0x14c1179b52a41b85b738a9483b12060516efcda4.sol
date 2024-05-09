1 pragma solidity ^0.4.18;
2 
3 
4 /**
5 * @title SafeMath
6 * @dev Math operations with safety checks that throw on error
7 */
8 library SafeMath {
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62     * account.
63     */
64     function Ownable() public {
65         owner = msg.sender;
66     }
67 
68     /**
69     * @dev Throws if called by any account other than the owner.
70     */
71     modifier onlyOwner() {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     /**
77     * @dev Allows the current owner to transfer control of the contract to a newOwner.
78     * @param newOwner The address to transfer ownership to.
79     */
80     function transferOwnership(address newOwner) public onlyOwner {
81         require(newOwner != address(0));
82         
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
128     *
129     * Send `_value` tokens to `_to` from `_from`
130     *
131     * @param _from Address of the sender
132     * @param _to Address of the recipient
133     * @param _value the amount to send
134     */
135     function _transfer(address _from, address _to, uint _value) internal {
136         // Prevent transfer to 0x0 address. Use burn() instead
137         require(_to != 0x0);
138         // Check if the sender has enough
139         require(balanceOf[_from] >= _value);
140 
141         // Check for overflows
142         require(balanceOf[_to].add(_value) > balanceOf[_to]);
143 
144         // Save this for an assertion in the future
145         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
146 
147         // Subtract from the sender
148         balanceOf[_from] = balanceOf[_from].sub(_value);
149 
150         // Add the same to the recipient
151         balanceOf[_to] = balanceOf[_to].add(_value);
152 
153         emit Transfer(_from, _to, _value);
154         // Asserts are used to use static analysis to find bugs in your code. They should never fail
155         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
156     }
157 
158     /**
159     * Transfer tokens
160     *
161     * Send `_value` tokens to `_to` from your account
162     *
163     * @param _to The address of the recipient
164     * @param _value the amount to send
165     */
166     function transfer(address _to, uint256 _value) public {
167         _transfer(msg.sender, _to, _value);
168     }
169 
170     /**
171     * Transfer tokens from other address
172     *
173     * Send `_value` tokens to `_to` in behalf of `_from`
174     *
175     * @param _from The address of the sender
176     * @param _to The address of the recipient
177     * @param _value the amount to send
178     */
179     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
180         require(_value <= allowance[_from][msg.sender]);     // Check allowance
181         //allowance[_from][msg.sender] -= _value;
182         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
183         _transfer(_from, _to, _value);
184         return true;
185     }
186 
187     /**
188     * Set allowance for other address
189     *
190     * Allows `_spender` to spend no more than `_value` tokens in your behalf
191     *
192     * @param _spender The address authorized to spend
193     * @param _value the max amount they can spend
194     */
195     function approve(address _spender, uint256 _value) public
196         returns (bool success) {
197         allowance[msg.sender][_spender] = _value;
198         return true;
199     }
200 
201     /**
202     * Set allowance for other address and notify
203     *
204     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
205     *
206     * @param _spender The address authorized to spend
207     * @param _value the max amount they can spend
208     * @param _extraData some extra information to send to the approved contract
209     */
210     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
211         tokenRecipient spender = tokenRecipient(_spender);
212         if (approve(_spender, _value)) {
213             spender.receiveApproval(msg.sender, _value, this, _extraData);
214             return true;
215         }	
216     }
217 
218     /**
219      * Destroy tokens
220      *
221      * Remove `_value` tokens from the system irreversibly
222      *
223      * @param _value the amount of money to burn
224      */
225     function burn(uint256 _value) public returns (bool success) {
226         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
227         balanceOf[msg.sender] -= _value;            // Subtract from the sender
228         totalSupply -= _value;                      // Updates totalSupply
229         emit Burn(msg.sender, _value);
230         return true;
231     }
232 
233     /**
234      * Destroy tokens from other account
235      *
236      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
237      *
238      * @param _from the address of the sender
239      * @param _value the amount of money to burn
240      */
241     function burnFrom(address _from, uint256 _value) public returns (bool success) {
242         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
243         require(_value <= allowance[_from][msg.sender]);    // Check allowance
244         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
245         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
246         totalSupply -= _value;                              // Update totalSupply
247         emit Burn(_from, _value);
248         return true;
249     }
250 }
251 
252 /******************************************/
253 /*       ADVANCED TOKEN STARTS HERE       */
254 /******************************************/
255 contract ICONIC_NIC is Ownable, TokenERC20 {
256     using SafeMath for uint256;
257 
258     mapping (address => bool)    public  frozenAccount;
259     mapping (address => uint256) public freezingPeriod; // how many days the account must remain frozen?
260 
261     mapping (address => bool) public exchangesAccounts;
262 
263     address public bountyManagerAddress; //bounty manager address
264     address public bountyManagerDistributionContract = 0x0; // bounty distributor smart contract address
265 
266     address public fundAccount; 	// ballast fund address
267     bool public isSetFund = false;	// if ballast fund is set
268 
269     uint256 public creationDate;
270 
271     uint256 public constant frozenDaysForAdvisor       = 186;  
272     uint256 public constant frozenDaysForBounty        = 186;
273     uint256 public constant frozenDaysForEarlyInvestor = 51;
274     uint256 public constant frozenDaysForICO           = 65;   
275     uint256 public constant frozenDaysForPartner       = 369;
276     uint256 public constant frozenDaysForPreICO        = 51;
277 
278     /**
279     * allowed for a bounty manager account only
280     */
281     modifier onlyBountyManager(){
282         require((msg.sender == bountyManagerDistributionContract) || (msg.sender == bountyManagerAddress));
283         _;
284     }
285 
286     /**
287     * allowed for a fund account only
288     */
289     modifier onlyFund(){
290         require(msg.sender == fundAccount);
291         _;
292     }
293 
294     /* This generates a public event on the blockchain that will notify clients */
295     event FrozenFunds(address target, bool frozen);
296 
297     /**
298     * Initializes contract with initial supply tokens to the creator of the contract
299     */
300     function ICONIC_NIC(
301         uint256 initialSupply,
302         string tokenName,
303         string tokenSymbol
304     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public 
305     {
306         /* solium-disable-next-line */
307         creationDate = now;
308 
309         // PARTNERS DISTRIBUTION
310         _initializeAccount(0x85abeD924205bbE4D32077E596e45B9F40AAF8d9, frozenDaysForPartner, 2115007);
311         _initializeAccount(0xf7817F08C2660970014a086a4Ba679636e73E8ef, frozenDaysForPartner, 8745473);
312         _initializeAccount(0x2c208677f8BAB9c6A44bBe3554f36d2440C9b6C2, frozenDaysForPartner, 3498189);
313         _initializeAccount(0x3689B9a43ab904D70f396B2A27DDac0E5885CF68, frozenDaysForPartner, 26236419);
314         _initializeAccount(0x245B058C8c256D011742aF5Faa296198735eE0Ee, frozenDaysForPartner, 211501);
315         _initializeAccount(0xeEFA9f8f39aaF1d1Ed160Ac2465e937A8F154182, frozenDaysForPartner, 1749095);
316 
317         // EARLY INVESTOR DISTRIBUTION
318         _initializeAccount(0x4718bB26bCE82459913aaCA09a006Daa517F1c0E, frozenDaysForEarlyInvestor, 225000);
319         _initializeAccount(0x8cC1d930e685c977EFcEf9dc412D3ADbE11B84c1, frozenDaysForEarlyInvestor, 2678100);
320 
321         // ADVISOR DISTRIBUTION
322         _initializeAccount(0x272c41b76Bad949739839E6BB5Eb9f2B0CDFD95D, frozenDaysForAdvisor, 1057503);
323         _initializeAccount(0x3a5cd9E7ccFE4DD5484335F3AF30CCAba95D07C3, frozenDaysForAdvisor, 528752);
324         _initializeAccount(0xA10CC5321E834c41137f2150A9b0f2Aa1c5016, frozenDaysForAdvisor, 1057503);
325         _initializeAccount(0x59B640c5663E5e79Ce9F68EBbC28454490DbA7B8, frozenDaysForAdvisor, 1057503);
326         _initializeAccount(0xdCA69FbfEFf48851ceC91B57610FA60ABc27Af3B, frozenDaysForAdvisor, 3172510);
327         _initializeAccount(0x332526F0082d4d385F9Ef393841f44c1bf813D8c, frozenDaysForAdvisor, 3172510);
328         _initializeAccount(0xf6B436cBB177777A170819128EbBeF0715101eA2, frozenDaysForAdvisor, 1275000);
329         _initializeAccount(0xB76a63Fa7658aD0480986e609b9d5b1f1b6B53b9, frozenDaysForAdvisor, 1487500);
330         _initializeAccount(0x2bC240bc0D28725dF790706da7663413ac8Fa5ee, frozenDaysForAdvisor, 2125000);
331         _initializeAccount(0x32Aa02961fa15e74D896C45A428E5d1884af2217, frozenDaysForAdvisor, 1057503);
332         _initializeAccount(0x5340EC716a00Db16a9C289369e4b30ae897C25d3, frozenDaysForAdvisor, 1586255);
333         _initializeAccount(0x39d6FDB4B0f8dfE39EC0b4fE5Dd9B2f66e30f8D1, frozenDaysForAdvisor, 846003);
334         _initializeAccount(0xCe438C52D95ee47634f9AeE36de5488D0d5D0FBd, frozenDaysForAdvisor, 250000);
335 
336         // BOUNTY DISTRIBUTION
337         bountyManagerAddress = 0xA9939938e6BAcC0b748045be80FD9E958898eB79;
338         _initializeAccount(bountyManagerAddress, frozenDaysForBounty, 15000000);
339     }
340 
341     /**
342     * Only owner function to set ballast fund account address
343     * 
344     * @dev it can be set only once
345     * @param _address smart contract address of ballast fund
346     */
347     function setFundAccount(address _address) onlyOwner public{
348         require (_address != 0x0);
349         require (!isSetFund);
350         fundAccount = _address;
351         isSetFund = true;    
352     }
353 
354     /**
355     * Only owner function to add Exchange Accounts
356     *
357     * @param _address Exchange address
358     */
359     function addExchangeTestAccounts(address _address) onlyOwner public{
360         require(_address != 0x0);
361         exchangesAccounts[_address] = true;
362     }
363 
364     /**
365     * Only owner function to remove Exchange Accounts
366     *
367     * @param _address Exchange address
368     */
369     function removeExchangeTestAccounts(address _address) onlyOwner public{
370         delete exchangesAccounts[_address];
371     }
372 
373     /**
374     * Initialize accounts when token deploy occurs
375     *
376     * initialize `_address` account, with balance equal `_value` and frozen for `_frozenDays`
377     *
378     * @param _address wallet address to initialize
379     * @param _frozenDays quantity of days to freeze account
380     * @param _value quantity of tokens to send to account
381     */
382     function _initializeAccount(address _address, uint _frozenDays, uint _value) internal{
383         _transfer(msg.sender, _address, _value * 10 ** uint256(decimals));
384         freezingPeriod[_address] = _frozenDays;
385         _freezeAccount(_address, true);
386     }
387 
388     /**
389     * Check if account freezing period expired
390     *
391     * `now` has to be greater or equal than `creationDate` + `freezingPeriod[_address]` * `1 day`
392     *
393     * @param _address account address to check if allowed to transfer tokens
394     * @return bool true if is allowed to transfer and false if not
395     */
396     function _isTransferAllowed( address _address ) view public returns (bool)
397     {
398         /* solium-disable-next-line */
399         if( now >= creationDate + freezingPeriod[_address] * 1 days ){
400             return ( true );
401         } else {
402             return ( false );
403         }
404     }
405 
406     /**
407     * Internal function to transfer tokens
408     *
409     * @param _from account to withdraw tokens
410     * @param _to account to receive tokens
411     * @param _value quantity of tokens to transfer
412     */
413     function _transfer(address _from, address _to, uint _value) internal {
414         require (_to != 0x0);                                  // Prevent transfer to 0x0 address. Use burn() instead
415         require (balanceOf[_from] >= _value);                  // Check if the sender has enough
416         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
417 
418         // check if the sender is under a freezing period
419         if(_isTransferAllowed(_from)){ 
420             _setFreezingPeriod(_from, false, 0);
421         }
422 
423         // check if the recipient is under a freezing period
424         if(_isTransferAllowed(_to)){
425             _setFreezingPeriod(_to, false, 0);
426         }
427 
428         require(!frozenAccount[_from]);     // Check if sender is frozen
429         require(!frozenAccount[_to]);       // Check if recipient is frozen                
430         
431         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
432         balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
433 
434         emit Transfer(_from, _to, _value);
435     }
436     
437     /**
438     * Internal function to deliver tokens for bounty, pre-ICO or ICO with determined freezing periods
439     *
440     * @param _from account address to withdraw tokens
441     * @param _to account address to send tokens
442     * @param _value quantity of tokes to send
443     * @param _frozenDays quantity of days to freeze account
444     */
445     function _tokenDelivery(address _from, address _to, uint _value, uint _frozenDays) internal {
446         freezingPeriod[_to] = 0;
447         _freezeAccount(_to, false);
448         _transfer(_from, _to, _value);
449         freezingPeriod[_to] = _frozenDays;
450         _freezeAccount(_to, true); 
451     }
452     
453     /**
454     * Only owner function to deliver tokens for pre-ICO investors
455     *
456     * @param _to account address who will receive the tokens
457     * @param _value quantity of tokens to deliver
458     */
459     function preICOTokenDelivery(address _to, uint _value) onlyOwner public {
460         _tokenDelivery(msg.sender, _to, _value, frozenDaysForPreICO);
461     }
462     
463     /**
464     * Only owner function to deliver tokens for ICO investors
465     *
466     * @param _to account address who will receive tokens
467     * @param _value quantity of tokens to deliver
468     */
469     function ICOTokenDelivery(address _to, uint _value) onlyOwner public {
470         _tokenDelivery(msg.sender, _to, _value, frozenDaysForICO);
471     }
472     
473     function setBountyDistributionContract(address _contractAddress) onlyOwner public {
474         bountyManagerDistributionContract = _contractAddress;
475     }
476 
477     /**
478     * Only bounty manager distribution contract function to deliver tokens for bounty community
479     *
480     * @param _to account addres who will receive tokens
481     * @param _value quantity of tokens to deliver
482     */
483     function bountyTransfer(address _to, uint _value) onlyBountyManager public {
484         _freezeAccount(bountyManagerAddress, false);
485         _tokenDelivery(bountyManagerAddress, _to, _value, frozenDaysForBounty);
486         _freezeAccount(bountyManagerAddress, true);
487     }
488 
489     /**
490     * Function to get days to unfreeze some account
491     *
492     * @param _address account address to get days
493     * @return result quantity of days to unfreeze `address`
494     */
495     function daysToUnfreeze(address _address) public view returns (uint256) {
496         require(_address != 0x0);
497 
498         /* solium-disable-next-line */
499         uint256 _now = now;
500         uint256 result = 0;
501 
502         if( _now <= creationDate + freezingPeriod[_address] * 1 days ) {
503             // still under the freezing period.
504             uint256 finalPeriod = (creationDate + freezingPeriod[_address] * 1 days) / 1 days;
505             uint256 currePeriod = _now / 1 days;
506             result = finalPeriod - currePeriod;
507         }
508         
509         return result;
510     }
511 
512     /**
513     * @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
514     * @param target Address to be frozen
515     * @param freeze either to freeze it or not
516     */
517     function _freezeAccount(address target, bool freeze) internal {
518         frozenAccount[target] = freeze;
519         emit FrozenFunds(target, freeze);
520     }
521 
522     /**
523     * Only owner function to call `_freezeAccount` directly
524     *
525     * @param target account address to freeze
526     * @param freeze true to freeze account and false to unfreeze
527     */
528     function freezeAccount(address target, bool freeze) onlyOwner public {
529         _freezeAccount(target, freeze);
530     }
531     
532     /**
533     * Internal call to set freezing period for some account
534     *
535     * @param _target account address to freeze
536     * @param _freeze true to freeze account and false to unfreeze
537     * @param _days period to keep account frozen
538     */
539     function _setFreezingPeriod(address _target, bool _freeze, uint256 _days) internal {
540         _freezeAccount(_target, _freeze);
541         freezingPeriod[_target] = _days;
542     }
543     
544     /**
545     * Only owner function to call `_setFreezingPeriod` directly
546     *
547     * @param _target account address to freeze
548     * @param _freeze true to freeze account and false to unfreeze
549     * @param _days period to keep account frozen
550     */
551     function setFreezingPeriod(address _target, bool _freeze, uint256 _days) onlyOwner public {
552         _setFreezingPeriod(_target, _freeze, _days);
553     }
554     
555     /**
556     * Transfer tokens from other address
557     *
558     * Send `_value` tokens to `_to` in behalf of `_from`
559     *
560     * @param _from The address of the sender
561     * @param _to The address of the recipient
562     * @param _value the amount to send
563     */
564     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
565         require(_value <= allowance[_from][msg.sender]);     // Check allowance
566         //allowance[_from][msg.sender] -= _value;
567         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
568         _transfer(_from, _to, _value);
569         return true;
570     }
571 
572     /**
573     * Set allowance for other address
574     *
575     * Allows `_spender` to spend no more than `_value` tokens in your behalf
576     *
577     * @param _spender The address authorized to spend
578     * @param _value the max amount they can spend
579     */
580     function approve(address _spender, uint256 _value) public returns (bool success) {
581         // check if the sender is under a freezing period
582         if( _isTransferAllowed(msg.sender) )  {
583             _setFreezingPeriod(msg.sender, false, 0);
584         }
585         
586         allowance[msg.sender][_spender] = _value;
587         return true;
588     }
589 
590     /**
591     * Set allowance for other address and notify
592     *
593     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
594     *
595     * @param _spender The address authorized to spend
596     * @param _value the max amount they can spend
597     * @param _extraData some extra information to send to the approved contract
598     */
599     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
600         // check if the sender is under a freezing period
601         if( _isTransferAllowed(msg.sender) ) {
602             _setFreezingPeriod(msg.sender, false, 0);
603         }
604 
605         tokenRecipient spender = tokenRecipient(_spender);
606 
607         if (approve(_spender, _value)) {
608             spender.receiveApproval(msg.sender, _value, this, _extraData);
609             return true;
610         }
611     }
612 
613     /**
614     * Destroy tokens
615     *
616     * Remove `_value` tokens from the system irreversibly
617     *
618     * @param _value the amount of money to burn
619     */
620     function burn(uint256 _value) public returns (bool success) {
621         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
622         return _burn(msg.sender, _value);
623     }
624 
625     /**
626     * Internal call to burn tokens
627     * 
628     * @param _from the address to burn tokens
629     * @param _value the amount of tokens to burn
630     */
631     function _burn(address _from, uint256 _value) internal returns (bool success) {
632         balanceOf[_from] = balanceOf[_from].sub(_value);            // Subtract from the sender
633         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
634         emit Burn(_from, _value);
635         return true;
636     }
637 
638     /**
639     * Destroy tokens from other account
640     *
641     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
642     *
643     * @param _from the address of to withdraw tokens
644     * @param _value the amount of tokens to burn
645     */
646     function burnFrom(address _from, uint256 _value) public returns (bool success) {
647         require(balanceOf[_from] >= _value);                                     // Check if the targeted balance is enough
648         require(_value <= allowance[_from][msg.sender]);                         // Check allowance
649         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value); // Subtract from the sender's allowance
650         return _burn(_from, _value);
651     }
652 
653     /**
654     * Only ballast fund function to burn tokens from account
655     *
656     * Allows `fundAccount` burn tokens to send equivalent ether for account that claimed it
657     * @param _from account address to burn tokens
658     * @param _value quantity of tokens to burn
659     */
660     function redemptionBurn(address _from, uint256 _value) onlyFund public{
661         _burn(_from, _value);
662     }   
663 }