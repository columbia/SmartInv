1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public view returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract UserRegistryInterface {
60   event AddAddress(address indexed who);
61   event AddIdentity(address indexed who);
62 
63   function knownAddress(address _who) public constant returns(bool);
64   function hasIdentity(address _who) public constant returns(bool);
65   function systemAddresses(address _to, address _from) public constant returns(bool);
66 }
67 
68 contract MultiOwners {
69 
70     event AccessGrant(address indexed owner);
71     event AccessRevoke(address indexed owner);
72     
73     mapping(address => bool) owners;
74     address public publisher;
75 
76     function MultiOwners() public {
77         owners[msg.sender] = true;
78         publisher = msg.sender;
79     }
80 
81     modifier onlyOwner() { 
82         require(owners[msg.sender] == true);
83         _; 
84     }
85 
86     function isOwner() public constant returns (bool) {
87         return owners[msg.sender] ? true : false;
88     }
89 
90     function checkOwner(address maybe_owner) public constant returns (bool) {
91         return owners[maybe_owner] ? true : false;
92     }
93 
94     function grant(address _owner) onlyOwner public {
95         owners[_owner] = true;
96         AccessGrant(_owner);
97     }
98 
99     function revoke(address _owner) onlyOwner public {
100         require(_owner != publisher);
101         require(msg.sender != _owner);
102 
103         owners[_owner] = false;
104         AccessRevoke(_owner);
105     }
106 }
107 
108 contract TokenRecipient {
109   function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
110 }
111 
112 contract TokenInterface is ERC20 {
113   string public name;
114   string public symbol;
115   uint public decimals;
116 }
117 
118 contract MintableTokenInterface is TokenInterface {
119   address public owner;
120   function mint(address beneficiary, uint amount) public returns(bool);
121   function transferOwnership(address nextOwner) public;
122 }
123 
124 /**
125  * Complex crowdsale with huge posibilities
126  * Core features:
127  * - Whitelisting
128  *  - Min\max invest amounts
129  * - Only known users
130  * - Buy with allowed tokens
131  *  - Oraclize based pairs (ETH to TOKEN)
132  * - Revert\refund
133  * - Personal bonuses
134  * - Amount bonuses
135  * - Total supply bonuses
136  * - Early birds bonuses
137  * - Extra distribution (team, foundation and also)
138  * - Soft and hard caps
139  * - Finalization logics
140 **/
141 contract Crowdsale is MultiOwners, TokenRecipient {
142   using SafeMath for uint;
143 
144   //  ██████╗ ██████╗ ███╗   ██╗███████╗████████╗███████╗
145   // ██╔════╝██╔═══██╗████╗  ██║██╔════╝╚══██╔══╝██╔════╝
146   // ██║     ██║   ██║██╔██╗ ██║███████╗   ██║   ███████╗
147   // ██║     ██║   ██║██║╚██╗██║╚════██║   ██║   ╚════██║
148   // ╚██████╗╚██████╔╝██║ ╚████║███████║   ██║   ███████║
149   //  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝
150   uint public constant VERSION = 0x1;
151   enum State {
152     Setup,          // Non active yet (require to be setuped)
153     Active,         // Crowdsale in a live
154     Claim,          // Claim funds by owner
155     Refund,         // Unsucceseful crowdsale (refund ether)
156     History         // Close and store only historical fact of existence
157   }
158 
159 
160   struct PersonalBonusRecord {
161     uint bonus;
162     address refererAddress;
163     uint refererBonus;
164   }
165 
166   struct WhitelistRecord {
167     bool allow;
168     uint min;
169     uint max;
170   }
171 
172 
173   //  ██████╗ ██████╗ ███╗   ██╗███████╗██╗███╗   ██╗ ██████╗ 
174   // ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║████╗  ██║██╔════╝ 
175   // ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██╔██╗ ██║██║  ███╗
176   // ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║╚██╗██║██║   ██║
177   // ╚██████╗╚██████╔╝██║ ╚████║██║     ██║██║ ╚████║╚██████╔╝
178   //  ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
179                                                            
180   bool public isWhitelisted;            // Should be whitelisted to buy tokens
181   bool public isKnownOnly;              // Should be known user to buy tokens
182   bool public isAmountBonus;            // Enable amount bonuses in crowdsale?
183   bool public isEarlyBonus;             // Enable early bird bonus in crowdsale?
184   bool public isTokenExchange;          // Allow to buy tokens for another tokens?
185   bool public isAllowToIssue;           // Allow to issue tokens with tx hash (ex bitcoin)
186   bool public isDisableEther;           // Disable purchase with the Ether
187   bool public isExtraDistribution;      // Should distribute extra tokens to special contract?
188   bool public isTransferShipment;       // Will ship token via minting?
189   bool public isCappedInEther;          // Should be capped in Ether 
190   bool public isPersonalBonuses;        // Should check personal beneficiary bonus?
191   bool public isAllowClaimBeforeFinalization;
192                                         // Should allow to claim funds before finalization?
193   bool public isMinimumValue;           // Validate minimum amount to purchase
194   bool public isMinimumInEther;         // Is minimum amount setuped in Ether or Tokens?
195 
196   uint public minimumPurchaseValue;     // How less buyer could to purchase
197 
198   // List of allowed beneficiaries
199   mapping (address => WhitelistRecord) public whitelist;
200 
201   // Known users registry (required to known rules)
202   UserRegistryInterface public userRegistry;
203 
204   mapping (uint => uint) public amountBonuses; // Amount bonuses
205   uint[] public amountSlices;                  // Key is min amount of buy
206   uint public amountSlicesCount;               // 10000 - 100.00% bonus over base pricetotaly free
207                                                //  5000 - 50.00% bonus
208                                                //     0 - no bonus at all
209   mapping (uint => uint) public timeBonuses;   // Time bonuses
210   uint[] public timeSlices;                    // Same as amount but key is seconds after start
211   uint public timeSlicesCount;
212 
213   mapping (address => PersonalBonusRecord) public personalBonuses; 
214                                         // personal bonuses
215   MintableTokenInterface public token;  // The token being sold
216   uint public tokenDecimals;            // Token decimals
217 
218   mapping (address => TokenInterface) public allowedTokens;
219                                         // allowed tokens list
220   mapping (address => uint) public tokensValues;
221                                         // TOKEN to ETH conversion rate (oraclized)
222   uint public startTime;                // start and end timestamps where 
223   uint public endTime;                  // investments are allowed (both inclusive)
224   address public wallet;                // address where funds are collected
225   uint public price;                    // how many token (1 * 10 ** decimals) a buyer gets per wei
226   uint public hardCap;
227   uint public softCap;
228 
229   address public extraTokensHolder;     // address to mint/transfer extra tokens (0 – 0%, 1000 - 100.0%)
230   uint public extraDistributionPart;    // % of extra distribution
231 
232   // ███████╗████████╗ █████╗ ████████╗███████╗
233   // ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██╔════╝
234   // ███████╗   ██║   ███████║   ██║   █████╗  
235   // ╚════██║   ██║   ██╔══██║   ██║   ██╔══╝  
236   // ███████║   ██║   ██║  ██║   ██║   ███████╗
237   // ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚══════╝
238   // amount of raised money in wei
239   uint public weiRaised;
240   // Current crowdsale state
241   State public state;
242   // Temporal balances to pull tokens after token sale
243   // requires to ship required balance to smart contract
244   mapping (address => uint) public beneficiaryInvest;
245   uint public soldTokens;
246 
247   mapping (address => uint) public weiDeposit;
248   mapping (address => mapping(address => uint)) public altDeposit;
249 
250   modifier inState(State _target) {
251     require(state == _target);
252     _;
253   }
254 
255   // ███████╗██╗   ██╗███████╗███╗   ██╗████████╗███████╗
256   // ██╔════╝██║   ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝
257   // █████╗  ██║   ██║█████╗  ██╔██╗ ██║   ██║   ███████╗
258   // ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██║╚██╗██║   ██║   ╚════██║
259   // ███████╗ ╚████╔╝ ███████╗██║ ╚████║   ██║   ███████║
260   // ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝
261   
262   event EthBuy(
263     address indexed purchaser, 
264     address indexed beneficiary, 
265     uint value, 
266     uint amount);
267   event HashBuy(
268     address indexed beneficiary, 
269     uint value, 
270     uint amount, 
271     uint timestamp, 
272     bytes32 indexed bitcoinHash);
273   event AltBuy(
274     address indexed beneficiary, 
275     address indexed allowedToken, 
276     uint allowedTokenValue, 
277     uint ethValue, 
278     uint shipAmount);
279     
280   event ShipTokens(address indexed owner, uint amount);
281 
282   event Sanetize();
283   event Finalize();
284 
285   event Whitelisted(address indexed beneficiary, uint min, uint max);
286   event PersonalBonus(address indexed beneficiary, address indexed referer, uint bonus, uint refererBonus);
287   event FundsClaimed(address indexed owner, uint amount);
288 
289 
290   // ███████╗███████╗████████╗██╗   ██╗██████╗     ███╗   ███╗███████╗████████╗██╗  ██╗ ██████╗ ██████╗ ███████╗
291   // ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗    ████╗ ████║██╔════╝╚══██╔══╝██║  ██║██╔═══██╗██╔══██╗██╔════╝
292   // ███████╗█████╗     ██║   ██║   ██║██████╔╝    ██╔████╔██║█████╗     ██║   ███████║██║   ██║██║  ██║███████╗
293   // ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝     ██║╚██╔╝██║██╔══╝     ██║   ██╔══██║██║   ██║██║  ██║╚════██║
294   // ███████║███████╗   ██║   ╚██████╔╝██║         ██║ ╚═╝ ██║███████╗   ██║   ██║  ██║╚██████╔╝██████╔╝███████║
295   // ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝         ╚═╝     ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
296 
297   function setFlags(
298     // Should be whitelisted to buy tokens
299     bool _isWhitelisted,
300     // Should be known user to buy tokens
301     bool _isKnownOnly,
302     // Enable amount bonuses in crowdsale?
303     bool _isAmountBonus,
304     // Enable early bird bonus in crowdsale?
305     bool _isEarlyBonus,
306     // Allow to buy tokens for another tokens?
307     bool _isTokenExchange,
308     // Allow to issue tokens with tx hash (ex bitcoin)
309     bool _isAllowToIssue,
310     // Should reject purchases with Ether?
311     bool _isDisableEther,
312     // Should mint extra tokens for future distribution?
313     bool _isExtraDistribution,
314     // Will ship token via minting? 
315     bool _isTransferShipment,
316     // Should be capped in ether
317     bool _isCappedInEther,
318     // Should beneficiaries pull their tokens? 
319     bool _isPersonalBonuses,
320     // Should allow to claim funds before finalization?
321     bool _isAllowClaimBeforeFinalization)
322     inState(State.Setup) onlyOwner public 
323   {
324     isWhitelisted = _isWhitelisted;
325     isKnownOnly = _isKnownOnly;
326     isAmountBonus = _isAmountBonus;
327     isEarlyBonus = _isEarlyBonus;
328     isTokenExchange = _isTokenExchange;
329     isAllowToIssue = _isAllowToIssue;
330     isDisableEther = _isDisableEther;
331     isExtraDistribution = _isExtraDistribution;
332     isTransferShipment = _isTransferShipment;
333     isCappedInEther = _isCappedInEther;
334     isPersonalBonuses = _isPersonalBonuses;
335     isAllowClaimBeforeFinalization = _isAllowClaimBeforeFinalization;
336   }
337 
338   // ! Could be changed in process of sale (since 02.2018)
339   function setMinimum(uint _amount, bool _inToken) 
340     onlyOwner public
341   {
342     if (_amount == 0) {
343       isMinimumValue = false;
344       minimumPurchaseValue = 0;
345     } else {
346       isMinimumValue = true;
347       isMinimumInEther = !_inToken;
348       minimumPurchaseValue = _amount;
349     }
350   }
351 
352   function setPrice(uint _price)
353     inState(State.Setup) onlyOwner public
354   {
355     require(_price > 0);
356     price = _price;
357   }
358 
359   function setSoftHardCaps(uint _softCap, uint _hardCap)
360     inState(State.Setup) onlyOwner public
361   {
362     hardCap = _hardCap;
363     softCap = _softCap;
364   }
365 
366   function setTime(uint _start, uint _end)
367     inState(State.Setup) onlyOwner public 
368   {
369     require(_start < _end);
370     require(_end > block.timestamp);
371     startTime = _start;
372     endTime = _end;
373   }
374 
375   function setToken(address _tokenAddress) 
376     inState(State.Setup) onlyOwner public
377   {
378     token = MintableTokenInterface(_tokenAddress);
379     tokenDecimals = token.decimals();
380   }
381 
382   function setWallet(address _wallet) 
383     inState(State.Setup) onlyOwner public 
384   {
385     require(_wallet != address(0));
386     wallet = _wallet;
387   }
388   
389   function setRegistry(address _registry) 
390     inState(State.Setup) onlyOwner public 
391   {
392     require(_registry != address(0));
393     userRegistry = UserRegistryInterface(_registry);
394   }
395 
396   function setExtraDistribution(address _holder, uint _extraPart) 
397     inState(State.Setup) onlyOwner public
398   {
399     require(_holder != address(0));
400     extraTokensHolder = _holder;
401     extraDistributionPart = _extraPart;
402   }
403 
404   function setAmountBonuses(uint[] _amountSlices, uint[] _bonuses) 
405     inState(State.Setup) onlyOwner public 
406   {
407     require(_amountSlices.length > 1);
408     require(_bonuses.length == _amountSlices.length);
409     uint lastSlice = 0;
410     for (uint index = 0; index < _amountSlices.length; index++) {
411       require(_amountSlices[index] > lastSlice);
412       lastSlice = _amountSlices[index];
413       amountSlices.push(lastSlice);
414       amountBonuses[lastSlice] = _bonuses[index];
415     }
416 
417     amountSlicesCount = amountSlices.length;
418   }
419 
420   function setTimeBonuses(uint[] _timeSlices, uint[] _bonuses) 
421     // ! Not need to check state since changes at 02.2018
422     // inState(State.Setup)
423     onlyOwner 
424     public 
425   {
426     // Only once in life time
427     // ! Time bonuses is changable after 02.2018
428     // require(timeSlicesCount == 0);
429     require(_timeSlices.length > 0);
430     require(_bonuses.length == _timeSlices.length);
431     uint lastSlice = 0;
432     uint lastBonus = 10000;
433     if (timeSlicesCount > 0) {
434       // ! Since time bonuses is changable we should take latest first
435       lastSlice = timeSlices[timeSlicesCount - 1];
436       lastBonus = timeBonuses[lastSlice];
437     }
438 
439     for (uint index = 0; index < _timeSlices.length; index++) {
440       require(_timeSlices[index] > lastSlice);
441 
442       // ! Add check for next bonus is equal or less than previous
443       require(_bonuses[index] <= lastBonus);
444 
445       // ? Should we check bonus in a future
446       lastSlice = _timeSlices[index];
447       timeSlices.push(lastSlice);
448       timeBonuses[lastSlice] = _bonuses[index];
449     }
450     timeSlicesCount = timeSlices.length;
451   }
452   
453   function setTokenExcange(address _token, uint _value)
454     inState(State.Setup) onlyOwner public
455   {
456     allowedTokens[_token] = TokenInterface(_token);
457     updateTokenValue(_token, _value); 
458   }
459 
460   function saneIt() 
461     inState(State.Setup) onlyOwner public 
462   {
463     require(startTime < endTime);
464     require(endTime > now);
465 
466     require(price > 0);
467 
468     require(wallet != address(0));
469     require(token != address(0));
470 
471     if (isKnownOnly) {
472       require(userRegistry != address(0));
473     }
474 
475     if (isAmountBonus) {
476       require(amountSlicesCount > 0);
477     }
478 
479     if (isExtraDistribution) {
480       require(extraTokensHolder != address(0));
481     }
482 
483     if (isTransferShipment) {
484       require(token.balanceOf(address(this)) >= hardCap);
485     } else {
486       require(token.owner() == address(this));
487     }
488 
489     state = State.Active;
490   }
491 
492   function finalizeIt(address _futureOwner) inState(State.Active) onlyOwner public {
493     require(ended());
494 
495     token.transferOwnership(_futureOwner);
496 
497     if (success()) {
498       state = State.Claim;
499     } else {
500       state = State.Refund;
501     }
502   }
503 
504   function historyIt() inState(State.Claim) onlyOwner public {
505     require(address(this).balance == 0);
506     state = State.History;
507   }
508 
509   // ███████╗██╗  ██╗███████╗ ██████╗██╗   ██╗████████╗███████╗
510   // ██╔════╝╚██╗██╔╝██╔════╝██╔════╝██║   ██║╚══██╔══╝██╔════╝
511   // █████╗   ╚███╔╝ █████╗  ██║     ██║   ██║   ██║   █████╗  
512   // ██╔══╝   ██╔██╗ ██╔══╝  ██║     ██║   ██║   ██║   ██╔══╝  
513   // ███████╗██╔╝ ██╗███████╗╚██████╗╚██████╔╝   ██║   ███████╗
514   // ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝    ╚═╝   ╚══════╝
515 
516   function calculateEthAmount(
517     address _beneficiary,
518     uint _weiAmount,
519     uint _time,
520     uint _totalSupply
521   ) public constant returns(
522     uint calculatedTotal, 
523     uint calculatedBeneficiary, 
524     uint calculatedExtra, 
525     uint calculatedreferer, 
526     address refererAddress) 
527   {
528     _totalSupply;
529     uint bonus = 0;
530     
531     if (isAmountBonus) {
532       bonus = bonus.add(calculateAmountBonus(_weiAmount));
533     }
534 
535     if (isEarlyBonus) {
536       bonus = bonus.add(calculateTimeBonus(_time.sub(startTime)));
537     }
538 
539     if (isPersonalBonuses && personalBonuses[_beneficiary].bonus > 0) {
540       bonus = bonus.add(personalBonuses[_beneficiary].bonus);
541     }
542 
543     calculatedBeneficiary = _weiAmount.mul(10 ** tokenDecimals).div(price);
544     if (bonus > 0) {
545       calculatedBeneficiary = calculatedBeneficiary.add(calculatedBeneficiary.mul(bonus).div(10000));
546     }
547 
548     if (isExtraDistribution) {
549       calculatedExtra = calculatedBeneficiary.mul(extraDistributionPart).div(10000);
550     }
551 
552     if (isPersonalBonuses && 
553         personalBonuses[_beneficiary].refererAddress != address(0) && 
554         personalBonuses[_beneficiary].refererBonus > 0) 
555     {
556       calculatedreferer = calculatedBeneficiary.mul(personalBonuses[_beneficiary].refererBonus).div(10000);
557       refererAddress = personalBonuses[_beneficiary].refererAddress;
558     }
559 
560     calculatedTotal = calculatedBeneficiary.add(calculatedExtra).add(calculatedreferer);
561   }
562 
563   function calculateAmountBonus(uint _changeAmount) public constant returns(uint) {
564     uint bonus = 0;
565     for (uint index = 0; index < amountSlices.length; index++) {
566       if(amountSlices[index] > _changeAmount) {
567         break;
568       }
569 
570       bonus = amountBonuses[amountSlices[index]];
571     }
572     return bonus;
573   }
574 
575   function calculateTimeBonus(uint _at) public constant returns(uint) {
576     uint bonus = 0;
577     for (uint index = timeSlices.length; index > 0; index--) {
578       if(timeSlices[index - 1] < _at) {
579         break;
580       }
581       bonus = timeBonuses[timeSlices[index - 1]];
582     }
583 
584     return bonus;
585   }
586 
587   function validPurchase(
588     address _beneficiary, 
589     uint _weiAmount, 
590     uint _tokenAmount,
591     uint _extraAmount,
592     uint _totalAmount,
593     uint _time) 
594   public constant returns(bool) 
595   {
596     _tokenAmount;
597     _extraAmount;
598 
599     // ! Check min purchase value (since 02.2018)
600     if (isMinimumValue) {
601       // ! Check min purchase value in ether (since 02.2018)
602       if (isMinimumInEther && _weiAmount < minimumPurchaseValue) {
603         return false;
604       }
605 
606       // ! Check min purchase value in tokens (since 02.2018)
607       if (!isMinimumInEther && _tokenAmount < minimumPurchaseValue) {
608         return false;
609       }
610     }
611 
612     if (_time < startTime || _time > endTime) {
613       return false;
614     }
615 
616     if (isKnownOnly && !userRegistry.knownAddress(_beneficiary)) {
617       return false;
618     }
619 
620     uint finalBeneficiaryInvest = beneficiaryInvest[_beneficiary].add(_weiAmount);
621     uint finalTotalSupply = soldTokens.add(_totalAmount);
622 
623     if (isWhitelisted) {
624       WhitelistRecord storage record = whitelist[_beneficiary];
625       if (!record.allow || 
626           record.min > finalBeneficiaryInvest ||
627           record.max < finalBeneficiaryInvest) {
628         return false;
629       }
630     }
631 
632     if (isCappedInEther) {
633       if (weiRaised.add(_weiAmount) > hardCap) {
634         return false;
635       }
636     } else {
637       if (finalTotalSupply > hardCap) {
638         return false;
639       }
640     }
641 
642     return true;
643   }
644 
645                                                                                         
646   function updateTokenValue(address _token, uint _value) onlyOwner public {
647     require(address(allowedTokens[_token]) != address(0x0));
648     tokensValues[_token] = _value;
649   }
650 
651   // ██████╗ ███████╗ █████╗ ██████╗ 
652   // ██╔══██╗██╔════╝██╔══██╗██╔══██╗
653   // ██████╔╝█████╗  ███████║██║  ██║
654   // ██╔══██╗██╔══╝  ██╔══██║██║  ██║
655   // ██║  ██║███████╗██║  ██║██████╔╝
656   // ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝ 
657   function success() public constant returns(bool) {
658     if (isCappedInEther) {
659       return weiRaised >= softCap;
660     } else {
661       return token.totalSupply() >= softCap;
662     }
663   }
664 
665   function capped() public constant returns(bool) {
666     if (isCappedInEther) {
667       return weiRaised >= hardCap;
668     } else {
669       return token.totalSupply() >= hardCap;
670     }
671   }
672 
673   function ended() public constant returns(bool) {
674     return capped() || block.timestamp >= endTime;
675   }
676 
677 
678   //  ██████╗ ██╗   ██╗████████╗███████╗██╗██████╗ ███████╗
679   // ██╔═══██╗██║   ██║╚══██╔══╝██╔════╝██║██╔══██╗██╔════╝
680   // ██║   ██║██║   ██║   ██║   ███████╗██║██║  ██║█████╗  
681   // ██║   ██║██║   ██║   ██║   ╚════██║██║██║  ██║██╔══╝  
682   // ╚██████╔╝╚██████╔╝   ██║   ███████║██║██████╔╝███████╗
683   //  ╚═════╝  ╚═════╝    ╚═╝   ╚══════╝╚═╝╚═════╝ ╚══════╝
684   // fallback function can be used to buy tokens
685   function () external payable {
686     buyTokens(msg.sender);
687   }
688 
689   function buyTokens(address _beneficiary) inState(State.Active) public payable {
690     require(!isDisableEther);
691     uint shipAmount = sellTokens(_beneficiary, msg.value, block.timestamp);
692     require(shipAmount > 0);
693     forwardEther();
694   }
695 
696   function buyWithHash(address _beneficiary, uint _value, uint _timestamp, bytes32 _hash) 
697     inState(State.Active) onlyOwner public 
698   {
699     require(isAllowToIssue);
700     uint shipAmount = sellTokens(_beneficiary, _value, _timestamp);
701     require(shipAmount > 0);
702     HashBuy(_beneficiary, _value, shipAmount, _timestamp, _hash);
703   }
704   
705   function receiveApproval(address _from, 
706                            uint256 _value, 
707                            address _token, 
708                            bytes _extraData) public 
709   {
710     if (_token == address(token)) {
711       TokenInterface(_token).transferFrom(_from, address(this), _value);
712       return;
713     }
714 
715     require(isTokenExchange);
716     
717     require(toUint(_extraData) == tokensValues[_token]);
718     require(tokensValues[_token] > 0);
719     require(forwardTokens(_from, _token, _value));
720 
721     uint weiValue = _value.mul(tokensValues[_token]).div(10 ** allowedTokens[_token].decimals());
722     require(weiValue > 0);
723 
724     uint shipAmount = sellTokens(_from, weiValue, block.timestamp);
725     require(shipAmount > 0);
726 
727     AltBuy(_from, _token, _value, weiValue, shipAmount);
728   }
729 
730   function claimFunds() onlyOwner public returns(bool) {
731     require(state == State.Claim || (isAllowClaimBeforeFinalization && success()));
732     wallet.transfer(address(this).balance);
733     return true;
734   }
735 
736   function claimTokenFunds(address _token) onlyOwner public returns(bool) {
737     require(state == State.Claim || (isAllowClaimBeforeFinalization && success()));
738     uint balance = allowedTokens[_token].balanceOf(address(this));
739     require(balance > 0);
740     require(allowedTokens[_token].transfer(wallet, balance));
741     return true;
742   }
743 
744   function claimRefundEther(address _beneficiary) inState(State.Refund) public returns(bool) {
745     require(weiDeposit[_beneficiary] > 0);
746     _beneficiary.transfer(weiDeposit[_beneficiary]);
747     return true;
748   }
749 
750   function claimRefundTokens(address _beneficiary, address _token) inState(State.Refund) public returns(bool) {
751     require(altDeposit[_token][_beneficiary] > 0);
752     require(allowedTokens[_token].transfer(_beneficiary, altDeposit[_token][_beneficiary]));
753     return true;
754   }
755 
756   function addToWhitelist(address _beneficiary, uint _min, uint _max) onlyOwner public
757   {
758     require(_beneficiary != address(0));
759     require(_min <= _max);
760 
761     if (_max == 0) {
762       _max = 10 ** 40; // should be huge enough? :0
763     }
764 
765     whitelist[_beneficiary] = WhitelistRecord(true, _min, _max);
766     Whitelisted(_beneficiary, _min, _max);
767   }
768   
769   function setPersonalBonus(
770     address _beneficiary, 
771     uint _bonus, 
772     address _refererAddress, 
773     uint _refererBonus) onlyOwner public {
774     personalBonuses[_beneficiary] = PersonalBonusRecord(
775       _bonus,
776       _refererAddress,
777       _refererBonus
778     );
779 
780     PersonalBonus(_beneficiary, _refererAddress, _bonus, _refererBonus);
781   }
782 
783   // ██╗███╗   ██╗████████╗███████╗██████╗ ███╗   ██╗ █████╗ ██╗     ███████╗
784   // ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗████╗  ██║██╔══██╗██║     ██╔════╝
785   // ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝██╔██╗ ██║███████║██║     ███████╗
786   // ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██║╚██╗██║██╔══██║██║     ╚════██║
787   // ██║██║ ╚████║   ██║   ███████╗██║  ██║██║ ╚████║██║  ██║███████╗███████║
788   // ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝╚══════╝
789   // low level token purchase function
790   function sellTokens(address _beneficiary, uint _weiAmount, uint timestamp) 
791     inState(State.Active) internal returns(uint)
792   {
793     uint beneficiaryTokens;
794     uint extraTokens;
795     uint totalTokens;
796     uint refererTokens;
797     address refererAddress;
798     (totalTokens, beneficiaryTokens, extraTokens, refererTokens, refererAddress) = calculateEthAmount(
799       _beneficiary, 
800       _weiAmount, 
801       timestamp, 
802       token.totalSupply());
803 
804     require(validPurchase(_beneficiary,   // Check if current purchase is valid
805                           _weiAmount, 
806                           beneficiaryTokens,
807                           extraTokens,
808                           totalTokens,
809                           timestamp));
810 
811     weiRaised = weiRaised.add(_weiAmount); // update state (wei amount)
812     beneficiaryInvest[_beneficiary] = beneficiaryInvest[_beneficiary].add(_weiAmount);
813     shipTokens(_beneficiary, beneficiaryTokens);     // ship tokens to beneficiary
814     EthBuy(msg.sender,             // Fire purchase event
815                   _beneficiary, 
816                   _weiAmount, 
817                   beneficiaryTokens);
818     ShipTokens(_beneficiary, beneficiaryTokens);
819 
820     if (isExtraDistribution) {            // calculate and
821       shipTokens(extraTokensHolder, extraTokens);
822       ShipTokens(extraTokensHolder, extraTokens);
823     }
824 
825     if (isPersonalBonuses) {
826       PersonalBonusRecord storage record = personalBonuses[_beneficiary];
827       if (record.refererAddress != address(0) && record.refererBonus > 0) {
828         shipTokens(record.refererAddress, refererTokens);
829         ShipTokens(record.refererAddress, refererTokens);
830       }
831     }
832 
833     soldTokens = soldTokens.add(totalTokens);
834     return beneficiaryTokens;
835   }
836 
837   function shipTokens(address _beneficiary, uint _amount) 
838     inState(State.Active) internal 
839   {
840     if (isTransferShipment) {
841       token.transfer(_beneficiary, _amount);
842     } else {
843       token.mint(address(this), _amount);
844       token.transfer(_beneficiary, _amount);
845     }
846   }
847 
848   function forwardEther() internal returns (bool) {
849     weiDeposit[msg.sender] = msg.value;
850     return true;
851   }
852 
853   function forwardTokens(address _beneficiary, address _tokenAddress, uint _amount) internal returns (bool) {
854     TokenInterface allowedToken = allowedTokens[_tokenAddress];
855     allowedToken.transferFrom(_beneficiary, address(this), _amount);
856     altDeposit[_tokenAddress][_beneficiary] = _amount;
857     return true;
858   }
859 
860   // ██╗   ██╗████████╗██╗██╗     ███████╗
861   // ██║   ██║╚══██╔══╝██║██║     ██╔════╝
862   // ██║   ██║   ██║   ██║██║     ███████╗
863   // ██║   ██║   ██║   ██║██║     ╚════██║
864   // ╚██████╔╝   ██║   ██║███████╗███████║
865   //  ╚═════╝    ╚═╝   ╚═╝╚══════╝╚══════╝
866   function toUint(bytes left) public pure returns (uint) {
867       uint out;
868       for (uint i = 0; i < 32; i++) {
869           out |= uint(left[i]) << (31 * 8 - i * 8);
870       }
871       
872       return out;
873   }
874 }
875 
876 contract BaseAltCrowdsale is Crowdsale {
877   function BaseAltCrowdsale(
878     address _registry,
879     address _token,
880     address _extraTokensHolder,
881     address _wallet,
882     bool _isWhitelisted,
883     uint _price,
884     uint _start,
885     uint _end,
886     uint _softCap,
887     uint _hardCap
888   ) public {
889     setFlags(
890       // Should be whitelisted to buy tokens
891       // _isWhitelisted,
892       _isWhitelisted,
893       // Should be known user to buy tokens
894       // _isKnownOnly,
895       true,
896       // Enable amount bonuses in crowdsale? 
897       // _isAmountBonus,
898       true,
899       // Enable early bird bonus in crowdsale?
900       // _isEarlyBonus,
901       true,
902       // Allow to buy tokens for another tokens?
903       // _isTokenExcange,
904       false,
905       // Allow to issue tokens with tx hash (ex bitcoin)
906       // _isAllowToIssue,
907       true,
908       // Should reject purchases with Ether?
909       // _isDisableEther,
910       false,
911       // Should mint extra tokens for future distribution?
912       // _isExtraDistribution,
913       true,
914       // Will ship token via minting? 
915       // _isTransferShipment,
916       false,
917       // Should be capped in ether
918       // bool _isCappedInEther,
919       true,
920       // Should check personal bonuses?
921       // _isPersonalBonuses
922       true,
923       // Should allow to claimFunds before finalizations?
924       false
925     );
926 
927     setToken(_token); 
928     setTime(_start, _end);
929     setRegistry(_registry);
930     setWallet(_wallet);
931     setExtraDistribution(
932       _extraTokensHolder,
933       6667 // 66.67%
934     );
935 
936     setSoftHardCaps(
937       _softCap, // soft
938       _hardCap  // hard
939     );
940 
941     // 200 ALT per 1 ETH
942     setPrice(_price);
943   }
944 }
945 
946 contract AltCrowdsalePhaseOne is BaseAltCrowdsale {
947   function AltCrowdsalePhaseOne (
948     address _registry,
949     address _token,
950     address _extraTokensHolder,
951     address _wallet
952   )
953   BaseAltCrowdsale(
954     _registry,
955     _token,
956     _extraTokensHolder,
957     _wallet,
958 
959     // Whitelisted
960     false,
961 
962     // price 1 ETH -> 100000 ALT
963     uint(1 ether).div(100000),
964 
965     // start - 13 Apr 2018 12:18:33 GMT
966     1523621913,
967     // end - 30 Jun 2018 23:59:59 GMT
968     1530403199,
969 
970     // _softCap,
971     2500 ether,
972     // _hardCap
973     7500 ether
974   )
975   public {
976   }
977 }