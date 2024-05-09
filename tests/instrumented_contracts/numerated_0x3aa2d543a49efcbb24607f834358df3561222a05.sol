1 pragma solidity ^0.4.20;
2 
3 
4 
5 
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     if (a == 0) {
9       return 0;
10     }
11     uint256 c = a * b;
12     assert(c / a == b);
13     return c;
14   }
15 
16   function div(uint256 a, uint256 b) internal pure returns (uint256) {
17     // assert(b > 0); // Solidity automatically throws when dividing by 0
18     uint256 c = a / b;
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24     assert(b <= a);
25     return a - b;
26   }
27 
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     assert(c >= a);
31     return c;
32   }
33 }
34 
35 
36 
37 
38 contract Ownable {
39   address public owner;
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 
63 
64 contract ERC20 {
65     uint256 public totalSupply;
66     function balanceOf(address who) public view returns (uint256);
67     function transfer(address to, uint256 value) public returns (bool);
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
69     mapping(address => uint256) balances;
70 }
71 contract AthTokenInterface is ERC20{
72 
73   function delivery( address _to, uint256 _amount ) public returns( bool );
74   function afterIco( uint256 _redemptionPrice ) public  returns( bool );
75   function currentBalance() public returns( uint256 );
76   
77 }
78 
79 
80 
81 
82 
83 
84 contract Crowdsale is Ownable{
85     
86     using SafeMath for uint256;
87     
88     bool _initialize = false;
89     
90     AthTokenInterface token;
91 
92     enum CrowdsaleStates { Disabled, Presale, ICO1, ICO2, ICO3, ICO4, Finished }
93     
94     uint256 public presale                  = 750000  ether;
95     uint256 public bounty                   = 500000  ether;
96     uint256 public constant price           = 0.00024 ether;
97     uint256 public constant threshold       = 50000 ether;
98     uint256 public constant min             = price * 500;
99     uint256 public constant hardcap         = 1000 ether; 
100     uint256 public          totalEth        = 0;
101     
102     uint256 public constant affiliatThreshold1 = 1 * min;
103     uint256 public constant affiliatThreshold2 = 10 * min;
104     uint256 public constant affiliatThreshold3 = 50 * min;
105     uint256 public constant affiliatThreshold4 = 100 * min;
106     
107     uint256 public icoTimeStart          = 0;
108     uint256 public ICO1Period            = 1 days;
109     uint256 public ICO2Period            = 7 days + ICO1Period;
110     uint256 public ICO3Period            = 10 days + ICO2Period;
111     uint256 public ICO4Period            = 12 days + ICO3Period;
112     
113     
114     address[] owners;
115     
116     
117     CrowdsaleStates public CrowdsaleState = CrowdsaleStates.Disabled;
118     
119     modifier icoActive {
120         require( 
121                getCrowdsaleState() == CrowdsaleStates.Presale 
122             || getCrowdsaleState() == CrowdsaleStates.ICO1 
123             || getCrowdsaleState() == CrowdsaleStates.ICO2 
124             || getCrowdsaleState() == CrowdsaleStates.ICO3
125             || getCrowdsaleState() == CrowdsaleStates.ICO4
126             );
127         _;
128     }
129     
130     modifier Finished {
131         require( getCrowdsaleState() == CrowdsaleStates.Finished );
132         _;
133     }
134     modifier notFinished {
135         require( getCrowdsaleState() != CrowdsaleStates.Finished );
136         _;
137     }
138     
139     modifier Initialized {
140         require( _initialize );
141         _;
142     }
143     
144     
145     
146     event NewInvestor( address );
147     event NewReferrer( address );
148     event Referral( address, address, uint256, uint256 );
149     event Bounty( address, uint256 );
150     event Swap( address, address, uint256 );
151     event NewSwapToken( address );
152     event Delivery( address, uint256 );
153     
154     
155     
156     mapping( address => uint256 ) investorsTotalBalances;
157     mapping( address => uint256 ) investorsStock;
158     mapping( address => bool ) investorsCheck;
159     address[] public investors;
160     
161     
162     
163     mapping( address => bool ) referrers;
164     address[] public referrersList;
165     
166     
167     
168     
169     
170     function initialize( address _a, address[] _owners ) public onlyOwner returns( bool )
171     {
172         require( _a != address(0) && _owners.length == 2 && _owners[0] != address(0) && _owners[1] != address(0) && !_initialize );
173         
174         
175         token = AthTokenInterface( _a );
176         owners = _owners;
177         _initialize = true;
178     }
179 
180     
181     function getOwners(uint8 _i) public constant returns( address )
182     {
183         return owners[_i];
184     }
185     
186    
187     
188     function referrersCount() public constant returns( uint256 )
189     {
190         return referrersList.length;
191     }
192     
193     
194     
195     function regReferrer( address _a ) public onlyOwner Initialized returns( bool )
196     {
197         if( referrers[_a] != true ) {
198             
199             referrers[_a] = true;
200             referrersList.push( _a );
201             
202             NewReferrer( _a );
203             
204         }
205     }
206     function regReferrers( address[] _a ) public onlyOwner Initialized returns( bool )
207     {
208         for( uint256 i = 0; i <= _a.length - 1; i++ ){
209             
210             if( referrers[_a[i]] != true ) {
211             
212                 referrers[_a[i]] = true;
213                 referrersList.push( _a[i] );
214                 
215                 NewReferrer( _a[i] );
216                 
217             }
218         }
219     }
220     
221     
222     
223     function referralBonusCalculate( uint256 _amount, uint256 _amountTokens ) public pure returns( uint256 )
224     {
225         uint256 amount = 0;
226         
227         if( _amount < affiliatThreshold2  )  amount =  _amountTokens.mul( 7 ).div( 100 );
228         if( _amount < affiliatThreshold3  )  amount =  _amountTokens.mul( 10 ).div( 100 );
229         if( _amount < affiliatThreshold4  )  amount =  _amountTokens.mul( 15 ).div( 100 );
230         if( _amount >= affiliatThreshold4  ) amount =  _amountTokens.mul( 20 ).div( 100 );
231         
232         return amount;
233     }
234     
235     function referrerBonusCalculate( uint256 _amount ) public pure returns( uint256 )
236     {
237         uint256 amount = 0;
238         
239         if( _amount < affiliatThreshold2  )  amount =  _amount.mul( 3 ).div( 100 );
240         if( _amount < affiliatThreshold3  )  amount =  _amount.mul( 7 ).div( 100 );
241         if( _amount < affiliatThreshold4  )  amount =  _amount.mul( 10 ).div( 100 );
242         if( _amount >= affiliatThreshold4  ) amount =  _amount.mul( 15 ).div( 100 );
243         
244         return amount;
245     }
246     
247     
248     function redemptionPriceCalculate( uint256 _ath ) public pure returns( uint256 )
249     {
250         if( _ath >= 3333333 ether ) return price.mul( 150 ).div( 100 );
251         if( _ath >= 2917777 ether ) return price.mul( 145 ).div( 100 );
252         if( _ath >= 2500000 ether ) return price.mul( 140 ).div( 100 );
253         if( _ath >= 2083333 ether ) return price.mul( 135 ).div( 100 );
254         if( _ath >= 1700000 ether ) return price.mul( 130 ).div( 100 );
255         if( _ath >= 1250000 ether ) return price.mul( 125 ).div( 100 );  
256         
257         return price;
258     }
259     
260    
261     function() public payable
262     {
263         buy( address(0) );
264     }
265     
266 
267     
268     function buy( address _referrer ) public payable icoActive Initialized
269     {
270         
271         
272         
273       require( msg.value >= min );
274       
275 
276       uint256 _amount = crowdsaleBonus( msg.value.div( price ) * 1 ether );
277       uint256 toReferrer = 0;
278       
279       if( referrers[_referrer] ){
280           
281         toReferrer = referrerBonusCalculate( msg.value );
282         _referrer.transfer( toReferrer );
283         _amount = _amount.add( referralBonusCalculate( msg.value, _amount ) );
284         
285         Referral( _referrer, msg.sender, msg.value, _amount );
286         
287       }
288       
289       
290       
291        
292        
293       token.delivery( msg.sender, _amount );
294       totalEth = totalEth.add( msg.value );
295       
296       Delivery( msg.sender, _amount );
297       
298        
299         
300       if( getCrowdsaleState() == CrowdsaleStates.Presale ) {
301           
302           presale = presale.sub( _amount );
303           
304           for( uint256 i = 0; i <= owners.length - 1; i++ ){
305               
306             owners[i].transfer( ( msg.value.sub( toReferrer ) ).div( owners.length ) );
307             
308           }
309       
310       }
311       
312       
313       investorsTotalBalances[msg.sender]  = investorsTotalBalances[msg.sender].add( _amount );
314        
315       if( investorsTotalBalances[msg.sender] >= threshold && investorsCheck[msg.sender] == false ){
316           investors.push( msg.sender );
317           investorsCheck[msg.sender] = true;
318           
319           NewInvestor( msg.sender );
320       }
321        
322        
323       
324        
325     }
326     
327 
328     
329 
330     
331     function getCrowdsaleState() public constant returns( CrowdsaleStates )
332     {
333         if( CrowdsaleState == CrowdsaleStates.Disabled ) return CrowdsaleStates.Disabled;
334         if( CrowdsaleState == CrowdsaleStates.Finished ) return CrowdsaleStates.Finished;
335         
336         if( CrowdsaleState == CrowdsaleStates.Presale ){
337             if( presale > 0 ) 
338                 return CrowdsaleStates.Presale;
339             else
340                 return CrowdsaleStates.Disabled;
341         }
342         
343         if( CrowdsaleState == CrowdsaleStates.ICO1 ){
344             
345             if( token.currentBalance() <= 0 || totalEth >= hardcap ) return CrowdsaleStates.Finished; 
346             
347             if( now.sub( icoTimeStart ) <= ICO1Period)  return CrowdsaleStates.ICO1;
348             if( now.sub( icoTimeStart ) <= ICO2Period ) return CrowdsaleStates.ICO2;
349             if( now.sub( icoTimeStart ) <= ICO3Period ) return CrowdsaleStates.ICO3;
350             if( now.sub( icoTimeStart ) <= ICO4Period ) return CrowdsaleStates.ICO4;
351             if( now.sub( icoTimeStart ) >  ICO4Period ) return CrowdsaleStates.Finished;
352             
353         }
354     }
355     
356     
357     
358     function crowdsaleBonus( uint256 _amount ) internal constant  returns ( uint256 )
359     {
360         uint256 bonus = 0;
361         
362         if( getCrowdsaleState() == CrowdsaleStates.Presale ){
363             bonus = _amount.mul( 50 ).div( 100 );
364         }
365         
366         if( getCrowdsaleState() == CrowdsaleStates.ICO1 ){
367             bonus = _amount.mul( 35 ).div( 100 );
368         }
369         if( getCrowdsaleState() == CrowdsaleStates.ICO2 ){
370             bonus = _amount.mul( 25 ).div( 100 );
371         }
372         if( getCrowdsaleState() == CrowdsaleStates.ICO3 ){
373             bonus = _amount.mul( 15 ).div( 100 );
374         }
375         
376         return _amount.add( bonus );
377         
378     }
379     
380     
381     function startPresale() public onlyOwner notFinished Initialized returns ( bool )
382     {
383         CrowdsaleState = CrowdsaleStates.Presale;
384         return true;
385     }
386     
387     function startIco() public onlyOwner notFinished Initialized returns ( bool )
388     {
389         CrowdsaleState = CrowdsaleStates.ICO1;
390         icoTimeStart = now;
391         return true;
392     }
393     
394     
395     function completeIcoPart1() public onlyOwner Finished Initialized returns( bool )
396     {
397         //stop ico
398         CrowdsaleState = CrowdsaleStates.Finished;
399         
400         uint256 sales = token.totalSupply() - token.currentBalance();
401         
402         
403         uint256 i;
404         
405         //burn
406         if( totalEth >= hardcap ) {
407             
408             for( i = 0; i <= owners.length - 1; i++ ){
409                 token.delivery( owners[i], bounty.div( owners.length ) );
410             }
411             
412         } else {
413             
414             uint256 tmp = sales.mul( 20 ).div( 100 ).add( bounty );
415             for( i = 0; i <= owners.length - 1; i++ ){
416                 token.delivery( owners[i], tmp.div( owners.length ) );
417             }  
418             
419         }
420         
421         uint b = address(this).balance;
422          for( i = 0; i <= owners.length - 1; i++ ){
423             owners[i].transfer(  b.div( owners.length ) );
424         }
425         
426         token.afterIco(  redemptionPriceCalculate( sales )  );
427     }
428     
429     function completeIcoPart2() public onlyOwner Finished Initialized returns( bool )
430     {
431         uint256 sum = 0;
432         uint256 i = 0;
433         for( i = 0; i <= investors.length - 1; i++ ) {
434             sum = sum.add( investorsTotalBalances[ investors[i] ] );
435         }
436         for( i = 0; i <= investors.length - 1; i++ ) {
437             investorsStock[ investors[i] ] = investorsTotalBalances[ investors[i] ].mul( 100 ).div( sum );
438         }
439     }
440     
441     
442     function investorsCount() public constant returns( uint256 )
443     {
444         return investors.length ;
445     }
446     
447     function investorsAddress( uint256 _i ) public constant returns( address )
448     {
449         return investors[_i] ;
450     }
451     
452     function investorsInfo( address _a ) public constant returns( uint256, uint256 )
453     {
454         return ( investorsTotalBalances[_a], investorsStock[_a] );
455     }
456     
457     function investorsStockInfo( address _a)  public constant returns(uint256)
458     {
459         return  investorsStock[_a];
460     }
461     
462     
463 
464     
465     function bountyTransfer( address _to, uint256 amount) public onlyOwner Initialized returns( bool )
466     {
467         
468         
469         require( bounty >= amount && token.currentBalance() >= amount );
470         
471         
472         token.delivery( _to, amount );
473         bounty = bounty.sub( amount );
474         
475         Delivery( _to, amount );
476         Bounty( _to, amount );
477         
478     }
479     
480     
481     
482     
483     bool public swapActivity = true;
484     address[] tokenList;
485     mapping( address => uint256 ) tokenRateAth;
486     mapping( address => uint256 ) tokenRateToken;
487     mapping( address => uint256 ) tokenLimit;
488     mapping( address => uint256 ) tokenMinAmount;
489     mapping( address => bool ) tokenActivity;
490     mapping( address => bool ) tokenFirst;
491     mapping ( address => uint256 ) tokenSwapped;
492     
493     
494     function swapActivityHandler() public onlyOwner
495     {
496         swapActivity = !swapActivity;
497     }
498     
499     
500     function setSwapToken( address _a, uint256 _rateAth, uint256 _rateToken, uint256 _limit, uint256 _minAmount,  bool _activity ) public onlyOwner returns( bool )
501     {
502        if( tokenFirst[_a] == false ) {
503            tokenFirst[_a] = true;
504            
505            NewSwapToken( _a );
506        }
507        
508        tokenRateAth[_a]     = _rateAth;
509        tokenRateToken[_a]   = _rateToken;
510        tokenLimit[_a]       = _limit;
511        tokenMinAmount[_a]   = _minAmount;
512        tokenActivity[_a]    = _activity;
513     }
514     
515 
516     function swapTokenInfo( address _a) public constant returns( uint256, uint256, uint256, uint256,  bool )
517     {
518         return ( tokenRateAth[_a], tokenRateToken[_a], tokenLimit[_a], tokenMinAmount[_a], tokenActivity[_a] );
519     }
520     
521     function swap( address _a, uint256 _amount ) public returns( bool )
522     {
523         require( swapActivity && tokenActivity[_a] && ( _amount >= tokenMinAmount[_a] ) );
524         
525         uint256 ath = tokenRateAth[_a].mul( _amount ).div( tokenRateToken[_a] );
526         tokenSwapped[_a] = tokenSwapped[_a].add( ath );
527         
528         require( ath > 0 && bounty >= ath && tokenSwapped[_a] <= tokenLimit[_a] );
529         
530         ERC20 ercToken = ERC20( _a );
531         ercToken.transferFrom( msg.sender, address(this), _amount );
532         
533         for( uint256 i = 0; i <= owners.length - 1; i++ )
534           ercToken.transfer( owners[i], _amount.div( owners.length ) );
535           
536         token.delivery( msg.sender, ath );
537         bounty = bounty.sub( ath );
538         
539         Delivery( msg.sender, ath );
540         Swap( msg.sender, _a, ath );
541         
542     }
543     
544 }