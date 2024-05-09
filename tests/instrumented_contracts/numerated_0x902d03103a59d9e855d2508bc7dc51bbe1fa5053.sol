1 pragma solidity 0.4.23;
2 
3 /**
4  * @title Utility interfaces
5  * @author Biglabs Pte. Ltd.
6  * @dev Smart contract with owner
7 */
8 
9 contract Owner {
10     /**
11     * @dev Get smart contract's owner
12     * @return The owner of the smart contract
13     */
14     function owner() public view returns (address);
15     
16     //check address is a valid owner (owner or coOwner)
17     function isValidOwner(address _address) public view returns(bool);
18 
19 }
20 
21 
22 
23 /**
24  * @title ERC20Basic
25  * @dev Simpler version of ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/179
27  */
28 contract ERC20Basic {
29   function totalSupply() public view returns (uint256);
30   function balanceOf(address who) public view returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 
35 /**
36  * @title Utility smart contracts
37  * @author Biglabs Pte. Ltd.
38  * @dev Upgradable contract with agent
39  */
40  
41 contract Upgradable {
42     function upgrade() public;
43     function getRequiredTokens(uint _level) public pure returns (uint);
44     function getLevel() public view returns (uint);
45 }
46 
47 
48 
49 
50 
51 /**
52  * @title SafeMath
53  * @dev Math operations with safety checks that throw on error
54  */
55 library SafeMath {
56 
57   /**
58   * @dev Multiplies two numbers, throws on overflow.
59   */
60   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61     if (a == 0) {
62       return 0;
63     }
64     uint256 c = a * b;
65     assert(c / a == b);
66     return c;
67   }
68 
69   /**
70   * @dev Integer division of two numbers, truncating the quotient.
71   */
72   function div(uint256 a, uint256 b) internal pure returns (uint256) {
73     // assert(b > 0); // Solidity automatically throws when dividing by 0
74     uint256 c = a / b;
75     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
76     return c;
77   }
78 
79   /**
80   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   /**
88   * @dev Adds two numbers, throws on overflow.
89   */
90   function add(uint256 a, uint256 b) internal pure returns (uint256) {
91     uint256 c = a + b;
92     assert(c >= a);
93     return c;
94   }
95 }
96 
97 
98 /**
99  * @title Utility smart contracts
100  * @author Biglabs Pte. Ltd.
101  * @dev Timeline smart contract (within the period)
102  */
103  
104 contract Timeline {
105     //start time
106     uint public startTime;
107 
108     //end time
109     uint public endTime;
110 
111     modifier started() {
112         require(now >= startTime);
113         _;
114     }
115 
116     modifier notEnded() {
117         require(now <= endTime);
118         _;
119     }
120 
121     modifier isEnded() {
122         require(now >= endTime);
123         _;
124     }
125 
126     modifier onlyWhileOpen() {
127         require(now >= startTime && now <= endTime);
128         _;
129     }
130 
131 
132     /**
133      * @dev Timeline constructor
134      * @param _startTime The opening time in seconds (unix Time)
135      * @param _endTime The closing time in seconds (unix Time)
136      */
137     function Timeline(
138         uint256 _startTime,
139         uint256 _endTime
140     )
141         public 
142     {
143         require(_startTime > now);
144         require(_endTime > _startTime);
145         startTime = _startTime;
146         endTime = _endTime;
147     }
148 
149 }
150 
151 
152 
153 
154 
155 
156 
157 
158 
159 
160 /**
161  * @title Basic token
162  * @dev Basic version of StandardToken, with no allowances.
163  */
164 contract BasicToken is ERC20Basic {
165   using SafeMath for uint256;
166 
167   mapping(address => uint256) balances;
168 
169   uint256 totalSupply_;
170 
171   /**
172   * @dev total number of tokens in existence
173   */
174   function totalSupply() public view returns (uint256) {
175     return totalSupply_;
176   }
177 
178   /**
179   * @dev transfer token for a specified address
180   * @param _to The address to transfer to.
181   * @param _value The amount to be transferred.
182   */
183   function transfer(address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[msg.sender]);
186 
187     // SafeMath.sub will throw if there is not enough balance.
188     balances[msg.sender] = balances[msg.sender].sub(_value);
189     balances[_to] = balances[_to].add(_value);
190     emit Transfer(msg.sender, _to, _value);
191     return true;
192   }
193 
194   /**
195   * @dev Gets the balance of the specified address.
196   * @param _owner The address to query the the balance of.
197   * @return An uint256 representing the amount owned by the passed address.
198   */
199   function balanceOf(address _owner) public view returns (uint256 balance) {
200     return balances[_owner];
201   }
202 
203 }
204 
205 
206 
207 
208 
209 /**
210  * @title Utility interfaces
211  * @author Biglabs Pte. Ltd.
212  * @dev ERC20 smart contract with owner
213 */
214 
215 contract OwnerERC20 is ERC20Basic, Owner {
216 }
217 
218 
219 
220 
221 
222 
223 
224 
225 
226 
227 /**
228  * @title Utility smart contracts
229  * @author Biglabs Pte. Ltd.
230  * @dev Chain smart contract with the same owner
231  */
232  
233 contract ChainOwner is Owner {
234     //parent contract
235     OwnerERC20 internal parent;
236 
237     /**
238     * @param _parent The parent smart contract
239     */
240     function ChainOwner(OwnerERC20 _parent) internal {
241         parent = _parent;
242     }
243 
244     modifier onlyOwner() {
245         require(parent.isValidOwner(msg.sender));
246         _;
247     }
248 
249     function owner() public view returns (address) {
250         return parent.owner();
251     }
252 
253     modifier validOwner(OwnerERC20 _smzoToken) {
254         //check if function not called by owner or coOwner
255         if (!parent.isValidOwner(msg.sender)) {
256             //require this called from smart contract
257             OwnerERC20 ico = OwnerERC20(msg.sender);
258             //this will throw exception if not
259 
260             //ensure the same owner
261             require(ico.owner() == _smzoToken.owner());
262         }
263         _;
264     }
265     
266     function isValidOwner(address _address) public view returns(bool) {
267         if (_address == owner()) {
268             return true;
269         }
270         return false;
271     }
272 
273 }
274 
275 
276 /**
277  * @title Utility smart contracts
278  * @author Biglabs Pte. Ltd.
279  * @dev Chain smart contract with the same owner
280  */
281  
282 contract ChainCoOwner is ChainOwner {
283 
284     mapping(address=>bool) internal coOwner;
285     
286     address[] internal coOwnerList;
287 
288     /**
289      * @param _parent The parent smart contract
290      * @param _coOwner Array of coOwner
291     */
292     function ChainCoOwner(OwnerERC20 _parent, address[] _coOwner) ChainOwner(_parent) internal {
293         _addCoOwners(_coOwner);
294     }
295     
296     function _addCoOwners(address[] _coOwner) internal {
297         uint len = _coOwner.length;
298         for (uint i=0; i < len; i++) {
299             coOwner[_coOwner[i]] = true;
300             coOwnerList.push(_coOwner[i]);
301         }
302     }
303 
304     function _addCoOwner(address _coOwner) internal {
305         coOwner[_coOwner] = true;
306         coOwnerList.push(_coOwner);
307     }
308 
309     function _disableCoOwners(address[] _coOwner) internal {
310         uint len = _coOwner.length;
311         for (uint i=0; i < len; i++) {
312             coOwner[_coOwner[i]] = false;
313         }
314     }
315 
316     function _disableCoOwner(address _coOwner) internal {
317         coOwner[_coOwner] = false;
318     }
319 
320     /**
321      * @dev Check address is valid owner (owner or coOwner)
322      * @param _address Address to check
323      * 
324     */
325     function isValidOwner(address _address) public view returns(bool) {
326         if (_address == owner() || coOwner[_address] == true) {
327             return true;
328         }
329         return false;
330     }
331 
332 }
333 
334 
335 
336 
337 
338 /**
339  * @title Utility interfaces
340  * @author Biglabs Pte. Ltd.
341  * @dev ICO smart contract
342  */
343  
344 contract ICO is OwnerERC20 {
345     //transfer tokens (use wei contribution information)
346     function transferByEth(address _to, uint _weiAmount, uint _value) public returns (bool);
347 
348     //calculate no tokens
349     function calculateNoToken(uint _weiAmount) public view returns(uint);
350 }
351 
352 
353 
354 /**
355  * @title Mozo sale token for ICO
356  * @author Biglabs Pte. Ltd.
357  */
358 
359 contract MozoSaleToken is BasicToken, Timeline, ChainCoOwner, ICO {
360     using SafeMath for uint;
361 
362     //sale token name, use in ICO phase only
363     string public constant name = "Mozo Sale Token";
364 
365     //sale token symbol, use in ICO phase only
366     string public constant symbol = "SMZO";
367 
368     //token symbol
369     uint8 public constant decimals = 2;
370 
371     //KYC/AML threshold: 20k SGD = 15k USD = 165k token (x100)
372     uint public constant AML_THRESHOLD = 16500000;
373 
374     //No. repicients that has bonus tokens
375     uint public noBonusTokenRecipients;
376 
377     //total no. bonus tokens
378     uint public totalBonusToken;
379 
380     //bonus transferred flags
381     mapping(address => bool) bonus_transferred_repicients;
382 
383     //maximum transferring per function
384     uint public constant MAX_TRANSFER = 80;
385 
386     //number of transferred address
387     uint public transferredIndex;
388 
389     //indicate hardcap is reached or not
390     bool public isCapped = false;
391 
392     //total wei collected
393     uint public totalCapInWei;
394 
395     //rate
396     uint public rate;
397 
398     //flag indicate whether ICO is stopped for bonus
399     bool public isStopped;
400 
401     //hold all address to transfer Mozo tokens when releasing
402     address[] public transferAddresses;
403 
404     //whitelist (Already register KYC/AML)
405     mapping(address => bool) public whitelist;
406 
407     //contain map of address that buy over the threshold for KYC/AML 
408     //but buyer is not in the whitelist yes
409     mapping(address => uint) public pendingAmounts;
410 
411     /**
412      * @dev Throws if called by any account that's not whitelisted.
413      */
414     modifier onlyWhitelisted() {
415         require(whitelist[msg.sender]);
416         _;
417     }
418 
419     /**
420      * @dev Only owner or coOwner
421     */
422     modifier onlyOwnerOrCoOwner() {
423         require(isValidOwner(msg.sender));
424         _;
425     }
426 
427     /**
428      * @dev Only stopping for bonus distribution
429     */
430     modifier onlyStopping() {
431         require(isStopped == true);
432         _;
433     }
434 
435     /**
436      * Only owner or smart contract of the same owner in chain.
437      */
438     modifier onlySameChain() {
439         //check if function not called by owner or coOwner
440         if (!isValidOwner(msg.sender)) {
441             //require this called from smart contract
442             ChainOwner sm = ChainOwner(msg.sender);
443             //this will throw exception if not
444 
445             //ensure the same owner
446             require(sm.owner() == owner());
447         }
448         _;
449     }
450 
451 
452     /**
453      * @notice owner should transfer to this smart contract {_supply} Mozo tokens manually
454      * @param _mozoToken Mozo token smart contract
455      * @param _coOwner Array of coOwner
456      * @param _supply Total number of tokens = No. tokens * 10^decimals = No. tokens * 100
457      * @param _rate number of wei to buy 0.01 Mozo sale token
458      * @param _openingTime The opening time in seconds (unix Time)
459      * @param _closingTime The closing time in seconds (unix Time)
460      */
461     function MozoSaleToken(
462         OwnerERC20 _mozoToken,
463         address[] _coOwner,
464         uint _supply,
465         uint _rate,
466         uint _openingTime,
467         uint _closingTime
468     )
469     public
470     ChainCoOwner(_mozoToken, _coOwner)
471     Timeline(_openingTime, _closingTime)
472     onlyOwner()
473     {
474         require(_supply > 0);
475         require(_rate > 0);
476 
477         rate = _rate;
478         totalSupply_ = _supply;
479 
480         //assign all sale tokens to owner
481         balances[_mozoToken.owner()] = totalSupply_;
482 
483         //add owner and co_owner to whitelist
484         addAddressToWhitelist(msg.sender);
485         addAddressesToWhitelist(_coOwner);
486         emit Transfer(0x0, _mozoToken.owner(), totalSupply_);
487     }
488     
489     function addCoOwners(address[] _coOwner) public onlyOwner {
490         _addCoOwners(_coOwner);
491     }
492 
493     function addCoOwner(address _coOwner) public onlyOwner {
494         _addCoOwner(_coOwner);
495     }
496 
497     function disableCoOwners(address[] _coOwner) public onlyOwner {
498         _disableCoOwners(_coOwner);
499     }
500 
501     function disableCoOwner(address _coOwner) public onlyOwner {
502         _disableCoOwner(_coOwner);
503     }
504 
505     /**
506      * @dev Get Rate: number of wei to buy 0.01 Mozo token
507      */
508     function getRate() public view returns (uint) {
509         return rate;
510     }
511 
512     /**
513      * @dev Set Rate: 
514      * @param _rate Number of wei to buy 0.01 Mozo token
515      */
516     function setRate(uint _rate) public onlyOwnerOrCoOwner {
517         rate = _rate;
518     }
519 
520     /**
521      * @dev Get flag indicates ICO reached hardcap
522      */
523     function isReachCapped() public view returns (bool) {
524         return isCapped;
525     }
526 
527     /**
528      * @dev add an address to the whitelist, sender must have enough tokens
529      * @param _address address for adding to whitelist
530      * @return true if the address was added to the whitelist, false if the address was already in the whitelist
531      */
532     function addAddressToWhitelist(address _address) onlyOwnerOrCoOwner public returns (bool success) {
533         if (!whitelist[_address]) {
534             whitelist[_address] = true;
535             //transfer pending amount of tokens to user
536             uint noOfTokens = pendingAmounts[_address];
537             if (noOfTokens > 0) {
538                 pendingAmounts[_address] = 0;
539                 transfer(_address, noOfTokens);
540             }
541             success = true;
542         }
543     }
544 
545     /**
546      * @dev add addresses to the whitelist, sender must have enough tokens
547      * @param _addresses addresses for adding to whitelist
548      * @return true if at least one address was added to the whitelist, 
549      * false if all addresses were already in the whitelist  
550      */
551     function addAddressesToWhitelist(address[] _addresses) onlyOwnerOrCoOwner public returns (bool success) {
552         uint length = _addresses.length;
553         for (uint i = 0; i < length; i++) {
554             if (addAddressToWhitelist(_addresses[i])) {
555                 success = true;
556             }
557         }
558     }
559 
560     /**
561      * @dev remove an address from the whitelist
562      * @param _address address
563      * @return true if the address was removed from the whitelist, 
564      * false if the address wasn't in the whitelist in the first place 
565      */
566     function removeAddressFromWhitelist(address _address) onlyOwnerOrCoOwner public returns (bool success) {
567         if (whitelist[_address]) {
568             whitelist[_address] = false;
569             success = true;
570         }
571     }
572 
573     /**
574      * @dev remove addresses from the whitelist
575      * @param _addresses addresses
576      * @return true if at least one address was removed from the whitelist, 
577      * false if all addresses weren't in the whitelist in the first place
578      */
579     function removeAddressesFromWhitelist(address[] _addresses) onlyOwnerOrCoOwner public returns (bool success) {
580         uint length = _addresses.length;
581         for (uint i = 0; i < length; i++) {
582             if (removeAddressFromWhitelist(_addresses[i])) {
583                 success = true;
584             }
585         }
586     }
587 
588     /**
589      * Stop selling for bonus transfer
590      * @notice Owner should release InvestmentDiscount smart contract before call this
591      */
592     function setStop() onlyOwnerOrCoOwner {
593         isStopped = true;
594     }
595 
596     /**
597      * @dev Set hardcap is reached
598      * @notice Owner must release all sale smart contracts
599      */
600     function setReachCapped() public onlyOwnerOrCoOwner {
601         isCapped = true;
602     }
603 
604     /**
605      * @dev Get total distribution in Wei
606      */
607     function getCapInWei() public view returns (uint) {
608         return totalCapInWei;
609     }
610 
611     /**
612      * @dev Get no. investors
613      */
614     function getNoInvestor() public view returns (uint) {
615         return transferAddresses.length;
616     }
617 
618     /**
619      * @dev Get unsold tokens
620      */
621     function getUnsoldToken() public view returns (uint) {
622         uint unsold = balances[owner()];
623         for (uint j = 0; j < coOwnerList.length; j++) {
624             unsold = unsold.add(balances[coOwnerList[j]]);
625         }
626 
627         return unsold;
628     }
629 
630     /**
631      * @dev Get distributed tokens
632      */
633     function getDistributedToken() public view returns (uint) {
634         return totalSupply_.sub(getUnsoldToken());
635     }
636 
637     /**
638      * @dev Override transfer token for a specified address
639      * @param _to The address to transfer to.
640      * @param _value The amount to be transferred.
641      */
642     function transfer(address _to, uint _value) public returns (bool) {
643         //required this contract has enough Mozo tokens
644         //obsolete
645         //if (msg.sender == owner()) {
646         //    require(parent.balanceOf(this) >= getDistributedToken().add(_value));
647         //}
648         //we will check it when releasing smart contract
649 
650         //owners or balances already greater than 0, no need to add to list
651         bool notAddToList = isValidOwner(_to) || (balances[_to] > 0);
652 
653         //check AML threshold
654         if (!isStopped) {
655             if (!whitelist[_to]) {
656                 if ((_value + balances[_to]) > AML_THRESHOLD) {
657                     pendingAmounts[_to] = pendingAmounts[_to].add(_value);
658                     return true;
659                 }
660             }
661         }
662 
663         if (BasicToken.transfer(_to, _value)) {
664             if (!notAddToList) {
665                 transferAddresses.push(_to);
666             }
667             return true;
668         }
669 
670         return false;
671     }
672 
673     /**
674      * @param _weiAmount Contribution in wei
675      * 
676      */
677     function calculateNoToken(uint _weiAmount) public view returns (uint) {
678         return _weiAmount.div(rate);
679     }
680 
681     /**
682      * @dev Override transfer token for a specified address
683      * @param _to The address to transfer to.
684      * @param _weiAmount The wei amount spent to by token
685      */
686     function transferByEth(address _to, uint _weiAmount, uint _value)
687     public
688     onlyWhileOpen
689     onlySameChain()
690     returns (bool)
691     {
692         if (transfer(_to, _value)) {
693             totalCapInWei = totalCapInWei.add(_weiAmount);
694             return true;
695         }
696         return false;
697     }
698 
699     /**
700      * @dev Release smart contract
701      * @notice Owner must release all sale smart contracts
702      */
703     function release() public onlyOwnerOrCoOwner {
704         _release();
705     }
706 
707     /**
708      * @dev Investor claim tokens
709      */
710     function claim() public isEnded {
711         require(balances[msg.sender] > 0);
712         uint investorBalance = balances[msg.sender];
713 
714         balances[msg.sender] = 0;
715         parent.transfer(msg.sender, investorBalance);
716     }
717 
718     /**
719      * @param _recipients list of repicients
720      * @param _amount list of no. tokens
721     */
722     function bonusToken(address[] _recipients, uint[] _amount) public onlyOwnerOrCoOwner onlyStopping {
723         uint len = _recipients.length;
724         uint len1 = _amount.length;
725         require(len == len1);
726         require(len <= MAX_TRANSFER);
727         uint i;
728         uint total = 0;
729         for (i = 0; i < len; i++) {
730             if (bonus_transferred_repicients[_recipients[i]] == false) {
731                 bonus_transferred_repicients[_recipients[i]] = transfer(_recipients[i], _amount[i]);
732                 total = total.add(_amount[i]);
733             }
734         }
735         totalBonusToken = totalBonusToken.add(total);
736         noBonusTokenRecipients = noBonusTokenRecipients.add(len);
737     }
738 
739     function min(uint a, uint b) internal pure returns (uint) {
740         return a < b ? a : b;
741     }
742 
743     /**
744      * @notice Only call after releasing all sale smart contracts, this smart contract must have enough Mozo tokens
745      * @dev Release smart contract
746      */
747     function _release() internal {
748         uint length = min(transferAddresses.length, transferredIndex + MAX_TRANSFER);
749         uint i = transferredIndex;
750 
751         if (isCapped) {
752             //Reach hardcap, burn all owner sale token
753             for (; i < length; i++) {
754                 address ad = transferAddresses[i];
755                 uint b = balances[ad];
756                 if (b == 0) {
757                     continue;
758                 }
759 
760                 balances[ad] = 0;
761                 // send Mozo token from ICO account to investor address
762                 parent.transfer(ad, b);
763             }
764         } else {
765             uint unsold = getUnsoldToken();
766             uint sold = totalSupply_.sub(unsold);
767 
768             if (sold <= 0) {
769                 //very bad if we reach here
770                 return;
771             }
772             for (; i < length; i++) {
773                 ad = transferAddresses[i];
774                 //obsolete
775                 //no need to check because we checked before adding
776                 //if (ad == owner()) {
777                 //    continue;
778                 //}
779                 b = balances[ad];
780                 if (b == 0) {
781                     continue;
782                 }
783                 //distribute all unsold token to investors
784                 b = b.add(b.mul(unsold).div(sold));
785 
786                 // send Mozo token from ICO account to investor address
787                 balances[ad] = 0;
788                 parent.transfer(ad, b);
789             }
790         }
791 
792         transferredIndex = i - 1;
793 
794         //transfer remain tokens to owner
795         //for testing only
796         //parent.transfer(owner(), parent.balanceOf(address(this)));
797     }
798 
799 }