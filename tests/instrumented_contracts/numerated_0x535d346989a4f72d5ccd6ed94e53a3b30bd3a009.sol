1 pragma solidity ^0.4.25;
2 pragma experimental ABIEncoderV2;
3 
4 ////// Version 6.2 ////// 
5 
6 // Contract 01
7 contract OwnableContract {    
8     event onTransferOwnership(address newOwner);
9 	address superOwner; 
10 	
11     constructor() public { 
12         superOwner = msg.sender;
13     }
14     modifier restricted() {
15         require(msg.sender == superOwner);
16         _;
17     } 
18 	
19     function viewSuperOwner() public view returns (address owner) {
20         return superOwner;
21     }
22       
23     function changeOwner(address newOwner) restricted public {
24         require(newOwner != superOwner);       
25         superOwner = newOwner;     
26         emit onTransferOwnership(superOwner);
27     }
28 }
29 
30 // Contract 02
31 contract BlockableContract is OwnableContract {    
32     event onBlockHODLs(bool status);
33     bool public blockedContract;
34     
35     constructor() public { 
36         blockedContract = false;  
37     }
38     
39     modifier contractActive() {
40         require(!blockedContract);
41         _;
42     } 
43     
44     function doBlockContract() restricted public {
45         blockedContract = true;        
46         emit onBlockHODLs(blockedContract);
47     }
48     
49     function unBlockContract() restricted public {
50         blockedContract = false;        
51         emit onBlockHODLs(blockedContract);
52     }
53 }
54 
55 // Contract 03
56 contract ldoh is BlockableContract {
57 	
58 	event onAddContractAddress(address indexed contracthodler, bool contractstatus, uint256 _maxcontribution);     
59 	event onCashbackCode(address indexed hodler, address cashbackcode);
60     event onStoreProfileHash(address indexed hodler, string profileHashed);
61     event onHodlTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
62     event onClaimTokens(address indexed hodler, address indexed tokenAddress, string tokenSymbol, uint256 amount, uint256 endtime);
63     event onReturnAll(uint256 returned);
64 	
65 	    // Variables 	
66     address internal AXPRtoken;			//ABCDtoken;
67 	
68 	// Struct Database
69 
70     struct Safe {
71         uint256 id;						// 01 -- > Registration Number
72         uint256 amount;					// 02 -- > Total amount of contribution to this transaction
73         uint256 endtime;				// 03 -- > The Expiration Of A Hold Platform Based On Unix Time
74         address user;					// 04 -- > The ETH address that you are using
75         address tokenAddress;			// 05 -- > The Token Contract Address That You Are Using
76 		string  tokenSymbol;			// 06 -- > The Token Symbol That You Are Using
77 		uint256 amountbalance; 			// 07 -- > 88% from Contribution / 72% Without Cashback
78 		uint256 cashbackbalance; 		// 08 -- > 16% from Contribution
79 		uint256 lasttime; 				// 09 -- > The Last Time You Withdraw Based On Unix Time
80 		uint256 percentage; 			// 10 -- > The percentage of tokens that are unlocked every month ( Default = 3% )
81 		uint256 percentagereceive; 		// 11 -- > The Percentage You Have Received
82 		uint256 tokenreceive; 			// 12 -- > The Number Of Tokens You Have Received
83 		uint256 lastwithdraw; 			// 13 -- > The Last Amount You Withdraw
84 		address referrer; 				// 14 -- > Your ETH referrer address
85 
86     }
87 	
88 		// Uint256
89 	
90 	uint256 public 	percent 				= 1200;        	// 01 -- > Monthly Unlock Percentage
91 	uint256 private constant affiliate 		= 12;        	// 02 -- > Affiliate Bonus = 12% Of Total Contributions
92 	uint256 private constant cashback 		= 16;        	// 03 -- > Cashback Bonus = 16% Of Total Contributions
93 	uint256 private constant nocashback 	= 28;        	// 04 -- > Total % loss amount if you don't get cashback
94 	uint256 private constant totalreceive 	= 88;        	// 05 -- > The total amount you will receive
95     uint256 private constant seconds30days 	= 2592000;  	// 06 -- > Number Of Seconds In One Month
96 	uint256 public  hodlingTime;							// 07 -- > Length of hold time in seconds
97 	uint256 private _currentIndex; 							// 08 -- > ID number ( Start from 500 )							//IDNumber
98 	uint256 public  _countSafes; 							// 09 -- > Total Smart Contract User							//TotalUser
99 	
100 	uint256 public allTimeHighPrice;						// Delete
101     uint256 public comission;								// Delete
102 	mapping(address => string) 	public profileHashed; 		// Delete
103 	
104 		// Mapping
105 	
106 	mapping(address => bool) 			public contractaddress; 	// 01 -- > Contract Address 	
107 	mapping(address => address) 		public cashbackcode; 		// 02 -- > Cashback Code 							
108 	mapping(address => uint256) 		public _totalSaved; 		// 03 -- > Token Balance				//TokenBalance		
109 	mapping(address => uint256[]) 		public _userSafes;			// 04 -- > Search ID by Address 		//IDAddress
110 	mapping(address => uint256) 		private _systemReserves;    // 05 -- > Reserve Funds				//EthereumVault
111 	mapping(uint256 => Safe) 			private _safes; 			// 06 -- > Struct safe database		
112 	mapping(address => uint256) 		public maxcontribution; 	// 07 -- > Maximum Contribution					//New					
113 	mapping(address => uint256) 		public AllContribution; 	// 08 -- > Deposit amount for all members		//New		
114 	mapping(address => uint256) 		public AllPayments; 		// 09 -- > Withdraw amount for all members		//New	
115 	
116     	// Double Mapping
117 
118 	mapping (address => mapping (address => uint256)) public LifetimeContribution;	// 01 -- > Total Deposit Amount Based On Address And Token	//New
119 	mapping (address => mapping (address => uint256)) public Affiliatevault;		// 02 -- > Affiliate Balance That Hasn't Been Withdrawn		//New
120 	mapping (address => mapping (address => uint256)) public Affiliateprofit;		// 03 -- > The Amount Of Profit As An Affiliate				//New
121 	
122 	
123     address[] 						public _listedReserves;		// ?????
124     
125     //Constructor
126    
127     constructor() public {
128         
129         AXPRtoken 		= 0xC39E626A04C5971D770e319760D7926502975e47;        
130         hodlingTime 	= 730 days;
131         _currentIndex 	= 500;
132         comission 		= 12;
133     }
134     
135 	
136 // Function 01 - Fallback Function To Receive Donation In Eth
137     function () public payable {
138         require(msg.value > 0);       
139         _systemReserves[0x0] = add(_systemReserves[0x0], msg.value);
140     }
141 	
142 // Function 02 - Contribute (Hodl Platform)
143     function HodlTokens(address tokenAddress, uint256 amount) public contractActive {
144         require(tokenAddress != 0x0);
145 		require(amount > 0 && amount <= maxcontribution[tokenAddress] );
146 		
147 		if (contractaddress[tokenAddress] == false) {
148 			revert();
149 		}
150 		else {
151 			
152 		
153         ERC20Interface token = ERC20Interface(tokenAddress);       
154         require(token.transferFrom(msg.sender, address(this), amount));
155 		
156 		uint256 affiliatecomission 		= div(mul(amount, affiliate), 100); 	
157 		uint256 no_cashback 			= div(mul(amount, nocashback), 100); 	
158 		
159 		 	if (cashbackcode[msg.sender] == 0 ) { 				
160 			uint256 data_amountbalance 		= div(mul(amount, 72), 100);	
161 			uint256 data_cashbackbalance 	= 0; 
162 			address data_referrer			= superOwner;
163 			
164 			cashbackcode[msg.sender] = superOwner;
165 			emit onCashbackCode(msg.sender, superOwner);
166 			
167 			_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], no_cashback);
168 			
169 			} else { 	
170 			data_amountbalance 				= sub(amount, affiliatecomission);			
171 			data_cashbackbalance 			= div(mul(amount, cashback), 100);			
172 			data_referrer					= cashbackcode[msg.sender];
173 			uint256 referrer_contribution 	= LifetimeContribution[data_referrer][tokenAddress];
174 
175 				if (referrer_contribution >= amount) {
176 		
177 					Affiliatevault[data_referrer][tokenAddress] 	= add(Affiliatevault[data_referrer][tokenAddress], affiliatecomission); 
178 					Affiliateprofit[data_referrer][tokenAddress] 	= add(Affiliateprofit[data_referrer][tokenAddress], affiliatecomission); 
179 					
180 				} else {
181 					
182 					uint256 Newbie 	= div(mul(referrer_contribution, affiliate), 100); 
183 					
184 					Affiliatevault[data_referrer][tokenAddress] 	= add(Affiliatevault[data_referrer][tokenAddress], Newbie); 
185 					Affiliateprofit[data_referrer][tokenAddress] 	= add(Affiliateprofit[data_referrer][tokenAddress], Newbie); 
186 					
187 					uint256 data_unusedfunds 		= sub(affiliatecomission, Newbie);	
188 					_systemReserves[tokenAddress] 	= add(_systemReserves[tokenAddress], data_unusedfunds);
189 					
190 				}
191 			
192 			} 	
193 			  		  				  					  
194 	// Insert to Database  			 	  
195 		_userSafes[msg.sender].push(_currentIndex);
196 		_safes[_currentIndex] = 
197 
198 		Safe(
199 		_currentIndex, amount, now + hodlingTime, msg.sender, tokenAddress, token.symbol(), data_amountbalance, data_cashbackbalance, now, percent, 0, 0, 0, data_referrer);	
200 
201 		LifetimeContribution[msg.sender][tokenAddress] = add(LifetimeContribution[msg.sender][tokenAddress], amount); 		
202 		
203 	// Update Token Balance, Current Index, CountSafes	
204 		AllContribution[tokenAddress] 	= add(AllContribution[tokenAddress], amount);   	
205         _totalSaved[tokenAddress] 		= add(_totalSaved[tokenAddress], amount);     		
206         _currentIndex++;
207         _countSafes++;
208         
209         emit onHodlTokens(msg.sender, tokenAddress, token.symbol(), amount, now + hodlingTime);
210     }	
211 			
212 			
213 }
214 		
215 	
216 // Function 03 - Claim (Hodl Platform)	
217     function ClaimTokens(address tokenAddress, uint256 id) public {
218         require(tokenAddress != 0x0);
219         require(id != 0);        
220         
221         Safe storage s = _safes[id];
222         require(s.user == msg.sender);  
223 		
224 		if (s.amountbalance == 0) {
225 			revert();
226 		}
227 		else {
228 			RetireHodl(tokenAddress, id);
229 		}
230     }
231     
232     function RetireHodl(address tokenAddress, uint256 id) private {
233         Safe storage s = _safes[id];
234         
235         require(s.id != 0);
236         require(s.tokenAddress == tokenAddress);
237 
238         uint256 eventAmount;
239         address eventTokenAddress = s.tokenAddress;
240         string memory eventTokenSymbol = s.tokenSymbol;		
241 		     
242         if(s.endtime < now) // Hodl Complete
243         {
244             PayToken(s.user, s.tokenAddress, s.amountbalance);
245             
246             eventAmount 				= s.amountbalance;
247 		   _totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], s.amountbalance); // *
248 		
249 		s.lastwithdraw = s.amountbalance;
250 		s.amountbalance = 0;
251 		s.lasttime 						= now;  
252 		s.tokenreceive 					= div(mul(s.amount, totalreceive), 100) ;
253 		s.percentagereceive 			= mul(mul(88, 100), 100000000000000000000) ;
254 		
255 		emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
256 		
257         }
258         else 
259         {
260 			
261 			uint256 timeframe  			= sub(now, s.lasttime);			                            
262 			uint256 CalculateWithdraw 	= div(mul(div(mul(s.amount, s.percentage), 100), timeframe), seconds30days); 
263 		//	uint256 CalculateWithdraw   = s.amount * s.percentage / 100 * timeframe / seconds30days	;
264 		                         
265 			uint256 MaxWithdraw 		= div(s.amount, 10);
266 			
267 			// Maximum withdraw before unlocked, Max 10% Accumulation
268 			if (CalculateWithdraw > MaxWithdraw) { 				
269 			uint256 MaxAccumulation = MaxWithdraw; 
270 			} else { MaxAccumulation = CalculateWithdraw; }
271 			
272 			// Maximum withdraw = User Amount Balance   
273 			if (MaxAccumulation > s.amountbalance) { 			     	
274 			uint256 realAmount = s.amountbalance; 
275 			} else { realAmount = MaxAccumulation; }
276 			
277 			s.lastwithdraw = realAmount;  			
278 			uint256 newamountbalance = sub(s.amountbalance, realAmount);	   	          			
279 			UpdateUserData(tokenAddress, id, newamountbalance, realAmount);
280 			
281 		}
282         
283     }   
284 
285     function UpdateUserData(address tokenAddress, uint256 id, uint256 newamountbalance, uint256 realAmount) private {
286         Safe storage s = _safes[id];
287         
288         require(s.id != 0);
289         require(s.tokenAddress == tokenAddress);
290 
291         uint256 eventAmount;
292         address eventTokenAddress = s.tokenAddress;
293         string memory eventTokenSymbol = s.tokenSymbol;			
294    			
295 		s.amountbalance 				= newamountbalance;  
296 		s.lasttime 						= now;  
297 		
298 			uint256 tokenaffiliate 		= div(mul(s.amount, affiliate), 100) ; 
299 			uint256 maxcashback 		= div(mul(s.amount, cashback), 100) ; 		
300 			uint256 tokenreceived 		= sub(add(sub(sub(s.amount, tokenaffiliate), newamountbalance), s.cashbackbalance), maxcashback) ;		
301 		//	uint256 tokenreceived 		= s.amount - tokenaffiliate - newamountbalance + s.cashbackbalance - maxcashback ;
302 			
303 			// Cashback = 100 - 12 - 88 + 16 - 16 = 0 ----> No_Cashback 	= 100 - 12 - 72 + 0 - 16 = 1
304 
305 			uint256 percentagereceived 	= mul(div(tokenreceived, s.amount), 100000000000000000000) ; 	
306 		
307 		s.tokenreceive 					= tokenreceived; 
308 		s.percentagereceive 			= percentagereceived; 		
309 		_totalSaved[s.tokenAddress] 	= sub(_totalSaved[s.tokenAddress], realAmount); 
310 		
311 		
312 	        PayToken(s.user, s.tokenAddress, realAmount);           		
313             eventAmount = realAmount;
314 			
315 			emit onClaimTokens(msg.sender, eventTokenAddress, eventTokenSymbol, eventAmount, now);
316     } 
317 
318     function PayToken(address user, address tokenAddress, uint256 amount) private {
319 		
320 		AllPayments[tokenAddress] 	= add(AllPayments[tokenAddress], amount);
321         
322         ERC20Interface token = ERC20Interface(tokenAddress);        
323         require(token.balanceOf(address(this)) >= amount);
324         token.transfer(user, amount);
325     }   	
326 	
327 // Function 04 - Get How Many Contribute ?
328     function GetUserSafesLength(address hodler) public view returns (uint256 length) {
329         return _userSafes[hodler].length;
330     }
331     
332 // Function 05 - Get Data Values
333 	function GetSafe(uint256 _id) public view
334         returns (uint256 id, address user, address tokenAddress, uint256 amount, uint256 endtime, string tokenSymbol, uint256 amountbalance, uint256 lasttime, uint256 percentage, uint256 percentagereceive, uint256 tokenreceive, address referrer)
335     {
336         Safe storage s = _safes[_id];
337         return(s.id, s.user, s.tokenAddress, s.amount, s.endtime, s.tokenSymbol, s.amountbalance, s.lasttime, s.percentage, s.percentagereceive, s.tokenreceive, s.referrer);
338     }
339 	
340 // Function 06 - Get Tokens Reserved For The Owner As Commission 
341     function GetTokenFees(address tokenAddress) public view returns (uint256 amount) {
342         return _systemReserves[tokenAddress];
343     }    
344     
345 // Function 07 - Get Contract's Balance  
346     function GetContractBalance() public view returns(uint256)
347     {
348         return address(this).balance;
349     } 	
350 	
351 //Function 08 - Cashback Code  
352     function CashbackCode(address _cashbackcode) public {
353 		require(_cashbackcode != msg.sender);
354 		
355 		if (cashbackcode[msg.sender] == 0) {
356 			cashbackcode[msg.sender] = _cashbackcode;
357 			emit onCashbackCode(msg.sender, _cashbackcode);
358 		}		             
359     }  
360 	
361 // Function 08 - Withdraw Affiliate Bonus
362     function WithdrawAffiliate(address user, address tokenAddress) public {  
363 		require(tokenAddress != 0x0);
364 		require(user == msg.sender);
365 		
366 		uint256 amount = Affiliatevault[msg.sender][tokenAddress];
367 		_totalSaved[tokenAddress] 	= sub(_totalSaved[tokenAddress], amount); 
368 		
369 		Affiliatevault[msg.sender][tokenAddress] = 0;
370         
371         ERC20Interface token = ERC20Interface(tokenAddress);        
372         require(token.balanceOf(address(this)) >= amount);
373         token.transfer(user, amount);
374 		
375 		
376     } 		
377 	
378 	
379 	
380 	
381 	
382 	
383 // Useless Function ( Public )	
384 	
385 //??? Function 01 - Store Comission From Unfinished Hodl
386     function StoreComission(address tokenAddress, uint256 amount) private {
387             
388         _systemReserves[tokenAddress] = add(_systemReserves[tokenAddress], amount);
389         
390         bool isNew = true;
391         for(uint256 i = 0; i < _listedReserves.length; i++) {
392             if(_listedReserves[i] == tokenAddress) {
393                 isNew = false;
394                 break;
395             }
396         }         
397         if(isNew) _listedReserves.push(tokenAddress); 
398     }    
399 	
400 //??? Function 02 - Delete Safe Values In Storage   
401     function DeleteSafe(Safe s) private {
402         
403         _totalSaved[s.tokenAddress] = sub(_totalSaved[s.tokenAddress], s.amount);
404         delete _safes[s.id];
405         
406         uint256[] storage vector = _userSafes[msg.sender];
407         uint256 size = vector.length; 
408         for(uint256 i = 0; i < size; i++) {
409             if(vector[i] == s.id) {
410                 vector[i] = vector[size-1];
411                 vector.length--;
412                 break;
413             }
414         } 
415     }
416 	
417 //??? Function 03 - Store The Profile's Hash In The Blockchain   
418     function storeProfileHashed(string _profileHashed) public {
419         profileHashed[msg.sender] = _profileHashed;        
420         emit onStoreProfileHash(msg.sender, _profileHashed);
421     }  	
422 
423 //??? Function 04 - Get User's Any Token Balance
424     function GetHodlTokensBalance(address tokenAddress) public view returns (uint256 balance) {
425         require(tokenAddress != 0x0);
426         
427         for(uint256 i = 1; i < _currentIndex; i++) {            
428             Safe storage s = _safes[i];
429             if(s.user == msg.sender && s.tokenAddress == tokenAddress)
430                 balance += s.amount;
431         }
432         return balance;
433     }
434 	
435 
436 ////////////////////////////////// restricted //////////////////////////////////
437 
438 // 00 Insert Token Contract Address	
439     function AddContractAddress(address tokenAddress, bool contractstatus, uint256 _maxcontribution) public restricted {
440         contractaddress[tokenAddress] = contractstatus;
441 		maxcontribution[tokenAddress] = _maxcontribution;
442 		
443 		emit onAddContractAddress(tokenAddress, contractstatus, _maxcontribution);
444 
445     }
446 	
447 	// 02 - Add Maximum Contribution	
448     function AddMaxContribution(address tokenAddress, uint256 _maxcontribution) public restricted  {
449         maxcontribution[tokenAddress] = _maxcontribution;	
450     }
451 	
452 // 01 Claim ( By Owner )	
453     function OwnerRetireHodl(address tokenAddress, uint256 id) public restricted {
454         require(tokenAddress != 0x0);
455         require(id != 0);      
456         RetireHodl(tokenAddress, id);
457     }
458     
459 // 02 Change Hodling Time   
460     function ChangeHodlingTime(uint256 newHodlingDays) restricted public {
461         require(newHodlingDays >= 180);      
462         hodlingTime = newHodlingDays * 1 days;
463     }   
464     
465 // 03 Change All Time High Price   
466     function ChangeAllTimeHighPrice(uint256 newAllTimeHighPrice) restricted public {
467         require(newAllTimeHighPrice > allTimeHighPrice);       
468         allTimeHighPrice = newAllTimeHighPrice;
469     }              
470 
471 	
472 	// 05 - Change Speed Distribution 
473     function ChangeSpeedDistribution(uint256 newSpeed) restricted public {
474         require(newSpeed <= 12);   
475 		comission = newSpeed;		
476 		percent = newSpeed;
477     }
478 	
479 // 05 - Withdraw Ether Received Through Fallback Function    
480     function WithdrawEth(uint256 amount) restricted public {
481         require(amount > 0); 
482         require(address(this).balance >= amount); 
483         
484         msg.sender.transfer(amount);
485     }
486     
487 // 06 Withdraw Token Fees By Token Address   
488     function WithdrawTokenFees(address tokenAddress) restricted public {
489         require(_systemReserves[tokenAddress] > 0);
490         
491         uint256 amount = _systemReserves[tokenAddress];
492         _systemReserves[tokenAddress] = 0;
493         
494         ERC20Interface token = ERC20Interface(tokenAddress);
495         
496         require(token.balanceOf(address(this)) >= amount);
497         token.transfer(msg.sender, amount);
498     }
499 
500 // 07 Withdraw All Eth And All Tokens Fees   
501     function WithdrawAllFees() restricted public {
502         
503         // Ether
504         uint256 x = _systemReserves[0x0];
505         if(x > 0 && x <= address(this).balance) {
506             _systemReserves[0x0] = 0;
507             msg.sender.transfer(_systemReserves[0x0]);
508         }
509         
510         // Tokens
511         address ta;
512         ERC20Interface token;
513         for(uint256 i = 0; i < _listedReserves.length; i++) {
514             ta = _listedReserves[i];
515             if(_systemReserves[ta] > 0)
516             { 
517                 x = _systemReserves[ta];
518                 _systemReserves[ta] = 0;
519                 
520                 token = ERC20Interface(ta);
521                 token.transfer(msg.sender, x);
522             }
523         }
524         _listedReserves.length = 0; 
525     }
526     
527 
528 
529 // 08 - Returns All Tokens Addresses With Fees       
530     function GetTokensAddressesWithFees() 
531         restricted public view 
532         returns (address[], string[], uint256[])
533     {
534         uint256 length = _listedReserves.length;
535         
536         address[] memory tokenAddress = new address[](length);
537         string[] memory tokenSymbol = new string[](length);
538         uint256[] memory tokenFees = new uint256[](length);
539         
540         for (uint256 i = 0; i < length; i++) {
541     
542             tokenAddress[i] = _listedReserves[i];
543             
544             ERC20Interface token = ERC20Interface(tokenAddress[i]);
545             
546             tokenSymbol[i] = token.symbol();
547             tokenFees[i] = GetTokenFees(tokenAddress[i]);
548         }
549         
550         return (tokenAddress, tokenSymbol, tokenFees);
551     }
552 
553 	
554 // 09 - Return All Tokens To Their Respective Addresses    
555     function ReturnAllTokens(bool onlyAXPR) restricted public
556     {
557         uint256 returned;
558 
559         for(uint256 i = 1; i < _currentIndex; i++) {            
560             Safe storage s = _safes[i];
561             if (s.id != 0) {
562                 if (
563                     (onlyAXPR && s.tokenAddress == AXPRtoken) ||
564                     !onlyAXPR
565                     )
566                 {
567                     PayToken(s.user, s.tokenAddress, s.amountbalance);
568 					
569 					s.lastwithdraw 					= s.amountbalance;
570 					s.amountbalance 				= 0;
571 					s.lasttime 						= now;  
572 					s.tokenreceive 					= div(mul(s.amount, totalreceive), 100) ;
573 					s.percentagereceive 			= mul(mul(88, 100), 100000000000000000000) ;
574 					
575 					AllPayments[s.tokenAddress] 	= add(AllPayments[s.tokenAddress], s.amountbalance);
576 
577 					_totalSaved[s.tokenAddress] 	= 0;					
578 					 
579                     _countSafes--;
580                     returned++;
581                 }
582             }
583         }
584 		
585 		
586         emit onReturnAll(returned);
587     }   
588 
589 	
590 
591     // SAFE MATH FUNCTIONS //
592 	
593 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
594 		if (a == 0) {
595 			return 0;
596 		}
597 
598 		uint256 c = a * b; 
599 		require(c / a == b);
600 		return c;
601 	}
602 	
603 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
604 		require(b > 0); 
605 		uint256 c = a / b;
606 		return c;
607 	}
608 	
609 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
610 		require(b <= a);
611 		uint256 c = a - b;
612 		return c;
613 	}
614 	
615 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
616 		uint256 c = a + b;
617 		require(c >= a);
618 		return c;
619 	}
620     
621 }
622 
623 contract ERC20Interface {
624 
625     uint256 public totalSupply;
626     uint256 public decimals;
627     
628     function symbol() public view returns (string);
629     function balanceOf(address _owner) public view returns (uint256 balance);
630     function transfer(address _to, uint256 _value) public returns (bool success);
631     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
632     function approve(address _spender, uint256 _value) public returns (bool success);
633     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
634 
635     // solhint-disable-next-line no-simple-event-func-name  
636     event Transfer(address indexed _from, address indexed _to, uint256 _value); 
637     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
638 }