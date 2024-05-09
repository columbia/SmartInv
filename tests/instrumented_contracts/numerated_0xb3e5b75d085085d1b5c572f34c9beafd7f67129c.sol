1 pragma solidity ^0.4.18;
2 
3 /*
4 *   CrowdSale DapCar (DAPX)
5 *   Created by Starlag Labs (www.starlag.com)
6 *   Copyright © DapCar.io 2018. All rights reserved.
7 *   https://www.dapcar.io
8 */
9 
10 library Math {
11     function mul(uint256 a, uint256 b) 
12     internal 
13     pure 
14     returns (uint256) 
15     {
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) 
25     internal 
26     pure 
27     returns (uint256) 
28     {
29         uint256 c = a / b;
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) 
34     internal 
35     pure 
36     returns (uint256) 
37     {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function add(uint256 a, uint256 b) 
43     internal 
44     pure 
45     returns (uint256) 
46     {
47         uint256 c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract Utils {
54     function Utils() public {}
55 
56     modifier greaterThanZero(uint256 _value) 
57     {
58         require(_value > 0);
59         _;
60     }
61 
62     modifier validUint(uint256 _value) 
63     {
64         require(_value >= 0);
65         _;
66     }
67 
68     modifier validAddress(address _address) 
69     {
70         require(_address != address(0));
71         _;
72     }
73 
74     modifier notThis(address _address) 
75     {
76         require(_address != address(this));
77         _;
78     }
79 
80     modifier validAddressAndNotThis(address _address) 
81     {
82         require(_address != address(0) && _address != address(this));
83         _;
84     }
85 
86     modifier notEmpty(string _data)
87     {
88         require(bytes(_data).length > 0);
89         _;
90     }
91 
92     modifier stringLength(string _data, uint256 _length)
93     {
94         require(bytes(_data).length == _length);
95         _;
96     }
97     
98     modifier validBytes32(bytes32 _bytes)
99     {
100         require(_bytes != 0);
101         _;
102     }
103 
104     modifier validUint64(uint64 _value) 
105     {
106         require(_value >= 0 && _value < 4294967296);
107         _;
108     }
109 
110     modifier validUint8(uint8 _value) 
111     {
112         require(_value >= 0 && _value < 256);
113         _;
114     }
115 
116     modifier validBalanceThis(uint256 _value)
117     {
118         require(_value <= address(this).balance);
119         _;
120     }
121 }
122 
123 contract Authorizable is Utils {
124     using Math for uint256;
125 
126     address public owner;
127     address public newOwner;
128     mapping (address => Level) authorizeds;
129     uint256 public authorizedCount;
130 
131     /*  
132     *   ZERO 0 - bug for null object
133     *   OWNER 1
134     *   ADMIN 2
135     *   DAPP 3
136     */  
137     enum Level {ZERO,OWNER,ADMIN,DAPP}
138 
139     event OwnerTransferred(address indexed _prevOwner, address indexed _newOwner);
140     event Authorized(address indexed _address, Level _level);
141     event UnAuthorized(address indexed _address);
142 
143     function Authorizable() 
144     public 
145     {
146         owner = msg.sender;
147         authorizeds[msg.sender] = Level.OWNER;
148         authorizedCount = authorizedCount.add(1);
149     }
150 
151     modifier onlyOwner {
152         require(authorizeds[msg.sender] == Level.OWNER);
153         _;
154     }
155 
156     modifier onlyOwnerOrThis {
157         require(authorizeds[msg.sender] == Level.OWNER || msg.sender == address(this));
158         _;
159     }
160 
161     modifier notOwner(address _address) {
162         require(authorizeds[_address] != Level.OWNER);
163         _;
164     }
165 
166     modifier authLevel(Level _level) {
167         require((authorizeds[msg.sender] > Level.ZERO) && (authorizeds[msg.sender] <= _level));
168         _;
169     }
170 
171     modifier authLevelOnly(Level _level) {
172         require(authorizeds[msg.sender] == _level);
173         _;
174     }
175     
176     modifier notSender(address _address) {
177         require(msg.sender != _address);
178         _;
179     }
180 
181     modifier isSender(address _address) {
182         require(msg.sender == _address);
183         _;
184     }
185 
186     modifier checkLevel(Level _level) {
187         require((_level > Level.ZERO) && (Level.DAPP >= _level));
188         _;
189     }
190 
191     function transferOwnership(address _newOwner) 
192     public 
193     {
194         _transferOwnership(_newOwner);
195     }
196 
197     function _transferOwnership(address _newOwner) 
198     onlyOwner 
199     validAddress(_newOwner)
200     notThis(_newOwner)
201     internal 
202     {
203         require(_newOwner != owner);
204         newOwner = _newOwner;
205     }
206 
207     function acceptOwnership() 
208     validAddress(newOwner)
209     isSender(newOwner)
210     public 
211     {
212         OwnerTransferred(owner, newOwner);
213         if (authorizeds[owner] == Level.OWNER) {
214             delete authorizeds[owner];
215         }
216         if (authorizeds[newOwner] > Level.ZERO) {
217             authorizedCount = authorizedCount.sub(1);
218         }
219         owner = newOwner;
220         newOwner = address(0);
221         authorizeds[owner] = Level.OWNER;
222     }
223 
224     function cancelOwnership() 
225     onlyOwner
226     public 
227     {
228         newOwner = address(0);
229     }
230 
231     function authorized(address _address, Level _level) 
232     public  
233     {
234         _authorized(_address, _level);
235     }
236 
237     function _authorized(address _address, Level _level) 
238     onlyOwner
239     validAddress(_address)
240     notOwner(_address)
241     notThis(_address)
242     checkLevel(_level)
243     internal  
244     {
245         if (authorizeds[_address] == Level.ZERO) {
246             authorizedCount = authorizedCount.add(1);
247         }
248         authorizeds[_address] = _level;
249         Authorized(_address, _level);
250     }
251 
252     function unAuthorized(address _address) 
253     onlyOwner
254     validAddress(_address)
255     notOwner(_address)
256     notThis(_address)
257     public  
258     {
259         if (authorizeds[_address] > Level.ZERO) {
260             authorizedCount = authorizedCount.sub(1);
261         }
262         delete authorizeds[_address];
263         UnAuthorized(_address);
264     }
265 
266     function isAuthorized(address _address) 
267     validAddress(_address)
268     notThis(_address)
269     public 
270     constant 
271     returns (Level) 
272     {
273         return authorizeds[_address];
274     }
275 }
276 
277 contract IERC20 {
278     function totalSupply() public constant returns (uint256);
279     function balanceOf(address _owner) public constant returns (uint256 balance);
280     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
281     function transfer(address _to, uint256 _value) public returns (bool success);
282     function approve(address _spender, uint256 _value) public returns (bool success);
283     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
284 
285     event Transfer(address indexed from, address indexed to, uint256 value);
286     event Approval(address indexed owner, address indexed spender, uint256 value);
287 }
288 
289 contract ITokenRecipient { function receiveApproval(address _spender, uint256 _value, address _token, bytes _extraData) public; }
290 
291 contract ICouponToken {
292     function updCouponConsumed(string _code, bool _consumed) public returns (bool success);
293     function getCoupon(string _code) public view returns (uint256 bonus, 
294         bool disposable, bool consumed, bool enabled);
295 }
296 
297 contract IDapCarToken {
298     function mint(address _address, uint256 _value) public returns (bool);
299     function balanceOf(address _owner) public constant returns (uint balance);
300 }
301 
302 contract IAirDropToken {
303     function burnAirDrop(address[] _address) public;
304     function balanceOf(address _owner) public constant returns (uint balance);
305 }
306 
307 contract CrowdSaleDapCar is Authorizable {
308     string public version = "0.1";
309     string public publisher = "https://www.dapcar.io";
310     string public description = "This is an official CrowdSale DapCar (DAPX)";
311 
312     address public walletWithdraw;
313     IDapCarToken public dapCarToken;
314     IAirDropToken public airDropToken;
315     ICouponToken public couponToken;
316 
317     uint256 public weiRaised = 0;
318     uint256 public soldToken = 0;
319     uint256 public fundToken = 0;
320     uint256 public weiDonated = 0;
321     uint256 public minPurchaseLimit = 10 finney;
322 
323     bool public crowdSaleEnabled = true;
324     bool public crowdSaleFinalized = false;
325     bool public crowdSaleInitialized = false;
326 
327     bool public airDropTokenEnabled = true;
328     bool public airDropTokenDestroy = true;
329     bool public amountBonusEnabled = true;
330     bool public couponBonusEnabled = true;
331 
332     mapping (uint8 => Rate) rates;
333 
334     mapping (address => Investor) investors;
335     uint256 public investorCount;
336 
337     /*  
338     *   ZERO 0 - bug for null object
339     *   PRESALE 1
340     *   PREICO 2
341     *   ICO 3
342     *   PRERELEASE 4
343     */ 
344     enum Period {ZERO,PRESALE,PREICO,ICO,PRERELEASE}
345 
346     struct Rate {
347         Period period;
348         uint256 rate;
349         uint256 bonusAirDrop;
350         uint64 start;
351         uint64 stop;
352         uint64 updated;
353         bool enabled;
354         bool initialized;
355     }
356 
357     struct Investor {
358         address wallet;
359         uint256 bonus;
360         uint64 updated;
361         bool preSaleEnabled;
362         bool enabled;
363         bool initialized;
364     }
365 
366 
367     event Donate(address indexed sender, uint256 value);
368     event WalletWithdrawChanged(address indexed sender, address indexed oldWallet, address indexed newWallet);
369     event Withdraw(address indexed sender, address indexed wallet, uint256 amount);
370     event WithdrawTokens(address indexed sender, address indexed wallet, address indexed token, uint256 amount);
371     event ReceiveTokens(address indexed spender, address indexed token, uint256 value, bytes extraData);
372     event RatePropsChanged(address indexed sender, uint8 period, string props, bool value);
373     event RateChanged(address indexed sender, uint8 period, uint256 oldBonus, uint256 newBonus);
374     event RateBonusChanged(address indexed sender, uint8 period, uint256 oldBonus, uint256 newBonus);
375     event RateTimeChanged(address indexed sender, uint8 period, uint64 oldStart, uint64 oldStop, 
376         uint64 newStart, uint64 newStop);
377     event InvestorDeleted(address indexed sender, address indexed wallet);
378     event InvestorPropsChanged(address indexed sender, address indexed wallet, string props, bool value);
379     event InvestorBonusChanged(address indexed sender, address indexed wallet, uint256 oldBonus, uint256 newBonus);
380     event InvestorCreated(address indexed sender, address indexed wallet, uint256 bonus);
381     event Purchase(address indexed sender, uint256 amountWei, uint256 amountToken, uint256 totalBonus);
382     event PropsChanged(address indexed sender, string props, bool oldValue, bool newValue);
383     event MinPurchaseLimitChanged(address indexed sender, uint256 oldValu, uint256 newValue);
384     event Finalized(address indexed sender, uint64 time, uint256 weiRaised, uint256 soldToken, 
385         uint256 fundToken, uint256 weiDonated);
386 
387     modifier validPeriod(Period _period) 
388     {
389         require(_period > Period.ZERO && _period <= Period.PRERELEASE);
390         _;
391     }
392 
393     function CrowdSaleDapCar() public {
394         crowdSalePeriodInit();
395     }
396 
397     /*
398     *   PRESALE: 1 DAPX = 1$
399     *   Monday, 5 March 2018, 00:00:00 GMT - Sunday, 25 March 2018, 23:59:59 GMT
400     *   PREICO: 1 DAPX = 2$
401     *   Monday, 9 April 2018, 00:00:00 GMT - Sunday, 29 April 2018, 23:59:59 GMT
402     *   ICO: 1 DAPX = 5$
403     *   Monday, 7 May 2018, 00:00:00 GMT - Sunday, 17 June 2018, 23:59:59 GMT
404     *   PRERELEASE: 1 DAPX = 10$
405     *   Monday, 18 June 2018, 00:00:00 GMT - Sunday, 1 July 2018, 23:59:59 GMT
406     *   RELEASE GAME: 1 DAPX = 1 DAPBOX >= 15$
407     */
408     
409     function crowdSalePeriodInit()
410     onlyOwnerOrThis
411     public
412     returns (bool success)
413     {
414         if (!crowdSaleInitialized) {
415             Rate memory ratePreSale = Rate({
416                 period: Period.PRESALE,
417                 rate: 740,
418                 bonusAirDrop: 0,
419                 start: 1520208000,
420                 stop: 1522022399,
421                 updated: 0,
422                 enabled: true,
423                 initialized: true
424             });
425             rates[uint8(Period.PRESALE)] = ratePreSale;
426 
427             Rate memory ratePreIco = Rate({
428                 period: Period.PREICO,
429                 rate: 370,
430                 bonusAirDrop: 10,
431                 start: 1523232000,
432                 stop: 1525046399,
433                 updated: 0,
434                 enabled: true,
435                 initialized: true
436             });
437             rates[uint8(Period.PREICO)] = ratePreIco;
438 
439             Rate memory rateIco = Rate({
440                 period: Period.ICO,
441                 rate: 148,
442                 bonusAirDrop: 5,
443                 start: 1525651200,
444                 stop: 1529279999,
445                 updated: 0,
446                 enabled: true,
447                 initialized: true
448             });
449             rates[uint8(Period.ICO)] = rateIco;
450 
451             Rate memory ratePreRelease = Rate({
452                 period: Period.PRERELEASE,
453                 rate: 74,
454                 bonusAirDrop: 0,
455                 start: 1529280000,
456                 stop: 1530489599,
457                 updated: 0,
458                 enabled: true,
459                 initialized: true
460             });
461             rates[uint8(Period.PRERELEASE)] = ratePreRelease;
462         
463             crowdSaleInitialized = true;
464             return true;
465         } else {
466             return false;
467         }
468     }
469 
470     function nowPeriod()
471     public
472     constant
473     returns (Period)
474     {
475         uint64 now64 = uint64(now);
476         Period period = Period.ZERO;
477         for (uint8 i = 1; i <= uint8(Period.PRERELEASE); i++) {
478             Rate memory rate = rates[i];
479             if (!rate.initialized || !rate.enabled) { 
480                 continue; 
481             }
482             if (rate.start == 0 || rate.stop == 0 || rate.rate == 0) { 
483                 continue; 
484             }
485             
486             if (now64 >= rate.start && now64 < rate.stop) {
487                 period = rate.period;
488                 break;
489             }
490         }
491 
492         return period;
493     }
494 
495     function updCrowdSaleEnabled(bool _value)
496     authLevel(Level.ADMIN)
497     public
498     returns (bool success)
499     {
500         PropsChanged(msg.sender, "crowdSaleEnabled", crowdSaleEnabled, _value);
501         crowdSaleEnabled = _value;
502         return true;
503     }
504 
505     function updAirDropTokenEnabled(bool _value)
506     authLevel(Level.ADMIN)
507     public
508     returns (bool success)
509     {
510         PropsChanged(msg.sender, "airDropTokenEnabled", airDropTokenEnabled, _value);
511         airDropTokenEnabled = _value;
512         return true;
513     }
514 
515     function updAirDropTokenDestroy(bool _value)
516     authLevel(Level.ADMIN)
517     public
518     returns (bool success)
519     {
520         PropsChanged(msg.sender, "airDropTokenDestroy", airDropTokenDestroy, _value);
521         airDropTokenDestroy = _value;
522         return true;
523     }
524 
525     function updAmountBonusEnabled(bool _value)
526     authLevel(Level.ADMIN)
527     public
528     returns (bool success)
529     {
530         PropsChanged(msg.sender, "amountBonusEnabled", amountBonusEnabled, _value);
531         amountBonusEnabled = _value;
532         return true;
533     }
534 
535     function updCouponBonusEnabled(bool _value)
536     authLevel(Level.ADMIN)
537     public
538     returns (bool success)
539     {
540         PropsChanged(msg.sender, "couponBonusEnabled", couponBonusEnabled, _value);
541         couponBonusEnabled = _value;
542         return true;
543     }
544 
545     function updMinPurchaseLimit(uint256 _limit)
546     authLevel(Level.ADMIN)
547     validUint(_limit)
548     public
549     returns (bool success)
550     {
551         MinPurchaseLimitChanged(msg.sender, minPurchaseLimit, _limit);
552         minPurchaseLimit = _limit;
553         return true;
554     }
555     
556     function getRate(Period _period)
557     validPeriod(_period)
558     public
559     constant
560     returns (uint256 rateValue, uint256 bonusAirDrop, uint64 start, uint64 stop, uint64 updated, bool enabled)
561     {
562         uint8 period = uint8(_period);
563         Rate memory rate = rates[period];
564         require(rate.initialized);
565 
566         return (rate.rate, rate.bonusAirDrop, rate.start, rate.stop, rate.updated, rate.enabled);
567     }
568 
569     function updRate(Period _period, uint256 _rate)
570     authLevel(Level.DAPP)
571     validPeriod(_period)
572     greaterThanZero(_rate)
573     public
574     returns (bool success)
575     {
576         uint8 period = uint8(_period);
577         require(rates[period].initialized);
578 
579         RateChanged(msg.sender, period, rates[period].rate, _rate);
580         rates[period].rate = _rate;
581         rates[period].updated = uint64(now);
582         return true;
583     }
584 
585     function updRateBonusAirDrop(Period _period, uint256 _bonusAirDrop)
586     authLevel(Level.DAPP)
587     validPeriod(_period)
588     validUint(_bonusAirDrop)
589     public
590     returns (bool success)
591     {
592         uint8 period = uint8(_period);
593         require(rates[period].initialized);
594 
595         RateBonusChanged(msg.sender, period, rates[period].bonusAirDrop, _bonusAirDrop);
596         rates[period].bonusAirDrop = _bonusAirDrop;
597         rates[period].updated = uint64(now);
598         return true;
599     }
600 
601     function updRateTimes(Period _period, uint64 _start, uint64 _stop)
602     authLevel(Level.ADMIN)
603     validPeriod(_period)
604     validUint64(_start)
605     validUint64(_stop)
606     public
607     returns (bool success)
608     {
609         require(_start < _stop);
610         uint8 period = uint8(_period);
611         require(rates[period].initialized);
612 
613         RateTimeChanged(msg.sender, period, rates[period].start, rates[period].stop, _start, _stop);
614         rates[period].start = _start;
615         rates[period].stop = _stop;
616         rates[period].updated = uint64(now);
617         return true;
618     }
619 
620     function updRateEnabled(Period _period, bool _enabled)
621     authLevel(Level.ADMIN)
622     validPeriod(_period)
623     public
624     returns (bool success)
625     {
626         uint8 period = uint8(_period);
627         require(rates[period].initialized);
628 
629         rates[period].enabled = _enabled;
630         rates[period].updated = uint64(now);
631         RatePropsChanged(msg.sender, period, "enabled", _enabled);
632         return true;
633     }
634 
635     function setInvestor(address _wallet, uint256 _bonus)
636     authLevel(Level.ADMIN)
637     validAddress(_wallet)
638     notThis(_wallet)
639     validUint(_bonus)
640     public
641     returns (bool success)
642     {
643         uint64 now64 = uint64(now);
644         if (investors[_wallet].initialized) {
645             InvestorBonusChanged(msg.sender, _wallet, investors[_wallet].bonus, _bonus);
646             investors[_wallet].bonus = _bonus;
647             investors[_wallet].updated = now64;
648         } else {
649             Investor memory investor = Investor({
650                 wallet: _wallet,
651                 bonus: _bonus,
652                 updated: now64,
653                 preSaleEnabled: false,
654                 enabled: true,
655                 initialized: true
656             });
657             investors[_wallet] = investor;
658             investorCount = investorCount.add(1);
659             InvestorCreated(msg.sender, _wallet, _bonus);
660         }
661 
662         return true;
663     }
664 
665     function updInvestorEnabled(address _wallet, bool _enabled)
666     authLevel(Level.ADMIN)
667     validAddress(_wallet)
668     notThis(_wallet)
669     public
670     returns (bool success)
671     {
672         require(investors[_wallet].initialized);
673 
674         investors[_wallet].enabled = _enabled;
675         investors[_wallet].updated = uint64(now);
676         InvestorPropsChanged(msg.sender, _wallet, "enabled", _enabled);
677         return true;
678     }
679 
680     function updInvestorPreSaleEnabled(address _wallet, bool _preSaleEnabled)
681     authLevel(Level.ADMIN)
682     validAddress(_wallet)
683     notThis(_wallet)
684     public
685     returns (bool success)
686     {
687         require(investors[_wallet].initialized);
688 
689         investors[_wallet].preSaleEnabled = _preSaleEnabled;
690         investors[_wallet].updated = uint64(now);
691         InvestorPropsChanged(msg.sender, _wallet, "preSaleEnabled", _preSaleEnabled);
692         return true;
693     }
694 
695     function delInvestor(address _wallet)
696     authLevel(Level.ADMIN)
697     validAddress(_wallet)
698     notThis(_wallet)
699     public
700     returns (bool success)
701     {
702         require(investors[_wallet].initialized);
703 
704         delete investors[_wallet];
705         investorCount = investorCount.sub(1);
706         InvestorDeleted(msg.sender, _wallet);
707         return true;
708     }
709 
710     function getInvestor(address _wallet)
711     validAddress(_wallet)
712     notThis(_wallet)
713     public
714     constant
715     returns (uint256 bonus, uint64 updated, bool preSaleEnabled, bool enabled)
716     {
717         Investor memory investor = investors[_wallet];
718         require(investor.initialized);
719 
720         return (investor.bonus,
721             investor.updated,
722             investor.preSaleEnabled,
723             investor.enabled);
724     }
725 
726     function setWalletWithdraw(address _wallet)
727     onlyOwner
728     notThis(_wallet)
729     public
730     returns (bool success)
731     {
732         WalletWithdrawChanged(msg.sender, walletWithdraw, _wallet);
733         walletWithdraw = _wallet;
734         return true;
735     }
736 
737     function setDapCarToken(address _token)
738     authLevel(Level.ADMIN)
739     validAddress(_token)
740     notThis(_token)
741     notOwner(_token)
742     public
743     returns (bool success)
744     {
745         dapCarToken = IDapCarToken(_token);
746         return true;
747     }
748 
749     function setCouponToken(address _token)
750     authLevel(Level.ADMIN)
751     validAddress(_token)
752     notThis(_token)
753     notOwner(_token)
754     public
755     returns (bool success)
756     {
757         couponToken = ICouponToken(_token);
758         return true;
759     }
760 
761     function setAirDropToken(address _token)
762     authLevel(Level.ADMIN)
763     validAddress(_token)
764     notThis(_token)
765     notOwner(_token)
766     public
767     returns (bool success)
768     {
769         airDropToken = IAirDropToken(_token);
770         return true;
771     }
772 
773     function balanceAirDropToken(address _address)
774     validAddress(_address)
775     notOwner(_address)
776     public
777     view
778     returns (uint256 balance)
779     {
780         if (address(airDropToken) != 0) {
781             return airDropToken.balanceOf(_address);
782         } else {
783             return 0;
784         }
785     }
786 
787     function donate() 
788     internal 
789     {
790         if (msg.value > 0) {
791             weiDonated = weiDonated.add(msg.value);
792             Donate(msg.sender, msg.value);
793             if (walletWithdraw != address(0)) {
794                 walletWithdraw.transfer(msg.value);
795             }
796         }
797 	}
798 
799     function withdrawTokens(address _token, uint256 _amount)
800     authLevel(Level.ADMIN)
801     validAddress(_token)
802     notOwner(_token)
803     notThis(_token)
804     greaterThanZero(_amount)
805     public 
806     returns (bool success) 
807     {
808         address wallet = walletWithdraw;
809         if (wallet == address(0)) {
810             wallet = msg.sender;
811         }
812 
813         bool result = IERC20(_token).transfer(wallet, _amount);
814         if (result) {
815             WithdrawTokens(msg.sender, wallet, _token, _amount);
816         }
817         return result;
818     }
819 
820     function withdraw() 
821     public 
822     returns (bool success)
823     {
824         return withdrawAmount(address(this).balance);
825     }
826 
827     function withdrawAmount(uint256 _amount) 
828     authLevel(Level.ADMIN) 
829     greaterThanZero(address(this).balance)
830     greaterThanZero(_amount)
831     validBalanceThis(_amount)
832     public 
833     returns (bool success)
834     {
835         address wallet = walletWithdraw;
836         if (wallet == address(0)) {
837             wallet = msg.sender;
838         }
839 
840         Withdraw(msg.sender, wallet, _amount);
841         wallet.transfer(_amount);
842         return true;
843     }
844 
845     function balanceToken(address _token)
846     validAddress(_token)
847     notOwner(_token)
848     notThis(_token)
849     public 
850     constant
851     returns (uint256 amount) 
852     {
853         return IERC20(_token).balanceOf(address(this));
854     }
855 
856     function getCouponBonus(string _code)
857     internal
858     view
859     returns (uint256) 
860     {
861         uint bonus = 0;
862         if (couponToken == address(0) || bytes(_code).length != 8) {
863             return bonus;
864         }
865 
866         bool disposable;
867         bool consumed;
868         bool enabled;
869         (bonus, disposable, consumed, enabled) = couponToken.getCoupon(_code);
870 
871         if (enabled && (!disposable || (disposable && !consumed))) { 
872             return bonus;
873         } else {
874             return 0;
875         }
876     }
877 
878     function updCouponBonusConsumed(string _code, bool _consumed)
879     internal
880     returns (bool success) 
881     {
882         if (couponToken == address(0) || bytes(_code).length != 8) {
883             return false;
884         }
885         return couponToken.updCouponConsumed(_code, _consumed);
886     }
887 
888     function purchase()
889     notThis(msg.sender)
890     greaterThanZero(msg.value)
891     internal
892     {
893         Period period = nowPeriod();
894         if (crowdSaleFinalized || !crowdSaleEnabled || period == Period.ZERO || msg.value <= minPurchaseLimit) {
895             donate();
896         } else if (dapCarToken == address(0)) {
897             donate();
898         } else {
899             Rate memory rate = rates[uint8(period)];
900             Investor memory investor = investors[msg.sender];
901             uint256 bonus = 0;
902             if (period == Period.PRESALE) {
903                 if (!investor.preSaleEnabled) {
904                     donate();
905                     return;
906                 } 
907             }
908             if (investor.enabled) {
909                 if (investor.bonus > 0) {
910                     bonus = bonus.add(investor.bonus);
911                 }
912             }
913             if (msg.data.length == 8) {
914                 uint256 bonusCoupon = getCouponBonus(string(msg.data));
915                 if (bonusCoupon > 0 && updCouponBonusConsumed(string(msg.data), true)) {
916                     bonus = bonus.add(bonusCoupon);
917                 }
918             }
919             if (airDropTokenEnabled) {
920                 if (balanceAirDropToken(msg.sender) > 0) {
921                     bonus = bonus.add(rate.bonusAirDrop);
922                     if (airDropTokenDestroy && address(airDropToken) != 0) {
923                         address[] memory senders = new address[](1);
924                         senders[0] = msg.sender;
925                         airDropToken.burnAirDrop(senders);
926                     }
927                 }
928             }
929             if (amountBonusEnabled) {
930                 if (msg.value >= 5 ether && msg.value < 10 ether) {
931                     bonus = bonus.add(5);
932                 } else if (msg.value >= 10 ether && msg.value < 50 ether) {
933                     bonus = bonus.add(10);
934                 } else if (msg.value >= 50 ether) {
935                     bonus = bonus.add(15);
936                 }
937             }
938             
939             uint256 purchaseToken = rate.rate.mul(1 ether).mul(msg.value).div(1 ether).div(1 ether);
940             if (bonus > 0) {
941                 purchaseToken = purchaseToken.add(purchaseToken.mul(bonus).div(100));
942             }
943 
944             if (walletWithdraw != address(0)) {
945                 walletWithdraw.transfer(msg.value);
946             }
947 
948             dapCarToken.mint(msg.sender, purchaseToken);
949             Purchase(msg.sender, msg.value, purchaseToken, bonus);
950 
951             weiRaised = weiRaised.add(msg.value);
952             soldToken = soldToken.add(purchaseToken);
953         }
954     }
955 
956     function () 
957     notThis(msg.sender)
958     greaterThanZero(msg.value)
959     external 
960     payable 
961     {
962         purchase();
963 	}
964 
965     function receiveApproval(address _spender, uint256 _value, address _token, bytes _extraData)
966     validAddress(_spender)
967     validAddress(_token)
968     greaterThanZero(_value)
969     public 
970     {
971         IERC20 token = IERC20(_token);
972         require(token.transferFrom(_spender, address(this), _value));
973         ReceiveTokens(_spender, _token, _value, _extraData);
974     }
975 
976     function finalize()
977     onlyOwner
978     public
979     returns (bool success)
980     {
981         return finalization();
982     }
983 
984     function finalization()
985     internal
986     returns (bool success)
987     {
988         if (address(this).balance > 0) {
989             address wallet = walletWithdraw;
990             if (wallet == address(0)) {
991                 wallet = owner;
992             }
993 
994             Withdraw(msg.sender, wallet, address(this).balance);
995             wallet.transfer(address(this).balance);
996         }
997 
998         //42% for Team, Advisor, Bounty, Reserve and Charity funds.
999         fundToken = soldToken.mul(42).div(100);
1000         dapCarToken.mint(walletWithdraw, fundToken);
1001 
1002         Finalized(msg.sender, uint64(now), weiRaised, soldToken, fundToken, weiDonated);
1003         crowdSaleFinalized = true;
1004         return true;
1005     }
1006 
1007     function kill() 
1008     onlyOwner 
1009     public 
1010     { 
1011         if (crowdSaleFinalized) {
1012             selfdestruct(owner);
1013         }
1014     }
1015 
1016 }