1 pragma solidity ^ 0.4.26;
2 
3 library SafeMath {
4 
5     function mul(
6         uint256 a, 
7         uint256 b
8     ) 
9         internal 
10         pure 
11         returns(uint256 c) 
12     {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20     
21     function div(
22         uint256 a, 
23         uint256 b
24     ) 
25         internal 
26         pure 
27         returns(uint256) 
28     {
29         return a / b;
30     }
31     
32     function sub(
33         uint256 a, 
34         uint256 b
35     ) 
36         internal 
37         pure 
38         returns(uint256) 
39     {
40         assert(b <= a);
41         return a - b;
42     }
43     
44     function add(
45         uint256 a, 
46         uint256 b
47     ) 
48         internal 
49         pure 
50         returns(uint256 c) 
51     {
52         c = a + b;
53         assert(c >= a);
54         return c;
55     }
56 
57 }
58 
59 
60 contract IERC20 {
61 
62     function totalSupply() 
63         external 
64         view 
65         returns(uint256);
66     
67     function balanceOf(
68         address account
69     ) 
70         external 
71         view 
72         returns(uint256);
73     
74     function transfer(
75         address recipient, 
76         uint256 amount
77     ) 
78         external 
79         returns(bool);
80     
81     function allowance(
82         address owner, 
83         address spender
84     ) 
85         external 
86         view 
87         returns(uint256);
88     
89     function approve(
90         address spender, 
91         uint256 amount
92     ) 
93         external returns(bool);
94     
95     function transferFrom(
96         address sender, 
97         address recipient, 
98         uint256 amount
99     ) 
100         external returns(bool);
101 
102 }
103 
104 
105 contract TrustStake {
106 
107     mapping(address => bool) internal ambassadors_;
108 
109     uint256 constant internal ambassadorMaxPurchase_ = 1000000e18;
110 
111     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
112 
113     bool public onlyAmbassadors = true;
114 
115     uint256 ACTIVATION_TIME = now;
116 
117     modifier antiEarlyWhale(
118         uint256 _amountOfERC20, 
119         address _customerAddress
120     )
121     {
122         if (now >= ACTIVATION_TIME) {
123             onlyAmbassadors = false;
124         }
125         
126         if (onlyAmbassadors) {
127             
128             require((ambassadors_[_customerAddress] == true && 
129             
130             (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfERC20) <= 
131                 ambassadorMaxPurchase_));
132                 
133             ambassadorAccumulatedQuota_[_customerAddress] = 
134                 SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfERC20);
135     
136             _;
137         
138         } else {
139             onlyAmbassadors = false;
140             _;
141         }
142     }
143 
144     modifier onlyTokenHolders {
145         require(myTokens() > 0);
146         _;
147     }
148 
149     modifier onlyDivis {
150         require(myDividends(true) > 0);
151         _;
152     }
153 
154     event onDistribute(
155         address indexed customerAddress,
156         uint256 price
157     );
158 
159     event onTokenPurchase(
160         address indexed customerAddress,
161         uint256 incomingERC20,
162         uint256 tokensMinted,
163         address indexed referredBy,
164         uint timestamp
165     );
166 
167     event onTokenSell(
168         address indexed customerAddress,
169         uint256 tokensBurned,
170         uint256 ERC20Earned,
171         uint timestamp
172     );
173 
174     event onReinvestment(
175         address indexed customerAddress,
176         uint256 ERC20Reinvested,
177         uint256 tokensMinted
178     );
179 
180     event onWithdraw(
181         address indexed customerAddress,
182         uint256 ERC20Withdrawn
183     );
184 
185     event Transfer(
186         address indexed from,
187         address indexed to,
188         uint256 tokens
189     );
190 
191     string public name = "TrustStake";
192     
193     string public symbol = "TRUST";
194     
195     uint8 constant public decimals = 18;
196     
197     uint256 internal entryFee_ = 5;
198     
199     uint256 internal exitFee_ = 5;
200     
201     uint256 internal referralFee_ = 10;
202     
203     uint256 internal maintenanceFee_ = 10;
204     
205     address internal maintenanceAddress;
206     
207     uint256 constant internal magnitude = 2 ** 64;
208     
209     mapping(address => uint256) public tokenBalanceLedger_;
210     
211     mapping(address => uint256) public referralBalance_;
212     
213     mapping(address => uint256) public totalReferralEarnings_;
214     
215     mapping(address => int256) public payoutsTo_;
216     
217     mapping(address => uint256) public invested_;
218     
219     uint256 internal tokenSupply_;
220     
221     uint256 internal profitPerShare_;
222     
223     IERC20 erc20;
224 
225     constructor() public {
226         maintenanceAddress = address(0x1682135756404355F58811F8E495D999ef3Ca0eC);
227         erc20 = IERC20(address(0xCC4304A31d09258b0029eA7FE63d032f52e44EFe));
228     }
229     
230     function checkAndTransfer(
231         uint256 _amount
232     ) 
233         private 
234     {
235         require(
236             erc20.transferFrom(
237                 msg.sender, 
238                 address(this), 
239                 _amount
240             ) == true, "transfer must succeed"
241         );
242     }
243 
244     function buy(
245         uint256 _amount, 
246         address _referredBy
247     ) 
248         public 
249         returns(uint256) 
250     {
251         checkAndTransfer(_amount);
252         
253         return purchaseTokens(
254             _referredBy, 
255             msg.sender, 
256             _amount
257         );
258     }
259     
260     function buyFor(
261         uint256 _amount, 
262         address _customerAddress, 
263         address _referredBy
264     ) 
265         public 
266         returns(uint256) 
267     {
268         checkAndTransfer(_amount);
269         return purchaseTokens(
270             _referredBy, 
271             _customerAddress,
272             _amount
273         );
274     }
275     
276     function() payable public {
277         revert();
278     }
279     
280     function reinvest() 
281         onlyDivis 
282         public 
283     {
284         address _customerAddress = msg.sender;
285         
286         uint256 _dividends = myDividends(false);
287         
288         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
289         
290         _dividends += referralBalance_[_customerAddress];
291         
292         referralBalance_[_customerAddress] = 0;
293         
294         uint256 _tokens = purchaseTokens(0x0, _customerAddress, _dividends);
295         
296         emit onReinvestment(_customerAddress, _dividends, _tokens);
297     }
298     
299     function exit() external {
300         
301         address _customerAddress = msg.sender;
302         
303         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
304         
305         if (_tokens > 0) sell(_tokens);
306         
307         withdraw();
308     }
309     
310     function withdraw() 
311         onlyDivis
312         public 
313     {
314         address _customerAddress = msg.sender;
315         
316         uint256 _dividends = myDividends(false);
317         
318         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
319         
320         _dividends += referralBalance_[_customerAddress];
321         
322         referralBalance_[_customerAddress] = 0;
323         
324         erc20.transfer(_customerAddress, _dividends);
325         
326         emit onWithdraw(_customerAddress, _dividends);
327     }
328     
329     function sell(
330         uint256 _amountOfERC20s
331     ) 
332         onlyTokenHolders 
333         public 
334     {
335         address _customerAddress = msg.sender;
336         require(_amountOfERC20s <= tokenBalanceLedger_[_customerAddress]);
337         
338         uint256 _dividends = SafeMath.div(SafeMath.mul(_amountOfERC20s, exitFee_), 100);
339         uint256 _taxedERC20 = SafeMath.sub(_amountOfERC20s, _dividends);
340         
341         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfERC20s);
342         
343         tokenBalanceLedger_[_customerAddress] = 
344             SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfERC20s);
345         
346         int256 _updatedPayouts = 
347             (int256)(profitPerShare_ * _amountOfERC20s + (_taxedERC20 * magnitude));
348             
349         payoutsTo_[_customerAddress] -= _updatedPayouts;
350         
351         if (tokenSupply_ > 0) {
352             profitPerShare_ = SafeMath.add(
353                 profitPerShare_, (_dividends * magnitude) / tokenSupply_
354             );
355         }
356         
357         emit Transfer(_customerAddress, address(0), _amountOfERC20s);
358         emit onTokenSell(_customerAddress, _amountOfERC20s, _taxedERC20, now);
359     }
360     
361     function transfer(
362         address _toAddress, 
363         uint256 _amountOfERC20s
364     ) 
365         onlyTokenHolders 
366         external 
367         returns(bool) 
368     {
369         address _customerAddress = msg.sender;
370         require(_amountOfERC20s <= tokenBalanceLedger_[_customerAddress]);
371     
372         if (myDividends(true) > 0) {
373             withdraw();
374         }
375         
376         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfERC20s);
377         
378         tokenBalanceLedger_[_customerAddress] = 
379             SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfERC20s);
380             
381         tokenBalanceLedger_[_toAddress] = 
382             SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfERC20s);
383         
384         payoutsTo_[_customerAddress] -= (int256)(profitPerShare_ * _amountOfERC20s);
385         payoutsTo_[_toAddress] += (int256)(profitPerShare_ * _amountOfERC20s);
386         
387         profitPerShare_ = SafeMath.add(profitPerShare_, (_amountOfERC20s * magnitude) / tokenSupply_);
388         
389         emit Transfer(_customerAddress, _toAddress, _amountOfERC20s);
390         
391         return true;
392     }
393     
394     function totalERC20Balance() 
395         public 
396         view 
397         returns(uint256) 
398     {
399         return erc20.balanceOf(address(this));
400     }
401 
402     function totalSupply() 
403         public 
404         view 
405         returns(uint256) 
406     {
407         return tokenSupply_;
408     }
409 
410     function myTokens() 
411         public 
412         view 
413         returns(uint256) 
414     {
415         address _customerAddress = msg.sender;
416         return balanceOf(_customerAddress);
417     }
418     
419     function myDividends(
420         bool _includeReferralBonus
421     ) 
422         public 
423         view 
424         returns(uint256) 
425     {
426         address _customerAddress = msg.sender;
427         return _includeReferralBonus ? dividendsOf(_customerAddress) + 
428             referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
429     }
430     
431     function balanceOf(
432         address _customerAddress
433     ) 
434         public 
435         view 
436         returns(uint256) 
437     {
438         return tokenBalanceLedger_[_customerAddress];
439     }
440     
441     function dividendsOf(
442         address _customerAddress
443     ) 
444         public 
445         view 
446         returns(uint256) 
447     {
448         return (uint256)((int256)(
449             profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - 
450             payoutsTo_[_customerAddress]) / magnitude;
451     }
452     
453     function sellPrice() 
454         public 
455         view 
456         returns(uint256) 
457     {
458         uint256 _erc20 = 1e18;
459         uint256 _dividends = SafeMath.div(SafeMath.mul(_erc20, exitFee_), 100);
460         uint256 _taxedERC20 = SafeMath.sub(_erc20, _dividends);
461         
462         return _taxedERC20;
463     }
464     
465     function buyPrice() 
466         public 
467         view 
468         returns(uint256) 
469     {
470         uint256 _erc20 = 1e18;
471         uint256 _dividends = SafeMath.div(SafeMath.mul(_erc20, entryFee_), 100);
472         uint256 _taxedERC20 = SafeMath.add(_erc20, _dividends);
473         
474         return _taxedERC20;
475     }
476     
477     function getInvested() 
478         public 
479         view 
480         returns(uint256) 
481     {
482         return invested_[msg.sender];
483     }
484     
485     function totalReferralEarnings(
486         address _client
487     )
488         public 
489         view 
490         returns(uint256)
491     {
492         return totalReferralEarnings_[_client];
493     }
494     
495     function referralBalance(
496         address _client 
497     )
498         public 
499         view 
500         returns(uint256)
501     {
502         return referralBalance_[_client];
503     }
504     
505     function purchaseTokens(
506         address _referredBy, 
507         address _customerAddress, 
508         uint256 _incomingERC20
509     ) 
510         internal 
511         antiEarlyWhale(_incomingERC20, _customerAddress) 
512         returns(uint256) 
513     {
514     invested_[msg.sender] += _incomingERC20;
515     
516     uint256 _undividedDividends = 
517         SafeMath.div(
518             SafeMath.mul(
519                 _incomingERC20, entryFee_
520             ), 
521         100);
522     
523     uint256 _maintenance = 
524         SafeMath.div(
525             SafeMath.mul(
526                 _undividedDividends, maintenanceFee_
527             ), 
528         100);
529         
530         
531     uint256 _referralBonus = 
532         SafeMath.div(
533             SafeMath.mul(
534                 _undividedDividends, referralFee_
535             ), 
536         100);
537     
538     uint256 _dividends = 
539         SafeMath.sub(
540             _undividedDividends, SafeMath.add(
541                 _referralBonus, _maintenance
542             )
543         );
544         
545     uint256 _amountOfERC20s = 
546         SafeMath.sub(_incomingERC20, _undividedDividends);
547         
548     uint256 _fee = _dividends * magnitude;
549     
550     require(
551         _amountOfERC20s > 0 && 
552         SafeMath.add(_amountOfERC20s, tokenSupply_) > tokenSupply_
553     );
554     
555     referralBalance_[maintenanceAddress] = 
556         SafeMath.add(referralBalance_[maintenanceAddress], _maintenance);
557     
558     if (_referredBy != address(0) && 
559         _referredBy != _customerAddress)
560     {
561         referralBalance_[_referredBy] = 
562             SafeMath.add(referralBalance_[_referredBy], _referralBonus);
563             
564         totalReferralEarnings_[_referredBy] = 
565             SafeMath.add(totalReferralEarnings_[_referredBy], _referralBonus);
566     } else {
567         _dividends = SafeMath.add(_dividends, _referralBonus);
568         _fee = _dividends * magnitude;
569     }
570     
571     if (tokenSupply_ > 0) 
572     {
573         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfERC20s);
574         
575         profitPerShare_ += ((_dividends * magnitude) / (tokenSupply_));
576         _fee = _fee - (_fee - (_amountOfERC20s * ((_dividends * magnitude) / (tokenSupply_))));
577         
578     } else {
579         tokenSupply_ = _amountOfERC20s;
580     }
581 
582     tokenBalanceLedger_[_customerAddress] = 
583         SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfERC20s);
584     
585     int256 _updatedPayouts = (int256)((profitPerShare_ * _amountOfERC20s) - _fee);
586         
587     payoutsTo_[_customerAddress] += _updatedPayouts;
588     
589     emit Transfer(
590         address(0), 
591         msg.sender, 
592         _amountOfERC20s
593     );
594     
595     emit onTokenPurchase(
596         _customerAddress, 
597         _incomingERC20, 
598         _amountOfERC20s, 
599         _referredBy, 
600         now
601     );
602     
603     return _amountOfERC20s;
604     }
605 
606     function multiData()
607     public
608     view
609     returns(
610         uint256, 
611         uint256, 
612         uint256, 
613         uint256, 
614         uint256, 
615         uint256, 
616         uint256,
617         uint256,
618         uint256
619     )
620     {
621         return (
622         
623         // [0] Total ERC20 in contract 
624         totalERC20Balance(),
625         
626         // [1] Total STAKE TOKEN supply
627         totalSupply(),
628         
629         // [2] User STAKE TOKEN balance 
630         balanceOf(msg.sender),
631         
632         // [3] User ERC20 balance
633         erc20.balanceOf(msg.sender),
634         
635         // [4] User divs 
636         dividendsOf(msg.sender),
637         
638         // [5] Buy price 
639         buyPrice(),
640         
641         // [6] Sell price 
642         sellPrice(),
643         
644         // [7] Total referral earnings  
645         totalReferralEarnings(msg.sender),
646         
647         // [8] Current referral earnings 
648         referralBalance(msg.sender)
649         );
650     }
651 }