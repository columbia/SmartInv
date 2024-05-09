1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) 
6   {
7     uint256 c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) 
13   {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) 
21   {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) 
27   {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 
33 }
34 
35 
36 /**
37  * @title Ownable
38  */
39 contract Ownable 
40 {
41   address public owner;
42 
43   event OwnerChanged(address indexed _oldOwner, address indexed _newOwner);
44 	
45 	function Ownable() public
46   {
47     owner = msg.sender;
48   }
49 
50   modifier onlyOwner() 
51   {
52     require(msg.sender == owner);
53     _;
54   }
55 
56   function changeOwner(address _newOwner) onlyOwner public 
57   {
58     require(_newOwner != address(0));
59     
60     address oldOwner = owner;
61     if (oldOwner != _newOwner)
62     {
63     	owner = _newOwner;
64     	
65     	OwnerChanged(oldOwner, _newOwner);
66     }
67   }
68 
69 }
70 
71 
72 /**
73  * @title Manageable
74  */
75 contract Manageable is Ownable
76 {
77 	address public manager;
78 	
79 	event ManagerChanged(address indexed _oldManager, address _newManager);
80 	
81 	function Manageable() public
82 	{
83 		manager = msg.sender;
84 	}
85 	
86 	modifier onlyManager()
87 	{
88 		require(msg.sender == manager);
89 		_;
90 	}
91 	
92 	modifier onlyOwnerOrManager() 
93 	{
94 		require(msg.sender == owner || msg.sender == manager);
95 		_;
96 	}
97 	
98 	function changeManager(address _newManager) onlyOwner public 
99 	{
100 		require(_newManager != address(0));
101 		
102 		address oldManager = manager;
103 		if (oldManager != _newManager)
104 		{
105 			manager = _newManager;
106 			
107 			ManagerChanged(oldManager, _newManager);
108 		}
109 	}
110 	
111 }
112 
113 
114 /**
115  * @title CrowdsaleToken
116  */
117 contract CrowdsaleToken is Manageable
118 {
119   using SafeMath for uint256;
120 
121   string public constant name     = "EBCoin";
122   string public constant symbol   = "EBC";
123   uint8  public constant decimals = 18;
124   
125   uint256 public totalSupply;
126   mapping(address => uint256) balances;
127   mapping (address => mapping (address => uint256)) internal allowed;
128   mapping (address => uint256) public releaseTime;
129   bool public released;
130 
131   event Transfer(address indexed _from, address indexed _to, uint256 _value);
132   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
133   event Mint(address indexed _to, uint256 _value);
134   event ReleaseTimeChanged(address indexed _owner, uint256 _oldReleaseTime, uint256 _newReleaseTime);
135   event ReleasedChanged(bool _oldReleased, bool _newReleased);
136 
137   modifier canTransfer(address _from)
138   {
139   	if (releaseTime[_from] == 0)
140   	{
141   		require(released);
142   	}
143   	else
144   	{
145   		require(releaseTime[_from] <= now);
146   	}
147   	_;
148   }
149 
150   function balanceOf(address _owner) public constant returns (uint256)
151   {
152     return balances[_owner];
153   }
154 
155   function transfer(address _to, uint256 _value) canTransfer(msg.sender) public returns (bool) 
156   {
157     require(_to != address(0));
158     require(_value <= balances[msg.sender]);
159 
160     balances[msg.sender] = balances[msg.sender].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     
163     Transfer(msg.sender, _to, _value);
164     
165     return true;
166   }
167 
168   function allowance(address _owner, address _spender) public constant returns (uint256) 
169   {
170     return allowed[_owner][_spender];
171   }
172   
173   function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) public returns (bool) 
174   {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     
183     Transfer(_from, _to, _value);
184     
185     return true;
186   }
187   
188   function allocate(address _sale, address _investor, uint256 _value) onlyOwnerOrManager public 
189   {
190   	require(_sale != address(0));
191   	Crowdsale sale = Crowdsale(_sale);
192   	address pool = sale.pool();
193 
194     require(_investor != address(0));
195     require(_value <= balances[pool]);
196     require(_value <= allowed[pool][msg.sender]);
197 
198     balances[pool] = balances[pool].sub(_value);
199     balances[_investor] = balances[_investor].add(_value);
200     allowed[pool][_sale] = allowed[pool][_sale].sub(_value);
201     
202     Transfer(pool, _investor, _value);
203   }
204   
205   function deallocate(address _sale, address _investor, uint256 _value) onlyOwnerOrManager public 
206   {
207   	require(_sale != address(0));
208   	Crowdsale sale = Crowdsale(_sale);
209   	address pool = sale.pool();
210   	
211     require(_investor != address(0));
212   	require(_value <= balances[_investor]);
213   	
214   	balances[_investor] = balances[_investor].sub(_value);
215   	balances[pool] = balances[pool].add(_value);
216   	allowed[pool][_sale] = allowed[pool][_sale].add(_value);
217   	
218   	Transfer(_investor, pool, _value);
219   }
220 
221  	function approve(address _spender, uint256 _value) public returns (bool) 
222  	{
223     allowed[msg.sender][_spender] = _value;
224     
225     Approval(msg.sender, _spender, _value);
226     
227     return true;
228   }
229 
230   function mint(address _to, uint256 _value, uint256 _releaseTime) onlyOwnerOrManager public returns (bool) 
231   {
232   	require(_to != address(0));
233   	
234     totalSupply = totalSupply.add(_value);
235     balances[_to] = balances[_to].add(_value);
236     
237     Mint(_to, _value);
238     Transfer(0x0, _to, _value);
239     
240     setReleaseTime(_to, _releaseTime);
241     
242     return true;
243   }
244 
245   function setReleaseTime(address _owner, uint256 _newReleaseTime) onlyOwnerOrManager public
246   {
247     require(_owner != address(0));
248     
249   	uint256 oldReleaseTime = releaseTime[_owner];
250   	if (oldReleaseTime != _newReleaseTime)
251   	{
252   		releaseTime[_owner] = _newReleaseTime;
253     
254     	ReleaseTimeChanged(_owner, oldReleaseTime, _newReleaseTime);
255     }
256   }
257   
258   function setReleased(bool _newReleased) onlyOwnerOrManager public
259   {
260   	bool oldReleased = released;
261   	if (oldReleased != _newReleased)
262   	{
263   		released = _newReleased;
264   	
265   		ReleasedChanged(oldReleased, _newReleased);
266   	}
267   }
268   
269 }
270 
271 
272 /**
273  * @title Crowdsale
274  */
275 contract Crowdsale is Manageable
276 {
277   using SafeMath for uint256;
278 
279   CrowdsaleToken public token;
280 
281   uint256 public startTime;
282   uint256 public endTime  ;
283 
284   uint256 public rate;
285   
286   uint256 public constant decimals = 18;
287   
288   uint256 public tokenSaleWeiCap;		
289   uint256 public tokenSaleWeiGoal;	
290   uint256 public tokenSaleWeiMax;		
291   uint256 public tokenSaleWeiMin;		
292   
293   address public pool; 
294   address public wallet;
295 
296   bool public isFinalized = false;
297 
298   enum State { Created, Active, Closed }
299 
300   uint256 public totalAllocated;
301   mapping (address => uint256) public allocated;
302   
303   uint256 public totalDeposited;
304   mapping (address => uint256) public deposited;
305 
306   State public state;
307 
308   event Closed();
309   event Finalized();
310   event FundWithdrawed(uint256 ethAmount);
311   event TokenPurchased(address indexed _purchaser, address indexed _investor, uint256 _value, uint256 _amount, bytes _data);
312   event TokenReturned(address indexed _investor, uint256 _value);
313 
314   function Crowdsale() public
315   {
316   	state = State.Created;
317   }
318   
319   function initCrowdsale(address _pool, address _token, uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _tokenSaleWeiCap, uint256 _tokenSaleWeiGoal, uint256 _tokenSaleWeiMax, uint256 _tokenSaleWeiMin, address _wallet) onlyOwnerOrManager public
320   {
321     require(state == State.Created);
322   	require(_pool != address(0));
323     require(_token != address(0));
324     require(_startTime >= now);
325     require(_endTime >= _startTime);
326     require(_endTime >= now);
327     require(_rate > 0);
328     require(_tokenSaleWeiCap >= _tokenSaleWeiGoal);
329     require(_wallet != 0x0);
330     
331     state = State.Active;
332     
333     pool             = _pool;
334     token            = CrowdsaleToken(_token);
335     startTime        = _startTime;
336     endTime          = _endTime;
337     rate             = _rate;
338     tokenSaleWeiCap  = _tokenSaleWeiCap;
339     tokenSaleWeiGoal = _tokenSaleWeiGoal;
340     tokenSaleWeiMax  = _tokenSaleWeiMax;
341     tokenSaleWeiMin  = _tokenSaleWeiMin;
342     wallet           = _wallet;
343   }
344 
345   function allocation(address _investor) public constant returns (uint256)
346   {
347   	return allocated[_investor];
348   }
349 
350   function () payable public
351   {
352     buyTokens(msg.sender);
353   }
354 
355   function buyTokens(address _investor) public payable 
356   {
357     require(_investor != 0x0);
358     require(startTime <= now && now <= endTime);
359     require(msg.value != 0);
360     require(state == State.Active);
361     
362     require(totalAllocated <= tokenSaleWeiCap);
363     
364     uint256 ethWeiAmount = msg.value;
365     
366     uint256 tokenWeiAmount = ethWeiAmount.mul(rate);
367     
368     uint256 personTokenWeiAmount = allocated[_investor].add(tokenWeiAmount);
369     
370     require(tokenSaleWeiMin <= personTokenWeiAmount);
371     require(personTokenWeiAmount <= tokenSaleWeiMax);
372     
373     totalAllocated = totalAllocated.add(tokenWeiAmount);
374 
375     totalDeposited = totalDeposited.add(ethWeiAmount);
376     
377     allocated[_investor] = personTokenWeiAmount;
378     
379     deposited[_investor] = deposited[_investor].add(ethWeiAmount);
380     
381     token.allocate(this, _investor, tokenWeiAmount);
382     
383     TokenPurchased(msg.sender, _investor, ethWeiAmount, tokenWeiAmount, msg.data);
384   }
385 
386   function deallocate(address _investor, uint256 _value) onlyOwnerOrManager public 
387   {
388   	require(_investor != address(0));
389   	require(_value > 0);
390     require(_value <= allocated[_investor]);
391 
392 		totalAllocated = totalAllocated.sub(_value);
393 		
394 		allocated[_investor] = allocated[_investor].sub(_value);
395 		
396 		token.deallocate(this, _investor, _value);
397 		
398 		TokenReturned(_investor, _value);
399   }
400 
401   function goalReached() public constant returns (bool)
402   {
403     return totalAllocated >= tokenSaleWeiGoal;
404   }
405 
406   function hasEnded() public constant returns (bool) 
407   {
408     bool capReached = (totalAllocated >= tokenSaleWeiCap);
409     return (now > endTime) || capReached;
410   }
411 
412   function finalize() onlyOwnerOrManager public 
413   {
414     require(!isFinalized);
415     require(hasEnded());
416 
417     if (goalReached()) 
418     {
419       close();
420     } 
421     
422     Finalized();
423 
424     isFinalized = true;
425   }
426 
427   function close() onlyOwnerOrManager public
428   {
429     require(state == State.Active);
430     
431     state = State.Closed;
432     
433     Closed();
434   }
435 
436   function withdraw() onlyOwnerOrManager public
437   {
438   	require(state == State.Closed);
439   	
440   	uint256 depositedValue = this.balance;
441   	if (depositedValue > 0)
442   	{
443   		wallet.transfer(depositedValue);
444   	
445   		FundWithdrawed(depositedValue);
446   	}
447   }
448   
449 }
450 
451 
452 /**
453  * @title CrowdsaleManager
454  */
455 contract CrowdsaleManager is Manageable 
456 {
457   using SafeMath for uint256;
458   
459   uint256 public constant decimals = 18;
460 
461   CrowdsaleToken public token;
462   Crowdsale      public sale1;
463   Crowdsale      public sale2;
464   Crowdsale      public sale3;
465   
466   address public constant tokenReserved1Deposit = 0x6EE96ba492a738BDD080d7353516133ea806DDee;
467   address public constant tokenReserved2Deposit = 0xAFBcB72fE97A5191d03E328dE07BB217dA21EaE4;
468   address public constant tokenReserved3Deposit = 0xd7118eE872870040d86495f13E61b88EE5C93586;
469   address public constant tokenReserved4Deposit = 0x08ce2b3512aE0387495AB5f61e6B0Cf846Ae59a7;
470   
471   address public constant withdrawWallet1       = 0xf8dafE5ee19a28b95Ad93e05575269EcEE19DDf2;
472   address public constant withdrawWallet2       = 0x6f4aF515ECcE22EA0D1AB82F8742E058Ac4d9cb3;
473   address public constant withdrawWallet3       = 0xd172E0DEe60Af67dA3019Ad539ce3190a191d71D;
474 
475   uint256 public constant tokenSale      = 750000000 * 10**decimals + 3000 * 1000 * 10**decimals;
476   uint256 public constant tokenReserved1 = 150000000 * 10**decimals - 3000 * 1000 * 10**decimals;
477   uint256 public constant tokenReserved2 = 270000000 * 10**decimals;           			 
478   uint256 public constant tokenReserved3 = 105000000 * 10**decimals;                		
479   uint256 public constant tokenReserved4 = 225000000 * 10**decimals;                      	
480   
481   function CrowdsaleManager() public
482   {
483   }
484   
485   function createToken() onlyOwnerOrManager public
486   {
487     token = new CrowdsaleToken();
488   }
489   
490   function mintToken() onlyOwnerOrManager public
491   {
492     token.mint(this                 , tokenSale     , now       );
493     token.mint(tokenReserved1Deposit, tokenReserved1, now       );
494     token.mint(tokenReserved2Deposit, tokenReserved2, 1544158800);
495     token.mint(tokenReserved3Deposit, tokenReserved3, 1544158800);
496     token.mint(tokenReserved4Deposit, tokenReserved4, 0         );
497   }
498   
499   function createSale1() onlyOwnerOrManager public
500   {
501     sale1 = new Crowdsale();
502   }
503   
504   function initSale1() onlyOwnerOrManager public
505   {
506     uint256 startTime 				= 1512622800;
507     uint256 endTime   				= 1515301200;
508     uint256 rate      				= 3450;		
509     
510     uint256 tokenSaleWeiCap		= 150000000000000000000000000;
511     uint256 tokenSaleWeiGoal	=  10350000000000000000000000;		
512     uint256 tokenSaleWeiMax		=    345000000000000000000000;	
513     uint256 tokenSaleWeiMin		=      3450000000000000000000;	
514     
515     sale1.initCrowdsale(this, token, startTime, endTime, rate, tokenSaleWeiCap, tokenSaleWeiGoal, tokenSaleWeiMax, tokenSaleWeiMin, withdrawWallet1);
516     
517     token.approve(sale1, tokenSaleWeiCap.add(tokenSaleWeiMax));
518     
519     token.changeManager(sale1);
520   }
521   
522   function finalizeSale1() onlyOwnerOrManager public
523   {
524   	sale1.finalize();
525   }
526   
527   function closeSale1() onlyOwnerOrManager public
528   {
529   	sale1.close();
530   }
531   
532   function withdrawSale1() onlyOwnerOrManager public
533   {
534   	sale1.withdraw();
535   }
536   
537   function createSale2() onlyOwnerOrManager public
538   {
539     sale2 = new Crowdsale();
540   }
541   
542   function initSale2() onlyOwnerOrManager public
543   {
544     uint256 startTime 				= 1515474000;
545     uint256 endTime   				= 1517288400;
546     uint256 rate      				= 3000;		
547     
548     uint256 tokenSaleWeiCap		= 375000000000000000000000000;
549     uint256 tokenSaleWeiGoal	=                           0;		
550     uint256 tokenSaleWeiMax		=   3000000000000000000000000;	
551     uint256 tokenSaleWeiMin		=      3000000000000000000000;	
552 
553    	tokenSaleWeiCap = tokenSaleWeiCap.add(sale1.tokenSaleWeiCap());
554    	tokenSaleWeiCap = tokenSaleWeiCap.sub(sale1.totalAllocated());
555     
556     sale2.initCrowdsale(this, token, startTime, endTime, rate, tokenSaleWeiCap, tokenSaleWeiGoal, tokenSaleWeiMax, tokenSaleWeiMin, withdrawWallet2);
557     
558     token.approve(sale2, tokenSaleWeiCap.add(tokenSaleWeiMax));
559     
560     token.changeManager(sale2);
561   }
562   
563   function finalizeSale2() onlyOwnerOrManager public
564   {
565   	sale2.finalize();
566   }
567   
568   function closeSale2() onlyOwnerOrManager public
569   {
570   	sale2.close();
571   }
572   
573   function withdrawSale2() onlyOwnerOrManager public
574   {
575   	sale2.withdraw();
576   }
577   
578   function createSale3() onlyOwnerOrManager public
579   {
580     sale3 = new Crowdsale();
581   }
582   
583   function initSale3(uint256 _startTime, uint256 _endTime, uint256 _rate, uint256 _cap, uint256 _goal, uint256 _max, uint _min) onlyOwnerOrManager public
584   {
585     require(_startTime >= now);
586     require(_endTime >= _startTime);
587     require(_rate > 0);
588     require(_cap >= _goal);
589   
590     uint256 startTime 				= _startTime;
591     uint256 endTime   				= _endTime;
592     uint256 rate      				= _rate;
593     
594     uint256 tokenSaleWeiCap		= _cap;
595     uint256 tokenSaleWeiGoal	= _goal;	
596     uint256 tokenSaleWeiMax		= _max;	
597     uint256 tokenSaleWeiMin		= _min;	
598 
599     sale3.initCrowdsale(this, token, startTime, endTime, rate, tokenSaleWeiCap, tokenSaleWeiGoal, tokenSaleWeiMax, tokenSaleWeiMin, withdrawWallet3);
600     
601     token.approve(sale3, tokenSaleWeiCap.add(tokenSaleWeiMax));
602     
603     token.changeManager(sale3);
604   }
605   
606   function finalizeSale3() onlyOwnerOrManager public
607   {
608   	sale3.finalize();
609   }
610   
611   function closeSale3() onlyOwnerOrManager public
612   {
613   	sale3.close();
614   }
615   
616   function withdrawSale3() onlyOwnerOrManager public
617   {
618   	sale3.withdraw();
619   }
620   
621   function releaseTokenTransfer(bool _newReleased) onlyOwner public
622   {
623   	token.setReleased(_newReleased);
624   }
625   
626   function changeTokenManager(address _newManager) onlyOwner public
627   {
628   	token.changeManager(_newManager);
629   }
630   
631   function changeSaleManager(address _sale, address _newManager) onlyOwner public
632   {
633   	require(_sale != address(0));
634   	Crowdsale sale = Crowdsale(_sale);
635   	
636   	sale.changeManager(_newManager);
637   }
638   
639   function deallocate(address _sale, address _investor) onlyOwner public
640   {
641   	require(_sale != address(0));
642   	Crowdsale sale = Crowdsale(_sale);
643   	
644   	uint256 allocatedValue = sale.allocation(_investor);
645   	
646   	sale.deallocate(_investor, allocatedValue);
647   }
648   
649   function promotionAllocate(address _investor, uint256 _value) onlyOwner public
650   {
651   	token.transfer(_investor, _value);
652   }
653   
654 }