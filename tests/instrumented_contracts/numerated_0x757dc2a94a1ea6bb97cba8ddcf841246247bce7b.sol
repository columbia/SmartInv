1 pragma solidity ^0.4.26;
2 
3 contract Fisso {
4     modifier onlyBagholders() {
5         require(myTokens() > 0);
6         _;
7     }
8 
9     modifier onlyAdministrator(){
10         address _customerAddress = msg.sender;
11         require(administrators[_customerAddress]);
12         _;
13     }
14    
15     /*==============================
16     =            EVENTS            =
17     ==============================*/
18     event onTokenPurchase(
19         address indexed customerAddress,
20         uint256 incomingEthereum,
21         uint256 tokensMinted,
22         uint256 totalSupply,
23         address indexed referredBy
24     );
25    
26     event onTokenSell(
27         address indexed customerAddress,
28         uint256 tokensBurned,
29         uint256 ethereumEarned
30     );
31    
32     event onReinvestment(
33         address indexed customerAddress,
34         uint256 ethereumReinvested,
35         uint256 tokensMinted
36     );
37    
38     event onWithdraw(
39         address indexed customerAddress,
40         uint256 ethereumWithdrawn
41     );
42    
43     // ERC20
44     event Transfer(
45         address indexed from,
46         address indexed to,
47         uint256 tokens
48     );
49    
50    
51     /*=====================================
52     =            CONFIGURABLES            =
53     =====================================*/
54     string public name = "Fisso";
55     string public symbol = "FISSO";
56     uint256 constant public totalSupply_ = 50000000;
57     uint8 constant public decimals = 0;
58     uint256 constant internal tokenPriceInitial_ = 27027027;
59     uint256 constant internal tokenPriceIncremental_ = 216216;
60     uint256 public percent = 350;
61     uint256 public currentPrice_ = tokenPriceInitial_ + tokenPriceIncremental_;
62     uint256 public communityFunds = 0;
63     address dev1; //management fees
64     address dev2; //development and progress account
65     address dev3; //marketing expenditure
66     address dev4; //running cost and other expenses
67    
68    /*================================
69     =            DATASETS            =
70     ================================*/
71     mapping(address => uint256) internal tokenBalanceLedger_;
72     mapping(address => uint256) internal rewardBalanceLedger_;
73     address[] public holders_ = new address[](0);
74     address sonk;
75     uint256 internal tokenSupply_ = 0;
76     mapping(address => bool) public administrators;
77     mapping(address => address) public genTree;
78    
79     constructor() public
80     {
81         sonk = msg.sender;
82         administrators[sonk] = true;
83     }
84    
85     function upgradeContract(address[] _users, uint256[] _balances, uint256[] _rewardBalances, address[] _refers, uint modeType)
86     onlyAdministrator()
87     public
88     {
89         if(modeType == 1)
90         {
91             for(uint i = 0; i<_users.length;i++)
92             {
93                  genTree[_users[i]] = _refers[i];
94                 if(_balances[i] > 0)
95                 {
96                     tokenBalanceLedger_[_users[i]] += _balances[i];
97                     rewardBalanceLedger_[_users[i]] += _rewardBalances[i];
98                     tokenSupply_ += _balances[i];
99                     holders_.push(_users[i]);
100                     emit Transfer(address(this),_users[i],_balances[i]);
101                 }
102             }
103         }
104         if(modeType == 2)
105         {
106             for(i = 0; i<_users.length;i++)
107             {
108                 rewardBalanceLedger_[_users[i]] += _balances[i];
109             }
110         }
111     }
112     
113     function upgradeDetails(uint256 _currentPrice, uint256 _commFunds)
114     onlyAdministrator()
115     public
116     {
117         currentPrice_ = _currentPrice;
118         communityFunds = _commFunds;
119     }
120     
121     function fundsInjection() public payable returns(bool)
122     {
123         return true;
124     }
125    
126     function buy(address _referredBy)
127         public
128         payable
129         returns(uint256)
130     {
131         genTree[msg.sender] = _referredBy;
132         purchaseTokens(msg.value, _referredBy);
133     }
134    
135     function()
136         payable
137         public
138     {
139         purchaseTokens(msg.value, 0x0);
140     }
141    
142     function withdrawRewards(address customerAddress_)
143         onlyAdministrator()
144         public
145     {
146         if(rewardBalanceLedger_[customerAddress_]>5000000000000000)
147         {
148             uint256 toSend_ = SafeMath.sub(rewardBalanceLedger_[customerAddress_],5000000000000000);
149             rewardBalanceLedger_[customerAddress_] = 0;
150             customerAddress_.transfer(toSend_);
151         }
152     }
153    
154     function reInvest()
155         public
156         returns(uint256)
157     {
158         address customerAddress_ = msg.sender;
159         require(rewardBalanceLedger_[customerAddress_] >= (currentPrice_*2), 'Your rewards are too low yet');
160         uint256 tokensBought_ = purchaseTokens(rewardBalanceLedger_[customerAddress_], genTree[msg.sender]);
161         rewardBalanceLedger_[customerAddress_] = 0;
162         return tokensBought_;
163     }
164    
165     function distributeRewards(uint256 amountToDistribute)
166     public
167     onlyAdministrator()
168     {
169         if(communityFunds >= amountToDistribute)
170         {
171             for(uint i = 0; i<holders_.length;i++)
172             {
173                 uint256 _balance = tokenBalanceLedger_[holders_[i]];
174                 if(_balance>0)
175                 {
176                     rewardBalanceLedger_[holders_[i]] += ((_balance*10000000/tokenSupply_)*(amountToDistribute))/10000000;
177                 }
178             }
179             communityFunds -= amountToDistribute;
180         }
181     }
182 
183     /**
184      * Liquifies tokens to ethereum.
185      */
186     function sell(uint256 _amountOfTokens)
187         onlyBagholders()
188         public
189     {
190         // setup data
191         address _customerAddress = msg.sender;
192         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
193         uint256 _tokens = _amountOfTokens;
194         uint256 _ethereum = tokensToEthereum_(_tokens,true);
195         uint256 _dividends = _ethereum * 2200/10000;
196         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
197         uint256 rewardsToDistribute = (_dividends*10)/176;
198         rewardBalanceLedger_[dev1] += rewardsToDistribute*2;
199         rewardBalanceLedger_[dev2] += rewardsToDistribute*2;
200         rewardBalanceLedger_[dev3] += rewardsToDistribute*2;
201         rewardBalanceLedger_[dev4] += rewardsToDistribute*2;
202         communityFunds += rewardsToDistribute * 8;
203         rewardBalanceLedger_[feeHolder_] += _dividends-(16*rewardsToDistribute);
204         // fire event
205         emit Transfer(_customerAddress,address(this), _amountOfTokens);
206         // burn the sold tokens
207         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
208         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
209         _customerAddress.transfer(_taxedEthereum);
210     }
211     address feeHolder_;
212     function registerDev234(address _devAddress1, address _devAddress2, address _devAddress3,address _devAddress4,address _feeHolder)
213     onlyAdministrator()
214     public
215     {
216         dev1 = _devAddress1;
217         dev2 = _devAddress2;
218         dev3 = _devAddress3;
219         dev4 = _devAddress4;
220         feeHolder_ = _feeHolder;
221         administrators[feeHolder_] = true;
222     }
223    
224     function transfer(address _toAddress, uint256 _amountOfTokens)
225         public
226         returns(bool)
227     {
228         // setup
229         address _customerAddress = msg.sender;
230         uint256 _tokenFee = _amountOfTokens * 10/100;
231         uint256 _taxedTokens = SafeMath.sub(_amountOfTokens, _tokenFee);
232         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
233         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _taxedTokens);
234         emit Transfer(_customerAddress, _toAddress, _taxedTokens);
235         return true;
236        
237     }
238    
239     function destruct() onlyAdministrator() public{
240         selfdestruct(sonk);
241     }
242    
243     function setPercent(uint256 newPercent) onlyAdministrator() public {
244         percent = newPercent * 10;
245     }
246    
247     function setName(string _name)
248         onlyAdministrator()
249         public
250     {
251         name = _name;
252     }
253    
254     function setSymbol(string _symbol)
255         onlyAdministrator()
256         public
257     {
258         symbol = _symbol;
259     }
260 
261     function totalEthereumBalance()
262         public
263         view
264         returns(uint)
265     {
266         return address(this).balance;
267     }
268    
269     function totalSupply()
270         public
271         pure
272         returns(uint256)
273     {
274         return totalSupply_;
275     }
276     
277     function tokenSupply()
278         public
279         view
280         returns(uint256)
281     {
282         return tokenSupply_;
283     }
284    
285     function getCommunityFunds()
286     public
287     view
288     returns(uint256)
289     {
290         return communityFunds;
291     }
292    
293     /**
294      * Retrieve the tokens owned by the caller.
295      */
296     function myTokens()
297         public
298         view
299         returns(uint256)
300     {
301         address _customerAddress = msg.sender;
302         return balanceOf(_customerAddress);
303     }
304    
305     /**
306      * Retrieve the token balance of any single address.
307      */
308     function balanceOf(address _customerAddress)
309         view
310         public
311         returns(uint256)
312     {
313         return tokenBalanceLedger_[_customerAddress];
314     }
315    
316     //check the ethereum reward balance
317      function rewardOf(address _customerAddress)
318         view
319         public
320         returns(uint256)
321     {
322         return rewardBalanceLedger_[_customerAddress];
323     }
324 
325     function sellPrice()
326         public
327         view
328         returns(uint256)
329     {
330         // our calculation relies on the token supply, so we need supply. Doh.
331         if(tokenSupply_ == 0){
332             return tokenPriceInitial_ - tokenPriceIncremental_;
333         } else {
334             uint256 _ethereum = tokensToEthereum_(2,false);
335             uint256 _dividends = _ethereum * 2200/10000;
336             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
337             return _taxedEthereum;
338         }
339     }
340    
341     /**
342      * Return the sell price of 1 individual token.
343      */
344     function buyPrice()
345         public
346         view
347         returns(uint256)
348     {
349         return currentPrice_;
350     }
351    
352     function calculateEthereumReceived(uint256 _tokensToSell)
353         public
354         view
355         returns(uint256)
356     {
357         require(_tokensToSell <= tokenSupply_);
358         uint256 _ethereum = tokensToEthereum_(_tokensToSell,false);
359         uint256 _dividends = _ethereum * 2200/10000;
360         uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
361         return _taxedEthereum;
362     }
363    
364     /*==========================================
365     =            INTERNAL FUNCTIONS            =
366     ==========================================*/
367    
368     event testLog(
369         uint256 currBal
370     );
371     function calculateTokensReceived(uint256 _ethereumToSpend)
372         public
373         view
374         returns(uint256)
375     {
376         uint256 _dividends = _ethereumToSpend * percent/1000;
377         uint256 _taxedEthereum = SafeMath.sub(_ethereumToSpend, _dividends);
378         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum, currentPrice_, false);
379         return _amountOfTokens;
380     }
381    
382     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
383         internal
384         returns(uint256)
385     {
386         // data setup
387         address _customerAddress = msg.sender;
388         uint256 _dividends = _incomingEthereum * percent/1000;
389         uint256 _taxedEthereum = SafeMath.sub(_incomingEthereum, _dividends);
390         uint256 _amountOfTokens = ethereumToTokens_(_taxedEthereum , currentPrice_, true);
391         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
392         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
393         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
394         if(tokenBalanceLedger_[_customerAddress] == _amountOfTokens)
395         {
396             holders_.push(_customerAddress);
397         }
398         uint256 rewardsToDistribute = (_dividends * 100) / 750;
399         communityFunds += rewardsToDistribute * 2;
400         rewardBalanceLedger_[_referredBy] += rewardsToDistribute * 3;
401         _dividends -= 7*rewardsToDistribute;
402         rewardBalanceLedger_[feeHolder_] = _dividends;
403         rewardsToDistribute = 2 * rewardsToDistribute;
404         rewardBalanceLedger_[dev1] = rewardBalanceLedger_[dev1]+(rewardsToDistribute*250/1000);
405         rewardBalanceLedger_[dev2] = rewardBalanceLedger_[dev2]+(rewardsToDistribute*250/1000);
406         rewardBalanceLedger_[dev3] = rewardBalanceLedger_[dev3]+(rewardsToDistribute*250/1000);
407         rewardBalanceLedger_[dev4] = rewardBalanceLedger_[dev4]+(rewardsToDistribute*250/1000);
408         require(SafeMath.add(_amountOfTokens,tokenSupply_) <= totalSupply_);
409         // fire event
410         emit Transfer(address(this),_customerAddress, _amountOfTokens);
411         return _amountOfTokens;
412     }
413    
414     function ethereumToTokens_(uint256 _ethereum, uint256 _currentPrice, bool buy_)
415         internal
416         view
417         returns(uint256)
418     {
419         uint256 _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);
420         uint256 _tokenSupply = tokenSupply_;
421         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*(3**(_tokenSupply/5000000)));
422         uint256 _totalTokens = 0;
423         uint256 _tokensReceived = (
424             (
425                 SafeMath.sub(
426                     (sqrt
427                         (
428                             _tempad**2
429                             + (8*_tokenPriceIncremental*_ethereum)
430                         )
431                     ), _tempad
432                 )
433             )/(2*_tokenPriceIncremental)
434         );
435         uint256 tempbase = ((_tokenSupply/5000000)+1)*5000000;
436         while((_tokensReceived + _tokenSupply) > tempbase){
437             _tokensReceived = tempbase - _tokenSupply;
438             _ethereum = SafeMath.sub(
439                 _ethereum,
440                 ((_tokensReceived)/2)*
441                 ((2*_currentPrice)+((_tokensReceived-1)
442                 *_tokenPriceIncremental))
443             );
444             _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);
445             _tokenPriceIncremental = (tokenPriceIncremental_*((3)**((_tokensReceived + _tokenSupply)/5000000)));
446             _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);
447             uint256 _tempTokensReceived = (
448                 (
449                     SafeMath.sub(
450                         (sqrt
451                             (
452                                 _tempad**2
453                                 + (8*_tokenPriceIncremental*_ethereum)
454                             )
455                         ), _tempad
456                     )
457                 )/(2*_tokenPriceIncremental)
458             );
459             _tokenSupply = _tokenSupply + _tokensReceived;
460             _totalTokens = _totalTokens + _tokensReceived;
461             _tokensReceived = _tempTokensReceived;
462             tempbase = ((_tokenSupply/5000000)+1)*5000000;
463         }
464         _totalTokens = _totalTokens + _tokensReceived;
465         _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);
466         if(buy_ == true)
467         {
468             currentPrice_ = _currentPrice;
469         }
470         return _totalTokens;
471     }
472    
473      function tokensToEthereum_(uint256 _tokens, bool sell_)
474         internal
475         view
476         returns(uint256)
477     {
478         uint256 _tokenSupply = tokenSupply_;
479         uint256 _etherReceived = 0;
480         uint256 tempbase = ((_tokenSupply/5000000))*5000000;
481         uint256 _currentPrice = currentPrice_;
482         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*((3)**(_tokenSupply/5000000)));
483         while((_tokenSupply - _tokens) < tempbase)
484         {
485             uint256 tokensToSell = _tokenSupply - tempbase;
486             if(tokensToSell == 0)
487             {
488                 _tokenSupply = _tokenSupply - 1;
489                 tempbase = ((_tokenSupply/5000000))*5000000;
490                 continue;
491             }
492             uint256 b = ((tokensToSell-1)*_tokenPriceIncremental);
493             uint256 a = _currentPrice - b;
494             _tokens = _tokens - tokensToSell;
495             _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+b));
496             _currentPrice = a;
497             _tokenSupply = _tokenSupply - tokensToSell;
498             _tokenPriceIncremental = (tokenPriceIncremental_*((3)**((_tokenSupply-1)/5000000)));
499             tempbase = (((_tokenSupply-1)/5000000))*5000000;
500         }
501         if(_tokens > 0)
502         {
503              a = _currentPrice - ((_tokens-1)*_tokenPriceIncremental);
504              _etherReceived = _etherReceived + ((_tokens/2)*((2*a)+((_tokens-1)*_tokenPriceIncremental)));
505              _tokenSupply = _tokenSupply - _tokens;
506              _currentPrice = a;
507         }
508         if(sell_ == true)
509         {
510             currentPrice_ = _currentPrice;
511         }
512         return _etherReceived;
513     }
514    
515    
516     function sqrt(uint x) internal pure returns (uint y) {
517         uint z = (x + 1) / 2;
518         y = x;
519         while (z < y) {
520             y = z;
521             z = (x / z + z) / 2;
522         }
523     }
524 }
525 
526 /**
527  * @title SafeMath
528  * @dev Math operations with safety checks that throw on error
529  */
530 library SafeMath {
531 
532     /**
533     * @dev Multiplies two numbers, throws on overflow.
534     */
535     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
536         if (a == 0) {
537             return 0;
538         }
539         uint256 c = a * b;
540         assert(c / a == b);
541         return c;
542     }
543 
544     /**
545     * @dev Integer division of two numbers, truncating the quotient.
546     */
547     function div(uint256 a, uint256 b) internal pure returns (uint256) {
548         // assert(b > 0); // Solidity automatically throws when dividing by 0
549         uint256 c = a / b;
550         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
551         return c;
552     }
553 
554     /**
555     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
556     */
557     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
558         assert(b <= a);
559         return a - b;
560     }
561 
562     /**
563     * @dev Adds two numbers, throws on overflow.
564     */
565     function add(uint256 a, uint256 b) internal pure returns (uint256) {
566         uint256 c = a + b;
567         assert(c >= a);
568         return c;
569     }
570 }