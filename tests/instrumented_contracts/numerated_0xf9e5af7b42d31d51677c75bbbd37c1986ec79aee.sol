1 pragma solidity 0.4.24;
2 
3 
4 library SafeMath {
5 
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7         if (a == 0) {
8             return 0;
9         }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26     
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28 
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 // source : https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
37 contract ERC20 {
38     function totalSupply() public view returns (uint);
39     function balanceOf(address tokenOwner) public view returns (uint balance);
40     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
41     function transfer(address to, uint tokens) public returns (bool success);
42     function approve(address spender, uint tokens) public returns (bool success);
43     function transferFrom(address from, address to, uint tokens) public returns (bool success);
44 
45     event Transfer(address indexed from, address indexed to, uint tokens);
46     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 
50 contract QuickxToken is ERC20 {
51     using SafeMath for uint;
52 
53 
54     // ------------------------------------------------------------------------
55     //            EVENTS
56     // ------------------------------------------------------------------------
57     event LogBurn(address indexed from, uint256 amount);
58     event LogFreezed(address targetAddress, bool frozen);
59     event LogEmerygencyFreezed(bool emergencyFreezeStatus);
60 
61     // ------------------------------------------------------------------------
62     //          STATE VARIABLES
63     // ------------------------------------------------------------------------
64     string public name = "QuickX Protocol";
65     string public symbol = "QCX";
66     uint8 public decimals = 8;
67     address public owner;
68     uint public totalSupply = 500000000 * (10 ** 8);
69     uint public currentSupply = 250000000 * (10 ** 8); // 50% of total supply
70     bool public emergencyFreeze = true;
71   
72     // ------------------------------------------------------------------------
73     //              MAPPINNGS
74     // ------------------------------------------------------------------------
75     mapping (address => uint) internal balances;
76     mapping (address => mapping (address => uint) ) private  allowed;
77     mapping (address => bool) private frozen;
78 
79     // ------------------------------------------------------------------------
80     //              CONSTRUCTOR
81     // ------------------------------------------------------------------------
82     constructor () public {
83         owner = address(0x2cf93Eed42d4D0C0121F99a4AbBF0d838A004F64);
84     }
85 
86     // ------------------------------------------------------------------------
87     //              MODIFIERS
88     // ------------------------------------------------------------------------
89     modifier onlyOwner {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     modifier unfreezed(address _account) { 
95         require(!frozen[_account]);
96         _;  
97     }
98     
99     modifier noEmergencyFreeze() { 
100         require(!emergencyFreeze);
101         _; 
102     }
103 
104     // ------------------------------------------------------------------------
105     // Transfer Token
106     // ------------------------------------------------------------------------
107     function transfer(address _to, uint _value)
108     public
109     unfreezed(_to) 
110     unfreezed(msg.sender) 
111     noEmergencyFreeze()  
112     returns (bool success) {
113         require(_to != 0x0);
114         _transfer(msg.sender, _to, _value);
115         return true;
116     }
117 
118     // ------------------------------------------------------------------------
119     // Approve others to spend on your behalf
120     //  RACE CONDITION HANDLED
121     // ------------------------------------------------------------------------
122     function approve(address _spender, uint _value)
123         public 
124         unfreezed(_spender) 
125         unfreezed(msg.sender) 
126         noEmergencyFreeze() 
127         returns (bool success) {
128             // To change the approve amount you first have to reduce the addresses`
129             //  allowance to zero by calling `approve(_spender, 0)` if it is not
130             //  already 0 to mitigate the race condition described here:
131             //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132             require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133             allowed[msg.sender][_spender] = _value;
134             emit Approval(msg.sender, _spender, _value);
135             return true;
136         }
137 
138     function increaseApproval(address _spender, uint _addedValue)
139         public
140         unfreezed(_spender)
141         unfreezed(msg.sender)
142         noEmergencyFreeze()
143         returns (bool success) {
144             allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
145             emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
146             return true;
147         }
148 
149     function decreaseApproval(address _spender, uint _subtractedValue)
150         public
151         unfreezed(_spender)
152         unfreezed(msg.sender)
153         noEmergencyFreeze()
154         returns (bool success) {
155             uint oldAllowance = allowed[msg.sender][_spender];
156             if (_subtractedValue > oldAllowance) {
157                 allowed[msg.sender][_spender] = 0;
158             } else {
159                 allowed[msg.sender][_spender] = oldAllowance.sub(_subtractedValue);
160             }
161             emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162             return true;
163         }
164 
165     // ------------------------------------------------------------------------
166     // Transferred approved amount from other's account
167     // ------------------------------------------------------------------------
168     function transferFrom(address _from, address _to, uint _value)
169         public 
170         unfreezed(_to)
171         unfreezed(_from) 
172         noEmergencyFreeze() 
173         returns (bool success) {
174             require(_value <= allowed[_from][msg.sender]);
175             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176             _transfer(_from, _to, _value);
177             return true;
178         }
179 
180     // ------------------------------------------------------------------------
181     //               ONLYOWNER METHODS                             
182     // ------------------------------------------------------------------------
183     // ------------------------------------------------------------------------
184     // Freeze account - onlyOwner
185     // ------------------------------------------------------------------------
186     function freezeAccount (address _target, bool _freeze) public onlyOwner {
187         require(_target != 0x0);
188         frozen[_target] = _freeze;
189         emit LogFreezed(_target, _freeze);
190     }
191 
192     // ------------------------------------------------------------------------
193     // Emerygency freeze - onlyOwner
194     // ------------------------------------------------------------------------
195     function emergencyFreezeAllAccounts (bool _freeze) public onlyOwner {
196         emergencyFreeze = _freeze;
197         emit LogEmerygencyFreezed(_freeze);
198     }
199 
200     // ------------------------------------------------------------------------
201     // Burn (Destroy tokens)
202     // ------------------------------------------------------------------------
203     function burn(uint256 _value) public onlyOwner returns (bool success) {
204         require(balances[msg.sender] >= _value);
205         balances[msg.sender] = balances[msg.sender].sub(_value);
206         totalSupply = totalSupply.sub(_value);
207         currentSupply = currentSupply.sub(_value);
208         emit LogBurn(msg.sender, _value);
209         return true;
210     }
211 
212     // ------------------------------------------------------------------------
213     //               CONSTANT METHODS
214     // ------------------------------------------------------------------------
215     // ------------------------------------------------------------------------
216     // Check Balance : Constant
217     // ------------------------------------------------------------------------
218     function balanceOf(address _tokenOwner) public view returns (uint) {
219         return balances[_tokenOwner];
220     }
221 
222     // ------------------------------------------------------------------------
223     // Total supply : Constant
224     // ------------------------------------------------------------------------
225     function totalSupply() public view returns (uint) {
226         return totalSupply;
227     }
228 
229     // ------------------------------------------------------------------------
230     // Check Allowance : Constant
231     // ------------------------------------------------------------------------
232     function allowance(address _tokenOwner, address _spender) public view returns (uint) {
233         return allowed[_tokenOwner][_spender];
234     }
235 
236     // ------------------------------------------------------------------------
237     // Get Freeze Status : Constant
238     // ------------------------------------------------------------------------
239     function isFreezed(address _targetAddress) public view returns (bool) {
240         return frozen[_targetAddress]; 
241     }
242 
243     function _transfer(address from, address to, uint amount) internal {
244         require(balances[from] >= amount);
245         uint balBeforeTransfer = balances[from].add(balances[to]);
246         balances[from] = balances[from].sub(amount);
247         balances[to] = balances[to].add(amount);
248         uint balAfterTransfer = balances[from].add(balances[to]);
249         assert(balBeforeTransfer == balAfterTransfer);
250         emit Transfer(from, to, amount);
251     }
252 }
253 
254 
255 contract QuickxProtocol is QuickxToken {
256     using SafeMath for uint;
257     // ------------------------------------------------------------------------
258     //          STATE VARIABLES  00000000
259     // ------------------------------------------------------------------------
260     // 50% of totail coins will be sold in ico
261     uint public tokenSaleAllocation = 250000000 * (10 ** 8);
262     // 2% of total supply goes for bounty 
263     uint public bountyAllocation = 10000000 * (10 ** 8); 
264     //13% of total tokens is reserved for founders and team
265     uint public founderAllocation =  65000000 * (10 ** 8); 
266     //5% of total tokens is reserved for partners
267     uint public partnersAllocation = 25000000 * (10 ** 8); 
268     // 15% of total tokens is for Liquidity reserve
269     uint public liquidityReserveAllocation = 75000000 * (10 ** 8); 
270     //5% of total tokens is reserved for advisors
271     uint public advisoryAllocation = 25000000 * (10 ** 8); 
272     //10% of total tokens in reserved for pre-seed Inverstors
273     uint public preSeedInvestersAllocation = 50000000 * (10 ** 8); 
274     
275     uint[] public founderFunds = [
276         1300000000000000,
277         2600000000000000, 
278         3900000000000000, 
279         5200000000000000, 
280         6500000000000000
281     ]; // 8 decimals included
282 
283     uint[] public advisoryFunds = [
284         500000000000000, 
285         1000000000000000,
286         1500000000000000, 
287         2000000000000000, 
288         2500000000000000
289     ];
290 
291     uint public founderFundsWithdrawn = 0;
292     uint public advisoryFundsWithdrawn = 0;
293     // check allcatios
294     bool public bountyAllocated;
295     //bool public founderAllocated;
296     bool public partnersAllocated;
297     bool public liquidityReserveAllocated;
298     bool public preSeedInvestersAllocated;
299     
300     uint public icoSuccessfulTime;
301     bool public isIcoSuccessful;
302 
303     address public beneficiary;   // address of hard wallet of admin. 
304 
305     // ico state variables
306     uint private totalRaised = 0;     // total wei raised by ICO
307     uint private totalCoinsSold = 0;   // total coins sold in ICO
308     uint private softCap;             // soft cap target in ether
309     uint private hardCap;             // hard cap target in ether
310     // rate is number of tokens (including decimals) per wei
311     uint private rateNum;              // rate numerator (to avoid fractions) (rate = rateNum/rateDeno)
312     uint private rateDeno;              // rate denominator (to avoid fractions) (rate = rateNum/rateDeno)
313     uint public tokenSaleStart;       // time when token sale starts
314     uint public tokenSaleEnds;        // time when token sale ends
315     bool public icoPaused;            // ICO can be paused anytime
316 
317     // ------------------------------------------------------------------------
318     //                EVENTS
319     // ------------------------------------------------------------------------
320     event LogBontyAllocated(
321         address recepient, 
322         uint amount);
323 
324     event LogPartnersAllocated(
325         address recepient, 
326         uint amount);
327 
328     event LogLiquidityreserveAllocated(
329         address recepient, 
330         uint amount);
331 
332     event LogPreSeedInverstorsAllocated(
333         address recepient,
334         uint amount);
335 
336     event LogAdvisorsAllocated(
337         address recepient, 
338         uint amount);
339 
340     event LogFoundersAllocated(
341         address indexed recepient, 
342         uint indexed amount);
343     
344     // ico events
345     event LogFundingReceived(
346         address indexed addr, 
347         uint indexed weiRecieved, 
348         uint indexed tokenTransferred, 
349         uint currentTotal);
350 
351     event LogRateUpdated(
352         uint rateNum, 
353         uint rateDeno); 
354 
355     event LogPaidToOwner(
356         address indexed beneficiary,
357         uint indexed amountPaid);
358 
359     event LogWithdrawnRemaining(
360         address _owner, 
361         uint amountWithdrawan);
362 
363     event LogIcoEndDateUpdated(
364         uint _oldEndDate, 
365         uint _newEndDate);
366 
367     event LogIcoSuccessful();
368     
369     /* mappings */
370     mapping (address => uint) public contributedAmount; // amount contributed by a user
371 
372     // ------------------------------------------------------------------------
373     //               CONSTRUCTOR
374     // ------------------------------------------------------------------------
375     constructor () public {
376         owner = address(0x2cf93Eed42d4D0C0121F99a4AbBF0d838A004F64);
377         rateNum = 75;
378         rateDeno = 100000000;
379         softCap = 4000  ether;
380         hardCap = 30005019135500000000000  wei;
381         tokenSaleStart = now;
382         tokenSaleEnds = now;
383         balances[this] = currentSupply;
384         isIcoSuccessful = true;
385         icoSuccessfulTime = now;
386         beneficiary = address(0x2cf93Eed42d4D0C0121F99a4AbBF0d838A004F64);
387         emit LogIcoSuccessful();
388         emit Transfer(0x0, address(this), currentSupply);
389     }
390 
391     /* Fallback function */
392     function () public payable {
393         require(msg.data.length == 0);
394         contribute();
395     }
396 
397     modifier isFundRaising() { 
398         require(
399             totalRaised <= hardCap &&
400             now >= tokenSaleStart &&
401             now < tokenSaleEnds &&
402             !icoPaused
403             );
404         _;
405     }
406 
407     // ------------------------------------------------------------------------
408     //                ONLY OWNER METHODS
409     // ------------------------------------------------------------------------
410     function allocateBountyTokens() public onlyOwner {
411         require(isIcoSuccessful && icoSuccessfulTime > 0);
412         require(!bountyAllocated); 
413         balances[owner] = balances[owner].add(bountyAllocation);
414         currentSupply = currentSupply.add(bountyAllocation);
415         bountyAllocated = true;
416         assert(currentSupply <= totalSupply);
417         emit LogBontyAllocated(owner, bountyAllocation);
418         emit Transfer(0x0, owner, bountyAllocation);
419     }
420 
421     function allocatePartnersTokens() public onlyOwner {
422         require(isIcoSuccessful && icoSuccessfulTime > 0);
423         require(!partnersAllocated);
424         balances[owner] = balances[owner].add(partnersAllocation);
425         currentSupply = currentSupply.add(partnersAllocation);
426         partnersAllocated = true;
427         assert(currentSupply <= totalSupply);
428         emit LogPartnersAllocated(owner, partnersAllocation);
429         emit Transfer(0x0, owner, partnersAllocation);
430     }
431 
432     function allocateLiquidityReserveTokens() public onlyOwner {
433         require(isIcoSuccessful && icoSuccessfulTime > 0);
434         require(!liquidityReserveAllocated);
435         balances[owner] = balances[owner].add(liquidityReserveAllocation);
436         currentSupply = currentSupply.add(liquidityReserveAllocation);
437         liquidityReserveAllocated = true;
438         assert(currentSupply <= totalSupply);
439         emit LogLiquidityreserveAllocated(owner, liquidityReserveAllocation);
440         emit Transfer(0x0, owner, liquidityReserveAllocation);
441     }
442 
443     function allocatePreSeedInvesterTokens() public onlyOwner {
444         require(isIcoSuccessful && icoSuccessfulTime > 0);
445         require(!preSeedInvestersAllocated);
446         balances[owner] = balances[owner].add(preSeedInvestersAllocation);
447         currentSupply = currentSupply.add(preSeedInvestersAllocation);
448         preSeedInvestersAllocated = true;
449         assert(currentSupply <= totalSupply);
450         emit LogPreSeedInverstorsAllocated(owner, preSeedInvestersAllocation);
451         emit Transfer(0x0, owner, preSeedInvestersAllocation);
452     }
453 
454     function allocateFounderTokens() public onlyOwner {
455         require(isIcoSuccessful && icoSuccessfulTime > 0);
456         uint calculatedFunds = calculateFoundersTokens();
457         uint eligibleFunds = calculatedFunds.sub(founderFundsWithdrawn);
458         require(eligibleFunds > 0);
459         balances[owner] = balances[owner].add(eligibleFunds);
460         currentSupply = currentSupply.add(eligibleFunds);
461         founderFundsWithdrawn = founderFundsWithdrawn.add(eligibleFunds);
462         assert(currentSupply <= totalSupply);
463         emit LogFoundersAllocated(owner, eligibleFunds);
464         emit Transfer(0x0, owner, eligibleFunds);
465     }
466 
467     function allocateAdvisoryTokens() public onlyOwner {
468         require(isIcoSuccessful && icoSuccessfulTime > 0);
469         uint calculatedFunds = calculateAdvisoryTokens();
470         uint eligibleFunds = calculatedFunds.sub(advisoryFundsWithdrawn);
471         require(eligibleFunds > 0);
472         balances[owner] = balances[owner].add(eligibleFunds);
473         currentSupply = currentSupply.add(eligibleFunds);
474         advisoryFundsWithdrawn = advisoryFundsWithdrawn.add(eligibleFunds);
475         assert(currentSupply <= totalSupply);
476         emit LogAdvisorsAllocated(owner, eligibleFunds);
477         emit Transfer(0x0, owner, eligibleFunds);
478     }
479 
480     // there is no explicit need of this function as funds are directly transferred to owner's hardware wallet.
481     // but this is kept just to avoid any case when ETH is locked in contract
482     function withdrawEth () public onlyOwner {
483         owner.transfer(address(this).balance);
484         emit LogPaidToOwner(owner, address(this).balance);
485     }
486 
487     function updateRate (uint _rateNum, uint _rateDeno) public onlyOwner {
488         rateNum = _rateNum;
489         rateDeno = _rateDeno;
490         emit LogRateUpdated(rateNum, rateDeno);
491     }
492 
493     function updateIcoEndDate(uint _newDate) public onlyOwner {
494         uint oldEndDate = tokenSaleEnds;
495         tokenSaleEnds = _newDate;
496         emit LogIcoEndDateUpdated (oldEndDate, _newDate);
497     }
498 
499     // admin can withdraw token not sold in ICO
500     function withdrawUnsold() public onlyOwner returns (bool) {
501         require(now > tokenSaleEnds);
502         uint unsold = (tokenSaleAllocation.sub(totalCoinsSold));
503         balances[owner] = balances[owner].add(unsold);
504         balances[address(this)] = balances[address(this)].sub(unsold);
505         emit LogWithdrawnRemaining(owner, unsold);
506         emit Transfer(address(this), owner, unsold);
507         return true;
508     }
509 
510     // ------------------------------------------------------------------------
511     // Owner can transfer out any accidentally sent ERC20 tokens
512     // ------------------------------------------------------------------------
513     function transferAnyERC20Token(address _tokenAddress, uint _value) public onlyOwner returns (bool success) {
514         // this condition is to stop admin from withdrawing funds unless all funds of ICO are successfully settelled
515         if (_tokenAddress == address(this)) {
516             require(now > tokenSaleStart + 730 days); // expecting 2 years time, all vested funds will be released.
517         }
518         return ERC20(_tokenAddress).transfer(owner, _value);
519     }
520 
521     function pauseICO(bool pauseStatus) public onlyOwner returns (bool status) {
522         require(icoPaused != pauseStatus);
523         icoPaused = pauseStatus;
524         return true;
525     }
526 
527     // ------------------------------------------------------------------------
528     //               PUBLIC METHODS
529     // ------------------------------------------------------------------------
530     function contribute () public payable isFundRaising returns(bool) {
531         uint calculatedTokens =  calculateTokens(msg.value);
532         require(calculatedTokens > 0);
533         require(totalCoinsSold.add(calculatedTokens) <= tokenSaleAllocation);
534         contributedAmount[msg.sender] = contributedAmount[msg.sender].add(msg.value);
535         totalRaised = totalRaised.add(msg.value);
536         totalCoinsSold = totalCoinsSold.add(calculatedTokens);
537         _transfer(address(this), msg.sender, calculatedTokens);
538         beneficiary.transfer(msg.value);
539         checkIfSoftCapReached();
540         emit LogFundingReceived(msg.sender, msg.value, calculatedTokens, totalRaised);
541         emit LogPaidToOwner(beneficiary, msg.value);
542         return true;
543     }
544 
545     // ------------------------------------------------------------------------
546     //              CONSTANT METHODS
547     // ------------------------------------------------------------------------
548     function calculateTokens(uint weisToTransfer) public view returns(uint) {
549         uint discount = calculateDiscount();
550         uint coins = weisToTransfer.mul(rateNum).mul(discount).div(100 * rateDeno);
551         return coins;
552     }
553 
554     function getTotalWeiRaised () public view returns(uint totalEthRaised) {
555         return totalRaised;
556     }
557 
558     function getTotalCoinsSold() public view returns(uint _coinsSold) {
559         return totalCoinsSold;
560     }
561       
562     function getSoftCap () public view returns(uint _softCap) {
563         return softCap;
564     }
565 
566     function getHardCap () public view returns(uint _hardCap) {
567         return hardCap;
568     }
569 
570     function getContractOwner () public view returns(address contractOwner) {
571         return owner;
572     }
573 
574     function isContractAcceptingPayment() public view returns (bool) {
575         if (totalRaised < hardCap && 
576             now >= tokenSaleStart && 
577             now < tokenSaleEnds && 
578             totalCoinsSold < tokenSaleAllocation)
579             return true;
580         else
581             return false;
582     }
583 
584     // ------------------------------------------------------------------------
585     //                INTERNAL METHODS
586     // ------------------------------------------------------------------------
587     function calculateFoundersTokens() internal view returns(uint) {
588         uint timeAferIcoSuceess = now.sub(icoSuccessfulTime);
589         uint timeSpendInMonths = timeAferIcoSuceess.div(30 days);
590         if (timeSpendInMonths >= 3 && timeSpendInMonths < 6) {
591             return founderFunds[0];
592         } else  if (timeSpendInMonths >= 6 && timeSpendInMonths < 9) {
593             return founderFunds[1];
594         } else if (timeSpendInMonths >= 9 && timeSpendInMonths < 12) {
595             return founderFunds[2];
596         } else if (timeSpendInMonths >= 12 && timeSpendInMonths < 18) {
597             return founderFunds[3];
598         } else if (timeSpendInMonths >= 18) {
599             return founderFunds[4];
600         } else {
601             revert();
602         }
603     } 
604 
605     function calculateAdvisoryTokens()internal view returns(uint) {
606         uint timeSpentAfterIcoEnd = now.sub(icoSuccessfulTime);
607         uint timeSpendInMonths = timeSpentAfterIcoEnd.div(30 days);
608         if (timeSpendInMonths >= 0 && timeSpendInMonths < 3)
609             return advisoryFunds[0];
610         if (timeSpendInMonths < 6)
611             return advisoryFunds[1];
612         if (timeSpendInMonths < 9)
613             return advisoryFunds[2];
614         if (timeSpendInMonths < 12)
615             return advisoryFunds[3];
616         if (timeSpendInMonths >= 12)
617             return advisoryFunds[4];
618         revert();
619     }
620 
621     function checkIfSoftCapReached() internal returns (bool) {
622         if (totalRaised >= softCap && !isIcoSuccessful) {
623             isIcoSuccessful = true;
624             icoSuccessfulTime = now;
625             emit LogIcoSuccessful();
626         }
627         return;
628     }
629 
630     function calculateDiscount() internal view returns(uint) {
631         if (totalCoinsSold < 12500000000000000) {
632             return 115;   // 15 % discount
633         } else if (totalCoinsSold < 18750000000000000) {
634             return 110;   // 10 % discount
635         } else if (totalCoinsSold < 25000000000000000) {
636             return 105;   // 5 % discount
637         } else {  // this case should never arise
638             return 100;   // 0 % discount
639         }
640     }
641 
642 }