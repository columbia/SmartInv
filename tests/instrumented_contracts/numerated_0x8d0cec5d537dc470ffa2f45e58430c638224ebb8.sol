1 pragma solidity ^0.4.26;
2 
3 contract LTT_Exchange {
4     // only people with tokens
5     modifier onlyBagholders() {
6         require(myTokens() > 0);
7         _;
8     }
9     modifier onlyAdministrator(){
10         address _customerAddress = msg.sender;
11         require(administrators[_customerAddress]);
12         _;
13     }
14     /*==============================
15     =            EVENTS            =
16     ==============================*/
17 
18     event Reward(
19        address indexed to,
20        uint256 rewardAmount,
21        uint256 level
22     );
23     // ERC20
24     event Transfer(
25         address indexed from,
26         address indexed to,
27         uint256 tokens
28     );
29    
30     /*=====================================
31     =            CONFIGURABLES            =
32     =====================================*/
33     string public name = "Link Trade Token";
34     string public symbol = "LTT";
35     uint8 constant public decimals = 0;
36     uint256 public totalSupply_ = 900000;
37     uint256 constant internal tokenPriceInitial_ = 0.00013 ether;
38     uint256 constant internal tokenPriceIncremental_ = 263157894;
39     uint256 public currentPrice_ = tokenPriceInitial_ + tokenPriceIncremental_;
40     uint256 public base = 1;
41     uint256 public basePrice = 380;
42     uint public percent = 1000;
43     uint256 public rewardSupply_ = 2000000;
44     mapping(address => uint256) internal tokenBalanceLedger_;
45     mapping(address => uint256) internal rewardBalanceLedger_;
46     address commissionHolder;
47     uint256 internal tokenSupply_ = 0;
48     mapping(address => bool) internal administrators;
49     mapping(address => address) public genTree;
50     mapping(address => uint256) public level1Holding_;
51     address terminal;
52     uint8[] percent_ = [5,2,1,1,1];
53     uint256[] holding_ = [0,460,460,930,930];
54     uint internal minWithdraw = 1000;
55    
56     constructor() public
57     {
58         terminal = msg.sender;
59         administrators[terminal] = true;
60     }
61    
62     function withdrawRewards() public returns(uint256)
63     {
64         address _customerAddress = msg.sender;
65         require(rewardBalanceLedger_[_customerAddress]>minWithdraw);
66         uint256 _balance = rewardBalanceLedger_[_customerAddress]/100;
67         rewardBalanceLedger_[_customerAddress] -= _balance*100;
68         uint256 _ethereum = tokensToEthereum_(_balance,true);
69         _customerAddress.transfer(_ethereum);
70         emit Transfer(_customerAddress, address(this),_balance);
71         tokenSupply_ = SafeMath.sub(tokenSupply_, _balance);
72     }
73    
74     function distributeRewards(uint256 _amountToDistribute, address _idToDistribute)
75     internal
76     {
77         uint256 _currentPrice = currentPrice_*basePrice;
78         uint256 _tempAmountToDistribute = _amountToDistribute*100;
79         for(uint i=0; i<5; i++)
80         {
81             address referrer = genTree[_idToDistribute];
82             uint256 value = _currentPrice*tokenBalanceLedger_[referrer];
83             uint256 _holdingLevel1 = level1Holding_[referrer]*_currentPrice;
84             if(referrer != 0x0 && value >= (50*10**18) && _holdingLevel1 >= (holding_[i]*10**18))
85             {
86                 rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[i]*100)/10;
87                 _idToDistribute = referrer;
88                 emit Reward(referrer,(_amountToDistribute*percent_[i]*100)/10,i);
89                 _tempAmountToDistribute -= (_amountToDistribute*percent_[i]*100)/10;
90             }
91         }
92         rewardBalanceLedger_[commissionHolder] += _tempAmountToDistribute;
93     }
94    
95    function setBasePrice(uint256 _price)
96     onlyAdministrator()
97     public
98     returns(bool) {
99         basePrice = _price;
100     }
101    
102     function buy(address _referredBy)
103         public
104         payable
105         returns(uint256)
106     {
107         genTree[msg.sender] = _referredBy;
108         purchaseTokens(msg.value, _referredBy);
109     }
110    
111     function()
112         payable
113         public
114     {
115         purchaseTokens(msg.value, 0x0);
116     }
117    
118     /**
119      * Liquifies tokens to ethereum.
120     */
121      
122     function sell(uint256 _amountOfTokens)
123         onlyBagholders()
124         public
125     {
126         // setup data
127         address _customerAddress = msg.sender;
128         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
129         uint256 _tokens = _amountOfTokens;
130         uint256 _dividends = _tokens * percent/10000;//SafeMath.div(_ethereum, dividendFee_);
131         uint256 _ethereum = tokensToEthereum_(_tokens,true);
132         // burn the sold tokens
133         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
134         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
135         distributeRewards(_dividends,_customerAddress);
136         level1Holding_[genTree[_customerAddress]] -=_amountOfTokens;
137         _customerAddress.transfer(_ethereum);
138         emit Transfer(_customerAddress, address(this), _tokens);
139     }
140    
141     function rewardOf(address _toCheck)
142         public view
143         returns(uint256)
144     {
145         return rewardBalanceLedger_[_toCheck];    
146     }
147    
148     function holdingLevel1(address _toCheck)
149         public view
150         returns(uint256)
151     {
152         return level1Holding_[_toCheck];    
153     }
154    
155     function transfer(address _toAddress, uint256 _amountOfTokens)
156         onlyAdministrator()
157         public
158         returns(bool)
159     {
160         // setup
161         address _customerAddress = msg.sender;
162         // exchange tokens
163         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
164         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
165         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
166         return true;
167     }
168    
169     function destruct() onlyAdministrator() public{
170         selfdestruct(terminal);
171     }
172    
173     function setName(string _name)
174         onlyAdministrator()
175         public
176     {
177         name = _name;
178     }
179    
180     function setSymbol(string _symbol)
181         onlyAdministrator()
182         public
183     {
184         symbol = _symbol;
185     }
186 
187     function setupCommissionHolder(address _commissionHolder)
188     onlyAdministrator()
189     public
190     {
191         commissionHolder = _commissionHolder;
192     }
193 
194     function totalEthereumBalance()
195         public
196         view
197         returns(uint)
198     {
199         return address(this).balance;
200     }
201    
202     function totalSupply()
203         public
204         view
205         returns(uint256)
206     {
207         return totalSupply_;
208     }
209    
210     function tokenSupply()
211     public
212     view
213     returns(uint256)
214     {
215         return tokenSupply_;
216     }
217    
218     /**
219      * Retrieve the tokens owned by the caller.
220      */
221     function myTokens()
222         public
223         view
224         returns(uint256)
225     {
226         address _customerAddress = msg.sender;
227         return balanceOf(_customerAddress);
228     }
229    
230    
231     /**
232      * Retrieve the token balance of any single address.
233      */
234     function balanceOf(address _customerAddress)
235         view
236         public
237         returns(uint256)
238     {
239         return tokenBalanceLedger_[_customerAddress];
240     }
241    
242 
243     function sellPrice()
244         public
245         view
246         returns(uint256)
247     {
248         // our calculation relies on the token supply, so we need supply. Doh.
249         if(tokenSupply_ == 0){
250             return tokenPriceInitial_ - tokenPriceIncremental_;
251         } else {
252             uint256 _ethereum = tokensToEthereum_(1,false);
253             uint256 _dividends = _ethereum * percent / 10000;
254             uint256 _taxedEthereum = SafeMath.sub(_ethereum, _dividends);
255             return _taxedEthereum;
256         }
257     }
258    
259     /**
260      * Return the sell price of 1 individual token.
261      */
262     function buyPrice()
263         public
264         view
265         returns(uint256)
266     {
267         return currentPrice_;
268     }
269    
270    
271     function calculateEthereumReceived(uint256 _tokensToSell)
272         public
273         view
274         returns(uint256)
275     {
276         require(_tokensToSell <= tokenSupply_);
277         _tokensToSell = SafeMath.sub(_tokensToSell,_tokensToSell*percent/10000);
278         uint256 _ethereum = tokensToEthereum_(_tokensToSell,false);
279         return _ethereum;
280     }
281    
282     /*==========================================
283     =            INTERNAL FUNCTIONS            =
284     ==========================================*/
285    
286     event testLog(
287         uint256 currBal
288     );
289 
290     function calculateTokensReceived(uint256 _ethereumToSpend)
291         public
292         view
293         returns(uint256)
294     {
295         uint256 _amountOfTokens = ethereumToTokens_(_ethereumToSpend, currentPrice_, base, false);
296         _amountOfTokens = SafeMath.sub(_amountOfTokens, _amountOfTokens * percent/10000);
297         return _amountOfTokens;
298     }
299    
300     function purchaseTokens(uint256 _incomingEthereum, address _referredBy)
301         internal
302         returns(uint256)
303     {
304         // data setup
305         address _customerAddress = msg.sender;
306         uint256 _amountOfTokens = ethereumToTokens_(_incomingEthereum , currentPrice_, base, true);
307         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
308         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
309         require(SafeMath.add(_amountOfTokens,tokenSupply_) < (totalSupply_+rewardSupply_));
310         //deduct commissions for referrals
311         distributeRewards(_amountOfTokens * percent/10000,_customerAddress);
312         _amountOfTokens = SafeMath.sub(_amountOfTokens, _amountOfTokens * percent/10000);
313         level1Holding_[_referredBy] +=_amountOfTokens;
314         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
315         // fire event
316         emit Transfer(address(this), _customerAddress, _amountOfTokens);
317         return _amountOfTokens;
318     }
319    
320     function ethereumToTokens_(uint256 _ethereum, uint256 _currentPrice, uint256 _grv, bool buy)
321         internal
322         view
323         returns(uint256)
324     {
325         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*(2**(_grv-1)));
326         uint256 _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);
327         uint256 _tokenSupply = tokenSupply_;
328         uint256 _totalTokens = 0;
329         uint256 _tokensReceived = (
330             (
331                 SafeMath.sub(
332                     (sqrt
333                         (
334                             _tempad**2
335                             + (8*_tokenPriceIncremental*_ethereum)
336                         )
337                     ), _tempad
338                 )
339             )/(2*_tokenPriceIncremental)
340         );
341         uint256 tempbase = upperBound_(_grv);
342         while((_tokensReceived + _tokenSupply) > tempbase){
343             _tokensReceived = tempbase - _tokenSupply;
344             _ethereum = SafeMath.sub(
345                 _ethereum,
346                 ((_tokensReceived)/2)*
347                 ((2*_currentPrice)+((_tokensReceived-1)
348                 *_tokenPriceIncremental))
349             );
350             _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);
351             _grv = _grv + 1;
352             _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
353             _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);
354             uint256 _tempTokensReceived = (
355                 (
356                     SafeMath.sub(
357                         (sqrt
358                             (
359                                 _tempad**2
360                                 + (8*_tokenPriceIncremental*_ethereum)
361                             )
362                         ), _tempad
363                     )
364                 )/(2*_tokenPriceIncremental)
365             );
366             _tokenSupply = _tokenSupply + _tokensReceived;
367             _totalTokens = _totalTokens + _tokensReceived;
368             _tokensReceived = _tempTokensReceived;
369             tempbase = upperBound_(_grv);
370         }
371         _totalTokens = _totalTokens + _tokensReceived;
372         _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);
373         if(buy == true)
374         {
375             currentPrice_ = _currentPrice;
376             base = _grv;
377         }
378         return _totalTokens;
379     }
380    
381     function upperBound_(uint256 _grv)
382     internal
383     view
384     returns(uint256)
385     {
386         if(_grv <= 5)
387         {
388             return (60000 * _grv);
389         }
390         if(_grv > 5 && _grv <= 10)
391         {
392             return (300000 + ((_grv-5)*50000));
393         }
394         if(_grv > 10 && _grv <= 15)
395         {
396             return (550000 + ((_grv-10)*40000));
397         }
398         if(_grv > 15 && _grv <= 20)
399         {
400             return (750000 +((_grv-15)*30000));
401         }
402         return 0;
403     }
404    
405      function tokensToEthereum_(uint256 _tokens, bool sell)
406         internal
407         view
408         returns(uint256)
409     {
410         uint256 _tokenSupply = tokenSupply_;
411         uint256 _etherReceived = 0;
412         uint256 _grv = base;
413         uint256 tempbase = upperBound_(_grv-1);
414         uint256 _currentPrice = currentPrice_;
415         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
416         while((_tokenSupply - _tokens) < tempbase)
417         {
418             uint256 tokensToSell = _tokenSupply - tempbase;
419             if(tokensToSell == 0)
420             {
421                 _tokenSupply = _tokenSupply - 1;
422                 _grv -= 1;
423                 tempbase = upperBound_(_grv-1);
424                 continue;
425             }
426             uint256 b = ((tokensToSell-1)*_tokenPriceIncremental);
427             uint256 a = _currentPrice - b;
428             _tokens = _tokens - tokensToSell;
429             _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+b));
430             _currentPrice = a;
431             _tokenSupply = _tokenSupply - tokensToSell;
432             _grv = _grv-1 ;
433             _tokenPriceIncremental = (tokenPriceIncremental_*((2)**(_grv-1)));
434             tempbase = upperBound_(_grv-1);
435         }
436         if(_tokens > 0)
437         {
438              a = _currentPrice - ((_tokens-1)*_tokenPriceIncremental);
439              _etherReceived = _etherReceived + ((_tokens/2)*((2*a)+((_tokens-1)*_tokenPriceIncremental)));
440              _tokenSupply = _tokenSupply - _tokens;
441              _currentPrice = a;
442         }
443        
444         if(sell == true)
445         {
446             base = _grv;
447             currentPrice_ = _currentPrice;
448         }
449         return _etherReceived;
450     }
451    
452    
453     function sqrt(uint x) internal pure returns (uint y) {
454         uint z = (x + 1) / 2;
455         y = x;
456         while (z < y) {
457             y = z;
458             z = (x / z + z) / 2;
459         }
460     }
461 }
462 
463 /**
464  * @title SafeMath
465  * @dev Math operations with safety checks that throw on error
466  */
467 library SafeMath {
468 
469     /**
470     * @dev Multiplies two numbers, throws on overflow.
471     */
472     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
473         if (a == 0) {
474             return 0;
475         }
476         uint256 c = a * b;
477         assert(c / a == b);
478         return c;
479     }
480 
481     /**
482     * @dev Integer division of two numbers, truncating the quotient.
483     */
484     function div(uint256 a, uint256 b) internal pure returns (uint256) {
485         // assert(b > 0); // Solidity automatically throws when dividing by 0
486         uint256 c = a / b;
487         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
488         return c;
489     }
490 
491     /**
492     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
493     */
494     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
495         assert(b <= a);
496         return a - b;
497     }
498 
499     /**
500     * @dev Adds two numbers, throws on overflow.
501     */
502     function add(uint256 a, uint256 b) internal pure returns (uint256) {
503         uint256 c = a + b;
504         assert(c >= a);
505         return c;
506     }
507 }