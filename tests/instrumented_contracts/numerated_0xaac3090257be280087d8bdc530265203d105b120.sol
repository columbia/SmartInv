1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     assert(b > 0);
16     uint c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 }
48 
49 
50 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
51 ///  later changed
52 contract Owned {
53 
54     /// @dev `owner` is the only address that can call a function with this
55     /// modifier
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     address public owner;
62 
63     /// @notice The Constructor assigns the message sender to be `owner`
64     function Owned() {
65         owner = msg.sender;
66     }
67 
68     address public newOwner;
69 
70     /// @notice `owner` can step down and assign some other address to this role
71     /// @param _newOwner The address of the new owner. 0x0 can be used to create
72     ///  an unowned neutral vault, however that cannot be undone
73     function changeOwner(address _newOwner) onlyOwner {
74         newOwner = _newOwner;
75     }
76 
77 
78     function acceptOwnership() {
79         if (msg.sender == newOwner) {
80             owner = newOwner;
81         }
82     }
83 }
84 
85 
86 contract ERC20Protocol {
87     /* This is a slight change to the ERC20 base standard.
88     function totalSupply() constant returns (uint supply);
89     is replaced with:
90     uint public totalSupply;
91     This automatically creates a getter function for the totalSupply.
92     This is moved to the base contract since public getter functions are not
93     currently recognised as an implementation of the matching abstract
94     function by the compiler.
95     */
96     /// total amount of tokens
97     uint public totalSupply;
98 
99     /// @param _owner The address from which the balance will be retrieved
100     /// @return The balance
101     function balanceOf(address _owner) constant returns (uint balance);
102 
103     /// @notice send `_value` token to `_to` from `msg.sender`
104     /// @param _to The address of the recipient
105     /// @param _value The amount of token to be transferred
106     /// @return Whether the transfer was successful or not
107     function transfer(address _to, uint _value) returns (bool success);
108 
109     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
110     /// @param _from The address of the sender
111     /// @param _to The address of the recipient
112     /// @param _value The amount of token to be transferred
113     /// @return Whether the transfer was successful or not
114     function transferFrom(address _from, address _to, uint _value) returns (bool success);
115 
116     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
117     /// @param _spender The address of the account able to transfer the tokens
118     /// @param _value The amount of tokens to be approved for transfer
119     /// @return Whether the approval was successful or not
120     function approve(address _spender, uint _value) returns (bool success);
121 
122     /// @param _owner The address of the account owning tokens
123     /// @param _spender The address of the account able to transfer the tokens
124     /// @return Amount of remaining tokens allowed to spent
125     function allowance(address _owner, address _spender) constant returns (uint remaining);
126 
127     event Transfer(address indexed _from, address indexed _to, uint _value);
128     event Approval(address indexed _owner, address indexed _spender, uint _value);
129 }
130 
131 
132 contract StandardToken is ERC20Protocol {
133     using SafeMath for uint;
134 
135     /**
136     * @dev Fix for the ERC20 short address attack.
137     */
138     modifier onlyPayloadSize(uint size) {
139         require(msg.data.length >= size + 4);
140         _;
141     }
142 
143     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
144         //Default assumes totalSupply can't be over max (2^256 - 1).
145         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
146         //Replace the if with this one instead.
147         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
148         if (balances[msg.sender] >= _value) {
149             balances[msg.sender] -= _value;
150             balances[_to] += _value;
151             Transfer(msg.sender, _to, _value);
152             return true;
153         } else { return false; }
154     }
155 
156     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {
157         //same as above. Replace this line with the following if you want to protect against wrapping uints.
158         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
159         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
160             balances[_to] += _value;
161             balances[_from] -= _value;
162             allowed[_from][msg.sender] -= _value;
163             Transfer(_from, _to, _value);
164             return true;
165         } else { return false; }
166     }
167 
168     function balanceOf(address _owner) constant returns (uint balance) {
169         return balances[_owner];
170     }
171 
172     function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
173         // To change the approve amount you first have to reduce the addresses`
174         //  allowance to zero by calling `approve(_spender, 0)` if it is not
175         //  already 0 to mitigate the race condition described here:
176         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
177         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
178 
179         allowed[msg.sender][_spender] = _value;
180         Approval(msg.sender, _spender, _value);
181         return true;
182     }
183 
184     function allowance(address _owner, address _spender) constant returns (uint remaining) {
185       return allowed[_owner][_spender];
186     }
187 
188     mapping (address => uint) balances;
189     mapping (address => mapping (address => uint)) allowed;
190 }
191 
192 /// @title Wanchain Token Contract
193 /// For more information about this token sale, please visit https://wanchain.org
194 /// @author Cathy - <cathy@wanchain.org>
195 contract WanToken is StandardToken {
196     using SafeMath for uint;
197 
198     /// Constant token specific fields
199     string public constant name = "WanCoin";
200     string public constant symbol = "WAN";
201     uint public constant decimals = 18;
202 
203     /// Wanchain total tokens supply
204     uint public constant MAX_TOTAL_TOKEN_AMOUNT = 210000000 ether;
205 
206     /// Fields that are only changed in constructor
207     /// Wanchain contribution contract
208     address public minter; 
209     /// ICO start time
210     uint public startTime;
211     /// ICO end time
212     uint public endTime;
213 
214     /// Fields that can be changed by functions
215     mapping (address => uint) public lockedBalances;
216     /*
217      * MODIFIERS
218      */
219 
220     modifier onlyMinter {
221         assert(msg.sender == minter);
222         _;
223     }
224 
225     modifier isLaterThan (uint x){
226         assert(now > x);
227         _;
228     }
229 
230     modifier maxWanTokenAmountNotReached (uint amount){
231         assert(totalSupply.add(amount) <= MAX_TOTAL_TOKEN_AMOUNT);
232         _;
233     }
234 
235     /**
236      * CONSTRUCTOR 
237      * 
238      * @dev Initialize the Wanchain Token
239      * @param _minter The Wanchain Contribution Contract     
240      * @param _startTime ICO start time
241      * @param _endTime ICO End Time
242      */
243     function WanToken(address _minter, uint _startTime, uint _endTime){
244         minter = _minter;
245         startTime = _startTime;
246         endTime = _endTime;
247     }
248 
249     /**
250      * EXTERNAL FUNCTION 
251      * 
252      * @dev Contribution contract instance mint token
253      * @param receipent The destination account owned mint tokens    
254      * @param amount The amount of mint token
255      * be sent to this address.
256      */    
257     function mintToken(address receipent, uint amount)
258         external
259         onlyMinter
260         maxWanTokenAmountNotReached(amount)
261         returns (bool)
262     {
263         require(now <= endTime);
264         lockedBalances[receipent] = lockedBalances[receipent].add(amount);
265         totalSupply = totalSupply.add(amount);
266         return true;
267     }
268 
269     /*
270      * PUBLIC FUNCTIONS
271      */
272 
273     /// @dev Locking period has passed - Locked tokens have turned into tradeable
274     ///      All tokens owned by receipent will be tradeable
275     function claimTokens(address receipent)
276         public
277         onlyMinter
278     {
279         balances[receipent] = balances[receipent].add(lockedBalances[receipent]);
280         lockedBalances[receipent] = 0;
281     }
282 
283     /*
284      * CONSTANT METHODS
285      */
286     function lockedBalanceOf(address _owner) constant returns (uint balance) {
287         return lockedBalances[_owner];
288     }
289 }
290 
291 /// @title Wanchain Contribution Contract
292 /// ICO Rules according: https://www.wanchain.org/crowdsale
293 /// For more information about this token sale, please visit https://wanchain.org
294 /// @author Zane Liang - <zaneliang@wanchain.org>
295 contract WanchainContribution is Owned {
296     using SafeMath for uint;
297 
298     /// Constant fields
299     /// Wanchain total tokens supply
300     uint public constant WAN_TOTAL_SUPPLY = 210000000 ether;
301     uint public constant EARLY_CONTRIBUTION_DURATION = 24 hours;
302     uint public constant MAX_CONTRIBUTION_DURATION = 3 weeks;
303 
304     /// Exchange rates for first phase
305     uint public constant PRICE_RATE_FIRST = 880;
306     /// Exchange rates for second phase
307     uint public constant PRICE_RATE_SECOND = 790;
308     /// Exchange rates for last phase
309     uint public constant PRICE_RATE_LAST = 750;
310 
311     /// ----------------------------------------------------------------------------------------------------
312     /// |                                                  |                    |                 |        |
313     /// |        PUBLIC SALE (PRESALE + OPEN SALE)         |      DEV TEAM      |    FOUNDATION   |  MINER |
314     /// |                       51%                        |         20%        |       19%       |   10%  |    
315     /// ----------------------------------------------------------------------------------------------------
316       /// OPEN_SALE_STAKE + PRESALE_STAKE = 51; 51% sale for public
317     uint public constant OPEN_SALE_STAKE = 510;  // 51% for open sale
318 
319     // Reserved stakes
320     uint public constant DEV_TEAM_STAKE = 200;   // 20%
321     uint public constant FOUNDATION_STAKE = 190; // 19%
322     uint public constant MINERS_STAKE = 100;     // 10%
323 
324     uint public constant DIVISOR_STAKE = 1000;
325 
326     uint public constant PRESALE_RESERVERED_AMOUNT = 41506655 ether; //presale prize amount(40000*880)
327   
328     /// Holder address for presale and reserved tokens
329     /// TODO: change addressed before deployed to main net
330 
331     // Addresses of Patrons
332     address public constant DEV_TEAM_HOLDER = 0x0001cdC69b1eb8bCCE29311C01092Bdcc92f8f8F;
333     address public constant FOUNDATION_HOLDER = 0x00dB4023b32008C45E62Add57De256a9399752D4;
334     address public constant MINERS_HOLDER = 0x00f870D11eA43AA1c4C715c61dC045E32d232787;
335     address public constant PRESALE_HOLDER = 0x00577c25A81fA2401C5246F4a7D5ebaFfA4b00Aa;
336   
337     uint public MAX_OPEN_SOLD = WAN_TOTAL_SUPPLY * OPEN_SALE_STAKE / DIVISOR_STAKE - PRESALE_RESERVERED_AMOUNT;
338 
339     /// Fields that are only changed in constructor    
340     /// All deposited ETH will be instantly forwarded to this address.
341     address public wanport;
342     /// Early Adopters reserved start time
343     uint public earlyReserveBeginTime;
344     /// Contribution start time
345     uint public startTime;
346     /// Contribution end time
347     uint public endTime;
348 
349     /// Fields that can be changed by functions
350     /// Accumulator for open sold tokens
351     uint public openSoldTokens;
352     /// Due to an emergency, set this to true to halt the contribution
353     bool public halted; 
354     /// ERC20 compilant wanchain token contact instance
355     WanToken public wanToken; 
356 
357     /// Quota for early adopters sale, Quota
358     mapping (address => uint256) public earlyUserQuotas;
359     /// tags show address can join in open sale
360     mapping (address => uint256) public fullWhiteList;
361 
362     uint256 public normalBuyLimit = 65 ether;
363 
364     /*
365      * EVENTS
366      */
367 
368     event NewSale(address indexed destAddress, uint ethCost, uint gotTokens);
369     //event PartnerAddressQuota(address indexed partnerAddress, uint quota);
370 
371     /*
372      * MODIFIERS
373      */
374 
375     modifier onlyWallet {
376         require(msg.sender == wanport);
377         _;
378     }
379 
380     modifier notHalted() {
381         require(!halted);
382         _;
383     }
384 
385     modifier initialized() {
386         require(address(wanport) != 0x0);
387         _;
388     }    
389 
390     modifier notEarlierThan(uint x) {
391         require(now >= x);
392         _;
393     }
394 
395     modifier earlierThan(uint x) {
396         require(now < x);
397         _;
398     }
399 
400     modifier ceilingNotReached() {
401         require(openSoldTokens < MAX_OPEN_SOLD);
402         _;
403     }  
404 
405     modifier isSaleEnded() {
406         require(now > endTime || openSoldTokens >= MAX_OPEN_SOLD);
407         _;
408     }
409 
410 
411     /**
412      * CONSTRUCTOR 
413      * 
414      * @dev Initialize the Wanchain contribution contract
415      * @param _wanport The escrow account address, all ethers will be sent to this address.
416      * @param _bootTime ICO boot time
417      */
418     function WanchainContribution(address _wanport, uint _bootTime){
419       require(_wanport != 0x0);
420 
421         halted = false;
422       wanport = _wanport;
423         earlyReserveBeginTime = _bootTime;
424       startTime = earlyReserveBeginTime + EARLY_CONTRIBUTION_DURATION;
425       endTime = startTime + MAX_CONTRIBUTION_DURATION;
426         openSoldTokens = 0;
427         /// Create wanchain token contract instance
428       wanToken = new WanToken(this,startTime, endTime);
429 
430         /// Reserve tokens according wanchain ICO rules
431       uint stakeMultiplier = WAN_TOTAL_SUPPLY / DIVISOR_STAKE;
432     
433         wanToken.mintToken(DEV_TEAM_HOLDER, DEV_TEAM_STAKE * stakeMultiplier);
434         wanToken.mintToken(FOUNDATION_HOLDER, FOUNDATION_STAKE * stakeMultiplier);
435         wanToken.mintToken(MINERS_HOLDER, MINERS_STAKE * stakeMultiplier);
436     
437         wanToken.mintToken(PRESALE_HOLDER, PRESALE_RESERVERED_AMOUNT);    
438     
439     }
440 
441     /**
442      * Fallback function 
443      * 
444      * @dev If anybody sends Ether directly to this  contract, consider he is getting wan token
445      */
446     function () public payable {
447       buyWanCoin(msg.sender);
448     }
449 
450     /*
451      * PUBLIC FUNCTIONS
452      */
453 
454     /// @dev Exchange msg.value ether to WAN for account recepient
455     /// @param receipient WAN tokens receiver
456     function buyWanCoin(address receipient) 
457         public 
458         payable 
459         notHalted 
460         initialized 
461         ceilingNotReached 
462         notEarlierThan(earlyReserveBeginTime)
463         earlierThan(endTime)
464         returns (bool) 
465     {
466         require(receipient != 0x0);
467         require(msg.value >= 0.1 ether);
468 
469         // Do not allow contracts to game the system
470         require(!isContract(msg.sender));        
471 
472         if( now < startTime && now >= earlyReserveBeginTime)
473             buyEarlyAdopters(receipient);
474         else {
475             require( tx.gasprice <= 50000000000 wei );
476             require(msg.value <= normalBuyLimit);
477             buyNormal(receipient);
478         }
479 
480         return true;
481     }
482 
483     function setNormalBuyLimit(uint256 limit)
484         public
485         initialized
486         onlyOwner
487         earlierThan(endTime)
488     {
489         normalBuyLimit = limit;
490     }
491 
492 
493     /// @dev batch set quota for early user quota
494     function setEarlyWhitelistQuotas(address[] users, uint earlyCap, uint openTag)
495         public
496         onlyOwner
497         earlierThan(earlyReserveBeginTime)
498     {
499         for( uint i = 0; i < users.length; i++) {
500             earlyUserQuotas[users[i]] = earlyCap;
501             fullWhiteList[users[i]] = openTag;
502         }
503     }
504 
505     /// @dev batch set quota for early user quota
506     function setLaterWhiteList(address[] users, uint openTag)
507         public
508         onlyOwner
509         earlierThan(endTime)
510     {
511         require(saleNotEnd());
512         for( uint i = 0; i < users.length; i++) {
513             fullWhiteList[users[i]] = openTag;
514         }
515     }
516 
517     /// @dev Emergency situation that requires contribution period to stop.
518     /// Contributing not possible anymore.
519     function halt() public onlyWallet{
520         halted = true;
521     }
522 
523     /// @dev Emergency situation resolved.
524     /// Contributing becomes possible again withing the outlined restrictions.
525     function unHalt() public onlyWallet{
526         halted = false;
527     }
528 
529     /// @dev Emergency situation
530     function changeWalletAddress(address newAddress) onlyWallet { 
531         wanport = newAddress; 
532     }
533 
534     /// @return true if sale not ended, false otherwise.
535     function saleNotEnd() constant returns (bool) {
536         return now < endTime && openSoldTokens < MAX_OPEN_SOLD;
537     }
538 
539     /// CONSTANT METHODS
540     /// @dev Get current exchange rate
541     function priceRate() public constant returns (uint) {
542         // Three price tiers
543         if (earlyReserveBeginTime <= now && now < startTime + 1 weeks)
544             return PRICE_RATE_FIRST;
545         if (startTime + 1 weeks <= now && now < startTime + 2 weeks)
546             return PRICE_RATE_SECOND;
547         if (startTime + 2 weeks <= now && now < endTime)
548             return PRICE_RATE_LAST;
549         // Should not be called before or after contribution period
550         assert(false);
551     }
552 
553     function claimTokens(address receipent)
554         public
555         isSaleEnded
556     {
557         wanToken.claimTokens(receipent);
558     }
559 
560     /*
561      * INTERNAL FUNCTIONS
562      */
563 
564     /// @dev Buy wanchain tokens for early adopters
565     function buyEarlyAdopters(address receipient) internal {
566       uint quotaAvailable = earlyUserQuotas[receipient];
567       require(quotaAvailable > 0);
568 
569         uint toFund = quotaAvailable.min256(msg.value);
570         uint tokenAvailable4Adopter = toFund.mul(PRICE_RATE_FIRST);
571 
572       earlyUserQuotas[receipient] = earlyUserQuotas[receipient].sub(toFund);
573       buyCommon(receipient, toFund, tokenAvailable4Adopter);
574     }
575 
576     /// @dev Buy wanchain token normally
577     function buyNormal(address receipient) internal {
578         uint inWhiteListTag = fullWhiteList[receipient];
579         require(inWhiteListTag > 0);
580 
581         // protect partner quota in stage one
582         uint tokenAvailable = MAX_OPEN_SOLD.sub(openSoldTokens);
583         require(tokenAvailable > 0);
584 
585       uint toFund;
586       uint toCollect;
587       (toFund, toCollect) = costAndBuyTokens(tokenAvailable);
588         buyCommon(receipient, toFund, toCollect);
589     }
590 
591     /// @dev Utility function for bug wanchain token
592     function buyCommon(address receipient, uint toFund, uint wanTokenCollect) internal {
593         require(msg.value >= toFund); // double check
594 
595         if(toFund > 0) {
596             require(wanToken.mintToken(receipient, wanTokenCollect));         
597             wanport.transfer(toFund);
598             openSoldTokens = openSoldTokens.add(wanTokenCollect);
599             NewSale(receipient, toFund, wanTokenCollect);            
600         }
601 
602         uint toReturn = msg.value.sub(toFund);
603         if(toReturn > 0) {
604             msg.sender.transfer(toReturn);
605         }
606     }
607 
608     /// @dev Utility function for calculate available tokens and cost ethers
609     function costAndBuyTokens(uint availableToken) constant internal returns (uint costValue, uint getTokens){
610       // all conditions has checked in the caller functions
611       uint exchangeRate = priceRate();
612       getTokens = exchangeRate * msg.value;
613 
614       if(availableToken >= getTokens){
615         costValue = msg.value;
616       } else {
617         costValue = availableToken / exchangeRate;
618         getTokens = availableToken;
619       }
620     }
621 
622     /// @dev Internal function to determine if an address is a contract
623     /// @param _addr The address being queried
624     /// @return True if `_addr` is a contract
625     function isContract(address _addr) constant internal returns(bool) {
626         uint size;
627         if (_addr == 0) return false;
628         assembly {
629             size := extcodesize(_addr)
630         }
631         return size > 0;
632     }
633 }