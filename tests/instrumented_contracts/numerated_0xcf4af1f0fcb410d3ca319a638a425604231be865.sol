1 pragma solidity 0.4.20;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         assert(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         assert(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         assert(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         assert(b > 0);
18         c = a / b;
19         assert(a == b * c + a % b);
20     }
21 }
22 
23 contract AcreConfig {
24     using SafeMath for uint;
25     
26     uint internal constant TIME_FACTOR = 1 minutes;
27 
28     // Ownable
29     uint internal constant OWNERSHIP_DURATION_TIME = 7; // 7 days
30     
31     // MultiOwnable
32     uint8 internal constant MULTI_OWNER_COUNT = 5; // 5 accounts, exclude master
33     
34     // Lockable
35     uint internal constant LOCKUP_DURATION_TIME = 365; // 365 days
36     
37     // AcreToken
38     string internal constant TOKEN_NAME            = "TAA";
39     string internal constant TOKEN_SYMBOL          = "TAA";
40     uint8  internal constant TOKEN_DECIMALS        = 18;
41     
42     uint   internal constant INITIAL_SUPPLY        =   1*1e8 * 10 ** uint(TOKEN_DECIMALS); // supply
43     uint   internal constant CAPITAL_SUPPLY        =  31*1e6 * 10 ** uint(TOKEN_DECIMALS); // supply
44     uint   internal constant PRE_PAYMENT_SUPPLY    =  19*1e6 * 10 ** uint(TOKEN_DECIMALS); // supply
45     uint   internal constant MAX_MINING_SUPPLY     =   4*1e8 * 10 ** uint(TOKEN_DECIMALS); // supply
46     
47     // Sale
48     uint internal constant MIN_ETHER               = 1*1e17; // 0.1 ether
49     uint internal constant EXCHANGE_RATE           = 1000;   // 1 eth = 1000 acre
50     uint internal constant PRESALE_DURATION_TIME   = 15;     // 15 days 
51     uint internal constant CROWDSALE_DURATION_TIME = 21;     // 21 days
52     
53     // helper
54     function getDays(uint _time) internal pure returns(uint) {
55         return SafeMath.div(_time, 1 days);
56     }
57     
58     function getHours(uint _time) internal pure returns(uint) {
59         return SafeMath.div(_time, 1 hours);
60     }
61     
62     function getMinutes(uint _time) internal pure returns(uint) {
63         return SafeMath.div(_time, 1 minutes);
64     }
65 }
66 
67 contract Ownable is AcreConfig {
68     address public owner;
69     address public reservedOwner;
70     uint public ownershipDeadline;
71     
72     event ReserveOwnership(address indexed oldOwner, address indexed newOwner);
73     event ConfirmOwnership(address indexed oldOwner, address indexed newOwner);
74     event CancelOwnership(address indexed oldOwner, address indexed newOwner);
75     
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80     
81     function Ownable() public {
82         owner = msg.sender;
83     }
84     
85     function reserveOwnership(address newOwner) onlyOwner public returns (bool success) {
86         require(newOwner != address(0));
87         ReserveOwnership(owner, newOwner);
88         reservedOwner = newOwner;
89 		ownershipDeadline = SafeMath.add(now, SafeMath.mul(OWNERSHIP_DURATION_TIME, TIME_FACTOR));
90         return true;
91     }
92     
93     function confirmOwnership() onlyOwner public returns (bool success) {
94         require(reservedOwner != address(0));
95         require(now > ownershipDeadline);
96         ConfirmOwnership(owner, reservedOwner);
97         owner = reservedOwner;
98         reservedOwner = address(0);
99         return true;
100     }
101     
102     function cancelOwnership() onlyOwner public returns (bool success) {
103         require(reservedOwner != address(0));
104         CancelOwnership(owner, reservedOwner);
105         reservedOwner = address(0);
106         return true;
107     }
108 }
109 
110 contract MultiOwnable is Ownable {
111     address[] public owners;
112     
113     event GrantOwners(address indexed owner);
114     event RevokeOwners(address indexed owner);
115     
116     modifier onlyMutiOwners {
117         require(isExistedOwner(msg.sender));
118         _;
119     }
120     
121     modifier onlyManagers {
122         require(isManageable(msg.sender));
123         _;
124     }
125     
126     function MultiOwnable() public {
127         owners.length = MULTI_OWNER_COUNT;
128     }
129     
130     function grantOwners(address _owner) onlyOwner public returns (bool success) {
131         require(!isExistedOwner(_owner));
132         require(isEmptyOwner());
133         owners[getEmptyIndex()] = _owner;
134         GrantOwners(_owner);
135         return true;
136     }
137 
138     function revokeOwners(address _owner) onlyOwner public returns (bool success) {
139         require(isExistedOwner(_owner));
140         owners[getOwnerIndex(_owner)] = address(0);
141         RevokeOwners(_owner);
142         return true;
143     }
144     
145     // helper
146     function isManageable(address _owner) internal constant returns (bool) {
147         return isExistedOwner(_owner) || owner == _owner;
148     }
149     
150     function isExistedOwner(address _owner) internal constant returns (bool) {
151         for(uint8 i = 0; i < MULTI_OWNER_COUNT; ++i) {
152             if(owners[i] == _owner) {
153                 return true;
154             }
155         }
156     }
157     
158     function getOwnerIndex(address _owner) internal constant returns (uint) {
159         for(uint8 i = 0; i < MULTI_OWNER_COUNT; ++i) {
160             if(owners[i] == _owner) {
161                 return i;
162             }
163         }
164     }
165     
166     function isEmptyOwner() internal constant returns (bool) {
167         for(uint8 i = 0; i < MULTI_OWNER_COUNT; ++i) {
168             if(owners[i] == address(0)) {
169                 return true;
170             }
171         }
172     }
173     
174     function getEmptyIndex() internal constant returns (uint) {
175         for(uint8 i = 0; i < MULTI_OWNER_COUNT; ++i) {
176             if(owners[i] == address(0)) {
177                 return i;
178             }
179         }
180     }
181 }
182 
183 contract Pausable is MultiOwnable {
184     bool public paused = false;
185     
186     event Pause();
187     event Unpause();
188     
189     modifier whenNotPaused() {
190         require(!paused);
191         _;
192     }
193     
194     modifier whenPaused() {
195         require(paused);
196         _;
197     }
198     
199     modifier whenConditionalPassing() {
200         if(!isManageable(msg.sender)) {
201             require(!paused);
202         }
203         _;
204     }
205     
206     function pause() onlyManagers whenNotPaused public returns (bool success) {
207         paused = true;
208         Pause();
209         return true;
210     }
211   
212     function unpause() onlyManagers whenPaused public returns (bool success) {
213         paused = false;
214         Unpause();
215         return true;
216     }
217 }
218 
219 contract Lockable is Pausable {
220     mapping (address => uint) public locked;
221     
222     event Lockup(address indexed target, uint startTime, uint deadline);
223     
224     function lockup(address _target) onlyOwner public returns (bool success) {
225 	    require(!isManageable(_target));
226         locked[_target] = SafeMath.add(now, SafeMath.mul(LOCKUP_DURATION_TIME, TIME_FACTOR));
227         Lockup(_target, now, locked[_target]);
228         return true;
229     }
230     
231     // helper
232     function isLockup(address _target) internal constant returns (bool) {
233         if(now <= locked[_target])
234             return true;
235     }
236 }
237 
238 interface tokenRecipient { 
239     function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; 
240 }
241 
242 contract TokenERC20 {
243     using SafeMath for uint;
244     
245     string public name;
246     string public symbol;
247     uint8 public decimals;
248     
249     uint public totalSupply;
250     mapping (address => uint) public balanceOf;
251     mapping (address => mapping (address => uint)) public allowance;
252 
253     event ERC20Token(address indexed owner, string name, string symbol, uint8 decimals, uint supply);
254     event Transfer(address indexed from, address indexed to, uint value);
255     event TransferFrom(address indexed from, address indexed to, address indexed spender, uint value);
256     event Approval(address indexed owner, address indexed spender, uint value);
257     
258     function TokenERC20(
259         string _tokenName,
260         string _tokenSymbol,
261         uint8 _tokenDecimals,
262         uint _initialSupply
263     ) public {
264         name = _tokenName;
265         symbol = _tokenSymbol;
266         decimals = _tokenDecimals;
267         
268         totalSupply = _initialSupply;
269         balanceOf[msg.sender] = totalSupply;
270         
271         ERC20Token(msg.sender, name, symbol, decimals, totalSupply);
272     }
273 
274     function _transfer(address _from, address _to, uint _value) internal returns (bool success) {
275         require(_to != address(0));
276         require(balanceOf[_from] >= _value);
277         require(SafeMath.add(balanceOf[_to], _value) > balanceOf[_to]);
278         uint previousBalances = SafeMath.add(balanceOf[_from], balanceOf[_to]);
279         balanceOf[_from] = balanceOf[_from].sub(_value);
280         balanceOf[_to] = balanceOf[_to].add(_value);
281         Transfer(_from, _to, _value);
282         assert(SafeMath.add(balanceOf[_from], balanceOf[_to]) == previousBalances);
283         return true;
284     }
285     
286     function transfer(address _to, uint _value) public returns (bool success) {
287         return _transfer(msg.sender, _to, _value);
288     }
289 
290     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
291         require(_value <= allowance[_from][msg.sender]);     
292         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
293         _transfer(_from, _to, _value);
294         TransferFrom(_from, _to, msg.sender, _value);
295         return true;
296     }
297 
298     function approve(address _spender, uint _value) public returns (bool success) {
299         allowance[msg.sender][_spender] = _value;
300         Approval(msg.sender, _spender, _value);
301         return true;
302     }
303 
304     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns (bool success) {
305         tokenRecipient spender = tokenRecipient(_spender);
306         if (approve(_spender, _value)) {
307             spender.receiveApproval(msg.sender, _value, this, _extraData);
308             return true;
309         }
310     }
311 }
312 
313 contract AcreToken is Lockable, TokenERC20 {
314     string public version = '1.0';
315     
316     address public companyCapital;
317     address public prePayment;
318     
319     uint public totalMineSupply;
320     mapping (address => bool) public frozenAccount;
321 
322     event FrozenAccount(address indexed target, bool frozen);
323     event Burn(address indexed owner, uint value);
324     event Mining(address indexed recipient, uint value);
325     event WithdrawContractToken(address indexed owner, uint value);
326     
327     function AcreToken(address _companyCapital, address _prePayment) TokenERC20(TOKEN_NAME, TOKEN_SYMBOL, TOKEN_DECIMALS, INITIAL_SUPPLY) public {
328         require(_companyCapital != address(0));
329         require(_prePayment != address(0));
330         companyCapital = _companyCapital;
331         prePayment = _prePayment;
332         transfer(companyCapital, CAPITAL_SUPPLY);
333         transfer(prePayment, PRE_PAYMENT_SUPPLY);
334         lockup(prePayment);
335         pause(); 
336     }
337 
338     function _transfer(address _from, address _to, uint _value) whenConditionalPassing internal returns (bool success) {
339         require(!frozenAccount[_from]); // freeze                     
340         require(!frozenAccount[_to]);
341         require(!isLockup(_from));      // lockup
342         require(!isLockup(_to));
343         return super._transfer(_from, _to, _value);
344     }
345     
346     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
347         require(!frozenAccount[msg.sender]); // freeze
348         require(!isLockup(msg.sender));      // lockup
349         return super.transferFrom(_from, _to, _value);
350     }
351     
352     function freezeAccount(address _target) onlyManagers public returns (bool success) {
353         require(!isManageable(_target));
354         require(!frozenAccount[_target]);
355         frozenAccount[_target] = true;
356         FrozenAccount(_target, true);
357         return true;
358     }
359     
360     function unfreezeAccount(address _target) onlyManagers public returns (bool success) {
361         require(frozenAccount[_target]);
362         frozenAccount[_target] = false;
363         FrozenAccount(_target, false);
364         return true;
365     }
366     
367     function burn(uint _value) onlyManagers public returns (bool success) {
368         require(balanceOf[msg.sender] >= _value);   
369         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            
370         totalSupply = totalSupply.sub(_value);                      
371         Burn(msg.sender, _value);
372         return true;
373     }
374     
375     function mining(address _recipient, uint _value) onlyManagers public returns (bool success) {
376         require(_recipient != address(0));
377         require(!frozenAccount[_recipient]); // freeze
378         require(!isLockup(_recipient));      // lockup
379         require(SafeMath.add(totalMineSupply, _value) <= MAX_MINING_SUPPLY);
380         balanceOf[_recipient] = balanceOf[_recipient].add(_value);
381         totalSupply = totalSupply.add(_value);
382         totalMineSupply = totalMineSupply.add(_value);
383         Mining(_recipient, _value);
384         return true;
385     }
386     
387     function withdrawContractToken(uint _value) onlyManagers public returns (bool success) {
388         _transfer(this, msg.sender, _value);
389         WithdrawContractToken(msg.sender, _value);
390         return true;
391     }
392     
393     function getContractBalanceOf() public constant returns(uint blance) {
394         blance = balanceOf[this];
395     }
396     
397     function getRemainingMineSupply() public constant returns(uint supply) {
398         supply = MAX_MINING_SUPPLY - totalMineSupply;
399     }
400     
401     function () public { revert(); }
402 }
403 
404 contract AcreSale is MultiOwnable {
405     uint public saleDeadline;
406     uint public startSaleTime;
407     uint public softCapToken;
408     uint public hardCapToken;
409     uint public soldToken;
410     uint public receivedEther;
411     address public sendEther;
412     AcreToken public tokenReward;
413     bool public fundingGoalReached = false;
414     bool public saleOpened = false;
415     
416     Payment public kyc;
417     Payment public refund;
418     Payment public withdrawal;
419 
420     mapping(uint=>address) public indexedFunders;
421     mapping(address => Order) public orders;
422     uint public funderCount;
423     
424     event StartSale(uint softCapToken, uint hardCapToken, uint minEther, uint exchangeRate, uint startTime, uint deadline);
425     event ReservedToken(address indexed funder, uint amount, uint token, uint bonusRate);
426     event WithdrawFunder(address indexed funder, uint value);
427     event WithdrawContractToken(address indexed owner, uint value);
428     event CheckGoalReached(uint raisedAmount, uint raisedToken, bool reached);
429     event CheckOrderstate(address indexed funder, eOrderstate oldState, eOrderstate newState);
430     
431     enum eOrderstate { NONE, KYC, REFUND }
432     
433     struct Order {
434         eOrderstate state;
435         uint paymentEther;
436         uint reservedToken;
437         bool withdrawn;
438     }
439     
440     struct Payment {
441         uint token;
442         uint eth;
443         uint count;
444     }
445 
446     modifier afterSaleDeadline { 
447         require(now > saleDeadline); 
448         _; 
449     }
450     
451     function AcreSale(
452         address _sendEther,
453         uint _softCapToken,
454         uint _hardCapToken,
455         AcreToken _addressOfTokenUsedAsReward
456     ) public {
457         require(_sendEther != address(0));
458         require(_addressOfTokenUsedAsReward != address(0));
459         require(_softCapToken > 0 && _softCapToken <= _hardCapToken);
460         sendEther = _sendEther;
461         softCapToken = _softCapToken * 10 ** uint(TOKEN_DECIMALS);
462         hardCapToken = _hardCapToken * 10 ** uint(TOKEN_DECIMALS);
463         tokenReward = AcreToken(_addressOfTokenUsedAsReward);
464     }
465     
466     function startSale(uint _durationTime) onlyManagers internal {
467         require(softCapToken > 0 && softCapToken <= hardCapToken);
468         require(hardCapToken > 0 && hardCapToken <= tokenReward.balanceOf(this));
469         require(_durationTime > 0);
470         require(startSaleTime == 0);
471 
472         startSaleTime = now;
473         saleDeadline = SafeMath.add(startSaleTime, SafeMath.mul(_durationTime, TIME_FACTOR));
474         saleOpened = true;
475         
476         StartSale(softCapToken, hardCapToken, MIN_ETHER, EXCHANGE_RATE, startSaleTime, saleDeadline);
477     }
478     
479     // get
480     function getRemainingSellingTime() public constant returns(uint remainingTime) {
481         if(now <= saleDeadline) {
482             remainingTime = getMinutes(SafeMath.sub(saleDeadline, now));
483         }
484     }
485     
486     function getRemainingSellingToken() public constant returns(uint remainingToken) {
487         remainingToken = SafeMath.sub(hardCapToken, soldToken);
488     }
489     
490     function getSoftcapReached() public constant returns(bool reachedSoftcap) {
491         reachedSoftcap = soldToken >= softCapToken;
492     }
493     
494     function getContractBalanceOf() public constant returns(uint blance) {
495         blance = tokenReward.balanceOf(this);
496     }
497     
498     function getCurrentBonusRate() public constant returns(uint8 bonusRate);
499     
500     // check
501     function checkGoalReached() onlyManagers afterSaleDeadline public {
502         if(saleOpened) {
503             if(getSoftcapReached()) {
504                 fundingGoalReached = true;
505             }
506             saleOpened = false;
507             CheckGoalReached(receivedEther, soldToken, fundingGoalReached);
508         }
509     }
510     
511     function checkKYC(address _funder) onlyManagers afterSaleDeadline public {
512         require(!saleOpened);
513         require(orders[_funder].reservedToken > 0);
514         require(orders[_funder].state != eOrderstate.KYC);
515         require(!orders[_funder].withdrawn);
516         
517         eOrderstate oldState = orders[_funder].state;
518         
519         // old, decrease
520         if(oldState == eOrderstate.REFUND) {
521             refund.token = refund.token.sub(orders[_funder].reservedToken);
522             refund.eth   = refund.eth.sub(orders[_funder].paymentEther);
523             refund.count = refund.count.sub(1);
524         }
525         
526         // state
527         orders[_funder].state = eOrderstate.KYC;
528         kyc.token = kyc.token.add(orders[_funder].reservedToken);
529         kyc.eth   = kyc.eth.add(orders[_funder].paymentEther);
530         kyc.count = kyc.count.add(1);
531         CheckOrderstate(_funder, oldState, eOrderstate.KYC);
532     }
533     
534     function checkRefund(address _funder) onlyManagers afterSaleDeadline public {
535         require(!saleOpened);
536         require(orders[_funder].reservedToken > 0);
537         require(orders[_funder].state != eOrderstate.REFUND);
538         require(!orders[_funder].withdrawn);
539         
540         eOrderstate oldState = orders[_funder].state;
541         
542         // old, decrease
543         if(oldState == eOrderstate.KYC) {
544             kyc.token = kyc.token.sub(orders[_funder].reservedToken);
545             kyc.eth   = kyc.eth.sub(orders[_funder].paymentEther);
546             kyc.count = kyc.count.sub(1);
547         }
548         
549         // state
550         orders[_funder].state = eOrderstate.REFUND;
551         refund.token = refund.token.add(orders[_funder].reservedToken);
552         refund.eth   = refund.eth.add(orders[_funder].paymentEther);
553         refund.count = refund.count.add(1);
554         CheckOrderstate(_funder, oldState, eOrderstate.REFUND);
555     }
556     
557     // withdraw
558     function withdrawFunder(address _funder) onlyManagers afterSaleDeadline public {
559         require(!saleOpened);
560         require(fundingGoalReached);
561         require(orders[_funder].reservedToken > 0);
562         require(orders[_funder].state == eOrderstate.KYC);
563         require(!orders[_funder].withdrawn);
564         
565         // token
566         tokenReward.transfer(_funder, orders[_funder].reservedToken);
567         withdrawal.token = withdrawal.token.add(orders[_funder].reservedToken);
568         withdrawal.eth   = withdrawal.eth.add(orders[_funder].paymentEther);
569         withdrawal.count = withdrawal.count.add(1);
570         orders[_funder].withdrawn = true;
571         WithdrawFunder(_funder, orders[_funder].reservedToken);
572     }
573     
574     function withdrawContractToken(uint _value) onlyManagers public {
575         tokenReward.transfer(msg.sender, _value);
576         WithdrawContractToken(msg.sender, _value);
577     }
578     
579     // payable
580     function () payable public {
581         require(saleOpened);
582         require(now <= saleDeadline);
583         require(MIN_ETHER <= msg.value);
584         
585         uint amount = msg.value;
586         uint curBonusRate = getCurrentBonusRate();
587         uint token = (amount.mul(curBonusRate.add(100)).div(100)).mul(EXCHANGE_RATE);
588         
589         require(token > 0);
590         require(SafeMath.add(soldToken, token) <= hardCapToken);
591         
592         sendEther.transfer(amount);
593         
594         // funder info
595         if(orders[msg.sender].paymentEther == 0) {
596             indexedFunders[funderCount] = msg.sender;
597             funderCount = funderCount.add(1);
598             orders[msg.sender].state = eOrderstate.NONE;
599         }
600         
601         orders[msg.sender].paymentEther = orders[msg.sender].paymentEther.add(amount);
602         orders[msg.sender].reservedToken = orders[msg.sender].reservedToken.add(token);
603         receivedEther = receivedEther.add(amount);
604         soldToken = soldToken.add(token);
605         
606         ReservedToken(msg.sender, amount, token, curBonusRate);
607     }
608 }
609 
610 contract AcrePresale is AcreSale {
611     function AcrePresale(
612         address _sendEther,
613         uint _softCapToken,
614         uint _hardCapToken,
615         AcreToken _addressOfTokenUsedAsReward
616     ) AcreSale(
617         _sendEther,
618         _softCapToken, 
619         _hardCapToken, 
620         _addressOfTokenUsedAsReward) public {
621     }
622     
623     function startPresale() onlyManagers public {
624         startSale(PRESALE_DURATION_TIME);
625     }
626     
627     function getCurrentBonusRate() public constant returns(uint8 bonusRate) {
628         if      (now <= SafeMath.add(startSaleTime, SafeMath.mul( 7, TIME_FACTOR))) { bonusRate = 30; } // 7days  
629         else if (now <= SafeMath.add(startSaleTime, SafeMath.mul(15, TIME_FACTOR))) { bonusRate = 25; } // 8days
630         else                                                                        { bonusRate = 0; }  // 
631     } 
632 }
633 
634 contract AcreCrowdsale is AcreSale {
635     function AcreCrowdsale(
636         address _sendEther,
637         uint _softCapToken,
638         uint _hardCapToken,
639         AcreToken _addressOfTokenUsedAsReward
640     ) AcreSale(
641         _sendEther,
642         _softCapToken, 
643         _hardCapToken, 
644         _addressOfTokenUsedAsReward) public {
645     }
646     
647     function startCrowdsale() onlyManagers public {
648         startSale(CROWDSALE_DURATION_TIME);
649     }
650     
651     function getCurrentBonusRate() public constant returns(uint8 bonusRate) {
652         if      (now <= SafeMath.add(startSaleTime, SafeMath.mul( 7, TIME_FACTOR))) { bonusRate = 20; } // 7days
653         else if (now <= SafeMath.add(startSaleTime, SafeMath.mul(14, TIME_FACTOR))) { bonusRate = 15; } // 7days
654         else if (now <= SafeMath.add(startSaleTime, SafeMath.mul(21, TIME_FACTOR))) { bonusRate = 10; } // 7days
655         else                                                                        { bonusRate = 0; }  // 
656     }
657 }