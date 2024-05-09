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
50 pragma solidity ^0.4.11;
51 
52 
53 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
54 ///  later changed
55 contract Owned {
56 
57     /// @dev `owner` is the only address that can call a function with this
58     /// modifier
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     address public owner;
65 
66     /// @notice The Constructor assigns the message sender to be `owner`
67     function Owned() {
68         owner = msg.sender;
69     }
70 
71     address public newOwner;
72 
73     /// @notice `owner` can step down and assign some other address to this role
74     /// @param _newOwner The address of the new owner. 0x0 can be used to create
75     ///  an unowned neutral vault, however that cannot be undone
76     function changeOwner(address _newOwner) onlyOwner {
77         newOwner = _newOwner;
78     }
79 
80 
81     function acceptOwnership() {
82         if (msg.sender == newOwner) {
83             owner = newOwner;
84         }
85     }
86 }
87 
88 // Abstract contract for the full ERC 20 Token standard
89 // https://github.com/ethereum/EIPs/issues/20
90 pragma solidity ^0.4.11;
91 
92 contract ERC20Protocol {
93     /* This is a slight change to the ERC20 base standard.
94     function totalSupply() constant returns (uint supply);
95     is replaced with:
96     uint public totalSupply;
97     This automatically creates a getter function for the totalSupply.
98     This is moved to the base contract since public getter functions are not
99     currently recognised as an implementation of the matching abstract
100     function by the compiler.
101     */
102     /// total amount of tokens
103     uint public totalSupply;
104 
105     /// @param _owner The address from which the balance will be retrieved
106     /// @return The balance
107     function balanceOf(address _owner) constant returns (uint balance);
108 
109     /// @notice send `_value` token to `_to` from `msg.sender`
110     /// @param _to The address of the recipient
111     /// @param _value The amount of token to be transferred
112     /// @return Whether the transfer was successful or not
113     function transfer(address _to, uint _value) returns (bool success);
114 
115     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
116     /// @param _from The address of the sender
117     /// @param _to The address of the recipient
118     /// @param _value The amount of token to be transferred
119     /// @return Whether the transfer was successful or not
120     function transferFrom(address _from, address _to, uint _value) returns (bool success);
121 
122     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
123     /// @param _spender The address of the account able to transfer the tokens
124     /// @param _value The amount of tokens to be approved for transfer
125     /// @return Whether the approval was successful or not
126     function approve(address _spender, uint _value) returns (bool success);
127 
128     /// @param _owner The address of the account owning tokens
129     /// @param _spender The address of the account able to transfer the tokens
130     /// @return Amount of remaining tokens allowed to spent
131     function allowance(address _owner, address _spender) constant returns (uint remaining);
132 
133     event Transfer(address indexed _from, address indexed _to, uint _value);
134     event Approval(address indexed _owner, address indexed _spender, uint _value);
135 }
136 
137 
138 pragma solidity ^0.4.11;
139 
140 //import "./ERC20Protocol.sol";
141 //import "./SafeMath.sol";
142 
143 contract StandardToken is ERC20Protocol {
144     using SafeMath for uint;
145 
146     /**
147     * @dev Fix for the ERC20 short address attack.
148     */
149     modifier onlyPayloadSize(uint size) {
150         require(msg.data.length >= size + 4);
151         _;
152     }
153 
154     function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
155         //Default assumes totalSupply can't be over max (2^256 - 1).
156         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
157         //Replace the if with this one instead.
158         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
159         if (balances[msg.sender] >= _value) {
160             balances[msg.sender] -= _value;
161             balances[_to] += _value;
162             Transfer(msg.sender, _to, _value);
163             return true;
164         } else { return false; }
165     }
166 
167     function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {
168         //same as above. Replace this line with the following if you want to protect against wrapping uints.
169         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
170         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
171             balances[_to] += _value;
172             balances[_from] -= _value;
173             allowed[_from][msg.sender] -= _value;
174             Transfer(_from, _to, _value);
175             return true;
176         } else { return false; }
177     }
178 
179     function balanceOf(address _owner) constant returns (uint balance) {
180         return balances[_owner];
181     }
182 
183     function approve(address _spender, uint _value) onlyPayloadSize(2 * 32) returns (bool success) {
184         // To change the approve amount you first have to reduce the addresses`
185         //  allowance to zero by calling `approve(_spender, 0)` if it is not
186         //  already 0 to mitigate the race condition described here:
187         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
188         assert((_value == 0) || (allowed[msg.sender][_spender] == 0));
189 
190         allowed[msg.sender][_spender] = _value;
191         Approval(msg.sender, _spender, _value);
192         return true;
193     }
194 
195     function allowance(address _owner, address _spender) constant returns (uint remaining) {
196       return allowed[_owner][_spender];
197     }
198 
199     mapping (address => uint) balances;
200     mapping (address => mapping (address => uint)) allowed;
201 }
202 
203 
204 
205 
206 pragma solidity ^0.4.11;
207 
208 
209 /*
210 
211   Copyright 2017 Wanchain Foundation.
212 
213   Licensed under the Apache License, Version 2.0 (the "License");
214   you may not use this file except in compliance with the License.
215   You may obtain a copy of the License at
216 
217   http://www.apache.org/licenses/LICENSE-2.0
218 
219   Unless required by applicable law or agreed to in writing, software
220   distributed under the License is distributed on an "AS IS" BASIS,
221   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
222   See the License for the specific language governing permissions and
223   limitations under the License.
224 
225 */
226 
227 //                            _           _           _
228 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
229 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
230 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
231 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
232 //
233 //  Code style according to: https://github.com/wanchain/wanchain-token/blob/master/style-guide.rst
234 
235 
236 
237 //import "./StandardToken.sol";
238 //import "./SafeMath.sol";
239 
240 
241 /// @title Wanchain Token Contract
242 /// For more information about this token sale, please visit https://wanchain.org
243 /// @author Cathy - <cathy@wanchain.org>
244 contract WanToken is StandardToken {
245     using SafeMath for uint;
246 
247     /// Constant token specific fields
248     string public constant name = "WanCoin";
249     string public constant symbol = "WAN";
250     uint public constant decimals = 18;
251 
252     /// Wanchain total tokens supply
253     uint public constant MAX_TOTAL_TOKEN_AMOUNT = 210000000 ether;
254 
255     /// Fields that are only changed in constructor
256     /// Wanchain contribution contract
257     address public minter;
258     /// ICO start time
259     uint public startTime;
260     /// ICO end time
261     uint public endTime;
262 
263     /// Fields that can be changed by functions
264     mapping (address => uint) public lockedBalances;
265     /*
266      * MODIFIERS
267      */
268 
269     modifier onlyMinter {
270     	  assert(msg.sender == minter);
271     	  _;
272     }
273 
274     modifier isLaterThan (uint x){
275     	  assert(now > x);
276     	  _;
277     }
278 
279     modifier maxWanTokenAmountNotReached (uint amount){
280     	  assert(totalSupply.add(amount) <= MAX_TOTAL_TOKEN_AMOUNT);
281     	  _;
282     }
283 
284     /**
285      * CONSTRUCTOR
286      *
287      * @dev Initialize the Wanchain Token
288      * @param _minter The Wanchain Contribution Contract
289      * @param _startTime ICO start time
290      * @param _endTime ICO End Time
291      */
292     function WanToken(address _minter, uint _startTime, uint _endTime){
293     	  minter = _minter;
294     	  startTime = _startTime;
295     	  endTime = _endTime;
296     }
297 
298     /**
299      * EXTERNAL FUNCTION
300      *
301      * @dev Contribution contract instance mint token
302      * @param receipent The destination account owned mint tokens
303      * @param amount The amount of mint token
304      * be sent to this address.
305      */
306     function mintToken(address receipent, uint amount)
307         external
308         onlyMinter
309         maxWanTokenAmountNotReached(amount)
310         returns (bool)
311     {
312       	lockedBalances[receipent] = lockedBalances[receipent].add(amount);
313       	totalSupply = totalSupply.add(amount);
314       	return true;
315     }
316 
317     /*
318      * PUBLIC FUNCTIONS
319      */
320 
321     /// @dev Locking period has passed - Locked tokens have turned into tradeable
322     ///      All tokens owned by receipent will be tradeable
323     function claimTokens(address receipent)
324         public
325         onlyMinter
326     {
327       	balances[receipent] = balances[receipent].add(lockedBalances[receipent]);
328       	lockedBalances[receipent] = 0;
329     }
330 
331     /*
332      * CONSTANT METHODS
333      */
334     function lockedBalanceOf(address _owner) constant returns (uint balance) {
335         return lockedBalances[_owner];
336     }
337 }
338 
339 
340 pragma solidity ^0.4.11;
341 
342 /*
343 
344   Copyright 2017 Wanchain Foundation.
345 
346   Licensed under the Apache License, Version 2.0 (the "License");
347   you may not use this file except in compliance with the License.
348   You may obtain a copy of the License at
349 
350   http://www.apache.org/licenses/LICENSE-2.0
351 
352   Unless required by applicable law or agreed to in writing, software
353   distributed under the License is distributed on an "AS IS" BASIS,
354   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
355   See the License for the specific language governing permissions and
356   limitations under the License.
357 
358 */
359 
360 //                            _           _           _
361 //  __      ____ _ _ __   ___| |__   __ _(_)_ __   __| | _____   __
362 //  \ \ /\ / / _` | '_ \ / __| '_ \ / _` | | '_ \@/ _` |/ _ \ \ / /
363 //   \ V  V / (_| | | | | (__| | | | (_| | | | | | (_| |  __/\ V /
364 //    \_/\_/ \__,_|_| |_|\___|_| |_|\__,_|_|_| |_|\__,_|\___| \_/
365 //
366 //  Code style according to: https://github.com/wanchain/wanchain-token/blob/master/style-guide.rst
367 
368 /// @title Wanchain Contribution Contract
369 /// ICO Rules according: https://www.wanchain.org/crowdsale
370 /// For more information about this token sale, please visit https://wanchain.org
371 /// @author Zane Liang - <zaneliang@wanchain.org>
372 contract WanchainContribution is Owned {
373     using SafeMath for uint;
374 
375     /// Constant fields
376     /// Wanchain total tokens supply
377     uint public constant WAN_TOTAL_SUPPLY = 210000000 ether;
378     uint public constant MAX_CONTRIBUTION_DURATION = 3 days;
379 
380     /// Exchange rates for first phase
381     uint public constant PRICE_RATE_FIRST = 880;
382     /// Exchange rates for second phase
383     uint public constant PRICE_RATE_SECOND = 790;
384     /// Exchange rates for last phase
385     uint public constant PRICE_RATE_LAST = 750;
386 
387     /// ----------------------------------------------------------------------------------------------------
388     /// |                                                  |                    |                 |        |
389     /// |        PUBLIC SALE (PRESALE + OPEN SALE)         |      DEV TEAM      |    FOUNDATION   |  MINER |
390     /// |                       51%                        |         20%        |       19%       |   10%  |
391     /// ----------------------------------------------------------------------------------------------------
392       /// OPEN_SALE_STAKE + PRESALE_STAKE = 51; 51% sale for public
393       uint public constant OPEN_SALE_STAKE = 459;  // 45.9% for open sale
394       uint public constant PRESALE_STAKE = 51;     // 5.1%  for presale
395 
396       // Reserved stakes
397       uint public constant DEV_TEAM_STAKE = 200;   // 20%
398       uint public constant FOUNDATION_STAKE = 190; // 19%
399       uint public constant MINERS_STAKE = 100;     // 10%
400 
401       uint public constant DIVISOR_STAKE = 1000;
402 
403       /// Holder address for presale and reserved tokens
404       /// TODO: change addressed before deployed to main net
405       address public constant PRESALE_HOLDER = 0xca8f76fd9597e5c0ea5ef0f83381c0635271cd5d;
406 
407       // Addresses of Patrons
408       address public constant DEV_TEAM_HOLDER = 0x1631447d041f929595a9c7b0c9c0047de2e76186;
409       address public constant FOUNDATION_HOLDER = 0xe442408a5f2e224c92b34e251de48f5266fc38de;
410       address public constant MINERS_HOLDER = 0x38b195d2a18a4e60292868fa74fae619d566111e;
411 
412       uint public MAX_OPEN_SOLD = WAN_TOTAL_SUPPLY * OPEN_SALE_STAKE / DIVISOR_STAKE;
413 
414     /// Fields that are only changed in constructor
415     /// All deposited ETH will be instantly forwarded to this address.
416     address public wanport;
417     /// Contribution start time
418     uint public startTime;
419     /// Contribution end time
420     uint public endTime;
421 
422     /// Fields that can be changed by functions
423     /// Accumulator for open sold tokens
424     uint openSoldTokens;
425     /// Normal sold tokens
426     uint normalSoldTokens;
427     /// The sum of reserved tokens for ICO stage 1
428     uint public partnerReservedSum;
429     /// Due to an emergency, set this to true to halt the contribution
430     bool public halted;
431     /// ERC20 compilant wanchain token contact instance
432     WanToken public wanToken;
433 
434     /// Quota for partners
435     mapping (address => uint256) public partnersLimit;
436     /// Accumulator for partner sold
437     mapping (address => uint256) public partnersBought;
438 
439     uint256 public normalBuyLimit = 65 ether;
440 
441     /*
442      * EVENTS
443      */
444 
445     event NewSale(address indexed destAddress, uint ethCost, uint gotTokens);
446     event PartnerAddressQuota(address indexed partnerAddress, uint quota);
447 
448     /*
449      * MODIFIERS
450      */
451 
452     modifier onlyWallet {
453         require(msg.sender == wanport);
454         _;
455     }
456 
457     modifier notHalted() {
458         require(!halted);
459         _;
460     }
461 
462     modifier initialized() {
463         require(address(wanport) != 0x0);
464         _;
465     }
466 
467     modifier notEarlierThan(uint x) {
468         require(now >= x);
469         _;
470     }
471 
472     modifier earlierThan(uint x) {
473         require(now < x);
474         _;
475     }
476 
477     modifier ceilingNotReached() {
478         require(openSoldTokens < MAX_OPEN_SOLD);
479         _;
480     }
481 
482     modifier isSaleEnded() {
483         require(now > endTime || openSoldTokens >= MAX_OPEN_SOLD);
484         _;
485     }
486 
487 
488     /**
489      * CONSTRUCTOR
490      *
491      * @dev Initialize the Wanchain contribution contract
492      * @param _wanport The escrow account address, all ethers will be sent to this address.
493      * @param _startTime ICO start time
494      */
495     function WanchainContribution(address _wanport, uint _startTime){
496     	require(_wanport != 0x0);
497 
498         halted = false;
499     	wanport = _wanport;
500     	startTime = _startTime;
501     	endTime = startTime + MAX_CONTRIBUTION_DURATION;
502         openSoldTokens = 0;
503         partnerReservedSum = 0;
504         normalSoldTokens = 0;
505         /// Create wanchain token contract instance
506     	wanToken = new WanToken(this,startTime, endTime);
507 
508         /// Reserve tokens according wanchain ICO rules
509     	uint stakeMultiplier = WAN_TOTAL_SUPPLY / DIVISOR_STAKE;
510 
511     	wanToken.mintToken(PRESALE_HOLDER, PRESALE_STAKE * stakeMultiplier);
512         wanToken.mintToken(DEV_TEAM_HOLDER, DEV_TEAM_STAKE * stakeMultiplier);
513         wanToken.mintToken(FOUNDATION_HOLDER, FOUNDATION_STAKE * stakeMultiplier);
514         wanToken.mintToken(MINERS_HOLDER, MINERS_STAKE * stakeMultiplier);
515     }
516 
517     /**
518      * Fallback function
519      *
520      * @dev If anybody sends Ether directly to this  contract, consider he is getting wan token
521      */
522     function () public payable notHalted ceilingNotReached{
523     	buyWanCoin(msg.sender);
524     }
525 
526     /*
527      * PUBLIC FUNCTIONS
528      */
529 
530    function setNormalBuyLimit(uint256 limit)
531         public
532         initialized
533         onlyOwner
534         earlierThan(endTime)
535     {
536         normalBuyLimit = limit;
537     }
538 
539     /// @dev Sets the limit for a partner address. All the partner addresses
540     /// will be able to get wan token during the contribution period with his own
541     /// specific limit.
542     /// This method should be called by the owner after the initialization
543     /// and before the contribution end.
544     /// @param setPartnerAddress Partner address
545     /// @param limit Limit for the partner address,the limit is WANTOKEN, not ETHER
546     function setPartnerQuota(address setPartnerAddress, uint256 limit)
547         public
548         initialized
549         onlyOwner
550         earlierThan(endTime)
551     {
552         require(limit > 0 && limit <= MAX_OPEN_SOLD);
553         partnersLimit[setPartnerAddress] = limit;
554         partnerReservedSum += limit;
555         PartnerAddressQuota(setPartnerAddress, limit);
556     }
557 
558     /// @dev Exchange msg.value ether to WAN for account recepient
559     /// @param receipient WAN tokens receiver
560     function buyWanCoin(address receipient)
561         public
562         payable
563         notHalted
564         initialized
565         ceilingNotReached
566         notEarlierThan(startTime)
567         earlierThan(endTime)
568         returns (bool)
569     {
570     	require(receipient != 0x0);
571     	require(msg.value >= 0.1 ether);
572 
573     	if (partnersLimit[receipient] > 0)
574     		buyFromPartner(receipient);
575     	else {
576     		require(msg.value <= normalBuyLimit);
577     		buyNormal(receipient);
578     	}
579 
580     	return true;
581     }
582 
583     /// @dev Emergency situation that requires contribution period to stop.
584     /// Contributing not possible anymore.
585     function halt() public onlyWallet{
586         halted = true;
587     }
588 
589     /// @dev Emergency situation resolved.
590     /// Contributing becomes possible again withing the outlined restrictions.
591     function unHalt() public onlyWallet{
592         halted = false;
593     }
594 
595     /// @dev Emergency situation
596     function changeWalletAddress(address newAddress) onlyWallet {
597         wanport = newAddress;
598     }
599 
600     /// @return true if sale has started, false otherwise.
601     function saleStarted() constant returns (bool) {
602         return now >= startTime;
603     }
604 
605     /// @return true if sale has ended, false otherwise.
606     function saleEnded() constant returns (bool) {
607         return now > endTime || openSoldTokens >= MAX_OPEN_SOLD;
608     }
609 
610     /// CONSTANT METHODS
611     /// @dev Get current exchange rate
612     function priceRate() public constant returns (uint) {
613         // Three price tiers
614         if (startTime <= now && now < startTime + 1 days)
615             return PRICE_RATE_FIRST;
616         if (startTime + 1 days <= now && now < startTime + 2 days)
617             return PRICE_RATE_SECOND;
618         if (startTime + 2 days <= now && now < endTime)
619             return PRICE_RATE_LAST;
620         // Should not be called before or after contribution period
621         assert(false);
622     }
623 
624 
625     function claimTokens(address receipent)
626       public
627       isSaleEnded
628     {
629 
630       wanToken.claimTokens(receipent);
631 
632     }
633 
634     /*
635      * INTERNAL FUNCTIONS
636      */
637 
638     /// @dev Buy wanchain tokens by partners
639     function buyFromPartner(address receipient) internal {
640     	uint partnerAvailable = partnersLimit[receipient].sub(partnersBought[receipient]);
641 	    uint allAvailable = MAX_OPEN_SOLD.sub(openSoldTokens);
642       partnerAvailable = partnerAvailable.min256(allAvailable);
643 
644     	require(partnerAvailable > 0);
645 
646     	uint toFund;
647     	uint toCollect;
648     	(toFund,  toCollect)= costAndBuyTokens(partnerAvailable);
649 
650     	partnersBought[receipient] = partnersBought[receipient].add(toCollect);
651 
652     	buyCommon(receipient, toFund, toCollect);
653 
654     }
655 
656     /// @dev Buy wanchain token normally
657     function buyNormal(address receipient) internal {
658         // Do not allow contracts to game the system
659         require(!isContract(msg.sender));
660 
661         // protect partner quota in stage one
662         uint tokenAvailable;
663         if(startTime <= now && now < startTime + 1 days) {
664             uint totalNormalAvailable = MAX_OPEN_SOLD.sub(partnerReservedSum);
665             tokenAvailable = totalNormalAvailable.sub(normalSoldTokens);
666         } else {
667             tokenAvailable = MAX_OPEN_SOLD.sub(openSoldTokens);
668         }
669 
670         require(tokenAvailable > 0);
671 
672     	uint toFund;
673     	uint toCollect;
674     	(toFund, toCollect) = costAndBuyTokens(tokenAvailable);
675         buyCommon(receipient, toFund, toCollect);
676         normalSoldTokens += toCollect;
677     }
678 
679     /// @dev Utility function for bug wanchain token
680     function buyCommon(address receipient, uint toFund, uint wanTokenCollect) internal {
681         require(msg.value >= toFund); // double check
682 
683         if(toFund > 0) {
684             require(wanToken.mintToken(receipient, wanTokenCollect));
685             wanport.transfer(toFund);
686             openSoldTokens = openSoldTokens.add(wanTokenCollect);
687             NewSale(receipient, toFund, wanTokenCollect);
688         }
689 
690         uint toReturn = msg.value.sub(toFund);
691         if(toReturn > 0) {
692             msg.sender.transfer(toReturn);
693         }
694     }
695 
696     /// @dev Utility function for calculate available tokens and cost ethers
697     function costAndBuyTokens(uint availableToken) constant internal returns (uint costValue, uint getTokens){
698     	// all conditions has checked in the caller functions
699     	uint exchangeRate = priceRate();
700     	getTokens = exchangeRate * msg.value;
701 
702     	if(availableToken >= getTokens){
703     		costValue = msg.value;
704     	} else {
705     		costValue = availableToken / exchangeRate;
706     		getTokens = availableToken;
707     	}
708 
709     }
710 
711     /// @dev Internal function to determine if an address is a contract
712     /// @param _addr The address being queried
713     /// @return True if `_addr` is a contract
714     function isContract(address _addr) constant internal returns(bool) {
715         uint size;
716         if (_addr == 0) return false;
717         assembly {
718             size := extcodesize(_addr)
719         }
720         return size > 0;
721     }
722 }