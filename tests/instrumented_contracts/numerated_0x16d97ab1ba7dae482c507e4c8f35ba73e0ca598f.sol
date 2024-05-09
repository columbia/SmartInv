1 pragma solidity ^0.7.0;
2 
3 contract AdoreFinanceToken {
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
23     event RewardWithdraw(
24        address indexed from,
25        uint256 rewardAmount
26     );
27     // ERC20
28     event Transfer(
29         address indexed from,
30         address indexed to,
31         uint256 tokens
32     );
33    
34     /*=====================================
35     =            CONFIGURABLES            =
36     =====================================*/
37     string public name = "Adore Finance Token";
38     string public symbol = "XFA";
39     uint8 constant public decimals = 0;
40     uint256 public totalSupply_ = 2000000;
41     uint256 constant internal tokenPriceInitial_ = 0.00012 ether;
42     uint256 constant internal tokenPriceIncremental_ = 25000000;
43     uint256 public currentPrice_ = tokenPriceInitial_ + tokenPriceIncremental_;
44     uint256 public base = 1;
45     uint256 public basePrice = 400;
46     uint public percent = 500;
47     uint public referralPercent = 1000;
48     uint public sellPercent = 1500;
49     mapping(address => uint256) internal tokenBalanceLedger_;
50     mapping(address => uint256) internal rewardBalanceLedger_;
51     address commissionHolder;
52     uint256 internal tokenSupply_ = 0;
53     mapping(address => bool) internal administrators;
54     mapping(address => address) public genTree;
55     mapping(address => uint256) public level1Holding_;
56     address payable internal creator;
57     address payable internal management; //for management funds
58     address internal poolFund;
59     uint8[] percent_ = [7,2,1];
60     uint8[] adminPercent_ = [37,37,16,10];
61     address dev1;
62     address dev2;
63     address dev3;
64     address dev4;
65    
66     constructor()
67     {
68         creator = msg.sender;
69         administrators[creator] = true;
70     }
71     
72     function isContract(address account) public view returns (bool) {
73         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
74         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
75         // for accounts without code, i.e. `keccak256('')`
76         bytes32 codehash;
77         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
78         // solhint-disable-next-line no-inline-assembly
79         assembly { codehash := extcodehash(account) }
80         return (codehash != accountHash && codehash != 0x0);
81     }
82    
83     function withdrawRewards(address payable _customerAddress, uint256 _amount) onlyAdministrator() public returns(uint256)
84     {
85         require(rewardBalanceLedger_[_customerAddress]>_amount && _amount > 3000000000000000);
86         rewardBalanceLedger_[commissionHolder] += 3000000000000000;
87         rewardBalanceLedger_[_customerAddress] -= _amount;
88         emit RewardWithdraw(_customerAddress,_amount);
89         _amount = SafeMath.sub(_amount, 3000000000000000);
90         _customerAddress.transfer(_amount);
91     }
92 
93     function setDevs(address _dev1, address _dev2, address _dev3, address _dev4) onlyAdministrator() public{
94         dev1 = _dev1;
95         dev2 = _dev2;
96         dev3 = _dev3;
97         dev4 = _dev4;
98     }
99     function distributeCommission() onlyAdministrator() public returns(bool)
100     {
101         require(rewardBalanceLedger_[management]>100000000000000);
102         rewardBalanceLedger_[dev1] += (rewardBalanceLedger_[management]*3700)/10000;
103         rewardBalanceLedger_[dev2] += (rewardBalanceLedger_[management]*3700)/10000;
104         rewardBalanceLedger_[dev3] += (rewardBalanceLedger_[management]*1600)/10000;
105         rewardBalanceLedger_[dev4] += (rewardBalanceLedger_[management]*1000)/10000;
106         rewardBalanceLedger_[management] = 0;
107         return true;
108     }
109     
110     function withdrawRewards(uint256 _amount) onlyAdministrator() public returns(uint256)
111     {
112         address payable _customerAddress = msg.sender;
113         require(rewardBalanceLedger_[_customerAddress]>_amount && _amount > 3000000000000000);
114         rewardBalanceLedger_[_customerAddress] -= _amount;
115         rewardBalanceLedger_[commissionHolder] += 3000000000000000;
116         _amount = SafeMath.sub(_amount, 3000000000000000);
117         _customerAddress.transfer(_amount);
118     }
119     
120     function useManagementFunds(uint256 _amount) onlyAdministrator() public returns(uint256)
121     {
122         require(rewardBalanceLedger_[management]>_amount && _amount > 4000000000000000);
123         rewardBalanceLedger_[commissionHolder] += 3000000000000000;
124         rewardBalanceLedger_[management] -= _amount;
125         _amount = _amount - 3000000000000000;
126         management.transfer(_amount);
127     }
128    
129     function distributeRewards(uint256 _amountToDistribute, address _idToDistribute)
130     internal
131     {
132         uint256 _tempAmountToDistribute = _amountToDistribute;
133         for(uint i=0; i<3; i++)
134         {
135             address referrer = genTree[_idToDistribute];
136             if(referrer != address(0x0) && level1Holding_[referrer] > i && i>0)
137             {
138                 rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[i])/10;
139                 _idToDistribute = referrer;
140                 emit Reward(referrer,(_amountToDistribute*percent_[i])/10,i);
141                 _tempAmountToDistribute -= (_amountToDistribute*percent_[i])/10;
142             }
143             else if(i == 0)
144             {
145                  rewardBalanceLedger_[referrer] += (_amountToDistribute*percent_[i])/10;
146                 _idToDistribute = referrer;
147                 emit Reward(referrer,(_amountToDistribute*percent_[i])/10,i);
148                 _tempAmountToDistribute -= (_amountToDistribute*percent_[i])/10;
149             }
150             else
151             {
152                 
153             }
154         }
155         rewardBalanceLedger_[commissionHolder] += _tempAmountToDistribute;
156     }
157    
158    function setBasePrice(uint256 _price)
159     onlyAdministrator()
160     public
161     returns(bool) {
162         basePrice = _price;
163     }
164    
165     function buy(address _referredBy)
166         public
167         payable
168         returns(uint256)
169     {
170         require(!isContract(msg.sender),"Buy from contract is not allowed");
171         require(_referredBy != msg.sender,"Self Referral Not Allowed");
172         if(genTree[msg.sender]!=_referredBy)
173             level1Holding_[_referredBy] +=1;
174         genTree[msg.sender] = _referredBy;
175         purchaseTokens(msg.value);
176     }
177    
178     receive() external payable
179     {
180         require(msg.value > currentPrice_, "Very Low Amount");
181         purchaseTokens(msg.value);
182     }
183     
184     fallback() external payable
185     {
186         require(msg.value > currentPrice_, "Very Low Amount");
187         purchaseTokens(msg.value);
188     }
189    
190      bool mutex = true;
191      
192     function sell(uint256 _amountOfTokens)
193         onlyBagholders()
194         public
195     {
196         // setup data
197         require(!isContract(msg.sender),"Selling from contract is not allowed");
198         require (mutex == true);
199         address payable _customerAddress = msg.sender;
200         require(_amountOfTokens <= tokenBalanceLedger_[_customerAddress]);
201         uint256 _tokens = _amountOfTokens;
202         uint256 _ethereum = tokensToEthereum_(_tokens,true);
203         uint256 _dividends = _ethereum * (sellPercent)/10000;
204         // burn the sold tokens
205         tokenSupply_ = SafeMath.sub(tokenSupply_, _tokens);
206         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _tokens);
207         rewardBalanceLedger_[management] += _dividends;
208         rewardBalanceLedger_[commissionHolder] += 3000000000000000;
209         _dividends = _dividends + 3000000000000000;
210         _ethereum = SafeMath.sub(_ethereum,_dividends);
211         _customerAddress.transfer(_ethereum);
212         emit Transfer(_customerAddress, address(this), _tokens);
213     }
214    
215     function rewardOf(address _toCheck)
216         public view
217         returns(uint256)
218     {
219         return rewardBalanceLedger_[_toCheck];    
220     }
221    
222     function transfer(address _toAddress, uint256 _amountOfTokens)
223         onlyAdministrator()
224         public
225         returns(bool)
226     {
227         // setup
228         address _customerAddress = msg.sender;
229         // exchange tokens
230         tokenBalanceLedger_[_customerAddress] = SafeMath.sub(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
231         tokenBalanceLedger_[_toAddress] = SafeMath.add(tokenBalanceLedger_[_toAddress], _amountOfTokens);
232         emit Transfer(_customerAddress, _toAddress, _amountOfTokens);
233         return true;
234     }
235    
236     function destruct() onlyAdministrator() public{
237         selfdestruct(creator);
238     }
239    
240     function setName(string memory _name)
241         onlyAdministrator()
242         public
243     {
244         name = _name;
245     }
246    
247     function setSymbol(string memory _symbol)
248         onlyAdministrator()
249         public
250     {
251         symbol = _symbol;
252     }
253 
254     function setupWallets(address _commissionHolder, address payable _management, address _poolFunds)
255     onlyAdministrator()
256     public
257     {
258         commissionHolder = _commissionHolder;
259         management = _management;
260         poolFund = _poolFunds;
261     }
262     
263 
264     function totalEthereumBalance()
265         public
266         view
267         returns(uint)
268     {
269         return address(this).balance;
270     }
271    
272     function totalSupply()
273         public
274         view
275         returns(uint256)
276     {
277         return totalSupply_;
278     }
279    
280     function tokenSupply()
281     public
282     view
283     returns(uint256)
284     {
285         return tokenSupply_;
286     }
287    
288     /**
289      * Retrieve the tokens owned by the caller.
290      */
291     function myTokens()
292         public
293         view
294         returns(uint256)
295     {
296         address _customerAddress = msg.sender;
297         return balanceOf(_customerAddress);
298     }
299    
300    
301     /**
302      * Retrieve the token balance of any single address.
303      */
304     function balanceOf(address _customerAddress)
305         view
306         public
307         returns(uint256)
308     {
309         return tokenBalanceLedger_[_customerAddress];
310     }
311    
312     /**
313      * Return the sell price of 1 individual token.
314      */
315     function buyPrice()
316         public
317         view
318         returns(uint256)
319     {
320         return currentPrice_;
321     }
322    
323     /*==========================================
324     =            INTERNAL FUNCTIONS            =
325     ==========================================*/
326    
327     function purchaseTokens(uint256 _incomingEthereum)
328         internal
329         returns(uint256)
330     {
331         // data setup
332         uint256 _totalDividends = 0;
333         uint256 _dividends = _incomingEthereum * referralPercent/10000;
334         _totalDividends += _dividends;
335         address _customerAddress = msg.sender;
336         distributeRewards(_dividends,_customerAddress);
337         _dividends = _incomingEthereum * referralPercent/10000;
338         _totalDividends += _dividends;
339         rewardBalanceLedger_[management] += _dividends;
340         _dividends = (_incomingEthereum *percent)/10000;
341         _totalDividends += _dividends;
342         rewardBalanceLedger_[poolFund] += _dividends;
343         _incomingEthereum = SafeMath.sub(_incomingEthereum, _totalDividends);
344         
345         uint256 _amountOfTokens = ethereumToTokens_(_incomingEthereum , currentPrice_, base, true);
346         require(_amountOfTokens > 0 && (SafeMath.add(_amountOfTokens,tokenSupply_) > tokenSupply_));
347         tokenSupply_ = SafeMath.add(tokenSupply_, _amountOfTokens);
348         require(SafeMath.add(_amountOfTokens,tokenSupply_) < (totalSupply_));
349         tokenBalanceLedger_[_customerAddress] = SafeMath.add(tokenBalanceLedger_[_customerAddress], _amountOfTokens);
350         // fire event
351         emit Transfer(address(this), _customerAddress, _amountOfTokens);
352         return _amountOfTokens;
353     }
354    
355     function ethereumToTokens_(uint256 _ethereum, uint256 _currentPrice, uint256 _grv, bool _buy)
356         internal
357         returns(uint256)
358     {
359         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*(3**(_grv-1)));
360         uint256 _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);
361         uint256 _tokenSupply = tokenSupply_;
362         uint256 _totalTokens = 0;
363         uint256 _tokensReceived = (
364             (
365                 SafeMath.sub(
366                     (sqrt
367                         (
368                             _tempad**2
369                             + (8*_tokenPriceIncremental*_ethereum)
370                         )
371                     ), _tempad
372                 )
373             )/(2*_tokenPriceIncremental)
374         );
375         uint256 tempbase = upperBound_(_grv);
376         while((_tokensReceived + _tokenSupply) > tempbase){
377             _tokensReceived = tempbase - _tokenSupply;
378             _ethereum = SafeMath.sub(
379                 _ethereum,
380                 ((_tokensReceived)/2)*
381                 ((2*_currentPrice)+((_tokensReceived-1)
382                 *_tokenPriceIncremental))
383             );
384             _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);
385             _grv = _grv + 1;
386             _tokenPriceIncremental = (tokenPriceIncremental_*((3)**(_grv-1)));
387             _tempad = SafeMath.sub((2*_currentPrice), _tokenPriceIncremental);
388             uint256 _tempTokensReceived = (
389                 (
390                     SafeMath.sub(
391                         (sqrt
392                             (
393                                 _tempad**2
394                                 + (8*_tokenPriceIncremental*_ethereum)
395                             )
396                         ), _tempad
397                     )
398                 )/(2*_tokenPriceIncremental)
399             );
400             _tokenSupply = _tokenSupply + _tokensReceived;
401             _totalTokens = _totalTokens + _tokensReceived;
402             _tokensReceived = _tempTokensReceived;
403             tempbase = upperBound_(_grv);
404         }
405         _totalTokens = _totalTokens + _tokensReceived;
406         _currentPrice = _currentPrice+((_tokensReceived-1)*_tokenPriceIncremental);
407         if(_buy == true)
408         {
409             currentPrice_ = _currentPrice;
410             base = _grv;
411         }
412         return _totalTokens;
413     }
414    
415     function upperBound_(uint256 _grv)
416     internal
417     pure
418     returns(uint256)
419     {
420         uint256 topBase = 0;
421         for(uint i = 1;i<=_grv;i++)
422         {
423             topBase +=200000-((_grv-i)*10000);
424         }
425         return topBase;
426     }
427    
428      function tokensToEthereum_(uint256 _tokens, bool _sell)
429         internal
430         returns(uint256)
431     {
432         uint256 _tokenSupply = tokenSupply_;
433         uint256 _etherReceived = 0;
434         uint256 _grv = base;
435         uint256 tempbase = upperBound_(_grv-1);
436         uint256 _currentPrice = currentPrice_;
437         uint256 _tokenPriceIncremental = (tokenPriceIncremental_*((3)**(_grv-1)));
438         while((_tokenSupply - _tokens) < tempbase)
439         {
440             uint256 tokensToSell = _tokenSupply - tempbase;
441             if(tokensToSell == 0)
442             {
443                 _tokenSupply = _tokenSupply - 1;
444                 _grv -= 1;
445                 tempbase = upperBound_(_grv-1);
446                 continue;
447             }
448             uint256 b = ((tokensToSell-1)*_tokenPriceIncremental);
449             uint256 a = _currentPrice - b;
450             _tokens = _tokens - tokensToSell;
451             _etherReceived = _etherReceived + ((tokensToSell/2)*((2*a)+b));
452             _currentPrice = a;
453             _tokenSupply = _tokenSupply - tokensToSell;
454             _grv = _grv-1 ;
455             _tokenPriceIncremental = (tokenPriceIncremental_*((3)**(_grv-1)));
456             tempbase = upperBound_(_grv-1);
457         }
458         if(_tokens > 0)
459         {
460              uint256 a = _currentPrice - ((_tokens-1)*_tokenPriceIncremental);
461              _etherReceived = _etherReceived + ((_tokens/2)*((2*a)+((_tokens-1)*_tokenPriceIncremental)));
462              _tokenSupply = _tokenSupply - _tokens;
463              _currentPrice = a;
464         }
465        
466         if(_sell == true)
467         {
468             base = _grv;
469             currentPrice_ = _currentPrice;
470         }
471         return _etherReceived;
472     }
473    
474    
475     function sqrt(uint x) internal pure returns (uint y) {
476         uint z = (x + 1) / 2;
477         y = x;
478         while (z < y) {
479             y = z;
480             z = (x / z + z) / 2;
481         }
482     }
483 }
484 
485 /**
486  * @title SafeMath
487  * @dev Math operations with safety checks that throw on error
488  */
489 library SafeMath {
490 
491     /**
492     * @dev Multiplies two numbers, throws on overflow.
493     */
494     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
495         if (a == 0) {
496             return 0;
497         }
498         uint256 c = a * b;
499         assert(c / a == b);
500         return c;
501     }
502 
503     /**
504     * @dev Integer division of two numbers, truncating the quotient.
505     */
506     function div(uint256 a, uint256 b) internal pure returns (uint256) {
507         // assert(b > 0); // Solidity automatically throws when dividing by 0
508         uint256 c = a / b;
509         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
510         return c;
511     }
512 
513     /**
514     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
515     */
516     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
517         assert(b <= a);
518         return a - b;
519     }
520 
521     /**
522     * @dev Adds two numbers, throws on overflow.
523     */
524     function add(uint256 a, uint256 b) internal pure returns (uint256) {
525         uint256 c = a + b;
526         assert(c >= a);
527         return c;
528     }
529 }