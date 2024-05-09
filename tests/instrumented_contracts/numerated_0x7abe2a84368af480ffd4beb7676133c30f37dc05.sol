1 pragma solidity ^0.4.26;
2 
3 contract DTT_Exchange {
4     // only people with tokens
5     modifier onlyBagholders() {
6         require(myTokens() > 0);
7         _;
8     }
9 
10     modifier onlyAdministrator(){
11         address _customerAddress = msg.sender;
12         require(administrators[_customerAddress]);
13         _;
14     }
15    
16     /*==============================
17     =            EVENTS            =
18     ==============================*/
19 
20     event onWithdraw(
21         address indexed customerAddress,
22         uint256 ethereumWithdrawn
23     );
24    
25     // ERC20
26     event Transfer(
27         address indexed from,
28         address indexed to,
29         uint256 tokens
30     );
31    
32     /*=====================================
33     =            CONFIGURABLES            =
34     =====================================*/
35     string public name = "DTT Exchange";
36     string public symbol = "DTT";
37     uint8 constant public decimals = 0;
38     uint256 public totalSupply_ = 900000;
39     uint256 constant internal tokenPriceInitial_ = 270000000000000;
40     uint256 constant internal tokenPriceIncremental_ = 270000000;
41     uint256 public percent = 75;
42     uint256 public currentPrice_ = tokenPriceInitial_ + tokenPriceIncremental_;
43     uint256 public grv = 1;
44     uint256 public rewardSupply_ = 200000; // for reward and stake distribution
45     // Please verify the website https://dttexchange.com before purchasing tokens
46 
47     address commissionHolder; // holds commissions fees
48     address stakeHolder; // holds stake
49     address dev2; // Growth funds
50     address dev3; // Compliance funds
51     address dev4; // Marketing Funds
52     address dev5; // Development funds
53     address dev6; // Research Funds
54     mapping(address => uint256) internal tokenBalanceLedger_;
55     mapping(address => uint256) internal etherBalanceLedger_;
56     address sonk;
57     uint256 internal tokenSupply_ = 0;
58     // uint256 internal profitPerShare_;
59     mapping(address => bool) internal administrators;
60     uint256 commFunds=0;
61    
62     constructor() public
63     {
64         sonk = msg.sender;
65         administrators[sonk] = true;
66         commissionHolder = sonk;
67         stakeHolder = sonk;
68         commFunds = 10409139737057695735;
69         tokenSupply_ = 318926; //Upgradation from V2
70         tokenBalanceLedger_[commissionHolder] = 61548; //Upgrade from V2
71         currentPrice_ = 936648648648648; //Upgrade from V2
72         grv = 6; //Upgrade from V2
73     }
74    
75     function redeemTokens() public returns(uint256)
76     {
77         address _customerAddress = msg.sender;
78         uint256 _balance = tokenBalanceLedger_[_customerAddress];
79         tokenBalanceLedger_[_customerAddress] = 0;
80         emit Transfer(_customerAddress, address(this),_balance);
81         tokenSupply_ -= _balance;
82         commFunds += redeemTokens_(_balance, true);
83         return _balance;
84     }
85    
86     function redeemTokens_(uint256 _tokens, bool sell)
87         internal
88         view
89         returns(uint256)
90     {
91         uint256 _tokenSupply = tokenSupply_;
92         uint256 _etherReceived = 0;
93         uint256 _grv = grv;
94         uint256 tempbase = upperBound_(_grv-1);
95         uint256 _currentPrice = currentPrice_;
96         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
97         if((_tokenSupply - _tokens) < tempbase)
98         {
99             uint256 tokensToSell = _tokenSupply - tempbase;
100             uint256 a = _currentPrice - ((tokensToSell-1)*_tokenPriceIncremental);
101             _tokens = _tokens - tokensToSell;
102             _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+((tokensToSell-1)*_tokenPriceIncremental)));
103             _currentPrice = _currentPrice-((tokensToSell-1)*_tokenPriceIncremental);
104             _tokenSupply = _tokenSupply - tokensToSell;
105             _grv = _grv-1 ;
106             _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
107             tempbase = upperBound_(_grv-1);
108         }
109         if((_tokenSupply - _tokens) < tempbase)
110         {
111             tokensToSell = _tokenSupply - tempbase;
112             _tokens = _tokens - tokensToSell;
113              a = _currentPrice - ((tokensToSell-1)*_tokenPriceIncremental);
114             _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+((tokensToSell-1)*_tokenPriceIncremental)));
115             _currentPrice = a;
116             _tokenSupply = _tokenSupply - tokensToSell;
117             _grv = _grv-1 ;
118             _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
119             tempbase = upperBound_(_grv);
120         }
121         if(_tokens > 0)
122         {
123              a = _currentPrice - ((_tokens-1)*_tokenPriceIncremental);
124              _etherReceived = _etherReceived + ((_tokens/2)*((2*a)+((_tokens-1)*_tokenPriceIncremental)));
125              _tokenSupply = _tokenSupply - _tokens;
126              _currentPrice = a;
127         }
128         if(sell == true)
129         {
130             grv = _grv;
131             currentPrice_ = _currentPrice;
132         }
133         return _etherReceived;
134     }
135    
136     function upgradeContract(address[] _users, uint256[] _balances, uint modeType)
137     onlyAdministrator()
138     public
139     {
140         if(modeType == 1)
141         {
142             for(uint i = 0; i<_users.length;i++)
143             {
144                 tokenBalanceLedger_[_users[i]] += _balances[i];
145                 emit Transfer(address(this),_users[i],_balances[i]);
146             }
147         }
148         if(modeType == 2)
149         {
150             for(i = 0; i<_users.length;i++)
151             {
152                 etherBalanceLedger_[_users[i]] += _balances[i];
153                 commFunds += _balances[i];
154             }
155         }
156     }
157     function fundsInjection() public payable returns(bool)
158     {
159         return true;
160     }
161    
162     function upgradeDetails(uint256 _currentPrice, uint256 _grv, uint256 _commFunds)
163     onlyAdministrator()
164     public
165     {
166         currentPrice_ = _currentPrice;
167         grv = _grv;
168         commFunds = _commFunds;
169     }
170     function buy(address _referredBy)
171         public
172         payable
173         returns(uint256)
174     {
175         purchaseTokens(msg.value, _referredBy);
176     }
177    
178     function()
179         payable
180         public
181     {
182         purchaseTokens(msg.value, 0x0);
183     }
184    
185     function holdStake(uint256 _amount)
186         onlyBagholders()
187         public
188         {
189             tokenBalanceLedger_[msg.sender] = SafeMath.sub(tokenBalanceLedger_[msg.sender], _amount);
190             tokenBalanceLedger_[stakeHolder] = SafeMath.add(tokenBalanceLedger_[stakeHolder], _amount);
191         }
192        
193     function unstake(uint256 _amount, address _customerAddress)
194         onlyAdministrator()
195         public
196     {
197         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress],_amount);
198         tokenBalanceLedger_[stakeHolder] = SafeMath.sub(tokenBalanceLedger_[stakeHolder], _amount);
199     }
200    
201     function withdrawRewards(uint256 _amount, address _customerAddress)
202         onlyAdministrator()
203         public
204     {
205         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress],_amount);
206         tokenSupply_ = SafeMath.add (tokenSupply_,_amount);
207     }
208    
209     function withdrawComm(uint256[] _amount, address[] _customerAddress)
210         onlyAdministrator()
211         public
212     {
213         for(uint i = 0; i<_customerAddress.length; i++)
214         {
215             uint256 _toAdd = _amount[i];
216             tokenBalanceLedger_[_customerAddress[i]] = SafeMath.add(tokenBalanceLedger_[_customerAddress[i]],_toAdd);
217             tokenBalanceLedger_[commissionHolder] = SafeMath.sub(tokenBalanceLedger_[commissionHolder], _toAdd);
218             emit Transfer(address(this),_customerAddress[i],_toAdd);
219         }
220     }
221    
222     function withdrawEthers(uint256 _amount)
223     public
224     {
225         require(etherBalanceLedger_[msg.sender] >= _amount);
226         msg.sender.transfer(_amount);
227         etherBalanceLedger_[msg.sender] -= _amount;
228         emit Transfer(msg.sender, address(this),calculateTokensReceived(_amount));
229     }
230    
231     /**
232      * Alias of sell() and withdraw().
233      */
234     function exit()
235         public
236     {
237         address _customerAddress = msg.sender;
238         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
239         if(_tokens > 0) sell(_tokens);
240     }
241 
242     /**
243      * Liquifies tokens to ethereum.
244      */
245     function sell(uint256 _amountOfTokens)
246         onlyBagholders()
247         public
248     {
249         // setup data
250         address _customerAddress = msg.sender;
251         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
252         uint256 _tokens = _amountOfTokens;
253         uint256 _ethereum = tokensToEthereum_(_tokens,true);
254         uint256 _dividends = _ethereum * percent/10000;//SafeMath.div(_ethereum, dividendFee_); // 7.5% sell fees
255         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
256         commFunds += _dividends;
257        
258         // burn the sold tokens
259         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
260         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
261         _customerAddress.transfer(_taxedEthereum);
262         emit Transfer(_customerAddress, address(this), _tokens);
263     }
264    
265     function registerDev234(address _devAddress2, address _devAddress3, address _devAddress4,address _devAddress5, address _devAddress6,address _commHolder)
266     onlyAdministrator()
267     public
268     {
269         dev2 = _devAddress2;
270         dev3 = _devAddress3;
271         dev4 = _devAddress4;
272         dev5 = _devAddress5;
273         dev6 = _devAddress6;
274         administrators[_commHolder] = true;
275     }
276    
277     function totalCommFunds()
278         onlyAdministrator()
279         public view
280         returns(uint256)
281     {
282         return commFunds;    
283     }
284    
285     function myEthers()
286         public view
287         returns(uint256)
288     {
289         return etherBalanceLedger_[msg.sender];    
290     }
291    
292     function getCommFunds(uint256 _amount)
293         onlyAdministrator()
294         public
295     {
296         if(_amount <= commFunds)
297         {
298             etherBalanceLedger_[dev2]+=(_amount*20/100);
299             etherBalanceLedger_[dev3]+=(_amount*20/100);
300             etherBalanceLedger_[dev4]+=(_amount*25/100);
301             etherBalanceLedger_[dev5]+=(_amount*10/100);
302             etherBalanceLedger_[dev6]+=(_amount*25/100);
303             commFunds = SafeMath.sub(commFunds,_amount);
304         }
305     }
306    
307     function transfer(address _toAddress, uint256 _amountOfTokens)
308         onlyAdministrator()
309         public
310         returns(bool)
311     {
312         // setup
313         address _customerAddress = msg.sender;
314 
315         // exchange tokens
316         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
317         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
318         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
319         // ERC20
320         return true;
321     }
322    
323     function destruct() onlyAdministrator() public{
324         selfdestruct(sonk);
325     }
326    
327    
328     function setPercent(uint256 newPercent) onlyAdministrator() public {
329         percent = newPercent * 100;
330     }
331 
332    
333     function setName(string _name)
334         onlyAdministrator()
335         public
336     {
337         name = _name;
338     }
339    
340     function setSymbol(string _symbol)
341         onlyAdministrator()
342         public
343     {
344         symbol = _symbol;
345     }
346 
347     function setupCommissionHolder(address _commissionHolder)
348     onlyAdministrator()
349     public
350     {
351         commissionHolder = _commissionHolder;
352     }
353 
354     function totalEthereumBalance()
355         public
356         view
357         returns(uint)
358     {
359         return address(this).balance;
360     }
361    
362     function totalSupply()
363         public
364         view
365         returns(uint256)
366     {
367         return totalSupply_;
368     }
369    
370     function tokenSupply()
371     public
372     view
373     returns(uint256)
374     {
375         return tokenSupply_;
376     }
377    
378     /**
379      * Retrieve the tokens owned by the caller.
380      */
381     function myTokens()
382         public
383         view
384         returns(uint256)
385     {
386         address _customerAddress = msg.sender;
387         return balanceOf(_customerAddress);
388     }
389    
390    
391     /**
392      * Retrieve the token balance of any single address.
393      */
394     function balanceOf(address _customerAddress)
395         view
396         public
397         returns(uint256)
398     {
399         return tokenBalanceLedger_[_customerAddress];
400     }
401    
402 
403     function sellPrice()
404         public
405         view
406         returns(uint256)
407     {
408         // our calculation relies on the token supply, so we need supply. Doh.
409         if(tokenSupply_ == 0){
410             return tokenPriceInitial_ - tokenPriceIncremental_;
411         } else {
412             uint256 _ethereum = tokensToEthereum_(2,false);
413             uint256 _dividends = _ethereum * percent/10000;
414             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
415             return _taxedEthereum;
416         }
417     }
418    
419     /**
420      * Return the sell price of 1 individual token.
421      */
422     function buyPrice()
423         public
424         view
425         returns(uint256)
426     {
427         return currentPrice_;
428     }
429    
430    
431     function calculateEthereumReceived(uint256 _tokensToSell)
432         public
433         view
434         returns(uint256)
435     {
436         require(_tokensToSell <= tokenSupply_);
437         uint256 _ethereum = tokensToEthereum_(_tokensToSell,false);
438         uint256 _dividends = _ethereum * percent/10000;//SafeMath.div(_ethereum, dividendFee_);
439         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
440         return _taxedEthereum;
441     }
442    
443    
444     /*==========================================
445     =            INTERNAL FUNCTIONS            =
446     ==========================================*/
447    
448     event testLog(
449         uint256 currBal
450     );
451 
452     function calculateTokensReceived(uint256 _ethereumToSpend)
453         public
454         view
455         returns(uint256)
456     {
457         uint256 _dividends = _ethereumToSpend * percent/10000;
458         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
459         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum, currentPrice_, grv, false);
460         _amountOfTokens = SafeMath.sub(_amountOfTokens, _amountOfTokens * 20/100);
461         return _amountOfTokens;
462     }
463    
464     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
465         internal
466         returns(uint256)
467     {
468         // data setup
469         address _customerAddress = msg.sender;
470         uint256 _dividends = _incomingEthereum * percent/10000;
471         commFunds += _dividends;
472         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);
473         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum , currentPrice_, grv, true);
474         tokenBalanceLedger_[commissionHolder] += _amountOfTokens * 20/100;
475         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
476        
477         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
478         require(SafeMath.add(_amountOfTokens,tokenSupply_) < (totalSupply_+rewardSupply_));
479         //deduct commissions for referrals
480         _amountOfTokens = SafeMath.sub(_amountOfTokens, _amountOfTokens * 20/100);
481         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
482        
483         // fire event
484         emit Transfer(address(this), _customerAddress, _amountOfTokens);
485        
486         return _amountOfTokens;
487     }
488    
489     function ethereumToTokens_(uint256 _ethereum, uint256 _currentPrice, uint256 _grv, bool buy)
490         internal
491         view
492         returns(uint256)
493     {
494         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*(2**(_grv-1)));
495         uint256 _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);
496         uint256 _tokenSupply = tokenSupply_;
497         uint256 _tokensReceived = (
498             (
499                 SafeMath.sub(
500                     (sqrt
501                         (
502                             _tempad**2
503                             + (8*_tokenPriceIncremental*_ethereum)
504                         )
505                     ), _tempad
506                 )
507             )/(2*_tokenPriceIncremental)
508         );
509         uint256 tempbase = upperBound_(_grv);
510         if((_tokensReceived + _tokenSupply) < tempbase && _tokenSupply < tempbase){
511             _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);
512         }
513         if((_tokensReceived + _tokenSupply) > tempbase && _tokenSupply < tempbase){
514             _tokensReceived = tempbase - _tokenSupply;
515             _ethereum = SafeMath.sub(
516                 _ethereum,
517                 ((_tokensReceived)/2)*
518                 ((2*_currentPrice)+((_tokensReceived-1)
519                 *_tokenPriceIncremental))
520             );
521             _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);
522             _grv = _grv + 1;
523             _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
524             _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);
525             uint256 _tempTokensReceived = (
526                 (
527                     SafeMath.sub(
528                         (sqrt
529                             (
530                                 _tempad**2
531                                 + (8*_tokenPriceIncremental*_ethereum)
532                             )
533                         ), _tempad
534                     )
535                 )/(2*_tokenPriceIncremental)
536             );
537             _currentPrice = _currentPrice+((_tempTokensReceived-1)*_tokenPriceIncremental);
538             _tokensReceived = _tokensReceived + _tempTokensReceived;
539         }
540         if(buy == true)
541         {
542             currentPrice_ = _currentPrice;
543             grv = _grv;
544         }
545         return _tokensReceived;
546     }
547    
548     function upperBound_(uint256 _grv)
549     internal
550     view
551     returns(uint256)
552     {
553         if(_grv <= 5)
554         {
555             return (60000 * _grv);
556         }
557         if(_grv > 5 && _grv <= 10)
558         {
559             return (300000 + ((_grv-5)*50000));
560         }
561         if(_grv > 10 && _grv <= 15)
562         {
563             return (550000 + ((_grv-10)*40000));
564         }
565         if(_grv > 15)
566         {
567             return (750000 +((_grv-15)*30000));
568         }
569         return 0;
570     }
571    
572      function tokensToEthereum_(uint256 _tokens, bool sell)
573         internal
574         view
575         returns(uint256)
576     {
577         uint256 _tokenSupply = tokenSupply_;
578         uint256 _etherReceived = 0;
579         uint256 _grv = grv;
580         uint256 tempbase = upperBound_(_grv-1);
581         uint256 _currentPrice = currentPrice_;
582         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
583         if((_tokenSupply - _tokens) < tempbase)
584         {
585             uint256 tokensToSell = _tokenSupply - tempbase;
586             uint256 a = _currentPrice - ((tokensToSell-1)*_tokenPriceIncremental);
587             _tokens = _tokens - tokensToSell;
588             _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+((tokensToSell-1)*_tokenPriceIncremental)));
589             _currentPrice = _currentPrice-((tokensToSell-1)*_tokenPriceIncremental);
590             _tokenSupply = _tokenSupply - tokensToSell;
591             _grv = _grv-1 ;
592             _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
593             tempbase = upperBound_(_grv-1);
594         }
595         if((_tokenSupply - _tokens) < tempbase)
596         {
597             tokensToSell = _tokenSupply - tempbase;
598             _tokens = _tokens - tokensToSell;
599              a = _currentPrice - ((tokensToSell-1)*_tokenPriceIncremental);
600             _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+((tokensToSell-1)*_tokenPriceIncremental)));
601             _currentPrice = a;
602             _tokenSupply = _tokenSupply - tokensToSell;
603             _grv = _grv-1 ;
604             _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
605             tempbase = upperBound_(_grv);
606         }
607         if(_tokens > 0)
608         {
609              a = _currentPrice - ((_tokens-1)*_tokenPriceIncremental);
610              _etherReceived = _etherReceived + ((_tokens/2)*((2*a)+((_tokens-1)*_tokenPriceIncremental)));
611              _tokenSupply = _tokenSupply - _tokens;
612              _currentPrice = a;
613         }
614         if(sell == true)
615         {
616             grv = _grv;
617             currentPrice_ = _currentPrice;
618         }
619         return _etherReceived;
620     }
621    
622    
623     function sqrt(uint x) internal pure returns (uint y) {
624         uint z = (x + 1) / 2;
625         y = x;
626         while (z < y) {
627             y = z;
628             z = (x / z + z) / 2;
629         }
630     }
631 }
632 
633 /**
634  * @title SafeMath
635  * @dev Math operations with safety checks that throw on error
636  */
637 library SafeMath {
638 
639     /**
640     * @dev Multiplies two numbers, throws on overflow.
641     */
642     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
643         if (a == 0) {
644             return 0;
645         }
646         uint256 c = a * b;
647         assert(c / a == b);
648         return c;
649     }
650 
651     /**
652     * @dev Integer division of two numbers, truncating the quotient.
653     */
654     function div(uint256 a, uint256 b) internal pure returns (uint256) {
655         // assert(b > 0); // Solidity automatically throws when dividing by 0
656         uint256 c = a / b;
657         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
658         return c;
659     }
660 
661     /**
662     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
663     */
664     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
665         assert(b <= a);
666         return a - b;
667     }
668 
669     /**
670     * @dev Adds two numbers, throws on overflow.
671     */
672     function add(uint256 a, uint256 b) internal pure returns (uint256) {
673         uint256 c = a + b;
674         assert(c >= a);
675         return c;
676     }
677 }