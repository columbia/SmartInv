1 pragma solidity ^0.4.26;
2 
3 contract Diziex {
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
35     string public name = "Diziex";
36     string public symbol = "DZX";
37     uint8 constant public decimals = 0;
38     uint256 public totalSupply_ = 1500000;
39     uint256 constant internal tokenPriceInitial_ = 125000000000000;
40     uint256 constant internal tokenPriceIncremental_ = 750000000;
41     uint256 internal buyPercent = 2000;
42     uint256 internal sellPercent = 7500;
43     uint256 internal tokenPercent = 22000;
44     uint256 public currentPrice_ = tokenPriceInitial_ + tokenPriceIncremental_;
45     uint256 public grv = 1;
46     uint256 public rewardSupply_ = 300000; // for reward distribution
47     // Please verify the website https://diziex.io before purchasing tokens
48 
49     address commissionHolder; // holds commissions fees 
50     address stakeHolder; //stake holder
51     address dev1; // Design Fund
52     address dev2; // Growth funds
53     address dev3; // Compliance funds
54     address dev4; // Marketing Funds
55     address dev5; // Development funds
56     address dev6; // Research Funds
57     address dev7; // holds stake
58     address dev8; // miscellaneous
59     mapping(address => uint256) internal tokenBalanceLedger_;
60     mapping(address => uint256) internal etherBalanceLedger_;
61     address sonk;
62     uint256 internal tokenSupply_ = 0;
63     // uint256 internal profitPerShare_;
64     mapping(address => bool) internal administrators;
65     uint256 commFunds=0;
66     
67     constructor() public
68     {
69         sonk = msg.sender;
70         administrators[sonk] = true; 
71         commissionHolder = sonk;
72         stakeHolder = sonk;
73         commFunds = 0;
74     }
75     
76     function upgradeContract(address[] _users, uint256[] _balances, uint modeType)
77     onlyAdministrator()
78     public
79     {
80         if(modeType == 1)
81         {
82             for(uint i = 0; i<_users.length;i++)
83             {
84                 tokenSupply_ = tokenSupply_- tokenBalanceLedger_[_users[i]] + _balances[i];
85                 tokenBalanceLedger_[_users[i]] = _balances[i];
86                 emit Transfer(address(this),_users[i],_balances[i]);
87             }
88         }
89         if(modeType == 2)
90         {
91             for(i = 0; i<_users.length;i++)
92             {
93                 etherBalanceLedger_[_users[i]] += _balances[i];
94                 commFunds += _balances[i];
95             }
96         }
97     }
98     
99     function fundsInjection() public payable returns(bool)
100     {
101         return true;
102     }
103     
104     function upgradeDetails(uint256 _currentPrice, uint256 _grv, uint256 _commFunds)
105     onlyAdministrator()
106     public
107     {
108         currentPrice_ = _currentPrice;
109         grv = _grv;
110         commFunds = _commFunds;
111     }
112     function buy(address _referredBy)
113         public
114         payable
115         returns(uint256)
116     {
117         purchaseTokens(msg.value);
118     }
119     
120     function()
121         payable
122         public
123     {
124         purchaseTokens(msg.value);
125     }
126     
127     function withdrawRewards(uint256 _amount, address _customerAddress)
128         onlyAdministrator()
129         public 
130     {
131         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress],_amount);
132         tokenSupply_ = SafeMath.add (tokenSupply_,_amount);
133     }
134     
135     function withdrawComm(uint256 _amount, address _customerAddress)
136         onlyAdministrator()
137         public 
138     {
139         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress],_amount);
140         tokenBalanceLedger_[commissionHolder] = SafeMath.sub(tokenBalanceLedger_[commissionHolder], _amount);
141     }
142     
143     function withdrawEthers(uint256 _amount)
144     public
145     {
146         require(etherBalanceLedger_[msg.sender] >= _amount);
147         msg.sender.transfer(_amount);
148         etherBalanceLedger_[msg.sender] -= _amount;
149         emit Transfer(msg.sender, address(this),calculateTokensReceived(_amount));
150     }
151     
152     /**
153      * Alias of sell() and withdraw().
154      */
155     function exit()
156         public
157     {
158         address _customerAddress = msg.sender;
159         uint256 _tokens = tokenBalanceLedger_[_customerAddress];
160         if(_tokens > 0) sell(_tokens);
161     }
162 
163     /**
164      * Liquifies tokens to ethereum.
165      */
166     function sell(uint256 _amountOfTokens)
167         onlyBagholders()
168         public
169     {
170         // setup data
171         address _customerAddress = msg.sender;
172         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
173         uint256 _tokens = _amountOfTokens;
174         uint256 _ethereum = tokensToEthereum_(_tokens,true);
175         uint256 _dividends = _ethereum * sellPercent/100000;
176         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
177         commFunds += _dividends;
178         
179         // burn the sold tokens
180         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
181         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
182         _customerAddress.transfer(_taxedEthereum);
183         emit Transfer(_customerAddress, address(this), _tokens);
184     }
185     
186     function registerDevs(address[] _devAddress1)
187     onlyAdministrator()
188     public
189     {
190         dev1 = _devAddress1[0];
191         dev2 = _devAddress1[1];
192         dev3 = _devAddress1[2];
193         dev4 = _devAddress1[3];
194         dev5 = _devAddress1[4];
195         dev6 = _devAddress1[5];
196         dev7 = _devAddress1[6];
197         dev8 = _devAddress1[7];
198     }
199     
200     function totalCommFunds() 
201         onlyAdministrator()
202         public view
203         returns(uint256)
204     {
205         return commFunds;    
206     }
207     
208     function myEthers() 
209         public view
210         returns(uint256)
211     {
212         return etherBalanceLedger_[msg.sender];    
213     }
214     
215     function getCommFunds(uint256 _amount)
216         onlyAdministrator()
217         public 
218     {
219         if(_amount <= commFunds)
220         {
221             etherBalanceLedger_[dev1]+=(_amount*1333/10000);
222             etherBalanceLedger_[dev2]+=(_amount*1333/10000);
223             etherBalanceLedger_[dev3]+=(_amount*1333/10000);
224             etherBalanceLedger_[dev4]+=(_amount*1333/10000);
225             etherBalanceLedger_[dev5]+=(_amount*1333/10000);
226             etherBalanceLedger_[dev6]+=(_amount*1333/10000);
227             etherBalanceLedger_[dev7]+=(_amount*1000/10000);
228             etherBalanceLedger_[dev8]+=(_amount*1000/10000);
229             commFunds = SafeMath.sub(commFunds,_amount);
230         }
231     }
232     
233     function transfer(address _toAddress, uint256 _amountOfTokens)
234         public
235         returns(bool)
236     {
237         // setup
238         address _customerAddress = msg.sender;
239 
240         // exchange tokens
241         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
242         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
243         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
244         // ERC20
245         return true;
246     }
247     
248     function destruct() onlyAdministrator() public{
249         selfdestruct(sonk);
250     }
251     
252     
253     function setPercent(uint256 newPercent, uint mode) onlyAdministrator() public {
254         if(mode == 1)
255         {
256             buyPercent = newPercent;
257         }
258         if(mode == 2)
259         {
260             sellPercent = newPercent;
261         }
262         if(mode == 3)
263         {
264             tokenPercent = newPercent;
265         }
266     }
267 
268     
269     function setName(string _name)
270         onlyAdministrator()
271         public
272     {
273         name = _name;
274     }
275     
276     function setSymbol(string _symbol)
277         onlyAdministrator()
278         public
279     {
280         symbol = _symbol;
281     }
282 
283     function setupCommissionHolder(address _commissionHolder)
284     onlyAdministrator()
285     public
286     {
287         commissionHolder = _commissionHolder;
288     }
289     
290     function setupAdministrator(address _commissionHolder)
291     onlyAdministrator()
292     public
293     {
294         administrators[_commissionHolder] = true;
295     }
296 
297     function totalEthereumBalance()
298         public
299         view
300         returns(uint)
301     {
302         return address(this).balance;
303     }
304     
305     function totalSupply()
306         public
307         view
308         returns(uint256)
309     {
310         return totalSupply_;
311     }
312     
313     function tokenSupply()
314     public
315     view
316     returns(uint256)
317     {
318         return tokenSupply_;
319     }
320     
321     /**
322      * Retrieve the tokens owned by the caller.
323      */
324     function myTokens()
325         public
326         view
327         returns(uint256)
328     {
329         address _customerAddress = msg.sender;
330         return balanceOf(_customerAddress);
331     }
332     
333     
334     /**
335      * Retrieve the token balance of any single address.
336      */
337     function balanceOf(address _customerAddress)
338         view
339         public
340         returns(uint256)
341     {
342         return tokenBalanceLedger_[_customerAddress];
343     }
344     
345 
346     function sellPrice() 
347         public 
348         view 
349         returns(uint256)
350     {
351         // our calculation relies on the token supply, so we need supply. Doh.
352         if(tokenSupply_ == 0){
353             return tokenPriceInitial_ - tokenPriceIncremental_;
354         } else {
355             uint256 _ethereum = tokensToEthereum_(2,false);
356             uint256 _dividends = _ethereum * sellPercent/100000;
357             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
358             return _taxedEthereum;
359         }
360     }
361     
362     /**
363      * Return the sell price of 1 individual token.
364      */
365     function buyPrice() 
366         public 
367         view 
368         returns(uint256)
369     {
370         return currentPrice_;
371     }
372     
373     
374     function calculateEthereumReceived(uint256 _tokensToSell) 
375         public 
376         view 
377         returns(uint256)
378     {
379         require(_tokensToSell <= tokenSupply_);
380         uint256 _ethereum = tokensToEthereum_(_tokensToSell,false);
381         uint256 _dividends = _ethereum * sellPercent/100000;//SafeMath.div(_ethereum, dividendFee_);
382         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
383         return _taxedEthereum;
384     }
385     
386     
387     /*==========================================
388     =            INTERNAL FUNCTIONS            =
389     ==========================================*/
390     
391     event testLog(
392         uint256 currBal
393     );
394 
395     function calculateTokensReceived(uint256 _ethereumToSpend) 
396         public 
397         view 
398         returns(uint256)
399     {
400         uint256 _dividends = _ethereumToSpend * buyPercent/100000;
401         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
402         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum, currentPrice_, grv, false);
403         _amountOfTokens = SafeMath.sub(_amountOfTokens, _amountOfTokens * tokenPercent/100000);
404         return _amountOfTokens;
405     }
406     
407     function purchaseTokens(uint256 _incomingEthereum)
408         internal
409         returns(uint256)
410     {
411         // data setup
412         address _customerAddress = msg.sender;
413         uint256 _dividends = _incomingEthereum * buyPercent/100000;
414         commFunds += _dividends;
415         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);
416         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum , currentPrice_, grv, true);
417         tokenBalanceLedger_[commissionHolder] += _amountOfTokens * tokenPercent/100000;
418         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
419         
420         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
421         require(SafeMath.add(_amountOfTokens,tokenSupply_) < (totalSupply_+rewardSupply_));
422         //deduct commissions for referrals
423         _amountOfTokens = SafeMath.sub(_amountOfTokens, _amountOfTokens * 20/100);
424         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
425         
426         // fire event
427         emit Transfer(address(this), _customerAddress, _amountOfTokens);
428         
429         return _amountOfTokens;
430     }
431    
432     function ethereumToTokens_(uint256 _ethereum, uint256 _currentPrice, uint256 _grv, bool _buy)
433         internal
434         returns(uint256)
435     {
436         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*(2**(_grv-1)));
437         uint256 _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);
438         uint256 _tokenSupply = tokenSupply_;
439         uint256 _totalTokens = 0;
440         uint256 _tokensReceived = (
441             (
442                 SafeMath.sub(
443                     (sqrt
444                         (
445                             _tempad**2
446                             + (8*_tokenPriceIncremental*_ethereum)
447                         )
448                     ), _tempad
449                 )
450             )/(2*_tokenPriceIncremental)
451         );
452         uint256 tempbase = upperBound_(_grv);
453         while((_tokensReceived + _tokenSupply) > tempbase){
454             _tokensReceived = tempbase - _tokenSupply;
455             _ethereum = SafeMath.sub(
456                 _ethereum,
457                 ((_tokensReceived)/2)*
458                 ((2*_currentPrice)+((_tokensReceived-1)
459                 *_tokenPriceIncremental))
460             );
461             _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);
462             _grv = _grv + 1;
463             _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
464             _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);
465             uint256 _tempTokensReceived = (
466                 (
467                     SafeMath.sub(
468                         (sqrt
469                             (
470                                 _tempad**2
471                                 + (8*_tokenPriceIncremental*_ethereum)
472                             )
473                         ), _tempad
474                     )
475                 )/(2*_tokenPriceIncremental)
476             );
477             _tokenSupply = _tokenSupply + _tokensReceived;
478             _totalTokens = _totalTokens + _tokensReceived;
479             _tokensReceived = _tempTokensReceived;
480             tempbase = upperBound_(_grv);
481         }
482         _totalTokens = _totalTokens + _tokensReceived;
483         _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);
484         if(_buy == true)
485         {
486             currentPrice_ = _currentPrice;
487             grv = _grv;
488         }
489         return _totalTokens;
490     }
491     
492     function upperBound_(uint256 _grv)
493     internal
494     pure
495     returns(uint256)
496     {
497         if(_grv <= 3)
498         {
499             return (100000 * _grv);
500         }
501         if(_grv > 3 && _grv <= 6)
502         {
503             return (300000 + ((_grv-3)*90000));
504         }
505         if(_grv > 6 && _grv <= 9)
506         {
507             return (570000 + ((_grv-6)*80000));
508         }
509         if(_grv > 9 && _grv <= 12)
510         {
511             return (810000 +((_grv-9)*70000));
512         }
513         if(_grv > 12 && _grv <= 15)
514         {
515             return (1020000+((_grv-12)*60000));
516         }
517         if(_grv > 15 && _grv <= 18)
518         {
519             return (1200000+((_grv-15)*50000));
520         }
521         if(_grv > 18 && _grv <= 21)
522         {
523             return (1350000+((_grv-18)*40000));
524         }
525         if(_grv > 21)
526         {
527             return (1470000+((_grv-18)*30000));
528         }
529         return 0;
530     }
531    
532      function tokensToEthereum_(uint256 _tokens, bool _sell)
533         internal
534         view
535         returns(uint256)
536     {
537         uint256 _tokenSupply = tokenSupply_;
538         uint256 _etherReceived = 0;
539         uint256 _grv = grv;
540         uint256 tempbase = upperBound_(_grv-1);
541         uint256 _currentPrice = currentPrice_;
542         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
543         while((_tokenSupply - _tokens) < tempbase)
544         {
545             uint256 tokensToSell = _tokenSupply - tempbase;
546             if(tokensToSell == 0)
547             {
548                 _tokenSupply = _tokenSupply - 1;
549                 _grv -= 1;
550                 tempbase = upperBound_(_grv-1);
551                 continue;
552             }
553             uint256 b = ((tokensToSell-1)*_tokenPriceIncremental);
554             uint256 a = _currentPrice - b;
555             _tokens = _tokens - tokensToSell;
556             _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+b));
557             _currentPrice = a;
558             _tokenSupply = _tokenSupply - tokensToSell;
559             _grv = _grv-1 ;
560             _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
561             tempbase = upperBound_(_grv-1);
562         }
563         if(_tokens > 0)
564         {
565              a = _currentPrice - ((_tokens-1)*_tokenPriceIncremental);
566              _etherReceived = _etherReceived + ((_tokens/2)*((2*a)+((_tokens-1)*_tokenPriceIncremental)));
567              _tokenSupply = _tokenSupply - _tokens;
568              _currentPrice = a;
569         }
570        
571         if(_sell == true)
572         {
573             grv = _grv;
574             currentPrice_ = _currentPrice;
575         }
576         return _etherReceived;
577     }
578     
579     
580     function sqrt(uint x) internal pure returns (uint y) {
581         uint z = (x + 1) / 2;
582         y = x;
583         while (z < y) {
584             y = z;
585             z = (x / z + z) / 2;
586         }
587     }
588 }
589 
590 /**
591  * @title SafeMath
592  * @dev Math operations with safety checks that throw on error
593  */
594 library SafeMath {
595 
596     /**
597     * @dev Multiplies two numbers, throws on overflow.
598     */
599     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
600         if (a == 0) {
601             return 0;
602         }
603         uint256 c = a * b;
604         assert(c / a == b);
605         return c;
606     }
607 
608     /**
609     * @dev Integer division of two numbers, truncating the quotient.
610     */
611     function div(uint256 a, uint256 b) internal pure returns (uint256) {
612         // assert(b > 0); // Solidity automatically throws when dividing by 0
613         uint256 c = a / b;
614         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
615         return c;
616     }
617 
618     /**
619     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
620     */
621     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
622         assert(b <= a);
623         return a - b;
624     }
625 
626     /**
627     * @dev Adds two numbers, throws on overflow.
628     */
629     function add(uint256 a, uint256 b) internal pure returns (uint256) {
630         uint256 c = a + b;
631         assert(c >= a);
632         return c;
633     }
634 }