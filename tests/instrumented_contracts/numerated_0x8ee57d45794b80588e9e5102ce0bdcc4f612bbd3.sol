1 pragma solidity ^ 0.5.17;
2 
3 
4 interface ApproveAndCallFallBack {
5     function receiveApproval(address from, uint256 tokens, address token, bytes20 data) external;
6 }
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     require(c / a == b);
14     return c;
15   }
16   function mult(uint256 x, uint256 y) internal pure returns (uint256) {
17       if (x == 0) {
18           return 0;
19       }
20 
21       uint256 z = x * y;
22       require(z / x == y, "Mult overflow");
23       return z;
24   }
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29   function divRound(uint256 x, uint256 y) internal pure returns (uint256) {
30       require(y != 0, "Div by zero");
31       uint256 r = x / y;
32       if (x % y != 0) {
33           r = r + 1;
34       }
35 
36       return r;
37   }
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     require(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     require(c >= a);
46     return c;
47   }
48 
49   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
50     uint256 c = add(a,m);
51     uint256 d = sub(c,1);
52     return mul(div(d,m),m);
53   }
54 }
55 interface ERC20 {
56   function totalSupply() external view returns (uint256);
57   function balanceOf(address who) external view returns (uint256);
58   function allowance(address owner, address spender) external view returns (uint256);
59   function transfer(address to, uint256 value) external returns (bool);
60   function approve(address spender, uint256 value) external returns (bool);
61   function approveAndCall(address spender, uint tokens, bytes calldata data) external returns (bool success);
62   function transferFrom(address from, address to, uint256 value) external returns (bool);
63   function burn(uint256 amount) external;
64 
65   event Transfer(address indexed from, address indexed to, uint256 value);
66   event Approval(address indexed owner, address indexed spender, uint256 value);
67 }
68 
69 
70 
71 
72 
73 
74 
75 contract ConTribute is ApproveAndCallFallBack{
76 
77     mapping(address => bool) internal ambassadors_;
78 
79     uint256 constant internal ambassadorMaxPurchase_ = 2500e18;
80 
81     mapping(address => uint256) internal ambassadorAccumulatedQuota_;
82 
83     bool public onlyAmbassadors = true;
84 
85     uint256 ACTIVATION_TIME = now+100 days;
86 
87     modifier antiEarlyWhale(
88         uint256 _amountOfERC20,
89         address _customerAddress
90     )
91     {
92         if (now >= ACTIVATION_TIME) {
93             onlyAmbassadors = false;
94         }
95 
96         if (onlyAmbassadors) {
97 
98             require((ambassadors_[_customerAddress] == true &&
99 
100             (ambassadorAccumulatedQuota_[_customerAddress] + _amountOfERC20) <=
101                 ambassadorMaxPurchase_));
102 
103             ambassadorAccumulatedQuota_[_customerAddress] =
104                 SafeMath.add(ambassadorAccumulatedQuota_[_customerAddress], _amountOfERC20);
105 
106             _;
107 
108         } else {
109             //if (now < (ACTIVATION_TIME + 60 seconds)) {
110             //    require(tx.gasprice <= 0.1 szabo);
111             //}
112 
113             //not needed because it's already false if it gets to here
114             //onlyAmbassadors = false;
115             _;
116         }
117     }
118 
119     modifier onlyTokenHolders {
120         require(myTokens() > 0);
121         _;
122     }
123 
124     modifier onlyDivis {
125         require(myDividends(true) > 0);
126         _;
127     }
128 
129     event onDistribute(
130         address indexed customerAddress,
131         uint256 price
132     );
133 
134     event onTokenPurchase(
135         address indexed customerAddress,
136         uint256 incomingERC20,
137         uint256 tokensMinted,
138         address indexed referredBy,
139         uint timestamp
140     );
141 
142     event onTokenSell(
143         address indexed customerAddress,
144         uint256 tokensBurned,
145         uint256 ERC20Earned,
146         uint timestamp
147     );
148 
149     event onReinvestment(
150         address indexed customerAddress,
151         uint256 ERC20Reinvested,
152         uint256 tokensMinted
153     );
154 
155     event onWithdraw(
156         address indexed customerAddress,
157         uint256 ERC20Withdrawn
158     );
159 
160     event Transfer(
161         address indexed from,
162         address indexed to,
163         uint256 tokens
164     );
165 
166     string public name = "conTRIBUTE";
167 
168     string public symbol = "CTRBT";
169 
170     uint8 constant public decimals = 18;
171 
172     uint256 public entryFee_ = 5;// 5%
173 
174     uint256 public exitFee_ = 15; // 15%
175 
176     uint256 public referralFee_ = 20; // 1% from the 5% fee
177 
178     uint256 internal maintenanceFee_ = 0;//10; // 1% of the 10% fee
179 
180     address internal maintenanceAddress;
181 
182     uint256 constant internal magnitude = 2 ** 64;
183 
184     mapping(address => uint256) public tokenBalanceLedger_;
185 
186     mapping(address => uint256) public referralBalance_;
187 
188     mapping(address => uint256) public totalReferralEarnings_;
189 
190     mapping(address => int256) public payoutsTo_;
191 
192     mapping(address => uint256) public invested_;
193 
194     uint256 internal tokenSupply_;
195 
196     uint256 internal profitPerShare_;
197 
198     ERC20 erc20;
199 
200 //testnet token 0x6A401A535a55f2BDAaE34622E4c3046E638c0d6e
201 //mainnet token 0x6b785a0322126826d8226d77e173d75DAfb84d11
202     constructor(address token,address extraAmbassador) public {
203         maintenanceAddress = address(0xaEbbd80Fd7dAe979d965A3a5b09bBCD23eB40e5F);
204         ambassadors_[extraAmbassador] = true;
205         ambassadors_[0xaEbbd80Fd7dAe979d965A3a5b09bBCD23eB40e5F] = true;
206         ambassadors_[0xf3850EA23B46fb4182d9cf60c938Da69aC2527d7] = true;
207         ambassadors_[0x9bEDbd434cEAda2ce139335f21905f8fF7894C5D] = true;
208         ambassadors_[0x1264EB4ad33ceF667C0fe2A84150b6a98fF4caf7] = true;
209         erc20 = ERC20(token);
210     }
211 
212     function activate() public{
213       require(ambassadors_[msg.sender]);
214       ACTIVATION_TIME = now;
215     }
216     /*
217       allows playing without using approve
218     */
219     function receiveApproval(address from, uint256 tokens, address token, bytes20 data) public{
220       require(msg.sender==address(erc20)); //calling address must be the token itself
221       _buy(tokens,from,address(data)); //buy tokens on behalf of the user
222     }
223     function checkAndTransfer(
224         uint256 _amount
225     )
226         private
227     {
228         require(
229             erc20.transferFrom(
230                 msg.sender,
231                 address(this),
232                 _amount
233             ) == true, "transfer must succeed"
234         );
235     }
236     /*
237       transfer from custom address, only use with _buy
238     */
239     function checkAndTransfer2(
240         uint256 _amount,
241         address _from
242     )
243         private
244     {
245         require(
246             erc20.transferFrom(
247                 _from,
248                 address(this),
249                 _amount
250             ) == true, "transfer must succeed"
251         );
252     }
253     /*
254       Private buy function for use by approveandcall, to purchase tokens on behalf of the user when msg.sender is the token
255     */
256     function _buy(
257         uint256 _amount,
258         address _sender,
259         address _referredBy
260     )
261         private
262         returns(uint256)
263     {
264         checkAndTransfer2(_amount,_sender);
265 
266         return purchaseTokens(
267             _referredBy,
268             _sender,
269             _amount
270         );
271     }
272     function buy(
273         uint256 _amount,
274         address _referredBy
275     )
276         public
277         returns(uint256)
278     {
279         checkAndTransfer(_amount);
280 
281         return purchaseTokens(
282             _referredBy,
283             msg.sender,
284             _amount
285         );
286     }
287 
288     function buyFor(
289         uint256 _amount,
290         address _customerAddress,
291         address _referredBy
292     )
293         public
294         returns(uint256)
295     {
296         checkAndTransfer(_amount);
297         return purchaseTokens(
298             _referredBy,
299             _customerAddress,
300             _amount
301         );
302     }
303 
304 
305     function reinvest()
306         onlyDivis
307         public
308     {
309         address _customerAddress = msg.sender;
310 
311         uint256 _dividends = myDividends(false);
312 
313         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
314 
315         _dividends += referralBalance_[_customerAddress];
316 
317         referralBalance_[_customerAddress] = 0;
318 
319         uint256 _tokens = purchaseTokens(address(0), _customerAddress, _dividends);
320 
321         emit onReinvestment(_customerAddress, _dividends, _tokens);
322     }
323 
324     function exit() external {
325 
326         address _customerAddress = msg.sender;
327 
328         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
329 
330         if (_tokens > 0) sell(_tokens);
331 
332         withdraw();
333     }
334 
335     function withdraw()
336         onlyDivis
337         public
338     {
339         address _customerAddress = msg.sender;
340 
341         uint256 _dividends = myDividends(false);
342 
343         payoutsTo_[_customerAddress] += (int256)(_dividends * magnitude);
344 
345         _dividends += referralBalance_[_customerAddress];
346 
347         referralBalance_[_customerAddress] = 0;
348 
349         erc20.transfer(_customerAddress, _dividends);
350 
351         emit onWithdraw(_customerAddress, _dividends);
352     }
353 
354     function sell(
355         uint256 _amountOfERC20s
356     )
357         onlyTokenHolders
358         public
359     {
360         address _customerAddress = msg.sender;
361         require(_amountOfERC20s <= tokenBalanceLedger_[_customerAddress]);
362 
363         uint256 _dividends = SafeMath.div(SafeMath.mul(_amountOfERC20s, exitFee_), 100);
364         uint256 _taxedERC20 = SafeMath.sub(_amountOfERC20s, _dividends);
365 
366         tokenSupply_ = SafeMath.sub(tokenSupply_, _amountOfERC20s);
367 
368         tokenBalanceLedger_[_customerAddress] =
369             SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfERC20s);
370 
371         int256 _updatedPayouts =
372             (int256)(profitPerShare_ * _amountOfERC20s + (_taxedERC20 * magnitude));
373 
374         payoutsTo_[_customerAddress] -= _updatedPayouts;
375 
376         if (tokenSupply_ > 0) {
377             profitPerShare_ = SafeMath.add(
378                 profitPerShare_, (_dividends * magnitude) / tokenSupply_
379             );
380         }
381 
382         emit Transfer(_customerAddress, address(0), _amountOfERC20s);
383         emit onTokenSell(_customerAddress, _amountOfERC20s, _taxedERC20, now);
384     }
385 
386     function totalERC20Balance()
387         public
388         view
389         returns(uint256)
390     {
391         return erc20.balanceOf(address(this));
392     }
393 
394     function totalSupply()
395         public
396         view
397         returns(uint256)
398     {
399         return tokenSupply_;
400     }
401 
402     function myTokens()
403         public
404         view
405         returns(uint256)
406     {
407         address _customerAddress = msg.sender;
408         return balanceOf(_customerAddress);
409     }
410 
411     function myDividends(
412         bool _includeReferralBonus
413     )
414         public
415         view
416         returns(uint256)
417     {
418         address _customerAddress = msg.sender;
419         return _includeReferralBonus ? dividendsOf(_customerAddress) +
420             referralBalance_[_customerAddress] : dividendsOf(_customerAddress);
421     }
422 
423     function balanceOf(
424         address _customerAddress
425     )
426         public
427         view
428         returns(uint256)
429     {
430         return tokenBalanceLedger_[_customerAddress];
431     }
432 
433     function dividendsOf(
434         address _customerAddress
435     )
436         public
437         view
438         returns(uint256)
439     {
440         return (uint256)((int256)(
441             profitPerShare_ * tokenBalanceLedger_[_customerAddress]) -
442             payoutsTo_[_customerAddress]) / magnitude;
443     }
444 
445     function sellPrice()
446         public
447         view
448         returns(uint256)
449     {
450         uint256 _erc20 = 1e18;
451         uint256 _dividends = SafeMath.div(SafeMath.mul(_erc20, exitFee_), 100);
452         uint256 _taxedERC20 = SafeMath.sub(_erc20, _dividends);
453 
454         return _taxedERC20;
455     }
456 
457     function buyPrice()
458         public
459         view
460         returns(uint256)
461     {
462         uint256 _erc20 = 1e18;
463         uint256 _dividends = SafeMath.div(SafeMath.mul(_erc20, entryFee_), 100);
464         uint256 _taxedERC20 = SafeMath.add(_erc20, _dividends);
465 
466         return _taxedERC20;
467     }
468 
469     function getInvested()
470         public
471         view
472         returns(uint256)
473     {
474         return invested_[msg.sender];
475     }
476 
477     function totalReferralEarnings(
478         address _client
479     )
480         public
481         view
482         returns(uint256)
483     {
484         return totalReferralEarnings_[_client];
485     }
486     //event DebugTest3(uint256 amount,address sender,address this,uint approved,uint balance);
487     function donateTokens(uint256 todonate) public {
488       require(tokenSupply_>0,"must be some shares in first to distribute to");
489       //transfer tokens
490       //emit DebugTest3(todonate,msg.sender,address(this),erc20.allowance(msg.sender,address(this)),erc20.balanceOf(msg.sender));
491       checkAndTransfer(todonate);
492       profitPerShare_ = SafeMath.add(profitPerShare_, (todonate * magnitude) / tokenSupply_);
493     }
494     function purchaseTokens(
495         address _referredBy,
496         address _customerAddress,
497         uint256 _incomingERC20
498     )
499         internal
500         antiEarlyWhale(_incomingERC20, _customerAddress)
501         returns(uint256)
502     {
503         invested_[_customerAddress] += _incomingERC20;
504 
505         uint256 _undividedDividends =
506             SafeMath.div(
507                 SafeMath.mul(
508                     _incomingERC20, entryFee_
509                 ),
510             100);
511 
512         uint256 _maintenance =
513             SafeMath.div(
514                 SafeMath.mul(
515                     _undividedDividends, maintenanceFee_
516                 ),
517             100);
518 
519 
520         uint256 _referralBonus =
521             SafeMath.div(
522                 SafeMath.mul(
523                     _undividedDividends, referralFee_
524                 ),
525             100);
526 
527         uint256 _dividends =
528             SafeMath.sub(
529                 _undividedDividends, SafeMath.add(
530                     _referralBonus, _maintenance
531                 )
532             );
533 
534         uint256 _amountOfERC20s =
535             SafeMath.sub(_incomingERC20, _undividedDividends);
536 
537         uint256 _fee = _dividends * magnitude;
538 
539         require(
540             _amountOfERC20s > 0 &&
541             SafeMath.add(_amountOfERC20s, tokenSupply_) > tokenSupply_
542         );
543 
544         referralBalance_[maintenanceAddress] =
545             SafeMath.add(referralBalance_[maintenanceAddress], _maintenance);
546 
547         if (_referredBy != address(0) &&
548             _referredBy != _customerAddress)
549         {
550             referralBalance_[_referredBy] =
551                 SafeMath.add(referralBalance_[_referredBy], _referralBonus);
552 
553             totalReferralEarnings_[_referredBy] =
554                 SafeMath.add(totalReferralEarnings_[_referredBy], _referralBonus);
555         } else {
556             _dividends = SafeMath.add(_dividends, _referralBonus);
557             _fee = _dividends * magnitude;
558         }
559 
560         if (tokenSupply_ > 0)
561         {
562             tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfERC20s);
563 
564             profitPerShare_ += ((_dividends * magnitude) / (tokenSupply_));
565             _fee = _fee - (_fee - (_amountOfERC20s * ((_dividends * magnitude) / (tokenSupply_))));
566 
567         } else {
568             tokenSupply_ = _amountOfERC20s;
569         }
570 
571         tokenBalanceLedger_[_customerAddress] =
572             SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfERC20s);
573 
574         int256 _updatedPayouts = (int256)((profitPerShare_ * _amountOfERC20s) - _fee);
575 
576         payoutsTo_[_customerAddress] += _updatedPayouts;
577 
578         emit Transfer(
579             address(0),
580             _customerAddress,
581             _amountOfERC20s
582         );
583 
584         emit onTokenPurchase(
585             _customerAddress,
586             _incomingERC20,
587             _amountOfERC20s,
588             _referredBy,
589             now
590         );
591 
592         return _amountOfERC20s;
593     }
594 
595     function multiData()
596     public
597     view
598     returns(
599         uint256,
600         uint256,
601         uint256,
602         uint256,
603         uint256,
604         uint256,
605         uint256,
606         uint256
607     )
608     {
609         return (
610 
611         // [0] Total ERC20 in contract
612         totalERC20Balance(),
613 
614         // [1] Total STAKE TOKEN supply
615         totalSupply(),
616 
617         // [2] User STAKE TOKEN balance
618         balanceOf(msg.sender),
619 
620         // [3] User ERC20 balance
621         erc20.balanceOf(msg.sender),
622 
623         // [4] User divs
624         dividendsOf(msg.sender),
625 
626         // [5] Buy price
627         buyPrice(),
628 
629         // [6] Sell price
630         sellPrice(),
631 
632         // [7] Total referral eranings
633         totalReferralEarnings(msg.sender)
634         );
635     }
636 }