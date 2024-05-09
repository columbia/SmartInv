1 // BLOCKCLOUT is a social DeFi network for cryptocurrency enthusiasts 
2 // https://blockclout.com
3 // https://blockclout.com/staking
4 // https://discord.gg/HDc2U5M
5 // https://t.me/blockcloutENG
6 // https://reddit.com/r/blockcloutENG
7 // https://medium.com/@blockclout
8 pragma solidity ^ 0.4.26;
9 
10 library SafeMath {
11 
12     function mul(
13         uint256 a, 
14         uint256 b
15     ) 
16         internal 
17         pure 
18         returns(uint256 c) 
19     {
20         if (a == 0) {
21             return 0;
22         }
23         c = a * b;
24         assert(c / a == b);
25         return c;
26     }
27     
28     function div(
29         uint256 a, 
30         uint256 b
31     ) 
32         internal 
33         pure 
34         returns(uint256) 
35     {
36         return a / b;
37     }
38     
39     function sub(
40         uint256 a, 
41         uint256 b
42     ) 
43         internal 
44         pure 
45         returns(uint256) 
46     {
47         assert(b <= a);
48         return a - b;
49     }
50     
51     function add(
52         uint256 a, 
53         uint256 b
54     ) 
55         internal 
56         pure 
57         returns(uint256 c) 
58     {
59         c = a + b;
60         assert(c >= a);
61         return c;
62     }
63 
64 }
65 
66 
67 contract IERC20 {
68 
69     function totalSupply() 
70         external 
71         view 
72         returns(uint256);
73     
74     function balanceOf(
75         address account
76     ) 
77         external 
78         view 
79         returns(uint256);
80     
81     function transfer(
82         address recipient, 
83         uint256 amount
84     ) 
85         external 
86         returns(bool);
87     
88     function allowance(
89         address owner, 
90         address spender
91     ) 
92         external 
93         view 
94         returns(uint256);
95     
96     function approve(
97         address spender, 
98         uint256 amount
99     ) 
100         external returns(bool);
101     
102     function transferFrom(
103         address sender, 
104         address recipient, 
105         uint256 amount
106     ) 
107         external returns(bool);
108 
109 }
110 
111 
112 contract BlockStake {
113 
114     mapping(address => bool) internal ambassadors_;
115 
116     uint256 constant internal ambassadorMaxPurchase_ = 1000000e18;
117 
118     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
119 
120     bool public onlyAmbassadors = true;
121 
122     uint256 ACTIVATION_TIME = now;
123 
124     modifier antiEarlyWhale(
125         uint256 _amountOfERC20, 
126         address _customerAddress
127     )
128     {
129         if (now >= ACTIVATION_TIME) {
130             onlyAmbassadors = false;
131         }
132         
133         if (onlyAmbassadors) {
134             
135             require((ambassadors_[_customerAddress] == true && 
136             
137             (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfERC20) <= 
138                 ambassadorMaxPurchase_));
139                 
140             ambassadorAccumulatedQuota_[_customerAddress] = 
141                 SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfERC20);
142     
143             _;
144         
145         } else {
146             onlyAmbassadors = false;
147             _;
148         }
149     }
150 
151     modifier onlyTokenHolders {
152         require(myTokens() > 0);
153         _;
154     }
155 
156     modifier onlyDivis {
157         require(myDividends(true) > 0);
158         _;
159     }
160 
161     event onDistribute(
162         address indexed customerAddress,
163         uint256 price
164     );
165 
166     event onTokenPurchase(
167         address indexed customerAddress,
168         uint256 incomingERC20,
169         uint256 tokensMinted,
170         address indexed referredBy,
171         uint timestamp
172     );
173 
174     event onTokenSell(
175         address indexed customerAddress,
176         uint256 tokensBurned,
177         uint256 ERC20Earned,
178         uint timestamp
179     );
180 
181     event onReinvestment(
182         address indexed customerAddress,
183         uint256 ERC20Reinvested,
184         uint256 tokensMinted
185     );
186 
187     event onWithdraw(
188         address indexed customerAddress,
189         uint256 ERC20Withdrawn
190     );
191 
192     event Transfer(
193         address indexed from,
194         address indexed to,
195         uint256 tokens
196     );
197 
198     string public name = "BlockStake";
199     
200     string public symbol = "BLOCK";
201     
202     uint8 constant public decimals = 18;
203     
204     uint256 internal entryFee_ = 5;
205     
206     uint256 internal exitFee_ = 15;
207     
208     uint256 internal referralFee_ = 10;
209     
210     uint256 internal maintenanceFee_ = 5;
211     
212     address internal maintenanceAddress;
213     
214     uint256 constant internal magnitude = 2 ** 64;
215     
216     mapping(address => uint256) public tokenBalanceLedger_;
217     
218     mapping(address => uint256) public referralBalance_;
219     
220     mapping(address => uint256) public totalReferralEarnings_;
221     
222     mapping(address => int256) public payoutsTo_;
223     
224     mapping(address => uint256) public invested_;
225     
226     uint256 internal tokenSupply_;
227     
228     uint256 internal profitPerShare_;
229     
230     IERC20 erc20;
231 
232     constructor() public {
233         maintenanceAddress = address(0x03298351da3fceED5Ad95Bd3e32829b4740EA277);
234         erc20 = IERC20(address(0xa10ae543db5d967a73e9abcc69c81a18a7fc0a78));
235     }
236     
237     function checkAndTransfer(
238         uint256 _amount
239     ) 
240         private 
241     {
242         require(
243             erc20.transferFrom(
244                 msg.sender, 
245                 address(this), 
246                 _amount
247             ) == true, "transfer must succeed"
248         );
249     }
250 
251     function buy(
252         uint256 _amount, 
253         address _referredBy
254     ) 
255         public 
256         returns(uint256) 
257     {
258         checkAndTransfer(_amount);
259         
260         return purchaseTokens(
261             _referredBy, 
262             msg.sender, 
263             _amount
264         );
265     }
266     
267     function buyFor(
268         uint256 _amount, 
269         address _customerAddress, 
270         address _referredBy
271     ) 
272         public 
273         returns(uint256) 
274     {
275         checkAndTransfer(_amount);
276         return purchaseTokens(
277             _referredBy, 
278             _customerAddress,
279             _amount
280         );
281     }
282     
283     function() payable public {
284         revert();
285     }
286     
287     function reinvest() 
288         onlyDivis 
289         public 
290     {
291         address _customerAddress = msg.sender;
292         
293         uint256 _dividends = myDividends(false);
294         
295         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
296         
297         _dividends += referralBalance_[_customerAddress];
298         
299         referralBalance_[_customerAddress] = 0;
300         
301         uint256 _tokens = purchaseTokens(0x0, _customerAddress, _dividends);
302         
303         emit onReinvestment(_customerAddress, _dividends, _tokens);
304     }
305     
306     function exit() external {
307         
308         address _customerAddress = msg.sender;
309         
310         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
311         
312         if (_tokens > 0) sell(_tokens);
313         
314         withdraw();
315     }
316     
317     function withdraw() 
318         onlyDivis
319         public 
320     {
321         address _customerAddress = msg.sender;
322         
323         uint256 _dividends = myDividends(false);
324         
325         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
326         
327         _dividends += referralBalance_[_customerAddress];
328         
329         referralBalance_[_customerAddress] = 0;
330         
331         erc20.transfer(_customerAddress, _dividends);
332         
333         emit onWithdraw(_customerAddress, _dividends);
334     }
335     
336     function sell(
337         uint256 _amountOfERC20s
338     ) 
339         onlyTokenHolders 
340         public 
341     {
342         address _customerAddress = msg.sender;
343         require(_amountOfERC20s <= tokenBalanceLedger_[_customerAddress]);
344         
345         uint256 _dividends = SafeMath.div(SafeMath.mul(_amountOfERC20s, exitFee_), 100);
346         uint256 _taxedERC20 = SafeMath.sub(_amountOfERC20s, _dividends);
347         
348         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfERC20s);
349         
350         tokenBalanceLedger_[_customerAddress] = 
351             SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfERC20s);
352         
353         int256 _updatedPayouts = 
354             (int256)(profitPerShare_ * _amountOfERC20s + (_taxedERC20 * magnitude));
355             
356         payoutsTo_[_customerAddress] -= _updatedPayouts;
357         
358         if (tokenSupply_ > 0) {
359             profitPerShare_ = SafeMath.add(
360                 profitPerShare_, (_dividends * magnitude) / tokenSupply_
361             );
362         }
363         
364         emit Transfer(_customerAddress, address(0), _amountOfERC20s);
365         emit onTokenSell(_customerAddress, _amountOfERC20s, _taxedERC20, now);
366     }
367     
368     function transfer(
369         address _toAddress, 
370         uint256 _amountOfERC20s
371     ) 
372         onlyTokenHolders 
373         external 
374         returns(bool) 
375     {
376         address _customerAddress = msg.sender;
377         require(_amountOfERC20s <= tokenBalanceLedger_[_customerAddress]);
378     
379         if (myDividends(true) > 0) {
380             withdraw();
381         }
382         
383         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfERC20s);
384         
385         tokenBalanceLedger_[_customerAddress] = 
386             SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfERC20s);
387             
388         tokenBalanceLedger_[_toAddress] = 
389             SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfERC20s);
390         
391         payoutsTo_[_customerAddress] -= (int256)(profitPerShare_ * _amountOfERC20s);
392         payoutsTo_[_toAddress] += (int256)(profitPerShare_ * _amountOfERC20s);
393         
394         profitPerShare_ = SafeMath.add(profitPerShare_, (_amountOfERC20s * magnitude) / tokenSupply_);
395         
396         emit Transfer(_customerAddress, _toAddress, _amountOfERC20s);
397         
398         return true;
399     }
400     
401     function totalERC20Balance() 
402         public 
403         view 
404         returns(uint256) 
405     {
406         return erc20.balanceOf(address(this));
407     }
408 
409     function totalSupply() 
410         public 
411         view 
412         returns(uint256) 
413     {
414         return tokenSupply_;
415     }
416 
417     function myTokens() 
418         public 
419         view 
420         returns(uint256) 
421     {
422         address _customerAddress = msg.sender;
423         return balanceOf(_customerAddress);
424     }
425     
426     function myDividends(
427         bool _includeReferralBonus
428     ) 
429         public 
430         view 
431         returns(uint256) 
432     {
433         address _customerAddress = msg.sender;
434         return _includeReferralBonus ? dividendsOf(_customerAddress) + 
435             referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
436     }
437     
438     function balanceOf(
439         address _customerAddress
440     ) 
441         public 
442         view 
443         returns(uint256) 
444     {
445         return tokenBalanceLedger_[_customerAddress];
446     }
447     
448     function dividendsOf(
449         address _customerAddress
450     ) 
451         public 
452         view 
453         returns(uint256) 
454     {
455         return (uint256)((int256)(
456             profitPerShare_ * tokenBalanceLedger_[_customerAddress]) - 
457             payoutsTo_[_customerAddress]) / magnitude;
458     }
459     
460     function sellPrice() 
461         public 
462         view 
463         returns(uint256) 
464     {
465         uint256 _erc20 = 1e18;
466         uint256 _dividends = SafeMath.div(SafeMath.mul(_erc20, exitFee_), 100);
467         uint256 _taxedERC20 = SafeMath.sub(_erc20, _dividends);
468         
469         return _taxedERC20;
470     }
471     
472     function buyPrice() 
473         public 
474         view 
475         returns(uint256) 
476     {
477         uint256 _erc20 = 1e18;
478         uint256 _dividends = SafeMath.div(SafeMath.mul(_erc20, entryFee_), 100);
479         uint256 _taxedERC20 = SafeMath.add(_erc20, _dividends);
480         
481         return _taxedERC20;
482     }
483     
484     function getInvested() 
485         public 
486         view 
487         returns(uint256) 
488     {
489         return invested_[msg.sender];
490     }
491     
492     function totalReferralEarnings(
493         address _client
494     )
495         public 
496         view 
497         returns(uint256)
498     {
499         return totalReferralEarnings_[_client];
500     }
501     
502     function referralBalance(
503         address _client 
504     )
505         public 
506         view 
507         returns(uint256)
508     {
509         return referralBalance_[_client];
510     }
511     
512     function purchaseTokens(
513         address _referredBy, 
514         address _customerAddress, 
515         uint256 _incomingERC20
516     ) 
517         internal 
518         antiEarlyWhale(_incomingERC20, _customerAddress) 
519         returns(uint256) 
520     {
521     invested_[msg.sender] += _incomingERC20;
522     
523     uint256 _undividedDividends = 
524         SafeMath.div(
525             SafeMath.mul(
526                 _incomingERC20, entryFee_
527             ), 
528         100);
529     
530     uint256 _maintenance = 
531         SafeMath.div(
532             SafeMath.mul(
533                 _undividedDividends, maintenanceFee_
534             ), 
535         100);
536         
537         
538     uint256 _referralBonus = 
539         SafeMath.div(
540             SafeMath.mul(
541                 _undividedDividends, referralFee_
542             ), 
543         100);
544     
545     uint256 _dividends = 
546         SafeMath.sub(
547             _undividedDividends, SafeMath.add(
548                 _referralBonus, _maintenance
549             )
550         );
551         
552     uint256 _amountOfERC20s = 
553         SafeMath.sub(_incomingERC20, _undividedDividends);
554         
555     uint256 _fee = _dividends * magnitude;
556     
557     require(
558         _amountOfERC20s > 0 && 
559         SafeMath.add(_amountOfERC20s, tokenSupply_) > tokenSupply_
560     );
561     
562     referralBalance_[maintenanceAddress] = 
563         SafeMath.add(referralBalance_[maintenanceAddress], _maintenance);
564     
565     if (_referredBy != address(0) && 
566         _referredBy != _customerAddress)
567     {
568         referralBalance_[_referredBy] = 
569             SafeMath.add(referralBalance_[_referredBy], _referralBonus);
570             
571         totalReferralEarnings_[_referredBy] = 
572             SafeMath.add(totalReferralEarnings_[_referredBy], _referralBonus);
573     } else {
574         _dividends = SafeMath.add(_dividends, _referralBonus);
575         _fee = _dividends * magnitude;
576     }
577     
578     if (tokenSupply_ > 0) 
579     {
580         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfERC20s);
581         
582         profitPerShare_ += ((_dividends * magnitude) / (tokenSupply_));
583         _fee = _fee - (_fee - (_amountOfERC20s * ((_dividends * magnitude) / (tokenSupply_))));
584         
585     } else {
586         tokenSupply_ = _amountOfERC20s;
587     }
588 
589     tokenBalanceLedger_[_customerAddress] = 
590         SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfERC20s);
591     
592     int256 _updatedPayouts = (int256)((profitPerShare_ * _amountOfERC20s) - _fee);
593         
594     payoutsTo_[_customerAddress] += _updatedPayouts;
595     
596     emit Transfer(
597         address(0), 
598         msg.sender, 
599         _amountOfERC20s
600     );
601     
602     emit onTokenPurchase(
603         _customerAddress, 
604         _incomingERC20, 
605         _amountOfERC20s, 
606         _referredBy, 
607         now
608     );
609     
610     return _amountOfERC20s;
611     }
612 
613     function multiData()
614     public
615     view
616     returns(
617         uint256, 
618         uint256, 
619         uint256, 
620         uint256, 
621         uint256, 
622         uint256, 
623         uint256,
624         uint256,
625         uint256
626     )
627     {
628         return (
629         
630         // [0] Total ERC20 in contract 
631         totalERC20Balance(),
632         
633         // [1] Total STAKE TOKEN supply
634         totalSupply(),
635         
636         // [2] User STAKE TOKEN balance 
637         balanceOf(msg.sender),
638         
639         // [3] User ERC20 balance
640         erc20.balanceOf(msg.sender),
641         
642         // [4] User divs 
643         dividendsOf(msg.sender),
644         
645         // [5] Buy price 
646         buyPrice(),
647         
648         // [6] Sell price 
649         sellPrice(),
650         
651         // [7] Total referral earnings  
652         totalReferralEarnings(msg.sender),
653         
654         // [8] Current referral earnings 
655         referralBalance(msg.sender)
656         );
657     }
658 }