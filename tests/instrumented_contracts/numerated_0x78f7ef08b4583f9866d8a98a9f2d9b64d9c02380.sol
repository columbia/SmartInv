1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
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
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 contract Telcoin {
36     using SafeMath for uint256;
37 
38     event Transfer(address indexed _from, address indexed _to, uint _value);
39     event Approval(address indexed _owner, address indexed _spender, uint _value);
40 
41     string public constant name = "Telcoin";
42     string public constant symbol = "TEL";
43     uint8 public constant decimals = 2;
44 
45     /// The ERC20 total fixed supply of tokens.
46     uint256 public constant totalSupply = 100000000000 * (10 ** uint256(decimals));
47 
48     /// Account balances.
49     mapping(address => uint256) balances;
50 
51     /// The transfer allowances.
52     mapping (address => mapping (address => uint256)) internal allowed;
53 
54     /// The initial distributor is responsible for allocating the supply
55     /// into the various pools described in the whitepaper. This can be
56     /// verified later from the event log.
57     function Telcoin(address _distributor) public {
58         balances[_distributor] = totalSupply;
59         Transfer(0x0, _distributor, totalSupply);
60     }
61 
62     /// ERC20 balanceOf().
63     function balanceOf(address _owner) public view returns (uint256) {
64         return balances[_owner];
65     }
66 
67     /// ERC20 transfer().
68     function transfer(address _to, uint256 _value) public returns (bool) {
69         require(_to != address(0));
70         require(_value <= balances[msg.sender]);
71 
72         // SafeMath.sub will throw if there is not enough balance.
73         balances[msg.sender] = balances[msg.sender].sub(_value);
74         balances[_to] = balances[_to].add(_value);
75         Transfer(msg.sender, _to, _value);
76         return true;
77     }
78 
79     /// ERC20 transferFrom().
80     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
81         require(_to != address(0));
82         require(_value <= balances[_from]);
83         require(_value <= allowed[_from][msg.sender]);
84 
85         balances[_from] = balances[_from].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88         Transfer(_from, _to, _value);
89         return true;
90     }
91 
92     /// ERC20 approve(). Comes with the standard caveat that an approval
93     /// meant to limit spending may actually allow more to be spent due to
94     /// unfortunate ordering of transactions. For safety, this method
95     /// should only be called if the current allowance is 0. Alternatively,
96     /// non-ERC20 increaseApproval() and decreaseApproval() can be used.
97     function approve(address _spender, uint256 _value) public returns (bool) {
98         allowed[msg.sender][_spender] = _value;
99         Approval(msg.sender, _spender, _value);
100         return true;
101     }
102 
103     /// ERC20 allowance().
104     function allowance(address _owner, address _spender) public view returns (uint256) {
105         return allowed[_owner][_spender];
106     }
107 
108     /// Not officially ERC20. Allows an allowance to be increased safely.
109     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
110         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
111         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112         return true;
113     }
114 
115     /// Not officially ERC20. Allows an allowance to be decreased safely.
116     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
117         uint oldValue = allowed[msg.sender][_spender];
118         if (_subtractedValue > oldValue) {
119             allowed[msg.sender][_spender] = 0;
120         } else {
121             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
122         }
123         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
124         return true;
125     }
126 }
127 
128 
129 contract TelcoinSaleToken {
130     using SafeMath for uint256;
131 
132     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
133     event Mint(address indexed to, uint256 amount);
134     event MintFinished();
135     event Redeem(address indexed beneficiary, uint256 sacrificedValue, uint256 grantedValue);
136     event Transfer(address indexed from, address indexed to, uint256 value);
137 
138     /// The owner of the contract.
139     address public owner;
140 
141     /// The total number of minted tokens, excluding destroyed tokens.
142     uint256 public totalSupply;
143 
144     /// The token balance and released amount of each address.
145     mapping(address => uint256) balances;
146     mapping(address => uint256) redeemed;
147 
148     /// Whether the token is still mintable.
149     bool public mintingFinished = false;
150 
151     /// Redeemable telcoin.
152     Telcoin telcoin;
153     uint256 public totalRedeemed;
154 
155     /// Vesting period.
156     uint256 vestingStart;
157     uint256 vestingDuration;
158 
159     modifier onlyOwner() {
160         require(msg.sender == owner);
161         _;
162     }
163 
164     function TelcoinSaleToken(
165         Telcoin _telcoin,
166         uint256 _vestingStart,
167         uint256 _vestingDuration
168     )
169         public
170     {
171         owner = msg.sender;
172         telcoin = _telcoin;
173         vestingStart = _vestingStart;
174         vestingDuration = _vestingDuration;
175     }
176 
177     function finishMinting() onlyOwner public returns (bool) {
178         require(!mintingFinished);
179 
180         mintingFinished = true;
181         MintFinished();
182 
183         return true;
184     }
185 
186     function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
187         require(_to != 0x0);
188         require(!mintingFinished);
189         require(_amount > 0);
190 
191         totalSupply = totalSupply.add(_amount);
192         balances[_to] = balances[_to].add(_amount);
193         Mint(_to, _amount);
194         Transfer(0x0, _to, _amount);
195 
196         return true;
197     }
198 
199     function redeemMany(address[] _beneficiaries) public {
200         for (uint256 i = 0; i < _beneficiaries.length; i++) {
201             redeem(_beneficiaries[i]);
202         }
203     }
204 
205     function redeem(address _beneficiary) public returns (uint256) {
206         require(mintingFinished);
207         require(_beneficiary != 0x0);
208 
209         uint256 balance = redeemableBalance(_beneficiary);
210         if (balance == 0) {
211             return 0;
212         }
213 
214         uint256 totalDistributable = telcoin.balanceOf(this).add(totalRedeemed);
215 
216         // Avoid loss of precision by multiplying and later dividing by
217         // a large value.
218         uint256 amount = balance.mul(10 ** 18).div(totalSupply).mul(totalDistributable).div(10 ** 18);
219 
220         balances[_beneficiary] = balances[_beneficiary].sub(balance);
221         redeemed[_beneficiary] = redeemed[_beneficiary].add(balance);
222         balances[telcoin] = balances[telcoin].add(balance);
223         totalRedeemed = totalRedeemed.add(amount);
224 
225         Transfer(_beneficiary, telcoin, balance);
226         Redeem(_beneficiary, balance, amount);
227 
228         telcoin.transfer(_beneficiary, amount);
229 
230         return amount;
231     }
232 
233     function transferOwnership(address _to) onlyOwner public {
234         require(_to != address(0));
235         OwnershipTransferred(owner, _to);
236         owner = _to;
237     }
238 
239     function balanceOf(address _owner) public constant returns (uint256) {
240         return balances[_owner];
241     }
242 
243     function redeemableBalance(address _beneficiary) public constant returns (uint256) {
244         return vestedBalance(_beneficiary).sub(redeemed[_beneficiary]);
245     }
246 
247     function vestedBalance(address _beneficiary) public constant returns (uint256) {
248         uint256 currentBalance = balances[_beneficiary];
249         uint256 totalBalance = currentBalance.add(redeemed[_beneficiary]);
250 
251         if (now < vestingStart) {
252             return 0;
253         }
254 
255         if (now >= vestingStart.add(vestingDuration)) {
256             return totalBalance;
257         }
258 
259         return totalBalance.mul(now.sub(vestingStart)).div(vestingDuration);
260     }
261 }
262 
263 
264 contract TelcoinSale {
265     using SafeMath for uint256;
266 
267     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
268     event WalletChanged(address indexed previousWallet, address indexed newWallet);
269     event TokenPurchase(
270         address indexed purchaser,
271         address indexed beneficiary,
272         uint256 value,
273         uint256 amount,
274         uint256 bonusAmount
275     );
276     event TokenAltPurchase(
277         address indexed purchaser,
278         address indexed beneficiary,
279         uint256 value,
280         uint256 amount,
281         uint256 bonusAmount,
282         string symbol,
283         string transactionId
284     );
285     event Pause();
286     event Unpause();
287     event Withdrawal(address indexed wallet, uint256 weiAmount);
288     event Extended(uint256 until);
289     event Finalized();
290     event Refunding();
291     event Refunded(address indexed beneficiary, uint256 weiAmount);
292     event Whitelisted(
293         address indexed participant,
294         uint256 minWeiAmount,
295         uint256 maxWeiAmount,
296         uint32 bonusRate
297     );
298     event CapFlexed(uint32 flex);
299 
300     /// The owner of the contract.
301     address public owner;
302 
303     /// The temporary token we're selling. Sale tokens can be converted
304     /// immediately upon successful completion of the sale. Bonus tokens
305     /// are on a separate vesting schedule.
306     TelcoinSaleToken public saleToken;
307     TelcoinSaleToken public bonusToken;
308 
309     /// The token we'll convert to after the sale ends.
310     Telcoin public telcoin;
311 
312     /// The minimum and maximum goals to reach. If the soft cap is not reached
313     /// by the end of the sale, the contract will enter refund mode. If the
314     /// hard cap is reached, the contract can be finished early.
315     ///
316     /// Due to our actual soft cap being tied to USD and the assumption that
317     /// the value of Ether will continue to increase during the ICO, we
318     /// implement a fixed minimum softcap that accounts for a 2.5x value
319     /// increase. The capFlex is a scale factor that allows us to scale the
320     /// caps above the fixed minimum values. Initially the scale factor will
321     /// be set so that our effective soft cap is ~10M USD.
322     uint256 public softCap;
323     uint256 public hardCap;
324     uint32 public capFlex;
325 
326     /// The sale period.
327     uint256 public startTime;
328     uint256 public endTime;
329     uint256 public timeExtension;
330 
331     /// The numnber of tokens to mint per wei.
332     uint256 public rate;
333 
334     /// The total number of wei raised. Note that the contract's balance may
335     /// differ from this value if someone has decided to forcefully send us
336     /// ether.
337     uint256 public weiRaised;
338 
339     /// The wallet that will receive the contract's balance once the sale
340     /// finishes and the soft cap is reached.
341     address public wallet;
342 
343     /// The list of addresses that are allowed to participate in the sale,
344     /// up to what amount, and any special rate they may have, provided
345     /// that they do in fact participate with at least the minimum value
346     /// they agreed to.
347     mapping(address => uint256) public whitelistedMin;
348     mapping(address => uint256) public whitelistedMax;
349     mapping(address => uint32) public bonusRates;
350 
351     /// The amount of wei and wei equivalents invested by each investor.
352     mapping(address => uint256) public deposited;
353     mapping(address => uint256) public altDeposited;
354 
355     /// An enumerable list of investors.
356     address[] public investors;
357 
358     /// Whether the sale is paused.
359     bool public paused = false;
360 
361     /// Whether the sale has finished, and when.
362     bool public finished = false;
363     uint256 public finishedAt;
364 
365     /// Whether we're accepting refunds.
366     bool public refunding = false;
367 
368     /// The total number of wei refunded.
369     uint256 public weiRefunded;
370 
371     modifier onlyOwner() {
372         require(msg.sender == owner);
373         _;
374     }
375 
376     modifier saleOpen() {
377         require(!finished);
378         require(!paused);
379         require(now >= startTime);
380         require(now <= endTime + timeExtension);
381         _;
382     }
383 
384     function TelcoinSale(
385         uint256 _softCap,
386         uint256 _hardCap,
387         uint32 _capFlex,
388         uint256 _startTime,
389         uint256 _endTime,
390         uint256 _rate,
391         address _wallet,
392         Telcoin _telcoin,
393         uint256 _bonusVestingStart,
394         uint256 _bonusVestingDuration
395     )
396         public
397         payable
398     {
399         require(msg.value > 0);
400         require(_softCap > 0);
401         require(_hardCap >= _softCap);
402         require(_startTime >= now);
403         require(_endTime >= _startTime);
404         require(_rate > 0);
405         require(_wallet != 0x0);
406 
407         owner = msg.sender;
408         softCap = _softCap;
409         hardCap = _hardCap;
410         capFlex = _capFlex;
411         startTime = _startTime;
412         endTime = _endTime;
413         rate = _rate;
414         wallet = _wallet;
415         telcoin = _telcoin;
416 
417         saleToken = new TelcoinSaleToken(telcoin, 0, 0);
418         bonusToken = new TelcoinSaleToken(
419             telcoin,
420             _bonusVestingStart,
421             _bonusVestingDuration
422         );
423 
424         wallet.transfer(msg.value);
425     }
426 
427     function () public payable {
428         buyTokens(msg.sender);
429     }
430 
431     function buyTokens(address _beneficiary) saleOpen public payable {
432         require(_beneficiary != address(0));
433 
434         uint256 weiAmount = msg.value;
435         require(weiAmount > 0);
436         require(weiRaised.add(weiAmount) <= hardCap);
437 
438         uint256 totalPrior = totalDeposited(_beneficiary);
439         uint256 totalAfter = totalPrior.add(weiAmount);
440         require(totalAfter <= whitelistedMax[_beneficiary]);
441 
442         uint256 saleTokens;
443         uint256 bonusTokens;
444 
445         (saleTokens, bonusTokens) = tokensForPurchase(_beneficiary, weiAmount);
446 
447         uint256 newDeposited = deposited[_beneficiary].add(weiAmount);
448         deposited[_beneficiary] = newDeposited;
449         investors.push(_beneficiary);
450 
451         weiRaised = weiRaised.add(weiAmount);
452 
453         saleToken.mint(_beneficiary, saleTokens);
454         if (bonusTokens > 0) {
455             bonusToken.mint(_beneficiary, bonusTokens);
456         }
457 
458         TokenPurchase(
459             msg.sender,
460             _beneficiary,
461             weiAmount,
462             saleTokens,
463             bonusTokens
464         );
465     }
466 
467     function changeWallet(address _wallet) onlyOwner public payable {
468         require(_wallet != 0x0);
469         require(msg.value > 0);
470 
471         WalletChanged(wallet, _wallet);
472         wallet = _wallet;
473 
474         wallet.transfer(msg.value);
475     }
476 
477     function extendTime(uint256 _timeExtension) onlyOwner public {
478         require(!finished);
479         require(now < endTime + timeExtension);
480         require(_timeExtension > 0);
481 
482         timeExtension = timeExtension.add(_timeExtension);
483         require(timeExtension <= 7 days);
484 
485         Extended(endTime.add(timeExtension));
486     }
487 
488     function finish() onlyOwner public {
489         require(!finished);
490         require(hardCapReached() || now > endTime + timeExtension);
491 
492         finished = true;
493         finishedAt = now;
494         saleToken.finishMinting();
495         bonusToken.finishMinting();
496 
497         uint256 distributableCoins = telcoin.balanceOf(this);
498 
499         if (softCapReached()) {
500             uint256 saleTokens = saleToken.totalSupply();
501             uint256 bonusTokens = bonusToken.totalSupply();
502             uint256 totalTokens = saleTokens.add(bonusTokens);
503 
504             // Avoid loss of precision by multiplying and later dividing by
505             // a large value.
506             uint256 bonusPortion = bonusTokens.mul(10 ** 18).div(totalTokens).mul(distributableCoins).div(10 ** 18);
507             uint256 salePortion = distributableCoins.sub(bonusPortion);
508 
509             saleToken.transferOwnership(owner);
510             bonusToken.transferOwnership(owner);
511 
512             telcoin.transfer(saleToken, salePortion);
513             telcoin.transfer(bonusToken, bonusPortion);
514 
515             withdraw();
516         } else {
517             refunding = true;
518             telcoin.transfer(wallet, distributableCoins);
519             Refunding();
520         }
521 
522         Finalized();
523     }
524 
525     function pause() onlyOwner public {
526         require(!paused);
527         paused = true;
528         Pause();
529     }
530 
531     function refundMany(address[] _investors) public {
532         for (uint256 i = 0; i < _investors.length; i++) {
533             refund(_investors[i]);
534         }
535     }
536 
537     function refund(address _investor) public {
538         require(finished);
539         require(refunding);
540         require(deposited[_investor] > 0);
541 
542         uint256 weiAmount = deposited[_investor];
543         deposited[_investor] = 0;
544         weiRefunded = weiRefunded.add(weiAmount);
545         Refunded(_investor, weiAmount);
546 
547         _investor.transfer(weiAmount);
548     }
549 
550     function registerAltPurchase(
551         address _beneficiary,
552         string _symbol,
553         string _transactionId,
554         uint256 _weiAmount
555     )
556         saleOpen
557         onlyOwner
558         public
559     {
560         require(_beneficiary != address(0));
561         require(totalDeposited(_beneficiary).add(_weiAmount) <= whitelistedMax[_beneficiary]);
562 
563         uint256 saleTokens;
564         uint256 bonusTokens;
565 
566         (saleTokens, bonusTokens) = tokensForPurchase(_beneficiary, _weiAmount);
567 
568         uint256 newAltDeposited = altDeposited[_beneficiary].add(_weiAmount);
569         altDeposited[_beneficiary] = newAltDeposited;
570         investors.push(_beneficiary);
571 
572         weiRaised = weiRaised.add(_weiAmount);
573 
574         saleToken.mint(_beneficiary, saleTokens);
575         if (bonusTokens > 0) {
576             bonusToken.mint(_beneficiary, bonusTokens);
577         }
578 
579         TokenAltPurchase(
580             msg.sender,
581             _beneficiary,
582             _weiAmount,
583             saleTokens,
584             bonusTokens,
585             _symbol,
586             _transactionId
587         );
588     }
589 
590     function transferOwnership(address _to) onlyOwner public {
591         require(_to != address(0));
592         OwnershipTransferred(owner, _to);
593         owner = _to;
594     }
595 
596     function unpause() onlyOwner public {
597         require(paused);
598         paused = false;
599         Unpause();
600     }
601 
602     function updateCapFlex(uint32 _capFlex) onlyOwner public {
603         require(!finished);
604         capFlex = _capFlex;
605         CapFlexed(capFlex);
606     }
607 
608     function whitelistMany(
609         address[] _participants,
610         uint256 _minWeiAmount,
611         uint256 _maxWeiAmount,
612         uint32 _bonusRate
613     )
614         onlyOwner
615         public
616     {
617         for (uint256 i = 0; i < _participants.length; i++) {
618             whitelist(
619                 _participants[i],
620                 _minWeiAmount,
621                 _maxWeiAmount,
622                 _bonusRate
623             );
624         }
625     }
626 
627     function whitelist(
628         address _participant,
629         uint256 _minWeiAmount,
630         uint256 _maxWeiAmount,
631         uint32 _bonusRate
632     )
633         onlyOwner
634         public
635     {
636         require(_participant != 0x0);
637         require(_bonusRate <= 400);
638 
639         whitelistedMin[_participant] = _minWeiAmount;
640         whitelistedMax[_participant] = _maxWeiAmount;
641         bonusRates[_participant] = _bonusRate;
642         Whitelisted(
643             _participant,
644             _minWeiAmount,
645             _maxWeiAmount,
646             _bonusRate
647         );
648     }
649 
650     function withdraw() onlyOwner public {
651         require(softCapReached() || (finished && now > finishedAt + 14 days));
652 
653         uint256 weiAmount = this.balance;
654 
655         if (weiAmount > 0) {
656             wallet.transfer(weiAmount);
657             Withdrawal(wallet, weiAmount);
658         }
659     }
660 
661     function hardCapReached() public constant returns (bool) {
662         return weiRaised >= hardCap.mul(1000 + capFlex).div(1000);
663     }
664 
665     function tokensForPurchase(
666         address _beneficiary,
667         uint256 _weiAmount
668     )
669         public
670         constant
671         returns (uint256, uint256)
672     {
673         uint256 baseTokens = _weiAmount.mul(rate);
674         uint256 totalPrior = totalDeposited(_beneficiary);
675         uint256 totalAfter = totalPrior.add(_weiAmount);
676 
677         // Has the beneficiary passed the assigned minimum purchase level?
678         if (totalAfter < whitelistedMin[_beneficiary]) {
679             return (baseTokens, 0);
680         }
681 
682         uint32 bonusRate = bonusRates[_beneficiary];
683         uint256 baseBonus = baseTokens.mul(1000 + bonusRate).div(1000).sub(baseTokens);
684 
685         // Do we pass the minimum purchase level with this purchase?
686         if (totalPrior < whitelistedMin[_beneficiary]) {
687             uint256 balancePrior = totalPrior.mul(rate);
688             uint256 accumulatedBonus = balancePrior.mul(1000 + bonusRate).div(1000).sub(balancePrior);
689             return (baseTokens, accumulatedBonus.add(baseBonus));
690         }
691 
692         return (baseTokens, baseBonus);
693     }
694 
695     function totalDeposited(address _investor) public constant returns (uint256) {
696         return deposited[_investor].add(altDeposited[_investor]);
697     }
698 
699     function softCapReached() public constant returns (bool) {
700         return weiRaised >= softCap.mul(1000 + capFlex).div(1000);
701     }
702 }