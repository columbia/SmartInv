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
22 
23  ///// Version 6.4 /////
24 
25 //// Contract 01
26 contract EthereumSmartContract {    
27     address EthereumNodes; 
28 	
29     constructor() public { 
30         EthereumNodes = msg.sender;
31     }
32     modifier restricted() {
33         require(msg.sender == EthereumNodes);
34         _;
35     } 
36 	
37     function GetEthereumNodes() public view returns (address owner) {
38         return EthereumNodes;
39     }
40 }
41 
42 //// Contract 02
43 contract ldoh is EthereumSmartContract {
44 	
45     event onReturnAll(uint256 returned);	// Delete
46 	event onUnlockedTokens(uint256 returned);	
47 	event onCashbackCode(address indexed hodler, address cashbackcode);
48     event onStoreProfileHash(address indexed hodler, string profileHashed);
49 	event onAddContractAddress(address indexed contracthodler, bool contractstatus, uint256 _maxcontribution); 
50     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
51     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);	
52 	event onAffiliateBonus(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
53     
54 	
55 	    // Variables 	
56     address internal AXPRtoken;			//ABCDtoken;	// Delete
57 	address internal DefaultToken;		
58 	
59 		// Struct Database
60 
61     struct Safe {
62         uint256 id;						// 01 -- > Registration Number
63         uint256 amount;					// 02 -- > Total amount of contribution to this transaction
64         uint256 endtime;				// 03 -- > The Expiration Of A Hold Platform Based On Unix Time
65         address user;					// 04 -- > The ETH address that you are using
66         address tokenAddress;			// 05 -- > The Token Contract Address That You Are Using
67 		string  tokenSymbol;			// 06 -- > The Token Symbol That You Are Using
68 		uint256 amountbalance; 			// 07 -- > 88% from Contribution / 72% Without Cashback
69 		uint256 cashbackbalance; 		// 08 -- > 16% from Contribution / 0% Without Cashback
70 		uint256 lasttime; 				// 09 -- > The Last Time You Withdraw Based On Unix Time
71 		uint256 percentage; 			// 10 -- > The percentage of tokens that are unlocked every month ( Default = 3% )
72 		uint256 percentagereceive; 		// 11 -- > The Percentage You Have Received
73 		uint256 tokenreceive; 			// 12 -- > The Number Of Tokens You Have Received
74 		uint256 lastwithdraw; 			// 13 -- > The Last Amount You Withdraw
75 		address referrer; 				// 14 -- > Your ETH referrer address
76     }
77 	
78 		// Uint256
79 	
80 	uint256 public 	percent 				= 1200;        	// 01 -- > Monthly Unlock Percentage (Default 3%)
81 	uint256 private constant affiliate 		= 12;        	// 02 -- > Affiliate Bonus = 12% Of Total Contributions
82 	uint256 private constant cashback 		= 16;        	// 03 -- > Cashback Bonus = 16% Of Total Contributions
83 	uint256 private constant nocashback 	= 28;        	// 04 -- > Total % loss amount if you don't get cashback
84 	uint256 private constant totalreceive 	= 88;        	// 05 -- > The total amount you will receive
85     uint256 private constant seconds30days 	= 2592000;  	// 06 -- > Number Of Seconds In One Month
86 	uint256 public  hodlingTime;							// 07 -- > Length of hold time in seconds
87 	uint256 private _currentIndex; 							// 08 -- > ID number ( Start from 500 )							//IDNumber
88 	uint256 public  _countSafes; 							// 09 -- > Total Smart Contract User							//TotalUser
89 	
90 		// Mapping
91 	
92 	mapping(address => bool) 			public contractaddress; 	// 01 -- > Contract Address 	
93 	mapping(address => address) 		public cashbackcode; 		// 02 -- > Cashback Code 							
94 	mapping(address => uint256) 		public _totalSaved; 		// 03 -- > Token Balance				//TokenBalance		
95 	mapping(address => uint256[]) 		public _userSafes;			// 04 -- > Search ID by Address 		//IDAddress
96 	mapping(address => uint256) 		private EthereumVault;    	// 05 -- > Reserve Funds				
97 	mapping(uint256 => Safe) 			private _safes; 			// 06 -- > Struct safe database			
98 	mapping(address => uint256) 		public maxcontribution; 	// 07 -- > Maximum Contribution					//N				
99 	mapping(address => uint256) 		public AllContribution; 	// 08 -- > Deposit amount for all members		//N	
100 	mapping(address => uint256) 		public AllPayments; 		// 09 -- > Withdraw amount for all members		//N
101 	mapping(address => string) 			public ContractSymbol; 		// 10 -- > Contract Address Symbol				//N
102 	mapping(address => address[]) 		public afflist;				// 11 -- > Affiliate List by ID					//N
103 	
104     	// Double Mapping
105 
106 	mapping (address => mapping (address => uint256)) public LifetimeContribution;	// 01 -- > Total Deposit Amount Based On Address & Token  //N
107 	mapping (address => mapping (address => uint256)) public LifetimePayments;		// 02 -- > Total Withdraw Amount Based On Address & Token //N	
108 	mapping (address => mapping (address => uint256)) public Affiliatevault;		// 02 -- > Affiliate Balance That Hasn't Been Withdrawn	  //N
109 	mapping (address => mapping (address => uint256)) public Affiliateprofit;		// 03 -- > The Amount Of Profit As An Affiliate			  //N
110 	
111 	
112     address[] public _listedReserves;		// Delete
113     
114 		//Constructor
115    
116     constructor() public {
117         
118         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;  	
119 		DefaultToken	= 0xA15C7Ebe1f07CaF6bFF097D8a589fb8AC49Ae5B3;  	
120         hodlingTime 	= 730 days;
121         _currentIndex 	= 500;
122     }
123     
124 	
125 	
126 ////////////////////////////////// Available For Everyone //////////////////////////////////	
127 
128 
129 	
130 //// Function 01 - Fallback Function To Receive Donation In Eth
131     function () public payable {
132         require(msg.value > 0);       
133         EthereumVault[0x0] = add(EthereumVault[0x0], msg.value);
134     }
135 	
136 	
137 //// Function 02 - Contribute (Hodl Platform)
138     function HodlTokens(address tokenAddress, uint256 amount) public {
139         require(tokenAddress != 0x0);
140 		require(amount > 0 && amount <= maxcontribution[tokenAddress] );
141 		
142 		if (contractaddress[tokenAddress] == false) {
143 			revert();
144 		}
145 		else {
146 			
147 		
148         ERC20Interface token = ERC20Interface(tokenAddress);       
149         require(token.transferFrom(msg.sender, address(this), amount));
150 		
151 		uint256 affiliatecomission 		= div(mul(amount, affiliate), 100); 	
152 		uint256 no_cashback 			= div(mul(amount, nocashback), 100); 	
153 		
154 		 	if (cashbackcode[msg.sender] == 0 ) { 				
155 			uint256 data_amountbalance 		= div(mul(amount, 72), 100);	
156 			uint256 data_cashbackbalance 	= 0; 
157 			address data_referrer			= EthereumNodes;
158 			
159 			cashbackcode[msg.sender] = EthereumNodes;
160 			emit onCashbackCode(msg.sender, EthereumNodes);
161 			
162 			EthereumVault[tokenAddress] 	= add(EthereumVault[tokenAddress], no_cashback);
163 			
164 			} else { 	
165 			data_amountbalance 				= sub(amount, affiliatecomission);			
166 			data_cashbackbalance 			= div(mul(amount, cashback), 100);			
167 			data_referrer					= cashbackcode[msg.sender];
168 			uint256 referrer_contribution 	= LifetimeContribution[data_referrer][tokenAddress];
169 
170 				if (referrer_contribution >= amount) {
171 		
172 					Affiliatevault[data_referrer][tokenAddress] 	= add(Affiliatevault[data_referrer][tokenAddress], affiliatecomission); 
173 					Affiliateprofit[data_referrer][tokenAddress] 	= add(Affiliateprofit[data_referrer][tokenAddress], affiliatecomission); 
174 					
175 				} else {
176 					
177 					uint256 Newbie 	= div(mul(referrer_contribution, affiliate), 100); 
178 					
179 					Affiliatevault[data_referrer][tokenAddress] 	= add(Affiliatevault[data_referrer][tokenAddress], Newbie); 
180 					Affiliateprofit[data_referrer][tokenAddress] 	= add(Affiliateprofit[data_referrer][tokenAddress], Newbie); 
181 					
182 					uint256 data_unusedfunds 		= sub(affiliatecomission, Newbie);	
183 					EthereumVault[tokenAddress] 	= add(EthereumVault[tokenAddress], data_unusedfunds);
184 					
185 				}
186 			
187 			} 	
188 			  		  				  					  
189 	// Insert to Database  		
190 	
191 		afflist[data_referrer].push(msg.sender);	
192 		_userSafes[msg.sender].push(_currentIndex);
193 		_safes[_currentIndex] = 
194 
195 		Safe(
196 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, data_referrer);	
197 
198 		LifetimeContribution[msg.sender][tokenAddress] = add(LifetimeContribution[msg.sender][tokenAddress], amount); 		
199 		
200 	// Update AllContribution, _totalSaved, _currentIndex, _countSafes
201 		AllContribution[tokenAddress] 	= add(AllContribution[tokenAddress], amount);   	
202         _totalSaved[tokenAddress] 		= add(_totalSaved[tokenAddress], amount);     		
203         _currentIndex++;
204         _countSafes++;
205         
206         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
207     }	
208 			
209 			
210 }
211 		
212 	
213 //// Function 03 - Claim Token That Has Been Unlocked
214     function ClaimTokens(address tokenAddress, uint256 id) public {
215         require(tokenAddress != 0x0);
216         require(id != 0);        
217         
218         Safe storage s = _safes[id];
219         require(s.user == msg.sender);  
220 		
221 		if (s.amountbalance == 0) {
222 			revert();
223 		}
224 		else {
225 			UnlockToken(tokenAddress, id);
226 		}
227     }
228     
229     function UnlockToken(address tokenAddress, uint256 id) private {
230         Safe storage s = _safes[id];
231         
232         require(s.id != 0);
233         require(s.tokenAddress == tokenAddress);
234 
235         uint256 eventAmount;
236         address eventTokenAddress = s.tokenAddress;
237         string memory eventTokenSymbol = s.tokenSymbol;		
238 		     
239         if(s.endtime < now) // Hodl Complete
240         {
241             PayToken(s.user, s.tokenAddress, s.amountbalance);
242             
243             eventAmount 				= s.amountbalance;
244 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
245 		
246 		s.lastwithdraw = s.amountbalance;
247 		s.amountbalance = 0;
248 		s.lasttime 						= now;  
249 		s.tokenreceive 					= div(mul(s.amount, totalreceive), 100) ;
250 		s.percentagereceive 			= mul(mul(88, 100), 100000000000000000000) ;
251 		
252 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
253 		
254         }
255         else 
256         {
257 			
258 			UpdateUserData1(s.tokenAddress, s.id);
259 				
260 		}
261         
262     }   
263 	
264 	function UpdateUserData1(address tokenAddress, uint256 id) private {
265 			
266 		Safe storage s = _safes[id];
267         
268         require(s.id != 0);
269         require(s.tokenAddress == tokenAddress);		
270 			
271 			uint256 timeframe  			= sub(now, s.lasttime);			                            
272 			uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), seconds30days); 
273 		//	uint256 CalculateWithdraw   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
274 		                         
275 			uint256 MaxWithdraw 		= div(s.amount, 10);
276 			
277 			// Maximum withdraw before unlocked, Max 10% Accumulation
278 			if (CalculateWithdraw > MaxWithdraw) { 				
279 			uint256 MaxAccumulation = MaxWithdraw; 
280 			} else { MaxAccumulation = CalculateWithdraw; }
281 			
282 			// Maximum withdraw = User Amount Balance   
283 			if (MaxAccumulation > s.amountbalance) { 			     	
284 			uint256 realAmount1 = s.amountbalance; 
285 			} else { realAmount1 = MaxAccumulation; }
286 			
287 			// Including Cashback In The First Contribution
288 			
289 			uint256 amountbalance72 = div(mul(s.amount, 72), 100);
290 			
291 			if (s.amountbalance >= amountbalance72) { 				
292 			uint256 realAmount = add(realAmount1, s.cashbackbalance); 
293 			} else { realAmount = realAmount1; }	
294 			
295 			//////////
296 			
297 			s.lastwithdraw = realAmount;  			
298 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
299 			UpdateUserData2(tokenAddress, id, newamountbalance, realAmount);
300 					
301     }   
302 
303     function UpdateUserData2(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
304         Safe storage s = _safes[id];
305         
306         require(s.id != 0);
307         require(s.tokenAddress == tokenAddress);
308 
309         uint256 eventAmount;
310         address eventTokenAddress = s.tokenAddress;
311         string memory eventTokenSymbol = s.tokenSymbol;		
312 
313 		s.amountbalance 				= newamountbalance;  
314 		s.lasttime 						= now;  
315 		
316 			uint256 tokenaffiliate 		= div(mul(s.amount, affiliate), 100) ; 
317 			uint256 maxcashback 		= div(mul(s.amount, cashback), 100) ; 		
318 			uint256 tokenreceived 		= sub(add(sub(sub(s.amount, tokenaffiliate), newamountbalance), s.cashbackbalance), maxcashback) ;		
319 		//	uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance + s.cashbackbalance - maxcashback ;
320 			
321 			// Cashback = 100 - 12 - 88 + 16 - 16 = 0 ----> No_Cashback 	= 100 - 12 - 72 + 0 - 16 = 1
322 
323 			uint256 percentagereceived 	= div(mul(tokenreceived, 100000000000000000000), s.amount) ; 	
324 		
325 		s.tokenreceive 					= tokenreceived; 
326 		s.percentagereceive 			= percentagereceived; 		
327 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
328 		
329 		
330 	        PayToken(s.user, s.tokenAddress, realAmount);           		
331             eventAmount = realAmount;
332 			
333 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
334     } 
335 	
336 
337     function PayToken(address user, address tokenAddress, uint256 amount) private {
338 		
339 		AllPayments[tokenAddress] 					= add(AllPayments[tokenAddress], amount);
340 		LifetimePayments[msg.sender][tokenAddress] = add(LifetimePayments[user][tokenAddress], amount); 
341         
342         ERC20Interface token = ERC20Interface(tokenAddress);        
343         require(token.balanceOf(address(this)) >= amount);
344         token.transfer(user, amount);
345     }   	
346 	
347 //// Function 04 - Get How Many Contribute ?
348     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
349         return _userSafes[hodler].length;
350     }
351 	
352 	
353 //// Function 05 - Get How Many Affiliate ?
354     function GetTotalAffiliate(address hodler) public view returns (uint256 length) {
355         return afflist[hodler].length;
356     }
357     
358 	
359 //// Function 06 - Get complete data from each user
360 	function GetSafe(uint256 _id) public view
361         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
362     {
363         Safe storage s = _safes[_id];
364         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
365     }
366 	
367 	
368 //// Function 07 - Get Tokens Reserved For Ethereum Vault
369     function GetTokenReserve(address tokenAddress) public view returns (uint256 amount) {
370         return EthereumVault[tokenAddress];
371     }    
372     
373 	
374 //// Function 08 - Get Ethereum Contract's Balance  
375     function GetContractBalance() public view returns(uint256)
376     {
377         return address(this).balance;
378     } 	
379 	
380 	
381 //// Function 09 - Cashback Code  
382     function CashbackCode(address _cashbackcode) public {
383 		require(_cashbackcode != msg.sender);
384 		
385 		if (cashbackcode[msg.sender] == 0) {
386 			cashbackcode[msg.sender] = _cashbackcode;
387 			emit onCashbackCode(msg.sender, _cashbackcode);
388 		}		             
389     }  
390 	
391 	
392 //// Function 10 - Withdraw Affiliate Bonus
393     function WithdrawAffiliate(address user, address tokenAddress) public {  
394 		require(tokenAddress != 0x0);
395 		require(user == msg.sender);
396 		
397 		require(Affiliatevault[user][tokenAddress] > 0 );
398 		
399 		uint256 amount = Affiliatevault[msg.sender][tokenAddress];
400 		
401 		_totalSaved[tokenAddress] 		= sub(_totalSaved[tokenAddress], amount); 
402 		AllPayments[tokenAddress] 		= add(AllPayments[tokenAddress], amount);
403 		
404 		uint256 eventAmount				= amount;
405         address eventTokenAddress 		= tokenAddress;
406         string 	memory eventTokenSymbol = ContractSymbol[tokenAddress];	
407 		
408 		Affiliatevault[msg.sender][tokenAddress] = 0;
409         
410         ERC20Interface token = ERC20Interface(tokenAddress);        
411         require(token.balanceOf(address(this)) >= amount);
412         token.transfer(user, amount);
413 		
414 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
415     } 		
416 	
417 	
418 //// Function 11 - Get User's Any Token Balance
419     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
420         require(tokenAddress != 0x0);
421         
422         for(uint256 i = 1; i < _currentIndex; i++) {            
423             Safe storage s = _safes[i];
424             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
425                 balance += s.amount;
426         }
427         return balance;
428     }
429 	
430 	
431 	
432 
433 ////////////////////////////////// restricted //////////////////////////////////
434 
435 //// 01 Add Contract Address	
436     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution, string _ContractSymbol) public restricted {
437         contractaddress[tokenAddress] 	= contractstatus;
438 		ContractSymbol[tokenAddress] 	= _ContractSymbol;
439 		maxcontribution[tokenAddress] 	= _maxcontribution;
440 		
441 		if (tokenAddress == DefaultToken && contractstatus == false) {
442 			contractaddress[tokenAddress] 	= true;
443 		}	
444 		
445 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution);
446     }
447 	
448 	
449 //// 02 - Add Maximum Contribution	
450     function AddMaxContribution(address tokenAddress, uint256 _maxcontribution) public restricted  {
451         maxcontribution[tokenAddress] = _maxcontribution;	
452     }
453 	
454 	
455 //// 03 - Unlock Tokens
456     function UnlockTokens(address tokenAddress, uint256 id) public restricted {
457         require(tokenAddress != 0x0);
458         require(id != 0);      
459         UnlockToken(tokenAddress, id);
460     }
461 	
462     
463 //// 04 Change Hodling Time   
464     function ChangeHodlingTime(uint256 newHodlingDays) restricted public {
465         require(newHodlingDays >= 180);      
466         hodlingTime = newHodlingDays * 1 days;
467     }   
468 	
469 //// 05 - Change Speed Distribution 
470     function ChangeSpeedDistribution(uint256 newSpeed) restricted public {
471         require(newSpeed >= 3 && newSpeed <= 12);   	
472 		percent = newSpeed;
473     }
474 	
475 	
476 //// 06 - Withdraw Ethereum Received Through Fallback Function   
477     function WithdrawEth(uint256 amount) restricted public {
478         require(amount > 0); 
479         require(address(this).balance >= amount); 
480         
481         msg.sender.transfer(amount);
482     }
483 	
484     
485 //// 07 Ethereum Nodes Fees   
486     function EthereumNodesFees(address tokenAddress) restricted public {
487         require(EthereumVault[tokenAddress] > 0);
488         
489         uint256 amount = EthereumVault[tokenAddress];
490 		_totalSaved[tokenAddress] 	= sub(_totalSaved[tokenAddress], amount); 
491         EthereumVault[tokenAddress] = 0;
492         
493         ERC20Interface token = ERC20Interface(tokenAddress);
494         
495         require(token.balanceOf(address(this)) >= amount);
496         token.transfer(msg.sender, amount);
497     }
498 	
499     
500 //// 08 - Return All Tokens To Their Respective Addresses    
501     function ReturnAllTokens(bool onlyAXPR) restricted public
502     {
503         uint256 returned;
504 
505         for(uint256 i = 1; i < _currentIndex; i++) {            
506             Safe storage s = _safes[i];
507             if (s.id != 0) {
508                 if (
509                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
510                     !onlyAXPR
511                     )
512                 {
513                     PayToken(s.user, s.tokenAddress, s.amountbalance);
514 					
515 					s.lastwithdraw 					= s.amountbalance;
516 					s.amountbalance 				= 0;
517 					s.lasttime 						= now;  
518 					
519 					s.percentagereceive 			= sub(add(totalreceive, s.cashbackbalance), 16); 
520 					s.tokenreceive 					= div(mul(s.amount, s.percentagereceive ), 100);		
521 
522 					_totalSaved[s.tokenAddress] 	= 0;					
523 					 
524                     _countSafes--;
525                     returned++;
526                 }
527             }
528         }
529 		
530         emit onReturnAll(returned);
531     }   
532 	
533 //// 09 - Send All Tokens That Have Been Unlocked  
534     function SendUnlockedTokens(bool onlyDefault) restricted public
535     {
536         uint256 returned;
537 
538         for(uint256 i = 1; i < _currentIndex; i++) {            
539             Safe storage s = _safes[i];
540             if (s.id != 0) {
541                 if ( (onlyDefault && s.tokenAddress == AXPRtoken) || !onlyDefault ) {
542 											
543 					UpdateUserData1(s.tokenAddress, s.id);
544 					
545                 }
546             }
547         }
548 		
549         emit onUnlockedTokens(returned);
550     }   	
551 	
552 	
553 
554 
555     // SAFE MATH FUNCTIONS //
556 	
557 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
558 		if (a == 0) {
559 			return 0;
560 		}
561 
562 		uint256 c = a * b; 
563 		require(c / a == b);
564 		return c;
565 	}
566 	
567 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
568 		require(b > 0); 
569 		uint256 c = a / b;
570 		return c;
571 	}
572 	
573 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
574 		require(b <= a);
575 		uint256 c = a - b;
576 		return c;
577 	}
578 	
579 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
580 		uint256 c = a + b;
581 		require(c >= a);
582 		return c;
583 	}
584     
585 }
586 
587 contract ERC20Interface {
588 
589     uint256 public totalSupply;
590     uint256 public decimals;
591     
592     function symbol() public view returns (string);
593     function balanceOf(address _owner) public view returns (uint256 balance);
594     function transfer(address _to, uint256 _value) public returns (bool success);
595     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
596     function approve(address _spender, uint256 _value) public returns (bool success);
597     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
598 
599     // solhint-disable-next-line no-simple-event-func-name  
600     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
601     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
602 }