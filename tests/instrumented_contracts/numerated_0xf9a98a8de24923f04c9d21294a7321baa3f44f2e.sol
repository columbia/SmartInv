1 pragma solidity ^0.4.25;
2 
3 
4 /**
5 
6 
7 					.----------------.  .----------------.  .----------------.  .----------------. 
8 					| .--------------. || .--------------. || .--------------. || .--------------. |
9 					| |  ____  ____  | || |     ____     | || |   _____      | || |  ________    | |
10 					| | |_   ||   _| | || |   .'    `.   | || |  |_   _|     | || | |_   ___ `.  | |
11 					| |   | |__| |   | || |  /  .--.  \  | || |    | |       | || |   | |   `. \ | |
12 					| |   |  __  |   | || |  | |    | |  | || |    | |   _   | || |   | |    | | | |
13 					| |  _| |  | |_  | || |  \  `--'  /  | || |   _| |__/ |  | || |  _| |___.' / | |
14 					| | |____||____| | || |   `.____.'   | || |  |________|  | || | |________.'  | |
15 					| |              | || |              | || |              | || |              | |
16 					| '--------------' || '--------------' || '--------------' || '--------------' |
17 					'----------------'  '----------------'  '----------------'  '----------------' 
18 
19  
20 */
21 
22 	/*==============================
23     =          Version 6.5         =
24     ==============================*/
25 	
26 
27 //** Contract 01
28 contract EthereumSmartContract {    
29     address EthereumNodes; 
30 	
31     constructor() public { 
32         EthereumNodes = msg.sender;
33     }
34     modifier restricted() {
35         require(msg.sender == EthereumNodes);
36         _;
37     } 
38 	
39     function GetEthereumNodes() public view returns (address owner) {
40         return EthereumNodes;
41     }
42 }
43 
44 //** Contract 02
45 contract ldoh is EthereumSmartContract {
46 	
47 	/*==============================
48     =            EVENTS            =
49     ==============================*/
50 	
51 	event onAffiliateBonus(
52 		  address indexed hodler,
53 		  address indexed tokenAddress,
54 	      string tokenSymbol,
55 		  uint256 amount,
56 		  uint256 endtime
57 		);
58 		
59 	event onClaimTokens(
60 		  address indexed hodler,
61 		  address indexed tokenAddress,
62 	      string tokenSymbol,
63 		  uint256 amount,
64 		  uint256 endtime
65 		);		
66 		
67 	event onHodlTokens(
68 		  address indexed hodler,
69 		  address indexed tokenAddress,
70 	      string tokenSymbol,
71 		  uint256 amount,
72 		  uint256 endtime
73 		);				
74 		
75 	event onAddContractAddress(
76 		  address indexed contracthodler,
77 		  bool contractstatus,
78 	      uint256 _maxcontribution,
79 		  string _ContractSymbol
80 		);	
81 		
82 	event onCashbackCode(
83 		  address indexed hodler,
84 		  address cashbackcode
85 		);			
86 	
87 	event onUnlockedTokens(
88 	      uint256 returned
89 		);		
90 		
91 	event onReturnAll( 
92 	      uint256 returned   	// Delete
93 		);
94 	
95 	
96 	
97 	/*==============================
98     =          VARIABLES           =
99     ==============================*/   
100 
101 	address internal DefaultToken;		
102 	
103 		// Struct Database
104 
105     struct Safe {
106         uint256 id;						// 01 -- > Registration Number
107         uint256 amount;					// 02 -- > Total amount of contribution to this transaction
108         uint256 endtime;				// 03 -- > The Expiration Of A Hold Platform Based On Unix Time
109         address user;					// 04 -- > The ETH address that you are using
110         address tokenAddress;			// 05 -- > The Token Contract Address That You Are Using
111 		string  tokenSymbol;			// 06 -- > The Token Symbol That You Are Using
112 		uint256 amountbalance; 			// 07 -- > 88% from Contribution / 72% Without Cashback
113 		uint256 cashbackbalance; 		// 08 -- > 16% from Contribution / 0% Without Cashback
114 		uint256 lasttime; 				// 09 -- > The Last Time You Withdraw Based On Unix Time
115 		uint256 percentage; 			// 10 -- > The percentage of tokens that are unlocked every month ( Default = 3% )
116 		uint256 percentagereceive; 		// 11 -- > The Percentage You Have Received
117 		uint256 tokenreceive; 			// 12 -- > The Number Of Tokens You Have Received
118 		uint256 lastwithdraw; 			// 13 -- > The Last Amount You Withdraw
119 		address referrer; 				// 14 -- > Your ETH referrer address
120     }
121 	
122 		// Uint256
123 	
124 	uint256 public 	percent 				= 1200;        	// 01 -- > Monthly Unlock Percentage (Default 3%)
125 	uint256 private constant affiliate 		= 12;        	// 02 -- > Affiliate Bonus = 12% Of Total Contributions
126 	uint256 private constant cashback 		= 16;        	// 03 -- > Cashback Bonus = 16% Of Total Contributions
127 	uint256 private constant nocashback 	= 28;        	// 04 -- > Total % loss amount if you don't get cashback
128 	uint256 private constant totalreceive 	= 88;        	// 05 -- > The total amount you will receive
129     uint256 private constant seconds30days 	= 2592000;  	// 06 -- > Number Of Seconds In One Month
130 	uint256 public  hodlingTime;							// 07 -- > Length of hold time in seconds
131 	uint256 private _currentIndex; 							// 08 -- > ID number ( Start from 500 )							//IDNumber
132 	uint256 public  _countSafes; 							// 09 -- > Total Smart Contract User							//TotalUser
133 	
134 		// Mapping
135 	
136 	mapping(address => bool) 			public contractaddress; 	// 01 -- > Contract Address 	
137 	mapping(address => address) 		public cashbackcode; 		// 02 -- > Cashback Code 							
138 	mapping(address => uint256) 		public _totalSaved; 		// 03 -- > Token Balance				//TokenBalance		
139 	mapping(address => uint256[]) 		public _userSafes;			// 04 -- > Search ID by Address 		//IDAddress
140 	mapping(address => uint256) 		private EthereumVault;    	// 05 -- > Reserve Funds				
141 	mapping(uint256 => Safe) 			private _safes; 			// 06 -- > Struct safe database			
142 	mapping(address => uint256) 		public maxcontribution; 	// 07 -- > Maximum Contribution					//N				
143 	mapping(address => uint256) 		public AllContribution; 	// 08 -- > Deposit amount for all members		//N	
144 	mapping(address => uint256) 		public AllPayments; 		// 09 -- > Withdraw amount for all members		//N
145 	mapping(address => string) 			public ContractSymbol; 		// 10 -- > Contract Address Symbol				//N
146 	mapping(address => address[]) 		public afflist;				// 11 -- > Affiliate List by ID					//N
147 	
148     	// Double Mapping
149 
150 	mapping (address => mapping (address => uint256)) public LifetimeContribution;	// 01 -- > Total Deposit Amount Based On Address & Token  //N
151 	mapping (address => mapping (address => uint256)) public LifetimePayments;		// 02 -- > Total Withdraw Amount Based On Address & Token //N	
152 	mapping (address => mapping (address => uint256)) public Affiliatevault;		// 02 -- > Affiliate Balance That Hasn't Been Withdrawn	  //N
153 	mapping (address => mapping (address => uint256)) public Affiliateprofit;		// 03 -- > The Amount Of Profit As An Affiliate			  //N
154 	
155 	
156 	
157 	/*==============================
158     =          CONSTRUCTOR         =
159     ==============================*/  	
160    
161     constructor() public {
162         	 	
163         hodlingTime 	= 730 days;
164         _currentIndex 	= 500;
165     }
166     
167 	
168 	
169 	/*==============================
170     =    AVAILABLE FOR EVERYONE    =
171     ==============================*/  
172 
173 //** Function 01 - Fallback Function To Receive Donation In Eth
174     function () public payable {
175         require(msg.value > 0);       
176         EthereumVault[0x0] = add(EthereumVault[0x0], msg.value);
177     }
178 	
179 //** Function 02 - Cashback Code  
180     function CashbackCode(address _cashbackcode) public {
181 		require(_cashbackcode != msg.sender);
182 		
183 		if (cashbackcode[msg.sender] == 0) {
184 			cashbackcode[msg.sender] = _cashbackcode;
185 			emit onCashbackCode(msg.sender, _cashbackcode);
186 		}		             
187     } 
188 	
189 //** Function 03 - Contribute (Hodl Platform)
190     function HodlTokens(address tokenAddress, uint256 amount) public {
191         require(tokenAddress != 0x0);
192 		require(amount > 0 && amount <= maxcontribution[tokenAddress] );
193 		
194 		if (contractaddress[tokenAddress] == false) {
195 			revert();
196 		}
197 		else {
198 			
199 		
200         ERC20Interface token = ERC20Interface(tokenAddress);       
201         require(token.transferFrom(msg.sender, address(this), amount));
202 		
203 		uint256 affiliatecomission 		= div(mul(amount, affiliate), 100); 	
204 		uint256 no_cashback 			= div(mul(amount, nocashback), 100); 	
205 		
206 		 	if (cashbackcode[msg.sender] == 0 ) { 				
207 			uint256 data_amountbalance 		= div(mul(amount, 72), 100);	
208 			uint256 data_cashbackbalance 	= 0; 
209 			address data_referrer			= EthereumNodes;
210 			
211 			cashbackcode[msg.sender] = EthereumNodes;
212 			emit onCashbackCode(msg.sender, EthereumNodes);
213 			
214 			EthereumVault[tokenAddress] 	= add(EthereumVault[tokenAddress], no_cashback);
215 			
216 			} else { 	
217 			data_amountbalance 				= sub(amount, affiliatecomission);			
218 			data_cashbackbalance 			= div(mul(amount, cashback), 100);			
219 			data_referrer					= cashbackcode[msg.sender];
220 			uint256 referrer_contribution 	= LifetimeContribution[data_referrer][tokenAddress];
221 			
222 			uint256 mycontribution			= add(LifetimeContribution[msg.sender][tokenAddress], amount);
223 
224 				if (referrer_contribution >= mycontribution) {
225 		
226 					Affiliatevault[data_referrer][tokenAddress] 	= add(Affiliatevault[data_referrer][tokenAddress], affiliatecomission); 
227 					Affiliateprofit[data_referrer][tokenAddress] 	= add(Affiliateprofit[data_referrer][tokenAddress], affiliatecomission); 
228 					
229 				} else {
230 					
231 					uint256 Newbie 	= div(mul(referrer_contribution, affiliate), 100); 
232 					
233 					Affiliatevault[data_referrer][tokenAddress] 	= add(Affiliatevault[data_referrer][tokenAddress], Newbie); 
234 					Affiliateprofit[data_referrer][tokenAddress] 	= add(Affiliateprofit[data_referrer][tokenAddress], Newbie); 
235 					
236 					uint256 data_unusedfunds 		= sub(affiliatecomission, Newbie);	
237 					EthereumVault[tokenAddress] 	= add(EthereumVault[tokenAddress], data_unusedfunds);
238 					
239 				}
240 			
241 			} 	
242 			  		  				  					  
243 	// Insert to Database  		
244 	
245 		afflist[data_referrer].push(msg.sender);	
246 		_userSafes[msg.sender].push(_currentIndex);
247 		_safes[_currentIndex] = 
248 
249 		Safe(
250 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, data_referrer);	
251 
252 		LifetimeContribution[msg.sender][tokenAddress] = add(LifetimeContribution[msg.sender][tokenAddress], amount); 		
253 		
254 	// Update AllContribution, _totalSaved, _currentIndex, _countSafes
255 		AllContribution[tokenAddress] 	= add(AllContribution[tokenAddress], amount);   	
256         _totalSaved[tokenAddress] 		= add(_totalSaved[tokenAddress], amount);     		
257         _currentIndex++;
258         _countSafes++;
259         
260         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
261     }	
262 			
263 			
264 }
265 		
266 	
267 //** Function 04 - Claim Token That Has Been Unlocked
268     function ClaimTokens(address tokenAddress, uint256 id) public {
269         require(tokenAddress != 0x0);
270         require(id != 0);        
271         
272         Safe storage s = _safes[id];
273         require(s.user == msg.sender);  
274 		
275 		if (s.amountbalance == 0) {
276 			revert();
277 		}
278 		else {
279 			UnlockToken(tokenAddress, id);
280 		}
281     }
282     
283     function UnlockToken(address tokenAddress, uint256 id) private {
284         Safe storage s = _safes[id];
285         
286         require(s.id != 0);
287         require(s.tokenAddress == tokenAddress);
288 
289         uint256 eventAmount;
290         address eventTokenAddress = s.tokenAddress;
291         string memory eventTokenSymbol = s.tokenSymbol;		
292 		     
293         if(s.endtime < now) // Hodl Complete
294         {
295             PayToken(s.user, s.tokenAddress, s.amountbalance);
296             
297             eventAmount 				= s.amountbalance;
298 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
299 		
300 		s.lastwithdraw 		= s.amountbalance;
301 		s.amountbalance 	= 0;
302 		s.lasttime 			= now;  
303 		
304 		    if(s.cashbackbalance > 0) {
305             s.tokenreceive 					= div(mul(s.amount, 88), 100) ;
306 			s.percentagereceive 			= mul(1000000000000000000, 88);
307             }
308 			else {
309 			s.tokenreceive 					= div(mul(s.amount, 72), 100) ;
310 			s.percentagereceive 			= mul(1000000000000000000, 72);
311 			}
312 		
313 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
314 		
315         }
316         else 
317         {
318 			
319 			UpdateUserData1(s.tokenAddress, s.id);
320 				
321 		}
322         
323     }   
324 	
325 	function UpdateUserData1(address tokenAddress, uint256 id) private {
326 			
327 		Safe storage s = _safes[id];
328         
329         require(s.id != 0);
330         require(s.tokenAddress == tokenAddress);		
331 			
332 			uint256 timeframe  			= sub(now, s.lasttime);			                            
333 			uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), seconds30days); 
334 		//	uint256 CalculateWithdraw   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
335 		                         
336 			uint256 MaxWithdraw 		= div(s.amount, 10);
337 			
338 			// Maximum withdraw before unlocked, Max 10% Accumulation
339 			if (CalculateWithdraw > MaxWithdraw) { 				
340 			uint256 MaxAccumulation = MaxWithdraw; 
341 			} else { MaxAccumulation = CalculateWithdraw; }
342 			
343 			// Maximum withdraw = User Amount Balance   
344 			if (MaxAccumulation > s.amountbalance) { 			     	
345 			uint256 realAmount1 = s.amountbalance; 
346 			} else { realAmount1 = MaxAccumulation; }
347 			
348 			// Including Cashback In The First Contribution
349 			
350 			uint256 amountbalance72 = div(mul(s.amount, 72), 100);
351 			
352 			if (s.amountbalance >= amountbalance72) { 				
353 			uint256 realAmount = add(realAmount1, s.cashbackbalance); 
354 			} else { realAmount = realAmount1; }	
355 			
356 			s.lastwithdraw = realAmount;  			
357 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
358 			UpdateUserData2(tokenAddress, id, newamountbalance, realAmount);
359 					
360     }   
361 
362     function UpdateUserData2(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
363         Safe storage s = _safes[id];
364         
365         require(s.id != 0);
366         require(s.tokenAddress == tokenAddress);
367 
368         uint256 eventAmount;
369         address eventTokenAddress = s.tokenAddress;
370         string memory eventTokenSymbol = s.tokenSymbol;		
371 
372 		s.amountbalance 				= newamountbalance;  
373 		s.lasttime 						= now;  
374 		
375 			uint256 tokenaffiliate 		= div(mul(s.amount, affiliate), 100) ; 
376 			uint256 maxcashback 		= div(mul(s.amount, cashback), 100) ; 		
377 			uint256 tokenreceived 		= sub(add(sub(sub(s.amount, tokenaffiliate), newamountbalance), s.cashbackbalance), maxcashback) ;		
378 		//	uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance + s.cashbackbalance - maxcashback ;
379 			
380 			// Cashback = 100 - 12 - 88 + 16 - 16 = 0 ----> No_Cashback 	= 100 - 12 - 72 + 0 - 16 = 1
381 			
382 			uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
383 		
384 		s.tokenreceive 					= tokenreceived; 
385 		s.percentagereceive 			= percentagereceived; 		
386 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
387 		
388 		
389 	        PayToken(s.user, s.tokenAddress, realAmount);           		
390             eventAmount = realAmount;
391 			
392 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
393     } 
394 	
395 
396     function PayToken(address user, address tokenAddress, uint256 amount) private {
397 		
398 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
399 		LifetimePayments[msg.sender][tokenAddress] 	= add(LifetimePayments[user][tokenAddress], amount); 
400         
401         ERC20Interface token = ERC20Interface(tokenAddress);        
402         require(token.balanceOf(address(this)) >= amount);
403         token.transfer(user, amount);
404     }   	
405 	
406 //** Function 05 - Get How Many Contribute ?
407     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
408         return _userSafes[hodler].length;
409     }
410 	
411 	
412 //** Function 06 - Get How Many Affiliate ?
413     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
414         return afflist[hodler].length;
415     }
416     
417 	
418 //** Function 07 - Get complete data from each user
419 	function GetSafe(uint256 _id) public view
420         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
421     {
422         Safe storage s = _safes[_id];
423         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
424     }
425 	
426 	
427 //** Function 08 - Get Tokens Reserved For Ethereum Vault
428     function GetTokenReserve(address tokenAddress) public view returns (uint256 amount) {
429         return EthereumVault[tokenAddress];
430     }    
431     
432 	
433 //** Function 09 - Get Ethereum Contract's Balance  
434     function GetContractBalance() public view returns(uint256)
435     {
436         return address(this).balance;
437     } 	
438 	
439 	
440 //** Function 10 - Withdraw Affiliate Bonus
441     function WithdrawAffiliate(address user, address tokenAddress) public {  
442 		require(tokenAddress != 0x0);
443 		
444 		require(Affiliatevault[user][tokenAddress] > 0 );
445 		
446 		uint256 amount = Affiliatevault[msg.sender][tokenAddress];
447 		
448 		_totalSaved[tokenAddress] 		= sub(_totalSaved[tokenAddress], amount); 
449 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
450 		
451 		uint256 eventAmount				= amount;
452         address eventTokenAddress 		= tokenAddress;
453         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
454 		
455 		Affiliatevault[msg.sender][tokenAddress] = 0;
456         
457         ERC20Interface token = ERC20Interface(tokenAddress);        
458         require(token.balanceOf(address(this)) >= amount);
459         token.transfer(user, amount);
460 		
461 		emit onAffiliateBonus(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
462     } 		
463 	
464 	
465 //** Function 11 - Get User's Any Token Balance
466     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
467         require(tokenAddress != 0x0);
468         
469         for(uint256 i = 1; i < _currentIndex; i++) {            
470             Safe storage s = _safes[i];
471             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
472                 balance += s.amount;
473         }
474         return balance;
475     }
476 	
477 	
478 	
479 	/*==============================
480     =          RESTRICTED          =
481     ==============================*/  	
482 
483 //** 01 Add Contract Address	
484     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol) public restricted {
485         contractaddress[tokenAddress] 	= contractstatus;
486 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
487 		maxcontribution[tokenAddress] 	= _maxcontribution;
488 		
489 		if (DefaultToken == 0) {
490 			DefaultToken = tokenAddress;
491 		}
492 		
493 		if (tokenAddress == DefaultToken && contractstatus == false) {
494 			contractaddress[tokenAddress] 	= true;
495 		}	
496 		
497 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution, _ContractSymbol);
498     }
499 	
500 	
501 //** 02 - Add Maximum Contribution	
502     function AddMaxContribution(address tokenAddress, uint256 _maxcontribution) public restricted  {
503         maxcontribution[tokenAddress] = _maxcontribution;	
504     }
505 	
506 	
507 //** 03 - Unlock Tokens
508     function UnlockTokens(address tokenAddress, uint256 id) public restricted {
509         require(tokenAddress != 0x0);
510         require(id != 0);      
511         UnlockToken(tokenAddress, id);
512     }
513 	
514     
515 //** 04 Change Hodling Time   
516     function ChangeHodlingTime(uint256 newHodlingDays) restricted public {
517         require(newHodlingDays >= 180);      
518         hodlingTime = newHodlingDays * 1 days;
519     }   
520 	
521 //** 05 - Change Speed Distribution 
522     function ChangeSpeedDistribution(uint256 newSpeed) restricted public {
523         require(newSpeed >= 3 && newSpeed <= 12);   	
524 		percent = newSpeed;
525     }
526 	
527 	
528 //** 06 - Withdraw Ethereum Received Through Fallback Function   
529     function WithdrawEth(uint256 amount) restricted public {
530         require(amount > 0); 
531         require(address(this).balance >= amount); 
532         
533         msg.sender.transfer(amount);
534     }
535 	
536     
537 //** 07 Ethereum Nodes Fees   
538     function EthereumNodesFees(address tokenAddress) restricted public {
539         require(EthereumVault[tokenAddress] > 0);
540         
541         uint256 amount = EthereumVault[tokenAddress];
542 		_totalSaved[tokenAddress] 	= sub(_totalSaved[tokenAddress], amount); 
543         EthereumVault[tokenAddress] = 0;
544         
545         ERC20Interface token = ERC20Interface(tokenAddress);
546         
547         require(token.balanceOf(address(this)) >= amount);
548         token.transfer(msg.sender, amount);
549     }
550 	
551 	
552 //** 08 - Send All Tokens That Have Been Unlocked  
553     function SendUnlockedTokens() restricted public
554     {
555         uint256 returned;
556 
557         for(uint256 i = 1; i < _currentIndex; i++) {            
558             Safe storage s = _safes[i];
559             if (s.id != 0) {
560 				
561 				UpdateUserData1(s.tokenAddress, s.id);
562 				WithdrawAffiliate(s.user, s.tokenAddress);	   
563             }
564         }
565 		
566         emit onUnlockedTokens(returned);
567     }   	
568 	
569 //** 09 - Return All Tokens To Their Respective Addresses    
570     function ReturnAllTokens() restricted public
571     {
572         uint256 returned;
573 
574         for(uint256 i = 1; i < _currentIndex; i++) {            
575             Safe storage s = _safes[i];
576             if (s.id != 0) {
577 				
578 					PayToken(s.user, s.tokenAddress, s.amountbalance);
579 					
580 					s.lastwithdraw 					= s.amountbalance;
581 					s.lasttime 						= now;  
582 					
583 					if(s.cashbackbalance > 0) {
584 					s.tokenreceive 					= div(mul(s.amount, 88), 100) ;
585 					s.percentagereceive 			= mul(1000000000000000000, 88);
586 					}
587 					else {
588 					s.tokenreceive 					= div(mul(s.amount, 72), 100) ;
589 					s.percentagereceive 			= mul(1000000000000000000, 72);
590 					}
591 					
592 					_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); 					
593 					s.amountbalance 				= 0;
594 
595                     returned++;
596                 
597             }
598         }
599 		
600         emit onReturnAll(returned);
601     }   
602 	
603 	
604 	
605 	/*==============================
606     =      SAFE MATH FUNCTIONS     =
607     ==============================*/  	
608 	
609 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
610 		if (a == 0) {
611 			return 0;
612 		}
613 
614 		uint256 c = a * b; 
615 		require(c / a == b);
616 		return c;
617 	}
618 	
619 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
620 		require(b > 0); 
621 		uint256 c = a / b;
622 		return c;
623 	}
624 	
625 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
626 		require(b <= a);
627 		uint256 c = a - b;
628 		return c;
629 	}
630 	
631 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
632 		uint256 c = a + b;
633 		require(c >= a);
634 		return c;
635 	}
636     
637 }
638 
639 
640 	/*==============================
641     =        ERC20 Interface       =
642     ==============================*/ 
643 
644 contract ERC20Interface {
645 
646     uint256 public totalSupply;
647     uint256 public decimals;
648     
649     function symbol() public view returns (string);
650     function balanceOf(address _owner) public view returns (uint256 balance);
651     function transfer(address _to, uint256 _value) public returns (bool success);
652     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
653     function approve(address _spender, uint256 _value) public returns (bool success);
654     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
655 
656     // solhint-disable-next-line no-simple-event-func-name  
657     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
658     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
659 }