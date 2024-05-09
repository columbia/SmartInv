1 pragma solidity ^0.4.19;
2 
3 
4 contract Owned
5 {
6     address public owner;
7 
8     modifier onlyOwner
9 	{
10         require(msg.sender == owner);
11         _;
12     }
13 
14     function transferOwnership(address newOwner) public onlyOwner()
15 	{
16         owner = newOwner;
17     }
18 }
19 
20 contract Agricoin is Owned
21 {
22     // Dividends payout struct.
23     struct DividendPayout
24     {
25         uint amount;            // Value of dividend payout.
26         uint momentTotalSupply; // Total supply in payout moment,
27     }
28 
29     // Redemption payout struct.
30     struct RedemptionPayout
31     {
32         uint amount;            // Value of redemption payout.
33         uint momentTotalSupply; // Total supply in payout moment.
34         uint price;             // Price of Agricoin in weis.
35     }
36 
37     // Balance struct with dividends and redemptions record.
38     struct Balance
39     {
40         uint icoBalance;
41         uint balance;                       // Agricoin balance.
42         uint posibleDividends;              // Dividend number, which user can get.
43         uint lastDividensPayoutNumber;      // Last dividend payout index, which user has gotten.
44         uint posibleRedemption;             // Redemption value in weis, which user can use.
45         uint lastRedemptionPayoutNumber;    // Last redemption payout index, which user has used.
46     }
47 
48     // Can act only one from payers.
49     modifier onlyPayer()
50     {
51         require(payers[msg.sender]);
52         _;
53     }
54     
55     // Can act only after token activation.
56     modifier onlyActivated()
57     {
58         require(isActive);
59         _;
60     }
61 
62     // Transfer event.
63     event Transfer(address indexed _from, address indexed _to, uint _value);    
64 
65     // Approve event.
66     event Approval(address indexed _owner, address indexed _spender, uint _value);
67 
68     // Activate event.
69     event Activate(bool icoSuccessful);
70 
71     // DividendPayout dividends event.
72     event PayoutDividends(uint etherAmount, uint indexed id);
73 
74     // DividendPayout redemption event.
75     event PayoutRedemption(uint etherAmount, uint indexed id, uint price);
76 
77     // Get unpaid event.
78     event GetUnpaid(uint etherAmount);
79 
80     // Get dividends.
81     event GetDividends(address indexed investor, uint etherAmount);
82 
83     // Constructor.
84     function Agricoin(uint payout_period_start, uint payout_period_end, address _payer) public
85     {
86         owner = msg.sender;// Save the owner.
87 
88         // Set payout period.
89         payoutPeriodStart = payout_period_start;
90         payoutPeriodEnd = payout_period_end;
91 
92         payers[_payer] = true;
93     }
94 
95     // Activate token.
96 	function activate(bool icoSuccessful) onlyOwner() external returns (bool)
97 	{
98 		require(!isActive);// Check once activation.
99 
100         startDate = now;// Save activation date.
101 		isActive = true;// Make token active.
102 		owner = 0x00;// Set owner to null.
103 		
104         if (icoSuccessful)
105         {
106             isSuccessfulIco = true;
107             totalSupply += totalSupplyOnIco;
108             Activate(true);// Call activation event.
109         }
110         else
111         {
112             Activate(false);// Call activation event.
113         }
114 
115         return true;
116 	}
117 
118     // Add new payer by payer.
119     function addPayer(address payer) onlyPayer() external
120     {
121         payers[payer] = true;
122     }
123 
124     // Get balance of address.
125 	function balanceOf(address owner) public view returns (uint)
126 	{
127 		return balances[owner].balance;
128 	}
129 
130     // Get posible dividends value.
131     function posibleDividendsOf(address owner) public view returns (uint)
132     {
133         return balances[owner].posibleDividends;
134     }
135 
136     // Get posible redemption value.
137     function posibleRedemptionOf(address owner) public view returns (uint)
138     {
139         return balances[owner].posibleRedemption;
140     }
141 
142     // Transfer _value etheres to _to.
143     function transfer(address _to, uint _value) onlyActivated() external returns (bool)
144     {
145         require(balanceOf(msg.sender) >= _value);
146 
147         recalculate(msg.sender);// Recalculate user's struct.
148         
149         if (_to != 0x00)// For normal transfer.
150         {
151             recalculate(_to);// Recalculate recipient's struct.
152 
153             // Change balances.
154             balances[msg.sender].balance -= _value;
155             balances[_to].balance += _value;
156 
157             Transfer(msg.sender, _to, _value);// Call transfer event.
158         }
159         else// For redemption transfer.
160         {
161             require(payoutPeriodStart <= now && now >= payoutPeriodEnd);// Check redemption period.
162             
163             uint amount = _value * redemptionPayouts[amountOfRedemptionPayouts].price;// Calculate amount of weis in redemption.
164 
165             require(amount <= balances[msg.sender].posibleRedemption);// Check redemption limits.
166 
167             // Change user's struct.
168             balances[msg.sender].posibleRedemption -= amount;
169             balances[msg.sender].balance -= _value;
170 
171             totalSupply -= _value;// Decrease total supply.
172 
173             msg.sender.transfer(amount);// Transfer redemption to user.
174 
175             Transfer(msg.sender, _to, _value);// Call transfer event.
176         }
177 
178         return true;
179     }
180 
181     // Transfer from _from to _to _value tokens.
182     function transferFrom(address _from, address _to, uint _value) onlyActivated() external returns (bool)
183     {
184         // Check transfer posibility.
185         require(balances[_from].balance >= _value);
186         require(allowed[_from][msg.sender] >= _value);
187         require(_to != 0x00);
188 
189         // Recalculate structs.
190         recalculate(_from);
191         recalculate(_to);
192 
193         // Change balances.
194         balances[_from].balance -= _value;
195         balances[_to].balance += _value;
196         
197         Transfer(_from, _to, _value);// Call tranfer event.
198         
199         return true;
200     }
201 
202     // Approve for transfers.
203     function approve(address _spender, uint _value) onlyActivated() public returns (bool)
204     {
205         // Recalculate structs.
206         recalculate(msg.sender);
207         recalculate(_spender);
208 
209         allowed[msg.sender][_spender] = _value;// Set allowed.
210         
211         Approval(msg.sender, _spender, _value);// Call approval event.
212         
213         return true;
214     }
215 
216     // Get allowance.
217     function allowance(address _owner, address _spender) onlyActivated() external view returns (uint)
218     {
219         return allowed[_owner][_spender];
220     }
221 
222     // Mint _value tokens to _to address.
223     function mint(address _to, uint _value, bool icoMinting) onlyOwner() external returns (bool)
224     {
225         require(!isActive);// Check no activation.
226 
227         if (icoMinting)
228         {
229             balances[_to].icoBalance += _value;
230             totalSupplyOnIco += _value;
231         }
232         else
233         {
234             balances[_to].balance += _value;// Increase user's balance.
235             totalSupply += _value;// Increase total supply.
236 
237             Transfer(0x00, _to, _value);// Call transfer event.
238         }
239         
240         return true;
241     }
242 
243     // Pay dividends.
244     function payDividends() onlyPayer() onlyActivated() external payable returns (bool)
245     {
246         require(now >= payoutPeriodStart && now <= payoutPeriodEnd);// Check payout period.
247 
248         dividendPayouts[amountOfDividendsPayouts].amount = msg.value;// Set payout amount in weis.
249         dividendPayouts[amountOfDividendsPayouts].momentTotalSupply = totalSupply;// Save total supply on that moment.
250         
251         PayoutDividends(msg.value, amountOfDividendsPayouts);// Call dividend payout event.
252 
253         amountOfDividendsPayouts++;// Increment dividend payouts amount.
254 
255         return true;
256     }
257 
258     // Pay redemption.
259     function payRedemption(uint price) onlyPayer() onlyActivated() external payable returns (bool)
260     {
261         require(now >= payoutPeriodStart && now <= payoutPeriodEnd);// Check payout period.
262 
263         redemptionPayouts[amountOfRedemptionPayouts].amount = msg.value;// Set payout amount in weis.
264         redemptionPayouts[amountOfRedemptionPayouts].momentTotalSupply = totalSupply;// Save total supply on that moment.
265         redemptionPayouts[amountOfRedemptionPayouts].price = price;// Set price of Agricoin in weis at this redemption moment.
266 
267         PayoutRedemption(msg.value, amountOfRedemptionPayouts, price);// Call redemption payout event.
268 
269         amountOfRedemptionPayouts++;// Increment redemption payouts amount.
270 
271         return true;
272     }
273 
274     // Get back unpaid dividends and redemption.
275     function getUnpaid() onlyPayer() onlyActivated() external returns (bool)
276     {
277         require(now >= payoutPeriodEnd);// Check end payout period.
278 
279         GetUnpaid(this.balance);// Call getting unpaid ether event.
280 
281         msg.sender.transfer(this.balance);// Transfer all ethers back to payer.
282 
283         return true;
284     }
285 
286     // Recalculates dividends and redumptions.
287     function recalculate(address user) onlyActivated() public returns (bool)
288     {
289         if (isSuccessfulIco)
290         {
291             if (balances[user].icoBalance != 0)
292             {
293                 balances[user].balance += balances[user].icoBalance;
294                 Transfer(0x00, user, balances[user].icoBalance);
295                 balances[user].icoBalance = 0;
296             }
297         }
298 
299         // Check for necessity of recalculation.
300         if (balances[user].lastDividensPayoutNumber == amountOfDividendsPayouts &&
301             balances[user].lastRedemptionPayoutNumber == amountOfRedemptionPayouts)
302         {
303             return true;
304         }
305 
306         uint addedDividend = 0;
307 
308         // For dividends.
309         for (uint i = balances[user].lastDividensPayoutNumber; i < amountOfDividendsPayouts; i++)
310         {
311             addedDividend += (balances[user].balance * dividendPayouts[i].amount) / dividendPayouts[i].momentTotalSupply;
312         }
313 
314         balances[user].posibleDividends += addedDividend;
315         balances[user].lastDividensPayoutNumber = amountOfDividendsPayouts;
316 
317         uint addedRedemption = 0;
318 
319         // For redemption.
320         for (uint j = balances[user].lastRedemptionPayoutNumber; j < amountOfRedemptionPayouts; j++)
321         {
322             addedRedemption += (balances[user].balance * redemptionPayouts[j].amount) / redemptionPayouts[j].momentTotalSupply;
323         }
324 
325         balances[user].posibleRedemption += addedRedemption;
326         balances[user].lastRedemptionPayoutNumber = amountOfRedemptionPayouts;
327 
328         return true;
329     }
330 
331     // Get dividends.
332     function () external payable
333     {
334         if (payoutPeriodStart >= now && now <= payoutPeriodEnd)// Check payout period.
335         {
336             if (posibleDividendsOf(msg.sender) > 0)// Check posible dividends.
337             {
338                 uint dividendsAmount = posibleDividendsOf(msg.sender);// Get posible dividends amount.
339 
340                 GetDividends(msg.sender, dividendsAmount);// Call getting dividends event.
341 
342                 balances[msg.sender].posibleDividends = 0;// Set balance to zero.
343 
344                 msg.sender.transfer(dividendsAmount);// Transfer dividends amount.
345             }
346         }
347     }
348 
349     // Token name.
350     string public constant name = "Agricoin";
351     
352     // Token market symbol.
353     string public constant symbol = "AGR";
354     
355     // Amount of digits after comma.
356     uint public constant decimals = 2;
357 
358     // Total supply.
359     uint public totalSupply;
360 
361     // Total supply on ICO only;
362     uint public totalSupplyOnIco;
363        
364     // Activation date.
365     uint public startDate;
366     
367     // Payment period start date, setted by ICO contract before activation.
368     uint public payoutPeriodStart;
369     
370     // Payment period last date, setted by ICO contract before activation.
371     uint public payoutPeriodEnd;
372     
373     // Dividends DividendPayout counter.
374     uint public amountOfDividendsPayouts = 0;
375 
376     // Redemption DividendPayout counter.
377     uint public amountOfRedemptionPayouts = 0;
378 
379     // Dividend payouts.
380     mapping (uint => DividendPayout) public dividendPayouts;
381     
382     // Redemption payouts.
383     mapping (uint => RedemptionPayout) public redemptionPayouts;
384 
385     // Dividend and redemption payers.
386     mapping (address => bool) public payers;
387 
388     // Balance records.
389     mapping (address => Balance) public balances;
390 
391     // Allowed balances.
392     mapping (address => mapping (address => uint)) public allowed;
393 
394     // Set true for activating token. If false then token isn't working.
395     bool public isActive = false;
396 
397     // Set true for activate ico minted tokens.
398     bool public isSuccessfulIco = false;
399 }
400 
401 
402 contract Ico is Owned
403 {
404     enum State
405     {
406         Runned,     // Ico is running.
407         Paused,     // Ico was paused.
408         Finished,   // Ico has finished successfully.
409         Expired,    // Ico has finished unsuccessfully.
410         Failed
411     }
412 
413     // Refund event.
414     event Refund(address indexed investor, uint amount);
415 
416     // Investment event.
417     event Invested(address indexed investor, uint amount);
418 
419     // End of ICO event.
420     event End(bool result);
421 
422     // Ico constructor.
423     function Ico(
424         address tokenAddress,       // Agricoin contract address.
425         uint tokenPreIcoPrice,      // Price of Agricoin in weis on Pre-ICO.
426         uint tokenIcoPrice,         // Price of Agricoin in weis on ICO.
427         uint preIcoStart,           // Date of Pre-ICO start.
428         uint preIcoEnd,             // Date of Pre-ICO end.
429         uint icoStart,              // Date of ICO start.
430         uint icoEnd,                // Date of ICO end.
431         uint preIcoEmissionTarget,  // Max number of Agricoins, which will be minted on Pre-ICO.
432         uint icoEmissionTarget,     // Max number of Agricoins, which will be minted on ICO.
433         uint icoSoftCap,
434         address bountyAddress) public
435     {
436         owner = msg.sender;
437         token = tokenAddress;
438         state = State.Runned;
439         
440         // Save prices.
441         preIcoPrice = tokenPreIcoPrice;
442         icoPrice = tokenIcoPrice;
443 
444         // Save dates.
445         startPreIcoDate = preIcoStart;
446         endPreIcoDate = preIcoEnd;
447         startIcoDate = icoStart;
448         endIcoDate = icoEnd;
449 
450         preIcoTarget = preIcoEmissionTarget;
451         icoTarget = icoEmissionTarget;
452         softCap = icoSoftCap;
453 
454         bounty = bountyAddress;
455     }
456 
457     // Returns true if ICO is active now.
458     function isActive() public view returns (bool)
459     {
460         return state == State.Runned;
461     }
462 
463     // Returns true if date in Pre-ICO period.
464     function isRunningPreIco(uint date) public view returns (bool)
465     {
466         return startPreIcoDate <= date && date <= endPreIcoDate;
467     }
468 
469     // Returns true if date in ICO period.
470     function isRunningIco(uint date) public view returns (bool)
471     {
472         return startIcoDate <= date && date <= endIcoDate;
473     }
474 
475     // Fallback payable function.
476     function () external payable
477     {
478         // Initialize variables here.
479         uint value;
480         uint rest;
481         uint amount;
482         
483         if (state == State.Failed)
484         {
485             amount = invested[msg.sender] + investedOnPreIco[msg.sender];// Save amount of invested weis for user.
486             invested[msg.sender] = 0;// Set amount of invested weis to zero.
487             investedOnPreIco[msg.sender] = 0;
488             Refund(msg.sender, amount);// Call refund event.
489             msg.sender.transfer(amount + msg.value);// Returns funds to user.
490             return;
491         }
492 
493         if (state == State.Expired)// Unsuccessful end of ICO.
494         {
495             amount = invested[msg.sender];// Save amount of invested weis for user.
496             invested[msg.sender] = 0;// Set amount of invested weis to zero.
497             Refund(msg.sender, amount);// Call refund event.
498             msg.sender.transfer(amount + msg.value);// Returns funds to user.
499             return;
500         }
501 
502         require(state == State.Runned);// Only for active contract.
503 
504         if (now >= endIcoDate)// After ICO period.
505         {
506             if (Agricoin(token).totalSupply() + Agricoin(token).totalSupplyOnIco() >= softCap)// Minted Agricoin amount above fixed SoftCap.
507             {
508                 state = State.Finished;// Set state to Finished.
509 
510                 // Get Agricoin info for bounty.
511                 uint decimals = Agricoin(token).decimals();
512                 uint supply = Agricoin(token).totalSupply() + Agricoin(token).totalSupplyOnIco();
513                 
514                 // Transfer bounty funds to Bounty contract.
515                 if (supply >= 1500000 * decimals)
516                 {
517                     Agricoin(token).mint(bounty, 300000 * decimals, true);
518                 }
519                 else if (supply >= 1150000 * decimals)
520                 {
521                     Agricoin(token).mint(bounty, 200000 * decimals, true);
522                 }
523                 else if (supply >= 800000 * decimals)
524                 {
525                     Agricoin(token).mint(bounty, 100000 * decimals, true);
526                 }
527                 
528                 Agricoin(token).activate(true);// Activate Agricoin contract.
529                 End(true);// Call successful end event.
530                 msg.sender.transfer(msg.value);// Returns user's funds to user.
531                 return;
532             }
533             else// Unsuccessful end.
534             {
535                 state = State.Expired;// Set state to Expired.
536                 Agricoin(token).activate(false);// Activate Agricoin contract.
537                 msg.sender.transfer(msg.value);// Returns user's funds to user.
538                 End(false);// Call unsuccessful end event.
539                 return;
540             }
541         }
542         else if (isRunningPreIco(now))// During Pre-ICO.
543         {
544             require(investedSumOnPreIco / preIcoPrice < preIcoTarget);// Check for target.
545 
546             if ((investedSumOnPreIco + msg.value) / preIcoPrice >= preIcoTarget)// Check for target with new weis.
547             {
548                 value = preIcoTarget * preIcoPrice - investedSumOnPreIco;// Value of invested weis without change.
549                 require(value != 0);// Check value isn't zero.
550                 investedSumOnPreIco = preIcoTarget * preIcoPrice;// Max posible number of invested weis in to Pre-ICO.
551                 investedOnPreIco[msg.sender] += value;// Increase invested funds by investor.
552                 Invested(msg.sender, value);// Call investment event.
553                 Agricoin(token).mint(msg.sender, value / preIcoPrice, false);// Mint some Agricoins for investor.
554                 msg.sender.transfer(msg.value - value);// Returns change to investor.
555                 return;
556             }
557             else
558             {
559                 rest = msg.value % preIcoPrice;// Calculate rest/change.
560                 require(msg.value - rest >= preIcoPrice);
561                 investedSumOnPreIco += msg.value - rest;
562                 investedOnPreIco[msg.sender] += msg.value - rest;
563                 Invested(msg.sender, msg.value - rest);// Call investment event.
564                 Agricoin(token).mint(msg.sender, msg.value / preIcoPrice, false);// Mint some Agricoins for investor.
565                 msg.sender.transfer(rest);// Returns change to investor.
566                 return;
567             }
568         }
569         else if (isRunningIco(now))// During ICO.
570         {
571             require(investedSumOnIco / icoPrice < icoTarget);// Check for target.
572 
573             if ((investedSumOnIco + msg.value) / icoPrice >= icoTarget)// Check for target with new weis.
574             {
575                 value = icoTarget * icoPrice - investedSumOnIco;// Value of invested weis without change.
576                 require(value != 0);// Check value isn't zero.
577                 investedSumOnIco = icoTarget * icoPrice;// Max posible number of invested weis in to ICO.
578                 invested[msg.sender] += value;// Increase invested funds by investor.
579                 Invested(msg.sender, value);// Call investment event.
580                 Agricoin(token).mint(msg.sender, value / icoPrice, true);// Mint some Agricoins for investor.
581                 msg.sender.transfer(msg.value - value);// Returns change to investor.
582                 return;
583             }
584             else
585             {
586                 rest = msg.value % icoPrice;// Calculate rest/change.
587                 require(msg.value - rest >= icoPrice);
588                 investedSumOnIco += msg.value - rest;
589                 invested[msg.sender] += msg.value - rest;
590                 Invested(msg.sender, msg.value - rest);// Call investment event.
591                 Agricoin(token).mint(msg.sender, msg.value / icoPrice, true);// Mint some Agricoins for investor.
592                 msg.sender.transfer(rest);// Returns change to investor.
593                 return;
594             }
595         }
596         else
597         {
598             revert();
599         }
600     }
601 
602     // Pause contract.
603     function pauseIco() onlyOwner external
604     {
605         require(state == State.Runned);// Only from Runned state.
606         state = State.Paused;// Set state to Paused.
607     }
608 
609     // Continue paused contract.
610     function continueIco() onlyOwner external
611     {
612         require(state == State.Paused);// Only from Paused state.
613         state = State.Runned;// Set state to Runned.
614     }
615 
616     // End contract unsuccessfully.
617     function endIco() onlyOwner external
618     {
619         require(state == State.Paused);// Only from Paused state.
620         state = State.Failed;// Set state to Expired.
621     }
622 
623     // Get invested ethereum.
624     function getEthereum() onlyOwner external returns (uint)
625     {
626         require(state == State.Finished);// Only for successfull ICO.
627         uint amount = this.balance;// Save balance.
628         msg.sender.transfer(amount);// Transfer all funds to owner address.
629         return amount;// Returns amount of transfered weis.
630     }
631 
632     // Get invested ethereum from Pre ICO.
633     function getEthereumFromPreIco() onlyOwner external returns (uint)
634     {
635         require(now >= endPreIcoDate);
636         require(state == State.Runned || state == State.Finished);
637         
638         uint value = investedSumOnPreIco;
639         investedSumOnPreIco = 0;
640         msg.sender.transfer(value);
641         return value;
642     }
643 
644     // Invested balances.
645     mapping (address => uint) invested;
646 
647     mapping (address => uint) investedOnPreIco;
648 
649     // State of contract.
650     State public state;
651 
652     // Agricoin price in weis on Pre-ICO.
653     uint public preIcoPrice;
654 
655     // Agricoin price in weis on ICO.
656     uint public icoPrice;
657 
658     // Date of Pre-ICO start.
659     uint public startPreIcoDate;
660 
661     // Date of Pre-ICO end.
662     uint public endPreIcoDate;
663 
664     // Date of ICO start.
665     uint public startIcoDate;
666 
667     // Date of ICO end.
668     uint public endIcoDate;
669 
670     // Agricoin contract address.
671     address public token;
672 
673     // Bounty contract address.
674     address public bounty;
675 
676     // Invested sum in weis on Pre-ICO.
677     uint public investedSumOnPreIco = 0;
678 
679     // Invested sum in weis on ICO.
680     uint public investedSumOnIco = 0;
681 
682     // Target in tokens minted on Pre-ICo.
683     uint public preIcoTarget;
684 
685     // Target in tokens minted on ICO.
686     uint public icoTarget;
687 
688     // SoftCap fot this ICO.
689     uint public softCap;
690 }